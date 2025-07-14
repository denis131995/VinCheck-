import Foundation

class HistoryService: ObservableObject {
    private let userDefaults = UserDefaults.standard
    private let historyKey = "vin_check_history"
    private let maxHistoryItems = 20
    
    @Published var history: [VINData] = []
    
    init() {
        loadHistory()
    }
    
    func addToHistory(_ vinData: VINData) {
        history.insert(vinData, at: 0)
        if history.count > maxHistoryItems {
            history = Array(history.prefix(maxHistoryItems))
        }
        saveHistory()
    }
    
    func updateNote(for vin: String, note: String?) {
        if let index = history.firstIndex(where: { $0.vin == vin }) {
            history[index].note = note
            history = Array(history) // Force update for SwiftUI
            saveHistory()
        }
    }
    
    func removeFromHistory(_ vinData: VINData) {
        history.removeAll { $0.id == vinData.id }
        saveHistory()
    }
    
    func clearHistory() {
        history.removeAll()
        saveHistory()
    }
    
    private func loadHistory() {
        if let data = userDefaults.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([VINData].self, from: data) {
            history = decodedHistory
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
} 
