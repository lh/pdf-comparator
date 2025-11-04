# PDF Comparator - Help Guide

**Author**: Luke Herbert
**Version**: 1.0
**License**: Open Source (MIT)

---

## What is PDF Comparator?

PDF Comparator is a tool designed to help you adjust the output of a PDF rendering program to match an existing PDF when you don't have access to the original PDF source.

### Use Case

Imagine you're writing a program that generates PDFs, and you need to match the layout of an existing PDF exactly. You can use PDF Comparator to:

1. Load the target PDF (the one you're trying to emulate) as the **Base PDF**
2. Load your program's output as the **Overlay PDF**
3. Adjust the scale and position until they align perfectly
4. Read the **Transformation Information** to understand what adjustments your program needs

---

## Important: Non-Destructive Application

**PDF Comparator does not modify, write, or save any files.**

- It only displays PDFs for visual comparison
- No data is collected, transmitted, or stored
- All processing happens locally on your device
- Your original PDFs remain completely untouched

---

## Getting Started

### 1. Load Your PDFs

- **Load Base PDF**: This is the PDF you're trying to emulate (your target/reference)
- **Load Overlay PDF**: This is the output from your PDF generation program

The overlay PDF will appear semi-transparent on top of the base PDF.

### 2. Adjust the Overlay

**Note**: All controls in the right panel affect only the **Overlay PDF**. The base PDF remains fixed and untransformed.

#### Opacity (Transparency)
- Use the **Opacity** slider to adjust transparency
- 30% is the default - you can see both PDFs clearly
- 100% makes the overlay completely opaque
- 0% makes it invisible

#### Scale
- **Slider**: Quick coarse adjustments (0.5x to 2.0x)
- **Fine Controls**:
  - Type exact values in the text field (e.g., 1.234)
  - Use **-0.01** and **+0.01** buttons for precise adjustments
- **Preset Buttons**: Jump to common values (50%, 75%, 100%, 125%, 150%)
- **Lock Toggle**: Prevent accidental scale changes from gestures

#### Rotation
- **Fine Controls**: Type exact angles or use **-1°** and **+1°** buttons
- **Quick Rotate**: **-90°** and **+90°** buttons for major rotations
- **Preset Buttons**: Jump to 0°, 90°, 180°, 270°
- **Trackpad Gesture**: Two-finger rotate for natural control
- **Lock Toggle**: Prevent accidental rotation changes

#### Flip
- **↔︎ button**: Flip horizontally (mirror left-right)
- **↕︎ button**: Flip vertically (mirror top-bottom)
- Useful for matching mirrored or inverted output

#### Position
- **Mouse/Trackpad**: Click and drag anywhere to move the overlay
- **Arrow Keys**: Move the overlay 1 point at a time
  - ↑ Up
  - ↓ Down
  - ← Left
  - → Right
- **Shift + Arrow Keys**: Move 10 points at a time for faster adjustments

**Tip**: Click anywhere in the comparison area first to ensure it has keyboard focus.

#### Ruler
- Toggle **Show Ruler** to display point measurements (1 pt = 1/72 inch)
- Helpful for precise alignment
- Shows horizontal and vertical rulers with a center crosshair

#### Scale Origin
- Toggle **Scale Origin** to show a draggable green crosshair
- Drag the crosshair to any feature you want to keep fixed
- Scaling will happen around this point instead of the center
- Useful for maintaining alignment of specific features while scaling

### 3. Read the Transformation Information

Once your overlay aligns with the base PDF, the **Transformation Information** panel shows:

```
Scale: 1.234
Translation: (45.00, -12.00)
Opacity: 0.30
```

**What this means:**

- **Scale**: Your program needs to scale output by this factor
  - Example: 1.234 means make everything 23.4% larger
  - Example: 0.950 means make everything 5% smaller

- **Translation**: Your program needs to shift output by these pixels
  - First number (X): Positive = right, Negative = left
  - Second number (Y): Positive = down, Negative = up
  - Example: (45.00, -12.00) means move right 45px and up 12px

- **Opacity**: Just for visual comparison - ignore for your program

**Important**: Apply transformations in this order:
1. **Scale first** (resize your content)
2. **Then translate** (move it to position)

### 4. Copy and Use

Click **Copy to Clipboard** to copy the transformation information.

Paste it into your code or notes to remember the exact adjustments needed.

---

## Workflow Example

Let's say you're writing a Python program that generates invoices, and you need to match an existing invoice template:

1. **Generate** your initial PDF with your program
2. **Load** the template as Base PDF
3. **Load** your output as Overlay PDF
4. **Adjust** scale and position until they align
5. **Copy** transformation information: `Scale: 0.985, Translation: (12.00, -8.00)`
6. **Update** your program:
   ```python
   # Scale page content by 0.985
   scale_factor = 0.985

   # Then shift by (12, -8) pixels
   x_offset = 12
   y_offset = -8
   ```
7. **Generate** new PDF and verify it matches!

---

## Controls Reference

### Mouse
- **Click** anywhere in comparison area to give it keyboard focus

### Keyboard
- **↑ ↓ ← →**: Nudge overlay 1 pixel
- **Shift + ↑ ↓ ← →**: Nudge overlay 10 pixels

### Buttons
- **Load Base PDF**: Choose your target/reference PDF
- **Load Overlay PDF**: Choose your program's output PDF
- **Show Ruler**: Toggle pixel measurement rulers
- **Reset Position**: Move overlay back to (0, 0)
- **Reset All Transformations**: Reset scale, position, and opacity
- **Copy to Clipboard**: Copy transformation information

---

## Tips & Tricks

### Getting Perfect Alignment

1. **Start with scale**: Get the size right first
2. **Then adjust position**: Use arrow keys for final alignment
3. **Toggle opacity**: Flip between 30% and 80% to see differences clearly
4. **Use the ruler**: Enable it to measure exact pixel offsets

### Dealing with Rotations

If your PDF needs rotation, this tool won't help directly. However:
- Fix rotation in your program first
- Then use PDF Comparator for scale and position

### Multiple Pages

- PDF Comparator shows the first page only
- For multi-page documents, compare page by page
- You may need different transformations for different pages

---

## Technical Details

- **Platform**: macOS 14.0 or later
- **Framework**: SwiftUI + PDFKit
- **Keyboard Handling**: Native AppKit for reliable arrow key capture
- **File Access**: Uses macOS sandboxed file pickers (user-selected files only)
- **Privacy**: No data collection, no network access, no file modifications

---

## Open Source

PDF Comparator is open source software!

- **GitHub Repository**: https://github.com/lherbertGit/pdf-comparator
- **License**: MIT License (free to use, modify, and distribute)
- **Contributions**: Welcome! Feel free to fork, improve, and submit pull requests

You can view the source code, learn how it works, or adapt it for your own needs.

---

## Frequently Asked Questions

**Q: Does this modify my PDFs?**
A: No! It's completely non-destructive. It only displays them for comparison.

**Q: Can I save the overlay result?**
A: No, there's no save function. This tool is for analysis only. Use the transformation information to adjust your PDF generation code.

**Q: Why can't I see my overlay?**
A: Check the opacity setting - it might be at 0%. Try setting it to 30-50%.

**Q: Arrow keys aren't working?**
A: Click in the comparison area first to give it keyboard focus.

**Q: Can I compare more than 2 PDFs?**
A: Not currently. Load them two at a time for comparison.

**Q: What about comparing PDFs with different page sizes?**
A: The tool will display them as-is. You'll need to account for page size differences in your transformation calculations.

---

## Support & Feedback

Found a bug? Have a feature request?

- **GitHub Issues**: https://github.com/lherbertGit/pdf-comparator/issues
- **Email**: [your-email@example.com]

---

## License

MIT License

Copyright (c) 2025 Luke Herbert

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

**PDF Comparator** - Made with ❤️ to help developers align PDFs perfectly.
