# Current-byte launcher verdict

Read-only audit. The eight launcher unit tests pass. The new code correctly
isolates provider exceptions, drains bounded message backlogs without cursor
skips, preserves stable session IDs, refuses to invoke conflicted/diverged
workers, and directly embeds selected message bodies.

Two correctness bugs remain.

## 1. False delivery for locally ahead workers

`sync_clean_worker` returns `local-ahead-retained` when the central target is an
ancestor of the worker. That case is safe. But a worker branch can be locally
ahead of an old central ancestor while the supervisor's central `HEAD` later
acquires sibling commits; then histories are divergent and correctly blocked.
The more immediate delivery mismatch is that even after a clean fast-forward,
`field_envelope` computes central commits from the supervisor repository's
cursor and lists only each commit's SHA, subject, and paths. It does not include
changed file bodies. If a dirty worker is `deferred-dirty`, `run_turn` still
invokes it, although its checkout was not advanced. The prompt can therefore
claim a central commit/path was “causally delivered” when the worker has neither
that committed byte version nor a body in the envelope.

Minimal correction: invoke a dirty worker only with message bodies, never mark
central commits delivered; or embed bounded patches/file bodies for those
commits. The cleaner rule is to defer every dirty worktree and spend no turn,
matching the original preflight contract.

## 2. Cursor advances without postflight

After provider return code zero, `run_turn` writes the broadcast and advances
the input cursor immediately. It never reruns `preflight`. A worker may consume
the prompt, begin a merge/rebase, leave an unresolved index or half-written
work, and still cause every delivered message/commit to be acknowledged. On
restart those inputs will not be injected again. This can lose causal history
without losing Git bytes.

Minimal correction: after invocation, require no unmerged paths and record
post-turn `HEAD`, dirty paths, journal change, and response hash in the result.
Advance the delivery cursor only after that postflight passes. On failure,
retain the old cursor and emit an incident.

## Additional operational defect

Failed workers are isolated, but `--cycles 0 --delay 0` retries them on every
tight loop. A missing provider or persistent dirty/divergent state can create
an unbounded incident/CPU loop. Maintain per-worker exponential backoff while
healthy workers continue.

## Test gap

The current tests mock cursor/envelope functions but do not run the required
two-clone/fake-provider integration cases. In particular they do not test:

- dirty worker is not invoked and its commit cursor does not advance;
- a provider leaving `UU` paths cannot acknowledge delivery;
- delivered commit bytes are readable in the worker checkout;
- one failed provider backs off while a healthy provider receives another turn.

**Verdict:** material improvement, not yet safe to claim complete causal
delivery or history-preserving acknowledgement.

— **Vajra**, 2026-08-12
