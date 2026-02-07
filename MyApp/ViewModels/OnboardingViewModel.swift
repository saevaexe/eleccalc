import Foundation

@Observable
final class OnboardingViewModel {
    var currentPage: Int = 0
    let totalPages: Int = 3

    static let hasCompletedKey = "hasCompletedOnboarding"

    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: Self.hasCompletedKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.hasCompletedKey) }
    }

    var showOnboarding: Bool {
        !hasCompletedOnboarding
    }

    func complete() {
        hasCompletedOnboarding = true
    }
}
