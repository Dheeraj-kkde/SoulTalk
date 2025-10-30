import Foundation

enum Gender: String, Codable, Hashable, CaseIterable {
    case female
    case male
}

struct Expert: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let gender: Gender
    let specialties: [String]
    let bio: String
    let ratePerMinute: Double
    let imageName: String?

    var initials: String {
        name
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }
}
