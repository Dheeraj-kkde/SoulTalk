import SwiftUI

struct ExpertDetailView: View {
    let expert: Expert

    @EnvironmentObject private var store: AppDataStore
    @State private var bookingDate = Date().addingTimeInterval(3600)
    @State private var durationMinutes: Int = 30
    @State private var showBookingConfirmation = false
    @State private var activeChatID: Chat.ID?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                aboutSection
                bookingSection
                chatSection
            }
            .padding()
        }
        .navigationTitle("Expert")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: Binding(
            get: { activeChatID != nil },
            set: { if !$0 { activeChatID = nil } }
        )) {
            NavigationStack {
                if let chatID = activeChatID, let chatBinding = store.binding(for: chatID) {
                    ChatView(chat: chatBinding)
                        .navigationTitle(chatBinding.wrappedValue.expert.name)
                        .navigationBarTitleDisplayMode(.inline)
                } else {
                    ContentUnavailableView("Chat unavailable", systemImage: "bubble.left.and.bubble.right")
                }
            }
        }
        .alert("Session Booked", isPresented: $showBookingConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your session with \(expert.name) on \(bookingDate.formatted(date: .long, time: .shortened)) has been scheduled.")
        }
    }

    private var header: some View {
        HStack(spacing: 16) {
            ExpertAvatarView(expert: expert, size: 72)
            VStack(alignment: .leading, spacing: 6) {
                Text(expert.name)
                    .font(.title2.weight(.semibold))
                Text(expert.specialties.joined(separator: ", "))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(.headline)
            Text(expert.bio)
                .foregroundStyle(.secondary)
        }
    }

    private var bookingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Book a Session")
                .font(.headline)

            DatePicker(
                "Date & Time",
                selection: $bookingDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )

            Stepper(
                "Duration: \(durationMinutes) minutes",
                value: $durationMinutes,
                in: 15...90,
                step: 15
            )

            Button {
                showBookingConfirmation = true
            } label: {
                Text("Book for \(bookingPrice)")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 14))
            .accessibilityHint("Confirms the appointment booking")
        }
    }

    private var chatSection: some View {
        Button {
            activeChatID = store.ensureChat(for: expert)
        } label: {
            Label("Start Chat", systemImage: "bubble.left.and.bubble.right.fill")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle(radius: 14))
    }

    private var bookingPrice: String {
        let total = Double(durationMinutes) * expert.ratePerMinute
        return CurrencyFormatter.inr.string(from: NSNumber(value: total)) ?? ""
    }
}

#Preview {
    NavigationStack {
        ExpertDetailView(expert: SampleData.experts[0])
            .environmentObject(AppDataStore())
    }
}
