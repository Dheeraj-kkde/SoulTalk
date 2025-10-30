import Foundation
import SwiftUI

@MainActor
final class AppDataStore: ObservableObject {
    @Published private(set) var experts: [Expert]
    @Published var chats: [Chat]

    init(experts: [Expert] = SampleData.experts, chats: [Chat] = SampleData.chats) {
        self.experts = experts
        self.chats = chats
    }

    var featuredExperts: [Expert] {
        Array(experts.prefix(5))
    }

    func searchExperts(matching query: String) -> [Expert] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return experts }
        return experts.filter { expert in
            expert.name.localizedCaseInsensitiveContains(trimmed) ||
            expert.specialties.joined(separator: ", ").localizedCaseInsensitiveContains(trimmed)
        }
    }

    func ensureChat(for expert: Expert) -> Chat.ID {
        if let existing = chats.first(where: { $0.expert.id == expert.id }) {
            return existing.id
        }

        let newChat = Chat(id: UUID(), expert: expert, messages: [])
        chats.append(newChat)
        return newChat.id
    }

    func binding(for chatID: Chat.ID) -> Binding<Chat>? {
        guard let index = chats.firstIndex(where: { $0.id == chatID }) else { return nil }
        return Binding(
            get: { self.chats[index] },
            set: { self.chats[index] = $0 }
        )
    }
}
