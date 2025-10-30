import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemBackground), Color.accentColor.opacity(0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }

                NavigationStack {
                    ExpertsView()
                }
                .tabItem { Label("Experts", systemImage: "person.3") }

                NavigationStack {
                    ChatListView()
                }
                .tabItem { Label("Chats", systemImage: "bubble.left.and.bubble.right") }

                NavigationStack {
                    ProfileView()
                }
                .tabItem { Label("Profile", systemImage: "person.circle") }
            }
            .tint(.accentColor)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppDataStore())
}
