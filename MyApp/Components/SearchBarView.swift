import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(AppTheme.Spacing.medium)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small))
    }
}
