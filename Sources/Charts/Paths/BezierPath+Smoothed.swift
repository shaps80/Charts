import CoreGraphics

extension BezierPath {

    /// Simple smoothing algorithm
    ///
    /// This iterates through the points in the array, drawing cubic bezier
    /// from the first to the fourth points, using the second and third as
    /// control points.
    ///
    /// This takes every third point and moves it so that it is exactly inbetween
    /// the points before and after it, which ensures that there is no discontinuity
    /// in the first derivative as you join these cubic beziers together.
    ///
    /// Note, if, at the end, there are not enough points for a cubic bezier, it
    /// will perform a quadratic bezier, or if not enough points for that, a line.
    ///
    /// - Parameters:
    ///   - points: An array  of `CGPoint` values describing the path
    ///   - closed: If true, the path will be closed
    convenience init?(smoothed points: [CGPoint], closed: Bool) {
        guard !points.isEmpty else { return nil }
        self.init()

        move(to: points[0])

        var index = 0

        while index < points.count - 1 {
            switch (points.count - index) {
            case 2:
                index += 1
                addLine(to: points[index])
            case 3:
                index += 2
                addQuadCurve(to: points[index], controlPoint: points[index - 1])
            case 4:
                index += 3
                addCurve(to: points[index], controlPoint1: points[index - 2], controlPoint2: points[index - 1])
            default:
                index += 3
                let point = CGPoint(x: (points[index - 1].x + points[index + 1].x) / 2,
                                    y: (points[index - 1].y + points[index + 1].y) / 2)
                addCurve(to: point, controlPoint1: points[index - 2], controlPoint2: points[index - 1])
            }
        }

        if closed { close() }
    }

}
