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
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Overlay Scale")
                        .font(.headline)
                    Spacer()
                    Toggle("Lock", isOn: $viewModel.lockScale)
                        .toggleStyle(.switch)
                        .controlSize(.mini)
                }

                // Coarse slider
                HStack {
                    Slider(value: $viewModel.overlayScale, in: 0.5...2.0)
                        .disabled(viewModel.lockScale)
                    Text("\(String(format: "%.2f", viewModel.overlayScale))x")
                        .frame(width: 55, alignment: .trailing)
                }

                // Fine controls with text field
                HStack(spacing: 8) {
                    Button("-0.01") {
                        viewModel.overlayScale = max(0.5, viewModel.overlayScale - 0.01)
                    }
                    .frame(width: 50)
                    .disabled(viewModel.lockScale)

                    TextField("Scale", value: $viewModel.overlayScale, format: .number.precision(.fractionLength(3)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 70)
                        .disabled(viewModel.lockScale)
                        .onSubmit {
                            // Clamp to valid range
                            viewModel.overlayScale = max(0.5, min(2.0, viewModel.overlayScale))
                        }

                    Button("+0.01") {
                        viewModel.overlayScale = min(2.0, viewModel.overlayScale + 0.01)
                    }
                    .frame(width: 50)
                    .disabled(viewModel.lockScale)

                    Text("(±0.01)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Preset scale buttons
                HStack {
                    Button("50%") { viewModel.overlayScale = 0.5 }
                        .disabled(viewModel.lockScale)
                    Button("75%") { viewModel.overlayScale = 0.75 }
                        .disabled(viewModel.lockScale)
                    Button("100%") { viewModel.overlayScale = 1.0 }
                        .disabled(viewModel.lockScale)
                    Button("125%") { viewModel.overlayScale = 1.25 }
                        .disabled(viewModel.lockScale)
                    Button("150%") { viewModel.overlayScale = 1.5 }
                        .disabled(viewModel.lockScale)
                }
                .buttonStyle(.borderless)
            }

            Divider()

            // Rotation control
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Overlay Rotation")
                        .font(.headline)
                    Spacer()
                    Toggle("Lock", isOn: $viewModel.lockRotation)
                        .toggleStyle(.switch)
                        .controlSize(.mini)
                }

                // Fine controls with text field
                HStack(spacing: 8) {
                    Button("-1°") {
                        viewModel.overlayRotation -= 1.0
                    }
                    .frame(width: 45)
                    .disabled(viewModel.lockRotation)

                    TextField("Rotation", value: $viewModel.overlayRotation, format: .number.precision(.fractionLength(2)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 70)
                        .disabled(viewModel.lockRotation)

                    Button("+1°") {
                        viewModel.overlayRotation += 1.0
                    }
                    .frame(width: 45)
                    .disabled(viewModel.lockRotation)

                    Text("(±1°)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Preset rotation buttons
                HStack {
                    Button("0°") { viewModel.overlayRotation = 0 }
                        .disabled(viewModel.lockRotation)
                    Button("90°") { viewModel.overlayRotation = 90 }
                        .disabled(viewModel.lockRotation)
                    Button("180°") { viewModel.overlayRotation = 180 }
                        .disabled(viewModel.lockRotation)
                    Button("270°") { viewModel.overlayRotation = 270 }
                        .disabled(viewModel.lockRotation)
                }
                .buttonStyle(.borderless)

                HStack {
                    Button("-90°") { viewModel.overlayRotation -= 90 }
                        .disabled(viewModel.lockRotation)
                    Button("+90°") { viewModel.overlayRotation += 90 }
                        .disabled(viewModel.lockRotation)
                }
                .buttonStyle(.borderless)
            }

            Divider()

            // Flip controls
            VStack(alignment: .leading, spacing: 8) {
                Text("Overlay Flip")
                    .font(.headline)

                HStack {
                    Toggle("Flip Horizontal", isOn: $viewModel.overlayFlipHorizontal)
                    Spacer()
                }

                HStack {
                    Toggle("Flip Vertical", isOn: $viewModel.overlayFlipVertical)
                    Spacer()
                }
            }

            Divider()

            // Nudge controls
            VStack(alignment: .leading) {
                Text("Position Offset")
                    .font(.headline)

                Text("X: \(String(format: "%.1f", viewModel.overlayOffset.width)) pt")
                Text("Y: \(String(format: "%.1f", viewModel.overlayOffset.height)) pt")

                Text("Use arrow keys to nudge")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Hold Shift for 10pt steps")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("(1 point = 1/72 inch)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack {
                    Button("Reset Position") {
                        viewModel.overlayOffset = .zero
                    }
                }
            }

            Divider()

            // Transformation information output
            VStack(alignment: .leading) {
                Text("Transformation Information")
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
