import SwiftUI

/// Design tokens. Every view references these, never a hardcoded Color, so the
/// dark-mode flip resolves entirely through the asset Color Sets.
enum DS {
    // Colors (asset Color Sets carry both light and dark appearances)
    static let bgPrimary = Color("bgPrimary")
    static let userBubble = Color("userBubble")
    static let bgComposer = Color("bgComposer")
    static let textPrimary = Color("textPrimary")
    static let textSecondary = Color("textSecondary")
    static let textTertiary = Color("textTertiary")
    static let separator = Color("separator")
    static let sendButtonBg = Color("sendButtonBg")
    static let sendButtonGlyph = Color("sendButtonGlyph")

    // Radii
    static let bubbleRadius: CGFloat = 18
    static let composerRadius: CGFloat = 22

    // Spacing
    static let hPadding: CGFloat = 16
    static let turnSpacing: CGFloat = 18

    // Type
    static let messageFont = Font.system(size: 17)
    static let titleFont = Font.system(size: 17, weight: .semibold)
}
