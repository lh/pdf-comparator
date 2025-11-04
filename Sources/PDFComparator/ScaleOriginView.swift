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
                // Delicate crosshair with center gap for vernier acuity
                CrosshairShape(gapSize: 6)
                    .stroke(Color.green.opacity(0.8), lineWidth: 1)
                    .frame(width: 60, height: 60)
                    .position(crosshairPosition)
                    .allowsHitTesting(false)

                // Invisible larger hit target for dragging
                Circle()
                    .fill(Color.clear)
                    .frame(width: 80, height: 80)
                    .position(crosshairPosition)
                    .contentShape(Circle())
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

                // Label (only show when dragging or hovering)
                if isDragging {
                    Text("Scale Origin")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(4)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(4)
                        .position(x: crosshairPosition.x, y: crosshairPosition.y - 40)
                }
            }
        }
        .allowsHitTesting(true)
    }
}

struct CrosshairShape: Shape {
    let gapSize: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let centerX = rect.midX
        let centerY = rect.midY
        let halfGap = gapSize / 2

        // Horizontal line (left side)
        path.move(to: CGPoint(x: rect.minX, y: centerY))
        path.addLine(to: CGPoint(x: centerX - halfGap, y: centerY))

        // Horizontal line (right side)
        path.move(to: CGPoint(x: centerX + halfGap, y: centerY))
        path.addLine(to: CGPoint(x: rect.maxX, y: centerY))

        // Vertical line (top side)
        path.move(to: CGPoint(x: centerX, y: rect.minY))
        path.addLine(to: CGPoint(x: centerX, y: centerY - halfGap))

        // Vertical line (bottom side)
        path.move(to: CGPoint(x: centerX, y: centerY + halfGap))
        path.addLine(to: CGPoint(x: centerX, y: rect.maxY))

        return path
    }
}
