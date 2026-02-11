import XCTest
@testable import ElecCalc

final class OhmLawEngineTests: XCTestCase {

    func testVoltage() {
        // V = I × R = 2 × 100 = 200
        XCTAssertEqual(OhmLawEngine.voltage(current: 2.0, resistance: 100.0), 200.0, accuracy: 1e-9)
        XCTAssertEqual(OhmLawEngine.voltage(current: 0.5, resistance: 47.0), 23.5, accuracy: 1e-9)
    }

    func testCurrent() {
        // I = V / R = 230 / 46 = 5
        XCTAssertEqual(OhmLawEngine.current(voltage: 230.0, resistance: 46.0), 5.0, accuracy: 1e-9)
    }

    func testResistance() {
        // R = V / I = 230 / 10 = 23
        XCTAssertEqual(OhmLawEngine.resistance(voltage: 230.0, current: 10.0), 23.0, accuracy: 1e-9)
    }

    func testPower() {
        // P = V × I = 230 × 10 = 2300
        XCTAssertEqual(OhmLawEngine.power(voltage: 230.0, current: 10.0), 2300.0, accuracy: 1e-9)
    }

    func testPowerFromCurrent() {
        // P = I² × R = 25 × 10 = 250
        XCTAssertEqual(OhmLawEngine.powerFromCurrent(current: 5.0, resistance: 10.0), 250.0, accuracy: 1e-9)
    }

    func testPowerFromVoltage() {
        // P = V² / R = 10000 / 50 = 200
        XCTAssertEqual(OhmLawEngine.powerFromVoltage(voltage: 100.0, resistance: 50.0), 200.0, accuracy: 1e-9)
    }
}
