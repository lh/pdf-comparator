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

                // Page navigation
                if viewModel.totalPages > 1 {
                    if viewModel.couplePages {
                        // Coupled mode - single navigator
                        Button(action: { viewModel.previousPage() }) {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(viewModel.currentPage == 0)
                        .help("Previous page")

                        Text(viewModel.pageDisplayString)
                            .font(.system(size: 11))
                            .frame(minWidth: 80)

                        Button(action: { viewModel.nextPage() }) {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(viewModel.currentPage >= viewModel.totalPages - 1)
                        .help("Next page")
                    } else {
                        // Decoupled mode - separate navigators
                        // Base PDF navigator
                        Button(action: { viewModel.previousBasePage() }) {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(viewModel.basePage == 0)
                        .help("Previous base page")

                        Text(viewModel.basePageDisplayString)
                            .font(.system(size: 10))
                            .frame(minWidth: 70)

                        Button(action: { viewModel.nextBasePage() }) {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(viewModel.basePage >= viewModel.basePageCount - 1)
                        .help("Next base page")

                        Divider()

                        // Overlay PDF navigator
                        Button(action: { viewModel.previousOverlayPage() }) {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(viewModel.overlayPage == 0)
                        .help("Previous overlay page")

                        Text(viewModel.overlayPageDisplayString)
                            .font(.system(size: 10))
                            .frame(minWidth: 70)

                        Button(action: { viewModel.nextOverlayPage() }) {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(viewModel.overlayPage >= viewModel.overlayPageCount - 1)
                        .help("Next overlay page")
                    }

                    Toggle("Couple Pages", isOn: $viewModel.couplePages)
                        .help("When enabled, both PDFs navigate together")

                    Spacer()
                }

                Toggle("Show Ruler", isOn: $viewModel.showRuler)

                Toggle("Scale Origin", isOn: $viewModel.showScaleOrigin)

                if viewModel.showScaleOrigin {
                    Toggle("Move Crosshair", isOn: $viewModel.dragScaleOrigin)
                        .help("When enabled, mouse and arrow keys move the crosshair instead of the overlay")
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
