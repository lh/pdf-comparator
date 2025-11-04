import SwiftUI
import PDFKit
import UniformTypeIdentifiers

@MainActor
class PDFComparisonViewModel: ObservableObject {
    @Published var basePDF: PDFDocument?
    @Published var overlayPDF: PDFDocument?

    @Published var overlayOpacity: Double = 0.3
    @Published var overlayOffset: CGSize = .zero
    @Published var overlayScale: Double = 1.0
    @Published var overlayRotation: Double = 0.0  // in degrees
    @Published var overlayFlipHorizontal: Bool = false
    @Published var overlayFlipVertical: Bool = false

    @Published var showRuler: Bool = false
    @Published var lockScale: Bool = false
    @Published var lockRotation: Bool = false

    // Scale origin point (center of scaling)
    @Published var showScaleOrigin: Bool = false
    @Published var scaleOrigin: CGPoint = .zero  // Relative to view center

    // Coordinate system configuration
    // Default: Bottom-Left origin (PostScript/PDF standard)
    // Up = positive Y, Right = positive X
    @Published var yAxisUp: Bool = true      // true = up is positive, false = up is negative
    @Published var xAxisRight: Bool = true   // true = right is positive, false = right is negative

    var coordinateSystemName: String {
        switch (xAxisRight, yAxisUp) {
        case (true, true):   return "Bottom-Left (PDF Standard)"
        case (true, false):  return "Top-Left (Screen/Image)"
        case (false, true):  return "Bottom-Right"
        case (false, false): return "Top-Right"
        }
    }

    // Transformation information for output (order: scale, rotate, flip, translate)
    // Note: macOS uses points where 1 point = 1 pixel on non-retina, 2 pixels on retina
    // For PDF work, points are the correct unit (1 point = 1/72 inch)
    var transformationVector: String {
        let flipH = overlayFlipHorizontal ? "Yes" : "No"
        let flipV = overlayFlipVertical ? "Yes" : "No"

        // Adjust translation based on coordinate system
        let xMultiplier: CGFloat = xAxisRight ? 1 : -1
        let yMultiplier: CGFloat = yAxisUp ? 1 : -1

        let adjustedX = overlayOffset.width * xMultiplier
        let adjustedY = overlayOffset.height * yMultiplier

        // Get screen scale to provide both points and actual pixels
        let screenScale = NSScreen.main?.backingScaleFactor ?? 1.0
        let pixelX = adjustedX * screenScale
        let pixelY = adjustedY * screenScale

        return """
        Coordinate System: \(coordinateSystemName)
        Scale: \(String(format: "%.3f", overlayScale))
        Rotation: \(String(format: "%.2f", overlayRotation))°
        Flip Horizontal: \(flipH)
        Flip Vertical: \(flipV)
        Translation (Points): (\(String(format: "%.2f", adjustedX)), \(String(format: "%.2f", adjustedY)))
        Translation (Pixels): (\(String(format: "%.0f", pixelX)), \(String(format: "%.0f", pixelY)))
        Opacity: \(String(format: "%.2f", overlayOpacity))

        Note: Translation adjusted for coordinate system
        Points are recommended for PDF manipulation (1 pt = 1/72 inch)
        """
    }

    func loadBasePDF() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.pdf]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        panel.begin { response in
            if response == .OK, let url = panel.url {
                self.basePDF = PDFDocument(url: url)
            }
        }
    }

    func loadOverlayPDF() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.pdf]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        panel.begin { response in
            if response == .OK, let url = panel.url {
                self.overlayPDF = PDFDocument(url: url)
            }
        }
    }

    func nudge(dx: CGFloat, dy: CGFloat) {
        overlayOffset = CGSize(
            width: overlayOffset.width + dx,
            height: overlayOffset.height + dy
        )
    }

    func resetTransformation() {
        overlayOffset = .zero
        overlayScale = 1.0
        overlayRotation = 0.0
        overlayFlipHorizontal = false
        overlayFlipVertical = false
        overlayOpacity = 0.3
    }
}
