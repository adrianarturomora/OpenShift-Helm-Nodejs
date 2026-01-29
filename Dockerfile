# syntax=docker/dockerfile:1

# ---- deps stage ----
FROM node:22-alpine AS deps
WORKDIR /app

# Install only production deps (cached layer)
COPY app/package*.json ./
RUN npm ci --omit=dev

# ---- runtime stage ----
FROM node:22-alpine AS runtime
WORKDIR /app

# Copy only what we need at runtime
COPY --from=deps /app/node_modules ./node_modules
COPY app/src ./src
COPY app/package.json ./package.json

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

# Ensure app dir is owned by the node user (uid 1000) and OpenShift group perms
RUN chown -R 1000:1000 /app && chmod -R g=u /app

# Run as non-root numeric UID (works in OpenShift + kind)
USER 1000:1000

# Avoid npm entirely at runtime
CMD ["node", "src/server.js"]
