import Foundation

struct MotorCalcEngine {
    /// Nominal akım: In = P(kW) × 1000 / (√3 × U × cosφ × η)
    static func nominalCurrent(powerKW: Double, voltage: Double, powerFactor: Double, efficiency: Double) -> Double {
        (powerKW * 1000.0) / (sqrt(3.0) * voltage * powerFactor * efficiency)
    }

    /// Kalkış akımı: Istart = kLR × In
    static func startingCurrent(nominalCurrent: Double, startingFactor: Double) -> Double {
        nominalCurrent * startingFactor
    }

    /// Mekanik tork: T = (P × 1000) / (2π × n/60)  [Nm]
    static func torque(powerKW: Double, rpm: Double) -> Double {
        (powerKW * 1000.0) / (2.0 * .pi * rpm / 60.0)
    }

    /// Aktif güç: P(kW) = √3 × U × I × cosφ × η / 1000
    static func activePower(voltage: Double, current: Double, powerFactor: Double, efficiency: Double) -> Double {
        (sqrt(3.0) * voltage * current * powerFactor * efficiency) / 1000.0
    }

    /// IEC standart motor güçleri (kW)
    static let standardPowers: [Double] = [
        0.37, 0.55, 0.75, 1.1, 1.5, 2.2, 3, 4, 5.5, 7.5,
        11, 15, 18.5, 22, 30, 37, 45, 55, 75, 90, 110, 132, 160, 200, 250, 315
    ]
}
