# macOS Build Guide for The Moon And Stars

## Overview
This guide provides detailed instructions for building The Moon And Stars application and creating a macOS .dmg installer.

## System Requirements

### Minimum macOS Version
- **Current build (Qt 6.6.0):** macOS 11.0 (Big Sur) or higher
- **For macOS Mojave (10.14) support:** See "Alternative: Qt 5.15 Build" section below

### Required Software
1. **Xcode Command Line Tools** - For compiling C++ code
2. **CMake** ≥ 3.21 - Build configuration system
3. **Python 3** - For aqtinstall and create-dmg
4. **macOS SDK** - Included with Xcode CLT

### Hardware Requirements
- **Minimum:** 4GB RAM, 10GB free disk space
- **Recommended:** 8GB+ RAM, 20GB+ free disk space (for Qt download and build)
- **Apple Silicon support:** Yes (arm64+x86_64 universal binary)

## Pre-Build Setup

### 1. Install Xcode Command Line Tools
```bash
xcode-select --install
```

If already installed, verify:
```bash
xcode-select -p
```

Should output: `/Applications/Xcode.app/Contents/Developer`

### 2. Verify CMake is Installed
```bash
cmake --version
```

If not installed, install via Homebrew:
```bash
brew install cmake
```

### 3. Verify Python 3
```bash
python3 --version
```

Should be 3.7 or higher.

## Building the Application

### Quick Start
1. Navigate to the project directory:
```bash
cd /path/to/themoonandstars
```

2. Make the build script executable and run it:
```bash
chmod +x build_mac.sh
./build_mac.sh
```

The script will automatically:
- Download Qt 6.6.0 using aqtinstall
- Download required Python packages (create-dmg, aqtinstall)
- Build the application
- Create .app bundle
- Sign the code
- Generate .dmg installer file
- Create a .zip archive

### Build Output
After successful build, find these files in `release/` directory:
- **TheMoonAndStars.dmg** - Ready-to-distribute installer
- **appTheMoonAndStars.app** - Application bundle (can be used directly)
- **TheMoonAndStars-macOS.zip** - Compressed app bundle

## Testing the Build

### Test the App Directly
```bash
open release/appTheMoonAndStars.app
```

### Test the DMG Installer
1. Double-click `release/TheMoonAndStars.dmg`
2. Drag app icon to Applications folder
3. Launch from Applications

## Troubleshooting

### Issue: "Command not found: cmake"
**Solution:** Install CMake via Homebrew
```bash
brew install cmake
```

### Issue: "Python3 not found"
**Solution:** Install Python 3
```bash
brew install python3
```

### Issue: "Xcode license has not been agreed"
**Solution:** Accept Xcode license
```bash
sudo xcode-select --reset
sudo xcode-select --install
xcode-select --license
# Press 'q' then 'agree'
```

### Issue: "Code signing failed"
**Solution:** The build script allows unsigned builds with `|| true`. The app will still work but will show a security warning on first launch. To remove this:
```bash
# Approve the app by running once and allowing in Security preferences
open release/appTheMoonAndStars.app
```

### Issue: Build fails with "Qt6 not found"
**Solution:** The script downloads Qt automatically. If it fails:
1. Check internet connection
2. Ensure Python 3 is available
3. Delete `deps/` folder and retry
```bash
rm -rf deps/
./build_mac.sh
```

## Advanced Options

### Customize Qt Version
To use a different Qt version, edit `build_mac.sh`:
```bash
QT_VERSION="6.7.0"  # Change this line
```

### Custom Build Paths
Modify environment variables before running:
```bash
export Qt6_DIR=/path/to/custom/qt
./build_mac.sh
```

## Alternative: Qt 5.15 Build (Mojave Support)

For macOS Mojave (10.14) compatibility, use Qt 5.15:

1. Create `build_mac_qt5.sh`:
```bash
cp build_mac.sh build_mac_qt5.sh
```

2. Edit `build_mac_qt5.sh` and change:
```bash
QT_VERSION="5.15.13"
QT_DIR="$DEPS_DIR/Qt/$QT_VERSION/macos"
```

3. Update CMakeLists.txt deployment target:
```bash
# Change in CMakeLists.txt:
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.14" CACHE STRING "Minimum macOS version")
# And change find_package:
find_package(Qt5 REQUIRED COMPONENTS Core Gui Qml Quick Quick3D Network)
```

4. Build:
```bash
chmod +x build_mac_qt5.sh
./build_mac_qt5.sh
```

## Distribution

### Signing and Notarization (Optional but Recommended)
For distribution on the App Store or wider distribution:

```bash
# Developer certificate ID (get from Keychain)
CERT_ID="Developer ID Application: Your Name (XXXXXXXXXX)"

codesign --force --sign "$CERT_ID" release/appTheMoonAndStars.app
codesign -v release/appTheMoonAndStars.app

# For notarization:
xcrun altool --notarize-app --file release/TheMoonAndStars.dmg \
  --primary-bundle-id com.themoonandstars.app \
  -u your-apple-id@example.com -p your-app-password
```

## Performance Optimization

For faster builds on subsequent runs:
```bash
# Keep the build directory and deps
# Just rebuild the source:
cd build
cmake --build . --config Release
cd ..
macdeployqt release/appTheMoonAndStars.app -qmldir=../qml
```

## Clean Build
To start fresh:
```bash
rm -rf build/ release/ deps/ dmg_temp/
./build_mac.sh
```

## Tips

1. **First build takes time:** The script downloads Qt (~1-2 GB), so expect 10-30 minutes depending on internet speed
2. **Subsequent builds are faster:** Qt is cached in `deps/` directory
3. **Monitor disk space:** Ensure at least 10-15 GB free space during build
4. **Network issues:** If build fails due to network, simply re-run the script

## Getting Help

If you encounter issues:
1. Check error messages carefully - they usually indicate the solution
2. Ensure all prerequisites are installed
3. Try a clean build: `rm -rf deps/ build/ release/`
4. Check macOS version: `sw_vers`

## Next Steps

After creating the .dmg:
1. Test on different macOS versions if possible
2. Distribute to users via the .dmg file
3. Gather feedback and debug as needed
