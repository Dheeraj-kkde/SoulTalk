import Foundation

struct Message: Identifiable, Hashable, Codable {
    let id: UUID
    let text: String
    let isUser: Bool
    let timestamp: Date
}
