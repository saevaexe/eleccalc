import SwiftUI
import SwiftData

struct CableAmpacityView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = CableAmpacityViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                VStack(spacing: AppTheme.Spacing.large) {
                    // Kesit seçimi
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Text(String(localized: "field.crossSection"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Picker(String(localized: "field.crossSection"), selection: $viewModel.selectedSection) {
                            Text("-").tag(Double?.none)
                            ForEach(CableAmpacityEngine.standardSections, id: \.self) { s in
                                Text("\(s.formatted(.number.precision(.fractionLength(0...1)))) mm²").tag(Double?.some(s))
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    // Malzeme
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Text(String(localized: "field.material"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Picker(String(localized: "field.material"), selection: $viewModel.material) {
                            ForEach(ConductorMaterial.allCases) { m in
                                Text(m.title).tag(m)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Yalıtım
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Text(String(localized: "field.insulation"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Picker(String(localized: "field.insulation"), selection: $viewModel.insulation) {
                            ForEach(InsulationType.allCases) { i in
                                Text(i.title).tag(i)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Döşeme yöntemi
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Text(String(localized: "field.installMethod"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Picker(String(localized: "field.installMethod"), selection: $viewModel.installMethod) {
                            ForEach(InstallMethod.allCases) { m in
                                Text(m.title).tag(m)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    InputFieldView(
                        label: String(localized: "field.ambientTemp"),
                        text: $viewModel.ambientTempText,
                        unit: "°C"
                    )

                    InputFieldView(
                        label: String(localized: "field.circuitCount"),
                        text: $viewModel.circuitCountText,
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
                    if viewModel.correctedAmpacity != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.hasCalculated {
                    if let base = viewModel.baseAmpacity {
                        ResultCardView(
                            title: String(localized: "result.baseAmpacity"),
                            value: base.formatted2,
                            unit: "A",
                            formula: "IEC 60364-5-52"
                        )
                    }
                    if let kt = viewModel.tempFactor {
                        ResultCardView(
                            title: String(localized: "result.tempFactor"),
                            value: String(format: "%.3f", kt),
                            unit: "",
                            formula: "Kt"
                        )
                    }
                    if let kg = viewModel.groupFactor {
                        ResultCardView(
                            title: String(localized: "result.groupFactor"),
                            value: String(format: "%.3f", kg),
                            unit: "",
                            formula: "Kg"
                        )
                    }
                    if let corrected = viewModel.correctedAmpacity {
                        ResultCardView(
                            title: String(localized: "result.correctedAmpacity"),
                            value: corrected.formatted2,
                            unit: "A",
                            formula: "Iz = Ib × Kt × Kg"
                        )
                    }
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.cableAmpacity"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
