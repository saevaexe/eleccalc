import Foundation

enum InsulationType: String, CaseIterable, Identifiable {
    case pvc, xlpe
    var id: String { rawValue }
    var title: String {
        switch self {
        case .pvc:  "PVC"
        case .xlpe: "XLPE"
        }
    }
}

enum InstallMethod: String, CaseIterable, Identifiable {
    case air, conduit, underground
    var id: String { rawValue }
    var title: String {
        switch self {
        case .air:         String(localized: "install.air")
        case .conduit:     String(localized: "install.conduit")
        case .underground: String(localized: "install.underground")
        }
    }
}

struct CableAmpacityEngine {
    static let standardSections: [Double] = [
        1.5, 2.5, 4, 6, 10, 16, 25, 35, 50, 70, 95, 120, 150, 185, 240
    ]

    // MARK: - IEC 60364-5-52 Tablo B.52.2 ~ B.52.5 (3 fazlı, A)
    // Key: (InstallMethod, ConductorMaterial, InsulationType) → [kesit: amper]

    private static let ampacityData: [String: [Double: Double]] = {
        var table: [String: [Double: Double]] = [:]

        // Bakır PVC - Havada (B1/B2 yaklaşık)
        table["air.copper.pvc"] = [
            1.5: 17.5, 2.5: 24, 4: 32, 6: 41, 10: 57, 16: 76, 25: 101,
            35: 125, 50: 151, 70: 192, 95: 232, 120: 269, 150: 300, 185: 341, 240: 400
        ]
        // Bakır XLPE - Havada
        table["air.copper.xlpe"] = [
            1.5: 23, 2.5: 31, 4: 42, 6: 54, 10: 75, 16: 100, 25: 133,
            35: 164, 50: 198, 70: 253, 95: 306, 120: 354, 150: 397, 185: 450, 240: 528
        ]
        // Bakır PVC - Kanal (C)
        table["conduit.copper.pvc"] = [
            1.5: 15.5, 2.5: 21, 4: 28, 6: 36, 10: 50, 16: 68, 25: 89,
            35: 110, 50: 134, 70: 171, 95: 207, 120: 239, 150: 267, 185: 304, 240: 356
        ]
        // Bakır XLPE - Kanal (C)
        table["conduit.copper.xlpe"] = [
            1.5: 20, 2.5: 28, 4: 37, 6: 48, 10: 66, 16: 88, 25: 117,
            35: 144, 50: 175, 70: 224, 95: 271, 120: 314, 150: 352, 185: 400, 240: 470
        ]
        // Bakır PVC - Toprak (D)
        table["underground.copper.pvc"] = [
            1.5: 22, 2.5: 29, 4: 37, 6: 46, 10: 63, 16: 81, 25: 104,
            35: 125, 50: 148, 70: 183, 95: 216, 120: 246, 150: 278, 185: 312, 240: 361
        ]
        // Bakır XLPE - Toprak (D)
        table["underground.copper.xlpe"] = [
            1.5: 26, 2.5: 34, 4: 44, 6: 56, 10: 73, 16: 95, 25: 121,
            35: 146, 50: 173, 70: 213, 95: 252, 120: 287, 150: 324, 185: 363, 240: 419
        ]

        // Alüminyum PVC - Havada
        table["air.aluminum.pvc"] = [
            2.5: 18.5, 4: 25, 6: 32, 10: 44, 16: 59, 25: 78,
            35: 96, 50: 117, 70: 149, 95: 180, 120: 208, 150: 233, 185: 266, 240: 312
        ]
        // Alüminyum XLPE - Havada
        table["air.aluminum.xlpe"] = [
            2.5: 24, 4: 32, 6: 42, 10: 58, 16: 77, 25: 103,
            35: 127, 50: 154, 70: 198, 95: 237, 120: 275, 150: 309, 185: 351, 240: 412
        ]
        // Alüminyum PVC - Kanal (C)
        table["conduit.aluminum.pvc"] = [
            2.5: 16.5, 4: 22, 6: 28, 10: 39, 16: 53, 25: 69,
            35: 85, 50: 104, 70: 133, 95: 161, 120: 186, 150: 208, 185: 237, 240: 278
        ]
        // Alüminyum XLPE - Kanal (C)
        table["conduit.aluminum.xlpe"] = [
            2.5: 21.5, 4: 29, 6: 37, 10: 51, 16: 68, 25: 90,
            35: 112, 50: 136, 70: 174, 95: 211, 120: 245, 150: 275, 185: 312, 240: 367
        ]
        // Alüminyum PVC - Toprak (D)
        table["underground.aluminum.pvc"] = [
            2.5: 22, 4: 29, 6: 36, 10: 49, 16: 63, 25: 80,
            35: 97, 50: 115, 70: 142, 95: 168, 120: 192, 150: 217, 185: 243, 240: 282
        ]
        // Alüminyum XLPE - Toprak (D)
        table["underground.aluminum.xlpe"] = [
            2.5: 26, 4: 34, 6: 43, 10: 57, 16: 74, 25: 94,
            35: 114, 50: 135, 70: 166, 95: 197, 120: 224, 150: 254, 185: 284, 240: 328
        ]

        return table
    }()

    // MARK: - Sıcaklık düzeltme faktörleri (Tablo B.52.14-15)
    // Referans: PVC → 30°C, XLPE → 30°C (havada), PVC → 20°C, XLPE → 20°C (toprakta)

    private static let tempFactorsAir: [String: [Int: Double]] = [
        "pvc": [
            10: 1.22, 15: 1.17, 20: 1.12, 25: 1.06, 30: 1.00,
            35: 0.94, 40: 0.87, 45: 0.79, 50: 0.71, 55: 0.61, 60: 0.50
        ],
        "xlpe": [
            10: 1.15, 15: 1.12, 20: 1.08, 25: 1.04, 30: 1.00,
            35: 0.96, 40: 0.91, 45: 0.87, 50: 0.82, 55: 0.76, 60: 0.71
        ]
    ]

    private static let tempFactorsUnderground: [String: [Int: Double]] = [
        "pvc": [
            10: 1.10, 15: 1.05, 20: 1.00, 25: 0.95, 30: 0.89,
            35: 0.84, 40: 0.77, 45: 0.71, 50: 0.63, 55: 0.55, 60: 0.45
        ],
        "xlpe": [
            10: 1.07, 15: 1.04, 20: 1.00, 25: 0.96, 30: 0.93,
            35: 0.89, 40: 0.85, 45: 0.80, 50: 0.76, 55: 0.71, 60: 0.65
        ]
    ]

    // MARK: - Gruplandırma düzeltme faktörleri (Tablo B.52.17)

    private static let groupFactors: [Int: Double] = [
        1: 1.00, 2: 0.80, 3: 0.70, 4: 0.65, 5: 0.60,
        6: 0.57, 7: 0.54, 8: 0.52, 9: 0.50, 10: 0.48,
        12: 0.45, 14: 0.43, 16: 0.41, 18: 0.39, 20: 0.38
    ]

    // MARK: - Hesaplama fonksiyonları

    static func baseAmpacity(crossSection: Double, material: ConductorMaterial, insulation: InsulationType, method: InstallMethod) -> Double? {
        let key = "\(method.rawValue).\(material.rawValue).\(insulation.rawValue)"
        return ampacityData[key]?[crossSection]
    }

    static func temperatureFactor(insulation: InsulationType, ambientTemp: Int, method: InstallMethod) -> Double {
        let table = method == .underground ? tempFactorsUnderground : tempFactorsAir
        guard let factors = table[insulation.rawValue] else { return 1.0 }

        // Tam eşleşme varsa döndür
        if let factor = factors[ambientTemp] { return factor }

        // En yakın sıcaklığa interpole et
        let sorted = factors.keys.sorted()
        guard let lower = sorted.last(where: { $0 <= ambientTemp }),
              let upper = sorted.first(where: { $0 >= ambientTemp }),
              let lv = factors[lower], let uv = factors[upper] else {
            return factors[sorted.last!]!
        }
        if lower == upper { return lv }
        let ratio = Double(ambientTemp - lower) / Double(upper - lower)
        return lv + ratio * (uv - lv)
    }

    static func groupingFactor(circuitCount: Int) -> Double {
        if circuitCount <= 1 { return 1.0 }
        if let factor = groupFactors[circuitCount] { return factor }

        // En yakın devre sayısına göre
        let sorted = groupFactors.keys.sorted()
        guard let lower = sorted.last(where: { $0 <= circuitCount }),
              let upper = sorted.first(where: { $0 >= circuitCount }),
              let lv = groupFactors[lower], let uv = groupFactors[upper] else {
            return groupFactors[sorted.last!]!
        }
        if lower == upper { return lv }
        let ratio = Double(circuitCount - lower) / Double(upper - lower)
        return lv + ratio * (uv - lv)
    }

    static func correctedAmpacity(base: Double, tempFactor: Double, groupFactor: Double) -> Double {
        base * tempFactor * groupFactor
    }
}
