import SwiftUI

struct CategoryCardView: View {
    let category: CalculationCategory

    var body: some View {
        VStack(spacing: AppTheme.Spacing.regular) {
            Image(systemName: category.iconName)
                .font(.system(size: 32))
                .foregroundStyle(category.color)
            Text(category.title)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text(category.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .padding()
        .background(category.color.opacity(0.1), in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
    }
}
