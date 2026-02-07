import SwiftUI

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel
    var onComplete: () -> Void

    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            // Page 1: Welcome
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.accent)
                Text(String(localized: "onboarding.welcome.title"))
                    .font(.largeTitle.bold())
                Text(String(localized: "onboarding.welcome.subtitle"))
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Spacer()
                Spacer()
            }
            .tag(0)

            // Page 2: Quick Calculation
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "function")
                    .font(.system(size: 80))
                    .foregroundStyle(.accent)
                Text(String(localized: "onboarding.calculate.title"))
                    .font(.largeTitle.bold())
                Text(String(localized: "onboarding.calculate.subtitle"))
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                Spacer()
                Spacer()
            }
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
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
