import Foundation
import SwiftData

@Observable
final class HistoryViewModel {
    func deleteRecord(_ record: CalculationRecord, modelContext: ModelContext) {
        modelContext.delete(record)
    }

    func deleteAll(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: CalculationRecord.self)
        } catch {
            // silently handle
        }
    }
}
