import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { fileURLToPath } from 'node:url';

const notes = defineCollection({
  loader: glob({
    // AGENTS.md 是目录级 agent 约定,不属于站点内容
    pattern: ['*.md', '!AGENTS.md'],
    base: fileURLToPath(new URL('../../ai-career-notes', import.meta.url)),
    // 保留原始文件名大小写与括号(默认 slugify 会转写,GitHub Pages 区分大小写会 404)
    generateId: ({ entry }) => entry.replace(/\.md$/, ''),
  }),
});

export const collections = { notes };
