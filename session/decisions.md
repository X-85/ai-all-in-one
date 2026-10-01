# 长期有效约定(decisions)

新会话写语言演进文档前必读本文件。

## 1. 文档模板(分层:不变件+按类型可变件,2026-09-16 定)

文件位置:`knowledge/doc/lang-evolution-notes/<X>演进路线.md`

不变件(任何类型照此,共同回答"形成过程、背景、解决什么问题"):
1. 标题 + 一句话版因果链(粗体)
2. 姊妹篇链接(指到其余几篇)
3. 一~三节:演进主体,每节"背景→问题→为什么诞生",节点年份
4. 四(或穿插):现代化补课/还债
5. 三个必要词汇(精选实用概念,不是名词堆砌)
6. 工程化:命令流程图(text 代码块)+ 三个关键认知 + AI 默认骨架与验收三连(骨架不变,口径按类型)
7. 因果链小结(text 代码块,箭头图)
8. FAQ:约定"随实际疑问追加,每条几句话";用对话中用户真实问过的问题做种子
9. 结尾注:与对比/深入主题"另行成文"

按类型可变件(先例:Redis 篇中间件 / Docker-K8s 篇平台):
- 工程化口径:语言/框架=「一个 X 项目怎么构建和运行」;中间件=「一个 X 服务怎么跑起来和正确使用」(安装→起服务→验活→上线必配项);平台=「一个应用怎么容器化并跑起来」(镜像→容器→声明式部署,先例 Docker-K8s 篇)
- 核心接口呈现:中间件把数据模型当"核心特性",在第一幕诞生处内嵌小表(结构→一句话用途,先例 Redis 数据结构/Kafka 分区与 offset),不新增模板小节;语言/框架篇无此项
- 速查表联动:工具成型的框架/平台加行并附速查链接(先例 Next.js/Vue/React、Spring/Django-Flask-FastAPI/Docker-K8s);中间件不加行不加链接(Redis/Kafka/MySQL)

## 2. 命名规则

- 默认单名:`X演进路线.md`(一个语言的传记)
- 仅当一次演进诞生多个主角时用链式命名:`JS-Node-TS演进路线.md`
- 判断标准:链上是否有多个"各自诞生"的东西(不同爹、不同年份)
- 转写例外(2026-09-16 定):文件名勿用 `#`——Astro glob loader 用 URL 拼路径,`#` 被当锚点,文件读不到、页面静默缺失;C# 篇文件名为 `CSharp演进路线.md`(标题/侧栏/链接文字仍显示 C#);`+` 已验证无害

## 3. 内容原则

- 一篇文档只回答一个问题;文档间不融合内容,只加姊妹篇链接
- 演进主体只讲"为什么诞生";构建实务放工程化小节
- 讲事实不编造:年份/事件需可靠(本系列使用的史实已经过讨论校准)
- 跨文档呼应手法:兼容哲学表(Python3 敢断痛十二年 / Go1.0 最早承诺 2012 / Rust1.0 2015 / ES6 只加不断 / Java 1996 至今最强 / Vue 2→3 并轨五年)、"错误左移"(TS 类型错/Rust 内存错)、"生态帝国"(Python=AI、Go=云原生、Java=企业+Android、JS=前端、Rust=工具链内核)
- 分类标注(2026-09-16 定,同日改为全量):文件名不加类别后缀,保持 `<X>演进路线.md`;每篇在一句话版之后加标签行 `> 类型:X | 生态:X | 诞生:年份`——类型=语言/框架/中间件/库/平台(中间件 2026-09-16 随 Redis 篇增补;库 2026-09-16 随 React 篇增补;平台 2026-09-17 随 Docker-K8s 篇增补),复合主体写复合(先例"语言(JS/TS)+ 运行时(Node)");生态≈矩阵的帝国来源;诞生=发布年份,多主角斜杠分隔。速查表(ref)不打标;首页矩阵表头第一列用"主体";已成稿各篇均已打标
- 演进对照矩阵(主体/诞生/帝国来源/独特教训)在站点首页 index.astro 维护,新条目要加行

## 4. 已成稿各篇及"独特教训"

- JS-Node-TS:运行时可换,语言不等于场景
- Python:选它是选生态;兼容性是生死线
- Java:兼容神话是统治的根(1996 承诺至今)
- Go:简单是特性,"不加什么"也是决策
- Rust:把错误从运行时左移到编译期
- Next.js(2026-09-16 增,系列首次收录框架):替你做决定的是框架,替你还债的也是它;命名沿用单名规则
- Vue(2026-09-16 增):渐进式是它的道,也是它的债——2→3 并轨双轨五年,顺手造的 Vite 反哺全生态;Vite 与 Vue 同爹,故不走链式命名
- C(2026-09-16 增):把信任交给程序员,自由与漏洞同源
- C++(2026-09-16 增):兼容是工业胜利的根,也是复杂度的根
- C#(2026-09-16 增,文件名转写 CSharp):绑死平台是高利贷,开源是赎身
- SQL(2026-09-16 增):被喊"取代"二十年,靠声明式内核活得更好
- React(2026-09-16 增,系列首次收录"库"):视图只做描述,渲染器可换;决定与债都归生态——React Native 证明渲染器可插拔,CRA 退役、Next.js 收编工程决定证明债归生态;React Native/RSC 均与 React 同源,不走链式命名
- Redis(2026-09-16 增,系列首次收录"中间件"):快来自少等待而非多线程;"开源"不是恒定属性,许可能走一个来回(2024 失开源→Valkey fork→2025 AGPL 回归);Valkey 属剧情不属主角,不走链式命名
- Kafka(2026-09-17 增):消息从"读完就删"变成"存下来就是资产"——顺序写磁盘+可回放;Confluent"开源内核+云"路线与 Redis 许可风波互为镜像
- MySQL(2026-09-17 增):事实标准属于最容易上车的;"兼容 MySQL"接口养大了 Aurora 们的换内核生态;MariaDB 是"fork 保险单"的先例
- Docker-K8s(2026-09-17 增,链式,系列首次收录"平台"):把核心捐给中立基金会反而赢得整个生态(containerd/OCI,与 Redis 许可风波对照);声明式 API 与 SQL 同魂;K8s 1.0 兼容承诺呼应 Go 1.0
- Spring(2026-09-17 增):框架会重走老路,能自我革命(Boot 约定优于配置)的才活过二十年;AOT 原生镜像是"左移"在 Java 的重演;Boot 与 Spring 同爹,不走链式命名
- Django-Flask-FastAPI(2026-09-17 增,链式):三代不是换代是分工;类型标注到哪契约跟到哪(FastAPI 签名即契约);异步是三家共同还的十五年旧账

## 5. 站点( lang-evolution-notes/ )

- 内容零拷贝:Astro content collection 直读 knowledge/doc/lang-evolution-notes/*.md
- 新增章节步骤:①md 放进该目录;②lang-evolution-notes/src/chapters.ts 的 chapters 数组加一条(id=文件名去 .md,label=侧栏显示名,group: 'route'|'ref');③push 自动部署
- 注意:勿在 md 中引用目录外文件;互链写相对文件名(如 [速查](构建工具链速查.md)),rehype 插件会转成路由
- 部署(2026-10-01 改):deploy-notes-site.yml 双站一次构建合并上传(见第 9 节),显式调 upload-pages-artifact 但全流程仅一次,无 409;若单站改回 withastro/action 则勿再显式上传(其内置,同名产物 409)
- 勿新建与 pages.yml 同类的 push 触发 Pages 工作流,会互相覆盖

## 6. pages.yml 决定

原 Docsify 全库站(.github/workflows/pages.yml)改为仅手动触发(2026-09-13):与新站点抢同一 Pages 地址。未删除;手动运行会覆盖新站点,这是已知取舍。去留待用户决定。

## 7. 网址方案

- 现役:https://x-85.github.io/ai-all-in-one/ (GitHub Pages,Actions 自动部署)
- 进行中:方案A Cloudflare Pages → lang-evolution-notes.pages.dev,等用户网页端部署;代码已适配(CF_PAGES 自动切 base)
- 终解可选:自定义域名(约¥60/年),用户未决

## 8. AI 求职技能专题( ai-career-notes/ ,2026-09-30 定)

- 定位:以 AI 应用工程岗为目标岗位(2027 年年后求职),不追算法岗;把一年多 agent 实战经验(codex/pi coding agent/codebuddy/zcode/zed/claude code)+ FAQ RAG 系统(钉钉+AstrBot)+ 知识库产出能力,按四层框架整理——原理 20% / 工程 30% / 质量 20% / 证据 30%,核心动作=体系化+证据化
- 目录:与 lang-evolution-notes 同级的 `ai-career-notes/`,专题内自有一份 AGENTS.md(定位/写作约定/台账指向);主干文档=`AI应用工程岗技能地图.md`,子文档按其第六节规划登记后动笔,中文望文知义命名
- 内容原则(专题特有):讲事实不编造升级为"不替用户编造经历"——用户未提供的个人体验/横评选材/数据一律 `[待回填:xxx]` 占位;面试故事、工具横评等独有素材必须来自用户真实经历
- 互链:目录内写相对文件名,引用目录外用仓库相对路径(如 `../knowledge/doc/RAG是什么.md`);已接独立站点 ai-career-notes-site/(见第 9 节,2026-10-01 起)
- 差异化重点:evals(golden set 评测报告)与证据层(作品集 README 化/量化指标/AstrBot 源码深读/公开输出);"用过 6 个 agent"的价值在横评认知与失败模式,不在数量
- 原理层文档双用途(2026-10-01 定):学习版规格=骨架四段(是什么/机制/工程推论/常见误区,速览层)+机制段展开+"例子(可直接讲,约 1 分钟)"块(讲稿层);延伸知识点一律登记进 `LLM基础认知-补充资料.md`,触发条件制(面试被问/工作用到才展开),防知识面焦虑性扩张

## 9. AI 求职技能专题站点( ai-career-notes-site/ ,2026-10-01 定)

- 结构:与 lang-evolution-notes 同构的极简 Astro 站,零拷贝直读 `ai-career-notes/*.md`;glob pattern `['*.md', '!AGENTS.md']` 排除目录级 agent 约定,不发布;generateId 保留原始文件名(含半角括号,合法)
- 部署:GitHub Pages 双站合并——一个仓库只有一个 Pages 地址,deploy-notes-site.yml 一次构建两站,求职站产物并入演进站 `dist/career/`,URL=`https://x-85.github.io/ai-all-in-one/career/`;astro.config 保留 `CF_PAGES` 切根路径开关,日后可独立迁 Cloudflare Pages(项目名建议 ai-career-notes)
- 链接重写(rehype 插件两条规则):目录内相对 `X.md` → 站内路由 `/notes/<enc>/`;`../knowledge/doc/X.md` → GitHub blob 源文件页——站点保持求职专题纯粹,不收 knowledge/doc 进站,零级联零维护
- 同 origin 陷阱:与演进站共享 x-85.github.io 的 localStorage,主题/沉浸 key 必须用 `ai-career:` 前缀(演进站是 `lang-evo:`),否则两站设置互相覆盖
- 新增章节步骤:①md 放进 ai-career-notes/;②ai-career-notes-site/src/chapters.ts 加一条(group: 'overview'|'principle'|'engineering'|'ext');③首页 index.astro 的 descriptions 补一句;④push 自动部署
- 推送约定:专题内容随站点发布先行推送(2026-10-01),Q8 原先"随 Q4 全部写完一起推"的耦合就此解耦;Q4 演进文档的推送约定不变
