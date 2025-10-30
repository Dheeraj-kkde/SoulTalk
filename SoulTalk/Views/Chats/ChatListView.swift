import SwiftUI

struct ChatListView: View {
    @EnvironmentObject private var store: AppDataStore

    var body: some View {
        Group {
            if store.chats.isEmpty {
                ContentUnavailableView("No conversations", systemImage: "bubble.left.and.bubble.right") {
                    Text("Start a conversation from an expert profile to see it here.")
                }
            } else {
                List {
                    ForEach(store.chats) { chat in
                        NavigationLink(value: chat.id) {
                            ChatRow(chat: chat)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Chats")
        .navigationDestination(for: Chat.ID.self) { chatID in
            if let chatBinding = store.binding(for: chatID) {
                ChatView(chat: chatBinding)
                    .navigationTitle(chatBinding.wrappedValue.expert.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView("Chat unavailable", systemImage: "bubble.left.and.bubble.right")
            }
        }
    }
}

private struct ChatRow: View {
    let chat: Chat
    private let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()

    var body: some View {
        HStack(spacing: 12) {
            ExpertAvatarView(expert: chat.expert, size: 44)

            VStack(alignment: .leading, spacing: 6) {
                Text(chat.expert.name)
                    .font(.headline)
                Text(chat.lastMessagePreview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Text(relativeFormatter.localizedString(for: chat.lastUpdated, relativeTo: Date()))
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        ChatListView()
            .environmentObject(AppDataStore())
    }
}
