#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
DEPS_DIR="$PROJECT_DIR/deps"
QT_VERSION="5.15.13"
QT_OUTDIR="$DEPS_DIR/Qt/$QT_VERSION/macos"
APP_BUNDLE_NAME="appTheMoonAndStars.app"
RELEASE_DIR="$PROJECT_DIR/release"
BUILD_DIR="$PROJECT_DIR/build"
DMG_NAME="TheMoonAndStars.dmg"

echo "Starting non-interactive build helper for macOS Mojave..."

function command_exists() { command -v "$1" >/dev/null 2>&1; }

echo "Checking Xcode Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools not found. Attempting to install..."
  xcode-select --install || true
  echo "If an interactive installer appeared, please complete it and re-run this script. Exiting now."
  exit 1
fi

echo "Checking Homebrew..."
if ! command_exists brew; then
  echo "Homebrew not found. Attempting non-interactive install..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true
  if ! command_exists brew; then
    echo "Homebrew install failed or requires interactive steps. Please install Homebrew manually and re-run this script:"
    echo "  /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
  fi
fi

echo "Ensuring build tools are present (cmake, git, python3)..."
brew install cmake git python@3.11 || true

PYTHON_BIN="$(brew --prefix)/opt/python@3.11/bin/python3"
if [ ! -x "$PYTHON_BIN" ]; then
  PYTHON_BIN="$(command -v python3 || true)"
fi
if [ -z "$PYTHON_BIN" ]; then
  echo "python3 not found. Install Python and re-run."
  exit 1
fi

echo "Installing Python helper packages locally..."
PY_PIP="$PYTHON_BIN -m pip"
"$PY_PIP" install --user --upgrade pip setuptools wheel || true
"$PY_PIP" install --user aqtinstall create-dmg dmgbuild || true

export PATH="$HOME/Library/Python/3.11/bin:$PATH"

echo "Downloading Qt $QT_VERSION (clang_64) using aqtinstall..."
PY_AQT="$PYTHON_BIN -m aqt"
mkdir -p "$DEPS_DIR/Qt"
if [ ! -d "$QT_OUTDIR" ]; then
  "$PYTHON_BIN" -m aqt install-qt mac desktop "$QT_VERSION" clang_64 --outputdir "$DEPS_DIR/Qt" || {
    echo "qt download failed. Check network and try again."
    exit 1
  }
fi

if [ ! -d "$QT_OUTDIR/bin" ]; then
  echo "Qt install missing expected bin directory: $QT_OUTDIR/bin"
  exit 1
fi

export PATH="$QT_OUTDIR/bin:$PATH"

echo "Patching CMakeLists.txt for Mojave/Qt5 compatibility (backup created)"
if [ -f "CMakeLists.txt" ]; then
  cp CMakeLists.txt CMakeLists.txt.bak || true
  # Ensure deployment target exists
  if ! grep -q "CMAKE_OSX_DEPLOYMENT_TARGET" CMakeLists.txt; then
    awk 'NR==1{print "set(CMAKE_OSX_DEPLOYMENT_TARGET \"10.14\" CACHE STRING \"Minimum macOS version\")"} {print}' CMakeLists.txt > CMakeLists.txt.tmp && mv CMakeLists.txt.tmp CMakeLists.txt
  fi
  # Replace Qt6 usage with Qt5 (best-effort)
  if grep -q "find_package(Qt6" CMakeLists.txt; then
    sed -i '' 's/find_package(Qt6 .* REQUIRED .*\\)/find_package(Qt5 REQUIRED COMPONENTS Core Gui Qml Quick Widgets Network)/' CMakeLists.txt || true
  fi
fi

echo "Configuring cmake and building..."
rm -rf "$BUILD_DIR" "$RELEASE_DIR"
mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$QT_OUTDIR" || {
  echo "CMake configuration failed. Check CMake output above."
  exit 1
}

cmake --build . --config Release || {
  echo "Build failed. Inspect the build log above."
  exit 1
}

echo "Expecting bundle in build/ or produced by CMake..."
# Try to locate an .app produced by the build
APP_PATH=""
if [ -d "$BUILD_DIR/$APP_BUNDLE_NAME" ]; then
  APP_PATH="$BUILD_DIR/$APP_BUNDLE_NAME"
else
  # Search for any .app under build
  APP_PATH="$(find "$BUILD_DIR" -maxdepth 3 -type d -name "*.app" -print -quit || true)"
fi

if [ -z "$APP_PATH" ]; then
  echo "No .app bundle found after build. Trying to assemble a bundle from the built binary..."
  # Attempt to find executable in build dir
  BIN_EXE="$(find . -type f -perm +111 -maxdepth 4 -print -quit || true)"
  if [ -z "$BIN_EXE" ]; then
    echo "No executable found. Build likely failed to produce the app binary. Exiting."
    exit 1
  fi
  echo "Found executable: $BIN_EXE"
  mkdir -p "$RELEASE_DIR/$APP_BUNDLE_NAME/Contents/MacOS"
  cp "$BIN_EXE" "$RELEASE_DIR/$APP_BUNDLE_NAME/Contents/MacOS/$(basename "$BIN_EXE")"
  APP_PATH="$RELEASE_DIR/$APP_BUNDLE_NAME"
fi

echo "Copying QML and resources into app bundle..."
mkdir -p "$APP_PATH/Contents/Resources/"
cp -R "$PROJECT_DIR/qml" "$APP_PATH/Contents/Resources/" || true
cp -R "$PROJECT_DIR/assets" "$APP_PATH/Contents/Resources/" || true

mkdir -p "$RELEASE_DIR"
rm -rf "$RELEASE_DIR/$APP_BUNDLE_NAME"
cp -R "$APP_PATH" "$RELEASE_DIR/"

echo "Running macdeployqt to bundle Qt frameworks..."
MACDEPLOYQT_BIN="$QT_OUTDIR/bin/macdeployqt"
if [ ! -x "$MACDEPLOYQT_BIN" ]; then
  # try Homebrew location
  MACDEPLOYQT_BIN="$(command -v macdeployqt || true)"
fi
if [ -z "$MACDEPLOYQT_BIN" ]; then
  echo "macdeployqt not found. Please ensure Qt bin directory is on PATH or install macdeployqt."
  exit 1
fi

"$MACDEPLOYQT_BIN" "$RELEASE_DIR/$APP_BUNDLE_NAME" -qmldir="$PROJECT_DIR/qml" || echo "macdeployqt returned non-zero, continuing"

echo "Ad-hoc codesign (may require elevated privileges)"
codesign --deep --force --sign - "$RELEASE_DIR/$APP_BUNDLE_NAME" || echo "codesign failed or not necessary"

echo "Creating DMG with create-dmg (falling back to dmgbuild if needed)"
mkdir -p "$PROJECT_DIR/dmg_temp"
rm -rf "$PROJECT_DIR/dmg_temp/*"
cp -R "$RELEASE_DIR/$APP_BUNDLE_NAME" "$PROJECT_DIR/dmg_temp/"
ln -s /Applications "$PROJECT_DIR/dmg_temp/Applications" || true

if command_exists create-dmg; then
  create-dmg --volname "The Moon And Stars" --window-size 800 400 --icon-size 120 --icon "$APP_BUNDLE_NAME" 200 200 --app-drop-link 600 200 "$RELEASE_DIR/$DMG_NAME" "$PROJECT_DIR/dmg_temp/" || true
else
  # try python create-dmg module
  "$PYTHON_BIN" -m create_dmg --volname "The Moon And Stars" --window-size 800 400 --icon-size 120 --icon "$APP_BUNDLE_NAME" 200 200 --app-drop-link 600 200 "$RELEASE_DIR/$DMG_NAME" "$PROJECT_DIR/dmg_temp/" || true
fi

if [ -f "$RELEASE_DIR/$DMG_NAME" ]; then
  echo "Success. DMG created: $RELEASE_DIR/$DMG_NAME"
else
  echo "DMG creation failed; fallback: creating zip of app bundle"
  cd "$RELEASE_DIR"
  zip -r "${DMG_NAME%.dmg}.zip" "$APP_BUNDLE_NAME"
  echo "Created zip: $RELEASE_DIR/${DMG_NAME%.dmg}.zip"
fi

echo "Build script completed. Inspect $RELEASE_DIR for artifacts."
