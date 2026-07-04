import SwiftUI
import StoreKit

struct CalculateButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    @Environment(\.requestReview) private var requestReview

    var body: some View {
        Button {
            action()
            recordCalculationAndMaybeRequestReview()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .disabled(!isEnabled)
        .accessibilityLabel(title)
        .accessibilityHint(isEnabled
            ? String(localized: "accessibility.tapToCalculate")
            : String(localized: "accessibility.fillFieldsFirst"))
    }

    /// Rating stratejisi: yalnız başarılı hesap sonrası, ≥3 hesapta bir kez,
    /// versiyon başına en fazla 1 istek. Paywall akışında bu buton yok —
    /// paywall reddi sonrası asla tetiklenmez.
    private func recordCalculationAndMaybeRequestReview() {
        let defaults = UserDefaults.standard
        let count = defaults.integer(forKey: Self.calcCountKey) + 1
        defaults.set(count, forKey: Self.calcCountKey)

        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        guard count >= 3, defaults.string(forKey: Self.promptedVersionKey) != version else { return }
        defaults.set(version, forKey: Self.promptedVersionKey)

        // Sonucun görünmesi için kısa gecikme — animasyonun üstüne prompt bindirme
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            requestReview()
        }
    }

    static let calcCountKey = "reviewPrompt.calcCount"
    static let promptedVersionKey = "reviewPrompt.promptedVersion"
}
