import SwiftUI
import SwiftData

struct ShortCircuitView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ShortCircuitViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                Toggle(String(localized: "phase.threePhase"), isOn: $viewModel.isThreePhase)
                    .padding(.horizontal)

                VStack(spacing: AppTheme.Spacing.large) {
                    InputFieldView(
                        label: String(localized: "field.systemVoltage"),
                        text: $viewModel.systemVoltageText,
                        unit: "V"
                    )
                    InputFieldView(
                        label: String(localized: "field.transformerPower"),
                        text: $viewModel.transformerPowerText,
                        unit: "kVA"
                    )
                    InputFieldView(
                        label: String(localized: "field.ukPercent"),
                        text: $viewModel.ukPercentText,
                        unit: "%"
                    )
                }

                VStack(spacing: AppTheme.Spacing.large) {
                    Text(String(localized: "shortCircuit.cableSection"))
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    InputFieldView(
                        label: String(localized: "field.cableResistance"),
                        text: $viewModel.cableResistancePerKmText,
                        unit: "Ω/km",
                        placeholder: String(localized: "field.optional")
                    )
                    InputFieldView(
                        label: String(localized: "field.cableReactance"),
                        text: $viewModel.cableReactancePerKmText,
                        unit: "Ω/km"
                    )
                    InputFieldView(
                        label: String(localized: "field.cableLength"),
                        text: $viewModel.cableLengthText,
                        unit: "m",
                        placeholder: String(localized: "field.optional")
                    )
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.calculate()
                    }
                    if viewModel.shortCircuitCurrent != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.hasCalculated {
                    if let isc = viewModel.shortCircuitCurrent {
                        ResultCardView(
                            title: String(localized: "result.shortCircuitCurrent"),
                            value: (isc / 1000.0).formatted2,
                            unit: "kA",
                            formula: viewModel.formulaUsed
                        )
                    }

                    if let peak = viewModel.peakCurrent {
                        ResultCardView(
                            title: String(localized: "result.peakCurrent"),
                            value: (peak / 1000.0).formatted2,
                            unit: "kA",
                            formula: "ip = κ × √2 × Isc"
                        )
                    }

                    if let z = viewModel.totalImpedance {
                        ResultCardView(
                            title: String(localized: "result.totalImpedance"),
                            value: (z * 1000.0).formatted2,
                            unit: "mΩ",
                            formula: "Zk = Zt + Zc"
                        )
                    }
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.shortCircuit"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
