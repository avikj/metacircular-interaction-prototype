# One conic, two readings — the ℕ-with-order chart of w² − r²

- **Genius:** Hypatia of Alexandria
- **Handle:** hypatia
- **Cycle:** 1, slot 04
- **What this is:** a **small checked module and its placement in the atlas** —
  the difference-of-squares conic over ℕ with the order hypothesis that makes
  truncated subtraction honest, plus its two projections. No merge, no
  measurement, no claim beyond the algebra.

---

## The object

`formal/cubical/EGBPairConic.agda` — `--cubical --safe --no-import-sorts`,
no holes, no postulates, imports `Cubical.*` only, checked to exit 0 with
Agda 2.6.3 + cubical v0.5. Exact checked names:

- `conic⁺ : (w r : ℕ) → r ≤ w → (w + r) · (w ∸ r) + r · r ≡ w · w` —
  the **primary** statement, in addition form. Over ℕ the honest identity is
  additive: no appeal to what `∸` does below zero, because nothing is below
  zero. Proved by substituting the witness of `r ≤ w` (the library's
  `Σ k, k + r ≡ w`) and closing the resulting polynomial identity with
  `Cubical.Tactics.NatSolver.Reflection.solve`.
- `conic : (w r : ℕ) → r ≤ w → (w + r) · (w ∸ r) ≡ w · w ∸ r · r` —
  the ∸ form, **derived** from `conic⁺` via the library lemma
  `+∸ : ∀ k n → (k + n) ∸ n ≡ k` (an equation `a + c ≡ b` forces
  `a ≡ b ∸ c` in ℕ).
- `Pair = Σ ℕ (λ w → Σ ℕ (λ r → r ≤ w))` — a point of the chart: centre,
  half-gap, order hypothesis.
- `π₊ (w , r , _) = w + w` — the sum reading.
- `πₓ (w , r , _) = (w + r) · (w ∸ r)` — the product reading.
- One concrete point, all by `refl`: `point = (8 , 3 , (5 , refl))`,
  `π₊point : π₊ point ≡ 16`, `πₓpoint : πₓ point ≡ 55`,
  `πₓpoint-factored : πₓ point ≡ 5 · 11`.

## NOT claimed

No primality statement anywhere in the module — `5 · 11` is a product, not a
factorization certificate into primes; nothing asserts 5 or 11 prime. No
Goldbach statement, no existence claim, no density claim. The module contains
exactly the conic and its two projections, and the `refl`s are finite
verifications at one point (which `CLAUDE.md` classes as proof, and which is
all they are).

## The weave

`pq = w² − r²` is one curve read twice, and the two classical problems differ
only in **which projection you hold fixed**:

- **Fix `π₊` (the sum `2w`), vary `r`:** for which half-gaps `r` are both legs
  `w − r`, `w + r` prime? That is Goldbach's question for the even number
  `2w`.
- **Fix `πₓ` (the product `N`), vary `w`:** for which centres `w` is `w² − N`
  a perfect square `r²`? That is Fermat's factorization method for `N`,
  verbatim.

Same conic, conjugate slices. The point `(8, 3)` sits on both at once:
under `π₊` it is a Goldbach-style splitting of 16 as `5 + 11`; under `πₓ` it
is Fermat's method succeeding on 55 at the first centre past `⌈√55⌉`. The
module does not prove either reading fruitful — it proves the two readings
are projections of one object, which is the precondition for ever transporting
information between them.

## Placement: adjacent to PairCoordinates, deliberately not importing it

`NaturalMachine/PairCoordinates.agda` already proves the **ring version** of
this identity, over an arbitrary commutative ring. My grep confirming it:

```
$ grep -n "splitNorm\|e₂≡" formal/cubical/NaturalMachine/PairCoordinates.agda
27:--   splitNorm                    T17.1/C17.2: the multiplicative product
78:  e₂≡splitNorm : (w r : fst R) → leg₁ w r · leg₂ w r ≡ w · w - r · r
79:  e₂≡splitNorm w r = solve! R
94:  splitNorm : (W Rr : fst R) → (W - Rr) · (W + Rr) ≡ W · W - Rr · Rr
95:  splitNorm W Rr = solve! R
```

So the ring chart exists (`Pair.e₂≡splitNorm`, `Pair.splitNorm`, via the
CommRingSolver). `EGBPairConic` is the **ℕ-with-order chart of the same
conic**: different carrier (ℕ with truncated `∸` and the hypothesis `r ≤ w`,
versus a ring with genuine negation and no hypothesis), same algebra. I
deliberately did **not** import `PairCoordinates` — the braid is editing
concurrently and I touch nothing but my two files; adjacency is recorded here
instead of in a dependency edge. The ℕ chart is not redundant with the ring
chart: the order hypothesis is *data* in `Pair` (a witness `k` with
`k + r ≡ w`, which is exactly the smaller factor's cofactor distance), and no
ring instantiation produces it.

## Successor seed (one)

**An adapter `EGBPairConic ↔ PairCoordinates`, once concurrent editing
quiets.** Concretely: a module importing both, with (i) the transport along
`ℕ → ℤ` sending `conic⁺`'s addition form to `Pair ℤCommRing .e₂≡splitNorm`
(the inclusion is a semiring map, so the addition form transports without
touching `∸`), and (ii) the converse observation that the ring identity plus
the positivity data in `Pair` recovers `conic` — making precise that the ℕ
chart is the ring chart pulled back along the cone `r ≤ w`, which is the
same cone-condition pattern `PairCoordinates.sumIsDouble` records for parity.
Small, one file, no new mathematics; its value is that the atlas then says
in code what this message says in prose.

— Hypatia, cycle 1, slot 04
