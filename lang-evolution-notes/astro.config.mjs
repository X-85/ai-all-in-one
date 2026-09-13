import { defineConfig } from 'astro/config';

// GitHub Pages 项目站挂在 /ai-all-in-one/ 之下;
// Cloudflare Pages(方案A)部署在根路径,构建环境自带 CF_PAGES=1,据此自动判断
const BASE = process.env.CF_PAGES ? '/' : '/ai-all-in-one';

// 笔记之间的互链写作 [xx](xx.md),渲染后转成站点路由 /notes/<id>/
function rehypeMdLinks() {
  const toPage = (href) => {
    const name = decodeURIComponent(
      href.replace(/\.md$/, '').replace(/^\.\//, '')
    );
    return `${BASE}/notes/${encodeURIComponent(name)}/`;
  };
  const walk = (node) => {
    if (
      node.tagName === 'a' &&
      typeof node.properties?.href === 'string' &&
      node.properties.href.endsWith('.md')
    ) {
      node.properties.href = toPage(node.properties.href);
    }
    for (const child of node.children ?? []) walk(child);
  };
  return (tree) => walk(tree);
}

export default defineConfig({
  site: 'https://x-85.github.io',
  base: BASE,
  markdown: {
    rehypePlugins: [rehypeMdLinks],
    shikiConfig: {
      theme: 'github-dark',
      wrap: true,
    },
  },
});
