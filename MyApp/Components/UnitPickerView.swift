import SwiftUI

struct UnitPickerView<T: Hashable & CaseIterable>: View where T.AllCases: RandomAccessCollection {
    let title: String
    @Binding var selection: T
    let labelProvider: (T) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Picker(title, selection: $selection) {
                ForEach(Array(T.allCases), id: \.self) { item in
                    Text(labelProvider(item)).tag(item)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
