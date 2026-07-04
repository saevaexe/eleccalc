import XCTest
@testable import ElecCalc

final class CableSectionEngineTests: XCTestCase {

    // Referans değerler elle hesaplandı (ρ70: Cu=0.0210, Al=0.0336 Ω·mm²/m)

    func testMinimumCrossSection_singlePhase_copper() {
        // S = (ρ × L × I × k) / ΔU_max = (0.0210 × 50 × 20 × 2) / 6.9 = 6.08696 mm²
        let result = CableSectionEngine.minimumCrossSection(
            current: 20, length: 50, material: .copper,
            voltage: 230, maxDropPercent: 3, phaseConfig: .singlePhase
        )
        XCTAssertEqual(result, 6.08696, accuracy: 1e-4)
    }

    func testMinimumCrossSection_threePhase_aluminum() {
        // S = (0.0336 × 100 × 50 × √3) / (400 × 0.05) = 14.5492 mm²
        let result = CableSectionEngine.minimumCrossSection(
            current: 50, length: 100, material: .aluminum,
            voltage: 400, maxDropPercent: 5, phaseConfig: .threePhase
        )
        XCTAssertEqual(result, 14.5492, accuracy: 1e-3)
    }

    func testRecommendedSection() {
        // 6.087 → en yakın standart = 10 mm² (6'yı aştığı için)
        XCTAssertEqual(CableSectionEngine.recommendedSection(minimumSection: 6.087), 10.0)
        // 1.0 → 1.5 mm²
        XCTAssertEqual(CableSectionEngine.recommendedSection(minimumSection: 1.0), 1.5)
        // 300 → 300 mm²
        XCTAssertEqual(CableSectionEngine.recommendedSection(minimumSection: 300.0), 300.0)
        // 301 → nil (standart dışı)
        XCTAssertNil(CableSectionEngine.recommendedSection(minimumSection: 301.0))
    }
}
