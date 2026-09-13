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
  { id: '构建工具链速查', label: '构建工具链速查', group: 'ref' },
];

export function chapterHref(id: string): string {
  const base = import.meta.env.BASE_URL.endsWith('/')
    ? import.meta.env.BASE_URL
    : import.meta.env.BASE_URL + '/';
  return base + 'notes/' + encodeURI(id) + '/';
}
