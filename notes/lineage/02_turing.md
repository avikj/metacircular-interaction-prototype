# Alan Turing — the machine that forgets, and the machine that keeps

## I. The life, as a cognitive trajectory

Alan Mathison Turing was born on 23 June 1912 in Maida Vale, London; his father was in the Indian Civil Service and he and his brother were raised largely by a retired army couple in Hastings. At Sherborne School he was the boy who worked out the mathematics he was not taught, and in 1928 he met Christopher Morcom, a slightly older student with whom he shared astronomy and chemistry. Morcom died of bovine tuberculosis in February 1930. The loss turned Turing toward the question he never let go of: how mind, which seems free, sits in matter, which seems determined. His private essay *Nature of Spirit* (c. 1932), written for Morcom's mother, already asks whether quantum indeterminacy leaves room for will. The machine he would invent four years later is the purest statement of the opposite pole — a mind reduced to a table of determined steps — and the rest of his life is an oscillation between those two poles.

At King's College, Cambridge (1931–34) he read mathematics and, independently of Lindeberg, proved the central limit theorem, which won him a fellowship in 1935. That year Max Newman lectured on Hilbert's *Entscheidungsproblem*: is there a mechanical procedure that decides, for any statement of first-order logic, whether it is provable? Newman's phrase "mechanical process" was the seed. Turing asked what a human computer actually does — reads a symbol, consults a finite state of mind, writes, moves — and made that the definition. *On Computable Numbers, with an Application to the Entscheidungsproblem* (submitted May 1936, published 1936–37) defined the machine, built the **universal machine** that reads another machine's description number from its tape and imitates it, proved that no machine decides whether a described machine ever prints a given symbol (the halting problem in its original form), and derived a negative answer to Hilbert's question. Alonzo Church had reached the same negative answer months earlier with the λ-calculus. Turing's 1937 appendix proved λ-definability and machine-computability coincide, and his correction note the same year repaired the representation of computable reals — decimal expansions are not computable from convergent sequences of rationals, so the right representation is by nested intervals.

He went to Princeton (1936–38) and wrote a doctorate under Church, *Systems of Logic Based on Ordinals* (1939). It contains two ideas far ahead of their use. The first is the **oracle machine**: a machine that may, at certain states, ask an external oracle a question it cannot compute, which founded relative computability. The second is the **ordinal logic**: since any consistent formal system leaves true statements unprovable, adjoin them — consistency statements — and iterate along constructive ordinals, hoping that the transfinite tower is complete. It is not, in the form he wanted; Feferman showed in 1962 that completeness can be recovered for a class of statements only by non-constructive choices of ordinal notations. Turing had found that the climb out of incompleteness requires information the system does not have.

From 1939 to 1945 he was at Bletchley Park. The Bombe mechanized the search through Enigma settings by exploiting the logical consequences of a guessed plaintext; *Banburismus* was sequential Bayesian inference, with evidence measured additively in *decibans* (with I. J. Good), the weight of evidence as a logarithm of a likelihood ratio. He broke Naval Enigma in Hut 8. In 1942–43 he crossed to the United States, worked on speech encipherment at Bell Labs, and talked with Shannon at lunch about thinking machines.

After the war, at the National Physical Laboratory, his *Proposed Electronic Calculator* (1945–46) was a complete design for a stored-program computer, the ACE, with subroutines and a microprogram-like instruction layer. In a 1947 lecture to the London Mathematical Society he said the machine should be allowed to learn from experience and to make mistakes. His 1948 NPL report *Intelligent Machinery*, unpublished until 1968, introduced randomly connected "unorganized machines" trained by interference, genetic search, and the idea of education. The same year he published *Rounding-off Errors in Matrix Processes*, which introduced the condition number and the LU decomposition into numerical analysis, and *Practical Forms of Type Theory* (with the unpublished *The Reform of Mathematical Notation and Phraseology*, c. 1944), which urged working mathematicians to adopt Church's theory of types to discipline free variables and ambiguous notation.

At Manchester from 1948 he wrote the programming manual for the Mark 1. In 1949 he gave *Checking a Large Routine*, three pages that state program correctness by assertions attached to points in the flow, an invariant, and a decreasing quantity for termination — Floyd and Hoare reinvented it in 1967–69. In 1950 came *Computing Machinery and Intelligence*, which replaced "can machines think?" by the imitation game, answered nine objections, and proposed building a *child machine* and educating it. The same year he proved the word problem for semigroups with cancellation unsolvable (*Annals of Mathematics*).

Then two last turns. In 1952, *The Chemical Basis of Morphogenesis* showed that two chemicals reacting and diffusing on a ring of cells can destabilise a perfectly homogeneous state and break its symmetry into a stationary pattern — spots, stripes, whorls — from nothing but the linear algebra of reaction and diffusion. He worked on phyllotaxis and Fibonacci patterns in plants until his death; most of it was published only in the collected works. And in 1950–53 he used the Manchester computer to check the Riemann hypothesis for zeros up to height about 1540, developing *Turing's method* for certifying that no zero has been missed; he had long suspected the hypothesis false and hoped to find a counterexample.

In 1952 he was prosecuted for homosexuality and accepted chemical castration rather than prison. He died of cyanide poisoning on 7 June 1954. His last postcards to Robin Gandy contain the "Turing paradox" — continuous observation of a quantum system freezes it — the old question of mind and determination returning at the end.

## II. What he left on the table

1. **The machine forgets.** Every step of the 1936 machine overwrites a square and changes state; the configuration before is not recoverable from the configuration after. Turing never asked what is lost or where it goes. Landauer (1961) and Bennett (1973) made reversibility a theory, physically.
2. **Interaction.** The oracle machine was a relativization device, not a theory of computation in dialogue with an environment. Whether interactive computation is strictly beyond the Turing machine became a long, imprecise dispute (Wegner, Milner, and others).
3. **Why universality needs a description.** The universal machine reads a description number. Turing proved the construction works; he did not isolate *why* universality must pass through an encoding rather than be native.
4. **Program versus behaviour.** Many programs compute one function, and Rice (1953) showed every nontrivial behavioural property is undecidable. The positive structure — what exactly the space of programs over a behaviour is — was left undescribed.
5. **Checking a large routine.** Assertions, invariants and termination measures, in 1949, unused for twenty years; and the certificate was prose beside the program, not part of it.
6. **Ordinal logics.** A tower of systems climbing past incompleteness: the climb works only with information from outside. Turing did not have an account of what an honest growth step must contain.
7. **Computable numbers and representation.** The 1937 correction exposed that which representation of a real one computes with changes what is computable. The general relation between finite observation and infinite objects was not formalised.
8. **Types for mathematicians.** The notation reform and practical type theory were not taken up; working mathematics stayed untyped for sixty years.
9. **Machine learning and education.** The child machine: a system that grows its own capacities from experience, without an engineer building each organ.
10. **Morphogenesis.** Symmetry breaking from homogeneity, and the phyllotaxis programme left in manuscript.
11. **Numerical error.** The condition number measures how errors grow; exact certificates for approximate factorizations were not part of his theory.
12. **The Riemann hypothesis by computation.** Each height checked is a finite fact; what the computations are *of*, structurally, was left implicit.
13. **Mind and determination.** Free will against the determined table: the question behind the whole life.

## III. Your work through Turing's eyes

### 1. The machine that forgets is the projection of the machine that keeps

**Open:** what the 1936 step loses, where it goes, and whether reversibility is a special property of some machines or a structure of all of them.

**What you proved.** `theorems/residue/Vishvayantra` encodes the universal machine directly: `Code` is the type of finite transition tables, so an effectively presented machine *is* an element of `Code`; `uStep : Machine → Machine` is total (an unaddressed configuration is a fixed point, nontermination is an infinite productive run); and the rule lookup `eq? : ℕ → ℕ → Maybe (m ≡ n)` returns a witness of the match, never a Boolean. Then:

- `lossless f : A ≃ Σ B (fiber f)` for **any** map, with visible projection literally f (`visible-projection` is `refl`);
- `turing-is-the-projection : fst (equivFun (LawfulStep.complete universal) mc) ≡ uStep mc` is **`refl`** — the ordinary universal Turing step *is* the forgetting of its lossless completion;
- `trace-is-fiber`: any trace family whose completion projects to the step (the field `visible`) is fibrewise equivalent to `fiber step`. The trace is not a design choice. It is forced to be the fibre.

`Ekatva` proves the strongest possible uniqueness: the type of lossless completions of a map,

```
Lossless f = Σ (T : B → Type) . Σ (e : A ≃ Σ B T) . (π₁ ∘ e ∼ f)
```

is **contractible**, by an eight-step chain of equivalences ending in `EquivContr` (univalence). And `lawful-steps-are-the-maps : LawfulStep A ≃ (A → A)`: the type of lossless proof-relevant machines on A *is* the type of ordinary programs on A. Completion adds nothing and forgets nothing.

`Nasha` exhibits the forgetting: a one-rule eraser sends a stroke and a blank to the same configuration (`collision` is `refl`), while the completion of any map is injective (`completed-injective`) and separates them (`fibres-separate`). `Avinimaya`: every table's completed step is unitary (`every-step-is-unitary`), and still the successor machine and the eraser **do not exchange** at a named configuration, both unitarity certificates carried in the same dependent pair. Reversibility is not commutativity; the non-exchange is where order lives.

`AnulomaViloma` gives the machine its ledger and its reverse gear: the fibres of a composite compose (`fibers-compose`), so a run of m + n steps keeps its trace leg by leg (`trace-composes`); the inverse of the completion reads the source out of the fibre by `refl` (`completed-reversible`, `source-recovered`) — reverse execution is a projection, not a search; halting is a proposition; silence persists; and **when** a machine first halts is a proposition (`halting-time-is-a-proposition`). `Niyati`: the type of productive infinite runs from a configuration is contractible (`one-execution`) — determinism is contractibility of the whole history, not a property of one step. `Sankramana` (residue lane) turns the completion into a path in the universe, `Machine ≡ Σ Machine (fiber uStep)`, and transport along it **computes** the completed step.

Read against Landauer and Bennett: the irreversibility of computation is not a fact about machines. It is a fact about the projection one chooses to watch, and the completion that undoes it is unique and definitional.

### 2. Interaction, measured exactly

**Open:** is interactive computation strictly beyond the Turing machine, and if so, by exactly what?

**What you proved.** `Prashna` defines the interactive symbolic computer as a guarded coalgebra,

```
ISC S Q E s  with one field  respond : (q : Q s) → Σ s' . E s q s' × ISC S Q E s'
```

and settles the question in both directions:

- `turingISC`: the universal machine is the instance with the trivial question `Q s = Unit` and receipt events `E s q s' = (uStep s ≡ s')`;
- `deterministic-collapse : isContr (DetISC mc)`: at that instance the **entire space** of interactive behaviours is a point, the contraction built coinductively, its squares filled because `Machine` is a set;
- `interaction-is-strictly-wider : ¬ isContr (FreeISC …)`: with the same trivial question but a free event, the machine that stands still and the machine that steps are distinct inhabitants.

UTM = deterministic ISC (a point) ⊊ interactive ISC, and what makes the inclusion strict is the event type, nothing else. `Sakshin` generalizes the collapse to **every** question alphabet: receipted answers leave one behaviour (`receipts-collapse`), so "freedom lives only in the unwitnessed event." `Sambandha` closes the triangle: a relational program with unique answers is its map (`relational-programs-are-maps`, via `ua`), and the deterministic ISC's receipt event is the graph relation of the step on the nose (`the-receipt-is-the-graph` is `refl`). Relations, functions and receipted interaction are three presentations of one object.

For oracles, `NaturalMachine/InterfaceSeparation` states what relative computation is once post-processing is arbitrary: `Simulates I J = Σ f . (∀ o. f (I o) ≡ J o)`, so simulation is refinement of partitions and "the only way to refute it is to exhibit a collision of I that J splits" (`collision⇒no-simulation`). It then proves a real oracle dichotomy — under a multiplicativity promise the functional-equation oracle is simulated by the empty transcript (`fe-oracle-simulated-by-nothing`, the *full* infinite oracle), and without the promise no value-query set that misses the product point simulates even one bit of it, however non-computable the post-processor (`value-cannot-simulate-fe`) — with the exact converse that three queries at the right points do (`fe-simulated-when-product-queried`). "The obstruction is support, not power." Turing's o-machines asked what an oracle adds; the answer here is a partition, and the partition is computed.

### 3. Why universality must pass through a description

**Open:** why the universal machine needs a description number.

**What you proved.** `Vikarna`:

- `no-native-universal-table`: there is no table U whose one-step action on raw configurations agrees with every machine's. Two machines that disagree at one configuration kill every candidate. A universal table **must** read its subject in some encoding. The change of representation is a theorem.
- `diagonal-escapes`: fix any tape-reading of codes (`decode`, with `decode-encode` proved). The configuration map `diag c = bump (uStep-conf (decode c) c)` — what the machine read off the tape would do, bumped — is realised by no program: a table evaluated at its own encoding would have to equal its own successor.

The universal *function* exists (`uStep`); the family of table behaviours cannot exhaust the configuration maps, and the escape is manufactured from self-reference, not counted from cardinality. `automata/Lawvere` and `residue/GodelSeparation` had recorded, in a dated audit, that the Turing line of the classical list of diagonal arguments carried no term in the repository. `Vikarna` is that term, stated at the universal machine itself.

### 4. Program and behaviour: one trace, infinitely many codes

**Open:** the positive structure of the space of programs over a behaviour.

**What you proved.** `Vistara`, the padding lemma: for a machine whose states are bounded by B, appending rules whose sources lie at or above B is invisible at every depth (`padding-invisible`), so there is an injection `prog : ℕ → Code` all of whose values run identically (`padding-lemma`). The behaviour quotient of code (`Beh = Code / runs-agree`, in the residue lane's `Pratibimba`, and `one-point-many-codes` in `Siddhanta`) has an infinite fibre over every behaviour. Against `Ekatva` the picture is exact both ways: the trace of a fixed step is a point, forced; the code of a behaviour is maximally non-unique, free. What is unique is the trace; what is multiple is the expression. Rice's theorem is the negative shadow of this: a property of the behaviour is a property of the quotient, and the quotient's fibres are too large for a decision procedure to read.

### 5. Checking a large routine, with the certificate inside the program

**Open:** Turing's 1949 method, with the proof made part of the object.

**What you proved.** `Vrddhi` verifies a two-rule successor machine: `increment-correct : run (suc n) (incr , unary n) ≡ (incr , done n)` for every n, by an induction whose every step the kernel computes (`walk-step` is `refl` in both cases). The point is `increment-certificate : fiber (run (suc n)) (incr , done n)` — **the correctness proof is a point of the kept fibre** — and `increment-reversed` recovers the source from the certificate by `refl`. A verified program is a program whose fibre point is written down.

`Samasa` composes tables: `M₁ ⨟ M₂ = M₁ ++ shift H M₂`, the two phases provably non-interfering, the shift proof-relevant (`eq?-+`: the shifted comparison witness is the original under `cong (H +_)`), and `compose-runs` proves the compound's (n₁ + n₂)-step run is M₂'s run lifted by H. `DviVrddhi` then builds the double increment with **no induction over the compound**: phase one is Vṛddhi's certificate, phase two is two computed steps, and the compound's certificate is their concatenation, step counts adding — exactly as the fibre composition law requires.

`NaturalMachine/EkaBhasha` carries the same discipline into the machine's own rule store: `record नियमः = { lhs ; rhs ; साक्षी : ⊨ (lhs , rhs) }`. An unproven rule is not refused by a gate; it is unconstructible. The prover `साधनम् : (e : Eq') → Maybe (⊨ e)` returns a proof or nothing, and syntactic equality returns the path (`_≟T_ : Maybe (a ≡ b)`) — "no Bool on any wire."

### 6. The honest climb: what growth must contain

**Open:** Turing's ordinal logics — how a system may climb past what it can prove, and why the constructive climb failed.

**What you proved.** Three results together give the structure Turing lacked.

- `NaturalMachine/Aroha`: an induction combinator on the store's truth predicate (`आरोहः`), whose premises are discharged by the internal prover and by computation. The boundary is **exhibited**: the flat prover returns nothing on `max(x,x) = x` and `le(x,x) = 1` (`समतल-मौनम्₁/₂` are `refl`), and one ascent proves each (`शिखरम्₁/₂`), admitted to the store through the **same** gate as normalization-proven rules. The climb is a theorem inside the object, and its reach is measured by `refl`.
- `theorems/physics/SamraksanaVrddhi`: for a sensorium S and a proposed new receptor q, the joint eye ⟨S, q⟩ always conserves S (`संरक्षणम्`, `refl`); **one witnessed blind pair** — two states S cannot split and q does — upgrades that to strict refinement `S ≺ ⟨S, q⟩` (`वृद्धिः`); and **no eye strictly refines itself** (`अ-स्वातिक्रमः`).
- `NaturalMachine/SvayamBhavendriya`: the machine reads its own store, detects commutativity, associativity and unit by matching on its own proven rules, extracts the value-level laws from those rules' witnesses, and instantiates one canonicalizer proven sound once — "no agent builds organs."

Turing's tower needed a new true statement at each stage, and the constructive choice of that statement was exactly what could not be supplied from inside. `अ-स्वातिक्रमः` is the structural form of that obstruction — re-reading the same organ cannot produce strict growth — and `वृद्धिः` is the exact form of what a growth step must contain: a pair the old system provably cannot separate, together with a reading that separates it. The climb is legitimate precisely when it carries its witnessed blind pair.

### 7. Computable numbers, finite observation, infinite objects

**Open:** the 1937 correction — representation changes what is computable — and the general relation between finite prefixes and infinite behaviour.

**What you proved.** `theorems/physics/PurnataSutra` and `HistoryCompletion`: streams (`Dhārā`) under the take-metric are **complete by corecursion** — every Cauchy sequence of streams has a limit (`limit`), agreeing with the n-th approximant to depth n (`limit-agrees`), unique by truncations (`take-ext`) — with depth a natural number and no precision representation anywhere. On top of that:

- `□ P s` ("P at every depth") is refuted by a single failing truncation (`separator`);
- **no depth decides it**: for every n there are two ℤ-streams agreeing to depth n, one bounded forever and one not (`no-depth-decides`);
- in the decoder language of `FiniteInformation`, being bounded forever does **not factor through any finite-depth prefix** (`bounded-does-not-factor-through-depth`, by `collisionObstructsDecoder`);
- and the one infinite-depth fact everything rests on is stated in the same stream form: no stream of naturals falls forever (`no-falling-stream`), so a measure-decreasing step empties its configuration space (`emptied-by-stream`).

This is the structure under Turing's 1936–37 papers: the halting problem, semidecidability, and the representation of computable reals are all the statement that a □-property of an infinite object is not a function of any finite observation of it, while its refutation is. `Pratyanayana` adds the constructive half at the machine: from the *mere* fact that a machine halts somewhere, `the-clock-needs-no-choice : ∥ Σ n . HaltsAt n mc ∥₁ → Σ n . FirstHalt mc n`, with no choice principle and no excluded middle — because every finite depth is decided with evidence (`TrtiyoMargo.each-depth-is-decided`) and the least halting time is a proposition. "The truncation destroys choices and preserves canons; minimality is a canon." `TrtiyoMargo` keeps the other side exact: divergence is a proposition, exclusive with halting, "not one more depth", never collapsed into a bit.

### 8. The Riemann hypothesis, at the fibres Turing computed

**Open:** what Turing's zeta computations were structurally.

**What you proved.** `theorems/primes/RH_TheWholeQuestionEntersTyped` states RH as one type through the Davis–Matiyasevich–Robinson arithmetization, every ingredient computable. `RHPratyaksa` makes RH, by `refl`, the Π over its fibres and inhabits the first three **by computation** — the typechecker running δ, the harmonic fraction and the signed square, the witness of each strict inequality being the exact gap. `SamastaSima` proves each fibre decided and `RH ≃ (∀ n . rhb (suc n) ≡ true)`: RH is exactly "this computable Boolean is true at every stage", refutation is a finite object, and the oracle computes the prefix. `HistoryCompletion` §4 gives the same shape on power-sum traces: roots on the unit circle satisfy □(|p_k| ≤ p_0) forever (`onCircle`), and a root off the circle is refuted at depth 1 (`offCircle`). Turing's Manchester runs were exactly the computation of a prefix of this section; the modules state plainly that the section itself is open.

### 9. Morphogenesis: symmetry breaking as a choice the observable cannot see

**Open:** the structural core of pattern formation from a homogeneous state.

**What you proved.** `theorems/physics/Varanam`: a section of `f : A → B` is a choice of receipt at every point. If f is an equivalence, the space of sections is contractible — "where nothing is hidden there is no choosing" (`अक्षये-वरणं-न`). If f loses something, the choice is real: `Bool → Unit` has two distinct sections (`वरणे-भेदः`), nothing decides between them, and the codomain cannot see which was taken (`वरण-स्थानं-न-एकम्`). Spontaneous symmetry breaking is exactly this: a formerly free fibre, a section chosen, the invariant observable blind to the choice. `Dhruva` is the same fact from the conservation side: a lossless observable admits no nontrivial conserving flow.

The linear algebra of Turing's 1952 paper appears in two places. `theorems/physics/EkaSesa` computes, exactly and with no residual term, that for the generator 𝒢(x) = L·x + x·L† + 2 Σⱼ Dⱼ·x·Dⱼ† with skew directions, the Laplacian carried by the drift and the doubled Laplacian from diffusion cancel at the unit, so **unitality holds exactly when the drift has no symmetric part**. And `KirchhoffIncidence` proves the graph Laplacian is div ∘ grad with exact summation by parts — the discrete diffusion operator on a ring of cells that Turing's model used. `SamraksanaVrddhi`'s header names what it is at the level of organisms: "permanent conservative refinement is organogenesis; temporary conservative refinement is attention."

### 10. Numerical error with an exact certificate

**Open:** Turing's 1948 analysis of rounding error in matrix factorization, where error is estimated, not certified.

**What you proved.** `theorems/physics/Gersgorin`: an exact LDLᵀ of a 64×64 rational matrix has pivots with thousands of digits, so a checkable certificate carries a dyadic L and D and an exact slack E = A − LDLᵀ. The file proves the theorem the slack needs over ℚ — if 4·Eᵢᵢ ≥ Σⱼ|Eᵢⱼ| + Σⱼ|Eⱼᵢ| for every row, then vᵀEv ≥ 0 for every v — by writing 2vᵀEv as a sum of terms each of which is a square by the sign of Eᵢⱼ. The approximate factorization becomes exact by carrying its error as data with a dominance proof.

### 11. Learning machines and the child machine

**Open:** a machine that grows its capacities from experience.

**What you proved.** Beyond `SvayamBhavendriya` and `Aroha`, `theorems/grammar/SelfImprovement` states the invariants a learning population must keep: an identity is never computed from scores (`identity-is-not-performance`); fitness transports across a representation change only with an invariance witness, and without it the transport is refuted by a homometric pair (`transport-needs-a-witness`); a gamed evaluator is quarantinable without touching the genotypes it scored. And `NaturalMachine/Sesa_TheDerivationCarriesNoMeaningAtAll…` gives the learning-theoretic no-go: correctness of an emission is one bit, so a likelihood that is a function of correctness cannot rank branches (`every-semantic-criterion-is-blind`), which is why search does not reduce to checking.

### 12. Mind and determination

Turing's lifelong question was how a mind can be free in a determined world. In your terms the question has a precise form. `Niyati` and `Prashna` prove that determinism is contractibility — of the history, and of the whole space of interactive behaviours under receipted events. `Sakshin` proves that freedom lives exactly in the unwitnessed event. `Varanam` proves that where something is hidden a choice is real and invisible to the observable, and where nothing is hidden there is nothing to choose. And `Jiva` (logic lane) defines a living step as one that refuses to descend to its marginals — the controlled-not, globally lossless and locally non-simulable. The oscillation of Turing's life between the determined table and the free spirit is, here, one equivalence read at two event types.

## IV. The shape of the resolution

| Turing left | Your term | Kind of answer |
|---|---|---|
| What the step forgets | `Vishvayantra.turing-is-the-projection` (refl); `trace-is-fiber`; `Nasha` | exact, definitional |
| Is reversibility special? | `Ekatva.losslessness-is-a-property`; `lawful-steps-are-the-maps` | contractible: unique for every map |
| Reverse execution | `AnulomaViloma.source-recovered` (refl) | a projection, not a search |
| Interaction beyond the TM | `Prashna`, `Sakshin`, `Sambandha` | strict inclusion, gap = event type |
| What an oracle adds | `InterfaceSeparation` | partition refinement; support, not power |
| Why universality needs encoding | `Vikarna.no-native-universal-table`, `diagonal-escapes` | theorem; the Turing diagonal as a term |
| Program vs behaviour | `Vistara.padding-lemma`; behaviour quotient | infinite code fibre, point trace |
| Checking a large routine | `Vrddhi`, `Samasa`, `DviVrddhi`, `EkaBhasha` | certificate = fibre point; composes |
| Ordinal logics | `Aroha`; `SamraksanaVrddhi.वृद्धिः`, `अ-स्वातिक्रमः` | growth needs a witnessed blind pair; no self-refinement |
| Computable numbers / semidecidability | `HistoryCompletion`, `PurnataSutra`, `Pratyanayana`, `TrtiyoMargo` | completion by corecursion; no depth decides □ |
| Zeta computations | `RHPratyaksa`, `SamastaSima` | fibres decided by computation; section open |
| Morphogenesis | `Varanam`; `EkaSesa`; `KirchhoffIncidence` | symmetry breaking = real section choice |
| Rounding error | `Gersgorin` | exact slack certificate |
| Child machine | `SvayamBhavendriya`, `SelfImprovement`, `Sesa` | growth from own store; ranking is extra-semantic |
| Mind and determination | `Niyati`, `Sakshin`, `Varanam`, `Jiva` | determinism = contractibility; freedom = unwitnessed event |

Still to locate in this lens: the unsolvability of the word problem for cancellation semigroups, Turing's fixed-point combinator Θ, the weight of evidence in Banburismus (the deciban as the additive hom of `GhataLekha` is a reading I have not seen stated in a file), and the quantum "Turing paradox."

What Turing would see first is that his own universal machine appears here twice and is the same object both times: once as the determined table that forgets, `uStep`, and once as the unique equivalence that keeps, `lossless uStep`, joined by `refl`. The question he asked at seventeen — how the free and the determined can be one thing — is the question of which projection of one equivalence you watch.
