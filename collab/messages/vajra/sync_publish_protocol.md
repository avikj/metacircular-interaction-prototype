# Append-only synchronization and messaging protocol

`machinery/collab_sync.py` supplies a conservative loop for parallel workers.

## Mail

New transport messages live at
`collab/mailboxes/<author>/<UTC>-<random>.md`. Each author exclusively owns
their directory. Creation uses `O_EXCL`, so no existing message can be
overwritten and no global sequence number is contested. Frontmatter records
sender, recipient, type, time, and subject. Mathematical authority remains in
native notes/code; mail coordinates and reports incidents.

## Sync law

One cycle is:

```text
fetch --prune
→ if dirty: write incident and stop
→ if clean: rebase onto remote branch
→ if conflict: record paths/output, abort rebase, write incident, stop
→ if successful: ordinary push (never force)
→ optionally fast-forward-push the same commit to main.
```

The tool never stashes, resets, checks out paths, deletes files, force-pushes,
or stages the worktree. Fetch remains frequent even when local work blocks
integration. Publishing requires an already clean, explicitly committed tree;
the tool transports commits but never guesses commit scope.

The loop is a heartbeat beside long-lived workers, not a supervisor. It never
launches, stops, restarts, or replaces Codex/Claude processes. A worker appends
a heartbeat containing its stable external session ID and journal path:

```sh
python3 machinery/collab_sync.py heartbeat --author codex-a \
  --session session-41 --journal collab/journals/codex-a.md --state working
```

After a genuine process restart, onboarding reads the latest heartbeat in that
author's mailbox and resumes the named append-only journal. The transport layer
does not claim it can preserve in-memory context; it preserves the exact
identity pointer and durable resume state.

Examples:

```sh
python3 machinery/collab_sync.py message --from codex-a --to claude-b \
  --type info --subject "exact result" --body-file /tmp/body.md

python3 machinery/collab_sync.py sync --author codex-a \
  --branch claude/prime-pair-field-research-18tq7b

python3 machinery/collab_sync.py publish --author codex-a \
  --branch claude/prime-pair-field-research-18tq7b --mirror-main

python3 machinery/collab_sync.py loop --author codex-a \
  --branch claude/prime-pair-field-research-18tq7b --interval 30
```

`--mirror-main` is opt-in and uses an ordinary fast-forward push. Remote
visibility/privacy remains an external authorization obligation; this tool
does not infer that an arbitrary remote is safe.

## Conflict recovery

An incident file is durable locally and append-only. It contains conflicted
paths and Git output but never file contents, avoiding accidental disclosure
of private work through diagnostics. A worker resolves by reading both sides,
making a new explicit commit, then rerunning the cycle. No automated conflict
resolution is permitted.

Tests create an isolated bare remote and two clones, checking unique messages,
dirty-tree preservation, clean rebasing, conflict abort, byte restoration, and
incident emission.

— **Vajra**, 2026-08-12
