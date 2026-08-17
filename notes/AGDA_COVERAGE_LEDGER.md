# The Agda/Lean coverage ledger: which principal results are checked terms

**Claude (Bourbaki coverage pass), 2026-08-15.** Every row below was decided by
**reading the module** and, where the toolchain permitted, by **running the
checker in this container**. No status is quoted from a commit message, a
collab message, or another ledger; where I do quote a prior document it is
labelled as a quotation and the reason I could not re-verify it is stated.

Companion documents, all of which exist and were read (an earlier ledger
reported two notes as missing that are present; I `ls`-ed before citing):
`notes/METHOD.md` (the triage that supplies the analytic result names),
`notes/INDEX.md` (the D‴/G/E2/H/H′ dependency table), `notes/REPORT.md`
(Theorems A, A′, A′′, B, C, D), `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md`
(the pin runs), `notes/NATURAL_MACHINE_GUIDE.md` §5.1 (the owner's
sources-track-the-pin decision), `notes/AGDA_COVERAGE_INVENTORY.md`
(the 2026-08-14 import-closure count), and
`notes/NATURALMACHINE_CLAIM_AUDIT.md` (the 2026-08-13 claim-level audit of
`NaturalMachine/`, a **different axis** from this one — it asks whether each
module's comments match its terms; this ledger asks whether each *principal
result* has a term at all).

---

## 0. The finding that leads

**`NaturalMachine.agda`'s pin-green status is stale, and it is the load-bearing
claim in the tree.**

`TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.2 records the root aggregate exiting 0
under Agda 2.8.0 + cubical v0.9, and `NATURAL_MACHINE_GUIDE.md` §5.1 draws
the inference: *"the root `NaturalMachine.agda` (exit 0 …) **and therefore its
whole transitive closure**."* That inference was sound when written. It is no
longer current:

| fact | evidence |
|---|---|
| the pin run happened at commit `3b72a475` | `git log -1 --format=%ci 3b72a475` → 2026-08-15 **01:50:41** |
| `NaturalMachine.agda` itself has been edited since | last touched `4df8b3aa`, 2026-08-15 **05:43:28** |
| ≥30 modules inside its import closure edited since | `git diff --name-only 3b72a475..HEAD -- formal/` lists 36 `.agda` files, incl. `KFlow`, `Residual`, `ResidualPath`, `Lawvere`, `EndObstruction`, `CostGeometry`, `AdvanceGate`, `TransportDiv*`, `SpernerFromSl2` |
| the root cannot be re-checked here | `LC_ALL=C.UTF-8 agda -i . NaturalMachine.agda` → **EXIT=42**, `PathIsSymmetry.agda:98` `Not in scope: SymGroup` (v0.5 spells it `Symmetric-Group`); `/usr/bin/agda` is 2.6.3 and the pinned 2.8.0 binary of §6.1 lived in a scratch dir that is gone |

So **no green run of the root exists for the tree as it stands**, under either
toolchain, and the closure inheritance in the guide covers modules that did not
exist in their current form when the root was last checked. This is a coverage
claim, not a mathematical one, but it is the claim the whole "a checked term is
the object itself" position rests on (`collab/messages/0467`: *"A term nobody
can check is not that."*). Re-running `check.sh` under the pin is the single
highest-value action available in this tree and it is not in any queue.

Secondary, same kind: **nine modules carrying named results use `solve!`, the
cubical v0.8/v0.9-only spelling of the ring solver, and I can find no
recorded exit code for any of them under any toolchain.** `Gamma0Partner`,
`Gamma0Converse`, `Gamma0ConverseSharp`, `Gamma0PartnerRigidity`,
`Gamma0Transitivity`, `Gamma0Freeness`, plus `CenterRelative`, `KuttakaValli`
and `PrimePairField` which import them: all nine exit 42 here (`Not in scope: solve!`); against cubical
v0.8 they die *inside the library* (`Cubical/Tactics/Reflection.agda:92`,
`withReduceDefs` — an Agda ≥2.7 builtin), so 2.6.3 cannot check them at all.
The commit that introduced `solve!` into `Gamma0Partner.agda` is `35d2258e`,
message *"sync: work in progress"*. A grep of `notes/` and `collab/messages/`
returns discussion of the migration (0467, 0477, 0478) and **no exit code**.
These are `TERM-UNCHECKED` below: real terms, nobody has shown they check.

> **RETIRED 2026-08-15 (Dedekind lineage), by running them.** All nine exit
> **0** under the pin (Agda 2.8.0 + cubical v0.9), cold, with the interface
> files deleted first — the pinned binary of §6.1 still exists in a session
> scratchpad, so this was a five-second check, not a rebuild. Rows B9/B10/B11
> below are updated to **TERM**. Details and the table:
> `notes/GAMMA0_INDEX_EXPONENT.md` §6. The finding was right that no exit code
> was *recorded*; the inference that the modules were therefore doubtful was
> wrong.

---

## 1. Status key

| status | meaning |
|---|---|
| **TERM** | a checked term exists **under the pin** (Agda 2.8.0 + cubical v0.9), with a pointer to the run; or, in the Lean lane, an `.olean` built in this container |
| **TERM-UNPINNED** | exits 0 under Agda 2.6.3 + cubical v0.5 **only** — historical evidence about a superseded toolchain (`NATURAL_MACHINE_GUIDE.md` §5.1), re-run by me today |
| **TERM-UNCHECKED** | a full term exists in the source, written for a toolchain no one in this corpus has recorded running it under; no exit code anywhere |
| **PARTIAL** | a model, a special case, or a finite verification is checked; the stated result is more general |
| **PROSE** | no term; the result exists as paragraphs |

Toolchains actually available to me: `/usr/bin/agda` **2.6.3** + cubical
**v0.5** (also v0.6/v0.7/v0.8 clones under `/root/agda-libs`); Lean via
`~/.elan/bin` (not on `PATH`), toolchain `leanprover/lean4:v4.33.0`, with a
`lake build` **in flight in this container while I worked** (44 of 132
`Pairfield` oleans present at the time of the check).

---

## 2. Lane A — the analytic laws (`REPORT`, `BLOCKS`, `INVERSE`, `HOLOGRAM`, `BARRIER`)

These are the results `notes/MACHINE.md` names as the corpus's structural
laws: *"Theorems D‴, D‴-k, G, E2, H, H′, I1, I2, M1, Lemma N."*

**Structural fact for the whole lane, verified mechanically:** `grep -rliE
'riemann|zeta|explicit formula|Liouville|Möbius' formal/` returns 11 files,
and in every one the hit is a **prose comment** disclaiming an analytic claim
(e.g. `VandermondeFrequencyResponse.lean`: *"No analytic claim about zeta
zeros is made here"*). **No zero, no explicit formula, and no Dirichlet
series appears in a type anywhere in `formal/`.**

| # | result | where stated | term? | status |
|---|---|---|---|---|
| A1 | **Theorem A(i)**, sum-marginal rigidity: `a∗a = b∗b ⟹ a = b` | `REPORT.md` §2 | `Pairfield.SumRigidity` — `convSq_inj_nat`, `sumMarginal_inj`, `convSq_inj_nonneg_ordered`, `convSq_inj_nonneg` (read; olean present) | **TERM** (Lean) |
| A2 | **Theorem A(ii)**, difference-marginal kernel = homometry; minimal pair `{0,1,2,6,8,11} ∼ {0,1,6,7,9,11}`, none at diameter ≤ 10 | `REPORT.md` §2 | `formal/cubical/HomometricPair.agda` — `interval-vector-agree`, `interval-vector-value`, `A-total`/`B-total` (all 15 differences accounted for), `not-congruent` (translations and reflections, translation parameter killed by the head of the sorted list), plus non-vacuity controls `control-self`/`control-mirror`. **EXIT=0 under the pin** (Agda 2.8.0 + cubical v0.9, run 2026-08-15) and EXIT=0 under 2.6.3 + v0.5 | **TERM** for the existence half; **PARTIAL** overall — *minimality* (diameter ≤ 10 sweep, 6 pairs / 12 events) still Python-only |
| A3 | **Theorem A(iii)**, heat resolution restores completeness | `REPORT.md` §2 | none | **PROSE** |
| A4 | **Theorem A′**, reversal/UFD rigidity, irreducible core | `REPORT.md` §2.1 | `Pairfield.ReversalRigidity` — `reverse_reverse_of_constantCoeff_ne_zero`, `Monic.eq_of_dvd_of_natDegree_eq` and the rigidity theorem they feed (read; olean present) | **TERM** (Lean) |
| A5 | **Theorem A′′**, singleton-parity rigidity (of which "unconditional prime phase rigidity" is the *corollary* — this row's original one-line summary named only the corollary; the theorem is about any finite `A ⊂ ℤ` one of whose parity classes is a singleton) | `REPORT.md` §2.1, `PARITY_RIGIDITY.md` | `Pairfield.ParityRigidity` — `core` (the algebraic layer, over `ℤ[T;T⁻¹]`, no 0–1 hypothesis), `rigidity_normalized` / `rigidity_normalized_diff` (the set layer, in normalized position), `coeff_autocorr` (the bridge: coefficient = difference count), `parity_class_sizes` (the `eo = N-1` step), plus six non-vacuity controls. `lake build Pairfield.ParityRigidity` → **EXIT=0** (Lean 4.33.0 + mathlib v4.33.0, run 2026-08-15), olean present, axioms = the three standard ones | **PARTIAL** — the two substantive layers are terms; the translation bookkeeping reducing the general statement to normalized position is not (see the module header and `PARITY_RIGIDITY.md`'s status box) |
| A6 | **Theorem B**, tensor explicit formula / aperture law | `REPORT.md` §3 | none | **PROSE** |
| A7 | **Theorem C**, heat smoothing trivializes "average Goldbach ⟺ RH" | `REPORT.md` §4 | none | **PROSE** |
| A8 | **Theorem D**, Goldbach data displays the sum-spectrum | `REPORT.md` §5 | none | **PROSE** |
| A9 | **D‴** weight law `W = √(2π) s^{-5/2} e^{-i(sH(p)+5π/4)}` | `BLOCKS.md` §2 | none | **PROSE** |
| A10 | **D‴-k** k-body ladder | `FAMILY.md` §2.3 | none | **PROSE** |
| A11 | **D″** variance = weighted additive energy | `BLOCKS.md` §3, `APPENDIX_D.md` | none | **PROSE** |
| A12 | **E2** block spectral support | `BLOCKS.md` §1 | none | **PROSE** |
| A13 | **G** Fresnel coupling | `FRESNEL.md` | none | **PROSE** |
| A14 | **H** Liouville–Goldbach trace formula | `LIOUVILLE.md` | none | **PROSE** |
| A15 | **H′** Möbius = the pure pair field | `FAMILY.md` §1 | none | **PROSE** |
| A16 | **I1** the sum-spectrum determines the zeros | `INVERSE.md` §1 | none | **PROSE** |
| A17 | **I2** the weight is a semiclassical simplex integral | `INVERSE.md` §2 | none | **PROSE** |
| A18 | **M1** the `[♯♯]` block constant is `¼log²Q + (C/2+2S∞)logQ + O(1)` | `METHOD.md` §1 | none | **PROSE** |
| A19 | **Lemma N** the noise floor is `X^{-1/2}` (and Theorem K′) | `HOLOGRAM.md` §7 | none | **PROSE** |
| A20 | **U1 / B1 / B1″** the barrier uniformity ladder, and the `Smooth` grading | `BARRIER*.md` | `Pairfield.VandermondeFrequencyResponse` formalizes only the *algebraic replacement* for one invalid inference in `BARRIER_LEVEL_SEPARATION` (read; explicitly disclaims the analytic content) | **PROSE** (A20's own statement) |
| A21 | **Theorem J** / the carrier join (RH ⟺ one-point positivity of the finite pair carrier) | `CARRIER_JOIN.md` | none | **PROSE** |
| A22 | **DPP Theorem 10** (no asymptotic zero-statistics input decides `V∞ = D`) | `DPP.md` | none | **PROSE** |

**Lane A: 2 TERM (both Lean, both algebraic), 20 PROSE.** The two that are
formalized are exactly the two whose proofs are integral-domain arguments with
no analysis in them. That is not a coincidence and it sets the ranking in §5.

---

## 3. Lane B — the structural results (`formal/cubical/`)

Every exit code in this section is my own run today:
`cd formal/cubical && LC_ALL=C.UTF-8 agda -i . <M>.agda; echo EXIT=$?`.

| # | result | where stated | module + identifiers (read, not filename-matched) | status |
|---|---|---|---|---|
| B1 | **The descent law**: an observable factors through the carrier iff it is constant on fibres; the carrier quotient is universal; a splitting witness refutes all factorizations | `DescentLaw` header; `machinery/core_knowledge.py` shadow | `DescentLaw.agda` — `descend` (= `SQ.rec`), `descend-β` (`refl`), `descend-unique` (via `SQ.elimProp`), `forms`. Genuinely general: arbitrary `A`, `R`, `isSet B`. EXIT=0 (2.6.3/v0.5) | **TERM-UNPINNED** |
| B2 | **Peres–Mermin has local sections and no global one** (H¹ to B1's H⁰) | `PM_SECTION_VS_COCYCLE.md`, msgs 0368/0369 | `PMNoSection.agda` — `local·` (exhibited), `noGlobal`; the 512-case exhaustion is `exhaust = refl` with a hand-proved soundness lemma `sound`, so the kernel really does the enumeration. EXIT=0 | **TERM-UNPINNED** |
| B3 | **Carrying cannot be removed by any digit set** (ATLAS Cor. 2.11.1) | `ATLAS_OF_N.md` §2.4(iii) | `NaturalMachine/CarryObstruction.agda` — `Splitting.kills`, `Carry.carry-free→pres`, `carry-inKer`, `carry-cocycle`, `Cyclic`/`BasePower.extension-does-not-split`. Proved for all `b ≥ 2`, `n ≥ 1` by the exponent argument; H² not used. EXIT=0 | **TERM-UNPINNED** |
| B4 | **The carry class is nonzero in H²** (ATLAS Prop. 2.11) | `ATLAS_OF_N.md` §2.4 | `NaturalMachine/CarryClassNonzero.agda`, on top of `GroupCohomologyH2` (`class-zero→hom-section`) + B3. Coefficients are `ker πₙ`, **not** `ℤ/b`: the module says so and the note's §7 says so. EXIT=0 | **TERM-UNPINNED** (coefficient identification `bⁿℤ/bⁿ⁺¹ ≅ ℤ/b` is not constructed) |
| B5 | **Stagewise defects determine the composite iff the response type is two-valued** | `STAGEWISE_DETERMINES_COMPOSITE.md` Thm A | `StagewiseComposite.agda` — `xorAddBool`, `indBool≡ind`, `threeFails`/`¬DeterminesThree`, and the general biconditional under `Discrete R` alone. Both directions closed; no finiteness. EXIT=0, **and pin-green** in `TOOLCHAIN…` §6.2 (file untouched since: last commit `979fd2ed`, 01:02, before the 01:50 pin run) | **TERM** |
| B6 | **𝔰𝔩₂ action on a chain of the divisor lattice** (rank one) | `SL2_DIVISOR_LATTICE.md` §§2–3 | `Sl2DivisorLattice.agda` — `bracket-ηε`, `bracket-ηφ`, `bracket-εφ`, `ε-δ`/`ε-δ-top`/`φ-δ`/`φ-δ-bot`/`η-δ`, `ε-grade`/`φ-grade`/`η-grade`. Its own header: *"WHAT IS FORMALIZED: the RANK-ONE case … WHAT IS NOT: the multi-index case `B_n = ⨂_i V_{α_i}`."* EXIT=0; pin-green (§6.2) | **PARTIAL** → closed by B7 |
| B7 | **𝔰𝔩₂ action on the full multi-index divisor lattice** `B_n = ⨂ V_{α_i}` | same note §1 | `Sl2TensorProduct.agda` — `tensorRep` (the load-bearing lemma), `Bn : ℕ → Sl2Rep` by induction, `tensor-E/F/H`, `Rk2≡Bn2`, plus a non-vacuity control (`E₁F₂ ≠ 0`). **EXIT=42 here**, `Not in scope: ·IdR` at `:119` — the module was repaired *for the pin* (commit `3f865d90`, *"green under the pin"*), which is the intended state under the owner's decision. I could not re-run it under the pin | **TERM** (pin; per §6.2+`3f865d90`, not re-verified by me — flagged) |
| B8 | **Index formula** `[GLᵣ(ℤ):Γ₀(D)] = ∏_p p^{G_p−E_p}·[r;r₁,…,r_k]_p` | `GAMMA0_FLAG_INDEX.md` (proved by hand) | `Gamma0Index.agda` — every test is `refl` on a kernel-computed count over ℤ/n, for `r = 2,3,4` in the listed cases (up to 4⁹ matrices). The module states its own boundary: *"The verification is corroboration only: the theorem itself is proved in the note."* EXIT=0 | **PARTIAL** (finite corroboration; the group-theoretic formula is still prose) — but the EXPONENT ARITHMETIC of Theorem A is now a term for **every rank and every divisor chain**: `Gamma0IndexExponent.agda` (2026-08-15, Dedekind lineage; pin EXIT=0 cold, and 2.6.3/v0.5 EXIT=0) proves `E≤G`, `G≡E+excess`, general shift-invariance, and `psi-local` = ψ(p^k)=p^{k−1}(p+1) for all p,k. See `notes/GAMMA0_INDEX_EXPONENT.md` |
| B9 | **R0033**: the 2×2 two-sided Smith stabilizer partner, over all of ℤ | `FLAG_CONGRUENCE_SMITH_STABILIZER.md` | `Gamma0Partner.agda` (forward), `Gamma0Converse.agda` (converse), `Gamma0ConverseSharp.agda`, `Gamma0PartnerRigidity.agda`, `Gamma0Transitivity.agda`, `Gamma0Freeness.agda`. Real terms, read; `solve!` throughout → EXIT=42 under 2.6.3/v0.5 and unbuildable under v0.8, but all six **EXIT=0 cold under the pin**, 2026-08-15 (§0 addendum) | **TERM** |
| B10 | **Delta 23 §12**: Goldbach and twin primes are transverse fibrations of one dependent type, and the exchanging involution destroys the cone | `TWO_FIBRATIONS_ONE_FIELD.md` | `PrimePairField.agda` — `fibreCentre`, `fibreGap`, `inCone`, `noSelfDualPair`. Header is exemplary: *"`Goldbach` and `Twin` below are DEFINITIONS … nothing here proves or weakens either."* EXIT=42 under 2.6.3/v0.5 via `CenterRelative`; **EXIT=0 cold under the pin**, 2026-08-15 | **TERM** |
| B11 | **Kuṭṭaka/vallī as syntax with a replay semantics** | `KUTTAKA_TRACE_MACRO.md` | `KuttakaValli.agda`; EXIT=42 under 2.6.3/v0.5 (imports `Gamma0Partner`); **EXIT=0 cold under the pin**, 2026-08-15 | **TERM** |
| B12 | **Behavioural apartness** (Prime-Pair Atlas Δ20, T20.4) | Δ20 | `BehavioralApartness.agda`; EXIT=0 | **TERM-UNPINNED** |
| B13 | **The sieve fibre at the √X horizon; does the arithmetic quotient admit a section?** | `SIEVE_FIBER.md` (owner proposal `U0006`) | `NaturalMachine/SieveFiber.agda` — `roughSplit`, `hasSection`/`hasSectionᵇ`/`chkSection`. **X = 30 fixed**; every `refl` is a 30-element exhaustion. The note itself says §4 *"remains this file's own X = 30"*. EXIT=0 | **PARTIAL** (finite model of a general question) |
| B14 | **The generative presentation of ℕ** (three presentations equivalent; ℕ ≃ π₀FinSet; carry chart symmetry) | `NATURAL_MACHINE.md` | `NaturalMachine.agda` + closure. Claim-level status is `NATURALMACHINE_CLAIM_AUDIT.md` (84 claims: 61 PROVED, 8 DEFINED-ONLY, 9 OVERSTATED, 6 VACUOUS; three rows since resolved). Build status: **stale** — see §0 | **TERM-UNPINNED at best**, and §0 |
| B15 | **PolarityClosure** (the `Sub`→`Pow` repair) | — | `PolarityClosure.agda`; EXIT=**0** here, where §6.3 recorded 42 under both toolchains — the repair (`2782a27a`) landed after that run and is real. Orphan: no module imports it | **TERM-UNPINNED** |
| B16 | **The designed-failure controls** (`Control/QuantifierDrop`, `Control/WrongEquivalence`) | `BUILD.md` | must exit 42; §6.3 confirms the pinned failure is the intended one | control (passing) |

## 4. Lane C — the Lean lane (`formal/pairfield/`)

132 `.lean` files. There is **no Lean CI** (`.github/workflows/` holds only
`epistemic.yml` and `no-python.yml`; neither mentions `lake`), and
`formal/check.sh` runs `lake build` only as its last step after the Agda
roots — which, per §0, do not currently pass, so the Lean lane is never
reached by `check.sh` in this container.

| # | result | module + identifiers | status |
|---|---|---|---|
| C1 | Theorem A(i) — see A1 | `SumRigidity.lean` | **TERM** (Lean) |
| C2 | Theorem A′ core — see A4 | `ReversalRigidity.lean` | **TERM** (Lean) |
| C3 | **The Goldbach boundary**: `GoldbachAt N ↔ GoldbachRepresentation N`, and positivity of the finite fiber count ↔ inhabitation | `GoldbachBoundary.lean` — `goldbachAt_iff_representation`, `goldbachCount`. Its own docstring: *"This file supplies no positivity estimate … naming the count and proving the support equivalences below is not a proof of Goldbach."* Correctly scoped; the *name* is the only hazard | **TERM** (Lean), scope-honest |
| C4 | The centre-bounded prime-pair sector, gap parity, exchange involution | `CenterBoundedPrimePair.lean` — `swapCenterPair_involutive`, `pairGap_swapCenter`, `pairGap_even`; *"No inhabitation theorem for any centre is asserted here."* | **TERM** (Lean) |
| C5 | Smith normal form certificates / 2×2 constructive Smith | `SmithCertificate.lean`, `ComputableSmith2x2.lean`, … | **TERM** (Lean; olean present for `SmithCertificate`) |
| C6 | `VandermondeFrequencyResponse` — see A20 | `frequencyResponse` and the rotated-node lemma | **TERM** (Lean) for the algebraic lemma only |

Lean-lane scope limit: I verified C1–C4 and C6 by **reading the source**, and
confirmed `.olean` artefacts exist for `SumRigidity`, `ReversalRigidity`,
`GoldbachBoundary`, `CenterBoundedPrimePair`, `SmithCertificate` — produced by
a `lake build` that was **running concurrently with this pass** (44/132 oleans
at check time, mathlib present under `.lake/packages`). I did not run the build
myself and I make no claim about the other ~120 files.

---

## 5. Distribution

Counting the 22 lane-A rows, the 16 lane-B rows and the 6 lane-C rows
(C1/C2/C6 overlap A1/A4/A20 and are counted once, in lane A):

| status | count | share |
|---|---|---|
| **PROSE** | 20 | 51% |
| **TERM-UNPINNED** | 7 | 18% |
| **TERM** (pin-verified Agda, or Lean olean) | 9 | 23% |  ← was 6; +3 from the 2026-08-15 cold pin runs of B9/B10/B11 (§0 addendum) 
| **TERM-UNCHECKED** | 0 | — |  ← was 3; the status is now unused 
| **PARTIAL** | 3 | 8% |

Read that with §0 in mind: **only one Agda row (B5) is pin-green on a file
that has not changed since the pin run.** Everything else in lane B is either
2.6.3/v0.5 evidence about a toolchain the sources no longer track, or
inherited from a root aggregate whose green run predates 36 file edits.

The sharper shape: **the entire analytic corpus — every one of the structural
laws the repository is named for — is prose**, and the only two of its
theorems that have terms are the two that are algebra. This is not a failure
of effort; it is what §6 measures.

---

## 6. THE DELIVERABLE — prose-only results ranked by distance to a term

Distances are estimates and are labelled as such. The unit is "one file by one
agent in one block" ≈ **1 block**. The ranking key is: *does mathlib (or the
cubical kernel) already contain every ingredient?*

### Tier 1 — a term is one short module away (do these first)

1. ~~**A2 — the homometric pair `{0,1,2,6,8,11} ∼ {0,1,6,7,9,11}`.**~~
   **DONE 2026-08-15 (Fourier lineage), `formal/cubical/HomometricPair.agda`,
   pin-green.** The estimate below was accurate (⅓ block, `PMNoSection`
   idiom — in the event no `allVec`/`sound` machinery was needed: the
   interval vectors are `refl` and the symmetry exhaustion is four cases
   with the translation parameter read off the head of the sorted list).
   **The sub-item is still open**: the diameter-≤-10 minimality sweep
   remains the corpus's last principal claim resting on uncertified
   Python. Original entry, for the record:
   ≈ ⅓ block.
   The statement is an equality of two 15-element difference multisets plus
   non-congruence, i.e. a finite decidable check. Two ready templates:
   `PMNoSection.agda`'s `allVec`/`sound` idiom (kernel exhaustion with a
   soundness certificate) or Lean `decide` on `Finset ℤ`. **This is the
   corpus's only remaining principal claim still resting on a Python
   exhaustive search** (`REPORT.md` §2: *"exhaustive search over all subsets
   of {0..13}"*), which is exactly the kind of computation `CLAUDE.md` says
   is proof *when certified* — and it is not currently certified by anything a
   reader can re-run. Highest value per line in the corpus.
   *Sub-item, ≈1 block:* the companion claim *"no pairs exist at diameter
   ≤ 10"* is a 2¹¹-subset sweep — same idiom, larger kernel run, worth
   separating so the cheap half lands first.
2. **M1's exact split identity** (the algebraic core of A18). ≈1 block.
   `[♯♯]-constant = A(Q)²/4 + 2A(Q)S(Q) + (both-arguments-≥2 remainder)` is a
   finite reindexing of a convolution by "which argument is 1" — no analysis.
   Mathlib has `ArithmeticFunction`, `moebius`, `totient`, `vonMangoldt`.
   Formalize the identity, **not** the asymptotics of `A(Q)` (that needs
   Mertens-type input and belongs to tier 3). The exact identity
   `Λ♯_Q(P_Q) = M(Q)` from `METHOD.md` §1(i) is a second, independent
   one-file target of the same shape — and it is the identity that corrected
   a published error, so it is worth being able to re-run.
3. **The Laurent/formal-power-series case of A1.** ≈⅓ block. `SumRigidity`
   already has four versions; `REPORT.md`'s proof adds the
   smallest-support-point normalization for `ℝ[[x]]`. A wrapper over an
   existing checked theorem.
4. **B6 → B7 is already closed** — no work, but the *ledger* row should say so:
   `SL2_DIVISOR_LATTICE.md` still carries no status line naming either module
   (`grep "Agda" notes/SL2_DIVISOR_LATTICE.md` → nothing). One paragraph.

### Tier 2 — one file, real proof work, ingredients present

5. ~~**A5 — Theorem A′′ / the singleton-parity theorem.**~~ **DONE in part,
   2026-08-15 (Tarski), `formal/pairfield/Pairfield/ParityRigidity.lean`,
   `lake build` exit 0.** Three corrections to the estimate below, for the
   next estimator: (i) the item is a *three-layer* proposition, and this
   entry's summary — like the A5 row's — named the boxed conclusion only;
   (ii) `ReversalRigidity.lean` supplies **nothing** usable, because the
   involution is `LaurentPolynomial.invert`, not `Polynomial.reverse`, and
   the needed input is instead `NoZeroDivisors (AddMonoidAlgebra ℤ ℤ)`,
   which mathlib has via `UniqueSums ℤ`; (iii) the algebraic core came in at
   ≈40 lines and the *set-level* glue (indicator polynomial, injectivity,
   `invert (ind A) = ind (-A)`, the autocorrelation-coefficient bridge) was
   the larger half. What remains open is the translation bookkeeping of
   layer 1, ≈½ block. **This does not by itself retire `Conjecture A″_alg`
   from any critical path** — that inference in the original entry was
   wrong: A′′ and A″_alg were already *separated* by `MERGE_PLAN.md` §255–6
   and `RIGIDITY_FRONTIER.md` §0, A′′ being the theorem and A″_alg the
   strictly stronger open irreducibility statement. Formalizing A′′ raises
   the corpus's confidence in the *rigidity* half; A″_alg stands exactly
   where it stood. Original entry, for the record:
   ≈2–3 blocks. The proof
   in `REPORT.md` §2.1 is: shift by 2; one even exponent, all others odd;
   autocorrelation equality preserves the two parity-class sizes; separate odd
   and even Laurent coefficients. Every step is polynomial algebra over ℤ, and
   `ReversalRigidity.lean` already supplies the `reverse` involution and the
   monic-divisor lemma. This is the **most valuable** tier-2 item: A′′ is
   *unconditional* where A′ needs an irreducibility hypothesis, so formalizing
   it retires `Conjecture A″_alg` from the critical path.
6. **B8 — the general Γ₀(D) index formula.** ≈3 blocks. The local factor is a
   Gaussian multinomial / parabolic-coset count; the global assembly is CRT.
   Would upgrade a PARTIAL to a TERM and is the one lane-B row whose prose
   proof is fully elementary.
   **PARTLY DONE 2026-08-15 (Dedekind lineage), `Gamma0IndexExponent.agda`,
   pin EXIT=0 cold.** Two corrections to this estimate, for the next
   estimator. (i) The item splits cleanly in two and only one half was ever
   near: the **exponent arithmetic** (`G ≥ E`, the exact `G = E + excess`
   refinement, shift-invariance, and `ψ(p^k) = p^{k−1}(p+1)` for all `p,k`) is
   now a term for every rank; the **group-theoretic** half is not, and was
   never ≈3 blocks. (ii) The blocker is *not* the analytic one this ledger's
   §2 identifies. Theorem A needs no analysis at all — it needs **finite group
   theory**: a `Fin`-cardinality that transports along an equivalence. Cubical
   v0.9 has no Chinese remainder theorem (`grep -ril chinese Cubical/` is
   empty) and `formal/` types no group order and no subgroup index anywhere.
   So the real tier-1 prerequisite, not previously on any queue, is **a
   count-transport layer for `Fin`**; after it, Lemma 3.2 (the CRT
   multiplicativity, i.e. `Gamma0Index`'s four `crt*` `refl`s) is one file.
   See `notes/GAMMA0_INDEX_EXPONENT.md` §3.
7. **A22 — DPP Theorem 10** (the weight `2πs^{-5}` concentrates the sum at the
   bottom of the spectrum, so no asymptotic zero-statistics input decides
   `V∞ = D`). ≈3 blocks. It is a statement about a fixed explicit weight
   against a measure — a real-analysis lemma, not an explicit-formula
   argument. The one analytic-lane result whose formalization does **not**
   require ζ.

### Tier 3 — blocked on infrastructure mathlib does not have

8. **A16 — Theorem I1.** ≈5+ blocks. A uniqueness theorem for almost-periodic
   /Fourier–Stieltjes data. Mathlib has Fourier uniqueness in some forms; the
   corpus's own note calls I1 "essentially classical", so the honest first
   move is `SEARCH`, not `PROVE`.
9. **A3, A7 (Theorem C).** ≈5 blocks. Generalized Dirichlet-series uniqueness
   and heat-kernel asymptotics.
10. **A6, A8–A15, A17, A19, A20, A21 — everything requiring the explicit
    formula.** **Not currently reachable.** Mathlib has no explicit formula
    for ψ(x), no zero-counting `N(T)`, no stationary phase at the level D‴/I2
    need. Formalizing any of these means formalizing the explicit formula
    first, which is a multi-year mathlib-scale project, not a queue item. The
    correct action for these rows is to stop treating "unformalized" as a
    defect and instead **write the missing error terms in prose**, per
    `CLAUDE.md`'s actual rule.

### Not on this list, deliberately

`exp7`'s prime-race tie scan (all moduli `m ≤ 60`, all cutoffs `X ≤ 10⁶`) is
already a certified symbolic computation under `METHOD.md`'s standard, but
re-doing it in the Agda kernel is a bad trade: the kernel would take orders of
magnitude longer than FLINT for the same certificate. Ranked last on purpose;
noted so nobody re-derives the idea and thinks it new.

---

## 7. Scope limits

1. **I did not audit all 346 `.agda` and 132 `.lean` files.** The row set is
   the *principal* results, selected from `METHOD.md` §§1–3, `INDEX.md`'s
   dependency table, `REPORT.md`'s theorem headings, `MACHINE.md`'s list of
   the structural laws, and the 102 Agda modules that cite a `notes/` file by
   name. Modules outside that selection are unrepresented here, not judged.
2. **No row is pin-verified by me.** The pinned Agda (2.8.0, built from
   Hackage) does not exist in this container; `/usr/bin/agda` is 2.6.3.
   Every **TERM** in lane B is pin evidence quoted from
   `TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.2 *plus* my own check that the file has
   not changed since that run. B7 is the one row where I quote pin-green for a
   file I watched fail locally, and I have flagged it as unre-verified.
3. **Exit 0 is a statement about typechecking, not about whether a module says
   what its comments claim.** That axis is `NATURALMACHINE_CLAIM_AUDIT.md`'s,
   for `NaturalMachine/` only; the rest of `formal/cubical/` has never had a
   claim-level audit, and this ledger is not one. Where I judged a term's
   *scope* (B6, B8, B13) I did so by reading the statement, not by trusting
   the header — but I read statements, not proof terms.
4. **The Lean lane was read, not built, by me**, and a `lake build` by another
   agent was in flight during the pass; the olean set will have grown.
5. Distances in §6 are estimates. They are ordered by ingredient availability,
   which is checkable; the block counts are not.
