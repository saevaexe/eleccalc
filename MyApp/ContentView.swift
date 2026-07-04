import SwiftUI
import CoreSpotlight

struct ContentView: View {
    /// Spotlight veya onboarding'den gelen hesaplayıcı isteği — MyAppApp sahiplenir
    @Binding var pendingCategory: CalculationCategory?
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @State private var selectedTab = 0
    @State private var path: [CalculationCategory] = []
    @State private var showPaywall = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $path) {
                HomeView()
                    .navigationDestination(for: CalculationCategory.self) { category in
                        destinationView(for: category)
                    }
            }
            .tabItem {
                Label(String(localized: "tab.calculator"), systemImage: "function")
            }
            .tag(0)

            NavigationStack {
                HistoryListView()
            }
            .tabItem {
                Label(String(localized: "tab.history"), systemImage: "clock.arrow.circlepath")
            }
            .tag(1)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(String(localized: "tab.settings"), systemImage: "gearshape")
            }
            .tag(2)
        }
        .onChange(of: pendingCategory) { _, newValue in
            guard let category = newValue else { return }
            pendingCategory = nil
            open(category)
        }
        .onContinueUserActivity(CSSearchableItemActionType) { activity in
            guard let id = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
                  let category = CalculationCategory(rawValue: id) else { return }
            open(category)
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private func open(_ category: CalculationCategory) {
        selectedTab = 0
        if category.isPremium && !subscriptionManager.hasFullAccess {
            showPaywall = true
        } else {
            path = [category]
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
        case .grounding:         GroundingView()
        case .shortCircuit:      ShortCircuitView()
        case .motorCalc:         MotorCalcView()
        case .lighting:          LightingView()
        case .energyConsumption: EnergyConsumptionView()
        case .cableAmpacity:    CableAmpacityView()
        case .breakerSelection: BreakerSelectionView()
        case .unitConverter:     UnitConverterView()
        case .formulaReference:  FormulaReferenceView()
        }
    }
}

// Spotlight: her hesaplayıcı cihaz aramasında bulunabilir olsun — kullanıcı
// "kablo kesiti" diye aratınca doğrudan hesaplayıcıya düşer. Bu dosyada
// tutuluyor — pbxproj'a dosya eklememek için.
enum SpotlightIndexer {
    private static let domain = "calculators"

    static func indexAll() {
        let items = CalculationCategory.allCases.map { category in
            let attributes = CSSearchableItemAttributeSet(contentType: .content)
            attributes.title = category.title
            attributes.contentDescription = category.subtitle
            attributes.keywords = [category.title, String(localized: "app.title")]
            return CSSearchableItem(
                uniqueIdentifier: category.rawValue,
                domainIdentifier: domain,
                attributeSet: attributes
            )
        }
        CSSearchableIndex.default().indexSearchableItems(items)
    }
}
