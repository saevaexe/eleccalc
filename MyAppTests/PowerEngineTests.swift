import XCTest
@testable import MyApp

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
        // Q = S × sin(acos(0.8)) = 1000 × 0.6 = 600 VAR
        let expected = 1000.0 * sin(acos(0.8))
        XCTAssertEqual(PowerEngine.reactivePower(apparentPower: 1000.0, powerFactor: 0.8), expected, accuracy: 1e-6)
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
        // S = √3 × V × I = √3 × 400 × 10 = 6928.2 VA
        let expected = sqrt(3.0) * 400.0 * 10.0
        XCTAssertEqual(PowerEngine.threePhaseApparentPower(lineVoltage: 400.0, lineCurrent: 10.0), expected, accuracy: 1e-6)
    }

    func testThreePhaseActivePower() {
        // P = √3 × V × I × cosφ
        let expected = sqrt(3.0) * 400.0 * 10.0 * 0.85
        XCTAssertEqual(PowerEngine.threePhaseActivePower(lineVoltage: 400.0, lineCurrent: 10.0, powerFactor: 0.85), expected, accuracy: 1e-6)
    }
}
