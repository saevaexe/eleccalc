import XCTest
@testable import MyApp

final class CableSectionEngineTests: XCTestCase {

    func testMinimumCrossSection_singlePhase_copper() {
        // S = (ρ × L × I × k) / ΔU_max
        // ρ=0.0175, L=50, I=20, k=2 (single phase)
        // ΔU_max = 230 × 3/100 = 6.9
        // S = (0.0175 × 50 × 20 × 2) / 6.9 = 5.072
        let expected = (0.0175 * 50.0 * 20.0 * 2.0) / 6.9
        let result = CableSectionEngine.minimumCrossSection(
            current: 20, length: 50, material: .copper,
            voltage: 230, maxDropPercent: 3, phaseConfig: .singlePhase
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testMinimumCrossSection_threePhase_aluminum() {
        // ρ=0.028, L=100, I=50, k=√3
        // ΔU_max = 400 × 5/100 = 20
        // S = (0.028 × 100 × 50 × √3) / 20
        let expected = (0.028 * 100.0 * 50.0 * sqrt(3.0)) / 20.0
        let result = CableSectionEngine.minimumCrossSection(
            current: 50, length: 100, material: .aluminum,
            voltage: 400, maxDropPercent: 5, phaseConfig: .threePhase
        )
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    func testRecommendedSection() {
        // 5.072 → en yakın standart = 6 mm²
        XCTAssertEqual(CableSectionEngine.recommendedSection(minimumSection: 5.072), 6.0)
        // 1.0 → 1.5 mm²
        XCTAssertEqual(CableSectionEngine.recommendedSection(minimumSection: 1.0), 1.5)
        // 300 → 300 mm²
        XCTAssertEqual(CableSectionEngine.recommendedSection(minimumSection: 300.0), 300.0)
        // 301 → nil (standart dışı)
        XCTAssertNil(CableSectionEngine.recommendedSection(minimumSection: 301.0))
    }
}
