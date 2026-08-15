# CC Switch 是什么

> 本文根据 CC Switch 官方仓库、README、版本发布说明和源码目录整理。
> 信息截至 2026-08-05。

## 一句话定义

CC Switch 是一个开源、跨平台的 AI 编程工具管理桌面应用。它最初主要用于切换 Claude Code 的 API 供应商，后来发展为集供应商管理、MCP/Skills/Prompt 管理、本地协议代理、故障转移、会话管理和用量统计于一体的本地 AI 工具控制台。

它不是大模型，也不是模型 API 服务商，而是位于 AI 编程工具和模型服务之间的管理层与适配层。

```text
Claude Code / Codex / Gemini / OpenCode
                |
             CC Switch
                |
不同模型厂商、云平台、聚合平台或本地模型服务
```

## 基本信息

| 项目 | 信息 |
| --- | --- |
| 项目名称 | CC Switch |
| 主要开发者 | Jason Young |
| GitHub 用户 | [farion1231](https://github.com/farion1231) |
| 官方网站 | [ccswitch.io](https://ccswitch.io) |
| 官方仓库 | [farion1231/cc-switch](https://github.com/farion1231/cc-switch) |
| 下载地址 | [GitHub Releases](https://github.com/farion1231/cc-switch/releases/latest) |
| 开源协议 | MIT |
| 当前版本 | v3.19.1（截至本文日期） |
| 支持平台 | Windows、macOS、Linux |

官方 README 明确声明 `ccswitch.io` 是唯一官方网站。下载软件时应优先通过官方网站或 GitHub 官方仓库，避免使用同名的第三方下载站。

## 支持的工具

截至 v3.19.1，CC Switch 的 README 列出以下管理对象：

- Claude Code
- Claude Desktop
- Codex
- Gemini CLI
- Grok Build
- OpenCode
- OpenClaw
- Hermes Agent

因此，今天的 CC Switch 已经不只是“Claude Code 配置切换器”。“CC”可以理解为它早期围绕 Claude Code 发展的历史痕迹，但当前产品范围已经扩展到多个 AI 编程工具和 Agent 工具。

## 它解决什么问题

### 1. 解决多套配置手动修改的问题

不同 AI 工具使用的配置文件和格式不一样，可能涉及 JSON、TOML、环境变量和多个本地目录。切换供应商时，用户通常需要手动修改 Base URL、API Key、模型名和其他参数。

CC Switch 把这些配置抽象成供应商卡片，可以保存多套配置并一键切换。它还会对配置进行快照、备份和恢复，降低手动编辑出错的风险。

### 2. 解决不同 API 协议不兼容的问题

常见模型接口包括：

- Anthropic Messages API
- OpenAI Chat Completions API
- OpenAI Responses API
- Gemini API

如果 AI 工具使用的协议和目标供应商提供的协议不同，仅修改 API 地址和 Key 还不够。这时 CC Switch 的本地代理可以进行请求和响应转换，例如：

```text
Claude Code
  -> Anthropic 格式请求
  -> CC Switch 本地代理
  -> OpenAI 或其他供应商格式请求
  -> 目标模型服务
  -> CC Switch 转换响应
  -> Claude Code
```

转换内容可能包括消息结构、模型名称、工具调用、思考参数、流式事件、Token 用量、错误格式和认证信息。

### 3. 解决 MCP、Skills 和 Prompt 分散的问题

不同工具的 MCP Server、Skills 和提示词文件通常分散在不同目录。CC Switch 提供统一面板，用于管理和同步：

- MCP Server
- Skills
- `CLAUDE.md`
- `AGENTS.md`
- `GEMINI.md`
- Prompt 配置

### 4. 解决供应商不稳定的问题

本地代理支持多供应商优先级、健康检查、自动故障转移、重试和熔断器。当当前供应商不可用时，可以自动切换到备用供应商。

### 5. 解决用量和费用不透明的问题

CC Switch 可以综合代理日志、会话日志和供应商查询结果，展示请求量、Token、缓存命中率、模型费用、余额和配额等信息。

### 6. 解决官方账号和第三方供应商只能二选一的问题

某些工具的认证文件本身是单槽配置，例如 Codex 的 `auth.json` 和 `config.toml`。CC Switch 会按供应商保存配置快照，让用户在官方账号、第三方 API 和不同模型供应商之间切换，同时尽量保留历史会话。

## 主要功能

### 供应商管理

- 供应商预设和自定义供应商
- API Key、Base URL、模型和高级参数管理
- 不同应用的独立供应商配置
- 通用供应商配置，并同步到多个应用
- 模型列表自动发现
- 供应商健康检查和余额查询

### 本地代理和路由

- 本地 HTTP API Proxy
- Anthropic、OpenAI Chat、OpenAI Responses、Gemini 等协议适配
- 按应用启用代理接管
- 模型映射和请求重写
- 自动故障转移
- 熔断器和健康状态记录
- 请求日志和用量统计

### 扩展和会话管理

- MCP Server 管理、导入和同步
- Skills 安装、发现、更新、备份和恢复
- Prompt 编辑和跨应用同步
- Claude、Codex、Gemini、OpenCode 等会话查看
- 会话搜索、恢复和用量导入

### 桌面应用能力

- 系统托盘快速切换
- 轻量模式
- 深链导入，例如 `ccswitch://`
- OAuth 登录和账号管理
- 自动更新
- Windows、macOS、Linux 安装包

## 技术路线

### 整体架构

```text
React + TypeScript + Vite 前端
                |
            Tauri 2 IPC
                |
Rust 后端
  |             |              |
配置适配器    SQLite 数据库    本地代理服务器
  |             |              |
JSON/TOML/ENV  供应商/日志/用量  协议转换/路由/故障转移
```

### 技术选型

| 层次 | 技术或实现 |
| --- | --- |
| 桌面框架 | Tauri 2 |
| 前端 | React、TypeScript、Vite、Tailwind |
| 后端 | Rust |
| 本地数据库 | SQLite，通过 `rusqlite` 管理 |
| 网络代理 | Rust 网络栈，使用 Axum/Hyper 相关组件 |
| 配置读写 | 针对 Claude、Codex、Gemini、OpenCode 等工具的适配器 |
| 数据处理 | JSON、TOML、YAML、环境变量、SSE 流式响应 |
| 数据保护 | 配置快照、备份、数据库迁移、原子写入 |
| 发布方式 | Windows MSI、macOS DMG、Linux AppImage/Deb/RPM 等 |

核心功能主要在本地运行，供应商数据保存在本地数据库和配置文件中；Dropbox、OneDrive、iCloud、WebDAV 等同步属于可选能力。

### 代码结构体现的模块

- [代理与协议转换](https://github.com/farion1231/cc-switch/tree/main/src-tauri/src/proxy)
- [数据库、迁移和备份](https://github.com/farion1231/cc-switch/tree/main/src-tauri/src/database)
- [供应商和配置命令](https://github.com/farion1231/cc-switch/tree/main/src-tauri/src/commands)
- [MCP 管理](https://github.com/farion1231/cc-switch/tree/main/src-tauri/src/mcp)
- [会话管理](https://github.com/farion1231/cc-switch/tree/main/src-tauri/src/session_manager)
- [Rust 依赖和后端配置](https://github.com/farion1231/cc-switch/blob/main/src-tauri/Cargo.toml)

### Tauri 2 的作用

Tauri 2 是一个桌面应用框架，负责把 Web 前端包装成 Windows、macOS 和 Linux 桌面程序。它不是前端 UI 框架，而是连接前端页面和操作系统能力的桌面外壳。

```text
React / TypeScript / Vite
          |
       Tauri 2
          |
Rust 后端 + 操作系统能力
```

在 CC Switch 中，Tauri 主要负责：

- 创建桌面窗口并打包安装程序
- 让前端通过 IPC 调用 Rust 后端
- 访问本地文件、SQLite 和系统进程
- 管理系统托盘、深链、单实例和自动更新
- 启动本地代理并与桌面应用生命周期绑定

如果只做普通浏览器页面，就不需要 Tauri。Tauri 的价值在于突破浏览器沙箱，安全地使用本机文件、进程、数据库和系统功能。

### 如果改成浏览器访问

React、TypeScript、Vite、Tailwind 足以构建前端界面，但不一定足以实现完整的 CC Switch Web 版。

```text
浏览器前端
  -> HTTP / WebSocket
后端服务
  -> 数据库、用户认证、文件、模型 API
```

仅展示页面、表单或静态数据时，可以只使用前端技术。以下功能通常还需要后端：

- 保存用户配置和供应商数据
- 用户登录、权限和多用户管理
- 数据库和用量统计
- 安全保存 API Key
- 调用模型 API

浏览器本身也不能随意读取本机的 Claude/Codex 配置、启动 CLI 或管理本地代理。因此，如果 Web 版仍然要管理用户电脑上的本地工具，还需要增加本地 Agent、桌面辅助程序或浏览器扩展。

常见架构有三种：

```text
纯 Web：      浏览器 -> Web 后端 -> 数据库 / 模型 API
本地 Agent：  浏览器 -> 本地 Agent -> 本机配置 / CLI / 代理
桌面应用：    Web 前端 -> Tauri -> Rust -> 本机资源
```

### Rust 适合做什么

Rust 适合编写对性能、并发、内存安全和系统能力有较高要求的软件，常见场景包括：

- 系统工具、命令行工具和文件处理工具
- HTTP API、WebSocket、高并发后端服务
- 网络代理、协议转换、连接复用和流式处理
- 数据库、任务调度和后台服务
- 桌面应用的文件、进程、托盘和操作系统集成层
- 嵌入式程序和 WebAssembly 模块

CC Switch 使用 Rust，主要是因为它需要同时处理本地系统能力和高并发网络代理，例如 HTTP 转发、SSE 流式响应、协议转换、超时、重试、故障转移和 SQLite 操作。

可以这样理解各层职责：

```text
React       负责页面和交互
TypeScript  负责前端类型和业务逻辑
Tauri       负责桌面窗口与前端/后端桥接
Rust        负责本地能力、数据库和高性能代理
```

### 和 Tauri 相似的技术

最接近 Tauri 的技术，是使用 Web 前端构建桌面应用的框架：

| 技术 | 前端 | 本地后端 | 特点 |
| --- | --- | --- | --- |
| Electron | React、Vue、Svelte 等 | Node.js | 生态最成熟，但安装包和内存占用通常较大 |
| Wails | React、Vue、Svelte 等 | Go | 技术路线接近 Tauri，适合熟悉 Go 的开发者 |
| Neutralinojs | HTML、JavaScript、React 等 | 原生运行时 | 轻量，但生态和桌面能力相对有限 |
| NW.js | HTML、JavaScript | Node.js + Chromium | 与 Electron 类似，目前使用相对较少 |
| WebView/Webview | 任意 Web 前端 | C、C++、Rust、Go 等 | 更底层，需要自行处理更多桌面能力 |
| Flutter Desktop | Flutter、Dart | Dart/原生代码 | 跨平台能力强，但不能直接复用普通 Web 前端 |
| Qt/QML | Qt/QML、C++、Python | C++ | 成熟稳定，适合专业桌面软件，但学习成本较高 |
| .NET MAUI | XAML、C# | .NET | 适合 C# 和微软技术栈 |

Tauri 与 Electron 的核心区别是：Electron 自带 Chromium 和 Node.js；Tauri 使用系统 WebView，并以 Rust 作为本地后端。Wails 则可以理解为“用 Go 替代 Rust 的 Tauri”。

对于 CC Switch 这类应用，选择可以简单归纳为：

- React 前端加小体积桌面应用：Tauri
- 追求成熟生态和快速开发：Electron
- 熟悉 Go：Wails
- 追求完整原生 UI：Flutter 或 Qt
- 已经使用 C#：.NET MAUI 或 Avalonia

## 起源与发展过程

### 第一阶段：配置切换器

项目的首次提交时间是 2025-08-04。早期代码是 Electron 桌面应用，重点是管理和切换 AI 供应商配置。

早期的重要变化包括：

- 添加供应商编辑和导入功能
- 支持默认供应商
- 从简单字段替换升级为完整配置文件切换
- 增加配置备份和恢复思路

项目在 2025-08-07 左右已经出现 1.x 版本，并于 2025-08-22 发布 v2.0.3。

### 第二阶段：本地 AI 网关

2026-01-08 发布的 v3.9.0 是重要转折点。该版本加入：

- 基于 Axum 的本地高性能 HTTP 代理
- Claude Code、Codex、Gemini CLI 的统一代理
- 自动故障转移和熔断器
- 通用供应商
- MCP 导入
- 跨应用 Skills 管理
- 用量和缓存统计

从这个版本开始，CC Switch 的定位从“配置管理器”扩展为“本地 AI 网关”。

### 第三阶段：协议、账号和生态扩展

2026-03 至 2026-05，项目继续扩展：

- v3.12.3：GitHub Copilot OAuth 反向代理、OpenCode SQLite 会话、推理参数映射
- v3.13.0：Codex OAuth 反向代理、模型自动发现、配额查询、会话用量导入、轻量托盘模式
- v3.15.0：Claude Desktop 成为独立管理对象，支持第三方供应商和角色模型映射，并加强代理可靠性

### 第四阶段：多 Agent 工具平台

v3.19.1 发布于 2026-07-31。此时 CC Switch 已经支持 8 类 AI 工具，并继续增强：

- Codex 原生 Responses API 支持
- DeepSeek、火山方舟 Coding Plan、腾讯混元等 Codex 供应商预设
- 官方模型目录镜像
- Grok Build 故障转移和环境变量检测
- Claude Desktop 用量统计修复
- 受管 CLI 工具的安装、升级和冲突诊断

## 与普通“改 Base URL”工具的区别

普通切换脚本通常只修改几个字段：

```text
Base URL + API Key + Model
```

CC Switch 的范围更大：

1. 保存和恢复完整供应商配置。
2. 适配多个 AI 编程工具的不同配置格式。
3. 在必要时启动本地代理进行协议转换。
4. 提供故障转移、日志和用量统计。
5. 管理 MCP、Skills、Prompt 和会话。
6. 通过桌面界面、托盘和深链降低使用成本。

但并不是每一次切换都需要代理。如果目标供应商原生支持目标工具所需的协议，CC Switch 可以让工具直接连接；只有协议不兼容时，才需要本地代理进行转换。

## 风险和边界

### API Key 和配置安全

CC Switch 需要管理 API Key、OAuth 状态和本地配置文件。使用时应：

- 只从官方渠道下载
- 保护本机账户和数据库文件
- 不把导出的配置、日志或 API Key 提交到 Git
- 使用代理前确认请求数据的流向

### 代理并不等于完全兼容

普通文本和基础流式输出通常比较容易转换，但以下能力可能出现差异：

- 工具调用
- 思考参数和思考内容
- 多模态输入
- 上下文缓存
- Token 用量
- 错误码和错误响应
- 长连接和流式事件

### 服务条款和数据留存

启用第三方供应商代理、OAuth 反向代理或订阅账号转发时，请确认目标供应商的服务条款、计费规则、数据留存政策和合规要求。CC Switch 官方发布说明也对部分 OAuth 反代功能进行了风险提示。

## 结论

CC Switch 的演进路线可以概括为：

```text
Claude Code 供应商切换器
        -> 多工具配置管理器
        -> 本地协议代理和故障转移网关
        -> AI 编程工具统一控制台
```

它最核心的价值不是简单地替换 API Key，而是把不同 AI 工具、不同配置格式、不同 API 协议和不同模型供应商整合到一个本地桌面应用中。

## 参考资料

- [CC Switch 官方网站](https://ccswitch.io)
- [GitHub 官方仓库](https://github.com/farion1231/cc-switch)
- [中文 README](https://github.com/farion1231/cc-switch/blob/main/README_ZH.md)
- [首次提交](https://github.com/farion1231/cc-switch/commit/e0a9c1ab4c46ecadf665dfb31dd967ce6f0019ac9)
- [v3.9.0 发布说明：本地代理和自动故障转移](https://github.com/farion1231/cc-switch/releases/tag/v3.9.0)
- [v3.12.3 发布说明：Copilot 代理和 OpenCode SQLite](https://github.com/farion1231/cc-switch/releases/tag/v3.12.3)
- [v3.13.0 发布说明：Codex OAuth、配额和会话](https://github.com/farion1231/cc-switch/releases/tag/v3.13.0)
- [v3.15.0 发布说明：Claude Desktop 支持](https://github.com/farion1231/cc-switch/releases/tag/v3.15.0)
- [v3.19.1 发布说明](https://github.com/farion1231/cc-switch/releases/tag/v3.19.1)
