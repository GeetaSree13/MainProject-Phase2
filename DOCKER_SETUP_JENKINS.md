# Fix Docker "Command Not Found" in Jenkins

## 🚨 Issue
```
docker: command not found
```

Jenkins server doesn't have Docker installed or configured properly.

## 🔧 Solutions

### Option 1: Install Docker on Jenkins Server (macOS)

Since you're running Jenkins on macOS, here's how to fix it:

#### Step 1: Install Docker Desktop
```bash
# Download and install Docker Desktop for Mac
# Go to: https://docs.docker.com/desktop/mac/install/
# Or install via Homebrew:
brew install --cask docker
```

#### Step 2: Start Docker Desktop
1. Open Docker Desktop application
2. Wait for Docker to start (whale icon in menu bar)
3. Verify Docker is running:
```bash
docker --version
docker ps
```

#### Step 3: Add Docker to Jenkins PATH
1. **Find Docker path:**
```bash
which docker
# Usually: /usr/local/bin/docker
```

2. **Configure Jenkins:**
   - Go to **Manage Jenkins** → **Global Tool Configuration**
   - Scroll to **Docker** section
   - Click **Add Docker**
   - Name: `Docker`
   - Installation root: `/usr/local/bin` (or your Docker path)
   - OR check **Install automatically**

#### Step 4: Add Jenkins User to Docker Group
```bash
# Add current user to docker group (if needed)
sudo dscl . -append /Groups/staff GroupMembership jenkins

# Or create docker group and add jenkins user
sudo dscacheutil -flushcache

# Restart Jenkins after this change
```

#### Step 5: Restart Jenkins
```bash
# If Jenkins is running as service:
sudo brew services restart jenkins-lts

# Or restart the Jenkins application
```

### Option 2: Use Docker in Docker (Advanced)

If you can't install Docker directly, modify the Jenkinsfile to use Docker-in-Docker:

```groovy
pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    // ... rest of pipeline
}
```

### Option 3: Skip Docker Stages (Temporary)

If you want to test the pipeline without Docker first:

```groovy
stage('Build Docker Image') {
    when {
        expression { 
            return sh(script: 'which docker', returnStatus: true) == 0 
        }
    }
    steps {
        // Docker build steps
    }
}
```

## 🧪 Testing Docker Installation

After installation, test Docker:

```bash
# Check Docker version
docker --version

# Test Docker run
docker run hello-world

# Check if Jenkins can access Docker
sudo -u jenkins docker ps
```

## 🔍 Troubleshooting

### Issue: Permission Denied
```bash
# Fix permissions
sudo chmod 666 /var/run/docker.sock
# Or add user to docker group
sudo usermod -aG docker jenkins
```

### Issue: Docker Desktop not in PATH
```bash
# Add to shell profile
echo 'export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Issue: Jenkins can't find Docker
1. Check Jenkins environment variables
2. Add Docker path to Jenkins system configuration
3. Restart Jenkins service

## ✅ Verification Steps

1. **Docker is installed:** `docker --version`
2. **Docker is running:** `docker ps`
3. **Jenkins can access Docker:** Check Jenkins system information
4. **Pipeline can use Docker:** Run a simple Docker command in pipeline

## 🚀 Quick Fix Commands

```bash
# Install Docker Desktop (if not installed)
brew install --cask docker

# Start Docker Desktop
open /Applications/Docker.app

# Verify installation
docker --version
docker run hello-world

# Add to PATH (if needed)
export PATH="/usr/local/bin:$PATH"

# Restart Jenkins
brew services restart jenkins-lts
```

After completing these steps, your Jenkins pipeline should be able to find and use Docker commands.
