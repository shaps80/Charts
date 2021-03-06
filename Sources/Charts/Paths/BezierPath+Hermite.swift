import CoreGraphics

public extension BezierPath {

    /// Create smooth UIBezierPath using Hermite Spline
    ///
    /// This requires at least two points.
    ///
    /// - seealso: https://github.com/jnfisher/ios-curve-interpolation
    /// - seealso: http://spin.atomicobject.com/2014/05/28/ios-interpolating-points/
    ///
    /// - parameter points: The array of `CGPoint` values.
    /// - parameter closed: Whether the path should be closed or not
    ///
    /// - returns:  An initialized `UIBezierPath`, or `nil` if an object could not be created for some reason (e.g. not enough points).
    convenience init?(hermite points: [CGPoint], closed: Bool) {
        self.init()

        guard points.count > 1 else { return nil }

        let numberOfCurves = closed
            ? points.count
            : points.count - 1

        var previousPoint: CGPoint? = closed ? points.last : nil
        var currentPoint: CGPoint  = points[0]
        var nextPoint: CGPoint? = points[1]

        move(to: currentPoint)

        for index in 0 ..< numberOfCurves {
            let endPt = nextPoint!

            var mx: CGFloat
            var my: CGFloat

            if previousPoint != nil {
                mx = (nextPoint!.x - currentPoint.x) * 0.5 + (currentPoint.x - previousPoint!.x) * 0.5
                my = (nextPoint!.y - currentPoint.y) * 0.5 + (currentPoint.y - previousPoint!.y) * 0.5
            } else {
                mx = (nextPoint!.x - currentPoint.x) * 0.5
                my = (nextPoint!.y - currentPoint.y) * 0.5
            }

            let ctrlPt1 = CGPoint(x: currentPoint.x + mx / 3.0, y: currentPoint.y + my / 3.0)

            previousPoint = currentPoint
            currentPoint = nextPoint!

            let nextIndex = index + 2
            if closed {
                nextPoint = points[nextIndex % points.count]
            } else {
                nextPoint = nextIndex < points.count ? points[nextIndex % points.count] : nil
            }

            if nextPoint != nil {
                mx = (nextPoint!.x - currentPoint.x) * 0.5 + (currentPoint.x - previousPoint!.x) * 0.5
                my = (nextPoint!.y - currentPoint.y) * 0.5 + (currentPoint.y - previousPoint!.y) * 0.5
            }
            else {
                mx = (currentPoint.x - previousPoint!.x) * 0.5
                my = (currentPoint.y - previousPoint!.y) * 0.5
            }

            let ctrlPt2 = CGPoint(x: currentPoint.x - mx / 3.0, y: currentPoint.y - my / 3.0)
            addCurve(to: endPt, controlPoint1: ctrlPt1, controlPoint2: ctrlPt2)
        }

        if closed { close() }
    }

}
