import SwiftUI

struct ChatView: View {
    @Binding var chat: Chat
    @State private var messageText: String = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(chat.messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color.clear)
                .onChange(of: chat.messages.count) { _ in
                    if let lastID = chat.messages.last?.id {
                        withAnimation(.easeOut(duration: 0.25)) {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            messageComposer
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.thinMaterial)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var messageComposer: some View {
        HStack(spacing: 12) {
            TextField("Type a message", text: $messageText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isInputFocused)
                .lineLimit(1...4)

            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .imageScale(.medium)
                    .fontWeight(.semibold)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.circle)
        }
    }

    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let newMessage = Message(id: UUID(), text: trimmed, isUser: true, timestamp: Date())
        chat.messages.append(newMessage)
        messageText = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let acknowledgement = Message(
                id: UUID(),
                text: "Thanks for sharing. I'll review this and respond shortly.",
                isUser: false,
                timestamp: Date()
            )
            chat.messages.append(acknowledgement)
        }
    }
}

private struct ChatBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }

            Text(message.text)
                .padding(12)
                .background(messageBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .foregroundStyle(message.isUser ? .primary : .secondary)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(message.text))

            if !message.isUser { Spacer(minLength: 40) }
        }
    }

    private var messageBackground: some ShapeStyle {
        if message.isUser {
            AnyShapeStyle(.thinMaterial)
        } else {
            AnyShapeStyle(.ultraThinMaterial)
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(chat: .constant(SampleData.chats[0]))
            .navigationTitle(SampleData.chats[0].expert.name)
    }
}
