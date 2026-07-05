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
#if DEBUG
            if let screenshotScene = ScreenshotScene.current {
                ScreenshotRootView(scene: screenshotScene)
                    .environment(subscriptionManager)
            } else {
                mainContent
            }
#else
            mainContent
#endif
        }
        .modelContainer(for: CalculationRecord.self)
    }

    private var mainContent: some View {
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
}

#if DEBUG
private enum ScreenshotScene: String {
    case home
    case cableSection
    case transformer
    case history
    case paywall

    static var current: ScreenshotScene? {
        let arguments = ProcessInfo.processInfo.arguments
        if let index = arguments.firstIndex(of: "--screenshot-scene"),
           arguments.indices.contains(index + 1) {
            return ScreenshotScene(rawValue: arguments[index + 1])
        }
        if let value = ProcessInfo.processInfo.environment["ELECCALC_SCREENSHOT_SCENE"] {
            return ScreenshotScene(rawValue: value)
        }
        return nil
    }
}

private struct ScreenshotRootView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var pendingCategory: CalculationCategory?
    let scene: ScreenshotScene

    var body: some View {
        Group {
            switch scene {
            case .home:
                ContentView(pendingCategory: $pendingCategory)
            case .cableSection:
                ContentView(pendingCategory: $pendingCategory, initialPath: [.cableSection])
            case .transformer:
                ContentView(pendingCategory: $pendingCategory, initialPath: [.transformer])
            case .history:
                ContentView(pendingCategory: $pendingCategory, initialTab: 1)
            case .paywall:
                ScreenshotPaywallView()
            }
        }
        .task(id: scene) {
            seedModelContext()
        }
    }

    private func seedModelContext() {
        try? modelContext.delete(model: CalculationRecord.self)
        guard scene == .history else { return }

        let rows: [(CalculationCategory, String, String)] = [
            (.cableSection, "I=125A, L=42m, Cu", "35 mm²"),
            (.transformer, "S=630 kVA, P=420 kW", "\(String(localized: "result.loadingRate")) = 78.43%"),
            (.voltageDrop, "I=80A, L=65m", "2.37%"),
        ]

        for (index, row) in rows.enumerated() {
            let record = CalculationRecord(
                category: row.0,
                title: row.0.title,
                inputSummary: row.1,
                resultSummary: row.2
            )
            record.timestamp = Calendar.current.date(byAdding: .hour, value: -index, to: .now) ?? .now
            record.isFavorite = index == 0
            modelContext.insert(record)
        }
        try? modelContext.save()
    }
}

private struct ScreenshotPaywallView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    featuresSection
                    planSection
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
        }
    }

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

            Text(String(localized: "paywall.title"))
                .font(.largeTitle.bold())
                .lineLimit(3)
                .minimumScaleFactor(0.82)

            Text(String(localized: "paywall.subtitle"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
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

    private var planSection: some View {
        VStack(spacing: AppTheme.Spacing.regular) {
            planCard(
                title: String(localized: "paywall.yearly"),
                subtitle: String(localized: "paywall.plan.yearlySubtitle"),
                price: "$29.99",
                period: String(localized: "paywall.perYear"),
                isSelected: true,
                badge: String(localized: "paywall.bestValue")
            )
            planCard(
                title: String(localized: "paywall.monthly"),
                subtitle: String(localized: "paywall.plan.monthlySubtitle"),
                price: "$4.99",
                period: String(localized: "paywall.perMonth"),
                isSelected: false,
                badge: nil
            )
        }
    }

    private func planCard(
        title: String,
        subtitle: String,
        price: String,
        period: String,
        isSelected: Bool,
        badge: String?
    ) -> some View {
        HStack(spacing: AppTheme.Spacing.regular) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                HStack(spacing: AppTheme.Spacing.medium) {
                    Text(title)
                        .font(.headline)
                    if let badge {
                        Text(badge)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, AppTheme.Spacing.medium)
                            .padding(.vertical, AppTheme.Spacing.small)
                            .background(.green.gradient, in: Capsule())
                    }
                }
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: AppTheme.Spacing.regular)

            VStack(alignment: .trailing, spacing: AppTheme.Spacing.small) {
                Text(price)
                    .font(.title3.bold())
                    .monospacedDigit()
                Text(period)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
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

    private var purchaseButton: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            Text(String(localized: "paywall.startTrial"))
                .font(.headline)
            Text(String(format: String(localized: "paywall.trialAfterIntro.yearly %@"), "$29.99"))
                .font(.caption)
                .foregroundStyle(.white.opacity(0.92))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.accent.gradient)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
        .shadow(color: Color.accentColor.opacity(0.26), radius: 14, y: 8)
    }

    private var restoreButton: some View {
        Text(String(localized: "paywall.restore"))
            .font(.footnote)
            .foregroundStyle(.accent)
    }

    private var legalLinks: some View {
        HStack(spacing: AppTheme.Spacing.large) {
            Text(String(localized: "paywall.termsOfUse"))
            Text("·").foregroundStyle(.secondary)
            Text(String(localized: "paywall.privacyPolicy"))
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.bottom, AppTheme.Spacing.regular)
    }

    private var subscriptionDisclosure: some View {
        Text(String(localized: "paywall.disclosure"))
            .font(.caption2)
            .foregroundStyle(.secondary.opacity(0.75))
            .multilineTextAlignment(.center)
            .lineSpacing(1)
            .padding(.horizontal)
    }
}
#endif

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
