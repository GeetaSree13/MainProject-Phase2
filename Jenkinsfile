pipeline {
    agent any
 
    tools {
        maven 'MAVEN3.9.11'
        jdk 'JDK23'
    }
 
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKERHUB_USERNAME = "geetasree0103"
        BACKEND_IMAGE = "${DOCKERHUB_USERNAME}/todolist-backend"
        FRONTEND_IMAGE = "${DOCKERHUB_USERNAME}/todolist-frontend"
        IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
        PATH = "/usr/local/bin:${env.PATH}"
    }
 
    stages {
        stage('Checkout from GitHub') {
            steps {
                echo "🔄 Cloning GitHub repository..."
                checkout scm
            }
        }
 
        stage('Build Backend with Maven') {
            steps {
                echo "🔨 Building Spring Boot application..."
                dir('TodoListProject') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
 
        stage('Build Docker Images') {
            parallel {
                stage('Build Backend Image') {
                    steps {
                        script {
                            echo "🐳 Building Backend Docker image..."
                            dir('TodoListProject') {
                                sh """
                                    docker build -t ${BACKEND_IMAGE}:${IMAGE_TAG} .
                                    docker tag ${BACKEND_IMAGE}:${IMAGE_TAG} ${BACKEND_IMAGE}:latest
                                """
                            }
                        }
                    }
                }
                stage('Build Frontend Image') {
                    steps {
                        script {
                            echo "🎨 Building Frontend Docker image..."
                            dir('Frontend') {
                                sh """
                                    docker build -t ${FRONTEND_IMAGE}:${IMAGE_TAG} .
                                    docker tag ${FRONTEND_IMAGE}:${IMAGE_TAG} ${FRONTEND_IMAGE}:latest
                                """
                            }
                        }
                    }
                }
            }
        }
 
        stage('Login to DockerHub') {
            steps {
                script {
                    echo "🔐 Logging into Docker Hub..."
                    sh """
                        docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW
                    """
                }
            }
        }
 
        stage('Push Docker Images to DockerHub') {
            parallel {
                stage('Push Backend Image') {
                    steps {
                        script {
                            echo "📤 Pushing Backend image to DockerHub..."
                            sh """
                                docker push ${BACKEND_IMAGE}:${IMAGE_TAG}
                                docker push ${BACKEND_IMAGE}:latest
                            """
                        }
                    }
                }
                stage('Push Frontend Image') {
                    steps {
                        script {
                            echo "📤 Pushing Frontend image to DockerHub..."
                            sh """
                                docker push ${FRONTEND_IMAGE}:${IMAGE_TAG}
                                docker push ${FRONTEND_IMAGE}:latest
                            """
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "☸️ Deploying to Kubernetes cluster..."
                    sh """
                        # Update image tags in Kubernetes manifests
                        sed -i '' 's|image: ${DOCKERHUB_USERNAME}/todolist-backend:.*|image: ${BACKEND_IMAGE}:${IMAGE_TAG}|g' k8s/backend-deployment.yaml
                        sed -i '' 's|image: ${DOCKERHUB_USERNAME}/todolist-frontend:.*|image: ${FRONTEND_IMAGE}:${IMAGE_TAG}|g' k8s/frontend-deployment.yaml
                        
                        # Apply Kubernetes manifests
                        kubectl apply -f k8s/namespace.yaml
                        kubectl apply -f k8s/mongodb-deployment.yaml
                        kubectl apply -f k8s/backend-deployment.yaml
                        kubectl apply -f k8s/frontend-deployment.yaml
                        kubectl apply -f k8s/ingress.yaml
                        
                        # Wait for deployments to be ready
                        kubectl rollout status deployment/mongodb -n todolist-app --timeout=300s
                        kubectl rollout status deployment/todolist-backend -n todolist-app --timeout=300s
                        kubectl rollout status deployment/todolist-frontend -n todolist-app --timeout=300s
                    """
                }
            }
        }
 
        stage('Clean Up Local Images') {
            steps {
                script {
                    echo "🧹 Cleaning up local Docker images..."
                    sh """
                        docker rmi ${BACKEND_IMAGE}:${IMAGE_TAG} || true
                        docker rmi ${BACKEND_IMAGE}:latest || true
                        docker rmi ${FRONTEND_IMAGE}:${IMAGE_TAG} || true
                        docker rmi ${FRONTEND_IMAGE}:latest || true
                        docker image prune -f
                    """
                }
            }
        }
    }
 
    post {
        success {
            echo "✅ Build, push, and deployment completed successfully!"
            echo "🎯 Backend Image: ${BACKEND_IMAGE}:${IMAGE_TAG}"
            echo "🎯 Frontend Image: ${FRONTEND_IMAGE}:${IMAGE_TAG}"
            echo "🏗️ Build Number: ${BUILD_NUMBER}"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for errors."
        }
        always {
            sh "docker logout || true"
        }
    }
}
