FROM node:18-alpine as builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies with specific flags to reduce warnings
RUN npm install --no-audit --no-fund --no-optional

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Production image
FROM node:18-alpine

WORKDIR /app

# Install serve with specific version to avoid deprecation warnings
RUN npm install -g serve@14.2.1 --no-audit --no-fund

# Copy built assets from builder stage
COPY --from=builder /app/build ./build

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["serve", "-s", "build", "-l", "3000"]
