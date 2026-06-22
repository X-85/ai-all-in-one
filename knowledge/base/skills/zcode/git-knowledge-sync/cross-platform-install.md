# ZCode Skill 跨平台同步与安装方案

> 本文是 `git-knowledge-sync` skill 的配套设计文档，介绍如何把 Windows 上的 ZCode skill 同步到 macOS，并通过 GitHub 实现**一行命令自动适配系统**的安装方案。

---

## 1. 方案概览

**核心思路：**

1. **把 skill 源码放进 GitHub 仓库**（与知识库一起）→ 一处更新，多机同步
2. **skill 内部不写死绝对路径**，使用 `git rev-parse` 或环境变量自动定位
3. **编写自动安装脚本**，根据当前系统（Windows / macOS / Linux）选择对应的 `SKILL.md.<os>` 文件并部署到 `~/.zcode/cli/plugins/cache/...`

最终效果：**任何电脑上执行一行命令即可安装最新 skill，自动适配系统**。

---

## 2. 仓库目录约定

在 `ai-all-in-one/knowledge` 仓库下，每个 skill 统一目录结构：

```
knowledge/
└── base/
    └── skills/
        └── zcode/
            └── <skill-name>/
                ├── SKILL.md              # 跨平台通用版（默认）
                ├── SKILL.md.macos        # macOS 专属覆盖（可选）
                ├── SKILL.md.windows      # Windows 专属覆盖（可选）
                ├── SKILL.md.linux        # Linux 专属覆盖（可选）
                ├── install.sh            # macOS / Linux 安装脚本
                ├── install.ps1           # Windows 安装脚本
                ├── plugin.json           # 插件 manifest
                ├── package.json          # 包信息
                └── README.md             # skill 说明
```

**优先级**：`<os>.md` > `SKILL.md`（安装脚本会按系统选择）

---

## 3. 跨平台 SKILL.md 写法

### 3.1 不写死绝对路径

❌ 错误写法（仅 Windows 可用）：
```bash
cd D:\personal\XProject\ai-all-in-one
```

✅ 正确写法（跨平台）：

**方式 A：使用 `git rev-parse` 自动发现仓库根**
```bash
cd "$(git rev-parse --show-toplevel)" 2>/dev/null || {
  echo "❌ 当前目录不在 git 仓库内"
  exit 1
}
```

**方式 B：使用环境变量 + 默认值**
```bash
# bash / zsh
REPO_DIR="${KNOWLEDGE_REPO:-$HOME/ai-all-in-one/knowledge}"
cd "$REPO_DIR"

# PowerShell
$repoDir = $env:KNOWLEDGE_REPO ?? "$HOME\ai-all-in-one\knowledge"
Set-Location $repoDir
```

### 3.2 路径分隔符兼容

| 用途 | Windows | macOS / Linux |
|------|---------|---------------|
| 路径分隔符 | `\` | `/` |
| 用户主目录 | `%USERPROFILE%` / `$env:USERPROFILE` | `$HOME` / `~` |
| 换行符 | `\r\n` | `\n` |
| 凭据存储 | Git Credential Manager | `osxkeychain` / `store` |

**推荐使用 Git 命令 + `git rev-parse`，避免直接拼接路径。**

### 3.3 认证方式兼容

skill 中不要写死 `git@github.com:...` 或 `https://...`，让用户本地配置：

```bash
# macOS 推荐
git remote set-url origin https://github.com/X-85/ai-all-in-one.git

# 让 git 记住 token
git config --global credential.helper osxkeychain

# 首次 push 时输入用户名 + PAT
```

---

## 4. 安装脚本设计

### 4.1 macOS / Linux 安装脚本 `install.sh`

```bash
#!/usr/bin/env bash
set -e

SKILL_NAME="git-knowledge-sync"
REPO_URL="https://github.com/X-85/ai-all-in-one.git"
TEMP_DIR=$(mktemp -d)
ZCODE_PLUGIN_DIR="$HOME/.zcode/cli/plugins/cache/zcode-plugins-official/$SKILL_NAME/0.1.0"

echo "📥 正在从 GitHub 拉取最新 skill..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1

SKILL_SRC="$TEMP_DIR/knowledge/base/skills/zcode/$SKILL_NAME"
if [ ! -d "$SKILL_SRC" ]; then
  echo "❌ 仓库中未找到 skill: $SKILL_NAME"
  exit 1
fi

# 选择对应平台的 SKILL.md
case "$(uname -s)" in
  Darwin*)  OS_FILE="SKILL.md.macos" ;;
  Linux*)   OS_FILE="SKILL.md.linux"  ;;
  *)        OS_FILE="SKILL.md"        ;;
esac

SKILL_MD_SRC="$SKILL_SRC/SKILL.md"
if [ -f "$SKILL_SRC/$OS_FILE" ]; then
  echo "✅ 使用平台专属文件: $OS_FILE"
  SKILL_MD_SRC="$SKILL_SRC/$OS_FILE"
fi

# 部署到 zcode 插件目录
echo "📦 安装到 $ZCODE_PLUGIN_DIR ..."
mkdir -p "$ZCODE_PLUGIN_DIR/.zcode-plugin"
mkdir -p "$ZCODE_PLUGIN_DIR/skills/$SKILL_NAME"

cp "$SKILL_MD_SRC" "$ZCODE_PLUGIN_DIR/skills/$SKILL_NAME/SKILL.md"
cp "$SKILL_SRC/.zcode-plugin/plugin.json" "$ZCODE_PLUGIN_DIR/.zcode-plugin/plugin.json" 2>/dev/null || true

rm -rf "$TEMP_DIR"

echo "✅ 安装完成！请重启 ZCode 使 skill 生效。"
```

### 4.2 Windows 安装脚本 `install.ps1`

```powershell
$ErrorActionPreference = "Stop"
$SkillName = "git-knowledge-sync"
$RepoUrl   = "https://github.com/X-85/ai-all-in-one.git"
$TempDir   = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
$PluginDir = "$env:USERPROFILE\.zcode\cli\plugins\cache\zcode-plugins-official\$SkillName\0.1.0"

git clone --depth 1 $RepoUrl $TempDir 2>$null | Out-Null
$SkillSrc = Join-Path $TempDir "knowledge\base\skills\zcode\$SkillName"
$SkillMdSrc = Join-Path $SkillSrc "SKILL.md"
$WinSrc     = Join-Path $SkillSrc "SKILL.md.windows"
if (Test-Path $WinSrc) { $SkillMdSrc = $WinSrc }

New-Item -ItemType Directory -Force -Path "$PluginDir\.zcode-plugin" | Out-Null
New-Item -ItemType Directory -Force -Path "$PluginDir\skills\$SkillName" | Out-Null
Copy-Item $SkillMdSrc "$PluginDir\skills\$SkillName\SKILL.md" -Force

Remove-Item -Recurse -Force $TempDir
Write-Host "✅ 安装完成！请重启 ZCode 使 skill 生效。" -ForegroundColor Green
```

---

## 5. 一键安装命令

### macOS / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/git-knowledge-sync/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/git-knowledge-sync/install.ps1 | iex
```

> 把 `git-knowledge-sync` 换成实际 skill 名即可，**任何机器执行一行命令就能装上最新 skill 并自动适配系统**。

---

## 6. 升级流程

1. **任何端**（Windows 或 Mac）修改 `base/skills/zcode/<skill>/` 下的文件
2. `git add .` + `git commit` + `git push origin main`
3. **目标机器**执行上面的一行命令，覆盖安装 → 自动拉取最新代码 → 重启 ZCode

---

## 7. 本次实际操作记录（Windows → macOS）

| 步骤 | 内容 |
|------|------|
| 1 | 拉取 GitHub 最新版本（commit `09dfc10`） |
| 2 | 复制 `base/skills/zcode/git-knowledge-sync/SKILL.md`（Windows 版） |
| 3 | 修改路径：`D:\personal\XProject\ai-all-in-one` → `~/ai-all-in-one/knowledge` |
| 4 | 修改认证方式：SSH → HTTPS + PAT |
| 5 | 补充 macOS 特有错误处理（HTTP/2 framing、osxkeychain） |
| 6 | 安装到 `~/.zcode/cli/plugins/cache/zcode-plugins-official/git-knowledge-sync/0.1.0/` |
| 7 | 创建插件 manifest：`plugin.json` + `package.json` |
| 8 | 创建 data 目录：`~/.zcode/cli/plugins/data/git-knowledge-sync@zcode-plugins-official/` |
| 9 | 补充平台覆盖文件：`SKILL.md.macos` / `SKILL.md.windows` / `SKILL.md.linux` |
| 10 | 编写 `install.sh` / `install.ps1` 一键安装脚本 |
| 11 | 重启 ZCode，验证 `/git-knowledge-sync` 可触发 |

---

## 8. 设计原则总结

1. **源码集中管理**：所有 skill 源码都在 GitHub 仓库 `base/skills/zcode/` 下
2. **平台自动适配**：通过 `SKILL.md.<os>` 覆盖机制 + 安装脚本自动选择
3. **路径自适应**：用 `git rev-parse` 而非硬编码绝对路径
4. **认证统一**：HTTPS + PAT（Windows、macOS、Linux 都支持）
5. **一键安装/升级**：单行命令即可拉取最新代码并部署
6. **可扩展**：新增 skill 时只需复制目录结构，无需修改其他文件

---

## 9. 验收清单

- [x] `base/skills/zcode/git-knowledge-sync/` 下有 `SKILL.md`、`SKILL.md.macos`、`SKILL.md.windows`、`SKILL.md.linux`
- [x] `install.sh` 和 `install.ps1` 一键安装脚本就绪
- [x] `~/.zcode/cli/plugins/cache/zcode-plugins-official/git-knowledge-sync/0.1.0/skills/git-knowledge-sync/SKILL.md` 已部署
- [x] `~/.zcode/cli/plugins/cache/zcode-plugins-official/git-knowledge-sync/0.1.0/.zcode-plugin/plugin.json` 已创建
- [x] `~/.zcode/cli/plugins/data/git-knowledge-sync@zcode-plugins-official/` 目录已创建
- [ ] 重启 ZCode 后，输入 `/git-knowledge-sync` 可触发该 skill
- [ ] 推送测试成功（首次需输入 GitHub PAT）
- [ ] 一行 curl 命令可重新安装（自包含）
