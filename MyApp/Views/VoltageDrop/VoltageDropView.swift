import SwiftUI
import SwiftData

struct VoltageDropView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = VoltageDropViewModel()

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
                    InputFieldView(label: String(localized: "field.crossSection"), text: $viewModel.crossSectionText, unit: "mm²")
                    InputFieldView(label: String(localized: "field.voltage"), text: $viewModel.voltageText, unit: "V")
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.calculate()
                    }
                    if viewModel.voltageDrop != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if let drop = viewModel.voltageDrop, let percent = viewModel.voltageDropPercent {
                    VStack(spacing: AppTheme.Spacing.regular) {
                        ResultCardView(
                            title: String(localized: "result.voltageDrop"),
                            value: drop.formatted2,
                            unit: "V",
                            formula: "ΔV = (k × ρ × L × I) / A"
                        )
                        HStack {
                            Text(String(localized: "result.dropPercent"))
                                .font(.headline)
                            Spacer()
                            Text("%\(percent.formatted2)")
                                .font(.title2.bold())
                                .foregroundStyle(percent > 5 ? .red : percent > 3 ? .orange : .green)
                        }
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
                    }
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.voltageDrop"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
