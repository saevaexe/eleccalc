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

    // MARK: - IEC 60364-5-52:2009 taşıma kapasiteleri (3 yüklü iletken, A)
    // Kaynak: Tablo B.52.4/B.52.5 (B1 ve D1 sütunları) + B.52.10~13 (Metod E, çok damarlı)
    // Eşleme: air → Metod E (serbest havada çok damarlı kablo)
    //         conduit → Metod B1 (duvar içi boruda yalıtılmış iletkenler)
    //         underground → Metod D1 (toprakta boru/kanal içinde)
    // Key: (InstallMethod, ConductorMaterial, InsulationType) → [kesit: amper]

    private static let ampacityData: [String: [Double: Double]] = {
        var table: [String: [Double: Double]] = [:]

        // Bakır PVC - Havada (Metod E, B.52.10)
        table["air.copper.pvc"] = [
            1.5: 18.5, 2.5: 25, 4: 34, 6: 43, 10: 60, 16: 80, 25: 101,
            35: 126, 50: 153, 70: 196, 95: 238, 120: 276, 150: 319, 185: 364, 240: 430
        ]
        // Bakır XLPE - Havada (Metod E, B.52.12)
        table["air.copper.xlpe"] = [
            1.5: 23, 2.5: 32, 4: 42, 6: 54, 10: 75, 16: 100, 25: 127,
            35: 158, 50: 192, 70: 246, 95: 298, 120: 346, 150: 399, 185: 456, 240: 538
        ]
        // Bakır PVC - Kanal (Metod B1, B.52.4)
        table["conduit.copper.pvc"] = [
            1.5: 15.5, 2.5: 21, 4: 28, 6: 36, 10: 50, 16: 68, 25: 89,
            35: 110, 50: 134, 70: 171, 95: 207, 120: 239, 150: 262, 185: 296, 240: 346
        ]
        // Bakır XLPE - Kanal (Metod B1, B.52.5)
        table["conduit.copper.xlpe"] = [
            1.5: 20, 2.5: 28, 4: 37, 6: 48, 10: 66, 16: 88, 25: 117,
            35: 144, 50: 175, 70: 222, 95: 269, 120: 312, 150: 342, 185: 384, 240: 450
        ]
        // Bakır PVC - Toprak (Metod D1, B.52.4)
        table["underground.copper.pvc"] = [
            1.5: 18, 2.5: 24, 4: 30, 6: 38, 10: 50, 16: 64, 25: 82,
            35: 98, 50: 116, 70: 143, 95: 169, 120: 192, 150: 217, 185: 243, 240: 280
        ]
        // Bakır XLPE - Toprak (Metod D1, B.52.5)
        table["underground.copper.xlpe"] = [
            1.5: 21, 2.5: 28, 4: 36, 6: 44, 10: 58, 16: 75, 25: 96,
            35: 115, 50: 135, 70: 167, 95: 197, 120: 223, 150: 251, 185: 281, 240: 324
        ]

        // Alüminyum PVC - Havada (Metod E, B.52.11)
        table["air.aluminum.pvc"] = [
            2.5: 19.5, 4: 26, 6: 33, 10: 46, 16: 61, 25: 78,
            35: 96, 50: 117, 70: 150, 95: 183, 120: 212, 150: 245, 185: 280, 240: 330
        ]
        // Alüminyum XLPE - Havada (Metod E, B.52.13)
        table["air.aluminum.xlpe"] = [
            2.5: 24, 4: 32, 6: 42, 10: 58, 16: 77, 25: 97,
            35: 120, 50: 146, 70: 187, 95: 227, 120: 263, 150: 304, 185: 347, 240: 409
        ]
        // Alüminyum PVC - Kanal (Metod B1, B.52.4)
        table["conduit.aluminum.pvc"] = [
            2.5: 16.5, 4: 22, 6: 28, 10: 39, 16: 53, 25: 70,
            35: 86, 50: 104, 70: 133, 95: 161, 120: 186, 150: 204, 185: 230, 240: 269
        ]
        // Alüminyum XLPE - Kanal (Metod B1, B.52.5)
        table["conduit.aluminum.xlpe"] = [
            2.5: 22, 4: 29, 6: 38, 10: 52, 16: 71, 25: 93,
            35: 116, 50: 140, 70: 179, 95: 217, 120: 251, 150: 267, 185: 300, 240: 351
        ]
        // Alüminyum PVC - Toprak (Metod D1, B.52.4)
        table["underground.aluminum.pvc"] = [
            2.5: 18.5, 4: 24, 6: 30, 10: 39, 16: 50, 25: 64,
            35: 77, 50: 91, 70: 112, 95: 132, 120: 150, 150: 169, 185: 190, 240: 218
        ]
        // Alüminyum XLPE - Toprak (Metod D1, B.52.5)
        table["underground.aluminum.xlpe"] = [
            2.5: 22, 4: 28, 6: 35, 10: 46, 16: 59, 25: 75,
            35: 90, 50: 106, 70: 130, 95: 154, 120: 174, 150: 197, 185: 220, 240: 253
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
