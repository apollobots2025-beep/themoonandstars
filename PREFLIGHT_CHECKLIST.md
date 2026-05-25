# 🚀 PRE-FLIGHT CHECKLIST - Ready to Build

## ✅ Project Status: READY FOR macOS BUILD

All preparation steps have been completed. This checklist verifies everything is in place.

---

## 📋 Files Verification

### Core Source Files
- ✅ `src/main.cpp` - Entry point
- ✅ `src/AppModel.cpp` - NEW: Application state management
- ✅ `src/AppModel.h` - NEW: Application state management header
- ✅ `src/TravelController.cpp` - NEW: Travel mode implementation
- ✅ `src/TravelController.h` - NEW: Travel mode header
- ✅ `src/CatalogLoader.cpp` - Data loading
- ✅ `src/CatalogLoader.h` - Data loading header
- ✅ `src/Parsing.cpp` - Data parsing
- ✅ `src/Parsing.h` - Data parsing header
- ✅ `src/Cosmology.cpp` - Cosmology calculations
- ✅ `src/Cosmology.h` - Cosmology calculations header
- ✅ `src/OrbitMath.cpp` - Orbital mechanics
- ✅ `src/OrbitMath.h` - Orbital mechanics header
- ✅ `src/Info.plist` - NEW: macOS app configuration

### Build Configuration
- ✅ `CMakeLists.txt` - ENHANCED: macOS build configuration
- ✅ `build_mac.sh` - ENHANCED: Automated build script
- ✅ `test_dmg.sh` - NEW: DMG testing script

### QML Files (10 files - all present)
- ✅ `qml/Main.qml`
- ✅ `qml/GlobeMode.qml`
- ✅ `qml/TravelMode.qml`
- ✅ `qml/components/SideButton.qml`
- ✅ `qml/components/InfoPanel.qml`
- ✅ `qml/components/LabelValue.qml`
- ✅ `qml/components/MetricChip.qml`
- ✅ `qml/components/StyledButton.qml`
- ✅ `qml/components/StatusPill.qml`
- ✅ `qml/components/TinyTag.qml`

### Assets
- ✅ `assets/app-icon.icns` - macOS app icon
- ✅ `assets/dmg-background.jpg` - DMG installer background

### Documentation
- ✅ `README.md` - Project overview
- ✅ `BUILD_MACOS.md` - NEW: Comprehensive build guide
- ✅ `PREPARATION_REPORT.md` - NEW: Detailed status report
- ✅ This file - Pre-flight checklist

---

## 🔧 System Requirements Checklist

Before running the build on macOS, ensure you have:

### macOS Version
- [ ] macOS 11.0 (Big Sur) or newer
  - _Note: For macOS Mojave (10.14) support, see BUILD_MACOS.md section "Alternative: Qt 5.15 Build"_

### Required Software (will be checked by build script)
- [ ] Xcode Command Line Tools installed
  - Install via: `xcode-select --install`
- [ ] CMake 3.21+ installed
  - Install via: `brew install cmake`
- [ ] Python 3 available
  - Install via: `brew install python3` (if needed)

### Hardware/Storage
- [ ] At least 10-15 GB free disk space
  - First build: ~12 GB (includes Qt download)
  - Subsequent builds: ~3 GB
- [ ] Stable internet connection for Qt download
- [ ] At least 4 GB RAM (8+ GB recommended)

---

## 🎯 Build Steps

### Step 1: Prepare macOS Machine
```bash
# Verify system version
sw_vers

# Install CMake if needed
brew install cmake

# Verify all tools
cmake --version
python3 --version
xcode-select -p
```

### Step 2: Navigate to Project
```bash
cd /path/to/themoonandstars
```

### Step 3: Run Build
```bash
# Make script executable
chmod +x build_mac.sh

# Run the automated build (grab coffee, this takes time!)
./build_mac.sh
```

### Step 4: Check Build Output
The script will create:
- `release/TheMoonAndStars.dmg` - **Primary distribution file**
- `release/appTheMoonAndStars.app` - Executable application
- `release/TheMoonAndStars-macOS.zip` - Compressed app bundle

### Step 5: Test (Optional but Recommended)
```bash
# Test DMG integrity and app launch
chmod +x test_dmg.sh
./test_dmg.sh release/
```

---

## 📊 Build Timeline Expectations

| First Build | Subsequent Builds |
|------------|------------------|
| 15-30 minutes | 5-10 minutes |
| Qt 6.6.0 downloads (~1-2 GB) | Uses cached Qt |
| Full compilation | Incremental build |

---

## ⚠️ Common Issues & Solutions

### Issue: "Command not found: cmake"
**Solution:** `brew install cmake`

### Issue: "Xcode license has not been agreed"
**Solution:** `sudo xcode-select --install` and accept license

### Issue: Build fails with network error
**Solution:** Check internet connection and retry - Qt download may have timed out

### Issue: "python3: No module named 'aqt'"
**Solution:** Script will install automatically, just ensure python3 is available

### Issue: "macdeployqt: command not found"
**Solution:** Path issue - verify Xcode CLT installed correctly

**For more troubleshooting:** See BUILD_MACOS.md troubleshooting section

---

## 🧪 What to Test After Build

Once the DMG is created, verify:

1. **DMG Structure**
   - [ ] DMG mounts without errors
   - [ ] Sees the app icon and Applications folder link
   - [ ] Background image displays

2. **Application Launch**
   - [ ] App launches without crash
   - [ ] UI appears correctly
   - [ ] No error dialogs

3. **Functionality** (Basic)
   - [ ] Can switch between Globe Mode and Travel Mode
   - [ ] UI buttons respond to clicks
   - [ ] Can load data (astronomical catalog)

4. **Installation**
   - [ ] Can drag app to Applications folder
   - [ ] App runs from Applications folder
   - [ ] App can be relaunched

---

## 📋 Build Verification Checklist

After successful build, verify:

- [ ] `release/TheMoonAndStars.dmg` exists and is > 100 MB
- [ ] `release/appTheMoonAndStars.app` exists
- [ ] `release/TheMoonAndStars-macOS.zip` exists
- [ ] DMG can be mounted
- [ ] App inside DMG can be launched
- [ ] App runs without immediate crashes
- [ ] Application window shows proper UI

---

## 🐛 Debugging if Issues Occur

If the app crashes or has issues:

1. **Check macOS Console**
   ```bash
   open /Applications/Utilities/Console.app
   # Filter for "appTheMoonAndStars" or error messages
   ```

2. **Run from Terminal for Debug Output**
   ```bash
   open -a "The Moon And Stars" --args 2>&1 | tee debug.log
   ```

3. **Check System Report**
   - About This Mac → System Report → Graphics/Memory

4. **Document Issues**
   - Record error messages
   - Note macOS version
   - Note Mac model (Apple Silicon vs Intel)
   - Note steps to reproduce

---

## ✨ After Successful Build

### Distribution
- Share `TheMoonAndStars.dmg` with users
- Users download → double-click → drag to Applications → launch

### For Multiple macOS Versions
- Test on different macOS versions (11+) if possible
- Note any version-specific issues
- Adjust deployment target if needed

### For App Store Distribution
- See BUILD_MACOS.md "Signing and Notarization" section
- Requires Apple Developer account
- Adds digital signature and notarization

---

## 📞 Support Resources

- **Build Issues:** See BUILD_MACOS.md troubleshooting
- **Project Info:** See README.md
- **Build Details:** See PREPARATION_REPORT.md
- **Build Logs:** Check terminal output (script provides detailed messages)

---

## ✅ FINAL VERIFICATION

Before moving to macOS, confirm:

**Project Directory Check:**
```bash
# From project root, verify key files exist:
ls -la src/AppModel.* src/TravelController.* src/Info.plist
ls -la CMakeLists.txt build_mac.sh BUILD_MACOS.md test_dmg.sh
```

All files should exist and be readable.

---

## 🚀 YOU ARE READY!

The project is fully prepared for macOS build. 

**Next Action:** Transfer this directory to a macOS machine and run:
```bash
chmod +x build_mac.sh
./build_mac.sh
```

**Expected Result:** A professional macOS .dmg installer in `release/TheMoonAndStars.dmg`

---

*Generated: May 24, 2026*
*Project: The Moon And Stars*
*Status: ✅ Ready for macOS Build*
