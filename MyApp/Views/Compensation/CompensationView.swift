import SwiftUI
import SwiftData

struct CompensationView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = CompensationViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                VStack(spacing: AppTheme.Spacing.large) {
                    InputFieldView(
                        label: String(localized: "field.activePower"),
                        text: $viewModel.activePowerText,
                        unit: "kW"
                    )
                    InputFieldView(
                        label: String(localized: "field.currentCosPhi"),
                        text: $viewModel.currentCosPhiText,
                        unit: "",
                        placeholder: "0,85"
                    )
                    InputFieldView(
                        label: String(localized: "field.targetCosPhi"),
                        text: $viewModel.targetCosPhiText,
                        unit: "",
                        placeholder: "0,95"
                    )
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    viewModel.calculate()
                    if viewModel.requiredKVAR != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.hasCalculated, let qc = viewModel.requiredKVAR {
                    ResultCardView(
                        title: String(localized: "result.requiredKVAR"),
                        value: qc.formatted2,
                        unit: "kVAR",
                        formula: viewModel.formulaUsed
                    )

                    if let cap = viewModel.recommendedCapacitor {
                        ResultCardView(
                            title: String(localized: "result.recommendedCapacitor"),
                            value: cap.formatted2,
                            unit: "kVAR",
                            formula: String(localized: "result.standardValue")
                        )
                    }

                    if let newCos = viewModel.newCosPhi {
                        ResultCardView(
                            title: String(localized: "result.newCosPhi"),
                            value: String(format: "%.4f", newCos),
                            unit: "",
                            formula: "cosφ = P / S"
                        )
                    }
                }
            }
            .padding()
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.compensation"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
