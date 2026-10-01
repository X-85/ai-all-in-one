# ai-all-in-one · 个人知识库与作品集

> 一年多 AI 实战的沉淀:语言演进系列、AI 求职技能专题、RAG/Agent 方法论文档——全部由"人设计工作流 + AI 量产 + 台账留痕"的协作方式产出。

## 🌐 在线站点

| 站点 | 地址 | 内容 |
|------|------|------|
| 语言演进笔记站 | https://x-85.github.io/ai-all-in-one/ | 20 篇语言/框架/中间件演进路线,因果链叙事 + 构建工具链速查 |
| AI 求职技能站 | https://x-85.github.io/ai-all-in-one/career/ | AI 应用工程岗技能专题:原理/工程/质量/证据四层框架 |

## 📂 两大专题

### 语言演进路线系列(20 篇)

`knowledge/doc/lang-evolution-notes/` —— JS-Node-TS / Python / Java / Go / Rust / Next.js / Vue / React / C / C++ / C# / SQL / Redis / Kafka / MySQL / Docker-K8s / Spring / Django-Flask-FastAPI……

每篇回答三个问题:它为什么诞生、它解决了什么前世解决不了的问题、工程师今天能从它的演进学到什么。模板与约定见 [session/decisions.md](session/decisions.md)。

### AI 求职技能专题(四层框架)

`ai-career-notes/` —— 以 AI 应用工程岗为目标,把一年多 agent 实战经验体系化:

- **原理层**:LLM 生成机制(上/下)、检索原理——每个概念落到"工程上意味着什么"
- **工程层**:RAG 系统设计复盘(钉钉+AstrBot 四路由系统)、工作流方法论、六工具横评
- **质量层**:golden set 评测实践(随公司项目落地推进)
- **证据层**:面试故事库、求职材料 checklist

## 📄 方法论与实战文档精选(`knowledge/doc/`)

- [RAG 问答系统质量设计:问答记录与落地方案](knowledge/doc/RAG问答系统质量设计-问答记录与落地方案.md) —— 四路由蓝图 + golden set 评估闭环
- [AstrBot 钉钉日志智能分析方案](knowledge/doc/AstrBot-钉钉日志智能分析方案.md) —— 三层递进分析、受控工具、MCP 引入决策
- [使用 AI 快速构建产品能力文档](knowledge/doc/使用AI快速构建产品能力文档.md) —— "审核初稿"人机分工模式
- [AI 治理工程方法论](knowledge/doc/AI治理工程方法论.md)
- [ZCode-MCP 巡览与配置文档生成公司试点手册](knowledge/doc/ZCode-MCP巡览与配置文档生成-公司试点手册.md) —— 工作流移交:占位符 + 铁律 + 验收

## ⚙️ 这套仓库怎么运转(工作法本身也是作品)

- **AGENTS.md**:仓库级与目录级 agent 指令——新会话零口令接续,产出一致
- **session/ 台账**:问题索引(events/index/decisions 三件套)——每个决定、每次踩坑可溯源
- **双站自动部署**:push 到 main 即构建上线

## 📝 编辑指南

文档均为 Markdown;`knowledge/doc/` 存方法论文档,两个专题目录各有自己的 AGENTS.md 约定。提交走 [git-knowledge-sync](.agents/skills/git-knowledge-sync/SKILL.md) 流程。
