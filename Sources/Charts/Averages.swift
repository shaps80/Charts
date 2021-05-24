import Foundation

extension RandomAccessCollection where Element: FloatingPoint {
    var average: Element {
        reduce(0, +) / Element(count)
    }
}

extension RandomAccessCollection where Element: BinaryInteger {
    var average: Element {
        reduce(0, +) / Element(count)
    }
}
