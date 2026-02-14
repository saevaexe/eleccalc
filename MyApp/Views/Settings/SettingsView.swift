import SwiftUI

struct SettingsView: View {
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @State private var showPaywall = false

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        List {
            // MARK: - Abonelik
            Section(String(localized: "settings.subscription")) {
                subscriptionStatusRow

                if !subscriptionManager.isSubscribed {
                    Button {
                        showPaywall = true
                    } label: {
                        Label(String(localized: "settings.upgradePro"), systemImage: "star.fill")
                            .foregroundStyle(.orange)
                    }
                }

                Button {
                    Task { await subscriptionManager.restorePurchases() }
                } label: {
                    Label(String(localized: "paywall.restore"), systemImage: "arrow.clockwise")
                }
            }

            // MARK: - Geri Bildirim
            Section(String(localized: "settings.feedback")) {
                Link(destination: URL(string: "mailto:osman.seven97@icloud.com?subject=ElecCalc%20Feedback")!) {
                    Label(String(localized: "settings.sendFeedback"), systemImage: "envelope")
                }

                Link(destination: URL(string: "https://apps.apple.com/app/id6758902534?action=write-review")!) {
                    Label(String(localized: "settings.rateApp"), systemImage: "star.bubble")
                }
            }

            // MARK: - Yasal
            Section(String(localized: "settings.legal")) {
                Link(destination: URL(string: "https://saevaexe.github.io/eleccalc/privacy-policy.html")!) {
                    Label(String(localized: "settings.privacyPolicy"), systemImage: "lock.shield")
                }

                Link(destination: URL(string: "https://saevaexe.github.io/eleccalc/terms.html")!) {
                    Label(String(localized: "settings.termsOfUse"), systemImage: "doc.text")
                }
            }

            // MARK: - Hakkında
            Section(String(localized: "settings.about")) {
                HStack {
                    Text(String(localized: "settings.version"))
                    Spacer()
                    Text(appVersion)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text(String(localized: "settings.calculators"))
                    Spacer()
                    Text("15")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(String(localized: "tab.settings"))
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    // MARK: - Subscription Status Row

    @ViewBuilder
    private var subscriptionStatusRow: some View {
        HStack {
            Text(String(localized: "settings.status"))
            Spacer()
            if subscriptionManager.isSubscribed {
                Text(String(localized: "settings.status.pro"))
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.green.gradient, in: Capsule())
            } else {
                Text(String(localized: "settings.status.free"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
