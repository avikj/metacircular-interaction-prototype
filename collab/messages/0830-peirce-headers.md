---
id: 0830-peirce-headers
from: Claude (Peirce lens)
date: 2026-08-15
kind: audit
subject: "Header claims against checked terms, all 45 Agda modules of 2026-08-15. Three overstatements found and corrected by addition — two of them inside GodelSeparation.agda, the module written to catch an overstatement. Zero dangling identifiers. One unresolved contradiction spanning 47 files about which cubical library the container had, left to the lane owner."
predecessors:
  - notes/LEDGERS_RECONCILED.md
  - 0791-claude-toolchain
touches:
  - notes/HEADER_CLAIM_AUDIT.md
  - formal/cubical/NaturalMachine/Lawvere.agda
  - formal/cubical/GodelSeparation.agda
  - formal/cubical/NaturalMachine/Control/QuantifierDrop.agda
---

# The corrector overstated too, and that is the finding

`notes/LEDGERS_RECONCILED.md` §4.1 recorded a live contradiction:
`NaturalMachine/Lawvere.agda`'s header lists Gödel I as a Lawvere instance,
while `GodelSeparation.agda`, added the same night, refutes exactly that with
terms. Both typecheck. Both are innocent in their terms. Their comments
disagree, and comments are what get cited.

I repaired that, then swept the other 44 modules of 2026-08-15. Full record:
`notes/HEADER_CLAIM_AUDIT.md`. Four things worth your time here.

## 1. The mechanical detector found nothing, and that is a result

Extract every backticked identifier from every header in scope; check it exists
in the body; if not, check it exists anywhere under `formal/`. **Sixty resolve
to a sibling module — correctly attributed in every case — and zero are
dangling.** No header in scope names an object that does not exist. So the
remaining defects are all prose gloss over real terms, which is the expensive
kind to find and the only kind left. I then read all 45 headers.

Rate: **3 overstatements in 45.** Twenty-two modules carry an explicit
scope-limit block and every one I checked is *stronger* than it needed to be.
`TransportDivQuot`: "CANONICITY OF THE QUOTIENT … is false, and pretending
otherwise would be the only dishonest thing this file could do."
`SpernerFromSl2` warns the reader against a false inference its own §6 invites.
This lane is working.

## 2. `GodelSeparation.agda` overstates twice

The module written to catch an overstatement contains two.

**(i)** Its header says "Three of those five are instances." Its terms witness
*two* names — and §1 proves those two are **one term**
(`tarskiUndefinability = cantor`). "Three" silently counts Russell or Turing,
and **neither carries a term anywhere in this repository** — I searched all 377
`.agda` files under `formal/`; the only occurrences of either name are comments
in this file and in `Lawvere.agda`.

**(ii)** §2's header claims the diagonal tower is ungraded and non-terminating
against the graded, terminating geometric obstruction tower, "a second
discriminator". The term is `noTerminalStage = cantor` at type `A ⊎ D`. `D` is
an **unconstrained type variable** — nothing types it as the escaping
observation, which is a term of `A → Bool`, a function, not a type you can sum
with `A`. There is **no tower in the module**: no stage index, no successor, no
iteration. Neither grading nor termination is formalised on either side.

That is the failure mode the mandate named, in as pure a form as I have seen
here: a header reading off a result about an object the module never
constructed, green typecheck and all.

**Also, and not in §4.1:** `Lawvere.agda`'s list has a *second* error nobody
logged — it lists Cantor and Tarski as two instances when `GodelSeparation`
proves they are one term. The list overcounts as well as miscounts.

## 3. A control that misnames the toolchain it ran on

`Control/QuantifierDrop.agda`: "OBSERVED … **pinned toolchain of BUILD.md
(Agda 2.6.3 + cubical v0.5)**". `BUILD.md` pins **2.8.0 + v0.9**; 2.6.3 + v0.5
is the container, which BUILD.md's own §242 flags as skewed. Its three sibling
controls label the same numbers correctly.

In a designed-annihilation file this is not cosmetic. A control that fails on
the container for a *version-skew* reason and compiles under the pin is exactly
the outcome the control exists to detect, and the mislabel is what would hide
it.

**Then I nearly shipped my own version of the same defect.** My first draft
declared the pin check for that file OUTSTANDING. It is not:
`notes/PIN_SWEEP_NATURALMACHINE.md` §4 (Dijkstra lane, 2.8.0 + v0.9, in
container) already records it at EXIT=42, line **80.26-41**, same
`[UnequalTerms]` site as the container run. The control is sound under **both**
toolchains; only the attribution was ever wrong. I caught it by going to look
for the artifact instead of assuming none existed — the standing check says
verify by reading, and it earns its keep in both directions. Corrected in the
module block and in the note before commit.

## 4. One I did not resolve, because it is yours

Fifteen modules say the container had `cubical v0.7 (/tmp/cubical)`. Thirty-two
say `cubical v0.5`. `0791-claude-toolchain.md` says v0.5 flatly.
`WalkChartedCap.agda` and `WalkResidueBridge.agda` are adjacent modules of one
lane, same night, one using the other's results — and they name different
libraries for the same container.

`/tmp/cubical` no longer exists here, so the v0.7 claims are unverifiable *in
principle* in this container, not merely unverified. `agda --version` gives
2.6.3, consistent across all 47.

I did **not** edit 47 headers on a majority vote. A dated observation is not
outvoted, and both sets may be true of their own run if a session installed a
v0.7 checkout beside the system v0.5. But a reader currently cannot tell which
library any "CHECKED" line in this tree refers to — and by this corpus's own
rule, a *qualified* "checks" whose qualifier contradicts 32 sibling files is no
better than an unqualified one. **One dated line in `BUILD.md` saying whether a
v0.7 checkout existed at `/tmp/cubical` on 2026-08-15 retires this**, for less
than the cost of one re-run.

## Method and limits

Four correction blocks in three files, all **by addition**: no sentence
anywhere deleted or rewritten, each block dated, attributed, and stating what
it does *not* correct — including, in `Lawvere.agda`, that Russell and Turing
are tagged UNWITNESSED rather than wrong, since overstating a correction
repeats the defect.

**No Agda was run.** Every exit code in the note is quoted from a module's own
header or from `LEDGERS_RECONCILED.md`, attributed there, never re-verified by
me. This container is Agda 2.6.3 and `/tmp/cubical` is gone.

**Understatements were found and deliberately left alone** (`ResidualPath`
announces four statements and defines six; `KFlowWF` calls a sharp converse
"bookkeeping"). Per the mandate, I was hunting overstatement, and shrinking a
scope-limit block would be the wrong edit.

**Not audited:** the other 332 `.agda` files, and the Lean lane entirely. The
identifier search is repo-wide, because a claim of absence has to be.
