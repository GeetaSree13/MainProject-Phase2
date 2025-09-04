# Fix Jenkins Docker-in-Docker Issue

## 🚨 Problem
Jenkins is running in a Docker container but can't access the host Docker daemon to build images.

## 🔧 Solution: Restart Jenkins with Docker Access

### Step 1: Stop Current Jenkins Container
```bash
docker stop jenkins-blueocean
docker rm jenkins-blueocean
```

### Step 2: Restart Jenkins with Docker Socket Access
```bash
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  myjenkins-blueocean:lts
```

### Step 3: Alternative - Simpler Approach (Recommended)
```bash
# Stop and remove current container
docker stop jenkins-blueocean
docker rm jenkins-blueocean

# Start with Docker socket mounted (simpler approach)
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume /usr/local/bin/docker:/usr/bin/docker \
  myjenkins-blueocean:lts
```

### Step 4: Verify Jenkins Can Access Docker
After restarting Jenkins:

1. Go to Jenkins → Manage Jenkins → Script Console
2. Run this script:
```groovy
println "docker --version".execute().text
println "docker ps".execute().text
```

## 🚀 Quick Commands to Execute

```bash
# 1. Stop current Jenkins
docker stop jenkins-blueocean
docker rm jenkins-blueocean

# 2. Restart with Docker access
docker run -d \
  --name jenkins-blueocean \
  --restart=on-failure \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/local/bin/docker:/usr/bin/docker:ro \
  myjenkins-blueocean:lts

# 3. Check if running
docker ps | grep jenkins
```

## ✅ Verification Steps

1. **Jenkins is running:** `docker ps | grep jenkins`
2. **Access Jenkins:** http://localhost:8080
3. **Test Docker in Jenkins:** Go to Jenkins Script Console and run `"docker --version".execute().text`
4. **Run your pipeline:** It should now be able to build Docker images

## 🔄 Alternative: Use Docker Plugin

If you prefer not to restart Jenkins, you can:

1. Install **Docker Pipeline Plugin** in Jenkins
2. Use Docker agent in your pipeline:
```groovy
agent {
    docker {
        image 'docker:latest'
        args '-v /var/run/docker.sock:/var/run/docker.sock'
    }
}
```

## ⚠️ Important Notes

- You'll need to re-configure any Jenkins settings after restart
- All your job configurations should be preserved in the jenkins-data volume
- Make sure Docker Desktop is running before starting Jenkins

## 🎯 Expected Result

After fixing this, your pipeline should successfully:
- ✅ Build Docker image
- ✅ Push to Docker Hub
- ✅ Complete all stages



