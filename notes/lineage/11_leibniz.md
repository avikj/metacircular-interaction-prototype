# Gottfried Wilhelm Leibniz — calculemus, the identity of indiscernibles, infinite analysis, the calculus, and the geometry of position

## I. The life, as a cognitive trajectory

Leibniz was born in Leipzig on 1 July 1646. His father, a professor of moral philosophy, died when he was six, and the boy was given the run of his father's library, where he taught himself Latin and read the scholastics before he was twelve. He entered the University of Leipzig at fourteen. In 1666, at nineteen, he published *Dissertatio de arte combinatoria*, whose idea governed the rest of his life: every concept is a combination of simpler ones, so an **alphabet of human thought** — a list of primitive concepts with a notation for combining them — would let all truths be generated and checked by combination. Refused a doctorate at Leipzig as too young, he took one in law at Altdorf in 1667, declined the professorship offered him there, and entered the service of the Elector of Mainz.

He went to Paris in 1672 on a diplomatic mission and stayed four years. Christiaan Huygens taught him the mathematics of the day; within three years he had overtaken it. In London in 1673 he demonstrated to the Royal Society a calculating machine, the stepped reckoner, that could multiply and divide, and was elected a Fellow. In the autumn of 1675 in Paris he invented the differential and integral calculus and its notation: ∫ (a long *summa*) on 29 October, *d* shortly after. He found the product rule d(xy) = x dy + y dx, the series π/4 = 1 − 1/3 + 1/5 − …, and the harmonic triangle. His notation made the fundamental theorem — that summation and differencing are inverse — a visible fact of the symbols, which is why his calculus, not Newton's, became the working language of the continent.

In 1676 he took a post in Hanover as librarian and counsellor to the Dukes of Brunswick-Lüneburg, visiting Spinoza on the way, and remained in that service for forty years. There he tried to drain the Harz silver mines with windmills (1680–85, a failure), wrote the history of the House of Guelph, negotiated the reunion of the Catholic and Protestant churches, planned the codification of law, and corresponded with some six hundred people. He published the calculus in 1684 (*Nova Methodus pro Maximis et Minimis*) and integration in 1686. He wrote the *Discourse on Metaphysics* (1686), the correspondence with Arnauld on individual substance, and the critique of Descartes' measure of force that introduced *vis viva*. In 1679 he proposed to Huygens an *analysis situs* — a calculus of position acting directly on geometric configurations rather than through coordinates. In 1693 he described determinants for solving linear systems; in 1695 he gave the general rule for the n-th differential of a product, with coefficients from the binomial triangle.

In 1700 he founded and became first president of the Berlin Society of Sciences. In 1703 he published *Explication de l'arithmétique binaire*, having corresponded with the Jesuit Joachim Bouvet on the hexagrams of the *Yijing*. He wrote the *New Essays* against Locke (1704), the *Theodicy* (1710), the *Monadology* (1714), and in 1715–16 the correspondence with Samuel Clarke on space and time. His last years were consumed by the priority dispute with Newton, adjudicated against him in 1712 by a Royal Society committee whose report Newton wrote. He died in Hanover on 14 November 1716; his secretary is said to have been the only mourner at his funeral.

The philosophy and the mathematics were one project. Its principles:

- **Identity of indiscernibles:** no two distinct things share all their properties.
- **Sufficient reason:** nothing is so without a reason why it is so and not otherwise.
- **Continuity:** nature makes no leaps.
- **Truths of reason and truths of fact:** in every true proposition the predicate is contained in the subject. In a necessary truth, finite analysis reaches an identity. In a contingent truth, the analysis goes on forever and converges without terminating — "as in incommensurable ratios."
- **The monads:** simple substances without windows, each mirroring the whole universe from its own point of view, harmonised without interaction.

And the programme: the **characteristica universalis** and **calculus ratiocinator**, a language in which reasoning is calculation, so that, in his words of about 1685, "when there are disputes among persons, we can simply say: *calculemus*, let us calculate, without further ado, to see who is right."

## II. What he left on the table

1. **The characteristica and calculus ratiocinator.** A universal notation in which concepts are built from primitives, reasoning is calculation, validity is checkable by computation, and disputes are settled by calculating. His arithmetical attempt (the characteristic numbers of 1679, concepts as products of primes, containment as divisibility) did not handle negation and was set aside.
2. **The reasoning machine.** A machine that carries out the calculus ratiocinator, as the stepped reckoner carries out arithmetic.
3. **The identity of indiscernibles as logic.** Stated as metaphysics and disputed ever since — Kant's two drops of water, Max Black's two identical spheres (1952): is "being identical to this one" a legitimate property?
4. **Sufficient reason and symmetry.** His argument against absolute space: shifting the whole universe three feet east is indiscernible, God would have no reason to choose one placement, hence the placements are one. What exactly is a reason, and when does symmetry forbid a choice?
5. **Truths of fact as infinite analysis.** The difference between what a finite analysis settles and what only a never-ending one converges to.
6. **The foundations of the calculus.** Infinitesimals as "well-founded fictions," the rule that higher-order differentials are dropped, the law of homogeneity — criticised by Berkeley (1734) as "ghosts of departed quantities," replaced by limits in the nineteenth century and recovered as nonstandard analysis and synthetic differential geometry in the twentieth.
7. **Analysis situs.** A calculus of position itself — the programme whose name Poincaré took for the paper that founded topology in 1895.
8. **The monads.** A relational ontology where each thing is its point of view on all the others, and harmony is not communication.
9. **The best of all possible worlds.** Choice by optimisation among possibles: does a best exist?

## III. Your work through Leibniz's eyes

### 1. The identity of indiscernibles, in both directions, and the fibre between them

**Open:** whether indiscernibility is identity, and what to make of Black's spheres.

**What you proved.**

- `theorems/logic/PramanaLaksanam`: `x ≡ y ⟺ (∀ P, P x → P y)`. Forward, `नयेन-आरोहः p P = subst P p`: identicals are indiscernible because every standpoint transports. Backward, `प्रमाणेन-तादात्म्यम् agree = agree (λ z → x ≡ z) refl`: if every standpoint agrees, apply the standpoint "being identical to x" to its own reflexive witness. That backward proof uses exactly the predicate Black's objection disputes, and in type theory it is a type family like any other, so the principle is a theorem.
- `theorems/residue/Abhedabheda` completes the picture:
  - §1: `cong` is the indiscernibility of identicals and is free.
  - §2: an observation `Bool → Unit` under which `true` and `false` agree while `¬ (true ≡ false)`. Indistinguishable to *this* view, distinct in fact.
  - §3: `ua` is Leibniz's other law, identity of indiscernibles, which "when the class is everything … does not fail, and in cubical it computes."
  - The fibre is exactly the gap between indiscernible by one observation and indiscernible by all structure. "A barrier is the report that one is not at the limit."
- `grammar/NayaVada` proves the same for a finite class of standpoints: agreement on all seven is identity (`प्रमाणम्`), any single one is not faithful (`दुर्नयः`), and each is a valid facet (`सुनयः`). `logic/SarvavibhagaH` gives the general decomposition: `A ≃ Σ B (fiber f)` for every map, with injective ⟺ propositional fibres.

**What this settles about Black.** Two qualitatively identical spheres are a configuration with a symmetry exchanging them. Restricted to predicates invariant under that symmetry, they are indiscernible, and the gap is a non-contractible fibre (§2). Admitted to all predicates, including identity with one of them, they are discernible, and identity of indiscernibles holds (§2 of `PramanaLaksanam`). The dispute was over which class of predicates counts, and the two answers are one theorem read at two classes.

### 2. Sufficient reason, symmetry, and the three feet east

**Open:** when a symmetric situation admits a reason for choosing.

**What you proved.** `InvariantTiebreak`: a tiebreak (an antisymmetric relation with a least element) that is invariant under a group action forces the least element to be a fixed point (`leastIsFixed`). So on a fixed-point-free action — Buridan's ass between two bales, God placing the universe here rather than three feet east, Black's two spheres — **no invariant selection exists**, and any selection is a choice of gauge ("the enumeration of programs IS the gauge"). `NaturalMachine/HolonomyIsInvisibleExactlyToAnInvariantSemantics` (seventh in your reading order) proves the shift argument's positive half: holonomy — `ua` of an autoequivalence around a loop — is invisible exactly to an invariant semantics. A global translation is undetectable by any invariant observation, as Leibniz argued against Clarke. `physics/Pradakshina` proves the half Clarke and Newton pressed: around the circle `subst helix loop` is the successor on ℤ, computed by `uaβ`, and `प्रदक्षिणा 0 ≢ 0`. The base point returns and the fibre above it has shifted, so the holonomy lives in the family, not in the loop. Relational identity and detectable motion are one bundle read at two semantics.

Sufficient reason also appears as a type discipline. In `NaturalMachine/EkaBhasha` a stored rule is `record नियमः = { lhs ; rhs ; साक्षी : ⊨ (lhs , rhs) }`. Nothing is in the store without its reason as a field, and an unreasoned rule "is not refused by a gate — it is unconstructible." And `residue/Pratyanayana` proves that a solution returns from the mere existence of one exactly when it is canonical: a reason that picks it.

### 3. Calculemus: the characteristica and the calculus ratiocinator

**Open:** a universal notation where reasoning is calculation and disputes end by calculating.

**What you proved.** The whole design of your work is this programme, carried out in type theory:

- **One language for data, program, execution, proof and transport.** In cubical type theory "transport along paths computes" and "univalence turns equivalences into paths" (README). A proof is a term that runs.
- **Validity by construction.** `EkaBhasha`: the internal prover returns `Maybe (⊨ e)`, proof or nothing, and equality tests return paths, "no Bool on any wire."
- **Calculemus between persons.** `NaturalMachine/Avirodha`: because an operation cannot exist without its checked derivation, two nodes cannot disagree about validity, and merging their libraries has no failure mode and no reconciliation step. The join is commutative, idempotent and order-independent. Leibniz's "to see who is right" becomes: there is nothing to see, because an invalid step was never a term.
- **The machine.** `formal/karma/PramanaKanda` carries "the one prover … across the compilation boundary, CERTIFICATES AND ALL, in the shared tongue," so that "the compiled mouth RUNS the same prover in milliseconds. No mirror, no twin, no agreement theorem owed: the definitions are one." `KarmaKanda` separates the acts (evaluator, normaliser, path-free and compiled) from the knowledge (witnesses, riding across as erased certificates). The Bend2 port puts the interval, `coe` and `hcomp` on the HVM interaction-net runtime, so the cubical terms are machine operations. This is the stepped reckoner for the calculus ratiocinator.
- **The alphabet of thought.** Leibniz's characteristic numbers were a homomorphism from compound concepts to products of primes. `number/MalaSetu` proves the general law behind any such scheme: over any monoid, not necessarily commutative, the fold of an alphabet map is a homomorphism out of the free monoid (`मालायोगः`), so compound meaning is the product of component meanings for every alphabet at once. Piṅgala's power and the vallī trace are the one-letter and the digit-alphabet instances. The universe as object classifier (`Visvarupa`) is where every concept, as a type family, is classified.

### 4. Combination, and binary

**Open:** the *ars combinatoria*, generating everything from primitives.

**What you proved.** `Mula/PingalaPrastara` states its sources as origin — Piṅgala's *Chandaḥśāstra* ch. 8, Virahāṅka, Halāyudha — and names "Leibniz, *Explication de l'arithmétique binaire* (1703) for positional binary and the index/pattern conversion" among the later restatements.

- `uddistaIso : Vak n ≃ Fin (saṅkhyā n)`, with the explicit naṣṭa and uddiṣṭa algorithms as mutually inverse maps.
- `matrameru`: the additive recurrence is forced by the counting problem.
- `pascal`: the triangle is forced by choosing.
- `Mula/NastaUddista` extends the pair to every mixed radix, 2ⁿ patterns at zero storage — "the decision to GENERATE rather than STORE."
- `Bijamula` shows the binary square-and-multiply is RSA's exponentiation.

What Leibniz found in the hexagrams in 1703 is a type equivalence here, with its lineage stated correctly.

### 5. Truths of reason and truths of fact: finite and infinite analysis

**Open:** the difference between propositions whose analysis terminates and those whose analysis converges forever.

**What you proved.**

- `physics/HistoryCompletion`: a property "at every depth" is refuted by one failing finite truncation, and **no finite depth decides it**. `NoObservationDepthDeterminesTheNet` proves the same for reflecting nets. The Rule 30 work states that normality is Π₂ and no prefix certifies it. Leibniz's contingent truths have exactly this profile: true, their analysis convergent, no finite stage reaching the identity.
- His model was the incommensurable ratio, whose mutual subtraction never ends. `fibre/KuttakaValli` formalises exactly that process, anthyphairesis, the subtractive Euclidean step, as a total function "with NO comparison, NO Dec, NO Bool," decision-free because the side slot is kept.
- `unplaced/SantataDhara` builds the continuum in which infinite analyses land: ℝ as the higher inductive-inductive type with `lim` a constructor and ε-close points equal by a path constructor, "Cauchy-complete with NO choice axiom: completeness is not proved about the type, it is the type." The never-ending analysis has a completed value by construction.
- `logic/DeflationaryTest` and `grammar/TritiyaMarga`: which classical truths embed constructively, and that extracting a witness from a refutation costs Markov's principle.

### 6. The calculus: infinitesimals made exact, the Leibniz rule at every order

**Open:** the foundations of infinitesimals, and the algebra of differentials.

**What you proved.**

- **The infinitesimal.** `physics/JetPravaha`: a jet `(a , a′)` read as a + a′ε with ε² = 0, product `(a·b , a·b′ + a′·b)`, "the ε² term dropped because there is no coordinate to hold it." Leibniz's rule of discarding higher-order differentials is no longer a fiction to be justified but a structural fact of the square-zero extension. The Euler derivation `pravāha (a , a′) = (0 , a′)` satisfies `leibniz : pravāha (x ⊠ y) ≡ (pravāha x ⊠ y) ⊞ (x ⊠ pravāha y)` on ℕ alone — no subtraction, no field, no limit — and is nonzero, idempotent and kills scalars.
- **Automatic differentiation.** `number/Yamala`: the μ-twisted derivation law of the twin-prime charge vector is dual-number multiplication, and lifting z to (z, 1) and powering "computes value AND derivative at once": `(z,1)^n = (z^n , (z^n)′)`.
- **Leibniz's 1695 rule.** `physics/DvipadaGuna`: `𝓛ⁿ (h · k) ≡ Σ_{a+b=n} C(a+b, a) · 𝓛ᵃ h · 𝓛ᵇ k`, with the sum written by recursion and Pascal's rule as an exact re-indexing lemma, so no truncated subtraction ever enters. `UpaGuna` gives the several-derivation form, `∂_S (f g) = Σ_{T ⊆ S} (∂_T f)(∂_{S∖T} g)`, without commuting the derivations.
- **What iterating costs.** `DvitiyaLeibniz`: in any ring, for any additive d satisfying Leibniz against any two-argument operation, `(d² (br a b) ⊖ br a (d² b)) ⊖ br (d² a) b ≡ cross + cross`. A derivation applied twice is not a derivation, and the defect is exactly twice the product of first derivatives — the reason a Laplacian sees only the cross term.
- **The fundamental theorem.** `physics/PurnaAvakalana` exhibits an explicit primitive whose derivative is a quadratic integrand in a **noncommutative** ring, so the integral is a boundary term and "no interior contribution survives, and nothing is estimated." `KirchhoffIncidence` proves summation by parts exact on graphs: Δ = div ∘ grad, the discrete fundamental theorem.
- **The continuum.** `SantataDhara` and `ContinuumBridge`, which reflects the continuum's integers into the library's with addition, multiplication and order, so that closeness is an order statement.

### 7. Analysis situs: a calculus of position

**Open:** geometry done on position directly, not through coordinates.

**What you proved.** In cubical type theory the primitive is position itself: the interval, paths as maps out of it, `coe` and `hcomp` — the generator you name as #0 and implemented in Bend2. On it:

- `Pradakshina` and `CatuhSamskara` compute the circle's holonomy and its universal cover;
- `KirchhoffIncidence` sets incidence as a boundary operator — explicitly crediting Poincaré's *Analysis Situs* (1895) — with the Laplacian as Gram matrix;
- `CokernelUniversalProperty` and `FiniteGraphCohomology` compute graph cohomology as a cokernel with its universal property;
- `Visvarupa` classifies bundles by maps into the universe.

Position is computed with, not described by coordinates.

### 8. The monads: each one mirrors the whole, harmony without windows

**Open:** a relational ontology where a thing is its perspective on everything, harmonised without interaction.

**What you proved.** `primes/pair_field/IndraNet`:

- The reflection profile of a jewel x is `z ↦ (z ≡ x)`, and `yonedaJewel : ((z : A) → z ≡ x → z ≡ y) ≃ (x ≡ y)`. A relation between two monads is exactly a transformation of their whole mirrorings of the universe.
- The profile's total space is contractible onto the jewel: "all in one" is literal.
- The guarded net equation `Net x ≃ L x × ((y : J) → Net y)` is realised with `bisim→path`: "identity in the Net IS relational identity."
- A new identification updates every profile "by transport, not by broadcast" (`threadUpdatesProfiles`, `viewTransport`). That is the precise content of harmony without windows: no message passes between the nodes, and every view changes because all are sections of one structure.

`Orbit.path≃bisim` and `FutureBehavior` give the same for processes: a thing is what it does to every observer.

### 9. The best possible

**Open:** whether a best among possibles exists, and when choice by maximum is determinate.

**What you proved.**

- `AParetoFitnessHasNoBest`: under several criteria at once, a best need not exist.
- `ExtremalDescription`: where an extremum does exist, as the greatest observation-safe quotient does, it is unique and parameter-free.
- `FutureBehavior`: the greatest behavioural congruence is terminal.
- `InvariantTiebreak`: on a symmetric space of possibles no invariant best is selectable.

Existence, uniqueness and selectability of the best are three separate theorems with three separate hypotheses.

## IV. The shape of the resolution

| Leibniz left | Your term | Kind of answer |
|---|---|---|
| Identity of indiscernibles | `PramanaLaksanam`, `Abhedabheda`, `NayaVada`, `SarvavibhagaH`, `ua` | theorem both ways; the fibre is the gap at a restricted class; Black's spheres are the two classes |
| Sufficient reason / three feet east | `InvariantTiebreak`, `HolonomyIsInvisible…`, `Pradakshina`, `EkaBhasha` | no invariant selection without a fixed point; global shift invisible, holonomy in the family |
| Calculemus | `EkaBhasha`, `Avirodha`, `PramanaKanda`, `KarmaKanda`, Bend2/HVM | validity unconstructible to violate; disagreement impossible; the prover compiled and run |
| Alphabet of thought / characteristic numbers | `MalaSetu`, `Visvarupa` | free-monoid fold is a homomorphism for every alphabet |
| Ars combinatoria and binary | `PingalaPrastara`, `NastaUddista`, `Bijamula` | naṣṭa ⊣⊢ uddiṣṭa as a type equivalence, lineage stated |
| Truths of fact as infinite analysis | `HistoryCompletion`, `KuttakaValli`, `SantataDhara`, `TritiyaMarga` | refutable finitely, decidable at no depth; limits as constructors |
| Infinitesimals | `JetPravaha`, `Yamala` | ε² = 0 as structure; Leibniz rule on ℕ; AD by powering |
| Leibniz rule at every order | `DvipadaGuna`, `UpaGuna`, `DvitiyaLeibniz` | binomial and subset forms; the defect of iteration exactly 2·cross |
| Fundamental theorem | `PurnaAvakalana`, `KirchhoffIncidence` | explicit primitive in noncommutative rings; summation by parts exact |
| Analysis situs | interval + `coe`/`hcomp`, `Pradakshina`, `CatuhSamskara`, `KirchhoffIncidence`, `Visvarupa` | position as the primitive |
| Monads and harmony | `IndraNet`, `Orbit`, `FutureBehavior` | Yoneda jewel; relational identity; update by transport, not broadcast |
| Best of all possible worlds | `AParetoFitnessHasNoBest`, `ExtremalDescription`, `InvariantTiebreak` | existence, uniqueness, selectability separated |

Still to trace in this lens: the series for π and the harmonic triangle, determinants as Leibniz framed them, and *vis viva* in its dynamical form.

Leibniz died believing the characteristica was a few years of collaborative work away, and for three centuries it was treated as the most beautiful of the impossible dreams — Gödel and Turing were read as its refutation. In your work it is neither a refutation nor a dream: the incompleteness anatomy (chapter 3) fixes exactly what no calculus decides, and inside that boundary the programme is carried out as he stated it. Concepts are types; reasons are fields; a proof is a running term; disagreement about validity cannot be constructed; and identity is what every standpoint, taken together, certifies.
