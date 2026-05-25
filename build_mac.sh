#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ ${1}${NC}"
}

log_success() {
    echo -e "${GREEN}✓ ${1}${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠ ${1}${NC}"
}

log_error() {
    echo -e "${RED}✗ ${1}${NC}"
}

# Check macOS version
check_macos_version() {
    if ! command -v sw_vers >/dev/null 2>&1; then
        log_error "This script must run on macOS"
        exit 1
    fi
    
    MACOS_VERSION=$(sw_vers -productVersion)
    MACOS_MAJOR=$(echo $MACOS_VERSION | cut -d. -f1)
    
    if [ "$MACOS_MAJOR" -lt 11 ]; then
        log_warning "Your macOS version ($MACOS_VERSION) is below the minimum required (11.0)"
        log_warning "For macOS Mojave (10.14) support, see BUILD_MACOS.md for Qt 5.15 alternative"
    fi
    
    log_success "macOS $MACOS_VERSION detected"
}

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEPS_DIR="$PROJECT_DIR/deps"
PYTHON_DEPS="$DEPS_DIR/python"
QT_VERSION="6.6.0"
QT_DIR="$DEPS_DIR/Qt/$QT_VERSION/macos"
APP_BUNDLE="appTheMoonAndStars.app"
DMG_NAME="TheMoonAndStars.dmg"
BG_FILE="$PROJECT_DIR/assets/dmg-background.jpg"

echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  The Moon And Stars - macOS Build      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Verify prerequisites
log_info "Checking prerequisites..."

check_macos_version

if ! command -v python3 >/dev/null 2>&1; then
    log_error "python3 is required but not found"
    log_info "Install via Homebrew: brew install python3"
    exit 1
fi
log_success "python3 found"

if ! command -v cmake >/dev/null 2>&1; then
    log_error "cmake is required but not found"
    log_info "Install via Homebrew: brew install cmake"
    exit 1
fi
log_success "cmake found ($(cmake --version | head -1))"

if ! command -v xcode-select >/dev/null 2>&1; then
    log_error "Xcode Command Line Tools are required"
    log_info "Install via: xcode-select --install"
    exit 1
fi
log_success "Xcode Command Line Tools found"

echo ""
log_info "Setting up Python environment..."
mkdir -p "$PYTHON_DEPS"
python3 -m pip install --upgrade --target "$PYTHON_DEPS" aqtinstall create-dmg 2>/dev/null || true
export PYTHONPATH="$PYTHON_DEPS:${PYTHONPATH:-}"
log_success "Python dependencies installed"

echo ""
log_info "Checking for Qt $QT_VERSION..."
if [ ! -d "$QT_DIR" ]; then
    log_info "Downloading and installing Qt $QT_VERSION (this may take several minutes)..."
    python3 -m aqt install-qt mac desktop "$QT_VERSION" clang_64 --outputdir "$DEPS_DIR/Qt" || {
        log_error "Failed to download Qt. Check your internet connection."
        exit 1
    }
    log_success "Qt $QT_VERSION installed"
else
    log_success "Qt $QT_VERSION found in cache"
fi

export PATH="$QT_DIR/bin:$PATH"

echo ""
log_info "Cleaning previous build artifacts..."
rm -rf "$PROJECT_DIR/build" "$PROJECT_DIR/release" "$PROJECT_DIR/dmg_temp"
mkdir -p "$PROJECT_DIR/release" "$PROJECT_DIR/dmg_temp"
log_success "Cleaned"

echo ""
log_info "Configuring CMake..."
cmake -S "$PROJECT_DIR" -B "$PROJECT_DIR/build" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="$QT_DIR" || {
    log_error "CMake configuration failed"
    exit 1
}
log_success "CMake configured"

echo ""
log_info "Building application (this may take a few minutes)..."
cmake --build "$PROJECT_DIR/build" --config Release || {
    log_error "Build failed"
    exit 1
}
log_success "Build complete"

echo ""
log_info "Creating .app bundle..."
cp -R "$PROJECT_DIR/build/$APP_BUNDLE" "$PROJECT_DIR/release/"
log_success ".app bundle created"

echo ""
log_info "Deploying Qt libraries..."
macdeployqt "$PROJECT_DIR/release/$APP_BUNDLE" -qmldir="$PROJECT_DIR/qml" || {
    log_error "macdeployqt failed"
    exit 1
}
log_success "Qt libraries deployed"

echo ""
log_info "Code signing (unsigned - app will work but may show security warning)..."
codesign --deep --force --sign - "$PROJECT_DIR/release/$APP_BUNDLE" 2>/dev/null || {
    log_warning "Code signing skipped (app will still work)"
}
log_success "Code signing complete"

echo ""
log_info "Preparing DMG structure..."
cp -R "$PROJECT_DIR/release/$APP_BUNDLE" "$PROJECT_DIR/dmg_temp/"
ln -s /Applications "$PROJECT_DIR/dmg_temp/Applications" || true
log_success "DMG structure prepared"

echo ""
log_info "Creating DMG installer (this may take a minute)..."
DMG_ARGS=(--volname "The Moon And Stars" --window-size 800 400 --icon-size 120 --icon "$APP_BUNDLE" 200 200 --app-drop-link 600 200)
if [ -f "$BG_FILE" ]; then
    log_info "Using background image: $BG_FILE"
    DMG_ARGS+=(--background "$BG_FILE")
fi

python3 -m create_dmg "${DMG_ARGS[@]}" "$PROJECT_DIR/release/$DMG_NAME" "$PROJECT_DIR/dmg_temp/" || {
    log_error "DMG creation failed"
    exit 1
}
log_success "DMG created: $DMG_NAME"

echo ""
log_info "Creating ZIP archive..."
cd "$PROJECT_DIR/release"
zip -r TheMoonAndStars-macOS.zip "$APP_BUNDLE" >/dev/null
cd "$PROJECT_DIR"
log_success "ZIP created"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Build Successful!                     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
log_success "DMG: $PROJECT_DIR/release/$DMG_NAME"
log_success "APP: $PROJECT_DIR/release/$APP_BUNDLE"
log_success "ZIP: $PROJECT_DIR/release/TheMoonAndStars-macOS.zip"
echo ""
log_info "Next steps:"
log_info "1. Test the app: open release/$APP_BUNDLE"
log_info "2. Test the DMG: open release/$DMG_NAME"
log_info "3. For distribution, consider code signing and notarization (see BUILD_MACOS.md)"
echo ""
