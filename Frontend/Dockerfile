# Multi-stage build for Frontend
FROM node:18-alpine as builder

WORKDIR /app

# Copy frontend files
COPY . .

# Create a simple build step (for future use if needed)
RUN echo "Frontend build completed"

# Production stage with Nginx
FROM nginx:alpine

# Copy frontend files to nginx directory
COPY --from=builder /app /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Remove default nginx config (if it exists)
RUN rm -f /etc/nginx/conf.d/default.conf.template

# Create nginx log directory
RUN mkdir -p /var/log/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
