import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .navigationDestination(for: CalculationCategory.self) { category in
                        destinationView(for: category)
                    }
            }
            .tabItem {
                Label(String(localized: "tab.calculator"), systemImage: "function")
            }

            NavigationStack {
                HistoryListView()
            }
            .tabItem {
                Label(String(localized: "tab.history"), systemImage: "clock.arrow.circlepath")
            }
        }
    }

    @ViewBuilder
    private func destinationView(for category: CalculationCategory) -> some View {
        switch category {
        case .ohmLaw:           OhmLawView()
        case .power:            PowerView()
        case .cableSection:     CableSectionView()
        case .voltageDrop:      VoltageDropView()
        case .compensation:     CompensationView()
        case .transformer:      TransformerView()
        case .grounding:        GroundingView()
        case .unitConverter:    UnitConverterView()
        case .formulaReference: FormulaReferenceView()
        }
    }
}
