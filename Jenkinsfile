pipeline {
    agent any

    environment {
        // Docker Hub credentials (configure these in Jenkins)
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = 'geetasree01/todolist-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    tools {
        maven 'MAVEN3.9.11' // Configure Maven in Jenkins Global Tool Configuration
        jdk 'JDK23'        // Configure JDK 17 in Jenkins Global Tool Configuration
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                echo 'Building the application with Maven...'
                dir('TodoListProject') {
                    sh 'mvn clean compile'
                }
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running unit tests...'
                dir('TodoListProject') {
                    sh 'mvn test'
                }
            }
            post {
                always {
                    dir('TodoListProject') {
                        // Publish test results
                        publishTestResults testResultsPattern: 'target/surefire-reports/*.xml'
                        
                        // Archive test reports
                        archiveArtifacts artifacts: 'target/surefire-reports/*.xml', allowEmptyArchive: true
                    }
                }
            }
        }

        stage('Package Application') {
            steps {
                echo 'Packaging the application...'
                dir('TodoListProject') {
                    sh 'mvn package -DskipTests'
                }
            }
            post {
                success {
                    dir('TodoListProject') {
                        // Archive the built JAR file
                        archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: false
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                dir('TodoListProject') {
                    script {
                        // Build Docker image
                        def dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                        
                        // Also tag as latest
                        dockerImage.tag("${DOCKER_IMAGE}:latest")
                        
                        // Store image reference for later use
                        env.DOCKER_IMAGE_ID = dockerImage.id
                    }
                }
            }
        }

        stage('Docker Security Scan') {
            steps {
                echo 'Scanning Docker image for vulnerabilities...'
                script {
                    try {
                        // Optional: Add security scanning with tools like Trivy or Snyk
                        sh """
                            echo 'Security scan placeholder - configure with your preferred security tool'
                            # docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \\
                            #   aquasec/trivy:latest image ${DOCKER_IMAGE}:${DOCKER_TAG}
                        """
                    } catch (Exception e) {
                        echo "Security scan failed: ${e.getMessage()}"
                        // Continue pipeline even if security scan fails
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        // Push both versioned and latest tags
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                echo 'Cleaning up local Docker images...'
                script {
                    try {
                        // Remove local images to save space
                        sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
                        sh "docker rmi ${DOCKER_IMAGE}:latest || true"
                        
                        // Clean up dangling images
                        sh 'docker image prune -f'
                    } catch (Exception e) {
                        echo "Cleanup failed: ${e.getMessage()}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
            
            // Clean workspace
            cleanWs()
        }
        
        success {
            echo 'Pipeline executed successfully!'
            
            // Send notification (configure your notification method)
            script {
                def message = """
                ✅ BUILD SUCCESS: TodoList Application
                
                📦 Docker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}
                🔗 Docker Hub: https://hub.docker.com/r/${DOCKER_IMAGE.replace('/', '/r/')}/tags
                🏗️ Build Number: ${BUILD_NUMBER}
                ⏰ Build Duration: ${currentBuild.durationString}
                """
                
                echo message
                
                // Uncomment and configure for your notification system:
                // slackSend(channel: '#ci-cd', message: message)
                // emailext(to: 'team@company.com', subject: 'Build Success', body: message)
            }
        }
        
        failure {
            echo 'Pipeline failed!'
            
            // Send failure notification
            script {
                def message = """
                ❌ BUILD FAILED: TodoList Application
                
                🏗️ Build Number: ${BUILD_NUMBER}
                📋 Stage: ${env.STAGE_NAME}
                🔗 Console: ${BUILD_URL}console
                """
                
                echo message
                
                // Uncomment and configure for your notification system:
                // slackSend(channel: '#ci-cd', message: message, color: 'danger')
                // emailext(to: 'team@company.com', subject: 'Build Failed', body: message)
            }
        }
        
        unstable {
            echo 'Pipeline is unstable.'
        }
    }
}
