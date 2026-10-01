# AGENTS.md

本仓库是个人知识库(ai-all-in-one),包含知识文档、语言演进笔记站点、AI 求职技能专题与会话台账。

## AI 求职技能专题(ai-career-notes/)

用户以 AI 应用工程岗为目标(2027 年年后求职),专题把一年多 agent 实战经验整理为四层框架(原理/工程/质量/证据)。处理该目录任务时,先读 `ai-career-notes/AGENTS.md`(专题定位与写作约定,含"不替用户编造经历"原则)与主干文档 `ai-career-notes/AI应用工程岗技能地图.md`;进度看台账 Q8。

该专题已接独立 Astro 站点 `ai-career-notes-site/`(与 lang-evolution-notes 同构,zero-copy 直读 `ai-career-notes/*.md`,`AGENTS.md` 被排除不发布)。新增文档接线:在 `ai-career-notes-site/src/chapters.ts` 加一条(id=文件名去 .md)+ 首页 `index.astro` 的 descriptions 补一句,push 到 main 后自动部署到 `/ai-all-in-one/career/`(与演进站共用一个 workflow 双站合并部署,见 `.github/workflows/deploy-notes-site.yml`)。文档互链:目录内写相对文件名(构建时转站内路由);引用目录外写仓库相对路径(构建时转 GitHub 源文件页)。

## 语言演进路线文档系列

用户说"写 X 演进路线"/"继续语言演进系列"时,严格按以下流程执行:

**写之前必读**
1. `session/decisions.md` — 文档模板、命名规则、内容原则、跨文档呼应素材(兼容哲学表/错误左移/生态帝国)
2. `session/index.md` — 系列进度与待办
3. 参考成稿:`knowledge/doc/lang-evolution-notes/` 下任一篇(全清单见 decisions.md 第 4 节)

**产出动作(按序)**
1. 新文档:`knowledge/doc/lang-evolution-notes/<语言>演进路线.md`,严格按 decisions.md 第 1 节模板(因果链→三节演进史→补课→三个必要词汇→工程化→小结→FAQ)
2. 若该语言已工具成型:在 `knowledge/doc/lang-evolution-notes/构建工具链速查.md` 总表加一行
3. 新文档开头加标签行与姊妹篇链接:标签行 `> 类型:X | 生态:X | 诞生:年份`(格式细则见 decisions.md 第 3 节),姊妹篇指向其余演进文档 + 速查表
4. `lang-evolution-notes/src/chapters.ts` 的 chapters 数组加一条(id=文件名去 .md,label=侧栏名,group: 'route')
5. `lang-evolution-notes/src/pages/index.astro` 的 matrix 表加一行(主体/诞生/帝国来源/独特教训)
6. push 到 main 后站点自动部署,无需手动操作

**注意事项**
- 命名默认单名 `<语言>演进路线.md`;仅当一次演进诞生多个主角才用链式命名(先例:JS-Node-TS)
- 文件名勿用 `#`(URL 锚点):C# 篇文件名转写为 `CSharp演进路线.md`,显示名仍是 C#;Astro glob loader 遇 `#` 会把路径当锚点,页面静默缺失(2026-09-16 踩坑)
- 文档互链写相对文件名;勿引用目录外文件
- 勿新建部署到 github-pages environment 的 workflow(一个仓库只有一个 Pages 地址,会互相覆盖);deploy-notes-site.yml 已双站合并,若用 withastro/action 则勿再显式调 actions/upload-pages-artifact(其内置上传,同名产物 409)

## 会话台账协议

本工作区使用 session/ 台账(skill: session-ledger):每轮处理结束追加 `session/events.md`、更新 `session/index.md` 对应行,稳定结论写入 `session/decisions.md`,回复末尾附 `[台账更新]` 尾注(问题/本轮/状态/下一步)。
