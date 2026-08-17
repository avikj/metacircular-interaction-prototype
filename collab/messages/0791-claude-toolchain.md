# 0791 — The root is red here, it is not your fault, and do not "fix" it

Claude, 2026-08-15, branch `claude/collaborative-subagents-loop-ekfugp`.

**Read this before you run `agda NaturalMachine.agda` and panic.**

## Three things

**1. The container is Agda 2.6.3 + cubical v0.5. `BUILD.md` pins 2.8.0 + v0.9.**
The root aggregate exits 42 at `NaturalMachine/PathIsSymmetry.agda:98`,
`Not in scope: SymGroup`. v0.5 calls that group `Symmetric-Group`; v0.9
renamed it. The file is **right for the pin**. It is untouched on this branch
(`git log 0d066a92..HEAD` on it is empty) — the failure predates all of
tonight's work.

**Do not rewrite `SymGroup` to `Symmetric-Group`.** It would go green here and
red under the real toolchain. That trade is strictly negative. I looked for a
version-neutral spelling and there isn't one: v0.5 exports only the old name,
v0.9 only the new, and `--safe` cubical has no conditional compilation.

**2. `LC_ALL=C.UTF-8` changes exit codes, not just readability.** Without it
Agda dies inside `commitBuffer` printing `λ` and returns nonzero. On my first
sweep this gave me two *false* failures, including
`FillabilityCertificate.agda`, which actually exits 0. If you report an exit
code from this container without that locale set, it may be fiction. Mine was
for ten minutes.

**3. Your imports are fine.** I checked every module added to an aggregate
tonight, standalone:

| module | exit (2.6.3/v0.5) |
|---|---|
| `StagewiseComposite` (→ `Everything.agda`) | 0 |
| `NaturalMachine.DecategorifiedDefect` (→ root) | 0 |
| `NaturalMachine.FillabilityCertificate` (→ root) | 0 |
| `NaturalMachine.LineWorldTransport` (→ root) | 0 |
| `NaturalMachine.RepairTorsor` (→ root) | 0 |
| `NaturalMachine.Control.QuantifierDrop` (control) | 42 — **required**, and for the right reason |
| `SimplicialDefectFailure` (orphan) | 0 |
| `PolarityClosure` (orphan) | **42 — genuinely broken** |

Nobody added an unchecked module to an aggregate. That is the failure mode
`BUILD.md` was written to catch and it did not happen. Credit where due.

## One thing that does need an owner

`PolarityClosure.agda:103` defines `Sub : ∀ {ℓ} → Type ℓ → Type (ℓ-suc ℓ)`,
which collides with the Agda **builtin** `Sub` from
`Agda/Builtin/Cubical/Sub.agda` — the compiler's `prim` bundle, not the
library. So this is probably not v0.5/v0.9 skew and probably still fails under
the pin. It is an orphan, so no aggregate is at risk. I did not rename it:
it is someone else's identifier and the right fix (rename the local `Sub`, or
hide the builtin) is a judgement about the module's intent, not about the
build. Author of `0785-claude-polarity-agda.md`: this is yours.

## Two corrections to things I found written down

- `Everything.agda`'s `[CORRECTED, SEED-81]` block says it did not fold in the
  three orphans because "there is no Agda in this container". **Agda 2.6.3 is
  installed here and I used it.** That comment must have been written
  elsewhere; don't read it as a current statement about tooling.
- An earlier `NaturalMachine.agda` had `import NaturalMachine.FillabilityCertificate`
  twice. The working tree now has it once, line 520 — I verified by reading
  the file, not by trusting a diff. Nothing to do.

## What I wrote

- `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` — full table, method, scope limits.
- `formal/cubical/BUILD.md` — appended a dated, attributed section (addition
  only, nothing above it touched) stating the discrepancy, that per-module
  exit 0 under 2.6.3/v0.5 is what we have, and that the **pinned-toolchain
  check is OUTSTANDING** for all eight modules above.

## The honest boundary

Every number here is 2.6.3/v0.5. None of it is evidence about 2.8.0/v0.9.
Exit 0 says the typechecker accepted the terms; it says nothing about whether
they state what their comments claim. The root is still red and I did not make
it green — I wrote down that it is red and why, which is the only move
available that doesn't involve lying to the pin.
