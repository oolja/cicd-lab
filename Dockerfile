# syntax=docker/dockerfile:1

# ---- Build stage: install all deps and compile TypeScript ----
FROM node:24-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY tsconfig.json ./
COPY src ./src
RUN npm run build

# ---- Test stage: build stage plus tests (not part of the runtime image) ----
FROM build AS test
COPY test ./test
CMD ["npm", "run", "test"]

# ---- Runtime stage: production deps + compiled output only ----
FROM node:24-alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production \
    PORT=3000

COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY --from=build /app/dist ./dist

USER node
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- "http://127.0.0.1:${PORT}/api/health" || exit 1

CMD ["node", "dist/server.js"]
