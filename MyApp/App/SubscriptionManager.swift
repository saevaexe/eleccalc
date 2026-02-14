import Foundation
import StoreKit

@Observable
final class SubscriptionManager {
    static let shared = SubscriptionManager()

    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isLoading: Bool = false

    var isSubscribed: Bool { !purchasedProductIDs.isEmpty }
    var hasFullAccess: Bool { isSubscribed }

    private var transactionListener: Task<Void, Never>?

    private init() { }

    // MARK: - Introductory Offer

    func isEligibleForIntroOffer(_ product: Product) async -> Bool {
        guard let subscription = product.subscription else { return false }
        return await subscription.isEligibleForIntroOffer
    }

    // MARK: - Product Loading

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let productIDs: Set<String> = [
                AppConstants.Subscription.monthlyProductID,
                AppConstants.Subscription.yearlyProductID
            ]
            products = try await Product.products(for: productIDs)
                .sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }

        await checkCurrentEntitlements()
    }

    // MARK: - Purchase

    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            purchasedProductIDs.insert(transaction.productID)
            await transaction.finish()
            return true
        case .userCancelled:
            return false
        case .pending:
            return false
        @unknown default:
            return false
        }
    }

    // MARK: - Restore

    func restorePurchases() async {
        try? await AppStore.sync()
        await checkCurrentEntitlements()
    }

    // MARK: - Transaction Listener

    func listenForTransactions() async {
        for await result in Transaction.updates {
            do {
                let transaction = try checkVerified(result)
                if transaction.revocationDate == nil {
                    purchasedProductIDs.insert(transaction.productID)
                } else {
                    purchasedProductIDs.remove(transaction.productID)
                }
                await transaction.finish()
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }
    }

    // MARK: - Entitlements Check

    func checkCurrentEntitlements() async {
        var activeIDs: Set<String> = []

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.revocationDate == nil {
                    activeIDs.insert(transaction.productID)
                }
            } catch {
                print("Entitlement verification failed: \(error)")
            }
        }

        purchasedProductIDs = activeIDs
    }

    // MARK: - Helpers

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }

    enum StoreError: Error {
        case verificationFailed
    }
}
