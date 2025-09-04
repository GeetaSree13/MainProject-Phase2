#!/bin/bash

echo "🔨 Building Frontend Docker Image..."

# Navigate to Frontend directory
cd Frontend

# Build Docker image
docker build -t geetasree0103/todolist-frontend:latest .

echo "✅ Frontend image built successfully!"

# Login to Docker Hub (if not already logged in)
echo "🔐 Logging into Docker Hub..."
docker login

# Push image to Docker Hub
echo "🚀 Pushing frontend image to Docker Hub..."
docker push geetasree0103/todolist-frontend:latest

echo "✅ Frontend image pushed to Docker Hub successfully!"
echo "🎯 Image available at: geetasree0103/todolist-frontend:latest"



