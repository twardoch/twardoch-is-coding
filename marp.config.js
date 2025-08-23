// this_file: marp.config.js

const { Marp } = require('@marp-team/marp-core');

// Import working plugins
const highlightjs = require('markdown-it-highlightjs');
const mark = require('markdown-it-mark');
const ins = require('markdown-it-ins');
const container = require('markdown-it-container');
const attrs = require('markdown-it-attrs');

module.exports = {
  // Configure the engine
  engine: (options) => {
    return new Marp(options)
      .use(highlightjs)
      .use(mark)
      .use(ins)
      .use(attrs)
      .use(container, 'info')
      .use(container, 'tip')
      .use(container, 'warning')
      .use(container, 'danger')
      .use(container, 'center');
  },
};