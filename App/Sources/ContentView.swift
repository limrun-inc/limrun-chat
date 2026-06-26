import SwiftUI

struct ContentView: View {
    @AppStorage("prefersDarkMode") private var prefersDarkMode = false

    var body: some View {
        ChatView(prefersDarkMode: $prefersDarkMode)
            .preferredColorScheme(prefersDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
