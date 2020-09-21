import SwiftUI

extension UnitPoint: Identifiable {
    public var id: String { "\(x)" }
}

public struct LineChartViewAxis: View {

    public var vector: AnimatableVector

    /// Instantiates a new shape with the specified unit-space coordinates and associated interpolation method
    /// - Parameters:
    ///   - unitPoints: The unit-space coordinates representing this shape
    ///   - interpolation: The interpolation method to use for this shape
    ///   - closed: If true, the path will be closed
    public init(_ unitPoints: [UnitPoint]) {
        self.vector = AnimatableVector(unitPoints)
    }

    public var body: some View {
        HStack {
            ForEach(vector.unitPoints) { unit in
                Text(String(format: "%.0f", unit.y * 100))
            }
            .frame(maxWidth: .infinity)
        }
    }

}
