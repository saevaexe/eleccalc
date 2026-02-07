import SwiftUI
import SwiftData

struct MotorCalcView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = MotorCalcViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                VStack(spacing: AppTheme.Spacing.large) {
                    InputFieldView(
                        label: String(localized: "field.motorPower"),
                        text: $viewModel.motorPowerText,
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
                    InputFieldView(
                        label: String(localized: "field.efficiency"),
                        text: $viewModel.efficiencyText,
                        unit: ""
                    )
                    InputFieldView(
                        label: String(localized: "field.startingFactor"),
                        text: $viewModel.startingFactorText,
                        unit: "×In"
                    )
                    InputFieldView(
                        label: String(localized: "field.rpm"),
                        text: $viewModel.rpmText,
                        unit: "rpm"
                    )
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.calculate()
                    }
                    if viewModel.nominalCurrent != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.hasCalculated {
                    if let inCurrent = viewModel.nominalCurrent {
                        ResultCardView(
                            title: String(localized: "result.nominalCurrent"),
                            value: inCurrent.formatted2,
                            unit: "A",
                            formula: "In = P / (√3 × U × cosφ × η)"
                        )
                    }

                    if let iStart = viewModel.startingCurrent {
                        ResultCardView(
                            title: String(localized: "result.startingCurrent"),
                            value: iStart.formatted2,
                            unit: "A",
                            formula: "Istart = kLR × In"
                        )
                    }

                    if let t = viewModel.torque {
                        ResultCardView(
                            title: String(localized: "result.torque"),
                            value: t.formatted2,
                            unit: "Nm",
                            formula: "T = P / (2π × n/60)"
                        )
                    }
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.motorCalc"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
