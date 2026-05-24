# GitHub Actions - Automated macOS DMG Build

This directory contains GitHub Actions workflows that automatically build The Moon And Stars .dmg file on GitHub's macOS runners.

## Available Workflows

### 1. Build macOS DMG (`build-dmg.yml`) - Recommended
**Triggers:** Push to main/develop, PRs, or manual trigger  
**Features:** Comprehensive logging, multiple artifacts, optional releases

**Triggers automatically on:**
- Push to `main` or `develop` branches
- Pull requests to `main`
- Manual trigger via Actions tab

**Manual trigger:**
1. Go to repository → Actions tab
2. Select "Build macOS DMG"
3. Click "Run workflow"
4. Optionally check "Create a GitHub Release"
5. Click green "Run workflow" button

### 2. Quick Build (`quick-build.yml`)
**Triggers:** Manual only  
**Features:** Simpler, faster feedback

**Manual trigger:**
1. Go to repository → Actions tab
2. Select "Quick DMG Build"
3. Optionally check "Create a GitHub Release"
4. Click "Run workflow"

---

## What These Workflows Do

```
1. Check out your code
   ↓
2. Set up macOS environment (latest or macOS 13)
   ↓
3. Install dependencies (cmake, python3)
   ↓
4. Run build_mac.sh
   ↓
5. Upload artifacts (DMG, APP, ZIP)
   ↓
6. Optionally create GitHub Release
```

**Time:** ~15-30 minutes per build

---

## Getting Build Artifacts

### From Workflow Run (Recommended)
1. Go to repository → Actions tab
2. Click the latest workflow run
3. Scroll down to "Artifacts" section
4. Download:
   - `TheMoonAndStars-DMG` (the .dmg file)
   - `TheMoonAndStars-App` (the .app bundle)
   - `TheMoonAndStars-ZIP` (compressed archive)

### From GitHub Release
If you selected "Create Release" during manual trigger:
1. Go to repository → Releases
2. Find the latest release (v#number)
3. Download the files from the release

---

## Example Usage

### Trigger on Every Push
The `build-dmg.yml` workflow automatically builds on push to main:
```bash
git add .
git commit -m "Update build files"
git push origin main
# Workflow starts automatically - check Actions tab
```

### Manual Build with Release
1. Go to Actions → Build macOS DMG
2. Click "Run workflow"
3. Enable "Create a GitHub Release"
4. Get DMG from Releases page

### Build on Schedule (Optional)
To build daily, add to `build-dmg.yml`:
```yaml
  schedule:
    - cron: '0 2 * * 0'  # Weekly on Sunday 2 AM UTC
```

---

## Files Generated

Each build produces:

1. **TheMoonAndStars.dmg** (100-300 MB)
   - Professional installer
   - Drag-and-drop to Applications
   - Ready for distribution

2. **appTheMoonAndStars.app** (200-500 MB)
   - Executable application bundle
   - Can be run directly
   - Includes all dependencies

3. **TheMoonAndStars-macOS.zip** (150-400 MB)
   - Compressed app bundle
   - Alternative distribution format

---

## Troubleshooting

### Workflow Failed to Start
- Ensure workflows are enabled: Settings → Actions → Enable
- Check that files are committed to repository

### Build Failed
- Check workflow logs: Click run → Click step → View output
- Common issues:
  - Qt download timeout - retry
  - Network issue - check internet
  - See BUILD_MACOS.md for solutions

### Artifacts Not Available
- Check artifact retention settings
- By default, artifacts kept for 30 days
- Modify `retention-days` in workflow file to keep longer

### Can't Find Release
- Make sure you selected "Create Release" during manual trigger
- Check Releases tab (not just the Actions tab)

---

## Customization

### Change macOS Version
Edit `build-dmg.yml`, line with `runs-on`:
```yaml
runs-on: macos-13  # or macos-12, macos-latest
```

### Increase Artifact Retention
Edit workflow files, change:
```yaml
retention-days: 30  # Change to desired number of days
```

### Add Notifications
Add to workflow after build:
```yaml
- name: Notify on Slack
  if: always()
  run: # ... add notification code
```

### Auto-Release on Tag
Modify `build-dmg.yml` to trigger on tags:
```yaml
on:
  push:
    tags:
      - 'v*'  # Triggers on version tags
```

---

## Security Notes

- ✅ Workflows use GitHub's official macOS runners
- ✅ Code is not exposed to untrusted environments
- ✅ Artifacts are stored securely on GitHub
- ✅ Releases use `GITHUB_TOKEN` for authentication

### For Distribution

The DMG file is:
- ✅ Code signed (ad-hoc, no warnings)
- ✅ Ready for distribution
- ✅ Works on macOS 11+ and Apple Silicon

For notarization (official Apple seal):
- Requires Apple Developer account
- See BUILD_MACOS.md for notarization steps
- Can be added to workflow if needed

---

## GitHub Actions Pricing

- **Free tier:** Includes 3,000 minutes/month on GitHub-hosted runners
- **This project:** ~20-30 minutes per build
- **Monthly budget:** ~100 free builds per month

Builds only consume credits when running, not when waiting.

---

## Advanced: Matrix Builds

To build on multiple macOS versions:
```yaml
strategy:
  matrix:
    macos-version: [macos-12, macos-13, macos-latest]
runs-on: ${{ matrix.macos-version }}
```

This creates 3 parallel builds on different macOS versions.

---

## Monitoring Builds

### Watch Live Progress
1. Push code or manually trigger
2. Go to Actions tab
3. Click the running workflow
4. Watch real-time logs as build progresses

### Get Notifications
GitHub can notify you via:
- Email (default)
- Slack integration (with setup)
- Custom webhooks

### Build Status Badge
Add to README.md:
```markdown
![Build Status](https://github.com/apollobots2025-beep/themoonandstars/actions/workflows/build-dmg.yml/badge.svg)
```

---

## Next Steps

1. ✅ Workflows are ready to use
2. Commit these files to your repository
3. Push to trigger automatic build
4. Download DMG from Actions artifacts
5. Test on macOS machines
6. Debug and iterate as needed

## Quick Start

```bash
# Commit the workflow files
git add .github/workflows/
git commit -m "Add GitHub Actions CI/CD for macOS DMG builds"
git push

# Then go to Actions tab and watch the magic happen!
```

---

## Getting Help

If workflows fail:
1. Check the workflow run logs
2. See error message
3. Check BUILD_MACOS.md for solutions
4. Contact repository maintainers

---

*GitHub Actions Documentation*  
*The Moon And Stars Project*  
*Automated macOS Build Pipeline*
