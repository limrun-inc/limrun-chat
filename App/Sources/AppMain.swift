import SwiftUI

@main
struct LimrunChatApp: App {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false

    var body: some Scene {
        WindowGroup {
            ContentView(isDarkModeEnabled: $isDarkModeEnabled)
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
    }
}
