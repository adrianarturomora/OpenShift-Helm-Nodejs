# syntax=docker/dockerfile:1

############################################
# deps stage: install production node_modules
############################################
FROM node:22-alpine AS deps
WORKDIR /app

# Only copy manifests first for better caching
COPY app/package*.json ./
RUN npm ci --omit=dev

############################################
# runtime stage: distroless (no npm)
############################################
FROM gcr.io/distroless/nodejs22-debian12 AS runtime
WORKDIR /app

# Copy production deps + app source
COPY --from=deps /app/node_modules ./node_modules
COPY app/src ./src
COPY app/package.json ./package.json

ENV NODE_ENV=production
ENV PORT=8080
EXPOSE 8080

# distroless node images run "node" by default, but we’ll be explicit:
CMD ["src/server.js"]
