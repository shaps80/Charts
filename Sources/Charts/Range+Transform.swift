import Foundation

extension RandomAccessCollection where Element: BinaryFloatingPoint {

    /// Transforms each element into the specified range.
    ///
    /// E.g. If the min value is 0.2 and the specified range is 0...1 the new value will be 0
    /// - Parameter range: The new range that will represent each elemenet
    /// - Returns: The transformed elements
    ///
    /// - Note: https://math.stackexchange.com/questions/1205733/how-to-convert-or-transform-from-one-range-to-another
    func map(to range: ClosedRange<Element>) -> [Element] {
        let sourceMin = self.min() ?? 0
        let sourceMax = self.max() ?? 1
        let destMin = range.lowerBound
        let destMax = range.upperBound
        return map { element in
            let oldRange = sourceMax - sourceMin
            let newRange = destMax - destMin
            return (((element - sourceMin) * newRange) / oldRange) + destMin
        }
    }

}
