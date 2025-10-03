FROM node:18-alpine

WORKDIR /app

# Install production dependencies (if package-lock.json exists use ci for reproducible installs)
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --only=production; else npm install --production; fi

# Copy source
COPY . .

# Cloud Run expects the app to listen on PORT env variable and typically uses 8080
ENV PORT=8080
EXPOSE 8080

CMD ["npm", "start"]

