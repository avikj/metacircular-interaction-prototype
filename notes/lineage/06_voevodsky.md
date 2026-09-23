# Vladimir Voevodsky — univalence that computes, h-levels as ways back, and mathematics that cannot silently err

## I. The life, as a cognitive trajectory

Vladimir Aleksandrovich Voevodsky was born on 4 June 1966 in Moscow. At Moscow State University he stopped attending classes and was expelled, but by then he was already writing research papers with Mikhail Kapranov, including a 1989–91 paper claiming that strict ∞-groupoids model all homotopy types. Harvard admitted him to its doctoral programme without an undergraduate degree; he completed his thesis, *Homology of Schemes and Covariant Motives*, under David Kazhdan in 1992.

The 1990s were the construction of **motivic homotopy theory**. With Fabien Morel he built A¹-homotopy theory (1999), in which the affine line plays the role of the unit interval, so that the methods of algebraic topology apply to algebraic varieties. With it he constructed motivic cohomology and the triangulated category of motives, and proved the **Milnor conjecture** relating Milnor K-theory mod 2 to Galois cohomology (announced 1996, published 2003). He received the Fields Medal in 2002. With Markus Rost's contributions he then proved the general **Bloch–Kato conjecture**, the norm residue isomorphism theorem, published in 2011.

Voevodsky told the story of what happened next in his 2014 lecture *The Origins and Motivations of Univalent Foundations*. Around 1999–2000 he discovered a mistake in the proof of a key lemma in a 1993 paper of his on presheaves with transfers; the result survived, but the lemma did not. In 1998 Carlos Simpson published a preprint arguing that the main claim of the Kapranov–Voevodsky paper was false, and for years nobody, Voevodsky included, could say with confidence who was right; he became convinced the claim was false only in 2013. His conclusion was that the mathematics he cared most about — long, abstract, with objects of higher dimension whose correctness no referee could fully check — had outrun human verification, and that its foundations would have to be something a computer could check.

From 2005 he studied type theory and saw, as Steve Awodey and Michael Warren did independently, that the identity types of Martin-Löf type theory behave like path spaces, so types behave like homotopy types. In 2009 he formulated the **univalence axiom**: for types A and B, the canonical map from identifications A = B to equivalences A ≃ B is itself an equivalence. Equivalent structures become equal, and every construction transports along equivalences automatically. He built a model in simplicial sets (with Kapulkin and Lumsdaine), began the Coq library *Foundations* (later UniMath), defined h-levels (contractible types, propositions, sets, groupoids, …), and organised the 2012–13 special year at the Institute for Advanced Study that produced the book *Homotopy Type Theory: Univalent Foundations of Mathematics*.

He left open problems he stated precisely:

- **Computational univalence (canonicity).** In Martin-Löf type theory with univalence as an axiom, does every closed term of type ℕ reduce to a numeral? An axiom blocks computation. The cubical type theory of Cohen, Coquand, Huber and Mörtberg (2015) made univalence a theorem that computes, and Huber proved canonicity for it (2016–18).
- **Homotopy canonicity** for type theory with univalence as an axiom, announced by Kapulkin and Sattler (2019).
- **The initiality conjecture**: that the syntax of a type theory is the initial model in a suitable category of models (C-systems, B-systems), which he regarded as essential for justifying the use of models.
- **Univalent universes in every ∞-topos**, proved by Shulman (2019).
- **Two-level type theory (HTS, 2013)**, separating a strict equality from the homotopical one, and the unresolved definability of semisimplicial types.

In his last years he also worked on statistical inference and population genetics. He died of an aneurysm on 30 September 2017.

## II. What he left on the table

1. **Univalence that computes**, as an everyday tool and on real hardware, not only as a model-theoretic fact.
2. **The meaning of h-levels.** A classification of types by the dimension of their identity structure, whose operational content — what you can and cannot recover from a truncation — was stated case by case.
3. **The strict/weak distinction.** The Kapranov–Voevodsky error was the claim that strict higher groupoids suffice. Where strictness is compatible with invertibility, and where it is not, remained a source of error.
4. **Motives and realizations.** The motive as a universal object and its realizations as functors out of it: the relationship between a universal lossless middle and the lossy readings of it, and the fate of quantities (like cost) that do not survive passage to invertible structure.
5. **Uniqueness of structure.** The structure identity principle: an equivalence of structures should be the same as an identification. What constructions are canonical, in the sense of forming a contractible type, rather than chosen.
6. **The object classifier.** A univalent universe classifies families; it cannot classify itself.
7. **Verification as practice.** A mathematics in which statements do not outrun their proofs, errors are caught mechanically, and corrections are part of the record.
8. **Initiality**: the syntax as the initial model, so that every interpretation is the unique map out of it.

## III. Your work through Voevodsky's eyes

### 1. Univalence computes, and you measured where

**Open:** computational univalence, as a working tool and on a runtime.

**What you proved and built.**

- `theorems/physics/Adhisthana`: `transport (ua नकार) true ≡ false` holds by **`refl`** — "not a proved path: a reduction." The Kan floor has **two** primitives, not one: `hcomp` fills a box inside one type; `transp` moves along a line of types and cannot be typed as an `hcomp`. And free path reversal `λ i → p (~ i)` is a property of the De Morgan interval of CCHM, not of cubical type theory as such — on the cartesian cubical site of Angiuli–Brunerie–Coquand–Harper–Favonia–Licata, univalence still computes and reversal is derived rather than read off the interval. The file marks that comparison as sourced metatheory, not a term.
- `theorems/historical_proofs/Anuvrtti_TheGlueIsTransparent…`: under Agda 2.8.0 with cubical v0.9, `transport (ua e) x ≡ equivFun e x` holds by `refl` for an **arbitrary** equivalence and a **neutral** x — the Glue is transparent. The only stuck step is a `transp` at a neutral *type*, and under composition the cost stays one β in the equivalence lane while becoming a transport-composite plus n β's in the path lane, with `uaCompEquiv` identifying the two paths. **The cost is a property of the presentation of an identification, not of the identification.** Every negative claim in the file is recorded as a measurement at a stated toolchain version.
- `theorems/residue/Sankramana` (machine lane): `Machine ≡ Σ Machine (fiber uStep)` by `ua`, and transporting a machine across it computes its completed step; on a concrete machine the crossing evaluates to a closed normal form.
- `collab/bend2-cubical`: the interval, `Path`/`PathP`, boundary-checked path lambdas, `coe` with per-former dispatch and regularity, J **defined** by `coe` along the connection square and computing definitionally on `refl`, binary `hcomp`, and iso-univalence with `uaBeta`, `uaIdEquiv` and `uaEta`, on the Bend2 checker, with a Bend2→HVM4 emitter that lowers transport faithfully (`coe` along a path application becomes applying the path's forward function) and runs on the HVM4 C runtime. `CORRECTIONS.md` records exactly what is not yet there: coherent-equivalence univalence with both round trips at the record level (the iso-level round trip fails by `refl`, as `uaroundtrip.bend` documents), general cofibration systems for `hcomp`, and HITs.

### 2. The meaning of h-levels: the type of ways back

**Open:** the operational content of truncation levels.

**What you proved.** `theorems/grammar/Apratikaryatva` gives the h-level hierarchy its exact meaning:

```
प्रत्यानयनम् n A  ≃  isOfHLevel n A
```

— the type of retractions of the n-truncation map `∣_∣ₕ : A → hLevelTrunc n A` is **equivalent** to the statement that A is an n-type. A retraction forces the level (a retract of an n-type is an n-type); an n-type is its own n-truncation; the space of retractions is contractible when one exists, so the type is a proposition, so the biimplication is an equivalence of types. When A is not an n-type the type of ways back is equivalent to ⊥ (`नष्टिः-न-न्यूनता`): not hard to find, absent. The paths of a propositional truncation are contractible, and the paths between them too (`पथ-नष्टिः`, `पथ-पथ-नष्टिः`), and exactly the maps into propositions survive truncation, as an equivalence of function types (`अनुक्तम्-न-नश्यति`). Every map's fibre family is a complete record of it (`दोषलेखः-पूर्णः`), a map is an equivalence exactly when every fibre is contractible (`संक्रमणम्≃निर्दोषः`), and the disjunction "equivalence or nameable defect" is proved to be exactly excluded middle.

Around it: `Avaccheda` (the fibre of `∣_∣₁` is the whole source), `HidingAndHardness` (the truncation is the maximal hiding modality), `Pratyanayana` (canonical data escapes truncation without choice), and `TritiyaMarga` (writing a defect costs at least Markov's principle).

### 3. Higher structure distinguishes constructions

**Open:** what homotopical content the univalent setting carries that set-level mathematics cannot see.

**What you proved.**

- `theorems/walks/AsetChidra`: `loop ≢ refl` in S¹ by the winding number, so S¹ is not a set; and the descent equivalence `(B → C) ≃ descent data` that `EffectiveDescent` proves for sets C **fails** at C = S¹ (`not-in-image`, `not-equiv`), so its set hypothesis is necessary.
- `theorems/residue/CatuhSamskara`: at the circle, four "repairs" of a non-commuting loop are four distinct objects — set truncation collapses to a point (`Γ∅-collapses`), keeping the class gives ΩS¹ ≡ ℤ with winding 1 (`Γ↺-keeps`), lifting to a 2-cell gives a nontrivial descent datum (`Γ⇑-distinct`), and completion gives the universal cover `helix` whose monodromy `sucℤ` has no fixed point and whose deck group is the loop space (`Γ^-self-classified`) — collected in `four-are-four`.
- `theorems/homotopy/Visvarupa_…ClassifierDoesNotClassifyItself` §8: one application of the fibre law is not vacuous — the winding number is, by `refl`, transport in `helix`, and that transport is an isomorphism onto ℤ. A group nobody put in comes out of one family over one circle.

### 4. The object classifier, and its limit

**Open:** the universe as classifier, and why it cannot classify itself.

**What you proved.** `theorems/homotopy/Visvarupa_TheFibreLawIsTheObjectClassifierAndTheClassifierDoesNotClassifyItself`:

- §0: your own decomposition `SarvavibhagaH` (every map is the sum of its fibres) and HoTT Lemma 4.8.2 (`totalEquiv`) are **the same equivalence** (`equivEq refl`) — while plain `refl` fails, because the two isos are built by different copattern clauses, and the file records that failure as the exact size of the claim;
- §1–§3: the object classifier `(Σ E . E → A) ≃ (A → Type)`; the universal fibration is `fst` on pointed types, its fibre over X is X; every family is a pullback of it;
- §4–§5: transport is a connection (identity over refl, composition over ∙), and the holonomy of the universal family is exactly `(X ≡ Y) ≃ (X ≃ Y)` — univalence read as a statement about one fibration, with `uaβ` making it compute;
- §6: a family that descends along f is constant on f's fibres;
- §7: **the classifier does not classify itself** — the universal fibration over `Type ℓ` is classified in `Type (ℓ-suc ℓ)`; one object per level, the tower forced, and the alternative would be `Type : Type` (Girard, Hurkens).

The companion `Visvarupa_TheObjectClassifierIsTheFibreLaw…` adds the observation that both bindings of `f a ≡ b` totalize to A — binding the output because every summand is contractible, binding the input because the fibres reassemble — so all loss lives in the partition, never in the total; and it states the limit plainly: univalent universes give flat monodromy for free, and curvature needs structure no module here carries.

### 5. Canonicity of structure: completions form a contractible type

**Open:** which constructions are canonical in the univalent sense — a contractible type of choices — rather than chosen.

**What you proved.**

- `theorems/residue/Ekatva`: the type `Lossless f` of lossless completions of any map is **contractible**, by eight explicit equivalences ending in `EquivContr`; and `lawful-steps-are-the-maps : LawfulStep A ≃ (A → A)`. A structure you might have thought was designed is a property.
- `Kernel/SthapanaVarga`: the kernel's self-extensions are classified. A `NativeOperation` is exactly a certificate together with a control gauge (both round trips `refl`); every operation factors through its own installation; the canonical gauge's applicability space is contractible with centre the source. "Self-extension is classified by derivation up to control gauge; installation is the canonical — total, terminal — gauge."
- `theorems/physics/AtmasamataUpari`: the stored two-sided inverse of a conserving flow is exactly invertibility of its map (both propositions), so an observable's symmetry group is Aut_B(A), the automorphisms over B — structure identified with property.
- `theorems/grammar/EkaSutra_J`: J, the graph decomposition and the fundamental theorem of identity types are instances of singleton contraction; `निवृत्तिः` transports any property along any equivalence, "no author required" — the structure identity principle at its working end.

### 6. Strict and weak: where invertibility and grading cannot meet

**Open:** the strict/weak distinction at the root of the Kapranov–Voevodsky error.

**What you proved.** Your kernel exhibits the tension exactly and proves where it lives.

- `NaturalMachine/Avirodha`: derivations under concatenation form a **strict** category — associativity and units hold as data (`⊕-assoc`, `⊕-unitˡ`, `⊕-unitʳ`) — and every derivation has a reversal, but `rev` is an inverse **only up to meaning**: `reverse (reverse p)` is a different constructor application from p, and the round trip has positive length. "Strictly a category, weakly a groupoid; the gap is the śeṣa."
- `theorems/grammar/Laghava`: the reason is a theorem. A grading that adds under composition refuses every inverse, and an inverse refuses every unit-detecting grading. The kernel carries a grading (`len`), so it cannot be a strict groupoid; transports form a group, so they carry no grading.
- `theorems/cost/AvarohaNisedha`: stated at the receiver side, in the language of the motivic tower — no additive ℕ-valued cost survives any receiver that inverts the generator (`noCostSurvives`), so "the implementation fiber must remain attached beside the motive — not as a design preference but as arithmetic."

The question that caught the 1991 paper — can the strict structure carry the invertible one? — has here an exact local form: strictness and invertibility can coexist only where nothing is graded, and wherever a quantity accumulates, the invertibility is weak and the difference is a fibre that no function of the invertible side can see.

### 7. Motives and realizations

**Open:** the motive as universal lossless middle and realizations as its readings, and the fate of quantities under passage to invertible structure.

**What you proved.**

- `fibre/TheCarrierIsTheMotiveAndEachReadingIsARealization`: the **motive** of f is `Carrier f`, into which the to-motive is always an equivalence; the **realization** is the projection out of the middle; every map factors definitionally as `f = realize ∘ to-motive` (`f-factors-through-the-motive` is `refl`); a realization is lossless exactly when every residual vanishes; and **middle-out mediation** — two realizations of one motive-source translate into each other through the shared middle (`through-the-middle-agrees`), so n realizations of one motive mediate n² translations.
- `AvarohaNisedha` (above): cost does not descend to any invertible receiver.
- `theorems/residue/DecategorifiedDefect`: an invariant that kills the zero detects a defect in one direction only — a faithful finite model of K₀ and the Euler characteristic, in which χ(k ⊕ k[1]) = 0 while k ⊕ k[1] ≢ 0 (`model-unsound`) — so the certificate "the invariant vanished, therefore the construction is sufficient" is refuted as a term, while the contrapositive holds unconditionally. The file separates what it models from the derived-category statement.

### 8. Initiality: every reading is the unique fold

**Open:** syntax as the initial model, so that interpretation is unique.

**What you proved.** `Kernel/AdiBija`: the kernel's derivations are initial among receivers of its steps — every receiver (a carrier per source and target, a reading of a rest, a reading of one step then the rest) has a fold (`fold`), and any function with the fold's two computation rules **is** the fold (`fold-unique`). Soundness, cost and every evaluator integral are exhibited as that fold at particular receivers, by the uniqueness theorem. This is initiality for the kernel's own derivation syntax — a different object from Voevodsky's initiality conjecture for the syntax of dependent type theories — and it delivers the consequence he wanted from initiality: every structural reading of the syntax is the unique map out of it.

### 9. A mathematics that does not silently err

**Open:** Voevodsky's reason for univalent foundations — mathematics whose statements cannot outrun their proofs.

**What your practice shows.** The files carry the discipline he asked for, visibly:

- every module states its checking toolchain and whether it was checked at the repository pin (Agda 2.8.0, cubical v0.9) or on a container version;
- headers that claimed more than their terms carry dated, appended corrections rather than silent edits — `Lawvere` and `GodelSeparation` record that two of five classical "instances" were unwitnessed and one was false as stated; `NoTerminalStage` records that its tower argument was not carried by its term; `WitSatisfiesEveryHypothesisButOmegaConsistency` withdraws its reading after a later module proves its witness overdetermined, and then records the matched pair that supplied the missing evidence; `TritiyaMarga` corrects "is exactly Markov's principle" to "at least"; `Dhruva` strikes its own slogan while keeping its term; `Apratiloma` corrects its own framing of a neighbour;
- `Visvarupa…DoesNotClassifyItself` §0 records that `refl` failed where `equivEq refl` succeeded, as the measured size of an identification;
- prior-art searches are run and quoted, including the forms of a statement that would evade the search.

The mathematics Voevodsky wanted was not only machine-checked; it was a mathematics in which prose is subordinate to terms and every overreach is caught and recorded. These files are that, at the scale of thousands of modules.

## IV. The shape of the resolution

| Voevodsky left | Your term | Kind of answer |
|---|---|---|
| Univalence that computes, and at what cost | `Adhisthana` (refl); `Anuvrtti`; `Sankramana`; Bend2 layer | reduction on neutral input; cost belongs to presentation; runs on HVM |
| Meaning of h-levels | `Apratikaryatva.प्रत्यानयनम्≃स्तरः` | type of ways back ≃ h-level hypothesis |
| Higher structure | `AsetChidra`, `CatuhSamskara`, `Visvarupa` §8 | distinct constructions told apart; ℤ from one family |
| Object classifier and its limit | `Visvarupa…DoesNotClassifyItself` §0–§7 | fibre law = classifier; no self-classification |
| Canonical structure | `Ekatva`, `SthapanaVarga`, `AtmasamataUpari`, `EkaSutra_J` | contractible types of completions/gauges |
| Strict vs weak | `Avirodha`, `Laghava`, `AvarohaNisedha` | strict category, weak groupoid; grading forbids strict inverses |
| Motives and realizations | `TheCarrierIsTheMotive…`, `DecategorifiedDefect` | motive = Carrier; realization carries all loss; invariants detect one way |
| Initiality | `AdiBija` | kernel initial; every reading the unique fold |
| Verification as practice | pin statements; appended corrections; quoted prior-art searches | a record in which prose cannot outrun terms |

What Voevodsky would recognize first is the equation at the centre of everything here: `A ≃ Σ B (fiber f)`, which he would read as the statement that every map is a fibration over its image with its homotopy fibres as the fibres — the object classifier's second half. The files show that same equation to be the lossless completion of the universal Turing machine, the chain rule of information, the structure of secrecy, the conservation law of a flow, and the motive of a map. His foundations were built so that such identifications could be trusted. Here they are used.
