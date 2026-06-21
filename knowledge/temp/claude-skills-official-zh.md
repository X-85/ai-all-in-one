# Claude Agent Skills 官方规范（中文版）

> 来源：[Anthropic Skills 仓库](https://github.com/anthropics/skills) 与 [agentskills.io 规范](https://agentskills.io/specification)
> 说明：本文档为 Anthropic 官方 Agent Skills 规范的中文翻译整理

---

## 一、Skills 定义

**官方原文：**

> Skills are folders of instructions, scripts, and resources that Claude loads dynamically to improve performance on specialized tasks. Skills teach Claude how to complete specific tasks in a repeatable way, whether that's creating documents with your company's brand guidelines, analyzing data using your organization's specific workflows, or automating personal tasks.

**中文翻译：**

> Skills 是包含指令、脚本和资源的文件夹，Claude 会**动态加载**它们以提升在特定任务上的表现。Skills 以可重复的方式教会 Claude 如何完成特定任务，例如：
> - 按公司品牌规范创建文档
> - 按组织特定工作流分析数据
> - 自动化个人任务

**关键特性：**
- 一个 Skill 是一个目录
- 至少包含一个 `SKILL.md` 文件
- 支持动态加载（按需激活）

---

## 二、目录结构

```
skill-name/
├── SKILL.md          # 必需：元数据 + 指令
├── scripts/          # 可选：可执行代码
├── references/       # 可选：参考文档
├── assets/           # 可选：模板、资源
└── ...               # 其他任意文件或目录
```

---

## 三、SKILL.md 格式

`SKILL.md` 文件必须包含 **YAML frontmatter**，后跟 Markdown 正文。

### Frontmatter 字段表

| 字段 | 是否必需 | 约束 |
|------|---------|------|
| `name` | 是 | 最多 64 字符。小写字母、数字、连字符。不能以连字符开头或结尾，不能有连续连字符。 |
| `description` | 是 | 最多 1024 字符。描述技能做什么以及何时使用。 |
| `license` | 否 | 许可证名称或对打包许可证文件的引用。 |
| `compatibility` | 否 | 最多 500 字符。环境要求（目标产品、系统包、网络访问等）。 |
| `metadata` | 否 | 用于附加元数据的任意键值映射。 |
| `allowed-tools` | 否 | 技能可使用的预批准工具，空格分隔。（实验性） |

### 最小示例

```markdown
---
name: skill-name
description: A description of what this skill does and when to use it.
---
```

### 带可选字段的示例

```markdown
---
name: pdf-processing
description: Extract PDF text, fill forms, merge files. Use when handling PDFs.
license: Apache-2.0
metadata:
  author: example-org
  version: "1.0"
---
```

---

## 四、字段详细规范

### 4.1 `name` 字段

- 必须为 1-64 个字符
- 只能包含 unicode 小写字母数字字符（`a-z`、`0-9`）和连字符（`-`）
- 不能以连字符（`-`）开头或结尾
- 不能包含连续的连字符（`--`）
- 必须与父目录名称匹配

**有效示例：**
```yaml
name: pdf-processing
name: data-analysis
name: code-review
```

**无效示例：**
```yaml
name: PDF-Processing      # 不允许大写
name: -pdf                # 不能以连字符开头
name: pdf--processing     # 不允许连续连字符
```

### 4.2 `description` 字段

- 必须为 1-1024 个字符
- 应**同时**描述技能做什么以及何时使用
- 应包含帮助代理识别相关任务的具体关键词

**良好示例：**
```yaml
description: Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when the user mentions PDFs, forms, or document extraction.
```

**糟糕示例：**
```yaml
description: Helps with PDFs.
```

### 4.3 `license` 字段

- 指定应用于该技能的许可证
- 建议保持简短

**示例：**
```yaml
license: Proprietary. LICENSE.txt has complete terms
```

### 4.4 `compatibility` 字段

- 如果提供，必须为 1-500 个字符
- 仅当技能具有特定环境要求时才应包含
- 可以指示目标产品、必需的系统包、网络访问需求等

**示例：**
```yaml
compatibility: Designed for Claude Code (or similar products)
compatibility: Requires git, docker, jq, and access to the internet
compatibility: Requires Python 3.14+ and uv
```

> 注意：大多数技能不需要 `compatibility` 字段。

### 4.5 `metadata` 字段

- 从字符串键到字符串值的映射
- 客户端可用于存储 Agent Skills 规范未定义的附加属性

**示例：**
```yaml
metadata:
  author: example-org
  version: "1.0"
```

### 4.6 `allowed-tools` 字段

- 预批准运行的工具的空格分隔字符串
- **实验性**：支持可能因代理实现而异

**示例：**
```yaml
allowed-tools: Bash(git:*) Bash(jq:*) Read
```

---

## 五、正文内容（Body Content）

frontmatter 之后的 Markdown 正文包含技能指令。**没有格式限制**，编写任何有助于代理有效执行任务的内容。

**推荐章节：**
- 分步说明
- 输入和输出示例
- 常见边界情况

> 一旦代理决定激活某个技能，它将**加载整个文件**。考虑将较长的 `SKILL.md` 内容拆分为引用的文件。

---

## 六、可选目录

### 6.1 `scripts/`

包含代理可以运行的可执行代码。脚本应该：
- 自包含或清楚地记录依赖项
- 包含有用的错误消息
- 优雅地处理边界情况

支持的语言取决于代理实现，常见选项包括 Python、Bash、JavaScript。

### 6.2 `references/`

包含代理在需要时可以阅读的附加文档：
- `REFERENCE.md` - 详细技术参考
- `FORMS.md` - 表单模板或结构化数据格式
- 领域特定文件（`finance.md`、`legal.md` 等）

保持单个引用文件聚焦。**代理按需加载它们，文件越小意味着上下文使用越少**。

### 6.3 `assets/`

包含静态资源：
- 模板（文档模板、配置模板）
- 图像（图表、示例）
- 数据文件（查找表、模式）

---

## 七、渐进式加载（Progressive Disclosure）

代理以**渐进方式**加载技能，仅在任务需要时拉入更多细节。技能应结构化以利用这一点：

| 加载阶段 | 内容 | Token 量 |
|---------|------|---------|
| 1. 元数据 | 启动时为所有技能加载 `name` 和 `description` | ~100 token |
| 2. 指令 | 激活技能时加载完整的 `SKILL.md` 正文 | 建议 <5000 token |
| 3. 资源 | `scripts/`、`references/`、`assets/` 中的文件按需加载 | 按需 |

**建议：**
- 主 `SKILL.md` 保持在 **500 行以内**
- 详细参考材料移至单独的文件

---

## 八、文件引用

在技能中引用其他文件时，使用**相对于技能根目录的相对路径**：

```markdown
See [the reference guide](references/REFERENCE.md) for details.

Run the extraction script:
scripts/extract.py
```

**最佳实践：**
- 保持文件引用从 `SKILL.md` 起**一级深度**
- 避免深度嵌套的引用链

---

## 九、验证

使用 [skills-ref](https://github.com/agentskills/agentskills/tree/main/skills-ref) 参考库验证技能：

```bash
skills-ref validate ./my-skill
```

这将检查 `SKILL.md` frontmatter 是否有效并遵循所有命名约定。

---

## 十、安装与使用

### Claude Code

```bash
# 注册仓库为 Plugin marketplace
/plugin marketplace add anthropics/skills

# 安装特定 skill 集合
/plugin install document-skills@anthropic-agent-skills
/plugin install example-skills@anthropic-agent-skills
```

安装后可直接提及使用，例如：
> "Use the PDF skill to extract the form fields from path/to/some-file.pdf"

### Claude.ai

示例 skills 在 Claude.ai 付费方案中已可用。

### Claude API

可通过 Claude API 使用 Anthropic 预构建的 skills 并上传自定义 skills。详见 [Skills API Quickstart](https://docs.claude.com/en/api/skills-guide#creating-a-skill)。

---

## 十一、模板

完整 SKILL.md 模板：

```markdown
---
name: my-skill-name
description: A clear description of what this skill does and when to use it
---

# My Skill Name

[Add your instructions here that Claude will follow when this skill is active]

## Examples
- Example usage 1
- Example usage 2

## Guidelines
- Guideline 1
- Guideline 2
```

---

## 十二、官方资源链接

- **GitHub 仓库**：https://github.com/anthropics/skills
- **规范地址**：https://agentskills.io/specification
- **官方教程**：
  - [What are skills?](https://support.claude.com/en/articles/12512176-what-are-skills)
  - [Using skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
  - [How to create custom skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)
  - [Equipping agents for the real world with Agent Skills](https://anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- **Agent Skills 标准站**：https://agentskills.io

---

## 十三、免责声明

> These skills are provided for demonstration and educational purposes only. While some of these capabilities may be available in Claude, the implementations and behaviors you receive from Claude may differ from what is shown in these skills. These skills are meant to illustrate patterns and possibilities. Always test skills thoroughly in your own environment before relying on them for critical tasks.

中文：这些 skills 仅用于演示和教育目的。虽然这些能力中的一些可能在 Claude 中可用，但实际行为可能与 skills 中展示的有差异。这些 skills 用于说明模式和可能性。在关键任务中使用前，请始终在您自己的环境中进行充分测试。