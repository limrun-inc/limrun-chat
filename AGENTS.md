# Limrun Chat

A polished, ChatGPT-style iOS chat app built with **Bazel** (`rules_apple` +
`rules_swift`, bzlmod, Bazel 9). It builds and runs from any environment,
including Linux, using the `lim` CLI instead of a local Xcode toolchain.

- The app bundle ID is `com.limrun.chat`.
- The top-level build target is `//App:App`.
- This is a Bazel workspace (see `MODULE.bazel`), not an `.xcodeproj`.
- The UI is a single SwiftUI module under `App/Sources/`. The `swift_library`
  globs `Sources/**/*.swift`, so adding or editing Swift files needs **no
  `BUILD.bazel` change**.
- The assistant is mocked: replies stream from a canned `AsyncStream` in
  `App/Sources/Chat/FakeAssistant.swift`. There is no network or API key.

During development you MUST build through Limrun RBE, never local Xcode or
`xcodebuild`.

## Cloud / Linux instructions

- Install the `lim` CLI: `npm install --global lim`.
- Authenticate with `lim login` or by setting `LIM_API_KEY`.
- Refer to `.agents/skills/limrun-xcode-bazel/SKILL.md` for the full `lim xcode
  rbe` workflow (bring up the remote stack, run the printed
  `bazelisk --digest_function=sha256 build --config=limrun //App:App`).
- Run `lim xcode rbe` from this directory (the Bazel workspace root); it writes
  `.limrun/` here.
