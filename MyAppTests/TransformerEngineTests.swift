import XCTest
@testable import MyApp

final class TransformerEngineTests: XCTestCase {

    func testLoadingRate() {
        // (500 / 1000) × 100 = 50%
        XCTAssertEqual(TransformerEngine.loadingRate(loadPower: 500, transformerPower: 1000), 50.0, accuracy: 1e-9)
        // (1000 / 1000) × 100 = 100%
        XCTAssertEqual(TransformerEngine.loadingRate(loadPower: 1000, transformerPower: 1000), 100.0, accuracy: 1e-9)
    }

    func testNominalCurrent() {
        // I = (S × 1000) / (√3 × V × 1000)
        // I = (1000 × 1000) / (√3 × 0.4 × 1000) = 1000000 / 692.82 = 1443.4 A
        let expected = (1000.0 * 1000.0) / (sqrt(3.0) * 0.4 * 1000.0)
        let result = TransformerEngine.nominalCurrent(transformerPowerKVA: 1000, voltageKV: 0.4)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testCopperLoss() {
        // Pcu = Pcu_nom × (loading/100)² = 10 × (50/100)² = 10 × 0.25 = 2.5 kW
        XCTAssertEqual(TransformerEngine.copperLoss(fullLoadCopperLoss: 10, loadingRate: 50), 2.5, accuracy: 1e-9)
        // Tam yükte: 10 × 1² = 10
        XCTAssertEqual(TransformerEngine.copperLoss(fullLoadCopperLoss: 10, loadingRate: 100), 10.0, accuracy: 1e-9)
    }

    func testTotalLoss() {
        // Toplam = demir + bakır = 1.5 + 2.5 = 4.0 kW
        XCTAssertEqual(TransformerEngine.totalLoss(ironLoss: 1.5, copperLoss: 2.5), 4.0, accuracy: 1e-9)
    }

    func testEfficiency() {
        // η = P / (P + Ptotal) × 100 = 400 / (400 + 5) × 100 = 98.765%
        let expected = (400.0 / 405.0) * 100.0
        XCTAssertEqual(TransformerEngine.efficiency(loadPowerKW: 400, totalLossKW: 5), expected, accuracy: 1e-6)
    }
}
