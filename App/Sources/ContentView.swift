import SwiftUI

struct ContentView: View {
    @AppStorage("appearance") private var appearance = "system"

    var body: some View {
        ChatView(appearance: $appearance)
            .preferredColorScheme(preferredColorScheme)
    }

    private var preferredColorScheme: ColorScheme? {
        switch appearance {
        case "dark":
            return .dark
        case "light":
            return .light
        default:
            return nil
        }
    }
}

#Preview {
    ContentView()
}
