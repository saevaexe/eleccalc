import SwiftUI

/// 3 ekranlık activation-odaklı onboarding: değer → araçlar → ilk hesap.
/// Satışı paywall ve premium gate yapar; buradaki tek hedef kullanıcıyı
/// en hızlı şekilde ilk başarılı hesaplamaya ulaştırmaktır.
struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel
    var onComplete: () -> Void
    /// Ücretsiz çip dokunuşu: onboarding'i bitir ve doğrudan o hesaplayıcıyı aç —
    /// ilk hesaba giden en kısa yol
    var onOpenCategory: (CalculationCategory) -> Void = { _ in }

    private var isLastPage: Bool {
        viewModel.currentPage == viewModel.totalPages - 1
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemBackground), Color.accentColor.opacity(0.12)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: AppTheme.Spacing.large) {
                // Skip — görünür ama baskın değil
                HStack {
                    Spacer()
                    Button(String(localized: "onboarding.button.skip")) {
                        viewModel.complete()
                        onComplete()
                    }
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .opacity(isLastPage ? 0 : 1)
                }
                .frame(height: 20)

                TabView(selection: $viewModel.currentPage) {
                    valuePage.tag(0)
                    toolsPage.tag(1)
                    startPage.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)

                bottomControls
            }
            .padding(.horizontal, AppTheme.Spacing.extraLarge)
            .padding(.vertical, AppTheme.Spacing.extraLarge)
        }
        .fullScreenCover(isPresented: $viewModel.showPaywall) {
            PaywallView()
        }
    }

    // MARK: - Page 1: Value

    private var valuePage: some View {
        VStack(spacing: AppTheme.Spacing.extraLarge) {
            pageHeader(
                title: String(localized: "onboarding.value.title"),
                subtitle: String(localized: "onboarding.value.subtitle")
            )

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: AppTheme.Spacing.regular), GridItem(.flexible())],
                spacing: AppTheme.Spacing.regular
            ) {
                miniModuleCard(.cableSection)
                miniModuleCard(.power)
                miniModuleCard(.transformer)
                miniModuleCard(.shortCircuit)
            }
        }
        .frame(maxWidth: 480)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private func miniModuleCard(_ category: CalculationCategory) -> some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Image(systemName: category.iconName)
                .font(.title2)
                .foregroundStyle(category.color)
            Text(category.title)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, minHeight: 88)
        .padding(AppTheme.Spacing.regular)
        .background(
            category.color.opacity(0.12),
            in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
        )
        .accessibilityElement(children: .combine)
    }

    // MARK: - Page 2: Core Tools

    private var toolsPage: some View {
        VStack(spacing: AppTheme.Spacing.extraLarge) {
            pageHeader(
                title: String(localized: "onboarding.tools.title"),
                subtitle: String(localized: "onboarding.tools.subtitle")
            )

            // Gerçek uygulama UI'ı: hesap sonucu kartı örneği
            ResultCardView(
                title: String(localized: "result.recommendedSection"),
                value: "10",
                unit: "mm²",
                formula: "S = (ρ × L × I × k) / ΔU"
            )

            HStack(spacing: AppTheme.Spacing.medium) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.accent)
                Text(String(localized: "onboarding.tools.iecBadge"))
                    .font(.footnote.weight(.semibold))
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            .padding(.vertical, AppTheme.Spacing.medium)
            .background(.thinMaterial, in: Capsule())
        }
        .frame(maxWidth: 480)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    // MARK: - Page 3: Start

    private var startPage: some View {
        VStack(spacing: AppTheme.Spacing.extraLarge) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .fill(.accent.gradient)
                Image(systemName: "bolt.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 72, height: 72)
            .padding(.top, AppTheme.Spacing.large)

            pageHeader(
                title: String(localized: "onboarding.start.title"),
                subtitle: String(localized: "onboarding.start.subtitle")
            )

            HStack(spacing: AppTheme.Spacing.medium) {
                freeChip(.ohmLaw)
                freeChip(.power)
                freeChip(.cableSection)
            }
        }
        .frame(maxWidth: 480)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private func freeChip(_ category: CalculationCategory) -> some View {
        Button {
            viewModel.complete()
            onOpenCategory(category)
        } label: {
            HStack(spacing: AppTheme.Spacing.small) {
                Image(systemName: category.iconName)
                    .font(.caption)
                Text(category.title)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .padding(.horizontal, AppTheme.Spacing.regular)
            .padding(.vertical, AppTheme.Spacing.medium)
            .background(category.color.opacity(0.12), in: Capsule())
            .foregroundStyle(category.color)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Shared

    private func pageHeader(title: String, subtitle: String) -> some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.85)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var bottomControls: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            if isLastPage {
                // Primary: onboarding'i bitir, Home'a git — activation hedefi
                Button {
                    viewModel.complete()
                    onComplete()
                } label: {
                    Text(String(localized: "onboarding.button.startCalculating"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.large)
                        .background(.accent.gradient, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)

                // Secondary: opsiyonel paywall — zorunlu değil
                Button {
                    viewModel.presentPaywall()
                } label: {
                    Text(String(localized: "onboarding.button.viewPro"))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.currentPage += 1
                    }
                } label: {
                    Text(String(localized: "onboarding.button.next"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.large)
                        .background(.accent.gradient, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: 480)
    }
}
