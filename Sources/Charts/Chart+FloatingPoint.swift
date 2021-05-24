import SwiftUI

extension Chart {

    /// Creates new chart geometry ideal for floating-point data in the given range
    /// - Parameters:
    ///   - data: The floating point data representing the values in this chart
    ///   - targetRange: The global range values should be translated to. Pass nil to have this inferred automatically
    ///   - content: The chart content, a proxy is provided to simplify access to values and convenience functions for drawing the chart
    public init(data: Data, sourceRange: ClosedRange<Element>? = nil, presentationRange: ClosedRange<Element>? = nil, @ViewBuilder _ content: @escaping (ChartProxy<Data, Element>) -> Content) where Data.Element == Element, Element: FloatingPoint {
        let srcMin = sourceRange?.lowerBound ?? data.min() ?? 0
        let srcMax = sourceRange?.upperBound ?? data.max() ?? 1
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

extension ChartProxy where Data: RandomAccessCollection, Data.Element: BinaryFloatingPoint, Data.Element == Element {

    public var average: Data.Element {
        values.reduce(0, +) / Element(values.count)
    }

    public func presentationValue(for value: Data.Element) -> Data.Element {
        value.map(from: sourceRange, to: range)
    }

    public func unitValue(for value: Data.Element) -> CGFloat {
        CGFloat(value.map(from: sourceRange, to: 0...1))
    }

}
