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

    /// Mil (mekanik) gücü: Pmil(kW) = √3 × U × I × cosφ × η / 1000
    /// Not: η çarpanı elektriksel giriş gücünü mile aktarılan güce çevirir;
    /// elektriksel aktif güç istenirse η kullanılmaz.
    static func shaftPower(voltage: Double, current: Double, powerFactor: Double, efficiency: Double) -> Double {
        (sqrt(3.0) * voltage * current * powerFactor * efficiency) / 1000.0
    }

    /// IEC standart motor güçleri (kW)
    static let standardPowers: [Double] = [
        0.37, 0.55, 0.75, 1.1, 1.5, 2.2, 3, 4, 5.5, 7.5,
        11, 15, 18.5, 22, 30, 37, 45, 55, 75, 90, 110, 132, 160, 200, 250, 315
    ]

    // MARK: - IEC 60034-30-1:2014 Verim Tablosu (4 kutup, 50 Hz)
    // Kaynak: ABB Technical note 9AKK107319 (IEC 60034-30-1 Tablo 3/5/7/9, 4 kutup sütunları)

    static let iecEfficiencyTable: [IECEfficiencyEntry] = [
        .init(powerKW: 0.75,  ie1: 0.721, ie2: 0.796, ie3: 0.825, ie4: 0.857),
        .init(powerKW: 1.1,   ie1: 0.750, ie2: 0.814, ie3: 0.841, ie4: 0.872),
        .init(powerKW: 1.5,   ie1: 0.772, ie2: 0.828, ie3: 0.853, ie4: 0.882),
        .init(powerKW: 2.2,   ie1: 0.797, ie2: 0.843, ie3: 0.867, ie4: 0.895),
        .init(powerKW: 3,     ie1: 0.815, ie2: 0.855, ie3: 0.877, ie4: 0.904),
        .init(powerKW: 4,     ie1: 0.831, ie2: 0.866, ie3: 0.886, ie4: 0.911),
        .init(powerKW: 5.5,   ie1: 0.847, ie2: 0.877, ie3: 0.896, ie4: 0.919),
        .init(powerKW: 7.5,   ie1: 0.860, ie2: 0.887, ie3: 0.904, ie4: 0.926),
        .init(powerKW: 11,    ie1: 0.876, ie2: 0.898, ie3: 0.914, ie4: 0.933),
        .init(powerKW: 15,    ie1: 0.887, ie2: 0.906, ie3: 0.921, ie4: 0.939),
        .init(powerKW: 18.5,  ie1: 0.893, ie2: 0.912, ie3: 0.926, ie4: 0.942),
        .init(powerKW: 22,    ie1: 0.899, ie2: 0.916, ie3: 0.930, ie4: 0.945),
        .init(powerKW: 30,    ie1: 0.907, ie2: 0.923, ie3: 0.936, ie4: 0.949),
        .init(powerKW: 37,    ie1: 0.912, ie2: 0.927, ie3: 0.939, ie4: 0.952),
        .init(powerKW: 45,    ie1: 0.917, ie2: 0.931, ie3: 0.942, ie4: 0.954),
        .init(powerKW: 55,    ie1: 0.921, ie2: 0.935, ie3: 0.946, ie4: 0.957),
        .init(powerKW: 75,    ie1: 0.927, ie2: 0.940, ie3: 0.950, ie4: 0.960),
        .init(powerKW: 90,    ie1: 0.930, ie2: 0.942, ie3: 0.952, ie4: 0.961),
        .init(powerKW: 110,   ie1: 0.933, ie2: 0.945, ie3: 0.954, ie4: 0.963),
        .init(powerKW: 132,   ie1: 0.935, ie2: 0.947, ie3: 0.956, ie4: 0.964),
        .init(powerKW: 160,   ie1: 0.938, ie2: 0.949, ie3: 0.958, ie4: 0.966),
        .init(powerKW: 200,   ie1: 0.940, ie2: 0.951, ie3: 0.960, ie4: 0.967),
        .init(powerKW: 250,   ie1: 0.940, ie2: 0.951, ie3: 0.960, ie4: 0.967),
        .init(powerKW: 315,   ie1: 0.940, ie2: 0.951, ie3: 0.960, ie4: 0.967),
    ]

    /// Verilen güce en yakın tablodaki satırı bulup ilgili IE sınıfının verimini döndürür (0-1 arası)
    static func iecEfficiency(powerKW: Double, ieClass: IEClass) -> Double {
        guard let nearest = iecEfficiencyTable.min(by: {
            abs($0.powerKW - powerKW) < abs($1.powerKW - powerKW)
        }) else { return 0.9 }
        return nearest.efficiency(for: ieClass)
    }
}
