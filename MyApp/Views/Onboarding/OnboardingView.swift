import SwiftUI
import StoreKit

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel
    var onComplete: () -> Void

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

            VStack(spacing: AppTheme.Spacing.extraLarge) {
                // Skip button
                HStack {
                    Spacer()
                    if !isLastPage {
                        Button(String(localized: "onboarding.button.skip")) {
                            viewModel.complete()
                            onComplete()
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                    }
                }

                TabView(selection: $viewModel.currentPage) {
                    // Page 1: Identity
                    OnboardingPageView(
                        icon: "bolt.circle.fill",
                        title: String(localized: "onboarding.identity.title"),
                        subtitle: String(localized: "onboarding.identity.subtitle"),
                        highlights: [
                            String(localized: "onboarding.identity.highlight1"),
                            String(localized: "onboarding.identity.highlight2"),
                            String(localized: "onboarding.identity.highlight3")
                        ]
                    )
                    .tag(0)

                    // Page 2: Trust / Standards
                    OnboardingPageView(
                        icon: "checkmark.shield.fill",
                        title: String(localized: "onboarding.trust.title"),
                        subtitle: String(localized: "onboarding.trust.subtitle"),
                        highlights: [
                            String(localized: "onboarding.trust.highlight1"),
                            String(localized: "onboarding.trust.highlight2"),
                            String(localized: "onboarding.trust.highlight3")
                        ]
                    )
                    .tag(1)

                    // Page 3: Value
                    OnboardingPageView(
                        icon: "chart.bar.doc.horizontal.fill",
                        title: String(localized: "onboarding.value.title"),
                        subtitle: String(localized: "onboarding.value.subtitle"),
                        highlights: [
                            String(localized: "onboarding.value.highlight1"),
                            String(localized: "onboarding.value.highlight2"),
                            String(localized: "onboarding.value.highlight3")
                        ]
                    )
                    .tag(2)

                    // Page 4: Get Started
                    OnboardingPageView(
                        icon: "play.circle.fill",
                        title: String(localized: "onboarding.start.title"),
                        subtitle: String(localized: "onboarding.start.subtitle"),
                        highlights: [
                            String(localized: "onboarding.start.highlight1"),
                            String(localized: "onboarding.start.highlight2"),
                            String(localized: "onboarding.start.highlight3")
                        ]
                    )
                    .tag(3)

                    // Page 5: Trial CTA
                    OnboardingPageView(
                        icon: "crown.fill",
                        title: String(localized: "onboarding.trial.title"),
                        subtitle: String(localized: "onboarding.trial.subtitle"),
                        highlights: [
                            String(localized: "onboarding.trial.highlight1"),
                            String(localized: "onboarding.trial.highlight2"),
                            String(localized: "onboarding.trial.highlight3")
                        ]
                    )
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)

                // Bottom buttons
                VStack(spacing: AppTheme.Spacing.medium) {
                    if viewModel.currentPage == 4 {
                        // Trial CTA page
                        Button {
                            viewModel.startTrial()
                        } label: {
                            Text(String(localized: "onboarding.trial.startButton"))
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppTheme.Spacing.large)
                                .background(.accent.gradient, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)

                        Button {
                            viewModel.complete()
                            onComplete()
                        } label: {
                            Text(String(localized: "onboarding.trial.maybeLater"))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)

                        Text(String(localized: "onboarding.trial.disclosure"))
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)

                    } else if viewModel.currentPage == 3 {
                        // Get Started page
                        Button {
                            viewModel.complete()
                            onComplete()
                        } label: {
                            Text(String(localized: "onboarding.button.getStarted"))
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppTheme.Spacing.large)
                                .background(.accent.gradient, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)

                    } else {
                        // Pages 0-2: Next button
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
            }
            .padding(.horizontal, AppTheme.Spacing.extraLarge)
            .padding(.vertical, AppTheme.Spacing.extraLarge)
        }
        .sheet(isPresented: $viewModel.showPaywall) {
            PaywallView()
        }
    }
}

// MARK: - Page View

private struct OnboardingPageView: View {
    let icon: String
    let title: String
    let subtitle: String
    let highlights: [String]

    var body: some View {
        VStack(spacing: AppTheme.Spacing.extraLarge) {
            Image(systemName: icon)
                .font(.system(size: 64, weight: .semibold))
                .foregroundStyle(.accent)
                .padding(.top, AppTheme.Spacing.extraLarge)

            VStack(spacing: AppTheme.Spacing.medium) {
                Text(title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.regular) {
                ForEach(highlights, id: \.self) { item in
                    HStack(spacing: AppTheme.Spacing.medium) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text(item)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.Spacing.large)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
        }
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
