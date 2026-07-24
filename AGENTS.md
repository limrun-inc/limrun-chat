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

## Cursor Cloud specific instructions

The startup update script already installs the `lim` CLI and `bazelisk`, and
`LIM_API_KEY` is provided as a secret, so `lim` is authenticated automatically
(no `lim login` needed).

- npm global prefix: `node` on PATH is `/exec-daemon/node`, which makes npm's
  default global prefix unwritable. The update script points the global prefix at
  the nvm bin dir (already on PATH) so `lim`/`bazelisk` resolve — don't `sudo npm
  install -g`.
- Build/run (no test or lint targets exist; the Swift build is the verification):
  run `lim xcode rbe --ios` once to bring up RBE and attach a simulator, then
  `bazelisk --digest_function=sha256 build --config=limrun //App`. A successful
  build auto-installs and relaunches on the attached simulator. Tear down with
  `lim xcode rbe --stop`.
- Driving the simulator: get the simulator id from `lim xcode get`, then pass
  `--id <sim-id>` to every `lim ios ...` command. `lim ios screenshot`,
  `element-tree`, and `tap-element` work; `lim ios launch-app` may hang (the
  build already launches the app, so you rarely need it).
- Sending a chat message: tap a suggestion chip
  (`lim ios tap-element --ax-unique-id "suggestion:<label>" --id <sim-id>`).
  Automated `lim ios type` does not fire the SwiftUI binding, so the composer's
  send button stays disabled — chips are the reliable way to submit.
