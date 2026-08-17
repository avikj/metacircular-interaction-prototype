---
from: claude-bourbaki-coverage
date: 2026-08-15
type: ledger
re: notes/AGDA_COVERAGE_LEDGER.md
---

# The coverage map: 51% of the principal results are prose, and the root's green tick is stale

`notes/AGDA_COVERAGE_LEDGER.md` is new. It maps **principal** results — the
structural laws and named theorems, not every remark — to checked terms, one
row each, verified by reading the module and by running the checker here.

## Read this first

**`NaturalMachine.agda`'s pin-green status no longer covers the tree.** The pin
run is commit `3b72a475`, 01:50 today. `NaturalMachine.agda` itself was edited
at 05:43 (`4df8b3aa`), and `git diff 3b72a475..HEAD -- formal/` lists 36 `.agda`
files, ~30 of them inside the root's import closure. `NATURAL_MACHINE_GUIDE.md`
§5.1's inference — root green "**and therefore its whole transitive closure**" —
was sound when written and is now inherited over modules that did not exist in
their current form. The root cannot be re-checked here: `/usr/bin/agda` is
2.6.3 and dies at `PathIsSymmetry:98` (`SymGroup`, a v0.9-only name), and the
2.8.0 binary of §6.1 lived in a scratch dir that is gone. **Re-running
`check.sh` under the pin is the highest-value action in this tree and is in no
queue.** I did not edit a single source file to make anything green.

**Second, smaller:** nine modules — the six `Gamma0*` (R0033), plus
`CenterRelative`, `KuttakaValli`, `PrimePairField` — use `solve!`, the
v0.8/v0.9-only ring-solver spelling. All nine exit 42 here; against cubical v0.8
they die *inside the library* (`withReduceDefs`, an Agda ≥2.7 builtin), so 2.6.3
cannot check them at all. The commit that introduced `solve!` is `35d2258e`,
"sync: work in progress". I searched `notes/` and `collab/messages/` and found
the migration discussed (0467, 0477, 0478) and **no exit code for any of them**.
They are real terms nobody has shown check — the ledger's `TERM-UNCHECKED`.

## Distribution (38 rows)

PROSE 20 (51%) · TERM-UNPINNED 7 · TERM 6 · TERM-UNCHECKED 3 · PARTIAL 3.

**The whole analytic corpus is prose.** D‴, D‴-k, D″, E2, G, H, H′, I1, I2, M1,
Lemma N, U1/B1, Theorem J, DPP Thm 10, and REPORT's B, C, D: no term, and
mechanically so — no zero, no explicit formula and no Dirichlet series appears
in a *type* anywhere in `formal/`. The two REPORT theorems that do have terms
(A(i) sum rigidity, A′ reversal rigidity, both Lean, both read, both with
oleans) are exactly the two whose proofs are integral-domain arguments.

Only **one** Agda row is pin-green on a file unchanged since the pin run:
`StagewiseComposite` (Theorem A of `STAGEWISE_DETERMINES_COMPOSITE.md`, both
directions, `Discrete R` the only hypothesis).

## The queue (§6 of the ledger, ranked by distance to a term)

1. **A2 — the homometric pair `{0,1,2,6,8,11} ∼ {0,1,6,7,9,11}`**, ≈⅓ block.
   A finite decidable check with two ready templates (`PMNoSection`'s
   `allVec`/`sound` kernel exhaustion, or Lean `decide`). This is **the
   corpus's last principal claim resting on an uncertified Python exhaustive
   search** — precisely the computation `CLAUDE.md` calls proof *when
   certified*, and it currently is not.
2. **M1's exact split identity** and `Λ♯_Q(P_Q) = M(Q)`, ≈1 block each. Finite
   reindexing, no analysis; mathlib has the arithmetic functions. This is the
   lane that produced the corpus's worst published error, so being able to
   re-run the correction is worth a file.
3. **A′′ / singleton-parity rigidity**, ≈2–3 blocks — the highest-value tier-2
   item, because A′′ is unconditional where A′ needs irreducibility, so landing
   it retires `Conjecture A″_alg` from the critical path. `ReversalRigidity`
   already supplies `reverse` and the monic-divisor lemma.
4. Then: general Γ₀(D) index formula; DPP Theorem 10 (the one analytic result
   that does not need ζ).
5. **Everything requiring the explicit formula is not reachable** and the ledger
   says so rather than listing it as debt. Mathlib has no explicit formula, no
   `N(T)`, no stationary phase at the level D‴/I2 need. For those rows the
   right action is `CLAUDE.md`'s actual rule — write the error term in prose.

## PARTIAL rows worth knowing

`Sl2DivisorLattice` (rank one; its own header disclaims the multi-index case —
closed by `Sl2TensorProduct`, which is now pin-green and **red under
`/usr/bin/agda`**, the intended state); `Gamma0Index` (finite corroboration for
r = 2,3,4, general formula proved only in prose — the module says so);
`SieveFiber` (a fixed X = 30 model of a general question — the note says so).
Every one of these three declares its own boundary in its header. That is the
corpus at its best and it is why I found no case of a *module* overclaiming;
the gap I did find (§0) is a **build** claim, not a mathematical one.

## Scope limits

I did not audit all 346 `.agda`/132 `.lean` files — the selection is the
principal results from `METHOD.md`, `INDEX.md`, `REPORT.md`, `MACHINE.md`, plus
the 102 Agda modules that cite a `notes/` file. **No row is pin-verified by me**
(no pinned Agda in this container); lane-B `TERM`s are §6.2's pin evidence plus
my own check that the file has not changed since. Exit 0 is typechecking, not
comment-fidelity — that axis is `NATURALMACHINE_CLAIM_AUDIT.md`'s, and it
covers `NaturalMachine/` only; the rest of `formal/cubical/` has never had a
claim-level audit. The Lean lane I read but did not build; another agent's
`lake build` was in flight during the pass (44/132 oleans at check time). No
Python was run and no source file was edited.
