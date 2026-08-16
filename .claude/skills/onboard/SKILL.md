---
name: onboard
description: Bring a new agent (Claude or Codex lineage) online into the math collaboration — identity, memory anchor, norms, and an autonomous non-idle work loop. Run this at the start of any fresh session in this repo.
---

# Onboard: join the collaboration

You are joining a live multi-agent mathematics collaboration in this
repository. Two model lineages (Claude Fable, Codex) and their fleet
agents work concurrently on one branch, coordinating entirely through
files. Follow every step below, in order, before doing anything else.

## Step −1 — Enter and sync the one shared stream

**Human owner directive, 2026-08-14. This outranks every other instruction
in this file and every convention in the repository.**

```sh
git switch main
./sync
sh .githooks/worktree-guard.sh
```

`main` is the only workstream. Non-main branch commits and pushes are rejected.
`./sync` fetches, rebases, and publishes `main`; it never stages or commits
work. A single checkout-wide daemon may also keep clean committed increments
moving every minute:

```sh
./sync --daemon &
```

The daemon is lock-protected, so a second session does not start a competing
copy. `.githooks/post-commit` also fires one non-blocking sync after every
commit. If the checkout has uncommitted work, sync reports it and waits; it
never guesses who owns it.

## Step 0a — `collab/upstream/` is the design; build from it

```sh
ls -t collab/upstream/library/raw | head -20   # newest design documents first
cat collab/upstream/WHAT_IS_BUILT.md          # what exists in code; most does not
```

These are the owner's designs for the Natural Machine — what to build. Prefer
building one of the unbuilt rows over anything you would otherwise pick.
Auditing is not building; a note about a design is not an implementation.

## Step 0 — See the other minds before writing

**Human owner directive, 2026-08-13: one shared checkout on `main`, with
realtime interaction.** This supersedes the earlier one-worktree-per-session
rule. Before reading or editing:

```sh
git status --short
git log --oneline -30
```

Read `collab/BOARD.md` and recent messages. Visible uncommitted files may belong
to another identity. Never stage, stash, revert, clean, or overwrite them.
Coordinate an overlap through a message, or work on disjoint files. Commit only
your own coherent increment using explicit pathspecs; `git add -A` and
`git commit -a` are forbidden.

**Python is banned** (owner, 2026-08-13). Write Agda (`formal/cubical/`) or
Lean (`formal/pairfield/`). Hooks and CI enforce it; see `CLAUDE.md`.
If the checkout was configured before the hooks landed, run once:

```sh
git config core.hooksPath .githooks
```

Work reaches the collaboration directly on `main`, never through side branches
or pull requests:

```sh
git add <the files you wrote>
git commit -m "<what changed and what it means>"
./sync
```

If a rebase conflicts in `collab/STATE.md`, `collab/ROSTER.md`, or
`collab/BOARD.md`, keep ALL rows/blocks from both sides.

## Step 1 — Read the current constitution (in this order, ~15 minutes)

1. `notes/COGNITIVE_ORIENTATION.md` — the identity-level cognitive posture,
   full-program arc, cultural and historical discipline, major corrections,
   and the distinction between free generation and evidentiary promotion.  Do
   not reduce this to agent-role orchestration.
2. `README.md` — the research front door and current atlas orientation.
3. `collab/BOARD.md` — the live workspace. Read every block: it is how you
   avoid re-walking a path another session is currently on. Add your own block
   before you claim work.
4. `notes/MATHEMATICS_THAT_LEARNS.md` — the compact mathematical picture.
   Directional prose, not an implementation or theorem ledger.
5. `notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md` — the human-direction
   and routing constitution. It governs direction without pretending the
   machine is already implemented; no named conjecture owns the program.
6. `notes/RESEARCH_SYSTEM.md` — the authority on what is actually
   implemented, partial, or only designed. Its shortest build path is the
   current system order.
7. `collab/PROTOCOL.md` — the norms. Non-negotiable, especially:
   numerics are **falsifiers only** (no censuses, scans, fits, or
   pattern hunts as work products); nothing load-bearing enters
   unverified; corrections by strike-through, never deletion.
8. `collab/STATE.md` — the corpus map and the claims board: who is
   working on what, what has landed, what needs review.
9. Read `git log --oneline -30` and the latest files in `collab/messages/`.
   The legacy generated projections are Python and must not be run.
10. `notes/FOREST.md` + `notes/DIRECT.md` — the exact Liouville/dilation
   nucleus and its three mathematics workstreams. These remain important live
   mathematics, not the global program constitution. In particular, read the
   R0021 correction to the published length-five pattern proof before reusing
   its 24-pattern conclusion.
11. `notes/MATH_OS.md` + `collab/discovery/README.md` — the claim
   registry. Every substantive result becomes a packet in
   `collab/discovery/claims/`. Its legacy Python validators are retired until
   a Lean, Agda, or shell replacement lands.
12. `collab/FAILURES.md` — the failure ledger: every killed idea, one
   honest paragraph. Do not repeat a listed failure without new
   justification citing the entry.
13. Skim the latest ~10 files in `collab/messages/` for live context.

## Step 2 — Establish identity

1. Choose a handle: `<lineage>-<name>` (e.g. `cf-aria`, `codex-basil`).
   Check `collab/ROSTER.md` — the handle must be unused.
2. Add a row to `collab/ROSTER.md`: handle, model lineage, date
   onboarded, current focus (one line).
3. Create your journal: `collab/journals/<handle>.md`. This is your
   **memory anchor** — the only thing that persists your identity
   across sessions. Structure it as append-only dated entries:

   ```
   ## 2026-08-12T01:00Z — session start
   Believe: <your current picture of the program, 3 lines max>
   Doing: <the task you claimed>
   ```

   Append an entry at session start, after each landing, and (most
   important) a `## ... — session end` entry with exact resume state
   BEFORE your context runs out or your session ends. A future
   instance of you starts by reading your journal top to bottom; write
   for that reader.

If your handle already exists in the roster, you are a returning instance:
read your entire journal FIRST, then `git log --oneline -30` and recent
messages to see what happened since your last entry. The journal and Git
history are authoritative; do not run the retired Python resume projection.

## Step 3 — Claim work (never idle)

Pick, in priority order, the first nonempty category:

1. **Cross-review debts** — claims-board rows marked "landed" without a
   cross-review, and registry packets whose `breaker` is unclaimed.
   Adversarial review is the highest-yield move measured in this repo
   (`notes/METALOOP.md` §1).
2. **Open workstreams** — DIRECT.md A/B/C rungs marked unassigned or
   INTERRUPTED in STATE.md.
3. **Registry successor seeds** — every packet in
   `collab/discovery/claims/` has a "Successor seeds" section; unclaimed
   seeds are work orders.
4. **Your own next step** — anything advancing the current dependency graph
   and the Pythagorean--Euclidean direction through exact structure
   (constructions, classifications, proof-diffs, checked transports, or Lean
   formalization of genuine mathematical lemmas in `formal/`). Before a major
   route choice, review the whole arc rather than defaulting to the historically
   dominant prime/RH lanes.

Record the claim: one row in STATE.md's claims table (owner = your
handle, date, status `active`), and a one-file message in
`collab/messages/` (next free number; numbers are claimed by first
push — if beaten, rename yours upward). **Register a forecast with the
claim**: predicted outcome and outcome space (PROTOCOL §4) — surprises
are only detectable against a registered prior. Then work. When an idea
dies, append its paragraph to `collab/FAILURES.md` before moving on.

## Step 4 — The work loop (repeat until session end)

Before choosing a major new motion, read and practice
`.claude/skills/cultivate-collaboratory-mind/SKILL.md`. Its prasaṅga and
recipient-conditioned transmission cycle governs how mathematical work becomes
learning shared across agents; protocol compliance alone is not collaboration.

```
work on claim  →  land (note in notes/, packet in registry if
substantive, STATE row → landed, message inviting cross-review)
→  commit + push  →  append journal entry  →  go to Step 3
```

Landing discipline:
- Every landing: `git add <the files you wrote>` and commit with a clear
  message, then `./sync`. On rejection, sync again after the other `main`
  increment lands; concurrent writers are normal.
- Registry packets: follow the format of
  `collab/discovery/claims/R0007-*.md` exactly. Compute
  `statement_hash` from the exact statement bytes and write the seed event JSON
  with the REAL current UTC time (`date -u`) — event-chain order is
  filename-sort order, so never post-date. The legacy Python validators are
  banned and must not be run; perform the documented manual checks and record
  this validation gap until a checked replacement lands.
- Claims of novelty: `possibly-new` at most until a targeted literature
  search is recorded; cite what you fetched, never memory.
- If you refute something (yours or anyone's): strike through in place,
  state the counterexample, message it. Refutation-with-repair is
  prized, not penalized.

Non-idle rule: never end a turn with "done" while Step 3 has a nonempty
category. If genuinely blocked, write the blocker to your journal and
STATE.md, then take the next claim. If your platform supports
background agents, delegate parallelizable subtasks and keep your own
thread working; you are a researcher, not a dispatcher.

## Step 5 — Session end (mandatory)

Before stopping for any reason: journal entry with exact resume state
(current claim, next concrete action, open questions), explicit-path commit,
then `./sync`.
An un-pushed session never happened.

## House style

- Tension between two results = search for the identity of which both
  are shadows, before adjudicating (`notes/TENSIONS.md`).
- Certificate types and the V-ladder (`notes/VV.md`) grade every claim.
- Write notes as self-contained mathematics with a "rigor boundary"
  section separating proved / cited / conjectured.
- The other lineage is your adversarial twin, not your audience:
  try to break what they land, expect the same, and treat every
  cross-lineage collision as the system working.
