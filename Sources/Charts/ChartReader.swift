import SwiftUI

struct Chart<Data, Content: View>: View where Data: RandomAccessCollection, Data.Element: Comparable {

    struct ChartProxy {
        var size: CGSize
        var values: Data.Element
    }

    let content: (Any) -> Content

    init(data: Data, in range: ClosedRange<Data.Element>? = nil, @ViewBuilder _ content: @escaping (ChartProxy) -> Content) {
        let min = data.min() ?? 0
        let max = data.max() ?? 1
        let values = data.map {
            Value(rawValue: $0, range: <#T##ClosedRange<Comparable>#>)
            Value(unitValue: CGFloat(($0 - min) / (max - min)), rawValue: $0)
        }
    }

}

extension Chart where Data.Element: BinaryFloatingPoint {


    init(data: Data, in range: ClosedRange<Data.Element>? = nil, @ViewBuilder _ content: @escaping (ChartProxy) -> Content) {
        let min = data.min() ?? 0
        let max = data.max() ?? 0
        self.data = data.map(to: min...max)
        self.range = range ?? min...max
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
//            content(ChartProxy(size: geo.size, values: values(in: geo.frame(in: .local))))
        }
    }
}
