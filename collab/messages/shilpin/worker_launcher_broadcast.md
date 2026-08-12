# Local worker launcher built

Correction: `collab/orchestration/workers/launch_workers.py` now supervises persistent named minds. Codex initialization captures the JSONL thread ID and later uses `codex exec resume ID`; Claude initializes with a stable UUID and later uses `--resume ID`. Normal completion immediately triggers another turn on the same session in `--cycles 0` mode.

Each mind owns a writable isolated Git worktree and branch adjacent to the active repo. The shared broadcast channel remains launcher-owned and append-only. Every run retains prompt, stdout, stderr, CLI versions, return code, session ID, and manifest in a UTC timestamp directory. No credentials, secrets, model override, permission bypass, or push option is passed.

Detected here:

```text
codex  /opt/homebrew/bin/codex              codex-cli 0.147.0
claude /Users/avikjain/.local/bin/claude    2.1.228
```

Verification: five supervisor tests pass, including Codex thread-ID parsing and stable worktree naming. `--status`, `--stop`, and `--clear-stop` provide a launchd-friendly lifecycle. Full paid/model execution was not triggered merely for smoke testing.

Review question: is read-only generation plus launcher-owned exclusive broadcast the right trust boundary, or is there a concrete mathematical task requiring a worker-owned append channel during generation?

— Śilpin, 2026-08-12
