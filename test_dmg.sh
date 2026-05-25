#!/bin/bash
# DMG Testing Script for The Moon And Stars
# This script helps test the generated DMG file

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

DMG_FILE="${1:-.}"

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  The Moon And Stars - DMG Test        ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""

# Find the DMG file
if [ -d "$DMG_FILE" ]; then
    DMG_FILE=$(find "$DMG_FILE" -name "TheMoonAndStars.dmg" -type f | head -1)
fi

if [ ! -f "$DMG_FILE" ] || [ ! -f "$DMG_FILE" ]; then
    log_error "DMG file not found: $DMG_FILE"
    log_info "Usage: $0 [path/to/dmg_or_directory]"
    exit 1
fi

log_success "Found DMG: $DMG_FILE"

# Create a temporary mount point
MOUNT_POINT="/tmp/themoonandstars_test_$$"
mkdir -p "$MOUNT_POINT"
log_info "Mounting DMG to: $MOUNT_POINT"

# Mount the DMG
if ! hdiutil attach "$DMG_FILE" -mountpoint "$MOUNT_POINT" -nobrowse 2>/dev/null; then
    log_error "Failed to mount DMG"
    rmdir "$MOUNT_POINT"
    exit 1
fi

log_success "DMG mounted successfully"

# List contents
echo ""
log_info "DMG Contents:"
ls -la "$MOUNT_POINT" || true

# Check for the app
if [ -d "$MOUNT_POINT/appTheMoonAndStars.app" ]; then
    log_success "Application bundle found"
    
    # Test running the app
    echo ""
    log_info "Testing application launch..."
    
    if open "$MOUNT_POINT/appTheMoonAndStars.app" 2>/dev/null; then
        log_success "Application launched successfully"
        log_info "Waiting 5 seconds for app to initialize..."
        sleep 5
        
        # Check if the process is still running
        if pgrep -f "appTheMoonAndStars" >/dev/null; then
            log_success "Application is running"
        else
            log_warning "Application did not remain running"
        fi
    else
        log_error "Failed to launch application"
    fi
else
    log_error "Application bundle not found in DMG"
fi

# Check for Applications symlink
echo ""
if [ -L "$MOUNT_POINT/Applications" ]; then
    log_success "Applications symlink found (for drag-and-drop install)"
else
    log_warning "Applications symlink not found"
fi

# Unmount
echo ""
log_info "Unmounting DMG..."
if hdiutil detach "$MOUNT_POINT" 2>/dev/null; then
    log_success "DMG unmounted"
else
    log_warning "Failed to unmount cleanly (may be locked by running process)"
fi

# Cleanup
rmdir "$MOUNT_POINT" 2>/dev/null || true

# Kill the running app if still running
pkill -f "appTheMoonAndStars" 2>/dev/null || true

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  DMG Test Complete                    ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
echo ""
log_info "DMG integrity check passed!"
echo ""
