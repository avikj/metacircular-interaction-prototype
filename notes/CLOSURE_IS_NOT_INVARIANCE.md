# Observational closure is strictly weaker than sector invariance — except for self-adjoint actions, where they coincide and Delta 19's criterion collapses

**Status:** proved. Answers seed 1 of `DELTA19_IS_THE_KERNEL_AGAIN.md`
(compare Delta 19's C19.10 with `LEAKAGE_RANK_IS_INCIDENCE_RANK.md`). Contains
one deflation of Delta 19 and one sharpening of the leakage lane.

**Worker:** opus-ekatva (Claude Opus 5), 2026-08-14.

---

## 1. Two criteria that look like the same criterion

Fix a Hilbert space `H = S ⊕ S^⊥`, `P` the orthogonal projection onto `S`,
`Q = I - P`, and an operator `T` in block form

```text
T = [ A  B ]      A = PTP,  B = PTQ,  C = QTP,  D = QTQ.
    [ C  D ]
```

**The reopening lane** (`REPRESENTATION_REOPENING_CYCLE.md`,
`LEAKAGE_COST_VECTOR.md`, and `LEAKAGE_RANK_IS_INCIDENCE_RANK.md` §0) prices an
installed projector by

> soundness: `(I-P)TP = 0`, i.e. **`C = 0`**;
> when it fails, `rank((I-P)TP) = rank C` is the correction channel paid per
> application.

**Delta 19** (T19.9, C19.10) gives

> exact closure: `PTⁿP = Aⁿ` for all `n`, iff **`B Dᵐ C = 0` for every `m ≥ 0`**;
> "an eliminated distinction matters only if there is BOTH a channel from S into
> it and a future channel back into S."

These are not the same condition, and the difference is not a technicality.

## 2. They ask different questions

**Proposition 2.1.** `C = 0` ⟺ `S` is `T`-invariant (`T·S ⊆ S`).

*Proof.* `C = QTP` is the component of `T|_S` landing in `S^⊥`. `□`

**Proposition 2.2 (Delta 19 T19.9, restated).** `PTⁿP = Aⁿ` for all `n ≥ 0` iff
`B Dᵐ C = 0` for all `m ≥ 0`.

So the reopening lane asks **"can I stay inside the sector?"** — a question about
subspace invariance, correct for its purpose, since a compiled primitive that
leaves its sector is no longer computing in that sector. Delta 19 asks
**"do my observations look Markovian?"** — a question about the observed
sequence only, which does not care where the state goes as long as nothing
comes back.

**Proposition 2.3.** Invariance ⟹ closure, and the converse is false.

*Proof.* `C = 0` gives `BDᵐC = 0` immediately. For the converse, take `B = 0`
with `C ≠ 0`: then `BDᵐC = 0` for all `m`, so closure holds, while `C ≠ 0` means
`S` is not invariant. `□`

**Minimal witness.** `S = span(e₁)`, `S^⊥ = span(e₂)`,

```text
T = [ 1  0 ]      A = 1,  B = 0,  C = 1,  D = 0.
    [ 1  0 ]
```

`T² = T`, so `PTⁿP = 1 = Aⁿ` for every `n ≥ 1`: the projected dynamics is
*exactly* Markovian. Yet `rank((I-P)TP) = rank C = 1`, so the reopening lane
prices a one-dimensional correction channel per application. **The correction is
never needed**: everything that leaks into `S^⊥` stays there and never returns.

This is exactly Delta 19's own C19.10 — *"pure leakage with no return changes
normalization/resource but not future internal S dynamics"* — and it is a real
gap in the leakage lane's pricing, in the sense that `rank C > 0` does not imply
memory is created.

## 3. For self-adjoint `T` the two collapse, and Delta 19's criterion is vacuous

This is the part that matters for this repository, because the leakage lane
works almost entirely with self-adjoint objects (averaging projections, the
centred sieve multiplier, character-sector projectors).

**Theorem 3.1.** Let `T` be self-adjoint. Then the following are equivalent:

1. `PTⁿP = Aⁿ` for all `n ≥ 0`  (Delta 19 closure);
2. `B Dᵐ C = 0` for all `m ≥ 0`;
3. `B Dᵐ C = 0` for `m = 0` alone;
4. `C = 0`  (sector invariance / reopening-lane soundness);
5. `B = 0`.

*Proof.* Self-adjointness of `T` gives `C = B*` (and `A = A*`, `D = D*`).
(2)⟹(3) trivially. For (3)⟹(5): the `m = 0` condition is `BC = BB* = 0`, and
`BB* = 0` forces `B = 0`, since `‖BB*‖ = ‖B‖²` (in finite dimensions: `BB* = 0`
⟹ `tr(BB*) = ‖B‖²_F = 0`). Then (5)⟺(4) because `C = B*`. (4)⟹(2) and
(2)⟺(1) are Propositions 2.3 and 2.2. `□`

**Corollary 3.2 (the deflation).** For self-adjoint dynamics, Delta 19's
infinite family of conditions `{B Dᵐ C = 0}_{m≥0}` **collapses to its `m = 0`
member**, and that member is precisely the reopening lane's existing soundness
test. The excursion structure — leave, wander in `Q` for `m-1` steps, return —
contributes nothing beyond `m = 0`.

**Corollary 3.3 (C19.10 is vacuous here).** Delta 19's C19.10 says an eliminated
distinction matters only if there is *both* a channel in and a channel back.
For self-adjoint `T` the two channels are adjoint to each other, `B = C*`, so
**one is nonzero iff the other is**. The conjunction that C19.10 identifies as the
obstruction can never be half-satisfied. Its content is real only outside the
self-adjoint world.

This is the same structural fact `LEAKAGE_RANK_IS_INCIDENCE_RANK.md`
Proposition D records — `rank((I-P)AP) = rank(PA(I-P))` for self-adjoint `A`,
"the installed sector and its complement pay exactly the same correction
dimension" — pushed one step: not only are the *ranks* equal, but one channel
vanishes iff the other does, which is what kills the excursion series.

## 4. What each side actually gains

**To Delta 19.** Its refinement is genuine but its natural habitat is
*non-normal* dynamics. In the self-adjoint case it reduces to a criterion the
repository already had. Anyone citing C19.10 as a new obstruction must first say
whether their `T` is self-adjoint; if it is, C19.10 is `C = 0` in disguise.

**To the leakage lane.** `rank((I-P)TP)` is the exact price of *maintaining the
sector*, and that is the right object for a compiled primitive. It is **not** the
price of *predicting the observations*, and for non-self-adjoint actions it can
strictly over-price (§2's witness: rank 1 charged, zero needed). The free test
is cheap: **if `PTQ = 0`, the observed dynamics is exactly Markovian no matter
what `QTP` is**, and no correction need be carried at all.

This bears directly on that note's successor seed 1 ("past idempotents"): the
first class where the two criteria genuinely differ is exactly the class where
self-adjointness fails, and the `position` operator on `ℤ/30` — the reopening
cycle's own live example — is diagonal, hence normal, hence (being real
diagonal) self-adjoint. So **Theorem 3.1 applies to the live example**, and its
leakage rank `φ(30) = 8` is a genuine memory cost, not an over-price.

## 5. Rigor boundary

- **Proved here:** Propositions 2.1, 2.3, Theorem 3.1, Corollaries 3.2, 3.3,
  and the minimal witness of §2 (a `2×2` integer matrix, verified by hand:
  `T² = T`, `PTⁿP = 1`, `rank C = 1`).
- **Cited, not proved here:** Delta 19's T19.9 / Proposition 2.2 (the renewal
  expansion), which is classical Feshbach/Schur — see
  `DELTA19_IS_THE_KERNEL_AGAIN.md` §3 for the recorded search;
  `LEAKAGE_RANK_IS_INCIDENCE_RANK.md` Proposition D.
- **Hypotheses.** §3 uses `‖BB*‖ = ‖B‖²`, i.e. the C*-identity; in finite
  dimensions the trace argument suffices and no functional analysis is needed.
  Everything is finite-dimensional in the repository's applications.
- **Not claimed:** that the reopening lane is *wrong*. It answers the invariance
  question correctly. The claim is that invariance and observational closure are
  different, that the lane's criterion is the stronger one, and that the gap is
  empty precisely when `T` is self-adjoint.
- **No novelty.** The block-triangular observation (`B = 0` ⟹ `PTⁿP = Aⁿ`) is
  immediate, and the self-adjoint collapse is one line from `BB* = 0 ⟹ B = 0`.
  The content is the *identification* of two repository criteria and the exact
  boundary between them. No literature search performed for §3; none needed at
  this level, and none would support a novelty claim if made.

## 6. Successor seeds

1. `PROVE`: the first genuinely non-self-adjoint action in the corpus. Theorem
   3.1 says all the interesting Delta 19 content lives there, and
   `LEAKAGE_RANK_IS_INCIDENCE_RANK.md` seed 1 already asks for the class past
   idempotents. The two seeds are the same seed; whoever takes one should take
   both.
2. `PROVE`: an exact price for observational closure, to sit beside
   `rank((I-P)TP)`. The natural candidate is the rank of the first-return
   family `{B Dᵐ C}` jointly, and Delta 19's `Σ(λ) = B(λ-D)⁻¹C` suggests the
   right invariant is the McMillan degree of that transfer function — which is
   classical realization theory again, and should be searched before it is
   named.
3. `DEMONSTRATE`: whether any action currently installed in the reopening cycle
   has `PTQ = 0` with `QTP ≠ 0`. If one does, it is being charged for memory it
   does not create, and §2 says so exactly. This is a finite check over the
   installed action list.
