# भेदः ज्ञानबीजम् — the univalent representation atlas, all thirty-six cells

*handle: `cf-tessera-t-0`, 2026-08-20. Companion module:
`formal/cubical/BhedahJnanabijam_TheConjugacyOfSumAndGapDiesOnTheConeAndTheRatioChartIsNotAQuotientUntilWIsInvertible.agda`,
Agda 2.6.3 + cubical v0.5, `--cubical --safe`, no postulates, no holes,
**exit 0**.*

---

## 0. Whose programme this is

The nine nodes, the demand that every one of the thirty-six pairs carry an
exact status, and the four-state comparison type are the owner's, in

> `collab/upstream/library/raw/ANEKANTA_UNIVALENCE_DELTA_13_2026-08-13.md`,
> §"Univalent representation atlas":
>
> For Prime-Pair, treat the major presentations as nodes: pair field; sum
> projection; gap projection; Mellin/Dirichlet; finite-adic charge; Buchstab
> flow; Hahn/angular; SU(1,1)/Meixner; affine fixed-determinant.
>
> For every pair, determine exact status: equivalence? faithful map?
> quotient? adjunction? transform invertible on a subspace? asymptotic
> relation? analogy only? unknown?
>
> Where equivalence is proved, formalize computational transport in Cubical
> Agda. Where only quotient exists, compute homotopy fibers. Where comparison
> fails, isolate the boundary/hypothesis.

and its epigraph, which is where this note and the module take their name:

> न एकदृष्टिः पर्याप्ता। न सर्वदृष्टयः समानाः।
> यत्र समता प्रमाणिता तत्र परिवहनम्; यत्र न, तत्र **भेदः ज्ञानबीजम्**।

Cells 3.5 and 3.6 below are also the owner's, filled by him in the next
transmission, **Prime-Pair Atlas Delta 18**, 2026-08-13, preserved at
`notes/reflection_ground--owner-messages-FULL-TRANSCRIPT-20260812-to-20260820.md`
lines 1685–1790 (T18.1, T18.2, T18.3).

**No Sanskrit label is invented for any of the mathematics.** The mathematics
is the owner's and this corpus's; the two Sanskrit words in the file name are
a quotation of his own epigraph, and `khahara` in §3.4 is Bhāskara II's term
for the object it names.

---

## 1. Measurement, re-run 2026-08-20

Excluding `collab/upstream/`, `kanye-devotional/` and the reflection streams.

| string | files | of those, in `formal/` |
|---|---:|---:|
| `T18.1` | 28 | 2 |
| `T18.2` | 14 | 2 |
| `T18.3` | 13 | 2 |
| `Delta 18` | 24 | 9 |
| `representation atlas` | 5 | 1 — this session's module |
| `univalent representation atlas` | 1 | 0 |

**The theorems propagated and the table did not.** Before this session,
`representation atlas` occurred zero times in `formal/`, zero in `papers/`,
zero in `collab/`. The one file containing the full phrase is a transcription
of the owner's own words.

Orthography check, per the standing warning that `grep` here returns false
zeros in both directions: `Bhāskara` 69 files, `Bhaskara` 21. Both live;
neither dominates. Node-name counts below were taken with the same care.

---

## 2. Node inventory — what this repository actually has

Delta 13's instruction is to treat each node as a **structure-producing
interpretation, not prose**. Graded on that criterion:

| # | node | status in this corpus | where |
|---|---|---|---|
| 1 | **pair field** | **present, as a type** | `formal/cubical/PrimePairField.agda` (Delta 23 §12), `CenterRelative.agda`, `NaturalMachine/PairCoordinates.agda`, `EGBPairConic.agda` |
| 2 | **sum projection** | **present, but never named as a node** — it exists only as the first component of `Φraw` and as `fibreCentre` | `CenterRelative.agda:56`, `PrimePairField.agda` |
| 3 | **gap projection** | same: second component of `Φraw`, `fibreGap` | as above |
| 4 | **Mellin/Dirichlet** | **prose only.** No Agda or Lean object. Both Agda files that say "Mellin" say it in a comment explaining what they do *not* reach | `NaturalMachine/PayloadMorphism.agda:163,173`, `NaturalMachine/PairCoordinates.agda:182`; content in `notes/PRIME_PAIR_FIELD_PROGRAM_LIBRARY_INDEX.md`, `collab/messages/vajra/mellin-layer-generation-result.md` |
| 5 | **finite-adic charge** | **partial.** A `Bool × Bool` toy of local-coordinate-plus-total-charge is checked; no valuation object, no adic tower | `formal/cubical/ProjectionChargeAudit.agda`, `ProjectionChargeAudit2.agda`; `notes/GLOBAL_CHARGE_DYNAMICS.md`, `notes/FF.md` |
| 6 | **Buchstab flow** | **present, as a rooted-tree grading**, and it carries a refutation of Delta 18's own Buchstab target. The analytic Buchstab identity itself is prose | `formal/cubical/NaturalMachine/BuchstabDegree.agda` |
| 7 | **Hahn/angular** | **partial, and in the other lane.** A bilinear-boundary statement in Lean, which explicitly disclaims having a Hahn eigenbasis. Nothing in cubical | `formal/pairfield/Pairfield/HahnBilinearBoundary.lean`, `notes/DIVISOR_HAHN_INCIDENCE.md`, `notes/HYPOTHESIS_U_AS_A_BILINEAR_FORM.md` |
| 8 | **SU(1,1)/Meixner** | **prose only, and explicitly excluded** by the one Agda file that mentions it | `NaturalMachine/CompressionDefect.agda:100–103`: *"Nothing from Delta 18's SU(1,1) sections… they belong with the Hahn/Meixner statements about positive reals"*; content in `notes/PRIME_PAIR_FIELD_PROGRAM_LIBRARY_INDEX.md` §Meixner |
| 9 | **affine fixed-determinant** | **partial.** Determinant multiplicativity is checked as a monoid morphism on an upper-triangular ℕ sector, and T18.3's wedge/determinant identity is checked over any commutative ring; the affine Buchstab *state space* is prose | `formal/cubical/EGBDetConservation.agda`, `NaturalMachine/PairCoordinates.agda` (`wedge≡det`), `M2Unimodular.agda`; prose in `notes/EGB_LIBRARY_INDEX_V3.md`, `chatgptdump.md` §9 |

**Three of the nine — Mellin/Dirichlet, SU(1,1)/Meixner, and Hahn/angular in
the cubical lane — do not exist here as structure.** They exist as prose, and
prose is what Delta 13's research operator explicitly refuses. I did not
invent presentations for them, and every cell touching them below is marked
open with that as the obstacle.

A caution the string count hides: of the 37 files matching `Hahn`, a
substantial share are **Hahn–Banach**, a different Hahn, in
`notes/OPEN_PROBLEMS_WE_TOUCH.md` and `notes/PROOF_MASS.md`. The node is the
continuous-Hahn/Jacobi angular basis; the two must not be counted together.

**Toolchain note, reported and not fixed:** `CenterRelative.agda`,
`NaturalMachine/PairCoordinates.agda` and `NaturalMachine/CenterRelativeIntegral.agda`
— the three modules carrying the existing pair-field algebra — **do not
typecheck on this container**, because they use `solve!`, which is cubical
v0.9. The container has v0.5, where the tactic is `solve` with the goal in
Π-form. That is why the companion module imports none of them and restates
what it needs. They are other identities' files; I did not touch them.

---

## 3. The cells that are determined

### Why these and not others

I chose pairs by one rule: **the corpus must already carry enough on both
sides that a status can be determined rather than guessed.** That eliminated
twenty-nine of the thirty-six immediately, because at least one endpoint is
prose (§2). Of the seven survivors among {pair field, sum, gap, Buchstab,
affine fixed-determinant}, I took the four where the comparison is a *map*
already in hand, and passed over:

- **⟨pair field, Buchstab flow⟩** and its two relatives — `BuchstabDegree.agda`
  presents Buchstab on a *rooted tree with a level grading*, not on the pair
  field; the comparison would first have to construct the embedding of the
  pair field into that tree, which is a new object, not a status.
- **⟨pair field, affine fixed-determinant⟩** — determinable, and I ran out of
  budget rather than obstacle. `EGBDetConservation.agda` has det as a monoid
  morphism on an ℕ-sector; the honest cell is "faithful map after restricting
  to the subtraction-free sector", and it needs the sector's inclusion checked.
  Marked open with that as the obstacle rather than guessed.
- **⟨sum projection, affine fixed-determinant⟩** — the determinant is the
  *gap*, not the sum (T18.3), so this cell is likely a proved failure; but
  "likely" is not a status.

### 3.1 ⟨pair field, sum projection⟩ — **quotient**

`σ (p,q) = p + q`. Delta 13's stated action where only a quotient exists is
*compute the homotopy fibers*, and they are computed:

```
fibreSum≃ℤ : (w : ℤ) → fiber σ w ≃ ℤ
σ-not-equiv : ¬ (isEquiv σ)
```

The fibre is ℤ **uniformly in w** — the projection is a fibration with
constant fibre, and the fibre coordinate is the first leg. Not an equivalence:
σ identifies (0,1) with (1,0).

### 3.2 ⟨pair field, gap projection⟩ — **quotient**, the same fibre

```
fibreGap≃ℤ : (w : ℤ) → fiber δ w ≃ ℤ
δ-not-equiv : ¬ (isEquiv δ)
```

### 3.3 ⟨sum projection, gap projection⟩ — **empty comparison type, conjugate anyway, and the conjugacy dies on the cone**

Three separate checked facts, and the third is Delta 13's *Immediate target B*.

```
σ≢δ               : ¬ (σ ≡ δ)                        -- Def(σ,δ) is EMPTY
J₁Equiv           : (ℤ × ℤ) ≃ (ℤ × ℤ)                -- one-leg sign flip
gapIsSumAfterFlip : (x : ℤ × ℤ) → σ (J₁ x) ≡ δ x     -- they are CONJUGATE
noConeConjugacy   : ¬ (Σ[ ψ ∈ (Cone → Cone) ]
                        ((c : Cone) → σ (fst (ψ c)) ≡ δ (fst c)))
```

The last is stronger than "J₁ does not preserve the cone": **no function
whatever** from the positive cone to itself conjugates the sum projection into
the gap projection there, because σ is positive on the whole cone and δ takes
the value −1 at (2,1). Equivalence upstairs, inequivalent effective subspaces
downstairs — which is what the owner reports in the ratio chart as **T18.2**,
*"the sum-gap operation sends |x|<1 to |x|>1 … it exits the real positive-cone
chart. This sharply corrects earlier language."* Same phenomenon, different
chart, and the module checks it in the chart where ℤ suffices.

### 3.4 ⟨pair field, Hahn/angular⟩ — **quotient after deleting one point, and the point is 0÷0**

T18.1's comparison is the ratio `x = R/W`. Over ℤ there is no division, so the
module checks (a) the denominator-free shadow, and (b) what the ratio relation
actually is.

Denominator-free, one line of ring algebra each, no analytic content claimed:

```
t-share         : (p q : ℤ) → σ (p,q) - (p + p) ≡ δ (p,q)   -- T18.1's x = 1-2t
T18-2-inversion : (W R : ℤ) → (- W) · R ≡ W · (- R)          -- T18.2's x ↦ 1/x
```

The content is the relation `SameRatio x y := δ x · σ y ≡ δ y · σ x`. It is
reflexive, symmetric, dilation-invariant — and **not transitive**:

```
sameRatio-dil         : (k : ℤ) (x : PairField) → SameRatio (dil k x) x
ratio-not-transitive  : ¬ ((x y z : PairField) → SameRatio x y
                                               → SameRatio y z → SameRatio x z)
```

with the explicit witness `(1,2) ~ (0,0) ~ (1,3)` and `(1,2) ≁ (1,3)`
(`pos 4 ≢ pos 6`). So **the ratio chart is not a quotient of the pair field at
all** until something is deleted. The obvious hypothesis is `W ≠ 0`, and it
works (`ratio-trans`, by ℤ-cancellation). **It is not sharp**, and the reason
is a distinction this repository already holds:

`formal/cubical/Khahara.agda` records Bhāskara II's *khahara* (Līlāvatī /
Bījagaṇita, 1150, correcting Brahmagupta, *Brāhmasphuṭasiddhānta*, 628): `n÷0`
with `n ≠ 0` is a determinate non-finite quantity, and it is a **different
thing** from `0÷0`, whose defect — per that module's own 2026-08-19 correction
— is that the solution set is not a singleton.

That is exactly the distinction the ratio chart makes. A khahara point
(`W = 0`, `R ≠ 0`) relates only to points whose own `W` vanishes, and
transitivity through it holds. Only `0÷0` — `W = R = 0` — relates to
everything, and destroys transitivity:

```
ratio-trans-sharp : (x y z : PairField) → ¬ ((σ y ≡ 0) × (δ y ≡ 0)) →
                    SameRatio x y → SameRatio y z → SameRatio x z
originOnly        : (p q : ℤ) → σ (p,q) ≡ 0 → δ (p,q) ≡ 0 → (p,q) ≡ (0,0)
```

**The divisor to delete is not `W = 0`. It is one point.** With
`ratio-not-transitive` supplying failure at that point and `ratio-trans-sharp`
supplying success everywhere else, "exactly one point" is a theorem here, not
a manner of speaking.

### 3.5 ⟨gap projection, affine fixed-determinant⟩ — **owner-filled, T18.3, and formalized**

Delta 18 T18.3: *"h is the exterior product (B,t)∧(A,s)"* — the additive gap,
the determinant/wedge invariant, and the p-adic collision depth are one
quantity. This one is not merely asserted: `NaturalMachine/PairCoordinates.agda`
checks `wedge` and `wedge≡det` over an arbitrary commutative ring. Marked
`ownerFilled` and **not re-landed**; it is another identity's module and it is
correct. (It does not typecheck on this container — see §2's toolchain note.)

### 3.6 ⟨Hahn/angular, SU(1,1)/Meixner⟩ — **owner-filled, T18.1; transport NOT formalized anywhere**

Delta 18 T18.1: *"ratio x₂/x₁, split-torus parameter η, and Jacobi coordinate
x are the same rank-one orbit coordinate in three charts."* That is an
**equivalence claim**, and Delta 13's stated action for equivalence is
*formalize the computational transport in Cubical Agda*.

**It is not formalized.** `T18.1` occurs in exactly two files under `formal/`;
one is this session's module and the other is
`NaturalMachine/CompressionDefect.agda`, which says in its own header that it
checks **nothing** from Delta 18's SU(1,1) sections.

`unknown-in-corpus`, with the settling computation named: T18.1 needs `tanh`
and `log` on positive reals. **Cubical v0.5 ships no ℝ** — there is
`Cubical.Data.Rationals` and no analysis — so the transport is out of reach in
this lane. It is *not* out of reach in the other: `formal/pairfield/` is Lean
with mathlib, which has `Real.tanh`, `Real.log` and the hyperbolic identities,
and `Pairfield/HahnBilinearBoundary.lean` is already the file it would extend.
**That is the concrete next step and it belongs to whoever works the Lean lane.**

---

## 4. What I refuted of my own

Both are checked in the module, both were load-bearing when I wrote them.

**Claim 1.** *If f, g : A → B present two nodes and Def(f,g) := (f ≡ g) is
empty, the two nodes are distinct perspectives and the cell is a proved
failure.* — This was the grading rule of my first draft of the table below.
It is **false**. §3.3 is the counterexample: `Def(σ,δ)` is empty and σ, δ are
nevertheless conjugate by an equivalence of the pair field.

```
emptyDefDoesNotSeparate :
  ¬ ( (A B : Type₀) (f g : A → B) → ¬ (f ≡ g) →
      ¬ (Σ[ e ∈ (A ≃ A) ] ((x : A) → f (equivFun e x) ≡ g x)) )
```

Emptiness of the comparison type is information about **one choice of parallel
routes**, not about the nodes. Delta 13 says *"absence or nonuniqueness of
comparison is information"* — it is, but it is not this information, and a
table graded by my rule would have marked ⟨sum, gap⟩ a proved failure when the
two are the same projection composed with a sign.

The neighbouring theorem from the other side, landed today by another identity:
`NaturalMachine/TransportPrice_AgreementDoesNotDetermineTheTransport.agda` —
agreement does not determine the transport. This says disagreement does not
deny it.

**Claim 2.** *The ratio chart is a quotient after deleting the divisor W = 0.*
— True, and **not sharp**: §3.4's `ratio-trans-sharp` deletes one point
instead. In a status table a hypothesis that is true and not sharp reads as a
bigger obstruction than there is, which is the specific way a table of this
kind goes wrong. Both statements are kept in the module, in that order,
because the second is only legible as a correction of the first.

---

## 5. The table — all thirty-six cells

Key: **C** = determined here, by a term; **O** = determined by the owner in
Delta 18; **·** = not attempted, with the obstacle named.

The three counts and the edge count are **machine-checked in the module**
(`nineNodes`, `thirtySixEdges`, `checkedCount ≡ 4`, `ownerCount ≡ 2`,
`openCount ≡ 30`), against the enumeration's *size* and not only its
non-emptiness. If a cell here is re-graded and the module is not, the module
stops compiling.

| | pair | status | obstacle, or the statement |
|---|---|---|---|
| 1 | pair field — **sum projection** | **C** | **quotient.** `fibreSum≃ℤ`, `σ-not-equiv`. §3.1 |
| 2 | pair field — **gap projection** | **C** | **quotient.** `fibreGap≃ℤ`, `δ-not-equiv`. §3.2 |
| 3 | pair field — Mellin/Dirichlet | · | no Mellin object exists in the corpus (§2 node 4); a status would be invented |
| 4 | pair field — finite-adic charge | · | charge exists only as a `Bool × Bool` toy; no valuation map from the pair field to it |
| 5 | pair field — Buchstab flow | · | Buchstab is presented on a rooted tree, not on the pair field; the comparison requires building the embedding first |
| 6 | pair field — **Hahn/angular** | **C** | **quotient after deleting one point.** `ratio-not-transitive`, `ratio-trans-sharp`, `originOnly`. §3.4 |
| 7 | pair field — SU(1,1)/Meixner | · | reachable only through cell 34 (T18.1), which is unformalized; would inherit its ℝ requirement |
| 8 | pair field — affine fixed-determinant | · | determinable and not done. `EGBDetConservation.agda` has det on the subtraction-free ℕ sector; the cell needs that sector's inclusion checked. **The best open cell.** |
| 9 | **sum projection — gap projection** | **C** | **Def empty, conjugate upstairs, no conjugacy on the cone.** `σ≢δ`, `gapIsSumAfterFlip`, `noConeConjugacy`. §3.3 |
| 10 | sum projection — Mellin/Dirichlet | · | node 4 is prose. The intended content is Delta 18's third level, `(ρ,ρ′) ↔ (s,ν)` |
| 11 | sum projection — finite-adic charge | · | node 5 is a toy; the intended content is `s_ℓ = v_ℓ(p)+v_ℓ(q)`, in `CenterRelativeIntegral.agda` but not as a comparison |
| 12 | sum projection — Buchstab flow | · | as cell 5 |
| 13 | sum projection — Hahn/angular | · | the ratio is R/W; the sum is its denominator alone. Likely "denominator of", not a status yet |
| 14 | sum projection — SU(1,1)/Meixner | · | as cell 7 |
| 15 | sum projection — affine fixed-determinant | · | T18.3 makes the determinant the *gap*; this cell is likely a proved failure, and "likely" is not a status |
| 16 | gap projection — Mellin/Dirichlet | · | node 4 is prose |
| 17 | gap projection — finite-adic charge | · | intended content `d_ℓ = v_ℓ(q)−v_ℓ(p)` and `v_p(α−β) = v_p(h)` (T18.3); no valuation object |
| 18 | gap projection — Buchstab flow | · | as cell 5 |
| 19 | gap projection — Hahn/angular | · | the gap is the ratio's numerator alone; same shape as cell 13 |
| 20 | gap projection — SU(1,1)/Meixner | · | as cell 7 |
| 21 | **gap projection — affine fixed-determinant** | **O** | **T18.3, and formalized** — `wedge≡det` in `NaturalMachine/PairCoordinates.agda`. §3.5 |
| 22 | Mellin/Dirichlet — finite-adic charge | · | both nodes prose or toy |
| 23 | Mellin/Dirichlet — Buchstab flow | · | node 4 is prose |
| 24 | Mellin/Dirichlet — Hahn/angular | · | node 4 is prose. Delta 18 asserts the continuous-Hahn transform *is* Mellin analysis of the ratio direction — the strongest unformalized claim in the atlas after T18.1 |
| 25 | Mellin/Dirichlet — SU(1,1)/Meixner | · | both nodes prose |
| 26 | Mellin/Dirichlet — affine fixed-determinant | · | node 4 is prose |
| 27 | finite-adic charge — Buchstab flow | · | `BuchstabDegree.agda` refutes one proposed comparison (the excursion–return identification) but does not supply the positive cell |
| 28 | finite-adic charge — Hahn/angular | · | node 7 absent in this lane |
| 29 | finite-adic charge — SU(1,1)/Meixner | · | both prose or toy |
| 30 | finite-adic charge — affine fixed-determinant | · | intended content is collision depth as `v_p(det)`; needs a valuation object |
| 31 | Buchstab flow — Hahn/angular | · | node 7 absent in this lane |
| 32 | Buchstab flow — SU(1,1)/Meixner | · | node 8 is prose |
| 33 | Buchstab flow — affine fixed-determinant | · | `chatgptdump.md` §9 asserts affine peeling preserves the determinant; not formalized, and the peeling operator is not defined in `formal/` |
| 34 | Hahn/angular — SU(1,1)/Meixner | **O** | **T18.1 asserts equivalence; transport NOT formalized anywhere.** Settled by a Lean development over ℝ; unreachable in cubical v0.5 (no ℝ). §3.6 |
| 35 | Hahn/angular — affine fixed-determinant | · | node 7 absent in this lane |
| 36 | SU(1,1)/Meixner — affine fixed-determinant | · | node 8 is prose |

**Shape of the result: 4 determined by proof, 2 by the owner, 30 open — and
not one cell of the thirty-six is an equivalence proved here.** All four
determined cells are quotients or failures. That is not a disappointment; it
is Delta 13's epigraph read literally, and every one of the four produced a
sharper object than an equivalence would have: a uniform fibre, a boundary
that breaks, and a single deleted point that a 1150 text already had a name for.

**The single most important structural fact the table exposes**, counted cell
by cell rather than asserted:

- **19 of the 30 open cells** (3, 7, 10, 13, 14, 16, 19, 20, 22, 23, 24, 25,
  26, 28, 29, 31, 32, 35, 36) touch one of the **three nodes that have no
  structure-producing presentation here at all** — Mellin/Dirichlet,
  SU(1,1)/Meixner, and Hahn/angular in the cubical lane.
- **11 of the 30** (4, 5, 8, 11, 12, 15, 17, 18, 27, 30, 33) touch nodes that
  *are* present but on the wrong carrier: finite-adic charge exists as a
  `Bool × Bool` toy with no valuation object, and Buchstab flow exists on a
  rooted tree with no map from the pair field to it.

So the atlas is not thirty-six independent problems. It is **three missing
objects and two carrier mismatches**, and cell 34 names the lane —
`formal/pairfield/`, Lean, mathlib — in which the first of the three is
reachable today.

---

## 6. What I want refused

- **Cell 34, marked `unknown`.** If anyone can produce T18.1's transport in
  cubical without ℝ — for instance by taking the split-torus parameter as
  formal and checking the identity at the level of the group law rather than
  of `tanh` — the `unknown` is wrong and I want it struck.
- **Cell 8**, which I marked open for budget, not obstacle. If it is harder
  than I said, say so; if it is easier, take it.
- **§3.4's sharpness.** I claim the deleted set is exactly one point. The
  proof of the positive direction uses `isIntegralℤ`; if the argument leaks a
  hypothesis I did not notice, the "one point" collapses back to a divisor.
- **The reading of cell 9 as a *conjugacy* rather than a failure.** I refuted
  my own rule to get there (§4, Claim 1). If the refutation is right but the
  conclusion is still wrong — if conjugacy by a total-space automorphism is
  the wrong notion of sameness for an atlas node — that is worth more than the
  cell.
