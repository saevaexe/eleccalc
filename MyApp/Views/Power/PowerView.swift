import SwiftUI
import SwiftData

struct PowerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = PowerViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                // Mod seçici
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text(String(localized: "solveFor"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Picker(String(localized: "solveFor"), selection: $viewModel.solveFor) {
                        ForEach(PowerSolveFor.allCases, id: \.self) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.menu)
                }

                if viewModel.solveFor != .fromKVA {
                    Toggle(String(localized: "phase.threePhase"), isOn: $viewModel.isThreePhase)
                        .padding(.horizontal)
                }

                VStack(spacing: AppTheme.Spacing.large) {
                    if viewModel.solveFor == .fromKVA {
                        InputFieldView(label: String(localized: "power.apparent"), text: $viewModel.apparentPowerText, unit: "kVA")
                        InputFieldView(label: String(localized: "field.voltage"), text: $viewModel.voltageText, unit: "V", placeholder: "400")
                        InputFieldView(label: "cosφ", text: $viewModel.powerFactorText, unit: "", placeholder: "0,85")
                    } else {
                        InputFieldView(label: String(localized: "field.voltage"), text: $viewModel.voltageText, unit: "V")
                        InputFieldView(label: String(localized: "field.current"), text: $viewModel.currentText, unit: "A")

                        if viewModel.solveFor == .activePower || viewModel.solveFor == .reactivePower {
                            InputFieldView(label: "cosφ", text: $viewModel.powerFactorText, unit: "", placeholder: "0,85")
                        }

                        if viewModel.solveFor == .powerFactor {
                            InputFieldView(label: String(localized: "power.active"), text: $viewModel.activePowerText, unit: "W")
                        }
                    }
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.calculate()
                    }
                    if viewModel.solveFor == .fromKVA {
                        if viewModel.kvaActivePower != nil {
                            viewModel.saveToHistory(modelContext: modelContext)
                        }
                    } else if viewModel.result != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.solveFor == .fromKVA && viewModel.hasCalculated {
                    if let p = viewModel.kvaActivePower {
                        ResultCardView(
                            title: String(localized: "power.active"),
                            value: p.formatted2,
                            unit: "kW",
                            formula: "P = S × cosφ"
                        )
                    }
                    if let q = viewModel.kvaReactivePower {
                        ResultCardView(
                            title: String(localized: "power.reactive"),
                            value: q.formatted2,
                            unit: "kVAR",
                            formula: "Q = S × sinφ"
                        )
                    }
                    if let i = viewModel.kvaCurrent {
                        ResultCardView(
                            title: String(localized: "field.current"),
                            value: i.formatted2,
                            unit: "A",
                            formula: "I = S / (√3 × V)"
                        )
                    }
                } else if let result = viewModel.result {
                    ResultCardView(
                        title: viewModel.solveFor.title,
                        value: result.formatted2,
                        unit: viewModel.solveFor.unit,
                        formula: viewModel.formulaUsed
                    )
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.power"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
