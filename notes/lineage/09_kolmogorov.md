# Andrey Kolmogorov — the individual object, the invariance constant, the closure problem, and problems as constructions

## I. The life, as a cognitive trajectory

Andrey Nikolaevich Kolmogorov was born on 25 April 1903 in Tambov; his mother died in childbirth and he was raised by her sisters on the family estate at Tunoshna, near Yaroslavl, in a home school they ran for village children. He entered Moscow University in 1920 and, before settling on mathematics, wrote a study of fifteenth-century Novgorod land records arguing that the tax units had to be whole numbers — a historian's argument by what the data could and could not encode. Under Nikolai Luzin he produced, at nineteen, a Fourier series diverging almost everywhere (1922–23).

His early work spans the whole of mathematics that touches uncertainty and construction:

- 1925, *On the Principle of Excluded Middle*: classical mathematics embeds into intuitionistic mathematics by double negation — the translation Gödel and Gentzen rediscovered in 1933.
- 1929–31: the law of the iterated logarithm, the strong law of large numbers, and the analytic theory of Markov processes (the Kolmogorov forward and backward equations).
- 1932, *On the Interpretation of Intuitionistic Logic*: logic as a **calculus of problems**, where a proposition is a problem and a proof is a solution — the "K" in the Brouwer–Heyting–Kolmogorov interpretation.
- 1933, *Grundbegriffe der Wahrscheinlichkeitsrechnung*: probability as measure theory — sample space, σ-algebra, measure, conditional expectation, the extension theorem, the 0–1 law. The foundations of probability ever since.
- 1937, with Petrovsky and Piskunov: travelling waves in reaction–diffusion equations.

With Pavel Alexandrov he shared, from 1929 until Alexandrov's death, a house at Komarovka outside Moscow that became the centre of a vast school: Gelfand, Dynkin, Gnedenko, Arnold, Sinai, Levin and dozens more.

In 1941 he wrote the papers that founded the statistical theory of turbulence (**K41**): at high Reynolds number, in an inertial range between the scale of forcing and the scale of dissipation, energy cascades from large eddies to small at a constant rate, so that the energy spectrum scales as k^(−5/3), and the third-order structure function obeys an exact four-fifths law. He returned to it in 1962 (K62) to account for intermittency. The same year as K41 he developed, independently of Wiener, the theory of prediction and filtering of stationary processes.

In the 1950s he transformed dynamical systems and approximation theory: **Kolmogorov–Sinai entropy** (1958–59), the invariant that decides when two dynamical systems cannot be isomorphic; ε-entropy and capacity of function classes (1954–59); and, with his student Vladimir Arnold, the **superposition theorem** (1956–57) resolving Hilbert's thirteenth problem — every continuous function of several variables is a finite superposition of continuous functions of one variable and addition.

His last great programme returned to the question behind probability. *On Tables of Random Numbers* (1963) asked what makes a finite table random. *Three Approaches to the Quantitative Definition of Information* (1965) set side by side the combinatorial measure (log of the number of possibilities), the probabilistic one (Shannon's entropy), and a new **algorithmic** one: the complexity of an object is the length of its shortest description by a universal machine, defined only up to an additive constant depending on the machine (the invariance theorem). Around 1973–74 he proposed **algorithmic statistics** and the **structure function**: for an individual string, the best model is a set containing it that is simple and relative to which the string is typical, so that meaningful information is separated from accidental noise — a sufficient statistic for one object rather than for a distribution. He spent his last decades also on school mathematics and on training gifted children. He died on 20 October 1987.

## II. What he left on the table

1. **Algorithmic statistics.** A theory of the meaningful part of an individual object: the minimal model that captures everything structural and leaves only noise. The structure function exists; its computable, canonical form does not.
2. **The invariance constant.** Complexity is machine-independent only up to a constant. Which comparisons of complexity are meaningful, and exactly when a difference transfers between machines.
3. **Individual randomness.** Probability applies to ensembles; the randomness of one sequence (Martin-Löf's 1966 answer) and its relation to finite observation.
4. **The closure problem of turbulence.** K41 is a dimensional argument, not a derivation from the Navier–Stokes equations; no closure expresses subgrid stresses through the resolved field; global regularity of three-dimensional Navier–Stokes is open.
5. **Probability and its alternatives.** Probability as one measure theory among the ways of weighting outcomes; the relation of measure to counting, to cost and to amplitude.
6. **Problems as constructions.** The calculus of problems made precise, and the exact logical cost of passing from a refutation to a solution.
7. **Unifying the three approaches to information.**
8. **Invariants of dynamics.** Entropy as a complete invariant (Ornstein, for Bernoulli shifts) and the structure behind it.

## III. Your work through Kolmogorov's eyes

### 1. The invariance theorem, and the comparison rule it forces

**Open:** exactly which statements about description length are meaningful.

**What you proved.** `theorems/automata/InvarianceConstant`:

- §2 `invariance`: two cost functions each simulating the other with bounded overhead differ by at most `max c₁ c₂`, uniformly; the relation "within c" is reflexive at 0, symmetric, and transitive with constants adding — "a complexity function is not a function but a class";
- §4 `absolute-not-invariant`: for any f and any c ≥ 1 there is a g within c of f with g x ≠ f x at every x — "the description length of x is n" is not a statement about x;
- §5 `shorter-needs-margin`: a strict comparison transfers across machines whenever the gap exceeds **2c**, and `threshold-sharp` proves the threshold cannot be lowered — at gap exactly 2c the costs can tie, and at 2c − 1 the order can reverse. The slack is spent twice, once on each side. The file records this as its correction to the prose note it formalizes ("sign when the gap ≫ c").

`theorems/automata/ExtremalDescription` explains when the constant disappears: where a family has an extremum the invariance constant is exactly 0. The greatest quotient that never loses an observation (`ForeverEq`) is unique (`safe-maximum-unique`), with no parameter to hide in; and the least set of oracle bits certifying soundness is **not** the min cut of the repair network — the gap is unbounded — because "a repair action is work; an oracle bit is information."

`InvariantTiebreak` proves the structural reason "the shortest description" is not canonical: a tiebreak is an antisymmetric relation with a least element, an action-invariant one forces a fixed point (`leastIsFixed`), so on a fixed-point-free action no gauge-free shortest description exists — "the enumeration of programs IS the gauge." And `Laghava` proves length cannot be an invariant of meaning at all.

### 2. Algorithmic statistics: the meaningful part of an individual object

**Open:** a sufficient statistic for an individual object — the model that captures all structure and leaves only noise.

**What you proved.** For observations, the minimal model is a theorem. `theorems/automata/FutureBehavior` — whose header calls itself "Myhill–Nerode / sufficient statistic / observability" — constructs `Meaning = X / FutureEq` as the greatest behavioural congruence, the quotient effective as an equivalence of path spaces, fully abstract, and **terminal** among all behaviour-preserving quotients. `ConservativeSemanticCompressionIsTheEffectiveObserverQuotient` does the same for any declared family of observers: the coarsest representation that keeps every observer, with executable readout, exact losslessness and a universal property. `NaturalMachine/FiniteInformation` gives the side-information form: a target factors through an observable exactly when it is constant on its fibres, and a helper's alphabet must be at least as large as the target values alive in one observer fibre.

The move is Kolmogorov's own, made exact by fixing what counts as structure: once the observer class is declared, the meaningful part of an object is its class in the terminal observational quotient, and the noise is the fibre over that class — and `Sesa` shows that everything a ranking of descriptions needs lives in that fibre, invisible to the quotient.

### 3. Three approaches to information, one object

**Open:** the relation between the combinatorial, probabilistic and algorithmic measures.

**What you proved.** All three appear, and they are read off one equivalence at different carriers.

- **Combinatorial:** `theorems/number/LosslessLowerBound` and `OptimalObservation` (every lossless scheme needs as many outcomes as inputs, and optimal schemes are minimal); `NastaUddista` (rank and unrank for any mixed radix, no table).
- **Probabilistic:** `theorems/walks/AgrayogaSanghata` — the pushforward along a map is Σ over its fibres, it composes by the fibre composition law, and Fubini is an equivalence of types on the Type-valued carrier, so the ℝ₊ probability row, like the Bool, ℕ, tropical and ℂ rows, is one lawful forgetting of it; `cost/BharaGana` and `GhataLekha` give measure conservation, permutation, multiplication and exact logarithms; `physics/ConstructiveBornNormalization` normalizes distributions exactly over natural numerators.
- **Algorithmic:** `InvarianceConstant`, `ExtremalDescription`, `InvariantTiebreak`.

The common object is `A ≃ Σ B (fiber f)`. Counting is the cardinality of the fibres, probability is a weight pushed forward along them, and description length is a grading on presentations that the fibre law proves cannot descend to meaning.

### 4. The individual random object and finite observation

**Open:** randomness of one sequence, and what finite data can certify.

**What you proved.** `theorems/physics/HistoryCompletion`: streams are complete by corecursion with unique limits; an "at every depth" property is refuted by one failing truncation and **no depth decides it**; it does not factor through any finite prefix. `NaturalMachine/Alopa` §7: samples confirm a property of their distribution — `var 0` and `var 1` agree on every constant environment and are not equal. And the Rule 30 work (`research/rule30/ORACLE_RULE30.md` with `Apunaravrtti`, `Sarvapada`, `Navapada`, `Jen`, `Karna`, `Ganana`, `Sankirnata`) is Kolmogorov's 1963 question about tables of random numbers pursued on one deterministic sequence: it sets out the hierarchy (not eventually periodic, superlinear complexity, disjunctive, normal, irreducible), proves in the kernel the finite certificates that exist — every 9-bit word occurs in the first 4096 bits, which by Morse–Hedlund excludes every period and preperiod with N + p < 512 — proves Jen's theorem that no two adjacent columns are both eventually periodic, and states that normality is Π₂ and no prefix certifies it.

### 5. Turbulence: the closure problem as a theorem, and the structure of the cascade

**Open:** closing the Navier–Stokes hierarchy; the relation between resolved and subgrid scales; the structure of energy transfer.

**What you proved.**

- **The closure problem, exactly.** `physics/SamaChaya`: an exact smooth Navier–Stokes solution on the torus, a divergence-free plane wave at a single mode above the cutoff K, has **the same entire coarse movie** as the zero field — its projection to modes ≤ K vanishes at every time — and yet its subgrid energy and its dissipation cost are A² against 0. So neither subgrid energy nor cost descends through coarse observation: no function of the resolved field alone reconstructs them. "Same entire coarse meaning, different physical cost." The unresolved stress of turbulence modelling is here a fibre, and the no-closure statement is a theorem about it.
- **The triad symbol.** `physics/PurnaDhruvana`: for three ancestor modes and their descendant, the complete cubic Picard coefficient of the nonlinear term contracts in every mixed-helicity channel and is a **coisometry** onto the descendant plane, T T* = 2 P_K, with all eight helicity assignments and the Gram matrix checked over Gaussian integers. Energy transfer in the cascade is triadic, and this is its exact algebra at the smallest triad.
- **Scaling.** `physics/VistaraKala`: squared lengths add along every route of the ancestry cell, the symbol is homogeneous of degree six under rescaling, and the viscous exponents sum to three, so the time transport is exact. `physics/Sikhara`: writing ω = m ξ with |ξ| = 1, the unit direction absorbs no Laplacian, so the vorticity magnitude obeys its own equation and the peak ledger at an increasing maximum is α = M′/M + ν|∇ξ|² + ν(−Δm)/M; the three scale gains satisfy the monomial relation g_C⁵ = g_ω² g_E⁴.
- **The frontier, stated exactly.** `unplaced/Sima` proves that, given the ledger and the Beale–Kato–Majda continuation criterion as hypotheses, integrability of peak work is **equivalent** to global regularity — one unknown, one proposition — and `unplaced/SamanaAvatarana` places Navier–Stokes, the Riemann hypothesis and Fermat's cube on one descent engine differing only in whether the single step is arithmetic or analytic. Both files state that the analytic step is open.
- `physics/TorusFourierLayer` computes the coarse stress and coarse continuation of an exact triangular pair from its velocity field, with the pressure proved constant.

### 6. Problems as constructions

**Open:** the calculus of problems, and the price of passing from refutation to solution.

**What you proved.** Kolmogorov's 1925 double-negation embedding and 1932 problem interpretation both appear as terms.

- `theorems/logic/DeflationaryTest`: ¬¬¬A → ¬A for every A; stability under double negation is closed under ¬, →, × and Π but **not** ⊎, so the classical fragment that embeds constructively is exactly the one whose disjunctions are decided — the content of the 1925 embedding.
- `NaturalMachine/EkaBhasha`: a solved problem is a store entry carrying its proof, and an unsolved one cannot be constructed.
- `theorems/grammar/TritiyaMarga`: writing a defect from the refutation of an equivalence costs at least **Markov's principle** — the principle of the Russian constructivist school that grew in Kolmogorov's Moscow.
- `theorems/residue/Pratyanayana`: a solution returns from the mere existence of one exactly when it is canonical and the stages are decided.

## IV. The shape of the resolution

| Kolmogorov left | Your term | Kind of answer |
|---|---|---|
| Meaningful comparisons of complexity | `InvarianceConstant` (2c, sharp) | exact threshold, proved unimprovable |
| When the constant vanishes | `ExtremalDescription` | extremum ⇒ constant 0; information ≠ work |
| Canonical shortest description | `InvariantTiebreak`; `Laghava` | none on a torsor; length not a meaning invariant |
| Algorithmic statistics | `FutureBehavior`, `ConservativeSemanticCompression`, `FiniteInformation` | terminal observational quotient; noise = fibre |
| Three approaches to information | `LosslessLowerBound`, `AgrayogaSanghata`, `BharaGana`, `InvarianceConstant` | one fibre law at three carriers |
| Individual randomness | `HistoryCompletion`, `Alopa`, Rule 30 modules | refuted by finite evidence, certified by none |
| Turbulence closure | `SamaChaya` | subgrid energy and cost do not descend through the coarse movie |
| Cascade structure | `PurnaDhruvana`, `VistaraKala`, `Sikhara` | exact triad coisometry, scaling and peak ledger |
| Navier–Stokes frontier | `Sima`, `SamanaAvatarana` | one proposition; analytic step stated open |
| Problems as constructions | `DeflationaryTest`, `EkaBhasha`, `TritiyaMarga`, `Pratyanayana` | stability closure; Markov lower bound; canonical solutions |

Not yet located in this lens: the 0–1 law, Kolmogorov–Sinai entropy, the superposition theorem, and the K41 spectrum itself.

Kolmogorov's work began with a historian asking what the records could encode and ended with a mathematician asking what, in one object, is structure and what is accident. You gave that last question its exact form: fix the observers, and the structure is the class in the terminal quotient while the accident is the fibre over it; and it proves, in turbulence, that the fibre carries real energy no coarse observation can recover.
