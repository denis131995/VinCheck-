import SwiftUI
import StoreKit
// Card теперь импортируется из Card.swift

struct SettingsView: View {
    @ObservedObject var viewModel: VINCheckViewModel
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Info Card
                    Card {
                        HStack(spacing: 16) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 36, weight: .bold))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("VINCheck Offline")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Version 1.0.0")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    // Data Section
                    Card {
                        VStack(spacing: 0) {
                            Button(action: {
                                showingResetAlert = true
                            }) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.2), .red.opacity(0.05)]), startPoint: .top, endPoint: .bottom))
                                            .frame(width: 36, height: 36)
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .font(.title2)
                                    }
                                    Text("Reset Data")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    // Support Section
                    Card {
                        VStack(spacing: 0) {
                            Button(action: {
                                if let url = URL(string: "https://vincheck.app/privacy") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue.opacity(0.1))
                                            .frame(width: 36, height: 36)
                                        Image(systemName: "hand.raised")
                                            .foregroundColor(.blue)
                                            .font(.title2)
                                    }
                                    Text("Privacy Policy")
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }
                            Divider()
                            Button(action: {
                                rateApp()
                            }) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(LinearGradient(gradient: Gradient(colors: [.yellow.opacity(0.2), .yellow.opacity(0.05)]), startPoint: .top, endPoint: .bottom))
                                            .frame(width: 36, height: 36)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.title2)
                                    }
                                    Text("Rate App")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.yellow)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    // About Section
                    Card {
                        HStack(alignment: .top, spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.15), .blue.opacity(0.05)]), startPoint: .top, endPoint: .bottom))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "doc.text.magnifyingglass")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("VINCheck Offline is an offline tool for decoding vehicle VIN numbers.")
                                    .font(.subheadline)
                                Text("The app works entirely locally, with no internet connection required.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("All data is stored on your device.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 90)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemGroupedBackground), Color(.systemGray6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Reset all data?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    viewModel.clearHistory()
                    viewModel.clearInput()
                }
            } message: {
                Text("This action will delete all check history and clear the input data. This action cannot be undone.")
            }
        }
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
} 