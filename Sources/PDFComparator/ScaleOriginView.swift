import SwiftUI

struct ScaleOriginView: NSViewRepresentable {
    @ObservedObject var viewModel: PDFComparisonViewModel

    func makeNSView(context: Context) -> ScaleOriginNSView {
        let view = ScaleOriginNSView()
        view.viewModel = viewModel
        return view
    }

    func updateNSView(_ nsView: ScaleOriginNSView, context: Context) {
        nsView.viewModel = viewModel
        nsView.needsDisplay = true
    }
}

class ScaleOriginNSView: NSView {
    var viewModel: PDFComparisonViewModel?
    private var isDragging = false
    private var dragLabel: NSTextField?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let viewModel = viewModel else { return }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let crosshairPos = CGPoint(
            x: center.x + viewModel.scaleOrigin.x,
            y: center.y - viewModel.scaleOrigin.y  // Flip Y for NSView coordinates
        )

        // Draw crosshair with center gap
        NSColor.green.withAlphaComponent(0.8).setStroke()
        let path = NSBezierPath()
        path.lineWidth = 1.0

        let size: CGFloat = 30
        let gap: CGFloat = 6

        // Horizontal lines
        path.move(to: CGPoint(x: crosshairPos.x - size, y: crosshairPos.y))
        path.line(to: CGPoint(x: crosshairPos.x - gap/2, y: crosshairPos.y))
        path.move(to: CGPoint(x: crosshairPos.x + gap/2, y: crosshairPos.y))
        path.line(to: CGPoint(x: crosshairPos.x + size, y: crosshairPos.y))

        // Vertical lines
        path.move(to: CGPoint(x: crosshairPos.x, y: crosshairPos.y - size))
        path.line(to: CGPoint(x: crosshairPos.x, y: crosshairPos.y - gap/2))
        path.move(to: CGPoint(x: crosshairPos.x, y: crosshairPos.y + gap/2))
        path.line(to: CGPoint(x: crosshairPos.x, y: crosshairPos.y + size))

        path.stroke()
    }

    override func mouseDown(with event: NSEvent) {
        guard let viewModel = viewModel else { return }

        let clickPoint = convert(event.locationInWindow, from: nil)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let crosshairPos = CGPoint(
            x: center.x + viewModel.scaleOrigin.x,
            y: center.y - viewModel.scaleOrigin.y
        )

        let distance = hypot(clickPoint.x - crosshairPos.x, clickPoint.y - crosshairPos.y)

        // Only start dragging if clicking within 40pt of crosshair
        if distance < 40 {
            isDragging = true
            showLabel()
        }
    }

    override func mouseDragged(with event: NSEvent) {
        guard isDragging, let viewModel = viewModel else { return }

        let location = convert(event.locationInWindow, from: nil)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        let newX = location.x - center.x
        let newY = -(location.y - center.y)  // Flip Y back to PDF coordinates

        viewModel.scaleOrigin = CGPoint(x: newX, y: newY)
        needsDisplay = true
    }

    override func mouseUp(with event: NSEvent) {
        isDragging = false
        hideLabel()
    }

    private func showLabel() {
        guard dragLabel == nil else { return }

        let label = NSTextField(labelWithString: "Scale Origin")
        label.font = NSFont.systemFont(ofSize: 10)
        label.textColor = .green
        label.backgroundColor = NSColor.black.withAlphaComponent(0.7)
        label.isBordered = false
        label.sizeToFit()
        addSubview(label)
        dragLabel = label
        updateLabelPosition()
    }

    private func hideLabel() {
        dragLabel?.removeFromSuperview()
        dragLabel = nil
    }

    private func updateLabelPosition() {
        guard let label = dragLabel, let viewModel = viewModel else { return }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let crosshairPos = CGPoint(
            x: center.x + viewModel.scaleOrigin.x,
            y: center.y - viewModel.scaleOrigin.y
        )

        label.frame.origin = CGPoint(
            x: crosshairPos.x - label.frame.width / 2,
            y: crosshairPos.y + 20
        )
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
