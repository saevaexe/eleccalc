import Foundation

struct ShortCircuitEngine {
    /// Toplam empedans: Zk = √(Rk² + Xk²)
    static func totalImpedance(resistance: Double, reactance: Double) -> Double {
        sqrt(resistance * resistance + reactance * reactance)
    }

    /// 3 fazlı kısa devre akımı: Isc = U / (√3 × Zk)
    static func shortCircuitCurrent3Phase(voltage: Double, impedance: Double) -> Double {
        voltage / (sqrt(3.0) * impedance)
    }

    /// 1 fazlı kısa devre akımı: Isc = U / (2 × Zk)
    static func shortCircuitCurrent1Phase(voltage: Double, impedance: Double) -> Double {
        voltage / (2.0 * impedance)
    }

    /// Kablo empedansı: Z = √((R/km × L/1000)² + (X/km × L/1000)²)
    static func cableImpedance(resistancePerKm: Double, reactancePerKm: Double, lengthM: Double) -> Double {
        let r = resistancePerKm * lengthM / 1000.0
        let x = reactancePerKm * lengthM / 1000.0
        return sqrt(r * r + x * x)
    }

    /// Trafo kısa devre empedansı: Zt = (Uk% / 100) × (U² / Sn)
    static func transformerImpedance(ukPercent: Double, secondaryVoltage: Double, nominalPowerVA: Double) -> Double {
        (ukPercent / 100.0) * (secondaryVoltage * secondaryVoltage) / nominalPowerVA
    }

    /// Darbe kısa devre akımı: ip = κ × √2 × Isc
    static func peakShortCircuitCurrent(rmsCurrent: Double, kappa: Double) -> Double {
        kappa * sqrt(2.0) * rmsCurrent
    }
}
