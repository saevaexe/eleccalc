import Foundation
import SwiftData

@Observable
final class LightingViewModel {
    var areaText: String = ""
    var targetLuxText: String = "500"
    var lumensPerFixtureText: String = ""
    var wattsPerFixtureText: String = ""
    var utilizationFactorText: String = "0,65"
    var maintenanceFactorText: String = "0,8"

    var requiredFixtures: Double?
    var powerDensity: Double?
    var totalLumens: Double?
    var formulaUsed: String = ""
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        parseDouble(areaText) != nil &&
        parseDouble(targetLuxText) != nil &&
        parseDouble(lumensPerFixtureText) != nil &&
        parseDouble(utilizationFactorText) != nil &&
        parseDouble(maintenanceFactorText) != nil
    }

    func calculate() {
        guard let area = parseDouble(areaText),
              let lux = parseDouble(targetLuxText),
              let lumens = parseDouble(lumensPerFixtureText),
              let cu = parseDouble(utilizationFactorText),
              let mf = parseDouble(maintenanceFactorText),
              area > 0, lumens > 0, cu > 0, mf > 0 else { return }

        requiredFixtures = LightingEngine.requiredFixtures(
            targetLux: lux, area: area,
            lumensPerFixture: lumens,
            utilizationFactor: cu, maintenanceFactor: mf
        )
        formulaUsed = "n = (E × A) / (Φ × CU × MF)"

        totalLumens = LightingEngine.totalLumens(
            targetLux: lux, area: area,
            utilizationFactor: cu, maintenanceFactor: mf
        )

        if let watts = parseDouble(wattsPerFixtureText), let n = requiredFixtures {
            let fixtureCount = Int(ceil(n))
            powerDensity = LightingEngine.powerDensity(
                fixtureCount: fixtureCount, wattsPerFixture: watts, area: area
            )
        }

        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let n = requiredFixtures else { return }
        let record = CalculationRecord(
            category: .lighting,
            title: String(localized: "category.lighting"),
            inputSummary: "A=\(areaText)m², E=\(targetLuxText)lux",
            resultSummary: "n = \(Int(ceil(n))) \(String(localized: "result.fixtures"))"
        )
        modelContext.insert(record)
    }

    func clear() {
        areaText = ""
        targetLuxText = "500"
        lumensPerFixtureText = ""
        wattsPerFixtureText = ""
        utilizationFactorText = "0,65"
        maintenanceFactorText = "0,8"
        requiredFixtures = nil
        powerDensity = nil
        totalLumens = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
