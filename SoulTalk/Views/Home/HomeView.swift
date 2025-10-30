import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppDataStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    quickActions
                    featuredExperts
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding()
            }
            .navigationDestination(for: Expert.self) { expert in
                ExpertDetailView(expert: expert)
            }
            .navigationTitle("Home")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome to SoulTalk")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, .accentColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Connect with licensed psychiatrists and therapists. Book sessions, chat securely, and get support anytime.")
                .foregroundStyle(.secondary)
        }
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            NavigationLink {
                ExpertsView()
            } label: {
                QuickActionCard(
                    title: "Find Expert",
                    subtitle: "Browse psychiatrists",
                    systemImage: "person.text.rectangle"
                )
            }

            NavigationLink {
                ChatListView()
            } label: {
                QuickActionCard(
                    title: "Open Chats",
                    subtitle: "Continue conversation",
                    systemImage: "bubble.left.and.bubble.right"
                )
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var featuredExperts: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Experts")
                .font(.title2.weight(.semibold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(store.featuredExperts) { expert in
                        NavigationLink(value: expert) {
                            ExpertCard(expert: expert)
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppDataStore())
}
