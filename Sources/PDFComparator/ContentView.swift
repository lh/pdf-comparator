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
            }
        }
    }
}
