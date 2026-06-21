# 电脑软件清单（softlist.md）

> 用途：维护本人电脑上安装的所有软件，每次安装/更新前先检查此清单
> 更新规则：
> - 安装新软件：补充条目
> - 更新已有软件：记录更新时间和新版本
> - 删除软件：标注移除

---

## 系统环境

- **操作系统**：macOS（darwin 25.4.0 arm64）
- **Shell**：zsh
- **最后检查时间**：2026-06-20

---

## 软件清单

| 软件 | 类型 | 安装时间 | 当前版本 | 状态 | 备注 |
|------|------|---------|---------|------|------|
| Python 3.9.6 | 开发语言/解释器 | 已安装（早于记录） | 3.9.6 | ✅ 系统默认 | 系统自带 |
| Python 3.11.15 | 开发语言/解释器 | 2026-06-20 | 3.11.15 | ✅ 已装 | uv 管理，`~/.local/bin/python3.11` |
| Git | 版本控制 | 已安装（早于记录） | 2.50.1 (Apple Git-155) | ✅ 最新 | 系统自带 |
| Docker | 容器化 | 已安装（早于记录） | 29.4.3 | ✅ 最新 | — |
| Node.js | 运行时 | 已安装（早于记录） | 24.15.0 | ✅ 最新 | — |
| pip | 包管理 | 已安装（早于记录） | 21.2.4 | ⚠️ 偏旧 | 跟随 Python |
| CodeBuddy | AI IDE | 已安装（早于记录） | 2.97.2 | ✅ 正常 | 腾讯出品 |
| CodeBuddy CN | AI IDE | 已安装（早于记录） | — | ✅ 正常 | 国内版 |
| ZCode | AI IDE | 2026-06 中旬开始使用 | — | ✅ 正常 | 智谱，当前主力 |
| Codex | AI IDE | 2026-06 中旬开始使用 | — | ✅ 正常 | OpenAI |
| MiniMax Code | AI IDE | 已安装（早于记录） | — | ✅ 正常 | MiniMax |
| CodeBuddy CLI | AI CLI 助手 | 2026-06 初开始使用 | 2.97.2 | ✅ 已装 | `/Users/bruce/.npm-global/bin/codebuddy` |
| Claude Code CLI | AI CLI 助手 | 已安装（早于记录） | 2.1.145 | ✅ 已装 | `@anthropic-ai/claude-code` |
| Agent Browser | 浏览器自动化 | 已安装（早于记录） | 0.27.0 | ✅ 已装 | npm 全局包 |
| uv | Python 包管理 | 2026-06-20 | 0.11.23 | ✅ 已装 | `~/.local/bin/uv` |
| VS Code | 代码编辑器 | 2026-06-20 | 1.125.1 | ✅ 已装 | `/Applications/Visual Studio Code.app` |
| LangChain | Agent 框架 | 2026-06-20 | 1.3.10 | ✅ 已装 | Python 3.11 + 清华镜像，`~/agent-practice/.venv` |
| LangGraph | Agent 编排 | 2026-06-20 | 已装 | ✅ 已装 | Python 3.11 + 清华镜像，`~/agent-practice/.venv` |
| Qwen-Agent | 国产 Agent SDK | 2026-06-20 | 0.0.34 | ✅ 已装 | Python 3.11 + 清华镜像，`~/agent-practice/.venv` |
| Dify | Agent 平台 | ❌ 未安装 | — | ⏸️ 暂缓 | Docker 镜像拉不下来（需梯子） |
| Milvus | 向量数据库 | ❌ 未安装 | — | 待安装 | Docker 部署 |
| Coze（扣子） | 零代码 Agent | ❌ 未安装 | — | 在线使用 | 字节出品 |

---

## 按类型分类

### 开发语言与运行时
- Python 3.9.6（建议升级）
- Node.js 24.15.0

### 包管理
- pip 21.2.4（Python）
- uv（待安装）

### 版本控制
- Git 2.50.1

### 容器化
- Docker 29.4.3

### AI IDE 与编辑器
- CodeBuddy 2.97.2
- CodeBuddy CN — `/Applications/CodeBuddy CN.app`
- ZCode — `/Applications/ZCode.app`（智谱）
- Codex — `/Applications/Codex.app`（OpenAI）
- MiniMax Code — `/Applications/MiniMax Code.app`
- VS Code（待安装）

### AI 编程助手（CLI / 远程控制）
- CodeBuddy CLI — 已安装（`/Users/bruce/.npm-global/bin/codebuddy`）
- Claude Code CLI — 已安装（`@anthropic-ai/claude-code@2.1.145`）
- Agent Browser — 已安装（`agent-browser@0.27.0`）

### Agent 框架与 SDK
- LangChain（待安装）
- LangGraph（待安装）
- Qwen-Agent（待安装）

### Agent 平台
- Coze（在线使用）
- Dify（待本地部署）

### 向量数据库
- Milvus（待安装）

---

## 检查日志

### 2026-06-20
- **操作**：首次创建清单
- **检查方法**：终端命令检查版本
- **结果**：
  - 已装：Python 3.9.6、Git 2.50.1、Docker 29.4.3、Node.js 24.15.0、pip 21.2.4、CodeBuddy 2.97.2、CodeBuddy CLI
  - 在线使用：ZCode（智谱）、Codex（智谱）、Coze（字节）
  - 未装：uv、VS Code、LangChain、LangGraph、Qwen-Agent、Dify、Milvus

### 2026-06-20（补充）
- **操作**：补充 ZCode、Codex、CodeBuddy CLI 到清单
- **说明**：这些工具在线/远程使用，无本地版本号，按使用记录归档

### 2026-06-20（安装）
- **操作**：开始安装 Agent 学习环境
- **结果**：
  - ❌ Python 3.11（brew 多次超时，跳过，改用系统 Python 3.9.6）
  - ✅ uv 0.11.23（官方脚本安装）
  - ✅ VS Code 1.125.1（brew cask）
  - ✅ LangChain + LangGraph（清华镜像）
  - ✅ Qwen-Agent 0.0.34（清华镜像）
- **环境**：`~/agent-practice/.venv`（uv 虚拟环境）
- **备注**：pip 默认源超时，已切换清华镜像源

### 2026-06-20（Python 3.11 补装）
- **操作**：用 uv 安装 Python 3.11
- **结果**：
  - ❌ brew install pyenv（编译 openssl 太慢超时）
  - ✅ uv python install 3.11 → Python 3.11.15
  - ✅ 用 3.11 重建虚拟环境 `~/agent-practice/.venv`
  - ✅ 重装 LangChain 1.3.10 + LangGraph + Qwen-Agent 0.0.34
  - ✅ 补装依赖：numpy、soundfile、python-dateutil、pandas
  - ✅ 全部验证通过

### 2026-06-21（Dify 部署尝试）
- **操作**：本地部署 Dify
- **结果**：
  - ✅ Docker Desktop 启动正常
  - ✅ GitCode 镜像克隆 Dify 源码（178M）
  - ✅ 复制 .env.example 到 .env
  - ✅ 配置 Docker 镜像加速（USTC/网易/百度）
  - ❌ docker pull langgenius/dify-api 超时失败
  - ❌ DNS 解析失败（docker.mirrors.ustc.edu.cn 无法访问）
- **结论**：国内访问 Docker Hub 受限，需梯子
- **后续**：暂缓 Dify 部署，先用 Coze 云平台

---

## 后续规则

每次执行安装/更新操作前：
1. **检查此清单**：是否已存在
2. **不存在**：补充条目，记录安装时间和版本
3. **已存在且需更新**：更新版本号，记录更新时间
4. **删除软件**：标记移除