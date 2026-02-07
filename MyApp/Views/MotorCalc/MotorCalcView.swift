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

                    // IE Sınıfı Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(localized: "motor.ieClass"))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Picker(String(localized: "motor.ieClass"), selection: $viewModel.selectedIEClass) {
                            Text("-").tag(IEClass?.none)
                            ForEach(IEClass.allCases) { ie in
                                Text(ie.title).tag(IEClass?.some(ie))
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: viewModel.motorPowerText) {
                            viewModel.updateEfficiencyFromIEC()
                        }

                        if viewModel.selectedIEClass != nil {
                            Text(String(localized: "motor.selectIEClass"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // IEC Verim Tablosu
                    DisclosureGroup(
                        String(localized: "motor.efficiencyTable"),
                        isExpanded: $viewModel.showEfficiencyTable
                    ) {
                        iecTableView
                    }
                    .tint(.accent)

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

    // MARK: - IEC Efficiency Table

    private var iecTableView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 0) {
                    Text("kW")
                        .frame(width: 56, alignment: .leading)
                        .fontWeight(.semibold)
                    ForEach(IEClass.allCases) { ie in
                        Text(ie.title)
                            .frame(width: 56, alignment: .trailing)
                            .fontWeight(.semibold)
                    }
                }
                .font(.caption)
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .background(Color(.systemGray5))

                // Rows
                ForEach(MotorCalcEngine.iecEfficiencyTable, id: \.powerKW) { entry in
                    HStack(spacing: 0) {
                        Text(entry.powerKW.formatted(.number.precision(.fractionLength(0...2))))
                            .frame(width: 56, alignment: .leading)
                        ForEach(IEClass.allCases) { ie in
                            let pct = entry.efficiency(for: ie) * 100.0
                            Text(pct.formatted(.number.precision(.fractionLength(1))))
                                .frame(width: 56, alignment: .trailing)
                                .foregroundStyle(viewModel.selectedIEClass == ie ? .accent : .primary)
                                .fontWeight(viewModel.selectedIEClass == ie ? .semibold : .regular)
                        }
                    }
                    .font(.caption)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                }
            }
        }
        .padding(.top, 8)
    }
}
