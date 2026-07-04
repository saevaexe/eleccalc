import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @Query(sort: \CalculationRecord.timestamp, order: .reverse) private var records: [CalculationRecord]
    @State private var showPaywall = false

    /// En son kullanılan 4 farklı hesaplayıcı — sahada aynı hesaplar tekrar tekrar açılır
    private var recentCategories: [CalculationCategory] {
        var seen = Set<CalculationCategory>()
        var result: [CalculationCategory] = []
        for record in records {
            guard let category = record.calculationCategory, !seen.contains(category) else { continue }
            seen.insert(category)
            result.append(category)
            if result.count == 4 { break }
        }
        return result
    }

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

                subscriptionBanner

                recentsSection

                LazyVGrid(columns: columns, spacing: AppTheme.Spacing.large) {
                    ForEach(Array(viewModel.filteredCategories.enumerated()), id: \.element.id) { index, category in
                        let needsPaywall = category.isPremium && !subscriptionManager.hasFullAccess
                        let showProBadge = category.isPremium && !subscriptionManager.hasFullAccess

                        if needsPaywall {
                            Button {
                                showPaywall = true
                            } label: {
                                CategoryCardView(
                                    category: category,
                                    animationDelay: Double(index) * 0.05,
                                    showProBadge: showProBadge
                                )
                            }
                            .buttonStyle(.plain)
                        } else {
                            NavigationLink(value: category) {
                                CategoryCardView(
                                    category: category,
                                    animationDelay: Double(index) * 0.05,
                                    showProBadge: showProBadge
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(String(localized: "app.title"))
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    // MARK: - Recents

    @ViewBuilder
    private var recentsSection: some View {
        if !recentCategories.isEmpty && viewModel.searchText.isEmpty {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                Text(String(localized: "home.recents"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.medium) {
                        ForEach(recentCategories) { category in
                            recentChip(category)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func recentChip(_ category: CalculationCategory) -> some View {
        let chipLabel = HStack(spacing: AppTheme.Spacing.small) {
            Image(systemName: category.iconName)
                .font(.caption)
            Text(category.title)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
        }
        .padding(.horizontal, AppTheme.Spacing.regular)
        .padding(.vertical, AppTheme.Spacing.medium)
        .background(category.color.opacity(0.12), in: Capsule())
        .foregroundStyle(category.color)

        if category.isPremium && !subscriptionManager.hasFullAccess {
            Button { showPaywall = true } label: { chipLabel }
                .buttonStyle(.plain)
        } else {
            NavigationLink(value: category) { chipLabel }
                .buttonStyle(.plain)
        }
    }

    // MARK: - Subscription Banner

    @ViewBuilder
    private var subscriptionBanner: some View {
        if subscriptionManager.isSubscribed {
            // Abone — banner gösterme
        } else {
            Button {
                showPaywall = true
            } label: {
                HStack {
                    Image(systemName: "star.fill")
                    Text(String(localized: "subscription.expired.banner"))
                        .font(.subheadline.bold())
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.white)
                .padding()
                .background(.orange.gradient, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
    }
}
