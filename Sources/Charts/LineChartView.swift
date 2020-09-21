import SwiftUI

public struct LineChartShape: InterpolatedShape {

    public var vector: AnimatableVector
    public var interpolation: Interpolation
    public var closed: Bool

    /// Instantiates a new shape with the specified unit-space coordinates and associated interpolation method
    /// - Parameters:
    ///   - unitPoints: The unit-space coordinates representing this shape
    ///   - interpolation: The interpolation method to use for this shape
    ///   - closed: If true, the path will be closed
    public init(_ unitPoints: [UnitPoint], interpolation: Interpolation = .hermite, closed: Bool = false) {
        self.vector = AnimatableVector(unitPoints)
        self.interpolation = interpolation
        self.closed = closed
    }

    public func path(in rect: CGRect) -> Path {
        var path = interpolatedPath(in: rect)

        if closed {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }

        return path
    }

}

