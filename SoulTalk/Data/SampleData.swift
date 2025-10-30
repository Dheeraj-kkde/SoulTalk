import Foundation

enum SampleData {
    static let experts: [Expert] = [
        Expert(
            id: UUID(),
            name: "Dr. Kavin Guleria",
            gender: .male,
            specialties: ["Psychiatry", "Anxiety", "Depression"],
            bio: "Experienced psychiatrist focusing on anxiety and mood disorders.",
            ratePerMinute: 220,
            imageName: "kavin"
        ),
        Expert(
            id: UUID(),
            name: "Dr. Aisha Verma",
            gender: .female,
            specialties: ["Psychiatry", "Anxiety", "Depression"],
            bio: "Board-certified psychiatrist with over a decade helping adults manage mood and anxiety disorders.",
            ratePerMinute: 200,
            imageName: "expert_aisha"
        ),
        Expert(
            id: UUID(),
            name: "Dr. Rohan Mehta",
            gender: .male,
            specialties: ["Child Psychiatry", "ADHD"],
            bio: "Child and adolescent psychiatrist focused on ADHD and behavioural health.",
            ratePerMinute: 180,
            imageName: "expert_rohan"
        ),
        Expert(
            id: UUID(),
            name: "Dr. Neha Kapoor",
            gender: .female,
            specialties: ["Therapy", "CBT", "Trauma"],
            bio: "Therapist specialising in CBT and trauma-informed care.",
            ratePerMinute: 150,
            imageName: "expert_neha"
        ),
        Expert(
            id: UUID(),
            name: "Dr. Vikram Singh",
            gender: .male,
            specialties: ["Addiction", "Recovery"],
            bio: "Addiction specialist supporting recovery journeys.",
            ratePerMinute: 220,
            imageName: "expert_vikram"
        ),
        Expert(
            id: UUID(),
            name: "Dr. Sara Kaur",
            gender: .female,
            specialties: ["Relationship", "Family Therapy"],
            bio: "Helps couples and families improve communication and resilience.",
            ratePerMinute: 160,
            imageName: "expert_sara"
        )
    ]

    static let chats: [Chat] = {
        guard let expert = experts.first else { return [] }
        let now = Date()
        return [
            Chat(
                id: UUID(),
                expert: expert,
                messages: [
                    Message(id: UUID(), text: "Hello, how can I help you today?", isUser: false, timestamp: now.addingTimeInterval(-3600)),
                    Message(id: UUID(), text: "I have been feeling anxious lately.", isUser: true, timestamp: now.addingTimeInterval(-3500)),
                    Message(id: UUID(), text: "Thank you for sharing. Can you describe when it started?", isUser: false, timestamp: now.addingTimeInterval(-3400))
                ]
            )
        ]
    }()
}
