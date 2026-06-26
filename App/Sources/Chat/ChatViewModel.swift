import SwiftUI
import UIKit

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message]
    @Published var draft: String = ""
    @Published var isResponding: Bool = false

    let suggestions = [
        "Explain Bazel RBE",
        "How fast are rebuilds?",
        "Run it on a simulator?",
    ]

    private var streamTask: Task<Void, Never>?
    private let impact = UIImpactFeedbackGenerator(style: .light)
    private let notify = UINotificationFeedbackGenerator()

    init() {
        // Pre-seed a short conversation so the very first frame looks alive.
        messages = [
            Message(role: .user, text: "What is Limrun Chat?"),
            Message(role: .assistant, text: "Limrun Chat is a SwiftUI demo app built with Bazel and run on a remote iOS simulator through Limrun, no local Mac required."),
            Message(role: .user, text: "How fast is an incremental rebuild?"),
            Message(role: .assistant, text: "A single-file change recompiles on Limrun's remote workers and reinstalls on the simulator in seconds, thanks to Bazel's shared cache."),
        ]
        impact.prepare()
        notify.prepare()
    }

    func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        draft = ""
        send(prompt: text)
    }

    func send(prompt: String) {
        guard !isResponding else { return }
        impact.impactOccurred()
        messages.append(Message(role: .user, text: prompt))
        respond(to: prompt)
    }

    func stop() {
        streamTask?.cancel()
        streamTask = nil
    }

    private func respond(to prompt: String) {
        isResponding = true
        let placeholder = Message(role: .assistant, text: "", isStreaming: true)
        messages.append(placeholder)
        let id = placeholder.id
        streamTask = Task { [weak self] in
            guard let self else { return }
            for await partial in FakeAssistant.stream(for: prompt) {
                if Task.isCancelled { break }
                if let idx = self.messages.firstIndex(where: { $0.id == id }) {
                    self.messages[idx].text = partial
                }
            }
            if let idx = self.messages.firstIndex(where: { $0.id == id }) {
                if self.messages[idx].text.isEmpty {
                    // Stopped before the first token arrived: drop the empty turn
                    // so no blank assistant bubble is left behind.
                    self.messages.remove(at: idx)
                } else {
                    self.messages[idx].isStreaming = false
                }
            }
            self.isResponding = false
            if !Task.isCancelled {
                self.notify.notificationOccurred(.success)
            }
        }
    }
}
