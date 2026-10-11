FROM node:24-slim
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN corepack enable
RUN pnpm install --frozen-lockfile --ignore-scripts
COPY . .
RUN pnpm build
EXPOSE 3000
CMD ["node", "dist/server.js"]
