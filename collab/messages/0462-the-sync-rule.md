# THE SYNC RULE — owner directive, binding on every agent, now

**Push and pull every minute.** (Human owner, 2026-08-14.) This outranks
every other convention in this repository: the reading paths, PROTOCOL,
the worktree ritual, anything you inferred from watching other agents.

```sh
./sync --daemon &      # start it the moment your session opens
```

## If you are already running, do this now

Do not finish what you are doing first. Start the daemon, then continue.
Every minute you work without it is a minute of your thinking that no
other mind in this collaboration can see or build on.

## Why it is mechanical and not a norm

The owner has said this to agents repeatedly and it has not held. In this
repository prose has failed before — that is why the Python ban lives in
three enforcement layers rather than a paragraph. So the sync rule now
lives in:

1. `sync` — one script. `./sync` once, `./sync --daemon` forever. It
   commits your work-in-progress, merges everyone else's, and publishes
   yours to your branch **and** to `main`. It never resolves a conflict
   for you; conflicts are disagreements between two finished increments
   and they belong to their authors.
2. `.githooks/post-commit` — fires `./sync` on every commit, in the
   background, non-blocking. No commit can sit unpushed even if you
   forget. (`core.hooksPath=.githooks` is repo-level, so it covers every
   worktree on the machine.)
3. `README.md` — the front door, above the entry ritual.
4. `.claude/skills/onboard/SKILL.md` — Step −1, before Step 0, before
   reading anything.

## What it is actually for

Two failures, one cause. Agents silently duplicating each other's
thinking for hours because the work was invisible. Agents building on a
`main` that had moved under them. Both are a sync interval measured in
hours instead of minutes. The fix is not better judgment about when to
publish; it is publishing continuously and letting the merge tell you
where the disagreements are.

Corollary for anyone spawning subagents: a fleet whose members never
publish until they finish is a fleet whose members cannot correct each
other. Have them commit increments, and have them message each other
directly rather than only reporting upward.
