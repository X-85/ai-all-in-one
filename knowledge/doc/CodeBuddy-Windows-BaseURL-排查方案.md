# CodeBuddy Windows 内置模型 Base URL 定位方案

## 目标

在 Windows 版 CodeBuddy IDE 中完成一次真实的 AI 对话，定位其模型请求的：

- 请求域名
- 完整请求 URL
- 接口路径
- 是否使用 HTTP、SSE 或 WebSocket
- 是否经过 CodeBuddy/腾讯云/公司内部网关

本方案只定位 Base URL 和接口路径，不保存、复制或导出 API Key、登录 Token、Cookie、项目代码或完整请求体。

## 适用范围

- CodeBuddy IDE Windows 版本
- CodeBuddy 国内版，官网为 `codebuddy.cn`
- 基于 VS Code/Electron 的桌面 IDE
- 已获得公司对本机网络审计和代理调试的授权

## 官方信息

CodeBuddy 官方文档确认了以下路径和配置项：

| 项目 | 路径或配置 |
| --- | --- |
| Windows 日志目录 | `C:\Users\<用户名>\AppData\Roaming\CodeBuddy\logs` |
| 常见安装目录 | `C:\Users\<用户名>\AppData\Local\Programs\CodeBuddy` |
| 国内版连通性检测域名 | `copilot.tencent.com` |
| 通用代理配置 | `http.proxy`、`http.proxySupport` |
| CodeBuddy 代理配置 | `codingcopilot.httpProxySettings`、`codingcopilot.httpProxyURL` |
| 自定义模型配置 | `%USERPROFILE%\.codebuddy\models.json` |

官方文档中的 `models.json` 用于配置自定义模型，不代表内置模型一定使用相同协议。官方文档要求自定义模型 URL 通常是完整接口路径，例如 `/v1/chat/completions`。

参考文档：

- [CodeBuddy IDE 简介](https://www.codebuddy.cn/docs/ide/Introduction)
- [Windows 安装和登录](https://www.codebuddy.cn/docs/ide/Getting-Started/Installation)
- [模型配置](https://www.codebuddy.cn/docs/ide/Features/models)
- [故障排查](https://www.codebuddy.cn/docs/ide/Support/Troubleshooting)
- [安全与隐私](https://www.codebuddy.cn/docs/ide/Support/security-privacy)

## 推荐执行顺序

```text
CodeBuddy 日志
    ↓
Fiddler/Charles 查看 Host 和完整 URL
    ↓
检查 SSE 和 WebSocket 请求
    ↓
PowerShell 查看 CodeBuddy 进程连接
    ↓
汇总 Base URL、完整接口和协议
```

优先使用日志和网络域名定位；只有在公司允许安装本机 HTTPS 调试证书时，才使用 HTTPS 解密查看完整路径。

## 前置准备

### 1. 确认 CodeBuddy 进程名称

在 PowerShell 执行：

```powershell
Get-CimInstance Win32_Process |
  Where-Object {
    $_.Name -match 'CodeBuddy|Code|Electron'
  } |
  Select-Object Name, ProcessId, CommandLine
```

记录 CodeBuddy 主进程及可能的扩展/后台进程 PID。不要把 `CommandLine` 输出上传到公共渠道，因为它可能包含启动参数或代理信息。

### 2. 确认当前是否已有公司代理

在 CodeBuddy 中按 `Ctrl+,`，搜索 `proxy`，记录已有配置。

重点查看：

```text
http.proxy
http.proxySupport
codingcopilot.httpProxySettings
codingcopilot.httpProxyURL
```

不要直接覆盖公司已有代理。测试结束后恢复原配置。

## 方案 A：查看 CodeBuddy 本地日志

### 1. 通过界面打开日志

在 CodeBuddy 菜单中打开：

```text
帮助 → 打开日志文件夹
```

也可以直接打开：

```text
C:\Users\<用户名>\AppData\Roaming\CodeBuddy\logs
```

### 2. 搜索 URL 和网络关键词

安装了 `rg` 时，在 PowerShell 执行：

```powershell
$logPath = "$env:APPDATA\CodeBuddy\logs"

rg -n -i `
  'https?://|copilot|codebuddy|endpoint|chat|model|websocket|sse' `
  $logPath
```

没有 `rg` 时使用 PowerShell：

```powershell
$logPath = "$env:APPDATA\CodeBuddy\logs"

Get-ChildItem $logPath -Recurse -File |
  Select-String -Pattern 'https?://|copilot|codebuddy|endpoint|chat|model|websocket|sse'
```

### 3. 重新触发一次请求

为了避免旧日志干扰：

1. 完全退出 CodeBuddy。
2. 重新打开 CodeBuddy。
3. 登录账号。
4. 发起一次普通 AI 对话或代码修改请求。
5. 立即检查最新日志。

重点关注：

```text
https://...
copilot.tencent.com
endpoint
request
stream
websocket
```

如果日志只记录错误，不记录成功请求，转到方案 B。

## 方案 B：使用 Fiddler 查看完整请求 URL

### 1. 安装和启动 Fiddler

可以使用 Fiddler Everywhere 或 Fiddler Classic。启动后：

1. 打开 `Settings` 或 `Tools`。
2. 进入 `HTTPS`。
3. 启用 `Decrypt HTTPS traffic`。
4. 按提示安装并信任 Fiddler Root Certificate。
5. 确认监听端口，通常为：

```text
127.0.0.1:8888
```

如果公司安全策略不允许安装证书，不要绕过策略，使用方案 A 或方案 C。

### 2. 配置 CodeBuddy 使用 Fiddler

先使用 Fiddler 的系统代理功能。如果 CodeBuddy 没有流量，再在 CodeBuddy 的 `settings.json` 中临时配置：

```json
{
  "http.proxy": "http://127.0.0.1:8888",
  "http.proxySupport": "override"
}
```

如果 CodeBuddy 使用专用代理配置，则检查以下配置项，并只修改实际生效的配置：

```text
codingcopilot.httpProxySettings
codingcopilot.httpProxyURL
```

修改后完全退出并重新打开 CodeBuddy。测试结束后恢复原配置。

### 3. 发起一次 AI 请求

在 CodeBuddy 中完成一次真实模型调用：

1. 打开一个普通项目。
2. 选择一个内置模型。
3. 发起一次简短对话，例如让模型解释一个函数。
4. 等待模型返回结果。
5. 回到 Fiddler 查看刚刚产生的会话。

### 4. 在 Fiddler 中筛选

重点筛选：

```text
copilot.tencent.com
codebuddy
tencent.com
POST
wss://
```

AI 请求可能使用以下形式：

```text
POST + chunked response
POST + Server-Sent Events
WebSocket / wss://
```

不要只筛选普通的 `POST` 请求。

### 5. 记录 URL

例如 Fiddler 显示：

```text
https://example.com/v1/chat/completions
```

记录为：

```text
完整请求 URL: https://example.com/v1/chat/completions
请求方法: POST
接口路径: /v1/chat/completions
候选 Base URL: https://example.com/v1
```

注意：Base URL 的定义取决于客户端 SDK。有的 SDK 要求填到 `/v1`，有的配置要求填完整的 `/chat/completions` 地址。因此应同时保留完整 URL 和候选 Base URL。

### 6. 不要保存敏感内容

只记录以下字段：

```text
请求域名
请求路径
请求方法
响应状态码
是否流式返回
是否 WebSocket
```

不要保存或复制：

```text
Authorization
api-key
x-api-key
Cookie
access_token
refresh_token
请求体
响应体
完整 Fiddler SAZ 会话文件
```

请求体和响应体可能包含公司源代码、提示词、登录凭证或用户数据。

## 方案 C：PowerShell 查看 CodeBuddy 的远程连接

这个方案不需要 HTTPS 解密，只能看到远程 IP 和端口，不能看到 URL 路径。

### 1. 查看 443 连接

```powershell
Get-NetTCPConnection -State Established |
  Where-Object {
    $_.RemotePort -eq 443
  } |
  Select-Object OwningProcess, LocalAddress, LocalPort, RemoteAddress, RemotePort
```

### 2. 根据 PID 确认进程

```powershell
Get-Process -Id <进程ID>
```

### 3. 查询远程 IP 的域名

```powershell
Resolve-DnsName <远程IP>
```

也可以使用：

```powershell
nslookup <远程IP>
```

这个方案适合验证 CodeBuddy 是否连接到了：

```text
copilot.tencent.com
腾讯云其他服务域名
CodeBuddy 服务域名
公司内部代理或网关
```

但 IP 连接无法证明具体的接口路径。

## 方案 D：使用 Electron 启动参数强制代理

如果 CodeBuddy 不遵循 IDE 的代理配置，可以尝试从 PowerShell 启动：

```powershell
& "C:\Users\<用户名>\AppData\Local\Programs\CodeBuddy\CodeBuddy.exe" `
  --proxy-server=http://127.0.0.1:8888
```

实际可执行文件路径以“右键 CodeBuddy 图标 → 打开文件所在位置”为准。

该参数可能只影响 Electron/Chromium 网络请求，扩展或后台 Node 进程不一定遵循。因此启动后仍需检查 Fiddler 是否出现 AI 请求。

## 失败分支排查

### Fiddler 没有任何 CodeBuddy 请求

按以下顺序检查：

1. Fiddler 是否正在监听 `127.0.0.1:8888`。
2. CodeBuddy 是否完全重启。
3. CodeBuddy 是否已有公司代理，导致请求没有经过 Fiddler。
4. 是否配置了正确的 `http.proxy` 或 `codingcopilot.httpProxyURL`。
5. 是否需要筛选 `wss://` WebSocket 请求。
6. CodeBuddy 是否通过独立后台进程发起请求。
7. Windows 防火墙或公司安全软件是否禁止本机代理。

### 只能看到登录请求

登录域名不等于模型服务域名。登录成功后重新触发一次模型生成，并按时间筛选新请求。

### 只能看到域名，看不到路径

可能原因：

- HTTPS 没有成功解密。
- CodeBuddy 使用了证书固定。
- 请求由 WebSocket 承载。
- 请求通过公司代理转发。

不要尝试绕过证书固定。改用 CodeBuddy 日志、公司代理日志或让 IT 提供服务端点。

### 看到的是腾讯云网关而不是 OpenAI/DeepSeek 域名

这通常说明 CodeBuddy 使用了自己的模型网关。此时记录网关域名和完整路径即可，不要假定它兼容 OpenAI API。

## 结果记录模板

将真实结果填入下面表格：

| 字段 | 结果 |
| --- | --- |
| CodeBuddy 版本 |  |
| Windows 版本 |  |
| 测试时间 |  |
| 模型显示名称 |  |
| 模型 ID（如果可见） |  |
| 请求域名 |  |
| 完整请求 URL |  |
| 候选 Base URL |  |
| 请求方法 |  |
| 协议 | HTTP / SSE / WebSocket |
| 响应状态码 |  |
| 是否经过公司代理 | 是 / 否 / 不确定 |
| 来源 | 日志 / Fiddler / PowerShell |

## 结论判断

### 情况 1：日志或抓包得到完整请求 URL

可以确认 CodeBuddy 实际使用的服务端点。但仅凭 URL 不能判断自研 Agent 是否能够调用，还要确认协议和认证方式。

### 情况 2：只得到域名

可以确认服务主机，但不能确认 Base URL 的路径前缀。需要获得 HTTPS 解密后的请求路径，或查看 CodeBuddy 内部日志。

### 情况 3：只得到 `copilot.tencent.com`

可以确认请求进入 CodeBuddy 国内服务入口，但不能直接推断模型接口是：

```text
/v1/chat/completions
```

还是 CodeBuddy 自定义的接口。

### 情况 4：没有任何外部模型请求

可能是：

- CodeBuddy 使用独立后台服务进程。
- 请求走了现有公司代理。
- 模型请求使用 WebSocket。
- 请求在公司网关侧完成转发。
- HTTPS 调试被安全策略阻断。

这时应把 CodeBuddy 日志、Fiddler 主机列表和 PowerShell 连接结果交给公司 IT 或供应商，请求正式的模型 API/网关接入方式。

## 安全边界

本方案的产出应只有：

```text
服务域名
接口路径
请求方法
协议类型
状态码
```

不要把 API Key、登录 Token、Cookie、项目代码或完整网络会话文件交给其他 Agent 工具。若认证字段意外出现在日志或抓包记录中，应立即停止传播并联系管理员轮换凭证。
