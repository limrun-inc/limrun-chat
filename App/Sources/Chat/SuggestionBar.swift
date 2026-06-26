import SwiftUI

/// A horizontally scrolling row of tappable prompt chips, ChatGPT-style. Tapping
/// one sends that prompt directly, no keyboard needed.
struct SuggestionBar: View {
    let suggestions: [String]
    var onTap: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button {
                        onTap(suggestion)
                    } label: {
                        Text(suggestion)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(DS.textPrimary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(DS.separator, lineWidth: 1)
                            )
                    }
                    .accessibilityIdentifier("suggestion:\(suggestion)")
                }
            }
            .padding(.horizontal, DS.hPadding)
            .padding(.vertical, 8)
        }
    }
}
