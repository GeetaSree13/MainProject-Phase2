# 🚀 Kubernetes Deployment Guide - TodoList Application

This guide will help you deploy your complete TodoList application (Frontend + Backend + MongoDB) to a Kubernetes cluster.

## 📋 Prerequisites

### 1. Kubernetes Cluster Setup

Choose **ONE** of these options:

#### Option A: Docker Desktop (Recommended for Mac)
```bash
# Enable Kubernetes in Docker Desktop
# Go to Docker Desktop Settings → Kubernetes → Enable Kubernetes
```

#### Option B: Minikube
```bash
# Install minikube
brew install minikube

# Start minikube cluster
minikube start --driver=docker

# Enable ingress addon
minikube addons enable ingress
```

#### Option C: Kind (Kubernetes in Docker)
```bash
# Install kind
brew install kind

# Create cluster
kind create cluster --name todolist-cluster
```

### 2. Required Tools
```bash
# Install kubectl (if not already installed)
brew install kubectl

# Verify installation
kubectl version --client
```

## 🚀 Deployment Steps

### Step 1: Build and Push Frontend Image
```bash
# Build and push frontend Docker image
./build-and-push-frontend.sh
```

### Step 2: Deploy to Kubernetes
```bash
# Deploy complete application
./deploy-to-k8s.sh
```

### Step 3: Access Your Application

#### If using Docker Desktop or Kind:
```bash
# Option 1: Port Forward (Recommended)
kubectl port-forward service/todolist-frontend-service 8080:80 -n todolist-app

# Then access: http://localhost:8080
```

#### If using Minikube:
```bash
# Get service URL
minikube service todolist-frontend-loadbalancer -n todolist-app

# Or port forward
kubectl port-forward service/todolist-frontend-service 8080:80 -n todolist-app
```

#### If using Ingress:
```bash
# Add to /etc/hosts (requires admin privileges)
echo "127.0.0.1 todolist.local" | sudo tee -a /etc/hosts

# Access: http://todolist.local
```

## 📊 Monitoring & Management

### Check Application Status
```bash
# View all resources
kubectl get all -n todolist-app

# Check pod logs
kubectl logs -f deployment/todolist-backend -n todolist-app
kubectl logs -f deployment/todolist-frontend -n todolist-app
kubectl logs -f deployment/mongodb -n todolist-app

# Check pod status
kubectl describe pod <pod-name> -n todolist-app
```

### Scaling Application
```bash
# Scale backend
kubectl scale deployment todolist-backend --replicas=3 -n todolist-app

# Scale frontend  
kubectl scale deployment todolist-frontend --replicas=3 -n todolist-app
```

### Update Application
```bash
# Update backend image
kubectl set image deployment/todolist-backend todolist-backend=geetasree0103/todolist-app:v2 -n todolist-app

# Update frontend image
kubectl set image deployment/todolist-frontend todolist-frontend=geetasree0103/todolist-frontend:v2 -n todolist-app
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Pods not starting
```bash
kubectl get events -n todolist-app --sort-by='.lastTimestamp'
kubectl describe pod <failing-pod-name> -n todolist-app
```

#### 2. Database connection issues
```bash
# Check MongoDB service
kubectl get svc mongodb-service -n todolist-app

# Test connectivity from backend pod
kubectl exec -it deployment/todolist-backend -n todolist-app -- curl mongodb-service:27017
```

#### 3. Image pull errors
```bash
# Check if images exist on Docker Hub
docker pull geetasree0103/todolist-app:latest
docker pull geetasree0103/todolist-frontend:latest
```

#### 4. Ingress not working
```bash
# Check ingress controller
kubectl get ingressclass

# Check ingress status
kubectl describe ingress todolist-ingress -n todolist-app
```

## 🗑️ Cleanup

### Remove Application
```bash
# Delete namespace (removes everything)
kubectl delete namespace todolist-app

# Or delete individual resources
kubectl delete -f k8s/
```

### Stop Cluster
```bash
# For Minikube
minikube stop

# For Kind
kind delete cluster --name todolist-cluster
```

## 🌟 Application Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │    Backend      │    │    MongoDB      │
│  (Nginx +       │────│  (Spring Boot)  │────│   (Database)    │
│   HTML/JS/CSS)  │    │     API         │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌─────────────────┐              │
         └──────────────│   Kubernetes    │──────────────┘
                        │    Cluster      │
                        └─────────────────┘
```

## 📱 Features Available

- ✅ **Scalable**: Multiple replicas of frontend and backend
- ✅ **Persistent**: MongoDB data persists across restarts
- ✅ **Load Balanced**: Traffic distributed across replicas
- ✅ **Health Checks**: Readiness and liveness probes
- ✅ **Resource Management**: CPU and memory limits
- ✅ **Configuration**: ConfigMaps for environment variables
- ✅ **External Access**: Ingress and LoadBalancer options

## 🎯 Next Steps

1. **Set up monitoring** with Prometheus and Grafana
2. **Add logging** with ELK stack
3. **Implement CI/CD** pipeline for automatic deployments
4. **Add SSL/TLS** certificates for HTTPS
5. **Set up backup** for MongoDB data



