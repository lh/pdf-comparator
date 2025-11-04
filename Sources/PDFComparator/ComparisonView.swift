import SwiftUI
import PDFKit

struct ComparisonView: View {
    @ObservedObject var viewModel: PDFComparisonViewModel

    var body: some View {
        ZStack {
            // Base PDF layer
            if let basePDF = viewModel.basePDF {
                PDFViewRepresentable(document: basePDF)
            } else {
                Text("Load Base PDF")
                    .foregroundColor(.secondary)
            }

            // Overlay PDF layer with transformations
            // Order: scale, rotate, flip, translate
            if let overlayPDF = viewModel.overlayPDF {
                PDFViewRepresentable(document: overlayPDF)
                    .scaleEffect(
                        x: viewModel.overlayScale * (viewModel.overlayFlipHorizontal ? -1 : 1),
                        y: viewModel.overlayScale * (viewModel.overlayFlipVertical ? -1 : 1)
                    )
                    .rotationEffect(.degrees(viewModel.overlayRotation))
                    .offset(viewModel.overlayOffset)
                    .opacity(viewModel.overlayOpacity)
            }

            // Ruler overlay
            if viewModel.showRuler {
                RulerOverlay()
            }

            // Key handler overlay
            KeyHandlerView(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// Custom view that uses NSViewRepresentable to capture keyboard events properly
struct KeyHandlerView: NSViewRepresentable {
    @ObservedObject var viewModel: PDFComparisonViewModel

    func makeNSView(context: Context) -> KeyHandlerNSView {
        let view = KeyHandlerNSView()
        view.viewModel = viewModel
        return view
    }

    func updateNSView(_ nsView: KeyHandlerNSView, context: Context) {
        nsView.viewModel = viewModel
    }
}

class KeyHandlerNSView: NSView {
    var viewModel: PDFComparisonViewModel?
    private var isDragging = false
    private var lastDragLocation: NSPoint?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        // Make the view transparent but still receive events
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var acceptsFirstResponder: Bool { true }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        // Automatically grab focus when added to window
        DispatchQueue.main.async {
            self.window?.makeFirstResponder(self)
        }
    }

    override func mouseDown(with event: NSEvent) {
        // Grab focus on mouse click
        window?.makeFirstResponder(self)

        // Start dragging
        isDragging = true
        lastDragLocation = event.locationInWindow
    }

    override func mouseDragged(with event: NSEvent) {
        guard isDragging, let lastLocation = lastDragLocation else { return }

        let currentLocation = event.locationInWindow
        let dx = currentLocation.x - lastLocation.x
        let dy = currentLocation.y - lastLocation.y

        // Update overlay position
        viewModel?.nudge(dx: dx, dy: -dy)  // Flip Y for correct direction

        lastDragLocation = currentLocation
    }

    override func mouseUp(with event: NSEvent) {
        isDragging = false
        lastDragLocation = nil
    }

    override func scrollWheel(with event: NSEvent) {
        guard let viewModel = viewModel, !viewModel.lockScale else { return }

        // Use scroll wheel to scale
        // Hold Option/Alt for fine control
        let scaleFactor: CGFloat = event.modifierFlags.contains(.option) ? 0.001 : 0.01
        let delta = event.scrollingDeltaY * scaleFactor

        let newScale = max(0.5, min(2.0, viewModel.overlayScale + delta))
        viewModel.overlayScale = newScale
    }

    override func magnify(with event: NSEvent) {
        guard let viewModel = viewModel, !viewModel.lockScale else { return }

        // Trackpad pinch gesture for scaling
        let newScale = max(0.5, min(2.0, viewModel.overlayScale * (1 + event.magnification)))
        viewModel.overlayScale = newScale
    }

    override func rotate(with event: NSEvent) {
        guard let viewModel = viewModel, !viewModel.lockRotation else { return }

        // Trackpad rotation gesture
        // Convert radians to degrees
        let degrees = event.rotation
        viewModel.overlayRotation += Double(degrees)
    }

    override func keyDown(with event: NSEvent) {
        let nudgeAmount: CGFloat = event.modifierFlags.contains(.shift) ? 10 : 1

        switch Int(event.keyCode) {
        case 126: // Up arrow
            viewModel?.nudge(dx: 0, dy: -nudgeAmount)
        case 125: // Down arrow
            viewModel?.nudge(dx: 0, dy: nudgeAmount)
        case 123: // Left arrow
            viewModel?.nudge(dx: -nudgeAmount, dy: 0)
        case 124: // Right arrow
            viewModel?.nudge(dx: nudgeAmount, dy: 0)
        default:
            super.keyDown(with: event)
        }
    }

    // Allow the view to be hit-tested
    override func hitTest(_ point: NSPoint) -> NSView? {
        // Return self to capture all mouse events in our bounds
        return bounds.contains(point) ? self : nil
    }
}

// SwiftUI wrapper for PDFView
struct PDFViewRepresentable: NSViewRepresentable {
    let document: PDFDocument

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .vertical
        return pdfView
    }

    func updateNSView(_ pdfView: PDFView, context: Context) {
        if pdfView.document != document {
            pdfView.document = document
        }
    }
}
