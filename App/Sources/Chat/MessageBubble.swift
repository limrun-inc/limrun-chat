import SwiftUI

/// Asymmetric turns, the single biggest "real ChatGPT" tell:
/// user = right-aligned gray bubble; assistant = full-width plain text, no bubble.
struct MessageBubble: View {
    let message: Message

    var body: some View {
        switch message.role {
        case .user:
            HStack {
                Spacer(minLength: 60)
                Text(message.text)
                    .font(DS.messageFont)
                    .foregroundStyle(DS.textPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        DS.userBubble,
                        in: RoundedRectangle(cornerRadius: DS.bubbleRadius, style: .continuous)
                    )
                    .textSelection(.enabled)
            }
        case .assistant:
            HStack(alignment: .top, spacing: 0) {
                if message.text.isEmpty && message.isStreaming {
                    TypingIndicator()
                } else {
                    assistantText
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer(minLength: 0)
            }
        }
    }

    private var assistantText: some View {
        // Plain text, plus a trailing block caret while streaming.
        (Text(message.text)
            + (message.isStreaming
                ? Text(" ▍").foregroundColor(DS.textTertiary)
                : Text("")))
            .font(DS.messageFont)
            .foregroundStyle(DS.textPrimary)
            .textSelection(.enabled)
    }
}
