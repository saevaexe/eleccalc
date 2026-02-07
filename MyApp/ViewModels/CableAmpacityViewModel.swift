import Foundation
import SwiftData

@Observable
final class CableAmpacityViewModel {
    var selectedSection: Double? = nil
    var material: ConductorMaterial = .copper
    var insulation: InsulationType = .xlpe
    var installMethod: InstallMethod = .air
    var ambientTempText: String = "30"
    var circuitCountText: String = "1"

    var baseAmpacity: Double?
    var tempFactor: Double?
    var groupFactor: Double?
    var correctedAmpacity: Double?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        selectedSection != nil
    }

    func calculate() {
        guard let section = selectedSection else { return }

        guard let base = CableAmpacityEngine.baseAmpacity(
            crossSection: section,
            material: material,
            insulation: insulation,
            method: installMethod
        ) else { return }

        let temp = parseDouble(ambientTempText) ?? 30
        let circuits = Int(parseDouble(circuitCountText) ?? 1)

        let kt = CableAmpacityEngine.temperatureFactor(
            insulation: insulation,
            ambientTemp: Int(temp),
            method: installMethod
        )
        let kg = CableAmpacityEngine.groupingFactor(circuitCount: circuits)
        let corrected = CableAmpacityEngine.correctedAmpacity(base: base, tempFactor: kt, groupFactor: kg)

        baseAmpacity = base
        tempFactor = kt
        groupFactor = kg
        correctedAmpacity = corrected
        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let corrected = correctedAmpacity, let section = selectedSection else { return }
        let record = CalculationRecord(
            category: .cableAmpacity,
            title: String(localized: "category.cableAmpacity"),
            inputSummary: "\(section.formatted(.number.precision(.fractionLength(0...1))))mm² \(material.title) \(insulation.title)",
            resultSummary: "Iz = \(corrected.formatted2) A"
        )
        modelContext.insert(record)
    }

    func clear() {
        selectedSection = nil
        material = .copper
        insulation = .xlpe
        installMethod = .air
        ambientTempText = "30"
        circuitCountText = "1"
        baseAmpacity = nil
        tempFactor = nil
        groupFactor = nil
        correctedAmpacity = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
