import Foundation

enum IEClass: String, CaseIterable, Identifiable {
    case ie1, ie2, ie3, ie4

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ie1: "IE1"
        case .ie2: "IE2"
        case .ie3: "IE3"
        case .ie4: "IE4"
        }
    }
}

struct IECEfficiencyEntry {
    let powerKW: Double
    let ie1: Double
    let ie2: Double
    let ie3: Double
    let ie4: Double

    func efficiency(for ieClass: IEClass) -> Double {
        switch ieClass {
        case .ie1: ie1
        case .ie2: ie2
        case .ie3: ie3
        case .ie4: ie4
        }
    }
}

struct MotorCalcEngine {
    /// Nominal akım: In = P(kW) × 1000 / (√3 × U × cosφ × η)
    static func nominalCurrent(powerKW: Double, voltage: Double, powerFactor: Double, efficiency: Double) -> Double {
        (powerKW * 1000.0) / (sqrt(3.0) * voltage * powerFactor * efficiency)
    }

    /// Kalkış akımı: Istart = kLR × In
    static func startingCurrent(nominalCurrent: Double, startingFactor: Double) -> Double {
        nominalCurrent * startingFactor
    }

    /// Mekanik tork: T = (P × 1000) / (2π × n/60)  [Nm]
    static func torque(powerKW: Double, rpm: Double) -> Double {
        (powerKW * 1000.0) / (2.0 * .pi * rpm / 60.0)
    }

    /// Aktif güç: P(kW) = √3 × U × I × cosφ × η / 1000
    static func activePower(voltage: Double, current: Double, powerFactor: Double, efficiency: Double) -> Double {
        (sqrt(3.0) * voltage * current * powerFactor * efficiency) / 1000.0
    }

    /// IEC standart motor güçleri (kW)
    static let standardPowers: [Double] = [
        0.37, 0.55, 0.75, 1.1, 1.5, 2.2, 3, 4, 5.5, 7.5,
        11, 15, 18.5, 22, 30, 37, 45, 55, 75, 90, 110, 132, 160, 200, 250, 315
    ]

    // MARK: - IEC 60034-30-1 Verim Tablosu (4 kutup, 50 Hz)

    static let iecEfficiencyTable: [IECEfficiencyEntry] = [
        .init(powerKW: 0.75,  ie1: 0.721, ie2: 0.774, ie3: 0.807, ie4: 0.825),
        .init(powerKW: 1.1,   ie1: 0.750, ie2: 0.796, ie3: 0.827, ie4: 0.841),
        .init(powerKW: 1.5,   ie1: 0.772, ie2: 0.813, ie3: 0.842, ie4: 0.853),
        .init(powerKW: 2.2,   ie1: 0.797, ie2: 0.832, ie3: 0.859, ie4: 0.867),
        .init(powerKW: 3,     ie1: 0.815, ie2: 0.846, ie3: 0.871, ie4: 0.877),
        .init(powerKW: 4,     ie1: 0.831, ie2: 0.858, ie3: 0.881, ie4: 0.886),
        .init(powerKW: 5.5,   ie1: 0.847, ie2: 0.870, ie3: 0.892, ie4: 0.896),
        .init(powerKW: 7.5,   ie1: 0.860, ie2: 0.881, ie3: 0.901, ie4: 0.904),
        .init(powerKW: 11,    ie1: 0.876, ie2: 0.894, ie3: 0.912, ie4: 0.914),
        .init(powerKW: 15,    ie1: 0.887, ie2: 0.903, ie3: 0.919, ie4: 0.921),
        .init(powerKW: 18.5,  ie1: 0.893, ie2: 0.909, ie3: 0.924, ie4: 0.926),
        .init(powerKW: 22,    ie1: 0.899, ie2: 0.913, ie3: 0.927, ie4: 0.930),
        .init(powerKW: 30,    ie1: 0.907, ie2: 0.920, ie3: 0.933, ie4: 0.936),
        .init(powerKW: 37,    ie1: 0.912, ie2: 0.925, ie3: 0.937, ie4: 0.939),
        .init(powerKW: 45,    ie1: 0.917, ie2: 0.929, ie3: 0.940, ie4: 0.942),
        .init(powerKW: 55,    ie1: 0.921, ie2: 0.932, ie3: 0.943, ie4: 0.946),
        .init(powerKW: 75,    ie1: 0.927, ie2: 0.938, ie3: 0.947, ie4: 0.950),
        .init(powerKW: 90,    ie1: 0.930, ie2: 0.941, ie3: 0.950, ie4: 0.952),
        .init(powerKW: 110,   ie1: 0.933, ie2: 0.943, ie3: 0.952, ie4: 0.954),
        .init(powerKW: 132,   ie1: 0.935, ie2: 0.946, ie3: 0.954, ie4: 0.956),
        .init(powerKW: 160,   ie1: 0.938, ie2: 0.948, ie3: 0.956, ie4: 0.958),
        .init(powerKW: 200,   ie1: 0.940, ie2: 0.950, ie3: 0.958, ie4: 0.960),
        .init(powerKW: 250,   ie1: 0.940, ie2: 0.950, ie3: 0.958, ie4: 0.960),
        .init(powerKW: 315,   ie1: 0.940, ie2: 0.950, ie3: 0.958, ie4: 0.960),
    ]

    /// Verilen güce en yakın tablodaki satırı bulup ilgili IE sınıfının verimini döndürür (0-1 arası)
    static func iecEfficiency(powerKW: Double, ieClass: IEClass) -> Double {
        guard let nearest = iecEfficiencyTable.min(by: {
            abs($0.powerKW - powerKW) < abs($1.powerKW - powerKW)
        }) else { return 0.9 }
        return nearest.efficiency(for: ieClass)
    }
}
