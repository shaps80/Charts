import SwiftUI

struct ChartProxy {
    var size: CGSize
}

struct ChartReader<Content: View>: View {

    private let content: (ChartProxy) -> Content

    init(@ViewBuilder _ content: @escaping (ChartProxy) -> Content) {
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            content(ChartProxy(size: geo.size))
        }
    }
}

struct ChartReader_Previews: PreviewProvider {
    static var previews: some View {
        ChartReader { chart in
            Text("\(chart.size.width)")
        }
    }
}
