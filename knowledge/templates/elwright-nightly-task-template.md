# Elwright 夜间开发任务

> 用于提交给 Elwright 仓库的 `ai-ready` 任务。一个任务只解决一个可验收结果。

状态：ai-ready
优先级：P1

## 任务类型

<!-- feature | bugfix | enhancement | refactor | migration | spike -->
类型：

## 背景与目标

<!-- 为什么做，以及这次任务要改变什么。不要写解决方案。 -->

## 用户场景

<!-- 以“作为……我希望……从而……”描述；没有用户场景时可删除。 -->

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

<!-- 可填写相关模块、已有 feature 文档、命令或约束；不确定时留空。 -->

相关位置：

- `src-tauri/src/`
- `src/`
- `docs/features/`

## 验证要求

- Rust：`cd src-tauri && cargo test`
- 前端：`cd src && npm run build`
- 如涉及 CLI：补充对应 `ew` 冒烟验证
- 行为变化同步更新 feature 文档和 `docs/work/active/`

## 夜间执行限制

- 在独立 `codex/nightly-*` 分支修改，不合并、不部署。
- 不改变架构锁定决策、默认配置或用户数据格式，除非任务明确要求。
- 发现需求不明确时改做 spike，并留下结论，不猜测扩大范围。

## 早晨交付格式

- 修改摘要：
- 变更文件：
- 验收标准完成情况：
- 测试/构建结果：
- 截图或预览方式：
- 风险与待人工确认：
