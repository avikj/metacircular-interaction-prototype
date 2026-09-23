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
| Drdha: "UNIQUENESS IS NOT PROVED â¦ v_p IS NOT DEFINED HERE" | historical_proofs/Uniqueness_â¦ | two firm lists with one product are a Perm; à®à¾à¨à®à p n well defined |
| TheUsualReasons / PairwiseCommutation: Perm not shown to be same-multiset; converse containment not proved | Uniqueness_â¦, automata/SamaCount_â¦ | on a discrete type Perm = â‰ˆ = same count of every element; the corpus's `_~_` is exactly same-count |
| TheConverseContainment: "Transitivity of Perm is NOT proved" | walks/PermTransport_â¦ | two insertions commute; exchange lemma; Perm and â‰ˆ are equivalence relations |
| TheOpenPigeonhole / TheTwoPigeonholes: "FinPigeonhole is still NOT proved" | historical_proofs/Kapota_â¦ | injection SFin n â’ SFin n is an equivalence; TheOpenPigeonhole inhabited |
| Bahupratyanayana: "SÂ has no two distinct points â¦ not invoked" | logic/VrttaBindu_â¦ | Â Î x y. Â x â‰¡ y on SÂ |
| EffectiveDescent: non-set C at which Â§4 fails "would need Ïâ(SÂ) and is not done" | walks/AsetChidra_â¦ | at C = SÂ the datum (const base, loop) is not in the image; set hypothesis necessary |
| Lagakriya Â§à®: Chosen n k empty for k > n not proved | historical_proofs/GuruSima_â¦ | guru â‰ syllables; row is a finite sum over Fin (suc n) |
| EveryCommonDivisorOfAConvergent: units of â "NOT proved and NOT imported" | number/LowestTerms_â¦ | aÂb = 1 â’ a = Â1; convergents in lowest terms |
| MinimalityOfABoundaryPopulation: general case "needs exactly one missing lemma, Euclid's" | historical_proofs/Laghutama_â¦ | in lowest terms every boundary population has length â‰ suc q |
| GaugeOrbitClasses: invariance of val under permutation "NOT proved here" | physics/SquareClass_â¦ | val invariant under â‰ˆ, Perm, equal counts; full square-class theorem |
| CompositionGenerative Â§5: "associativity is unproved" (stale: Â§7 has PathP forms) | historical_proofs/CompositionAssoc_â¦ | Solâ‰¡, non-dependent subst forms, solver rederivation |
| ThreadYoneda: "needs isSet (Weave i j) â¦ not proved here" | primes/pair_field/YonedaEquiv_â¦ | Weave is a set; Yoneda bijection is an equivalence |
| TheTextPredicateIsUnique: round trip "not shown to be the identity" | cost/TheRoundTripsCloseâ¦ | both round trips; Decision â‰ Predicate under the module's hypothesis |
| KsetraSamasa: CRT identification "NOT proved here" | number/RekhaSamasa_â¦ | crtEquiv restricts to survivors; residue-line census (pâˆ’2)(qâˆ’2) |
| SieveRoughBridge / WalkInduction / CoprimeSplitting: valuation machinery absent | historical_proofs/Prthakkarana_â¦ | n = p^v Â m with p âˆ m, exponent unique, valuation additive |
| SthiraBinduGanana: six-element enumeration "NOT proved" complete | physics/SthiraBinduPurnata_â¦ | every element of Sâ is one of six; census reads off the class |
| Avarta: "LAGRANGE, or Euler's theorem for a general finite group. Not proved" | historical_proofs/Sarvavarta_â¦ | a^|G| = 1 for every finite group, via SubgroupIndex's Lagrange |
| TransmissionRefutations: Î_{d|n} Î¼(d)(n/d) = Ï(n) "NOT proved" in general | number/MobiusPhi_â¦ | the identity for every n â‰ 1 in that module's own definitions |
| TheStrictRateOrder: "ASYMMETRY and TRICHOTOMY are not proved" | order/Trairashika_â¦ | untruncated trichotomy on Rate; total non-strict order; antitonicity |
| Kuttaka: "the ia section â¦ is not supplied here" | historical_proofs/KuttakaIsta_â¦ | Euclidean division on â; least non-negative member; uniqueness at g = 1 |
| PairComposition: "SEED (stated, not proved here)" | primes/pair_field/PairCompositionSeed_â¦ | isPrime (aÂb) â‰¡ false for a, b â‰ 2; no composed pair is a prime pair |
| HomometricPair: minimality "still rests on the legacy Python search" | order/HomometricMinimality_â¦ | 1024-form kernel sweep with completeness and soundness proofs |
| Hieroglyphics II Â§5 / notes/FOUR_REPAIR_MODES: "cannot see" whether the four repairs Î“âˆ Î“â Î“âº Î“^ are four objects; Î“â has no corpus defect | residue/CatuhSamskara_â¦ | at SÂ: âˆSÂâˆâ contractible (Î“âˆ); winding loop = 1 (Î“âº); loopDatum â‰ any restricted constant (Î“â, the descent defect); helix with fixed-point-free sucâ and Î©SÂ â‰¡ â (Î“^); four-are-four |
| Cantor/Lawvere and the Mbius monodromy treated as two theorems (LawvereFixedPoint, Diagonal modules) | automata/Ekasutra_â¦ | Section (Torus e) â‰ FixedPoint (equivFun e) via ua-glue/unglue; point-surjection gives sections; a free monodromy (notEquiv) has no section |
| Hieroglyphics III Â§Z: Goldbach and twins are read from two kernels; KuttakaSamapti "the logarithmic bound â¦ (Lam©); provable, not yet composed" | primes/EkaBija_â¦, historical_proofs/Svarnasima_â¦ | one kernel ð’¦ w r = a(wâˆr)Âa(w+r); Goldbach is the centre marginal, twins the radius marginal, ordered Goldbach count is the Cauchy square; the vall of consecutive Virahka numbers is the longest, every vall is shorter than the Virahka inverse |
| fibre census: the seam conjecture (fibre of âˆ_âˆâ over a truncated point) | fibre/Fibre/Avaccheda_â¦ | fiber âˆ_âˆâ x â‰ A for every x : âˆ A âˆâ |
| ChargePolynomialFinite: "the table is *the* factorization â¦ unique factorization â¦ not proved" | number/Sarani_â¦ | tables expand to firm lists; exponents are the valuation; 12, 30, 360 are the factorizations |

## Not closed, with the exact obstruction

- Cakravla termination and Bhskara's minimality (CakravalaBound, CakravalaDescent, CakravalaStep): Lagrange 1768; needs periodicity of the continued fraction of âˆD.  No corpus term approaches it.
- Petersen's optimality of the ivastras (Sivasutra, PratyaharaLaghava, Dvihpatha): a graded minimisation over all enumerations; unread source, no formal statement in the corpus.
- â(âˆ2) has exactly two orderings (SamacaranaNityam): needs ordered-field theory absent from the pin.
- Nontrivial factorisation of the norm form forces âˆ’1 a square (WhereTheCircleSplits): polynomial factorisation over a field, absent.
- Aut â‰ Î  over the codomain of Aut(fibre) (AtmaequalityUpari, SamraksakaSet): the currying coherence of Avaccheda; open in the corpus's own terms.
- Sha256Varga: two distinct colliding inputs.  A SHA-256 collision.
- GunakaKsepa Â§5: sign normalisation preserving the congruence; a statement about the wheel's own reactor, not a composition.
- KuttakaSamapti: the logarithmic bound on the vall length (Lam©) is now the Virahka bound of Svarnasima; the base-Ï logarithm as a function is still not composed.
- Gleason's theorem (UniquenessMatra); Born interior.
- The seven UNSUPPLIED nodes of research/handoff_20260908 (O-RBOUND, O-RONESIDE, O-RLOWER, O-RLIFT, O-RDYADIC, O-RGOLDBACH, O-NPEAK): analytic estimates; no real-analysis library at the pin; nothing here changes their status.
- The section `(n : â•) â’ frontierb n â‰¡ true` of SamastaSima (RH — Goldbach): every stage is decided; the section is not inhabited by anything in this corpus.

## What the exercise shows

Twenty-six absences the corpus had recorded were compositions of terms it
already held.  Several had been closed inside the corpus without the ledger
noticing (CompositionGenerative Â§7 already held the PathP forms; FinCardinality
already held the CRT equivalence KsetraSamasa named as missing; WalkJumps
already held the Euclid lemma MinimalityOfABoundaryPopulation said was not
shipped).  The rest of the ledger is either a real theorem beyond the pinned
library or prose.  The open frontier proper is untouched.
