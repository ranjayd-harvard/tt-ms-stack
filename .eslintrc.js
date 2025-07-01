module.exports = {
    root: true,
    parserOptions: {
      ecmaVersion: 2021,
      sourceType: "module"
    },
    env: {
      browser: true,
      node: true,
      es2021: true
    },
    extends: ["eslint:recommended", "plugin:react/recommended"],
    plugins: ["react"],
    rules: {
      "no-console": "warn"
    },
    settings: {
        react: {
            version: "detect" // auto-detects React version
        }
    }
  };
  