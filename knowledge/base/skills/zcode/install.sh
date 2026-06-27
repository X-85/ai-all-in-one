#!/usr/bin/env bash
# zcode skills 一键安装脚本（macOS / Linux）
# 自动从 GitHub 拉取最新 skill，遍历 zcode/ 下所有 skill 目录，
# 按 .scope 文件（project / user）决定安装位置。
#
# 一键安装：
#   curl -fsSL https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/install.sh | bash
#
# 环境变量：
#   ZCODE_PROJECT_ROOT  强制指定项目根（默认用 git rev-parse 自动定位）
#   ZCODE_DRY_RUN=1     只打印不实际写入

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
REPO_URL="https://github.com/X-85/ai-all-in-one.git"
BRANCH="main"
PLUGIN_VERSION="0.1.0"
DRY_RUN="${ZCODE_DRY_RUN:-0}"

# 1. 优先从 GitHub 拉取最新 skill；失败则用本地
TEMP_DIR=$(mktemp -d)
echo "📥 正在从 GitHub 拉取最新 skill..."
if git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
    SKILLS_ROOT="$TEMP_DIR/knowledge/base/skills/zcode"
    echo "✅ 已从 GitHub 拉取"
else
    echo "⚠️  GitHub 拉取失败，使用本地 skill"
    SKILLS_ROOT="$SCRIPT_DIR"
fi

# 2. 定位项目根（用于 project scope）
if [ -n "${ZCODE_PROJECT_ROOT:-}" ]; then
    PROJECT_ROOT="$ZCODE_PROJECT_ROOT"
elif command -v git >/dev/null 2>&1; then
    PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
else
    PROJECT_ROOT=""
fi

# 3. 遍历每个 skill 目录
INSTALLED=0
SKIPPED=0
for skill_dir in "$SKILLS_ROOT"/*/; do
    [ -f "$skill_dir/SKILL.md" ] || continue
    skill_name=$(basename "$skill_dir")

    # 读 .scope
    if [ -f "$skill_dir/.scope" ]; then
        scope=$(tr -d '[:space:]' < "$skill_dir/.scope")
    else
        scope="user"
    fi

    case "$scope" in
        project)
            if [ -z "$PROJECT_ROOT" ]; then
                echo "  ⚠️  $skill_name: scope=project 但不在 git 仓库中（设 ZCODE_PROJECT_ROOT 覆盖），跳过"
                SKIPPED=$((SKIPPED + 1))
                continue
            fi
            target="$PROJECT_ROOT/.agents/skills/$skill_name"
            if [ "$DRY_RUN" = "1" ]; then
                echo "  🔍 $skill_name → [project] $target/SKILL.md (dry-run)"
            else
                mkdir -p "$target"
                cp "$skill_dir/SKILL.md" "$target/SKILL.md"
                echo "  ✅ $skill_name → [project] $target"
            fi
            ;;
        user)
            target="$HOME/.zcode/cli/plugins/cache/zcode-plugins-official/$skill_name/$PLUGIN_VERSION/skills/$skill_name"
            if [ "$DRY_RUN" = "1" ]; then
                echo "  🔍 $skill_name → [user] $target/SKILL.md (dry-run)"
            else
                mkdir -p "$target"
                cp "$skill_dir/SKILL.md" "$target/SKILL.md"
                echo "  ✅ $skill_name → [user] $target"
            fi
            ;;
        *)
            echo "  ❌ $skill_name: 未知 scope '$scope'，跳过"
            SKIPPED=$((SKIPPED + 1))
            continue
            ;;
    esac
    INSTALLED=$((INSTALLED + 1))
done

# 4. 清理临时目录
rm -rf "$TEMP_DIR" 2>/dev/null || true

echo ""
echo "================================================"
echo "✅ 共安装 $INSTALLED 个 skill（跳过 $SKIPPED 个）"
echo "👉 请重启 zcode 使新 skill 生效"
echo "   在 zcode 中输入 /<skill-name> 即可触发"
echo "================================================"
