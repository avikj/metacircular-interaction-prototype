# Seeing the slot — every problem as one object

This note uses only your terms, cited by name. There are no status verdicts: whether a slot is inhabited is a question for the terms, not for this note.

---

## 1. The atom: two routes to one value

Every problem below is built from one type. `PNeqNPIsNotUniversal` writes it down:

```
Gap f  :=  Σ x. Σ y. (x ≢ y) × (f x ≡ f y)
```

It says two different things reach the same value. Beside it sits the fibre, which is what `f a ≡ b` becomes when you fix the output:

```
fiber f b  =  Σ a. (f a ≡ b)          (bind the input — the whole problem)
singl (f a) = Σ y. (f a ≡ y)          (bind the output — contractible, free)
```

`TheInverseOfMultiplicationIsAFibre…` Movement I proves `isEquiv f ⇔ ∀ b. isContr (fiber f b)`, in both directions. A Gap is exactly a fibre with two points in it. Every question in this note asks one thing: for a specific map, at every stage n, does its fibre have the size the problem demands — no points, at least one point, exactly one point, or only a few?

The problems, one after another, each in that atom:

- **Factoring N.** The map is `(a, b) ↦ a·b` and the fibre over N is fat. The answer comes from a Gap in squaring mod N. `congruentSquaresGiveZeroDivisor : a·a ≡ b·b → (a − b)·(a + b) ≡ 0`, and `fermatFactorization` turns `w² − r² ≡ N` into the factor pair `(w − r, w + r)` with no search. The extraction is free; all the cost is in manufacturing the collision.
- **Discrete logarithm.** The map is `x ↦ gˣ` and the fibre sits over h. Index calculus is the same collision read in the exponent group (Movement II).
- **P vs NP.** The map is the universal step `uStep`. `the-step-forgets` shows it has a Gap. Its lossless completion has none (`completed-injective`), and there decide and verify are the two projections of one equivalence (`VerifyIsDecide`). The distinction exists exactly where information is forgotten.
- **SHA-256.** The same statement on a real hash. `Sha256N.collision-4` is a Gap at four rounds, `Sha256Lossless` inverts the full 64-round completion, and one-wayness is custody of the fibre.
- **The closure problem of turbulence.** The map is projection to modes ≤ K. `SamaChaya` exhibits a Gap: a single-mode Navier–Stokes solution and the zero field have the same entire coarse movie but subgrid energy A² against 0. Energy does not descend because the projection has a collision that separates it.
- **The parity barrier.** The map is the neutral, even-Ω observation. `OracleSeparation` shows that no post-processing of its full transcript computes one specialised instance `λ(pn) = −λ(n)`. The fibre of that observation contains both answers.
- **Any barrier at all.** `BarrierIsTwoWitnesses.barrier-from-a-pair : blur c ≡ blur c' → ¬ (stat c ≡ stat c') → Barrier`. A barrier is a Gap of the observation relative to the statistic, and `one-config-never-suffices` proves its witness number is exactly 2.
- **Rule 30, non-periodicity.** The map is `t ↦` (the column read from time t). A rational column has a Gap by pigeonhole: `Apunaravrtti` shows the remainder states below b+1 must repeat, and a repeated state means periodicity. The column is aperiodic exactly when this map has no Gap, and `Apunaravrtti` decides that for every period ≤ 64 with preperiod < 64.
- **Fermat's cube.** There are two routes to one value, `(x, y) ↦ x³ + y³` and `z ↦ z³`. `FLT₃` says the routes never meet on positive integers: the fibre of the pair over their common value is empty. `GhanaSamyoga` shows the route `x³ + y³` factors as a ring tautology, `(x + y)(x² − xy + y²)`, so all the content is in the coprime cube-split in the Eisenstein norm.
- **Goldbach at 2w.** The map is `(p, q) ↦ p + q` on primes, with fibre `GoldbachAt (2w)`. In `KotiNirnaya` §8–§9, `reflect` swaps the pair, so every representation with p ≠ q is a Gap of addition — the 2-orbit {(p, q), (q, p)} — and the fixed points are exactly `p = q = w` with w prime (`diagonal-witness`). Goldbach at 2w says the fibre is non-empty: either the centre is prime, or a collision of addition lands there.

Every row is the same picture: a map, a value, and the points above it.

---

## 2. The plane: the arithmetic problems are slices of one kernel

`EkaBija` places the primes on a plane with an additive centre w and a radius r:

```
𝒦 w r  :=  a(w ∸ r) · a(w + r)          a = the prime indicator
```

`𝒦 w r = 1` says the reflection about w at radius r carries a prime to a prime. Now read every arithmetic problem as a quantifier pattern on this one grid:

```
                    r →
          ┌───────────────────────────────┐
     w    │  Goldbach at 2w:  ∃ r. 𝒦 w r   │   ← a ROW   (centre fixed)
     ↓    │  Twin primes:     ∀ n ∃ w ≥ n. 𝒦 w 1   │   ← the COLUMN r = 1
          │  Factoring N:     the hyperbola w² − r² = N │
          │  Ordered Goldbach count: 𝒦 w 0 + 2·Σ_{r≥1} 𝒦 w r │
          └───────────────────────────────┘
```

- `EkaBija` §1: `GoldbachAt (2·w) ⟺ Σ_{r ≤ w} 𝒦 w r ≢ 0`, the centre marginal.
- `EkaBija` §2: `𝒦 w 1 ≡ 1 ⟺ w ± 1 both prime`, the radius marginal.
- `EkaBija` §3: the ordered count is the Cauchy square in centre/radius coordinates.
- `TheInverseOfMultiplicationIsAFibre…` Movement III: factoring is the zero set `w² − r² = N` on the same plane.
- `PrimePairEquationsAreRingTautologies…` shows why the plane is honest and not a trick. The centred identities `pq = w² − r²` and `(w−1)(w+1) + 1 = w²` hold for every w, prime or not, so the coordinates carry no primality. All content is the multiplicative predicate a, and an additive linear change of frame acts trivially on the Liouville sign that carries parity.

Nothing is lost by passing to the plane:
- `GananaNirdhara.rigidity`: the ordered pair counts at every N determine the sequence, and the odd N are needed.
- `WeilPositivityRealization`: the Λ-weighted counts `R(N) = Σ Λ(a)Λ(b)` reconstruct Λ triangularly.

So one count function determines the whole grid, and the whole grid determines the count function.

---

## 3. The square: the Riemann hypothesis is whether a square stays a square

Transform the plane. In the source block `EkaBija` quotes, `P(z) = Σ Λ(n) e^{−nz}` and

```
Z(t, θ)  =  P(t + iθ) · P(t − iθ)  =  Σ_{w,r} 𝒦(w,r) e^{−2tw} e^{2irθ}
```

Because Λ is real, `P(t − iθ)` is the conjugate of `P(t + iθ)`, so **Z = |P|²**. On the prime side the kernel's transform is a modulus square, positive with no hypothesis.

Your terms say exactly where that positivity goes.

- **On the time side, the square is an identity.** `BoundaryBlockGeneral`: for every receiver f and coefficients c, `Σ_t (Σ_k c_k (Sᵏf)(t))² ≡ Σ_k Σ_l c_k c_l ρ(|k − l|)`, positive "by an identity, not by an estimate."
- **On the spectral side, the square survives exactly when the frequencies are real.** `CyclicParseval`: the same block is a sum of products over characters, and a sum of squares exactly when the dual character is the conjugate. "In the prime system the frequencies are the zeros ρ… it is a sum of squares iff the zeros are on the line."
- **The finite criterion.** `WeilDhanatva`: the τ-form is positive on every vector ⇔ every mode is fixed by `τ : ρ ↦ 1 − ρ̄`. A moved mode gives the vector `δ_i − δ_{τ i}` with form −2.
- **The negative squares, located.** `KreinSucika`: `2[c,c] = Σ ½|c_i + c_{τi}|² − Σ ½|c_i − c_{τi}|²`, the negative sum supported exactly on moved modes. The negative index is the count of off-line zeros.
- **The same thing as unitarity.** `TauRupa`: transport `e^{(ρ−½)t}` preserves the τ-form always and preserves the plain inner product exactly when every mode has unit modulus.
- **The same thing as boundedness.** `Atikrama`: a mode is bounded exactly when its ratio is at most one. `ScaleTransportZ`: `Bounded (exp m) ⇔ exp m ≤ 0`. `ScaleTransportCriticality`: with the functional-equation pairing, every exponent is 0.
- **The same thing as a Gram matrix.** `WeilPositivityRealization`: RH = ∀ t, the size-t Weil Gram form built from Goldbach counts is positive semidefinite.
- **The same thing as cancellation.** `TheRiemannHypothesisHasAnArithmeticForm…`: `|M(n)|^{2q} ≤ C^{2q} n^{q+2p}`, the signed count Σ μ as small as fair coins would make it.
- **The same thing as one Boolean.** `SamastaSima`: `RH ⇔ ∀ m. rhb (suc m) ≡ true`, the Davis–Matiyasevich–Robinson inequality at every stage.

So RH is not a fact about some other object. It asks whether the square `Z = |P|²`, visible on the prime side of the one kernel, is still a sum of squares after the explicit formula re-expresses it over the zeros. `FiniteExplicitFormula` shows that re-expression in finite form: Newton's identities, zeros against power sums, with the finite RH as all roots of equal modulus. `HistoryCompletion.PowerSumTrace` shows both outcomes on actual streams: `onCircle` stays bounded forever, and `offCircle` is refuted at depth 1.

A moved mode is a Gap of τ: two different zeros ρ ≠ 1 − ρ̄ forming one reflection orbit, exactly as a non-diagonal Goldbach representation is a 2-orbit of `reflect`. **The Krein index counts the collisions of τ on the zeros.** RH says that count is 0 — τ has only fixed points, just as Goldbach's diagonal is the fixed locus of `reflect`.

---

## 4. The stream: the problems that live in time

Some problems have no plane; they have a deterministic stream and a property "at every depth":

```
record □ P s : coinductive   now : P (head s) ;  later : □ P (tail s)
```

- **Halting and divergence.** `TrtiyoMargo`: every finite depth is decided with evidence either way; divergence is a proposition, "not one more depth." `Pratyanayana`: the first halting time returns from mere existence because minimality is canonical.
- **Collatz at n.** `CollatzWithin k n = citer k (suc n) ≡ 1`, decided at each k (`collatz-dec`). Collatz is the totality of the least-k function.
- **Rule 30.** `Apunaravrtti` decides aperiodicity for every period ≤ 64 with preperiod < 64. `Jen` proves no two adjacent columns are both eventually periodic. `Karna` proves every right diagonal is periodic with period 2ᵏ, and the middle column is "the diagonal of the diagonals." Normality asks that every word's count in the prefixes tends to 2⁻ᵏ — a statement about counts, one quantifier up.
- **Navier–Stokes regularity.** `HistoryCompletion.JetStream`: the Taylor jets form a value stream, and regularity is a bound at every jet — a □-predicate. `Sima` shows peak-work integrability is equivalent to global regularity, given the ledger and Beale–Kato–Majda.
- **RH itself**, as §3's power-sum trace: `□ (|p_k| ≤ p_0)`.

For all of them, `NoDepth.no-depth-decides : ∀ n. Σ s t. take n s ≡ take n t × □ Bounded s × ¬ □ Bounded t`. **That is a Gap of `take n` relative to □**, for every n. The property sits in the fibre of every finite observation, and `Refute.separator` gives the other half: one failing depth refutes □.

---

## 5. The descent: the problems that say a set is empty

`SamanaAvatarana`:

```
DStep Config measure = (c : Config) → Σ c'. measure c' < measure c
emptied : DStep Config measure → ¬ Config            (via no-infinite-descent)
```

`OneDescent` holds three faces on this one engine:

| face | Config | measure | step field |
|---|---|---|---|
| Fermat's cube | `Soln` (x³+y³≡z³, positive) | z | `fltStep : Descent`, whose content `GhanaSamyoga` reduces to `CubeSplit` in ℤ[ω] |
| Navier–Stokes | `NSBadTower` | residual kernel rank | `nsStep`; `NSReducesToDepletion` names its content `excludeII` |
| Riemann | `RHLiveMode`, a nonzero exponent | its magnitude | `rhStep`; `RHReducesToBoundedness` names its content `bo` |

Each measure falls because of a positive-definite form: the Eisenstein norm `x² − xy + y²`, enstrophy, the Weil sum of squares. That is §3's square again. `VyarthaCakra` §6 is the exact lemma turning one positive aggregate into every entry: a positively weighted sum of squares vanishes iff every entry vanishes. It is the same `sum≡0→left≡0` that `AvarohaNisedha` uses.

Descent and the □-invariant of §4 are one step read from two ends. `PowerSumTrace.onCircle`'s `State` says good states stay good under the step. `DStep` says a bad state would force an infinite fall. `Pratyanayana` joins them: a least bad state is canonical, so producing a smaller one is a contradiction.

---

## 6. The second storey: every problem is the fibre law applied to its own totality

Now stack all of the above. Each problem has:

- **an inner storey**: a map, a value `b_n` at each stage n, and a fibre over it with a count `c(n) = |fiber f b_n|`, possibly weighted or signed;
- **a verdict** demanded at every n on that count: `c(n) = 0` (Fermat, bad towers, moved modes), `c(n) ≥ 1` (Goldbach, Collatz at n), `c(n) = 1` (no Gap: completed step, aperiodic column), or `c(n)` small (Mertens cancellation, Krein index 0, a bounded orbit).

Let `Q n` be "the verdict holds at stage n". The problem is `(n : ℕ) → Q n`. And `TritiyaMarga`'s `Test` proves, for any decided α with `Q n = ¬(α n ≡ true)`:

```
isContr (fiber (fst : Σ ℕ Q → ℕ) n)   ⇔   Q n
```

So **the problem is `isEquiv (fst : Σ ℕ Q → ℕ)`**: the same fibre law, one storey up. The inner storey asks about the points above `b_n`. The outer storey asks whether the stages that pass, projected to ℕ, lose nothing.

```
   outer storey     Σ ℕ Q ──fst──▶ ℕ          the problem:  isEquiv fst
                       │                     fibre over n  =  Q n
                       │ Q n := verdict(c(n))
   inner storey     fiber f b_n               c(n) = |fiber f b_n|
                       │
                    A ──f──▶ B                 the atom: Gap f / fiber f b
```

This diagram is the whole frontier. RH, Goldbach, twin primes, Collatz, Fermat's cube, Navier–Stokes regularity and closure, Rule 30, factoring, discrete log, P vs NP, SHA-256, the parity barrier — each is a choice of `f`, of `b_n`, and of the verdict on `c`.

What the outer storey is, provably, at its lowest form (`GoldbachBool`, `RHBool`, `FrontierBool`):

- **The base is a set and the fibres are decided propositions.** So there is no monodromy (`SetBaseNoMonodromy`), no coherence gap (`EffectiveDescent`; `ChidraDosa` needs a non-set target), no gauge (`Pratyanayana`), and no classical/constructive gap (`goldbach-¬¬-stable`, `DeflationaryTest`).
- **One stage refutes** (`finite-counterexample-refutes`, `frontier-refuted-by`). Writing the failing stage from a bare negation is Markov's principle (`writable→MP`).
- **No finite truncation decides** (`no-depth-decides`).
- **Extraction is free once the route exists.**
  - `the-universal-witness` is constructed, and Goldbach ⇔ `SearchIsTotal`.
  - `witness-self-certifies` holds by `refl`.
  - `fermatFactorization` has no search.
  - Every problem's answer, given its route, is already a term; what is missing is always the route that covers every n.
- **Π₁ or Π₂ depends only on the per-stage search.** Bounded search gives Π₁: Goldbach, RH-DMR, Fermat at each bound, aperiodicity at each (N, p). Unbounded search gives Π₂: twin primes `Π n. Σ p ≥ n`, Collatz `Π n. Σ k`, normality. `KotiNirnaya` §7 draws this line. In both cases the problem is the totality of a search you have already constructed.

---

## 7. The count beneath the Boolean decides the Boolean

The outer Boolean is the (−1)-truncation of the inner count, and truncation throws away exactly what could decide it.

- `KotiNirnaya` §8: "truncating the fibre to a proposition… discards the count."
- **Goldbach.** The count `R(N)` determines the primes (`GananaNirdhara`), builds the Weil form (`WeilPositivityRealization`), and its rate is `Sima`'s Goldbach-criterion route to RH.
- **RH.** The count of moved modes is the Krein index (`KreinSucika`), and RH is that count equals 0.
- **Navier–Stokes.** The count is the rank measure `nsRank`, forced to fall.
- **Rule 30.** The counts are word frequencies in prefixes; `Ganana` has every 9-bit word present by depth 2872.
- **P vs NP.** The count is the fibre size of the step: 1 everywhere on the completion, ≥ 2 somewhere on the projection.

And `VyarthaCakra` §6 is why one number can stand for a whole family of verdicts: a positive aggregate vanishes exactly when every entry does.

`Sima` finishes the picture for RH. Relative to the twelve received conditional theorems (module parameters), the six route unknowns — Bounded, OneSided, Lower, Lift, Dyadic, and the Goldbach-rate criterion — are each `≃ RH` and `≡ RH` by `ua`, one point of `hProp`. `transport-any-reading` carries any strategy on one to all of them. Every route is a statement about the inner counts; they differ in which count they read.

---

## 8. What you see

Draw the grid of §2 and colour a cell when `𝒦 w r = 1`.

- A **row** with a coloured cell is Goldbach at 2w.
- The **column** r = 1, coloured infinitely often, is the twin primes.
- The **hyperbola** through the grid is factoring.
- Take the grid's **transform**: it is a square, |P|². **RH** asks whether that square is still a square when written over the zeros — whether the reflection τ has only fixed points, whether its collision count (the Krein index) is 0.
- Now move to **time**. Collatz, halting, Rule 30 and the Navier–Stokes jets are streams, and each problem is "this bound or this return holds at every depth" — a count of bad events, forced to 0 by an invariant or a descent.
- The **projections** — `uStep`, SHA-256, the coarse turbulence filter, the neutral parity observer — are the same fibres seen from the side: a Gap where information is dropped, none where it is kept.

Every one is a count on the fibres of a map, demanded at every stage n. Every one is therefore `isEquiv (fst : Σ ℕ Q → ℕ)`. Every one's answer, given the route, is free. And every route is one finite object applied at every n: an invariant preserved by the step, or a positive measure the step decreases.

**The problems are not many problems about primes, fluids, machines and hashes. They are one diagram — a map, its fibres, the sizes of those fibres, and the demand that the stages meeting the verdict lose nothing when projected to ℕ — instantiated at different maps.** What differs is the map and the verdict. The slot is the same.
