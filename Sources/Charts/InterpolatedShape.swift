import SwiftUI

/// The interpolation method to apply to this shape
public enum Interpolation: Equatable {
    /// No interpolation will be applied
    case none
    /// Values will be interpolated using a simple method, fewest number of points will be considered
    case simple
    /// Values will be interpolated using the catmull-rom algorithm
    case catmullRom(alpha: UIBezierPath.Alpha)
    /// Values will be interpolated using the hermite algorithm
    case hermite
}

public protocol InterpolatedShape: Shape, Equatable {

    /// The underlying vector data representing the unit-space coordinates for this shape
    var vector: AnimatableVector { get set }

    /// The interpolation method to use when creating the path
    var interpolation: Interpolation { get set }

    /// If true, the path will be closed
    var closed: Bool { get set }

    /// Instantiates a new shape with the specified unit-space coordinates and associated interpolation method
    /// - Parameters:
    ///   - unitPoints: The unit-space coordinates representing this shape
    ///   - interpolation: The interpolation method to use for this shape
    ///   - closed: If true, the path will be closed
    init(_ unitPoints: [UnitPoint], interpolation: Interpolation, closed: Bool)

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
                y: rect.minY + rect.height * $0.y
            )
        }
    }

    internal func interpolatedPath(in rect: CGRect) -> Path {
        let path: UIBezierPath
        let points = self.points(in: rect)

        switch interpolation {
        case let .catmullRom(alpha):
            path = UIBezierPath(catmullRom: points, closed: false, alpha: alpha) ?? UIBezierPath()
        case .hermite:
            path = UIBezierPath(hermite: points, closed: false) ?? UIBezierPath()
        case .simple:
            path = UIBezierPath(smoothed: points, closed: false) ?? UIBezierPath()
        case .none:
            path = UIBezierPath(points: points, closed: false) ?? UIBezierPath()
        }

        return Path(path.cgPath)
    }

}
