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

    // Transformation information for output (order: scale, rotate, flip, translate)
    // Note: macOS uses points where 1 point = 1 pixel on non-retina, 2 pixels on retina
    // For PDF work, points are the correct unit (1 point = 1/72 inch)
    var transformationVector: String {
        let flipH = overlayFlipHorizontal ? "Yes" : "No"
        let flipV = overlayFlipVertical ? "Yes" : "No"

        // Get screen scale to provide both points and actual pixels
        let screenScale = NSScreen.main?.backingScaleFactor ?? 1.0
        let pixelX = overlayOffset.width * screenScale
        let pixelY = overlayOffset.height * screenScale

        return """
        Scale: \(String(format: "%.3f", overlayScale))
        Rotation: \(String(format: "%.2f", overlayRotation))°
        Flip Horizontal: \(flipH)
        Flip Vertical: \(flipV)
        Translation (Points): (\(String(format: "%.2f", overlayOffset.width)), \(String(format: "%.2f", overlayOffset.height)))
        Translation (Pixels): (\(String(format: "%.0f", pixelX)), \(String(format: "%.0f", pixelY)))
        Opacity: \(String(format: "%.2f", overlayOpacity))

        Note: Points are recommended for PDF manipulation (1 pt = 1/72 inch)
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
