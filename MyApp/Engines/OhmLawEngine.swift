import Foundation

struct OhmLawEngine {
    static func voltage(current: Double, resistance: Double) -> Double {
        current * resistance
    }

    static func current(voltage: Double, resistance: Double) -> Double {
        voltage / resistance
    }

    static func resistance(voltage: Double, current: Double) -> Double {
        voltage / current
    }

    static func power(voltage: Double, current: Double) -> Double {
        voltage * current
    }

    static func powerFromCurrent(current: Double, resistance: Double) -> Double {
        current * current * resistance
    }

    static func powerFromVoltage(voltage: Double, resistance: Double) -> Double {
        voltage * voltage / resistance
    }
}
