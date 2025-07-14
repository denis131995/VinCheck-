import SwiftUI

struct ManufacturersView: View {
    @StateObject private var manufacturerService = ManufacturerService()
    @State private var searchText = ""
    @State private var selectedManufacturer: Manufacturer?
    @State private var showingManufacturerDetail = false
    @State private var showingVINCheck = false
    
    var filteredManufacturers: [Manufacturer] {
        manufacturerService.searchManufacturers(query: searchText)
    }
    
    var popularManufacturers: [Manufacturer] {
        let popularBrands = ["Toyota", "BMW", "Mercedes-Benz", "Volkswagen", "Ford", "Honda", "Audi", "Nissan"]
        let allNames = manufacturerService.manufacturers.map { $0.displayName }
        print("All manufacturers:", allNames)
        let filtered = manufacturerService.manufacturers.filter { manufacturer in
            popularBrands.contains(manufacturer.displayName)
        }
        print("Popular manufacturers:", filtered.map { $0.displayName })
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    Image(systemName: "car.2.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("Available Brands")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("\(manufacturerService.manufacturers.count) brands supported")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                
                Button(action: {
                    showingVINCheck = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.caption)
                        
                        Text("Check VIN Now")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 8)
                }
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search brands...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                if !manufacturerService.isLoading && searchText.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Brands")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(popularManufacturers, id: \.id) { manufacturer in
                                    PopularBrandCard(manufacturer: manufacturer)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 16)
                }
                
                if manufacturerService.isLoading {
                    Spacer()
                    ProgressView("Loading manufacturers...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(searchText.isEmpty ? "All Brands" : "Search Results")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)
                        
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(filteredManufacturers) { manufacturer in
                                    ManufacturerCard(manufacturer: manufacturer)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 90)
                        }
                    }
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationBarHidden(true)
            .sheet(isPresented: $showingManufacturerDetail) {
                if let manufacturer = selectedManufacturer {
                    ManufacturerDetailView(manufacturer: manufacturer)
                }
            }
            .sheet(isPresented: $showingVINCheck) {
                VINCheckSheet()
            }
        }
    }
}

struct ManufacturerCard: View {
    let manufacturer: Manufacturer
    
    var body: some View {
        VStack(spacing: 12) {
            Text(manufacturer.displayName)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Text("\(manufacturer.countries.count) countries")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(manufacturer.wmiCodes.count) WMI codes")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct ManufacturerDetailView: View {
    let manufacturer: Manufacturer
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue.opacity(0.1), .blue.opacity(0.05)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            Image(systemName: "car.2.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.blue)
                        }
                        Text(manufacturer.displayName)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(manufacturer.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    // Stats
                    HStack(spacing: 20) {
                        StatCard(
                            title: "Countries",
                            value: "\(manufacturer.countries.count)",
                            icon: "globe"
                        )
                        StatCard(
                            title: "WMI Codes",
                            value: "\(manufacturer.wmiCodes.count)",
                            icon: "number"
                        )
                    }
                    .padding(.horizontal, 20)
                    // Countries
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Production Countries")
                            .font(.headline)
                            .fontWeight(.semibold)
                        if manufacturer.countries.isEmpty {
                            Text("No data")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 8)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                                ForEach(manufacturer.countries, id: \.self) { country in
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.blue)
                                        Text(country)
                                            .font(.subheadline)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    // WMI codes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("WMI Codes")
                            .font(.headline)
                            .fontWeight(.semibold)
                        if manufacturer.wmiCodes.isEmpty {
                            Text("No data")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 8)
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(manufacturer.wmiCodes, id: \.self) { wmi in
                                    Text(wmi)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: 600)
                .padding(.horizontal, 0)
                .padding(.top, 0)
                .padding(.bottom, 0)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct PopularBrandCard: View {
    let manufacturer: Manufacturer
    // let onTap: () -> Void // больше не нужен
    
    var body: some View {
        VStack(spacing: 8) {
            Text(manufacturer.displayName)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 80, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct VINCheckSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = VINCheckViewModel()
    @FocusState private var isVINFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("Check VIN")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Enter a 17-character VIN number")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    TextField("Enter VIN number", text: $viewModel.vinInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title2)
                        .textInputAutocapitalization(.characters)
                        .focused($isVINFocused)
                        .onChange(of: viewModel.vinInput) { newValue in
                            if newValue.count > 17 {
                                viewModel.vinInput = String(newValue.prefix(17))
                            }
                        }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    isVINFocused = false
                    viewModel.decodeVIN()
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                        }
                        
                        Text(viewModel.isLoading ? "Decoding..." : "Check VIN")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                .disabled(viewModel.vinInput.isEmpty || viewModel.isLoading)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    ManufacturersView()
} 
