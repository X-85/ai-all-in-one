# Agent 理解总结

## 一、Claude Code 本身就是 Agent

- **Claude Code 是主 Agent**：用户与之交互，它自主完成任务
- **内置的 Explore、Plan、general-purpose 等就是子 Agent**
- **工作关系**：
  - 主 Agent 接收用户请求
  - 遇到匹配子 Agent 描述的任务时**自动委派**
  - 子 Agent 在自己上下文里干活，结果返回主 Agent
  - 主 Agent 综合结果交付用户
- **Plan 模式特殊点**：Plan 子 Agent 专用于计划阶段，研究后返回方案，但不执行修改（只读工具），主 Agent 等用户确认后才继续

## 二、如何做自己的 Agent

**核心**：不一定要从头做，用现有 SDK/框架最快。

### 三种方式

#### 1. 用 Claude Agent SDK（最快）
Anthropic 官方 SDK，封装好工具调用、循环、权限管理，相当于"Claude Code 的内核"

#### 2. 基于现有 Agentic 框架
- Claude Agent SDK
- Strands Agents SDK（AWS）
- LangGraph、AutoGen 等

#### 3. 从零搭建（学习原理用）
LLM + 工具循环 + 上下文管理 + 权限控制

### 关键组件
1. **LLM 接口**：模型 API
2. **工具系统**：定义工具（读文件、执行命令等）
3. **循环控制**：自主决策循环
4. **上下文管理**：滑动窗口、压缩
5. **权限系统**：操作前确认
6. **Skills/Plugins**：能力扩展

**建议**：先从 Claude Agent SDK 入手，不要重复造轮子。

## 三、Claude Agent SDK 是什么

**官方给的工具包**，让你在自己的程序里跑 Claude Agent——类似 Claude Code 内核但可嵌入任何应用。

### 核心能力
- 调用 Claude 模型
- 工具执行（文件、命令、代码）
- 子 Agent 委派
- Skills 加载
- 权限管理
- Hooks 生命周期

### 能否构建非 Claude Code 风格的 Agent？

**能，且推荐。**

SDK 不强制你做"终端编程助手"，你可以构建：
- 数据分析 Agent
- 客服 Agent
- 自动化运维 Agent
- 任何自定义领域的 Agent

**只是底层用 Claude 模型 + 工具循环**，界面、场景完全由你定。

## 四、个人练习推荐工具

**轻量、低成本：**
- **Claude Agent SDK / Strands SDK**：理解 Agent 核心循环
- **LangChain / LangGraph**：图结构编排，直观
- **OpenAI Assistants API**：快速上手
- **Dify / Coze**：零代码平台，理解 Agent 概念
- **Cursor / Claude Code**：在 IDE 里实践 Plan、Sub-Agent

**学习路径：**
1. 先用 Coze/Dify 搭个简单 Agent
2. 用 LangGraph 写代码版
3. 用 Claude Agent SDK 做完整项目

## 五、公司级 Agent 开发技术栈（招聘常见）

### 基础层
- **LLM API**：Anthropic Claude、OpenAI GPT、国产（Qwen/DeepSeek/智谱）
- **编程语言**：Python（主流）、TypeScript/Node.js

### 框架与编排
- **LangChain / LangGraph**：最常见
- **Claude Agent SDK / Strands SDK**：企业级首选
- **LlamaIndex**：RAG 场景多
- **CrewAI / AutoGen**：多 Agent 协作

### 工具与协议
- **MCP（Model Context Protocol）**：Anthropic 推，工具接入标准
- **Function Calling / Tool Use**：基础能力

### 向量数据库（RAG 用）
- Milvus、Qdrant、Weaviate、Pinecone

### 部署运维
- Docker / Kubernetes
- FastAPI / Flask（接口）
- Redis（缓存/会话）

### 监控与评估
- LangSmith、LangFuse
- 自建评估体系

## 六、招聘常见要求（按岗位）

| 岗位方向 | 重点技能 |
|---------|---------|
| **Agent 应用开发** | LangChain/LangGraph + LLM API + Prompt 工程 |
| **Agent 平台/框架** | 分布式系统 + 多 Agent 架构 + 性能优化 |
| **RAG/知识库** | LlamaIndex + 向量数据库 + Embedding |
| **企业级 Agent** | Claude Agent SDK + MCP + 权限/安全 |
| **算法/研究** | 强化学习 + Tool Learning + 模型微调 |

## 七、推荐学习路线

```
1. Prompt 工程 + Function Calling 基础
        ↓
2. LangChain/LangGraph 搭简单 Agent
        ↓
3. RAG + 向量数据库
        ↓
4. Multi-Agent 协作（CrewAI/AutoGen）
        ↓
5. MCP 协议 + Skills 设计
        ↓
6. 企业级 Agent SDK（Claude Agent SDK）
        ↓
7. 部署、监控、评估全链路
```

**建议**：先精通 Python + LangGraph + 一个主流 LLM，再横向扩展。