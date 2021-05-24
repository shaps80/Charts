import SwiftUI

extension Chart {

    /// Creates new chart geometry ideal for range-based data in the given range
    /// - Parameters:
    ///   - data: The range data representing the values in this chart
    ///   - range: The global range values should be translated to. Pass nil to have this inferred automatically
    ///   - content: The chart content, a proxy is provided to simplify access to values and convenience functions for drawing the chart
    public init(data: Data, sourceRange: ClosedRange<Element>? = nil, presentationRange: ClosedRange<Element>? = nil, @ViewBuilder _ content: @escaping (ChartProxy<Data, Element>) -> Content) where Data.Element == ClosedRange<Element>, Element: FloatingPoint {
        let srcMin = sourceRange?.lowerBound ?? data.min(by: { $0.lowerBound < $1.lowerBound })?.lowerBound ?? 0
        let srcMax = sourceRange?.upperBound ?? data.max(by: { $0.upperBound < $1.upperBound })?.upperBound ?? 1
        let dstMin = presentationRange?.lowerBound ?? srcMin
        let dstMax = presentationRange?.upperBound ?? srcMax
        let source = srcMin...srcMax
        let destination = dstMin...dstMax
        self.content = { geo in
            content(
                ChartProxy(
                    size: geo.size,
                    values: data,
                    range: destination,
                    sourceRange: source
                )
            )
        }
    }

}

extension ChartProxy where Data: RandomAccessCollection, Data.Element == ClosedRange<Element>, Element: BinaryFloatingPoint {

    public var average: Data.Element {
        let lower = values.map { $0.lowerBound }.average
        let upper = values.map { $0.upperBound }.average
        return Data.Element(uncheckedBounds: (lower, upper))
    }

    public func presentationRange(for value: Data.Element) -> Data.Element {
        value.map(from: sourceRange, to: range)
    }

    public func unitRange(for value: Data.Element) -> ClosedRange<CGFloat> {
        let range = value.map(from: sourceRange, to: 0...1)
        return CGFloat(range.lowerBound)...CGFloat(range.upperBound)
    }

}
