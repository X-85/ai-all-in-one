---
name: git-knowledge-sync
description: AI 知识库的 Git 同步和提交流程。当用户主动要求提交、推送、同步 ai-all-in-one 知识库，或提到"提交知识库"、"git push"、"推送到 GitHub"等关键词时触发。也支持通过斜杠命令 /git-knowledge-sync 调用。此 skill 不会自动检测文件变更，必须由用户主动触发。执行流程：拉取远程代码、处理冲突、分析变更、生成符合 Conventional Commits 格式的中文提交信息并推送到 GitHub。跨平台版本，支持 Windows / macOS / Linux。
---

# Git Knowledge Sync（跨平台版）

AI 知识库的 Git 同步和提交流程，专门针对 `ai-all-in-one` 仓库。**支持 Windows / macOS / Linux**。

## 触发条件

只在以下情况触发：
- 用户主动说："提交"、"提交知识库"、"git push"、"推送到 GitHub"、"同步一下"、"把代码 push 上去" 等
- 用户调用斜杠命令：`/git-knowledge-sync`

**不会**自动检测文件变更而触发。所有提交都必须由用户主动发起。

## 路径处理（跨平台兼容）

**核心原则：skill 中不写死绝对路径**，统一通过 `git rev-parse` 自动定位仓库根目录。

```bash
# bash / zsh（macOS、Linux）
cd "$(git rev-parse --show-toplevel)"

# PowerShell（Windows）
Set-Location (git rev-parse --show-toplevel)
```

如果当前目录不在 git 仓库中：
```bash
# 优先使用环境变量，否则用当前工作目录
REPO_DIR="${KNOWLEDGE_REPO:-$(pwd)}"
cd "$REPO_DIR"
```

Windows 下：
```powershell
$repoDir = $env:KNOWLEDGE_REPO ?? $PWD
Set-Location $repoDir
```

## 工作流程

按顺序执行以下步骤：

### Step 1：进入仓库目录并检查状态

```bash
cd "$(git rev-parse --show-toplevel)" 2>/dev/null || {
  echo "❌ 当前目录不在 git 仓库内"
  exit 1
}
git status
```

**判断：**
- 如果 working tree clean（无变更），提示用户"没有需要提交的修改"，结束流程。
- 如果有变更（untracked files / modified files），继续下一步。

### Step 2：拉取远程最新代码

```bash
git fetch origin
git pull --rebase origin main
```

**判断：**
- 如果 rebase 成功（无冲突），继续 Step 3。
- 如果 rebase 失败（有冲突），执行强制同步：

```bash
git fetch origin
git reset --hard origin/main
```

然后**提示用户**："检测到本地与远程有冲突，本地未推送的修改已被丢弃。需要重新编辑要提交的内容。"

让用户重新编辑后，再次 `git status` 检查，直到有变更要提交。

### Step 3：分析变更内容

执行以下命令查看具体变更：

```bash
git status --short
git diff --stat HEAD
git diff HEAD
```

**读取变更内容**，理解：
- 哪些文件被修改/新增/删除
- 修改了什么内容
- 变更的"主题"是什么（是新增文档、修改文档、还是修复问题）

### Step 4：生成提交信息

根据变更内容，生成**中文 + Conventional Commits 格式**的提交信息。

**格式规范：**
```
<类型>(<范围>): <简短描述>
```

**常用类型：**

| 类型 | 含义 | 适用场景 |
|------|------|---------|
| `docs` | 文档变更 | knowledge/ 下的 md 文件变更 |
| `feat` | 新功能 | 新增项目、工具、配置 |
| `fix` | 修复 | 修复错误、链接、配置问题 |
| `chore` | 杂项 | .gitignore、目录结构等 |
| `refactor` | 重构 | 重组文档、调整结构 |
| `style` | 样式 | docsify 主题、格式调整 |

**常用范围（可选）：**

| 范围 | 含义 |
|------|------|
| `knowledge` | 知识库目录 |
| `projects` | 项目目录（未来的） |
| `docs` | 文档网站配置（index.html、_sidebar.md 等） |
| 省略 | 跨多个目录的通用变更 |

**要求：**
- **中文描述**
- **精简**：一两句话说清楚改了什么
- **覆盖所有变更**：如果有多个不同主题的变更，列出主要项
- **不加句号**
- **不超过 72 个字符**（commit subject 的最佳实践）

**示例：**

```bash
# 单个变更
docs(knowledge): 新增 Git 学习总结文档

# 多个相关变更
docs(knowledge): 更新 agent 和 skills 学习笔记

# 多类型变更
docs: 更新侧边栏并新增多设备同步文档
chore: 初始化 docsify 文档网站配置
```

**特殊情况处理：**
- 如果变更太多太杂，可以分多个 commit 提交（询问用户）
- 如果只是格式调整，用 `style`
- 如果是新建目录或文件，用 `chore` 或 `feat`

### Step 5：执行提交

**单次提交：**

```bash
git add .
git commit -m "生成的提交信息"
```

**多次提交（如果用户要求）：**

按主题分组，分别 `git add <files>` + `git commit -m "..."`。

### Step 6：推送到 GitHub

```bash
git push origin main
```

**如果推送失败：**

1. **网络问题（macOS 常见）**：用 HTTP/1.1 重试
   ```bash
   git -c http.version=HTTP/1.1 push origin main
   ```
2. **认证问题**：
   - macOS 首次推送会弹出凭据框，输入 GitHub 用户名 + Personal Access Token
   - 或提前配置：`git config --global credential.helper osxkeychain`
   - Windows SSH 推送失败：检查 `~/.ssh/config` 和 `ssh-add -l`
3. **非快进**：可能远程有新提交，重新执行 Step 2 的拉取流程

### Step 7：反馈结果

告诉用户：
- 提交是否成功
- commit hash（短格式）
- 推送到了哪个分支
- 涉及哪些文件（简要列表）

```
✅ 提交成功！
- Commit: a1b2c3d
- 分支: main
- 变更: 2 个文件（新增 1，修改 1）
- 提交信息: docs(knowledge): 新增 Git 学习总结文档
```

## 重要原则

1. **绝不自动触发**：用户没说要提交，就不要提交
2. **优先使用 rebase**：冲突时才用 reset --hard（确保安全）
3. **提交前要分析变更**：不要直接用 `git add .` 然后写个空泛的提交信息
4. **commit message 要有意义**：未来回看时要能一眼看懂改了什么
5. **推送失败要诚实**：不要假装成功，让用户知道出了什么问题
6. **路径自适应**：用 `git rev-parse` 而非硬编码绝对路径

## 仓库信息

- **本地路径**：通过 `git rev-parse --show-toplevel` 自动获取，或环境变量 `KNOWLEDGE_REPO`
- **远程地址**：`https://github.com/X-85/ai-all-in-one.git`（HTTPS + PAT，跨平台通用）
- **主分支**：`main`
- **认证方式**：HTTPS + Personal Access Token（Windows、macOS、Linux 都支持）

## 常用命令速查

| 命令 | 用途 |
|------|------|
| `git rev-parse --show-toplevel` | 获取 git 仓库根目录 |
| `git status` | 查看仓库状态 |
| `git status --short` | 简洁查看 |
| `git diff --stat HEAD` | 查看变更统计 |
| `git diff HEAD` | 查看具体变更 |
| `git fetch origin` | 获取远程更新 |
| `git pull --rebase origin main` | 拉取并 rebase |
| `git reset --hard origin/main` | 强制同步远程 |
| `git log --oneline -5` | 查看最近 5 次提交 |
| `git remote -v` | 查看远程地址 |
| `git -c http.version=HTTP/1.1 push origin main` | HTTP/2 不稳定时降级为 HTTP/1.1 |

## 错误处理

### 情况 1：网络超时 / HTTP/2 framing layer 错误（macOS 常见）
- 重试一次，仍然失败则用 `git -c http.version=HTTP/1.1` 重新执行对应命令
- 如果还失败，告诉用户可能是网络问题，建议稍后再试或检查代理

### 情况 2：rebase 冲突
- 自动转为 `reset --hard origin/main`
- 提示用户本地修改已丢失，需要重新编辑

### 情况 3：推送失败（非快进）
- 说明远程可能有新提交
- 重新执行 Step 2 的拉取流程
- 然后再推送

### 情况 4：认证失败
- **macOS**：提示用户在弹窗中输入 GitHub 用户名和 Personal Access Token；或配置 `git config --global credential.helper osxkeychain`
- **Linux**：配置 `git config --global credential.helper cache`（临时 1 小时）或 `store`（永久、明文）；生产环境推荐用 SSH
- **Windows**：检查 `~/.ssh/id_ed25519` 是否存在并已添加到 GitHub；或使用 `git credential-manager` 弹窗输入 PAT

### 情况 5：xcode-select / xcrun 缺失（macOS）
- 提示用户安装 Xcode Command Line Tools：`xcode-select --install`
- 某些 Git 操作（特别是 HTTPS clone）依赖 CLT 中的 `git` 和 `curl`

### 情况 6：用户没在仓库目录
- 自动 `cd "$(git rev-parse --show-toplevel)"`
- 如果还是找不到，使用环境变量 `$KNOWLEDGE_REPO` 或当前工作目录
- 如果目录不存在，提示用户检查路径

## 安装方式（一行命令）

### macOS / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/install.ps1 | iex
```

> 安装脚本会遍历 `zcode/` 下所有 skill，按每个 skill 的 `.scope` 文件（`project` / `user`）自动决定安装位置。
