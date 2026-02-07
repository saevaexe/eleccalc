import SwiftUI
import SwiftData

struct GroundingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = GroundingViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                UnitPickerView(
                    title: String(localized: "grounding.calcType"),
                    selection: $viewModel.calcType,
                    labelProvider: { $0.title }
                )

                if viewModel.calcType == .electrodeResistance {
                    electrodeInputs
                } else {
                    conductorInputs
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

                if viewModel.hasCalculated, let result = viewModel.result {
                    let unitStr = viewModel.calcType == .electrodeResistance ? "Ω" : "mm²"
                    let titleStr = viewModel.calcType == .electrodeResistance
                        ? String(localized: "result.groundResistance")
                        : String(localized: "result.conductorSection")
                    ResultCardView(
                        title: titleStr,
                        value: result.formatted2,
                        unit: unitStr,
                        formula: viewModel.formulaUsed
                    )
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.grounding"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }

    private var electrodeInputs: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            UnitPickerView(
                title: String(localized: "grounding.electrodeType"),
                selection: $viewModel.electrodeType,
                labelProvider: { $0.title }
            )

            InputFieldView(
                label: String(localized: "field.soilResistivity"),
                text: $viewModel.soilResistivityText,
                unit: "Ω·m"
            )

            if viewModel.electrodeType == .rod {
                InputFieldView(
                    label: String(localized: "field.rodLength"),
                    text: $viewModel.rodLengthText,
                    unit: "m"
                )
                InputFieldView(
                    label: String(localized: "field.rodDiameter"),
                    text: $viewModel.rodDiameterText,
                    unit: "m"
                )
            } else {
                InputFieldView(
                    label: String(localized: "field.plateSideLength"),
                    text: $viewModel.plateSideLengthText,
                    unit: "m"
                )
            }
        }
    }

    private var conductorInputs: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            UnitPickerView(
                title: String(localized: "grounding.conductorMaterial"),
                selection: $viewModel.conductorMaterial,
                labelProvider: { $0.title }
            )

            InputFieldView(
                label: String(localized: "field.faultCurrent"),
                text: $viewModel.faultCurrentText,
                unit: "A"
            )
            InputFieldView(
                label: String(localized: "field.clearingTime"),
                text: $viewModel.clearingTimeText,
                unit: "s"
            )
        }
    }
}
