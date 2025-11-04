import SwiftUI
import PDFKit
import UniformTypeIdentifiers

@MainActor
class PDFComparisonViewModel: ObservableObject {
    @Published var basePDF: PDFDocument?
    @Published var overlayPDF: PDFDocument?

    @Published var overlayOpacity: Double = 0.5
    @Published var overlayOffset: CGSize = .zero
    @Published var overlayScale: Double = 1.0

    @Published var showRuler: Bool = false

    // Transformation vector for output
    var transformationVector: String {
        """
        Translation: (\(String(format: "%.2f", overlayOffset.width)), \(String(format: "%.2f", overlayOffset.height)))
        Scale: \(String(format: "%.4f", overlayScale))
        Opacity: \(String(format: "%.2f", overlayOpacity))
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
        overlayOpacity = 0.5
    }
}
