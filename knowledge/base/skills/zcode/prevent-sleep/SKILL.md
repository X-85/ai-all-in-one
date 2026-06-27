---
name: prevent-sleep
description: 防止系统进入休眠，允许屏幕按系统设置自动熄灭。macOS 用 caffeinate -i；Windows 用 PowerShell + SetThreadExecutionState(ES_SYSTEM_REQUIRED)。启动前检查对应进程/状态，重复时清理重建。适用于手机远程控制、长时间运行任务等场景。
---

# Prevent Sleep Skill（跨平台版）

防止系统进入休眠，让 AI agent（如 zcode 的 web remote control）能持续远程控制电脑。屏幕按系统设置自动熄灭以保持省电。

## 平台检测

执行前先判断操作系统：

```bash
case "$(uname -s 2>/dev/null || echo "$OS")" in
  Darwin*)  PLATFORM=macos ;;
  Linux*)   PLATFORM=linux ;;
  MINGW*|CYGWIN*|MSYS*|Windows_NT)  PLATFORM=windows ;;
  *)        PLATFORM=unknown ;;
esac
```

仅 `macos` 和 `windows` 平台实现本 skill。Linux 暂未实现。

## macOS 实现

### 启动前检查

每次执行前必须先检测已有 `caffeinate` 进程数量，避免重复守护进程堆积：

```bash
COUNT=$(pgrep -x caffeinate | wc -l | tr -d ' ')

if [ "$COUNT" -eq 0 ]; then
  # 无现有进程，正常启动
  caffeinate -i &
elif [ "$COUNT" -eq 1 ]; then
  # 已有 1 个：提示用户，不创建新进程
  echo "ℹ️ 检测到 1 个 caffeinate 已在运行，不创建新进程"
  pgrep -l caffeinate
else
  # ≥2 个重复进程：提示具体数量，kill 全部，重建 1 个
  echo "⚠️ 检测到 $COUNT 个 caffeinate 重复进程，清理后新建 1 个"
  pgrep -l caffeinate
  pkill -x caffeinate
  sleep 0.3
  caffeinate -i &
fi
```

### 执行命令

- `caffeinate -i &` — 阻止系统空闲睡眠，屏幕按系统设置自动熄灭

### 验证

```bash
pgrep -l caffeinate
```

期望结果：仅有 1 个 `caffeinate` 进程。

### 手动结束

```bash
pkill caffeinate
```

## Windows 实现

### 启动前检查

通过 `powercfg /requests` 查看当前是否有进程已声明 `ES_SYSTEM_REQUIRED`（防系统睡眠）的 Power Request：

```powershell
$existing = (powercfg /requests | Select-String "SYSTEM" | Measure-Object).Count

if ($existing -eq 0) {
    # 无现有请求，正常启动
    Set-PreventSleep
} elseif ($existing -eq 1) {
    # 已有 1 个：提示用户
    Write-Host "ℹ️ 检测到 1 个防休眠请求已在运行，不创建新请求" -ForegroundColor Yellow
    powercfg /requests | Select-String "SYSTEM"
} else {
    # ≥2 个重复请求：清理后重建
    Write-Host "⚠️ 检测到 $existing 个防休眠请求，清理后新建 1 个" -ForegroundColor Yellow
    Clear-PreventSleep
    Start-Sleep -Milliseconds 300
    Set-PreventSleep
}
```

### 定义 PowerShell 函数

把以下代码块加入 `$PROFILE` 或脚本头部：

```powershell
# 加载 Win32 API
Add-Type -Namespace Win32 -Name Kernel -MemberDefinition @"
[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);

public const uint ES_CONTINUOUS       = 0x80000000;
public const uint ES_SYSTEM_REQUIRED  = 0x00000001;
public const uint ES_DISPLAY_REQUIRED = 0x00000002;
"@ -ErrorAction SilentlyContinue

function Set-PreventSleep {
    # 阻止系统空闲睡眠（屏幕可按系统设置自动熄灭）
    [Win32.Kernel]::SetThreadExecutionState(
        [Win32.Kernel]::ES_CONTINUOUS -bor [Win32.Kernel]::ES_SYSTEM_REQUIRED
    ) | Out-Null
    Write-Host "✅ 已设置防系统睡眠（屏幕可自动灭）" -ForegroundColor Green
}

function Clear-PreventSleep {
    # 恢复（让系统可以正常睡眠）
    [Win32.Kernel]::SetThreadExecutionState([Win32.Kernel]::ES_CONTINUOUS) | Out-Null
    Write-Host "✅ 已清除防休眠请求" -ForegroundColor Green
}
```

### 执行命令

直接调用：

```powershell
Set-PreventSleep
```

或一次性执行（无需 $PROFILE）：

```powershell
powershell -Command "Add-Type -Namespace Win32 -Name Kernel -MemberDefinition '[DllImport(\"kernel32.dll\")] public static extern uint SetThreadExecutionState(uint esFlags); public const uint ES_CONTINUOUS = 0x80000000; public const uint ES_SYSTEM_REQUIRED = 0x00000001;' ; [Win32.Kernel]::SetThreadExecutionState([Win32.Kernel]::ES_CONTINUOUS -bor [Win32.Kernel]::ES_SYSTEM_REQUIRED)"
```

### 验证

```powershell
powercfg /requests
```

期望结果：列表中包含一个 Power Request 类型为 `SYSTEM` 的条目（来自当前 PowerShell 进程）。

### 手动结束

```powershell
# 退出 PowerShell 进程（系统自动清除）或显式调用
Clear-PreventSleep
# 或者：
powershell -Command "Add-Type -Namespace Win32 -Name Kernel -MemberDefinition '[DllImport(\"kernel32.dll\")] public static extern uint SetThreadExecutionState(uint esFlags); public const uint ES_CONTINUOUS = 0x80000000;' ; [Win32.Kernel]::SetThreadExecutionState([Win32.Kernel]::ES_CONTINUOUS)"
```

## 适用场景

- 手机远程控制电脑
- 长时间下载或运行任务
- 远程桌面连接
- AI agent 通过 web remote control 保持连接

## 注意事项

- 全局只需 1 个实例即可（macOS 的 `caffeinate` / Windows 的 Power Request），多个实例不会带来额外保护效果
- `prevent-sleep` 与 `prevent-sleep-now` 互为幂等，可以共存
- macOS 进程退出时 `caffeinate` 自动结束；Windows PowerShell 进程退出时系统自动清除 Power Request
- 如需立即熄屏，用 `prevent-sleep-now`