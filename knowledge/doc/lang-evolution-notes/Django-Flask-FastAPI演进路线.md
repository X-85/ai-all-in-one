# Django-Flask-FastAPI 演进路线

一句话版：**Python 写网站的三次回答——Django 把"一个新闻网站要的一切"打包成全家桶，Flask 反其道只给你一个微内核，FastAPI 再用类型标注与异步把 API 服务带进 AI 时代。三代框架接力，正好是 Python 从脚本语言长成服务端主力军的服役史。**

> 类型：框架（Python Web 三代） | 生态：Python 服务端（AI 应用 API 底座） | 诞生：2005 / 2010 / 2018

姊妹篇：[JS-Node-TS演进路线](JS-Node-TS演进路线.md)、[Python演进路线](Python演进路线.md)、[Java演进路线](Java演进路线.md)、[Go演进路线](Go演进路线.md)、[Rust演进路线](Rust演进路线.md)、[Next.js演进路线](Next.js演进路线.md)、[Vue演进路线](Vue演进路线.md)、[React演进路线](React演进路线.md)、[C#演进路线](CSharp演进路线.md)、[C演进路线](C演进路线.md)、[C++演进路线](C++演进路线.md)、[SQL演进路线](SQL演进路线.md)、[Spring演进路线](Spring演进路线.md)、[Kafka演进路线](Kafka演进路线.md)、[MySQL演进路线](MySQL演进路线.md)、[Docker-K8s演进路线](Docker-K8s演进路线.md)。链式命名（先例 JS-Node-TS）：三个主角不同爹、不同年，却是一条因果链上的三次回答。本文站在 Python 篇的下半场——语言生态成熟后，框架层如何接棒；FastAPI 的类型契约呼应 JS 篇的 TS（错误左移），全家桶与微内核之争则与 Spring 篇的 Boot 互为注脚。

配套速查（django-admin / flask / fastapi 命令）：[构建工具链速查](构建工具链速查.md)

## 一、Django：报社里的全家桶（2003-2005）

千禧年后的 Python Web 世界是拼装车间：各自选模板引擎、ORM、路由库再手工组装。堪萨斯州《劳伦斯日报世界》的两个程序员 Adrian Holovaty 和 Simon Willison 被这件事折磨了两年——报社网站的需求（文章、图库、专题、归档）高度重复，每换一次排版工具就重写一遍。

2005 年他们把报社内部系统开源，命名 Django（吉普赛爵士吉他手 Django Reinhardt——能在一无所有里玩出花）。哲学一句话：**有主见的全家桶（batteries included）**——ORM、模板、表单、认证、Session、还有杀手锏 **Admin 后台**：数据模型定义好，管理界面自动生成。口号"为完美主义者准备的、赶得及截止日期的框架"精准打击报社："编辑部明天就要个新专题页"。

它的成功与争议同源：全家桶让你起飞快，也让你按它的规矩来（MTV 结构、自带 ORM）。这条路线与 Spring 篇的家族化殊途同归——**大而全是企业默认态，无论 Java 还是 Python**。多年后的注脚：Instagram 以全球最大的 Django 站点之一证明这套"全家桶"扛得住十亿级用户。

## 二、Flask：反全家桶的微内核（2010）

全家桶用久了，反弹必然出现：小工具、内部 API、原型验证，只需要"接住 HTTP 请求"这一件事，凭什么都替我决定？2010 年 4 月 1 日，Pocoo 社区的 Armin Ronacher（模板引擎 Jinja2、工具库 Werkzeug 的作者）发布了 Flask——原本是个愚人节玩笑（"看，我也能几行代码写个框架"），结果认真长了十年。

微框架只给三样：路由、请求/响应对象、开发服务器。其他一切（ORM、表单、登录、迁移）通过**扩展**自选拼装。"Hello World"三行：

```python
from flask import Flask
app = Flask(__name__)
@app.route("/") ... 
```

代价随后就来：**每个 Flask 项目的目录结构都不一样**——自由是税，结构、选型、版本组合全自己负责。它把"全家桶 vs 微内核"这道选型题摆上了每个 Python 团队的桌面（Spring 篇的 EJB 之重与本文的全家桶之重，是一枚硬币的两面：重有重的痛，轻有轻的税）。Flask 的历史地位：给 Python 圈普及了"框架可以只是一层薄纸"这个观念，也为下一代铺了路。

## 三、FastAPI：类型与异步的合流（2018）

2018 年底，Sebastián Ramírez（tiangolo）发布 FastAPI——站在两块巨人肩膀上：Starlette（异步 Web 内核）与 Pydantic（数据校验库）。它把 Python 那两年最关键的两大进化拧成了框架的卖点：

1. **函数签名即 API 契约**。参数写类型标注，框架据此自动**校验**（参数错在进函数前就被 400 拦下）并自动**生成文档**（`/docs` 交互式 OpenAPI 文档）。这是 TS 篇"类型左移"的服务端版：**错误拦在请求进门之前**——Python 3 的类型标注（Python 篇的 3 时代收获）第一次成为 Web 开发的一等生产力。
2. **异步 IO 成为默认选项**。`async def` 路由直接消费 asyncio 生态（Python 3.5，2015），IO 密集场景（查库、调外部 API、等 LLM 响应）的吞吐与传统同步栈拉开身位——WSGI 时代（同步网关协议，2003 年的标准）攒了十五年的债，由 ASGI 这代新插座还掉。

AI 时代它成了最大赢家：LLM 应用的 API 服务、RAG 系统的对外接口，教程与模板几乎默认 FastAPI——**Python 在 AI 帝国（Python 篇）的位置，服务端出口就是它**。它没取代前两代：内容站用 Django，胶水服务用 Flask，API 用 FastAPI——三代各守一摊。

## 四、还债：异步，三家共同的十五年旧账（2019-2022）

Python Web 最大的共同欠账是**异步**：WSGI 协议生来同步，一个 worker 进程同一时刻只伺候一个请求，IO 密集（数据库、外呼）时线程整段干等。asyncio 成熟后，三家先后补课，节奏最能说明性格：

- **Django**：3.0（2019）接入 ASGI，先通视图与中间件，ORM 的异步支持至今仍在半路——全家桶的债最多，还得最慢（对照 Vue 篇 2→3 并轨五年）；
- **Flask**：2.0（2021）官方支持 `async def` 视图（底层仍转同步调度）——微内核的债少，动作也轻；
- **FastAPI**：生而异步，无债一身轻——新框架的优势从来不是更聪明，是**生得晚**。

## 五、三个必要词汇

- **WSGI / ASGI**：Python Web 框架与服务器之间的插座标准。WSGI（2003）同步一生，ASGI（2017 前后）异步当立——三代的接线史都绕不开它。类比：框架是电器，插座换了，电器跟着换代。
- **全家桶 vs 微内核**：Django 式"都替你定了"起步快、上限受约定束缚；Flask 式"只给一层纸"自由、结构自担。没有赢家，只有场景——这道题在 Java（Spring）、JS（Next.js vs Express）每个生态都要重答一遍。
- **类型标注即契约**：FastAPI 的立身之本——函数签名声明"我收什么、发什么"，校验、文档、（IDE）补全全部自动派生。"左移"手法在 Web 层的完整落地：参数错误死在门外，不进业务。

## 六、工程化：三个框架各怎么构建和运行

三代各一行流程（Python 工程的公共前置：venv/uv 虚拟环境，见速查表 Python 行）：

```text
Django:  django-admin startproject mysite → python manage.py migrate(自带 ORM 迁移) → runserver(自带开发服+Admin 后台)
Flask:   三行起步(上面第二节) → flask --app hello run --debug → 结构自定,常配 Blueprint 分模块
FastAPI: fastapi dev main.py → http://127.0.0.1:8000/docs 自动交互文档(招牌) → 生产 uvicorn/gunicorn+uvicorn worker
```

三个关键认知：

1. **选型三问就够**：做内容站/要后台管理 → Django（Admin 白送）；小服务/胶水/原型 → Flask；对外 API、AI 服务、要文档 → FastAPI。三者在同一个 Python 工程里共存也常见。
2. **FastAPI 的 `/docs` 不是装饰，是契约**。前后端与 AI 联调从这份自动文档开始；签名改了文档跟着变——"文档过期"这类事故在这里结构性消失（呼应"类型即契约"）。
3. **异步要用在刀刃上**。`async def` 只对 IO 密集（查库、外呼、等 LLM）有收益；CPU 密集任务该进进程池，写错地方反而更慢。默认同步、热点再 async，是稳妥顺序。

AI 验收三连（以 FastAPI 为例）：`fastapi dev` 起服务；`/docs` 里发出一个请求得到响应；传一个类型不符的参数，收到 422 而不是进函数后才炸。Django/Flask 同理各验：起服务、跑通一个路由、看到各自的默认行为（Admin 登录页 / debug 页）。

## 七、因果链小结

```text
报社网站需求重复,拼装车间太苦                    → Django(2005,全家桶+Admin,有主见的默认)
全家桶的税:小事也要按它的规矩                   → Flask(2010,微内核+扩展,自由与结构自担)
类型标注(3 时代)与 asyncio(3.5)成熟              → FastAPI(2018,签名即契约+异步,AI 服务默认底座)
WSGI 同步攒了十五年的 IO 债                     → 三家先后补异步:Django 3.0(2019)/Flask 2.0(2021)/FastAPI 生而异步
```

## FAQ

约定：这里的问答随实际疑问追加，每条回答控制在几句话内；问题来自真实使用中的困惑，不预设。

**Q1：学 Python Web 该从哪个开始？**
按目标倒推：做 AI 应用/API 服务 → FastAPI（当前回报最高）；做完整网站/内部系统 → Django（Admin 省一个后台前端的工）；理解原理/写小工具 → Flask（薄到能看穿"Web 框架"到底是什么）。先语言（Python 篇）后框架的顺序不变。

**Q2：Django 老了吗，还值得学吗？**
"老"不等于出局：Instagram 仍在重度使用，内容管理类需求它仍是效率之王。新项目若主要是 API，多选 FastAPI——这不是 Django 的失败，是场景分化（三代分工一节）。

**Q3：Flask 和 FastAPI 名字像，是一家的吗？**
不是。Flask 出自 Armin Ronacher（Pocoo），FastAPI 出自 Sebastián Ramírez，底层用的是 Starlette+Pydantic。共同点只有：都是 Python Web 框架、都以"轻"为起点——FastAPI 多还带上了类型与异步两张新牌。

**Q4：`async def` 什么时候用？**
请求处理里要等外部 IO（数据库、HTTP 外呼、LLM 生成）→ 用，吞吐显著提升；纯 CPU 计算 → 不用（还可能更慢），要并行扔进程池。判断口诀：在等别人 → async；自己在算 → 同步/进程池。

**Q5：为什么 FastAPI 能自动生成文档，Django 要手写？**
因为契约的来源不同：FastAPI 把类型标注当契约，文档从签名派生，天然同步；Django 时代类型标注还不存在，契约只能靠手写文档维护——"文档过期"是手写契约的必然病，不是谁懒。

**Q6：FastAPI 算语言吗？**
不算，是框架——三代主角都不是语言。写的仍是纯 Python（装饰器 + 类型标注），没有自己的语法和编译器，跑在 CPython 上；三层模型里它在框架层，底下是 Python 语言层与运行时层（判定先例：Next.js / React / Vue 篇的同名 FAQ）。它"像语言"是因为行话密（路径装饰器、Pydantic 模型、async def），但那是框架 API 不是语法——写错只是不生效或抛 Python 的错，不存在"FastAPI 编译不过"。

---

注：Django/Flask/FastAPI 与 Express/NestJS 的跨生态对比、SQLAlchemy 2.0 异步实务、Django Admin 深度定制，遵循"一篇文档只回答一个问题"的原则，另行成文，不混入本文。
