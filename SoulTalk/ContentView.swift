//
//  ContentView.swift
//  SoulTalk
//
//  Created by Dheeraj Kumar on 10/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(.systemBackground), Color.accentColor.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                ExpertsView()
                    .tabItem { Label("Experts", systemImage: "person.3") }
                ChatListView()
                    .tabItem { Label("Chats", systemImage: "bubble.left.and.bubble.right") }
                ProfileView()
                    .tabItem { Label("Profile", systemImage: "person.circle") }
            }
            .tint(.accentColor)
        }
    }
}

// MARK: - Home
struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome to SoulTalk")
                        .font(.largeTitle).bold()
                        .foregroundStyle(LinearGradient(colors: [.primary, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                    Text("Connect with licensed psychiatrists and therapists. Book sessions, chat securely, and get support anytime.")
                        .foregroundStyle(.secondary)

                    // Quick actions
                    HStack(spacing: 12) {
                        NavigationLink {
                            ExpertsView()
                        } label: {
                            QuickActionCard(title: "Find Expert", subtitle: "Browse psychiatrists", systemImage: "person.text.rectangle")
                        }
                        NavigationLink {
                            ChatListView()
                        } label: {
                            QuickActionCard(title: "Open Chats", subtitle: "Continue conversation", systemImage: "bubble.left.and.bubble.right")
                        }
                    }

                    // Featured experts (mock)
                    Text("Featured Experts")
                        .font(.title2).bold()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(MockData.experts.prefix(5)) { expert in
                                NavigationLink(value: expert) {
                                    ExpertCard(expert: expert)
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding()
                .animation(.snappy, value: UUID())
            }
            .navigationDestination(for: Expert.self) { expert in
                ExpertDetailView(expert: expert)
            }
            .navigationTitle("Home")
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(.tint)
            }
            .frame(width: 44, height: 44)
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.white.opacity(0.1))
        )
    }
}

struct ExpertAvatarView: View {
    let expert: Expert
    let size: CGFloat

    var body: some View {
        Group {
            if let uiImage = expert.displayUIImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Circle().fill(Color.accentColor.opacity(0.15))
                    Text(expert.initials).font(size >= 60 ? .title2 : .headline).bold()
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

struct ExpertCard: View {
    let expert: Expert

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ExpertAvatarView(expert: expert, size: 64)
            Text(expert.name)
                .font(.headline)
            Text(expert.specialties.joined(separator: ", "))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(spacing: 6) {
                Image(systemName: "indianrupeesign")
                Text("\(expert.ratePerMinute, specifier: "%.0f")/min")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(LinearGradient(colors: [Color.white.opacity(0.15), Color.accentColor.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .frame(width: 210)
    }
}

// MARK: - Experts
struct ExpertsView: View {
    @State private var search: String = ""

    var filteredExperts: [Expert] {
        if search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return MockData.experts }
        return MockData.experts.filter { $0.name.localizedCaseInsensitiveContains(search) || $0.specialties.joined(separator: ", ").localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredExperts) { expert in
                    NavigationLink(destination: ExpertDetailView(expert: expert)) {
                        HStack(spacing: 12) {
                            ExpertAvatarView(expert: expert, size: 44)
                            VStack(alignment: .leading) {
                                Text(expert.name).font(.headline)
                                Text(expert.specialties.joined(separator: ", "))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("$\(expert.ratePerMinute, specifier: "%.0f")/min")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.clear)
            .navigationTitle("Experts")
        }
    }
}

struct ExpertDetailView: View {
    let expert: Expert
    @State private var bookingDate = Date().addingTimeInterval(3600)
    @State private var durationMinutes: Int = 30

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    ExpertAvatarView(expert: expert, size: 64)
                    VStack(alignment: .leading) {
                        Text(expert.name).font(.title2).bold()
                        Text(expert.specialties.joined(separator: ", "))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }

                Text("About")
                    .font(.headline)
                Text(expert.bio)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Book a Session").font(.headline)
                    DatePicker("Date & Time", selection: $bookingDate, displayedComponents: [.date, .hourAndMinute])
                    Stepper("Duration: \(durationMinutes) min", value: $durationMinutes, in: 15...90, step: 15)
                    Button {
                        // Placeholder booking action
                    } label: {
                        Text("Book for $\(price, specifier: "%.0f")")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 14))
                }

                Button {
                    // Placeholder start chat action
                } label: {
                    Label("Start Chat", systemImage: "bubble.left.and.bubble.right.fill")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle(radius: 14))
            }
            .padding()
        }
        .navigationTitle("Expert")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var price: Double { Double(durationMinutes) * expert.ratePerMinute }
}

// MARK: - Chats
struct ChatListView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(MockData.chats) { chat in
                    NavigationLink(destination: ChatView(chat: chat)) {
                        VStack(alignment: .leading) {
                            Text(chat.expert.name).font(.headline)
                            Text(chat.lastMessagePreview)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.clear)
            .navigationTitle("Chats")
        }
    }
}

struct ChatView: View {
    let chat: Chat
    @State private var messageText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(chat.messages) { msg in
                        HStack {
                            if msg.isUser { Spacer() }
                            Text(msg.text)
                                .padding(10)
                                .background(
                                    (msg.isUser ? AnyShapeStyle(.thinMaterial) : AnyShapeStyle(.ultraThinMaterial))
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            if !msg.isUser { Spacer() }
                        }
                    }
                }
                .padding()
            }
            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(.roundedBorder)
                Button {
                    // send message placeholder
                    messageText = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(.thinMaterial)
        }
        .navigationTitle(chat.expert.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Profile
struct ProfileView: View {
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    HStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.15))
                            .frame(width: 48, height: 48)
                            .overlay(Text("DK").font(.title3).bold())
                            .overlay(
                                Circle().strokeBorder(Color.white.opacity(0.2))
                            )
                        VStack(alignment: .leading) {
                            Text("Dheeraj Kumar").font(.headline)
                            Text("dheeraj@example.com").foregroundStyle(.secondary)
                        }
                    }
                }
                Section(header: Text("Preferences")) {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                }
                Section(header: Text("Support")) {
                    Button("Help Center") {}
                    Button("Contact Us") {}
                }
                Section {
                    Button(role: .destructive) { } label: {
                        Text("Log Out")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.clear)
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Models & Mock Data
enum Gender: String, Codable, Hashable {
    case male
    case female
}

struct Expert: Identifiable, Hashable {
    let id: UUID
    let name: String
    let gender: Gender
    let specialties: [String]
    let bio: String
    let ratePerMinute: Double
    let imageName: String?

    var initials: String {
        let parts = name.split(separator: " ")
        return parts.prefix(2).map { String($0.first ?? Character("?")) }.joined()
    }
    
    var displayUIImage: UIImage? {
        if let imageName = imageName, let img = UIImage(named: imageName) {
            return img
        }
        return UIImage(named: gender == .female ? "Female Pic" : "Male Pic")
    }
}

struct Message: Identifiable, Hashable {
    let id: UUID
    let text: String
    let isUser: Bool
    let timestamp: Date
}

struct Chat: Identifiable, Hashable {
    let id: UUID
    let expert: Expert
    var messages: [Message]

    var lastMessagePreview: String { messages.last?.text ?? "New chat" }
}

enum MockData {
    static let experts: [Expert] = [
        Expert(id: UUID(), name: "Dr. Kavin Guleria", gender: .male, specialties: ["Psychiatry", "Anxiety", "Depression"], bio: "Experienced psychiatrist focusing on anxiety and mood disorders.", ratePerMinute: 2.2, imageName: "kavin"),
        Expert(id: UUID(), name: "Dr. Aisha Verma", gender: .female, specialties: ["Psychiatry", "Anxiety", "Depression"], bio: "Board-certified psychiatrist with 10+ years helping adults manage mood and anxiety disorders.", ratePerMinute: 2.0, imageName: "expert_aisha"),
        Expert(id: UUID(), name: "Dr. Rohan Mehta", gender: .male, specialties: ["Child Psychiatry", "ADHD"], bio: "Child and adolescent psychiatrist focused on ADHD and behavioral health.", ratePerMinute: 1.8, imageName: "expert_rohan"),
        Expert(id: UUID(), name: "Dr. Neha Kapoor", gender: .female, specialties: ["Therapy", "CBT", "Trauma"], bio: "Therapist specializing in CBT and trauma-informed care.", ratePerMinute: 1.5, imageName: "expert_neha"),
        Expert(id: UUID(), name: "Dr. Vikram Singh", gender: .male, specialties: ["Addiction", "Recovery"], bio: "Addiction specialist supporting recovery journeys.", ratePerMinute: 2.2, imageName: "expert_vikram"),
        Expert(id: UUID(), name: "Dr. Sara Kaur", gender: .female, specialties: ["Relationship", "Family Therapy"], bio: "Helps couples and families improve communication and resilience.", ratePerMinute: 1.6, imageName: "expert_sara")
    ]

    static let chats: [Chat] = {
        let expert = experts.first!
        return [
            Chat(id: UUID(), expert: expert, messages: [
                Message(id: UUID(), text: "Hello, how can I help you today?", isUser: false, timestamp: Date().addingTimeInterval(-3600)),
                Message(id: UUID(), text: "I have been feeling anxious lately.", isUser: true, timestamp: Date().addingTimeInterval(-3500)),
                Message(id: UUID(), text: "Thank you for sharing. Can you describe when it started?", isUser: false, timestamp: Date().addingTimeInterval(-3400))
            ])
        ]
    }()
}

#Preview {
    ContentView()
}
