import SwiftUI

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel
    var onComplete: () -> Void

    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            // Page 1: Welcome
            onboardingPage(
                icon: "bolt.circle.fill",
                title: String(localized: "onboarding.welcome.title"),
                subtitle: String(localized: "onboarding.welcome.subtitle")
            )
            .tag(0)

            // Page 2: Quick Calculation
            onboardingPage(
                icon: "function",
                title: String(localized: "onboarding.calculate.title"),
                subtitle: String(localized: "onboarding.calculate.subtitle")
            )
            .tag(1)

            // Page 3: History & Favorites
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 80))
                    .foregroundStyle(.accent)
                Text(String(localized: "onboarding.history.title"))
                    .font(.largeTitle.bold())
                Text(String(localized: "onboarding.history.subtitle"))
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Spacer()
                Button {
                    viewModel.complete()
                    onComplete()
                } label: {
                    Text(String(localized: "onboarding.getStarted"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    private func onboardingPage(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundStyle(.accent)
            Text(title)
                .font(.largeTitle.bold())
            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity)
    }
}
