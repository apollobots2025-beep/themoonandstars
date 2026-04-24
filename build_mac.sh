#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEPS_DIR="$PROJECT_DIR/deps"
PYTHON_DEPS="$DEPS_DIR/python"
QT_VERSION="6.6.0"
QT_DIR="$DEPS_DIR/Qt/$QT_VERSION/macos"
APP_BUNDLE="appTheMoonAndStars.app"
DMG_NAME="TheMoonAndStars.dmg"
BG_FILE="$PROJECT_DIR/assets/dmg-background.png"

echo "Starting build..."

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required."
  exit 1
fi

mkdir -p "$PYTHON_DEPS"
python3 -m pip install --upgrade --target "$PYTHON_DEPS" aqtinstall create-dmg >/dev/null
export PYTHONPATH="$PYTHON_DEPS:${PYTHONPATH:-}"

if [ ! -d "$QT_DIR" ]; then
  python3 -m aqt install-qt mac desktop "$QT_VERSION" clang_64 --outputdir "$DEPS_DIR/Qt"
fi

export PATH="$QT_DIR/bin:$PATH"

rm -rf "$PROJECT_DIR/build" "$PROJECT_DIR/release" "$PROJECT_DIR/dmg_temp"
mkdir -p "$PROJECT_DIR/release" "$PROJECT_DIR/dmg_temp"

cmake -S "$PROJECT_DIR" -B "$PROJECT_DIR/build" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$QT_DIR"
cmake --build "$PROJECT_DIR/build" --config Release

cp -R "$PROJECT_DIR/build/$APP_BUNDLE" "$PROJECT_DIR/release/"
macdeployqt "$PROJECT_DIR/release/$APP_BUNDLE" -qmldir="$PROJECT_DIR/qml"
codesign --deep --force --sign - "$PROJECT_DIR/release/$APP_BUNDLE" || true

cp -R "$PROJECT_DIR/release/$APP_BUNDLE" "$PROJECT_DIR/dmg_temp/"
ln -s /Applications "$PROJECT_DIR/dmg_temp/Applications" || true

DMG_ARGS=(--volname "The Moon And Stars" --window-size 800 400 --icon-size 120 --icon "$APP_BUNDLE" 200 200 --app-drop-link 600 200)
if [ -f "$BG_FILE" ]; then
  DMG_ARGS+=(--background "$BG_FILE")
fi

python3 -m create_dmg "${DMG_ARGS[@]}" "$PROJECT_DIR/release/$DMG_NAME" "$PROJECT_DIR/dmg_temp/"

cd "$PROJECT_DIR/release"
zip -r TheMoonAndStars-macOS.zip "$APP_BUNDLE" >/dev/null

echo "Done."
echo "DMG: $PROJECT_DIR/release/$DMG_NAME"
echo "ZIP: $PROJECT_DIR/release/TheMoonAndStars-macOS.zip"
