export interface Chapter {
  id: string;
  label: string;
  group: 'route' | 'ref';
}

export const chapters: Chapter[] = [
  { id: 'JS-Node-TS演进路线', label: 'JS → Node → TS', group: 'route' },
  { id: 'Python演进路线', label: 'Python', group: 'route' },
  { id: 'Java演进路线', label: 'Java', group: 'route' },
  { id: 'Go演进路线', label: 'Go', group: 'route' },
  { id: 'Rust演进路线', label: 'Rust', group: 'route' },
  { id: 'C演进路线', label: 'C', group: 'route' },
  { id: 'C++演进路线', label: 'C++', group: 'route' },
  { id: 'CSharp演进路线', label: 'C#', group: 'route' },
  { id: 'SQL演进路线', label: 'SQL', group: 'route' },
  { id: 'Next.js演进路线', label: 'Next.js', group: 'route' },
  { id: 'Vue演进路线', label: 'Vue', group: 'route' },
  { id: 'React演进路线', label: 'React', group: 'route' },
  { id: 'Redis演进路线', label: 'Redis', group: 'route' },
  { id: 'Spring演进路线', label: 'Spring', group: 'route' },
  { id: 'Django-Flask-FastAPI演进路线', label: 'Django → Flask → FastAPI', group: 'route' },
  { id: 'Kafka演进路线', label: 'Kafka', group: 'route' },
  { id: 'MySQL演进路线', label: 'MySQL', group: 'route' },
  { id: 'Docker-K8s演进路线', label: 'Docker → K8s', group: 'route' },
  { id: '构建工具链速查', label: '构建工具链速查', group: 'ref' },
  { id: '语言主战场速查', label: '语言主战场速查', group: 'ref' },
];

export function chapterHref(id: string): string {
  const base = import.meta.env.BASE_URL.endsWith('/')
    ? import.meta.env.BASE_URL
    : import.meta.env.BASE_URL + '/';
  // encodeURIComponent 与 astro.config 的 rehypeMdLinks 统一:
  // C# 的 # 在 URL 里是锚点符号,必须编码成 %23,否则链接断在 C
  return base + 'notes/' + encodeURIComponent(id) + '/';
}
