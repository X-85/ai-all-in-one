# AstrBot 插件夜间开发任务

> 用于 AstrBot 或 `data/plugins/` 下插件的 `ai-ready` 任务。优先保持插件独立、可回滚、可测试。

状态：ai-ready
优先级：P1

## 任务类型

<!-- feature | bugfix | enhancement | refactor | compatibility | spike -->
类型：

## 背景与目标

<!-- 描述用户/群聊/管理员遇到的问题，以及期望结果。 -->

## 触发方式与用户体验

- 触发入口（命令、事件、定时任务或 WebUI）：
- 示例输入：
- 期望输出：
- 权限要求：
- 失败时提示：

## 验收标准

- [ ] 
- [ ] 
- [ ] 

## 范围边界

包含：

- 

不包含：

- 

## 实现提示

<!-- 写明目标插件目录、相关 AstrBot API、配置项或兼容版本。 -->

目标目录：

- `data/plugins/<plugin_name>/`

相关模块/API：

- 

配置与数据：

- 是否新增配置项：
- 是否需要迁移：
- 是否涉及密钥/隐私数据：

## 验证要求

- `uv run ruff format .`
- `uv run ruff check .`
- 运行相关单元测试或最小启动验证
- 涉及后端 API/OpenAPI 时运行 `cd dashboard && pnpm generate:api`
- 保持 Python 3.10+、macOS/Windows/Linux 兼容

## 夜间执行限制

- 在独立 `codex/nightly-*` 分支修改，不自动发布、不自动升级版本。
- 不修改 AstrBot 核心，除非任务明确指定；优先在插件目录内完成。
- 不把 token、cookie、真实聊天记录或本机路径写入代码和日志。
- 发现 API/需求不确定时改做 spike，并记录兼容性风险。

## 早晨交付格式

- 修改摘要：
- 修改插件与文件：
- 触发/输出示例：
- lint/测试/启动结果：
- 配置或升级注意事项：
- 风险与待人工确认：
