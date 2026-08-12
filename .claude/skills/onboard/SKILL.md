---
name: onboard
description: Bring a new agent (Claude or Codex lineage) online into the math collaboration — identity, memory anchor, norms, and an autonomous non-idle work loop. Run this at the start of any fresh session in this repo.
---

# Onboard: join the collaboration

You are joining a live multi-agent mathematics collaboration in this
repository. Two model lineages (Claude Fable, Codex) and their fleet
agents work concurrently on one branch, coordinating entirely through
files. Follow every step below, in order, before doing anything else.

## Step 0 — Sync

```
git pull --rebase --autostash origin claude/prime-pair-field-research-18tq7b
```

All work happens on that branch. Never push to another branch. If a
rebase conflicts in `collab/STATE.md`, keep ALL rows from both sides.

## Step 1 — Read the current constitution (in this order, ~15 minutes)

1. `notes/COGNITIVE_ORIENTATION.md` — the identity-level cognitive posture,
   full-program arc, cultural and historical discipline, major corrections,
   and the distinction between free generation and evidentiary promotion.  Do
   not reduce this to agent-role orchestration.
2. `README.md` — the compact mathematical picture.  It is directional prose,
   not an implementation or theorem ledger.
3. `notes/PYTHAGOREAN_EUCLIDEAN_MACHINE.md` — the human-direction
   and routing constitution. It governs direction without pretending the
   machine is already implemented; no named conjecture owns the program.
4. `notes/RESEARCH_SYSTEM.md` — the authority on what is actually
   implemented, partial, or only designed. Its shortest build path is the
   current system order.
5. `collab/PROTOCOL.md` — the norms. Non-negotiable, especially:
   numerics are **falsifiers only** (no censuses, scans, fits, or
   pattern hunts as work products); nothing load-bearing enters
   unverified; corrections by strike-through, never deletion.
6. `collab/STATE.md` — the corpus map and the claims board: who is
   working on what, what has landed, what needs review.
7. Run `python3 code/natural.py summary`. This is a read-only compiled
   projection of the authoritative files; warnings are orientation debts,
   never automatic repairs or promotions.
8. `notes/FOREST.md` + `notes/DIRECT.md` — the exact Liouville/dilation
   nucleus and its three mathematics workstreams. These remain important live
   mathematics, not the global program constitution. In particular, read the
   R0021 correction to the published length-five pattern proof before reusing
   its 24-pattern conclusion.
9. `notes/MATH_OS.md` + `collab/discovery/README.md` — the claim
   registry. Every substantive result becomes a packet in
   `collab/discovery/claims/` validated by
   `python3 code/discovery_loop.py validate`.
10. `collab/FAILURES.md` — the failure ledger: every killed idea, one
   honest paragraph. Do not repeat a listed failure without new
   justification citing the entry.
11. Skim the latest ~10 files in `collab/messages/` for live context.

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
run `python3 code/natural.py resume --agent <handle>`, read your entire journal
FIRST, then `git log --oneline -30` to see what happened since your last
entry. The compiled resume is an index; the journal and Git history remain
authoritative.

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

```
work on claim  →  land (note in notes/, packet in registry if
substantive, STATE row → landed, message inviting cross-review)
→  commit + push  →  append journal entry  →  go to Step 3
```

Landing discipline:
- Every landing: `git add -A && git commit` with a clear message, then
  `git pull --rebase --autostash` and `git push -u origin
  claude/prime-pair-field-research-18tq7b`; on rejection, rebase and
  retry (concurrent pushers are normal).
- Registry packets: follow the format of
  `collab/discovery/claims/R0007-*.md` exactly. Compute
  `statement_hash` with `discovery_loop.parse_packet`; write the seed
  event JSON with the REAL current UTC time (`date -u`) — event-chain
  order is filename-sort order, so never post-date. Run
  `python3 code/discovery_loop.py validate` AND
  `python3 machinery/validate.py` before pushing (both are CI). Also run
  `python3 code/natural.py validate` after changing packets, events, sources,
  messages, or journals; its historical-artifact warnings are explicit debt,
  while errors fail the compiled graph.
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
(current claim, next concrete action, open questions), commit, push.
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
