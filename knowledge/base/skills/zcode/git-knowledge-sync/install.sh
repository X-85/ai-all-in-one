#!/usr/bin/env bash
# 安装 git-knowledge-sync skill 到当前 macOS / Linux
# 一键安装：
#   curl -fsSL https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/git-knowledge-sync/install.sh | bash
set -e

SKILL_NAME="git-knowledge-sync"
REPO_URL="https://github.com/X-85/ai-all-in-one.git"
BRANCH="main"
TEMP_DIR=$(mktemp -d)
ZCODE_PLUGIN_DIR="$HOME/.zcode/cli/plugins/cache/zcode-plugins-official/$SKILL_NAME/0.1.0"
ZCODE_DATA_DIR="$HOME/.zcode/cli/plugins/data/${SKILL_NAME}@zcode-plugins-official"

echo "📥 正在从 GitHub 拉取最新 skill..."
if ! git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
  echo "❌ 克隆仓库失败，请检查网络"
  exit 1
fi

SKILL_SRC="$TEMP_DIR/knowledge/base/skills/zcode/$SKILL_NAME"
if [ ! -d "$SKILL_SRC" ]; then
  echo "❌ 仓库中未找到 skill: $SKILL_NAME"
  rm -rf "$TEMP_DIR"
  exit 1
fi

# 根据当前系统选择 SKILL.md
case "$(uname -s)" in
  Darwin*)  OS_FILE="SKILL.md.macos" ;;
  Linux*)   OS_FILE="SKILL.md.linux"  ;;
  *)        OS_FILE="SKILL.md"        ;;
esac

SKILL_MD_SRC="$SKILL_SRC/SKILL.md"
if [ -f "$SKILL_SRC/$OS_FILE" ]; then
  echo "✅ 检测到平台 $(uname -s)，使用: $OS_FILE"
  SKILL_MD_SRC="$SKILL_SRC/$OS_FILE"
else
  echo "ℹ️  使用默认 SKILL.md（跨平台版）"
fi

# 部署到 zcode 插件目录
echo "📦 安装到 $ZCODE_PLUGIN_DIR ..."
mkdir -p "$ZCODE_PLUGIN_DIR/.zcode-plugin"
mkdir -p "$ZCODE_PLUGIN_DIR/skills/$SKILL_NAME"
mkdir -p "$ZCODE_DATA_DIR"

cp "$SKILL_MD_SRC" "$ZCODE_PLUGIN_DIR/skills/$SKILL_NAME/SKILL.md"

# plugin.json（如果仓库里有则用，没有则生成）
if [ -f "$SKILL_SRC/.zcode-plugin/plugin.json" ]; then
  cp "$SKILL_SRC/.zcode-plugin/plugin.json" "$ZCODE_PLUGIN_DIR/.zcode-plugin/plugin.json"
else
  cat > "$ZCODE_PLUGIN_DIR/.zcode-plugin/plugin.json" <<EOF
{
  "name": "$SKILL_NAME",
  "version": "0.1.0",
  "description": "AI 知识库的 Git 同步和提交流程（自动安装）。",
  "author": { "name": "Bruce" },
  "license": "MIT",
  "skills": "skills"
}
EOF
fi

# package.json
cat > "$ZCODE_PLUGIN_DIR/package.json" <<EOF
{
  "name": "@bruce/$SKILL_NAME-plugin",
  "version": "0.1.0",
  "private": true,
  "license": "MIT",
  "description": "AI 知识库 Git 同步 skill（$(uname -s) 安装）。"
}
EOF

# 清理
rm -rf "$TEMP_DIR"

echo ""
echo "✅ 安装完成！"
echo "📁 插件目录: $ZCODE_PLUGIN_DIR"
echo ""
echo "👉 请重启 ZCode 使 skill 生效。"
echo "   重启后可通过 /git-knowledge-sync 触发。"
