import SwiftUI
import SwiftData

struct PowerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = PowerViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                UnitPickerView(
                    title: String(localized: "solveFor"),
                    selection: $viewModel.solveFor,
                    labelProvider: { $0.title }
                )

                Toggle(String(localized: "phase.threePhase"), isOn: $viewModel.isThreePhase)
                    .padding(.horizontal)

                VStack(spacing: AppTheme.Spacing.large) {
                    InputFieldView(label: String(localized: "field.voltage"), text: $viewModel.voltageText, unit: "V")
                    InputFieldView(label: String(localized: "field.current"), text: $viewModel.currentText, unit: "A")

                    if viewModel.solveFor == .activePower || viewModel.solveFor == .reactivePower {
                        InputFieldView(label: "cosφ", text: $viewModel.powerFactorText, unit: "", placeholder: "0.85")
                    }

                    if viewModel.solveFor == .powerFactor {
                        InputFieldView(label: String(localized: "power.active"), text: $viewModel.activePowerText, unit: "W")
                    }
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.calculate()
                    }
                    if viewModel.result != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if let result = viewModel.result {
                    ResultCardView(
                        title: viewModel.solveFor.title,
                        value: result.formatted2,
                        unit: viewModel.solveFor.unit.symbol,
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
