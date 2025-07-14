import Foundation

class ManufacturerService: ObservableObject {
    @Published var manufacturers: [Manufacturer] = []
    @Published var isLoading = false
    
    init() {
        loadManufacturers()
    }
    
    private func loadManufacturers() {
        isLoading = true
        
        guard let url = Bundle.main.url(forResource: "wmi_database", withExtension: "json") else {
            print("Error: wmi_database.json not found")
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let wmiData = try JSONDecoder().decode([WMIRawData].self, from: data)
            
            let groupedManufacturers = Dictionary(grouping: wmiData) { $0.Name }
            
            manufacturers = groupedManufacturers.map { name, wmiList in
                let countries = Set(wmiList.map { $0.Country })
                let wmiCodes = wmiList.map { $0.WMI }
                
                return Manufacturer(
                    name: name,
                    displayName: getDisplayName(for: name),
                    countries: Array(countries),
                    wmiCodes: wmiCodes,
                    logo: getLogo(for: name)
                )
            }
            .sorted { $0.displayName < $1.displayName }
            
            isLoading = false
        } catch {
            print("Error loading manufacturers: \(error)")
            isLoading = false
        }
    }
    
    private func getDisplayName(for manufacturer: String) -> String {
        print("getDisplayName called with: \(manufacturer)")
        let displayNames: [String: String] = [
            "AUDI AG": "Audi",
            "TOYOTA MOTOR CORPORATION": "Toyota",
            "NISSAN MOTOR CO., LTD.": "Nissan",
            "HONDA MOTOR CO., LTD.": "Honda",
            "BMW AG": "BMW",
            "MERCEDES-BENZ AG": "Mercedes-Benz",
            "VOLKSWAGEN AG": "Volkswagen",
            "FORD MOTOR COMPANY": "Ford",
            "GENERAL MOTORS LLC": "General Motors",
            "HYUNDAI MOTOR COMPANY": "Hyundai",
            "KIA CORPORATION": "Kia",
            "RENAULT SAS": "Renault",
            "PEUGEOT": "Peugeot",
            "CITROEN": "Citroën",
            "OPEL": "Opel",
            "VOLVO": "Volvo",
            "MAZDA MOTOR CORPORATION": "Mazda",
            "SUBARU CORPORATION": "Subaru",
            "MITSUBISHI MOTORS CORPORATION": "Mitsubishi",
            "LEXUS": "Lexus",
            "INFINITI": "Infiniti",
            "ACURA": "Acura",
            "BUICK": "Buick",
            "CADILLAC": "Cadillac",
            "CHEVROLET": "Chevrolet",
            "CHRYSLER": "Chrysler",
            "DODGE": "Dodge",
            "JEEP": "Jeep",
            "RAM": "RAM",
            "GMC": "GMC",
            "PONTIAC": "Pontiac",
            "SATURN": "Saturn",
            "OLDSMOBILE": "Oldsmobile",
            "PLYMOUTH": "Plymouth",
            "FIAT": "Fiat",
            "ALFA ROMEO": "Alfa Romeo",
            "LANCIA": "Lancia",
            "MASERATI": "Maserati",
            "FERRARI": "Ferrari",
            "LAMBORGHINI": "Lamborghini",
            "PORSCHE": "Porsche",
            "BENTLEY": "Bentley",
            "ROLLS-ROYCE": "Rolls-Royce",
            "ASTON MARTIN": "Aston Martin",
            "JAGUAR": "Jaguar",
            "LAND ROVER": "Land Rover",
            "MINI": "Mini",
            "SMART": "Smart",
            "SEAT": "SEAT",
            "SKODA": "Škoda",
            "LADA": "Lada",
            "GAZ": "GAZ",
            "UAZ": "UAZ",
            "ZAZ": "ZAZ",
            "MOSKVICH": "Moskvich",
            "IZH": "IZH",
            "KAMAZ": "KAMAZ",
            "URAL": "Ural",
            "KRAZ": "KrAZ",
            "BELAZ": "BelAZ",
            "MAZ": "MAZ",
            "ZIL": "ZIL"
        ]
        
        return displayNames[manufacturer] ?? manufacturer
    }
    
    private func getLogo(for manufacturer: String) -> String {
        let logos: [String: String] = [
            "AUDI AG": "logo_audi",
            "TOYOTA MOTOR CORPORATION": "logo_toyota",
            "NISSAN MOTOR CO., LTD.": "logo_nissan",
            "HONDA MOTOR CO., LTD.": "logo_honda",
            "BMW AG": "logo_bmw",
            "MERCEDES-BENZ AG": "logo_mercedes",
            "VOLKSWAGEN AG": "logo_vw",
            "FORD MOTOR COMPANY": "logo_ford",
            "GENERAL MOTORS LLC": "logo_gm",
            "HYUNDAI MOTOR COMPANY": "logo_hyundai",
            "KIA CORPORATION": "logo_kia",
            "RENAULT SAS": "logo_renault",
            "PEUGEOT": "car.fill",
            "CITROEN": "car.fill",
            "OPEL": "car.fill",
            "VOLVO": "car.fill",
            "MAZDA MOTOR CORPORATION": "car.fill",
            "SUBARU CORPORATION": "car.fill",
            "MITSUBISHI MOTORS CORPORATION": "car.fill",
            "LEXUS": "car.fill",
            "INFINITI": "car.fill",
            "ACURA": "car.fill",
            "BUICK": "car.fill",
            "CADILLAC": "car.fill",
            "CHEVROLET": "car.fill",
            "CHRYSLER": "car.fill",
            "DODGE": "car.fill",
            "JEEP": "car.fill",
            "RAM": "car.fill",
            "GMC": "car.fill",
            "PONTIAC": "car.fill",
            "SATURN": "car.fill",
            "OLDSMOBILE": "car.fill",
            "PLYMOUTH": "car.fill",
            "FIAT": "car.fill",
            "ALFA ROMEO": "car.fill",
            "LANCIA": "car.fill",
            "MASERATI": "car.fill",
            "FERRARI": "car.fill",
            "LAMBORGHINI": "car.fill",
            "PORSCHE": "car.fill",
            "BENTLEY": "car.fill",
            "ROLLS-ROYCE": "car.fill",
            "ASTON MARTIN": "car.fill",
            "JAGUAR": "car.fill",
            "LAND ROVER": "car.fill",
            "MINI": "car.fill",
            "SMART": "car.fill",
            "SEAT": "car.fill",
            "SKODA": "car.fill",
            "LADA": "car.fill",
            "GAZ": "car.fill",
            "UAZ": "car.fill",
            "ZAZ": "car.fill",
            "MOSKVICH": "car.fill",
            "IZH": "car.fill",
            "KAMAZ": "car.fill",
            "URAL": "car.fill",
            "KRAZ": "car.fill",
            "BELAZ": "car.fill",
            "MAZ": "car.fill",
            "ZIL": "car.fill"
        ]
        
        return logos[manufacturer] ?? "car.fill"
    }
    
    func searchManufacturers(query: String) -> [Manufacturer] {
        if query.isEmpty {
            return manufacturers
        }
        
        return manufacturers.filter { manufacturer in
            manufacturer.displayName.localizedCaseInsensitiveContains(query) ||
            manufacturer.name.localizedCaseInsensitiveContains(query)
        }
    }
}

struct Manufacturer: Identifiable {
    let id = UUID()
    let name: String
    let displayName: String
    let countries: [String]
    let wmiCodes: [String]
    let logo: String
}

struct WMIRawData: Codable {
    let WMI: String
    let Name: String
    let Country: String
} 
