import SwiftUI
import PDFKit

struct ContentView: View {
    @StateObject private var viewModel = PDFComparisonViewModel()

    var body: some View {
        HSplitView {
            // Main comparison view
            ComparisonView(viewModel: viewModel)
                .frame(minWidth: 600, minHeight: 400)

            // Control panel
            ControlPanelView(viewModel: viewModel)
                .frame(width: 300)
        }
        .toolbar {
            ToolbarItemGroup {
                Button("Load Base PDF") {
                    viewModel.loadBasePDF()
                }

                Button("Load Overlay PDF") {
                    viewModel.loadOverlayPDF()
                }

                Spacer()

                Toggle("Show Ruler", isOn: $viewModel.showRuler)

                Toggle("Scale Origin", isOn: $viewModel.showScaleOrigin)

                if viewModel.showScaleOrigin {
                    Toggle("Drag Crosshair", isOn: $viewModel.dragScaleOrigin)
                        .help("When enabled, dragging moves the crosshair instead of the overlay")
                }
            }
        }
        .alert("PDF Changed", isPresented: $viewModel.showReloadAlert) {
            Button("Reload") {
                viewModel.reloadPDF()
            }
            Button("Ignore", role: .cancel) {
                viewModel.showReloadAlert = false
            }
        } message: {
            Text(viewModel.reloadMessage)
        }
    }
}
