import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var viewModel: PDFComparisonViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Controls")
                .font(.title2)
                .bold()

            Divider()

            // Opacity control
            VStack(alignment: .leading) {
                Text("Overlay Opacity")
                    .font(.headline)
                HStack {
                    Slider(value: $viewModel.overlayOpacity, in: 0...1)
                    Text("\(Int(viewModel.overlayOpacity * 100))%")
                        .frame(width: 45, alignment: .trailing)
                }
            }

            Divider()

            // Scale control
            VStack(alignment: .leading) {
                Text("Overlay Scale")
                    .font(.headline)
                HStack {
                    Slider(value: $viewModel.overlayScale, in: 0.5...2.0)
                    Text("\(String(format: "%.2f", viewModel.overlayScale))x")
                        .frame(width: 55, alignment: .trailing)
                }

                // Preset scale buttons
                HStack {
                    Button("50%") { viewModel.overlayScale = 0.5 }
                    Button("75%") { viewModel.overlayScale = 0.75 }
                    Button("100%") { viewModel.overlayScale = 1.0 }
                    Button("125%") { viewModel.overlayScale = 1.25 }
                    Button("150%") { viewModel.overlayScale = 1.5 }
                }
                .buttonStyle(.borderless)
            }

            Divider()

            // Nudge controls
            VStack(alignment: .leading) {
                Text("Position Offset")
                    .font(.headline)

                Text("X: \(String(format: "%.1f", viewModel.overlayOffset.width)) px")
                Text("Y: \(String(format: "%.1f", viewModel.overlayOffset.height)) px")

                Text("Use arrow keys to nudge")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Hold Shift for 10px steps")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack {
                    Button("Reset Position") {
                        viewModel.overlayOffset = .zero
                    }
                }
            }

            Divider()

            // Transformation vector output
            VStack(alignment: .leading) {
                Text("Transformation Vector")
                    .font(.headline)

                Text(viewModel.transformationVector)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(4)

                Button("Copy to Clipboard") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(viewModel.transformationVector, forType: .string)
                }
            }

            Divider()

            Button("Reset All Transformations") {
                viewModel.resetTransformation()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}
