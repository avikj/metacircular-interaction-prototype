# The orphans of `Everything.agda`: 36 found, 33 folded in, aggregate green from a clean tree

2026-08-15, Claude (Euclid-lineage orphan pass). Details, tables and scope
limits: `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §7; `formal/cubical/BUILD.md`
has the short form.

## What was checked

I recomputed `Everything.agda`'s import closure from the sources — BFS over
`^\s*(open\s+)?import\s+`, no comment believed, no aggregate's own claim
believed — and diffed it against `find . -name '*.agda'`. **367 files, 322
reached, 45 not.** Of the 45, 9 are the `NaturalMachine/Control/` modules
that must never be reached, and I ran the opposite check they deserve: every
occurrence of `NaturalMachine.Control` outside that directory is inside a
comment. Not one import. The exclusion holds.

That leaves **36 genuine orphans**. Every one was run individually under the
BUILD.md pin (Agda 2.8.0 + cubical v0.9, `LC_ALL=C.UTF-8`). 33 exited 0 and
are now imported by an aggregate. Nothing red and nothing unrun was folded
in.

`SimplicialDefectFailure.agda` was an orphan exactly as its author reported,
and it exits 0 under the pin. Both halves verified rather than taken on the
report.

## The clean run

`Everything.agda`, in a fresh copy with `_build` removed and zero `.agdai`
present: **EXIT=0, 358 modules checked, 0 errors, 200
`UnsupportedIndexedMatch` warnings.** Every `Checking` line names a file in
the fresh copy; there is no cache hit in the log. Two earlier attempts were
**discarded rather than published**, for the reason a sibling discarded one
tonight: a run that reuses interfaces you just wrote is not a check.

This supersedes §6.7's 315 with 358 — because the aggregate now covers 33
modules it did not, not because anything about the toolchain changed.

## Two things worth your time

**1. A module that can never be reached from the root, structurally.**
`NaturalMachine/TransportCost.agda` line 30 is `open import NaturalMachine`.
Adding it to the root is a `[CyclicModuleDependency]` — the first clean run
died on it. So BUILD.md's mechanical orphan check ("run the root, look for a
missing `.agdai`") **cannot ever clear this module**: its interface is
missing not because someone forgot, but because it is impossible. It is
imported from `Everything.agda`, which sits above the root. If you write a
module that imports the root, it belongs in `Everything.agda` and nowhere
else.

**2. The `solve!` schism is over, and the note that said so was right to
wait.** `Everything.agda` carried a block naming `CenterRelative`,
`PrimePairField` and five `Swarm` modules as deliberately-not-imported,
because they use the v0.9 CommRingSolver `solve!` and the container had
v0.5, ending "when the schism resolves, fold them in." It has: the owner
decided today that the sources track the pin, and all seven are green under
it. Folded in, and the old block superseded by addition rather than deleted
— it was correct when written and its refusal was the right one.

## What I did not establish

- `NaturalMachine/DSONucleusMiddleAssociativityAudit.agda` and
  `DSONucleusResidualAudit.agda`: **no exit code.** Neither returned after
  >25 and >15 minutes under the pin, on a container at load ~4.5 with
  several agents' Agda running. `notes/PIN_SWEEP_NATURALMACHINE.md` §3 hit
  the same wall at 41 and 30 minutes. They stay orphans and stay OUTSTANDING.
  I am not supplying a number for them.
- `NaturalMachine/WalkFastInstance.agda`: **exit 137** — SIGKILL from the OOM
  killer, which is a fact about the container, not about the module. Another
  lane folded it in later the same hour; nothing in *this* pass supports that.
- One stale-copy trap, recorded because it nearly became a false red:
  `PolynomialAttachmentGrowth.agda` exited 42 in my working copy and 0
  against the working tree. The difference is a sibling's uncommitted
  two-token repair, confirmed **by diffing the two files** rather than by
  believing the coincidence.

## The standing lesson, observed inside one hour

While this pass ran: the directory went 367 → 369 files, `WFIScratch1/2`
(green minutes earlier) were deleted by another lane, `WalkFastInstance` was
folded in by a third, and `HomometricPair.agda` appeared as a brand-new
orphan — run under the pin, EXIT=0, folded in. The residue as of commit is
exactly the 9 `Control/` modules (correct) and the two `DSONucleus*Audit`
modules. As of commit, and no later. Regenerate the list; do not quote it.
