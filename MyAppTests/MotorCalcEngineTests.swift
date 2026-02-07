import XCTest
@testable import MyApp

final class MotorCalcEngineTests: XCTestCase {

    func testNominalCurrent() {
        // In = P(kW)×1000 / (√3 × U × cosφ × η)
        // P=11kW, U=400V, cosφ=0.85, η=0.9
        let expected = 11.0 * 1000.0 / (sqrt(3.0) * 400.0 * 0.85 * 0.9)
        let result = MotorCalcEngine.nominalCurrent(powerKW: 11, voltage: 400, powerFactor: 0.85, efficiency: 0.9)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testStartingCurrent() {
        // Istart = kLR × In = 6 × 20 = 120 A
        XCTAssertEqual(MotorCalcEngine.startingCurrent(nominalCurrent: 20, startingFactor: 6), 120.0, accuracy: 1e-9)
    }

    func testTorque() {
        // T = (P × 1000) / (2π × n/60) = (11 × 1000) / (2π × 1500/60)
        let expected = (11.0 * 1000.0) / (2.0 * .pi * 1500.0 / 60.0)
        let result = MotorCalcEngine.torque(powerKW: 11, rpm: 1500)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testActivePower() {
        // P(kW) = √3 × U × I × cosφ × η / 1000
        let expected = (sqrt(3.0) * 400.0 * 20.0 * 0.85 * 0.9) / 1000.0
        let result = MotorCalcEngine.activePower(voltage: 400, current: 20, powerFactor: 0.85, efficiency: 0.9)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testStandardPowersNotEmpty() {
        XCTAssertFalse(MotorCalcEngine.standardPowers.isEmpty)
        XCTAssertEqual(MotorCalcEngine.standardPowers.first, 0.37)
    }

    // MARK: - IEC Efficiency Table

    func testIECEfficiencyLookup() {
        // 11 kW + IE3 → 0.912
        let eff = MotorCalcEngine.iecEfficiency(powerKW: 11, ieClass: .ie3)
        XCTAssertEqual(eff, 0.912, accuracy: 1e-6)
    }

    func testIECEfficiencyNearestPower() {
        // 10 kW → en yakın 11 kW satırı, IE3 = 0.912
        let eff = MotorCalcEngine.iecEfficiency(powerKW: 10, ieClass: .ie3)
        XCTAssertEqual(eff, 0.912, accuracy: 1e-6)
    }
}
