# React 演进路线

一句话版：**界面复杂度爆炸的年代，手改 DOM 跟不上 Facebook 的体量——React 把 UI 变成"状态的函数"：数据变了就整棵重新描述，虚拟 DOM 兜住性能；又因为只做视图层这一件事，渲染器可以换（浏览器、手机、服务器），其余决定全留给生态——自由归生态，债也归生态。**

> 类型：库（视图层） | 生态：前端视图层事实标准（npm） | 诞生：2013

姊妹篇：[JS-Node-TS演进路线](JS-Node-TS演进路线.md)、[Python演进路线](Python演进路线.md)、[Java演进路线](Java演进路线.md)、[Go演进路线](Go演进路线.md)、[Rust演进路线](Rust演进路线.md)、[Next.js演进路线](Next.js演进路线.md)、[Vue演进路线](Vue演进路线.md)、[C#演进路线](CSharp演进路线.md)、[C演进路线](C演进路线.md)、[C++演进路线](C++演进路线.md)、[SQL演进路线](SQL演进路线.md)。本文与 Next.js 篇、Vue 篇构成前端三部曲：React 出题（怎么画界面），Next.js 收走它的工程决定，Vue 是它的镜像对手（模板路线）；声明式的灵魂则与 SQL 篇同源——说"要什么"，不说"怎么做"。

配套速查（Vite 模板 / CRA 退役说明）：[构建工具链速查](构建工具链速查.md)

## 一、Facebook 的界面死结（2011-2013）

2011 年前后的前端，写界面就是"手动同步"：数据变了，记得亲手改 DOM。jQuery 把这活干熟练了，但 Facebook 体量的界面（动态、广告、聊天）状态成百上千，谁在哪儿改了 DOM 查不清——不是写不出来，是**改不动了**。

React 的家谱在 Facebook 内部：2010 年工程师把服务端的 HTML 组件化做成 PHP 扩展 **XHP**（组件拼界面，安全转义）；2011 年 Jordan Walke 受其启发做 JS 实验 **FaxJS**；2012 年成熟的版本在 Facebook 内部投产（广告与动态界面）；2013 年 5 月在 JSConf US 开源，取名 React。

首秀被群嘲：`JSX` 把 HTML 写进 JS，"违反关注点分离"——分离模板与逻辑曾是铁律；"数据一变就整棵重画？疯了吧"。Pete Hunt 的回应成了范式宣言（*Rethinking Best Practices*）：**该分离的是关注点，不是技术**——一个组件的结构与逻辑本就是同一个关注点，硬拆成两个文件才是笑话。核心思想一句话：**UI = f(state)**——界面是状态的函数，状态变了框架重新算出该长的样子，怎么改 DOM 是框架的事。对照当时的 Angular 双向绑定：React 只走单向——数据流向清晰可追踪。

## 二、范式胜利与渲染器帝国（2013-2016）

**虚拟 DOM 让"整棵重画"可承受。** 描述与真实 DOM 之间放一层 JS 对象树，重画时先 diff 新旧对象树、只把差异落到真 DOM。声明式从此不再为性能道歉——Vue 2 引入虚拟 DOM（Vue 篇第二节）、Angular 2 重写转向组件化，都是这条范式的注脚。

**Flux / Redux：数据流的决定由生态先做。** 2014 年 Facebook 公开一个线上事故的复盘：聊天角标错乱，根源是双向绑定让数据流不可追踪——由此提出 Flux 架构（单向数据流）。2015 年 Dan Abramov 把它与 Elm 的思想合并简化成 **Redux**，从此"状态管理"成为 React 生态的独立城邦。注意这个分工：React 本体不收状态管理，**库不做决定，生态做**。

**React Native（2015）：渲染器帝国的第一块版图。** React 的真身不是"DOM 操作库"，是一份**界面描述**——那渲染器凭什么只能是浏览器？2015 年 React Native 登陆 iOS（同年 Android）：写的是 React，渲染到原生控件，JS 与原生之间走桥接。"Learn once, write anywhere"。这是 JS 篇"语言不等于场景"的框架版：**描述不等于渲染**——同一份组件描述，宿主可以换。

同一时期 Angular 1 崩塌（2014 年宣布 Angular 2 重写且不兼容，真空两年），大批用户迁向 React；到 2016 年，React 已是前端视图层的事实标准。

## 三、Fiber 重写与 Hooks（2016-2019）

两个死结逼近。

**1. 渲染不可中断。** 原协调器是栈式递归：diff 一棵大树一口气跑完，中途不能停、不能插队——动画掉帧、输入卡顿，低优先级的大更新堵住高优先级的小交互。React 16（2017-09）交付 **Fiber**：协调器彻底重写为链表式的可中断工作单元，可分片、可优先级调度。用户视角 API 几乎不变——"外壳不变，换内核"（速查表规律），这次换是为了给并发渲染铺路。

**2. 类组件的逻辑复用靠嵌套。** 有状态逻辑想跨组件复用，只有高阶组件、render props 两招，层层包裹成"嵌套地狱"；生命周期又按"时机"（mount/update）切散逻辑，同一功能的代码散落各处；`this` 的心智包袱雪上加霜。2018 年 11 月 React Conf 公布 **Hooks**（争议极大），2019 年 2 月 16.8 转正：`useState` 声明状态、`useEffect` 声明副作用，函数组件一统天下，逻辑复用就是抽一个自定义函数。同年 Vue 定稿 Composition API（Vue 篇第三节）——两大框架在"按功能组织代码"上殊途同归。

## 四、并发长跑与服务器回归（2018-2026）

React 后半程的节奏是"研究驱动、发布缓慢"——特性从公布到转正常以年计，社区戏称永远在 beta；但每次转正都定一次行业方向。

- **并发渲染转正（React 18，2022-03）**：Suspense 2018 年就公布，配套的数据获取版熬到 18 才齐——`useTransition` 让低优先级更新可被插队，自动批处理，基于 Suspense 的流式 SSR。Fiber 重写（2017）到此刻才兑现完。
- **Server Components（2020-12 公布，2023 RFC，随 React 19 时代落地）**：组件直接跑在服务器，只把需要交互的部分发往浏览器。Next.js 篇讲了框架侧（App Router），这里是库侧：React 的渲染器帝国添了最后一个宿主——**服务器本身**。而家谱里最有戏剧性的一幕在此：React 的祖师爷 XHP（2010）本来就是服务端组件——绕了十三年，回家的路是 Next.js 铺的。
- **React 19（2024-12）**：Actions（表单直调服务器函数）、`use()`、不再需要 `forwardRef`。
- **React Compiler（2023 公布，2025 RC）**：自动记忆化——`useMemo`/`useCallback` 十年手动优化债，交给编译器还。与 Vue 的 Vapor Mode（Vue 篇第四节）同一大势：编译器吃掉运行时的活。

## 五、三个必要词汇

- **V = f(state)（声明式 UI）**：界面是状态的函数——不说怎么改 DOM，只说"这个状态下界面长什么样"，diff 与更新交给框架。三大框架的公约数、React 的原版贡献（配虚拟 DOM 让它可承受）。灵魂与 SQL 同源：说"要什么"，不说"怎么做"（SQL 篇第一节）。
- **虚拟 DOM 与渲染器**：虚拟 DOM 是"界面描述"的中间表示，付出内存与 diff 的代价，换来两件事：写法自由（随时整棵重算）与**渲染器可换**（react-dom / React Native / SSR / Server Components）。Vue 2 借它起家，Svelte 与 Vue Vapor 用编译器绕开它——它是"运行时通用"与"编译时精确"两条路线的分叉点。
- **Hooks**：用函数组织与复用有状态逻辑——`useState` 状态、`useEffect` 副作用、自定义 Hook 即复用单元。最常被误解的是 `useEffect`：它声明的是"与外部系统保持同步"，不是生命周期清单；依赖数组是同步的输入，漏了就是 bug。2019 年与 Vue 组合式 API 同构，前端两种范式在此合流。

## 六、工程化：一个 React 项目怎么构建和运行

演进讲完，补实务：如今用 React（库路线，Vite 方案）从零到跑起来，标准动作是——

```text
npm create vite@latest my-app -- --template react-ts → Vite 官方 React 模板(不要 TS 用 react 模板)
npm install       → 装依赖
npm run dev       → Vite 开发服务器 localhost:5173,热更新
npm run build     → 产出 dist/ 纯静态文件(必经)
npm run preview   → 本地静态服务器预览生产构建
npm test          → 模板默认不配,自行加 vitest
```

三个关键认知：

1. **官方脚手架已经让位**。create-react-app（CRA）曾是数年官方标准，2023 年官宣退役、文档下架——官方"新建 React 项目"第一推荐是 Next.js（库的配置层被框架收编，Next.js 篇第五节的实锤），纯 SPA 用 Vite 模板。AI 生成项目若给出 `react-scripts` 的 CRA 骨架，要求换成 Vite 或 Next.js。
2. **库的边界要认清**。React 本体不含路由、取数、构建：纯 SPA 配 react-router；要文件路由、SSR、全栈，升级 Next.js（对照 Vue 世界：Vue → Nuxt）。`dist/` 是纯静态，任何静态服务器、CDN 都能伺候。
3. **JSX 必须经过编译**。浏览器不认 JSX——报 `Unexpected token <` 是没编译，不是代码写错。TS 项目配 `jsx: "react-jsx"`，生产翻译由 Vite 内置的 esbuild/SWC 完成（"外壳不变，换内核"的又一处）。

AI 验收三连：`npm run dev` 起来打开 5173 端口；改 `App.tsx` 一行看热更新；`npm run build && npm run preview` 过生产构建。测试默认不带，要验收测试先让 AI 配好 vitest。

## 七、因果链小结

```text
Facebook 级界面,手改 DOM 追不上状态复杂度          → React 开源(2013,V=f(state),vdom 兜底,JSX 被嘲后成范式)
双向绑定数据流不可追踪,界面描述本可跨端            → Flux/Redux 单向数据流(2014-2015)+ React Native 渲染器可插拔(2015)
栈式渲染不可中断,类组件逻辑复用靠嵌套              → Fiber 重写(2017)+ Hooks(2019,按功能组织,Vue 同年同归)
工程决定留给生态,配置地狱与决策疲劳                → 生态收敛:CRA 退役,Next.js 收编决定(2016→),Vite 收编构建(2020→)
渲染调度十年长跑,祖师爷 XHP 思想回归               → 并发转正(2022)+ Server Components(2020-2024)+ Compiler 自动还优化债(2025)
```

## FAQ

约定：这里的问答随实际疑问追加，每条回答控制在几句话内；问题来自真实使用中的困惑，不预设。

**Q1：React 和 Vue 怎么选？**
Vue 篇 Q1 答过，这里给 React 视角：更贴 JS/TS 本体（JSX 就是 JS 表达式），生态与岗位数量最大，跨端有 React Native；Vue 模板上手平缓、渐进式、中文生态强。技术差异没有传言那么大，实际常落在团队存量与就业市场。

**Q2：先学 React 还是直接学 Next.js？**
先学 React 的组件、props、hooks——Next.js 全部建立在其上；但 Next.js 的地基认知（组件默认跑在服务器）是 React 入门教程不讲的，见 Next.js 篇第三、五节。直接从 Next.js 入门也可行，补 React 基础即可。

**Q3：create-react-app 还能用吗？**
不能。2023 年官方宣布退役并从文档下架，新项目两个方向：纯 SPA 用 Vite 的 react 模板，要全栈用 Next.js。老 CRA 项目建议迁移；AI 若生成 CRA 骨架（`react-scripts`），直接要求重换。

**Q4：React Native 是网页套壳吗？**
不是。渲染到原生控件（不是 WebView），JS 与原生之间靠桥接（后演进为 JSI 直调）。它是"渲染器可插拔"的第一次证明：写的是 React，宿主换掉了。

**Q5：class 组件还要学吗？**
读老项目认得即可。新代码一律函数组件 + Hooks；面试考 class 生命周期多为考历史。

**Q6：React 算语言吗？算框架吗？**
都不算。写的是 JS/TS（JSX 是 JS 的语法扩展，由编译器翻译，框架自带编译能力不等于语言）；它连框架都算不上——不收路由、不收构建、不收取数，官方自称 library。三层模型里它与 Vue 同在视图层，Next.js 才是它上面的框架层。

**Q7：useState 之外，状态管理该用什么？**
库不做决定，所以选项最多：小项目 Context + useReducer，大了 Redux Toolkit / Zustand / Jotai 按规模与口味选。这条 FAQ 本身就是"决定归生态"的活例子——对照 Next.js 把这些决定收进框架的路线。

---

注：与 Vue / Angular / Svelte 的横向对比、状态管理选型深入、React Native 与跨端方案，遵循"一篇文档只回答一个问题"的原则，另行成文，不混入本文。
