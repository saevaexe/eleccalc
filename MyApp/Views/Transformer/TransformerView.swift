import SwiftUI
import SwiftData

struct TransformerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = TransformerViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                VStack(spacing: AppTheme.Spacing.large) {
                    InputFieldView(
                        label: String(localized: "field.transformerPower"),
                        text: $viewModel.transformerPowerText,
                        unit: "kVA"
                    )
                    InputFieldView(
                        label: String(localized: "field.loadPower"),
                        text: $viewModel.loadPowerText,
                        unit: "kW"
                    )
                    InputFieldView(
                        label: String(localized: "field.cosPhi"),
                        text: $viewModel.cosPhiText,
                        unit: "",
                        placeholder: "0,85"
                    )
                    InputFieldView(
                        label: String(localized: "field.secondaryVoltage"),
                        text: $viewModel.secondaryVoltageText,
                        unit: "kV",
                        placeholder: "0,4"
                    )
                    InputFieldView(
                        label: String(localized: "field.ironLoss"),
                        text: $viewModel.ironLossText,
                        unit: "kW",
                        placeholder: String(localized: "field.optional")
                    )
                    InputFieldView(
                        label: String(localized: "field.copperLoss"),
                        text: $viewModel.copperLossText,
                        unit: "kW",
                        placeholder: String(localized: "field.optional")
                    )
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    viewModel.calculate()
                    if viewModel.loadingRate != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.hasCalculated {
                    if let rate = viewModel.loadingRate {
                        ResultCardView(
                            title: String(localized: "result.loadingRate"),
                            value: rate.formatted2,
                            unit: "%",
                            formula: "Yüklenme = (S_yük / S_trafo) × 100"
                        )
                    }

                    if let current = viewModel.nominalCurrent {
                        ResultCardView(
                            title: String(localized: "result.nominalCurrent"),
                            value: current.formatted2,
                            unit: "A",
                            formula: "I = S / (√3 × U)"
                        )
                    }

                    if let eff = viewModel.efficiency {
                        ResultCardView(
                            title: String(localized: "result.efficiency"),
                            value: eff.formatted2,
                            unit: "%",
                            formula: "η = P / (P + P_kayıp) × 100"
                        )
                    }

                    if let tLoss = viewModel.totalLoss {
                        ResultCardView(
                            title: String(localized: "result.totalLoss"),
                            value: tLoss.formatted2,
                            unit: "kW",
                            formula: "P_kayıp = P_fe + P_cu × (Yüklenme/100)²"
                        )
                    }
                }
            }
            .padding()
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.transformer"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
