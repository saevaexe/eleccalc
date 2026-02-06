import SwiftUI

struct FormulaReferenceView: View {
    @State private var viewModel = FormulaReferenceViewModel()

    var body: some View {
        List {
            ForEach(viewModel.filteredGroups) { group in
                Section {
                    ForEach(group.formulas) { formula in
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                            Text(formula.name)
                                .font(.headline)
                            Text(formula.formula)
                                .font(.system(.body, design: .monospaced))
                                .foregroundStyle(.blue)
                            Text(formula.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, AppTheme.Spacing.small)
                    }
                } header: {
                    Label(group.title, systemImage: group.icon)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: String(localized: "formula.searchPrompt"))
        .navigationTitle(String(localized: "category.formulaReference"))
    }
}
