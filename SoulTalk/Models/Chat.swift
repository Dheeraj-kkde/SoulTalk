import Foundation

struct Chat: Identifiable, Hashable, Codable {
    let id: UUID
    var expert: Expert
    var messages: [Message]

    var lastMessagePreview: String {
        messages.last?.text ?? "New chat"
    }

    var lastUpdated: Date {
        messages.last?.timestamp ?? Date()
    }
}
