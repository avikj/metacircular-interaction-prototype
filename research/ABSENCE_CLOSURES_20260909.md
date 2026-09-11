# Absence closures, 2026-09-09

Method. The corpus records, in its own module headers, what it has not proved
("NOT PROVED", "left open", "would need", "not attempted").  A grep over all
theorem modules yields 795 such lines in 463 files.  Each was read against the
module it sits in and classified: a composition of terms already checked in the
corpus or the pinned library; a real theorem beyond current reach; or prose that
is not a mathematical absence.  Every item in the first class was then composed,
checked at the pin (Agda 2.8.0, agda/cubical v0.9, `--safe`), and committed as a
new module whose header quotes the absence verbatim.  No existing module was
edited.  Nothing was assumed.

## Closed

| Absence (module, its own words) | Closing module | Content |
|---|---|---|
| Drdha: "UNIQUENESS IS NOT PROVED … v_p IS NOT DEFINED HERE" | historical_proofs/Ekatva_… | two firm lists with one product are a Perm; मानम् p n well defined |
| TheUsualReasons / PairwiseCommutation: Perm not shown to be same-multiset; converse containment not proved | Ekatva_…, automata/SamaSankhya_… | on a discrete type Perm = ≈ = same count of every element; the corpus's `_~_` is exactly same-count |
| TheConverseContainment: "Transitivity of Perm is NOT proved" | walks/PermSankramana_… | two insertions commute; exchange lemma; Perm and ≈ are equivalence relations |
| TheOpenPigeonhole / TheTwoPigeonholes: "FinPigeonhole is still NOT proved" | historical_proofs/Kapota_… | injection SFin n → SFin n is an equivalence; TheOpenPigeonhole inhabited |
| Bahupratyanayana: "S¹ has no two distinct points … not invoked" | logic/VrttaBindu_… | ¬ Σ x y. ¬ x ≡ y on S¹ |
| EffectiveDescent: non-set C at which §4 fails "would need π₁(S¹) and is not done" | walks/AsetChidra_… | at C = S¹ the datum (const base, loop) is not in the image; set hypothesis necessary |
| Lagakriya §८: Chosen n k empty for k > n not proved | historical_proofs/GuruSima_… | guru ≤ syllables; row is a finite sum over Fin (suc n) |
| EveryCommonDivisorOfAConvergent: units of ℤ "NOT proved and NOT imported" | number/LowestTerms_… | a·b = 1 ⇒ a = ±1; convergents in lowest terms |
| MinimalityOfABoundaryPopulation: general case "needs exactly one missing lemma, Euclid's" | historical_proofs/Laghutama_… | in lowest terms every boundary population has length ≥ suc q |
| GaugeOrbitClasses: invariance of val under permutation "NOT proved here" | physics/SquareClass_… | val invariant under ≈, Perm, equal counts; full square-class theorem |
| BhavanaGenerative §5: "associativity is unproved" (stale: §7 has PathP forms) | historical_proofs/BhavanaAssoc_… | Sol≡, non-dependent subst forms, solver rederivation |
| ThreadYoneda: "needs isSet (Weave i j) … not proved here" | primes/pair_field/YonedaEquiv_… | Weave is a set; Yoneda bijection is an equivalence |
| TheTextPredicateIsUnique: round trip "not shown to be the identity" | cost/TheRoundTripsClose… | both round trips; Decision ≃ Predicate under the module's hypothesis |
| KsetraSamasa: CRT identification "NOT proved here" | number/RekhaSamasa_… | crtEquiv restricts to survivors; residue-line census (p−2)(q−2) |
| SieveRoughBridge / WalkInduction / CoprimeSplitting: valuation machinery absent | historical_proofs/Prthakkarana_… | n = p^v · m with p ∤ m, exponent unique, valuation additive |
| SthiraBinduGanana: six-element enumeration "NOT proved" complete | physics/SthiraBinduPurnata_… | every element of S₃ is one of six; census reads off the class |
| Avarta: "LAGRANGE, or Euler's theorem for a general finite group. Not proved" | historical_proofs/Sarvavarta_… | a^|G| = 1 for every finite group, via SubgroupIndex's Lagrange |
| TransmissionRefutations: Σ_{d|n} μ(d)(n/d) = φ(n) "NOT proved" in general | number/MobiusPhi_… | the identity for every n ≥ 1 in that module's own definitions |
| TheStrictRateOrder: "ASYMMETRY and TRICHOTOMY are not proved" | order/Trairashika_… | untruncated trichotomy on Rate; total non-strict order; antitonicity |
| Kuttaka: "the iṣṭa section … is not supplied here" | historical_proofs/KuttakaIsta_… | Euclidean division on ℤ; least non-negative member; uniqueness at g = 1 |
| PairComposition: "SEED (stated, not proved here)" | primes/pair_field/PairCompositionSeed_… | isPrime (a·b) ≡ false for a, b ≥ 2; no composed pair is a prime pair |
| HomometricPair: minimality "still rests on the legacy Python search" | order/HomometricMinimality_… | 1024-form kernel sweep with completeness and soundness proofs |
| Hieroglyphics II §5 / notes/FOUR_REPAIR_MODES: "cannot see" whether the four repairs Γ∅ Γ⇑ Γ↺ Γ^ are four objects; Γ⇑ has no corpus defect | residue/CatuhSamskara_… | at S¹: ∥S¹∥₂ contractible (Γ∅); winding loop = 1 (Γ↺); loopDatum ≢ any restricted constant (Γ⇑, the descent defect); helix with fixed-point-free sucℤ and ΩS¹ ≡ ℤ (Γ^); four-are-four |
| Cantor/Lawvere and the Möbius monodromy treated as two theorems (LawvereFixedPoint, Diagonal modules) | automata/Ekasutra_… | Section (Torus e) ≃ FixedPoint (equivFun e) via ua-glue/unglue; point-surjection gives sections; a free monodromy (notEquiv) has no section |
| Hieroglyphics III §Z: Goldbach and twins are read from two kernels; KuttakaSamapti "the logarithmic bound … (Lamé); provable, not yet composed" | primes/EkaBija_…, historical_proofs/Svarnasima_… | one kernel 𝒦 w r = a(w∸r)·a(w+r); Goldbach is the centre marginal, twins the radius marginal, ordered Goldbach count is the Cauchy square; the vallī of consecutive Virahāṅka numbers is the longest, every vallī is shorter than the Virahāṅka inverse |
| fibre census: the seam conjecture (fibre of ∣_∣₁ over a truncated point) | fibre/Fibre/Avaccheda_… | fiber ∣_∣₁ x ≃ A for every x : ∥ A ∥₁ |
| SpernerFromSl2 §8: "THE OPEN STATEMENT. Uninhabited below, deliberately." GeneralSperner, GeneralRankSymmetry | number/Bahuguna_… | both inhabited by the symmetric-chain route; rank sequence of a product of chains is symmetric unimodal (box-SU); caveat that the earlier DivM constrains every coordinate |
| ChargePolynomialFinite; D0026 §5.5 Φ_n(t) = t^{Ω−ω}(t−1)^ω "for every n" | number/Sthirabhara_… | the identity for every positive integer by peeling the least prime; κ₁ three cases; Ω is the length of every firm factorisation; also CHARGE_TOWER_MONODROMY's "Stated, not proved: Ω(n/p⁻(n)) = Ω(n) − 1" is its Ω-step |
| D0026 §5.11 / D0018 T18.7: the gluing defect PU_{h+k}P − PU_hPU_kP | number/PeirceGluing_… | equals the off-sector mass in any ring with a complete family of idempotents; closure iff it vanishes; projection linear not multiplicative |
| D0022 T22.2–T22.5 (owner transmission, in history only) | primes/Vargamula_… | composites coprime to any finite prime set; √X suffices; no finite divisibility observer decides primality; centre/product/gap are Vieta coordinates |
| Lean SumRigidity "does not transport anything from the Agda lane"; the even-N question | primes/GananaNirdhara_… | ordered pair counts at every N determine the sequence, over ℕ; the even counts alone do not (φ = x³+2x⁵+x⁶, ψ = x³+2x⁴+x⁶) |
| PARITY_RIGIDITY / ParityRigidity.lean: "the prime-prefix corollary ... needs 2 odd-prime arithmetic" | primes/DvikaLangara_… | an even number passing primeb is 2; odd differences of primes involve 2; the odd part of the difference count is the prime indicator shifted by 2 |
| WALK_STATE_IS_ITS_LCM: "Not yet Agda — §2's (⊇) needs a coprime-family lcm computation" | walks/Antarala_… | every divisor of cap(k) is the lcm of a family below k; reachable states = divisor lattice of the capacity |
| DISTINCTION_CARRIES_WITNESSES §6 seeds 1, 2: d_sep and cotransitivity under decidable Obs | number/Vaidharmya_… | Apart is irreflexive, symmetric, cotransitive; over a finite alphabet the shortest separating experiment is computed from any separating one |
| ChargePolynomialFinite: "the table is *the* factorization … unique factorization … not proved" | number/Sarani_… | tables expand to firm lists; exponents are the valuation; 12, 30, 360 are the factorizations |

## Not closed, with the exact obstruction

- Cakravāla termination and Bhāskara's minimality (CakravalaBound, CakravalaDescent, CakravalaStep): Lagrange 1768; needs periodicity of the continued fraction of √D.  No corpus term approaches it.
- Petersen's optimality of the Śivasūtras (Sivasutra, PratyaharaLaghava, Dvihpatha): a graded minimisation over all enumerations; unread source, no formal statement in the corpus.
- ℚ(√2) has exactly two orderings (SamacaranaNityam): needs ordered-field theory absent from the pin.
- Nontrivial factorisation of the norm form forces −1 a square (WhereTheCircleSplits): polynomial factorisation over a field, absent.
- Aut ≃ Π over the codomain of Aut(fibre) (AtmasamataUpari, SamraksakaSamuha): the currying coherence of Avaccheda; open in the corpus's own terms.
- Sha256Varga: two distinct colliding inputs.  A SHA-256 collision.
- GunakaKsepa §5: sign normalisation preserving the congruence; a statement about the wheel's own reactor, not a composition.
- KuttakaSamapti: the logarithmic bound on the vallī length (Lamé) is now the Virahāṅka bound of Svarnasima; the base-φ logarithm as a function is still not composed.
- Gleason's theorem (EkatvaMatra); Born interior.
- The seven UNSUPPLIED nodes of research/handoff_20260908 (O-RBOUND, O-RONESIDE, O-RLOWER, O-RLIFT, O-RDYADIC, O-RGOLDBACH, O-NPEAK): analytic estimates; no real-analysis library at the pin; nothing here changes their status.
- The section `(n : ℕ) → frontierb n ≡ true` of SamastaSima (RH × Goldbach): every stage is decided; the section is not inhabited by anything in this corpus.

## Items the fleet's notes list as open that were already closed elsewhere

- DESCENT_ALONG_ONE_MAP_IS_UNOBSTRUCTED seed 1 ("exhibit a non-set C at which clause (2) fails, presumably C = S¹"): walks/AsetChidra_… (2026-09-09).
- FOUR_REPAIR_MODES seed 4 ("Is there a corpus defect whose correct mode is Γ⇑?"): residue/CatuhSamskara_… exhibits the descent datum at S¹ as exactly that object.
- INDIC_CORPUS_OPEN_FRONTIER item 2 ("Meru diagonal = Fibonacci ... Open because the diagonal reindexing over the list representation is fiddly"): metre/MeruKarna.agda already holds मेरु-कर्ण n ≡ length (सर्व n).
- WHAT_IS_ACTUALLY_OPEN §3 (OBLIGATION §7 "specified and never performed"): notes/OBLIGATION_S7_MINCUT.md performed it (interval [115, 222]; self-instance kernel-certified in ObligationMinCut.agda).
- DELTA19_IS_THE_KERNEL_AGAIN seed 3 (instantiate FutureBehavior at a linear system, N_obs = ∩ ker(PTⁿ)): formal/lean/Pairfield/LinearObservabilityKernel.lean.
- GeneralSmith2x2's open item d₁ = gcd of the entries: formal/lean/Pairfield/SmithContent.lean.

## What the exercise shows

Thirty-four absences the corpus had recorded were compositions of terms it
already held.  Several had been closed inside the corpus without the ledger
noticing (BhavanaGenerative §7 already held the PathP forms; FinCardinality
already held the CRT equivalence KsetraSamasa named as missing; WalkJumps
already held the Euclid lemma MinimalityOfABoundaryPopulation said was not
shipped).  The rest of the ledger is either a real theorem beyond the pinned
library or prose.  The open frontier proper is untouched.
