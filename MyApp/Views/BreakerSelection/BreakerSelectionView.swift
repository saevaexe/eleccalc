import SwiftUI
import SwiftData

struct BreakerSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = BreakerSelectionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                // Giriş modu
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text(String(localized: "solveFor"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Picker(String(localized: "solveFor"), selection: $viewModel.inputMode) {
                        ForEach(BreakerInputMode.allCases, id: \.self) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                VStack(spacing: AppTheme.Spacing.large) {
                    if viewModel.inputMode == .fromPower {
                        InputFieldView(
                            label: String(localized: "field.power"),
                            text: $viewModel.powerText,
                            unit: "kW"
                        )
                        InputFieldView(
                            label: String(localized: "field.voltage"),
                            text: $viewModel.voltageText,
                            unit: "V"
                        )
                        InputFieldView(
                            label: "cosφ",
                            text: $viewModel.cosPhiText,
                            unit: ""
                        )
                        Toggle(String(localized: "phase.threePhase"), isOn: $viewModel.isThreePhase)
                            .padding(.horizontal)
                    } else {
                        InputFieldView(
                            label: String(localized: "field.loadCurrent"),
                            text: $viewModel.loadCurrentText,
                            unit: "A"
                        )
                    }

                    InputFieldView(
                        label: String(localized: "field.cableAmpacity"),
                        text: $viewModel.cableAmpacityText,
                        unit: "A",
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
                    if viewModel.loadCurrent != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.hasCalculated {
                    if let ib = viewModel.loadCurrent {
                        ResultCardView(
                            title: String(localized: "result.loadCurrent"),
                            value: ib.formatted2,
                            unit: "A",
                            formula: viewModel.inputMode == .fromPower
                                ? "Ib = P / (√3 × U × cosφ)"
                                : ""
                        )
                    }

                    if let mcb = viewModel.recommendedMCB {
                        ResultCardView(
                            title: String(localized: "result.recommendedMCB"),
                            value: "\(Int(mcb))",
                            unit: "A",
                            formula: "Ib ≤ In"
                        )
                    }

                    if let mccb = viewModel.recommendedMCCB {
                        ResultCardView(
                            title: String(localized: "result.recommendedMCCB"),
                            value: "\(Int(mccb))",
                            unit: "A",
                            formula: "Ib ≤ In"
                        )
                    }

                    if let fuse = viewModel.recommendedFuse {
                        ResultCardView(
                            title: String(localized: "result.recommendedFuse"),
                            value: "\(Int(fuse))",
                            unit: "A",
                            formula: "gG — Ib ≤ In"
                        )
                    }

                    if let ok = viewModel.protectionOk {
                        ResultCardView(
                            title: String(localized: ok ? "result.protectionOk" : "result.protectionFail"),
                            value: ok ? "✓" : "✗",
                            unit: "",
                            formula: "Ib ≤ In ≤ Iz"
                        )
                    }
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.breakerSelection"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
