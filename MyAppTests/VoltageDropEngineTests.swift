import XCTest
@testable import ElecCalc

final class VoltageDropEngineTests: XCTestCase {

    func testVoltageDrop_singlePhase_copper() {
        // ΔV = (k × ρ × L × I) / S
        // k=2, ρ=0.0175, L=50, I=20, S=6
        let expected = (2.0 * 0.0175 * 50.0 * 20.0) / 6.0
        let result = VoltageDropEngine.voltageDrop(
            current: 20, length: 50, crossSection: 6,
            material: .copper, phaseConfig: .singlePhase
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testVoltageDrop_threePhase_aluminum() {
        // k=√3, ρ=0.028, L=100, I=50, S=35
        let expected = (sqrt(3.0) * 0.028 * 100.0 * 50.0) / 35.0
        let result = VoltageDropEngine.voltageDrop(
            current: 50, length: 100, crossSection: 35,
            material: .aluminum, phaseConfig: .threePhase
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testVoltageDropPercent() {
        // %ΔV = (ΔV / V) × 100 = (6.9 / 230) × 100 = 3.0
        XCTAssertEqual(VoltageDropEngine.voltageDropPercent(voltageDrop: 6.9, systemVoltage: 230.0), 3.0, accuracy: 1e-6)
    }

    func testMaxLength() {
        // L_max = (ΔV_max × S) / (k × ρ × I)
        // ΔV_max = 230 × 3/100 = 6.9
        let expected = (6.9 * 6.0) / (2.0 * 0.0175 * 20.0)
        let result = VoltageDropEngine.maxLength(
            current: 20, crossSection: 6, material: .copper,
            systemVoltage: 230, maxDropPercent: 3, phaseConfig: .singlePhase
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }
}
