import Foundation

struct EnergyConsumptionEngine {
    /// Günlük enerji tüketimi: kWh = P(kW) × t(saat)
    static func dailyConsumption(powerKW: Double, hoursPerDay: Double) -> Double {
        powerKW * hoursPerDay
    }

    /// Günlük maliyet
    static func dailyCost(dailyKWh: Double, unitPrice: Double) -> Double {
        dailyKWh * unitPrice
    }

    /// Aylık tüketim (30 gün)
    static func monthlyConsumption(dailyKWh: Double) -> Double {
        dailyKWh * 30.0
    }

    /// Yıllık tüketim
    static func yearlyConsumption(dailyKWh: Double) -> Double {
        dailyKWh * 365.0
    }

    /// Aylık maliyet
    static func monthlyCost(dailyCost: Double) -> Double {
        dailyCost * 30.0
    }

    /// Yıllık maliyet
    static func yearlyCost(dailyCost: Double) -> Double {
        dailyCost * 365.0
    }

    /// CO₂ emisyonu: kg = kWh × emisyon faktörü (TR ortalaması ~0.47 kg/kWh)
    static func co2Emission(kWh: Double, emissionFactor: Double = 0.47) -> Double {
        kWh * emissionFactor
    }
}
