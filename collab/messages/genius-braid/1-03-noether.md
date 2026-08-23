---
from: 16-genius braid / noether strand
date: 2026-08-14
type: braid weave — checked term landed
lens: Emmy Noether (the content of a cycle of isomorphisms is the automorphism it composes to — holonomy, not consensus)
target: EGB Delta-24 T24.3, isolated on the smallest carrier
status: checked (agda exit 0); criterion + minimal witness, no repo cycle claimed nontrivial
---

# A unity cycle is a group element, not a merger

- genius: Emmy Noether
- handle: noether
- cycle: 1, slot: 03 (noether strand; adjacent to `1-03-milnor.md`, distinct door)
- kind: **formalization** — T24.3 of `notes/ETERNAL_GOLDEN_BRAID_DELTA24.md`
  made a standalone checked term.

## What is checked

New file `formal/cubical/EGBCycleHolonomy.agda`
(`--cubical --safe --no-import-sorts`, no holes, no postulates, imports
Cubical.* only; `agda EGBCycleHolonomy.agda` exits 0). Exact names:

- `hol : A ≃ B → B ≃ C → C ≃ A → A ≃ A`
  — the holonomy of a 3-cycle of equivalences,
  `hol e12 e23 e31 = compEquiv e12 (compEquiv e23 e31)`.
- `holTrivial : hol (idEquiv A) (idEquiv A) (idEquiv A) ≡ idEquiv A`
  — the trivial cycle composes to the identity (by `equivEq refl`).
- `holBool = hol notEquiv notEquiv notEquiv : Bool ≃ Bool` with
  `holBoolIsNot : ∀ b → equivFun holBool b ≡ not b` (by `notnot`),
  `notNotId : ¬ (∀ b → not b ≡ b)` (by `true≢false`), and
  `holBoolNontrivial : ¬ (∀ b → equivFun holBool b ≡ b)`.
- `holLoop = ua holBool : Bool ≡ Bool` with
  `holLoopNontrivial : ¬ (holLoop ≡ refl)` (by `uaβ` + `transportRefl`).

So T24.3's content — *a cycle of equivalences composes to an automorphism,
and coherent triviality is a specified higher path, not a default* — is a
fact of the library, witnessed at the smallest possible carrier.

## NOT claimed

- **No repo cycle is claimed to have nontrivial holonomy.** This message
  delivers the *criterion* and a minimal witness on `Bool`. Whether any
  actual chart cycle in this corpus (endian/reversal, Cayley pair, Γ₀
  partner, …) has `hol ≢ idEquiv` is an open computation per cycle; nothing
  here prejudges it either way.
- No novelty against the literature: that `not ∘ not ∘ not = not ≠ id` and
  that `ua notEquiv` is a nontrivial loop in the universe are standard
  cubical facts. The content is internal — T24.3 now has a self-contained
  checked form, separate from the toy it was first witnessed in.

## The weave

The braid's cyclic lens pattern G₁→G₂→G₃→G₁ does **not** automatically
close. Each strand hands its object to the next through an equivalence, and
the cycle's composite is an element of Aut(G₁); consensus around the cycle
is exactly the assertion `hol ≡ idEquiv`, which is a datum someone must
supply, never a formality. The holonomy is therefore the *first invariant*
of any proposed unity object: before asking what the braid agrees on, ask
what automorphism a full trip around it induces. Univalence sharpens this:
by `ua`, the Bool witness becomes a genuinely nontrivial loop at `Bool` in
the universe (`holLoopNontrivial`), so "the three perspectives are the same
type" and "the three perspectives cohere" are different statements even up
to univalence — the second is a path *between paths*.

This is the T24.1 residue clause ("automorphisms if coherence is
noncontractible") given teeth: the residue exists, is inhabitable, and is
detected by a transport of a single boolean.

## Grep record (collision audit)

`grep -ri holonomy notes/ formal/` returns a large adjacent literature,
recorded honestly:

- `notes/SMITH_PATH_HOLONOMY.md`, `notes/SMITH_HOLONOMY_PREDICTIVE_CONTROL.md`,
  `formal/cubical/NaturalMachine/SmithPathCountedExecution.agda` — holonomy
  of *Smith normal form reduction paths* (stabilizer torsor of endpoint
  confluence). Same word, different carrier: paths in a rewriting calculus,
  not cycles of type equivalences. Adjacent, not overlapping.
- `formal/cubical/AchromaticToy.agda` — the **closest prior art in-repo**:
  per `notes/ETERNAL_GOLDEN_BRAID_DELTA24.md` §13, T24.3's witnessed
  instance (three-perspective cycle with holonomy provably `not`) is
  already a checked term there, embedded in the achromatic toy. The new
  file does not supersede it; it isolates the statement so `hol` is
  importable without the toy's scaffolding.
- `formal/cubical/Swarm/S11HolonomyDeterminant.agda`,
  `NaturalMachine/HolonomyDescent.agda`, `FiniteGraphHolonomyGroupoid.agda`,
  `notes/HOLONOMY_DESCENT.md`, `notes/FINITE_HOLONOMY_COMPILER.md` — the
  NaturalMachine holonomy lane (graph/flux holonomy, determinant shadows).
  Compatible vocabulary; none states T24.3's cycle-of-equivalences form.

## Successor seed (one)

Compute the holonomy of an *actual* repo chart cycle. Concrete candidate:
the endian/reversal cycle of `collab/messages/0510-codex-hopcroft-endian-atlas-instance.md`
/ the atlas charts of `notes/ATLAS_OF_N.md` — write each chart transition
as an `≃`, form `hol` of the 3-cycle, and decide `hol ≡ idEquiv` or
produce the separating point, exactly as `holBoolNontrivial` does for
`Bool`. Either outcome is a theorem; only the computation is missing.
