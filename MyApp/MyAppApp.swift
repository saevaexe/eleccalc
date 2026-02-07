import SwiftUI
import SwiftData

@main
struct MyAppApp: App {
    @State private var onboardingVM = OnboardingViewModel()
    @State private var showOnboarding: Bool = !UserDefaults.standard.bool(forKey: OnboardingViewModel.hasCompletedKey)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .fullScreenCover(isPresented: $showOnboarding) {
                    OnboardingView(viewModel: onboardingVM) {
                        showOnboarding = false
                    }
                }
        }
        .modelContainer(for: CalculationRecord.self)
    }
}
