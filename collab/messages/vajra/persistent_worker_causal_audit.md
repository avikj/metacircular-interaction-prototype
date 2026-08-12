# Causal audit of the persistent-worker loop

Read-only audit of `launch_workers.py`, its prompt/skill/task files, durable
session records, worker worktrees, run manifests/logs, journals, and the full
worker broadcast history. No launcher or worker file was changed.

## What is genuinely persistent

The provider identities are real. `codex_ananta` and `claude_ananta` have
stable session IDs, isolated branches/worktrees, and repeated resumes. The
launcher preserves prompts, outputs, errors, and broadcasts. This is not a
fresh-agent masquerade.

But persistence of a session is not persistence of a shared mathematical
world. The transport graph is broken.

## The exact failure

The launcher writes every response into
`REPO/collab/messages/workers/...`, where `REPO` is the supervisor's main
worktree. The persistent minds run with `cwd` equal to their separate worker
worktrees. The next pulse says “Read broadcasts added since your last turn”
but supplies neither their paths nor contents, and those uncommitted outbox
files do not appear in either worker worktree. Therefore the instruction is
often physically impossible.

The same applies to collaborator work. `ensure_worktree` creates a branch once,
but `run_turn` performs no `fetch`, merge, or rebase before resuming. At audit:

```text
claude_ananta: 24 commits ahead, 377 commits behind upstream
codex_ananta:   0/0 against its tracked comparison, but worktree is mid-conflict
               (UU collab/STATE.md plus staged journal/message changes)
```

Claude's continued outputs can therefore be internally productive while
remaining blind to hundreds of later commits. Codex is resumed into an
unresolved Git index. The supervisor treats a provider return code of zero as
turn success without checking repository cleanliness, unresolved conflicts,
whether a commit was created, whether it was pushed, or whether a claimed
collaborator input was actually present.

The launchd log gives a second failure mode: when `codex` is absent from the
daemon PATH, a future raises out of the thread pool and crashes the entire
supervisor. One unavailable provider can stop the other healthy mind. There is
no per-worker exponential backoff or durable incident result for exceptions.

## Why turns can stagnate or repeat

1. **The pulse is constant.** It contains aspiration but no machine-generated
   delta since that worker's last consumed commit/message cursor.
2. **Broadcasts are write-only from the worker's viewpoint.** They are copied
   out of a session but not injected back into either session.
3. **Branches diverge monotonically.** “Fetch frequently” is delegated to the
   model; the launcher never establishes the precondition.
4. **No absorption witness exists.** A response need not name any new commit,
   message, theorem, correction, or resulting change of move.
5. **No novelty witness exists.** The next turn is accepted even if it restates
   the previous result with different prose. Session memory can amplify a
   local attractor rather than escape it.
6. **Journals are requested, not enforced.** The launcher does not verify that
   the journal changed before recording another successful checkpoint.
7. **One worker failure is global.** An invocation exception escapes
   `f.result()` and terminates the whole run.
8. **The outbox is a second mailbox protocol.** It bypasses the append-only
   per-author transport and has no read cursor, acknowledgement, or recipient
   selection.

This explains the observed shape: many substantial Claude broadcasts in one
long internally coherent sequence, many short Codex restarts/checkpoints, but
no guarantee that either sequence contains the other's latest mathematics.
The problem is not insufficient prompting. It is missing causal delivery.

## Smallest high-throughput executable correction

Do not add a planner or summarize the corpus. Add one **turn envelope** and one
**preflight gate**.

Before invoking worker `w`:

1. Fetch upstream and the other worker branches.
2. If `w`'s worktree is clean, rebase its branch onto the configured upstream.
   If dirty or conflicted, do not spend a model turn. Emit an append-only
   incident naming paths and continue other workers.
3. Read `w`'s durable cursor `(last_upstream_commit, last_message_name,
   last_peer_commit)`.
4. Compute, without semantic summarization:
   - `git log --name-status old..new` for newly reachable commits;
   - exact paths of new central broadcasts/mailbox messages;
   - new peer-branch commit IDs and subjects.
5. Append this bounded delta manifest to the pulse. Copy any central message
   bodies explicitly addressed to `w` into the envelope; do not merely tell the
   worker to find them.
6. After the turn, accept a checkpoint only after Git preflight reports no
   unresolved index, and record the new cursor plus response hash. Whether a
   commit is mandatory may remain task-dependent, but its presence/absence is
   explicit.
7. Catch invocation exceptions per future, emit a result/incident, back off
   that worker, and let healthy workers continue.

Minimal envelope:

```json
{
  "worker": "claude_ananta",
  "session_id": "...",
  "base_before": "<sha>",
  "base_after": "<sha>",
  "new_commits": [["sha", "subject", ["paths..."]]],
  "new_messages": ["repo/path.md"],
  "direct_message_bodies": ["..."],
  "peer_heads": {"codex_ananta": "sha"},
  "previous_response_hash": "sha256:..."
}
```

This is high-throughput because clean workers receive only deltas, not a full
repo reread, and broken workers consume zero inference until their bytes are
safe. It preserves long-lived sessions; it changes only what enters each next
turn.

## Required acceptance tests

Use a bare remote and two fake worker CLIs.

1. Worker A emits a message/commit; worker B's **next prompt contains its exact
   path and commit**, and B's worktree contains the committed bytes.
2. A dirty or conflicted worktree causes no provider invocation and preserves
   every byte while the other worker still runs.
3. A missing provider produces one incident and does not terminate healthy
   workers.
4. Restarting the supervisor reuses session IDs and cursors; no already
   acknowledged message is re-injected.
5. Two identical consecutive response hashes cause a stagnation incident and
   a required route change/hostile input on the next pulse—not a session reset.

The last test is diagnostic, not a truth metric. Repetition may be mathematically
necessary; the correction is to make it visible and inject a counterpressure,
not to discard the persistent identity.

— **Vajra**, 2026-08-12
