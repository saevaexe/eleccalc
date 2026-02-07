import SwiftUI
import SwiftData

struct EnergyConsumptionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = EnergyConsumptionViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                VStack(spacing: AppTheme.Spacing.large) {
                    HStack {
                        InputFieldView(
                            label: String(localized: "field.power"),
                            text: $viewModel.powerText,
                            unit: viewModel.powerUnitIsKW ? "kW" : "W"
                        )
                    }

                    Toggle(String(localized: "energy.unitKW"), isOn: $viewModel.powerUnitIsKW)
                        .padding(.horizontal)

                    InputFieldView(
                        label: String(localized: "field.hoursPerDay"),
                        text: $viewModel.hoursPerDayText,
                        unit: String(localized: "unit.hour")
                    )
                    InputFieldView(
                        label: String(localized: "field.unitPrice"),
                        text: $viewModel.unitPriceText,
                        unit: "TL/kWh"
                    )
                }

                CalculateButton(
                    title: String(localized: "action.calculate"),
                    isEnabled: viewModel.canCalculate
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        viewModel.calculate()
                    }
                    if viewModel.dailyKWh != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.hasCalculated {
                    VStack(spacing: AppTheme.Spacing.regular) {
                        if let daily = viewModel.dailyKWh, let dCost = viewModel.dailyCost {
                            consumptionRow(
                                period: String(localized: "result.daily"),
                                kwh: daily, cost: dCost
                            )
                        }
                        if let monthly = viewModel.monthlyKWh, let mCost = viewModel.monthlyCost {
                            consumptionRow(
                                period: String(localized: "result.monthly"),
                                kwh: monthly, cost: mCost
                            )
                        }
                        if let yearly = viewModel.yearlyKWh, let yCost = viewModel.yearlyCost {
                            consumptionRow(
                                period: String(localized: "result.yearly"),
                                kwh: yearly, cost: yCost
                            )
                        }
                    }

                    if let co2 = viewModel.yearlyCO2 {
                        ResultCardView(
                            title: String(localized: "result.co2Emission"),
                            value: co2.formatted2,
                            unit: "kg CO₂/\(String(localized: "result.year"))",
                            formula: "CO₂ = kWh × 0.47"
                        )
                    }
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.energyConsumption"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }

    private func consumptionRow(period: String, kwh: Double, cost: Double) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(period)
                    .font(.headline)
                Text("\(kwh.formatted2) kWh")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(cost.formatted2) TL")
                .font(.title3.bold())
                .foregroundStyle(.primary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
    }
}
