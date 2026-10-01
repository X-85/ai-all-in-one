# RAG 学习路线图与实战指南

RAG(Retrieval-Augmented Generation,检索增强生成)是一种架构模式:大模型回答前先从外部知识库检索相关内容,拼进 prompt 再生成答案。本文给出一条从零到生产的完整学习路线,以及配套的动手实战项目。

概念与典型架构详解见 [RAG是什么](RAG是什么.md)。

**适用人群**:会 Python 基础、调用过大模型 API、想让 AI 基于自己的文档回答问题的开发者。

**预计总时长**:3~4 周(每天 1~2 小时)。

---

## 一、核心概念速览

先花 30 分钟建立全局认知,后面每个阶段都在往这张图里填细节。

```text
【离线索引阶段】(提前做好,只做一次或文档更新时做)
原始文档 → 解析(PDF/网页/Markdown) → 切分(chunk)
→ Embedding 模型向量化 → 存入向量数据库

【在线问答阶段】(用户每次提问时)
用户问题 → 向量化 → 向量库相似度检索(Top-K)
→ (可选)重排 rerank 精筛 → 拼进 prompt
→ LLM 基于检索内容生成答案
```

**关键术语表**:

| 术语 | 含义 |
|------|------|
| chunk | 文档切分后的小块,检索的基本单位,通常几百字 |
| Embedding | 把文本映射成向量,语义相近的文本向量距离近 |
| 向量数据库 | 存向量并支持相似度检索,如 Chroma、Milvus |
| Top-K | 检索时取相似度最高的 K 个 chunk |
| 召回 / 精排 | 先粗筛出候选,再用更重的模型精筛顺序 |
| rerank(重排) | 用交叉编码器对"问题-chunk"对打分重排序 |
| 混合检索 | 向量语义检索 + 关键词(BM25)检索结合 |
| 幻觉 | 模型编造事实,RAG 的主要解决目标之一 |

---

## 二、学习路线图

### 路线总览

| 阶段 | 主题 | 产出 | 预计时间 |
|------|------|------|---------|
| 阶段 0 | 环境准备 | 可用的 API Key + Python 环境 | 1 小时 |
| 阶段 1 | 零代码体验 | 用 Dify 搭一个知识库问答机器人 | 半天 |
| 阶段 2 | 手写最小 RAG | 100 行纯 Python 代码跑通全流程 | 1 天 |
| 阶段 3 | 工程化组件 | 接入向量数据库 Chroma | 半天 |
| 阶段 4 | 框架重构 | 用 LangChain 重写并支持多格式文档 | 1~2 天 |
| 阶段 5 | 效果优化 | 混合检索 + 重排,检索准确率可感知提升 | 2 天 |
| 阶段 6 | 评估与生产化 | 用 RAGAS 量化效果,了解生产关注点 | 1 天 |
| 毕业项目 | 知识库问答机器人 | 对本仓库(ai-all-in-one)问答的完整应用 | 周末 2 天 |

**路线设计原则**:先用平台建立直觉 → 再手写理解原理 → 然后才用框架。顺序不能反,直接学框架会被抽象概念(Loader、Splitter、Retriever)绕晕,不知道每一步背后发生了什么。

### 阶段 0:环境准备

- 注册一个模型服务商账号,拿到 API Key(智谱开放平台 open.bigmodel.cn 即可,`glm-4-flash` 免费,`embedding-3` 便宜,学习期够用)。
- Python 3.10+ 环境,建议新建虚拟环境。
- 安装核心依赖:`pip install openai numpy`。

**过关标准**:能用 API 成功调用一次 embedding 和一次 chat 补全。

### 阶段 1:零代码体验(建立直觉)

不写代码,用 Dify(Docker 自部署或云端版)搭一个知识库问答:

1. 创建知识库,上传几篇自己的 PDF/Markdown 文档;
2. 观察它如何切分、用哪个 embedding 模型(先保持默认);
3. 创建聊天助手,关联知识库,测试问答;
4. 故意问文档里没有的问题,观察"知识库外"的表现。

**重点体验**:检索命中时答案的引用来源、文档外问题的拒答表现、换不同 chunk 大小后效果差异。

**过关标准**:能说清楚"我的文档从上传到能被问答,中间经历了哪几步"。

### 阶段 2:手写最小 RAG(理解原理)

丢开所有框架,用纯 Python + 模型 API 实现 60~100 行的最小 RAG。这是整个路线最重要的一步——你会发现 RAG 没有魔法,就是"向量化 → 算余弦相似度 → 拼prompt"。

完整代码见下文「实战 2」。**过关标准**:不改资料能向别人解释 embedding 向量怎么参与检索、Top-K 的 chunk 怎么进入 prompt。

### 阶段 3:工程化(向量数据库)

最小 RAG 每次启动都重新计算所有文档向量,数据一多就不可用。引入 Chroma 解决持久化和规模问题,顺便理解元数据过滤。

**过关标准**:知识入库后程序重启不丢;能按元数据(如来源文件)过滤检索。

### 阶段 4:框架重构(LangChain / LlamaIndex)

用框架重写阶段 2~3 的功能,体会框架解决的是"组件标准化和拼装效率",不是黑魔法。重点学:

- DocumentLoader:多格式文档加载(PDF、网页、Markdown);
- TextSplitter:递归切分、按结构切分;
- Retriever:检索接口抽象;
- 现成的 RAG 链(LCEL 或 LlamaIndex 的 QueryEngine)。

**过关标准**:能独立搭"上传 PDF → 切分 → 入库 → 问答"的命令行程序,并且每一环都能换成自定义实现。

### 阶段 5:效果优化(RAG 的真正难点)

基础版搭好后,80% 的问题出在检索而不是生成。逐个实验以下手段,每个实验都记录"好例子/坏例子"的前后对比:

1. **切分策略**:固定长度 → 递归切分 → 带重叠(overlap)→ 按标题/段落结构切分;
2. **查询改写**:用户问题太短或口语化时,先让 LLM 改写成适合检索的形式;
3. **混合检索**:向量检索 + BM25 关键词检索,用 RRF(倒数排序融合)合并;
4. **重排**:初筛 Top-20 → rerank 精排取 Top-3,常用 BGE-reranker;
5. **加大 Top-K + 让模型自己筛**:便宜但费 token。

**过关标准**:准备 10 个曾答错的问题,优化后至少 7 个明显改善,且能说出是哪个手段起的作用。

### 阶段 6:评估与生产化

没有评估就只能"感觉变好了"。学习用 RAGAS 从四个维度量化:

| 指标 | 衡量什么 |
|------|---------|
| Faithfulness | 答案是否忠于检索到的资料(不编造) |
| Answer Relevancy | 答案是否切题 |
| Context Precision | 检索回来的内容有多少是真有用的 |
| Context Recall | 该检回的内容是否都检回来了 |

同时了解生产关注点:增量更新文档、多用户隔离、检索缓存、敏感信息、成本控制(token 花在检索内容和生成上)、慢查询定位(是检索慢还是生成慢)。

**过关标准**:给自己的应用跑出一份评估报告,并能指出最薄弱的环节。

---

## 三、实战指导书

### 实战 0:环境准备

```bash
python -m venv rag-env && source rag-env/bin/activate
pip install openai numpy
export ZHIPU_API_KEY="你的key"
```

验证连通性:

```python
from openai import OpenAI
client = OpenAI(api_key="...", base_url="https://open.bigmodel.cn/api/paas/v4/")
r = client.embeddings.create(model="embedding-3", input=["hello"])
print(len(r.data[0].embedding))  # 输出维度,成功即通
```

### 实战 1:Dify 知识库问答(阶段 1)

1. Docker 部署:`docker compose up -d`(见 Dify 官方文档),访问 localhost 安装;
2. 知识库 → 上传 3~5 篇自己的文档;
3. 创建应用 → 聊天助手 → 关联知识库;
4. 测试 5 个文档内问题 + 3 个文档外问题;
5. 回到知识库设置,把 chunk 从默认改小/改大各测一轮,记录答案质量变化。

### 实战 2:手写最小 RAG(阶段 2,核心)

```python
"""min_rag.py — 纯 Python 最小 RAG,无任何框架"""
from openai import OpenAI
import numpy as np

client = OpenAI(
    api_key="你的key",
    base_url="https://open.bigmodel.cn/api/paas/v4/",  # 智谱;OpenAI 则换 base_url
)

# 1. 知识库:先用少量手写 chunk,跑通后再换成读 Markdown 文件
docs = [
    "RAG 是检索增强生成,先检索资料再让大模型回答。",
    "Embedding 把文本变成向量,语义相近的文本向量距离更近。",
    "向量数据库负责存储向量和相似度检索,例如 Chroma 和 Milvus。",
    "chunk 指文档切分后的小块,是检索的基本单位。",
]

def embed(texts: list[str]) -> list[list[float]]:
    r = client.embeddings.create(model="embedding-3", input=texts)
    return [d.embedding for d in r.data]

# 2. 离线:全部向量化(最小版不持久化,重启重算)
doc_emb = np.array(embed(docs))

def retrieve(query: str, k: int = 2) -> list[str]:
    q = np.array(embed([query])[0])
    # 余弦相似度 = 点积 / (模 * 模)
    scores = doc_emb @ q / (np.linalg.norm(doc_emb, axis=1) * np.linalg.norm(q))
    top = scores.argsort()[::-1][:k]
    return [docs[i] for i in top]

def ask(query: str):
    hits = retrieve(query)
    context = "\n".join(f"[{i+1}] {h}" for i, h in enumerate(hits))
    r = client.chat.completions.create(
        model="glm-4-flash",
        messages=[
            {"role": "system", "content": "仅根据资料回答,资料里没有就说不知道,并注明依据第几条资料。"},
            {"role": "user", "content": f"资料:\n{context}\n\n问题: {query}"},
        ],
    )
    print(r.choices[0].message.content)

if __name__ == "__main__":
    ask("chunk 是什么?")        # 应命中第 4 条
    ask("怎么衡量文本语义相似?")  # 应命中第 2 条
    ask("今天天气怎么样?")       # 库里没有,应答不知道
```

**练习任务**:
1. 把 `docs` 换成读取一个 Markdown 文件并按 `##` 标题切分;
2. 把 Top-K 从 2 改成 4,观察答案变化;
3. 故意把 system 提示里的"仅根据资料回答"删掉,观察幻觉出现。

### 实战 3:接入 Chroma(阶段 3)

```bash
pip install chromadb
```

```python
import chromadb
db = chromadb.PersistentClient(path="./chroma_db")   # 落盘,重启不丢
col = db.get_or_create_collection("notes")

col.upsert(
    ids=["d1", "d2"],                    # 稳定 id,重复入库即覆盖(增量更新)
    documents=["RAG 是检索增强生成", "chunk 是切分后的文本块"],
    embeddings=embed(["RAG 是检索增强生成", "chunk 是切分后的文本块"]),
    metadatas=[{"src": "rag.md"}, {"src": "notes.md"}],
)

res = col.query(query_embeddings=embed(["什么是RAG"]), n_results=1,
                where={"src": "rag.md"})   # 元数据过滤
print(res["documents"])
```

改造实战 2:embedding 只在入库时算一次,`ask()` 里只做查询。

### 实战 4:LangChain 重构(阶段 4)

```bash
pip install langchain langchain-community langchain-text-splitters pypdf
```

```python
from langchain_community.document_loaders import PyPDFLoader, TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter

loader = PyPDFLoader("manual.pdf")          # 或 TextLoader("notes.md")
docs = loader.load()
splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
chunks = splitter.split_documents(docs)     # 每个 chunk 自动带来源元数据
# 检索与生成部分:接 Chroma + 模型,组合成 chain(参见 LangChain RAG 官方教程)
```

**练习任务**:对比"手写按标题切分"与 `RecursiveCharacterTextSplitter` 在同一篇文档上的 chunk 差异。

### 实战 5:混合检索 + 重排(阶段 5)

最小可用方案(不引重型服务):

1. BM25 关键词检索:`pip install rank-bm25`,对全部 chunk 建索引;
2. 向量检索照旧取 Top-10;
3. RRF 融合两路结果:`score = Σ 1/(60 + rank)`;
4. (可选)重排:用 siliconflow 等平台托管 的 BGE-reranker API,对融合后 Top-10 精排,取 Top-3 进 prompt。

**实验记录模板**:

```text
问题: <曾经答错的问题>
优化前: <检索到的chunk / 答案>
手段: <如: 加了rerank>
优化后: <检索到的chunk / 答案>
结论: <命中/未命中,哪个环节改善了>
```

### 实战 6:RAGAS 评估(阶段 6)

```bash
pip install ragas datasets
```

准备 15~20 条"问题 + 标准答案"的测试集,跑四项指标(Faithfulness、Answer Relevancy、Context Precision、Context Recall)。对比优化前后的分数,把阶段 5 的实验结论量化。

### 毕业项目:本仓库知识库问答机器人

把整条链路用在自己的真实数据上:

- **语料**:`ai-all-in-one/knowledge/` 下全部 Markdown;
- **要求 1**:按文件路径做元数据,检索可按目录(doc/base/projects)过滤;
- **要求 2**:答案附带引用(文件名 + 标题);
- **要求 3**:包含至少一项阶段 5 的优化手段,并用 RAGAS 出一份前后对比报告;
- **要求 4**(可选):用 FastAPI 包成 HTTP 接口,或接 Dify 做前端。

做完这个项目,RAG 从概念到落地就完整走了一遍。

---

## 四、常见坑与排查

| 现象 | 常见原因 | 排查方向 |
|------|---------|---------|
| 检索不到明显相关的内容 | chunk 切太碎丢失上下文,或切太大稀释语义 | 调 chunk_size(中文建议 300~800 字)加 overlap |
| 关键词精确匹配的问题答不出 | 纯向量检索对专有名词/编号不敏感 | 加 BM25 混合检索 |
| 检索对了但答案还是编 | prompt 没约束"仅根据资料回答",或资料太长被忽略 | 收紧 system 提示、减少 Top-K、上 rerank |
| 答非所问 | 用户问题口语化/过短,向量代表性差 | 查询改写、假设性文档嵌入(HyDE) |
| 多文档主题混杂互相干扰 | 无元数据过滤,不同来源内容混检 | 按来源/目录过滤,或分库 |
| 中文效果差于英文示例 | embedding 模型中文能力弱 | 换 BGE 系列、智谱 embedding-3 等中文友好模型 |
| 入库慢、成本高 | 重复全量重建索引 | 稳定 chunk id + upsert 增量更新 |

**排查万能思路**:先看检索回来的 chunk(不看答案),检索错了优化检索,检索对了才是生成/prompt 的问题。RAG 调优 80% 时间应该花在检索侧。

---

## 五、技术选型速查

| 层次 | 推荐 | 说明 |
|------|------|------|
| 生成模型 | glm-4-flash(免费)→ glm-4-plus / DeepSeek | 学习期用免费,生产按需升级 |
| Embedding | 智谱 embedding-3、BGE-M3(开源自部署) | 中文效果好 |
| 重排 | BGE-reranker-v2-m3 | 经 siliconflow 等 API 或本地部署 |
| 向量库 | Chroma(学习/小规模)→ Milvus / Qdrant(生产) | 起步不要碰分布式 |
| 框架 | LangChain(生态全)或 LlamaIndex(检索专精) | 二选一深入即可 |
| 一体化平台 | Dify(通用)、RAGFlow(深度文档解析) | 不写代码或快速交付用 |
| 评估 | RAGAS | 事实上的标准 |

---

## 六、推荐资源

- **论文**:RAG 原始论文(Lewis et al., 2020)、Self-RAG、RAPTOR(进阶再读);
- **官方教程**:LangChain RAG Tutorial、LlamaIndex Documentation、RAGAS Docs;
- **中文生态**:智谱开放平台文档、BGE 系列模型卡(HuggingFace 搜 BAAI);
- **实践参考**:Dify 与 RAGFlow 的官方文档对"知识库产品形态"的定义,值得通读一遍,即使不部署。

---

> 学习记录建议:每完成一个阶段,在本目录新建一篇笔记,记录跑通的代码、踩的坑、实验数据。学完回看,这些笔记比任何教程都有价值。
