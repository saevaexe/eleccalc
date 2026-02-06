import SwiftUI
import SwiftData

struct HistoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CalculationRecord.timestamp, order: .reverse) private var records: [CalculationRecord]
    @State private var viewModel = HistoryViewModel()
    @State private var showDeleteAlert = false

    var body: some View {
        Group {
            if records.isEmpty {
                ContentUnavailableView(
                    String(localized: "history.empty"),
                    systemImage: "clock.arrow.circlepath",
                    description: Text(String(localized: "history.emptyDescription"))
                )
            } else {
                List {
                    ForEach(records) { record in
                        HistoryRowView(record: record)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteRecord(records[index], modelContext: modelContext)
                        }
                    }
                }
            }
        }
        .navigationTitle(String(localized: "tab.history"))
        .toolbar {
            if !records.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .alert(String(localized: "history.deleteAll"), isPresented: $showDeleteAlert) {
            Button(String(localized: "action.delete"), role: .destructive) {
                viewModel.deleteAll(modelContext: modelContext)
            }
            Button(String(localized: "action.cancel"), role: .cancel) {}
        }
    }
}
