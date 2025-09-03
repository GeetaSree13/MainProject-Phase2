# Jenkins Pipeline Setup Guide

This guide will help you set up the Jenkins pipeline to build and push your TodoList application to Docker Hub.

## Prerequisites

1. **Jenkins Server** with the following plugins installed:
   - Docker Pipeline Plugin
   - Maven Integration Plugin
   - Pipeline Plugin
   - Git Plugin

2. **Docker Hub Account**

3. **Maven and JDK configured in Jenkins**

## Setup Steps

### 1. Configure Jenkins Global Tools

Go to **Manage Jenkins > Global Tool Configuration** and configure:

#### Maven Configuration
- Name: `Maven-3.9.0`
- Install automatically: ✅
- Version: Latest 3.9.x

#### JDK Configuration
- Name: `JDK-17`
- Install automatically: ✅
- Version: OpenJDK 17

### 2. Configure Docker Hub Credentials

1. Go to **Manage Jenkins > Manage Credentials**
2. Select the appropriate domain (usually "Global")
3. Click **Add Credentials**
4. Configure:
   - Kind: `Username with password`
   - ID: `dockerhub-credentials`
   - Username: Your Docker Hub username
   - Password: Your Docker Hub password (or access token)
   - Description: `Docker Hub Credentials`

### 3. Update Docker Image Name

In the `Jenkinsfile`, update the following line:
```groovy
DOCKER_IMAGE = 'your-dockerhub-username/todolist-app'
```

Replace `your-dockerhub-username` with your actual Docker Hub username.

### 4. Create Jenkins Pipeline Job

1. Go to Jenkins dashboard
2. Click **New Item**
3. Enter job name (e.g., `todolist-docker-pipeline`)
4. Select **Pipeline**
5. Click **OK**

#### Configure Pipeline
In the job configuration:

1. **General Section:**
   - ✅ GitHub project (if using GitHub)
   - Project URL: Your repository URL

2. **Build Triggers:**
   - ✅ GitHub hook trigger (for automatic builds on push)
   - ✅ Poll SCM (optional fallback)

3. **Pipeline Section:**
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: Your Git repository URL
   - Credentials: Your Git credentials
   - Branch: `*/master` (or your main branch)
   - Script Path: `Jenkinsfile`

4. Click **Save**

### 5. Test the Pipeline

1. Click **Build Now** to test the pipeline
2. Monitor the build in the **Console Output**

## Pipeline Stages Explained

1. **Checkout**: Downloads source code from Git
2. **Build Application**: Compiles the Java application
3. **Run Tests**: Executes unit tests
4. **Package Application**: Creates JAR file
5. **Build Docker Image**: Creates Docker image
6. **Docker Security Scan**: Optional security scanning
7. **Push to Docker Hub**: Uploads image to Docker Hub
8. **Clean Up**: Removes local images to save space

## Running the Docker Container

After successful build and push, you can run your container:

```bash
# Pull the latest image
docker pull your-dockerhub-username/todolist-app:latest

# Run the container
docker run -d -p 8080:8080 --name todolist-app your-dockerhub-username/todolist-app:latest

# Check if it's running
docker ps

# View logs
docker logs todolist-app

# Access the application
curl http://localhost:8080
```

## Environment Variables (Optional)

You can pass environment variables to your container:

```bash
docker run -d -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=production \
  -e SERVER_PORT=8080 \
  --name todolist-app \
  your-dockerhub-username/todolist-app:latest
```

## Troubleshooting

### Common Issues:

1. **Docker not found**: Ensure Docker is installed on Jenkins agent
2. **Permission denied**: Ensure Jenkins user is in docker group
3. **Maven not found**: Check Maven tool configuration
4. **Docker Hub push fails**: Verify credentials and image name

### Useful Commands:

```bash
# Check Jenkins logs
docker logs jenkins

# Check Docker images
docker images

# Remove all unused Docker images
docker system prune -a

# View container logs
docker logs container-name
```

## Security Best Practices

1. Use Docker Hub access tokens instead of passwords
2. Scan images for vulnerabilities
3. Use non-root user in Docker containers
4. Keep base images updated
5. Use specific image tags instead of 'latest' in production

## Next Steps

1. Set up automated triggers from Git
2. Configure notification channels (Slack, email)
3. Add deployment stages for different environments
4. Implement blue-green deployment strategy
5. Add monitoring and health checks
