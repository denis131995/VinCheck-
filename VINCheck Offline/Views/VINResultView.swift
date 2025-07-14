import SwiftUI

struct VINResultView: View {
    @ObservedObject var viewModel: VINCheckViewModel
    let result: VINDecodeResult
    @State private var showCopyToast = false
    
    var adaptiveBottomPadding: CGFloat {
        UIScreen.main.bounds.height < 700 ? 60 : 120
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.green)
                            
                            Text("VIN Decoded!")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Decoding Results")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ResultCard(
                                icon: "🏷️",
                                title: "Make",
                                value: result.make,
                                color: .blue
                            )
                            
                            ResultCard(
                                icon: "🌍",
                                title: "Country",
                                value: result.country,
                                color: .green
                            )
                            
                            ResultCard(
                                icon: "🏭",
                                title: "Manufacturer",
                                value: result.manufacturer,
                                color: .orange
                            )
                            
                            ResultCard(
                                icon: "📆",
                                title: "Year",
                                value: "\(result.year)",
                                color: .purple
                            )
                            
                            if let plant = result.plant {
                                ResultCard(
                                    icon: "🏢",
                                    title: "Plant",
                                    value: plant,
                                    color: .red
                                )
                            }
                            
                            if let model = result.model {
                                ResultCard(
                                    icon: "🚗",
                                    title: "Model",
                                    value: model,
                                    color: .indigo
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recall Check")
                                .font(.headline)
                                .fontWeight(.semibold)
                            let wmi = String(viewModel.vinInput.prefix(3))
                            let recalls: [String: String] = [
                                "WA1": "⚠️ Для Audi (WA1) был отзыв по подушкам безопасности в 2018 году.",
                                "JTD": "⚠️ Для Toyota (JTD) был отзыв по топливной системе в 2016 году.",
                                "1HG": "⚠️ Для Honda (1HG) был отзыв по подушкам безопасности Takata в 2017 году.",
                                "WVW": "⚠️ Для Volkswagen (WVW) был отзыв по DSG в 2014 году."
                            ]
                            Text("No known recalls for this manufacturer.")
                                .font(.subheadline)
                                .foregroundColor(recalls[wmi] != nil ? .red : .secondary)
                                .padding(.bottom, 4)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("VIN Breakdown")
                                .font(.headline)
                                .fontWeight(.semibold)
                            let vin = viewModel.vinInput
                            let wmi = String(vin.prefix(3))
                            let vds = String(vin.dropFirst(3).prefix(6))
                            let vis = String(vin.dropFirst(9))
                            Text("WMI: \(wmi) — \(result.manufacturer), \(result.country)")
                                .font(.subheadline)
                            Text("VDS: \(vds) — model/engine (no breakdown)")
                                .font(.subheadline)
                            Text("VIS: \(vis) — serial number, year, plant")
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("VIN Symbol Explanation")
                                .font(.headline)
                                .fontWeight(.semibold)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("1–3: WMI — manufacturer and country")
                                Text("4–9: VDS — model characteristics")
                                Text("10: \(String(viewModel.vinInput.dropFirst(9).prefix(1))) — year (\(String(result.year)))")
                                if let plant = result.plant {
                                    Text("11: \(String(viewModel.vinInput.dropFirst(10).prefix(1))) — plant (\(plant))")
                                } else {
                                    Text("11: \(String(viewModel.vinInput.dropFirst(10).prefix(1))) — plant (no data)")
                                }
                                Text("12–17: Serial number")
                            }
                            .font(.subheadline)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                viewModel.selectedTab = 0
                            }) {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("New Check")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                let resultText = """
                                VIN: \(viewModel.vinInput)
                                Make: \(result.make)
                                Country: \(result.country)
                                Manufacturer: \(result.manufacturer)
                                Year: \(result.year)
                                \(result.plant != nil ? "Plant: \(result.plant!)\n" : "")\(result.model != nil ? "Model: \(result.model!)" : "")
                                """
                                UIPasteboard.general.string = resultText
                                withAnimation {
                                    showCopyToast = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showCopyToast = false
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy Result")
                                }
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .padding(.bottom, geo.safeAreaInsets.bottom + 80)
                }
                .background(Color(.systemBackground))
                if showCopyToast {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Result copied!")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(Color.blue.opacity(0.95))
                                .cornerRadius(16)
                            Spacer()
                        }
                        .padding(.bottom, geo.safeAreaInsets.bottom + 80)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                }
            }
        }
    }
}

struct ResultCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 32))
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
} 
