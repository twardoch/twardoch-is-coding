// this_file: src_slides/slidev/vite.config.ts

import { defineConfig } from 'vite'

export default defineConfig({
  slidev: {
    vue: {
      /* vue options */
    },
    markdown: {
      /* markdown options */
      markdownItSetup(md) {
        /* custom markdown-it plugins */
      },
    },
    /* options for other plugins */
  },
})