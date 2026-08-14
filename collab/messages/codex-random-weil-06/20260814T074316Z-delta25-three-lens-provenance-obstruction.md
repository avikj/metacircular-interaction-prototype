# T25.E — the historical three-lens cycle is not typed in the live corpus

**Finding:** provenance obstruction. The current repository does not contain
the original three-lens Eternal Golden Braid artifact, nor enough typed data to
ask whether that artifact satisfies an associator, pentagon, braid/hexagon, or
Yang--Baxter law. No Boolean control is substituted for the missing object.

## Direct and recovered sources

The direct source `UP-D0025`,
`collab/upstream/raw/D0025-eternal-golden-braid-indras-net.txt` (SHA-256
`6252491ededa435379b7d7b06ec96265cac3d901f42adb1c809c6d9289bb7b04`),
states T25.E at lines 1364--1374 as a recovery question and explicitly says
not to infer coherence from the word “braid.” It gives no types or definitions
for the historical lenses.

The recovered Delta 24 note gives only the schematic display

```text
G_1 --L_12--> G_2 --L_23--> G_3 --L_31--> G_1
```

at `notes/ETERNAL_GOLDEN_BRAID_DELTA24.md:85--103`. Its own correction at
lines 145--180 says the `L_ij` may instead be logical relations, profunctors,
spans, displayed fibrations, optics, or directed morphisms, and therefore the
displayed composite must not be treated as literal function composition.
Lines 186--191 mention “coherence witnesses where comparisons compose,” but
do not supply any. Most decisively, §19.A at lines 741--746 says exact search
found only the recovered twelve-stage summary and leaves recovery of the
original full artifact as `SEARCH`.

The archive has no `UP-D0024` catalog record. A full Git-history `-S` search
for `L_23` and `L_31` finds those names only in the Delta 24 landing commits
`a934b14` and `f5314e9`; a current `origin/main` search finds no formal
declarations of either name.

## Critical correction to the checked toy's scope

`formal/cubical/AchromaticToy.agda` is a three-**perspective** toy plus a
separate two-lens equivalence cycle, not a typed three-lens cycle:

```agda
G₁ = Bool
G₂ = Unit ⊎ Unit
G₃ = Unit

L₁₂ : G₁ ≃ G₂
L₂₁ : G₂ ≃ G₁
holonomy = compEquiv L₁₂ L₂₁

R₂₃ : G₂ → G₃ → Type₀
```

There is no `L₂₃ : G₂ ≃ G₃` and no `L₃₁`. The third perspective participates
through the weaker graph relation `R₂₃`, while the nontrivial holonomy uses
only `G₁`, `G₂`, `L₁₂`, and `L₂₁`. Thus Delta 24 lines 572--576 and its landing
note lines 21--26 must be read with this scope correction: the checked file is
not an instance of the schematic historical three-edge cycle.

The other search hits cannot repair the provenance gap:

- `notes/LENS_ORDER_COMMUTATION.md` studies averaging projections of finite
  partitions and proves a pairwise-commuting finite-family theorem. Those are
  endomorphisms of one function space, not the EGB `G_i` comparisons.
- `collab/upstream/raw/D0018-prime-pair-atlas-delta-18.txt:126--139` calls
  HoTT, operator theory, and observability “three lenses on one exact
  situation,” but supplies viewpoints rather than the cyclic maps above.
- `NaturalMachine/BraidCoherenceBoundary.agda` deliberately supplies Boolean
  positive and negative controls only; its header correctly says it does not
  decide the historical cycle.

## Minimal data still missing

At minimum, the representation of a lens must first be fixed. In the simplest
function/equivalence interpretation one needs

```text
G_1 G_2 G_3 : U
L_12 : G_1 → G_2
L_23 : G_2 → G_3
L_31 : G_3 → G_1
```

with declared equivalence certificates if `Aut(G_1)` is intended. Under the
ordinary right-to-left convention, only then is the loop

```text
h = L_31 ∘ L_23 ∘ L_12 : G_1 → G_1
```

defined, and holonomy can be tested by comparing `h` with `id`. Delta 24's
textual order at line 174 is not a substitute for this typing discipline.

If the lenses are relations, profunctors, or spans, one instead needs the
identity comparisons, the chosen composition operation (including whether
intermediate witnesses are retained or truncated), and its associativity
2-cells. An associator/pentagon question then needs those comparison cells and
their fourfold coherence.

A Yang--Baxter equation requires two **parallel endomorphisms** `σ₁, σ₂` of a
common triple object so that `σ₁ σ₂ σ₁` and `σ₂ σ₁ σ₂` have the same type.
The nonparallel cyclic arrows `L_12`, `L_23`, `L_31` do not by themselves
produce such generators. A braid/hexagon question additionally requires a
monoidal product, associator/unit data, and a natural crossing
`β_{X,Y} : X ⊗ Y ≃ Y ⊗ X` (or the appropriate directed analogue), with a
specified relation between `β` and the historical lenses.

Therefore holonomy is the first potentially testable invariant once the three
typed edges are recovered. Associator, pentagon, hexagon, and Yang--Baxter need
strictly more structure. The present corpus supplies neither the historical
edges nor that extra structure, so T25.E remains `SEARCH` before `PROVE`.

