# syntax=docker/dockerfile:1
FROM node:20-alpine

WORKDIR /app

# Upgrade npm to fix vulnerabilities in npm's bundled deps
RUN npm install -g npm@latest

# Install deps first for better caching
COPY app/package*.json ./
RUN npm ci --omit=dev

# Copy app source
COPY app/ ./

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

# Ensure app dir is owned by the node user (uid 1000)
RUN chown -R 1000:1000 /app

# Run as non-root numeric UID (works everywhere, OpenShift-safe)
USER 1000:1000

CMD ["npm", "start"]
