import SwiftUI

public struct LineChart: InterpolatedShape {

    public var vector: AnimatableVector
    public var interpolation: Interpolation
    public var closed: Bool

    /// Instantiates a new shape with the specified unit-space coordinates and associated interpolation method
    /// - Parameters:
    ///   - data: An array of values representing the chart
    ///   - interpolation: The interpolation method to use for this shape
    ///   - closed: If true, the path will be closed
    public init<Data>(_ data: Data, in range: ClosedRange<Data.Element>? = nil, interpolation: Interpolation = .hermite, closed: Bool = false) where Data: RandomAccessCollection, Data.Element: BinaryFloatingPoint {
        self.vector = AnimatableVector(data, in: range)
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
