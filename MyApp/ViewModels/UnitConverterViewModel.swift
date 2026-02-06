import Foundation
import SwiftData

@Observable
final class UnitConverterViewModel {
    var unitCategory: UnitCategory = .voltage
    var sourceUnitIndex: Int = 1
    var targetUnitIndex: Int = 0
    var inputText: String = ""

    var result: Double?
    var hasCalculated: Bool = false

    var availableUnits: [ElectricalUnit] { unitCategory.units }
    var sourceUnit: ElectricalUnit { availableUnits[min(sourceUnitIndex, availableUnits.count - 1)] }
    var targetUnit: ElectricalUnit { availableUnits[min(targetUnitIndex, availableUnits.count - 1)] }

    var canCalculate: Bool {
        parseDouble(inputText) != nil
    }

    func onCategoryChange() {
        sourceUnitIndex = min(sourceUnitIndex, availableUnits.count - 1)
        targetUnitIndex = min(targetUnitIndex, availableUnits.count - 1)
        result = nil
        hasCalculated = false
    }

    func calculate() {
        guard let value = parseDouble(inputText) else { return }
        result = UnitConverterEngine.convert(value, from: sourceUnit, to: targetUnit)
        hasCalculated = true
    }

    func swapUnits() {
        let temp = sourceUnitIndex
        sourceUnitIndex = targetUnitIndex
        targetUnitIndex = temp
        if hasCalculated { calculate() }
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let result else { return }
        let record = CalculationRecord(
            category: .unitConverter,
            title: String(localized: "category.unitConverter"),
            inputSummary: "\(inputText) \(sourceUnit.symbol)",
            resultSummary: "\(result.formatted2) \(targetUnit.symbol)"
        )
        modelContext.insert(record)
    }

    func clear() {
        inputText = ""
        result = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        let cleaned = text.replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }
}
