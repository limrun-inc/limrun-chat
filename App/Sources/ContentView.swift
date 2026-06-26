import SwiftUI

struct ContentView: View {
    @Binding var isDarkModeEnabled: Bool

    var body: some View {
        ChatView(isDarkModeEnabled: $isDarkModeEnabled)
    }
}

#Preview {
    ContentView(isDarkModeEnabled: .constant(false))
}

#Preview("Dark Mode") {
    ContentView(isDarkModeEnabled: .constant(true))
        .preferredColorScheme(.dark)
}
