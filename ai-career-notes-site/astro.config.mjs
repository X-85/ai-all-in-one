import { defineConfig } from 'astro/config';

// GitHub Pages 上与 lang-evolution-notes 共用一个 Pages 地址,本站挂在其 /career/ 子路径;
// Cloudflare Pages 独立项目部署在根路径,构建环境自带 CF_PAGES=1,据此自动判断
const BASE = process.env.CF_PAGES ? '/' : '/ai-all-in-one/career';

const REPO_BLOB = 'https://github.com/x-85/ai-all-in-one/blob/main';

// 笔记之间的互链写作 [xx](xx.md),渲染后转成站点路由 /notes/<id>/;
// 跨目录引用(../knowledge/doc/X.md)不属于本站,重写到 GitHub 源文件页
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
      const href = node.properties.href;
      node.properties.href = href.startsWith('../')
        ? `${REPO_BLOB}/${href.replace(/^\.\.\//, '')}`
        : toPage(href);
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
