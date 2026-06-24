---
name: prevent-sleep
description: 防止 Mac 系统进入休眠，允许屏幕按系统设置自动熄灭。适用于手机远程控制、长时间运行任务等场景。启动前检查 caffeinate 进程，已有则提示，重复则清理重建。
---

# Prevent Sleep Skill

## 功能
防止 Mac 系统进入休眠，允许屏幕按系统设置时间自动熄灭。

## 启动前检查

每次执行前必须先检测已有 `caffeinate` 进程数量，避免重复守护进程堆积：

```bash
COUNT=$(pgrep -x caffeinate | wc -l | tr -d ' ')

if [ "$COUNT" -eq 0 ]; then
  # 无现有进程，正常启动
  caffeinate -i &
elif [ "$COUNT" -eq 1 ]; then
  # 已有 1 个：提示用户，不创建新进程
  echo "ℹ️ 检测到 1 个 caffeinate 已在运行,不创建新进程"
  pgrep -l caffeinate
else
  # ≥2 个重复进程：提示具体数量，kill 全部，重建 1 个
  echo "⚠️ 检测到 $COUNT 个 caffeinate 重复进程,清理后新建 1 个"
  pgrep -l caffeinate
  pkill -x caffeinate
  sleep 0.3
  caffeinate -i &
fi
```

## 执行命令
- `caffeinate -i &` — 阻止系统空闲睡眠，屏幕按系统设置自动熄灭

## 验证
```bash
pgrep -l caffeinate
```

期望结果：仅有 1 个 `caffeinate` 进程。

## 适用场景
- 手机远程控制电脑
- 长时间下载或运行任务
- 远程桌面连接

## 注意事项
- 全局只需 1 个 `caffeinate` 实例即可，多个实例不会带来额外保护效果
- `prevent-sleep` 与 `prevent-sleep-now` 共用 `caffeinate`，互为幂等
- 如需手动结束防休眠：`pkill caffeinate`
