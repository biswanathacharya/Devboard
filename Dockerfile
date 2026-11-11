# Stage 1: Build the frontend application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package.json package-lock.json* ./
RUN npm install

# Copy the rest of the source code and build the static assets
COPY . .
RUN npm run build

# Stage 2: Serve the built files with Nginx
FROM nginx:alpine

# Copy the production build output from Stage 1 to Nginx's web root
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for incoming HTTP traffic
EXPOSE 80

# Start Nginx in the foreground so the container stays alive
CMD ["nginx", "-g", "daemon off;"]
