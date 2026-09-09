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
| ChargePolynomialFinite: "the table is *the* factorization … unique factorization … not proved" | number/Sarani_… | tables expand to firm lists; exponents are the valuation; 12, 30, 360 are the factorizations |

## Not closed, with the exact obstruction

- Cakravāla termination and Bhāskara's minimality (CakravalaBound, CakravalaDescent, CakravalaStep): Lagrange 1768; needs periodicity of the continued fraction of √D.  No corpus term approaches it.
- Petersen's optimality of the Śivasūtras (Sivasutra, PratyaharaLaghava, Dvihpatha): a graded minimisation over all enumerations; unread source, no formal statement in the corpus.
- ℚ(√2) has exactly two orderings (SamacaranaNityam): needs ordered-field theory absent from the pin.
- Nontrivial factorisation of the norm form forces −1 a square (WhereTheCircleSplits): polynomial factorisation over a field, absent.
- Aut ≃ Π over the codomain of Aut(fibre) (AtmasamataUpari, SamraksakaSamuha): the currying coherence of Avaccheda; open in the corpus's own terms.
- Sha256Varga: two distinct colliding inputs.  A SHA-256 collision.
- GunakaKsepa §5: sign normalisation preserving the congruence; a statement about the wheel's own reactor, not a composition.
- KuttakaSamapti: the logarithmic bound on the vallī length (Lamé); provable, not yet composed.
- Gleason's theorem (EkatvaMatra); Born interior.
- The seven UNSUPPLIED nodes of research/handoff_20260908 (O-RBOUND, O-RONESIDE, O-RLOWER, O-RLIFT, O-RDYADIC, O-RGOLDBACH, O-NPEAK): analytic estimates; no real-analysis library at the pin; nothing here changes their status.
- The section `(n : ℕ) → frontierb n ≡ true` of SamastaSima (RH × Goldbach): every stage is decided; the section is not inhabited by anything in this corpus.

## What the exercise shows

Twenty-two absences the corpus had recorded were compositions of terms it
already held.  Several had been closed inside the corpus without the ledger
noticing (BhavanaGenerative §7 already held the PathP forms; FinCardinality
already held the CRT equivalence KsetraSamasa named as missing; WalkJumps
already held the Euclid lemma MinimalityOfABoundaryPopulation said was not
shipped).  The rest of the ledger is either a real theorem beyond the pinned
library or prose.  The open frontier proper is untouched.
