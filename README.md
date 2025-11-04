# PDF Comparator

A macOS application for comparing two PDF files side-by-side with overlay capabilities to understand transformation vectors between PDF versions.

**Author**: Luke Herbert
**License**: MIT (Open Source)
**Platform**: macOS 14.0+

## Purpose

PDF Comparator helps you adjust the output of a PDF rendering program to match an existing PDF when you don't have access to the original source. Load your target PDF as the base, your output as the overlay, adjust until they align, and use the transformation information to fix your code.

**Important**: This is a non-destructive tool - it never modifies, writes, or saves any files.

## Features

- **Dual PDF Loading**: Load a base PDF and an overlay PDF
- **Translucent Overlay**: Adjust opacity (0-100%) of the overlay PDF to see both documents simultaneously
- **Interactive Ruler**: Toggle rulers with point measurements for precise alignment (1 pt = 1/72 inch, standard PDF unit)
- **Scale Origin Point**: Draggable green crosshair defines the center point for scaling operations
  - Toggle "Scale Origin" in toolbar to show/hide
  - Click and drag the crosshair to position it over any feature you want to keep fixed
  - Delicate design with center gap for precise vernier alignment
  - Scaling happens around this point instead of center
  - Useful for maintaining alignment of specific features (logos, text, landmarks) while scaling
  - Label appears while dragging
- **Position Controls**: Multiple ways to adjust overlay position
  - **Mouse/Trackpad**: Click and drag anywhere to move overlay
  - **Arrow keys**: Move 1 point at a time
  - **Shift + Arrow keys**: Move 10 points at a time
- **Scaling Controls**: Adjust overlay scale from 50% to 200%
  - **Trackpad**: Pinch to zoom (natural gesture)
  - **Mouse wheel**: Scroll to scale (hold Option for fine control)
  - **Slider**: Quick coarse adjustments
  - **±0.01 buttons**: Fine increment/decrement
  - **Text input**: Enter exact values
  - **Presets**: Quick jump to 50%, 75%, 100%, 125%, 150%
  - **Lock toggle**: Prevent accidental scale changes
- **Rotation Controls**: Rotate overlay in any direction
  - **Trackpad**: Two-finger rotate gesture (natural rotation)
  - **±1° buttons**: Fine increment/decrement
  - **Text input**: Enter exact angles
  - **Presets**: Quick jump to 0°, 90°, 180°, 270°
  - **±90° buttons**: Fast major rotations
  - **Lock toggle**: Prevent accidental rotation changes
- **Flip Controls**: Mirror the overlay
  - Flip Horizontal toggle
  - Flip Vertical toggle
- **Coordinate System Configuration**: Match your PDF library's coordinate system
  - **Y-Axis**: Up = + (default) or Up = −
  - **X-Axis**: Right = + (default) or Right = −
  - **Presets**: Bottom-Left (PDF), Top-Left (Screen), Bottom-Right, Top-Right
  - Translation values automatically adjusted for selected system
- **Transformation Information**: Real-time display of scale, rotation, flip, translation, and opacity values
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

1. Click "Load Base PDF" to load the PDF you're trying to emulate (your target)
2. Click "Load Overlay PDF" to load your program's PDF output
3. Adjust the overlay opacity slider to see both PDFs (default 30%)
4. Adjust transformations to align:
   - **Position**: Drag with mouse/trackpad or use arrow keys (1pt or 10pt with Shift)
   - **Scale**: Pinch trackpad, scroll mouse, or use slider/buttons
   - **Rotation**: ±1° buttons or 90° presets
   - **Flip**: Toggle horizontal/vertical if needed
5. Toggle "Show Ruler" for precise measurements (shows **points** - 1 pt = 1/72 inch)
6. Copy the transformation information to adjust your code

**See [HELP.md](HELP.md) for detailed workflow examples.**

## Quick Controls Reference

### Moving the Overlay
- **Click and drag**: Move overlay with mouse/trackpad
- **Arrow keys**: Nudge 1 point at a time
- **Shift + Arrows**: Nudge 10 points at a time

### Scaling the Overlay
- **Trackpad pinch**: Natural zoom gesture
- **Mouse wheel**: Scroll up/down to scale
- **Option + Wheel**: Fine scaling control (0.1% steps)
- **Slider**: Visual adjustment
- **±0.01 buttons**: Precise increments
- **Lock toggle**: Prevent accidental changes (disables all scale controls)
- **Scale Origin**: Toggle to show crosshair, click and drag to position over feature to keep fixed while scaling

### Rotating the Overlay
- **Trackpad rotate**: Two-finger rotation gesture
- **±1° / ±90° buttons**: Precise angle adjustments
- **Text input**: Enter exact angles
- **Lock toggle**: Prevent accidental changes (disables all rotation controls)

### Other Controls
- **Click anywhere**: Focus the window for keyboard shortcuts
- **Opacity slider**: Adjust transparency
- **Toolbar toggles**: Show Ruler, Scale Origin
- **Panel toggles**: Flip horizontal/vertical, lock scale/rotation

## Coordinate Systems Explained

Different PDF libraries use different coordinate systems. PDF Comparator lets you choose:

### Bottom-Left Origin (Default - PDF Standard)
```
  Y↑
   |
   |
   └──→ X
(0,0)
```
- **Y-Axis**: Up = +, Down = −
- **X-Axis**: Right = +, Left = −
- **Used by**: PostScript, PDF spec, most PDF libraries
- **Example**: ReportLab, PyPDF2, PDFKit

### Top-Left Origin (Screen/Image)
```
(0,0)
   ┌──→ X
   |
   ↓
   Y
```
- **Y-Axis**: Up = −, Down = +
- **X-Axis**: Right = +, Left = −
- **Used by**: Most image formats, screen coordinates
- **Example**: HTML Canvas, some graphics libraries

### How to Choose:
1. Check your PDF library's documentation
2. Try bottom-left first (most common for PDF)
3. If translations seem inverted, switch Y-axis setting
4. The transformation output will be correct for your chosen system

## Understanding Points vs Pixels

**PDF Comparator uses POINTS, not pixels.**

- **1 point (pt) = 1/72 inch** - This is the standard PDF unit
- On non-Retina displays: 1 point = 1 pixel
- On Retina displays: 1 point = 2 pixels (or more)

**Why points are better for PDF work:**
- PDFs are resolution-independent
- All PDF libraries expect point coordinates
- Consistent across different displays
- Standard unit in PDF specifications

**The transformation output provides both:**
- Translation in **points** (use this for PDF manipulation)
- Translation in pixels (for reference/debugging)

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later (for building)

## Documentation

- **[HELP.md](HELP.md)** - Complete user guide with workflow examples
- **[APP_STORE_GUIDE.md](APP_STORE_GUIDE.md)** - How to submit to Mac App Store

## Open Source

This project is open source under the MIT License. You are free to:
- Use it for any purpose
- Modify and distribute it
- Include it in commercial products
- Fork and improve it

**Sharing on App Store**: Yes, you can absolutely share the source code on GitHub and still sell or distribute the app on the Mac App Store! Apple has no restrictions on open-source apps. Many popular Mac App Store apps are open source.

### Contributing

Contributions are welcome! Feel free to:
- Report bugs via GitHub Issues
- Submit feature requests
- Fork the repository and submit pull requests
- Use the code to learn or build your own tools

### GitHub Repository

Coming soon: https://github.com/lherbertGit/pdf-comparator
