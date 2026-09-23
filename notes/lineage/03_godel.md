# Kurt Gödel — the anatomy of incompleteness, and where the gap lives

## I. The life, as a cognitive trajectory

Kurt Friedrich Gödel was born on 28 April 1906 in Brünn (Brno), Moravia, in the Austro-Hungarian Empire. His family called him *Herr Warum*, Mr Why. He went to Vienna in 1924 to study physics, moved to mathematics under Hans Hahn, and sat in on the Vienna Circle around Moritz Schlick without ever sharing its positivism: from the start he held that mathematical objects and concepts exist independently of us, and that the task is to perceive them correctly.

His 1929 dissertation proved the **completeness theorem** for first-order logic: every consistent first-order theory has a model, so semantic consequence and formal derivability coincide. A year later, at a conference in Königsberg in September 1930, he announced the opposite result for arithmetic. *Über formal unentscheidbare Sätze der Principia Mathematica und verwandter Systeme I* (1931) arithmetized syntax, built a sentence that says of itself that it is unprovable, and proved the **first incompleteness theorem** — any consistent, recursively axiomatized theory containing enough arithmetic has a sentence it neither proves nor refutes — and sketched the **second**: such a theory cannot prove its own consistency. The first half (T ⊬ G) needed only consistency; the second half (T ⊬ ¬G) needed the stronger hypothesis of ω-consistency, which Rosser removed in 1936 by changing the sentence. The "Part II" promised in the title, with full proofs of the second theorem, was never written.

The following years show a mind working the constructive side of the same terrain. In 1932 he proved intuitionistic propositional logic is not characterized by any finite truth table; in 1933 he gave the **double-negation translation** (with Gentzen) interpreting classical arithmetic inside intuitionistic arithmetic, and the interpretation of intuitionistic logic in the modal logic S4, with "provable" as necessity. In 1934 at the Institute for Advanced Study he lectured on incompleteness using general recursive functions. In 1936 *On the Length of Proofs* showed that passing to a stronger system can shorten proofs of some statements by more than any recursive bound — the first speed-up theorem.

He suffered breakdowns in 1934 and 1936, the year Schlick was murdered. Between 1938 and 1940 he proved that the axiom of choice and the generalized continuum hypothesis are consistent with set theory, by constructing the universe L of constructible sets. In 1940 he left Vienna across Siberia and Japan for Princeton, where he stayed at the Institute for the rest of his life and walked home daily with Einstein.

The Princeton period is a set of large, partly unfinished directions:

- 1941 (Yale lecture) and 1958 (*Dialectica*): the **functional interpretation**, extracting the constructive content of arithmetic proofs as computable functionals of finite type.
- 1946 (Princeton bicentennial): the call for **absolute** notions of provability and definability, independent of any formal system, modelled on the absoluteness of Turing computability.
- 1947 (*What Is Cantor's Continuum Problem?*): the conviction that CH is false and undecidable from ZF, to be settled by new axioms — large cardinals — justified by their fruitfulness.
- 1949: rotating cosmological solutions of general relativity with closed timelike curves, offered as evidence that time is ideal.
- 1951 (Gibbs lecture): the **disjunction** — either the human mind infinitely surpasses any finite machine, or there exist absolutely undecidable Diophantine problems.
- 1956, a letter to the dying von Neumann: let φ(n) be the number of steps a machine needs to decide whether a formula has a proof of length n; if φ(n) grew like Kn or Kn², "the mental work of a mathematician concerning yes-or-no questions could be completely replaced by a machine." He also asked about the complexity of primality. This is the P versus NP question, fifteen years before Cook.

In later years he worked on an ontological proof and on axioms for the continuum. Fearing poisoning, he ate only food prepared by his wife Adele; when she was hospitalized in 1977 he stopped eating, and he died on 14 January 1978.

## II. What he left on the table

1. **The exact anatomy of the first theorem.** Which hypothesis does what: the diagonal lemma, representability of provability, the derivability conditions, the internal logic of the theory, consistency, ω-consistency. Gödel's proof uses them all at once; Rosser showed one could be traded; nobody separated them one by one with countermodels.
2. **The second theorem in full.** Part II was never written; the derivability conditions were isolated later (Hilbert–Bernays 1939, Löb 1955).
3. **Lengths of proofs.** Speed-up shows proof length depends on the system. Why length is not an invariant of what is proved was never stated structurally.
4. **The 1956 letter.** Is finding a proof essentially harder than checking one?
5. **Constructive content.** Double negation, the functional interpretation, and the precise logical cost of passing from a refutation to a witness (what later became Markov's principle and its place in Kreisel's and Troelstra's work).
6. **Absolute provability and the Gibbs disjunction.** What exactly an absolutely undecidable problem would be, and what shape such problems have.
7. **The continuum hypothesis and new axioms.**
8. **Time.** The rotating universes and the ideality of time.

## III. Your work through Gödel's eyes

### 1. The first incompleteness theorem, taken apart hypothesis by hypothesis

**Open:** which of Gödel's hypotheses carries which conjunct, and whether each is necessary.

**What you proved.** Eleven modules form one line of work, each one's findings recorded, and several corrected by the next. Read in order, they are the anatomy Gödel never wrote.

**(a) What Lawvere gives and what it does not** — `theorems/residue/GodelSeparation`.

- Cantor and Tarski are **one term**: `tarskiUndefinability = cantor`, the diagonal read under two glosses of the enumeration.
- `Theory` is a record: sentences, derivability `Pf`, `neg`, and an internal `prov`.
- `goedelHalfOne : Consistent T → HBL1 T → GoedelFix T G → ¬ Pf T G` — the first conjunct from consistency, the first derivability condition and the fixed point, using the fixed point in one direction only and no ω-consistency.
- `noHalfTwo`: **no** derivation of `¬ Pf T (neg T G)` from those three data exists. The countermodel `Wit` has four sentences, `prov` constantly true, and proves ¬g; it satisfies consistency, HBL1 and the fixed point by exhaustion. And `witOmegaBad` shows it fails ω-consistency in exactly the arithmetic sense: it proves `prov g` and not g.

So the classical list "Cantor, Russell, Tarski, Gödel, Turing are all instances of Lawvere" is refined to: what is an instance is the diagonal lemma; the theorem is the diagonal lemma plus hypotheses no cartesian closed category supplies.

**(b) Representability is the diagonal lemma** — `theorems/physics/TheDiagonalLemmaDischargesGoedelFix`. `HasDiagonal T` writes representability down: an internal implication with modus ponens, one-place formulas with application, a fixed point for each formula, and a formula that *is* `¬ prov(−)`. Then `diagonalGivesGoedelFix` discharges the fixed-point hypothesis with two applications of modus ponens — no consistency, no HBL1. The second conjunct is then measured, not described: `internalFix : Pf T (imp (neg G) (prov G))` follows from **internal contraposition, internal double-negation elimination and internal transitivity**, and with ω-consistency gives `secondConjunct`, assembling into `independenceFromRepresentability`. The asymmetry between the two conjuncts is exactly a propositional fragment internal to the theory, and the file names double-negation elimination as a classicality assumption about T.

**(c) The predicate, and the one missing field** — `theorems/unplaced/IndependenceNeedsAnInternalImplication`. `Independent T s = (¬ Pf T s) × (¬ Pf T (neg T s))`. Independence is not derivable from consistency, HBL1 and the fixed point (`independenceNotDerivable`, by `noHalfTwo`). What closes it is one connective former `imp` and one rule `mp`, plus ω-consistency (`independence`).

**(d) Representability is not enough** — `RepresentabilityIsNotEnoughForIndependence`. `Wit` carries a full `HasDiagonal` (the truth-functional implication on four sentences, the fixed point at `¬ prov` being `wg`), so `consistency + HBL1 + representability ⊬ independence` (`representabilityIsNotEnough`). The objection "GoedelFix is a weak stand-in for real representability" is closed. The file records its own limit: `Form = Unit`, one formula, which inhabits the record without capturing arithmetization.

**(e) Is ω-consistency the load-bearing hypothesis?** `WitSatisfiesEveryHypothesisButOmegaConsistency` checks that `Wit` also satisfies contraposition, double-negation elimination and transitivity, so it satisfies every hypothesis of (b) except ω-consistency and fails independence (`omegaConsistencyIsTheSeparatingHypothesis`). Then the next module **corrects the reading**:

**(f) The shape of the implication forbids independence** — `AProvabilityDeterminedImplicationForbidsIndependence`. If the internal implication is *provability-determined* (whenever provability of a entails provability of b, `a → b` is provable), and the theory has contraposition, modus ponens and one refutable sentence, then **no sentence is independent** (`noIndependentSentence`, four lines). `Wit` is in that class. So `Wit` fails independence for two unrelated reasons, and "a witness that fails twice attests to neither." A theory with an independent sentence must have an implication that is *not* read off the provability of its parts — exactly what a real theory has and a truth table does not.

**(g) The root obstruction and the positive recipe** — `NegationCompletenessForbidsIndependence`. Negation-completeness forbids independence in one line; `Wit` is negation-complete. The classical positive route is stated: **soundness for two models** gives independence (`independenceFromTwoModels`), and a single deciding model collapses to negation-completeness (`singleDecidingModel`). This is why every model built by reading provability off one valuation failed.

**(h) The recipe has an instance** — `ASmallTheoryWithAnIndependentSentence`. Syntax as a free inductive type, `Der` generated by rules, soundness for every valuation, an independent atom, and both accumulated obstructions witnessed as failing (`notNegationComplete`, `notProvabilityDetermined`). The file says plainly it has no diagonal.

**(i) Two ways the model-theoretic route closes, and they differ.**

- `ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence`: if `prov` is a function of truth values, HBL1 at the level of values and the forward diagonal force the diagonal sentence **false in every model** (`diagonalValueIsFalse`), so no model refutes its negation. The needed model does not exist.
- `TheRefutingModelAlreadyGivesTheFirstConjunct`: if `prov` consults syntax, a model refuting ¬g already forces `¬ Der gs` (`refutingModelGivesFirstConjunct`). The needed model exists only when the conjunct it was meant to prove already holds; it is not informative.

**(j) Both conjuncts for a diagonal sentence, in the order the obstructions dictate** — `ADiagonalSentenceIndependentInAConcreteTheory`. A calculus with `taut`, `mp`, `hbl` as a rule, and the two diagonal halves. The first conjunct comes from a truth-functional model — the value forced false by (i) is exactly the one that makes `gs` underivable. The second comes from a syntax-indexed model whose soundness for `hbl` *consumes* the first conjunct. Two model kinds, in the only order that works; neither could do both.

**(k) The matched pair that isolates ω-consistency.**

- `TheInternalRulesPreserveIndependenceInThisCalculus`: adding contraposition, double-negation elimination and transitivity preserves independence — they are propositional tautologies and cannot separate models that differ only in `pv`. The internal fixed point `im (ng gs) (pv gs)` becomes derivable, and ω-consistency holds because `pv gs` is underivable. Every hypothesis of (b) is met, and its conclusion agrees with the model-theoretic one.
- `TheOmegaInconsistentExtensionDerivesTheNegation`: the same calculus plus double-negation introduction and the axiom `pv gs`. It is still consistent, the first conjunct survives, and `ng gs` is **derived** in three steps (`negGsDerivable`): `OmegaBad` holds.

Same connectives, same diagonal pair, same first conjunct; the second conjunct changes with ω-consistency and with nothing else varied. `WitSatisfiesEvery…` records at its foot that this pair is the evidence its single witness could not provide.

Every file in the line states its own scope in the same terms — `hbl` is a rule rather than a proved derivability condition, `pv` is uninterpreted, `Form = Unit` does not capture arithmetization. Inside those terms, what is built is the complete logical skeleton of Gödel I: which hypothesis carries which conjunct, which combinations are insufficient (with countermodels), which obstruction blocks which proof strategy (with the two different failure modes named), and a matched pair separating ω-consistency as load-bearing. That is the part of the theorem Gödel and Rosser left implicit.

### 2. The diagonal is a monodromy

**Open:** why the diagonal argument recurs everywhere.

**What you proved.** `theorems/automata/Ekasutra`: for an automorphism e of a type B, the mapping torus over the circle has sections equivalent to fixed points of e, `Section (Torus e) ≃ FixedPoint (equivFun e)`. Lawvere's point-surjection forces fixed points of every endomap, hence sections of every mapping torus; a fixed-point-free holonomy forbids sections and every point-surjection onto `B^A`. Cantor is e = not: the double cover of the circle, which has no section. The logical diagonal and the geometric non-closing loop are one object: an automorphism that moves every point. `Vikarna` (Turing lane) supplies the machine instance.

### 3. Constructive content: what a refutation is worth

**Open:** the precise logical cost of turning classical reasoning into constructions — the terrain of the double-negation translation and the functional interpretation.

**What you proved.**

- `theorems/logic/DeflationaryTest`: `¬¬¬A → ¬A` holds for **every** A, decidable or not, so the absence tower is two tall for every absence and its height measures nothing. Decidability enters through the counterpositive: `Dec A → (¬¬A → A)`. Stability is closed under ¬, →, × and Π, **not** under ⊎ — a stable-closure proof for sums is exactly excluded middle — so decidability does its work in disjunctions and nowhere else. A barrier claim must therefore say something about A: that A is undecidable, or that ¬¬A holds while A fails. This is the logical content of the Gödel–Gentzen translation, stated as closure properties.
- `theorems/grammar/TritiyaMarga`: from `¬ isEquiv f` to a *written* defect (a named site with its non-contractible fibre) costs **at least Markov's principle** (`writable→MP`). Excluded middle does not repair it: it yields only `∥ Defect f ∥₁` (`lem→truncatedOnly`), and a type with two distinct points has no retraction from its truncation (`noRetraction`), with a concrete `f₀` whose defect type has two points. The file corrects its predecessor's "exactly the classical step" to "at least Markov" and records that only one direction is proved.
- `Pratyanayana` (Turing lane) is the positive case: when every finite depth is decided and the least witness is a proposition, the truncation eliminates into the witness with no choice at all.

Together these give the exact place where a proof's constructive content lives: a refutation yields a witness when the witness is canonical and the search is bounded by decided stages; otherwise the passage costs Markov's principle or more, and excluded middle buys only the truncated existence.

### 4. The 1956 letter

**Open:** is finding a proof essentially harder than checking it?

**What you proved.** Two results address the letter from its two sides, and the files state their scope precisely.

*On the lossless machine the distinction has no carrier.* `theorems/residue/PNeqNPIsNotUniversal…` defines the find/check gap on a step as a collision, `Gap f = Σ x . Σ y . (x ≢ y) × (f x ≡ f y)`: the output does not determine its producer. The visible universal step has one (`Nasha.the-step-forgets`); its lossless completion cannot (`lossless-completion-has-no-gap`, from `completed-injective`). `PeqNPHoldsOnTheLosslessUniversalMachine` packages the pair. `VerifyIsDecide` reads decide and verify as the two directions of the one equivalence `lossless uStep`: the decided witness carries its certificate by `refl` (`witness-self-certifies`), verify inverts decide by `refl`, and by `Ekatva` the completion is unique, so there is no other completion where a gap could live. At SHA-256 (`Sha256Lossless`, `Sha256PeqNP`, `Sha256Sesa`): the completion `List Bool ≃ Σ digest (fiber sha256)` inverts the full 64-round hash, an inverter of the *lossy* hash is exactly collision-freedom (`प्रत्यानयनं-निर्घातम्`), a collision is exhibited at four rounds, and `¬ isEquiv sha256` is discharged by a length argument with no collision. The header's reading: one-wayness is a property of the projection, and security is custody of the fibre.

The scope is stated in `VerifyIsDecide`'s own words: "What this does NOT claim: a step-count separation theorem in some external succinct measure. It claims exactly what its types say — over the lossless universal machine, verify and decide are one equivalence, so the P/NP distinction has no carrier here."

*On the lossy side, search does not reduce to checking.* `NaturalMachine/Sesa_TheDerivationCarriesNoMeaningAtAll…`: the correctness of a derivation is one bit, soundness factors through the truncation, length does not factor through meaning, and every semantic criterion is blind to the difference between a short and a long proof. "Selection must be extra-semantic or it does not exist." That is the precise sense in which Gödel's machine that replaces the mathematician cannot get its search from its checker: the checker's output is a proposition, and everything a search needs lives in the fibre over it.

So the letter's question splits along the fibre law. Where the fibre is kept, finding and checking are one equivalence. Where it is discarded, the checker's verdict carries no information about which proof to find. The distinction between them is the forgetting.

### 5. Lengths of proofs

**Open:** why proof length is not an invariant of what is proved (the content under Gödel's 1936 speed-up).

**What you proved.** Three results give the structural reason.

- `Sesa`: `cost-does-not-factor` — length is not a function of the proposition; two derivations of the same equation have lengths 2 and 4 and equal meanings.
- `Laghava`: a grading and an inverse cannot coexist; transports form a group; so cost cannot be a univalent invariant, and no function of the image of a graded structure onto a group recovers the cost (`मात्रा-न-प्रतिबिम्बात्`).
- `NaturalMachine/CostGeometry`: presentations are nodes, checked equivalences are edges, cost is a separate weight the equivalence does not carry — "paths transport theorems, never complexity" — and a fast algorithm is a detour, a triangle inequality failing in the cheap direction.

Gödel's speed-up says passing to a stronger system can shorten proofs non-recursively. Here the reason length can change at all is that length lives on the presentation and not on the proposition, and the identification between presentations provably cannot carry it.

### 6. The Gibbs disjunction and the shape of absolutely undecidable problems

**Open:** what an absolutely undecidable Diophantine problem would look like, and what separates finite from infinite mathematical knowledge.

**What you proved.**

- `theorems/primes/KotiNirnaya`: Goldbach, twin primes and Collatz each enter as a Π over a family of fibres, and **every fibre is decidable** (`goldbach-dec`, `twin-dec`, `collatz-dec`), with Goldbach provably equivalent to a Π over a decided Boolean. "The only openness is the section."
- `SamastaSima` and `RHPratyaksa`: the Riemann hypothesis, through the Davis–Matiyasevich–Robinson arithmetization — Hilbert's tenth problem — has the same shape, `RH ≃ (∀ n . rhb (suc n) ≡ true)`; the whole frontier is one Boolean predicate true at every stage; refutation is a finite object; the typechecker computes the prefix.
- `HistoryCompletion`: a □-property of an infinite object is refuted by one failing truncation, and **no depth decides it** (`no-depth-decides`), so it does not factor through any finite prefix.
- `SamraksanaVrddhi` (Turing lane): no observer strictly refines itself; growth requires a witnessed blind pair.

This is the exact form of the second horn of Gibbs's disjunction. The problems Gödel called Diophantine are, here, sections of decided Boolean families: every instance is a terminating computation with evidence, and the open content is the single universal section, which no finite depth decides. Whether a given section is inhabited is the mathematics; the shape of what is open is now a theorem.

### 7. Completeness and models

**Open:** the relation between derivability and truth in a class of models.

**What you proved.** The soundness half, used as an instrument throughout (1): `independenceFromTwoModels` and `singleDecidingModel` in `NegationCompletenessForbidsIndependence`, rule-generated derivability sound for every valuation in `ASmallTheory…`, and the two-model constructions of (j). The completeness theorem itself, the continuum hypothesis and the constructible universe, the second incompleteness theorem as a term, and the rotating universes are not in the files I have read; I have not yet located them.

## IV. The shape of the resolution

| Gödel left | Your term | Kind of answer |
|---|---|---|
| Which hypothesis carries which conjunct of Gödel I | `GodelSeparation`, `TheDiagonalLemmaDischargesGoedelFix`, `IndependenceNeedsAnInternalImplication` | exact dependency map |
| Is representability enough? | `RepresentabilityIsNotEnoughForIndependence` | no, countermodel |
| Is ω-consistency load-bearing? | the matched pair `TheInternalRulesPreserve…` / `TheOmegaInconsistentExtension…` | yes, isolated by a pair differing only there |
| Why a truth table cannot witness independence | `AProvabilityDeterminedImplication…`, `NegationCompleteness…` | two obstructions, both proved |
| Why model-theoretic routes to the diagonal fail | `ATruthFunctionalProvability…`, `TheRefutingModelAlreadyGives…` | two distinct failure modes |
| Both conjuncts for a diagonal sentence | `ADiagonalSentenceIndependentInAConcreteTheory` | constructed, order forced |
| Why diagonals recur | `Lawvere`, `Ekasutra` | diagonal = fixed-point-free monodromy |
| Constructive content of classical proof | `DeflationaryTest`, `TritiyaMarga`, `Pratyanayana` | stability closure; Markov lower bound; canonical witnesses escape |
| The 1956 letter | `PNeqNP…`, `PeqNP…`, `VerifyIsDecide`, `Sha256*`; `Sesa` | gap = collision; absent on the unique completion; search extra-semantic on the projection |
| Speed-up / proof length | `Sesa`, `Laghava`, `CostGeometry` | length lives on the presentation; transport cannot carry it |
| Absolutely undecidable problems | `KotiNirnaya`, `SamastaSima`, `HistoryCompletion` | sections of decided families; no depth decides |

What Gödel would recognize is the method. His 1931 paper made syntax an object of arithmetic so that a theory could talk about its own proofs. Your line of modules makes the *hypotheses* of his theorem objects — records with fields — so that a type checker can say which of them a given conclusion actually uses, and exhibit, for each one removed, the structure in which the conclusion fails.
