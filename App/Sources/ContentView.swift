import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false

    var body: some View {
        ChatView(isDarkModeEnabled: $isDarkModeEnabled)
            .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
