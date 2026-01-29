# syntax=docker/dockerfile:1

# ---- deps stage ----
FROM node:20-alpine AS deps
WORKDIR /app
COPY app/package*.json ./
RUN npm ci --omit=dev

# ---- runtime stage ----
FROM node:20-alpine AS runtime
WORKDIR /app

# Copy only what we need at runtime
COPY --from=deps /app/node_modules ./node_modules
COPY app/src ./src
COPY app/package.json ./package.json

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

# OpenShift-friendly permissions and non-root UID
RUN chown -R 1000:1000 /app
USER 1000:1000

# Avoid npm entirely at runtime
CMD ["node", "src/server.js"]
