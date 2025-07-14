import Foundation

class VINDecoderService: ObservableObject {
    private var wmiDatabase: [WMIData] = []
    private var yearCodes: [YearCode] = []
    
    init() {
        loadDatabases()
    }
    
    private func loadDatabases() {
        if let url = Bundle.main.url(forResource: "wmi_database", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let rawArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
            wmiDatabase = rawArray.compactMap { dict in
                guard let wmi = dict["WMI"] as? String,
                      let country = dict["Country"] as? String,
                      let manufacturer = dict["Name"] as? String else { return nil }
                return WMIData(wmi: wmi, country: country, manufacturer: manufacturer, make: nil, description: nil)
            }
        } else {
            wmiDatabase = []
        }
        yearCodes = [
            YearCode(code: "A", year: 2010),
            YearCode(code: "B", year: 2011),
            YearCode(code: "C", year: 2012),
            YearCode(code: "D", year: 2013),
            YearCode(code: "E", year: 2014),
            YearCode(code: "F", year: 2015),
            YearCode(code: "G", year: 2016),
            YearCode(code: "H", year: 2017),
            YearCode(code: "J", year: 2018),
            YearCode(code: "K", year: 2019),
            YearCode(code: "L", year: 2020),
            YearCode(code: "M", year: 2021),
            YearCode(code: "N", year: 2022),
            YearCode(code: "P", year: 2023),
            YearCode(code: "R", year: 2024),
            YearCode(code: "S", year: 2025),
            YearCode(code: "T", year: 2026),
            YearCode(code: "U", year: 2027),
            YearCode(code: "V", year: 2028),
            YearCode(code: "W", year: 2029),
            YearCode(code: "X", year: 2030),
            YearCode(code: "Y", year: 2031),
            YearCode(code: "Z", year: 2032),
            YearCode(code: "1", year: 2001),
            YearCode(code: "2", year: 2002),
            YearCode(code: "3", year: 2003),
            YearCode(code: "4", year: 2004),
            YearCode(code: "5", year: 2005),
            YearCode(code: "6", year: 2006),
            YearCode(code: "7", year: 2007),
            YearCode(code: "8", year: 2008),
            YearCode(code: "9", year: 2009)
        ]
    }
    
    func decodeVIN(_ vin: String) -> VINDecodeResult? {
        guard vin.count == 17 else { return nil }
        
        let upperVIN = vin.uppercased()
        
        let wmi = String(upperVIN.prefix(3))
        let vds = String(upperVIN.dropFirst(3).prefix(6))
        let yearCode = String(upperVIN.dropFirst(9).prefix(1))
        let plantCode = String(upperVIN.dropFirst(10).prefix(1))
        
        var wmiData: WMIData? = wmiDatabase.first(where: { $0.wmi == wmi })
        if wmiData == nil {
            let wmi2 = String(wmi.prefix(2))
            wmiData = wmiDatabase.first(where: { $0.wmi == wmi2 })
        }
        if wmiData == nil {
            let wmi1 = String(wmi.prefix(1))
            wmiData = wmiDatabase.first(where: { $0.wmi == wmi1 })
        }
        guard let foundWMI = wmiData else {
            return nil
        }
        
        guard let year = yearCodes.first(where: { $0.code == yearCode })?.year else {
            return nil
        }
        
        let plant = getPlantName(for: plantCode, manufacturer: foundWMI.manufacturer)
        
        let model = getModelName(for: vds, manufacturer: foundWMI.manufacturer)
        
        return VINDecodeResult(
            country: foundWMI.country,
            manufacturer: foundWMI.manufacturer,
            make: foundWMI.make ?? foundWMI.manufacturer,
            year: year,
            plant: plant,
            model: model,
            engine: nil,
            transmission: nil
        )
    }
    
    private func getPlantName(for code: String, manufacturer: String) -> String? {
        let plantDatabase: [String: [String: String]] = [
            "TOYOTA": [
                "A": "Takaoka",
                "B": "Tsutsumi",
                "C": "Tahara",
                "D": "Motomachi",
                "E": "Kanto Auto Works",
                "F": "Fujimatsu",
                "G": "Tahara",
                "H": "Hino",
                "J": "Takaoka",
                "K": "Tsutsumi",
                "L": "Tahara",
                "M": "Motomachi",
                "N": "Kanto Auto Works",
                "P": "Fujimatsu",
                "R": "Tahara",
                "S": "Tsutsumi",
                "T": "Takaoka",
                "U": "Motomachi",
                "V": "Kanto Auto Works",
                "W": "Fujimatsu",
                "X": "Tahara",
                "Y": "Tsutsumi",
                "Z": "Takaoka"
            ],
            "HONDA": [
                "A": "Suzuka",
                "B": "Sayama",
                "C": "Yorii",
                "D": "Yokkaichi",
                "E": "Kumamoto",
                "F": "Saitama",
                "G": "Tochigi",
                "H": "Honda of America",
                "J": "Honda of Canada",
                "K": "Honda of UK",
                "L": "Honda of Brazil",
                "M": "Honda of Mexico",
                "N": "Honda of Thailand",
                "P": "Honda of India",
                "R": "Honda of Turkey",
                "S": "Honda of China",
                "T": "Honda of Indonesia",
                "U": "Honda of Malaysia",
                "V": "Honda of Vietnam",
                "W": "Honda of Pakistan",
                "X": "Honda of Argentina",
                "Y": "Honda of South Africa",
                "Z": "Honda of Australia"
            ],
            "NISSAN": [
                "A": "Oppama",
                "B": "Tochigi",
                "C": "Nissan Shatai",
                "D": "Kyushu",
                "E": "Smyrna",
                "F": "Aguascalientes",
                "G": "Sunderland",
                "H": "Rosslyn",
                "J": "Barcelona",
                "K": "Avila",
                "L": "Canton",
                "M": "Decherd",
                "N": "Nissan Motor",
                "P": "Nissan Diesel",
                "R": "Nissan Shatai",
                "S": "Nissan Motor",
                "T": "Nissan Diesel",
                "U": "Nissan Motor",
                "V": "Nissan Diesel",
                "W": "Nissan Motor",
                "X": "Nissan Diesel",
                "Y": "Nissan Motor",
                "Z": "Nissan Diesel"
            ],
            "BMW": [
                "A": "Munich",
                "B": "Dingolfing",
                "C": "Regensburg",
                "D": "Spartanburg",
                "E": "Leipzig",
                "F": "Oxford",
                "G": "Rosslyn",
                "H": "Chennai",
                "J": "Shenyang",
                "K": "Rayong",
                "L": "Jakarta",
                "M": "Kulim",
                "N": "Cairo",
                "P": "Pretoria",
                "R": "Bangkok",
                "S": "Chennai",
                "T": "Shenyang",
                "U": "Rayong",
                "V": "Jakarta",
                "W": "Kulim",
                "X": "Cairo",
                "Y": "Pretoria",
                "Z": "Bangkok"
            ],
            "MERCEDES": [
                "A": "Sindelfingen",
                "B": "Bremen",
                "C": "Rastatt",
                "D": "Tuscaloosa",
                "E": "East London",
                "F": "Pune",
                "G": "Beijing",
                "H": "Bangkok",
                "J": "Jakarta",
                "K": "Kuala Lumpur",
                "L": "Ho Chi Minh",
                "M": "Cairo",
                "N": "Istanbul",
                "P": "Buenos Aires",
                "R": "Sao Paulo",
                "S": "Mexico City",
                "T": "Bangkok",
                "U": "Jakarta",
                "V": "Kuala Lumpur",
                "W": "Ho Chi Minh",
                "X": "Cairo",
                "Y": "Istanbul",
                "Z": "Buenos Aires"
            ],
            "AUDI": [
                "D": "Ingolstadt",
                "N": "Neckarsulm",
                "V": "Bratislava",
                "Y": "Gyor",
                "1": "Brussels"
            ],
            "VOLKSWAGEN": [
                "W": "Wolfsburg",
                "M": "Mosel",
                "H": "Hannover",
                "P": "Poznan",
                "K": "Kaluga",
                "C": "Chattanooga",
                "3": "Puebla",
                "4": "Curitiba",
                "5": "Palmela",
                "6": "Uitenhage",
                "7": "Emden",
                "8": "Dresden",
                "9": "Osnabruck"
            ]
        ]
        
        var normalized = manufacturer.uppercased()
        if normalized.contains("AUDI") {
            normalized = "AUDI"
        } else if normalized.contains("VOLKSWAGEN") {
            normalized = "VOLKSWAGEN"
        } else if normalized.contains("MERCEDES") {
            normalized = "MERCEDES"
        } else if normalized.contains("TOYOTA") {
            normalized = "TOYOTA"
        } else if normalized.contains("HONDA") {
            normalized = "HONDA"
        } else if normalized.contains("NISSAN") {
            normalized = "NISSAN"
        } else if normalized.contains("BMW") {
            normalized = "BMW"
        }
        normalized = normalized.replacingOccurrences(of: " AG", with: "")
            .replacingOccurrences(of: " MOTOR CO., LTD.", with: "")
            .replacingOccurrences(of: " MOTOR CORPORATION", with: "")
            .replacingOccurrences(of: " LLC", with: "")
            .replacingOccurrences(of: " SAS", with: "")
            .replacingOccurrences(of: " NV", with: "")
            .replacingOccurrences(of: " SPA", with: "")
            .replacingOccurrences(of: " AUTOMOBILES", with: "")
            .replacingOccurrences(of: " CORPORATION", with: "")
            .trimmingCharacters(in: .whitespaces)
        let plant = plantDatabase[normalized]?[code]
        return plant
    }
    
    private func getModelName(for vds: String, manufacturer: String) -> String? {
        let modelDatabase: [String: [String: String]] = [
            "TOYOTA": [
                "1HGBH": "Camry",
                "1HGBJ": "Corolla",
                "1HGCM": "Prius",
                "1HGCV": "RAV4",
                "1HGDJ": "Highlander",
                "1HGEM": "Sienna",
                "1HGFV": "Tacoma",
                "1HGGJ": "Tundra",
                "1HGKM": "4Runner",
                "1HGCJ": "Avalon"
            ],
            "HONDA": [
                "1HGBH": "Civic",
                "1HGBJ": "Accord",
                "1HGCM": "CR-V",
                "1HGCV": "Pilot",
                "1HGDJ": "Odyssey",
                "1HGEM": "Ridgeline",
                "1HGFV": "HR-V",
                "1HGGJ": "Passport",
                "1HGKM": "Insight",
                "1HGCJ": "Clarity"
            ],
            "NISSAN": [
                "1HGBH": "Altima",
                "1HGBJ": "Sentra",
                "1HGCM": "Rogue",
                "1HGCV": "Murano",
                "1HGDJ": "Pathfinder",
                "1HGEM": "Maxima",
                "1HGFV": "Frontier",
                "1HGGJ": "Titan",
                "1HGKM": "Leaf",
                "1HGCJ": "Versa"
            ],
            "BMW": [
                "1HGBH": "3 Series",
                "1HGBJ": "5 Series",
                "1HGCM": "X3",
                "1HGCV": "X5",
                "1HGDJ": "7 Series",
                "1HGEM": "X1",
                "1HGFV": "X7",
                "1HGGJ": "4 Series",
                "1HGKM": "i3",
                "1HGCJ": "8 Series"
            ],
            "MERCEDES": [
                "1HGBH": "C-Class",
                "1HGBJ": "E-Class",
                "1HGCM": "GLC",
                "1HGCV": "GLE",
                "1HGDJ": "S-Class",
                "1HGEM": "GLA",
                "1HGFV": "GLS",
                "1HGGJ": "A-Class",
                "1HGKM": "EQC",
                "1HGCJ": "CLA"
            ]
        ]
        
        let vdsPrefix = String(vds.prefix(5))
        return modelDatabase[manufacturer.uppercased()]?[vdsPrefix]
    }
    
    func validateVIN(_ vin: String) -> Bool {
        let upperVIN = vin.uppercased()
        
        guard upperVIN.count == 17 else { return false }
        
        let validCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHJKLMNPRSTUVWXYZ")
        let vinCharacterSet = CharacterSet(charactersIn: upperVIN)
        
        guard vinCharacterSet.isSubset(of: validCharacters) else { return false }
        
        return true
    }
    
    // Returns a sorted list of unique supported brands (manufacturers)
    func supportedBrands() -> [String] {
        let brands = wmiDatabase.map { $0.manufacturer.trimmingCharacters(in: .whitespacesAndNewlines) }
        return Array(Set(brands)).sorted()
    }
} 
