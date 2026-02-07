import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProduct: Product?
    @State private var isPurchasing = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.extraLarge) {
                    headerSection
                    featuresSection
                    productsSection
                    purchaseButton
                    restoreButton
                }
                .padding()
            }
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
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.regular) {
            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.orange.gradient)

            Text(String(localized: "paywall.title"))
                .font(.title.bold())
                .multilineTextAlignment(.center)

            Text(String(localized: "paywall.subtitle"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, AppTheme.Spacing.large)
    }

    // MARK: - Features

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.regular) {
            featureRow(String(localized: "paywall.feature1"))
            featureRow(String(localized: "paywall.feature2"))
            featureRow(String(localized: "paywall.feature3"))
        }
        .padding()
        .background(
            Color(.secondarySystemBackground),
            in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
        )
    }

    private func featureRow(_ text: String) -> some View {
        HStack(spacing: AppTheme.Spacing.regular) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text(text)
                .font(.subheadline)
        }
    }

    // MARK: - Products

    private var productsSection: some View {
        HStack(spacing: AppTheme.Spacing.regular) {
            ForEach(subscriptionManager.products) { product in
                productCard(product)
            }
        }
    }

    private func productCard(_ product: Product) -> some View {
        let isSelected = selectedProduct?.id == product.id
        let isYearly = product.id == AppConstants.Subscription.yearlyProductID

        return Button {
            selectedProduct = product
        } label: {
            VStack(spacing: AppTheme.Spacing.medium) {
                if isYearly {
                    Text(String(localized: "paywall.savings"))
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.green.gradient, in: Capsule())
                }

                Text(isYearly ? String(localized: "paywall.yearly") : String(localized: "paywall.monthly"))
                    .font(.headline)

                Text(product.displayPrice)
                    .font(.title2.bold())

                Text(isYearly ? String(localized: "paywall.perYear") : String(localized: "paywall.perMonth"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                isSelected ? Color.orange.opacity(0.15) : Color(.secondarySystemBackground),
                in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Purchase Button

    private var purchaseButton: some View {
        Button {
            Task { await performPurchase() }
        } label: {
            Group {
                if isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(subscriptionManager.isTrialActive
                         ? String(localized: "paywall.startTrial")
                         : String(localized: "paywall.subscribe"))
                }
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.orange.gradient)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
        }
        .disabled(selectedProduct == nil || isPurchasing)
        .opacity(selectedProduct == nil ? 0.6 : 1.0)
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
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Actions

    private func performPurchase() async {
        guard let product = selectedProduct else { return }
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
}
