import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProduct: Product?
    @State private var isPurchasing = false
    @State private var errorMessage: String?
    @State private var introEligible = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    featuresSection
                    productsSection
                    purchaseButton
                    restoreButton
                    legalLinks
                    subscriptionDisclosure
                }
                .padding()
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.title3)
                    }
                }
            }
            .alert(String(localized: "paywall.error"), isPresented: .init(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK") { errorMessage = nil }
            } message: {
                if let msg = errorMessage { Text(msg) }
            }
            .task {
                if subscriptionManager.products.isEmpty {
                    await subscriptionManager.loadProducts()
                }
                autoSelectProductIfNeeded()
                await checkIntroEligibility()
            }
            .onChange(of: subscriptionManager.products.map(\.id)) { _, _ in
                autoSelectProductIfNeeded()
            }
            .onChange(of: selectedProduct?.id) { _, _ in
                Task { await checkIntroEligibility() }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            HStack(spacing: AppTheme.Spacing.regular) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .fill(.accent.gradient)
                    Image(systemName: "bolt.fill")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text(String(localized: "paywall.badge"))
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    Text("ElecCalc PRO")
                        .font(.title3.bold())
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                Text(String(localized: "paywall.title"))
                    .font(.largeTitle.bold())
                    .lineLimit(3)
                    .minimumScaleFactor(0.82)

                Text(String(localized: "paywall.subtitle"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: AppTheme.Spacing.medium) {
                metricPill("checkmark.seal.fill", String(localized: "paywall.metric1"))
                metricPill("square.grid.2x2.fill", String(localized: "paywall.metric2"))
                metricPill("clock.arrow.circlepath", String(localized: "paywall.metric3"))
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.accentColor.opacity(0.16), Color.orange.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
        )
    }

    private func metricPill(_ systemImage: String, _ text: String) -> some View {
        VStack(spacing: AppTheme.Spacing.small) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(.accent)

            Text(text)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .padding(.horizontal, AppTheme.Spacing.small)
        .background(.background.opacity(0.72), in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
    }

    // MARK: - Features

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            Text(String(localized: "paywall.includedTitle"))
                .font(.headline)

            VStack(spacing: AppTheme.Spacing.regular) {
                featureRow("ruler.fill", String(localized: "paywall.feature1"), color: .green)
                featureRow("bolt.horizontal.circle.fill", String(localized: "paywall.feature2"), color: .orange)
                featureRow("shield.checkered", String(localized: "paywall.feature3"), color: .blue)
                featureRow("tray.full.fill", String(localized: "paywall.feature4"), color: .purple)
            }
        }
        .padding(20)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
        )
    }

    private func featureRow(_ systemImage: String, _ text: String, color: Color) -> some View {
        HStack(spacing: AppTheme.Spacing.regular) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(color)
                .frame(width: 24)

            Text(text)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }

    // MARK: - Products

    private var productsSection: some View {
        Group {
            if subscriptionManager.isLoading {
                ProgressView()
                    .frame(height: 120)
            } else if subscriptionManager.products.isEmpty {
                VStack(spacing: AppTheme.Spacing.regular) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text(String(localized: "paywall.productsUnavailable"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button(String(localized: "paywall.retry")) {
                        Task { await subscriptionManager.loadProducts() }
                    }
                    .font(.subheadline.weight(.medium))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    Color(.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                )
            } else {
                VStack(spacing: AppTheme.Spacing.regular) {
                    ForEach(orderedProducts) { product in
                        productCard(product)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func productCard(_ product: Product) -> some View {
        let isSelected = selectedProduct?.id == product.id
        let isYearly = product.id == AppConstants.Subscription.yearlyProductID

        return Button {
            selectedProduct = product
        } label: {
            HStack(spacing: AppTheme.Spacing.regular) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    HStack(spacing: AppTheme.Spacing.medium) {
                        Text(isYearly ? String(localized: "paywall.yearly") : String(localized: "paywall.monthly"))
                            .font(.headline)

                        if isYearly {
                            Text(String(localized: "paywall.bestValue"))
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, AppTheme.Spacing.medium)
                                .padding(.vertical, AppTheme.Spacing.small)
                                .background(.green.gradient, in: Capsule())
                        }
                    }

                    Text(isYearly ? String(localized: "paywall.plan.yearlySubtitle") : String(localized: "paywall.plan.monthlySubtitle"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: AppTheme.Spacing.regular)

                VStack(alignment: .trailing, spacing: AppTheme.Spacing.small) {
                    Text(product.displayPrice)
                        .font(.title3.bold())
                        .monospacedDigit()

                    Text(isYearly ? String(localized: "paywall.perYear") : String(localized: "paywall.perMonth"))
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    if isYearly, let savingsPercent {
                        Text(String(
                            format: String(localized: "paywall.savings %lld"),
                            Int64(savingsPercent)
                        ))
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.green)
                    }
                }

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color.accentColor : .secondary.opacity(0.45))
            }
            .frame(maxWidth: .infinity, minHeight: 92)
            .padding(16)
            .background(
                isSelected ? Color.accentColor.opacity(0.12) : Color(.secondarySystemGroupedBackground),
                in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(isSelected ? Color.accentColor : Color(.separator).opacity(0.35), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Purchase Button

    private var purchaseButton: some View {
        Button {
            Task { await performPurchase() }
        } label: {
            VStack(spacing: AppTheme.Spacing.small) {
                Group {
                    if isPurchasing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(introEligible
                             ? String(localized: "paywall.startTrial")
                             : String(localized: "paywall.subscribe"))
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)

                if !isPurchasing, let trialAfterIntroText {
                    Text(trialAfterIntroText)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.92))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.accent.gradient)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
            .shadow(color: Color.accentColor.opacity(0.26), radius: 14, y: 8)
        }
        .disabled(subscriptionManager.products.isEmpty || isPurchasing)
        .opacity(subscriptionManager.products.isEmpty ? 0.6 : 1.0)
    }

    // MARK: - Restore

    private var restoreButton: some View {
        Button {
            Task {
                await subscriptionManager.restorePurchases()
                if subscriptionManager.isSubscribed {
                    dismiss()
                }
            }
        } label: {
            Text(String(localized: "paywall.restore"))
                .font(.footnote)
                .foregroundStyle(.accent)
        }
    }

    // MARK: - Subscription Disclosure

    private var subscriptionDisclosure: some View {
        Text(String(localized: "paywall.disclosure"))
            .font(.caption2)
            .foregroundStyle(.secondary.opacity(0.75))
            .multilineTextAlignment(.center)
            .lineSpacing(1)
            .padding(.horizontal)
    }

    private var savingsPercent: Int? {
        guard
            let monthlyProduct = subscriptionManager.products.first(where: { $0.id == AppConstants.Subscription.monthlyProductID }),
            let yearlyProduct = subscriptionManager.products.first(where: { $0.id == AppConstants.Subscription.yearlyProductID })
        else {
            return nil
        }

        let monthlyPrice = NSDecimalNumber(decimal: monthlyProduct.price).doubleValue
        let yearlyPrice = NSDecimalNumber(decimal: yearlyProduct.price).doubleValue
        guard monthlyPrice > 0 else { return nil }

        let annualMonthlyCost = monthlyPrice * 12
        let savings = ((annualMonthlyCost - yearlyPrice) / annualMonthlyCost) * 100
        let roundedSavings = Int(savings.rounded())
        return roundedSavings > 0 ? roundedSavings : nil
    }

    private var trialAfterIntroText: String? {
        guard
            introEligible,
            let product = selectedProduct ?? subscriptionManager.products.first
        else {
            return nil
        }

        let localizedFormat = product.id == AppConstants.Subscription.yearlyProductID
            ? String(localized: "paywall.trialAfterIntro.yearly %@")
            : String(localized: "paywall.trialAfterIntro.monthly %@")

        return String(format: localizedFormat, product.displayPrice)
    }

    // MARK: - Legal Links

    private var legalLinks: some View {
        HStack(spacing: AppTheme.Spacing.large) {
            Link(String(localized: "paywall.termsOfUse"), destination: URL(string: "https://saevaexe.github.io/eleccalc/terms.html")!)
            Text("·").foregroundStyle(.secondary)
            Link(String(localized: "paywall.privacyPolicy"), destination: URL(string: "https://saevaexe.github.io/eleccalc/privacy-policy.html")!)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.bottom, AppTheme.Spacing.regular)
    }

    // MARK: - Actions

    private var orderedProducts: [Product] {
        subscriptionManager.products.sorted { lhs, rhs in
            productPriority(lhs) < productPriority(rhs)
        }
    }

    private func productPriority(_ product: Product) -> Int {
        switch product.id {
        case AppConstants.Subscription.yearlyProductID:
            return 0
        case AppConstants.Subscription.monthlyProductID:
            return 1
        default:
            return 2
        }
    }

    private func performPurchase() async {
        guard let product = selectedProduct ?? subscriptionManager.products.first else { return }
        isPurchasing = true
        defer { isPurchasing = false }

        do {
            let success = try await subscriptionManager.purchase(product)
            if success {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func autoSelectProductIfNeeded() {
        guard selectedProduct == nil else { return }
        selectedProduct = subscriptionManager.products.first(where: { $0.id == AppConstants.Subscription.yearlyProductID })
            ?? subscriptionManager.products.first
    }

    private func checkIntroEligibility() async {
        guard let product = selectedProduct else {
            introEligible = false
            return
        }
        introEligible = await subscriptionManager.isEligibleForIntroOffer(product)
    }
}
