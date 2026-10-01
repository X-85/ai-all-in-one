# Spring 演进路线

一句话版：**EJB 把"企业级 Java"做成了灾难片——写一个增删改查要一摞 XML 和三个接口；Rod Johnson 用一本三万行代码的书证明轻量容器加普通对象就够了。Spring 由此接管 Java 后端二十年，又在自己长胖之后用 Boot 完成自我革命——"约定优于配置"补上的那天，Java 才追回云时代的开发体验。**

> 类型：框架 | 生态：Java 企业后端（Spring 全家桶） | 诞生：2002 / 2004

姊妹篇：[JS-Node-TS演进路线](JS-Node-TS演进路线.md)、[Python演进路线](Python演进路线.md)、[Java演进路线](Java演进路线.md)、[Go演进路线](Go演进路线.md)、[Rust演进路线](Rust演进路线.md)、[Next.js演进路线](Next.js演进路线.md)、[Vue演进路线](Vue演进路线.md)、[React演进路线](React演进路线.md)、[C#演进路线](CSharp演进路线.md)、[C演进路线](C演进路线.md)、[C++演进路线](C++演进路线.md)、[SQL演进路线](SQL演进路线.md)、[Django-Flask-FastAPI演进路线](Django-Flask-FastAPI演进路线.md)、[Kafka演进路线](Kafka演进路线.md)、[MySQL演进路线](MySQL演进路线.md)、[Docker-K8s演进路线](Docker-K8s演进路线.md)。本文站在 Java 篇的下半场——语言守兼容，框架打天下；Boot 的"约定优于配置"与 Django-Flask-FastAPI 篇的 Rails 一脉同门；第三节的 AOT 编译则是"左移"手法（TS/Rust 篇）在 Java 的重演。命名走单名规则：Spring Boot 与 Spring 同爹同血脉，不链式（先例：Vite 与 Vue）。

配套速查（Initializr / mvn / spring-boot 命令）：[构建工具链速查](构建工具链速查.md)

## 一、EJB 之重与一本书的造反（2002-2004）

世纪之交的"企业级 Java"等于 J2EE 等于 EJB（Enterprise JavaBeans）：为了一个数据库表的增删改查，你要写 Home 接口、Remote 接口、部署描述符 XML、容器回调——业务逻辑被埋在规范的仪式里，单元测试近乎不可能，启动一次应用服务器慢到够泡茶。厂商们靠卖应用服务器（WebLogic、WebSphere）赚得盆满钵满，程序员苦 EJB 久矣。

2002 年，悉尼的顾问 Rod Johnson 出版《Expert One-on-One J2EE Design and Development》，随书附了三万行代码，论证一件事：**不需要 EJB，一个轻量 IoC 容器加普通 Java 对象（POJO）就能做企业开发**。2003 年这套代码开源为 Spring（寓意：J2EE 的寒冬之后的春天），2004 年出 1.0。两招打天下：

| EJB 的世界 | Spring 的世界 |
|------|------|
| 容器是厂商的重量级应用服务器 | 容器就是一个 jar，跟着你的程序跑 |
| 组件必须实现规范接口 | 普通 Java 对象（POJO），什么都不用实现 |
| 依赖自己 new / JNDI 查找 | **依赖注入（DI）**：容器把依赖送进门 |
| 事务、日志写死在业务代码里 | **AOP**：横切关注统一织入 |

IoC（控制反转）是灵魂：对象不自己创建依赖，而是声明"我需要什么"，容器装配注入——这就是著名的"别打电话给我们，我们会打给你"。可测试性由此而来：测试时注入一个假实现即可，不用启动整个应用服务器。呼应 Java 篇：**语言层守了兼容承诺，生态层的统治力正是由 Spring 这样的框架挣来的**。

## 二、家族化与配置之债（2004-2014）

Spring 长成家族：Spring MVC（Web）、Spring Security（认证授权）、Spring Data（持久化）、Spring Batch（批处理）……2.5（2007）引入注解驱动，3.0（2009）引入 Java 配置与 REST 支持。国内后端十年的默认栈 SSM（SpringMVC + Spring + MyBatis）就是这段的产物；企业世界里 Spring 之于 Java，渐渐逼近"没有之一"。

但债也在复利：**配置地狱换了东家**——applicationContext.xml 一屏一屏，一个 `DataSource` 要写半页 XML；依赖版本打架（"jar 冲突"是那十年 Java 面试必考）；"会配 Spring"本身成了工种。真正的刺激来自外部：2004 年 Ruby on Rails 用五分钟搭出一个博客（见 Django-Flask-FastAPI 篇），全程零配置——Java 社区被公开处刑了十年。

## 三、Boot 二次创业与云原生（2014-2025）

2014 年 4 月，Spring Boot 1.0 发布（Phil Webb、Dave Syer 主导）。名字直白：给 Spring 装个启动器。三件套重构了体验：

1. **Starter 起步依赖**：要 Web 就引一个 `spring-boot-starter-web`——该有的依赖与版本兼容性，官方替你配好；
2. **自动配置**：classpath 里有什么 jar，框架就按约定装配什么——"约定优于配置"（Rails 开创的手法）落地 Java；
3. **内嵌服务器**：Tomcat 打进 jar，`java -jar app.jar` 直接跑——部署单位从"WAR + 外部应用服务器"变成"一个 jar"。

代价与收益一体两面：默认约定替你做了大量决定（呼应 Next.js 篇——替你做决定的是框架）；不喜欢可以覆盖，但**先接受约定，再谈定制**。2015 年起的 Spring Cloud 把全家桶扩到微服务（注册发现、配置中心、熔断——早期骨架来自 Netflix OSS，2018 年 Netflix 停更后国内转向 Spring Cloud Alibaba 系）。最近的还债在云原生：JVM 启动慢与内存占用在 Serverless 时代是硬伤，Boot 3（2022，基线 Java 17）支持 GraalVM **AOT 编译成原生镜像**，启动从秒级到毫秒级——把运行时的工作提前到编译期，**"左移"手法（TS 的类型、Rust 的内存）在 Java 的第 N 次重演**。

## 四、还债：配置、分布式与启动时间（2007-2022）

1. **配置之债，三级台阶**：XML（2004-）→ 注解+Java Config（2007/2009）→ Boot 自动配置（2014）。Spring 的演进史本身就是一部还配置债的历史——每一代都在回答"上一代为什么这么难配"。
2. **微服务之债**：拆分带来分布式的全套病（服务寻址、熔断、链路追踪），Spring Cloud 开出一柜子药——**治拆分的药又长成新的学习曲线**。这与 K8s 篇"复杂度是还不完的债"是同一条规律在两个生态的显形。
3. **启动时间之债**：JVM"一次编写到处运行"换来的预热成本，在容器与 Serverless 时代被放大成短板；AOT/原生镜像是迟到的答卷，也让"JVM 必须 JIT"从真理变成选项。

## 五、三个必要词汇

- **IoC / DI（控制反转/依赖注入）**：对象声明依赖、容器装配注入，控制权从程序反转给容器。一切现代框架的标配动作（Angular/Vue 的注入器同宗），可测试性的根——没有 DI，mock 就无从注入。
- **约定优于配置**：框架给一套开箱即用的默认（端口、路径、装配规则），你只在偏离时才写配置。Rails 首创，Boot 落地 Java，Django/Next.js 同门。识别它你就识别了"为什么引个 jar 就能跑"。
- **Starter 与自动配置**：starter 是"版本对齐的依赖套餐"，自动配置是"按条件装配"（classpath 有 A 就配 A 的 bean）。两者合起来把"装什么、怎么配"从每个项目重复回答，变成框架按约定统一回答。

## 六、工程化：一个 Spring Boot 项目怎么构建和运行

```text
start.spring.io(或 IDE 内置 Initializr) → 勾选 Web/JPA 等 starter,生成 Maven/Gradle 骨架
./mvnw spring-boot:run            → 起开发服务器(内嵌 Tomcat,localhost:8080,改代码热重启配 devtools)
./mvnw clean package              → 打出可执行 fat jar(dependencies 全打进一个 jar)
java -jar target/app-1.0.jar      → 任何有 JVM 的机器直接跑(不再需要外部应用服务器)
curl localhost:8080/actuator/health → 生产体检(UP 即健康)
```

三个关键认知：

1. **骨架从 Initializr 来，别手搓**。pom 里的版本矩阵由 starter 对齐——自己拼依赖版本是上一个时代的工伤来源。这与 Next.js 篇"脚手架生成项目"是同一条行业共识。
2. **默认约定优先，覆盖而非重配**。端口 8080、配置在 application.yml、bean 按包扫描——先顺着约定走，需要偏离时用配置覆盖，不要上来就自定义一套结构。
3. **产物是可执行 jar**。部署形态从"WAR 丢进 Tomcat"变成"jar 交给 java"——这正好接 Docker-K8s 篇：jar 再打进镜像，就是"一次编写，容器里到处运行"。Java 篇的口号在容器时代反而更顺口了。

AI 验收三连：`spring-boot:run` 起来并 curl 通一个接口；`package` 出的 jar 用 `java -jar` 能独立跑；`/actuator/health` 返回 UP。

## 七、因果链小结

```text
EJB 之重:仪式化组件+厂商应用服务器,测试不可能         → Spring(2002/2004,IoC+POJO,一本书的造反)
家族化长成默认栈,但配置地狱换东家,Rails 公开处刑       → Boot(2014,starter+自动配置+内嵌服务器,约定优于配置)
微服务拆分引入分布式全套病                           → Spring Cloud(2015-),治拆分的药长成新学习曲线
JVM 启动慢在 Serverless 时代成为硬伤                 → Boot 3 + AOT 原生镜像(2022-),运行时工作左移到编译期
```

## FAQ

约定：这里的问答随实际疑问追加，每条回答控制在几句话内；问题来自真实使用中的困惑，不预设。

**Q1：Spring、Spring Boot、Spring Cloud 什么关系？**
Spring 是内核（IoC 容器+核心抽象）；Boot 是加速壳（自动配置+内嵌服务器，简化"用 Spring 起项目"）；Cloud 是分布式全家桶（在 Boot 之上补微服务治理）。新人直接从 Boot 入门，旧 Spring 的 XML 时代不必补课。

**Q2：Spring 和 Java 是什么关系？**
Java 是语言与运行时，Spring 是其上最大的应用框架家族——地位约等于"全家桶加强版 Django 之于 Python"（对照 Django-Flask-FastAPI 篇），但统治度高得多：Java 企业后端里"不用 Spring"反而是需要理由的选择。

**Q3：现在的 Spring 还要写 XML 吗？**
基本不用。2007 年起注解驱动、2009 年起 Java Config、2014 年 Boot 自动配置——三步把 XML 送进博物馆。老项目里见到 XML 是存量，不是新常态。

**Q4：微服务必须配 Spring Cloud 吗？**
不必。单体加模块化是大多数团队的正确起点；要拆时，K8s 本身已接管了不少治理（服务发现、扩缩），Spring Cloud 的定位随之收窄为"应用层治理"。国内存量以 Alibaba 系为主，新项目按需选。

**Q5：GraalVM 原生镜像是必须的吗？**
不是。常规部署下 JVM 的 JIT 峰值性能仍占优；原生镜像买的是**冷启动与内存**（Serverless、边缘、密集扩缩容场景）。Boot 项目保持"能 AOT"的代码习惯（少用运行时字节码魔法）即可，用不用随时可切。

---

注：Spring 与 Solon/Quarkus/Micronaut 的横向对比、Spring Security 与 OAuth2 实务、微服务拆分方法论，遵循"一篇文档只回答一个问题"的原则，另行成文，不混入本文。
