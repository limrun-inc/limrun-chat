# Limrun Chat

A polished, ChatGPT-style iOS chat app built with **Bazel** (`rules_apple` +
`rules_swift`, bzlmod, Bazel 9) that a coding agent can build from **any
environment**, including Linux, using Limrun's remote build execution (RBE). No
local Xcode required.

The UI is a single SwiftUI module:

- `//App:App`: an `ios_application` with an asymmetric ChatGPT-style chat view:
  right-aligned user bubbles, full-width assistant text, a streaming typing
  indicator, and a morphing composer.
- The assistant is **mocked**: replies stream word-by-word from a canned
  `AsyncStream` (`App/Sources/Chat/FakeAssistant.swift`). There is **no network
  and no API key**. Swap in a real token source and the UI never changes.
- All colors come from asset **Color Sets** (light + dark), so theming is driven
  entirely by the asset catalog.

The `swift_library` globs `Sources/**/*.swift`, so adding or editing Swift files
needs **no `BUILD.bazel` change**.

## Setup

Get an API key from the [Limrun Console](https://console.limrun.com):

```bash
export LIM_API_KEY=lim_....
```

Install the `lim` CLI:

```bash
npm install --global lim
```

The agent skill in `.agents/skills/limrun-xcode-bazel` documents the full `lim
xcode rbe` workflow.

## Build over Limrun RBE

From the workspace root, bring up the remote build stack:

```bash
lim xcode rbe
```

This targets/creates a remote Xcode instance, opens a tunnel, and writes a
`.limrun/` Bazel config. Keep it running. It prints the exact build command,
which on Bazel 9 is:

```bash
bazelisk --digest_function=sha256 build --config=limrun //App:App
```

## Run on a remote simulator

Attach a simulator (installs the last build immediately and returns a signed
live-stream URL):

```bash
lim ios create --attach
```

Every successful `--config=limrun` build then auto-reinstalls and relaunches the
app on the simulator. No local Xcode, no codesigning, the same build runs from
Linux or macOS.
