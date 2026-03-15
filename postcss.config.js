const cssnano = require('cssnano');
const purgecssModule = require('@fullhuman/postcss-purgecss');

const purgecss = purgecssModule.default || purgecssModule;

const isDevelopment = process.env.HUGO_ENVIRONMENT === 'development';
const contentTokenPattern = /[A-Za-z0-9-_:/.[\]]+/g;

function extractHugoStats(content) {
  try {
    const stats = JSON.parse(content);
    const elements = stats && typeof stats === 'object' ? stats.htmlElements || {} : {};
    const tags = Array.isArray(elements.tags) ? elements.tags : [];
    const classes = Array.isArray(elements.classes) ? elements.classes : [];
    const ids = Array.isArray(elements.ids) ? elements.ids : [];
    return [...tags, ...classes, ...ids];
  } catch (error) {
    return [];
  }
}

function extractTokens(content) {
  return content.match(contentTokenPattern) || [];
}

module.exports = {
  plugins: [
    !isDevelopment &&
      purgecss({
        content: [
          './hugo_stats.json',
          './content/**/*.{md,html}',
          './themes/banyan/layouts/**/*.html',
          './themes/banyan/assets/js/**/*.{js,tmpl}',
        ],
        defaultExtractor: extractTokens,
        extractors: [
          {
            extensions: ['json'],
            extractor: extractHugoStats,
          },
        ],
        fontFace: true,
        keyframes: true,
        variables: true,
        safelist: {
          standard: [':root'],
          greedy: [
            /data-theme/,
            /data-nav-progress/,
            /data-logged-in/,
            /data-site-update/,
            /data-site-update-anchor/,
          ],
        },
      }),
    !isDevelopment &&
      cssnano({
        preset: ['default', { discardComments: { removeAll: true } }],
      }),
  ].filter(Boolean),
};
