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
FROM nginx:alpine

# Copier la configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built assets from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose the port the app runs on
EXPOSE 3000

# Command to run nginx
CMD ["nginx", "-g", "daemon off;"]
