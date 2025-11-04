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
- **Interactive Ruler**: Toggle rulers with pixel measurements for precise alignment
- **Nudging Controls**: Use arrow keys to adjust overlay position
  - Arrow keys: Move 1 pixel at a time
  - Shift + Arrow keys: Move 10 pixels at a time
- **Scaling Controls**: Adjust overlay scale from 50% to 200%
  - Coarse slider for quick adjustments
  - Fine controls with ±0.01 increment buttons
  - Direct text input for precise values
  - Preset buttons (50%, 75%, 100%, 125%, 150%)
- **Transformation Information**: Real-time display of scale, translation, and opacity values
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
4. Adjust scale to match sizes (use fine controls for precision)
5. Use arrow keys to nudge the overlay into position
6. Toggle "Show Ruler" for pixel-perfect measurements
7. Copy the transformation information to adjust your code

**See [HELP.md](HELP.md) for detailed workflow examples.**

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
