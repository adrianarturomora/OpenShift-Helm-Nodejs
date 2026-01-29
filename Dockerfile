# syntax=docker/dockerfile:1

##########
# deps/build stage (has npm)
##########
FROM node:22-alpine AS deps
WORKDIR /app

# Install only prod deps using the lockfile
COPY app/package*.json ./
RUN npm ci --omit=dev

##########
# runtime stage (NO npm here)
##########
FROM gcr.io/distroless/nodejs22-debian12:nonroot AS runtime
WORKDIR /app

# Copy production node_modules + app source
COPY --from=deps /app/node_modules ./node_modules
COPY app/src ./src
COPY app/package.json ./package.json

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

# Run node directly (not npm)
CMD ["src/server.js"]
