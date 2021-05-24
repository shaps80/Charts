import Foundation

extension FloatingPoint {

    /// Transforms this value from the source range to the destination range. An assertion will be thrown is this value is not within the source range
    /// - Parameters:
    ///   - source: The source range where this value exists
    ///   - destination: The destination range to be used for the transform
    /// - Returns: The transformed value within the destination range
    /// - Note: https://math.stackexchange.com/questions/1205733/how-to-convert-or-transform-from-one-range-to-another
    func map(from source: ClosedRange<Self>, to destination: ClosedRange<Self>) -> Self {
        let oldRange = source.upperBound - source.lowerBound
        let newRange = destination.upperBound - destination.lowerBound
        return (((self - source.lowerBound) * newRange) / oldRange) + destination.lowerBound
    }

}

extension ClosedRange where Bound: FloatingPoint {

    /// Transforms the lower and upper bound values into the target range
    /// - Parameter destination: The target range
    /// - Returns: The transformed range
    func map(from source: Self, to destination: Self) -> Self {
        let min = lowerBound.map(from: source, to: destination)
        let max = upperBound.map(from: source, to: destination)
        return min...max
    }

}
