#!/bin/bash

echo "🚀 Starting TodoList Application with MongoDB..."

# Stop any existing containers
echo "📋 Stopping existing containers..."
docker-compose down 2>/dev/null || true

# Start the application with MongoDB
echo "🐳 Starting MongoDB and TodoList application..."
docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 10

# Show status
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "✅ Application should be available at:"
echo "🌐 TodoList App: http://localhost:8080"
echo "🍃 MongoDB: localhost:27017"
echo ""
echo "📋 To stop the application:"
echo "   docker-compose down"
echo ""
echo "📋 To view logs:"
echo "   docker-compose logs -f todolist-app"
echo "   docker-compose logs -f mongodb"



