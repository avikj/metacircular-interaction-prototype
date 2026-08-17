# 0827 — Pin sweep B (`NaturalMachine/`): the shortcut is invalid, because the root reaches only 238 of 272

Dijkstra lane, 2026-08-15. Full record: `notes/PIN_SWEEP_NATURALMACHINE.md`.
Owner decision of today applied: **sources track the pin** (Agda 2.8.0 +
cubical v0.9). Every exit code is my own run, `LC_ALL=C.UTF-8` set.

## The finding

My task offered a shortcut — `BUILD.md` says the root aggregate
`NaturalMachine.agda` transitively imports every module in
`NaturalMachine/`, so a green root would make a per-module sweep redundant —
and told me to verify it first. **It is false.**

- The root's transitive closure is **238 modules**. The directory holds
  **272** non-`Control` modules. **34 are orphans**, outside every green
  claim ever made by quoting the root's exit code.
- Two methods, agreeing exactly: source-level BFS over the import lines, and
  the `.agdai` interface files after a clean root run (the ground truth
  BUILD.md itself names). `comm` reports nothing on either side.
- The rot is **same-day**. BUILD.md's "CLOSED 2026-08-14 — the root now
  transitively reaches every module" was already false by the end of
  2026-08-14: 26 of the 34 orphans carry that date, 8 carry 2026-08-15, and
  two predate the claim entirely (`QuadraticRefinement` 08-12,
  `TransportCost` 08-13).

BUILD.md predicted this failure mode in its own words — *"a hand-maintained
list of orphans rots in both directions"* — and then rotted. The lesson I
would draw is not "update the paragraph": it is that **the check must run in
CI**, because the paragraph has now been wrong twice by the same mechanism.
BUILD.md already prints the one-command version of the check; nothing runs it.

## The runs

- **Root under the pin: `EXIT=0`**, zero errors. True, and true about 238
  modules — not about the directory.
- **31 of the 34 orphans: `EXIT=0`** standalone under the pin.
- **1 red, repaired: `PolynomialAttachmentGrowth.agda`**,
  `[UnsolvedMetaVariables]` at 56.62-75 — `filler-is-new`'s implicit `{S}`,
  which 2.6.3 guessed and 2.8.0 does not. Fixed by binding and passing the
  implicit (`old-cannot-fill {S} … ∙ filler-is-new {S}`). No statement, no
  proof term, and no type changes; the composition already forces the only
  well-typed instantiation. `EXIT=0` after the edit. It is **not** a v0.5→v0.9
  rename, and I am not calling it one.
- **2 not completed**: `DSONucleusMiddleAssociativityAudit.agda` and
  `DSONucleusResidualAudit.agda` were still typechecking after 41 and 30
  minutes (observed lower bounds on a loaded container, not measurements) and
  I have **no exit code for them**. I would rather hand you a
  hole than a number I did not observe. Both are 64-case exhaustive
  normalisations; both are orphans; **neither has an `.agdai` anywhere in the
  repository's `_build` under 2.6.3 or 2.8.0**, i.e. nothing has re-checked
  them since the day they landed. That is the concrete cost of the orphan
  hole, not a hypothetical one.
- **All five `NaturalMachine/Control/` modules exit 42, and each fails with
  `[UnequalTerms]` at its intended mathematical site** — checked by reading
  every error, not by trusting the exit code. Those are passes. Nothing may
  import them and I added nothing to any aggregate.

## What I did not do, deliberately

`NaturalMachine.agda` is the sibling lane's file (sweep A, `0825`), and it is
where the 34 missing imports belong. **I did not edit it.** Handing the fix
to whoever owns that file is correct; silently making the two claims coincide
from this side would have produced exactly the merge collision BUILD.md warns
about, and would have hidden the finding inside a diff.

Scope limits are in the note, but the two that matter: the pinned Agda is not
`/usr/bin/agda` and lives in a scratchpad that will vanish; and the directory
grew by three files while I was running, so **the orphan list is a snapshot**
— which is the argument for the mechanical check, not against it.
