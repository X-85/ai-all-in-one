# C# 演进路线

一句话版：**Java 攻城略地，微软想要自己的 Java 却被授权掐灭，于是请来 Delphi 之父造了 C#；语言一路激进迭代、多处领先行业，平台却锁死 Windows，直到 Windows 失势，才靠开源跨平台赎回第二条命。**

> 类型：语言 | 生态：企业开发（微软系）+ Unity 游戏 | 诞生：2002

姊妹篇：[JS-Node-TS演进路线](JS-Node-TS演进路线.md)、[Python演进路线](Python演进路线.md)、[Java演进路线](Java演进路线.md)、[Go演进路线](Go演进路线.md)、[Rust演进路线](Rust演进路线.md)、[Next.js演进路线](Next.js演进路线.md)、[Vue演进路线](Vue演进路线.md)、[C演进路线](C演进路线.md)、[C++演进路线](C++演进路线.md)、[SQL演进路线](SQL演进路线.md)。与 Java 篇互为镜像——同宗出身、缠斗二十年；而 JS 篇里 TS 的设计者 Anders Hejlsberg，正是 C# 之父。

配套速查（dotnet/NuGet 等工具命令）：[构建工具链速查](构建工具链速查.md)

## 一、Java 之争的产物（1995-2002）

1995 年 Java 横空出世，"一次编写、到处运行"直奔企业市场（Java 篇讲过这条线）。微软的应对是 Visual J++：给 Java 加 Windows 专属扩展，让程序离开 Windows 就跑不了——Sun 1997 年起诉违约，2001 年和解，微软逐步停产了自己的 Java 实现。

被掐灭之后，微软决定造自己的：2000 年发布 .NET 战略，连同新语言 C#。主持人是 1996 年从 Borland 请来的 Anders Hejlsberg——Turbo Pascal 和 Delphi 的架构师（十二年后他还会再造一门语言 TypeScript，见 JS 篇）。2002 年初，C# 1.0 随 .NET Framework 1.0 发布，第一眼几乎是"微软版 Java"：

| Java 的设定 | C# 的对应 |
|------|------|
| 源码编译到字节码 | 编译到 IL 中间语言 |
| JVM 执行 | CLR（公共语言运行时）执行 |
| GC + JIT | 一样 |
| 跨一切平台 | **只跨 Windows 家族** |

最后一行是全部差别：Java 的承诺是"任何系统"，微软的承诺是"任何 Windows"。此后十年两家在企业市场对峙，像同宗两支分了家的房系。

## 二、语言快跑（2002-2012）：LINQ 与 async/await

对峙之下走了两条路：Java 守兼容、迭代保守（Java 篇的"兼容神话"），C# 迭代激进，几乎每版都领先半步：

- **C# 2.0（2005）**：泛型，且类型信息在运行时真实保留——Java 2004 年的泛型靠"类型擦除"妥协，C# 在 CLR 层真做了；
- **C# 3.0（2007）**：**LINQ**——查询语法直接进语言，`list.Where(x => x.Age > 18).Select(...)`，lambda 表达式随之进入主流企业开发。函数式风格第一次大规模进入"用 Windows 写企业软件的人群"；
- **C# 5.0（2012）**：**async/await**——异步代码写起来像同步（灵感部分来自同门 F# 的异步工作流）。这是这个语法的行业首创，此后 JavaScript、Python、Swift、Rust 全部跟进——今天满世界的 async/await，源头在这里。

所以别把 C# 当"Java 跟班"：现代语言最普及的两样东西——LINQ 式流式 API 与 async/await——都是它先做出来的。

## 三、开源赎身（2014-2016）：.NET Core

问题出在平台。.NET Framework 深度焊死在 Windows：移动时代 iPhone/Android 起来，服务器是 Linux 的天下，.NET 开发者守着 Windows 眼看机会流失。民间先造反——Miguel de Icaza 2004 年起做开源的 Mono，在 Linux 上硬跑 .NET（这剧情和 Java 篇"配置地狱逼出 Spring 民间造反"同款），后来演成 Xamarin，2016 年被微软收编。

2014 年风向大转：新 CEO 纳德拉喊出"Microsoft ❤ Linux"，正殿开源——**.NET Core**（2016 年 1.0）：MIT 协议、跨平台、模块化、性能对标一切。2020 年 .NET 5 统一品牌接棒，旧 .NET Framework 停在 4.8，进入"随 Windows 维护到永远"的养老状态——兼容哲学表又添一行：Python3 敢断痛十二年 / Go1.0 承诺兼容 / ES6 只加不断 / Java 1996 至今最强 / **.NET Framework 4.8 永不下岗**。

赎身之后 .NET 成了正常的跨平台技术：Linux 服务器上的 ASP.NET Core、CLI 工具（dotnet 自己就是）、外加一个意外帝国——**Unity 用 C# 做游戏脚本语言**，游戏开发这大片生态归了 C#。语言本体一年一版随 .NET 滚动（偶数版 LTS）；C# 8（2019）的可空引用类型，把"空引用"这个十亿美元错误从运行时炸左移成编译期警告——和 TS 左移类型错误、Rust 左移内存错误是同一手法（见两篇姊妹篇）。

## 四、三个必要词汇

- **C# / .NET / CLR**：C# 是语言；.NET 是平台（类库+运行时+工具整套）；CLR 是平台里的执行引擎（GC + JIT）。编译产物是 IL 中间语言，CLR 现场 JIT——"一次编译到 IL，处处 JIT"，与 Java 的字节码+JVM 同一思路，呼应 Java 篇。
- **async/await**：异步语法糖——写起来是顺序代码，编译器改写成状态机。2012 年 C# 首创，现已是主流语言标配；看到它要知道出处是这里。
- **NuGet**：.NET 的包管理器，中央仓库 nuget.org，`dotnet add package` 一条命令装依赖——npm/cargo 在 .NET 世界的对应物。

## 五、工程化：一个 C# 项目怎么构建和运行

```text
dotnet new console -n MyApp → 脚手架(还有 webapi/web/classlib 等模板)
dotnet add package Xxx    → 加 NuGet 依赖(写进 .csproj)
dotnet run                → 编译+运行一步(开发)
dotnet build              → 编译(必经,run 内置)
dotnet test               → 跑测试(xUnit/NUnit)
dotnet publish            → 出发布产物,可自包含(连运行时打包,目标机免装)
```

三个关键认知：

1. **.csproj 是清单，SDK 风格后极简**。老版 XML 动辄几百行，2016 年后的 SDK 风格十几行——看到 .csproj 就知道是 .NET 项目，依赖和目标框架都在里面。
2. **编译必经，但 `dotnet run` 一步完成**（同 cargo run / go run 的体验），不是老牌"先 msbuild 再跑"的两段式。
3. **AI 验收三连**：`dotnet run` 跑通、`dotnet build` 无错、`dotnet test` 过。Web 项目 `dotnet new webapi` 再 `dotnet run` 即起服务——ASP.NET Core 之于 .NET，就是 Next.js 之于 JS 那一层的框架。

## 六、因果链小结

```text
Java 攻企业市场,微软自研 Java 被授权掐灭 → 有了 C#(2000-2002,CLR 版 Java,锁 Windows)
Java 守兼容,C# 激进迭代               → LINQ(2007)与 async/await(2012)成为行业源头
移动+云时代 Windows 失势,.NET 被锁死    → 开源赎身 .NET Core(2014-2016),跨平台 + Unity 帝国
```

## FAQ

约定：这里的问答随实际疑问追加，每条回答控制在几句话内；问题来自真实使用中的困惑，不预设。

**Q1：.NET 和 C# 是一回事吗？**
不是。C# 是语言，.NET 是平台；平台上还住着 F#、VB.NET，它们都编译到 IL、都在 CLR 上跑——多语言共享一套运行时，这是 .NET 设计之初的架构。

**Q2：.NET Framework 和 .NET Core / .NET 5+ 什么关系？**
新旧两条线。Framework（2002-2019）只跑 Windows、闭源，停在 4.8 养老；Core（2016 起）开源跨平台，2020 年起改名 .NET 5 接棒，现在一年一版。新项目一律 .NET 5+ 线。

**Q3：C# 只能写 Windows 程序吗？**
早不是。开源后 Linux 服务器、macOS、CLI、Web 全覆盖；最大的跨平台场景反而是游戏——Unity 的脚本语言就是 C#。

**Q4：C# 和 Java 长得这么像，学哪个？**
语法同宗（都继承 C 的花括号传统），概念互通度高，先学哪个另一个都便宜。差别在生态取向：Java 生态更跨厂商，C# 与微软系（Azure/Visual Studio/Unity）咬合更紧。

**Q5：可空引用类型是什么，为什么重要？**
C# 8（2019）起的编译期检查：引用默认"不应为空"，可能为空的要标 `?`。空指针异常从运行时炸变成编辑器画线——TS/Rust 同款"错误左移"。

---

注：与 Java 的详细对比、ASP.NET Core 框架深入，遵循"一篇文档只回答一个问题"的原则，另行成文，不混入本文。
