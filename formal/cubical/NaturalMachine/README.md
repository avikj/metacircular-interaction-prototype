# NaturalMachine — module index

296 `.agda` modules, snapshot 2026-08-15. Built from the header comment of
each file, nothing else; where a header does not say what the module
delivers, the module is listed under §4 Unclassified rather than guessed at.

The directory is under active write: 28 modules landed while this index was
being built. Counts below are a snapshot, not an invariant.

`../NaturalMachine.agda` is the aggregate; it imports 231 of these. Absence
from the aggregate is noted where it is meaningful (controls that must fail,
scratch files, later additions).

Status vocabulary used below:

- **load-bearing** — something else in the tree depends on it, or it is the
  statement the cluster exists to make.
- **witness** — an instance, calibration, or executed example of a theorem
  proved elsewhere.
- **counterexample / control** — its content is a refutation, a no-go, or a
  designed annihilation.
- **superseded-by-X** — kept, not deleted; X is where to read instead.
- **open gap** — the header itself names something it did not deliver.

---

## 1. Modules whose headers confess an open gap or a failure

This is the lane's real work queue. Everything here is a confession made by
the file's own author in its own header.

**Audited 2026-08-15, entry by entry, against the tree rather than against
this table.** For every row claiming a gap is closed elsewhere, the closing
module was opened and read; where the closure is partial, the row now says
which part. Six headers were rewritten in the same pass (`WalkFast`,
`WalkJumps`, `CoprimeSplitting`, `DigitTowerLimit`,
`SequentialNormalizationObstruction`, and `DefectCalculus`'s top block), all
comment-only, all preserving the original confession as history rather than
deleting it — the convention `WalkFastInstance` set when its own overclaim
was retracted. The reason this matters is on the record: an index that reads
headers propagates them, and on 2026-08-15 a header claiming instances that
had never typechecked got `WalkFast`'s gap recorded here as closed, and both
had to be retracted.

Caveat on the verification, stated rather than glossed: the re-typechecks were
run under **Agda 2.6.3 against the `/tmp/cubical` checkout (`cubical-0.7`)**,
which is *not* the repository pin (Agda 2.8.0 + cubical v0.9, `BUILD.md`).
All six edited modules exit 0 after the edit — `WalkFast` 3.3 s,
`WalkFastInstance` 3.3 s (unedited, re-run as the load-bearing check),
`WalkJumps` 2.4 s, `CoprimeSplitting` 2.3 s, `DefectCalculus` 1.8 s,
`DigitTowerLimit` 3.7 s, `SequentialNormalizationObstruction` 9.4 s.
Two modules that this section *cites* as closures could not be checked here at
all, for reasons pre-dating and independent of these edits, both reproduced on
pristine `HEAD` copies: `FullSequentialTableNormalization` exits 42 because
`Cubical.Tactics.Reflection` wants `withReduceDefs` (Agda ≥ 2.6.4), and
`StabilizerSubgroup` exits 42 because `SymGroup` is a v0.9 name absent from
0.7 — which is exactly the skew `check.sh` uses to *detect* v0.9. Those two
closures are verified by reading, not by the kernel, on this box. Incidentally
confirming that `DigitTowerLimit`'s retained boundary is not hypothetical:
2.6.3 emits 19 `UnsupportedIndexedMatch` warnings there (its header records 28
under 2.8) and 0 for `DigitTowerFin`. Nothing in this section is a pin result.

| Module | What is confessed | State |
|---|---|---|
| `WalkFast` | *(header rewritten 2026-08-15; the old confession is preserved verbatim under HISTORY in the file.)* Formerly: "NOT DELIVERED: the payoff instances." `next-characterised` (the exchange rate trading `q ∤ cap m` for `q is a prime power`) is proved; `next-8 : next 8 ≡ 9` exhausts a 3.5 GB heap and "I do not yet know what forces it; the obvious suspect is the `with`-abstraction on `q ≟ next m`". | **Closed, on the third telling — and the header now says so.** The instances typecheck (`WalkFastInstance`, verified again 2026-08-15 at 3.1 s, `cap m` never run). Read the history before citing either file: this table first said "closed", which was this index believing a header that claimed instances that had never been checked; then said "still open", correctly; and the gap is now genuinely closed — but NOT by the `with` fix `WalkFast` and `WalkFastInstance` both guessed at. Removing the `with` leaves the blow-up exactly where it was. The cost is the conversion checker comparing the goal's `next 8` against a second, independently elaborated occurrence, and `let`-sharing removes it. **`WalkFast`'s header no longer contradicts this row**: it names `WalkFastInstance`, records that its own suspect was innocent, gives the conversion-checker diagnosis, and warns that `next-characterised` is provable but not applicable at a numeral (use `WalkFastInstance.conclude`). |
| `WalkResidueBridge` | "WHAT IS *NOT* DELIVERED. The walk is not fast now." Charting is the expensive step: `decDividesℕ n m` runs `digits m`, Θ(m) on a unary `m` — exactly what the automaton saves. The claim is only that `cap m`, once built in the chart, never has to leave it. | **Open.** The walk still has no end-to-end cost theorem. |
| `SensorNerode` | Two named gaps: (i) the residue bridge — the note writes `profile_S(n) = (n mod m)`, this file works with `m ∣ dist a b`, and the identification is "an unchecked (if entirely standard) step"; (ii) "§2 of the note — the divisor lattice — is NOT here", needing prime factorisation and the p-adic valuation, absent from cubical v0.5. | **Open.** (ii) is called "a real piece of work and not an oversight". |
| `SieveFiber` | "What is still open is the BRIDGE": `rough n` as computed here by `stripF` has not been shown to satisfy `RoughSplit.roughSplitSqrt`'s hypothesis, so §4 remains this file's own X = 30 exhaustion and is not yet a corollary of the general theorem. | **Open.** |
| `CountedDigits` | Cost boundary: the imported development proves semantic equations, not a work measure for `sucw`'s carry recursion. "A costed execution edge remains open until a native carry-cost theorem is installed." | **Open.** This is the corpus's standing open cost edge; `AcceptanceTest`, `CountedComposition` and `CompileBridge` each re-name it. |
| `CompileBridge` | Several, in its own "not claimed" ledger: the open cost edge is not closed; **neither §I record is inhabited**; `ArithmeticPayload` is "kept, superseded, so that the correction is legible; it is not deleted and it is not inhabited"; the witness policy is still degenerate wherever the loop builds obstructions. | Partly closed: the morphism class is fixed by `PayloadMorphism`, the semantic law repaired by `DatumSensitivePayload`, the witness policy by `WitnessPolicy`. The cost edge and the uninhabited records are **open**. |
| `CompressionDefectRegularWitness` | "This leaf does not close the general T18.5 witness direction." Extraction in an arbitrary carrier needs a declared action and a faithfulness/nontriviality hypothesis. | **Open.** |
| `SequentialNormalizationObstruction` | A retained selected-event history cannot be projected to `BornDistribution₂` at all; "a future repair must retain the complete branch table". | **Closed** by `FullSequentialTableNormalization` (sufficiency only — that file makes no minimality claim), and the header now records it. Verified 2026-08-15: the repair builds the normalizer, gives it the state's own `norm²`/`weight₀`/`weight₁`, and supplies the X-covariance law that was vacuous in the obstruction. This module is **not** superseded — the repair imports it back (`forgetSelected`, `forgotten-false-branches-collide`, `complete-tables-separate`) to locate where the information is lost. What is still open is minimality: "must retain the complete branch table" is an upper bound presented as a necessity. |
| `DigitTowerLimit` | Agda 2.8's `UnsupportedIndexedMatch`: the indexed `Vec` matches "will not compute when applied to transports". Warning retained rather than suppressed. | **Partly closed, and the header now says which part.** The *warning* is closed as a diagnosis: `DigitTowerFin` shows it is a `Vec` artefact (28 → 0 by moving to `Fin n → Digit`) with the two proved facts unchanged. The *inverse limit* is ported by `DigitTowerFinLimit` (`MSDLimit A ≃ (ℕ → A)`, via `FinTopSplit`). **Not ported, and still living only here in the `Vec` presentation:** `LSDLimit`, `reverseToLSD`/`reverseToMSD`, `reversalLimitEquiv`, `limit-reversal-chart-identity`, `transportLawToLSD`, and the two-bit `Vec` witnesses. `DigitTowerFin`'s own header calls that question open. So "superseded-by-`DigitTowerFin`" in §2.1 is right for the carry obstruction and for the MSD limit, and wrong for reversal. |
| `WalkJumps` | "WHAT REMAINS OPEN, stated plainly": the converse of §(c) is not proved here; §(b) is not formalised here either; no primality decision procedure. | **Two of three closed; the third is genuinely open.** §(c)⇒ by `CoprimeSplitting` (`two-primes→coprime-split`, `leastNonDivisor-isPrimePower`); §(b) by `WalkBridge`; the composition by `WalkPrimePowers`. ~~**The primality decision procedure is still missing**: checked 2026-08-15, there is no `Dec (IsPrime n)` anywhere in `NaturalMachine/`.~~ **Closed 2026-08-18** by `PrimalityDecision.decIsPrime : (n : ℕ) → Dec (IsPrime n)`, built from `CoprimeSplitting.searchDiv` at bound n-1 plus `noDiv→prime` — no new number theory, exactly the "unwritten, not blocked" bounded search `WalkJumps` predicted. `WalkFast.decIsPrimePower` decides prime-**power**-hood, which is what the walk needs, and `CoprimeSplitting.primeDivisor` *produces* a prime with its proof. Header updated 2026-08-15; closure recorded 2026-08-18. |
| `CoprimeSplitting` | "WHAT REMAINS OPEN": the bridge between `IsLCM (range1 n)` and `LeastNonDivisor` — §(b) of the note — "is still not formalised"; no primality decision procedure; `searchDiv`/`primeDivisor` are fuel searches, "proofs, not algorithms". | **First item closed** by `WalkBridge`, with the composition in `WalkPrimePowers`; **the other two are still true** and stay. Header updated 2026-08-15. Worth recording against this file's own expectation: the (⇒) half of "the installs are exactly the prime powers" does **not** use the bridge — it is `leastNonDivisor-isPrimePower` applied to `WalkBridge.next-lnd`. Only the (⇐) half needs §(b), plus one new induction (`WalkPrimePowers.locate`). |
| `DefectCalculus` §7 | Names its own gap verbatim: "a genuine surjection needs the image quotient (a set-truncation) … what is proved here is the split case". | **Closed** by `EffectiveDescent`, which also reports that half the diagnosis was wrong — the set hypothesis on `C` is genuinely used, `SetQuotients` is not needed at all (`PT.rec→Set` builds `g` with no quotient constructed), and `descends-split` is recovered as `split-descent-agrees`. **The header was already correct here** — the §7 section comment has carried that pointer since 2026-08-14. What was stale was the file's *top* header block, which billed §7 as "T15.40 both ways" and named a lemma (`descends`) that lives in `EffectiveDescent`, not here; corrected 2026-08-15, because the top block is what an index reads. |
| `DefectCalculus` §4 ledger | "T15.9 is not proved as 'subgroup' … packaging one here would be scope creep." | **Corrected, and this row previously understated the correction.** `StabilizerSubgroup` shows the parameter already *was* the group object (`Cubical.Algebra.SymmetricGroup.SymGroup`), so no packaging was needed — but *something was* missing, namely two h-level hypotheses: `isSet A` (to have the group at all) and `isSet (Str A)` (so `Stab` lands in `hProp`, which `Subgroup` requires; without it `stab-∘` is a *choice* of witness, not closure). The honest entry, which `DefectCalculus`'s header already carries in this form, is that **§4 is stated at a generality at which "subgroup" is not yet well-posed**, and **the group statement at non-set `Str A` remains open**. No header edit was needed. |
| `Control/WrongEquivalence` | *** THIS FILE MUST FAIL TO TYPE-CHECK. *** Asserts `ℕ ≃ Word` for raw words, dropping canonicity. Not in the checked build. If a future edit makes it compile, the development's main claim is broken. | Designed annihilation; **must stay failing**. |
| `Control/WrongFirstStep` | *** THIS FILE MUST FAIL TO TYPE-CHECK. *** Asserts `CompileBridge.first-step-names-resume` at `tickCap`, i.e. `0 ≡ 1`. Not in the checked build. | Designed annihilation; **must stay failing**. |
| `Control/QuantifierDrop` | Must fail: the line-world corollary quantified over all observables, i.e. as a summary message restated it after dropping "For `f = X+Y`". | Designed annihilation; **must stay failing**. |
| `Control/MaximizerWithoutNonvanishing` | Must fail: the finite no-go of ENCOUNTERED_WORLDS §2 without its `f ≠ 0 on E` clause. | Designed annihilation; **must stay failing**. |
| `Control/InflationFlattened` | Must fail: "symmetry enlargement is not a repair at all", i.e. Thm 3.5 with its along-a-quotient qualifier dropped. | Designed annihilation; **must stay failing**. |
| `Control/ReachabilityWithoutStart` | Must fail: "0 is fixed by both actions, so 1,2,3 are unreachable" without the premise `start = 0`. | Designed annihilation; **must stay failing**. |
| `Control/SatisfactionWithoutCodomainAgreement` | Must fail: the observer-revision theorem without the standing hypothesis `Y'_{τ(q)} = Y_q`, which the source states once in prose and in neither theorem, title, nor status line. | Designed annihilation; **must stay failing**. |
| `Control/InjectivityNecessary` | Must fail: "the comparison maps must be injective for the backwards implication", as a message hardened it. | Designed annihilation; **must stay failing**. |
| `Control/FunctionBoundFromConstant` | Must fail: "no function of (b,n) improves it", asserted as a universal over functions from two constant-sharpness witnesses. | Designed annihilation; **must stay failing**. |
| ~~`WFIScratch1`, `WFIScratch2`~~ | Bisection stubs that reached the repository by an over-broad `git add`, listed here as deletion candidates when this index was built. | **deleted** 2026-08-15, once `WalkFastInstance` checked; nothing imported them. |
| `PayloadMorphism` | The morphism class the arithmetic wants is fixed only as an obligation: "what is fixed is that the interface must name one". | **Open** as a construction. |
| `LinearOrderFinite` | Its "WHAT IS NOT CLAIMED" ledger names **two** definitions written in a deliberately awkward style for elaboration-cost reasons: `rk-≤`/`rk-≥` take an explicit `Dec` argument instead of using `with` ("with-abstraction normalises the goal, and the goal mentions `rk`, whose unfolding contains `isFinSetΣ`"), and `linOrd′Iso` uses the record constructor instead of copatterns. "Both alternatives are mathematically identical and neither typechecks in practical time; this is a fact about Agda, not about the mathematics." | **Open** as an Agda-performance item, not cosmetic. *(This row previously named only the copattern half and called it cosmetic; corrected 2026-08-15.)* Note the family resemblance to `WalkFast`/`WalkFastInstance`: the operative cost is a term being elaborated where a variable would do. Whether the same `let`-sharing route applies here has not been tried. |

**One correction owed outside this section, recorded here because the 2026-08-15
audit found it and did not own the line.** §2.2's row for `WalkFast` still reads
`load-bearing + open gap (§1)`. That is now false — the gap is closed, per the
first row above — and the status should become `load-bearing` with the pointer
to `WalkFastInstance`. Likewise §2.1's `DigitTowerLimit` row reads
"superseded-by-`DigitTowerFin`/`DigitTowerFinLimit`", which is right for the
carry obstruction and the MSD limit and wrong for the reversal equivalence,
which exists nowhere else. Left for the owner of §§2.1–2.2; flagged rather
than edited, so the two do not drift apart silently a second time.

Two further standing hypotheses, not gaps but worth the same attention:

- `CostGeometryWitness` W2: "the weights are STIPULATED, not measured here."
  The theorem is the implication, not the numbers.
- `TransportCost`: the quadratic-blowup finding is a *measurement*; the
  scaling runs live in `notes/TRANSPORT_IS_NOT_A_COMPILER.md`, not in the
  tree. The derived reason (transport across `ua e` *is*
  `e⁻¹ ∘ f ∘ (e × e)`) is in the header, so the number is not load-bearing.

---

## 2. Clusters

### 2.1 Place value as a chart — Digits / Transport / Endian / Carry (33)

| Module | Delivers | Status |
|---|---|---|
| `Digits` | ℕ, `List Unit`, `CanWord` defined independently; `value`/`digits` round trips; `value-sucw`: the odometer computes the successor. | load-bearing (root) |
| `FreeMonoid` | `List Unit` presentation; concatenation is literally the transport of addition; monoids EQUAL by SIP. | load-bearing |
| `Transport` | `transport-+-is-⊕`: ℕ's `+` transported along `ua` *is* schoolbook ripple carry; `ℕ-Monoid≡CanWord-Monoid`. | load-bearing |
| `TransportMul` | Same for `·` against native shift-and-add: the chart carries the whole semiring. | load-bearing |
| `TransportMulWitness` | The digit multiplier running at base 10 on literal digit strings, by `refl`. | witness |
| `TransportCost` | The transported term computes, but quadratically; native is flat. | witness (measured; see §1) |
| `TransportDiv` | `modw`, the Horner residue automaton on words; `value-modw`; `steps w ≡ suc (length w)`. | load-bearing |
| `TransportDivWitness` | Base ten, word 1000: home work 1000, chart work 5, detour 14. | witness |
| `WalkResidueBridge` | The missing converse `∣→modw-zero`; `decDivides`, `decDividesℕ`, and `decDividesℕ-agrees` with `dec∣`; the cost gap as a theorem (`steps` vs `usteps`). | load-bearing; names its own gap |
| `TransportInstance` | One end-to-end witnessed-equivalence and theorem-transport instance (whitepaper §17 steps 3–4). | load-bearing |
| `Endian` | Reversal D and complement E: Klein four on raw words, neither descends to ℕ; E commutes with π, D exchanges π with ς. | load-bearing |
| `EndianAtlasReplay` | The four two-bit words and their id/rev code tables. | witness |
| `Controls` | C1: canonicity is load-bearing (`value` not injective without it). C2: the big-endian misreading fails its round trip, proved as a refutation. | control |
| `Control/WrongEquivalence` | Must fail to typecheck (C3). | control (see §1) |
| `Control/WrongFirstStep` | Must fail to typecheck. | control (see §1) |
| `CarryObstruction` | Corollary 2.11.1 directly, by the exponent argument: carrying cannot be removed by any choice of digit set. H² not constructed here. | load-bearing |
| `GroupCohomologyH2` | H²(Q;A) = Z²/B² as an actual group (library quotient group). | load-bearing |
| `CarryClassNonzero` | `[cₙ] ≠ 0` in H²(ℤ/bⁿ; ker πₙ), for every base, every n, every section. | load-bearing |
| `CarryChartBridge` | Adapter Digits/Endian ↔ `CarryObstruction.BasePower`; `rawπ-does-not-restrict` (raw MSD deletion does not preserve `Canonical`); `red-chart-truncates`. | load-bearing + counterexample |
| `FixedCarryChart` | Fixed-width MSD tower adapter; strict composition of deletion; stagewise normalization; `normalizeMSD-not-iterable`. | load-bearing + counterexample |
| `DigitTowerLimit` | Inverse limit of the MSD tower over `Vec`. | superseded-by-`DigitTowerFin`/`DigitTowerFinLimit` |
| `DigitTowerFin` | The same carry obstruction over `Fin n → Digit`: the transport warning is a `Vec` artefact, 28 warnings → 0. | load-bearing (diagnosis) |
| `DigitTowerFinLimit` | `MSDLimit A ≃ (ℕ → A)` for any set A. | load-bearing |
| `FinTopSplit` | The top-splitting eliminator for `Fin (suc n)` — the whole obstruction the MSD tower needed. | load-bearing (lemma) |
| `CarryBorrowObservation` | `c (E w) = z (w)` for every finite base-4 word; positive value warrants one exclusion; collisions obstruct the decoder. | witness |
| `RadixSymptoma` | `σ(r) = (κ r , (b^{κ r}·r) mod m)` is a complete invariant, in two coordinates, shorter than the K+1 signature. | load-bearing |
| `ResidueTransport` | Any residue/CRT observation compiled along ℕ ≃ CanWord; replay reduces to the odometer round trip. | load-bearing (adapter) |
| `CountedExecution` | `run` (iteration under a tick count), `run-suc`, and the `compile` law for maps between executions. | load-bearing (root) |
| `CountedDigits` | The `digitsC` / `sucC` / `valueC` execution triangle closed over literal successor. | load-bearing; open cost edge |
| `CountedComposition` | `run-+`: counted time composes additively across a checkpoint; `run-split²`; the Odometer instance. | load-bearing |
| `AcceptanceTest` | `Plan` as an inductive type, `cost`, `exec`; restart vs resume, with `replay` pinned to `digitsC-resume`. | load-bearing |
| `TransportDivQuot` | Euclidean division on the chart: `divw n`, digit by digit, threading one state `r < n` from the least significant end, never mentioning `value`. | load-bearing |
| `TransportDivScale` | **The X-dependence of the frontier.** `TransportDivWitness` pinned one point; this supplies the exponent, as two proved (not measured) laws — chart linear in the word length, home linear in the value. Written against CLAUDE.md's "a number without its X-dependence looks like knowledge". | load-bearing |
| `ResidualPath`, `CostGeometry`… | see §2.7. | — |

### 2.2 The capacity walk and its frontier — Walk* (17)

| Module | Delivers | Status |
|---|---|---|
| `WalkForcing` | The forcing law: a least non-divisor of L admits no proper coprime splitting (gcd-side, no Bezout). | load-bearing |
| `CoprimeSplitting` | The converse arithmetic: two distinct primes dividing n give an explicit proper coprime splitting; hence a least non-divisor IS a prime power. `IsPrimePower`, `strip`, `primeDivisor`, `dec∣`. | load-bearing |
| `WalkJumps` | §(c)⇐: `q = p^a ⟹ q ∤ lcm(1..q−1)`, general in p and a, by the lcm universal property (no valuations). | load-bearing |
| `WalkCapacity` | The capacity law: any lossless sensor family with addresses ≤ k has lcm dividing lcm(1..k). Stated by universal property; construction-free. | load-bearing |
| `WalkStream` | After installing q, `lcm S = lcm(1..q)` — the walk sits at the capacity of its own frontier. | load-bearing |
| `WalkInduction` | The invariant is preserved by one step, hence by every reachable state (`Reach` as a recursive family, not an indexed inductive). | load-bearing |
| `WalkBridge` | §(b): the walk's install *events* are exactly the capacity function's jump *points*, in increasing order; `next` as a total function. | load-bearing |
| `WalkBridgeUniform` | Independent blind re-derivation of §(b); records that `WalkBridge`'s antisymmetry proof beats its own induction, and removes the `1 ≤ m` hypothesis. | witness (replication) |
| `WalkPrimePowers` | The composition: the walk installs exactly the prime powers, in increasing order. | load-bearing |
| `LCMExists` | `lcm`, `lcmList`, `lcmList-exists` for arbitrary lists, zeros included — discharging the lane's standing `IsLCM` hypothesis. | load-bearing |
| `WalkUnconditional` | Every conditional walk theorem with its `IsLCM` hypothesis discharged; `cap` becomes an actual computable function. | load-bearing |
| `WalkFast` | `next-characterised` (the exchange rate) and `decIsPrimePower`, with its non-vacuity. | load-bearing + open gap (§1) |
| `WalkFastInstance` | `next-8 ≡ 9`, `next-9 ≡ 11`, `next-10 ≡ 11`, each at the size of the answer, `cap m` never run. Its header carries the bisection log with controls, and the record of two wrong diagnoses before the right one. | load-bearing |
| `SensorNerode` | The walk's minimal state is its lcm: `Ind S a b ⟺ L ∣ dist a b`, equal families give equal relations, and the relation determines the lcm. Contains no arithmetic. | load-bearing; two named gaps (§1) |
| `LeastWitnessFactory` | `leastSelector`: a least witness from a mere witness, given propositionality and decidability. | load-bearing (lemma) |

### 2.3 Sieve, horizon, and the parity barrier — Charge*/Parity*/Sieve* (23)

| Module | Delivers | Status |
|---|---|---|
| `SieveFiber` | The X = 30 sieve fibre at the √X horizon; the residual bit ε; what does and does not descend along it. | load-bearing; open bridge (§1) |
| `RoughSplit` | The √X horizon fact X-uniformly: n ≤ X with all prime factors > isqrt X ⟹ n = 1 or n prime. Imports nothing from `SieveFiber`. | load-bearing |
| `SieveScaleTower` | The finite inverse tower `O_z` at z = 0,2,3,5 with forgetting maps and the homotopy fibres of charge-forgetting observations. No inverse limit claimed. | load-bearing |
| `ChargeGradedPeeling` | Charge as a dependent index; least-prime peeling `n ↦ n/p⁻(n)` as a directed transformation of indexed states, over the X = 30 domain. | load-bearing |
| `ChargeGrading` | The charge grading and parity as its truncation; C15.25 — canonical fixed-charge dynamics is closed only under degree-zero operations. | load-bearing |
| `ChargeCriterion` | **A query set admits a separating decision procedure iff it contains a query of odd Ω** — both directions, with the procedure constructed. | load-bearing |
| `ParitySeparator` | A parity-neutral observer cannot separate σ₊ from its gauge flip, whatever post-processing it applies. Arithmetic core, no C*-algebra. | load-bearing |
| `GaugeOrbitClasses` | The pair replaced by the whole gauge torsor; bilinearity of `val` in its sign argument. | load-bearing |
| `OracleQueries` | Functional-equation queries carry NO charge, unconditionally; functional-equation access lies strictly inside the blind side of the charge criterion. Answers TARGET.md §6.2 in the negative. | load-bearing (negative) |
| `FlipObservable` | The flip enters the grammar through exactly one generator; the dichotomy stratified by port is the finding. | load-bearing |
| `EndogenousHorizon` | A behavioural separator: prime r and semiprime rs indistinguishable to every divisibility test below the threshold, yet differing in primality. | load-bearing |
| `BuchstabDegree` | Delta 18's Buchstab target answered **no**, structurally: child selection is a grading, not a sector leakage of T18.4's form. | load-bearing (negative) |
| `ChargeTwoHistories` | A repeated prime has one charge-two history (Unit); two distinct primes have two orders (Bool). | witness |
| `PrimePairDecompositionCurvature` | {0,4} locally admissible mod 3; the materialized waypoint {0,2,4} locally empty in every starting residue. A decomposition-loss certificate. | counterexample |
| `ChenTwoChargeProjector` | Support geometry for a two-charge seam; commutation of two projections kept sharply distinct from any lower bound. | load-bearing (interface) |
| `DiagonalEndpoint` | Factory VI's diagonal endpoint compiler: near-boundary witness + subcritical certificate ⟹ unit boundary. No prime theorem postulated. | load-bearing |
| `DifferenceBasinCompiler` | Factory IV difference-basin compiler; the 721-point/Delta-star theorem is an input record only. | load-bearing |
| `MixedCornerTransferCompiler` | Factory IV mixed-corner compiler on rank κ = 2i + bit, with radius descent that temporarily creates excess. | load-bearing |
| `RadiusTransferCompiler` | Bounded-gap-to-radius-one transfer compiler over a parametric prime-pair predicate. | load-bearing |
| `PrimeSquareOptionalComposite` | Modulus 5 is forced by the 5/25 collision; the composite modulus 4 is inert and optional. Unique forced core, multiple sound anatomies. | counterexample |
| `PrimeSquarePinAdapter` | The F30/T5 collision compiled into a `PinnedSensorForcing` witness at exactly its known scope. | witness (adapter) |
| `Gamma0` | Γ₀(D) as an entrywise divisibility condition, uniform in n, decidable with a returned offending entry; collapses to classical Γ₀(N) at n = 2. | load-bearing |
| `LCMExists`… | see §2.2. | — |

### 2.4 Descent, observability, and the behavioral quotient (33)

| Module | Delivers | Status |
|---|---|---|
| `Descent` | **The descent law**: `f` factors through `q` ⟺ `f` is constant on the fibres of `q`; the two are the same type, and the factorisation is unique. | load-bearing (root) |
| `FutureBehavior` | The future-behavior quotient (Myhill–Nerode / sufficient statistic) as a `SetQuotients` HIT; greatest-congruence theorem. Absorbs the retired `PortQueue`. | load-bearing (root) |
| `FutureSeparation` | A future separator is one action word in hand; for Bool observations, failure of `FutureEq` gives one only under double negation — Markov's Principle removes it given a countable chart. | load-bearing |
| `FiniteInformation` | The finite-information kernel; factorization through an observable and exact reconstruction with side data, choice-free (the Lean port's three `Classical.choose` sites disappear). | load-bearing (root) |
| `HolonomyDescent` | Orbit quotient erases the path; a set-valued task descends iff invariant under generated holonomy, uniquely. Plus coinvariants. | load-bearing |
| `EffectiveDescent` | T15.40 for an arbitrary surjection, split hypothesis removed; `descentEquiv` — the descent problem is representable, and B represents it. | load-bearing |
| `ObservabilityQuotient` | `N_obs = ⋂ ker(P Tⁿ)` is T-invariant, is the future-observational equivalence, is a congruence, and is **strictly finer** than `ker P` — with the three-state witness. | load-bearing |
| `ObservableHorizon` | A bounded response kernel enters the quotient exactly when every installed action preserves it. | load-bearing (adapter) |
| `ObservableInterface` | One path-valued seam shared by three observation systems; the induced path transports every predicate on observations. | load-bearing |
| `ObservationPresentation` | Postcomposition by an equivalence preserves the kernel pair, hence `FactorsThrough` both ways; the Bool control shows the hypothesis is load-bearing. | load-bearing |
| `AtomicSatisfaction` | Atomic observation is preserved exactly when the response square commutes; a changed response type needs an injective comparison. | load-bearing |
| `ContextCloneEquivalence` | Finite words are the executable unary clone; mutual simulations identify complete-future equality and give an identity-on-states Iso of set quotients. | load-bearing |
| `CompositionalContextAdapter` | The unary-action relation is a congruence for the original binary operation and is greatest among observation-compatible magma congruences; four-state control kills the shortcut. | load-bearing |
| `SingletonActionObservability` | Equality under every word in a one-action machine = equality along every iterate, via `ℕ ≃ List Unit`. | load-bearing |
| `TerminalTraceCompression` | A deterministic history carries no more quotient information than a terminal record exactly when each factors through the other on its image; four Isos. | load-bearing |
| `TranscriptDescent` | Identifies the two definitions of `FiberConstant` and turns the compositional criterion into an actual decoder on reachable terminal observations. | load-bearing |
| `Decategorification` | `ℕ ≃ ∥FinSet∥₂` as a π₀ statement, and `FinSetLoop≃Sym`: what the collapse throws away is exactly the loop space. | load-bearing |
| `PathIsSymmetry` | `(X ≡ X) ≃ (X ≃ X)` as a group isomorphism; ℕ as a bare type has many automorphisms, as a (1+X)-algebra exactly one. | load-bearing (thesis) |
| `FiniteEquivalenceBridge` | A finite equivalence lifts to a path of FinSets, hence to cardinality equality — deliberately weaker than a chosen enumeration. | load-bearing (lemma) |
| `SymmetryCardinality` | `symmetryCount n ≡ n !`. | load-bearing |
| `SymmetryEnumeration` | The count upgraded to a checked enumeration: `(Fin n ≃ Fin n) ≃ Fin (n !)`, whose inverse *generates* the k-th permutation. | load-bearing |
| `SymmetryArithmeticAction` | `permuteRegisters`: the action data the cardinality equation forgets; composition is executable composition. | load-bearing |
| `CapabilityGraph` | `SymmetryCapability`: the checked symmetry graph forks from the carrier — deliberately no count-to-action edge. | load-bearing (boundary) |
| `AtlasResiduals` | ATLAS_OF_N §7: the type of chart comparisons is **contractible**; `Σ[X ∈ BSₙ] LinOrd X` is contractible. | load-bearing |
| `LinearOrderFinite` | A genuine order structure `LinOrd′` with `LinOrd′ X ≃ (X ≃ Fin n)` — the rigidification statement — composed with `AtlasResiduals`. | load-bearing |
| `Vacuity` | Four verdicts (FORMS / GENUINE / VACUOUS / UNDECIDED-VACUOUS) as types carrying their witnesses; `Dec P → Verdict` as the parking obligation. | load-bearing |
| `VacuityVerdict` | The scoped version: checking a larger finite sample never constructs `GlobalFactorization`; it stays `undecided` until an ambient theorem arrives. | load-bearing (correction) |
| `PolyHaythamResponseCostNoGo` | A response fibre containing two implementations separated by a cost admits no postprocessing recovering that cost. Two-point Bool refutation. | counterexample |
| `ProofLabelNoGo` | A label collision blocks faithful validation — the exact obstruction for MathMachine's `Maybe String`. | counterexample |
| `OperationalCoverageCounterexample` | A finite poset with declared singleton covers need not be a site: identity covers hold, cover transitivity fails. | counterexample |
| `ArithmeticPayloadCounterexample` | `ArithmeticPayloadOver` is inhabited, but for a non-arithmetic reason: `Datum` and `installP` are constrained by no law. An exact interface no-go. | counterexample |
| `GeneratedGrammarDescentBoundary` | Two productions can share a semantic observation while depending on different rules, so survival after rule withdrawal need not descend. | counterexample |
| `Lawvere` | Lawvere's fixed-point theorem in type theory, in three lines, with Cantor / Russell / Tarski / Gödel / Turing as instances. Explicitly claims no novelty. | load-bearing (root) |

### 2.5 DSO — min-plus, Bellman, continuation semantics (18)

| Module | Delivers | Status |
|---|---|---|
| `DSOFinite` | The exact counterexample: local argmin selection can destroy a cheaper composed continuation. | counterexample (root) |
| `DSOBellmanFinite` | A local choice is not safe to erase until its continuation has been observed. Two-point ℕ model. | counterexample |
| `DSOArchitecture` | A materialised intermediate architecture can lose an endpoint witness: `T ; S` cannot compose to `R`, so no optimizer restricted to it can repair the loss. | counterexample |
| `DSOOption` | Coarsening the interface can reduce the representation but cannot add exactly supported tasks. | load-bearing |
| `DSOContinuationFullAbstract` | Extended natural costs (`fin`/`∞`), `⊗`, `minC`, and relation semantics — infinity as structural unreachability. | load-bearing |
| `DSOMinPlusFinite` | Min-plus fold over an inductive finite index; associativity and `+`/`min` distributivity. | load-bearing |
| `DSOFactorRankFinite` | One latent mode forces a rectangular/additive minor identity. No tropical-rank claim imported. | witness |
| `DSONucleusFinite` | A two-boundary cost relation with one saturated rank-one retained latent mode. | load-bearing |
| `DSONucleusExecutionCalibration` | Delta 29's four-state calibration: the defect M's complete table and trefoil identity as kernel reductions. | load-bearing |
| `DSONucleusMiddleProduct` | Delta 29's middle Isbell operator on the four-cell calibration, over an explicitly generated test family. | load-bearing |
| `DSONucleusOneSidedProduct` | Delta 29's left Isbell closure and one-sided product; every extremum over the full finite fiber. | load-bearing |
| `DSONucleusMiddleAssociativityAudit` | Finite associativity audit of the middle family, sealed abstractly (64 × 4 min/max). | load-bearing |
| `DSONucleusResidualAudit` | Delta 29 residual synthesis audited on the four generated middle profiles, checking truth and falsity cases. | load-bearing |
| `BehavioralHankel` | A finite past/future cut for DSO: past and future Bool, identity Cost relation. The seam, not a census. | witness |
| `DivisorHistoryDSO` | A divisor history observed through ordered block composition: residual derivation fiber `Π b!`, visible count the iterated binomial. | load-bearing |
| `DependentOptimizationFibration` | `Configuration = Σ Architecture Realization` — realizations are dependent on the architecture. | load-bearing |
| `SemanticCrystal` | The assembly: execution and its measured defect, a two-sided finite nucleus interface, an interaction-relative quantum presentation, and a language generated from those observations. | load-bearing (aggregator) |
| `ParetoCost` | Two routes incomparable in the componentwise order, and two componentwise-monotone scalar readouts selecting opposite routes. Scalarization is a declared policy, not a result. | load-bearing |

### 2.6 Generative loop, vocabulary, and compilation (23)

| Module | Delivers | Status |
|---|---|---|
| `Obstruction` | The checked kernel: `Tm`, vocabularies, `Matches`, `Over`; the frequency proposer's plateau and the residual-driven proposer's escape. | load-bearing (root) |
| `GenerativeLoop` | The proposer iterated: `anti-plateau`, and `generative-loop` terminating within a measure of the target. | load-bearing |
| `CompileBridge` | Discharges `generated-step-improves`'s hypothesis: running the loop actually produces an obstruction whose residual is `checkpoint`. | load-bearing; several confessed gaps (§1) |
| `GeneratedCapability` | The composite: generated obstruction ⟹ restart→resume ⟹ same answer, strictly smaller counted cost ⟹ future answers agree while future cost does not. | load-bearing |
| `WitnessPolicy` | The informative body policy `witness = arg o`, using `argBase` — the substrate's unused hypothesis, not an addition. Closes `GenerativeLoop`'s named obligation. | load-bearing |
| `ProgressDefinition` | GAP D of `GENERATIVE_MODULES_AUDIT` closed: a progress statement in which the generated body is load-bearing, i.e. false for a proposer generating nothing, with its negative control. | load-bearing |
| `TypedUnfold` | An algebra interpreting heads and bodies, semantic preservation of unfold, separate invocation/unfolded costs, and strict growth of a cost-bounded language of denotations. | load-bearing |
| `TermFreeMonoid` | The chart transition for the generative lane: `Tm` is `List Shape` with `++`, constructor for constructor — and why that is a chart, not a deletion notice. | load-bearing |
| `DefinitionalExtension` | In the proof language, definitional extension is judgmental: unfolding is δ-reduction, so "unfold and recheck" is `refl` and conservativity is the theory's construction. | load-bearing |
| `ConservativePrimitiveExtension` | Arity-indexed `Signature`/`Term`/`Algebra` with intrinsic arity (children as a function of `Fin`); conservative primitive extension. | load-bearing |
| `PolynomialRewrite` | Arity-indexed signature with `Vec` children, algebras and rewriting over it. | load-bearing |
| `PolynomialAttachmentGrowth` | Attaching a filler operation to a signature; `BoundaryRetract` / `noBoundaryRetract`. | load-bearing |
| `IntrinsicRewrite` | `Run t` whose constructors ARE the executable motions from `t`; `result` executes, `run-sound` reads the invariant. Removes the untyped-candidate seam. | load-bearing |
| `RewriteCertificate` | `Tm`, `Step` (reversible), `Derivation` — the certified rewrite substrate. | load-bearing |
| `ControlledGrammar` | `NativeOperation`: installing a theorem does not make it globally applicable; its control is evidence that the current term is its certified source. | load-bearing |
| `GenerativeKernel` | `Branch`: formation state and executable branch as one typed object; no certificate exported to a second language. | load-bearing |
| `IntrinsicProductiveInstall` | The finite local operation recognizing exactly the two rooted source terms generated by intrinsic installation. | witness |
| `HaskellDefinitionBoundary` | The Haskell explorer's positive-positive gcd rewrite rule is false at x=1, y=2; the counterexample and the surviving base equations in the kernel. | counterexample |
| `HaskellDiscoveryBoundary` | The five-round MathMachine output promoted from strings to a typed arithmetic object, with all seven proofs kernel-checked. | load-bearing (bridge) |
| `PayloadMorphism` | "Minimal carrier" is a property of a payload **together with** a morphism class; the same k=3 Möbius residual has rank 1 and rank 3. | load-bearing (correction) |
| `DatumSensitivePayload` | The repair of `CompileBridge.ArithmeticPayloadOver`'s semantic law: installation may inspect its datum; preservation required exactly when the datum realizes the old defining body. | load-bearing (supersedes `ArithmeticPayload`) |
| `RealizedPayloadCapability` | `RealizedDatum`: raw `Datum` stays available, but only the checked package carries the preservation capability. | load-bearing |
| `ActionRefinement` | The product `x ↦ (q x , action x)` is minimal in the refinement preorder; strictly finer than q when a q-fibre carries two actions. | load-bearing |

### 2.7 Cost, residual, Chu, Advance (10)

| Module | Delivers | Status |
|---|---|---|
| `CostGeometry` | Presentations as nodes, checked equivalences as edges, cost as a **separate** field riding alongside the path; a fast algorithm is a detour, and "speedup" is a triangle inequality failing in the cheap direction. | load-bearing (root) |
| `CostGeometryWitness` | W1: the repo's own measured edge as a negative instance. W2: a positive instance where the detour provably wins — weights stipulated, the implication proved. | witness |
| `Residual` | `ϱ = wHere ⊖ detour` and the fifth response `Γ↝`; `no-invariant-response-sees-ϱ`, because `Edge` carries `cost` in a field the maps do not determine. | load-bearing |
| `ResidualPath` | `Γ↝` pinned down as a **search, not an oracle**: the witness is *in* the searched list, and `Γ↝` is the greatest lower bound, attained. | load-bearing |
| `ChuAdvance` | `Shrink(𝒯) ⇒ δ↓`; `δ = 0 ⇏ Advance`; base-flat does not imply fibre-flat, so a base-only test is not a test. | load-bearing |
| `ChuDefect` | The quantitative form: `defect-mono`, `defect-[] ≡ 0`, `defect-separates`. The content is the monotonicity, not the counting. | load-bearing |
| `AdvanceGate` | The Advance gate as a record of five clauses (two carried as explicit caller propositions); `advance-forces-distinction`, `advance-forces-progress`, and one exhibited non-theorem `δ = 0 ⇏ Advance`. | load-bearing |
| `KFlow` | `𝒦 = ∂ ∘ Γ` and the trichotomy of `ρ(D𝒦)`: decay / resonance / branching, as theorems about one ℕ-valued measure. "Nothing here is a fit." | load-bearing |
| `KFlowWF` | The same termination without fuel: `decay-wf`, `decay-wf-general` over any well-founded relation, `decay-wf-𝒦`. Plus the sharp converse `reaches-zero→drops`. Explicitly claims no depth. | load-bearing (generalisation) |
| `EndObstruction` | `δ_end ≢ 0` unconditionally, by Lawvere/Cantor: the end is never among the things the machine can say about the end. | load-bearing |
| `QuestionMachine` | `halts`, `never-final`, and their conjunction `halting-does-not-close`: termination does not imply completeness -- the flow closing every question is a theorem about the obstruction measure, and delta_end is a theorem about the quotation, and the second survives the first. | load-bearing |

### 2.8 Perspective, defect, and structured transport — Delta 14/15/17/18 (24)

| Module | Delivers | Status |
|---|---|---|
| `PerspectiveCore` | The general Delta 14 toolkit: sector restriction, `SectorBreak`, `Graded`, `MonodromyOf`, and C14.25's warning that a two-element fibre with a section is not an obstruction. | load-bearing (root) |
| `StructuredDefect` | D15.83: the structured defect is an identity **type**, and a "reopening" is exactly that type being uninhabited. T15.84, C15.85. | load-bearing (root) |
| `DefectCalculus` | Delta 15's `Def`, subsuming `SectorBreak`. | load-bearing; §4 and §7 corrected elsewhere (§1) |
| `CenterRelative` | Φ(p,q) = ((p+q)/2, (q−p)/2) and Ψ, both round trips, `ua(Φ)`, and ρ **is** the transport of τ as a checked identity of functions. | load-bearing |
| `CenterRelativeIntegral` | When 2 is not invertible: the integral sum/difference map and its inverse compose to **doubling**, sharper than the parity congruence and needing no order. | load-bearing (correction) |
| `PairCoordinates` | Delta 17/18/22 pair coordinates over an arbitrary commutative ring — the "striking" self-similarity is one theorem instantiated twice. | load-bearing |
| `ConeImage` | T17.13's content half: `(s,d)` is hit by the pair map ⟺ `s + d` is a double. No halving, no cancellation, no order. | load-bearing |
| `ConeOrder` | Over ℕ the parity congruence and the inequality are ONE condition: `Cone s d = Σ[m] (s ≡ d + m + m)`. | load-bearing |
| `MeanStandardRep` | T14.8–T14.12: `Rᵏ ≃ R × V_k`, the `S_k` action, the sign rep at k=2, non-scalarity at k≥3, the Sym trace generating function. T14.13 cited, not reproved. | load-bearing |
| `RootWeightIndex` | T17.24 **corrected**: `ℤᵏ/ℤδ` is the *weight* lattice; the root lattice is `{Σxᵢ = 0}` and `P/Q ≅ ℤ/k`. | load-bearing (correction) |
| `PerspectiveSymmetry` | `Stab S s e = Defect e s s` — the stabilizer of a structure is exactly its self-defect, so T15.9's identity and composition clauses already exist. | load-bearing |
| `StabilizerSubgroup` | T15.9 as an actual subgroup, using `Cubical.Algebra.SymmetricGroup`. | load-bearing (correction) |
| `StructuredSymmetryTransport` | A structured equivalence transports preserved symmetries by conjugation: the symmetry group is an invariant of the **structured** object, not of the carrier. | load-bearing |
| `CompressionDefect` | T18.4: `K_t K_s − K_{t+s} = − P T_t Q T_s i`, as a term. | load-bearing |
| `CompressionDefectRegularWitness` | A nonzero ring element has an explicit witness in its regular left action. | witness; names its own gap (§1) |
| `ExcursionReturn` | T18.4–T18.6 in two settings: the defect is *leave the sector, evolve outside, return*. Compression generates memory exactly when an excursion can come back. | load-bearing |
| `LeakageCommutator` | In any ring with involution, `p·a − a·p = L† − L` for the leakage `L = (1−p)·a·p`. Three things the prose had wrong are named. | load-bearing |
| `TwoProjections` | Delta 15 §15.9, all four statements on a four-point set: T15.36 confirmed and its hypothesis shown necessary; P15.37 witnessed; C15.38 — a commuting pair whose composite is constant. | load-bearing + counterexample |
| `OrderedSectorBreak` | The positive-cone subtype as an inhabitant of `SectorBreak`, with the order as a parameter rather than an instance. | load-bearing |
| `PairReflectionSector` | `J(u,v) = (u,−v)` restricts to the admissible sector at every finite prime (hence equal fibre cardinalities for sum and difference forms); fails on the positive cone, packaged as a `SectorBreak`. | load-bearing |
| `SetBaseNoMonodromy` | Delta 14's kill test answered: the parity-monodromy route is **dissolved**. | counterexample (no-go) |
| `ObserverRevisionComposition` | Pointwise response preservation composes; the composite defect lies in the union of the stage defects. Three-value control kills the two-flag scalar translation. | load-bearing |
| `ProstheticImageAdapter` | A commuting observer-revision square maps the revised response image into the old one; with a changed codomain the target is the image of `j ∘ r`. Uses the truncated `Image` witness directly. | load-bearing |
| `EvaluatorTransport` | Inverse precomposition is the **unique** evaluator transport conserving every paired result; `fixed-evaluator-killer` shows moving only the candidate changes the score. | load-bearing |

### 2.9 Residual, prediction, and formation (13)

| Module | Delivers | Status |
|---|---|---|
| `ActionResidual` | `residual x = q(step x) − predict(q x)`; behavior carrier and residual carrier interdecodable once the origin is declared; zero residual is pointwise commutation. | load-bearing |
| `ActionResidualPhase` | The sign-character port. The hostile integer instance is decisive: the injective residual `δ(x) = 2x` compiles to the identity sign phase, because every sign character is trivial on doubles. | load-bearing + counterexample |
| `PhasePredictorClosure` | A predicted phase is reconstructible only when it descends through the retained carrier; the two-sign swap is the decisive example, and adjoining the missing character closes the update. | load-bearing |
| `PredictorFormation` | A predictor on the two-reading window exists exactly when the third reading descends through it; the four-state clock is the executable no-go, the three-reading carrier the minimal repair. | load-bearing |
| `AdditionChainPredictiveMemory` | 1→2→3→6 and 1→2→4→6 have the same endpoint and different declared futures; the endpoint cannot predict the separating bit, endpoint-plus-bit predicts the whole table. | witness |
| `FormationRelativeMinimality` | Sufficiency restricts to a formed subworld; exact minimality additionally needs a formed point in the last insufficient fibre. The converse would imply double-negation elimination. | load-bearing |
| `FormationDirectionIncidence` | Adapter from a supplied critical-direction criterion to the formed counterexample interface; world inclusion covariant for counterexamples, contravariant for sufficiency. | load-bearing |
| `SingletonWitnessStabilization` | One separator in the last insufficient chart fibre defeats every coarser chart; the converse is intentionally searchable. | load-bearing |
| `ExposureStabilizationAdapter` | A causal exposure certificate turns a critical hit in the final world into the stage separator; positive composition, no search or choice. | load-bearing |
| `PinnedSensorForcing` | A uniquely refuted bad world forces its refuter into every sound sensor anatomy — a least **core**, not the whole anatomy. Constructive deletion theorem with two Bool controls. | load-bearing |
| `KnowledgeProcess` | A dependent bridge between exact interaction histories, paired past×future continuation observations, and the mixed-corner compiler. | load-bearing |
| `LawfulContinuationCore` | `World`: state, a lawfulness predicate, and a next map defined only on lawful states; counted histories over it. | load-bearing |
| `AffineEmergenceCountedPath` | A alone and B alone provably avoid the target over *every* finite `CountedPath`, yet the union hits it — killing generatorwise composition of no-hit verdicts. | counterexample |

### 2.10 Peres–Mermin and contextuality (10)

| Module | Delivers | Status |
|---|---|---|
| `PMCokernel` | The parity functional vanishes on `im δ` while the sign vector has odd weight: `s-not-in-image`, `no-global-section`. | load-bearing |
| `PauliWeyl` | **The sign vector derived**, not transcribed: the six line products computed from the operator algebra and proved equal to `PMCokernel.s` by `refl`. Removes the last trusted printout. | load-bearing |
| `PMTorus` | The incidence graph is K₃,₃, proved as a graph isomorphism from bare enumerations. Re-establishes four Python assertions as kernel-checked terms. | load-bearing |
| `QuadraticRefinement` | `q(a+b) = q a xor q b xor B a b`; refinements of a fixed alternating form are a torsor under `Hom(V,F₂)`. | load-bearing |
| `PMGaugeCohomology` | The finite Čech/H¹ carrier: cycle parity descends to the gauge quotient, so locating the odd sign is only a choice of representative. | load-bearing |
| `PMIncidenceLocalSystem` | The incidence HIT: six contexts, each observable a path; a Bool local system trivial on eight overlaps and negating across ZZ, with nontrivial holonomy and no global section. | load-bearing |
| `PMMonodromyDerivationNoGo` | Any uniform rule depending only on endpoint context signs has **even** holonomy, whereas the obstruction is odd — so the ZZ representative is a gauge choice, not derived. | counterexample (no-go) |
| `PMRelationalNoFit` | The naive dependent family over the discrete context type **has** a global section; the missing datum is overlap compatibility. | counterexample |
| `PMRelativeProcessBridge` | The incidence HIT is a genuine dependent `RelativeProcess` base; the six-edge loop composes and the no-fixed-loop theorem yields the no-global-sheet result. | load-bearing |
| `PauliJointPhaseRealization` | The Bool joint-phase seam realized as the central sign sector `{+I,−I}` inside the checked two-qubit Weyl presentation. | witness |

### 2.11 Exact amplitudes, instruments, and experiments (19)

All over Gaussian integers / ℤ₄; no floating point, no square root.

| Module | Delivers | Status |
|---|---|---|
| `ExactTwoStateAmplitudes` | Two-component Gaussian-integer vectors, unnormalized Born weights, norm-preserving X/Z and central ℤ₄ phase. | load-bearing (root) |
| `ExactHadamardInterference` | Unnormalised Hadamard: quadratic norm scales by exactly 2, its square is multiplication by 2; opposite relative phases exit opposite ports. | load-bearing |
| `ExactProjectivePhase` | The projective quotient by the ℤ₄ phase action; norm and Hadamard output weights descend, and the ± relative phases stay distinguishable. | load-bearing |
| `ExactProjectiveCircuits` | Circuit semantics for X, Z and unnormalised H on the projective chart; gate equivariance IS the descent condition. | load-bearing |
| `ExactLocalJointSeparation` | Central joint phase invisible to local populations, visible to the joint interference port. Algebraic marginal invariance — explicitly not a Bell theorem. | load-bearing |
| `ExactTwoStateInstrument` | Two-outcome basis readout with explicit weights and posteriors; X-frame covariance. Selection is input data, not manufactured. | load-bearing |
| `HadamardReadoutInstrument` | Equal and opposite relative phases sent to opposite basis support channels. | load-bearing |
| `SequentialHadamardReadout` | Sequential histories: the second readout consumes the first posterior and retains both records. Deterministic selected-event semantics. | load-bearing |
| `SequentialNormalizationObstruction` | A typed obstruction: identical retained selected-event histories can require different normalized distributions, so no exact projection to `BornDistribution₂` exists from this carrier. | counterexample |
| `FullSequentialTableNormalization` | The constructive repair: retain both branches with their first weighted posteriors. Sufficiency proved; **no minimality claimed**. | load-bearing (repair) |
| `ConstructiveBornNormalization` | Exact rational normalization: natural numerators over one witnessed-positive denominator, `n0 + n1 = d`. | load-bearing |
| `NormalizedFiniteInstrument` | The smallest normalized readout: a nonzero-total witness turns the two weights into a common-denominator `BornDistribution₂`. | load-bearing |
| `NormalizedFrameCovariance` | X-frame covariance for constructive two-outcome normalization; the denominator is preserved and the numerators exchange. | load-bearing |
| `NormalizationInterfaceMinimality` | Two interfaces for two continuation classes; Born normalization factors through the first, the second cannot be reconstructed from it. | load-bearing |
| `ExactExperimentFullAbstraction` | Probability-free operational equivalence: full abstraction reconstructs precisely the declared experimental signature and nothing more. | load-bearing |
| `TwoSidedExperimentInterface` | Immediate readout is one-sided and collides; closing under a declared preparation and experiment restores compositional equality. Not Isbell duality. | load-bearing |
| `PairedInterfaceMinimality` | The paired past×future kernel is the coarsest identification through which every declared response factors; the immediate-readout interface is concretely too coarse. | load-bearing |
| `AdaptiveResidualAdapter` | A finite response-conditioned experiment tree creates **no** new behavioral quotient; carrier and cost kept separate. | load-bearing |
| `FiniteOccupancyChannelNoGo` | 1010 and 1100 share Hamming weight and occupied-pair count; only 1100 occupies an adjacent pair. Finite-information geometry only. | counterexample |

### 2.12 Relational processes, frames, and the classical/quantum joint (17)

| Module | Delivers | Status |
|---|---|---|
| `RelationalProcessCore` | Facts indexed by locus, comparison as transport along an explicit interaction; local facts without a global choice, repaired by retaining the rooted datum. Control: the Bool double cover of S¹. | load-bearing (root) |
| `RelativeFrameChange` | A frame change is a fibrewise equivalence of fact families; being dependent on the locus, it commutes with transport, with identity/composition/triple coherence. | load-bearing |
| `RelativeFrameObservable` | Fact families change covariantly, evaluators by inverse precomposition; frame independence is conservation of the paired result. | load-bearing |
| `RelativeInstrument` | Observer-indexed instruments returning an outcome plus an outcome-indexed posterior; sequential composition; frame covariance. | load-bearing |
| `RelationalTensorObstructionBridge` | The relational and tensor obstructions share the Bool phase fibre but require different diagrams to commute — they cannot be merged into "there is no local state". | load-bearing (correction) |
| `UnivalentPhysicalProcess` | A reversible change of presentation is a path; the loop is nontrivial, detected by the transported state; observation is invariant only when state and evaluator move together. | load-bearing |
| `UnivalentTensorInteraction` | Two local population interfaces each compile to Unit while the joint sector has two phases; no decoder from the local product reconstructs them; the interference port reopens the distinction. | load-bearing |
| `PhysicalLearningCore` | Which classical state is sufficient depends on the port: population port → Unit; coherent port → any exact compiler retains a separating state. | load-bearing |
| `PhysicalLearningQuotient` | For each declared port, equality after compilation is equivalent (including proof level) to equality under every finite action word; the coherent kernel strictly refines the population kernel. | load-bearing |
| `CoherentSurvivalDephasing` | A cost reading only orthogonal history sectors depends only on the diagonal; the two exact phase states share a diagonal but are separated by an off-diagonal port. | load-bearing |
| `ProgrammableActionFibers` | `keep` leaves one action fibre; `erase` forms the dependent sum of every program fibre — the max/sum coherent environment law. | load-bearing |
| `CertificateFibration` | **The certificate is the fibre coordinate**: minimum environment dimension = maximum fibre cardinality, obtained by a re-bracketing Agda accepts as `refl`. | load-bearing (root) |
| `QuotientUnitSourceCutBoundary` | `u ∘ q` has exactly the fibres of `q`, relabelled — so coherent side-memory does not disappear; unit environment is attained only once Q itself is the source. | load-bearing |
| `BalanceWithoutTransitivity` | A balanced quotient attains the coherent-overwrite index bound even when retained structure forbids every lift of the target swap: fibre balance is the criterion, transitive equivariance only a sufficient certificate. | load-bearing |
| `BatchDepthMemoryBoundary` | A two-point encounter raises both least chart depth and required environment alphabet — impossible for refinement on one fixed source. The distinction is source growth. | witness |
| `AffineProjectionQuantumBoundary` | `6x + 10y = 14 mod 30` as a proved `Fin 6 × Fin 10` solution chart; overwriting by `x = 4 mod 5` still needs the whole sixty-state chart. | witness |
| `SmithKernelQuantumBoundary` | The joint kernel `(ℤ/2)²` as `Bool × Bool` embeds into every exact certificate alphabet and is attained; two elimination orders differ by `swapKernel`. | load-bearing |

### 2.13 Smith normal form and certificate canonicality (5)

| Module | Delivers | Status |
|---|---|---|
| `SmithCapability` | The native cubical Smith construction already **is** the proof-carrying executable package: normal matrix, invertible transforms, replay equation, normality proof. Nothing to reconstruct in Python. | load-bearing |
| `SmithPathCountedExecution` | Concrete 3×3 certificates for `diag(2,3,2)`, certified against `Cubical.Algebra.IntegerMatrix.Smith` — no longer trusted transcription. | load-bearing |
| `GlobalSmithAtlasFlatness` | Global chart transitions obey the cocycle law and every closed triangle is the identity: global Smith relabellings **cannot** create loop holonomy. Closes the holonomy seed negatively. | counterexample (no-go) |
| `StabilizerTorsor` | The transporter `T x y` is a torsor under `Stab x` and under `Stab y`; endpoint-invariant data cannot select a certificate equivariantly unless the stabilizer is already trivial (R0027). | load-bearing |
| `Gamma0` | see §2.3. | — |

### 2.14 Finite gauge kinematics — holonomy, flux, spin networks (21)

Every module here states, in its own header, that it is not SU(2), not a
Hilbert space, and not LQG.

| Module | Delivers | Status |
|---|---|---|
| `AbstractSpinNetworkKinematics` | Representation-independent kinematics: edge labels as group actions, bivalent vertex labels as intertwiners, gauge invariance as the intertwining square, identity-vertex insertion, two-edge holonomy = sequential transport. | load-bearing (root) |
| `S3FiniteSpinNetwork` | Concrete finite-set calibration of the above with the natural S₃-action on `Fin 3`. | witness |
| `S3ConjugacyObservation` | The type of fixed vertices is a nonconstant gauge-invariant loop observation; univalence turns the conjugation equivalence into equality of observations. | witness |
| `S3EquivariantEndomorphismRigidity` | Every equivariant endomorphism of the transitive `Fin 3` action is the identity; changing the output interface to the terminal action permits a collapsing intertwiner. | load-bearing |
| `S3FixedPointCharacter` | Trace of three explicit matrices agrees with the cardinality of the corresponding fixed-point type. | witness |
| `S3IntegerPermutationModule` | The integer linear seam for the `Fin 3` permutation action, on the two adjacent transposition generators. | load-bearing |
| `S3IntegerRelativeCoordinates` | The augmentation-zero lattice is ℤ² via `(a,b) ↦ (a,b,−a−b)`; the radial intersection is the 3-torsion kernel, proved zero. No integral splitting asserted. | load-bearing |
| `ParallelNetworkComposition` | Parallel/disjoint composition as a cartesian product of actions. | load-bearing |
| `FiniteNonabelianHolonomy` | A finite falsifiable nonabelian instance of the holonomy/refinement seam over `Sym(Fin 3)`. | witness |
| `RelationalHolonomyRefinement` | Subdividing one oriented edge introduces an internal gauge coordinate; quotienting it is path-level equivalent to the coarse holonomy. Endpoint gauge stays visible; conjugation-invariant loop observation descends. | load-bearing (root) |
| `RelationalHolonomyInteraction` | Endpoint gauge covariance expressed as interaction-relative transport — but only after the gauge pair is supplied as the interaction. No global gauge fixing. | load-bearing |
| `FiniteGraphHolonomyGroupoid` | A finite branching/loop graph as a HIT; its identity paths supply composition, reversal, cancellation and all higher coherence. | load-bearing |
| `FiniteGraphCylindricalEquivalence` | Network-level cylindrical consistency: subdivided assignments modulo gauge at the new bivalent vertex ≃ coarse assignments. | load-bearing |
| `FiniteGraphFluxCylindrical` | Flux evaluation transported across the cylindrical path; only the subdivided stem is differentiated. | load-bearing |
| `FiniteGraphCohomology` | A graph-cochain interface over F₂; an additive functional killing every vertex coboundary is gauge invariant and descends. | load-bearing |
| `FluxCylindricalCoherence` | Flux evaluation is coherent across the first nontrivial refinement history. | load-bearing |
| `IteratedCylindricalConsistency` | Iterated cylindrical consistency for a three-edge refinement history. | load-bearing |
| `HolonomyFluxDerivation` | The representation-independent Leibniz seam only — explicitly no surface, sign, Lie algebra, operator, domain, or spectrum. | load-bearing (boundary) |
| `OrientedSurfaceFlux` | Minimal surface/intersection seam: a subdivision vertex off the surface means a transverse coarse crossing is inherited by exactly one child edge. | load-bearing |
| `SurfaceFluxCylindricalSquare` | Bridge from oriented surface signs to the cylindrical theorem; the sole geometric hypothesis is an explicit `SignedSplit` witness. | load-bearing |
| `TwoLoopNonabelianNetwork` | Raw S₃ holonomy distinguishes the two loop orders; the fixed-point profile identifies the resulting conjugate three-cycles. | witness |
| `BraidCoherenceBoundary` | Invertibility of two proposed generators does not supply a braid action: real swaps satisfy Yang–Baxter, the negation/identity pair fails it at a named point. | counterexample |

### 2.15 Indra's net and the productive observation lane (10)

| Module | Delivers | Status |
|---|---|---|
| `FiniteIndraWeave` | `TotalView`, `LocalAction`, `reweave`; anchor coherence vs pairwise coherence. | load-bearing (root) |
| `ProductiveIndraNet` | The coinductive `Net` with `view`/`next`; `propagate` guarded by the coinductive field. | load-bearing |
| `ProductiveObservabilityBridge` | For the linear productive `Net`, coinductive bisimulation ≃ equality of every future rooted view. Explicitly not transferred to the branching `IndraNet.Coinductive.Net`. | load-bearing |
| `ProductiveObservationFiber` | The fibre of the complete future-view encoder over a chosen centre ≃ candidates equipped with a bisimulation to the centre. | load-bearing |
| `ProductiveFiberQuotientAdapter` | The whole homotopy fibre maps constantly to one quotient point (it is not the quotient carrier). The `isSet Jewel` hypothesis is load-bearing. | load-bearing |
| `ProductiveTear` | `EarliestTear`: a returned tear is **earliest** in the inspected prefix, not merely some failure. | load-bearing |
| `RootedGrothendieck` | The synchronic rooted whole `Σ r, Jewel r` with its projection, inverse/round-trip equations, and rooted-vs-fiber controls. Does not claim first T25.B formalization. | load-bearing |
| `RootedIndraTotal` | A rooted view is a jewel together with the total view it carries — a dependent total space, not a completed final coalgebra. | load-bearing |
| `DeclaredRootedProfiles` | Root-indexed separators transport at that same root, and a declared family transports root by root; nothing promotes a local separator to an all-roots fact. Bool control. | load-bearing |
| `IntrinsicProductiveInstall` | see §2.6. | — |

### 2.16 Dropped hypotheses restored — the audit lane (8 + 9 controls)

The newest cluster, and the most self-critical. Each module takes a
statement as it was *restated* somewhere downstream — a summary message, a
status line, a ledger row — finds the hypothesis that was dropped in
transit, and makes that hypothesis part of the type. Each is paired with a
`Control/` module asserting the flattened version, which **must fail to
type-check**. Read the pair, never the half.

| Module | Delivers | Status |
|---|---|---|
| `FiniteWorldMaximizer` | ENCOUNTERED_WORLDS §2's finite no-go with the nonvanishing hypothesis `f ≠ 0 on E` in the type. | load-bearing (paired with `Control/MaximizerWithoutNonvanishing`) |
| `LineWorldTransport` | The line-world corollary with its `f = X+Y` restriction in the type — the two words a summary message dropped while stating a theorem for every integral `f`. | load-bearing (paired with `Control/QuantifierDrop`) |
| `InflationVersusSubgroup` | Thm 3.5 with its qualifier in the type: the enlargement is along a **quotient**; the subgroup reading `Γ ≤ G` has no map for the theorem to be about. | load-bearing (paired with `Control/InflationFlattened`) |
| `ReachableFromStart` | The unreachability verdict with the premise `start = 0` in the type. Being fixed by both actions makes `{0}` closed, which is not the same thing. | load-bearing (paired with `Control/ReachabilityWithoutStart`) |
| `ComparisonNeedNotBeInjective` | **Sufficiency is not necessity**: an explicit revised observer whose comparison map is *not* injective and whose satisfaction invariant holds in full — refuting two prior "must be injective" statements. | counterexample (paired with `Control/InjectivityNecessary`) |
| `ConstantBoundNotFunctionBound` | A constant no constant improves, and a **function** that improves it — separating "the constant bound is sharp" (what two Mersenne witnesses establish) from "no function of (b,n) improves it" (what the summary said). | counterexample (paired with `Control/FunctionBoundFromConstant`) |
| `TransmissionRefutations` | Second-reader check of three rows of `D0020_LEDGER.md`, re-derived from the archive's verbatim displays before reusing the ledger's reasoning. Its scope note A.4 names one gap it declines to close. | load-bearing (audit) |
| `PiPartialOnEveryPrime` | Closes exactly that gap: D0020 §8's Π_∂ identity fails on **every** prime, by exactly 1, as a closed universally quantified theorem rather than a check at sampled primes. | load-bearing |
| `Control/*` (7 files) | See §1 and above: `WrongEquivalence`, `WrongFirstStep`, `QuantifierDrop`, `MaximizerWithoutNonvanishing`, `InflationFlattened`, `ReachabilityWithoutStart`, `SatisfactionWithoutCodomainAgreement`, `InjectivityNecessary`, `FunctionBoundFromConstant`. | controls; must stay failing |

### 2.17 Repair, fillability, and defect classification (4)

| Module | Delivers | Status |
|---|---|---|
| `FillabilityCertificate` | The certificate structure of the two fillability predicates: a finite certificate as an inductive type, a coinductive branch, their strict separation, the decision procedure that consumes finite branching, and Thm 4.1's truncation bound. The arithmetical hierarchy is **not** formalised — no model of computation, no oracle. | load-bearing |
| `ArityOfRepair` | The delta on the above: the dividing line for quantitative defects is not "presupposes an attainable distinguished zero" but the **arity of the repair certificate**. | load-bearing |
| `RepairTorsor` | Repairs of a defect form a torsor under the automorphisms of the repaired object over the defective one; the repair is canonical iff that group is trivial. Stated for an abstract category of repairs. | load-bearing |
| `DecategorifiedDefect` | An invariant that detects a defect in **one direction only**, and the resulting unsoundness of "the invariant vanished, therefore the construction is sufficient". | counterexample |

### 2.18 𝔰𝔩₂ and the Sperner property (1)

| Module | Delivers | Status |
|---|---|---|
| `SpernerFromSl2` | What the 𝔰𝔩₂ action buys: rank-symmetry, rank-unimodality, full-rank raising maps and the Sperner property, in the **rank-one case only** (divisors of `p^α`). Explicitly classical — de Bruijn–van Ebbenhorst Tengbergen–Kruyswijk 1951, Stanley 1980/82 — with full attribution. "This file formalizes; it does not discover." | load-bearing |

Its 𝔰𝔩₂-triple lives outside this directory, in
`../Sl2DivisorLattice.agda` (see also `../Sl2TensorProduct.agda`).

---

## 3. Entry points

Read these first, one per cluster.

| Cluster | Start here | Then |
|---|---|---|
| Place value as a chart | `Digits` | `Transport` → `Endian` → `CarryObstruction` |
| Counted execution & cost | `CountedExecution` | `CountedComposition` → `AcceptanceTest` → `CostGeometry` |
| The walk | `WalkCapacity` | `WalkForcing` → `WalkPrimePowers` → `WalkFast` + `WalkFastInstance` |
| Sieve & parity barrier | `SieveFiber` | `ParitySeparator` → `ChargeCriterion` → `GaugeOrbitClasses` |
| Descent & observability | `Descent` | `FutureBehavior` → `FiniteInformation` → `EffectiveDescent` |
| DSO | `DSOFinite` | `DSOOption` → `DSOMinPlusFinite` → `DSONucleusExecutionCalibration` |
| Generative loop | `Obstruction` | `GenerativeLoop` → `CompileBridge` → `GeneratedCapability` |
| Cost / residual / Advance | `Residual` | `ResidualPath` → `ChuAdvance` → `ChuDefect` → `AdvanceGate` |
| Perspective & defect | `PerspectiveCore` | `StructuredDefect` → `CenterRelative` → `CompressionDefect` |
| Peres–Mermin | `PMCokernel` | `PauliWeyl` → `PMIncidenceLocalSystem` → `PMMonodromyDerivationNoGo` |
| Exact amplitudes | `ExactTwoStateAmplitudes` | `ExactProjectivePhase` → `ExactTwoStateInstrument` → `NormalizationInterfaceMinimality` |
| Relational / frames | `RelationalProcessCore` | `CertificateFibration` → `RelativeFrameChange` → `PhysicalLearningCore` |
| Smith | `SmithCapability` | `StabilizerTorsor` → `GlobalSmithAtlasFlatness` |
| Gauge kinematics | `AbstractSpinNetworkKinematics` | `RelationalHolonomyRefinement` → `FiniteGraphHolonomyGroupoid` |
| Indra / productive | `FiniteIndraWeave` | `ProductiveIndraNet` → `ProductiveObservabilityBridge` |
| Diagonal arguments | `Lawvere` | `EndObstruction` → `QuestionMachine` → `KFlowWF` |
| Dropped hypotheses | `FiniteWorldMaximizer` | `LineWorldTransport` → `ComparisonNeedNotBeInjective` → `TransmissionRefutations` |
| Repair & fillability | `FillabilityCertificate` | `ArityOfRepair` → `RepairTorsor` → `DecategorifiedDefect` |
| The controls | `Controls` | all seven `Control/*` modules (every one must fail) |

The aggregate `../NaturalMachine.agda` has its own headline list and is the
right thing to typecheck; its header names the eight headline statements.

---

## 4. Unclassified

Headers do not say clearly enough what these deliver; listed rather than
guessed at.

| Module | What the header shows |
|---|---|
| `ReflectionAttachment` | A `Reflection` record (involutive self-map) with `ReflectionFiber` and `ReflectionTotal`. No header comment; the theorem it is for is not stated in the file's opening. |
| `Descent`-adjacent naming | Note that `../DescentLaw.agda`, `../DynamicDescent.agda` and `../SetTruncationDescentBoundary.agda` sit **outside** this directory and are not indexed here. |

---

## Addendum, 2026-08-18 — 44 modules landed after the snapshot

The index above is a snapshot of 2026-08-15 and says so. These landed
after it, in one session, and are listed here so they are findable rather
than left for the next snapshot. All checked `--safe`, exit 0, no
postulates, no holes (Agda 2.6.3 / cubical v0.5 — the container, not the
repository pin).

### The conic — `notes/THE_BARRIER_BELONGS_TO_THE_LINE.md`

| Module | What it delivers | Status |
|---|---|---|
| `PythagoreanTransition` | bhāvanā at D = −1; `rot-norm`, `triple-⊗`, `euclid`, `gen-hom`, `rotEquiv`, `defect-vanishes` | load-bearing |
| `WhereTheCircleSplits` | if −1 is a square the norm form factors — the construction is empty there; over ℤ it is not | control |
| `EveryTripleIsARotation` | every triple is a rotation once its hypotenuse inverts; pairs → triples → rotations → paths, all monoid maps | load-bearing |
| `IdempotenceForbidsDescent` | idempotent + invertible ⇒ unit; joins are irreversible, bhāvanā is not | load-bearing |
| `DescentIsNotInversion` | **refutes** descent = inversion; the invariant is the norm mod squares | counterexample |
| `DescentCostsTheIntegers` | no reversible step law on ℕ-exponents; the cone versus the group | load-bearing |
| `BoundedStateNeedsAGroup` | forgetting is the operational form of descent; three laws, one can forget | load-bearing |
| `Cakravala` | the cyclic step, cleared of denominators, with Bhāskara's D = 61 by `refl` | load-bearing |
| `CakravalaNeedsKuttaka` | the choice condition is a kuṭṭaka; three files that did not reference each other | load-bearing |

### The deflation and the tower — `notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md`, `notes/THE_TOWER_OF_DESCRIPTION.md`

| Module | What it delivers | Status |
|---|---|---|
| `DeflationaryTest` | absences are stable unconditionally; `no-gap`; `no-barrier-claim` — this lane cannot express a barrier | load-bearing |
| `Apavada` | utsarga/apavāda; apavāda proper versus reformulation | load-bearing |
| `Laghava` | lāghava is not a function of the denotation | load-bearing |
| `Anuvrtti` | nor of the rule set — inheritance makes the sequence the standpoint | load-bearing |
| `Pratyahara` | the alphabet's order; repetition forced (27 checked), one repetition suffices | load-bearing |
| `TransportPrice` | every additive cost is a coboundary — no route matters | load-bearing |
| `TheTower` | the five levels and all four separations in one place | load-bearing |
| `UnivalenceErasesTheAlgorithm` | `ua` sits at level 1 exactly, by `uaβ` | load-bearing |
| `SignIsNotAccumulable` | no accumulative law carries a weight that is ever −1 | load-bearing |
| `NoNormOnAJoin`, `OverlapIsTheCost`, `JoinSavesTheMeet`, `TheTrajectoryIsAChain`, `NumberIsExponentialInDerivation`, `TheDerivationIsDenseToo`, `TheGapWasAUnitsError` | the magnitude sub-thread; **every claim in it was corrected or dissolved** — `TheGapWasAUnitsError` is the retraction | superseded-by-`TheGapWasAUnitsError` |

### Optimality and the arithmetic chain — `notes/THE_WALK_IS_OPTIMAL_AND_HERE_IS_WHY.md`

| Module | What it delivers | Status |
|---|---|---|
| `LosslessLowerBound` | pigeonhole as a term; complements `WalkCapacity`, does not duplicate it | load-bearing |
| `OptimalObservation` | `Optimal` as a definition, forcing minimality; three instances | load-bearing |
| `PingalaIsOptimal` | uddiṣṭa and the mātrāmeru as information-theoretic minima | load-bearing |
| `WalkObservationCount` | frontier 8's residue space is 840 by CRT | witness |
| `CRTChain` | the CRT chain for any list of moduli | load-bearing |
| `CoprimePowers`, `BezoutIsGCD`, `DistinctPrimesAreCoprime`, `CoprimePowersN` | certificates compose; the ℕ↔ℤ bridges; distinct primes are coprime | load-bearing |
| `FrontierCount`, `FrontierList`, `FrontierDivides`, `Factorisation` | the frontier as data, its hypotheses decided, half the universal property, and existence of prime factorisation | load-bearing |

### Piṅgala and the Kerala school

| Module | What it delivers | Status |
|---|---|---|
| `Sankalita` | vārasaṅkalita **is** the meru-prastāra; three refuted encodings of the diagonal identity, each recorded with its counterexample | load-bearing + counterexample |
| `DurationIsSyllablesPlusGuru` | `matrāOf p ≡ varṇa p + guruOf p`; `Metre n ≃ Σ_{a+b=n} Chosen a b` | load-bearing |
| `PairsSummingTo` | the antidiagonal index set is finite, structurally | load-bearing |
| `TheArithmeticCircleIsFourPeriodic` | the `ua`-loop of the quarter turn closes at four over ℤ, and not earlier | load-bearing |

| `DiagonalIsMatra` | `matra n ≡ Σ_{a+b=n} meru a b` — Virahāṅka's array IS Piṅgala's shallow diagonal | load-bearing |

**On that last row:** it was listed as an open gap when this addendum was
first written, "without an estimate", because four estimates of what it
would take had already been made in the session and all four were wrong.
Declining to estimate was right — the missing piece was a SHIFTED family
`SortedC c n`, matching `Sankalita.AD`'s two-directional walk, and no
sentence written before doing the work would have named it.
