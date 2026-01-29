# syntax=docker/dockerfile:1

########################
# deps stage (build)
########################
FROM node:22-bookworm-slim AS deps
WORKDIR /app

# Install deps with good caching
COPY app/package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

########################
# runtime stage (no npm)
########################
FROM gcr.io/distroless/nodejs22-debian12:nonroot AS runtime
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080

# Copy node_modules + app source
COPY --from=deps /app/node_modules ./node_modules
COPY app/src ./src
COPY app/package.json ./package.json

EXPOSE 8080

# Run directly with node (no npm in image)
CMD ["src/server.js"]
