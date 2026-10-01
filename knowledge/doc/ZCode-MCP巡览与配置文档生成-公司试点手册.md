# ZCode 页面巡览 + 配置文档生成 公司试点手册(Windows / 网络受限版)

> 目的:在公司用 ZCode 完成两件事——①挂 Playwright MCP 巡览平台 web 页面,产出页面功能清单;②从代码仓库自动生成配置类文档。
> 读者有两位:①你自己(负责第 0~2 节的环境准备);②执行任务的 ZCode(按本文档分阶段执行)。
> 编写于 2026-09-17,配套工具:ZCode(公司已装)、Playwright MCP(微软开源,免费)。

---

## 0. 开始前必须填写(人类完成,ZCode 开工前检查)

| 占位符 | 值 | 说明 |
|---|---|---|
| 测试环境地址 | ____________ | 必须是测试环境,严禁连生产 |
| 测试账号/密码 | ____________ | 只读权限或数据可重置 |
| 平台仓库本地路径 | ____________ | 前端或 monorepo 仓库,已 clone 到本机 |
| 输出目录 | 建议 `<仓库>\docs\ai-generated\` | 所有产出集中在这里 |

**给读到本文档的 ZCode agent 的指令**:上表有空缺就停下来向用户索要,不要猜。然后按顺序执行:**第 1 节环境自检 → 第 3 节(配置文档,不需要浏览器)→ 第 4 节(页面巡览,需要 MCP)**。遇到故障先查第 6 节排查表。铁律:所有产出必须标注出处(代码=文件:行号;页面=路由+截图文件名);查不到的信息留空,严禁编造;页面上的危险操作(删除/提交/发布)只截图不点击。

---

## 1. 环境自检(开工第一步,约 5 分钟)

PowerShell 逐条执行:

```powershell
node -v     # 需要 v18 以上;报"无法识别"= 没装 Node,用 2.3 节的便携版 Node
npx -v      # 与 node 同源,能出版本号即可
```

另查三样:
- **浏览器**:Chrome 或 Edge 任一能打开即可(Windows 必带 Edge,MCP 可直接驱动它)
- **仓库**:能访问公司 git 并 clone 到本机(内网 git 一般不受限)
- **测试环境**:本机浏览器手动打开测试环境地址能访问(需要 VPN/内网就先连)

**网络三问**(决定第 2 节走哪条安装路线):
1. `npx @playwright/mcp@latest --help` 能跑通 → 走 **2.1 直连路线**
2. 拉包超时,但公司有 npm 私服(问前端同事要 registry 地址)→ 走 **2.2 私服路线**
3. 都不行 → 走 **2.3 离线包路线**(需要今天在家先准备,见该节)

---

## 2. 安装/挂载 Playwright MCP(按网络状况三选一)

### 2.0 零配置备选:官方 browser-use 插件

如果公司 ZCode 能访问插件市场:Settings → Plugin Management → Discover → 安装 **browser-use** 插件,装完即有浏览器控制能力,本节其余全部跳过。装不了(网络不通)再走下面。

### 2.1 路线 A:直连可用

网络能直连 npm 时,无需预装任何东西,配置里直接写 npx。跳到 2.4 挂载。

### 2.2 路线 B:公司 npm 私服

```powershell
npm config set registry <前端同事提供的私服地址>
npx @playwright/mcp@latest --help    # 能打印帮助说明包能拉到
```

然后同样按 2.4 挂载(npx 写法)。

### 2.3 路线 C:完全离线(今天在家准备,明天直接用)

家里电脑执行:

```powershell
mkdir playwright-mcp-portable
cd playwright-mcp-portable
npm install @playwright/mcp
```

再从 https://nodejs.org 下载 **Windows 版 .zip(x64)便携包**(免安装,比如 `node-v22-win-x64.zip`)。两样一起(整个 `playwright-mcp-portable` 文件夹 + node zip)用 U 盘或公司允许的方式带到公司,解压到如 `C:\tools\`,最终结构:

```
C:\tools\node\node.exe
C:\tools\playwright-mcp-portable\node_modules\@playwright\mcp\cli.js
```

此路线不依赖公司网络的任何下载,配置见 2.4 的离线写法。

### 2.4 挂载到 ZCode(Windows)

配置文件位置二选一:
- **个人全局**:`C:\Users\<你的用户名>\.zcode\cli\config.json`
- **仓库共享**(可提交进 git 给团队用):`<仓库>\.zcode\config.json`

> 文件已存在时,把 `playwright` 合并进现有 `mcp.servers`,不要整文件覆盖。

**npx 写法**(路线 A/B):

```json
{
  "mcp": {
    "servers": {
      "playwright": {
        "command": "npx",
        "args": ["@playwright/mcp@latest", "--browser", "chrome"]
      }
    }
  }
}
```

**离线写法**(路线 C;注意 Windows 路径用正斜杠,避免双反斜杠转义问题):

```json
{
  "mcp": {
    "servers": {
      "playwright": {
        "command": "C:/tools/node/node.exe",
        "args": ["C:/tools/playwright-mcp-portable/node_modules/@playwright/mcp/cli.js", "--browser", "msedge"]
      }
    }
  }
}
```

说明:
- 机器上没装 Chrome 就用 `--browser msedge`(Windows 自带 Edge,开箱即用)
- npx 写法若报 spawn/启动失败,把 `command` 改成 `cmd`、`args` 前面加 `"/c", "npx"`,或干脆换离线写法(它绕开了 npx,最稳)

**验证**:保存配置后开个新 ZCode 会话,Settings → MCP 里 playwright 显示已连接;或直接问 agent:"你有 playwright 的哪些工具"——能看到 `browser_navigate`、`browser_snapshot`、`browser_take_screenshot` 之类即成功。

---

## 3. 阶段一:配置类文档生成(不需要浏览器,先做,约 30 分钟)

### 3.1 先写仓库地图(10 分钟,人工)

在仓库根目录创建/补充 `AGENTS.md`,至少写清(不知道的让 AI 找一遍后补进来):

```markdown
# 仓库地图(给 AI 的导航)
- 前端代码:src/(框架:React/Vue;路由表:src/router/**)
- 后端代码:server/
- 菜单/导航定义:src/layout/menu.*  ← 平台功能的官方清单
- i18n 文案:src/locales/            ← 功能名称/提示语的现成中文文案
- 配置相关:设置页表单组件 src/views/settings/**;后端 config 读取 server/config/**;.env.example
- feature flags / 权限点定义:______
```

### 3.2 执行提示词(直接粘给 ZCode)

```text
你是产品能力文档助手,请在当前仓库按 AGENTS.md 的地图工作。
任务:找出所有"配置项"的定义位置——前端设置页表单、配置文件 schema、后端 config 读取代码、.env.example、feature flags 等。
输出 markdown 表格,列:配置项名称 | 所属模块 | 类型 | 默认值 | 取值范围 | 前端入口(菜单路径) | 代码出处(文件:行号)。
要求:先只给"配置模块概览"让我确认;确认后再逐模块展开;每行必须有代码出处;查不到的字段留空,严禁编造。
产出写入 docs/ai-generated/配置项总表.md
```

### 3.3 验收标准

- [ ] 表格每行都有 `文件:行号` 出处
- [ ] 随机抽 3 条,去代码里核对名称与默认值一致
- [ ] 默认值是代码里的真实默认,不是 AI 猜的"常见值"

---

## 4. 阶段二:页面 MCP 巡览(需要第 2 节挂载成功,约 60 分钟)

### 4.1 第一批:先巡 3~5 个页面验证流程(不要一上来全站!)

```text
使用 playwright 工具完成页面巡览。
打开 {测试环境地址},用账号 {账号/密码} 登录。本批只巡这些页面:______(列 3~5 个)。
每个页面做两件事:
1) 截图存到 docs/ai-generated/page-snapshots/(文件名用菜单路径转写);
2) 提取页面快照(accessibility tree),记录:菜单路径、按钮、表单项、表格列名。
输出"页面功能清单" markdown 到 docs/ai-generated/页面功能清单.md,每页一节:
入口路径 | 页面用途(一句话) | 主要操作 | 涉及配置项(引用配置项总表,对齐名称) | 截图文件名。
铁律:危险操作(删除/提交/发布)只截图不点击;信息以页面实际内容为准,查不到留空不编造。
```

跑通且清单质量合格后,再分批放量:**每批 ≤10 个页面**,分多轮跑完,避免上下文爆掉。

### 4.2 验收标准

- [ ] 截图文件真实存在且能打开
- [ ] 清单里每个操作项都能在页面/快照里找到对应
- [ ] "涉及配置项"与配置项总表名称对得上

---

## 5. 收尾:与人工初稿 diff(最有价值的一步)

让 ZCode 把页面功能清单 + 配置项总表,与你的产品能力初稿对照,输出 `docs/ai-generated/与初稿diff.md`,分三类:

1. **遗漏**:代码/页面有,初稿没有
2. **已下线或未上线**:初稿有,代码/页面找不到
3. **命名不一致**:同一个能力两边叫法不同

最终产出物清单:

```
docs/ai-generated/
├── 配置项总表.md
├── 页面功能清单.md
├── page-snapshots/*.png
└── 与初稿diff.md
```

---

## 6. 故障排查表

| 症状 | 可能原因 | 解法 |
|---|---|---|
| `npx` 拉包超时/403 | 网络白名单没放行 npm | 走 2.2 私服;都不行走 2.3 离线包 |
| MCP 显示 failed / spawn 失败 | Windows 下 npx 解析问题 | command 改 `cmd` + args 加 `"/c","npx"`;或离线写法(node.exe 直指 cli.js) |
| 浏览器起不来 | 机器没有 Chrome | args 用 `--browser msedge`(Edge 系统必带) |
| 页面打不开 | 没连 VPN/内网 | 先用本机浏览器手动打开测试环境确认可达,再让 AI 上 |
| 登录卡验证码 | 测试环境反自动化 | 找测试环境管理员要免验证码账号,或先关掉测试环境验证码 |
| AI 跑一半开始胡编 | 上下文过长/找不到来源 | 每批页面 ≤10;提示词里重申"查不到留空";要求每条标出处 |
| 配置项漏找 | 仓库地图不准 | 把已知的配置文件路径直接写进 AGENTS.md,再让 AI 顺藤摸瓜 |
| ZCode 插件市场打不开 | 网络受限 | 正常,放弃 2.0,走 2.1~2.3 |

---

## 7. 时间表(90 分钟版)

| 时间 | 动作 | 对应节 |
|---|---|---|
| 0:00-0:10 | 环境自检 + 确定安装路线 | 1 |
| 0:10-0:25 | 挂载 Playwright MCP 并验证 | 2 |
| 0:25-0:55 | 阶段一:配置文档生成 + 抽查验收 | 3 |
| 0:55-1:20 | 阶段二:第一批 3~5 页巡览 + 验收,合格则放量 | 4 |
| 1:20-1:30 | 与初稿 diff,收工 | 5 |
