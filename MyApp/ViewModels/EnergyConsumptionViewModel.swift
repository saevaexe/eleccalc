import Foundation
import SwiftData

@Observable
final class EnergyConsumptionViewModel {
    var powerText: String = ""
    var hoursPerDayText: String = ""
    var unitPriceText: String = ""
    var powerUnitIsKW: Bool = false

    var dailyKWh: Double?
    var dailyCost: Double?
    var monthlyKWh: Double?
    var monthlyCost: Double?
    var yearlyKWh: Double?
    var yearlyCost: Double?
    var yearlyCO2: Double?
    var hasCalculated: Bool = false

    var canCalculate: Bool {
        parseDouble(powerText) != nil &&
        parseDouble(hoursPerDayText) != nil &&
        parseDouble(unitPriceText) != nil
    }

    func calculate() {
        guard let power = parseDouble(powerText),
              let hours = parseDouble(hoursPerDayText),
              let price = parseDouble(unitPriceText) else { return }

        let powerKW = powerUnitIsKW ? power : power / 1000.0

        dailyKWh = EnergyConsumptionEngine.dailyConsumption(powerKW: powerKW, hoursPerDay: hours)

        guard let daily = dailyKWh else { return }

        dailyCost = EnergyConsumptionEngine.dailyCost(dailyKWh: daily, unitPrice: price)
        monthlyKWh = EnergyConsumptionEngine.monthlyConsumption(dailyKWh: daily)
        monthlyCost = EnergyConsumptionEngine.monthlyCost(dailyCost: dailyCost!)
        yearlyKWh = EnergyConsumptionEngine.yearlyConsumption(dailyKWh: daily)
        yearlyCost = EnergyConsumptionEngine.yearlyCost(dailyCost: dailyCost!)
        yearlyCO2 = EnergyConsumptionEngine.co2Emission(kWh: yearlyKWh!)

        hasCalculated = true
    }

    func saveToHistory(modelContext: ModelContext) {
        guard let daily = dailyKWh, let yearly = yearlyCost else { return }
        let record = CalculationRecord(
            category: .energyConsumption,
            title: String(localized: "category.energyConsumption"),
            inputSummary: "P=\(powerText)\(powerUnitIsKW ? "kW" : "W"), t=\(hoursPerDayText)h",
            resultSummary: "\(daily.formatted2) kWh/\(String(localized: "result.day")), \(yearly.formatted2) TL/\(String(localized: "result.year"))"
        )
        modelContext.insert(record)
    }

    func clear() {
        powerText = ""
        hoursPerDayText = ""
        unitPriceText = ""
        dailyKWh = nil
        dailyCost = nil
        monthlyKWh = nil
        monthlyCost = nil
        yearlyKWh = nil
        yearlyCost = nil
        yearlyCO2 = nil
        hasCalculated = false
    }

    private func parseDouble(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
