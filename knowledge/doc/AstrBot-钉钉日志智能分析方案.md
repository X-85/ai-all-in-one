# AstrBot 钉钉日志智能分析方案

## 1. 目标

通过钉钉机器人接收用户提交的日志，使用 AstrBot 对日志进行问题分析，并把分析结果返回钉钉。

分析能力分为三个层次：

1. 直接调用 LLM 分析日志。
2. 调用 Skill，并结合模块功能文档分析日志。
3. 通过插件访问受控的模块源码、配置和测试信息，与日志进行比对分析。

推荐的总体原则是：

- 钉钉只负责消息入口和结果展示。
- AstrBot 负责会话、任务编排、Agent 执行、权限、超时和回复。
- Skill 负责模块知识和分析方法。
- 插件负责提供受控的业务工具和源码证据。
- MCP 只在确实需要进程隔离、远程执行或多系统复用时引入。

## 2. 总体架构

```text
钉钉消息
   ↓
DingTalk Platform Adapter
   ↓
日志分析插件 / Analysis Orchestrator
   ↓
任务路由
   ├─ 直接 LLM 分析
   ├─ Skill + 模块文档分析
   └─ 插件工具 + 本地源码分析
   ↓
结果合并与结构化
   ↓
钉钉 Markdown/Card 回复
```

AstrBot 当前已经具备以下可复用能力：

- DingTalk 平台适配器，用于接收和发送消息。
- Tool Loop Agent，用于循环执行 LLM 工具调用。
- `FunctionTool` 和 `FunctionToolExecutor`，用于注册和执行插件工具。
- `SubAgentOrchestrator` 和 `HandoffTool`，用于专用分析 Agent。
- `SkillManager`，用于加载和管理 `SKILL.md`。
- MCP Client，用于接入外部 MCP 工具。

因此第一版不需要重新实现一套 Agent 框架。

## 3. 钉钉接入设计

AstrBot 已有 DingTalk 官方 API 适配器，可以直接作为入口。第一版建议优先支持文本日志，后续再支持钉钉文件消息。

推荐支持以下命令：

```text
/analyze direct
<日志内容>
```

```text
/analyze docs
<日志内容>
```

```text
/analyze code
<日志内容>
```

```text
/analyze all
<日志内容>
```

含义如下：

| 命令 | 作用 |
| --- | --- |
| `direct` | 只调用 LLM 分析日志 |
| `docs` | 调用 Skill 和模块文档分析 |
| `code` | 调用源码分析工具分析 |
| `all` | 依次执行基础分析、文档分析和必要的源码分析 |

也可以不要求用户输入命令，由插件根据会话配置选择默认模式。但不建议完全依赖 LLM 自己决定是否访问源码，应通过明确命令、群组配置或一个受限路由器控制。

大日志需要注意钉钉消息长度限制。建议：

- 小日志直接使用文本消息。
- 大日志通过钉钉文件消息或对象存储上传。
- AstrBot 将文件保存到本次任务的临时目录。
- 对输入大小、行数和文件类型设置限制。
- 返回钉钉摘要，完整报告保存到本地或对象存储。

## 4. 三种分析模式

### 4.1 直接 LLM 分析

适用于日志格式清晰、无需查询源码的场景。

提示词应固定要求模型完成以下工作：

- 识别异常时间、服务和组件。
- 提取异常类型、错误码和调用链。
- 区分日志中明确存在的事实和模型推测。
- 给出可能原因以及置信度。
- 给出修复和进一步排查建议。
- 列出当前缺少的信息。
- 按统一 JSON 结构输出。

这一模式可以直接复用 AstrBot 的普通 LLM 请求，不需要工具调用，成本和延迟最低。

### 4.2 Skill + 模块文档分析

将模块知识组织为 AstrBot Skill，例如：

```text
skills/
└── order-service-analysis/
    ├── SKILL.md
    ├── error-codes.md
    ├── architecture.md
    └── examples.md
```

`SKILL.md` 至少应包含：

- 模块职责和边界。
- 日志中的关键字段。
- 常见错误模式和错误码。
- 错误码与异常类型的对应关系。
- 日志分析步骤。
- 什么时候需要进一步查看源码。
- 输出结果格式和证据要求。

推荐使用渐进式加载：先向 LLM 展示 Skill 名称和描述，模型判断需要使用某个 Skill 后，再读取完整的 `SKILL.md` 和相关文档。不要把所有模块文档一次性放进上下文。

如果文档数量较少，直接使用 Skill 文件即可。如果文档数量较大，再增加关键词检索、向量检索或混合检索。

### 4.3 插件工具 + 本地源码分析

源码分析应由插件提供受控的语义化工具，而不是直接给 LLM 一个无限制的 shell。

建议的工具包括：

```text
read_source_file(path, start_line, end_line)
search_source(pattern, path, glob)
list_module_files(path)
get_git_blame(path, line)
get_git_diff(commit)
query_module_metadata(module_name)
run_allowed_test(test_name)
```

工具返回值必须包含证据定位，例如：

```json
{
  "file": "src/order/service.py",
  "start_line": 128,
  "end_line": 145,
  "content": "...",
  "source": "repository"
}
```

最终报告应该能够说明：

```text
问题原因：订单状态更新异常后仍然返回成功。

证据：
- 日志中的 request_id 与订单状态更新调用匹配。
- src/order/service.py:128-145 捕获异常后没有重新抛出。

置信度：高
```

插件最好提供业务语义工具，例如 `find_order_exception`、`get_request_trace`，而不是让模型自己执行大量 `grep`、`cat` 和 shell 命令。

## 5. 推荐的任务编排流程

当用户选择 `all` 模式时，推荐采用逐步增强的流程：

```text
1. 保存和脱敏日志
2. 直接 LLM 分析，得到基础结论
3. 根据模块选择相关 Skill
4. 使用模块文档校验基础结论
5. 只有证据不足时才查询源码
6. 由最终合并 Agent 汇总结果
7. 转换为钉钉 Markdown/Card 消息
```

不是所有日志都需要执行源码分析。源码分析成本更高、耗时更长，应由以下条件触发：

- 日志中包含明确的模块名或堆栈路径。
- Skill 文档无法确认根因。
- 用户明确要求查看源码。
- 基础分析的置信度低于阈值。
- 需要用源码证据确认修复位置。

三种分析可以并行执行，但建议第一版使用顺序流程，便于控制成本、超时和错误处理。后续可以将直接分析和文档分析并行，再根据结果决定是否执行源码分析。

## 6. 统一结果结构

建议所有分析器都返回同一种结构：

```json
{
  "summary": "一句话结论",
  "severity": "low|medium|high|critical",
  "confidence": 0.85,
  "component": "order-service",
  "root_causes": [
    {
      "cause": "异常处理逻辑错误",
      "evidence": [
        "日志中的异常堆栈",
        "src/order/service.py:128-145"
      ]
    }
  ],
  "impact": "影响范围",
  "recommendations": [
    "修复异常处理逻辑",
    "增加回滚测试"
  ],
  "unknowns": [
    "缺少数据库版本信息"
  ]
}
```

钉钉消息只展示高价值信息：

- 问题摘要。
- 严重级别和置信度。
- 可能原因。
- 关键证据。
- 修复建议。
- 缺少的信息。

完整日志、工具调用记录和完整分析过程保存到报告中，并通过报告 ID 或链接关联。

## 7. 本地代码 Agent 执行器

### 7.1 第一版直接复用 AstrBot 执行器

建议将 AstrBot 作为唯一 Agent 执行器，并为日志分析注册一个专用 SubAgent：

```text
LogAnalysisAgent
├── read_source_file
├── search_source
├── list_module_files
├── get_git_blame
└── run_allowed_test
```

该 Agent 的系统提示词应明确：

```text
你是生产日志分析 Agent。

要求：
1. 分析用户提供的日志。
2. 只有在日志不足以确认原因时才访问源码。
3. 所有结论必须引用日志或源码证据。
4. 不得修改代码。
5. 不得访问工作区以外的路径。
6. 不得执行未允许的命令。
7. 必须输出结构化分析结果。
```

分析插件收到钉钉事件后，可以执行以下步骤：

1. 获取并校验用户输入。
2. 对日志进行脱敏。
3. 将日志保存到本次任务的临时目录。
4. 根据模块名选择 Skill、源码根目录和工具集合。
5. 创建 Agent 运行上下文。
6. 调用 AstrBot 的 Tool Loop Agent 或专用 SubAgent。
7. 等待最终结果，处理超时或取消。
8. 规范化 JSON 结果。
9. 发送钉钉 Markdown/Card 回复。

### 7.2 工具执行边界

工具必须以本次任务的源码根目录为边界：

- 所有路径解析后必须位于指定源码根目录内。
- 默认只读，不允许修改代码。
- 禁止访问源码目录之外的路径。
- shell 使用命令白名单，而不是任意命令。
- 默认禁止网络访问。
- 每个工具设置独立超时。
- 限制单次返回内容大小。
- 限制 Agent 最大工具调用次数，例如 8 到 12 次。
- 支持用户取消正在执行的任务。
- 记录工具名称、参数、耗时和结果摘要。

如果确实需要执行命令，应优先提供固定的业务操作，例如 `run_allowed_test("order_state_transition")`，而不是开放一个任意命令执行接口。

## 8. 是否使用 MCP

### 8.1 第一阶段不建议使用外部 MCP Agent

MCP 是工具接入协议，不是必须替换的 Agent 执行器。

第一阶段推荐：

```text
AstrBot Agent
   ├─ Skill
   ├─ 本地插件工具
   └─ 必要时调用 MCP 工具
```

这样可以复用 AstrBot 已有的：

- 会话上下文。
- LLM Provider。
- Tool Loop。
- Agent 超时和取消。
- 工具调用审计。
- 钉钉消息生命周期。
- SubAgent 和 Skill 机制。

不建议一开始同时引入 DSH 或 pi-mono，并让它们再启动一套 Agent Loop。这样会造成上下文重复、工具调用难以追踪、超时和取消复杂化，并增加调用成本。

### 8.2 适合拆成 MCP 服务的情况

当出现以下需求时，再考虑把代码分析能力拆成 MCP 服务：

- 代码分析必须运行在独立容器或远程机器中。
- 分析服务使用其他语言实现。
- 多个 AstrBot 实例需要共享同一个分析服务。
- 代码仓库很大，需要独立索引和缓存。
- 需要独立部署、扩缩容和权限审计。
- DSH 或 pi-mono 已经提供成熟的代码沙箱。

拆分时选择一种 Agent 所有权，不要嵌套两个 Agent Loop。

方案 A：AstrBot 拥有 Agent Loop：

```text
AstrBot Agent → MCP Tools → 代码分析服务
```

方案 B：外部服务拥有 Agent Loop：

```text
AstrBot → analyze_log API/MCP → 外部 Agent 服务 → 最终报告
```

第二种方案中，外部服务应该作为一个完整的异步分析服务，而不是让 AstrBot 和外部服务同时管理同一轮工具调用。

## 9. 安全与可靠性要求

日志和源码分析通常涉及生产信息，必须默认按不可信输入处理。

### 输入安全

- 限制日志大小、行数和文件类型。
- 对密码、Token、Cookie、手机号和邮箱进行脱敏。
- 将每次任务绑定到用户、群组和租户。
- 防止日志中的文本注入 Agent 指令。
- 不允许用户通过日志内容改变系统提示词或工具权限。

### 源码安全

- 使用显式源码目录白名单。
- 只读访问。
- 禁止目录穿越。
- 禁止默认访问密钥、环境变量和生产配置。
- 禁止未授权网络访问。
- 对命令、参数、CPU、内存和执行时间设置限制。

### 任务可靠性

- 设置单任务总超时，例如 60 秒或 120 秒。
- 设置最大 Agent 步数。
- 支持用户取消任务。
- 工具失败时返回可理解的错误，不让 Agent 无限重试。
- 对大工具结果截断，并保存完整结果到报告文件。
- 为每次任务生成 `trace_id`，便于排查。
- 记录分析模式、使用的 Skill、调用的工具和最终结论。

## 10. 推荐实施顺序

### 第一阶段：最小可用版本

1. 使用现有 DingTalk 适配器接收文本日志。
2. 实现 `/analyze direct`。
3. 统一 JSON 分析结果。
4. 将结果转换为钉钉 Markdown 消息。
5. 增加输入长度、超时和脱敏。

### 第二阶段：文档分析

1. 为一个核心模块编写 `SKILL.md`。
2. 增加模块错误码、架构和典型日志文档。
3. 实现 `/analyze docs`。
4. 验证 Skill 的渐进式读取和结果引用。

### 第三阶段：源码分析

1. 创建只读源码分析插件。
2. 增加 `read_source_file`、`search_source` 和 `list_module_files`。
3. 配置专用 `LogAnalysisAgent` SubAgent。
4. 增加源码行号证据。
5. 增加允许的测试查询工具。

### 第四阶段：完整编排

1. 实现 `/analyze all`。
2. 先执行直接分析和文档分析。
3. 根据置信度决定是否执行源码分析。
4. 由最终 Agent 合并结果。
5. 增加报告保存、查询和审计能力。

### 第五阶段：评估 MCP

只有当代码分析出现隔离部署、远程仓库、多实例共享或独立扩缩容需求时，才将源码工具拆成 MCP 服务。

## 11. 最终推荐架构

```text
DingTalk
  ↓
AstrBot Analysis Plugin
  ↓
AstrBot Agent / SubAgent
  ├─ Direct LLM
  ├─ Skill 文档
  ├─ Read-only Code Tools
  └─ Optional MCP Tools
  ↓
Structured Analysis Report
  ↓
DingTalk Markdown/Card
```

核心结论：先复用 AstrBot 的 Agent 执行器，插件负责任务编排和工具权限，Skill 负责模块知识，代码分析通过受限插件工具完成。只有当隔离部署或跨系统复用成为明确需求时，再将代码分析能力拆成 MCP 服务。
