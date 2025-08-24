// this_file: src_slides/marp/marp.config.js

const { Marp } = require('@marp-team/marp-core');
const markdownItContainer = require('markdown-it-container');
const markdownItMark = require('markdown-it-mark');
const markdownItIns = require('markdown-it-ins');
const markdownItAttrs = require('markdown-it-attrs');
const markdownItHighlightjs = require('markdown-it-highlightjs');

module.exports = {
  engine: (opts) => {
    const marp = new Marp({
      ...opts,
      html: true,
      math: 'katex', // Enable math support
    });

    // Enable containers for alerts
    marp.markdown
      .use(markdownItContainer, 'info', {
        render: (tokens, idx) => {
          const token = tokens[idx];
          const info = token.info.trim().slice('info'.length).trim();
          if (token.nesting === 1) {
            return `<div class="alert alert-info">\n<div class="alert-title">${info || 'Info'}</div>\n`;
          } else {
            return '</div>\n';
          }
        },
      })
      .use(markdownItContainer, 'tip', {
        render: (tokens, idx) => {
          const token = tokens[idx];
          const info = token.info.trim().slice('tip'.length).trim();
          if (token.nesting === 1) {
            return `<div class="alert alert-tip">\n<div class="alert-title">${info || 'Tip'}</div>\n`;
          } else {
            return '</div>\n';
          }
        },
      })
      .use(markdownItContainer, 'warning', {
        render: (tokens, idx) => {
          const token = tokens[idx];
          const info = token.info.trim().slice('warning'.length).trim();
          if (token.nesting === 1) {
            return `<div class="alert alert-warning">\n<div class="alert-title">${info || 'Warning'}</div>\n`;
          } else {
            return '</div>\n';
          }
        },
      })
      .use(markdownItContainer, 'danger', {
        render: (tokens, idx) => {
          const token = tokens[idx];
          const info = token.info.trim().slice('danger'.length).trim();
          if (token.nesting === 1) {
            return `<div class="alert alert-danger">\n<div class="alert-title">${info || 'Danger'}</div>\n`;
          } else {
            return '</div>\n';
          }
        },
      })
      .use(markdownItContainer, 'center', {
        render: (tokens, idx) => {
          if (tokens[idx].nesting === 1) {
            return '<div class="center-content">\n';
          } else {
            return '</div>\n';
          }
        },
      })
      .use(markdownItMark)
      .use(markdownItIns)
      .use(markdownItAttrs)
      .use(markdownItHighlightjs, {
        inline: false,
        auto: true,
        code: true,
      });

    return marp;
  },
  html: true,
  pdf: {
    format: 'A4',
    printBackground: true,
  },
  allowLocalFiles: true,
};