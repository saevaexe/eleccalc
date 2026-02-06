import SwiftUI

enum AppTheme {
    enum Spacing {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let regular: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }

    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }

    enum CategoryColor {
        static let ohmLaw = Color.blue
        static let power = Color.orange
        static let cableSection = Color.green
        static let voltageDrop = Color.purple
        static let compensation = Color.red
        static let transformer = Color.brown
        static let grounding = Color.teal
        static let unitConverter = Color.indigo
        static let formulaReference = Color.mint
    }
}
