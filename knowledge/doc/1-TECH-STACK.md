# 技术栈梳理

> 来源:`/Users/bruce/ai-all-in-one/knowledge` 目录下的真实记录(`base/`、`temp/`)。
> 所有条目均标注了出处文件与行号。
> 梳理日期:2026-06-25

---

## 1. 编程语言

| 语言 | 状态 | 引用 |
|------|------|------|
| **Python 3.9.6** | 系统默认 | `temp/softlist.md:23` |
| **Python 3.11.15** | uv 安装,Agent 框架环境 | `temp/softlist.md:24` |
| **Bash / zsh** | macOS 默认 shell,`install.sh` | `temp/softlist.md:14` |
| **PowerShell** | Windows 安装脚本 | `base/skills/.../SKILL.md:26,38` |
| **Node.js 24.15.0** | 全局 npm 包 | `temp/softlist.md:27,52` |
| **TOML** | Codex 配置文件 | `temp/codexShare.md:32-47` |
| **YAML** | Skill / Sub-Agent frontmatter | `temp/claude-subagent-official-zh.md:94-174` |
| **JSON / JSON5** | 清单与模型目录 | `plugin.json`、`model-catalogs` |
| **Markdown** | 知识库主体语言 | 全部 `.md` |

---

## 2. Agent / LLM 编排框架

| 框架 | 状态 | 引用 |
|------|------|------|
| **LangChain 1.3.10** | ✅ 已装 | `temp/softlist.md:39`;`temp/agent-understanding.md:25,69,86,111` |
| **LangGraph** | ✅ 已装 | `temp/softlist.md:40`;`temp/agent-understanding.md:25,69,87,122` |
| **Qwen-Agent 0.0.34** | ✅ 已装 | `temp/softlist.md:41` |
| **Claude Agent SDK** | 📚 学习目标 | `temp/agent-understanding.md:21,24,42,88,114,130` |
| **Strands Agents SDK (AWS)** | 📚 学习目标 | `temp/agent-understanding.md:25,69,87` |
| **LlamaIndex** | 📚 学习目标(RAG) | `temp/agent-understanding.md:88,113` |
| **CrewAI** | 📚 学习目标(多 Agent) | `temp/agent-understanding.md:89,126` |
| **AutoGen** | 📚 学习目标 | `temp/agent-understanding.md:25,89,126` |
| **OpenAI Assistants API** | 📚 学习目标 | `temp/agent-understanding.md:70` |
| **Rivet** | 📚 GUI 工作流 | `temp/claude-agent-official-zh.md:158` |
| **Vellum** | 📚 GUI 工作流 | `temp/claude-agent-official-zh.md:159` |

---

## 3. AI IDE / 编程助手

| 工具 | 说明 | 引用 |
|------|------|------|
| **ZCode** | 智谱,当前主力 | `temp/softlist.md:31`;`temp/my-ai-usage.md:42-44` |
| **Codex (OpenAI)** | 桌面 + CLI | `temp/codexShare.md` 全文;`temp/codex-glossary.md` 全文 |
| **CodeBuddy / CodeBuddy CN** | 腾讯 AI IDE | `temp/softlist.md:29,30,34` |
| **CodeBuddy CLI 2.97.2** | npm 全局包 | `temp/softlist.md:34,74` |
| **Claude Code CLI 2.1.145** | `@anthropic-ai/claude-code` | `temp/softlist.md:35,74` |
| **MiniMax Code** | MiniMax 出品 | `temp/softlist.md:33` |
| **KiloCode** | 2025.11-2026.5 编程主力 | `temp/my-ai-usage.md:27,57` |
| **Cursor** | 辅助使用 | `temp/my-ai-usage.md:28` |
| **Agent Browser 0.27.0** | 浏览器自动化 | `temp/softlist.md:36,75` |
| **慧码 / 华言** | 公司内部工具(2025 中-11 月主力) | `temp/my-ai-usage.md:24,56` |

---

## 4. 工具链与开发工具

### 4.1 包管理 / 运行时

| 工具 | 版本 | 引用 |
|------|------|------|
| **uv** | 0.11.23,`~/.local/bin/uv` | `temp/softlist.md:24,37,56,109,117` |
| **pip** | 21.2.4 | `temp/softlist.md:28,55` |
| **npm** | 全局 `~/.npm-global/bin` | `temp/softlist.md:34` |
| **brew / Homebrew** | macOS 包管理 | `temp/softlist.md:108,119` |
| **pyenv** | ❌ 安装失败(编译 openssl 超时) | `temp/softlist.md:119` |

### 4.2 容器化

| 工具 | 状态 | 引用 |
|------|------|------|
| **Docker 29.4.3** | 已装,镜像拉取受限 | `temp/softlist.md:26,62` |
| **Docker Desktop** | 本地运行 | `temp/softlist.md:129` |
| **Kubernetes** | 📚 学习目标 | `temp/agent-understanding.md:99` |

### 4.3 镜像源

| 源 | 用途 | 引用 |
|----|------|------|
| 清华镜像 | pip 装 LangChain / LangGraph / Qwen-Agent | `temp/softlist.md:39-42,108,114,122` |
| USTC / 网易 / 百度 | Docker 加速(均失败) | `temp/softlist.md:132` |
| GitCode 镜像 | Dify 源码克隆 | `temp/softlist.md:130` |

### 4.4 编辑器

| 工具 | 路径 | 引用 |
|------|------|------|
| **VS Code 1.125.1** | `/Applications/Visual Studio Code.app` | `temp/softlist.md:38,70` |
| **ZCode.app** | `/Applications/ZCode.app` | `temp/softlist.md:67` |
| **CodeBuddy CN.app** | `/Applications/CodeBuddy CN.app` | `temp/softlist.md:66` |
| **Codex.app** | `/Applications/Codex.app` | `temp/softlist.md:68` |
| **MiniMax Code.app** | `/Applications/MiniMax Code.app` | `temp/softlist.md:69` |

---

## 5. 平台与服务

### 5.1 Git / 代码托管

- **GitHub** 仓库 `X-85/ai-all-in-one.git`,主分支 `main`(`base/skills/.../README.md:61`)
- **GitHub Pages** + docsify 静态站点,`x-85.github.io/ai-all-in-one/`(`temp/github-multi-device-sync.md:9,64-71`)
- **GitHub Actions** Pages 部署 workflow,`.github/workflows/pages.yml`(`temp/git-learn.md:215-231`)
- **GitHub PAT** 存 `osxkeychain` / Git Credential Manager / `store`(`temp/git-learn.md:34-39,91-98`)
- **GitHub CLI (`gh`)**(`temp/git-learn.md:132`)

### 5.2 LLM 服务

- **Anthropic Claude**:Sonnet / Opus / Haiku / Fable(`temp/claude-subagent-official-zh.md:49,78,80,131,181`)
- **OpenAI GPT-1/2/3/4/5**,o1 / o3 推理模型(`temp/llm-timeline.md:31-47`)
- **DeepSeek / DeepSeek-R1** `platform.deepseek.com`(`temp/my-ai-usage.md:18`)
- **Qwen / 文心一言 / 智谱 GLM / MiniMax-M3 / M2.7 / M2.7-highspeed / M2.5**(`temp/softlist.md:31,33,68-69`)
- **Kimi / 百川 / 智源悟道·天鹰**(`temp/llm-timeline.md:36,42,45`)
- **Meta LLaMA / LLaMA 2** 开源(`temp/llm-timeline.md:39,41`)
- **Google T5 / BERT**,OpenAI **Sora**(`temp/llm-timeline.md:30,32,44`)

### 5.3 Agent / 低代码平台

| 平台 | 状态 | 引用 |
|------|------|------|
| **Coze(扣子)** | ✅ 在线使用,暂替 Dify | `temp/softlist.md:44,84` |
| **Dify** | ❌ 本地 Docker 部署失败,暂缓 | `temp/softlist.md:42,84,126-136` |

### 5.4 部署 / 基础设施

- **GitHub Pages + docsify** + Fastly CDN 缓存 `max-age=600`(`temp/git-learn.md:238`)
- **FastAPI / Flask** 接口层(学习目标)(`temp/agent-understanding.md:100`)
- **Redis** 缓存 / 会话(学习目标)(`temp/agent-understanding.md:101`)

### 5.5 监控与评估

- **LangSmith / LangFuse**(`temp/agent-understanding.md:104`)

### 5.6 协议 / 标准

- **MCP (Model Context Protocol)** Anthropic 工具接入(`temp/agent-understanding.md:92,114`)
- **Function Calling / Tool Use**(`temp/agent-understanding.md:93,120`)
- **SSH ed25519** + **HTTPS + PAT** 双认证(`temp/git-learn.md:42-70,142-149`)
- **Conventional Commits**(`docs:`、`feat:`、`fix:`、`chore:`、`refactor:`、`style:`)(`base/skills/.../SKILL.md:101-114`)

---

## 6. 向量数据库 / RAG

| 组件 | 状态 | 引用 |
|------|------|------|
| **Milvus** | ⏸ 待装(Docker) | `temp/softlist.md:43,87` |
| **Qdrant** | 📚 学习目标 | `temp/agent-understanding.md:96` |
| **Weaviate** | 📚 学习目标 | `temp/agent-understanding.md:96` |
| **Pinecone** | 📚 学习目标 | `temp/agent-understanding.md:96` |
| **Embedding** | RAG 必需 | `temp/agent-understanding.md:113` |

---

## 7. Python 配套依赖

来源 `temp/softlist.md:123`:

- `numpy`
- `soundfile`
- `python-dateutil`
- `pandas`

---

## 8. 关键技术配置

| 配置 | 路径 |
|------|------|
| Codex 配置 | `~/.codex/config.toml` |
| 模型目录 | `~/.codex/model-catalogs/minimax-models.json` |
| ZCode 插件 | `~/.zcode/cli/plugins/cache/.../git-knowledge-sync/0.1.0/` |
| Claude user-level agents | `~/.claude/agents/` |
| Claude project-level agents | `.claude/agents/` |
| Python 虚拟环境 | `~/agent-practice/.venv` |
| Windows 工作目录 | `D:\personal\XProject\ai-all-in-one` |
| SSH 密钥 | `~/.ssh/id_ed25519` / `.pub` |
| 仓库路径变量 | `KNOWLEDGE_REPO` |

---

## 9. ⚠️ 凭据安全警告

`base/pwd.md` 中记录了一个**已暴露的 GitHub PAT**(`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`)。按照 `temp/git-learn.md:120-134` 的安全提示,token 已处于泄露状态,**应立即在 https://github.com/settings/tokens 删除并轮换**。

`temp/codexShare.md:136` 的 MiniMax key 已被作者用 `...` 截断,处理方式正确。

---

## 10. 暂未安装 / 暂缓的工具

| 工具 | 原因 | 引用 |
|------|------|------|
| Dify | Docker 镜像拉不下来 | `temp/softlist.md:42,84,126-136` |
| Milvus | 依赖 Docker | `temp/softlist.md:43,87` |
| pyenv | 编译 openssl 超时 | `temp/softlist.md:119` |
| brew 装 Python 3.11 | 多次超时,改用 uv | `temp/softlist.md:108` |

---

## 总览画像

这是一个以 **AI Agent 开发** 为主线的个人知识库。技术栈围绕 **Python + LangChain / LangGraph / Qwen-Agent** 展开,搭配 **Claude / Codex / ZCode** 等多 AI IDE 工具链,使用 **docsify + GitHub Pages** 做文档站,辅以 **Docker / K8s / Milvus** 等企业级组件作为后续学习目标。
