# PDF Comparator

A macOS application for comparing two PDF files side-by-side with overlay capabilities to understand transformation vectors between PDF versions.

## Features

- **Dual PDF Loading**: Load a base PDF and an overlay PDF
- **Translucent Overlay**: Adjust opacity (0-100%) of the overlay PDF to see both documents simultaneously
- **Interactive Ruler**: Toggle rulers with pixel measurements for precise alignment
- **Nudging Controls**: Use arrow keys to adjust overlay position
  - Arrow keys: Move 1 pixel at a time
  - Shift + Arrow keys: Move 10 pixels at a time
- **Scaling Controls**: Adjust overlay scale from 50% to 200%
  - Coarse slider for quick adjustments
  - Fine controls with ±0.01 increment buttons
  - Direct text input for precise values
  - Preset buttons (50%, 75%, 100%, 125%, 150%)
- **Transformation Vector**: Real-time display of translation, scale, and opacity values
- **Copy to Clipboard**: Export transformation parameters

## Building

```bash
swift build
```

## Running

### From Terminal (Recommended)

```bash
swift run
```

This is the most reliable way to run the app.

### From Xcode

```bash
open Package.swift
```

Then press Cmd+R to run. The app should automatically activate and come to the foreground.

**Note**: If running from Xcode, make sure to click in the app window to give it focus before using arrow keys.

## Usage

1. Click "Load Base PDF" to load your reference PDF
2. Click "Load Overlay PDF" to load the PDF you want to compare
3. Adjust the overlay opacity slider to see both PDFs
4. Use arrow keys to nudge the overlay into position
5. Adjust scale if needed
6. Toggle "Show Ruler" for precise measurements
7. Copy the transformation vector to understand the differences

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later (for building)

## App Store Distribution

Want to submit this to the Mac App Store? See the comprehensive guide:
**[APP_STORE_GUIDE.md](APP_STORE_GUIDE.md)**

The app is fully functional and ready for App Store submission. The guide walks you through creating a proper Xcode project, adding required assets, and submitting for review.
