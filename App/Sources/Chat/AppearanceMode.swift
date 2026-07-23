import SwiftUI

/// User-selectable appearance override, persisted across launches. `system`
/// defers to the device setting; `light`/`dark` force a scheme regardless of
/// it. All colors come from `DS`-backed asset Color Sets, so no other code
/// needs to change to support this — it's just which scheme SwiftUI resolves.
enum AppearanceMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var label: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    var icon: String {
        switch self {
        case .system: return "circle.righthalf.filled"
        case .light: return "sun.max"
        case .dark: return "moon"
        }
    }
}
