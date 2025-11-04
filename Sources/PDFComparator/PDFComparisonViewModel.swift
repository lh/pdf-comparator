import SwiftUI
import PDFKit
import UniformTypeIdentifiers

@MainActor
class PDFComparisonViewModel: ObservableObject {
    @Published var basePDF: PDFDocument?
    @Published var overlayPDF: PDFDocument?
    @Published var currentPage: Int = 0  // Current page index when coupled (0-based)
    @Published var basePage: Int = 0  // Base PDF page when decoupled
    @Published var overlayPage: Int = 0  // Overlay PDF page when decoupled
    @Published var couplePages: Bool = true  // Default to coupled

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
    @Published var dragScaleOrigin: Bool = false  // Toggle: drag crosshair vs drag overlay

    // Coordinate system configuration
    // Default: Bottom-Left origin (PostScript/PDF standard)
    // Up = positive Y, Right = positive X
    @Published var yAxisUp: Bool = true      // true = up is positive, false = up is negative
    @Published var xAxisRight: Bool = true   // true = right is positive, false = right is negative

    // File watching
    @Published var showReloadAlert: Bool = false
    private var basePDFURL: URL?
    private var overlayPDFURL: URL?
    private var baseFileMonitor: DispatchSourceFileSystemObject?
    private var overlayFileMonitor: DispatchSourceFileSystemObject?
    private var pendingReloadType: ReloadType?

    enum ReloadType {
        case base
        case overlay
    }

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

    var totalPages: Int {
        max(basePDF?.pageCount ?? 0, overlayPDF?.pageCount ?? 0)
    }

    var basePageCount: Int {
        basePDF?.pageCount ?? 0
    }

    var overlayPageCount: Int {
        overlayPDF?.pageCount ?? 0
    }

    var pageDisplayString: String {
        guard totalPages > 0 else { return "No pages" }
        return "Page \(currentPage + 1) of \(totalPages)"
    }

    var basePageDisplayString: String {
        guard basePageCount > 0 else { return "No pages" }
        return "Base: \(basePage + 1)/\(basePageCount)"
    }

    var overlayPageDisplayString: String {
        guard overlayPageCount > 0 else { return "No pages" }
        return "Overlay: \(overlayPage + 1)/\(overlayPageCount)"
    }

    func nextPage() {
        if couplePages {
            guard currentPage < totalPages - 1 else { return }
            currentPage += 1
        }
    }

    func previousPage() {
        if couplePages {
            guard currentPage > 0 else { return }
            currentPage -= 1
        }
    }

    func nextBasePage() {
        guard basePage < basePageCount - 1 else { return }
        basePage += 1
    }

    func previousBasePage() {
        guard basePage > 0 else { return }
        basePage -= 1
    }

    func nextOverlayPage() {
        guard overlayPage < overlayPageCount - 1 else { return }
        overlayPage += 1
    }

    func previousOverlayPage() {
        guard overlayPage > 0 else { return }
        overlayPage -= 1
    }

    func loadBasePDF() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.pdf]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        panel.begin { response in
            if response == .OK, let url = panel.url {
                self.basePDFURL = url
                self.basePDF = PDFDocument(url: url)
                self.currentPage = 0  // Reset to first page
                self.resetTransformation()  // Auto-reset when loading new PDF
                self.setupFileMonitor(for: url, type: .base)
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
                self.overlayPDFURL = url
                self.overlayPDF = PDFDocument(url: url)
                self.currentPage = 0  // Reset to first page
                self.resetTransformation()  // Auto-reset when loading new PDF
                self.setupFileMonitor(for: url, type: .overlay)
            }
        }
    }

    private func setupFileMonitor(for url: URL, type: ReloadType) {
        // Cancel existing monitor for this type only
        switch type {
        case .base:
            baseFileMonitor?.cancel()
            baseFileMonitor = nil
        case .overlay:
            overlayFileMonitor?.cancel()
            overlayFileMonitor = nil
        }

        let fileDescriptor = open(url.path, O_EVTONLY)
        guard fileDescriptor >= 0 else { return }

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: [.write, .delete, .rename],
            queue: DispatchQueue.main
        )

        source.setEventHandler { [weak self] in
            guard let self = self else { return }
            Task { @MainActor in
                self.pendingReloadType = type
                self.showReloadAlert = true
            }
        }

        source.setCancelHandler {
            close(fileDescriptor)
        }

        source.resume()

        // Store monitor for this type
        switch type {
        case .base:
            baseFileMonitor = source
        case .overlay:
            overlayFileMonitor = source
        }
    }

    func reloadPDF() {
        guard let reloadType = pendingReloadType else { return }

        switch reloadType {
        case .base:
            if let url = basePDFURL {
                basePDF = PDFDocument(url: url)
                resetTransformation()  // Reset transformations on reload
                // Re-establish monitoring after reload
                setupFileMonitor(for: url, type: .base)
            }
        case .overlay:
            if let url = overlayPDFURL {
                overlayPDF = PDFDocument(url: url)
                resetTransformation()  // Reset transformations on reload
                // Re-establish monitoring after reload
                setupFileMonitor(for: url, type: .overlay)
            }
        }

        showReloadAlert = false
        pendingReloadType = nil
    }

    var reloadMessage: String {
        guard let reloadType = pendingReloadType else { return "" }
        switch reloadType {
        case .base:
            return "Base PDF has been modified on disk."
        case .overlay:
            return "Overlay PDF has been modified on disk."
        }
    }

    deinit {
        baseFileMonitor?.cancel()
        overlayFileMonitor?.cancel()
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
