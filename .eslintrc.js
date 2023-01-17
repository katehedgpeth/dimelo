module.exports = {
  env: {
    browser: true,
    es6: true,
  },
  extends: [
    "airbnb",
    "plugin:react/recommended",
    "plugin:import/recommended",
    "plugin:import/typescript",
  ],
  globals: {
    Atomics: "readonly",
    JSX: true,
    SharedArrayBuffer: "readonly",
  },
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 11,
    sourceType: "module",
  },
  plugins: [
    "react",
    "react-hooks",
    "@typescript-eslint",
  ],
  rules: {
    "@typescript-eslint/no-shadow": ["error"],
    "@typescript-eslint/no-unused-vars": [
      "error",
      { ignoreRestSiblings: true },
    ],
    "@typescript-eslint/no-use-before-define": ["error"],
    camelcase: "off",
    "import/extensions": [
      2,
      "ignorePackages",
      {
        json: "always",
        ts: "never",
        tsx: "never",
      },
    ],
    "import/no-extraneous-dependencies": [
      "error",
      {
        devDependencies: [
          "**/*.test.ts*",
          "vite.config.ts",
        ],
      },
    ],
    "import/no-unresolved": [2, { caseSensitive: false }],
    "import/order": [
      "error",
      {
        groups: ["builtin", "external", "internal"],
        pathGroups: [
          {
            group: "builtin",
            pattern: "react",
            position: "before",
          },
        ],
        pathGroupsExcludedImportTypes: ["react"],
      },
    ],
    "import/prefer-default-export": "off",

    "max-len": [2, 80],
    // we use @typescript/no-shadow
    "no-shadow": "off",

    "no-unused-expressions": [
      2,
      { allowShortCircuit: true, allowTernary: true },
    ],

    // we use @typescript/no-unused-vars
    "no-unused-vars": "off",

    // we use @typescript/no-use-before-define
    "no-use-before-define": "off",

    quotes: ["error", "double"],

    "react/function-component-definition": [2, {
      namedComponents: "arrow-function",
      unnamedComponents: "arrow-function",
    }],

    "react/jsx-curly-newline": [0],

    "react/jsx-filename-extension": [2, { extensions: [".ts", ".tsx"] }],

    "react/jsx-one-expression-per-line": [0],

    "react/jsx-props-no-spreading": [0],

    "react/jsx-wrap-multilines": [
      "error",
      { assignment: false, declaration: false },
    ],

    "react/prop-types": "off",

    "react/require-default-props": "off",

    "sort-keys": "error",
  },
  settings: {
    "import/resolver": {
      node: {
        paths: ["src"],
      },
      typescript: {
        paths: ["src"],
      },
    },
  },
};
