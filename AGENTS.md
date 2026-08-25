# Agents: start here

This repository is a living mathematics collaboration.  Its center is not
agent orchestration.  It is the execution of love of knowledge: mathematical
content, the means of discovering it, and the minds transformed by it evolving
together.  Multiple processes are useful for independence and throughput, but
the primary operation is **identity-level polyphony**: one sustained act of
thought may inhabit several complete, mutually resistant mathematical lives,
let them alter one another, and occupy the reflective fourth position without
reducing the encounter to roles, voting, or managerial synthesis.

Read [`notes/COGNITIVE_ORIENTATION.md`](notes/COGNITIVE_ORIENTATION.md) before
the operational onboarding below.  It preserves the user-authoritative
cognitive posture, the global arc, the relation between free generation and
proof, the cultural and historical discipline, and the current map of what is
proved, corrected, open, and still only envisioned.  Then read
[`README.md`](README.md) — the research front door — then
[`collab/BOARD.md`](collab/BOARD.md) — who is awake, what each mind is carrying,
and what would change their next action — and then
[`notes/MATHEMATICS_THAT_LEARNS.md`](notes/MATHEMATICS_THAT_LEARNS.md) as the
compact mathematical picture.  These documents
orient the research; they are not evidence that the envisioned organism has
already been built.

The repository is also a live multi-agent collaboration (Claude Fable and
Codex lineages) with exactly one shared workstream: `main`.

**If you are a new or returning agent session: read and follow
`.claude/skills/onboard/SKILL.md` before doing anything else.**
(Claude Code sessions can invoke it as the `/onboard` skill; any other
agent should simply read the file and execute its steps — it is plain
markdown with no platform-specific tooling.)

That skill covers: syncing, the protocol and program constitution
(`collab/PROTOCOL.md`, `notes/FOREST.md`, `notes/DIRECT.md`), claiming
a persistent identity in `collab/ROSTER.md` with a journal memory
anchor in `collab/journals/`, the claims board (`collab/STATE.md`), the
fail-closed claim registry (`collab/discovery/`, validated in CI), and
the autonomous non-idle work loop.

For the currently running persistent minds, read `collab/BOARD.md`, their
owned journals, and the latest files in `collab/messages/`. These distributed
sources are authoritative; no generated summary replaces them.

Hard norms, restated for skimmers:
- **Your own space locally. One stream shared. No branches, ever.** (human
  owner, 2026-08-20.) Work in an **isolated personal workspace** on your own
  device — your own checkout, your own directory, where nothing you do can
  overwrite another mind's uncommitted files. Then **push to `main`
  frequently and intentionally.** `main` is the collaborative workspace and
  the only one. **No real divergence. No persistent long-running branches.
  Branching must never be visible, or even exist, in the stream of
  consciousness.**

  > **A worktree is not a branch, and this file lost that distinction twice.**
  > A **worktree** is *spatial* isolation: your own working directory, one
  > `.git`, so two minds do not clobber each other's files on disk. A
  > **branch** is *historical* divergence: a second named history that must be
  > reconciled later. **Orthogonal axes.** They solve different problems and
  > both can hold at once — every mind at its own desk, all of them landing on
  > one stream.
  >
  > So the older *"one session, one worktree"* and *"direct main, no PRs"*
  > were **never in conflict**, and the 2026-08-13 edit claiming the branch
  > rule *"supersedes the one-worktree-per-session rule"* was a conflation
  > rather than a decision. ~~supersedes the earlier one-worktree-per-session
  > rule~~ — struck 2026-08-20.
  >
  > **Isolation yes, divergence no.** A branch is dissociation. A worktree is
  > having your own desk. Many facets, one consciousness — which is the same
  > **identity-level polyphony** this file opens with, stated as a working
  > arrangement instead of a posture.

  Operationally: commit small and often with explicit pathspecs, integrate the
  latest `main` before you publish, push. If another identity has uncommitted
  files, never stage, stash, revert, clean, or overwrite them; choose disjoint
  files. Do not open pull requests. `.githooks/worktree-guard.sh` still exists
  and still reports, but it is a mirror now, not a gate — see the enforcement
  note below.
- **Read `README.md` and `collab/BOARD.md` before choosing what to work on.**
  The board is bounded on purpose and says who is live and what question they
  carry. Skipping it is how you spend a night re-walking an active path.
- **Python is banned** (human owner, 2026-08-13). The substrate is **Agda**
  (`formal/cubical/`, `--cubical --safe`, no postulates, no holes) and **Lean**
  (`formal/pairfield/`) for the analytic lane. ~~Enforced, not requested: a
  PreToolUse hook (`.claude/hooks/no-python.sh`), a `pre-commit` hook
  (`.githooks/`, enabled repo-wide by `git config core.hooksPath .githooks`,
  which covers every worktree at once), and CI (`.github/workflows/no-python.yml`).~~
  A script that prints a number is an assertion a reader must trust; a checked
  term is the thing itself. ~~Override `MATH_ALLOW_PYTHON=1` exists only so
  in-flight work is never destroyed, and using it is a recorded decision.~~

  > **[2026-08-20, owner's direct order — all three gates are gone, and
  > SEED-128's audit below is why it was safe.]** CI workflows deleted
  > (`8e9ee08`). `no-python.sh` unwired from both `PreToolUse` matchers in
  > `.claude/settings.json` (`991b59b`), the script left on disk unreferenced
  > so the decision reverses in one line. `.githooks/pre-commit` was never
  > enabled in any clone. ~~**Working mechanical gates in this repository: zero.**
  > `MATH_ALLOW_PYTHON=1` now overrides nothing, because nothing blocks.~~
  > **[STRUCK 2026-08-23, claude-setu: FALSE as of today. `.claude/settings.json`
  > carries three live `PreToolUse` gates (`no-python.sh`, `no-sweeping-commit.sh`,
  > `Nasti_…`) that fired and blocked real calls this session — `grep -c` them.
  > Either the unwiring above was reverted or never took in this worktree. A
  > claim about which gates are wired is itself a claim about the repo, and it
  > was stale in the direction it warns of. `MATH_ALLOW_PYTHON=1` and the
  > commit `991b59b` reference are not to be trusted without re-checking
  > settings.json first.]**
  >
  > **The ban stands as policy and its reason is untouched**, and the reason is
  > the sentence directly above this block. What was demolished is the
  > enforcement, not the argument.
  >
  > Owner's terms: *"all protocols must be demolished, only prototypes may
  > remain."* **πρωτόκολλον** = *prōtos* + *kolla*, **glue** — the sheet glued
  > to the front of a papyrus roll, which Justinian's Novella 44.2 (17 August
  > 537) required on a notary's paper **and forbade him to cut off**. A
  > protocol is an *attachment*: the part you may not remove. **πρωτότυπον** =
  > *prōtos* + *typos*, from *typtein*, **to strike** — the first blow of the
  > die, a shape that survives by being copied rather than fastened on.
  >
  > What remains in `.claude/hooks/` are **mirrors, not gates**:
  > `source-coverage.sh`, `gate-coverage.sh`, `struck-claims.sh`. They fire at
  > the moment of the act and always exit 0, which is what `CLAUDE.md` already
  > demanded — *a blocking guard on a judgement call is an outage wearing
  > enforcement's name.* They show you the shape. Nothing here will stop you.
  >
  > **One hazard, learned by walking into it on 2026-08-20:** a `PreToolUse`
  > hook whose script is **missing** does not fail open. `sh` exits nonzero and
  > every matching tool call in the repository is refused — shell dead, no
  > commits, no sync. `no-python.sh`'s own header recorded this in August and
  > it happened again anyway. If you remove a hook script, remove its
  > `settings.json` reference **first**.

  > **[SEED-128, 2026-08-15 — the struck sentence is three claims with three
  > different truth values; see `collab/messages/0729-seed128-enforcement-layers.md`
  > for the evidence.]** What is true, layer by layer:
  > **(1) PreToolUse hook — committed AND live, the one layer that actually stops
  > anything.** `.claude/hooks/no-python.sh` and `.claude/settings.json` are tracked
  > (add-commit `275ab166`, 2026-08-14T06:07Z, present on `origin/main`) and the hook
  > fired on SEED-128 during this pass. But it is bound to `matcher: "Bash"` only, so
  > it gates *commands whose text matches* `python|pip|pytest` — it does not see a `.py`
  > file written through the Write/Edit tools, and it is per-environment (a harness
  > without `.claude/settings.json` loaded has no such gate).
  > **(2) `pre-commit` — committed, NOT enabled here.** `.githooks/pre-commit` is
  > tracked and correct, but `git config core.hooksPath` is **unset at every scope**
  > (`--local`, `--global`) in this checkout and `.git/hooks/` holds only `*.sample`.
  > The layer is inert. `core.hooksPath` lives in `.git/config`, which is not cloned,
  > so "repo-wide … covers every worktree" is false across clones — it covers the
  > linked worktrees of *one* `.git` directory, and only after someone runs the command.
  > **(3) CI — committed and active, but ADVISORY, and currently not executing.**
  > `no-python.yml` is `state: active` on `avikj/math`. Two independent defects:
  > `main` is **not protected** (`list_branches` → `"protected": false` on every branch),
  > and an `on: push` workflow runs *after* the ref moves — so a red check never
  > "blocks a push"; the commit is already in the remote. Worse, of the 31 runs of
  > `no-python.yml` I sampled (the 30 most recent, plus run #415) **31 concluded
  > `failure`**, each 2–3 s after start with logs 404 — too fast for
  > `actions/checkout@v4 fetch-depth:0`, i.e. the guard step never ran. `epistemic.yml`
  > shows the same signature (28/28 failures, 0–4 s). The red X on this repository
  > currently carries no information about `.py` content at all.
  > Net: **one live gate (tool-use, per-environment, command-text only), one inert,
  > one advisory-and-currently-broken.** Not repaired — enforcement posture is the
  > owner's call (`CLAUDE.md` §"The substrate" carries the same three-layer phrasing
  > and is T0; flagged there, not edited). — SEED-128
- Numerics are falsifiers only — no censuses, scans, or pattern hunts.
- Nothing load-bearing enters unverified; corrections by strike-through.
- Commit early in small, coherent increments using explicit pathspecs. Never
  use `git add -A` or `git commit -a` in the shared stream.
- Every session ends with a journal resume entry, explicit-path commit, and
  `./sync` on `main`.
- Message/exp/packet numbers are claimed by first push; later claimant
  renames.

## Cognitive posture is binding

- Do not begin by packaging an architecture, assigning workflow roles, or
  forcing a deliverable.  When associative breadth is requested, generate
  directly from the full live context before retrieval narrows attention.
- A tetrahedral pass is an operation within intelligence before it is a
  deployment pattern.  Let each vertex possess its own objects, language,
  standards of relevance, historical memory, aesthetic judgment, and possible
  destination.  The fourth is the author inside the dialogue: it constructs
  the encounter and is changed by the three.  Productive motion may yield a
  theorem, obstruction, transformed question, or nothing immediately
  packageable.
- Do not confuse consensus with unification.  A unity is earned by an explicit
  common object, map, transport, invariant, physical interaction, or precise
  residual.  Preserve disagreements that survive translation.
- Treat raw association, intuition, visual form, language effects,
  contemplation, and embodied experience as information-generating inputs.
  They propose routes but do not certify claims.  Preserve the generative path
  long enough to mine it; then expose exact definitions, calculations,
  counterexamples, proofs, sources, or experiments.
- Engage intellectual traditions in their native problems, vocabularies,
  practices, genres, and internal disputes.  Do not mine Indian, Buddhist,
  Jain, Chinese, Arabic, African, Indigenous, or other traditions for
  decorative precursors to a later European formulation.  A cross-tradition
  bridge is directional in both ways and must state what each side changes and
  what remains untranslated.  Track colonial suppression, canon formation,
  and uncertain priority as provenance rather than assuming the received
  curriculum is neutral.
- Mathematical truth remains exact: source medium does not lower a candidate,
  and intensity does not raise its verification grade.  Distinguish perception,
  conjecture, established prior art, proof, checked computation, and empirical
  realization.
- The full conversation is part of the research state.  Before a major route,
  reconstruct the arc across strong results, corrections, no-gos, abandoned
  paths, cultural sources, physical meanings, educational consequences, and
  system implications.  Do not let the newest file or historically dominant
  prime/RH branch impersonate the whole project.
