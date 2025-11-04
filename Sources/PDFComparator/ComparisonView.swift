import SwiftUI
import PDFKit

struct ComparisonView: View {
    @ObservedObject var viewModel: PDFComparisonViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            // Base PDF layer
            if let basePDF = viewModel.basePDF {
                PDFViewRepresentable(document: basePDF)
                    .allowsHitTesting(false)
            } else {
                Text("Load Base PDF")
                    .foregroundColor(.secondary)
            }

            // Overlay PDF layer with transformations
            if let overlayPDF = viewModel.overlayPDF {
                PDFViewRepresentable(document: overlayPDF)
                    .opacity(viewModel.overlayOpacity)
                    .scaleEffect(viewModel.overlayScale)
                    .offset(viewModel.overlayOffset)
                    .allowsHitTesting(false)
            }

            // Ruler overlay
            if viewModel.showRuler {
                RulerOverlay()
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .focusable()
        .focused($isFocused)
        .onAppear {
            isFocused = true
        }
        .onKeyPress(keys: [.upArrow, .downArrow, .leftArrow, .rightArrow]) { press in
            let nudgeAmount: CGFloat = press.modifiers.contains(.shift) ? 10 : 1

            switch press.key {
            case .upArrow:
                viewModel.nudge(dx: 0, dy: -nudgeAmount)
            case .downArrow:
                viewModel.nudge(dx: 0, dy: nudgeAmount)
            case .leftArrow:
                viewModel.nudge(dx: -nudgeAmount, dy: 0)
            case .rightArrow:
                viewModel.nudge(dx: nudgeAmount, dy: 0)
            default:
                return .ignored
            }

            return .handled
        }
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
