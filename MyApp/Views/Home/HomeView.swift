import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.Spacing.large),
        GridItem(.flexible(), spacing: AppTheme.Spacing.large)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.large) {
                SearchBarView(
                    text: $viewModel.searchText,
                    placeholder: String(localized: "search.placeholder")
                )
                .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: AppTheme.Spacing.large) {
                    ForEach(viewModel.filteredCategories) { category in
                        NavigationLink(value: category) {
                            CategoryCardView(category: category)
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
