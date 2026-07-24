import SwiftUI

/// The user's chosen appearance. `system` defers to the device setting; the
/// other two pin the app to a specific palette. The raw value is what gets
/// persisted in `@AppStorage`, so keep it stable.
enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    /// What SwiftUI should force. `nil` means "follow the system", which lets
    /// the asset Color Sets resolve to whichever appearance the device is in.
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

    var symbol: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max"
        case .dark: return "moon.stars"
        }
    }
}
