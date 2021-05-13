import SwiftUI
import enum Accelerate.vDSP

/// A vector for representing an array of arbitrary animated values
///
/// - seealso: https://nerdyak.tech/development/2020/05/07/morphing-shapes-in-swiftui.html
public struct AnimatableVector: VectorArithmetic, RandomAccessCollection {

    /// Represents the underlying vector values.
    private var elements: [Element]

    /// Instantiates an animatable vector with a series of values
    /// - Parameter elements: The values this vector will represent.
    public init<Data>(_ elements: Data) where Data: RandomAccessCollection, Data.Element: BinaryFloatingPoint {
        self.elements = []
        let max = elements.max() ?? 0
        let min = elements.min() ?? 0

        for (index, value) in elements.enumerated() {
            let x = CGFloat(index) / CGFloat(elements.count - 1)
            let y = CGFloat((value - min) / (max - min))
            self.elements.append(Element(x))
            self.elements.append(Element(y))
        }
    }

}

public extension AnimatableVector {

    typealias Element = Double
    typealias Iterator = Array<Element>.Iterator
    typealias Index = Array<Element>.Index

    func makeIterator() -> IndexingIterator<[Element]> {
        return elements.makeIterator()
    }

    var isEmpty: Bool { return elements.isEmpty }
    var startIndex: Index { return elements.startIndex }
    var endIndex: Index { return elements.endIndex }
    subscript(_ value: Int) -> Element { elements[value] }

}

public extension AnimatableVector {

    /// Convenience initializer that takes a series of `CGPoint` values, such that the `x` and `y` values will be flattened into an array
    /// - Parameter values: The points this vector will represent.
    init(_ values: [CGPoint]) {
        var elements: [Element] = []

        for value in values {
            elements.append(Element(value.x))
            elements.append(Element(value.y))
        }

        self.elements = elements
    }

    /// Convenience initializer that takes a series of `CGPoint` values, such that the `x` and `y` values will be flattened into an array
    /// - Parameter points: The points this vector will represent.
    init(_ values: [UnitPoint]) {
        var elements: [Element] = []

        for value in values {
            elements.append(Element(value.x))
            elements.append(Element(value.y))
        }

        self.elements = elements
    }

}

public extension AnimatableVector {

    static var zero: AnimatableVector { .init([Element]()) }

    var magnitudeSquared: Element {
        vDSP.sum(vDSP.multiply(elements, elements))
    }

    mutating func scale(by rhs: Element) {
        elements = vDSP.multiply(rhs, elements)
    }

    static func + (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = Swift.min(lhs.elements.count, rhs.elements.count)
        return .init(vDSP.add(lhs.elements[0..<count], rhs.elements[0..<count]))
    }

    static func += (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = Swift.min(lhs.elements.count, rhs.elements.count)
        vDSP.add(lhs.elements[0..<count], rhs.elements[0..<count], result: &lhs.elements[0..<count])
    }

    static func - (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = Swift.min(lhs.elements.count, rhs.elements.count)
        return .init(vDSP.subtract(lhs.elements[0..<count], rhs.elements[0..<count]))
    }

    static func -= (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = Swift.min(lhs.elements.count, rhs.elements.count)
        vDSP.subtract(lhs.elements[0..<count], rhs.elements[0..<count], result: &lhs.elements[0..<count])
    }

}

public extension Path {

    func animatableVector(granularity: Int) -> AnimatableVector {
        AnimatableVector((0..<granularity).map {
            point(for: CGFloat($0) / CGFloat(granularity))
        })
    }

    private func point(for offset: CGFloat) -> CGPoint {
        let clamped = min(max(offset, 0), 1)
        guard clamped > 0 else { return cgPath.currentPoint }
        return trimmedPath(from: 0, to: clamped).cgPath.currentPoint
    }

}

public extension Array where Element == CGPoint {

    /// Returns an array of unit-space coordinates relative the reference frame
    /// - Parameter rect: The reference frame representing these points
    func unitPoints(in rect: CGRect) -> [UnitPoint] {
        map { UnitPoint(x: $0.x / rect.width, y: $0.y / rect.height) }
    }

}

extension AnimatableVector: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

public extension AnimatableVector {

    /// Returns the UnitVector values as a series of `UnitPoint` values
    ///
    /// If the underlying data cannot be represented by `UnitPoint` values, an empty array will be returned
    var unitPoints: [UnitPoint] {
        guard count % 2 == 0 else { return [] }
        return chunked(into: 2).map { UnitPoint(x: CGFloat($0[0]), y: CGFloat($0[1])) }
    }

}

private extension RandomAccessCollection where Index == Int {
    /// Returns an array of elements grouped in chunks of `size`
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
