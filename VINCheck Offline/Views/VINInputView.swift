import SwiftUI
// Card now imported from Card.swift

struct VINInputView: View {
    @ObservedObject var viewModel: VINCheckViewModel
    @StateObject private var manufacturerService = ManufacturerService()
    @FocusState private var isVINFocused: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.12), Color(.systemBackground)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 28) {
                    // Large header
                    VStack(spacing: 8) {
                        Text("VINCheck Offline")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.top, 24)
                        Text("VIN Decoder")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    // Mini statistics
                    HStack(spacing: 16) {
                        StatisticCard(
                            icon: "car.2.fill",
                            title: "Brands",
                            value: "\(manufacturerService.manufacturers.count)",
                            color: .blue
                        )
                        StatisticCard(
                            icon: "globe",
                            title: "Countries",
                            value: "50+",
                            color: .green
                        )
                        StatisticCard(
                            icon: "number",
                            title: "WMI Codes",
                            value: "1000+",
                            color: .orange
                        )
                    }
                    // VIN input card
                    Card {
                        VStack(spacing: 16) {
                            HStack {
                                TextField("Enter VIN number", text: $viewModel.vinInput)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .font(.title2)
                                    .textInputAutocapitalization(.characters)
                                    .focused($isVINFocused)
                                    .onChange(of: viewModel.vinInput) { newValue in
                                        if newValue.count > 17 {
                                            viewModel.vinInput = String(newValue.prefix(17))
                                        }
                                    }
                                Button(action: {
                                    viewModel.pasteFromClipboard()
                                }) {
                                    Image(systemName: "doc.on.clipboard")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            // Progress indicator
                            if viewModel.vinInput.count > 0 {
                                HStack(spacing: 4) {
                                    ForEach(0..<17, id: \.self) { index in
                                        Rectangle()
                                            .fill(index < viewModel.vinInput.count ? Color.green : Color.gray.opacity(0.3))
                                            .frame(height: 4)
                                            .cornerRadius(2)
                                    }
                                }
                                .animation(.easeInOut(duration: 0.2), value: viewModel.vinInput.count)
                            }
                            // Error message
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            // Check button
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
                                .cornerRadius(14)
                                .shadow(color: .blue.opacity(0.18), radius: 8, x: 0, y: 4)
                            }
                            .disabled(viewModel.vinInput.isEmpty || viewModel.isLoading)
                            .opacity(viewModel.vinInput.isEmpty || viewModel.isLoading ? 0.6 : 1.0)
                        }
                        .padding(.horizontal, 8)
                    }
                    // Clear button
                    if !viewModel.vinInput.isEmpty {
                        Button(action: {
                            viewModel.clearInput()
                        }) {
                            Text("Clear")
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    // VIN examples
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Examples")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                VINExampleCard(
                                    brand: "Toyota",
                                    example: "JTDKN3DU0E1765432",
                                    description: "Camry 2014"
                                ) {
                                    viewModel.vinInput = "JTDKN3DU0E1765432"
                                }
                                VINExampleCard(
                                    brand: "BMW",
                                    example: "WBA3B5C56DF123456",
                                    description: "3 Series"
                                ) {
                                    viewModel.vinInput = "WBA3B5C56DF123456"
                                }
                                VINExampleCard(
                                    brand: "Ford",
                                    example: "1FADP3K26EL123456",
                                    description: "Focus"
                                ) {
                                    viewModel.vinInput = "1FADP3K26EL123456"
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
    }
}

struct StatisticCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct VINExampleCard: View {
    let brand: String
    let example: String
    let description: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(brand)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(example)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 100)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VINInputView(viewModel: VINCheckViewModel())
} 