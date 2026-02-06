import SwiftUI
import SwiftData

struct UnitConverterView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = UnitConverterViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.extraLarge) {
                // Kategori seçimi
                Picker(String(localized: "unitConverter.category"), selection: $viewModel.unitCategory) {
                    ForEach(UnitCategory.allCases, id: \.self) { cat in
                        Text(cat.title).tag(cat)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: viewModel.unitCategory) { _, _ in
                    viewModel.onCategoryChange()
                }

                // Kaynak birim ve değer
                VStack(spacing: AppTheme.Spacing.large) {
                    Picker(String(localized: "unitConverter.from"), selection: $viewModel.sourceUnitIndex) {
                        ForEach(0..<viewModel.availableUnits.count, id: \.self) { idx in
                            Text(viewModel.availableUnits[idx].symbol).tag(idx)
                        }
                    }
                    .pickerStyle(.segmented)

                    InputFieldView(
                        label: String(localized: "unitConverter.value"),
                        text: $viewModel.inputText,
                        unit: viewModel.sourceUnit.symbol
                    )
                }

                // Swap butonu
                Button {
                    viewModel.swapUnits()
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .font(.title2)
                }

                // Hedef birim
                Picker(String(localized: "unitConverter.to"), selection: $viewModel.targetUnitIndex) {
                    ForEach(0..<viewModel.availableUnits.count, id: \.self) { idx in
                        Text(viewModel.availableUnits[idx].symbol).tag(idx)
                    }
                }
                .pickerStyle(.segmented)

                CalculateButton(
                    title: String(localized: "action.convert"),
                    isEnabled: viewModel.canCalculate
                ) {
                    viewModel.calculate()
                    if viewModel.result != nil {
                        viewModel.saveToHistory(modelContext: modelContext)
                    }
                }

                if viewModel.hasCalculated, let result = viewModel.result {
                    ResultCardView(
                        title: String(localized: "result.convertedValue"),
                        value: result.formatted2,
                        unit: viewModel.targetUnit.symbol,
                        formula: "\(viewModel.inputText) \(viewModel.sourceUnit.symbol) → \(result.formatted2) \(viewModel.targetUnit.symbol)"
                    )
                }
            }
            .padding()
        }
        .hideKeyboardOnTap()
        .navigationTitle(String(localized: "category.unitConverter"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "action.clear"), action: viewModel.clear)
            }
        }
    }
}
