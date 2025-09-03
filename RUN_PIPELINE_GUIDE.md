# How to Run the Jenkins Pipeline - Step by Step Guide

## 🚀 Quick Start Checklist

Before running the pipeline, ensure you have:
- ✅ Jenkins server running
- ✅ Docker installed on Jenkins server
- ✅ Docker Hub account (geetasree01)
- ✅ Git repository accessible to Jenkins

## 📋 Step-by-Step Execution

### Step 1: Configure Jenkins Tools

1. **Go to Jenkins Dashboard** → **Manage Jenkins** → **Global Tool Configuration**

2. **Configure Maven:**
   - Click **Add Maven**
   - Name: `MAVEN3.9.11` (exactly as in Jenkinsfile)
   - ✅ Install automatically
   - Version: `3.9.11` or latest 3.9.x
   - Click **Save**

3. **Configure JDK:**
   - Click **Add JDK**
   - Name: `JDK-17` (exactly as in Jenkinsfile)
   - ✅ Install automatically
   - Version: `OpenJDK 17`
   - Click **Save**

### Step 2: Set Up Docker Hub Credentials

1. **Go to** **Manage Jenkins** → **Manage Credentials**
2. **Click** on **(global)** domain
3. **Click** **Add Credentials**
4. **Configure:**
   ```
   Kind: Username with password
   Scope: Global
   Username: geetasree01
   Password: [Your Docker Hub password or access token]
   ID: dockerhub-credentials
   Description: Docker Hub Credentials for geetasree01
   ```
5. **Click** **OK**

### Step 3: Create Pipeline Job

1. **Go to Jenkins Dashboard**
2. **Click** **New Item**
3. **Enter name:** `todolist-docker-pipeline`
4. **Select** **Pipeline**
5. **Click** **OK**

### Step 4: Configure Pipeline Job

In the job configuration page:

#### General Section:
- ✅ **GitHub project** (if using GitHub)
- **Project URL:** `https://github.com/your-username/your-repo-name`

#### Build Triggers (Optional):
- ✅ **GitHub hook trigger for GITScm polling** (for auto-builds)
- ✅ **Poll SCM** with schedule: `H/5 * * * *` (check every 5 minutes)

#### Pipeline Section:
- **Definition:** `Pipeline script from SCM`
- **SCM:** `Git`
- **Repository URL:** Your Git repository URL
- **Credentials:** Select your Git credentials
- **Branch Specifier:** `*/master` (or your main branch)
- **Script Path:** `Jenkinsfile`

**Click** **Save**

### Step 5: Run the Pipeline

1. **Go to your pipeline job**
2. **Click** **Build Now**
3. **Monitor the build** by clicking on the build number → **Console Output**

## 📊 What to Expect During Execution

### Build Stages Timeline:
```
1. Checkout           (~30 seconds)
2. Build Application  (~2-3 minutes)
3. Run Tests         (~1-2 minutes)
4. Package Application (~1 minute)
5. Build Docker Image (~3-5 minutes)
6. Security Scan     (~1 minute)
7. Push to Docker Hub (~2-3 minutes)
8. Clean Up          (~30 seconds)
```

**Total Expected Time:** ~10-15 minutes (first run may take longer)

### Success Indicators:
- ✅ All stages show **green checkmarks**
- ✅ Console shows: `Pipeline executed successfully!`
- ✅ Docker image appears in Docker Hub: `https://hub.docker.com/r/geetasree01/todolist-app`

## 🐳 After Successful Build - Running Your Application

### Option 1: Run Locally
```bash
# Pull the image
docker pull geetasree01/todolist-app:latest

# Run the container
docker run -d -p 8080:8080 --name todolist-app geetasree01/todolist-app:latest

# Check if running
docker ps

# Test the application
curl http://localhost:8080
# or open http://localhost:8080 in browser
```

### Option 2: Run with MongoDB (if needed)
```bash
# Create a network
docker network create todolist-network

# Run MongoDB
docker run -d --name mongodb --network todolist-network \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  mongo:latest

# Run your app connected to MongoDB
docker run -d -p 8080:8080 --name todolist-app --network todolist-network \
  -e SPRING_DATA_MONGODB_URI=mongodb://admin:password@mongodb:27017/todolist \
  geetasree01/todolist-app:latest
```

### Option 3: Using Docker Compose
Create `docker-compose.yml`:
```yaml
version: '3.8'
services:
  app:
    image: geetasree01/todolist-app:latest
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATA_MONGODB_URI=mongodb://admin:password@mongodb:27017/todolist
    depends_on:
      - mongodb

  mongodb:
    image: mongo:latest
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password
    ports:
      - "27017:27017"
```

Run with: `docker-compose up -d`

## 🔍 Monitoring and Logs

### View Application Logs:
```bash
docker logs todolist-app
```

### View Real-time Logs:
```bash
docker logs -f todolist-app
```

### Check Application Health:
```bash
curl http://localhost:8080/actuator/health
```

## 🛠️ Troubleshooting Common Issues

### Issue 1: Maven Tool Not Found
**Error:** `Maven tool 'MAVEN3.9.11' not found`
**Solution:** Check Global Tool Configuration and ensure exact name match

### Issue 2: Docker Permission Denied
**Error:** `Permission denied while trying to connect to Docker`
**Solution:** Add Jenkins user to docker group:
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Issue 3: Docker Hub Push Failed
**Error:** `unauthorized: authentication required`
**Solution:** Verify Docker Hub credentials in Jenkins

### Issue 4: Port Already in Use
**Error:** `Port 8080 is already in use`
**Solution:** 
```bash
# Find and stop conflicting container
docker ps
docker stop <container-name>

# Or use different port
docker run -d -p 8081:8080 --name todolist-app geetasree01/todolist-app:latest
```

## 🔄 Re-running the Pipeline

- **Manual:** Click **Build Now** in Jenkins
- **Automatic:** Push code to Git (if GitHub webhooks configured)
- **Scheduled:** Set up cron-style scheduling in Build Triggers

## 📈 Next Steps After Success

1. **Set up automatic triggers** from Git pushes
2. **Configure notifications** (Slack/Email)
3. **Add deployment to staging/production**
4. **Set up monitoring** (Prometheus, Grafana)
5. **Implement blue-green deployment**

## 🚨 Emergency Commands

### Stop Everything:
```bash
docker stop $(docker ps -q)
```

### Clean Up All:
```bash
docker system prune -a --volumes
```

### Reset Jenkins Job:
1. Go to job → **Configure**
2. Scroll down → **Pipeline** → **Definition** → **Pipeline script**
3. Paste Jenkinsfile content directly
4. **Save** and **Build Now**
