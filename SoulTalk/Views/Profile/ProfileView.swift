import SwiftUI

struct ProfileView: View {
    @State private var notificationsEnabled = true
    @State private var marketingOptIn = false
    @State private var showLogoutConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("Account")) {
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 56, height: 56)
                        .overlay(Text("DK").font(.title3).bold())
                        .overlay(
                            Circle().strokeBorder(Color.white.opacity(0.2))
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dheeraj Kumar")
                            .font(.headline)
                        Text("dheeraj@example.com")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("Preferences")) {
                Toggle("Notifications", isOn: $notificationsEnabled)
                Toggle("Product updates", isOn: $marketingOptIn)
            }

            Section(header: Text("Support")) {
                Button("Help Center", action: openHelpCenter)
                Button("Contact Us", action: contactSupport)
            }

            Section {
                Button(role: .destructive) {
                    showLogoutConfirmation = true
                } label: {
                    Text("Log Out")
                }
            }
        }
        .navigationTitle("Profile")
        .confirmationDialog(
            "Are you sure you want to log out?",
            isPresented: $showLogoutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Log Out", role: .destructive, action: performLogout)
            Button("Cancel", role: .cancel, action: {})
        }
    }

    private func openHelpCenter() {
        // Integrate with in-app support or open a URL when backend is available.
    }

    private func contactSupport() {
        // Connect this action to your messaging or support system.
    }

    private func performLogout() {
        // Hook this up with your authentication provider.
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
