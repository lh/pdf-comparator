import SwiftUI

struct ScaleOriginView: View {
    @ObservedObject var viewModel: PDFComparisonViewModel
    @State private var isDragging = false

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let crosshairPosition = CGPoint(
                x: center.x + viewModel.scaleOrigin.x,
                y: center.y + viewModel.scaleOrigin.y
            )

            ZStack {
                // Crosshair
                CrosshairShape()
                    .stroke(Color.green, lineWidth: 2)
                    .frame(width: 40, height: 40)
                    .position(crosshairPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDragging = true
                                let newX = value.location.x - center.x
                                let newY = value.location.y - center.y
                                viewModel.scaleOrigin = CGPoint(x: newX, y: newY)
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )

                // Center circle for better visibility
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                    .position(crosshairPosition)

                // Label
                Text("Scale Origin")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(4)
                    .position(x: crosshairPosition.x, y: crosshairPosition.y - 30)
            }
        }
        .allowsHitTesting(true)
    }
}

struct CrosshairShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let centerX = rect.midX
        let centerY = rect.midY

        // Horizontal line
        path.move(to: CGPoint(x: rect.minX, y: centerY))
        path.addLine(to: CGPoint(x: rect.maxX, y: centerY))

        // Vertical line
        path.move(to: CGPoint(x: centerX, y: rect.minY))
        path.addLine(to: CGPoint(x: centerX, y: rect.maxY))

        return path
    }
}
