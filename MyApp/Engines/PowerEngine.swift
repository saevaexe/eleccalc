import Foundation

struct PowerEngine {
    static func apparentPower(voltage: Double, current: Double) -> Double {
        voltage * current
    }

    static func activePower(apparentPower: Double, powerFactor: Double) -> Double {
        apparentPower * powerFactor
    }

    static func reactivePower(apparentPower: Double, powerFactor: Double) -> Double {
        apparentPower * sin(acos(powerFactor))
    }

    static func powerFactor(activePower: Double, apparentPower: Double) -> Double {
        activePower / apparentPower
    }

    static func apparentPowerFromPQ(activePower: Double, reactivePower: Double) -> Double {
        sqrt(activePower * activePower + reactivePower * reactivePower)
    }

    static func threePhaseApparentPower(lineVoltage: Double, lineCurrent: Double) -> Double {
        sqrt(3.0) * lineVoltage * lineCurrent
    }

    static func threePhaseActivePower(lineVoltage: Double, lineCurrent: Double, powerFactor: Double) -> Double {
        sqrt(3.0) * lineVoltage * lineCurrent * powerFactor
    }
}
