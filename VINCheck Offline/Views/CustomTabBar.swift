import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs: [TabBarItem] = [
        .init(index: 0, icon: "magnifyingglass", title: "Check"),
        .init(index: 1, icon: "car.2.fill", title: "Brands"),
        .init(index: 2, icon: "checkmark.circle", title: "Result"),
        .init(index: 3, icon: "clock.arrow.circlepath", title: "History"),
        .init(index: 4, icon: "gearshape", title: "Settings")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = tab.index
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == tab.index {
                                Circle()
                                    .fill(Color.blue.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                    .shadow(color: .blue.opacity(0.12), radius: 8, x: 0, y: 4)
                            }
                            Image(systemName: tab.icon)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(selectedTab == tab.index ? .blue : .gray)
                        }
                        Text(tab.title)
                            .font(.caption2)
                            .fontWeight(selectedTab == tab.index ? .bold : .regular)
                            .foregroundColor(selectedTab == tab.index ? .blue : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 6)
        .padding(.bottom, 10)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 4)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

struct TabBarItem: Identifiable {
    let id = UUID()
    let index: Int
    let icon: String
    let title: String
} 