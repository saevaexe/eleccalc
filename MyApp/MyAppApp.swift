import SwiftUI
import SwiftData

@main
struct MyAppApp: App {
    @State private var onboardingVM = OnboardingViewModel()
    @State private var showOnboarding: Bool = false
    @State private var showSplash: Bool = true
    @State private var pendingCategory: CalculationCategory?
    @State private var subscriptionManager = SubscriptionManager.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(pendingCategory: $pendingCategory)
                    .environment(subscriptionManager)
                    .fullScreenCover(isPresented: $showOnboarding) {
                        OnboardingView(viewModel: onboardingVM, onComplete: {
                            showOnboarding = false
                        }, onOpenCategory: { category in
                            showOnboarding = false
                            pendingCategory = category
                        })
                        .environment(subscriptionManager)
                    }
                    .task {
                        await subscriptionManager.loadProducts()
                    }
                    .task {
                        await subscriptionManager.listenForTransactions()
                    }

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .task {
                SpotlightIndexer.indexAll()
                try? await Task.sleep(for: .seconds(0.9))
                withAnimation(.easeOut(duration: 0.3)) {
                    showSplash = false
                }
                // Onboarding, splash fade'i bittikten sonra sunulmalı — cover splash'in üstüne binmesin
                try? await Task.sleep(for: .seconds(0.35))
                showOnboarding = !UserDefaults.standard.bool(forKey: OnboardingViewModel.hasCompletedKey)
            }
        }
        .modelContainer(for: CalculationRecord.self)
    }
}

// Splash: onboarding'deki marka markıyla aynı görsel dil (accent gradient + bolt.fill).
// MyAppApp.swift içinde tutuluyor — pbxproj'a dosya eklememek için.
private struct SplashView: View {
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: AppTheme.Spacing.large) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .fill(.accent.gradient)
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 96, height: 96)

                Text(String(localized: "app.title"))
                    .font(.title.bold())
            }
            .scaleEffect(appeared ? 1 : 0.85)
            .opacity(appeared ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }
}
