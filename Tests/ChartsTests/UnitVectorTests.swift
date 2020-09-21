import XCTest
import SwiftUI
@testable import Charts

final class UnitVectorTests: XCTestCase {

    func testPointsToUnitVector() {
        let points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 20, y: 0),
            CGPoint(x: 0, y: 20),
            CGPoint(x: 40, y: 40),
            CGPoint(x: -50, y: -10),
        ]

        let vector = AnimatableVector(points)
        let actual = vector.map { $0 }

        var expected: [AnimatableVector.Element] = []
        points.forEach {
            expected.append(Double($0.x))
            expected.append(Double($0.y))
        }

        XCTAssertEqual(expected, actual)
    }

    func testUnitsToUnitVector() {
        let units = [
            UnitPoint(x: 0, y: 0),
            UnitPoint(x: 20, y: 0),
            UnitPoint(x: 0, y: 20),
            UnitPoint(x: 40, y: 40),
            UnitPoint(x: -50, y: -10),
        ]

        let vector = AnimatableVector(units)
        let actual = vector.map { $0 }

        var expected: [AnimatableVector.Element] = []
        units.forEach {
            expected.append(Double($0.x))
            expected.append(Double($0.y))
        }

        XCTAssertEqual(expected, actual)
    }

}
