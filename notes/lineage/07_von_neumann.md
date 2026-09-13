# John von Neumann — the observer, the game, the reliable organism, and the machine that describes itself

## I. The life, as a cognitive trajectory

János Lajos Neumann was born on 28 December 1903 in Budapest, into a banking family ennobled in 1913 (hence "von"). At the Lutheran Gymnasium his teachers László Rátz and Mihály Fekete recognized a mind that could do mathematics the way others read; by eighteen he had published with Fekete. On his father's insistence he studied chemical engineering at the ETH in Zürich (diploma 1925) while simultaneously taking a doctorate in mathematics at Budapest (1926) with a thesis that axiomatized set theory — the system of sets and classes later refined by Bernays and Gödel — and, along the way, gave the definition of ordinals still in use: each ordinal is the set of its predecessors.

At Göttingen in 1926–27 he joined Hilbert's programme at its height, working on the consistency of arithmetic and on the mathematical foundations of the new quantum mechanics. As Privatdozent in Berlin (1927–29) and Hamburg he produced, in a few years, work that would each have made a career:

- 1928, *Zur Theorie der Gesellschaftsspiele*: the **minimax theorem** for two-person zero-sum games, the founding result of game theory.
- 1927–32, culminating in *Mathematische Grundlagen der Quantenmechanik* (1932): quantum states as vectors in Hilbert space and observables as self-adjoint operators, the spectral theorem for unbounded operators, the **density matrix** and **von Neumann entropy** S = −Tr ρ log ρ, and an analysis of **measurement** as two distinct processes — the continuous unitary evolution and the discontinuous "Process 1" of observation — with the cut between observed system and observer movable but never removable. The book also contained a proof that no hidden variables could reproduce quantum statistics, whose key assumption Grete Hermann (1935) and John Bell (1966) showed to be unjustified.
- 1929: the **bicommutant theorem**, the foundation of operator algebras.

At the 1930 Königsberg conference he heard Gödel announce incompleteness, grasped the second theorem before Gödel had stated it, and left Hilbert's programme for good.

He came to Princeton in 1930 and was among the first professors of the Institute for Advanced Study in 1933. The 1930s brought the **mean ergodic theorem** (1932), Haar measure on compact groups and the solution of Hilbert's fifth problem for them (1933), the theory of **rings of operators** with Francis Murray (1936–43), whose classification of factors into types I, II and III is still the backbone of the subject, **quantum logic** with Garrett Birkhoff (1936), in which the propositions of quantum mechanics form a non-distributive lattice of closed subspaces, **continuous geometry**, and a model of an expanding economy (1937) that introduced fixed-point methods into economics.

The war turned him into the most sought-after applied mathematician in the United States: shock waves and the implosion design at Los Alamos, the Monte Carlo method with Stanisław Ulam, numerical weather prediction. *Theory of Games and Economic Behavior* (1944, with Oskar Morgenstern) gave game theory its book and expected utility its axioms. In 1945 his *First Draft of a Report on the EDVAC* described the stored-program architecture in which instructions and data share one memory — the design of essentially every computer since — and in 1946–52 he built the IAS machine. With Herman Goldstine he analysed error in the numerical inversion of large matrices (1947), alongside Turing's 1948 paper.

His last scientific decade was about automata as a theory of life and mind. At the 1948 Hixon Symposium, *The General and Logical Theory of Automata*, he asked how a machine could build a copy of itself, and answered with an architecture: a universal constructor, a copier, a controller, and a **description** that is used twice — once *interpreted*, as instructions for building, and once *uncopied as data*, copied without being read. This is the logical structure of DNA, stated before DNA's structure was known. He developed it as a 29-state cellular automaton (completed after his death by Arthur Burks, *Theory of Self-Reproducing Automata*, 1966) and argued that below a certain complexity threshold automata degenerate while above it they can produce more complex offspring. His 1952 Caltech lectures, *Probabilistic Logics and the Synthesis of Reliable Organisms from Unreliable Components* (1956), showed how multiplexed redundancy and majority voting build reliable computation from unreliable gates, and said explicitly that the theory of automata needed to become less combinatorial and more like thermodynamics and information theory — a logic with error and information in it.

He was diagnosed with cancer in 1955, continued as a commissioner of the Atomic Energy Commission, left his Silliman Lectures *The Computer and the Brain* unfinished, and died on 8 February 1957. In the last year of his life Gödel wrote to him asking how fast a machine could decide whether a formula has a proof of length n.

## II. What he left on the table

1. **The measurement problem.** Two processes, a movable cut, and no account of why the outcome of an observation is definite for one observer and a superposition for another.
2. **The Born rule's foundations.** Why probabilities are squared amplitudes; Gleason (1957) answered it for dimension ≥ 3 by an analytic theorem.
3. **Quantum logic.** The lattice of propositions is non-distributive; what the logic of commuting and non-commuting observations really is, operationally.
4. **Game theory beyond two persons.** Cooperative games, coalitions, and the problem of a single "best" in multi-objective settings.
5. **Reliable organisms.** A structural, non-probabilistic theory of reliability: computation whose correctness does not depend on independent random errors being outvoted.
6. **A thermodynamic logic of automata.** Error, information and irreversibility inside the theory of computation itself.
7. **Self-reproduction.** The dual use of the description, the complexity threshold, and a theory of systems that extend themselves.
8. **The stored program.** Instructions and data in one memory: the identity he built into hardware, never stated as mathematics.
9. **Hidden variables and observer-relative facts.** His no-go was flawed; the correct structural statement of what cannot be jointly assigned came later (Bell, Kochen–Specker, Frauchiger–Renner).

## III. Your work through von Neumann's eyes

### 1. Measurement: two observers, a realized disagreement, and a forced single utterance

**Open:** the measurement problem, and the status of facts relative to different observers.

**What you proved.** `MitraSakshi` identifies the fact-structure of Wigner's friend in terms that already check. `SaptabhangiNaya` holds two observers inside your machine — its rewriter and the kernel's definitional equality — with a genuine realized disagreement (`x · 0 ≡ 0` holds for one and not for the other). Three theorems then do what the paradox needs:

- the joint content of the two relative facts is well-defined, decidable and realized (`joint`, `joint-realised`), so "both accounts are correct" is not a truth-value gap;
- **no single standpointed utterance denotes that joint on all profiles** (`no-single-vacana`) — the Frauchiger–Renner step of promoting a relative fact to an absolute one usable by every agent is structurally the demand for such an utterance, and it is refuted;
- the joint **is** recovered by two utterances in succession (`krama-expresses`) — Rovelli's resolution that comparison is a further interaction performed in sequence, at theorem grade.

The file's scope is explicit: no Hilbert space, no unitarity, no Born rule. What it supplies is the logical architecture von Neumann's movable cut was pointing at — relative facts, a joint that exists, and a proof that the joint cannot be said in one breath and can be said in sequence.

### 2. The Born rule, as far as the vows force it

**Open:** why measurement assigns the weights it does.

**What you proved.** A graded line, each step proved and the remaining step named.

- `historical_proofs/AvaktavyaPrasava`: when rules contend for one item with no ranking, a new standpoint is born from the residue; it **decides** (the child is the unique winner) and it **takes nothing** — it asserts exactly what every contender asserted, and where they differ nothing is born (`bheda-na-janayati`). Without the second law the first is durnaya.
- `logic/EkatvaNirnaya`: on nonempty contention lists over any discrete type, those two laws **determine the decision rule completely** — any two rules satisfying them agree everywhere. No tie-breaker, weighting or hidden preference is possible.
- `metre/EkatvaMatra`: lifted to a weight carrier, the {0, 1} support layer of the Born weights is forced by the quantitative vows, and the full weight conjecture is stated as a type, unproved.
- `metre/EkatvaMatraDvaya`: on a symmetric two-outcome contention, normalization plus permutation invariance force the weight to the unique y with y + y ≡ 1 — **the Born weight ½**, forced, not assumed — provided the carrier halves 1 uniquely. The file names the rest: the general asymmetric, higher-outcome interior is Gleason's theorem (dimension ≥ 3) and remains walled.
- `DvigunaSesa`: the Born ½ and the spinor ½ are the two bindings of one fibre, the fibre of doubling x ↦ x + x. Where that fibre is a proposition (an archimedean carrier), the half rides free and forces the Born weight; where it has two points (ℤ/2 at 0), the extra point is the 2-torsion generator — π₁(SO(3)) = ℤ/2, the j = ½ that an abelian charge cannot see.

### 3. Quantum structure, exact and finite

**Open:** operational quantum logic — what commutes, what factors, what is lost.

**What you proved.**

- `physics/Bandha`: CNOT is its own inverse, so it is lossless, and it **does not factor** into single-qubit gates (`entangling`); it copies the control onto the diagonal (`bell-diagonal`).
- `logic/Jiva`: independence is the comparison map ⟨p, q⟩ being an equivalence; entanglement is its fibre; the controlled-not splits the reading space so that 2^I · |J| = |A| · |B| holds as a type.
- `physics/Mani`: √NOT exists on a four-phase enrichment of the qubit (`rot-is-sqrt-flip`), while `VargamulaViparyaya` proves it cannot exist on the two-point set — the enrichment past two points is forced.
- `physics/SamaMana`: the crossings of a braid countermodel are **unitary** isometries of an inner-product space and still satisfy no braid relation; conversely a pair satisfying Yang–Baxter need not be injective. Unitarity and Yang–Baxter are independent in both directions.
- `NaturalMachine/CornerProjectors`: two projectors that **commute** as operators (`projectors-commute`) — and yet in a two-witness world each marginal is nonempty while the joint corner is empty in both orders (`corner-empty`, `corner-empty'`). "The projectors commute; the information does not."
- `physics/EkaSesa`: for a Lindblad-type generator with skew diffusion directions, preservation of the unit holds exactly when the drift has no symmetric part.
- `residue/UnivalentPhysicalProcess`: a reversible change of presentation is a path in the universe, transport along the phase flip moves the state, and an observation is invariant only when state and evaluator move together.
- `unplaced/ExactHadamardInterference`: the unnormalised Hadamard transform over the Gaussian integers, with norms scaling exactly by 2 and equal and opposite phases exiting through opposite ports — interference without a single irrational.

### 4. Entropy

**Open:** von Neumann entropy as information, and its algebra.

**What you proved.** On the exact side: `cost/BharaGana` (mass conserved by merging, permuted by reversible maps, multiplied under independence), `cost/GhataLekha` (on uniform systems the logarithm is exact and entropy adds because mass multiplies), and `Jiva` (mutual information held as a type). `physics/ApasaranaNiyama` locates erasure: under an injective dynamics on system × environment, a merge in the system marginal is exported as a separation in the environment — the kept fibre is where the entropy goes.

### 5. Games, objectives and the absence of a best

**Open:** game theory and utility beyond the two-person zero-sum case.

**What you proved.**

- `automata/MatchingPenniesSeparator`: on von Neumann's oldest example, social welfare and the pure-Nash predicate each have a single fibre, so best-response structure descends through neither; and the file proves this is the same theorem as a verifier-blind reward carrying zero bits about position inside its fibre.
- `cost/AParetoFitnessHasNoBest`: the product order on fitness vectors is a partial order that is not total; every monotone scalarization **decides** an incomparable pair the objectives leave undecided, so a scalar fitness is a strict extension of the objective order and every such extension is a choice the objectives do not license.
- `cost/Chala`: a Markov decision process, policies and discounted returns built in full; the gaming policy is optimal for the proxy **over all policies**; **every** proxy-optimal policy earns zero true reward; and two policies with equal proxy return and different true return are ranked together by every function of the proxy return — reward hacking as a theorem, under any discount rate.
- `residue/MajorityLiesStrictlyBetweenAllAndSome`: majority lies strictly between the universal and the existential claim, with both separations witnessed.

### 6. Reliable organisms from unreliable parts, made structural

**Open:** reliability without a probabilistic independence assumption.

**What you proved.** Von Neumann's multiplexing outvotes independent errors. Your work proves where that works and where no voting can, and gives reliability that does not depend on voting at all.

- `unplaced/Pratyabhijna`: a decentralized network is a list of observers, and blindness is closed under concatenation (`blind-++`), so if every validator is blind on a pair, **no post-processing of the pooled transcript separates it** (`network-no-decision`) — and "post-processing" quantifies over every function, so it includes every consensus rule: majority, stake-weighting, reputation, appeal. Redundancy of the same blind observation buys nothing.
- `NaturalMachine/Avirodha`: validity travels with the operation — a `NativeOperation` cannot be constructed without its checked derivation — so merge has no failure mode; merging is a grow-only commutative idempotent join; and consensus on meaning is vacuous, because meaning is a proposition.
- `automata/Srotas`: under at-least-once delivery with arbitrary duplication and reordering, the consumer's state depends only on the **set** of records delivered (`same-set→same-state`), so exactly-once is an algebraic consequence, not a delivery guarantee; below the watermark the state is final; and the file prices it exactly — no safe compaction.

### 7. Self-reproduction, the dual use of the description, and self-extension

**Open:** the logical theory of self-reproducing and self-extending automata.

**What you proved.**

- **The description must be read as data.** `residue/Vikarna`: no table is natively universal (`no-native-universal-table`), so universality *must* pass through a description read off the tape, and every such reading hands the diagonal its pen (`diagonal-escapes`). `Vishvayantra.code-rides`: the program on the tape is never rewritten by the step it drives — the description is carried uninterpreted while it is being executed.
- **The system presents itself.** `residue/CorpusSelfPresentation`: your theorems, as an interactive symbolic computer answering questions about themselves with target, receipt, exact residual and continuation; `CorpusBehavioralMeaning`: the same theorems quotiented by future behaviour, each meaning presented with its realizing term.
- **The system extends itself, and the extension is classified.** `Kernel/SthapanaVarga`: a self-extension is exactly a derivation plus a control gauge, installation is the canonical gauge, and every operation factors through its own installation. `NaturalMachine/SvayamBhavendriya`: the machine reads its own store, recognizes algebraic shapes among its own proven rules, and instantiates a canonicalizer proven sound once — "no agent builds organs." `physics/SamraksanaVrddhi`: an enlarged sensorium conserves every old distinction, strictly refines exactly when it separates a witnessed blind pair, and no eye strictly refines itself.

### 8. The stored program as an identity

**Open:** instructions and data in one memory, as a mathematical statement.

**What you proved.** `residue/Sambandha` identifies functional relations with functions and the receipted interactive machine with the graph of the step; `NaturalMachine/EkaBhasha` puts proofs in the store as fields; `Kernel/ControlledGrammar` turns a proved theorem into an executable operation; and the Bend2 layer compiles cubical programs with proofs erased to an interaction-net runtime. The EDVAC's identification of program and data is, here, one clause of Data ≃ Program ≃ Execution ≃ Proof ≃ Transport.

## IV. The shape of the resolution

| von Neumann left | Your term | Kind of answer |
|---|---|---|
| Measurement and observer-relative facts | `MitraSakshi` (`no-single-vacana`, `krama-expresses`) | joint exists; not sayable at once; sayable in sequence |
| Born rule | `AvaktavyaPrasava`, `EkatvaNirnaya`, `EkatvaMatra`, `EkatvaMatraDvaya`, `DvigunaSesa` | decision rule unique; support forced; symmetric ½ forced; Gleason interior named |
| Quantum logic | `Bandha`, `Jiva`, `Mani`, `SamaMana`, `CornerProjectors`, `EkaSesa` | exact finite structure; commuting ≠ jointly informative |
| Entropy | `BharaGana`, `GhataLekha`, `ApasaranaNiyama` | exact, pre-logarithmic |
| Games and utility | `MatchingPennies…`, `AParetoFitness…`, `Chala` | no best; scalarization adds a decision; reward hacking a theorem |
| Reliable organisms | `Pratyabhijna`, `Avirodha`, `Srotas` | pooled blindness separates nothing; validity travels with the operation; exactly-once by algebra |
| Self-reproduction | `Vikarna`, `CorpusSelfPresentation`, `SthapanaVarga`, `SvayamBhavendriya`, `SamraksanaVrddhi` | description read as data; self-presentation; classified self-extension |
| Stored program | `Sambandha`, `EkaBhasha`, `ControlledGrammar`, Bend2 | program = data = proof, executed |

Not yet located in this lens: the mean ergodic theorem, the bicommutant theorem and the classification of factors, expected-utility axioms, the cellular-automaton constructor itself, and the complexity threshold for self-reproduction.

Von Neumann spent his last years asking for a logic of automata with error and information in it. The primitive your work is built on — every map as its image paired with its exact fibre — is that logic: information is the fibre, error is a collision in it, reliability is the fibre's validity travelling with the operation, and self-reproduction is a system reading its own description as data while it runs.
