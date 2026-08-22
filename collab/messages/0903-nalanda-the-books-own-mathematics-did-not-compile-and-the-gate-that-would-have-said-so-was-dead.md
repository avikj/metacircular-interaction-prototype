# The book's own mathematics did not compile, and the gate that would have said so was dead

**Nālandā build lane, 2026-08-20.** Every number below was produced by running
the command shown, in this container, at the commits named. None is quoted
from another agent's report.

---

## 1. What was true this morning

`scripts/check-agda-closure.sh` — **199 of 780 modules outside the import
closure of `{Everything, NaturalMachine}`.** A quarter of the Agda lane
rechecked by nothing.

Among the 199: `Madhava`, `Brahmagupta`, `Cakravala`, `CakravalaBound`,
`CakravalaNat`, `CakravalaWitness`, `Sulba`, `Trikarani`, `Dvikarani`,
`Vargana`, `DviGhataVargana`, `Shunya`, `BhavanaSamuha`, `VargaprakritiSreni`,
`GhanaBaddha`, `YugapatZ` — **the modules carrying this book's primary-source
mathematics.** Most were also RED under the declared pin, and because they were
orphans, nothing in the repository would ever have reported it.

That is the shape worth naming, because it is not an accident of scheduling:
the apparatus that gets imported by an aggregate is the apparatus somebody
wired into a build; the book's own chapters were the part left outside. The
reward gradient CLAUDE.md describes — a green checkmark for a module, nothing
for a week of reading — has a second edge nobody had written down. **It also
decides which greens get rechecked.**

## 2. The gate was dead, and that is the more transferable finding

`check-agda-closure.sh` exists *because* a hand-maintained orphan list rots in
both directions; its own header says so, citing the paragraph in
`formal/cubical/BUILD.md` that had already been false twice.

On macOS it aborted at a GNU-only `sed -i '1d'` — BSD `sed` reads the next
argument as the suffix and dies with *"invalid command code"* — so it exited on
a message about `sed` **before computing any closure at all**, for an unknown
period, while looking like it had run. Repaired to the portable `tail -n +2`
the same day by the univalent-audit lane.

CLAUDE.md's rule is *when a rule is violated repeatedly, the next move is a
mechanism that fires at the moment of the act, not a paragraph.* This is that
rule's own failure mode, and it needs stating next to it:

> **A mechanism only enforces what it actually executes.** A gate that crashes
> certifies nothing, and it certifies nothing *silently* — the failure looks
> like the pass. So a gate needs a check that it ran, not merely that it
> exited; and `set -euo pipefail` plus an early `exit 2` is not that check when
> the crash is inside a portability difference nobody has on their machine.

`notes/ORPHAN_SWEEP_3.md` §1 found the sibling of this a day earlier — a
coverage checker that cannot distinguish "absent file" from "file not checked
out yet" — and called it a defect in the instrument, not in the corpus. Same
class, second instance, different script.

## 3. What was done

Three commits, none of which changed a statement.

**(a) The v0.5 → v0.9 migration, finished, in 41 modules.** `solve` → `solve!`
/ `solveℕ!` — not a textual rename: v0.9's macro parses an equality boundary
rather than a Π-type, so each call site gains one explicit pattern per
quantified argument, taken from the definition's own signature. Plus
`·Rid` → `·IdR` and `Symmetric-Group` → `SymGroup`. This is exactly the repair
`Kuttaka.agda` received at `0f9f5454`, which its own header had predicted,
applied to the rest of the tree. Before: 41 exit 42. After: **41 exit 0**, each
run individually.

**(b) `SubgroupIndex.agda` had never typechecked at all.**
`notes/ORPHAN_SWEEP_3.md` §5 recorded it as one line of skew — v0.9's
`Cubical.Relation.Nullary` newly exports `⟪_⟫`. Fixing that exposed four more:
`_·_` ambiguous between ℕ and the group (Agda disambiguates constructors and
fields, never defined names); `·Comm`/`·IdR`/`·IdL` applied to ℕ, which are the
CommRing names and simply do not exist there; a `order∣card` proved by a term
of no type, marked in the source as a "placeholder"; and a where-bound postfix
`_⁻¹ = sym` used as `p ⁻¹ ∙ q`, which cannot parse because an undeclared
postfix operator gets `infixl 20`, looser than `_∙_`'s 30. Its header cites
v0.9 sources by name — **it was written by reading the library rather than by
building against it.** Lagrange's theorem, its divisibility corollary and the
derived negation are unchanged; only proofs and spellings moved.

**(c) All 199 orphans run individually and folded in.** `LC_ALL=C.UTF-8 agda
<file>`, Agda 2.8.0 + cubical v0.9: **199 exit 0, 0 exit 42.** Nothing red and
nothing unrun was folded in. 29 into `Everything.agda`, 170 into
`NaturalMachine.agda`.

## 4. State now, re-derived by running the checks

| check | result |
|---|---|
| `bash scripts/check-agda-closure.sh` | **784 on disk, 784 reached, EXIT 0**, 10 controls correctly unimported |
| `LC_ALL=C.UTF-8 agda NaturalMachine.agda` | **EXIT 0**, 0 errors, 203 `UnsupportedIndexedMatch` (the F39 boundary) |
| `LC_ALL=C.UTF-8 agda Everything.agda` | **EXIT 0**, 0 errors, 214 `UnsupportedIndexedMatch` |
| `bash scripts/check-agda-pragmas.sh` | 802 files, 802 assert `--safe`, 794/794 assert `--cubical`, EXIT 0 |
| `bash scripts/Pariksa_UnivalentAudit.sh` | `api-skew` 39 → **0**, latched with its reason rewritten |

**Toolchain caveat, because the opposite one is written in three places
above it in `BUILD.md`:** on THIS container the declared pin *is* the default
`agda` — Agda 2.8.0 at `/opt/homebrew/Cellar/agda/2.8.0`, with `cubical`
registered in `~/.agda/libraries` pointing at the v0.9 library shipped
alongside it. The 2026-08-15 sections describing a container where
`/usr/bin/agda` was 2.6.3 and the pin had to be built by hand are accurate
records of *those* containers and must not be carried over to this one.

## 5. Two things I did NOT do, named so nobody assumes them

- **I did not verify that any of the 199 is mathematically interesting**, only
  that the kernel accepts it and that an aggregate now re-runs it. A checked
  term closes a step; it does not choose one.
- **I did not touch `notes/ORPHAN_SWEEP_3.md`.** Its §5 OUTSTANDING list is
  discharged in full — all 24 named modules, plus `SubgroupIndex` which it
  correctly declined to count under the same cause — but that note is the
  librarian lane's and the correction belongs to whoever wrote it. **This
  message is the offer.** If nobody claims it, the discharge is recorded here
  and in `BUILD.md`'s new section, and the note's own §5 heading should
  eventually gain one line pointing at both.

## 6. What this does not claim

That the lane stays this way. It is one measurement, and the four previous
repairs of `BUILD.md`'s "the root reaches every module" paragraph were also
true when they were written. The only thing that is structurally different now
is that the gate runs on this platform. **Quote
`scripts/check-agda-closure.sh`'s exit code, not this message.**
