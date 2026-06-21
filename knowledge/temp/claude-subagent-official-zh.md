# Claude Sub-Agent 官方文档（中文整理）

> 来源：[Claude Code Sub-Agents 官方文档](https://code.claude.com/docs/en/sub-agents)
> 说明：本文档为 Claude Code 官方 Sub-Agents 文档的完整中文整理

---

## 一、Sub-Agent 定义

**官方原文：**

> Subagents are specialized AI assistants that handle specific types of tasks. Use one when a side task would flood your main conversation with search results, logs, or file contents you won't reference again: the subagent does that work in its own context and returns only the summary.

**中文翻译：**

> Sub-Agent 是**专门处理特定类型任务的 AI 助手**。当一个分支任务会让你的主对话充斥大量搜索结果、日志或文件内容（而你不会再引用它们）时，就使用 Sub-Agent：Sub-Agent 在自己的上下文中完成工作，只返回摘要。

**关键特性：**
- 在**自己的上下文窗口**中运行
- 自定义系统提示（system prompt）
- 特定的工具访问权限
- 独立的权限管理
- 主 Claude 遇到匹配 sub-agent 描述的任务时委派给它
- Sub-Agent 独立工作后返回结果

---

## 二、Sub-Agent 的核心价值

Sub-Agent 帮助你：

1. **保留上下文**（Preserve context）：让探索和实现保持在主对话之外
2. **强制约束**（Enforce constraints）：限制 sub-agent 可使用的工具
3. **跨项目复用配置**（Reuse configurations）：用户级 sub-agent
4. **专业化行为**（Specialize behavior）：为特定领域编写聚焦的系统提示
5. **控制成本**（Control costs）：把任务路由到更快、更便宜的模型（如 Haiku）

> Claude 通过每个 sub-agent 的 `description` 字段决定何时委派任务。创建时**务必写清晰的 description**，让 Claude 知道何时使用它。

---

## 三、内置 Sub-Agent

Claude Code 包含 Claude 在适当时自动使用的内置 sub-agent。每个都继承父会话权限，并附加工具限制。

### 3.1 Explore（探索型）

- **模型**：Haiku（快速、低延迟）
- **工具**：只读工具（禁止 Write 和 Edit）
- **用途**：文件发现、代码搜索、代码库探索

Claude 在需要搜索或理解代码库而不做修改时委派给 Explore。**让探索结果不进入主对话上下文**。

调用时可指定彻底性级别：
- **quick**：针对性查找
- **medium**：平衡探索
- **very thorough**：全面分析

### 3.2 Plan（规划型）

- **模型**：继承主对话
- **工具**：只读工具（禁止 Write 和 Edit）
- **用途**：为规划进行代码库研究

在 plan 模式下，Claude 需要理解代码库时把研究委派给 Plan sub-agent，**让探索输出保持在独立上下文中**，主对话保持只读。

### 3.3 General-purpose（通用型）

- **模型**：继承主对话
- **工具**：所有工具
- **用途**：复杂研究、多步操作、代码修改

需要同时探索和修改、复杂推理解释结果、多步依赖任务时委派。

### 3.4 其他辅助 Agent

| Agent | 模型 | 何时使用 |
|-------|------|---------|
| statusline-setup | Sonnet | 运行 `/statusline` 配置状态栏时 |
| claude-code-guide | Haiku | 询问 Claude Code 功能问题时 |

### 3.5 禁用内置 Sub-Agent

- **阻止特定类型**：添加到 `permissions.deny`
- **完全禁止委派**：用 `permissions.deny` 禁用 `Agent` 工具
- **非交互模式 / Agent SDK**：设置 `CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS=1` 移除所有内置类型

---

## 四、快速创建 Sub-Agent

Sub-Agent 定义在带 YAML frontmatter 的 Markdown 文件中。可手动创建或用 `/agents` 命令。

**`/agents` 命令步骤：**

1. 打开 Sub-Agent 界面：运行 `/agents`
2. 选择位置：切换到 **Library** 标签，选择 **Create new agent**，然后选 **Personal**（保存到 `~/.claude/agents/`）
3. 用 Claude 生成：选 **Generate with Claude** 并描述 sub-agent
4. 选择工具：例如只读审查者，只勾选 **Read-only tools**
5. 选择模型：选 sub-agent 用的模型
6. 选择颜色：选识别用背景色
7. 配置内存：选 **User scope**，持久化到 `~/.claude/agent-memory/`
8. 保存使用：按 `s` 或 `Enter`

---

## 五、Sub-Agent 配置

### 5.1 配置位置与作用域

| 位置 | 作用域 | 优先级 | 创建方式 |
|------|--------|--------|---------|
| Managed settings | 组织级 | 1（最高） | 通过托管设置部署 |
| `--agents` CLI flag | 当前会话 | 2 | 启动 Claude Code 时传 JSON |
| `.claude/agents/` | 当前项目 | 3 | 交互式或手动 |
| `~/.claude/agents/` | 所有项目 | 4 | 交互式或手动 |
| Plugin 的 `agents/` 目录 | 插件启用范围 | 5（最低） | 插件安装 |

**项目 sub-agent**（`.claude/agents/`）从当前工作目录向上遍历发现。

**用户 sub-agent**（`~/.claude/agents/`）在所有项目中可用，递归扫描。

**CLI 定义 sub-agent**：启动 Claude Code 时传 JSON：

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

### 5.2 编写 Sub-Agent 文件

Sub-Agent 文件用 YAML frontmatter 配置，后跟 Markdown 格式的系统提示：

```markdown
---
name: code-reviewer
description: Reviews code for quality and best practices
tools: Read, Glob, Grep
model: sonnet
---

You are a code reviewer. When invoked, analyze the code and provide
specific, actionable feedback on quality, security, and best practices.
```

**Frontmatter 定义 sub-agent 的元数据和配置，正文成为系统提示**。Sub-Agent 只接收该系统提示（加工作目录等基础环境信息），**不接收完整的 Claude Code 系统提示**。

---

## 六、Frontmatter 字段详解

| 字段 | 是否必需 | 描述 |
|------|---------|------|
| `name` | 是 | 唯一标识，使用小写字母和连字符。文件名不必匹配 |
| `description` | 是 | Claude 何时应委派给该 sub-agent |
| `tools` | 否 | sub-agent 可用的工具。省略则继承所有工具 |
| `disallowedTools` | 否 | 拒绝的工具，从继承或指定的列表中移除 |
| `model` | 否 | 模型：`sonnet`/`opus`/`haiku`/`fable`/完整模型 ID/`inherit`（默认） |
| `permissionMode` | 否 | 权限模式：`default`/`acceptEdits`/`auto`/`dontAsk`/`bypassPermissions`/`plan` |
| `maxTurns` | 否 | sub-agent 停止前的最大智能体轮数 |
| `skills` | 否 | 启动时预加载到 sub-agent 上下文中的 skills |
| `mcpServers` | 否 | 该 sub-agent 可用的 MCP 服务器 |
| `hooks` | 否 | 限定该 sub-agent 的生命周期 hooks |
| `memory` | 否 | 持久内存作用域：`user`/`project`/`local`，启用跨会话学习 |
| `background` | 否 | 设为 `true` 始终作为后台任务运行 |
| `effort` | 否 | sub-agent 活跃时的努力级别：`low`/`medium`/`high`/`xhigh`/`max` |
| `isolation` | 否 | 设为 `worktree` 在临时 git worktree 中运行 |
| `color` | 否 | 显示颜色：`red`/`blue`/`green`/`yellow`/`purple`/`orange`/`pink`/`cyan` |
| `initialPrompt` | 否 | 当该 agent 作为主会话 agent 运行时，作为第一条用户消息自动提交 |

---

## 七、模型选择

`model` 字段控制 sub-agent 使用的 AI 模型。可选值：`sonnet`、`opus`、`haiku`、`fable`、完整模型 ID、`inherit`（同主会话）。

**模型解析顺序：**

1. `CLAUDE_CODE_SUBAGENT_MODEL` 环境变量
2. 每次调用的 `model` 参数
3. sub-agent 定义中的 `model` frontmatter
4. 主会话的模型

---

## 八、能力控制

### 8.1 可用工具

Sub-Agent 默认继承主会话的内部工具和 MCP 工具。

**Sub-Agent 不可用的工具：**
- `AskUserQuestion`
- `EnterPlanMode`
- `ExitPlanMode`（除非 `permissionMode` 为 `plan`）
- `ScheduleWakeup`
- `WaitForMcpServers`

用 `tools`（白名单）或 `disallowedTools`（黑名单）限制：

```yaml
---
name: safe-researcher
description: Research agent with restricted capabilities
tools: Read, Grep, Glob, Bash
---
```

```yaml
---
name: no-writes
description: Inherits every tool except file writes
disallowedTools: Write, Edit
---
```

> 两个都设置时，先应用 `disallowedTools`，再按 `tools` 解析剩余池。

MCP 服务器级模式：`mcp__<server>` 或 `mcp__<server>__*` 授予或移除指定服务器的所有工具。

### 8.2 限制可生成的 Sub-Agent

当 agent 作为主线程运行时（`claude --agent`），在 `tools` 字段使用 `Agent(agent_type)` 语法：

```yaml
---
name: coordinator
description: Coordinates work across specialized agents
tools: Agent(worker, researcher), Read, Bash
---
```

允许生成任何 sub-agent：`tools: Agent, Read, Bash`。**如果省略 `Agent`，该 agent 不能生成任何 sub-agent**。

### 8.3 权限模式

| 模式 | 行为 |
|------|------|
| `default` | 标准权限检查并提示 |
| `acceptEdits` | 自动接受文件编辑和常见文件系统命令 |
| `auto` | 自动模式：后台分类器审查命令 |
| `dontAsk` | 自动拒绝权限提示 |
| `bypassPermissions` | 跳过权限提示 |
| `plan` | 计划模式（只读探索） |

> ⚠️ **谨慎使用 `bypassPermissions`**：它允许 sub-agent 无需批准执行操作，包括写入 `.git`、`.config/git`、`.claude`、`.vscode`、`.idea`、`.husky`、`.cargo`、`.devcontainer`、`.yarn`、`.mvn`。

父级用 `bypassPermissions` 或 `acceptEdits` 时优先；父级用 auto 模式时 sub-agent 继承 auto 模式。

### 8.4 预加载 Skills

```yaml
---
name: api-developer
description: Implement API endpoints following team conventions
skills:
  - api-conventions
  - error-handling-patterns
---
```

### 8.5 启用持久内存

```yaml
---
name: code-reviewer
description: Reviews code for quality and best practices
memory: user
---
```

| 作用域 | 位置 | 适用场景 |
|--------|------|---------|
| `user` | `~/.claude/agent-memory/<name-of-agent>/` | sub-agent 跨所有项目记住学习内容 |
| `project` | `.claude/agent-memory/<name-of-agent>/` | 项目特定，可通过版本控制共享 |
| `local` | `.claude/agent-memory-local/<name-of-agent>/` | 项目特定但不提交到版本控制 |

启用内存时，sub-agent 系统提示包含内存目录下 `MEMORY.md` 的前 200 行或 25KB。

### 8.6 禁用特定 Sub-Agent

```json
{
  "permissions": {
    "deny": ["Agent(Explore)", "Agent(my-custom-agent)"]
  }
}
```

或 CLI：`claude --disallowedTools "Agent(Explore)"`

---

## 九、Hooks 事件

Sub-Agent 支持以下 hooks：

| 事件 | 匹配输入 | 触发时机 |
|------|---------|---------|
| `PreToolUse` | 工具名 | sub-agent 使用工具前 |
| `PostToolUse` | 工具名 | sub-agent 使用工具后 |
| `Stop` | (无) | sub-agent 完成时（运行时转换为 `SubagentStop`） |
| `SubagentStart` | Agent 类型名 | sub-agent 开始执行 |
| `SubagentStop` | Agent 类型名 | sub-agent 完成 |

```yaml
---
name: db-reader
description: Execute read-only database queries
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---
```

---

## 十、使用 Sub-Agent

### 10.1 自动委派

Claude 基于任务描述、sub-agent 配置中的 `description` 字段和当前上下文自动委派任务。**在 description 中包含 "use proactively" 等短语**。

### 10.2 显式调用（三种方式）

**自然语言：**
```text
Use the test-runner subagent to fix failing tests
```

**@-mention**：输入 `@` 从提示中选择：
```text
@"code-reviewer (agent)" look at the auth changes
```

**会话级**：使用 `--agent <name>` flag：
```bash
claude --agent code-reviewer
```

插件 sub-agent 带子文件夹：`claude --agent my-plugin:review:security`

### 10.3 前台与后台运行

- **前台 Sub-Agent**：阻塞主对话直到完成
- **后台 Sub-Agent**：并发运行，你继续工作

禁用后台任务：`CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1`

### 10.4 嵌套 Sub-Agent

自 v2.1.172，sub-agent 可以生成自己的 sub-agent。**深度限制：深度 5 的 sub-agent 不接收 Agent 工具**。限制固定且不可配置。

---

## 十一、主对话 vs Sub-Agent 选择

### 使用主对话的场景
- 频繁来回交互
- 多阶段共享上下文
- 快速针对性变更
- 延迟敏感

### 使用 Sub-Agent 的场景
- 主上下文中不需要详细输出
- 想强制工具限制
- 工作是自包含的

---

## 十二、Sub-Agent 上下文管理

### 启动时加载内容

非 fork 的 sub-agent 初始上下文包含：
- **系统提示**：agent 自己的提示加环境详情
- **任务消息**：Claude 写的委派提示
- **CLAUDE.md 和内存**：内存层次每个层级（Explore 和 Plan 跳过）
- **Git 状态**：父会话开始时的快照（Explore 和 Plan 跳过）
- **预加载 skills**：`skills` 字段中任何 skill 的完整内容

---

## 十三、核心要点速记

| 问题 | 答案 |
|------|------|
| Sub-Agent 是什么？ | 在独立上下文窗口运行的专门 AI 助手 |
| 何时用 Sub-Agent？ | 任务会产生大量不需要回到主对话的内容时 |
| 如何触发？ | 自动（基于 description）或显式（自然语言/@-mention/--agent） |
| 配置位置？ | `.claude/agents/`（项目）或 `~/.claude/agents/`（用户） |
| 能嵌套吗？ | 能，但深度上限 5 |
| 能调用 Skills 吗？ | 能，用 `skills` 字段预加载 |
| 与 Skills 区别？ | Sub-Agent 是"独立工人"，Skills 是"标准说明书" |

---

## 十四、官方资源链接

- [Claude Code Sub-Agents 文档](https://code.claude.com/docs/en/sub-agents)
- [背景 Agent](https://code.claude.com/docs/en/agent-view)
- [Agent 团队](https://code.claude.com/docs/en/agent-teams)
- [Anthropic Skills GitHub 仓库](https://github.com/anthropics/skills)
- [Agent Skills 规范](https://agentskills.io/specification)