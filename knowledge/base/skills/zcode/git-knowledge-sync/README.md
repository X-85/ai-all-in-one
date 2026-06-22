# Git Knowledge Sync Skill

AI 知识库（`ai-all-in-one`）的 Git 同步和提交流程，**跨 Windows / macOS / Linux**。

## 一键安装

### macOS / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/git-knowledge-sync/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/X-85/ai-all-in-one/main/knowledge/base/skills/zcode/git-knowledge-sync/install.ps1 | iex
```

安装脚本会自动：
1. 从 GitHub 拉取最新代码
2. 检测当前操作系统
3. 选择对应的 `SKILL.md`（默认 / macOS / Windows / Linux）
4. 部署到 zcode 插件目录
5. 生成 manifest 文件

## 使用

重启 ZCode 后：
- 输入 `/git-knowledge-sync` 调用
- 或在对话中说"提交知识库"、"git push"、"推送到 GitHub" 等

## 目录结构

```
git-knowledge-sync/
├── SKILL.md              # 跨平台默认版（被安装脚本选用）
├── SKILL.md.macos        # macOS 专属覆盖
├── SKILL.md.windows      # Windows 专属覆盖
├── SKILL.md.linux        # Linux 专属覆盖（占位）
├── install.sh            # macOS / Linux 安装脚本
├── install.ps1           # Windows 安装脚本
├── plugin.json           # 插件 manifest
├── package.json          # 包信息
└── README.md             # 本文件
```

## 升级

只需在 Windows 或 Mac 上修改文件并 push，然后到目标机器重新执行一行安装命令即可。

## 跨平台兼容要点

1. **路径**：使用 `git rev-parse --show-toplevel` 自动定位，不写死绝对路径
2. **认证**：统一使用 HTTPS + Personal Access Token（Windows SSH 也能兼容）
3. **凭据存储**：
   - macOS：`osxkeychain`
   - Windows：Git Credential Manager
   - Linux：`store` 或 `cache`

## 仓库信息

- **本地路径**：`~/ai-all-in-one/knowledge`（macOS/Linux）或 `D:\personal\XProject\ai-all-in-one`（Windows）
- **远程地址**：`https://github.com/X-85/ai-all-in-one.git`
- **主分支**：`main`
