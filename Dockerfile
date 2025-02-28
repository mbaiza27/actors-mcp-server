# Generated by https://smithery.ai. See: https://smithery.ai/docs/config#dockerfile
# Stage 1: Build the TypeScript project
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy source files
COPY src ./src
COPY tsconfig.json ./

# Build the project
RUN npm run build

# Stage 2: Set up the runtime environment
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /app/dist ./dist
COPY package.json package-lock.json ./

# Install production dependencies only
RUN npm ci --omit=dev

# Expose any necessary ports (example: 3000)
EXPOSE 3000

# Set the environment variable for the Apify token
ENV APIFY_TOKEN=<your-apify-token>

# Set the entry point for the container
ENTRYPOINT ["node", "dist/main.js"]