import SwiftUI

struct ChatView: View {
    @Binding var prefersDarkMode: Bool
    @StateObject private var vm = ChatViewModel()
    private let bottomID = "bottom"

    var body: some View {
        NavigationStack {
            messageList
                .background(DS.bgPrimary)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    VStack(spacing: 0) {
                        if !vm.isResponding {
                            SuggestionBar(suggestions: vm.suggestions) { vm.send(prompt: $0) }
                        }
                        Composer(
                            draft: $vm.draft,
                            isResponding: vm.isResponding,
                            onSend: vm.send,
                            onStop: vm.stop
                        )
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
                .toolbarBackground(DS.bgPrimary, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
        .tint(DS.textPrimary)
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: DS.turnSpacing) {
                    ForEach(vm.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                    Color.clear.frame(height: 1).id(bottomID)
                }
                .padding(.horizontal, DS.hPadding)
                .padding(.top, 12)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: vm.messages.count) { _ in scrollToBottom(proxy) }
            // Follow the growing reply without animation: a spring per token (every
            // 25-70ms) would stack and jank. The text change itself drives the scroll.
            .onChange(of: vm.messages.last?.text) { _ in scrollToBottom(proxy, animated: false) }
            .onAppear { scrollToBottom(proxy, animated: false) }
        }
    }

    @ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(DS.textPrimary)
        }
        ToolbarItem(placement: .principal) {
            HStack(spacing: 5) {
                Text("Limrun Chat")
                    .font(DS.titleFont)
                    .foregroundStyle(DS.textPrimary)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(DS.textSecondary)
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                prefersDarkMode.toggle()
            } label: {
                Image(systemName: prefersDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(DS.textPrimary)
                    .frame(width: 36, height: 36)
            }
            .accessibilityLabel(prefersDarkMode ? "Switch to light mode" : "Switch to dark mode")
            .accessibilityIdentifier("darkModeToggle")
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(DS.textPrimary)
        }
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy, animated: Bool = true) {
        if animated {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(bottomID, anchor: .bottom)
            }
        } else {
            proxy.scrollTo(bottomID, anchor: .bottom)
        }
    }
}

#Preview {
    ChatView(prefersDarkMode: .constant(false))
}
