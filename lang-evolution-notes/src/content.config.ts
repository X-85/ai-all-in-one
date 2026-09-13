import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { fileURLToPath } from 'node:url';

const notes = defineCollection({
  loader: glob({
    pattern: '*.md',
    base: fileURLToPath(
      new URL('../../knowledge/doc/lang-evolution-notes', import.meta.url)
    ),
    // 保留原始文件名大小写(默认 slugify 会全转小写,GitHub Pages 区分大小写会 404)
    generateId: ({ entry }) => entry.replace(/\.md$/, ''),
  }),
});

export const collections = { notes };
