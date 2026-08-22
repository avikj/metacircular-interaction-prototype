# The Everything.agda coverage latch

`formal/cubical/Everything.agda` is a hand-maintained import list. BUILD.md
and the file's own SEED-81 comment both predicted its failure mode:

> A hand-maintained list of orphans rots in both directions … the check is
> mechanical and takes one command; run it rather than trusting this file.

`formal/cubical/check-everything-coverage.sh` is that one command.

## What it checks (and what it does not)

It is a **coverage** latch, not a build. It does **not** typecheck anything.
It asserts one thing: the set of modules Everything.agda *imports* equals the
set of modules *on disk*, exactly.

Scope of "on disk":
- every top-level `formal/cubical/*.agda` except `Everything.agda`
- every `formal/cubical/Swarm/*.agda`

The `NaturalMachine/` subtree (including `NaturalMachine/Control/`) is **not**
enumerated — it is covered transitively through the `NaturalMachine` root
import. A dangling import *into* that subtree is still caught, because the
rot-back check resolves the file behind every import line wherever it points.

Two directions of rot, both fatal (exit 1):
- **rot-forward** — a file on disk that no import line names. This is the
  SEED-81 hole: a module nobody names is invisible to a latch made of names.
- **rot-back** — an import line naming a module whose file is absent.

Duplicate import lines are reported as a non-fatal WARNING (Agda tolerates
them; they are census noise, not a coverage gap).

## The honest aggregate claim

A green coverage latch says the import list is a faithful census of the
directory. Per-module `agda` exit-0 (the actual build) says each module
checks. **Neither alone is the claim BUILD.md's green is taken to mean.**

    green coverage latch  +  per-module exit-0  =  "Everything.agda covers the
                                                    whole directory, and the
                                                    whole directory checks"

This script supplies the first conjunct only, and supplies it mechanically so
it cannot silently rot the way a prose sentence or an unwatched import list
does.

## Current state (2026-08-16)

Exit 1. Diff:

- rot-forward (2): `HeadDepthMergeBreaker`, `R0021FlipOrbit` — on disk,
  imported by nothing.
- rot-back (0): none; every import resolves to a file (including the subtree
  import `NaturalMachine.TransportCost`).
- duplicate (1, warning): `HeadDepthTwo` is imported twice.

Note: the orphans named in Everything.agda's own SEED-81 comment
(`BehavioralApartness`, `PrimePairField`, `CenterRelative`) have since been
folded into the import list and are no longer orphans — which is exactly why
the fix is a script and not a comment: the comment is already stale, the
script is not. The remaining orphans (`HeadDepthMergeBreaker`,
`R0021FlipOrbit`) landed after the last hand-edit.

The fix is to add the two missing roots to Everything.agda's import list (and
optionally drop the duplicate `HeadDepthTwo`), then re-run until exit 0.
Ownership of Everything.agda's content belongs to another concern; this latch
only reports.

## Usage

    formal/cubical/check-everything-coverage.sh

Runs from any directory (it anchors to its own location). Exit 0 iff the
import list and directory coincide exactly; otherwise exit 1 with the exact
missing/extra names. Suitable for CI as a fast pre-build gate.
