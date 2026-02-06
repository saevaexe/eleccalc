import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.Spacing.large),
        GridItem(.flexible(), spacing: AppTheme.Spacing.large)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: AppTheme.Spacing.large) {
                ForEach(viewModel.categories) { category in
                    NavigationLink(value: category) {
                        CategoryCardView(category: category)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "app.title"))
    }
}
