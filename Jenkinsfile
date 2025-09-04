pipeline {
    agent any
 
    tools {
        maven 'MAVEN3.9.11'
        jdk 'JDK23'
    }
 
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKERHUB_REPO = "geetasree0103/todolist-app"
        APP_VERSION = "v1.0.${BUILD_NUMBER}"
        PATH = "/usr/local/bin:${env.PATH}"
    }
 
    stages {
        stage('Checkout from GitHub') {
            steps {
                echo "Cloning GitHub repository..."
                checkout scm
            }
        }
 
        stage('Build with Maven') {
            steps {
                echo "Running Maven build..."
                sh '''
                    cd TodoListProject
                    mvn clean install -DskipTests
                '''
            }
        }
 
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image from Dockerfile..."
                    sh """
                        cd TodoListProject
                        docker build -t $DOCKERHUB_REPO:$APP_VERSION .
                    """
                }
            }
        }
 
        stage('Login to DockerHub') {
            steps {
                script {
                    echo "Logging into Docker Hub..."
                    sh """
                        docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW
                    """
                }
            }
        }
 
        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    echo "🚀 Pushing Docker image to DockerHub..."
                    sh """
                        docker push $DOCKERHUB_REPO:$APP_VERSION
                        docker tag $DOCKERHUB_REPO:$APP_VERSION $DOCKERHUB_REPO:latest
                        docker push $DOCKERHUB_REPO:latest
                    """
                }
            }
        }
    }
 
    post {
        success {
            echo "✅ Build, Docker image, and push completed successfully!"
            echo "📦 Docker Image: $DOCKERHUB_REPO:$APP_VERSION"
            echo "🏗️ Build Number: ${BUILD_NUMBER}"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for errors."
        }
    }
}