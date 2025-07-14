import Foundation

struct VINData: Codable, Identifiable {
    let id = UUID()
    let vin: String
    let timestamp: Date
    var note: String?
    
    // Decoded data
    var country: String?
    var manufacturer: String?
    var year: Int?
    var make: String?
    var model: String?
    var plant: String?
    var engine: String?
    var transmission: String?
    
    init(vin: String, note: String? = nil) {
        self.vin = vin.uppercased()
        self.timestamp = Date()
        self.note = note
    }
}

struct WMIData: Codable {
    let wmi: String
    let country: String
    let manufacturer: String
    let make: String?
    let description: String?
}

struct YearCode: Codable {
    let code: String
    let year: Int
}

struct VINDecodeResult {
    let country: String
    let manufacturer: String
    let make: String
    let year: Int
    let plant: String?
    let model: String?
    let engine: String?
    let transmission: String?
} 