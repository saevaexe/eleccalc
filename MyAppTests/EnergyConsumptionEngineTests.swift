import XCTest
@testable import ElecCalc

final class EnergyConsumptionEngineTests: XCTestCase {

    func testDailyConsumption() {
        // kWh = P(kW) × t(h) = 2.0 × 8 = 16 kWh
        XCTAssertEqual(EnergyConsumptionEngine.dailyConsumption(powerKW: 2.0, hoursPerDay: 8), 16.0, accuracy: 1e-9)
    }

    func testDailyCost() {
        // cost = kWh × price = 16 × 2.5 = 40 TL
        XCTAssertEqual(EnergyConsumptionEngine.dailyCost(dailyKWh: 16, unitPrice: 2.5), 40.0, accuracy: 1e-9)
    }

    func testMonthlyConsumption() {
        // monthly = daily × 30 = 16 × 30 = 480 kWh
        XCTAssertEqual(EnergyConsumptionEngine.monthlyConsumption(dailyKWh: 16), 480.0, accuracy: 1e-9)
    }

    func testYearlyConsumption() {
        // yearly = daily × 365 = 16 × 365 = 5840 kWh
        XCTAssertEqual(EnergyConsumptionEngine.yearlyConsumption(dailyKWh: 16), 5840.0, accuracy: 1e-9)
    }

    func testMonthlyCost() {
        // monthly = daily × 30 = 40 × 30 = 1200 TL
        XCTAssertEqual(EnergyConsumptionEngine.monthlyCost(dailyCost: 40), 1200.0, accuracy: 1e-9)
    }

    func testYearlyCost() {
        // yearly = daily × 365 = 40 × 365 = 14600 TL
        XCTAssertEqual(EnergyConsumptionEngine.yearlyCost(dailyCost: 40), 14600.0, accuracy: 1e-9)
    }

    func testCO2Emission() {
        // CO₂ = kWh × 0.47 = 5840 × 0.47 = 2744.8 kg
        XCTAssertEqual(EnergyConsumptionEngine.co2Emission(kWh: 5840), 5840.0 * 0.47, accuracy: 1e-9)
    }

    func testCO2EmissionCustomFactor() {
        // CO₂ = kWh × factor = 1000 × 0.5 = 500 kg
        XCTAssertEqual(EnergyConsumptionEngine.co2Emission(kWh: 1000, emissionFactor: 0.5), 500.0, accuracy: 1e-9)
    }

    func testFullPipeline() {
        // 500W device, 10 hours/day, 3 TL/kWh
        let powerKW = 0.5
        let hours = 10.0
        let price = 3.0

        let daily = EnergyConsumptionEngine.dailyConsumption(powerKW: powerKW, hoursPerDay: hours)
        XCTAssertEqual(daily, 5.0, accuracy: 1e-9)

        let dCost = EnergyConsumptionEngine.dailyCost(dailyKWh: daily, unitPrice: price)
        XCTAssertEqual(dCost, 15.0, accuracy: 1e-9)

        let monthly = EnergyConsumptionEngine.monthlyConsumption(dailyKWh: daily)
        XCTAssertEqual(monthly, 150.0, accuracy: 1e-9)

        let yearly = EnergyConsumptionEngine.yearlyConsumption(dailyKWh: daily)
        XCTAssertEqual(yearly, 1825.0, accuracy: 1e-9)

        let yCost = EnergyConsumptionEngine.yearlyCost(dailyCost: dCost)
        XCTAssertEqual(yCost, 5475.0, accuracy: 1e-9)
    }
}
