# Claude Agent 官方文档（中文整理）

> 来源：
> 1. [Equipping agents for the real world with Agent Skills](https://anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
> 2. [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
>
> 说明：本文档为 Anthropic 官方关于 Agent 的核心定义与机制的整理

---

## 一、Agent 的定义

### 通用定义（来自 Building Effective Agents）

> "Agents can handle sophisticated tasks, but their implementation is often straightforward. They are typically just LLMs using tools based on environmental feedback in a loop."

**中文**：Agent 能处理复杂任务，但其实现通常很直接——本质上是 **基于环境反馈在循环中使用工具的 LLM**。

### Workflows vs Agents（关键区分）

| 类型 | 定义 |
|------|------|
| **Workflows** | LLM 和工具通过**预定义代码路径**编排的系统 |
| **Agents** | LLM **动态指导自身流程和工具使用**的系统，对如何完成任务保持控制权 |

Anthropic 将两者都归为 "agentic systems"（智能体系统），但做出重要架构区分。

---

## 二、Agent 的核心特征

1. **启动方式**：通过用户命令或交互式讨论开始
2. **自主规划与执行**：任务明确后独立规划和操作
3. **环境反馈**：每步从环境获取真实反馈（如工具调用结果、代码执行）
4. **人类介入**：在 checkpoint 处暂停获取人类反馈，或遇到阻塞时回退
5. **终止条件**：任务完成时终止，通常包含最大迭代次数等停止条件

**本质**：Agent 是 **LLM + 工具 + 环境反馈循环** 的组合。

---

## 三、通用 Agent 与专业化 Agent

### 通用 Agent（General-purpose agents）

随着模型能力提升，现在可以构建与完整计算环境交互的通用 Agent。例如 **Claude Code** 能够使用本地代码执行和文件系统在多个领域完成复杂任务。

### 专业化 Agent（Specialized agents）

通过 **Agent Skills**（指令、脚本和资源的可组合资源）将通用 Agent 转变为适合特定需求的**专业化 Agent**。

---

## 四、Agent 的核心能力

1. **与计算环境交互**：使用本地代码执行和文件系统
2. **跨领域执行复杂任务**（Claude Code 的典型能力）
3. **动态发现与加载 Skills**：从系统提示中预加载的元数据判断何时调用某个 skill
4. **渐进式信息披露（Progressive Disclosure）**：
   - **第一层**：所有已安装 skill 的名称和描述（启动时加载）
   - **第二层**：相关 skill 的完整 `SKILL.md` 内容
   - **第三层及更深**：按需浏览的附加文件
5. **代码执行能力**：可执行 skill 中捆绑的脚本（如 PDF skill 的预写 Python 脚本），无需将脚本或文件加载到上下文中
6. **自主决定**：自行判断何时触发某个 skill、运行哪些脚本

---

## 五、多 Agent 协作模式

### Orchestrator-workers（编排者-工作者）

> "a central LLM dynamically breaks down tasks, delegates them to worker LLMs, and synthesizes their results"

- **中心 LLM** 动态分解任务
- **委派给 worker LLMs**
- **综合其结果**
- 与 parallelization 的关键区别：**灵活性**——子任务不是预定义的，由 orchestrator 根据输入决定

**应用场景：**
- 对多个文件做复杂修改的编码产品
- 涉及从多个来源收集和分析信息的搜索任务

### Parallelization（并行化）

两种变体：
- **Sectioning**：分解为独立的子任务并行运行
- **Voting**：多次运行同一任务获得多样化输出

> 注：Anthropic 官方文档**未明确提及 sub-agent 概念**，最接近的是 Orchestrator-workers 模式。

---

## 六、Agent 设计三大核心原则

1. **保持设计简洁性**（Simplicity）
2. **通过显式展示规划步骤保证透明性**（Transparency）
3. **精心设计 Agent-Computer Interface（ACI）**，包括工具文档和测试

---

## 七、构建 Skill 装备 Agent 的方法论

1. **从评估开始**：在代表性任务上运行 agent，观察短板，针对性构建 skill
2. **为可扩展性而设计**：将过大的 `SKILL.md` 拆分为独立文件并交叉引用
3. **从 Claude 视角思考**：监控 Claude 实际使用 skill 的方式并迭代
4. **与 Claude 共同迭代**：让 Claude 自行总结成功方法和常见错误

---

## 八、Agent 使用建议

**适用场景：**
- 开放性问题
- 难以预测所需步骤数
- 无法硬编码固定路径
- 需要 LLM 自主决策

**风险警告：**
- 自主性带来更高成本
- 错误可能**复合累积**
- 推荐在沙盒环境中充分测试，并设置适当的护栏

---

## 九、安全考量

> 恶意 skill 可能引入漏洞或指示 Claude 窃取数据。

**Anthropic 建议：**
- **仅从可信来源安装 skill**
- 安装前审查文件内容、代码依赖及外部网络调用

---

## 十、未来方向

- 支持 skill 的完整生命周期（创建、编辑、发现、分享、使用）
- 与 **Model Context Protocol (MCP)** 互补
- 长期目标：让 agent **自主创建、编辑和评估 skill**，将其行为模式编码为可复用能力

---

## 十一、当前支持平台

- Claude.ai
- Claude Code
- Claude Agent SDK
- Claude Developer Platform

---

## 十二、相关框架

用于构建 agentic 系统的框架：
- Claude Agent SDK
- Strands Agents SDK（AWS）
- Rivet（GUI 工作流构建器）
- Vellum（GUI 工作流构建与测试工具）

---

## 十三、官方资源链接

- [Equipping agents for the real world with Agent Skills](https://anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)
- [Anthropic Skills GitHub 仓库](https://github.com/anthropics/skills)
- [Agent Skills 规范](https://agentskills.io/specification)

---

## 核心要点速记

| 问题 | 答案 |
|------|------|
| Agent 是什么？ | LLM + 工具 + 环境反馈循环 |
| Agent 与 Workflow 区别？ | Workflow 预定义路径，Agent 动态决策 |
| Agent 与 Skills 关系？ | Skills 把通用 Agent 武装成专业化 Agent |
| 是否有 sub-agent 概念？ | 官方未明确提，最接近的是 Orchestrator-workers |