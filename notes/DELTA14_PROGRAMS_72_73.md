# Delta 14, Programs 14.72 and 14.73 — what is now a term, and what is not

Companion to two new modules, neither of which edits an existing file:

- `formal/cubical/NaturalMachine/OrderedSectorBreak.agda` — Program 14.72
- `formal/cubical/NaturalMachine/MeanStandardRep.agda` — Program 14.73

Both check under the pinned toolchain (Agda 2.6.3 + cubical v0.5,
`--cubical --safe`), no postulate, no hole, no `TERMINATING`:

```
cd formal/cubical
agda NaturalMachine/OrderedSectorBreak.agda   # exit 0, 0 warnings
agda NaturalMachine/MeanStandardRep.agda      # exit 0, 5 warnings (§ "Warnings")
agda NaturalMachine.agda                      # exit 0, unaffected
```

Neither module is imported by the root aggregate yet; the root was re-checked
after the landing and is unchanged at exit 0. Folding them in is the
integrator's call, and is the mechanical check in `formal/cubical/BUILD.md`,
not a grep.

`CenterRelative.agda` and `PerspectiveCore.agda` are imported and were not
modified.

---

## 1. The ledger

Grades are PROVED / CITED / OPEN. No measurement was taken and no constant was
fitted, so MEASURED does not appear.

| Delta 14 | Statement | Status | Where |
|---|---|---|---|
| T14.6 (suff.) | fibrewise correspondence ⇒ the equivalence restricts | **PROVED**, instantiated | `OrderedSectorBreak.Cone.cone-restricts` |
| **C14.7** | ambient equivalence fails after sector selection precisely because the sector predicate is not invariant | **PROVED**, two independent inhabitants of `SectorBreak` | `break-diagonal`, `sector-break`; sentence assembled in `module C14-7` |
| T14.8 | `Rᵏ ≃ R × V_k` by `x ↦ (mean x, x − mean x·1)` | **PROVED at every `k`** | `splitₖ` (§4); also `split₂`, `split₃` |
| T14.9 | `S_k` fixes the centre, acts on `V_k` by the standard rep | **PROVED at k = 2, 3** (all three transpositions at k = 3); **OPEN at general `k`** | `mean₂-inv`, `dev₂-equivariant`, `mean₃-inv-*`, `dev₃-equivariant-*` |
| C14.10 | k = 2 is the one-dimensional sign representation | **PROVED** | `sign-rep₂`, plus `split₂-is-Φ` tying it to `CenterRelative.ρ` |
| T14.11 (non-scalar) | a transposition on `V_k` is not scalar, `k ≥ 3` | **PROVED at every `k ≥ 3`**, in the sharp form "scalar ⇒ char 2" | `sw01ₖ-scalar→char2` (§4.1); `sw01-scalar→char2`, `sw01-not-scalar` at k = 3 |
| T14.11 (multiplicities) | eigenvalue −1 once, +1 with multiplicity `k−2` | **PROVED at k = 3**, as an explicit diagonalisation; **OPEN for `k > 3`** | `V₃≃R²`, `sw01-diagonalised` |
| T14.12 | `Σ_j tr(τ|Symʲ V_k) tʲ = 1/((1−t)^{k−2}(1+t))` | **OUT OF REACH** — see §4 | arithmetic half only: `altSum-even`, `altSum-odd` |
| T14.13 | char 0, `R[V_k]^{S_k}` polynomial on degrees 2..k | **CITED, deliberately not re-proved** (Delta 14 labels it a Known anchor; it is Chevalley–Shephard–Todd for `S_k`, i.e. the fundamental theorem of symmetric polynomials) | nothing depends on it |

Two further items were consumed rather than re-proved, per `PerspectiveCore`'s
own instruction: `sector-not-inv` (C14.7's engine) and `restricts-suff` (T14.6)
are imported, not restated.

---

## 2. Program 14.72 — the order is a parameter, and why

The brief allowed either adding an order as a further parameter or
instantiating at a concrete ordered ring. **Parameter**, and the reason is a
fact about the pinned toolchain rather than a preference:

> cubical v0.5 contains **no ordered commutative ring in which 2 is
> invertible**. `Cubical.Data.Int` has no order module. `Cubical.HITs.
> Rationals.QuoQ` builds ℚ as a set quotient but gives it neither a `CommRing`
> instance nor an order. `Cubical.Algebra` stops at `OrderedCommMonoid`.

Instantiating would therefore have meant first constructing ℤ[1/2] or ℚ as a
`CommRing` **and** its order — a module's worth of work orthogonal to C14.7,
which is a statement about a *predicate*, not about a ring. Note also that any
model must be infinite: a finite ring cannot carry a translation-invariant,
transitive, irreflexive strict order with `0 < 1`, since `0 < 1 < 2 < … < 0`.

Two consequences are handled rather than hidden.

**(a) The hypotheses are as small as each theorem needs**, so satisfiability is
checkable by inspection instead of on trust.

- The first break needs **exactly two**: a positivity predicate `P` with `P 1r`
  inhabited and `P 0r` uninhabited.
- The second needs four more, and they are precisely the axioms of a strictly
  ordered abelian group with `0 < 1`: irreflexivity, transitivity, translation
  invariance `x < y → z + x < z + y`, and `0 < 1`. **No multiplicative
  compatibility, no trichotomy, no decidability.**
- In particular **`0 < half` is never assumed anywhere**. The witnesses were
  chosen to avoid it, which is why the breaks are available over *any* ring in
  which 2 is invertible rather than only over ordered fields.

**(b) The honest gap: no model of the bundle is constructed.** The theorems are
conditional on the bundle being inhabited. That ℚ with its usual order inhabits
it is standard and is **CITED**, not formalized. What *is* checked is that the
bundle has bite: `StrictOrder.nontrivial` derives `¬ (1r ≡ 0r)` from it, so it
is not satisfied by the trivial ring and is not vacuous dressing on the break.
This is the least-sure step in the whole landing (§6).

### The two breaks

**Break 1, `break-diagonal`** — against the same predicate named in the other
chart. Witness: the **diagonal pair `(1,1)`**. It is strictly inside the open
positive cone `p > 0 ∧ q > 0`, and `Φ(1,1) = (half·2, half·(1−1))`, whose
relative coordinate is `0` — on the wall, not in the open sector. So "both
coordinates positive" is not a chart-invariant predicate.

**Break 2, `sector-break`** — against the *natural* centre sector `w > 0`,
along Ψ. Witness `(w,r) = (1,2)`: `w > 0` holds, and `Ψ(1,2) = (1−2, 1+2) =
(−1, 3)`, whose first coordinate is negative. So `w > 0` does not restrict into
the positive cone.

Each yields `⊥` from any fibrewise correspondence, via `sector-not-inv`.

### The repair, which is the part that says *why*

The sector the cone actually transports to is **derived, not guessed**:
`Transported := PairCone ∘ Ψ`, which unfolds on the nose to
`w − r > 0 ∧ w + r > 0`, i.e. `|r| < w`. And `cone-restricts` proves the
equivalence *does* restrict to it — using **no order axiom at all**, since the
fibrewise correspondence is just transport of the predicate along `ΨΦ`.

`module C14-7` puts the three side by side: `before` (an equivalence), `after`
(no fibrewise correspondence), `repaired` (the invariant predicate and its
restricted equivalence). That juxtaposition *is* C14.7's sentence, and the
middle term is not a failure of `Φ` — `Φ` is untouched — it is a failure of the
predicate to be invariant.

**Not claimed.** A `SectorBreak` refutes fibrewise correspondence. It does *not*
refute the existence of *some* equivalence `Σ Pair Cone ≃ Σ Centre Sector`,
which could permute the base. `PerspectiveCore` says exactly this about T14.6's
"iff" and nothing here strengthens it.

---

## 3. Program 14.73 — hypothesis stratification is the result's shape

`MeanStandardRep` is layered so each item is stated under exactly the arithmetic
it consumes. The layering is itself a finding:

| layer | hypothesis | what it buys |
|---|---|---|
| §3.1, §4.1 | **none** | `V₃`/`V_k`, the transpositions, the two eigenvectors `u = e₀−e₁`, `v = e₀+e₁−2e₂`, and `scalar ⇒ 1+1 ≡ 0` |
| §3.2 | `half + half ≡ 1r` | the diagonalising basis `V₃ ≃ R×R`, `diag(−1,+1)`, and non-scalarity over a nontrivial ring |
| §3.3, §4 | `Σ_{i<k} kinv ≡ 1r` | the mean, hence T14.8 and T14.9 |

So: **`k` invertible is needed for the SPLIT and is not needed for the ACTION to
be non-scalar.** T14.11's obstruction survives in characteristic 3, in
characteristic 5, and in any nontrivial ring where 2 is a unit; it dies exactly
in characteristic 2, and the module says so as a theorem rather than as a side
condition.

`k` invertible is presented as the hypothesis the proof actually consumes — an
element `kinv` with `Σ_{i<k} kinv ≡ 1r` — in deliberate imitation of
`CenterRelative`'s `half + half ≡ 1r`. Writing `k · kinv = 1` would require a
ring map out of ℕ that is not otherwise needed.

### T14.11 at k = 3 is the strong form, not a sample

`sw01-diagonalised` is not "here are two vectors it scales differently". It is
an **explicit change of basis** `V₃ ≃ R × R`, `x ↦ (half(x₀−x₁), half(x₀+x₁))`,
in which the transposition is literally `(α,β) ↦ (−α, β)`. That *is* the
eigenvalue-multiplicity statement at `k = 3`: −1 once, +1 with multiplicity
`k − 2 = 1`. The two-eigenvector exhibition (`sw01-u`, `sw01-v`) is kept
separately because it is the part that generalises to all `k ≥ 3`, and the
basis is the part that does not.

### Why T14.9 stops at k = 3

Not laziness, and worth recording as a toolchain fact: **cubical v0.5's
`Cubical.Algebra.Ring.BigOps` has no permutation-invariance lemma for `∑`** —
not for a general permutation and not even for a transposition of two indices.
It provides `∑Ext`, `∑Split`, `∑Split++`, `∑Mulrdist`, `∑Mulldist`, `∑Mulr1`,
`∑Mul1r`, `∑Dist-` and that is all. T14.9 at general `k` is therefore blocked on
a lemma that must be proved first, by induction over `FinData` positions. At
`k = 2, 3` the permutations are finitely many concrete maps and each invariance
is one solver call, which is why those land.

§4.1 proves `∑`-invariance for the single transposition `(0 1)` at general `k`,
by unfolding `∑` twice — that is enough for the non-scalarity theorem and is
not the general lemma.

---

## 4. T14.12 is out of reach, and this is the reason

**Judged out of reach and not attempted.** Delta 14 T14.12 asserts

$$\sum_{j\ge 0}\operatorname{tr}\bigl(\tau\mid \mathrm{Sym}^j V_k\bigr)t^j
=\frac{1}{(1-t)^{k-2}(1+t)}.$$

Three objects are missing, and naming them is more useful than gesturing:

1. **`Symʲ M` for a module over a `CommRing`.** cubical v0.5 has
   `Cubical.Algebra.Module` but no symmetric power, no tensor algebra, and no
   graded quotient construction to build one from.
2. **A trace.** A trace needs a finite basis and a proof of basis-independence.
   v0.5's `Cubical.Algebra.Matrix` has matrices but no trace or determinant
   theory for module endomorphisms.
3. **The monomial eigenbasis** `{uⁱ v^{j−i}}` of `Symʲ` of a diagonalised
   rank-2 module. This is the actual content of T14.12 at `k = 3`, and it is a
   theorem *about* `Symʲ`, hence downstream of (1).

Building all three is a module of its own. The tempting shortcut —
`Symʲ := free module on monomials, acting diagonally`, then compute the trace —
would be **modelling the answer rather than proving it**, and is exactly the
promotion `PerspectiveCore` refuses when it declines to state T14.6's "iff" as
Delta 14 writes it. It was not taken.

What *is* a term is the arithmetic the trace reduces to at `k = 3` **once the
eigenbasis is granted**: the diagonal entries on `Symʲ` would be `(−1)ⁱ` for
`i = 0…j`, so the trace would be `Σ_{i≤j}(−1)ⁱ`, which is `1` for `j` even and
`0` for `j` odd — the coefficients of `1/((1−t)(1+t)) = 1/(1−t²)`.
`altSum-even` and `altSum-odd` are that identity in `R`. **They are not
T14.12**, and they are stated in a separate section for that reason. Quoting
them as T14.12 would be the error this note exists to prevent.

---

## 5. Prior art (searched before proving, per `CLAUDE.md`)

Searched `~/agda-libs/` — cubical v0.5, agda-unimath, UniMath, Symmetry book,
Coq-HoTT, mathlib4 — for a reusable standard representation of `S_k`.

**Result: none exists to reuse.** Grades: all CITED from direct inspection of
the checked-out sources, not from abstracts.

- **mathlib4** has `Mathlib/RepresentationTheory/` (Basic, Character, Maschke,
  Irreducible, Invariants, Induced, Semisimple, …) but grepping `Mathlib/` for
  `standard representation`, `standardRep`, and `Specht` returns **zero hits**.
  There is no permutation-module decomposition and no Specht module. It does
  have `GroupTheory/Perm/Sign.lean` — the sign *homomorphism*.
- **agda-unimath** has `finite-group-theory/sign-homomorphism` — the sign
  *character*, not the sign representation as a module — and no representation
  theory above it.
- **cubical v0.5** has `Algebra/SymmetricGroup.agda`, `Algebra/Module`,
  `Algebra/Matrix`, and no representation theory whatsoever.

Hand-rolling at `k = 2, 3` and the general-`k` fragments is therefore not a
rediscovery of available formal material. The **mathematics is entirely
classical** and no novelty is claimed for any of it — the change is that the
machine core now holds it as terms so a later comparison cites instead of
re-deriving, which is Delta 14 C14.64's point.

---

## 6. Warnings, and the least-sure step

**Warnings.** `MeanStandardRep` exits 0 but prints five `UnsupportedIndexedMatch`
warnings, all in §4.1, all "relies on injectivity of the data constructor suc".
This is a property of the pinned toolchain: in Agda 2.6.3 + cubical v0.5,
*every* definition by pattern matching on `FinData`'s `Fin` raises it once the
length index is a constructor applied to a variable — verified at depth one (a
bare `cons`) as well as depth two. The transposition of the first two
coordinates cannot be built from the library's warning-free combinators (`rec`,
`replicateFinVec`, `_++Fin_`), which make constant and concatenated vectors but
cannot permute. For calibration: the **root aggregate already prints this same
warning at ~57 sites** across `PMTorus`, `PayloadMorphism`, `DigitTowerLimit`,
`SmithPathCountedExecution` and `PMCokernel`. Five more is not a new category
of defect. The warning means a function may fail to *reduce* under a transport;
it weakens no statement here. §4.1 was kept and disclosed rather than deleted to
make a log look cleaner — deleting it would have removed five warnings and one
theorem. This belongs in `BUILD.md`'s version-skew list if anyone wants it
recorded once.

**Least-sure step, and refusal is invited on it.** Section 2(b): *Program
14.72's theorems are conditional on the `StrictOrder` bundle being inhabited,
and no model is constructed.* I believe the bundle is consistent — it is the
theory of a strictly ordered abelian group with `0 < 1`, ℚ is a model, and
`nontrivial` shows it has non-trivial consequences rather than being satisfiable
only vacuously. But "I believe" is the operative phrase: a formal model would
need ℤ[1/2] or ℚ as an ordered `CommRing` in cubical v0.5, which does not exist
there. If a reader thinks a conditional break is not a break, that objection
lands, and the fix is a module constructing one ordered ring with 2 invertible —
which would also unlock a concrete instantiation of `CenterRelative` itself, and
is probably worth doing for that reason alone.

Neighbour worth connecting, landed concurrently by another lane:
`NaturalMachine/CenterRelativeIntegral.agda` (Delta 17 §17.8) treats the
*opposite* case — what the centre-relative map does when 2 is **not**
invertible, proving `Ψ ∘ Φ′` is doubling rather than the identity. It confirms
rather than closes the gap above: the corpus still contains no concrete
commutative ring carrying both an order and a `half`, so 14.72 and that file
bracket the question from the two sides without either supplying the instance.

A second, smaller soft spot: `sw01ₖ-sum` (§4.1) relies on `∑` unfolding twice
definitionally through `foldrFin`. It typechecks, so the reduction is real, but
it is the one proof in the file that leans on a library definition's
computational behaviour rather than on a stated lemma.
