import SwiftUI

public extension BezierPath {

    /// Simple line based path from a series of points. No smoothing will be applied
    /// - Parameter points: The array of `CGPoint`.
    convenience init?(points: [CGPoint], closed: Bool) {
        guard !points.isEmpty else { return nil }
        self.init()

        move(to: points[0])

        var index = 0

        while index < (points.count - 1) {
            index += 1
            addLine(to: points[index])
        }

        if closed { close() }
    }

}

#if os(iOS)
public typealias BezierPath = UIBezierPath
#else
public typealias BezierPath = NSBezierPath

extension BezierPath {
    func addLine(to point: CGPoint) {
        line(to: point)
    }
    func addQuadCurve(to endPoint: CGPoint, controlPoint: CGPoint) {
        let startPoint = currentPoint
        let controlPoint1 = CGPoint(x: (startPoint.x + (controlPoint.x - startPoint.x) * 2.0/3.0), y: (startPoint.y + (controlPoint.y - startPoint.y) * 2.0/3.0))
        let controlPoint2 = CGPoint(x: (endPoint.x + (controlPoint.x - endPoint.x) * 2.0/3.0), y: (endPoint.y + (controlPoint.y - endPoint.y) * 2.0/3.0))
        curve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }

    func addCurve(to endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        curve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }

    /// A `CGPath` object representing the current `NSBezierPath`.
    var cgPath: CGPath {
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)

        if elementCount > 0 {
            for index in 0..<elementCount {
                let pathType = element(at: index, associatedPoints: points)

                switch pathType {
                case .moveTo:
                    path.move(to: points[0])
                case .lineTo:
                    path.addLine(to: points[0])
                case .curveTo:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                case .closePath:
                    path.closeSubpath()
                @unknown default:
                    break
                }
            }
        }

        points.deallocate()
        return path
    }
}

#endif
