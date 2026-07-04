import XCTest
@testable import ElecCalc

final class PowerEngineTests: XCTestCase {

    func testApparentPower() {
        // S = V × I = 230 × 10 = 2300 VA
        XCTAssertEqual(PowerEngine.apparentPower(voltage: 230.0, current: 10.0), 2300.0, accuracy: 1e-9)
    }

    func testActivePower() {
        // P = S × cosφ = 2300 × 0.85 = 1955 W
        XCTAssertEqual(PowerEngine.activePower(apparentPower: 2300.0, powerFactor: 0.85), 1955.0, accuracy: 1e-9)
    }

    func testReactivePower() {
        // Q = S × sinφ, cosφ=0.8 → sinφ=0.6 → Q = 1000 × 0.6 = 600 VAR
        XCTAssertEqual(PowerEngine.reactivePower(apparentPower: 1000.0, powerFactor: 0.8), 600.0, accuracy: 1e-6)
    }

    func testPowerFactor() {
        // cosφ = P / S = 800 / 1000 = 0.8
        XCTAssertEqual(PowerEngine.powerFactor(activePower: 800.0, apparentPower: 1000.0), 0.8, accuracy: 1e-9)
    }

    func testApparentPowerFromPQ() {
        // S = √(P² + Q²) = √(300² + 400²) = 500
        XCTAssertEqual(PowerEngine.apparentPowerFromPQ(activePower: 300.0, reactivePower: 400.0), 500.0, accuracy: 1e-9)
    }

    func testThreePhaseApparentPower() {
        // S = √3 × 400 × 10 = 6928.203 VA
        XCTAssertEqual(PowerEngine.threePhaseApparentPower(lineVoltage: 400.0, lineCurrent: 10.0), 6928.203, accuracy: 1e-2)
    }

    func testThreePhaseActivePower() {
        // P = √3 × 400 × 10 × 0.85 = 5888.973 W
        XCTAssertEqual(PowerEngine.threePhaseActivePower(lineVoltage: 400.0, lineCurrent: 10.0, powerFactor: 0.85), 5888.973, accuracy: 1e-2)
    }

    func testCurrentFromApparentPower_threePhase() {
        // I = S / (√3 × U) = 100000 / (√3 × 400) = 144.338 A
        let result = PowerEngine.currentFromApparentPower(apparentPower: 100_000, voltage: 400, isThreePhase: true)
        XCTAssertEqual(result, 144.338, accuracy: 1e-2)
    }

    func testCurrentFromApparentPower_singlePhase() {
        // I = S / U = 10000 / 230 = 43.478 A
        let result = PowerEngine.currentFromApparentPower(apparentPower: 10_000, voltage: 230, isThreePhase: false)
        XCTAssertEqual(result, 43.478, accuracy: 1e-2)
    }
}
