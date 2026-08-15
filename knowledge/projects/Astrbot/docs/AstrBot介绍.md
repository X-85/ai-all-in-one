# AstrBot 介绍

> 整理日期：2026-08-07  
> 资料来源：AstrBot 官网、GitHub 仓库、官方文档及 GitHub API 公开信息。

## 一句话定义

AstrBot 是一个开源的一站式 Agent 个人与群聊助手，也是一个用于开发对话式 AI 应用的框架。它把即时通讯平台、LLM、Agent、插件、知识库和工具调用能力组织在同一个可自部署系统中，使用户可以直接在 QQ、Telegram、企业微信、飞书、钉钉、Discord、Slack 等聊天平台里使用和扩展 AI 应用。

从产品形态看，AstrBot 不是单一的聊天机器人，也不是某一家模型厂商的客户端，而是位于“消息平台”和“AI 能力”之间的连接与编排层：

```text
QQ / Telegram / 企业微信 / 飞书 / Discord / Slack / ...
                         |
                 平台适配与消息处理
                         |
       AstrBot 核心：会话、Agent、插件、工具、知识库
                         |
       OpenAI 兼容服务 / Anthropic / Gemini / 本地模型 / Agent 平台
```

## 基本信息

| 项目 | 信息 |
| --- | --- |
| 项目名称 | AstrBot |
| 项目定位 | AI Agent 助手与开发框架、多平台 Agent 聊天机器人平台 |
| 官网 | [https://astrbot.app](https://astrbot.app) |
| 官方文档 | [https://docs.astrbot.app](https://docs.astrbot.app) |
| GitHub 仓库 | [AstrBotDevs/AstrBot](https://github.com/AstrBotDevs/AstrBot) |
| 代码托管组织 | AstrBot AI（GitHub 组织：AstrBotDevs） |
| 开源协议 | AGPL-3.0-or-later；同时需要遵守项目 EULA |
| 仓库创建时间 | 2022-12-08 |
| 当前版本快照 | v4.27.2，2026-08-05 发布 |

仓库信息和版本数据会持续变化。上表中的版本与仓库规模只代表整理日期附近的状态，不应当视为永久数据。

## 是谁开发的

AstrBot 是一个由 AstrBot AI 组织维护的开源项目，不是单一商业公司的闭源产品。官方文档明确说明，项目为非盈利项目，由全球开源贡献者共同维护，并采用 AGPL-v3 开源许可证。

从 GitHub 公开信息看：

- 项目仓库归属于 `AstrBotDevs/AstrBot`，组织名称为 AstrBot AI。
- `Soulter` 是仓库的核心开发者和长期维护者，也是当前贡献数量最多的个人贡献者。
- 项目还由其他核心开发成员、平台适配器作者、插件作者和普通社区贡献者共同建设。

因此，更准确的表述是：AstrBot 由 AstrBot AI 组织发起和维护，以 Soulter 等核心开发者为主，并由全球开源社区共同贡献。

## 起源与发展过程

官方公开资料没有提供一份完整的逐年项目编年史，但结合仓库创建时间、版本记录、文档结构和源码演进，可以归纳出 AstrBot 的发展路线。

### 1. 早期：从即时通讯机器人起步

项目仓库创建于 2022 年 12 月。早期产品方向可以概括为：把机器人接入即时通讯平台，使用户能够在熟悉的聊天环境中与机器人互动。

这一阶段的核心问题是平台接入和消息处理，包括消息收取、事件分发、会话管理、消息回复以及不同平台之间的接口差异。

### 2. 扩展期：接入多种 IM 平台和模型服务

随着项目发展，AstrBot 从单一平台机器人扩展为多平台消息基础设施。官方文档目前提供了 QQ、OneBot v11、企业微信、微信公众号、个人微信、飞书、钉钉、Telegram、LINE、Slack、Discord、KOOK、Satori 等平台的接入指南，部分平台由社区适配器提供。

与此同时，AstrBot 建立了模型提供商抽象层，支持 OpenAI 及兼容服务、Anthropic、Google Gemini、DeepSeek、智谱、Moonshot、Ollama、LM Studio 等模型服务。这样，平台接入和模型选择可以相互独立，用户不必为更换模型而重写机器人逻辑。

### 3. 平台化：插件生态和 Web 管理能力

为了避免所有功能都堆积在核心代码中，AstrBot 逐步形成了插件机制和插件市场。插件可以监听消息事件、注册命令、调用 AI、发送消息、保存数据、提供配置页面等，社区插件数量已经超过 1000 个。

项目也加入了 WebUI、配置管理、日志查看、插件管理和 Web ChatUI，使 AstrBot 不再只是一个需要通过命令行维护的后台机器人，而是可以通过浏览器管理和使用的自托管 AI 平台。

### 4. Agent 化：从聊天机器人发展为 AI 应用运行时

当前 AstrBot 的重点已经从“让机器人回答消息”扩展到“让 Agent 在消息平台中完成任务”。官方功能和源码中可以看到以下能力：

- 内置 Agent 执行器和工具调用循环；
- 接入 Dify、Coze、阿里云百炼应用、DeerFlow 等第三方 Agent 平台；
- MCP、Skills、知识库、网页搜索和主动型 Agent；
- 多模态输入、人格设定和自动上下文压缩；
- 代码执行、Shell 调用、文件操作等能力对应的 Agent 沙箱；
- 定时任务、群聊上下文和会话级状态管理。

这意味着 AstrBot 的发展方向已经从“IM 机器人框架”逐渐演变为“面向聊天场景的 Agent 平台和开发框架”。

### 5. 当前阶段：面向个人、开发者和团队的可部署基础设施

截至 2026 年 8 月，官方定位强调个人 AI 伙伴、智能客服、自动化助手和企业知识库等场景。部署方式也覆盖 uv 包管理器、Docker、桌面应用、启动器、云平台、宝塔面板、1Panel、Kubernetes 等，说明项目正在同时服务个人用户、开发者和需要长期运行服务的团队。

## 解决什么问题

### 1. 解决 AI 与聊天平台之间的连接问题

很多用户希望在 QQ、企业微信、飞书、Telegram 或 Discord 中直接使用 AI，但不同平台的认证、消息格式、事件模型和发送接口都不一样。AstrBot 通过平台适配器统一这些差异，让上层 Agent 和插件可以使用较一致的消息事件接口。

### 2. 解决模型服务切换和供应商适配问题

模型服务的 API 协议、认证方式、模型名称和多模态能力各不相同。AstrBot 把模型提供商封装为统一接口，同时兼容 OpenAI 风格服务、Anthropic、Gemini、本地模型和多个国内模型平台，使用户可以更换模型而不必重新开发消息机器人。

### 3. 解决聊天机器人功能难以扩展的问题

传统机器人往往把每个功能都写进主程序，代码容易变得庞大且难以维护。AstrBot 使用插件机制把功能拆分成独立扩展，插件可以增加命令、消息处理、外部 API 调用、AI 能力、存储和管理页面，从而形成社区生态。

### 4. 解决 Agent 能力难以进入真实工作流的问题

单纯的聊天窗口无法覆盖群聊协作、客服响应、消息通知、定时任务和企业知识库等工作流。AstrBot 把 Agent 放入用户已经使用的 IM 平台中，使 AI 可以在会话上下文中调用工具、检索知识、执行任务并返回文本、图片、音频等结果。

### 5. 解决个人和团队对可控部署的需求

用户可以自行选择模型服务、部署位置和数据存储方式，不必把所有会话和插件配置交给单一 SaaS 平台。AstrBot 支持本地机器、云服务器、Docker 和多种面板部署，适合希望自行管理数据和运行环境的用户。

### 6. 解决 Agent 工具调用的安全与可管理问题

Agent 如果可以执行代码、Shell 命令、文件操作或访问网络，就需要隔离、权限控制和会话级资源管理。AstrBot 提供 Agent Sandbox，并在源码中将计算机操作、Shell、文件系统、浏览器和 Python 等能力分成独立模块，试图在可用性和运行安全之间建立边界。

## 技术路线

AstrBot 的技术路线可以概括为：**Python 异步核心 + 事件与流水线处理 + 多平台适配器 + 模型/Agent 抽象层 + 插件生态 + Web 管理界面 + 本地知识与任务能力**。

### 1. Python 异步后端

项目当前 `pyproject.toml` 要求 Python 3.12 及以上，并以 Python 作为主要开发语言。依赖中包含 `aiohttp`、`websockets`、`aiosqlite`、`FastAPI`、`Quart`、`SQLAlchemy`、`SQLModel`、`Pydantic` 等，体现出明显的异步 I/O 和 Web 服务路线。

异步架构适合同时处理多个聊天平台连接、流式模型响应、定时任务、插件调用和 Web 请求，避免某一个外部 API 或长耗时任务阻塞整个机器人进程。

### 2. 事件总线与消息处理流水线

核心代码包含平台管理、消息事件、事件总线和 pipeline 目录。消息到达后，系统可以经过预处理、会话状态检查、内容安全检查、Agent 或插件处理、结果装饰和回复等阶段。

这种设计把“收到一条消息”拆成可组合的处理流程，便于增加权限、限流、内容安全、上下文管理和不同类型的回复策略。

### 3. 平台适配器抽象

AstrBot 为不同 IM 平台提供适配器，并将平台差异隔离在适配层。上层使用统一的消息事件和消息组件表示文本、图片、语音、文件、引用、群聊等内容。

官方平台接入与社区适配器共同构成扩展边界，因此新增平台通常不需要修改 Agent 和插件的核心逻辑。

### 4. LLM 与 Agent 双层抽象

AstrBot 同时抽象了“模型服务”和“Agent 执行器”：

- 模型服务层负责对接 OpenAI 兼容服务、Anthropic、Gemini、Ollama、LM Studio 等服务；
- Agent 层负责上下文、工具调用、执行循环、会话状态、上下文压缩和任务编排；
- 外部 Agent 执行器可以接入 Dify、Coze、阿里云百炼应用和 DeerFlow；
- 内置 Agent 可以在 AstrBot 内部直接使用工具、Skills、MCP 和知识库。

这种分层让“使用哪家模型”和“使用哪种 Agent 工作流”可以分别配置。

### 5. 插件优先的扩展体系

源码中存在 `astrbot/api`、`builtin_stars` 等目录，官方文档也提供了插件开发、事件监听、发送消息、插件配置、插件页面、国际化、存储和发布指南。插件是 AstrBot 连接核心能力与社区生态的主要方式。

插件体系的价值在于：核心框架负责生命周期、消息事件、配置、会话和权限等公共能力，具体业务由插件实现，降低核心代码和扩展之间的耦合。

### 6. 知识库与本地数据存储

项目依赖和源码中可以看到 SQLite、SQLAlchemy/SQLModel、FAISS、BM25、文档解析和向量检索相关组件。其知识库路线大致包括：文档导入、文本切分、稀疏检索、向量检索、排序融合和上下文注入。

这使 AstrBot 可以从通用聊天机器人扩展到企业知识库、个人资料库和基于文档的问答场景，同时可以在自托管环境中保存配置、会话和知识库数据。

### 7. WebUI、ChatUI 与多种部署方式

项目包含 dashboard 和 Web API 代码，并通过构建流程把 Web dashboard 打包进 Python 项目。官方同时提供 WebUI、Web ChatUI、Docker、uv、桌面端、启动器、面板和 Kubernetes 等使用方式。

这条路线说明 AstrBot 既考虑服务器后台运行，也考虑个人用户通过浏览器或桌面界面完成配置和聊天。

### 8. 面向 Agent 的工具和安全边界

AstrBot 的 Agent 能力不仅是文本生成，还包括 Function Calling、MCP、Skills、网页搜索、电脑操作、代码解释器、文件处理和主动任务。源码中对 Agent、工具执行器、MCP 客户端、计算机操作和沙箱进行了模块化拆分。

总体上，项目采取的是“能力模块化、工具可插拔、执行环境可隔离”的路线，而不是把所有工具直接写死在模型调用代码中。

## 典型使用场景

- **个人 AI 助手**：在 QQ、Telegram 或 Web ChatUI 中进行多轮对话、语音交互和日常问答。
- **群聊机器人**：在群聊中提供问答、娱乐、信息查询、群管理和自定义命令。
- **智能客服**：接入企业微信、飞书等平台，结合企业知识库回答常见问题。
- **自动化助手**：通过插件、工具调用、定时任务和主动型 Agent 完成通知、查询和流程自动化。
- **企业知识库**：导入 Markdown、PDF 等资料，通过检索增强生成回答内部问题。
- **Agent 应用开发**：利用插件 API、HTTP API 和平台适配器开发可复用的对话式 AI 应用。

## 项目边界与使用注意

1. AstrBot 是 AI 应用运行与编排框架，本身不等于大模型。使用时通常还需要配置模型服务或本地模型。
2. 不同 IM 平台的开放接口、账号风险和服务条款不同，部署前应遵守对应平台规则。
3. Agent 沙箱可以降低工具执行风险，但不能替代完整的操作系统隔离、网络策略、权限控制和密钥管理。
4. 项目采用 AGPL-3.0-or-later，并有单独的 EULA。对项目进行修改后提供具有商业性质的网络服务时，应认真核对许可证和 EULA 要求。
5. 插件来自不同作者，安装第三方插件前应审查源码、权限和网络访问行为。

## 官方入口

- 官网：[https://astrbot.app](https://astrbot.app)
- 官方文档：[https://docs.astrbot.app](https://docs.astrbot.app)
- GitHub：[https://github.com/AstrBotDevs/AstrBot](https://github.com/AstrBotDevs/AstrBot)
- 路线图：[https://astrbot.featurebase.app/roadmap](https://astrbot.featurebase.app/roadmap)
- 官方博客：[https://blog.astrbot.app](https://blog.astrbot.app)

## 资料来源与核验说明

- [AstrBot 官网](https://astrbot.app)：项目名称和官网定位。
- [GitHub README](https://github.com/AstrBotDevs/AstrBot)：项目定位、功能列表、支持的平台、模型服务、部署方式和社区插件规模。
- [官方文档：关于 AstrBot](https://docs.astrbot.app/what-is-astrbot.html)：一站式 Agent 个人和群聊助手的定义、架构概览、平台和 Agent 能力说明。
- [GitHub 仓库信息 API](https://api.github.com/repos/AstrBotDevs/AstrBot)：仓库创建时间、许可证、版本仓库元数据和规模快照。
- [项目依赖配置](https://github.com/AstrBotDevs/AstrBot/blob/master/pyproject.toml)：Python 版本、异步 Web、数据库、模型服务、MCP、FAISS 和构建配置。
- [官方社区页面](https://docs.astrbot.app/community.html)：项目社区和核心开发交流信息。

