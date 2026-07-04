import XCTest
@testable import ElecCalc

final class MotorCalcEngineTests: XCTestCase {

    func testNominalCurrent() {
        // In = 11000 / (√3 × 400 × 0.85 × 0.9) = 20.7544 A
        let result = MotorCalcEngine.nominalCurrent(powerKW: 11, voltage: 400, powerFactor: 0.85, efficiency: 0.9)
        XCTAssertEqual(result, 20.7544, accuracy: 1e-3)
    }

    func testStartingCurrent() {
        // Istart = kLR × In = 6 × 20 = 120 A
        XCTAssertEqual(MotorCalcEngine.startingCurrent(nominalCurrent: 20, startingFactor: 6), 120.0, accuracy: 1e-9)
    }

    func testTorque() {
        // T = 11000 / (2π × 1500/60) = 70.0282 Nm
        let result = MotorCalcEngine.torque(powerKW: 11, rpm: 1500)
        XCTAssertEqual(result, 70.0282, accuracy: 1e-3)
    }

    func testShaftPower() {
        // Pmil = √3 × 400 × 20 × 0.85 × 0.9 / 1000 = 10.6002 kW
        let result = MotorCalcEngine.shaftPower(voltage: 400, current: 20, powerFactor: 0.85, efficiency: 0.9)
        XCTAssertEqual(result, 10.6002, accuracy: 1e-3)
    }

    func testStandardPowersNotEmpty() {
        XCTAssertFalse(MotorCalcEngine.standardPowers.isEmpty)
        XCTAssertEqual(MotorCalcEngine.standardPowers.first, 0.37)
    }

    // MARK: - IEC 60034-30-1:2014 Verim Tablosu (4 kutup, 50 Hz)
    // Referans: ABB Technical note 9AKK107319

    func testIECEfficiencyLookup() {
        // 11 kW + IE3 (4 kutup) → 0.914
        let eff = MotorCalcEngine.iecEfficiency(powerKW: 11, ieClass: .ie3)
        XCTAssertEqual(eff, 0.914, accuracy: 1e-6)
    }

    func testIECEfficiencyNearestPower() {
        // 10 kW → en yakın 11 kW satırı, IE3 = 0.914
        let eff = MotorCalcEngine.iecEfficiency(powerKW: 10, ieClass: .ie3)
        XCTAssertEqual(eff, 0.914, accuracy: 1e-6)
    }

    func testIECEfficiency_075kW_referenceValues() {
        // IEC 60034-30-1, 0.75 kW 4 kutup: IE1=72.1, IE2=79.6, IE3=82.5, IE4=85.7
        XCTAssertEqual(MotorCalcEngine.iecEfficiency(powerKW: 0.75, ieClass: .ie1), 0.721, accuracy: 1e-6)
        XCTAssertEqual(MotorCalcEngine.iecEfficiency(powerKW: 0.75, ieClass: .ie2), 0.796, accuracy: 1e-6)
        XCTAssertEqual(MotorCalcEngine.iecEfficiency(powerKW: 0.75, ieClass: .ie3), 0.825, accuracy: 1e-6)
        XCTAssertEqual(MotorCalcEngine.iecEfficiency(powerKW: 0.75, ieClass: .ie4), 0.857, accuracy: 1e-6)
    }

    func testIECEfficiency_75kW_referenceValues() {
        // IEC 60034-30-1, 75 kW 4 kutup: IE2=94.0, IE3=95.0, IE4=96.0
        XCTAssertEqual(MotorCalcEngine.iecEfficiency(powerKW: 75, ieClass: .ie2), 0.940, accuracy: 1e-6)
        XCTAssertEqual(MotorCalcEngine.iecEfficiency(powerKW: 75, ieClass: .ie3), 0.950, accuracy: 1e-6)
        XCTAssertEqual(MotorCalcEngine.iecEfficiency(powerKW: 75, ieClass: .ie4), 0.960, accuracy: 1e-6)
    }

    func testIECEfficiencyMonotonicAcrossClasses() {
        // Her güçte IE1 < IE2 < IE3 < IE4 olmalı
        for entry in MotorCalcEngine.iecEfficiencyTable {
            XCTAssertLessThan(entry.ie1, entry.ie2, "IE1 < IE2 fail @ \(entry.powerKW) kW")
            XCTAssertLessThan(entry.ie2, entry.ie3, "IE2 < IE3 fail @ \(entry.powerKW) kW")
            XCTAssertLessThan(entry.ie3, entry.ie4, "IE3 < IE4 fail @ \(entry.powerKW) kW")
        }
    }
}
