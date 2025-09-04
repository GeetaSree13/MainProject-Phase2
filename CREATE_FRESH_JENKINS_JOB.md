# Create Fresh Jenkins Pipeline Job

The Git configuration got corrupted. Here's how to create a completely fresh job:

## 🔧 Quick Steps to Recreate the Job

### Step 1: Access Jenkins
- Go to: http://localhost:8090
- Login with your credentials

### Step 2: Create New Pipeline Job
1. **Click "New Item"**
2. **Item name:** `todolist-pipeline` (new name to avoid conflicts)
3. **Select:** Pipeline
4. **Click "OK"**

### Step 3: Configure the Pipeline

#### General Section:
- Leave default settings

#### Build Triggers (Optional):
- ✅ GitHub hook trigger for GITScm polling
- ✅ Poll SCM: `H/5 * * * *`

#### Pipeline Section:
**Definition:** Pipeline script from SCM

**SCM:** Git

**Repository URL:** `https://github.com/GeetaSree13/MainProject-Phase2`

**Credentials:** None (public repo)

**Branches to build:** `*/master`

**Repository browser:** (Auto)

**Additional Behaviours:** (Leave empty)

**Script Path:** `Jenkinsfile`

#### Advanced Settings:
- **Lightweight checkout:** ✅ (enabled)

### Step 4: Save and Test
1. **Click "Save"**
2. **Click "Build Now"**

## 🎯 Expected Result

The fresh job should:
✅ Clone Git repository properly
✅ Find and execute Jenkinsfile
✅ Run complete pipeline successfully

## 🚀 Alternative: Pipeline Script Directly

If SCM approach still fails, use **Pipeline script** instead:

1. **Definition:** Pipeline script (instead of SCM)
2. **Script:** Copy the entire Jenkinsfile content into the text area
3. **Save and run**

## ✅ Verification Steps

After creating the job:
1. Check "Pipeline Syntax" link works
2. Verify Git repository is accessible
3. Run pipeline and monitor Console Output

## 🔧 If Still Having Issues

Try these troubleshooting steps:

### Check Git Plugin
- Go to Manage Jenkins > Manage Plugins
- Ensure Git plugin is installed and updated

### Test Git Access
- Go to Manage Jenkins > Script Console
- Run: `"git --version".execute().text`

### Manual Git Test
```groovy
node {
    git url: 'https://github.com/GeetaSree13/MainProject-Phase2', branch: 'master'
    sh 'ls -la'
    sh 'pwd'
}
```

This basic pipeline can test if Git works at all.



