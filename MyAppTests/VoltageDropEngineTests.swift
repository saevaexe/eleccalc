import XCTest
@testable import ElecCalc

final class VoltageDropEngineTests: XCTestCase {

    // Referans değerler elle hesaplandı (ρ70: Cu=0.0210, Al=0.0336 Ω·mm²/m)

    func testVoltageDrop_singlePhase_copper() {
        // ΔV = (k × ρ × L × I) / S = (2 × 0.0210 × 50 × 20) / 6 = 7.0 V
        let result = VoltageDropEngine.voltageDrop(
            current: 20, length: 50, crossSection: 6,
            material: .copper, phaseConfig: .singlePhase
        )
        XCTAssertEqual(result, 7.0, accuracy: 1e-6)
    }

    func testVoltageDrop_threePhase_aluminum() {
        // ΔV = (√3 × 0.0336 × 100 × 50) / 35 = 8.31384 V
        let result = VoltageDropEngine.voltageDrop(
            current: 50, length: 100, crossSection: 35,
            material: .aluminum, phaseConfig: .threePhase
        )
        XCTAssertEqual(result, 8.31384, accuracy: 1e-4)
    }

    func testVoltageDropPercent() {
        // %ΔV = (6.9 / 230) × 100 = 3.0
        XCTAssertEqual(VoltageDropEngine.voltageDropPercent(voltageDrop: 6.9, systemVoltage: 230.0), 3.0, accuracy: 1e-6)
    }

    func testMaxLength() {
        // L_max = (ΔV_max × S) / (k × ρ × I) = (6.9 × 6) / (2 × 0.0210 × 20) = 49.2857 m
        let result = VoltageDropEngine.maxLength(
            current: 20, crossSection: 6, material: .copper,
            systemVoltage: 230, maxDropPercent: 3, phaseConfig: .singlePhase
        )
        XCTAssertEqual(result, 49.2857, accuracy: 1e-3)
    }

    func testRoundTrip_dropAtMaxLengthEqualsLimit() {
        // maxLength'te hesaplanan düşüm tam olarak izin verilen sınıra eşit olmalı
        let length = VoltageDropEngine.maxLength(
            current: 32, crossSection: 10, material: .copper,
            systemVoltage: 400, maxDropPercent: 5, phaseConfig: .threePhase
        )
        let drop = VoltageDropEngine.voltageDrop(
            current: 32, length: length, crossSection: 10,
            material: .copper, phaseConfig: .threePhase
        )
        XCTAssertEqual(drop, 400 * 0.05, accuracy: 1e-9)
    }
}
