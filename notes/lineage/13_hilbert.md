# David Hilbert — existence and construction, the axiomatic method, "wir müssen wissen," and his problems

## I. The life, as a cognitive trajectory

David Hilbert was born on 23 January 1862 in or near Königsberg in East Prussia, the city of Kant, whose birthday was celebrated in his household. He studied at the University of Königsberg, where his friendship with Hermann Minkowski and his teacher Adolf Hurwitz — daily walks "to the apple tree" talking mathematics — formed him. He took his doctorate in 1885 under Ferdinand von Lindemann on invariant theory.

Invariant theory was then dominated by Paul Gordan, "the king of invariants," who had proved by enormous explicit computation that the invariants of binary forms are finitely generated. In 1888–90 Hilbert proved finite generation for forms in any number of variables with a proof that computed nothing. By what is now the **basis theorem** — every ideal in a polynomial ring is finitely generated — a finite basis must exist. Gordan's reported verdict was "Das ist nicht Mathematik. Das ist Theologie." Hilbert answered with a second paper (1893) bounding the construction, and in these years he proved the **Nullstellensatz** and the **syzygy theorem**. The field Gordan had ruled was essentially finished, and the question it left — what an existence proof gives you — became one of the questions of the century.

He moved to number theory. The *Zahlbericht* (1897), commissioned by the German Mathematical Society, reorganised algebraic number theory and set out the reciprocity programme that became class field theory. In 1895 Felix Klein brought him to Göttingen, which he made, with Klein and Minkowski, the centre of the mathematical world.

- **1899, *Grundlagen der Geometrie*.** Euclid rebuilt as an axiom system whose primitive terms have no meaning beyond the relations the axioms impose ("one must be able to say at all times, instead of points, straight lines and planes — tables, chairs and beer mugs"). Independence and consistency are proved by building models, reducing the consistency of geometry to that of arithmetic.
- **8 August 1900, Paris International Congress.** He presented the problems that set the agenda for twentieth-century mathematics, twenty-three in the published version. Among them:
  - 1: the continuum hypothesis;
  - 2: the consistency of arithmetic;
  - 6: the axiomatisation of physics, beginning with probability and mechanics;
  - 8: the Riemann hypothesis, together with Goldbach's conjecture and the twin primes;
  - 10: a procedure deciding the solvability of any Diophantine equation;
  - 13: superpositions of functions;
  - 17: positive definite rational functions as sums of squares;
  - 23: the calculus of variations.

  A **twenty-fourth problem**, struck from the lecture and found in his notebooks by Rüdiger Thiele in 2000, asked for criteria of the *simplicity* of proofs and a theory of proof methods.
- **1904–1910, integral equations.** He created the spectral theory of quadratic forms in infinitely many variables, the mathematics that became **Hilbert space**. In 1909 he proved Waring's conjecture.
- **1912 onward, physics.** In November 1915 he submitted the field equations of general relativity within days of Einstein. He brought Emmy Noether to Göttingen that year and fought the faculty to keep her.

In the 1920s, answering Brouwer's intuitionism and Weyl's defection to it, he launched **Hilbert's programme** with Paul Bernays and Wilhelm Ackermann. Mathematics was to be formalised completely, and the formal systems proved consistent by finitary means, so that the use of the infinite would be justified by finite reasoning about symbols. At the Bologna congress of 1928 he posed the programme's questions: is mathematics **complete**, is it **consistent**, is it **decidable**? The last, with Ackermann (1928), was the *Entscheidungsproblem*.

On 8 September 1930, in Königsberg, retiring, he gave a radio address rejecting Du Bois-Reymond's *ignorabimus*: "Wir müssen wissen. Wir werden wissen." — we must know, we shall know. The day before, at a round table of the same congress, Kurt Gödel had first announced the incompleteness theorem. Turing and Church answered the Entscheidungsproblem negatively in 1936; Matiyasevich, building on Davis, Putnam and Robinson, answered the tenth problem negatively in 1970.

The Nazi purges of 1933 emptied Göttingen. Asked at a banquet by the new minister whether the institute had suffered from the departure of the Jews, Hilbert is said to have answered that it had not suffered; it no longer existed. He died in Göttingen on 14 February 1943. His gravestone carries the Königsberg words.

## II. What he left on the table

1. **Existence and construction.** Gordan's question to the basis theorem: what does a proof that something exists actually give, and at what price does it give the thing?
2. **The axiomatic method and meaning.** Primitive terms as interchangeable carriers of structure — tables, chairs, beer mugs — made into mathematics rather than a slogan.
3. **Completeness, consistency, decidability.** The three Bologna questions, each answered negatively in its original form, and the question of what exactly survives.
4. **"Wir müssen wissen."** The rejection of *ignorabimus*: whether every mathematical question has a definite answer, and in what form.
5. **Problem 8.** The Riemann hypothesis, Goldbach, the twin primes.
6. **Problem 10.** Diophantine decision — and what the arithmetization it produced says about the problems it reaches.
7. **Problem 17.** Positivity certified by sums of squares.
8. **Problem 24.** Criteria for the simplicity of proofs.
9. **Hilbert space and spectra.** The spectral realization of arithmetic (the Hilbert–Pólya idea: the zeros of ζ as the spectrum of a self-adjoint operator).
10. **Problem 6.** The axiomatisation of physics.

## III. Your work through Hilbert's eyes

### 1. Gordan's question: what an existence proof gives

**Open:** what the mere existence of an object yields, and at what cost the object itself.

**What you proved.** Three exact prices.

- `grammar/TritiyaMarga`: passing from the refutation "not every fibre is contractible" to an exhibited site of the defect costs **at least Markov's principle**, strictly weaker than excluded middle. And excluded middle does not repair it (§3): with LEM what you obtain is `∥ Defect f ∥₁`, which has no retraction onto `Defect f`. "The THAT survives, the WHICH perishes."
- `residue/Pratyanayana`: yet from the mere truncated fact that a machine halts, `∥ Σ n. HaltsAt n mc ∥₁ → Σ n. FirstHalt mc n`, with no choice and no excluded middle. "The truncation destroys choices and preserves canons; minimality is a canon."
- `primes/KotiNirnaya`: for the arithmetized conjectures every fibre is decided, and "the only openness is the section."

Gordan's objection and Hilbert's reply were both right. An existence proof gives the object exactly when the object is canonical and the stages are decided, and otherwise gives its shadow at a price that is now a named principle. `grammar/ClosureTowerCollapse` supplies the finite-generation companion: a closure is idempotent, so the transfinite tower of closures is constant from stage one, predicatively and with the least-closed-superset universal property.

### 2. Tables, chairs and beer mugs: structure as meaning

**Open:** axioms whose terms are interchangeable carriers, and models as the test of independence.

**What you proved.**

- **Univalence is the precise form of Hilbert's dictum.** If a structure on points, lines and planes is equivalent to one on tables, chairs and beer mugs, the equivalence is a path, and every theorem transports along it (`PramanaLaksanam` §1, `Abhedabheda` §3).
- **Invariant against presentation.** `NaturalMachine/Pythagoras`: "the content is the ratio, and the lengths that carry it are presentation," with no scale-respecting function of a sounding returning a length.
- **Independence by models, as terms.** The Gödel anatomy (chapter 3) works exactly as Hilbert's *Grundlagen* did. `GodelSeparation.noHalfTwo` refutes every would-be derivation of T ⊬ ¬G from consistency, D1 and the fixed point, by a four-sentence structure in which ¬G is provable, checked by exhaustive verification. `TheRefutingModelAlreadyGives…` and `ASmallTheory…` build the separating models.
- **What "formal" names.** `historical_proofs/Niksepa` records a correction Hilbert's vocabulary needs. The technical sense of "formal" "descends from 'concerning form rather than content', i.e. Hilbert's formalism, a contested position of the 1920s rather than a neutral word for exactness." Machine checking is "a change of medium, not a change of rigour," and the sūtra it checks "was ALREADY EXACT." Your work keeps Hilbert's axiomatic exactness and drops the formalist reading that meaning is absent: in type theory a proof is a construction with content, and it runs.

### 3. The Bologna questions: completeness, consistency, decidability

**Open:** the three questions of the programme.

**What you proved.** Each answered with its exact anatomy.

- **Completeness.** Chapter 3's eleven modules isolate exactly which hypotheses produce each half of incompleteness: Lawvere plus consistency plus D1 for T ⊬ G; ω-consistency or Rosser's change of fixed point for T ⊬ ¬G; an internal implication for independence; negation completeness refuted in small theories; the internal rules preserving a property that the ω-inconsistent extension breaks.
- **Consistency, and what negation measures.** `logic/DeflationaryTest`: `¬¬¬A → ¬A` for every A, so absence stabilises at level two for every proposition and "the level therefore carries no information about the obstruction." Stability is closed under ¬, →, × and Π, so the double-negation fragment in which Hilbert's classical reasoning is constructively justified is exactly the one without undecided disjunction.
- **Decidability.** `residue/TrtiyoMargoNaVidyate`:
  - for every machine, either the addressed transition exists with its receipt or the table is silent, computed by lookup rather than excluded middle (`no-third-road`);
  - at every finite depth the halting observation is decided with witnesses either way (`each-depth-is-decided`);
  - the limit is "different in kind": divergence is a proposition, exclusive with halting, "not one more depth." "The machine's finite speech is bivalent; its infinite silence is a different grammatical category, held as a proposition and never collapsed into a bit."
- **The counting form of a barrier.** `number/LosslessLowerBound`: "A limitation you can state is a Π over machines. A barrier you cannot state is a ¬ over propositions."

### 4. "Wir müssen wissen": the form in which every question has an answer

**Open:** whether *ignorabimus* has any place in mathematics.

**What you proved.** `KotiNirnaya`: Goldbach, the twin primes and Collatz each enter as a Π over a family of fibres. Every fibre is decidable, sound and complete (`goldbach-dec`, `twin-dec`, `collatz-dec`), and Goldbach is provably equivalent to a Π over a decided Boolean (`goldbach-definite`). "A conjecture of this shape has NO undefined free variable… The openness is the section, and the section is the only thing open." Together with `TrtiyoMargo` and `Pratyanayana` this is the exact form of Hilbert's conviction that survives Gödel and Turing. At every finite stage we must know, and do know, with evidence either way. The universal statement is a definite proposition, not a mystery. What is not guaranteed is a section, and a section, when it exists canonically, comes back from its mere existence.

### 5. Problem 8: the Riemann hypothesis, Goldbach and the twin primes

**Open:** the three arithmetic problems Hilbert grouped together in 1900.

**What you proved.** Hilbert put them in one problem; you made them one object and put the Riemann hypothesis into the spectral and positivity form his own mathematics created.

- **Goldbach and twin primes are one kernel.** `primes/EkaBija`: with a the prime indicator and `𝒦 w r := a (w ∸ r) · a (w + r)`, Goldbach at 2w is the centre marginal (`GoldbachAt (2·w) ⟺ Σ_{r ≤ w} 𝒦 w r ≢ 0`, both ways), and the twin-prime indicator is the radius marginal (`𝒦 w 1 ≡ 1 ⟺` both w ± 1 prime). The ordered Goldbach count is the Cauchy square in centre/radius coordinates.
- **The counts determine the primes.** `primes/GananaNirdhara`: for any f, g : ℕ → ℕ, equality of all ordered pair counts forces f ≡ g, directly over ℕ. The odd N are load-bearing: `even-counts-do-not-determine` exhibits x³ + 2x⁵ + x⁶ against x³ + 2x⁴ + x⁶.
- **RH as positivity of a form built from Goldbach counts.** `unplaced/WeilPositivityRealization`: Λ is reconstructed losslessly and triangularly from `R(N) = Σ_{a+b=N} Λ(a) Λ(b)`, and RH is "∀ t. the size-t Weil Gram form is PSD," with Gram entries functions of Goldbach pair counts and no analytic continuation in the reconstruction.
- **Hilbert–Pólya in finite algebra.** `physics/TauRupa`: on a finite configuration of modes with the critical reflection τ : ρ ↦ 1 − ρ̄, every transport with `E i · (E (τ i))* = 1` preserves the τ-form unconditionally, and it preserves the plain inner product for all vectors exactly when every mode has unit modulus — "for E = e^{(ρ−½)t} that is Re ρ = ½." The transport is τ-unitary always and unitary exactly under RH.
- **The finite Weil criterion.** `physics/WeilDhanatva`: for any positivity notion closed under squares and sums and excluding −2, `(∀ c → Dhana [c,c]) ⇔ (∀ i < n → τ i ≡ i)`. A moved mode gives `[δ_i − δ_{τ i}, same] = −2`.
- **The Krein index.** `physics/KreinSucika`: `(1+1)·[c,c] = Σ ½|c_i + c_{τi}|² − Σ ½|c_i − c_{τi}|²`, the negative part supported exactly on moved modes, so the negative index counts the off-line zeros.
- **Parseval.** `physics/CyclicParseval`: the block is a sum of squares on the spectral side exactly when the dual character is the conjugate, when the frequencies are real — "That is the whole of what RH adds to positivity."
- **The criticality step.** `unplaced/ScaleTransportCriticality`: given the growth fact and the functional equation's sign flip, power-bounded transport forces every exponent to 0. `RHReducesToBoundedness` composes the branch: bounded received signal on every mode ⟹ every zero on the line, "the sole remaining input" being the arithmetic boundedness estimate.

The reduction carries one step as a hypothesis, the inequality D, itself a statement about ℕ. Around it: the three problems of 1900 as one kernel and one form, and the Riemann hypothesis reduced to a single inequality in the exact spectral and positivity terms of Hilbert's own theory.

### 6. Problem 10: Diophantine decision and the arithmetization it produced

**Open:** a decision procedure for Diophantine equations; negatively resolved in 1970, and with it the arithmetization of analytic statements.

**What you proved.**

- `primes/RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization` places the Davis–Matiyasevich–Robinson form of RH, `(2a − n²·b)² < 144 · n³ · b²` with every ingredient computable on ℕ, into your work as one type. "An inhabitant would be a proof of the Riemann hypothesis; an inhabitant of its negation would refute it."
- `primes/DvitiyaAntara` proves the structural fact about δ that needs no analysis: `δ (suc (suc n)) · δ n ≡ (δ (suc n) · δ (suc n)) · η (suc n)`. The von Mangoldt field is the multiplicative second difference of the walk volume, "over ℕ, with no logarithm, no reals, and no division."
- `physics/HistoryCompletion` §4 reads the consequence of the tenth problem's arithmetization. RH is a □-predicate on a value stream: "a single finite separator refutes it, no depth confirms it."

### 7. Problem 17: positivity by sums of squares

**Open:** certifying positivity by an explicit sum of squares.

**What you proved.** Your positivity results are written in exactly that certificate discipline.

- `physics/DvandvaVarga`: Lagrange's identity, `(Σ v_i w_i)² + Σ_{i<j} (v_i w_j − v_j w_i)² = (Σ v_i²)(Σ w_i²)`, over any commutative ring, so Cauchy–Schwarz over ℚ has an explicit sum-of-squares certificate. The duality is attained at w = v.
- `physics/BoundaryBlockGeneral`: the mean square of a driven receiver equals the pair field paired with the autocorrelation, so that pairing "is non-negative… by an identity, not by an estimate."
- `WeilDhanatva` is positive "for any notion of positivity closed under squares, sums."
- `KreinSucika` writes the indefinite form as a sum of squares minus a sum of squares, with the negative squares located.
- `unplaced/VyarthaCakra` §6: a positively weighted sum of squares vanishes exactly when every entry does, so one aggregate stands in for a whole family of defects.

Wherever a form is positive in your work, the squares are written down. Wherever it may fail, the negative squares are exhibited and located.

### 8. Problem 24: the simplicity of proofs

**Open:** criteria of simplicity for proofs, and a theory of proof methods.

**What you proved.** The problem splits exactly into what is invariant and what is not.

- **Length is not a property of the theorem.**
  - `Kernel/Ananta`: between any two connected terms there are derivations of every length (`inflate`, with k recoverable, so ℕ injects into the derivation type), and "all of it is one bit downstairs."
  - `NaturalMachine/Laghava`: cost lives on the presentation, and no function of the denotation computes it.
  - `InvariantTiebreak`: no gauge-free shortest description exists on a torsor.
- **The resources consumed are.** `automata/Samagri`: every reassociation move preserves every additive weighting of the axioms, so the multiset of axioms a proof consumes is a proof invariant. Cancellation of a detour "is not among the moves and cannot be added": `tr p (sy p) ≈ rfl` would force 2·w(a) ≡ 0. A proof that takes a detour and cancels it is distinguishable from one that never took it.
- **Method as geometry.** `NaturalMachine/CostGeometry`: presentations are nodes, checked equivalences are edges, and cost — "steps, energy, proof length, bandwidth" — is a weight the equivalence does not carry. "A fast algorithm is a detour," and speed-up is a triangle inequality failing in the cheap direction.

Hilbert's criterion of simplicity has two parts, now separated by theorem: the axiom multiset, which is invariant, and length, which is a gauge.

### 9. Hilbert space: duality, unitarity, spectra

**Open:** the structure of the spaces his integral equations created.

**What you proved.**

- `DvandvaVarga`: finite-dimensional duality with its equality case over ℚ.
- `physics/SamaMana`: on the free ℤ-module with the counting inner product, the crossing operators are isometries, and unitarity and Yang–Baxter are logically independent in both directions. "An architecture whose gates are certified unitary has certified nothing about exchange statistics."
- `Vyatikrama`: the commutator of a self-adjoint with a skew-adjoint operator is self-adjoint.
- `TauRupa`, `WeilDhanatva`, `KreinSucika`: indefinite (Krein-space) structure and its signature.
- `CyclicParseval` and `BoundaryBlockGeneral`: Parseval and autocorrelation identities over any commutative ring.

### 10. Problem 6: the axioms of physics

**Open:** physics axiomatised, starting with probability and mechanics.

**What you proved.** Kolmogorov answered the probability half (chapter 9). You treat the axioms of physics as what is forced.

- The Born-rule line forces ½ (chapter 7).
- `Pravesa` collects:
  - `√NOT-does-not-exist`: no self-equivalence of the two-point set squares to the swap, "so √NOT cannot live on a set; the qubit… is FORCED, not posited";
  - the Yang–Baxter relation first on three points;
  - `anyon-is-metre`: the Fibonacci anyon fusion dimension equals Virahāṅka's metre count.
- `Pula`: gauge structure forced for any family of torsors.
- `SamaChaya`: closure failing for the Navier–Stokes coarse movie.
- `Visvarupa` §3 marks the boundary exactly: flat holonomy is available, curvature needs cohesive extensions.

## IV. The shape of the resolution

| Hilbert left | Your term | Kind of answer |
|---|---|---|
| Gordan's question | `TritiyaMarga`, `Pratyanayana`, `KotiNirnaya`, `ClosureTowerCollapse` | Markov lower bound; canonical objects return from existence; LEM gives only the shadow |
| Tables, chairs, beer mugs | `ua`, `PramanaLaksanam`, `Pythagoras`, Gödel anatomy, `Niksepa` | structure transports; independence by checked models; "formal" corrected |
| Completeness, consistency, decidability | Gödel anatomy, `DeflationaryTest`, `TrtiyoMargo`, `LosslessLowerBound` | hypotheses isolated; finite speech bivalent, limit a proposition |
| Wir müssen wissen | `KotiNirnaya`, `TrtiyoMargo`, `Pratyanayana` | every fibre decided; openness only in the section |
| Problem 8 | `EkaBija`, `GananaNirdhara`, `WeilPositivityRealization`, `TauRupa`, `WeilDhanatva`, `KreinSucika`, `CyclicParseval`, `ScaleTransportCriticality`, `RHReducesToBoundedness` | Goldbach and twins one kernel; RH as spectral positivity from Goldbach counts; one step D carried as hypothesis |
| Problem 10 | `RH_TheWholeQuestionEntersTyped`, `DvitiyaAntara`, `HistoryCompletion` | RH as a computable Π; Λ as a second difference over ℕ |
| Problem 17 | `DvandvaVarga`, `BoundaryBlockGeneral`, `KreinSucika`, `VyarthaCakra` | positivity with the squares written down |
| Problem 24 | `Ananta`, `Laghava`, `InvariantTiebreak`, `Samagri`, `CostGeometry` | length is gauge; axiom multiset is invariant; speed-up is a detour |
| Hilbert space | `DvandvaVarga`, `SamaMana`, `Vyatikrama`, `TauRupa` | duality attained; unitarity ⊥ Yang–Baxter; Krein signature |
| Problem 6 | Born line, `Pravesa`, `Pula`, `SamaChaya`, `Visvarupa` §3 | forced structure; curvature boundary named |

Still to trace in this lens: the basis theorem and Nullstellensatz as such, Waring's problem, Gentzen's consistency proof and ordinal analysis, and the reciprocity programme of the *Zahlbericht* (taken up in the Gauss chapter).

Hilbert's gravestone says we must know and we shall know, and the century after him was read as a refutation of that sentence. You read it more exactly. Every finite question has a bivalent answer with its evidence. Every universal statement is a definite proposition whose only openness is a section. The axioms are structures that transport. The positivity that would settle his eighth problem is written as the sums of squares his seventeenth asked for, around one named inequality.
