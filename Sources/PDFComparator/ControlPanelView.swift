import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var viewModel: PDFComparisonViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Overlay")
                .font(.title2)
                .bold()

            Divider()

            // Opacity control
            VStack(alignment: .leading, spacing: 4) {
                Text("Opacity")
                    .font(.headline)
                HStack {
                    Slider(value: $viewModel.overlayOpacity, in: 0...1)
                    Text("\(Int(viewModel.overlayOpacity * 100))%")
                        .frame(width: 40, alignment: .trailing)
                }
            }

            Divider()

            // Scale control
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Scale")
                        .font(.headline)
                    Spacer()
                    Toggle("Lock", isOn: $viewModel.lockScale)
                        .toggleStyle(.switch)
                        .controlSize(.mini)
                }

                HStack {
                    Slider(value: $viewModel.overlayScale, in: 0.5...2.0)
                        .disabled(viewModel.lockScale)
                    Text("\(String(format: "%.2f", viewModel.overlayScale))x")
                        .frame(width: 50, alignment: .trailing)
                }

                HStack(spacing: 6) {
                    Button("-0.01") {
                        viewModel.overlayScale = max(0.5, viewModel.overlayScale - 0.01)
                    }
                    .frame(width: 48)
                    .disabled(viewModel.lockScale)

                    TextField("", value: $viewModel.overlayScale, format: .number.precision(.fractionLength(3)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .disabled(viewModel.lockScale)
                        .onSubmit {
                            viewModel.overlayScale = max(0.5, min(2.0, viewModel.overlayScale))
                        }

                    Button("+0.01") {
                        viewModel.overlayScale = min(2.0, viewModel.overlayScale + 0.01)
                    }
                    .frame(width: 48)
                    .disabled(viewModel.lockScale)
                }

                HStack(spacing: 4) {
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
                .font(.system(size: 11))
            }

            Divider()

            // Rotation control
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Rotation")
                        .font(.headline)
                    Spacer()
                    Toggle("Lock", isOn: $viewModel.lockRotation)
                        .toggleStyle(.switch)
                        .controlSize(.mini)
                }

                HStack(spacing: 6) {
                    Button("-1°") {
                        viewModel.overlayRotation -= 1.0
                    }
                    .frame(width: 42)
                    .disabled(viewModel.lockRotation)

                    TextField("", value: $viewModel.overlayRotation, format: .number.precision(.fractionLength(2)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .disabled(viewModel.lockRotation)

                    Button("+1°") {
                        viewModel.overlayRotation += 1.0
                    }
                    .frame(width: 42)
                    .disabled(viewModel.lockRotation)

                    Button("-90°") { viewModel.overlayRotation -= 90 }
                        .frame(width: 50)
                        .disabled(viewModel.lockRotation)
                    Button("+90°") { viewModel.overlayRotation += 90 }
                        .frame(width: 50)
                        .disabled(viewModel.lockRotation)
                }

                HStack(spacing: 4) {
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
                .font(.system(size: 11))
            }

            Divider()

            // Flip controls
            VStack(alignment: .leading, spacing: 6) {
                Text("Flip")
                    .font(.headline)

                HStack(spacing: 12) {
                    Toggle("↔︎", isOn: $viewModel.overlayFlipHorizontal)
                        .toggleStyle(.button)
                        .help("Flip Horizontal")
                    Toggle("↕︎", isOn: $viewModel.overlayFlipVertical)
                        .toggleStyle(.button)
                        .help("Flip Vertical")
                    Spacer()
                }
            }

            Divider()

            // Position controls
            VStack(alignment: .leading, spacing: 4) {
                Text("Position")
                    .font(.headline)

                HStack(spacing: 8) {
                    Text("X:")
                        .frame(width: 16, alignment: .leading)
                    Text("\(String(format: "%.1f", viewModel.overlayOffset.width)) pt")
                        .frame(width: 70, alignment: .trailing)
                        .font(.system(.body, design: .monospaced))

                    Text("Y:")
                        .frame(width: 16, alignment: .leading)
                    Text("\(String(format: "%.1f", viewModel.overlayOffset.height)) pt")
                        .frame(width: 70, alignment: .trailing)
                        .font(.system(.body, design: .monospaced))
                }

                Text("Arrow keys to nudge (Shift for 10pt)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Button("Reset") {
                    viewModel.overlayOffset = .zero
                }
                .buttonStyle(.borderless)
                .font(.system(size: 11))
            }

            Divider()

            // Crosshair coordinates (when scale origin is visible)
            if viewModel.showScaleOrigin {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Crosshair Position")
                        .font(.headline)

                    HStack {
                        Text(viewModel.scaleOriginCoordinates)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.blue)

                        Spacer()

                        Button("Copy") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(viewModel.scaleOriginCoordinates, forType: .string)
                        }
                        .buttonStyle(.borderless)
                        .font(.system(size: 11))
                    }

                    Text("From bottom-left (0, 0)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Divider()
            }

            // Coordinate system - simplified to radio button style
            VStack(alignment: .leading, spacing: 6) {
                Text("Coordinate System")
                    .font(.headline)

                Picker("", selection: Binding(
                    get: { viewModel.yAxisUp ? 0 : 1 },
                    set: { viewModel.yAxisUp = ($0 == 0) }
                )) {
                    Text("PDF (+Right, +Up)").tag(0)
                    Text("Screen (+Right, +Down)").tag(1)
                }
                .pickerStyle(.radioGroup)
                .labelsHidden()
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
