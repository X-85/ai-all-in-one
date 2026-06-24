"""
Auto-generate _sidebar.md from repository filesystem scan + hardcoded rules.

Called by .github/workflows/pages.yml on every push to main.

Design:
  - Hardcoded grouping rules (path-prefix based) keep the navigation predictable.
  - Display aliases map file stems to friendly Chinese titles.
  - Skip files whose name starts with underscore (`_sidebar.md` etc.) or
    files inside `scripts/`.

To add a new section: add a tuple to GROUP_RULES + an alias case in alias_for().
To add a new file: just push a .md under an existing matching path prefix.
"""

from pathlib import Path

REPO_ROOT = Path(".")
SKIP_PARTS = ("scripts", ".git")
SKIP_FILENAME_PREFIXES = ("_",)


# Hardcoded grouping rules.
# Order matters: the first predicate that matches wins.
# Each entry: (section_title, path_predicate)
GROUP_RULES = [
    (
        "入门",
        lambda p: (
            # Only the root README counts as 入门
            p == Path("README.md")
            or p.match("knowledge/base/pwd.md")
        ),
    ),
    (
        "Skills",
        lambda p: (
            p.match(".agents/skills/*/SKILL.md")
            or p.match("knowledge/base/skills/zcode/*/*.md")
        ),
    ),
    (
        "Git 学习",
        lambda p: (
            p.match("knowledge/temp/git-learn.md")
            or p.match("knowledge/temp/github-multi-device-sync.md")
            or p.match("knowledge/temp/ssh-test.md")
        ),
    ),
    (
        "AI 概念",
        lambda p: (
            p.match("knowledge/temp/agent-understanding.md")
            or p.match("knowledge/temp/claude-agent-official-zh.md")
            or p.match("knowledge/temp/claude-skills-official-zh.md")
            or p.match("knowledge/temp/claude-subagent-official-zh.md")
            or p.match("knowledge/temp/skills-learning.md")
            or p.match("knowledge/temp/llm-timeline.md")
        ),
    ),
    (
        "Codex",
        lambda p: p.match("knowledge/temp/codex-glossary.md")
        or p.match("knowledge/temp/codexShare.md"),
    ),
    (
        "杂项",
        lambda p: (
            p.match("knowledge/temp/my-ai-usage.md")
            or p.match("knowledge/temp/softlist.md")
        ),
    ),
]


def alias_for(rel: Path) -> str:
    """Return the friendly display name for a sidebar entry."""
    name = rel.stem
    parent = rel.parent.name

    # README at repo root
    if rel == Path("README.md"):
        return "关于本知识库"
    # knowledge/base/skills/zcode/git-knowledge-sync/README.md
    if rel.match("knowledge/base/skills/zcode/*/README.md"):
        return f"{parent} (规范版 README)"
    # knowledge/base/pwd.md
    if name == "pwd":
        return "环境配置"

    # SKILL.md under .agents/skills/<name>/ -> "<name> (本地版)"
    # Only skills whose canonical form is NOT under knowledge/base/skills/zcode/ count as 本地版.
    # git-knowledge-sync exists in both locations and represents the same content,
    # so label it (规范版) instead of (本地版).
    if name == "SKILL" and rel.match(".agents/skills/*/SKILL.md"):
        if parent == "git-knowledge-sync":
            return "git-knowledge-sync (本地版, 与规范版同步)"
        return f"{parent} (本地版)"

    # knowledge/base/skills/zcode/git-knowledge-sync/*.md
    if rel.match("knowledge/base/skills/zcode/git-knowledge-sync/README.md"):
        return "git-knowledge-sync (规范版)"
    if rel.match("knowledge/base/skills/zcode/git-knowledge-sync/SKILL.md"):
        return "git-knowledge-sync SKILL.md"
    if rel.match("knowledge/base/skills/zcode/git-knowledge-sync/cross-platform-install.md"):
        return "跨平台安装指南"

    # knowledge/temp/*.md
    aliases = {
        "agent-understanding": "Agent 理解",
        "claude-agent-official-zh": "Claude Agent 官方指南",
        "claude-skills-official-zh": "Claude Skills 官方指南",
        "claude-subagent-official-zh": "Claude SubAgent 官方指南",
        "skills-learning": "Skills 学习笔记",
        "llm-timeline": "LLM 时间线",
        "codex-glossary": "Codex 术语表",
        "codexShare": "Codex 分享",
        "git-learn": "Git 学习总结",
        "github-multi-device-sync": "多设备 GitHub 同步",
        "ssh-test": "SSH 测试",
        "my-ai-usage": "我的 AI 使用",
        "softlist": "软件列表",
    }
    if name in aliases:
        return aliases[name]

    # Fallback: humanize the filename (replace dashes/underscores)
    return name.replace("-", " ").replace("_", " ")


def is_skippable(rel: Path) -> bool:
    if any(rel.parts[0] == part for part in SKIP_PARTS):
        return True
    if any(rel.name.startswith(prefix) for prefix in SKIP_FILENAME_PREFIXES):
        return True
    return False


def main() -> None:
    md_files = sorted(REPO_ROOT.rglob("*.md"))
    md_files = [p for p in md_files if not is_skippable(p.relative_to(REPO_ROOT))]

    grouped: dict[str, list[tuple[Path, str]]] = {title: [] for title, _ in GROUP_RULES}

    for path in md_files:
        rel = path.relative_to(REPO_ROOT)
        for title, predicate in GROUP_RULES:
            if predicate(rel):
                grouped[title].append((rel, alias_for(rel)))
                break

    # Build markdown
    lines: list[str] = []
    for title, _ in GROUP_RULES:
        if not grouped[title]:
            continue
        lines.append(f"* **{title}**")
        # Sort entries alphabetically by display alias within each section
        for rel, alias in sorted(grouped[title], key=lambda t: t[1]):
            lines.append(f"  * [{alias}]({rel.as_posix()})")
        lines.append("")

    output = "\n".join(lines).rstrip() + "\n"
    Path("_sidebar.md").write_text(output, encoding="utf-8")

    total_entries = sum(len(v) for v in grouped.values())
    print(
        f"OK: wrote _sidebar.md "
        f"({len(output)} bytes, {len(md_files)} scanned, "
        f"{total_entries} entries in {sum(1 for v in grouped.values() if v)} sections)"
    )


if __name__ == "__main__":
    main()
