export interface Chapter {
  id: string;
  label: string;
  group: 'overview' | 'principle' | 'engineering' | 'quality' | 'ext';
}

// 侧栏分组(与技能地图四层框架对应),布局循环渲染
export const GROUPS: { key: Chapter['group']; label: string }[] = [
  { key: 'overview', label: '主干' },
  { key: 'principle', label: '原理层' },
  { key: 'engineering', label: '工程层' },
  { key: 'quality', label: '质量层' },
  { key: 'ext', label: '延伸' },
];

export const chapters: Chapter[] = [
  { id: 'AI应用工程岗技能地图', label: '技能地图 · 主干', group: 'overview' },
  { id: 'LLM基础认知-生成机制(上)', label: '生成机制(上)', group: 'principle' },
  { id: 'LLM基础认知-生成机制(下)', label: '生成机制(下)', group: 'principle' },
  { id: 'LLM基础认知-检索原理', label: '检索原理', group: 'principle' },
  { id: 'LLM基础认知-上下文工程', label: '上下文工程(延伸)', group: 'principle' },
  { id: 'LLM基础认知-提示词工程', label: '提示词工程(延伸)', group: 'principle' },
  { id: 'RAG系统设计复盘', label: 'RAG 系统设计复盘', group: 'engineering' },
  { id: 'Agent编码工具横评', label: '工具横评(待回填)', group: 'engineering' },
  { id: '工作流agent实践', label: '工作流 agent 实践', group: 'engineering' },
  { id: 'FastAPI学习指南', label: 'FastAPI 学习指南', group: 'engineering' },
  { id: 'RAG评测实践-golden-set与报告', label: '评测报告(模板待填)', group: 'quality' },
  { id: '面试故事库', label: '面试故事库', group: 'ext' },
  { id: '求职材料checklist', label: '求职材料 checklist', group: 'ext' },
  { id: '公开输出-从三分法到四路由(初稿)', label: '公开输出·四路由(初稿)', group: 'ext' },
  { id: '待办清单', label: '待办清单(用户侧)', group: 'ext' },
  { id: 'LLM基础认知-补充资料', label: '补充资料(占位登记)', group: 'ext' },
];

export function chapterHref(id: string): string {
  const base = import.meta.env.BASE_URL.endsWith('/')
    ? import.meta.env.BASE_URL
    : import.meta.env.BASE_URL + '/';
  // encodeURIComponent 与 astro.config 的 rehypeMdLinks 统一,
  // 文件名里的括号等字符需编码,保证两侧生成完全一致的 URL
  return base + 'notes/' + encodeURIComponent(id) + '/';
}
