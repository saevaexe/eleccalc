import SwiftUI
import SwiftData

@main
struct MyAppApp: App {
    @State private var onboardingVM = OnboardingViewModel()
    @State private var showOnboarding: Bool = !UserDefaults.standard.bool(forKey: OnboardingViewModel.hasCompletedKey)
    @State private var subscriptionManager = SubscriptionManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(subscriptionManager)
                .fullScreenCover(isPresented: $showOnboarding) {
                    OnboardingView(viewModel: onboardingVM) {
                        showOnboarding = false
                    }
                    .environment(subscriptionManager)
                }
                .task {
                    await subscriptionManager.loadProducts()
                }
                .task {
                    await subscriptionManager.listenForTransactions()
                }
        }
        .modelContainer(for: CalculationRecord.self)
    }
}
