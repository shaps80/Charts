import SwiftUI

extension Chart {

    /// Creates new chart geometry ideal for integer data in the given range
    /// - Parameters:
    ///   - data: The integer data representing the values in this chart
    ///   - range: The global range values should be translated to. Pass nil to have this inferred automatically
    ///   - content: The chart content, a proxy is provided to simplify access to values and convenience functions for drawing the chart
    public init(data: Data, sourceRange: ClosedRange<Element>? = nil, presentationRange: ClosedRange<Element>? = nil, @ViewBuilder _ content: @escaping (ChartProxy<Data, Element>) -> Content) where Data.Element == Element, Element: BinaryInteger {
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

extension ChartProxy where Data: RandomAccessCollection, Element: BinaryInteger, Data.Element == Element {

    public var average: Data.Element {
        values.reduce(0, +) / Element(values.count)
    }

    public func presentationValue(for value: Data.Element) -> Data.Element {
        let source = Double(sourceRange.lowerBound)...Double(sourceRange.upperBound)
        let destination = Double(range.lowerBound)...Double(range.upperBound)
        return Element(Double(value).map(from: source, to: destination))
    }

    public func unitValue(for value: Data.Element) -> CGFloat {
        let source = Double(sourceRange.lowerBound)...Double(sourceRange.upperBound)
        return CGFloat(Double(value).map(from: source, to: 0...1))
    }

}
