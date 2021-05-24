import SwiftUI

/// Provides a container that defines axis-agnostic geometry for a series of chart data
public struct Chart<Data, Element, Content: View>: View where Data: RandomAccessCollection, Element: Comparable {

    internal let content: (GeometryProxy) -> Content

    public var body: some View {
        GeometryReader { content($0) }
    }

}

/// A proxy for access to the chart geometry and anchor resolution of the parent chart
public struct ChartProxy<Data, Element> where Element: Comparable {
    public let size: CGSize
    public let values: Data
    public let range: ClosedRange<Element>
    internal let sourceRange: ClosedRange<Element>
}
