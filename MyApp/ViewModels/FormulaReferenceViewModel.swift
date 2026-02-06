import Foundation

struct FormulaItem: Identifiable {
    let id = UUID()
    let name: String
    let formula: String
    let description: String
}

struct FormulaGroup: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let formulas: [FormulaItem]
}

@Observable
final class FormulaReferenceViewModel {
    let groups: [FormulaGroup] = [
        FormulaGroup(
            title: String(localized: "formula.group.ohmLaw"),
            icon: "bolt.circle.fill",
            formulas: [
                FormulaItem(
                    name: String(localized: "formula.voltage"),
                    formula: "V = I × R",
                    description: String(localized: "formula.voltage.desc")
                ),
                FormulaItem(
                    name: String(localized: "formula.current"),
                    formula: "I = V / R",
                    description: String(localized: "formula.current.desc")
                ),
                FormulaItem(
                    name: String(localized: "formula.resistance"),
                    formula: "R = V / I",
                    description: String(localized: "formula.resistance.desc")
                ),
            ]
        ),
        FormulaGroup(
            title: String(localized: "formula.group.power"),
            icon: "powerplug.fill",
            formulas: [
                FormulaItem(
                    name: String(localized: "formula.powerDC"),
                    formula: "P = V × I",
                    description: String(localized: "formula.powerDC.desc")
                ),
                FormulaItem(
                    name: String(localized: "formula.power1Phase"),
                    formula: "P = V × I × cosφ",
                    description: String(localized: "formula.power1Phase.desc")
                ),
                FormulaItem(
                    name: String(localized: "formula.power3Phase"),
                    formula: "P = √3 × V × I × cosφ",
                    description: String(localized: "formula.power3Phase.desc")
                ),
            ]
        ),
        FormulaGroup(
            title: String(localized: "formula.group.cableSection"),
            icon: "cable.connector",
            formulas: [
                FormulaItem(
                    name: String(localized: "formula.cableSection"),
                    formula: "S = (ρ × L × I × k) / ΔU",
                    description: String(localized: "formula.cableSection.desc")
                ),
                FormulaItem(
                    name: String(localized: "formula.voltageDrop"),
                    formula: "ΔU = (ρ × L × I × k) / S",
                    description: String(localized: "formula.voltageDrop.desc")
                ),
            ]
        ),
        FormulaGroup(
            title: String(localized: "formula.group.compensation"),
            icon: "gauge.with.dots.needle.33percent",
            formulas: [
                FormulaItem(
                    name: String(localized: "formula.reactivePower"),
                    formula: "Qc = P × (tanφ₁ - tanφ₂)",
                    description: String(localized: "formula.reactivePower.desc")
                ),
                FormulaItem(
                    name: String(localized: "formula.apparentPower"),
                    formula: "S = √(P² + Q²)",
                    description: String(localized: "formula.apparentPower.desc")
                ),
            ]
        ),
        FormulaGroup(
            title: String(localized: "formula.group.transformer"),
            icon: "square.stack.3d.up.fill",
            formulas: [
                FormulaItem(
                    name: String(localized: "formula.loadingRate"),
                    formula: "Yüklenme = (S_yük / S_trafo) × 100",
                    description: String(localized: "formula.loadingRate.desc")
                ),
                FormulaItem(
                    name: String(localized: "formula.efficiency"),
                    formula: "η = P / (P + P_kayıp) × 100",
                    description: String(localized: "formula.efficiency.desc")
                ),
            ]
        ),
        FormulaGroup(
            title: String(localized: "formula.group.grounding"),
            icon: "arrow.down.to.line",
            formulas: [
                FormulaItem(
                    name: String(localized: "formula.rodElectrode"),
                    formula: "R = ρ/(2πL) × ln(4L/d)",
                    description: String(localized: "formula.rodElectrode.desc")
                ),
                FormulaItem(
                    name: String(localized: "formula.plateElectrode"),
                    formula: "R = ρ / (4a)",
                    description: String(localized: "formula.plateElectrode.desc")
                ),
                FormulaItem(
                    name: String(localized: "formula.peConductor"),
                    formula: "S = I×√t / k",
                    description: String(localized: "formula.peConductor.desc")
                ),
            ]
        ),
    ]

    var searchText: String = ""

    var filteredGroups: [FormulaGroup] {
        if searchText.isEmpty { return groups }
        return groups.compactMap { group in
            let filtered = group.formulas.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.formula.localizedCaseInsensitiveContains(searchText)
            }
            if filtered.isEmpty { return nil }
            return FormulaGroup(title: group.title, icon: group.icon, formulas: filtered)
        }
    }
}
