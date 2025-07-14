import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var page = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            image: "car.2.fill",
            title: "Welcome to VINCheck Offline",
            description: "Decode any VIN instantly, even without internet."
        ),
        OnboardingPage(
            image: "magnifyingglass",
            title: "How to Use",
            description: "Enter a 17-character VIN and get detailed info about the car."
        ),
        OnboardingPage(
            image: "clock.arrow.circlepath",
            title: "History & Brands",
            description: "View your check history and see all supported brands."
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.12), Color(.systemBackground)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer()
                TabView(selection: $page) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        VStack(spacing: 24) {
                            Image(systemName: pages[i].image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.blue)
                                .padding(.bottom, 8)
                            Text(pages[i].title)
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text(pages[i].description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 32)
                        .tag(i)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 340)
                Spacer()
                Button(action: {
                    hasSeenOnboarding = true
                }) {
                    Text(page == pages.count - 1 ? "Get Started" : "Skip")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 32)
            }
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
} 