import XCTest
@testable import MyApp

final class UnitConverterEngineTests: XCTestCase {

    // MARK: - Voltage

    func testConvert_milliVoltToVolt() {
        XCTAssertEqual(UnitConverterEngine.convert(1000, from: .milliVolt, to: .volt), 1.0, accuracy: 1e-9)
    }

    func testConvert_voltToKiloVolt() {
        XCTAssertEqual(UnitConverterEngine.convert(1000, from: .volt, to: .kiloVolt), 1.0, accuracy: 1e-9)
    }

    // MARK: - Current

    func testConvert_ampereToMilliAmpere() {
        XCTAssertEqual(UnitConverterEngine.convert(1, from: .ampere, to: .milliAmpere), 1000.0, accuracy: 1e-6)
    }

    func testConvert_kiloAmpereToAmpere() {
        XCTAssertEqual(UnitConverterEngine.convert(2.5, from: .kiloAmpere, to: .ampere), 2500.0, accuracy: 1e-6)
    }

    // MARK: - Power

    func testConvert_kiloWattToWatt() {
        XCTAssertEqual(UnitConverterEngine.convert(1.5, from: .kiloWatt, to: .watt), 1500.0, accuracy: 1e-6)
    }

    func testConvert_wattToMegaWatt() {
        XCTAssertEqual(UnitConverterEngine.convert(1_000_000, from: .watt, to: .megaWatt), 1.0, accuracy: 1e-9)
    }

    // MARK: - Resistance

    func testConvert_megaOhmToOhm() {
        XCTAssertEqual(UnitConverterEngine.convert(2.2, from: .megaOhm, to: .ohm), 2_200_000.0, accuracy: 1e-3)
    }

    func testConvert_ohmToKiloOhm() {
        XCTAssertEqual(UnitConverterEngine.convert(4700, from: .ohm, to: .kiloOhm), 4.7, accuracy: 1e-9)
    }

    func testConvert_milliOhmToOhm() {
        XCTAssertEqual(UnitConverterEngine.convert(500, from: .milliOhm, to: .ohm), 0.5, accuracy: 1e-9)
    }

    // MARK: - Capacitance

    func testConvert_microFaradToNanoFarad() {
        XCTAssertEqual(UnitConverterEngine.convert(1.0, from: .microFarad, to: .nanoFarad), 1000.0, accuracy: 1e-3)
    }

    func testConvert_picoFaradToNanoFarad() {
        XCTAssertEqual(UnitConverterEngine.convert(1000, from: .picoFarad, to: .nanoFarad), 1.0, accuracy: 1e-6)
    }

    // MARK: - Round Trip

    func testRoundTrip_voltage() {
        let original = 42.0
        let converted = UnitConverterEngine.convert(original, from: .kiloVolt, to: .milliVolt)
        let back = UnitConverterEngine.convert(converted, from: .milliVolt, to: .kiloVolt)
        XCTAssertEqual(back, original, accuracy: 1e-6)
    }

    func testRoundTrip_capacitance() {
        let original = 100.0
        let converted = UnitConverterEngine.convert(original, from: .microFarad, to: .picoFarad)
        let back = UnitConverterEngine.convert(converted, from: .picoFarad, to: .microFarad)
        XCTAssertEqual(back, original, accuracy: 1e-3)
    }

    func testRoundTrip_resistance() {
        let original = 3.3
        let converted = UnitConverterEngine.convert(original, from: .kiloOhm, to: .milliOhm)
        let back = UnitConverterEngine.convert(converted, from: .milliOhm, to: .kiloOhm)
        XCTAssertEqual(back, original, accuracy: 1e-6)
    }
}
