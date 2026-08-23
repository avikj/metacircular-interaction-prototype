# Census of the Lean lane: every module in `formal/pairfield/Pairfield/`, its mathematics, the rigidity chain, and the root closure

Census date: 2026-08-23.  Method: read every module docstring and every
top-level `theorem`/`lemma` declaration in all **203** modules under
`formal/pairfield/Pairfield/` (1,506 top-level theorems and lemmas), plus the
root `Pairfield.lean` and `scripts/check-lean-root-closure.sh`.  Nothing here
is measured by trust: the closure number below was produced by running the
script, and every one-line result is read off the module's own statements.

Lane discipline spot-check at census time: no `sorry`, no `admit`, no `axiom`
declaration in any module (the strings occur only inside prose comments).
`YogyaAnupalabdhi_TheAxiomCheckStatesWhereItCouldHaveSeen.lean` at the lane
root carries the `#print axioms` surface; it is outside `Pairfield/` and not
counted in the 203.

---

## 1. Root import closure

`bash scripts/check-lean-root-closure.sh` on this checkout prints:

```
modules under Pairfield/: 203 ; reachable from Pairfield.lean: 203
OK: every module under Pairfield/ is reachable or declared out.
```

**Modules NOT in the closure of `Pairfield.lean`: 0.**  There is no
`formal/pairfield/root-exclusions.txt`, so nothing is "declared out" either —
all 203 are reachable from the root.  The lane's own audit warning ("a module
not in the import closure is built by nothing") is currently moot on the
reachability side, and was never true on the build side: `lakefile.toml`
carries `globs = ["Pairfield", "Pairfield.+"]`, so every module under
`Pairfield/` is a build target whether or not anything imports it.  The three
पुनरागमन/एकरूपता files that were orphaned (on disk, in no commit) on
2026-08-22 are now tracked; the working tree is clean.

---

## 2. The quantitative-Goldbach rigidity chain

The central object is `additiveSquareCoeff a N = ∑_{m+n=N} a(m)·a(n)`
(defined in `GoldbachTriangularReconstruction`), specialized to
`R(N) = additiveSquareCoeff Λ N` — the complete quantitative Goldbach
convolution of the von Mangoldt sequence
(`mangoldtGoldbachCoeff`, defined in `GoldbachDeterminesZeta`).

Import diagram (arrows point from imported to importer; every edge below is a
literal `import` line):

```
SumRigidity                    GoldbachTriangularReconstruction   GoldbachPowerSeriesRigidity
 (finite rigidity;              (defines additiveSquareCoeff;      (square injective in ℝ⟦q⟧,
  conceptual root,               triangular inverse formula)        sign fixed at q²)
  no imports into chain)                  \                            /
                                           v                          v
                                     GoldbachPowerSeriesLosslessBridge
                                     (additiveSquareCoeff = power-series
                                      square coeffs; sequence determined)
                                        /                      \
                                       v                        v
                        GoldbachDeterminesZeta         GoldbachPowerSeriesCharacteristicRigidity
                        (data ⇒ Λ ⇒ -ζ'/ζ, re s>1)     (ℂ version, char ≠ 2)
                        /        |          \                     |
                       v         v           v                    v
   BooleanGoldbach-   GoldbachSupportIsThe-  VonMangoldt-    GoldbachTailLossless
   InformationLoss    PrimePowerSumPredicate TriangularRe-   (tail N≥4 injective;
        |             (R(N)>0 ⟺ N is a sum   construction     Equiv onto range)
        v              of two prime powers)   (exact inverse)      |
   BooleanGoldbach-                               \                |
   SupportInvariance                               v               v
        |                                     GoldbachReconstructionChain
        v                                     (headline T1–T3 composition)
   BooleanVonMangoldtPrimePowerSupport
   (also imports GoldbachBoundary; N=11 control)
```

Bridge into the analytic lane: `GoldbachCrossover` imports
`GoldbachFixedFiberContamination` (analytic lane) and compares the
contamination bound against `mangoldtGoldbachCoeff` — the point where the
rigidity chain's exact object meets the ψ−θ estimate.

What the chain proves, end to end: the complete quantitative Goldbach data
`{R(N)}` (even just its tail `N ≥ 4`, with positivity at one coefficient
fixing the square-root sign) determines the von Mangoldt sequence exactly, by
an explicit triangular inverse; therefore it determines `-ζ'/ζ(s)` on
`re s > 1`; its Boolean shadow (positivity support) is exactly the
two-prime-power-sum predicate and provably loses the quantitative
information.

---

## 3. The analytic / pair-field Goldbach boundary lane

```
BoundedPrimePair → GoldbachBoundary → GoldbachWeightedBoundary
                                          → GoldbachFixedFiberContamination
                                              → GoldbachChebyshevAdapter
GoldbachDecision → GoldbachDecisionRange ─┐   → GoldbachCrossover ←──┘
                                          └──────────↑
GoldbachSquareErrorTransfer → ComplexGoldbachSquareErrorTransfer
RestrictedGoldbachEdge (imports GoldbachWeightedBoundary route)
```

Its quantitative content: `primePowerContamination(N) ≤ 2·log N·(ψ(N)−θ(N))
≤ 4·√N·(log N)²`, so `R(N) > 4√N log²N` forces a genuine prime pair at `N`;
finite verification up to `X` plus a contamination tail bound yields strong
Goldbach (`GoldbachCrossover`).

---

## 4. Complete module table

One line of mathematics per module.  Grouped by family; every module of the
203 appears exactly once.

### 4.1 Goldbach rigidity chain (13)

| module | main result |
|---|---|
| `SumRigidity` | For finitely supported nonnegative sequences, `a∗a = b∗b ⟹ a = b` (ℕ-polynomials, literal sum-marginal form, ordered rings, ℝ). |
| `GoldbachTriangularReconstruction` | Defines `additiveSquareCoeff`; leading coefficient is a square-root base case, and for `n ≥ 3` the coefficient formula is genuinely triangular (interior indices strictly smaller). |
| `GoldbachPowerSeriesRigidity` | In `ℝ⟦q⟧` a square has only roots `±A`; positivity of the coefficient at `q²` fixes the sign — no convergence hypothesis. |
| `GoldbachPowerSeriesLosslessBridge` | `additiveSquareCoeff` = coefficients of the power-series square; two sequences positive at 2 with equal additive squares are equal. |
| `GoldbachPowerSeriesCharacteristicRigidity` | ℂ-coefficient version: equality of all additive-square coefficients plus the same nonzero coefficient at 2 forces equality. |
| `GoldbachDeterminesZeta` | Any positive-at-two real sequence with the complete (or tail-`N≥4`) quantitative Goldbach field of Λ **is** Λ; hence the data determines `-ζ'/ζ` on `re s > 1`. |
| `GoldbachTailLossless` | Coefficients below 4 vanish for normalized sequences, so the tail map is injective; `goldbachTailEquivRange` is an `Equiv` onto its range. |
| `VonMangoldtTriangularReconstruction` | Exact inverse: `Λ(2) = log 2 = √R(4)`, and for `n ≥ 3` a division formula reconstructs `Λ(n)` from `{R(k)}`; the triangular specification has a unique solution. |
| `GoldbachReconstructionChain` | Headline composition T1–T3: tail agreement from `N = 4` + positivity ⟹ the sequence is Λ, obeys the triangular formula, and has L-series `-ζ'/ζ` on `re s > 1`. |
| `BooleanGoldbachInformationLoss` | Two distinct nonnegative spikes at 2 have identical positivity support but different quantitative coefficients: Boolean Goldbach is not quantitatively lossless. |
| `BooleanGoldbachSupportInvariance` | Positivity support depends only on the pointwise positive-support predicate of the sequence. |
| `BooleanVonMangoldtPrimePowerSupport` | `R(N) > 0 ⟺ N` is a sum of two prime powers; `N = 11` is the least center that is prime-power-representable but has no two-prime representation. |
| `GoldbachSupportIsThePrimePowerSumPredicate` | The support of the ζ-complete Goldbach field is verbatim the two-prime-power-sum predicate — prime-power Goldbach is a projection of an object determining `-ζ'/ζ`. |

### 4.2 Analytic Goldbach boundary (12)

| module | main result |
|---|---|
| `BoundedPrimePair` | Data structures for prime pairs below a horizon with swap/weaken operations (definitional layer; simp lemmas only). |
| `CenterBoundedPrimePair` | Center/gap bookkeeping: `pairGap` is even for odd-prime pairs; explicit absence/asymmetry controls (`3+17` in a leg-box, non-integral center for `2+3`). |
| `GoldbachBoundary` | `goldbachAt N ⟺ ∃ p+q = N` (primes); strong Goldbach equivalent to classical statement and to positivity of the count; restriction to `≤ X`. |
| `GoldbachDecision` | A computable `goldbachLeg?` whose `isSome` is proved equivalent to existence of a representation. |
| `GoldbachDecisionRange` | `goldbachUpToCheck X = true ⟺ GoldbachUpTo X`; certificates transfer. |
| `GoldbachWeightedBoundary` | `primeLogGoldbachCoeff ≤ mangoldtGoldbachCoeff`; `primePowerContamination ≤ 2ψ(N)(ψ−θ)(N)` and explicit forms; contamination `< R(N)` forces `goldbachAt N`. |
| `GoldbachFixedFiberContamination` | Antidiagonal sharpening: contamination `≤ 2·log N·(ψ−θ)(N) ≤ 4√N log²N`; `R(N) = contamination` when `N` has no prime-pair representation. |
| `GoldbachChebyshevAdapter` | Existence of constants: `∑ primePowerError ≤ C√N`, contamination `≤ C·ψ(N)·√N`, `≤ C·√N·log N` (Chebyshev-strength inputs). |
| `GoldbachCrossover` | `contamination < R(N) ⟺ goldbachAt N`; verified-up-to-`X` + tail bound (in either contamination or `4√N log²N` form) ⟹ strong Goldbach. |
| `RestrictedGoldbachEdge` | Same boundary restricted to legs `≥ L`: positivity iff a restricted representation; `log²(N+1)`-lower bound criterion; restricted contamination `≤ 4√N log²N`. |
| `GoldbachSquareErrorTransfer` | From an error bound on `G(t) = A(t)²` to one on `A(t)`: positive squaring loses no error scale beyond the factor `t` (real axis, exact algebra). |
| `ComplexGoldbachSquareErrorTransfer` | The same root-error transfer through a complex root, compatible with the positive real root. |

### 4.3 Phase retrieval, homometry, all-scale reconstruction (9)

| module | main result |
|---|---|
| `ParityRigidity` | Laurent-polynomial parity argument: normalized finite sets with odd-type supports and equal autocorrelations are equal (`rigidity_normalized`); `coeff_autocorr` identifies autocorrelation coefficients; parity class sizes `e·o+1 = e+o ⟹ e=1 ∨ o=1`. |
| `FixedScaleAutocorrelationAmbiguity` | The classical homometric pair `{0,1,2,6,8,11}`/`{0,1,6,7,9,11}` in `ZMod 23`: equal cyclic autocorrelation, related by no translation or reflected translation — fixed-scale phase retrieval obstruction, checked. |
| `HomometricAllScalesSeparation` | The homometric pair's diagonal-energy (all-scale) fields differ: one added scale variable separates what one scale cannot. |
| `FiniteHeatFieldHomometricSeparation` | `H_a(t) = ∑ a(n)² e^{-2nt}` is injective on nonnegative finitely supported signals; the homometric pair's heat fields differ at some `t > 0`. |
| `FiniteLaplaceUniqueness` | A finitely supported sequence is determined by its Laplace values at every `t > 0` (via polynomial rigidity on `(0,1)`); ℝ and ℂ forms. |
| `AllScalesPairFieldReconstruction` | Anchored reconstruction: the all-scale zero-gap field is injective on nonnegative signals; rank-one pair-field form. |
| `FiniteCesaroConvolution` | Exact finite layer-cake: the Cesàro-weighted convolution equals the tent pair sum equals products of prefix sums; endpoint controls show the weights are forced. |
| `ZeroPairSumSeparation` | The matched pair-sum functional is not injective; the diagonal full pair-sum is — locating exactly where pair-sum data separates. |
| `AntiSpike` | A sequence with `|steps| ≤ B` obeys the two-sided anti-spike window bound `forward_antiSpike_half` (no spike inside a bounded-step window). |

### 4.4 Kloosterman / Kuznetsov / Bessel no-go family (15)

| module | main result |
|---|---|
| `FiniteKloostermanCompletion` | The inverse-phase completion of a residue weight is the DFT of Kloosterman sums; constant weight yields Ramanujan sums. |
| `DivisorBoundaryKloostermanBridge` | The gcd-stratum inverse phase sum equals a DFT of Kloosterman sums (exact bridge from divisor-boundary weights). |
| `KuznetsovSingleKernelBoundary` | A single scalar Bessel kernel evaluated at `√(mn)/c` cannot distinguish mode pairs with equal product; explicit collision and rank-two crossed-mode escape. |
| `DivisorBoundaryBesselCollision` | For stratum `(6,1,6,7)` the boundary weight is `δ₅`; its DFT at frequencies 4 and 1 differ while the colliding lifts share the scalar argument — no single radial kernel. |
| `ActualDivisorBoundaryKuznetsovNoGo` | Packaging: the actual gcd stratum is not one scalar radial full-lift kernel, but a separable Whittaker-index realization survives. |
| `ActualBesselLiftDichotomy` | At the genuine arguments `4π√(mn)/c`: full lifts collide (no scalar geometric function); the six sparse lifts have distinct arguments and one smooth test interpolates. |
| `ActualBesselSparseInterpolation` | The six canonical sparse-lift Bessel points are positive and distinct; a smooth compactly supported `g` on `(0,∞)` takes six prescribed values. |
| `FiniteSmoothBesselInterpolation` | Any finite set of distinct positive reals admits smooth compactly supported interpolation with support in `(0,∞)`; applied to the sparse stratum. |
| `SparseLiftScalarKernelCompiler` | Injective kernel shape ⟹ every coefficient family descends through one scalar kernel; the sparse section's six products are distinct, so it compiles. |
| `WhittakerLiftAliasing` | `1 ≡ 6 (mod 5)` gives equal Kloosterman data but different Bessel arguments: the finite residue identity does not determine an integer Whittaker lift. |
| `FiniteKuznetsovFactorizationRank` | Crossed-corner tensor over a common radial fiber has rank exactly two (`rankAtMost` calculus). |
| `PrimeResidueKloostermanBoundary` | The prime-representative weight on `ZMod 6` is not CRT-factorable, yet has a finite Kloosterman completion — completion without factorization. |
| `PrimeResidueTensorRank` | That weight has CRT tensor rank exactly two: one Euler-type pure tensor is insufficient, two suffice. |
| `PrimeResidueKloostermanRankFifteen` | Modulo 15: Kloosterman completion exists with exact CRT rank three, and without two-component factorization. |
| `PrimeResidueTensorRankFifteen` | The mod-15 prime weight is not rank ≤ 2, every weight is rank ≤ 3, hence rank exactly three. |

### 4.5 Prime-charge tensor rank (6)

| module | main result |
|---|---|
| `PrimeChargeThreeTensorRank` | `W₃` (three-place squarefree Möbius charge in local basis) has tensor rank exactly 3 over ℚ, by the matrix-pencil substitution argument. |
| `PrimeChargeFourTensorRank` | `W₄` has rank exactly 4; local zeta change of basis transfers exact rank to the four-place `μ·1_P` restriction. |
| `PrimeChargeArbitraryRank` | Dimension-free substitution lemma; `wCube n` (= n-mode W tensor) and the squarefree charge cube have tensor rank **exactly n**, uniformly. |
| `PrimeChargeUnboundedLocalRank` | Consequently the local charge rank exceeds every fixed bound — no uniform finite-rank model. |
| `PrimeChargeKuznetsovRankBridge` | Embedding into radial-fiber coordinates preserves the rank obstruction: the embedded charge is not rank ≤ 2. |
| `PrimeChargeFourKuznetsovGroupingNoGo` | Scalar-radial grouping loses four-way rank: no rank-3 scalar-radial transport to the four-way tensor. |
| `PrimeMobiusInsertion` | `n ↦ ∑_{p∣n} μ(n/p)` computed on divisors; it is **not** multiplicative (explicit failure). |
| `PrimeThreeChannelThresholds` | Distinct concrete three-channel thresholds on `ZMod 15` (separation instance). |

(8 rows: the family's two arithmetic feeders included here.)

### 4.6 Smith normal form and certificates (17)

| module | main result |
|---|---|
| `SmithCertificate` | Executable 2×2 Smith certificate checker; `check` is sound **and** complete for `Valid` (untrusted-producer gate). |
| `SmithPresentation` | Presentation arrows `B = L·A·R` compose (replay and unimodularity compose); every reducer stratum is additive. |
| `GeneralSmith2x2` | **Total verified producer**: `smith A` terminates by a well-founded gcd measure and `smithCertificate_valid` holds for every integer 2×2 matrix; `|det|` preserved. |
| `SmithContent` | `(smith A).d₁ = gcd of the four entries` — for *every* valid presentation, since unimodular matrices have integral inverses; `d₁·d₂ = ±det` variant. |
| `CertificateSource` | A valid certificate recovers its source (`A = L⁻¹DR⁻¹`), so the certificate map is injective — no irreducible quotient trace exists. |
| `DirectSmith2x2` | Determinant `±1` matrices: direct certificates, and exact linear-system solving `solve_spec`/`solve_unique`. |
| `ComputableSmith2x2` | Backend-executable diagonal join: closed-formula reduction after common-factor/coprime splitting (structural termination). |
| `ComputableSmith2x2Adapter` | The executable join's output satisfies the full `SmithCertificate2.Valid` proposition (field-for-field translation). |
| `DiagonalSmithRoute` | Positive-diagonal dispatcher (identity / swap / kuṭṭaka join) with validity in each branch; kuṭṭaka-610 transcript replay, cost minimality, and no history decoder from endpoints. |
| `RankOneSmith2x2` | From an outer-product witness and two Bezout equations, a valid Smith certificate for any rank-one matrix. |
| `RankOneWitness` | Total producer of that witness from bare `det A = 0` — verified extended Euclid (`xgcd_spec`), no oracle. |
| `ArbitrarySmithClosure` | The capability graph's first open typed joint is closed: arbitrary matrix ⟹ checked certificate, via `GeneralSmith2x2`. |
| `ZeroPivotRelocationInvariant` | Zero-pivot relocation (row/column/endpoint routing) preserves `|det|` and content; visible pivot can rise — raw pivot is not a global descent measure. |
| `SmithMemory` | The Smith response is injective; any memory implementing it needs at least the quotient cardinality; constant responses need no side state. |
| `Ekarupata_TheFourSmithSpellings…` | The four Smith structures in the lane are one Carrier shape identified by `Equiv`s; `natAbs det` matches; no presentation from `1` to `diag(2,2)`. |
| `Apavartana_ThePriceOfAnIntegerCut…` | For divisors `(2,12)`: rank of the cut as a function on Spec ℤ drops exactly at `p ∣ det`; the cokernel `ZMod 2 × ZMod 12` has order 24, exponent 12, and is not cyclic. |
| `SarvatraApavartana_WhichPrimesSee…` | Generic rank equals length; `rankAt p < length ⟺ p ∣ det` for every prime at once (list form, recursion step checked). |

### 4.7 Euclid coefficient formation and replay cost (9)

| module | main result |
|---|---|
| `EuclidCoefficientTrace` | Unary `inc`/`dec` coefficient grammar with replayable traces; value does not determine cost (`no_value_cost_decoder`); kuṭṭaka-610 coefficients witnessed. |
| `EuclidCoefficientForkNoGo` | The tempting shared-prefix fork through coefficient 1 is never cheaper than the direct pair — a checked counterexample to premature DAG pricing. |
| `EuclidCoefficientCutBound` | Cut-crossing argument: any shared formation of `{2,−1}` costs ≥ 3; the direct pair attains 3 — the no-go is exhaustive in the declared grammar. |
| `EuclidFiniteTargetFormation` | In the unary grammar the minimum formation cost of any finite target set is exactly the width of the interval hull of `targets ∪ {0}` — detours never help. |
| `EuclidDoublingFork` | Adding a `double` constructor strictly escapes the interval law: the `{3,8}` fork costs 5 vs unary minimum 8. |
| `EuclidDoublingForkMinimal` | Exhaustive finite decision over all ≤ 4-operation causal DAGs: none forms both 3 and 8, so the five-operation fork is the global causal minimum. |
| `AdditionChainPredictiveMemory` | Two addition chains with the same endpoint 6 but different formed sets: availability probes separate them; exact two-history coding lower bound; endpoint has no decoder. |
| `TemporalAmortizationBoundary` | Install-vs-keep reuse decisions: profitability thresholds, and no horizon-free decision is optimal at both 3 and 4. |
| `OutputSensitiveCleanCost` | Digit-trace subtraction accounting: within-level plus boundary subtractions determined by query counts; max-geodesic ≠ rolling at `p=3, k=1`. |

### 4.8 DFA behavior, observability, and experiment trees (62)

The lane's largest family: Myhill–Nerode style behavioral theory
(`FutureEq`, left quotients, reduced presentations), BFS witnesses with
minimality proofs, observable horizons, and adaptive experiment trees, with
an exact adaptive-vs-uniform gap theorem at its head.

| module | main result |
|---|---|
| `FutureBehavior` | `FutureEq` is an equivalence compatible with steps, equal to behavior equality; behavior quotient is injective. |
| `MyhillNerodeAdapter` | `FutureEq` = state-language equality; regularity ⟺ finitely many reachable behavioral states. |
| `NerodeChartAdapter` | The Nerode presentation is reduced, all-states-reachable, accepts the same language, and is cardinality-minimal among presentations. |
| `Automata` | Shared definitional layer (DFA words/runs; no theorems). |
| `BehavioralBFS` | Sound, complete, minimal shortest distinguishing-word search up to a fuel bound; `none ⟺ boundedFutureEq`. |
| `ResidualBFS` | Same for left-quotient (residual) separators; `card²` bound converts bounded search into a global decision. |
| `ChartStateBFS` | Pair-DFA state separators exist below `card²`; shortest-witness soundness and minimality. |
| `ShortestReach` | Shortest reaching-word search: sound, minimal, none-iff-unreachable, predecessor structure. |
| `VisitedReach` | Verified BFS queue: nodes valid, nodup, frontier word lengths monotone, minimality of found nodes, stability at the fixpoint. |
| `VisitedReachCardinality` | The visited-state count is bounded by the state cardinality. |
| `VisitedPair` | Pair-queue BFS witnesses are globally shortest; length agrees with `shortestStateWitness`. |
| `VisitedPairHorizon` | Pair-BFS termination: frontier empties by `card²`; `none ⟺ no separator`. |
| `VisitedResidual` | Visited left-quotient witnesses: globally shortest, length equal to the BFS answer, existence ⟺ separator fiber. |
| `ObservableVisitedPairAdapter` | Observable closure ⟺ the visited-pair witness is `none` (bridge). |
| `ObservableHorizon` | Observable closure at depth `n` ⟺ bounded equivalence implies future equality; finite DFAs close by `card²`; a 3-state example closes at exactly 1. |
| `GlobalObservableHorizon` | The global horizon is the least depth at which observation closes (isLeast, with witnesses below it). |
| `ResidualObservableHorizon` | Closure ⟺ left-quotient stabilization for reachable automata; reachability hypothesis is essential (counterexample). |
| `AdaptiveObservableHorizon` | Adaptive experiment trees: a depth-2 adaptive tree identifies what no depth-1 tree can, while the uniform horizon is 1 — the gap exists. |
| `ReachableAdaptiveObservableHorizon` | The same gap survives with all states reachable (deliberately parallel witness; the differing `step` is the content). |
| `AdaptiveUniformBound` | Adaptive identification at depth `d` bounds the global observable horizon by `d`. |
| `LinearAdaptiveGap` | Exact gap family: uniform/residual horizon 1 vs adaptive depth exactly `n−1` on an `n`-action automaton (`exact_linear_gap`). |
| `AdaptiveDistinguishingTransport` | Identifying all states ⟺ identifying initial fibers; left-quotient equality ⟺ current + all adaptive responses equal. |
| `AdaptiveResidualAdapter` | Left-quotient equality ⟺ equality of all adaptive traces ⟺ adaptive test equivalence (fixed-word trees embed words). |
| `AdaptiveBranchResidual` | Branch residues determine branch traces; step lemma. |
| `AdaptiveResidualSplitting` | A query that separates residuals is safe; `merge` is not safe and roots no residual separator (3-state witness). |
| `AdaptiveResidualPartition` | Residual splitting ⟺ separation on prefixes ⟺ initial-fiber splitting; omit-one trees as witnesses. |
| `AdaptiveSplitPotential` | Safe advance is injective on response fibers; square potential splits; strict progress ⟺ both branches nonempty. |
| `AdaptiveResidualPotentialAdapter` | Safe advance ⟺ residual safety; duplicate cells are safe but not distinct (potential bookkeeping transported to residuals). |
| `AdaptiveResidualConstructor` | Trees with residual splitting exist ⟺ a separating tree exists (`toTree`/`ofTree` round trip). |
| `AdaptiveResidualSteering` | Constant responses keep cardinal scores invariant; constant-false actions are not safe and make no progress. |
| `AdaptiveConstantResponseSteering` | 5-state witness: every separator starts with `steer`; `steer` has constant response yet strictly decreases potential — steering before splitting is forced. |
| `AdaptiveResidualPositionRank` | Cells of prefixes have `card` = residual count; fixed-cell histories are bounded by `choose 2`; repeated cells are not reduced. |
| `AdaptiveResidualCycleDeletion` | Separation is monotone/congruent in position; transplanting at the same position preserves trees; steering changes canonical position. |
| `AdaptiveResidualPositionCycleAdapter` | Position = cell-of-prefixes; equal finite positions allow transplant; loop presenters coalesce. |
| `AdaptiveResidualMinimalSpine` | Depth-minimal splitting trees admit no same-position proper descendant; a redundant-steering tree separates but is not depth-minimal, yet its mandatory steer survives. |
| `AdaptiveResidualNodeMinimalSpine` | Node-minimal plans exist; strict subplans lower query count; rooted spine length ≤ `2^stateCount`. |
| `AdaptiveResidualNodeMinimalDepth` | A depth-realizing spine exists; node-minimal depth + 1 ≤ `2^stateCount`. |
| `AdaptiveResidualNonhomogeneousSpine` | Node-minimal query nodes are non-homogeneous; ≥ 2 finite positions per query; improved bound `2^n − n`. |
| `AdaptiveResidualGlobalPartition` | The experiment partition refines under insert; complete witness sets of size ≤ `choose 2` decide everything (`eq_of_agree_completeWitnesses`). |
| `AdaptiveResidualAnnotatedSplit` | Square-ambiguity splits under branching with a `+2` accounting; reveal spends exactly two; `Fin 3` events < `choose 2`. |
| `AdaptiveResidualAnnotatedPartitionAdapter` | Inserting an agreeing separator strictly refines; opposite children are separated; the complete partition cannot be strictly refined. |
| `AdaptiveResidualStrictRefinementIff` | Insert strictly refines **iff** some pair agrees on installed tests and is separated by the new one. |
| `AdaptiveResidualBinomialBudgetNoGo` | Exhaustive nodup histories saturate the binomial budget: a 6-state local countermodel and the 5-state two-subset boundary. |
| `NativeCompleteWitnesses` | Complete witness sets of size ≤ `choose 2` with globally shortest separating words. |
| `NativeCompleteWitnessPartition` | The response partition of the complete words is discrete. |
| `NativeCompleteWitnessCost` | Total complete-word length ≤ aggregate expansion bound; word length < `card²`; shared suffixes are not root-free. |
| `NativeWitnessGreedyFormation` | Greedy installation prunes useless words while keeping the partition discrete (checked on a planted duplicate). |
| `NativeDemandRestrictedFormation` | Demand-driven scheduling resolves all unresolved pairs to the same discrete observable — provably the *same automaton* as the greedy control. |
| `NativeShortestSeparatorPolicy` | Compiled shortest-separator policies form an exact two-word discrete observable on the reduced control. |
| `NativeReverseSeparatorPolicy` | Rank-fueled suffix policies separate with length ≤ rank; appended shared suffixes separate roots. |
| `NativeReversePairTraversal` | Sorted-universe pair enumeration is complete; reverse-certificate reachability; expansion bound; a closed reverse node exists for distinct pairs. |
| `NativeReverseEdgeInventory` | The reverse-edge inventory has exactly the predicted edge count and respects the generic `card²·alphabet` bound. |
| `NativeIndexedReverseTraversal` | Verified indexed reverse-BFS: chained certificates, sound bucket materialization, nodup keys, complete frontier consumption. |
| `NativeIndexedParentExtraction` | The last edge of a chained node targets its state; boundary nodes never appear in the run queue. |
| `NativeIndexedParentRetention` | The indexed queue retains parents; every nonempty run has a strictly shorter parent. |
| `NativeIndexedPolicyBoundary` | Endpoint validity does **not** force the last-edge target — the wrong-predecessor boundary is exhibited. |
| `TernaryCancellationFormation` | A pairwise ledger collision that a ternary residual separates; repairing the observable restores injectivity. |
| `ChartQuotient` | The behavioral quotient DFA is reduced, all-reachable, accepts the same language (quotient card 3 on the witness). |
| `ReachableChart` | Behavioral presentations cover evaluation; `accepts` transfers; shortest left-quotient witness minimality. |
| `ReachableSubDFA` | Start-reachable restriction preserves acceptance, reaches all states, and composes with reduction. |
| `ExecutableMinimization` | Finite DFAs accept regular languages; reachable-reduced state count ≤ Nerode bound ≤ original. |
| `WalkFalsifier` | The runtime's Python falsifiers re-done as kernel objects: `by decide` finite verifications and fuel-structured executables (`#eval`), no `native_decide`. |

### 4.9 Channels, information, memory (12)

| module | main result |
|---|---|
| `FiniteInformation` | `factorsThrough ⟺ fiber-constant`; a channel completes a task ⟺ it separates its fibers; injective channels complete everything; monotone in refinement. |
| `LinearCongruenceChannel` | For `d : ZMod n`-multiplication: kernel/output cardinalities multiply to `n`, occupied fibers are balanced, exact decoder ⟺ unit multiplier (30/12/7/0 instances). |
| `LinearObservabilityKernel` | Generic `FutureEq` for a linear system **is** the classical kernel `⋂ ker(P∘Tⁿ)`; invariance; a hidden state exhibits the gap with the instantaneous kernel. |
| `BuildCoverageChannel` | An exit bit over health states has no decoder; the full report is injective and decodable — coverage claims need the report, not the bit. |
| `FiniteHistoryTotalization` | Totalized histories always decode; endpoint fibers have cardinality `|State|^n`; endpoint decoders exist ⟺ prefix space is a subsingleton. |
| `DependentRootedHistoryFiber` | A rooted history is determined by its endpoint chain; endpoint fiber cardinality formula. |
| `HeldAMSProgramCount` | Exact count of held-memory AM/AMS syntax programs (dependent product of step choices); endpoint image is bounded by it; held values do not change the syntax count. |
| `SmithMemory`† | (listed in 4.6) |
| `ResourceBalance` | Transaction balance is additive over disjoint unions; componentwise balance fails without disjointness. |
| `PointwiseRevision` | Lattice-valued belief revision: the pointwise revision operator's exact order laws (`≤ update`, inf/characterization iffs). |
| `FiniteChuCalibration` | Finite Chu spaces: composition of pairings; the `bit` space is calibrated. |
| `FiniteChuResidualTransport` | Chu morphisms transport pair profiles naturally; bit identity instance. |
| `FiniteCoYonedaWeave` | Woven (co-Yoneda) profiles evaluate canonically; distinct bare presentations weave equal — no bare decoder. |

### 4.10 Miscellaneous algebra, analysis, arithmetic adapters (28)

| module | main result |
|---|---|
| `Lorentz` | An integer matrix in `SO(1,1)` (preserves `J`, det 1) is `±I` — the integral Lorentz group in 1+1 is `{±1}` (via two Pell-type factorizations). |
| `Lowenheim` | Löwenheim's reproductive general solution for Boolean equations: `lowenheimBA` is a fixed-point idempotent retraction onto the solution set, with range characterization. |
| `ReversalRigidity` | Monic irreducible `F,G ∈ ℤ[X]` with `F ∣ G` and equal degrees are equal; coefficient-reversal rigidity (`reverse_reverse` under nonzero constant term). |
| `HolonomyDescent` | A task factors through the orbit quotient ⟺ it is `G`-invariant, uniquely; additive coinvariant version for `AddHom`s. |
| `InvariantCorrectiveClosure` | The least `a`-invariant submodule containing `U` (Krylov closure); one-step correction `U ⊔ a(U)` strictness and idempotent collapse. |
| `CarryCohomologyAdapter` | For `b ∣ N` the degree-two class of the cyclic extension is nonzero — carries are cohomology (`H²(ZMod N)` witness). |
| `CharacterSectorClosure` | A nowhere-zero vector is cyclic for an injective diagonal action (Vandermonde determinant): admitting the position operator destroys every character-sector compression. |
| `IndraFourierNetAdapter` | Exact two-leg Dirichlet-character Fourier inversion on `((ZMod n)ˣ)²` — the Indra residue-pair net reconstructs. |
| `IncrementalCRTAdapter` | Generalized-CRT state merge: compatibility ⟺ common state exists; merge = intersection of congruence classes; unique representative below `lcm`; signed obstruction certifies failure. |
| `CyclotomicRoutingAdapter` | `xⁿ−1 = ∏ Φ_d`; a prime dividing `Φ_d(a)` with `p ∤ d` makes `a` a primitive root of order `d` mod `p` (primitive branch, 2³−1 route checked). |
| `CyclotomicPrimitiveTransportAdapter` | Prime divides at most one piece with order = index; the exceptional branch refutes the unqualified iff; product order is not determined by component orders. |
| `HeadDepthBlindnessAdapter` | Lifting-the-exponent transport: `emultiplicity` of `q^a − 1` equals that of the head `q − 1`; Fermat-blindness ⟺ head threshold. |
| `HigherArityPadicAdapter` | p-adic valuation of native tuple sums: proper subsets keep the profile, the full sum jumps — a labeled profile collision (3³−6 control). |
| `InfiniteValuationFiberAdapter` | A multivariate polynomial's zero status at a root residue is not determined by any same-residue chart (infinitely many probes cannot see it); nonroot residues decide. |
| `LeviResidueCorank` | Finite identity: block count = coordinate count − combinatorial Levi rank, with the local admissibility iff. |
| `ProcessCutRankAdapter` | Exact rank defect at a process cut: `rank(A∘B) + defect = rank B` via restriction to `range B`; matrix forms. |
| `ModFiveAutonomousProfile` | Multiplication traces mod 5 stabilize at horizon two with exactly four classes; horizon-one collisions exist; optimal 4-element code attained. |
| `LeastNonDivisor` | The least non-divisor of any `L ≥ 1` is a prime power — proved, so the runtime's assertion can never fire; prime-power minimality suffices for full minimality. |
| `FrontierOptimality` | `lcm = lcm(1..K)` follows from one sensor certificate (`¬q ∣ L` + minimality) by induction — the walk's `capacity_certificate` recomputation is a theorem. |
| `HaarNullProcess` | A null-supported signal is `0` in `L²`; no bounded linear postprocessing recovers the null event. |
| `HahnBilinearBoundary` | The complex two-site control `(1,i)`: bilinear parity ≠ absolute-square parity — the real Hahn identity does not extend silently to ℂ. |
| `BombieriRankCeiling` | First and second moments do not determine positive inertia in dim 3 (third moment separates); the flat-window two-thirds certificate is attained by `(2,1,1,1,1,0)`. |
| `VandermondeFrequencyResponse` | A frequency mode inside a "constant" coefficient responds as the Lagrange polynomial evaluated at the phase increment; genuine constants are killed — replacing an invalid inference in `BARRIER_LEVEL_SEPARATION`. |
| `UpwardEscape` / `UpwardEscapeNecessity` | Cardinality bounds on bad/good escape sets and the energy lower bound; conversely `card·λ² ≤ energy` forces escape — the escape is necessary. |
| `CharacterAnchor` | In a commutative domain, two unordered pairs with equal sum and equal product agree up to exchange (`U = V ∨ U = V*`) — the algebraic core of character-anchor rigidity. |
| `FinitePositiveExposedPoint` | A positive weighted aggregate over unit-disc coefficients exposes the all-ones point; a coordinate weight lower bound converts distance-from-1 into an aggregate real-part deficit — but zero weight breaks rigidity (arbitrarily small deficit, fixed displacement 2). Finite kernel of exposed-point rigidity. |
| `SieveRestriction` | Sieve restrictions compose, compose oppositely, and commute iff the stated condition; an explicit lens-circuit composition counterexample. |

(27 rows: the Upward pair shares one row; all 28 modules counted.)

### 4.11 Argmin / decision infrastructure (4)

| module | main result |
|---|---|
| `ArgminDecomposition` | An argmin over a decomposed domain decomposes (`argmin_decompose`). |
| `BellmanArgminIntegration` | A concrete Bellman argmin witness with value 1 (route-cost instance). |
| `ChuArgminTransport` | Chu morphisms transport pair-argmins (adjointness of the pairing cost). |
| `DefinitionalFoldPruneBoundary` | Pruning after unfold never increases distinct counts (ℕ-prune 0, ℤ-prune ≤ 0); removing the decoder makes pruning look positive — the boundary is the decoder. |

### 4.12 Carrier / return family (3)

| module | main result |
|---|---|
| `Punaragamana_TheDeterminedFieldRidesFree` | `Carrier f` (base + determined field + pinning witness): descent from the base is the identity; maps factor through the base; non-subsingleton preimages obstruct factoring. |
| `PunaragamanaPrayoga_TheTraceWitness…` | `CoefficientWitness` and the CRT `MergeCertificate` are Carriers, by `Equiv` from outside; the no-value-cost-decoder transports. |
| `Ekarupata…`† | (listed in 4.6) |

### 4.13 Indian primary-source modules (10)

| module | main result |
|---|---|
| `Sulba_TheCordDoublesTheSquare…` | The Baudhāyana triple family is a ring identity; `3²+4²=5²`, `5²+12²=13²`. |
| `Kuttaka_ThepulverizerSolves…` | The kuṭṭaka solves the linear indeterminate equation: Bezout `∃ x y, a·x + b·y = gcd a b`, with coprime instance. |
| `Bhavana_TheCompositionOfTwoNorms…` | Brahmagupta's bhāvanā: both the samāsa and antara composition identities for the form `x² − N y²`. |
| `Cakravala_TheBhavanaStepBreeds…` | The bhāvanā step maps a vargaprakṛti solution for `N=2` to a larger one (`(3,2)→(17,12)→(577,408)` checked; growth proved). |
| `Chandahsastra_ThePrastara…` | Meru row sum: `∑_k C(n,k) = 2ⁿ` (Piṅgala's prastāra count). |
| `Virahanka_TheMatrameru…` | The mātrā-meru recurrence is the Fibonacci sequence: `matra n = fib (n+1)`. |
| `Madhava` | The Mādhava series: `tendsto_paridhi` — the partial sums of the paridhi (circumference) series converge (π series, `vyāsa` parametrized, value 1 instance). |
| `Nada_OneNoteContains…` | The overtone series diverges: `¬ Summable (1/n)`. |
| `Pramanasruti_TheCommaNeverCloses` | `2^a = 3^b ⟹ a = b = 0`; in particular `2¹⁹ ≠ 3¹²` — the Pythagorean comma never closes. |
| `YugmaPurana_TheEvenPaddingIsForced…` | The `+2` paddings in both no-decoder theorems were **forced**: `det(euclidStep) = −1` uniformly so word determinants are `(−1)^n`, and unary steps flip value parity — both theorems are tight at the parity quotient. |

### 4.14 Capability graph (2)

| module | main result |
|---|---|
| `CapabilityGraph` | Executable index of checked capability joints: each closed edge is a term whose type names both endpoints; open edges are uninhabited types, not assertions. |
| `PrimePairDecomposition` | `PrimeWaypoint024 p ⟺ p = 3`; 7 is an endpoint but obstructed as a waypoint — decomposition loss located exactly. |

Module count check (unique modules per section; `†` rows are cross-listed
and counted once, in 4.6): 13+12+9+15+8+17+9+62+12+28+4+2+10+2 = 203.

---

## 5. Judgment: the eight strongest results as mathematics

Ranked by mathematical content — what the theorem says about objects people
outside this repository care about, not by formalization effort.

1. **`GoldbachDeterminesZeta` (+ `GoldbachPowerSeriesLosslessBridge`).** The
   complete quantitative Goldbach field of Λ determines the sequence Λ and
   hence `-ζ'/ζ` on `re s > 1`. The statement is sharp about what it does not
   claim (no Boolean sufficiency, no continuation), and it converts "Goldbach
   data" from a folklore phrase into a checked determination theorem. The
   strongest single composition in the lane.

2. **`GoldbachReconstructionChain` + `GoldbachTailLossless` +
   `VonMangoldtTriangularReconstruction`.** Not just abstract injectivity: an
   *explicit triangular inverse* (`Λ(2) = log 2 = √R(4)`, division formula
   from index 3) with a uniqueness theorem, composed with tail-losslessness
   (`N ≥ 4` suffices, `Equiv` onto range). Reconstruction, not merely
   rigidity.

3. **`SumRigidity`.** `a∗a = b∗b ⟹ a = b` for nonnegative finitely
   supported sequences, in four graded formalizations, by the integral-domain
   `±` argument. The root theorem of the entire chain and the cleanest
   statement in the lane.

4. **`GoldbachFixedFiberContamination` (+ `GoldbachWeightedBoundary`,
   `GoldbachCrossover`).** `primePowerContamination(N) ≤ 2·log N·(ψ−θ)(N) ≤
   4√N log²N`, hence `R(N) > 4√N log²N` forces a genuine prime pair at `N`,
   and finite verification plus a tail bound yields strong Goldbach. The
   lane's only genuinely *quantitative analytic* estimate chain, with the
   antidiagonal fixed-fiber trick doing real work.

5. **`ParityRigidity`.** Autocorrelation rigidity for normalized finite
   integer sets via a Laurent-polynomial parity decomposition — a genuine
   contribution to the homometry/phase-retrieval question, and the
   non-trivial half of the pair whose ambiguity half is
   `FixedScaleAutocorrelationAmbiguity` (the classical homometric pair,
   checked).

6. **`PrimeChargeArbitraryRank` (+ `PrimeChargeUnboundedLocalRank`).** The
   `n`-mode W tensor and the squarefree Möbius charge cube have tensor rank
   **exactly `n`**, uniformly in `n`, by a dimension-free substitution lemma
   — real multilinear algebra (the W-state rank statement, fully checked),
   with the corollary that no fixed-rank local model captures the charge.

7. **`GeneralSmith2x2` + `SmithContent` + `CertificateSource`.** A total,
   terminating, certificate-emitting Smith normal form producer for
   arbitrary 2×2 integer matrices, with `d₁ = content` proved for *every*
   valid presentation (unimodular ⟹ integral inverse), and injectivity of
   the certificate map. Compute / check / prove on one object.

8. **`FiniteLaplaceUniqueness` + `FiniteHeatFieldHomometricSeparation` +
   `HomometricAllScalesSeparation`.** The all-scale heat field
   `H_a(t) = ∑ a(n)²e^{-2nt}` is injective on nonnegative finite signals
   while one fixed scale provably is not (the homometric pair): a complete
   finite model of why phase retrieval fails at one scale and succeeds with
   a scale variable — the mathematical heart of the "pair field" idea.

Near misses, recorded so the cut is visible: `LeastNonDivisor` (the least
non-divisor is always a prime power — small, perfect, and it retired a
runtime assertion), `LinearAdaptiveGap` (exact adaptive-vs-uniform horizon
gap `n−1` vs `1`), `EuclidFiniteTargetFormation` (formation cost = interval
width, a clean exact combinatorial optimization theorem),
`YugmaPurana_TheEvenPaddingIsForced` (both no-decoder theorems are tight at
the parity quotient — a theorem *about* two other theorems), and `Lorentz`
(integer `SO(1,1)` is `{±1}`).
