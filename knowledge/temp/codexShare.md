# CodeX 学习记录

> 本文档用于记录我对 CodeX 的学习过程、笔记和心得体会。

## 基本信息

- **学习日期**: 2026-06-18
- **学习主题**: CodeX 配置 MiniMax 模型

## 学习目标

- 掌握 CodeX 接入第三方模型的方法
- 了解 MiniMax 系列模型的差异

---

## 一、CodeX 接入其他模型的方法

### 1.1 工作原理

```
Codex CLI / Desktop App → 本地代理 (Moon Bridge) → DeepSeek API
                      或
Codex → MiniMax API (直接接入)
```

Codex 支持通过配置文件接入其他 AI 模型提供商，无需依赖 OpenAI。

### 1.2 配置文件位置

```
~/.codex/config.toml
```

### 1.3 配置格式 (TOML)

```toml
model = "MiniMax-M3"
model_provider = "minimax"
model_context_window = 512000

[model_providers.minimax]
name = "MiniMax"
base_url = "https://api.minimaxi.com/v1"
experimental_bearer_token = "<你的API_KEY>"
wire_api = "responses"
```

### 1.4 模型目录配置（可选）

如需在 Codex 模型选择器中显示多个模型，可创建模型目录 JSON：

```json
// ~/.codex/model-catalogs/minimax-models.json
{
  "version": 1,
  "models": [
    {
      "name": "MiniMax-M3",
      "model_provider": "minimax",
      "description": "最新多模态模型，支持长上下文和推理",
      "context_window": 1000000,
      "supported_features": ["chat", "thinking", "vision", "tools"]
    },
    {
      "name": "MiniMax-M2.7",
      "model_provider": "minimax",
      "description": "高速多模态模型",
      "context_window": 1000000,
      "supported_features": ["chat", "thinking", "vision", "tools"]
    },
    {
      "name": "MiniMax-M2.7-highspeed",
      "model_provider": "minimax",
      "description": "M2.7 极速版，低延迟响应",
      "context_window": 1000000,
      "supported_features": ["chat", "thinking", "vision", "tools"]
    }
  ]
}
```

---

## 二、MiniMax 系列模型对比

### 2.1 模型列表

| 模型 | 上下文 | 特点 |
|------|--------|------|
| MiniMax-M3 | 1M | 最新 Agentic 前沿模型，原生多模态 |
| MiniMax-M2.7 | 1M | 高速版，支持深度推理 |
| MiniMax-M2.7-highspeed | 1M | 极速版，与 M2.7 效果一致，速度大幅提升 |
| MiniMax-M2.5 | 256K | 标准版，支持工具调用 |

### 2.2 M3 更新内容

**核心升级：**
- **MSA 架构**：全新稀疏注意力机制（MiniMax Sparse Attention）
- **1M 超长上下文**：支持 100 万 token
- **原生多模态**：从训练初期就混合多模态数据

**新增能力：**
- **Agentic 能力**：优秀的工具使用（Tool Use）能力
- **交错思维链**：支持 Interleaved Thinking，处理复杂任务推理能力更强
- **M3 Thinking**：独特的推理控制能力

**性能表现：**
- 在 IMO 2025 和 USAMO 2026 国际数学竞赛真题上超过人类金牌线

### 2.3 M2.7 vs M2.7-highspeed

| 特性 | M2.7 | M2.7-highspeed |
|------|------|-----------------|
| 效果 | 标准效果 | 与 M2.7 效果**完全一致** |
| 速度 | 标准速度 | **大幅提升** |
| 适用 | 复杂推理任务 | 需要快速交互的场景 |

---

## 三、已完成的配置

### 3.1 配置文件

**路径**: `~/.codex/config.toml`

**内容**:
```toml
model = "MiniMax-M3"
model_provider = "minimax"
model_context_window = 512000

[model_providers.minimax]
name = "MiniMax"
base_url = "https://api.minimaxi.com/v1"
experimental_bearer_token = "sk-cp-Hzj52xetE3ZxeX0awzdQUsTOSX7vX0cs-..."
wire_api = "responses"
```

**API Key 来源**: MiniMax Coding Plan 订阅 Key

### 3.2 模型目录

**路径**: `~/.codex/model-catalogs/minimax-models.json`

已配置 M3、M2.7、M2.7-highspeed 三个模型

### 3.3 使用方法

1. 重启 Codex Desktop App
2. 在模型选择器中选择 MiniMax-M3 / M2.7 / M2.7-highspeed
3. 或在对话中输入 `/model MiniMax-M2.7` 切换模型

---

## 四、相关资源

- MiniMax 开放平台: https://platform.minimaxi.com
- MiniMax Code 下载: https://code.minimaxi.com
- DeepSeek API: https://platform.deepseek.com

---

*最后更新: 2026-06-18*
