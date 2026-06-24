---
name: prevent-sleep-now
description: 防止 Mac 系统进入休眠并立即熄灭屏幕。适用于需要立即熄屏但仍保持远程连接的场景。启动前检查 caffeinate 进程，已有则提示，重复则清理重建。
---

# Prevent Sleep Now Skill

## 功能
防止 Mac 系统进入休眠，并立即熄灭屏幕，同时保持后台连接。

## 启动前检查

每次执行前必须先检测已有 `caffeinate` 进程数量，避免重复守护进程堆积：

```bash
COUNT=$(pgrep -x caffeinate | wc -l | tr -d ' ')

if [ "$COUNT" -eq 0 ]; then
  # 无现有进程，正常启动并熄屏
  caffeinate -i -d & disown
  sleep 0.3 && pmset displaysleepnow
elif [ "$COUNT" -eq 1 ]; then
  # 已有 1 个：提示用户，不创建新进程，但立即熄屏
  echo "ℹ️ 检测到 1 个 caffeinate 已在运行,不创建新进程"
  pgrep -l caffeinate
  pmset displaysleepnow
else
  # ≥2 个重复进程：提示具体数量，kill 全部，重建 1 个并立即熄屏
  echo "⚠️ 检测到 $COUNT 个 caffeinate 重复进程,清理后新建 1 个"
  pgrep -l caffeinate
  pkill -x caffeinate
  sleep 0.3
  caffeinate -i -d & disown
  sleep 0.3 && pmset displaysleepnow
fi
```

## 执行命令
- `caffeinate -i -d &` — 阻止系统空闲睡眠 + 阻止显示器睡眠
- `pmset displaysleepnow` — 立即熄灭屏幕

## 验证
```bash
pgrep -l caffeinate
```

期望结果：仅有 1 个 `caffeinate` 进程。

## 适用场景
- 需要立即熄屏省电
- 手机远程控制电脑
- 远程桌面连接

## 注意事项
- 全局只需 1 个 `caffeinate` 实例即可，多个实例不会带来额外保护效果
- `prevent-sleep` 与 `prevent-sleep-now` 共用 `caffeinate`，互为幂等
- 如需手动结束防休眠：`pkill caffeinate`
- `disown` 用于把 `caffeinate` 与当前 shell 解绑，避免 shell 退出时误杀
