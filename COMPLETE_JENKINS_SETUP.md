# Complete Jenkins Setup from Scratch

## 🎯 Quick Setup Guide (10 minutes)

Since everything was lost, here's how to quickly restore Jenkins with all configurations:

## Step 1: Initial Jenkins Setup

1. **Go to:** http://localhost:8090
2. **Get Initial Admin Password:**
```bash
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```
3. **Copy the password** and paste it in Jenkins
4. **Install suggested plugins** (wait for completion)
5. **Create admin user:**
   - Username: admin (or your choice)
   - Password: [your password]
   - Full name: Your Name
   - Email: your.email@example.com

## Step 2: Install Required Plugins

Go to **Manage Jenkins** → **Manage Plugins** → **Available**

Search and install:
- ✅ **Docker Pipeline Plugin**
- ✅ **Maven Integration Plugin** 
- ✅ **Git Plugin** (should already be installed)
- ✅ **Pipeline Plugin** (should already be installed)

Click **Install without restart**

## Step 3: Configure Global Tools

**Manage Jenkins** → **Global Tool Configuration**

### Maven Configuration:
- Click **Add Maven**
- Name: `MAVEN3.9.11`
- ✅ Install automatically
- Version: Latest 3.9.x
- **Save**

### JDK Configuration:
- Click **Add JDK**
- Name: `JDK23`
- ✅ Install automatically  
- Version: OpenJDK 23
- **Save**

## Step 4: Add Docker Hub Credentials

**Manage Jenkins** → **Manage Credentials** → **(global)** → **Add Credentials**

Configure:
```
Kind: Username with password
Scope: Global
Username: geetasree01
Password: [Your Docker Hub password]
ID: dockerhub-credentials
Description: Docker Hub Credentials
```
Click **OK**

## Step 5: Create Pipeline Job

1. **Dashboard** → **New Item**
2. **Item name:** `todo-app2`
3. **Select:** Pipeline
4. **Click OK**

### Configure Pipeline:
- **General:** Leave defaults
- **Build Triggers:** (optional) ✅ GitHub hook trigger
- **Pipeline:**
  - Definition: **Pipeline script from SCM**
  - SCM: **Git**
  - Repository URL: `https://github.com/GeetaSree13/MainProject-Phase2`
  - Credentials: (none needed for public repo)
  - Branch Specifier: `*/master`
  - Script Path: `Jenkinsfile`
- **Click Save**

## Step 6: Test Docker Access

**Manage Jenkins** → **Script Console**

Run this test:
```groovy
println "Docker version:"
println "docker --version".execute().text

println "Docker containers:"
println "docker ps".execute().text

println "Docker socket access:"
println new File("/var/run/docker.sock").exists()
```

Expected output should show Docker version and container list.

## Step 7: Run Your Pipeline

1. **Go to** `todo-app2` job
2. **Click "Build Now"**
3. **Monitor progress** in Console Output

Expected stages:
```
✅ Checkout
✅ Build Application  
✅ Run Tests
✅ Package Application
✅ Build Docker Image (should work now!)
✅ Security Scan
✅ Push to Docker Hub
✅ Clean Up
```

## 🚀 Quick Commands Reference

### Get Jenkins Initial Password:
```bash
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```

### Test Docker in Jenkins:
```bash
docker exec jenkins-blueocean docker --version
```

### Restart Jenkins if needed:
```bash
docker restart jenkins-blueocean
```

## ⚡ Verification Checklist

Before running pipeline:
- ✅ Jenkins accessible at http://localhost:8090
- ✅ Maven tool `MAVEN3.9.11` configured
- ✅ JDK tool `JDK23` configured  
- ✅ Docker Hub credentials `dockerhub-credentials` added
- ✅ Pipeline job `todo-app2` created
- ✅ Docker works in Script Console

## 🎯 Expected Final Result

After setup, your pipeline should:
1. **Pull code** from GitHub (all fixes included)
2. **Compile** Java code (setCompleted method fixed)
3. **Run tests** (passing)
4. **Build Docker image** (Docker access working)
5. **Push to Docker Hub** (geetasree01/todolist-app)
6. **Complete successfully** 🎉

## 📱 Access Your App After Success

```bash
# Pull and run your app
docker pull geetasree01/todolist-app:latest
docker run -d -p 8080:8080 --name todolist-app geetasree01/todolist-app:latest

# Access at:
http://localhost:8080          # Your TodoList app
http://localhost:8080/swagger-ui.html  # API docs
```



