##########
# Stage 1: Build / Install production dependencies
##########
FROM node:18-alpine AS build

WORKDIR /usr/src/app

# Install build tools for native modules (sqlite3) then remove later in final image
RUN apk add --no-cache python3 make g++

# Copy dependency manifests first (better layer caching)
COPY package*.json ./

# Install only production dependencies (Node 18: use --omit=dev instead of deprecated --only=production)
ENV NODE_ENV=production
RUN npm ci --omit=dev

# Copy application source (tests are excluded via .dockerignore)
COPY src ./src

##########
# Stage 2: Runtime image (lighter, no build tools)
##########
FROM node:18-alpine AS runtime
WORKDIR /usr/src/app

ENV NODE_ENV=production \
		PORT=3000

# Create non-root user for security
RUN addgroup -S nodejs && adduser -S nodejs -G nodejs

# Copy only what we need from build stage
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package*.json ./
COPY --from=build /usr/src/app/src ./src

# Expose application port (Cloud Run will override PORT env var at runtime)
EXPOSE 3000

# Add simple healthcheck (optional; Cloud Run does its own, safe to keep)
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
	CMD wget -qO- http://127.0.0.1:${PORT}/items > /dev/null 2>&1 || exit 1

# Switch to non-root user
USER nodejs

LABEL org.opencontainers.image.title="gcp-pipeline" \
			org.opencontainers.image.description="Express + SQLite/Postgres demo app for Cloud Run" \
			org.opencontainers.image.source="https://github.com/fikrat86/gcp_pipeline" \
			org.opencontainers.image.version="1.0.0" \
			org.opencontainers.image.licenses="MIT"

# Directly run the node process (faster than npm start for simple case)
CMD ["node", "src/index.js"]
