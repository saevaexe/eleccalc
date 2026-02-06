import Foundation

struct VoltageDropEngine {
    static func voltageDrop(
        current: Double,
        length: Double,
        crossSection: Double,
        material: ConductorMaterial,
        phaseConfig: PhaseConfiguration
    ) -> Double {
        (phaseConfig.factor * material.resistivity * length * current) / crossSection
    }

    static func voltageDropPercent(voltageDrop: Double, systemVoltage: Double) -> Double {
        (voltageDrop / systemVoltage) * 100.0
    }

    static func maxLength(
        current: Double,
        crossSection: Double,
        material: ConductorMaterial,
        systemVoltage: Double,
        maxDropPercent: Double,
        phaseConfig: PhaseConfiguration
    ) -> Double {
        let maxDrop = systemVoltage * (maxDropPercent / 100.0)
        return (maxDrop * crossSection) / (phaseConfig.factor * material.resistivity * current)
    }
}
