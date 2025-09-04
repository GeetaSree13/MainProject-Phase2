# Restore Jenkins Configuration After Restart

## ✅ Good News
- Jenkins data volume (`jenkins-data`) is preserved
- Jenkins is accessible at http://localhost:8090
- No initial setup required

## 📋 What Needs to be Reconfigured

### 1. **Docker Hub Credentials**
- Go to **Manage Jenkins** → **Manage Credentials**
- Add credentials with ID: `dockerhub-credentials`
- Username: `geetasree01`
- Password: Your Docker Hub password

### 2. **Maven Tool Configuration**
- Go to **Manage Jenkins** → **Global Tool Configuration**
- Add Maven with name: `MAVEN3.9.11`
- Check "Install automatically"

### 3. **JDK Tool Configuration**
- In same Global Tool Configuration page
- Add JDK with name: `JDK23` (as per your Jenkinsfile)
- Check "Install automatically"

### 4. **Pipeline Job Recreation**
- Create new Pipeline job named: `todo-app2`
- Set it to use SCM with your Git repository
- Point to Jenkinsfile in root

## 🚀 Quick Restoration Steps

1. **Access Jenkins:** http://localhost:8090
2. **Login** with your existing credentials
3. **Check if jobs exist** - they might be preserved!
4. **If jobs are missing, recreate them**

## 🔧 Quick Recreation Commands

If you need to recreate everything quickly:

### Step 1: Access Jenkins
```
Open: http://localhost:8090
```

### Step 2: Add Docker Hub Credentials
```
Manage Jenkins → Manage Credentials → Add Credentials
- Kind: Username with password
- ID: dockerhub-credentials  
- Username: geetasree01
- Password: [Your Docker Hub password]
```

### Step 3: Configure Tools
```
Manage Jenkins → Global Tool Configuration

Maven:
- Name: MAVEN3.9.11
- Install automatically: ✅

JDK:
- Name: JDK23
- Install automatically: ✅
```

### Step 4: Create Pipeline Job
```
New Item → Pipeline → Name: todo-app2

Pipeline Configuration:
- Definition: Pipeline script from SCM
- SCM: Git
- Repository URL: https://github.com/GeetaSree13/MainProject-Phase2
- Branch: */master
- Script Path: Jenkinsfile
```

## ⚡ Test Docker Access
After setup, test in Jenkins Script Console:
```groovy
println "docker --version".execute().text
println "docker ps".execute().text
```

## 🎯 Expected Result
Your pipeline should work immediately after reconfiguration since:
- ✅ Docker access is now working
- ✅ All code issues are fixed
- ✅ Jenkinsfile is correct



