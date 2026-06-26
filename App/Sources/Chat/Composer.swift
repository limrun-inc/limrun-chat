import SwiftUI

/// The input bar: a growing text field plus a morphing mic -> send -> stop button.
struct Composer: View {
    @Binding var draft: String
    var isResponding: Bool
    var onSend: () -> Void
    var onStop: () -> Void

    private var hasText: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(DS.textSecondary)
                .frame(width: 36, height: 36)

            TextField("Message", text: $draft, axis: .vertical)
                .font(DS.messageFont)
                .foregroundStyle(DS.textPrimary)
                .tint(DS.textPrimary)
                .lineLimit(1...5)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(
                    DS.bgComposer,
                    in: RoundedRectangle(cornerRadius: DS.composerRadius, style: .continuous)
                )

            actionButton
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(DS.separator)
                .frame(height: 0.5)
        }
    }

    @ViewBuilder private var actionButton: some View {
        Button {
            if isResponding {
                onStop()
            } else if hasText {
                onSend()
            }
        } label: {
            Image(systemName: glyph)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(DS.sendButtonGlyph)
                .frame(width: 36, height: 36)
                .background(DS.sendButtonBg, in: Circle())
        }
        .animation(.easeInOut(duration: 0.15), value: hasText)
        .animation(.easeInOut(duration: 0.15), value: isResponding)
    }

    private var glyph: String {
        if isResponding { return "stop.fill" }
        return hasText ? "arrow.up" : "mic.fill"
    }
}
