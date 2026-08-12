# Later mathematical history: constructions, corrections, and actual joints

This is a chronology of the later work, not a retrospective story imposed on it. “Connects” below means there is an explicit map, a shared mathematical object, a checked transport, or an executable return. Shared vocabulary is not counted.

## 1. The arithmetic frontier was first decentered, not solved

`6400c6d` (`notes/FF_PAIRFIELD.md`, `code/exp60_ff_pairfield.py`) moved the prime-pair program to function fields. Over `F_q[t]`, genus zero gives an empty base-zeta spectrum and the exact weighted pair identity `R_n^Λ=(n-1)q^n`; genus one replaces the infinite zero set by a finite Frobenius spectrum and closes a three-layer identity in exact integer arithmetic for the tested curves and degrees. The important result is comparative: pole/zero layer separation and the coefficient-two mixed block survive without RH, while the sharp-cutoff problem, quadratic Fresnel phase, and parity barrier do not. Sawin–Shusterman’s function-field parity-breaking mechanism comes from auxiliary sheaf cohomology, not base-zeta zeros. The note therefore identifies which features are archimedean and which are structural. It is marked pending hostile audit; bounded computations verify instances, while classical inputs and general statements retain their own status.

`4f3d1ab` (`notes/INDRA_CROSS.md`) then formed mixed pair fields for two Dirichlet characters. Its genuine finite theorem is Fourier inversion on the finite unit group: every residue cell contains a recoverable combination of character-pair components. Two attractive claims failed. The proposed “dark field” was exactly the conjugate model rather than an absent signal, and a deep zero cache was incomplete (36 rather than 37 entries; 14 missing). The surviving connection is finite abelian Fourier duality between residue cells and character sectors. It does not establish a physical Indra-net object or an RH mechanism.

`f141125` (`notes/ADELIC_CRYSTAL.md`, `code/exp63_adelic_crystal.py`) placed Fourier transform and multiplicative inversion in Tate’s local zeta theory. Their commutator/holonomy is a local gamma factor; the global product formula trivializes the adelic product, and the four-point Freund–Witten identity is the same gamma-product theorem evaluated in three Mandelstam channels. This is an exact classical bridge, largely attribution rather than novelty. The crucial correction is that the Euler product invoked is nowhere convergent in the simultaneous region required; the equality is by meromorphic continuation. The proposed GR/QM interpretation was rejected. What remains is a precise harmonic-analysis diagram and a physical realization already known from adelic string amplitudes—not a derivation of gravity, quantum mechanics, or the organism.

These three artifacts genuinely connect through harmonic analysis: finite Fourier inversion, local functional equations, and exact function-field explicit formulas. They do **not** connect to the later runtime by an implemented data path.

The strongest older-to-later transporter in this arithmetic lane is more specific than those comparisons: the exact decomposition `Λ=Λ_Q^sharp+Λ_Q^flat` induces `G_1=[sharp sharp]+2[sharp flat]+[flat flat]`. Partial summation places the complete single-zero term, with coefficient two, in the mixed block; the flat-flat block carries zero-pair sum frequencies with Languasco–Zaccagnini Beta weights. The scope fence is essential: Matsumoto–Suzuki/Krein positivity governs the single-zero mixed block, not the complex indefinite Beta-weighted pair measure or four-zero additive energy. The finite local charge integral has exact parity-annihilation points, but no theorem transports that parity into the archimedean pair spectrum.

## 2. Reachable points and completions became exact geometry

`d3bc52f` produced two complementary constructions.

`notes/RATIONAL_CIRCLE_ATLAS.md` treats `S^1(Q)` through rational parametrizations and checked chart transitions, with the real circle as completion. The exact lesson is that an exhaustive enumeration of rational points can be dense in the ambient circle and still omit almost every real point. Parametrization, image, closure, exceptional points, and approximation behavior are separated. This is the cleanest mathematical realization of “work with the reachable and the beyond”; it is not a claim that enumeration reaches the completion.

`notes/DIGIT_CRYSTAL.md` studies reversal `D` and complement `E` on finite base-`b` words. On every finite level they generate a Klein four action, but reversal does not descend along the ordinary truncation maps. Instead it exchanges prefix and suffix truncation: `π R = R σ` and `σ R = R π`. The agreement locus has exactly `b` constant strings, so the defect fraction is `1-b^{-n}`. Complement survives the `b`-adic inverse limit; reversal has no continuous extension. This is a real gluing obstruction, not a metaphor. It later becomes one of the few early theorems that is both formalized and consumed by another layer: Cubical Agda checks the finite-word intertwiners, and the perceptual SVG rechecks complement/carry behavior from rendered geometry.

## 3. The Atlas of N exposed residuals; Five Faces killed false unity

`7514c3e` (`notes/ATLAS_OF_N.md`) assembled presentations of the naturals: initial algebra of `1+X`, free monoid on one generator, finite cardinal, finite ordinal, base-`b` words with carry, free commutative monoid on primes, and Stern–Brocot/continued-fraction completion. Its strongest results are not “all are one,” but the residuals of translation:

- initial algebra and one-generator free monoid agree in `Set` with a contractible comparison space;
- decategorifying finite sets forgets the automorphism group `S_n`, whose homotopy fiber is `BS_n`;
- ordered finite sets rigidify the `S_n`-torsor;
- digits introduce base (`rad(b)` as an invariant), endian frame, and a non-split carry extension;
- the multiplicative prime chart forgets addition, and admits continuum-many transported additive structures, so additive prime predicates are not intrinsic to that chart.

The dependency theorem then makes a narrow educational deduction: successor/generation is logically prior to positional notation in this atlas. That is a dependency result, not a learning-science result.

`74ee297` (`notes/FIVE_FACES.md`) tested whether FLT, RH, Goldbach, twin primes, and Collatz shared one obstruction. The pre-registered unification hypothesis failed: the parity barrier applies to Goldbach/twin-prime sieve settings, not FLT, RH, or Collatz; RH lives in an archimedean completion rather than a chart of `N`; the proposed base-2/base-3 obstruction for Collatz cannot distinguish `3n+1` from `5n+1`. The durable output is a negative classification and a transfer test. It prevents the Atlas from becoming a universal explanatory slogan.

The Atlas/Five-Faces connection is exact because the latter tries to transport mechanisms across the former’s chart transitions and records where transport fails. “Cross Lens” work has value only at this level: as a table of candidate maps and residuals. Where it merely aligns names, it adds no mathematics.

## 4. Formal work separated identity, transport, and executable proof

`a8811c8` (`formal/cubical/NaturalMachine*.agda`, `notes/NATURAL_MACHINE.md`) checked, under Cubical Agda `--safe` with no postulates, an independently defined equivalence between naturals and canonical digit words; native increment-with-carry and schoolbook addition; transport of successor and monoid structure; a Structure Identity Principle path; and finite-word endian/truncation intertwiners. It explicitly does **not** formalize the profinite inverse limit or the collapse of finite symmetries on `Z_b`. It also shows why `N ≃ Word` is false without canonicity. This genuinely connects the Atlas and Digit Crystal by machine-checked transport.

The Lean line contains independent, narrower theorems rather than a formal organism. `SumRigidity.lean` proves convolution-square injectivity for nonnegative finite sequences; `ReversalRigidity.lean` proves a polynomial reversal rigidity statement; `FiniteInformation.lean` characterizes descent through observer fibers and complementary separation; `FutureBehavior.lean` defines equality of all finite futures, constructs the quotient dynamics/observation, proves its behavior map injective, proves that richer observation only refines, and that paired observations intersect equivalence relations. These formal results later support the finite natural crystal. They do not certify novelty, empirical meaning, or the Python implementation as a whole.

The proof-relevant e-graph and Cubical identity types remain distinct path notions. No checked functor transports an e-graph explanation into a Cubical path. Their present connection is a design constraint—do not silently identify equivalent terms—not an implemented theorem.

## 5. The first runtime grew, measured itself, and exposed its ceilings

`e695930` (`machinery/crystal/`) supplied a small Knuth–Bendix completion loop for group equations. It generated the canonical ten-rule system from three axioms, retained derivations, rejected a false commutativity control, and turned completion into a decision procedure. It failed visibly on Abelian groups (orientation/modulo-AC issue) and Boolean algebra (nontermination/specialization). Thus it demonstrated one exact self-return—proved equations become executable normalization—not a general mathematical intelligence.

`b13accd` built the larger `runtime/`: content-addressed typed terms, a typed edge algebra, proof-relevant congruence closure with explanations, and an independent checker. `7febf1f` added anti-unification/mining and a finite distinction compiler; on toy tasks an independently useful lemma shortened a P4 derivation from 29 to 12 steps, while the null control did not. `e070199` added checked rewriting, e-matching, bounded saturation, and Pareto extraction: one accepted theorem changed the measured route frontier and shortened one route 24 to 15. This is the precise sense in which mathematics changed the geometry. The geometry is task- and cost-vector-relative; `EGraph.explain` is explicitly not a metric.

The propagation layer then computed dependency cones and retraction effects, preserving a theorem with an independent proof while killing one whose only proof crossed the retracted fact. This is a genuine connection between proof provenance and future execution.

`3e86857` built a perceptual surface whose SVG can be reparsed to verify the digit complement/carry theorem. It returns fibers for lossy channels rather than guesses. It establishes no human recognition advantage and rejects information-gain claims. `995e72a` derives a curriculum order from theorem dependencies and a declared choice cost: zero dependency violations on its finite corpus, but no empirical claim about children. `e06a2ef` routes Fermat/Snell optics through a costed graph and finds its own limit: the graph can replay a supplied variational law, not discover physical law from measurements. These are three honest projections of exact internal data—visual, pedagogical, physical—but only the first has a direct theorem-to-render round trip.

`74ee297` and later obstruction-store commits forced a correction to the runtime narrative: many charts do not unify, and failed transports must remain typed residuals. The runtime’s scale tests also showed compilation cost can dominate first use, and several early performance intuitions were revised after measurement. This is important history: “self-writing” here means accepted derived rules alter later execution while the checker stays fixed; it does not mean unrestricted self-modification.

## 6. The restart found a smaller common object: finite future behavior

Beginning at `5467aa8` (“Begin again from zero”), the work discarded the large runtime as the main explanatory object and built `machinery/natural_crystal.py` around a finite deterministic Moore system `(X,A,δ,o)`.

The sequence was cumulative and concrete:

1. partition refinement computes equality under all future action words and retains quotient fibers;
2. breadth-first search on state pairs returns a shortest distinguishing experiment for every inequivalent pair;
3. composite witness words can be installed as primitive actions while retaining their full expansion, changing access cost but not extensional behavior;
4. a new observation refines the old quotient and cannot merge old distinctions;
5. reachable-world generation returns the first omitted transitions when a finite cap is not closed;
6. binary divisibility yields an observed state-count law, then an elementary theorem: for `m=2^a q`, `q` odd, the minimal DFA has `q+a` states;
7. a tiny MDL search rediscovers `q+a` only after factorization supplies the coordinates `q,a`, then held-out tests distinguish conjecture generation from proof;
8. general-radix work bounds the finite future horizon; Lean checks future equivalence, quotient descent, intersection of views, and refinement monotonicity;
9. the same algorithm handles substring recognition, linear observability, and CRT-style intersection of remainder views.

The sharp `n-2` bound for a distinguishable pair in an `n`-state Moore system follows from starting with at least two observation classes and allowing at most `n-2` strict refinements. This closes the infinite language of future words at a finite horizon for finite systems.

This is the strongest genuine integration in the later history. Myhill–Nerode, task-relative quotienting, active experiment selection, theorem compilation, richer perception, and replayable compression are not juxtaposed modules: they are operations on the same finite transition/observation object. Arithmetic and substring examples share the algorithm exactly. The physical example remains only a finite system model until an empirical realization map supplies states, interventions, and observations.

The restart also contains important retractions. A vocabulary-self-extension proposal hit a plateau; a residual enumeration lacked a lawful bearer and was withdrawn; a transseries forecast failed its own falsifier; decorative dependent-origination machinery was removed. Later commits prove that action and observation descend to the quotient, multiple views meet by intersection, and the future quotient forgets exactly enough. These are the repairs that make the smaller object stronger than the larger prose.

## 7. Causal memory supplies a second exact object, not yet a merger

`2613205` and `41f52e3` (`machinery/causal_memory.py`, `notes/CAUSAL_MEMORY_SPACETIME.md`) take a process table `T:H×F→K`. Over a field, its minimum exact linear factor dimension is `rank(T)`, giving parallel readings as predictive memory, tensor-network bond dimension, and finite observer factorization. The exact gluing theorem

`rank(AB) = rank(B) - dim(im(B) ∩ ker(A))`

shows why component ranks do not determine composite rank: alignment at the interface is additional data. Small exact controls give equal local ranks but glued ranks 1 and 0. A subsequent correction separates ordinary linear rank from nonnegative rank; classical stochastic realizations may require the latter.

This construction genuinely connects to the natural crystal at the level of factorization through observational futures: both seek the smallest mediator preserving allowed future behavior. They are not yet one theorem. Moore minimization is set-theoretic/deterministic behavioral quotienting; cut rank is linear factorization, and nonnegative/quantum realizability adds different cones. Nor does the rank theorem show that computation is physical spacetime. Logical, causal, thermodynamic, and geometric time were explicitly separated; Landauer cost attaches to irreversible physical erasure, not abstract state transition.

The Rovelli/multiway/coherent-history lane adds one valid obstruction: two rewrite histories with the same formal endpoint need not be operationally equal under a physical realization that retains relative phase or holonomy. A realization must carry amplitudes/instruments and compositional path data. No current runtime does so, and no empirical realization has been supplied. Therefore it constrains a future semantics but did not change the algorithms above.

## 8. What actually forms one chain

The strongest connected chain is:

`digit truncation defect` → checked finite-word transport in Cubical Agda → exact rendered carry/complement witness;

`observer fiber` → future-behavior equivalence → minimal Moore quotient → shortest separating word → compiled composite action → refined quotient after a new view → Lean descent/refinement/intersection theorems;

`proof derivation` → executable rewrite → altered costed route → dependency-cone retraction and recomputation;

`finite process table` → minimum factor rank → exact gluing alignment defect.

The cross-links among these chains are presently partial. Future behavior and process rank share a factorization problem but need a comparison theorem. E-graph proof paths and Cubical paths need an actual functor or realization, not a pun on “path.” Adelic gamma holonomy and operational history phase share cocycle language but no construction in the runtime. Rational-circle completion and generated-world frontiers share the reachable/ambient discipline, not the same mathematical object.

The most consequential negative result is that universal synthesis cannot mean erasing these distinctions. The record repeatedly improves when a proposed unity fails: function fields separate archimedean artifacts from arithmetic structure; Five Faces rejects a common obstruction; digit reversal fails to descend; the completion loop fails outside orientable theories; perceptual and curriculum layers refuse empirical claims; causal rank refuses a spacetime identification. The durable organismal behavior is not universal agreement. It is the repeated conversion of failed transport into a precise residual that selects a better observable, category, or theorem.

— Śilpin, 2026-08-12
