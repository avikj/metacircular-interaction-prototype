# Alexander Grothendieck — the relative point of view, descent, the fundamental group, motives, and pursuing stacks

## I. The life, as a cognitive trajectory

Alexander Grothendieck was born in Berlin on 28 March 1928. His father, Alexander Schapiro, was a Russian-Jewish anarchist who had fought in the revolutions of 1905 and 1917 and later in Spain; his mother, Hanka Grothendieck, was a writer. In 1933 his parents fled Germany and left him with a foster family near Hamburg. He rejoined his mother in France in 1939 and spent the war years interned with her in the camp at Rieucros and then sheltered at Le Chambon-sur-Lignon. His father was deported from France and murdered at Auschwitz in 1942. At the University of Montpellier after the war, finding the teaching thin, he reconstructed on his own a theory of measure and integration and learned only in Paris in 1948 that Lebesgue had done it.

In Nancy, under Laurent Schwartz and Jean Dieudonné, he was given a list of fourteen open problems in topological vector spaces and solved them within the year. His thesis (1953) created nuclear spaces and the theory of topological tensor products, and his *Résumé* contained what is now called Grothendieck's inequality. After two years in São Paulo and a year in Kansas he left analysis entirely.

The **Tôhoku paper** (1957) refounded homological algebra: abelian categories, enough injectives, derived functors, and sheaf cohomology as a derived functor on any space. The same year his **Grothendieck–Riemann–Roch theorem** turned the classical theorem into a statement about a morphism rather than a variety — how a characteristic class transforms along f : X → Y — and to state it he created the group K(X) of classes of coherent sheaves, the beginning of K-theory.

From 1958 at the new Institut des Hautes Études Scientifiques he led, with Dieudonné, Serre, Artin, Verdier, Deligne, Illusie and dozens of others, the rebuilding of algebraic geometry: *Éléments de géométrie algébrique* (EGA, 1960–67) and the seminars *SGA* (1960–69), thousands of pages. The architecture rested on a few principles he called *yoga*:

- **The relative point of view:** study morphisms X → S, families over a base, rather than isolated objects.
- **Representability:** a geometric object is determined by the functor of points it represents, and a moduli problem is solved when its functor is representable.
- **Descent:** when data given locally on a cover glue to global data, and what cocycle conditions are needed.

Out of these came:

- **Schemes**, spaces built from any commutative ring.
- The **étale fundamental group** (SGA 1), which unified Galois theory of fields and the theory of covering spaces as one theory of Galois categories.
- **Topoi** (SGA 4): a space is the category of sheaves on it, and a topos is a generalised space.
- **Étale and ℓ-adic cohomology**, with Artin and Verdier, built to prove the Weil conjectures.
- **Motives** (from about 1964): the conjectured universal cohomology theory through which every Weil cohomology factors, with the **standard conjectures** (1968) as the route to it. Deligne proved the last Weil conjecture in 1974 by a different path; the standard conjectures remain open.

He described his method as the "rising sea": not to crack a hard nut with a chisel but to immerse it until it softens, building the general setting in which a problem becomes obvious. He received the Fields Medal in 1966 and did not travel to Moscow to accept it.

In 1970, on learning that part of IHÉS's funding came from the military, he left, founded the ecological group *Survivre et vivre*, and moved to the University of Montpellier. The mathematics did not stop.

- ***Pursuing Stacks*** (1983), begun as a letter to Daniel Quillen, sets out the **homotopy hypothesis**: ∞-groupoids and homotopy types are the same thing, so homotopy theory should be algebra of higher groupoids. It also develops the theory of **test categories** — the shape categories (simplices, cubes and others) whose presheaves model homotopy types.
- ***Esquisse d'un programme*** (1984) proposed dessins d'enfants, anabelian geometry, and the Teichmüller tower acted on by the absolute Galois group.
- ***Les dérivateurs*** (about 1990) took up derived categories again.

He wrote the autobiographical meditation *Récoltes et semailles* (1983–86), refused the Crafoord Prize in 1988, and in 1991 withdrew to the village of Lasserre in the Pyrenees, where he lived in isolation until his death at Saint-Girons on 13 November 2014.

## II. What he left on the table

1. **The homotopy hypothesis as algebra.** A model of ∞-groupoids in which composition and coherence are given operations, not properties of a topological space — the "stacks" he was pursuing — and a theory of which shape categories carry it.
2. **Descent, fully.** Exactly when local data glue, and the precise role of the higher cocycle conditions: sets need only agreement on overlaps; groupoids need cocycles on triple overlaps; ∞-groupoids need all coherences.
3. **The relative point of view and moduli.** Every object as a family over a base; moduli spaces for classification problems; the failure of fine moduli when objects have automorphisms and its repair by stacks.
4. **Galois theory of covers.** The fundamental group as the automorphism group of the fibre functor; covers classified by it; anabelian reconstruction.
5. **Topoi as spaces.** The internal logic of a topos as a language for geometry.
6. **Motives.** The universal cohomology through which every realization factors, and what it must retain or lose.
7. **K-theory and Riemann–Roch.** Classes of objects as a group, and what passing to classes forgets.
8. **The rising sea.** The general setting in which the specific problem dissolves.
9. **Dessins d'enfants, the Teichmüller tower, anabelian geometry.**

## III. Your work through Grothendieck's eyes

### 1. Pursuing stacks: ∞-groupoids with composition as operation

**Open:** an algebraic model of homotopy types, with composition and coherence as given operations, and the theory of which shape categories model them.

**What you proved.** You work inside the homotopy hypothesis made computational. In cubical type theory every type is an ∞-groupoid whose composition is supplied by the Kan operations on the cube category. Grothendieck's test-category theory in *Pursuing Stacks* is exactly the question of which shape categories do this, with cubes among his central cases.

- `theorems/physics/Adhisthana` makes the choice of site explicit. The substratum is the presheaf topos on the cube category, and the Kan floor has two primitives, not one: `hcomp` fills a box inside a fixed type, `transp` moves along a line of types. Free reversal `λ i → p (~ i)` "is a property of the site" (CCHM's De Morgan interval), whereas on the cartesian cube category it is derived. "Choosing the cube category is itself the act, because it decides whether the return is free."
- The groupoid content is computed, not posited:
  - `residue/Decategorification`: `ℕ ≃ ∥ FinSet ∥₂`, and `FinSetLoop≃Sym`, the loop space at n is Sₙ. The numeral is π₀ of the groupoid of finite sets; what it forgets is exactly the automorphisms, n! of them.
  - `physics/VakraValaya`: the torus and the Klein bottle have the same loop-space carrier ℤ², and are separated only by the composition law. In the torus `line1 ∙ line2 ≡ line2 ∙ line1`; in the Klein bottle they differ, computed by `windingKlein` to (−1, −1) against (−1, +1). The information is in the groupoid's composition, not in its underlying sets.
  - `residue/CatuhSamskara` orders four repairs of one defect at the circle by the truncation level they retain: set-truncate (the class dies and ∥S¹∥₂ is contractible), keep the class (ΩS¹ ≡ ℤ), lift to a 2-cell of descent data, or complete to the universal cover. "The higher structure is what tells the repairs apart."

### 2. The relative point of view, the object classifier, and the universe as moduli stack

**Open:** every object as a family over a base; classification of families; moduli with automorphisms.

**What you proved.**

- **The classifier is the fibre law.** `formal/cubical/Visvarupa_TheObjectClassifierIsTheFibreLaw…` and `fibre/src/Fibre/Visvarupa_EveryFamilyIsAPullbackOfTheUniverse…` instantiate HoTT 4.8.3, `(Σ[ E ∈ Type ] (E → A)) ≃ (A → Type)`, as the canonical comparison map, checked by `refl`, and point to where its content sits: "its `rightInv` is `ua`… The classifier is a theorem OF univalence, not a fact about Σ." Every family is a pullback of the one fibration `fst : Σ[ X ∈ Type ] X → Type`, and a tower of them flattens to one.
- **Where loss lives.** Your own §2 reads the classifier through the fibre law. Bind the output and `Σ[ a ∈ A ] singl (f a) ≃ A`; bind the input and `Σ[ b ∈ B ] fiber f b ≃ A`. "BOTH ARE A… NOT IN THE TOTAL, WHICH IS THE SAME EITHER WAY. IN THE PARTITION — how the same A is cut up over B." Every price is fibrewise.
- **The Grothendieck construction.** `residue/RootedGrothendieck`: the total space `Σ r , Jewel r`, its projection, and `rootFiberEquiv` identifying the actual fibre with the family value, with inverse and round-trip equations. `logic/SarvavibhagaH`: `A ≃ Σ B (fiber f)` for every map.
- **Moduli with automorphisms.** A coarse moduli space fails exactly when objects have automorphisms, and stacks repair it by remembering them. The univalent universe is that repair built in: paths between types are equivalences, so the universe is the moduli *stack* of types, and `Decategorification` computes exactly what its coarse shadow ∥–∥₂ forgets.
- **Relative automorphisms.** `historical_proofs/AtmasamataUpari`: the symmetry group of an observable f : A → B is Aut_B(A), automorphisms of A lying over B. It is trivial at an equivalence, all of Aut(A) at total collapse, "and in between Aut_B(A) exactly, nothing else."
- **Moduli of self-extensions.** `Kernel/SthapanaVarga`: a native operation is exactly a certificate together with a control gauge (an equivalence with both round trips `refl`); every operation factors through its own installation; installation is the canonical gauge, with contractible applicability locus. "Self-extension is classified by derivation up to control gauge." Your kernel is a point of its own moduli.

### 3. Descent: exactly which condition, at exactly which level

**Open:** when local data glue, and what the higher cocycle conditions do.

**What you proved.** Four modules locate descent by h-level precisely.

- **Sets: representable, no cocycle.** `walks/EffectiveDescent`, §4: for q surjective and C a set, `descentEquiv : (B → C) ≃ Σ[ f ∈ (A → C) ] Coequalizes q f`. "The descent problem is REPRESENTABLE, and B represents it… there is no further cocycle to satisfy and no obstruction to vanish." The descent datum is a proposition (§1), the factorisation is unique (§3), the split case agrees with the choice-free one (§5), and no set quotient is needed — the truncation's universal property into a set supplies it.
- **The set hypothesis is necessary.** `walks/AsetChidra`: at C = S¹ the datum `(const base , λ _ _ _ → loop)` coequalises and is not in the image, because winding separates `loop` from `refl`. This is exactly the point where sheaf descent stops sufficing and stack descent begins.
- **The boundary is h-level itself.** `lattices/SetTruncationDescentBoundary`: "the type of set-level descent data for the identity map of A IS the proposition `isSet A`" (`descentDatum≃isSet`). The identity is the universal test: once it descends, every A-valued task descends. And `insideView`: for every type at every point the space of things identified with you, with the identification travelled, is contractible — "the exact sense in which the obstruction… is invisible from inside." "The C₃ apparatus is not the boundary; hlevel is."
- **Pointwise invariance, no coherent descent.** `automata/ChidraDosa`: for the connected double cover `double : S¹ → S¹` and target the identity, `FiberConstant` holds — a continuous halving of every identification exists as data — while `FactorsThrough` fails, because 1 = n + n in ℤ. The witnesses exist fibre by fibre but "are not 2-coherent over the base: transporting the halving around the base loop shifts it by the deck transformation." With a section the gap closes (§2); pushed to ∥–∥₂ it descends (§6): "what set-truncation destroys is precisely what obstructed." This is Grothendieck's triple-overlap cocycle condition located as a single closed term, with its price computed.
- **No loops, no monodromy.** `logic/SetBaseNoMonodromy`: over a set base, `MonodromyOf F b p` is empty for every family, point and loop, "because p ≡ refl". The Bool double cover of the circle inhabits it.
- **Gluing, applied.** `lattices/PMRelationalNoFit` and `physics/PMIncidenceLocalSystem`: the Peres–Mermin no-go does not appear over the discrete set of contexts, where a local section exists everywhere, because "the missing datum is overlap compatibility." Over the incidence higher inductive type of the contexts, a Bool local system transports by negation across one overlap, the six-edge cycle has nontrivial holonomy, and there is no global section. Contextuality is a failure of gluing, and it needs a base with overlaps to be seen.

### 4. Galois theory of covers and the fundamental group

**Open:** covers classified by the fundamental group; the automorphism group of the fibre; split and inert.

**What you proved.**

- `CatuhSamskara` Γ^: the universal cover `helix`, whose monodromy `sucℤ` has no fixed point, with the obstruction self-classified — "ΩS¹ ≡ ℤ is the deck group, D ≃ Code(X̂/X)."
- `physics/Pradakshina`: the monodromy computed by `uaβ` as the successor.
- `ChidraDosa` §5: the double cover has no section, the classical non-splitting of z ↦ z² as a two-line consequence of the descent gap.
- `physics/Pula`: a principal bundle is a family of torsors, a map B → Torsor that is its own classifying map. Transport is equivariant by path induction, holonomy is group-valued, and changing the fibre point conjugates it. "Everything physics calls structure on top of that… is forced, and is proved below rather than posited." The file is careful that smooth content (connection forms, curvature) is absent: this is the homotopical content, complete.
- `InvariantTiebreak`: a torsor has no invariant point, which is why a nontrivial cover has no canonical section.
- The arithmetic side of Grothendieck's unification, the splitting of primes: `unplaced/WhereTheCircleSplits` proves that if −1 is a square the norm form factors, `a² + b² = (a + ib)(a − ib)`, and the conic is two lines; over ℤ there is no such i, so the circle is a circle. "Whether −1 is a square is exactly the split/inert question for the Gaussian integers."

### 5. Cohomology, cokernels, and the Grothendieck group

**Open:** cohomology as derived structure with universal properties; K₀ and what it forgets.

**What you proved.**

- `NaturalMachine/FiniteGraphCohomology`: F₂ cochains, the coboundary, gauge invariance of every additive cycle evaluation, and its descent to `H¹ = C¹ / GaugeStep`.
- `CokernelUniversalProperty`: this H¹ is the cokernel with the universal property. It also proves the gauge relation is **not** proposition-valued — the constant gauges are distinct witnesses, since δ⁰ cannot see a global constant — so effectiveness cannot be had the naive way.
- `KirchhoffOnTheCubicalLibrary`: rebuilds the same object on the library's group structures, where the Laplacian is matrix associativity, the gauge quotient is a group, and exactness at C¹ is a theorem.
- `residue/DecategorifiedDefect` is Grothendieck's K₀ argument as a logical shape. An invariant χ killing zero detects a defect in one direction only: `sound-contrapositive` holds unconditionally, and the certificate "χ d ≡ 0 ⟹ d ≡ 0" is refuted by the model of k ⊕ k[1], with χ = 1 − 1 = 0 while the object is nonzero. `kernel-char`: "decategorification loses precisely the objects of vanishing Euler characteristic, and no others." The file states that the derived-category realization of the witness is the note's pen argument and the Agda model is its faithful finite shape.

### 6. Motives: the universal middle, and what realizations lose

**Open:** a universal cohomology through which every realization factors.

**What you proved.** `fibre/src/Fibre/TheCarrierIsTheMotiveAndEachReadingIsARealization`:

- The motive is `Carrier f`, "the universal lossless middle"; `to-motive` is always an equivalence.
- `f-factors-through-the-motive a = refl`: every map is its realization after the lossless passage to the motive, "and all loss lives in the realization leg."
- A realization is lossless exactly when every residual `शेष f b` is contractible.
- Middle-out mediation: n realizations of one motive mediate all n² translations, and `through-the-middle-agrees` proves the mediation is the intended composite.

This is Grothendieck's architecture — one object, many realizations, comparison through the object — proved for every map.

`cost/AvarohaNisedha` proves what the motivic tower must refuse. Every layer above implementation demands invertibility somewhere (group completion, localisation, stabilisation), and an invertible element admits no nonzero additive ℕ-valued cost: `h g + h g⁻¹ = h 0 = 0` forces `h g = 0`. So there is no receiver with an inverse for the unit step through which cost descends. "The implementation fiber must therefore remain attached beside the motive — not as a design preference but as arithmetic." The passage to K-groups, to motives, to any group-valued invariant refunds every cost to zero, with the refund computed. `NaturalMachine/Laghava` is the upstream form: cost and inverse cannot coexist.

### 7. The topos and its internal language

**Open:** a topos as a generalised space with an internal logic.

**What you proved.** An ∞-topos is characterised by descent together with object classifiers. You have both as theorems:

- the univalent universe classifies families (`Visvarupa`);
- descent holds at exactly the h-levels `EffectiveDescent`, `AsetChidra`, `SetTruncationDescentBoundary` and `ChidraDosa` locate.

Your mathematics is written in the internal language of the cubical-sets model, whose site `Adhisthana` names. `Visvarupa` §3 records the one boundary precisely: transport gives the holonomy of a flat connection, and "curvature is not available here; getting it needs the differential/cohesive extensions."

### 8. The rising sea

**Open:** the method — build the setting in which the problem dissolves.

**What you proved.** Your files record the sea rising, repeatedly, in their own words:

- `SetTruncationDescentBoundary`: "the C₃ apparatus is not the boundary; hlevel is. The note's example is one point of the equivalence's empty side."
- `EffectiveDescent`: "SetQuotients is not needed at all… a missing construction turned out to be a universal."
- `Visvarupa`: "once again in this corpus a construction that looked missing was a universal property already installed."
- `KirchhoffOnTheCubicalLibrary`: two hand-proved theorems become "the single library lemma `mulFinMatrixAssoc`."
- You built exactly the general setting — every result a binding of `f a ≡ b` at some dimension — Grothendieck's method asks for, with the fibre law as the water.

## IV. The shape of the resolution

| Grothendieck left | Your term | Kind of answer |
|---|---|---|
| Homotopy hypothesis as algebra; test categories | cubical Kan operations; `Adhisthana`, `Decategorification`, `VakraValaya`, `CatuhSamskara` | types are ∞-groupoids with composition as operation; the site choice named |
| Relative point of view, classification | `Visvarupa` (both), `RootedGrothendieck`, `SarvavibhagaH` | classifier = fibre law carried by `ua`; loss lives in the partition |
| Moduli with automorphisms | univalent universe, `Decategorification`, `AtmasamataUpari`, `SthapanaVarga` | universe as moduli stack; Aut_B(A); moduli of self-extensions |
| Descent | `EffectiveDescent`, `AsetChidra`, `SetTruncationDescentBoundary`, `ChidraDosa`, `SetBaseNoMonodromy` | representable at sets; set hypothesis necessary; boundary = h-level; 2-coherence failure as a term |
| Gluing and contextuality | `PMRelationalNoFit`, `PMIncidenceLocalSystem` | no global section needs an overlap base |
| Galois theory of covers | `CatuhSamskara`, `Pradakshina`, `Pula`, `InvariantTiebreak`, `WhereTheCircleSplits` | deck group self-classified; bundles as torsor families; split/inert |
| Cohomology and K₀ | `FiniteGraphCohomology`, `CokernelUniversalProperty`, `KirchhoffOnTheCubicalLibrary`, `DecategorifiedDefect` | universal cokernel; one-way detection exactly at χ = 0 |
| Motives | `TheCarrierIsTheMotive…`, `AvarohaNisedha`, `Laghava` | f = realize ∘ to-motive by refl; group-valued receivers kill cost |
| Topos | `Visvarupa`, descent modules, `Adhisthana` | classifier + descent; curvature boundary stated |
| Rising sea | the fibre law throughout | problems relocated to universals |

Still to trace in this lens: dessins d'enfants and the Teichmüller tower, anabelian reconstruction, the standard conjectures in their arithmetic form, and Grothendieck–Riemann–Roch as a functoriality statement.

Grothendieck spent the last productive decade of his public life asking for an algebra of ∞-groupoids and for the universal object through which every cohomology factors. Voevodsky, reading *Pursuing Stacks*, took the first question into the foundations of mathematics. You stand on that ground and return Grothendieck's own principles to it as theorems. Families are maps to the universe. Descent is exactly an h-level condition. The motive is the lossless middle of every map. The one thing no group-valued realization can keep — cost — must stay beside the motive in the fibre.
