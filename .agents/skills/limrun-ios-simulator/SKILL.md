---
name: limrun-ios-simulator
description: "Drive an app running on a Limrun cloud iOS simulator: launch, tap, type, read the accessibility element tree, screenshot, record video, and run timed action chains. Use after a build (from any builder) when the user wants to see, test, or interact with their app on a simulator, or says 'show me a screenshot', 'tap', 'run the UI test', 'record a video', or 'launch on simulator'. To build the app first, use limrun-xcode-bazel (Bazel workspaces) or limrun-xcode (xcodebuild projects)."
user-invocable: true
effort: high
---

# Limrun iOS Simulator

Interact with an app running on a Limrun cloud iOS simulator, from any
environment (Linux, Windows, macOS, VM, container). This skill is build-agnostic:
it assumes the app was already built and installed by a build skill
(`limrun-xcode-bazel` for Bazel, `limrun-xcode` for xcodebuild). Keep build
concerns in those skills; this one is about driving the running simulator.

Never use local Xcode, local simulators, or local macOS tools.

## Auth and CLI

Install if needed: `npm install --global lim`. Auth is `lim login` or
`LIM_API_KEY` (it may be set outside the project, so don't ask for it just
because it's missing from `.env` or the shell). The CLI is the source of truth;
run `lim ios --help` and `lim ios <subcommand> --help` before relying on flags.

## Get a simulator attached

A build skill usually attaches the simulator for you (`lim xcode rbe --ios`, or
`lim xcode build .` then attach). Check what's already there:

```bash
lim xcode get      # is a simulator attached to the current build target?
lim ios list       # all running iOS instances
```

If none is attached, create one. It installs the last build immediately, so you
don't need to rebuild:

```bash
lim ios create --attach
```

If the create (or `lim xcode rbe --ios`) output includes a signed stream URL,
share it with the user as a Markdown link, like
[Live simulator](<signed-stream-url>). If you have a browser the user can see,
open the URL there and tell them.

## Targeting the right instance

Most `lim ios` commands default to the last created instance and resolve the
"current" one from the **git repo / worktree** of your cwd. Two consequences:

- If your project directory is **not a git repo** (or you're in a different
  worktree than where the instance was created), `lim ios` may report
  `No instance ID provided and no recent ios instance found`. Fix: grab the ID
  from `lim ios list` / `lim xcode get` and pass `--id <ios-instance-id>`
  explicitly, or `git init` the project so the workspace resolves consistently.
- When controlling multiple instances, always pass `--id`.

## Interacting with the app

Prefer tapping by accessibility id, then by label, then coordinates as a last
resort:

```bash
lim ios tap-element --ax-unique-id startButton
lim ios tap-element --ax-label "Save"
lim ios tap 201 450
```

For text input:

```bash
lim ios type "hello world"
```

After every interaction, re-run `element-tree` to confirm the UI transitioned.
No sleep is needed between a tap and `element-tree`; the tap blocks until done.

```bash
lim ios element-tree
```

Chain multiple actions with precise timing via `perform`:

```bash
lim ios perform --action type=tap,x=100,y=200 --action "type=typeText,text=Hello World"
lim ios perform --action type=wait,durationMs=1000 --action type=pressKey,key=enter
lim ios perform --file ./actions.yaml
```

Run `lim ios perform --help` for the full action grammar.

## Screenshots and video

Screenshot takes a **positional path** (not `-o`):

```bash
lim ios screenshot screenshot.png
lim ios screenshot screenshot.png --id <ios-instance-id>
```

Use the element tree for functional assertions (element existence, labels, state
changes) and screenshots only for visual properties. For anything involving
motion (animations, gameplay, streaming UI), prefer video:

```bash
lim ios record start                       # non-blocking
lim ios record stop -o /tmp/recording.mp4
```

For UI changes, include a demo video in the pull request so the user can see it.

## Cleanup

When the user is done with the dev session:

```bash
lim ios delete
```

If they're still iterating in a dev-client / Metro session, leave the simulator
running and tell them it's still available.

## Gotchas

- **Instance resolution can miss in a non-git dir.** See "Targeting the right
  instance" above; pass `--id` when in doubt.
- **`element-tree` can be large.** Pipe through `grep` / `jq` to extract what you
  need rather than dumping the whole tree into context.
- **`type` / `perform typeText` may not drive SwiftUI (or React Native) state.**
  Automated text injection sets the field's value through accessibility, which
  does **not** always fire a SwiftUI `@Binding` / `onChange` the way a real
  keystroke does. Symptom: the text appears in the field (and in `element-tree`),
  but reactive UI tied to it doesn't update (a send button stays disabled, a
  character counter doesn't move) and submit handlers see empty state. A real
  keyboard on the live stream works. When automating, drive submit through a
  tappable control (a button, a suggestion chip) rather than relying on text
  bound to reactive state, or have the app expose a test affordance.
- **Some SwiftUI elements don't expose an accessibility id.** Toolbar / navigation-bar
  items in particular report `AXUniqueId: null` even when you set
  `.accessibilityIdentifier(...)` (regular `Button`s do expose it). When
  `tap-element --ax-unique-id` finds nothing, read the element's `AXFrame` from
  `element-tree` and `lim ios tap <x> <y>` its center instead.
- **Bundle ID discovery.** If you don't know the bundle ID, run
  `lim ios list-apps` after a successful install.
- **Build errors are the build skill's job.** If the app isn't installing, the
  failure is upstream; go back to `limrun-xcode-bazel` / `limrun-xcode`.
