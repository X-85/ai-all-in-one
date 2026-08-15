# 开发 IDE 使用指南

本文记录常用开发 IDE 的安装、项目打开、中文界面、终端和代码运行方法。不同项目的依赖和启动命令以项目根目录中的 `AGENTS.md`、`README.md` 或项目配置为准。

## Visual Studio Code

### 安装与中文界面

1. 从 [Visual Studio Code 官网](https://code.visualstudio.com/)下载安装包。
2. 打开扩展面板：macOS 使用 `Command + Shift + X`，Windows/Linux 使用 `Ctrl + Shift + X`。
3. 搜索并安装 Microsoft 发布的 `Chinese (Simplified) Language Pack for Visual Studio Code`。
4. 按 `Command + Shift + P` 或 `Ctrl + Shift + P`，执行 `Configure Display Language`，选择 `zh-cn`，然后重启 VS Code。

### 打开项目

1. 选择菜单 `文件 -> 打开文件夹`。
2. 选择项目根目录，而不是只打开某个源代码文件。
3. 等待 VS Code 完成语言服务、依赖索引和扩展初始化。

### 常用功能

- `Command/Ctrl + P`：按文件名快速打开文件。
- `Command/Ctrl + Shift + F`：在整个项目中搜索文本。
- `Command/Ctrl + Shift + P`：打开命令面板。
- 左侧“源代码管理”：查看 Git 修改、暂存文件和提交代码。
- 菜单 `终端 -> 新建终端`：在项目根目录运行命令。

### Python 项目

1. 安装 Microsoft 的 `Python` 扩展和 Astral 的 `Ruff` 扩展。
2. 使用命令面板执行 `Python: Select Interpreter`，选择项目使用的 Python 环境。
3. 在集成终端中运行项目规定的安装、测试和启动命令。

## Cursor

### 安装与项目打开

1. 从 [Cursor 官网](https://www.cursor.com/)下载安装 Cursor。
2. 选择 `File -> Open Folder`，打开项目根目录。
3. 根据提示登录并配置模型；涉及敏感代码时，先确认隐私和数据设置符合项目要求。

### 常用 AI 操作

- 选中代码后使用 `Command/Ctrl + K`：让 AI 修改或生成选中的代码。
- 使用聊天面板：询问项目结构、调用关系、错误原因或实现方案。
- 使用 `@Files`、`@Folders` 或 `@Code`：明确告诉 AI 需要参考的文件、目录或代码符号。
- 让 AI 修改文件后，先查看 diff，再运行测试和格式检查。

### 使用建议

1. 先说明目标、限制条件和验收标准，再让 AI 编码。
2. 一次处理一个清晰的小任务，避免让 AI 同时修改无关模块。
3. 不要直接接受大范围改动；检查 API、异常处理、权限和兼容性。
4. 将项目约定写入 `AGENTS.md`、`README.md` 或项目配置，让后续操作保持一致。

## IntelliJ IDEA

### 安装与项目打开

1. 从 [JetBrains 官网](https://www.jetbrains.com/idea/)下载安装 IntelliJ IDEA。
2. 选择 `Open`，打开项目根目录或项目构建文件。
3. 对 Maven 项目打开 `pom.xml`，对 Gradle 项目打开 `build.gradle` 或 `build.gradle.kts`。
4. 等待 IDE 完成依赖下载、索引和项目同步。

### 中文界面

1. 打开 `Settings`（macOS 使用 `Command + ,`，Windows/Linux 使用 `Ctrl + Alt + S`）。
2. 进入 `Plugins`，搜索 `Chinese (Simplified) Language Pack`。
3. 安装 JetBrains 发布的中文语言包并重启 IDE。

### 常用功能

- `Shift` 连按两次：搜索文件、类、操作和设置。
- `Command/Ctrl + Shift + F`：在项目中搜索文本。
- `Command/Ctrl + B`：跳转到定义或实现。
- `Command/Ctrl + Alt + L`：格式化当前文件。
- `Command/Ctrl + Shift + F10`：运行当前配置。
- `Command/Ctrl + F8`：切换断点。
- `Command/Ctrl + F5`：调试运行。

### Java 项目

1. 在 `Project Structure` 中选择正确的 JDK。
2. 确认 Maven 或 Gradle 使用的 Java 版本与项目要求一致。
3. 先同步依赖，再运行测试或启动配置。
4. 调试时在关键代码行设置断点，通过变量面板和调用栈定位问题。

## 通用开发流程

1. 使用 Git 克隆项目，或打开已有的项目目录。
2. 阅读项目根目录的说明文件，确认运行环境和依赖安装命令。
3. 创建独立分支后再开始修改代码。
4. 使用 IDE 的搜索和跳转功能理解相关代码，避免只修改表面报错位置。
5. 保存修改后查看 Git diff。
6. 运行格式化、静态检查和测试。
7. 确认没有提交密钥、个人配置或无关文件，再提交代码。

## 常用快捷键对照

| 功能 | VS Code / Cursor | IntelliJ IDEA |
| --- | --- | --- |
| 快速打开文件 | `Command/Ctrl + P` | 连按两次 `Shift` |
| 全局搜索 | `Command/Ctrl + Shift + F` | `Command/Ctrl + Shift + F` |
| 打开命令或操作搜索 | `Command/Ctrl + Shift + P` | 连按两次 `Shift` |
| 格式化代码 | `Shift + Option/Alt + F` | `Command/Ctrl + Alt + L` |
| 查看版本控制改动 | 左侧源代码管理 | `Git` 工具窗口 |
