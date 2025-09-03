#!/bin/bash

# Quick Run Script for TodoList Application
# This script helps you run the application after Jenkins builds it

echo "🚀 TodoList Application Quick Run Script"
echo "========================================"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

print_status "Docker is running ✓"

# Pull the latest image
print_status "Pulling latest TodoList image from Docker Hub..."
if docker pull geetasree01/todolist-app:latest; then
    print_status "Image pulled successfully ✓"
else
    print_error "Failed to pull image. Make sure the Jenkins pipeline has run successfully."
    exit 1
fi

# Stop existing container if running
if docker ps -q -f name=todolist-app | grep -q .; then
    print_warning "Stopping existing todolist-app container..."
    docker stop todolist-app
    docker rm todolist-app
fi

# Run the application
print_status "Starting TodoList application..."
docker run -d \
    --name todolist-app \
    -p 8080:8080 \
    --restart unless-stopped \
    geetasree01/todolist-app:latest

if [ $? -eq 0 ]; then
    print_status "TodoList application started successfully! ✓"
    echo ""
    echo "📱 Application Details:"
    echo "   🌐 URL: http://localhost:8080"
    echo "   📋 Swagger UI: http://localhost:8080/swagger-ui.html"
    echo "   🔍 Health Check: http://localhost:8080/actuator/health"
    echo ""
    echo "🐳 Container Details:"
    echo "   📛 Name: todolist-app"
    echo "   🔌 Port: 8080"
    echo ""
    
    # Wait for application to start
    print_status "Waiting for application to start..."
    sleep 10
    
    # Check if application is responding
    if curl -s http://localhost:8080 > /dev/null; then
        print_status "Application is responding! 🎉"
        echo ""
        echo "🚀 Your TodoList application is now running!"
        echo "   Open http://localhost:8080 in your browser"
    else
        print_warning "Application started but may still be initializing..."
        echo "   Please wait a few more seconds and try: http://localhost:8080"
    fi
    
    echo ""
    echo "📊 Useful Commands:"
    echo "   📋 View logs: docker logs todolist-app"
    echo "   📋 Follow logs: docker logs -f todolist-app"
    echo "   ⏹️  Stop app: docker stop todolist-app"
    echo "   🗑️  Remove app: docker rm todolist-app"
    echo ""
    
else
    print_error "Failed to start TodoList application"
    exit 1
fi
