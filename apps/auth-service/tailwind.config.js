const path = require('path');
const uiConfig = require('../../packages/ui/tailwind.config.js');

module.exports = {
  presets: [uiConfig],
  content: [
    path.join(__dirname, './src/**/*.{js,ts,jsx,tsx,mdx}'),
    path.join(__dirname, '../../packages/ui/src/**/*.{js,ts,jsx,tsx,mdx}'),
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
