const lintstagedrc = {
  "*.{ts,tsx}": [() => "tsc --noEmit", "eslint --fix", "prettier --write"],
  "*.{js,jsx,mjs}": ["eslint --fix", "prettier --write"],
  "*.{json,md,css}": ["prettier --write"],
};

export default lintstagedrc;
