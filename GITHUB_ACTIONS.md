# GitHub Actions - Automated .dmg Build Guide

## 🎯 Quick Start

You now have **automated GitHub Actions workflows** that build the .dmg file on GitHub's macOS runners!

### Get Your .dmg in 3 Steps:

1. **Push the workflow files:**
```bash
git add .github/workflows/
git commit -m "Add GitHub Actions CI/CD"
git push origin main
```

2. **Go to your repository and click Actions tab**
   - Select "Build macOS DMG"
   - Click "Run workflow"
   - Wait 15-30 minutes

3. **Download the .dmg file:**
   - Click the completed workflow run
   - Scroll to "Artifacts"
   - Download "TheMoonAndStars-DMG"

---

## 🚀 Features

✅ **Fully Automated** - Builds on every push to main  
✅ **Cloud-Based** - No local macOS machine needed  
✅ **Free** - Uses GitHub's free macOS runners  
✅ **Multiple Artifacts** - DMG, APP bundle, ZIP archive  
✅ **GitHub Releases** - Optional automatic releases  
✅ **Retention** - Artifacts kept for 30 days  

---

## 📋 Available Workflows

### Main Workflow: `build-dmg.yml`
**What it does:**
- Runs on push to main/develop
- Runs on pull requests
- Can be triggered manually
- Comprehensive logging
- Uploads all artifacts
- Can create GitHub Release

**Manual trigger:**
```
Actions tab → Build macOS DMG → Run workflow → Select options → Run
```

### Alternative: `quick-build.yml`
**What it does:**
- Manual trigger only
- Faster feedback
- Simpler output
- Ideal for quick builds

---

## 🔄 Automatic Builds

The workflow automatically builds when:
- ✅ You push to `main` branch
- ✅ You push to `develop` branch
- ✅ You create a pull request to `main`

All builds create artifacts that you can download.

---

## 🎮 Manual Trigger

To manually trigger a build:

1. **Go to Actions tab** in your GitHub repository
2. **Select "Build macOS DMG"** workflow
3. **Click "Run workflow"** button
4. **Choose options:**
   - Default: Just build
   - Check "Create Release": Also publish a GitHub Release
5. **Click green "Run workflow"** button
6. **Wait** 15-30 minutes (watch the progress)
7. **Download** from artifacts or releases

---

## 📥 Getting Your .dmg

### From Artifacts (Easiest)
1. Go to Actions tab
2. Click the latest workflow run
3. Scroll down to "Artifacts"
4. Download "TheMoonAndStars-DMG"

### From GitHub Releases
1. Go to Releases tab
2. Click latest release
3. Download the .dmg file

---

## 🧪 Test Your .dmg

Once you have the .dmg:

**On macOS:**
```bash
# Double-click to mount
open TheMoonAndStars.dmg

# Then drag app to Applications and launch
```

**Issues?**
- See BUILD_MACOS.md troubleshooting section
- Check Console.app for error logs

---

## 💰 Cost

**GitHub Free Plan:**
- ✅ 3,000 minutes/month free
- ✅ Each build: ~20-30 minutes
- ✅ You get: ~100 free builds/month
- ✅ **More than enough!**

No charges unless you exceed free tier.

---

## 🔧 Customization

### Build on Different macOS Versions
Edit `build-dmg.yml` and change:
```yaml
runs-on: macos-latest  # or macos-13, macos-12
```

### Schedule Automatic Builds
Edit `build-dmg.yml` and add:
```yaml
  schedule:
    - cron: '0 2 * * 0'  # Weekly on Sunday
```

### Keep Artifacts Longer
Edit retention-days (default 30):
```yaml
retention-days: 60  # Days to keep artifacts
```

See `.github/workflows/README.md` for more options.

---

## 📊 Monitoring

### Watch Build Progress
1. Go to Actions tab
2. Click running workflow
3. Click a step to see details
4. Watch real-time logs

### Build Logs
Each build creates detailed logs showing:
- Prerequisites check
- Qt download progress
- Build compilation
- Deployment status
- Final artifact creation

### Build Status Badge
Add to README.md:
```markdown
![Builds](https://github.com/apollobots2025-beep/themoonandstars/actions/workflows/build-dmg.yml/badge.svg)
```

---

## ✨ What You Get

Each successful build creates:

1. **TheMoonAndStars.dmg** (100-300 MB)
   - Professional installer
   - Drag-and-drop to Applications
   - Custom background
   - Ready for distribution

2. **appTheMoonAndStars.app** (200-500 MB)
   - Executable application bundle
   - Includes all Qt dependencies
   - Can run directly

3. **TheMoonAndStars-macOS.zip** (150-400 MB)
   - Compressed app for backup/distribution

---

## 🐛 Troubleshooting

### Workflow Doesn't Run
**Solution:** Enable Actions in Settings
- Settings → Actions → Allow all actions

### Build Fails
**Solution:** Check logs
- Click workflow run
- Click failed step
- Read error message
- Fix issue based on error

### Can't Find Artifacts
**Solution:** Check retention
- Default: 30 days old
- Increase `retention-days` in workflow
- Or create a Release instead

### Build Timeout
**Solution:** Increase timeout or retry
- Default: 60 minutes (more than enough)
- If Qt download slow, just retry
- GitHub has good internet

---

## 🎓 How It Works

```
1. You push code or manually trigger
2. GitHub checks out the code on a macOS runner
3. Installs dependencies (cmake, python3)
4. Runs build_mac.sh
5. Qt 6.6.0 downloads automatically (~1-2 GB)
6. Application builds
7. DMG is created
8. Artifacts uploaded to GitHub
9. You download .dmg and use it!
```

**Total time:** 15-30 minutes (first run with Qt)

---

## 🚀 Next Steps

### 1. Commit Workflow Files
```bash
git add .github/workflows/
git commit -m "Add automated macOS build"
git push
```

### 2. Trigger First Build
- Go to Actions tab
- Run "Build macOS DMG"
- Watch the build

### 3. Download and Test
- Once build completes
- Download the DMG
- Test on macOS machine
- Debug any issues

### 4. Iterate
- Fix bugs in code
- Push changes
- Automatic rebuild happens
- Download updated DMG
- Repeat

---

## 📚 More Information

- **Details:** See `.github/workflows/README.md`
- **Build Guide:** See `BUILD_MACOS.md`
- **Project Info:** See `README.md`
- **All Changes:** See `CHANGELOG.md`

---

## ✅ You're All Set!

Everything is ready for automated builds. Just:
1. Commit the workflow files
2. Go to Actions tab
3. Run a workflow
4. Get your .dmg!

No more need for a local macOS machine. GitHub Actions builds it for you. 🎉

---

*GitHub Actions Guide*  
*The Moon And Stars Project*  
*Automated Cloud-Based Building*
