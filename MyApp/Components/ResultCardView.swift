import SwiftUI

struct ResultCardView: View {
    let title: String
    let value: String
    let unit: String
    let formula: String

    var body: some View {
        VStack(spacing: AppTheme.Spacing.regular) {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .contentTransition(.numericText())
            Text(unit)
                .font(.title3)
                .foregroundStyle(.secondary)
            Divider()
            Text(formula)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
        .transition(.scale(scale: 0.9).combined(with: .opacity))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value) \(unit)")
        .accessibilityHint(formula)
    }
}

/// Hesaplayıcı ekranlarının altında gösterilen standart/varsayım notu.
/// Riskli hesaplarda (kablo, kısa devre, kesici, trafo...) hangi kabullerle
/// çalışıldığını görünür kılar — sonuçlar mühendislik kontrolünün yerine geçmez.
struct AssumptionNoteView: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.medium) {
            Image(systemName: "info.circle")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(text)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppTheme.Spacing.small)
        .accessibilityElement(children: .combine)
    }
}
