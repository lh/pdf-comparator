import SwiftUI

struct RulerOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Horizontal ruler at top
                HorizontalRuler(width: geometry.size.width)
                    .frame(height: 30)
                    .position(x: geometry.size.width / 2, y: 15)

                // Vertical ruler at left
                VerticalRuler(height: geometry.size.height)
                    .frame(width: 30)
                    .position(x: 15, y: geometry.size.height / 2)

                // Center crosshair
                Crosshair()
                    .stroke(Color.red, lineWidth: 1)
                    .frame(width: 20, height: 20)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .allowsHitTesting(false)
    }
}

struct HorizontalRuler: View {
    let width: CGFloat
    let majorInterval: CGFloat = 100
    let minorInterval: CGFloat = 10

    var body: some View {
        Canvas { context, size in
            // Background
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(.white.opacity(0.8))
            )

            // Draw tick marks
            var x: CGFloat = 0
            var tickNumber = 0

            while x <= width {
                let isMajor = tickNumber % 10 == 0
                let tickHeight: CGFloat = isMajor ? 20 : 10

                var path = Path()
                path.move(to: CGPoint(x: x, y: size.height))
                path.addLine(to: CGPoint(x: x, y: size.height - tickHeight))
                context.stroke(path, with: .color(.black), lineWidth: 1)

                // Draw numbers for major ticks
                if isMajor && x > 0 {
                    let text = Text("\(Int(x))")
                        .font(.system(size: 9))
                    context.draw(text, at: CGPoint(x: x, y: 5))
                }

                x += minorInterval
                tickNumber += 1
            }
        }
    }
}

struct VerticalRuler: View {
    let height: CGFloat
    let majorInterval: CGFloat = 100
    let minorInterval: CGFloat = 10

    var body: some View {
        Canvas { context, size in
            // Background
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(.white.opacity(0.8))
            )

            // Draw tick marks
            var y: CGFloat = 0
            var tickNumber = 0

            while y <= height {
                let isMajor = tickNumber % 10 == 0
                let tickWidth: CGFloat = isMajor ? 20 : 10

                var path = Path()
                path.move(to: CGPoint(x: size.width, y: y))
                path.addLine(to: CGPoint(x: size.width - tickWidth, y: y))
                context.stroke(path, with: .color(.black), lineWidth: 1)

                // Draw numbers for major ticks
                if isMajor && y > 0 {
                    var context = context
                    context.translateBy(x: 5, y: y)
                    context.rotate(by: .degrees(-90))
                    let text = Text("\(Int(y))")
                        .font(.system(size: 9))
                    context.draw(text, at: .zero)
                }

                y += minorInterval
                tickNumber += 1
            }
        }
    }
}

struct Crosshair: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Horizontal line
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))

        // Vertical line
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))

        return path
    }
}
