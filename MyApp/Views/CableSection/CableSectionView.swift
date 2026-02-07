import SwiftUI
import SwiftData

struct CableSectionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = CableSectionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                UnitPickerView(
                    title: String(localized: "material.title"),
                    selection: $viewModel.material,
                    labelProvider: { $0.title }
                )

                UnitPickerView(
                    title: String(localized: "phase.title"),
                    selection: $viewModel.phaseConfig,
                    labelProvider: { $0.title }
                )

                VStack(spacing: AppTheme.Spacing.large) {
                    InputFieldView(label: String(localized: "field.current"), text: $viewModel.currentText, unit: "A")
                    InputFieldView(label: String(localized: "field.length"), text: $viewModel.lengthText, unit: "m")
                    InputFieldView(label: String(localized: "field.voltage"), text: $viewModel.voltageText, unit: "V")
                    InputFieldView(label: String(localized: "field.maxDrop"), text: $viewModel.maxDropPercentText, unit: "%")
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.calculate()
                    }
                    if viewModel.recommendedSection != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if let minimum = viewModel.minimumSection, let recommended = viewModel.recommendedSection {
                    VStack(spacing: AppTheme.Spacing.regular) {
                        ResultCardView(
                            title: String(localized: "result.recommendedSection"),
                            value: recommended.formatted2,
                            unit: "mm²",
                            formula: String(localized: "result.minimumSection") + ": \(minimum.formatted2) mm²"
                        )
                    }
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.cableSection"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
