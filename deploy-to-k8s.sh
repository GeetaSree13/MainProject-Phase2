#!/bin/bash

echo "🚀 Deploying TodoList Application to Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster. Please check your cluster connection."
    exit 1
fi

echo "✅ Kubernetes cluster is accessible!"

# Deploy all manifests
echo "📦 Applying Kubernetes manifests..."

# Apply in order
kubectl apply -f k8s/00-namespace.yaml
echo "✅ Namespace created"

kubectl apply -f k8s/01-mongodb.yaml
echo "✅ MongoDB deployed"

kubectl apply -f k8s/02-backend.yaml  
echo "✅ Backend deployed"

kubectl apply -f k8s/03-frontend.yaml
echo "✅ Frontend deployed"

kubectl apply -f k8s/04-ingress.yaml
echo "✅ Ingress configured"

echo ""
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n todolist-app
kubectl wait --for=condition=available --timeout=300s deployment/todolist-backend -n todolist-app  
kubectl wait --for=condition=available --timeout=300s deployment/todolist-frontend -n todolist-app

echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📊 Checking deployment status..."
kubectl get pods -n todolist-app
echo ""
kubectl get services -n todolist-app
echo ""
kubectl get ingress -n todolist-app

echo ""
echo "🌐 Access your application:"
echo "   - If using Ingress: http://todolist.local"
echo "   - If using NodePort: http://localhost:30080"
echo "   - If using Minikube: minikube service todolist-frontend-loadbalancer -n todolist-app"
echo ""
echo "📋 Useful commands:"
echo "   - View pods: kubectl get pods -n todolist-app"
echo "   - View logs: kubectl logs -f deployment/todolist-backend -n todolist-app"
echo "   - Port forward: kubectl port-forward service/todolist-frontend-service 8080:80 -n todolist-app"



