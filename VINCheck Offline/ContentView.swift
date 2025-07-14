//
//  ContentView.swift
//  VINCheck Offline
//
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = VINCheckViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView()
        } else {
            ZStack(alignment: .bottom) {
                Group {
                    switch viewModel.selectedTab {
                    case 0:
                        VINInputView(viewModel: viewModel)
                    case 1:
                        ManufacturersView()
                    case 2:
                        if let result = viewModel.decodedResult {
                            VINResultView(viewModel: viewModel, result: result)
                        } else {
                            VStack(spacing: 20) {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .font(.system(size: 64))
                                    .foregroundColor(.secondary)
                                Text("No results")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text("Check a VIN on the first tab")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemGroupedBackground))
                        }
                    case 3:
                        HistoryView(viewModel: viewModel)
                    case 4:
                        SettingsView(viewModel: viewModel)
                    default:
                        VINInputView(viewModel: viewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                CustomTabBar(selectedTab: $viewModel.selectedTab)
            }
            .accentColor(.blue)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    ContentView()
}
