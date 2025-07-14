import Foundation
import SwiftUI

class VINCheckViewModel: ObservableObject {
    @Published var vinInput = ""
    @Published var decodedResult: VINDecodeResult?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showHistory = false
    @Published var selectedTab = 0
    
    private let decoderService = VINDecoderService()
    private let historyService = HistoryService()
    
    var history: [VINData] {
        historyService.history
    }
    
    func decodeVIN() {
        guard !vinInput.isEmpty else {
            errorMessage = "Enter VIN number"
            return
        }
        
        guard decoderService.validateVIN(vinInput) else {
            errorMessage = "Invalid VIN format"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let result = self.decoderService.decodeVIN(self.vinInput) {
                self.decodedResult = result
                let vinData = VINData(vin: self.vinInput)
                self.historyService.addToHistory(vinData)
                self.selectedTab = 2
            } else {
                self.errorMessage = "Failed to decode VIN"
            }
            self.isLoading = false
        }
    }
    
    func pasteFromClipboard() {
        if let string = UIPasteboard.general.string {
            vinInput = string.uppercased()
        }
    }
    
    func clearInput() {
        vinInput = ""
        decodedResult = nil
        errorMessage = nil
    }
    
    func addNote(_ note: String, for vin: String) {
        historyService.updateNote(for: vin, note: note)
    }
    
    func removeFromHistory(_ vinData: VINData) {
        historyService.removeFromHistory(vinData)
    }
    
    func clearHistory() {
        historyService.clearHistory()
    }
    
    func toggleHistory() {
        showHistory.toggle()
    }
} 