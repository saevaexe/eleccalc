import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var columns: [GridItem] {
        let count = sizeClass == .regular ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.large), count: count)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.large) {
                SearchBarView(
                    text: $viewModel.searchText,
                    placeholder: String(localized: "search.placeholder")
                )
                .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: AppTheme.Spacing.large) {
                    ForEach(Array(viewModel.filteredCategories.enumerated()), id: \.element.id) { index, category in
                        NavigationLink(value: category) {
                            CategoryCardView(
                                category: category,
                                animationDelay: Double(index) * 0.05
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(String(localized: "app.title"))
    }
}
