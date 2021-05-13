import SwiftUI

/// The interpolation method to apply to this shape
public enum Interpolation: Equatable {
    /// No interpolation will be applied
    case none
    /// Values will be interpolated using a simple method, fewest number of points will be considered
    case simple
    /// Values will be interpolated using the catmull-rom algorithm
    case catmullRom(alpha: BezierPath.Alpha)
    /// Values will be interpolated using the hermite algorithm
    case hermite
    /// Values will be intepolated using a cubic bezier curve algorithm
    case cubic
}

public protocol InterpolatedShape: Shape, Equatable {

    /// The underlying vector data representing the unit-space coordinates for this shape
    var vector: AnimatableVector { get set }

    /// The interpolation method to use when creating the path
    var interpolation: Interpolation { get set }

    /// If true, the path will be closed
    var closed: Bool { get set }

}

extension InterpolatedShape {

    public var animatableData: AnimatableVector {
        set { vector = newValue }
        get { vector }
    }

    /// Describes this shape as a series of points within a rectangular frame of reference.
    /// - Parameter rect: The frame of reference for describing this shape.
    public func points(in rect: CGRect) -> [CGPoint] {
        vector.unitPoints.map {
            CGPoint(
                x: rect.minX + rect.width * $0.x,
                y: rect.maxY - (rect.minY + rect.height * $0.y)
            )
        }
    }

    internal func interpolatedPath(in rect: CGRect) -> Path {
        let path: BezierPath
        let points = self.points(in: rect)

        switch interpolation {
        case let .catmullRom(alpha):
            path = BezierPath(catmullRom: points, closed: false, alpha: alpha) ?? BezierPath()
        case .hermite:
            path = BezierPath(hermite: points, closed: false) ?? BezierPath()
        case .simple:
            path = BezierPath(smoothed: points, closed: false) ?? BezierPath()
        case .cubic:
            path = BezierPath(cubic: points, closed: false) ?? BezierPath()
        case .none:
            path = BezierPath(points: points, closed: false) ?? BezierPath()
        }

        return Path(path.cgPath)
    }

}
