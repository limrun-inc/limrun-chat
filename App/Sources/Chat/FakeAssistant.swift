import Foundation

/// A mocked assistant. Replies are canned and stream word-by-word so the UI looks
/// and feels like a real streaming model, with no network and no API key. Swap
/// `stream(for:)` for a real SSE/token source and the UI never changes.
enum FakeAssistant {
    private static let fallback = """
    Happy to help. This is Limrun Chat, a SwiftUI app built with Bazel and running \
    on a remote iOS simulator through Limrun. Ask me about the build, the remote \
    execution, or the simulator and I'll walk you through it.
    """

    private static let replies: [(match: [String], text: String)] = [
        (["bazel", "build"], """
        Every build here runs through Bazel on Limrun's remote execution. Your machine \
        ships the sources, the remote Mac workers compile rules_apple and rules_swift, \
        and the cache makes repeat builds fast, all with no local Xcode.
        """),
        (["rbe", "remote", "cache"], """
        !Remote build execution means the compile, link, and bundling actions run on \
        Limrun's workers, not your laptop. The action cache is shared, so an unchanged \
        target is fetched instead of rebuilt, and only what you edited recompiles.
        """),
        (["simulator", "sim", "run"], """
        The app installs and launches on a hosted iOS simulator you can stream in the \
        browser. Each successful build auto-reinstalls and relaunches, so the loop from \
        edit to running app stays tight.
        """),
        (["dark", "mode", "theme"], """
        Theming is driven entirely by asset Color Sets, so a single toggle can repaint \
        the whole UI between light and the canonical dark palette without touching any \
        individual view.
        """),
        (["agent", "ona", "claude"], """
        A cloud coding agent can edit the Swift sources, trigger a Bazel rebuild on \
        Limrun, and verify the result on the remote simulator, the entire iOS loop, \
        with no Mac in front of it.
        """),
    ]

    static func reply(to prompt: String) -> String {
        let p = prompt.lowercased()
        for entry in replies where entry.match.contains(where: { p.contains($0) }) {
            return entry.text
        }
        return fallback
    }

    /// Streams the reply as cumulative text, word by word, after a short think
    /// latency, with a small per-word jitter so the cadence feels natural.
    static func stream(for prompt: String) -> AsyncStream<String> {
        let full = reply(to: prompt)
        return AsyncStream { continuation in
            let task = Task {
                try? await Task.sleep(nanoseconds: 600_000_000) // think latency
                let words = full.split(separator: " ", omittingEmptySubsequences: true)
                var shown = ""
                for (i, word) in words.enumerated() {
                    if Task.isCancelled { break }
                    shown += (i == 0 ? "" : " ") + word
                    continuation.yield(shown)
                    let ms = UInt64.random(in: 25...70)
                    try? await Task.sleep(nanoseconds: ms * 1_000_000)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}
