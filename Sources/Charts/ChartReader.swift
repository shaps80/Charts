import SwiftUI

struct SingleValueChart<Data, Content: View>: View where Data: RandomAccessCollection, Data.Element: BinaryFloatingPoint {

    let data: Data
    let range: ClosedRange<Data.Element>
    let content: (ChartProxy) -> Content

    init(data: Data, in range: ClosedRange<Data.Element>? = nil, @ViewBuilder _ content: @escaping (ChartProxy) -> Content) {
        let min = data.min() ?? 0
        let max = data.max() ?? 0
        self.data = data
        self.range = range ?? min...max
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            content(ChartProxy(size: geo.size, dataset: dataset(in: geo.frame(in: .local))))
        }
    }

    private func dataset(in rect: CGRect) -> [Value] {
        []
    }

}

extension SingleValueChart {
    struct Value {
        var unitPoint: UnitPoint
        var rawValue: Data.Element
    }

    struct ChartProxy {
        var size: CGSize
        var dataset: [Value]
    }
}
