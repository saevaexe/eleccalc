import SwiftUI
import SwiftData

struct OhmLawView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = OhmLawViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                UnitPickerView(
                    title: String(localized: "solveFor"),
                    selection: $viewModel.solveFor,
                    labelProvider: { $0.title }
                )

                VStack(spacing: AppTheme.Spacing.large) {
                    if viewModel.solveFor != .voltage {
                        InputFieldView(label: String(localized: "field.voltage"), text: $viewModel.voltageText, unit: "V")
                    }
                    if viewModel.solveFor != .current {
                        InputFieldView(label: String(localized: "field.current"), text: $viewModel.currentText, unit: "A")
                    }
                    if viewModel.solveFor != .resistance {
                        InputFieldView(label: String(localized: "field.resistance"), text: $viewModel.resistanceText, unit: "Ω")
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

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
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
        .navigationTitle(String(localized: "category.ohmLaw"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
