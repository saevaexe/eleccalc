import SwiftUI
import SwiftData

struct LightingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = LightingViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                VStack(spacing: AppTheme.Spacing.large) {
                    InputFieldView(
                        label: String(localized: "field.area"),
                        text: $viewModel.areaText,
                        unit: "m²"
                    )
                    InputFieldView(
                        label: String(localized: "field.targetLux"),
                        text: $viewModel.targetLuxText,
                        unit: "lux"
                    )
                    InputFieldView(
                        label: String(localized: "field.lumensPerFixture"),
                        text: $viewModel.lumensPerFixtureText,
                        unit: "lm"
                    )
                    InputFieldView(
                        label: String(localized: "field.wattsPerFixture"),
                        text: $viewModel.wattsPerFixtureText,
                        unit: "W",
                        placeholder: String(localized: "field.optional")
                    )
                    InputFieldView(
                        label: String(localized: "field.utilizationFactor"),
                        text: $viewModel.utilizationFactorText,
                        unit: ""
                    )
                    InputFieldView(
                        label: String(localized: "field.maintenanceFactor"),
                        text: $viewModel.maintenanceFactorText,
                        unit: ""
                    )
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.calculate()
                    }
                    if viewModel.requiredFixtures != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.hasCalculated {
                    if let n = viewModel.requiredFixtures {
                        ResultCardView(
                            title: String(localized: "result.fixtureCount"),
                            value: "\(Int(ceil(n)))",
                            unit: String(localized: "result.fixtures"),
                            formula: viewModel.formulaUsed
                        )
                    }

                    if let pd = viewModel.powerDensity {
                        ResultCardView(
                            title: String(localized: "result.powerDensity"),
                            value: pd.formatted2,
                            unit: "W/m²",
                            formula: "W/m² = (n × W) / A"
                        )
                    }
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.lighting"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
