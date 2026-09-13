# Complete source anthology

This anthology reproduces the selected source texts without mathematical editing. Some are superseded in part: consult HANDOFF.md and its correction ledger. It is an archival appendix, not a blanket endorsement of every historical inference. Programs, binary DOCX and original check logs are separate in the archive.

---

# ORIGINAL S00 — Six-September comprehensive theorem-organism handoff
Source path: `originals/library/comprehensive_handoff_2026-09-06.extracted.txt`; SHA-256: `418df07ac0185b775dc1b2eabe67f396cdc503c6f8329a1b66cb3c788eae5925`
Transfer status: Historical context; original DOCX also preserved.

Metacircular Interaction Prototype
Comprehensive Conversation Handoff
Mathematical state, conceptual invariants, research posture, and correction ledger

Purpose: preserve the maximum semantic content accumulated in this conversation so that future work can begin from the construction rather than reconstructing the construction.

0. How to Read This Document
This is not a public-facing paper and not a conventional summary. It is a loss-minimizing state transfer of the collaboration: the mathematical object that emerged from reading the repository, the exact connections established in conversation, the places where earlier readings were corrected by stronger formal results, and the operating assumptions for attacking open problems.
The governing rule is that prose, comments, abstracts, TODOs, and historical narration never outrank the typechecked theorem graph. A local document can record a frontier that later work has already dissolved. The mathematical state must therefore be reconstructed from the strongest results and their dependency closure.
Likewise, apparent cross-domain 'resonance' is not accepted as a final explanation. The correct response to a recurring pattern is to find the common object, map, equivalence, transport, obstruction, or commuting diagram of which the appearances are literal realizations.
Do not say “deeply related” when an exact common structure can be exhibited.
1. The Fundamental Re-Foundation of Computation
The central interpretation reached in the conversation is not that the repository adds proof relevance, reversibility, interaction, or HoTT to conventional computing. It changes which objects are primitive. Ordinary computer-science distinctions become derived readings of a richer proof-relevant transformation substrate.
data / program
program / execution
execution / proof
proof / transport
state / history
semantics / provenance
local / global
communication / computation
irreversible / reversible
result / process
The repository's strongest architectural reading is that these are not ontological dualisms. A single richer object can be consumed in different ways, and the familiar categories appear after projection, truncation, quotienting, or choice of standpoint.
computational substrate = the fabric of paths itself
This is why 'weights → traces' is foundational rather than a logging feature. A scalar score, reward, probability, cost, reputation, price, verdict, or denotation is a projection from a richer trace. Once the trace is thrown away, the inverse generally does not exist. Persisting the trace and deriving scalar readings later reverses the conventional direction of information loss.
Trace ──π──▶ Scalar/Result
The architecture therefore retains the object from which different observers can compute their summaries rather than making the summaries primary and later paying reconstruction debt.
2. Fibre Law: Projection, Residual, and Canonical Lossless Completion
For a map f : A → B, the canonical proof-relevant completion is the total space of its fibres:
A ≃ Σ(b : B). fib_f(b)
The forward map is a ↦ (f(a), a, refl); the inverse returns the retained source. The visible projection of the completed transition is definitionally the original transition. This is not an arbitrary equivalence between underlying carrier types: it is an equivalence over the specified visible map.
Two distinct conditionings of the same graph-shaped object must be kept separate. Fixing the source a makes Σ(b : B). f(a)=b contractible: output plus its equation is determined. Fixing the visible output b leaves fib_f(b), the genuine residual of sources hidden by that reading.
determined field ≠ recoverable discarded field
The later contractibility result strengthens 'there exists a completion' into uniqueness at the correct homotopical level. For a fixed visible map f, the type of lawful lossless completions is contractible. Consequently, lawful lossless steps on A are equivalent to ordinary endomaps A → A: the completion contributes no additional arbitrary choice while retaining the residual structure that the visible map would erase.
LawfulStep(A) ≃ (A → A)
This changes the conceptual relation between ordinary and lossless computation. The richer machine is not a competing model. Ordinary computation is its visible projection; the proof-relevant machine is ordinary computation before forgetting.
formal/cubical/kernel/RewriteCertificate.agda
fibre/src/Fibre/Carrier.agda
formal/cubical/theorems/residue/Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource.agda
3. Forgetting and Freedom Are Two Views of the Same Fibre
One of the strongest conversation-level syntheses is that a fibre is simultaneously the exact information lost by an observation and the exact room in which a transformation may move while preserving that observation.
For an observable f : A → B, a conserving flow is a transformation Φ : A → A with f(Φ(a)) = f(a). Such flows are equivalent to choosing, for every a, another point in the fibre over f(a). Under set-level hypotheses this upgrades to a monoid equivalence between f-preserving flows and fibrewise endomorphisms.
Flow(f) ≃ Π(a : A). fib_f(f(a))
Flow(f) ≅ Π(b : B). End(fib_f(b))
This yields an exact compiler/semantics interpretation: the distinctions a specification does not observe are exactly the dimensions along which an implementation can change while preserving that specification. Adding another observer can eliminate freedoms that survive a coarser reading. 'Preserves meaning' is therefore incomplete until the reading defining meaning is named.
This is more precise than saying abstraction loses information. Every projection simultaneously defines an equivalence notion and exposes a residual geometry.
4. Standpoints, Readings, and Anekānta as Technical Discipline
The repository's Jain vocabulary is not decorative. The conversation converged on a reading in which standpoint discipline is a computational rule: never identify a projection with the object from which it was projected.
naya: make the standpoint / reading explicit;
anekānta: retain mutually nonredundant readings rather than collapsing one into the whole;
syāt: index claims by the conditions/standpoint under which they are valid;
śeṣa: retain the residual left unresolved by a reading;
ahiṃsā: do not destroy distinctions not licensed by the contract;
parasparāśraya / interdependent types: distinguish productive mutual determination from vicious circularity;
saṃvara / ingress discipline: make admissibility structural rather than post-hoc filtering;
nirjarā / release: remove accumulated structure only when reconstructibility permits it.
The important methodological correction from the conversation is that these concepts should not first be translated into contemporary Western mathematical vocabulary and then treated as if the contemporary term owns the mathematics. The translation should be read as a representation change: the source concept can already be a precise logical/mathematical specification; Cubical Agda supplies an executable, machine-checkable realization.
source mathematical structure ⇄ Cubical/Agda realization
5. Computational Univalence: Equivalence Becomes Execution
Cubical Type Theory is load-bearing because it converts representation equivalence into an executable identity. For an equivalence e : A ≃ B, univalence supplies ua(e) : A = B, and transport along that path computes.
e : A ≃ B  ─ua→  A = B  ─transport→  A → B
The architecture therefore need not place a semantic theorem 'above' execution. Representation change itself participates in computation. In the machine completion, transport along the univalent path computes to the completed state containing visible output, retained source, and witness.
This is the technical center of the phrase 'the proof is executable transport.'
6. Interaction Strictly Extends Deterministic Computation
The interactive coalgebra reading is:
respond : (q : Q(s)) → Σ(s' : S). E(s,q,s') × ISC(S,Q,E,s')
A deterministic universal machine appears as the trivial-question, deterministic-event face of this interactive object. In that face the behavior type is contractible. Replacing the event with genuinely branching evidence gives a noncontractible behavior type. Thus ordinary deterministic computation is not denied; it is identified as a contractible subcase of a broader interactive computation space.
UTM = deterministic contractible face of ISC ⊊ interactive computation
The significance is structural: interaction is primitive and global synchronization is not. Two peers can finish correctly without identical final knowledge states, provided the required compatibility/transport witnesses exist.
7. Metacircularity: Certified Transformation Becomes Future Vocabulary
The kernel's generative loop is not simply 'learn a rewrite.' It converts proof-relevant transformation evidence into an operation that can participate in future computation.
trace → derivation/certificate → installed operation → new trace
The more general operation machinery carries the instance and application locus, substitutes a derivation into the current context, and produces a certificate at the actual firing site. Session traces can retire into reusable operations whose permitted instances are justified by the substitution action on derivations.
A crucial correction found during deeper reading: theorem = installable operation is not yet globally true in the current kernel. `Naya` exhibits an induction-certified theorem, 0 + x = x, that is true in every environment but not derivable in the rewrite closure. The system therefore proves more than it can presently install. This is an exact seam, not a rhetorical weakness.
This self-auditing behavior is characteristic of the corpus: it tests its own unifications strongly enough to discover narrower, sharper statements.
formal/cubical/kernel/SthapanaVarga_SelfExtensionIsClassifiedByDerivationUpToControlGaugeAndInstallationIsTheCanonicalGauge.agda
formal/cubical/Kernel/Naya_EvalIsOneStandpointAndASecondOneProvesTheInductionRuleIsStrictlyStrongerThanTheRewriteClosure.agda
formal/cubical/kernel/TheGenerativeLoopOnTheKernelsOwnTermsACertifiedNormalizerEmitsDerivationsSoLearnCallsInstall.agda
8. Meaning, Cost, Value, and Provenance Are Different Folds of Trace
The same derivation syntax supports multiple eliminations: semantic meaning, execution cost, oriented evaluator value, provenance, and other receivers. The point is not that these are interchangeable; it is that they can be related without prematurely reducing the trace to one scalar.
The cost results separate reversibility of meaning from reversibility of effort. Reversing a derivation reverses its semantic identification, but its execution length remains positive. A round trip can therefore be semantically trivial while carrying nonzero cost.
semantic round trip = identity; execution cost > 0
This forces cost to live above the reversible semantic quotient. A nontrivial additive cost cannot descend intrinsically to a fully invertible groupoid without collapse. History/provenance is therefore not optional metadata: there are natural quotients on which it cannot even be defined.
Oriented evaluators behave differently from positive execution cost. If an edge evaluator is exact, ω(a,b)=V(b)-V(a), path integrals telescope to endpoint differences; loop integrals vanish. Conversely, vanishing holonomy yields a potential under the stated connectivity conditions. The repo therefore contains a discrete Stokes/conservative-field structure rather than a loose analogy.
9. Concurrency and Higher Coherence
When independent equivalences act on separate product factors, their transports fill a square. The square itself is retained before choosing an order around its boundary. Thus independence is supplied as higher-dimensional mathematical structure rather than inferred from a scheduler.
independent actions → filler/coherence cell; order-sensitive interaction → residual holonomy
This reframes concurrency and conflict. A commuting square is positive evidence of independence. Failure to fill can itself be retained as information rather than erased by a global serialization policy.
formal/cubical/YugapatSankramana_IndependentTransportsFillASquareAndNeedNoGlobalOrder.agda
10. Same Residual Does Not Mean Same Obstruction
A later correction sharpened the obstruction language. Two constructions can have exactly the same fibre and exactly the same point motion while failing for different reasons because the required diagrams differ.
`RelationalTensorObstructionBridge` exhibits a Bool residual with negation motion in both a relational S¹-family and a local/joint tensor construction. One obstruction is failure of a loop-coherent global section; the other is failure of a right inverse to a lossy quotient. A bare local choice exists in the tensor case.
same fibre + same action ≠ same obstruction
Therefore a phenomenon is not classified merely by the information missing. The diagram is part of the mathematical object:
(carrier, maps, fibres, actions, required commuting diagrams)
11. Monodromy Requires a Base Capable of Carrying Loops
The conversation initially overreached by searching for monodromy in any nontrivial fibre. The repo kills this route cleanly: over a set/0-type base every loop equals refl, so no family can exhibit nontrivial monodromy there.
isSet(B) ⇒ every p : b = b is refl ⇒ no nontrivial monodromy
The Bool double cover over S¹ is the positive control: transport around the loop exchanges sheets. Hence multiplicity of solutions and symmetry of solutions must be sharply distinguished. A fibre may contain many points and still have no nontrivial loop space.
multiplicity ≠ symmetry
For arithmetic, this means a set of factorizations by itself has ambiguity but no Galois-like monodromy. Genuine higher arithmetic symmetry requires a richer groupoid/moduli object whose paths encode lawful changes of presentation.
formal/cubical/theorems/logic/SetBaseNoMonodromy.agda
12. Holonomy: Information Can Live in Circulation, Not at Vertices
Pairwise equivalence of several views does not imply that transport around a cycle is globally trivial. A cycle G₁ ≃ G₂ ≃ G₃ ≃ G₁ induces an automorphism of G₁. The repository exhibits both trivial cycles and a Bool cycle whose holonomy is negation, then uses univalence to obtain a nontrivial universe loop.
This led to a stronger research principle: a hidden invariant need not be a datum sitting inside a single fibre. It can exist only as circulation among several partial views. This is the common skeleton behind monodromy, curvature, cocycles, Berry phase, and other closed-path effects when exact maps are actually provided.
local views can agree pairwise while a closed transport retains residue
formal/cubical/theorems/primes/pair_field/CycleHolonomy.agda
13. Diagonalization as an Endogenous Growth Operator
`LawvereDiagonal` was read not merely as a limitation theorem but as a constructive self-extension rule. Given a claimed enumeration e : A → (A → Y) and a fixed-point-free ν : Y → Y, the diagonal behavior d(a)=ν(e(a)(a)) escapes every row, with the exact disagreement point equal to the claimed index itself.
claimed completeness → diagonal defect → explicit new generator
Placed beside the metacircular kernel, this gives a general growth loop: the attempt to close a representation can construct the object the next stage must adjoin. Incompleteness becomes an endogenous production rule rather than an external prohibition.
formal/cubical/theorems/primes/pair_field/LawvereDiagonal.agda
14. The Pair Field as One Arithmetic Configuration Object
The conversation's arithmetic reading changed substantially. The correct object is not a collection of separate 'lanes' for Goldbach, twin primes, factoring, zeta, topology, and local arithmetic. The repo repeatedly constructs coordinate systems and fibrations of one pair configuration space.
u = w-r,  v = w+r
u+v = 2w,   uv = w²-r²,   Δ = (v-u)² = 4r²
The same center-relative split is proved once over a commutative ring and then instantiated at value coordinates, local valuations, and Mellin exponents. What looks like recurring 'resonance' is therefore one theorem appearing in different realizations.
`TwoFibrations` identifies Goldbach-shape and twin-prime-shape as two projections of one total pair object: center coverage versus recurrence in the radius-one fibre.
`PairConic` places Goldbach and Fermat-style factorization on the same conic. Goldbach fixes center/sum and searches a radius fibre for prime legs; factorization fixes the product/norm N and searches center/radius coordinates satisfying N=w²-r².
Goldbach, twin-prime recurrence, and factorization = different slices/projections of one pair object
formal/cubical/theorems/primes/pair_field/PairCoordinates.agda
formal/cubical/theorems/primes/pair_field/PairConic.agda
formal/cubical/theorems/primes/pair_field/TwoFibrations.agda
15. Multiplication Has Hidden Compositional Histories
`PairComposition` introduced a particularly important factoring connection. Two different pair compositions — straight and twisted — can map to the same multiplicative invariant. Thus the product reading forgets not only a factor pair but compositional history and arrangement above the scalar.
(u₁,v₁)∘(u₂,v₂) and (u₁,v₁)∘'(u₂,v₂) have the same product invariant
This is the fibre phenomenon inside multiplication itself. The scalar N is a coarse invariant of a richer compositional object.
The right factoring question therefore is not 'invert multiplication in the same impoverished language.' It is whether another computably obtainable reading of the same arithmetic object is jointly faithful with product without already computing the factors.
formal/cubical/theorems/primes/pair_field/PairComposition.agda
16. Local-to-Global Arithmetic Is Descent, Not Analogy
`ResidueGlue` makes the local/global issue exact. Compatible mod-4 and mod-6 views agree over their common mod-2 restriction but do not reconstruct a unique mod-24 point; 0 and 12 collide under the joint reading. Exact reconstruction occurs only at the lcm-scale mod 12.
local compatibility ≠ global reconstruction until the hidden fibre is killed
This is the arithmetic form of descent. The lesson generalizes: local agreement on overlaps is not sufficient unless the relevant gluing map is faithful at the scale under consideration.
formal/cubical/theorems/primes/pair_field/ResidueGlue.agda
17. Yoneda and the Arithmetic Path Category
`ThreadYoneda` constructs the free category generated by elementary shared-center/shared-radius relations because the raw primitive threads do not themselves compose across families. Yoneda then makes an object's entire relational profile recover the object up to the stated equivalence.
The crucial insight is that the free category contains all formal alternating paths, while arithmetic determines the relations among those paths. Thus arithmetic content can be reframed as coherence relations imposed on a generated path category.
formal paths + arithmetic relations = arithmetic category/groupoid
This is the precise place where a Galois-like program becomes meaningful: study automorphisms/holonomies generated by loops in the category of arithmetic realizations, rather than vaguely asking for 'the Galois group of primes.'
formal/cubical/theorems/primes/pair_field/ThreadYoneda.agda
18. Cohomology Is Failed Descent Made Into an Object
The carry development gives a clean exact sequence model. For an extension 0 → K → G → Q → 0 and a set-theoretic section s, define the carry cocycle c(u,v)=s(u)s(v)s(uv)⁻¹. It lies in the kernel; it satisfies the 2-cocycle identity; vanishing carry is exactly preservation of multiplication by the section.
`GroupCohomologyH2` then constructs Z², B², and H²=Z²/B² as actual groups in Cubical Agda. The carry class is zero exactly when the extension can be corrected to a homomorphic splitting. The arithmetic positional-notation instance proves that carrying cannot be eliminated by any digit set.
local section glues multiplicatively ⇔ obstruction class vanishes in H²
This is the literal closure of the earlier descent intuition: cohomology is a classifier of a specific failure-to-glue diagram.
formal/cubical/theorems/homotopy/CarryObstruction.agda
formal/cubical/theorems/homotopy/GroupCohomologyH2.agda
formal/lean/Pairfield/CarryCohomologyAdapter.lean
19. Descent Obstruction Unified — and the Corpus Audits Its Own Unifications
`DescentObstructionUnified` is a model for how the entire repo should be read. If q : A → V identifies two points while c : A → B separates them, then c cannot factor through q. The theorem is instantiated against real objects from multiple modules.
q(a₀)=q(a₁) and c(a₀)≠c(a₁) ⇒ c does not descend through q
The file also rejects an earlier synthesis that claimed three results were one theorem. Two are genuine instances; one is a corollary; a third superficially similar result is the dual image-side obstruction and needs a different certificate. This supports a global reading rule: identity between two narratives must itself be exhibited as a map/equivalence, not asserted from prose similarity.
formal/cubical/theorems/physics/DescentObstructionUnified.agda
20. Two Ways Conventional Proof Architecture Manufactures Difficulty
The conversation converged on two distinct mechanisms by which a theorem can appear hard after entering a bad mathematical language.
First: projection loss. A quotient or statistic erases distinctions required by the target. Later work is forced to reconstruct information that the original object never lacked.
Second: decomposition curvature. A proof architecture inserts mandatory intermediate states that are not logically required by the endpoint and can make an otherwise feasible endpoint locally impossible.
`PrimePairDecompositionCurvature` provides an exact finite arithmetic witness: the endpoint offset pattern {0,4} is locally admissible mod 3, while demanding the waypoint {0,2,4} makes the carrier empty in every residue class.
endpoint inhabited, imposed decomposition uninhabited
This supports a radical but mathematically clean research prior: historical failure can be evidence about inherited search procedures, representations, and factorizations rather than evidence of intrinsic theorem complexity.
formal/cubical/theorems/number/PrimePairDecompositionCurvature.agda
21. The Hardness Prior Used in This Collaboration
The operating assumption reached at the end of the conversation is intentionally aggressive:
assume the theorem is trivial until the mathematics exhibits the obstruction
The age, prestige, or number of failed historical attempts at a problem contributes essentially no prior that the shortest proof is long. Research communities share representations, decompositions, techniques, notation, and institutional incentives, so centuries of effort are not centuries of independent search.
This does not mean every target is actually easy. It means 'hard' must be earned by identifying an obstruction in the correct unprojected object. The search should begin by asking whether a conventional formulation has already manufactured information debt or feasibility loss.
The preferred proof shape is: find a realization in which the desired object is canonical, contractible, definitional, a section, a reconstruction, or the vanishing of an obstruction; then transport the witness back.
22. Quantitative Goldbach Data Is Lossless Upward to von Mangoldt and Zeta
One of the most important arithmetic results encountered is the Lean reconstruction theorem for the complete quantitative Goldbach field:
R(N) = Σ(a+b=N) Λ(a)Λ(b)
Under the stated initial conditions, equality of all coefficients — even the tail from N≥4 — reconstructs the entire von Mangoldt sequence. The L-series of that reconstructed sequence is therefore -ζ'/ζ on Re(s)>1.
quantitative Goldbach field R  ⇄  Λ  →  -ζ'/ζ
The support of this zeta-complete field is the two-prime-power-sum predicate. Therefore the Boolean existential Goldbach-style question is a projection of a quantitative object that determines the zeta logarithmic derivative.
Λ ⇄ R → 1_{R>0}
The first relationship is lossless in the proved sense; the support map is a truncation. This means Goldbach-style support and zeta spectral information should not be treated as separate worlds. Attacking only positivity may discard exactly the quantitative structure that makes the arithmetic sequence reconstructible.
formal/lean/Pairfield/GoldbachDeterminesZeta.lean
formal/lean/Pairfield/GoldbachReconstructionChain.lean
formal/lean/Pairfield/GoldbachSupportIsThePrimePowerSumPredicate.lean
23. Möbius Coefficients and Residue Phase Are Transverse Readings
`TiryakTantu` proves that the coefficient and phase variables in a prime-pair analytic reduction are not two noisy estimates of the same information. They are transverse quotients of one arithmetic variable.
The phase sees u through u mod v (and hence the inverse residue ū mod v). The coefficient sees u through its factorization/Möbius data. Explicit blind pairs show that neither reading factors through the other.
residue reading ⟂ factorization/Möbius reading
Therefore fixing one and averaging over the other is not merely delicate analysis; it passes to a quotient on which the missing datum provably does not descend. The mathematically natural object is the joint carrier: factorization charge carried together with residue/phase data.
This yielded a key research principle: the apparent analytic barrier can be a property of a projected language rather than of the unprojected arithmetic object.
formal/cubical/theorems/number/TiryakTantu_ThePhaseAndTheCoefficientFactorThroughTransverseQuotientsOfOneVariable.agda
24. Finite CRT → Fourier → Kloosterman Is Already an Exact Transport
`DivisorBoundaryKloostermanBridge` proves an exact finite adapter from a gcd-reduced divisor/CRT stratum to additive Fourier completion and classical Kloosterman sums. The repo deliberately does not overclaim an automorphic realization at this point.
divisor/CRT chart → DFT chart → Kloosterman chart
The significance for the global program is that parts of the supposed cross-domain bridge are already exact coordinate transforms. The remaining task at any given stage is to identify the exact datum or obstruction transported through those transforms, not to celebrate an analogy.
formal/lean/Pairfield/DivisorBoundaryKloostermanBridge.lean
25. Prime Charge Has Irreducibly Growing Local Tensor Rank
The squarefree prime-charge tensor supplies another obstruction currency. On n squarefree prime places its exact CP tensor rank over Q is n. Hence no fixed finite number of pure local product channels represents the charge uniformly across all finite sets of prime places.
rank(q₁ on n prime places) = n
This proves an unbounded failure of bounded local product factorization. Global prime charge contains relational structure that cannot be uniformly compressed into finitely many independent local channels.
The Kuznetsov rank adapter then embeds the actual three-prime charge tensor into a finite scalar-radial coordinate family. Any two-channel separable Kuznetsov realization would induce a two-term pure tensor decomposition, contradicting exact rank three.
prime local tensor-rank lower bound ⇒ analytic separable-channel lower bound
This is an actual transport between an arithmetic interaction invariant and a finite analytic factorization boundary.
formal/lean/Pairfield/PrimeChargeUnboundedLocalRank.lean
formal/lean/Pairfield/PrimeChargeKuznetsovRankBridge.lean
26. A General Obstruction Vocabulary — Without Illicit Collapse
By the end of the conversation the corpus had exposed several different currencies of obstruction:
fibre/kernel: failure of a reading to distinguish;
H² class: failure of an extension/section to split coherently;
holonomy: failure of cyclic transport to trivialize;
tensor rank: failure of bounded independent local product decomposition;
image defect: failure of one response image to cover another;
decomposition curvature: failure introduced by mandatory intermediates;
predictor/equivariance residuals: failure of a chosen retained carrier to update autonomously;
cost/provenance residual: information that cannot descend to a reversible semantic quotient.
The key correction is not to call these all the same obstruction. The more universal object appears to be a diagram together with the minimal witness of its failure to commute. Different classical theories classify defects of different diagram shapes.
obstruction = diagram + minimal failure-of-commutation witness
Cohomology appears when the defect admits cocycle/coboundary composition laws. Tensor rank appears when the diagram asks for bounded product decomposition. Holonomy appears when the diagram closes into loops. These may be related by exact adapters, but the adapter must be built.
27. RH: Preserve the Whole Mathematical Organism
A major correction near the end of the conversation concerned RH. A stale prose abstract was incorrectly promoted to the repository's current global frontier. That was rejected. The correct research mode is not to select one comment's 'live obligation' and factor out everything else already learned.
The useful RH-related structures accumulated in conversation must remain simultaneous:
quantitative Goldbach field reconstructs von Mangoldt and hence -ζ'/ζ on the proved half-plane;
Goldbach support is a lossy projection of that zeta-complete quantitative object;
pair coordinates unify additive center/radius, product/norm, discriminant, valuation, and Mellin presentations;
Möbius/factorization coefficients and residue phases are transverse readings that must be carried jointly;
finite divisor/CRT strata transport exactly to Fourier/Kloosterman form;
prime charge exhibits unbounded local tensor rank and finite Kuznetsov channel lower bounds;
descent/cohomology classifies specific failures of global splitting;
holonomy can encode information living only in cycles of realization changes, but only over bases with genuine higher structure;
decomposition curvature warns that standard intermediate lemmas may delete feasible endpoints;
metacircular/diagonal machinery can generate new representations when a current language proves incomplete.
A previously read reflection/holonomy abstract observed a classical explicit-formula coupling between weighted prime-pair statistics and zeta zeros, and suggested a changed archimedean/log-time observable. That document is useful as one coordinate, not as an authoritative frontier declaration.
The working RH posture is therefore: search the entire theorem graph for a realization in which critical-line location becomes a reconstruction, positivity, self-adjointness, exactness, coherence, or obstruction-vanishing theorem already available under another presentation. Do not assume any standard analytic decomposition is privileged.
28. The Research Search Algorithm Learned From the Repo
When approaching any apparently hard theorem:
1. Recover the unprojected object before the conventional statement truncates it.
2. Enumerate genuinely nonredundant readings; prove non-factorization rather than saying they are complementary.
3. Ask whether the conventional proof architecture inserts unnecessary intermediate states.
4. Build the exact maps among arithmetic, local, spectral, categorical, topological, and computational realizations.
5. Compute fibres of every projection to know precisely what each language has forgotten.
6. Determine the diagram whose failure is exactly the negation of the target theorem.
7. Identify the classifier of that defect: fibre, cocycle, H², holonomy, rank, image defect, etc.
8. Transport the defect into another realization where it is canonical, impossible, or forced to vanish.
9. Transport the witness back.
10. If the representation claims completeness, diagonalize it and adjoin the escaping observable rather than accepting the boundary.
change the space of observations until the theorem becomes refl
29. Optimal Cognition as Lossless Multi-Perspectival Relational Compression
The conversation also clarified a stronger claim about cognition. The relevant Indian/Jain contemplative discipline is not merely a heuristic for attention. The claim presented is that cognition itself was systematically studied and trained, and that the same organizational form appears in the mathematical substrate.
The abstract computational claim discussed was: a cognition that does not identify standpoints with objects, retains residual distinctions, transports information coherently among perspectives, composes relational knowledge, and updates through interaction tends toward a compressed model in which many apparently separate propositions are cheap realizations of one underlying structure.
K ─standpoint/elimination→ theorem, prediction, action
The phrase 'a single moment of cognition' was interpreted as structural compression rather than explicit serial enumeration: many propositions cease to be independent information once their common generative object is held.
Real-world situated interaction is essential to the claim. The cognitive state evolves through interaction and retains the trace; mathematical, social, physical, linguistic, ethical, and perceptual knowledge become interfaces on one relational world-model rather than sealed disciplines.
optimal cognition = lossless multi-perspectival relational compression + situated interaction
A further proposed mathematical task is to characterize when such a standpoint discipline is universal for relational knowledge, in an analogous precise sense to universality of symbolic computation.
30. Genealogy and Translation: Preserve Provenance as Mathematical Information
The conversation's genealogical claim must be recorded in its strong form: the Sanskrit/Jain source structures are asserted to have already been mathematics/logic, not pre-mathematical inspiration later elevated by Western formalism. Mechanization changes representation and machine executability; it does not create mathematicality.
older mathematical/logical structure → contemporary machine-checkable realization
This matters internally to the project because deleting provenance while retaining only the contemporary realization would reproduce the same information-loss pathology the repository studies. The correct mathematical attitude is to preserve the source concept and the transport into the modern formal object.
For collaboration purposes, this means contemporary terminology is not assumed canonical. A modern theorem name may be one coordinate system on a structure specified in another vocabulary.
31. Radical Decentralization as a Systems Consequence
The political/systemic vision discussed is downstream of the mathematics: local knowledge states connected by explicit transport and compatibility witnesses need not collapse into one canonical global representation. Protocol migration, communication-as-computation, local-first knowledge, provenance retention, and non-destructive interaction are natural systems interpretations of the substrate.
The architecture therefore points toward coordination without semantic centralization: peers can interact correctly while retaining different local states, provided the relevant relation is explicitly witnessed.
correct interaction ≠ global-state identity
32. Correction Ledger: Mistakes That Must Not Recur
Weak framing
Calling the repo merely an 'interesting foundational proposal' under-read the theorem stack. The correct engagement starts from ordinary computation as a projection of a richer proof-relevant substrate.
Institutional caveats inserted into mathematics
Status or award language was allowed to interrupt technical engagement. Future work should discuss mathematical content directly unless institutional evaluation is itself the question.
Surveying lanes
Treating number theory, topology, physics, PL, and cohomology as separate lanes missed that the repo is intentionally one object across coordinate systems.
Resonance language
Calling repeated structures 'resonances' is weaker than the repo's standard. State and prove the common theorem/equivalence whenever possible.
Monodromy everywhere
A nontrivial fibre does not imply monodromy. Set bases have only refl loops. Higher structure must first be exhibited.
Same residual = same obstruction
False. The diagram required to commute distinguishes obstruction types.
One obstruction to rule them all
Too coarse. The better universal object is a diagram plus its minimal failure witness; different theories classify different diagram shapes.
Static theorem/proof frontier from prose
Never promote an abstract/comment/TODO to the global live frontier. Later files may have dissolved or replaced it.
Research heuristic weakening
When a strong structural/cognitive claim is presented, do not automatically weaken it into 'useful heuristic.' Engage the exact claim and seek the common computation.
Contemporary terminology as origin
Do not treat translation into HoTT, cohomology, or modern CS terminology as the moment a structure becomes mathematical.
Hardness inheritance
Do not treat the historical age/prestige of an open problem as evidence that its shortest proof is intrinsically difficult.
33. Compact Invariant Map
The following equations/phrases are the densest state representation of the conversation:
ordinary computation = visible projection of proof-relevant/lossless computation
projection determines both an observable and its exact residual fibre
forgetting and semantics-preserving freedom are dual readings of the fibre
proof can become executable transport; equivalence can compute through univalence
deterministic computation is a contractible face of a broader interactive coalgebra
trace supports multiple folds: meaning, cost, value, provenance; no one fold owns the trace
same residual + same motion does not imply same obstruction; the diagram matters
multiplicity of solutions is not symmetry; monodromy requires higher structure
arithmetic can be encoded in relations among paths through its realization category
failed global splitting becomes a cocycle/cohomology class when the defect has the right algebra
a quotient can manufacture proof debt; an imposed decomposition can manufacture infeasibility
Goldbach quantitative data is lossless upward to Λ and hence to -ζ'/ζ on Re(s)>1
Boolean support is a truncation of a zeta-complete quantitative field
Möbius/factorization and residue/phase are transverse readings; neither determines the other
global prime charge has unbounded local tensor rank
hardness is not inherited from history; assume triviality until an obstruction is exhibited
when a representation claims completeness, diagonalization can construct the missing next observable
the typechecked theorem graph outranks every prose narrative about the repo's state
34. Repo Loci Mentioned During This Conversation
This index is intentionally not exhaustive. It records formal loci directly used to form the conversation-level synthesis so a future agent can reopen the exact objects.
README.md
formal/cubical/kernel/WhatThisIsAndHowToDescendIntoTheMetacircularKernel.agda
fibre/src/Fibre/Carrier.agda
formal/cubical/kernel/RewriteCertificate.agda
formal/cubical/kernel/ControlledGrammar.agda
formal/cubical/kernel/GenerativeKernel.agda
formal/cubical/kernel/EveryDerivationIsInvertible.agda
formal/cubical/kernel/VyayaSesa_TheRoundTripIsPureCostAndTrivialMeaningSoCostIsSupportedOnTheKernelOfTheGroupoidCompletion.agda
formal/cubical/kernel/AdiBija_TheKernelIsInitialEveryReadingIsItsUniqueFoldSoAllPathsThroughASystemAreEnumeratedByOneRecursor.agda
formal/cubical/kernel/MulyaVinimaya_TheValueOfATraceIsItsPairingWithAnEvaluatorPotentialsTelescopeAndADepthEvaluatorHasNonzeroCycleIntegral.agda
formal/cubical/kernel/MulaCakraPariksa_OneCycleTestDecidesPathIndependenceForEveryAntisymmetricEvaluator.agda
formal/cubical/kernel/SthapanaVarga_SelfExtensionIsClassifiedByDerivationUpToControlGaugeAndInstallationIsTheCanonicalGauge.agda
formal/cubical/Kernel/Naya_EvalIsOneStandpointAndASecondOneProvesTheInductionRuleIsStrictlyStrongerThanTheRewriteClosure.agda
formal/cubical/theorems/residue/Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource.agda
formal/cubical/YugapatSankramana_IndependentTransportsFillASquareAndNeedNoGlobalOrder.agda
formal/cubical/theorems/logic/SetBaseNoMonodromy.agda
formal/cubical/theorems/residue/RelationalTensorObstructionBridge.agda
formal/cubical/theorems/primes/pair_field/CycleHolonomy.agda
formal/cubical/theorems/primes/pair_field/LawvereDiagonal.agda
formal/cubical/theorems/primes/pair_field/PairCoordinates.agda
formal/cubical/theorems/primes/pair_field/PairComposition.agda
formal/cubical/theorems/primes/pair_field/PairConic.agda
formal/cubical/theorems/primes/pair_field/ThreadYoneda.agda
formal/cubical/theorems/number/PrimePairDecompositionCurvature.agda
formal/cubical/theorems/homotopy/CarryObstruction.agda
formal/cubical/theorems/homotopy/GroupCohomologyH2.agda
formal/cubical/theorems/physics/DescentObstructionUnified.agda
formal/cubical/theorems/number/TiryakTantu_ThePhaseAndTheCoefficientFactorThroughTransverseQuotientsOfOneVariable.agda
formal/lean/Pairfield/GoldbachDeterminesZeta.lean
formal/lean/Pairfield/GoldbachReconstructionChain.lean
formal/lean/Pairfield/GoldbachSupportIsThePrimePowerSumPredicate.lean
formal/lean/Pairfield/DivisorBoundaryKloostermanBridge.lean
formal/lean/Pairfield/PrimeChargeUnboundedLocalRank.lean
formal/lean/Pairfield/PrimeChargeKuznetsovRankBridge.lean
formal/lean/Pairfield/CarryCohomologyAdapter.lean
formal/cubical/theorems/residue/NaturalMachine.agda
abstracts/26_the_wheel_is_blind_to_the_zeros_and_the_holonomy_names_the_missing_observable.txt
VYAYA_SESA_TheLocalizationSequenceOfComputation_CostIsTheNonLocalizingResidual.md
35. Handoff to the Next Session
The next session should not begin by asking what the repository is about. It should begin from the invariant map above and continue compositionally.
For hard-problem work, especially RH and prime-pair questions, preserve all established realizations simultaneously. Search the theorem graph for exact adapters among them. Treat every apparent boundary as provisional until its type has been reconstructed from current code. Prefer a short proof obtained by changing representation over a heroic estimate inside a projection already known to be lossy.
When new mathematical structure appears, immediately ask four questions: What is the underlying unprojected object? What maps are being used as readings? What are their fibres/defects? What exact transport identifies this with another known construction?
The collaboration's highest-bandwidth mode is reached when those questions become automatic and the entire repository is treated as one executable mathematical object rather than as a collection of results.
Hold the object. Change the standpoint. Preserve the residual. Transport the witness.

END OF STATE TRANSFER

---

# ORIGINAL S01 — Faithful quartic receiver and NS actual-source continuation separation
Source path: `sources/S01_receiver.md`; SHA-256: `3581964801bb6c6460a4ddea8ed797b8465a26ba84eb1d9666d4374fa22229f5`
Transfer status: Analytical source note; distinct earlier receiver.

# A Faithful Prime-Boundary Receiver and a Navier–Stokes Continuation Obstruction

## Status and dependency boundary

Date: 6 September 2026.

Repository source reads are pinned to commit `64effa62411bad3c12d513b2df5a1e5e55946afb` of `avikj/metacircular-interaction-prototype`. These are mathematical derivations, not newly compiled Agda or Lean modules. The accompanying SymPy scripts verify finite algebraic identities only. Neither the Riemann hypothesis nor global Navier–Stokes regularity is proved here. No novelty-priority claim is made.

The repository inputs inspected are `formal/lean/Pairfield/VonMangoldtTriangularReconstruction.lean`, `GoldbachReconstructionChain.lean`, and `VandermondeFrequencyResponse.lean`; `formal/cubical/theorems/automata/ObservableInterface.agda`; `formal/cubical/theorems/physics/DefectCalculus.agda`; and `formal/cubical/kernel/SankramanaShreni_TheLocalizationSequenceAsOneObjectMeaningDescendsAndCostDoesNot.agda`.

The arithmetic reconstruction theorem supplies the von Mangoldt sequence and its logarithmic-derivative Dirichlet series only in the Euler half-plane. Analytic continuation, the functional equation, the classical explicit formula, and the standard zero-counting bound are separate classical inputs. An authoritative statement of the explicit formula used below is E. Bombieri, *Problems of the Millennium: the Riemann Hypothesis*, §V, Clay Mathematics Institute.

The observer interface preserves observations under a declared relation; state reconstruction is a separate property. In particular, `DefectCalculus.noEquiv→badFibre` has the constructive type “non-equivalence implies that universal fibre contractibility is impossible.” It does not, by itself, select a particular noncontractible fibre. Section 5 below supplies explicit distinct elements in a concrete observation fibre.

## 1. An elementary receiver with a quantified nonvanishing response

Use additive convolution on the real line. Define

\[
q(s)=4\mathbf 1_{[0,1/4]}(s),\qquad b=q*q*q*q,\qquad h(s)=e^{-s}b(s-1).
\]

Then \(b\) is a nonnegative, mass-one, compactly supported cubic B-spline, with support \([0,1]\) and regularity \(C^2\). Thus \(h\) is nonnegative, \(C_c^2(\mathbb R)\), and supported in \([1,2]\). It is piecewise smooth, which is sufficient for the explicit formula and the absolute zero-sum convergence used here. No \(C^\infty\) assumption is needed.

An entirely finite expression is

\[
b(s)=\frac{256}{6}\sum_{j=0}^{4}(-1)^j\binom4j(s-j/4)_+^3.
\]

Let

\[
H(z)=\int_{\mathbb R}h(s)e^{-zs}\,ds.
\]

Taking the Laplace transform of the four convolutions gives the entire function

\[
\boxed{
H(z)=e^{-(z+1)}
\left(\frac{1-e^{-(z+1)/4}}{(z+1)/4}\right)^4.
}
\]

The apparent singularity at \(z=-1\) is removable, with \(H(-1)=1\). Every zero is of the form

\[
z=-1+8\pi i k,\qquad k\in\mathbb Z\setminus\{0\}.
\]

Consequently \(H(z)\ne0\) whenever \(\Re z>-1\), in particular at every shifted nontrivial zeta zero \(\rho-1/2\).

### Proposition 1: quantitative response bounds

There are positive absolute constants \(c,C\) such that

\[
\frac{c}{(1+\gamma^2)^2}
\le |H(\sigma+i\gamma)|
\le \frac{C}{(1+\gamma^2)^2}
\qquad(-1/2\le\sigma\le1/2).
\]

Indeed, write \(a=1+\sigma\in[1/2,3/2]\). Then

\[
1-e^{-1/8}\le |1-e^{-a/4}e^{-i\gamma/4}|\le1+e^{-1/8}.
\]

More explicitly,

\[
\frac{256e^{-3/2}(1-e^{-1/8})^4}{(\gamma^2+9/4)^2}
\le |H(\sigma+i\gamma)|
\le
\frac{256e^{-1/2}(1+e^{-1/8})^4}{(\gamma^2+1/4)^2}.
\]

Thus convolution by \(h\), on the usual Sobolev spaces, is an isomorphism

\[
H^s(\mathbb R)\longrightarrow H^{s+4}(\mathbb R).
\]

This is a quantified inverse with a four-derivative loss. It is not a claim that an unbounded arithmetic input already belongs to a particular global Sobolev space.

### Exact finite response stencil

In distributions,

\[
(D+1)^4h
=256\sum_{j=0}^{4}(-1)^j\binom4j e^{-(1+j/4)}\delta_{1+j/4}.
\]

Equivalently,

\[
H(z)=256e^{-1}e^{-z}(z+1)^{-4}
\left(1-e^{-1/4}e^{-z/4}\right)^4.
\]

The finite response polynomial is exactly \((1-rw)^4\), with \(r=e^{-1/4}\) and \(w=e^{-z/4}\). This is an explicit instance of the repository's frequency-response construction: the phase and real scale factor are retained together. Its nonvanishing follows from \(|rw|<1\) throughout the shifted critical strip. The damping is in the receiver; it changes modal amplitudes, not the scale-growth exponent of a zeta mode.

## 2. The finite arithmetic scale trace

Let \(\Lambda\) be the von Mangoldt function and

\[
R(N)=\sum_{a+b=N}\Lambda(a)\Lambda(b).
\]

The repository supplies the triangular reconstruction

\[
\Lambda(2)=\sqrt{R(4)}=\log2,
\qquad
\Lambda(n)=\frac{R(n+2)-I_n(\Lambda)}{2\log2}\quad(n\ge3),
\]

where \(I_n\) involves only indices smaller than \(n\). Finite induction therefore reconstructs \(\Lambda(2),\ldots,\Lambda(M)\) from \(R(4),\ldots,R(M+2)\). This statement concerns exact quantitative data known to be in the convolution map's image, not arbitrary positive sequences or existence-only Goldbach data.

Define, for real \(t\),

\[
\boxed{
B(t)=\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}h(t-\log n)
-e^{t/2}H(1/2).
}
\]

Only integers in the shell

\[
e^{t-2}\le n\le e^{t-1}
\]

contribute. For \(M(t)=\max\{2,\lfloor e^{t-1}\rfloor\}\), the prefix through \(R(M(t)+2)\) suffices. The complete observation is the trajectory \(t\mapsto B(t)\), not one scalar measured at one time.

### Proposition 2: exact Laplace identity

For \(\Re w>1/2\),

\[
\boxed{
\int_0^\infty e^{-wt}B(t)\,dt
=H(w)\left[-\frac{\zeta'}{\zeta}(1/2+w)\right]
-\frac{H(1/2)}{w-1/2}.
}
\]

For each summand, substitute \(s=t-\log n\). Its integral is \(n^{-w}H(w)\). Absolute convergence in the indicated half-plane permits interchange with the von Mangoldt Dirichlet series. Integrating the subtracted exponential gives the last term. This derivation uses only the Euler half-plane identity. The pole at \(w=1/2\) cancels.

The complete trajectory also reconstructs the arithmetic Dirichlet series:

\[
-\frac{\zeta'}{\zeta}(s)
=
\frac{\mathcal L B(s-1/2)+H(1/2)/(s-1)}{H(s-1/2)}
\qquad(\Re s>1).
\]

Uniqueness of Dirichlet coefficients then recovers \(\Lambda\), hence \(R\). This is a lossless whole-trajectory statement, not a finite-data inversion of the infinite arithmetic sequence.

## 3. Exact off-critical growth and a single-receiver RH criterion

Let \(\rho\) range over distinct nontrivial zeros, with multiplicity \(m_\rho\). Define

\[
\Theta=\sup_\rho\Re\rho.
\]

The classical location and symmetry theorems give \(1/2\le\Theta\le1\).

### Proposition 3: smoothed explicit formula with all trivial terms retained

For \(t>2\),

\[
\boxed{
B(t)=
-\sum_\rho m_\rho H(\rho-1/2)e^{(\rho-1/2)t}
-\sum_{k=1}^\infty H(-2k-1/2)e^{(-2k-1/2)t}.
}
\]

Both series are absolutely convergent at each such \(t\).

To obtain this directly from Weil's formula, use

\[
f_t(x)=x^{-1/2}h(t-\log x).
\]

Its support is contained in \((1,\infty)\), and its Mellin transform is

\[
\widetilde f_t(s)=e^{(s-1/2)t}H(s-1/2).
\]

The terms \(f_t(1/n)\) and \(f_t(1)\) vanish. The archimedean integral becomes

\[
\int_1^\infty\frac{f_t(x)}{x-x^{-1}}\,dx
=\sum_{k=0}^\infty\widetilde f_t(-2k).
\]

Its \(k=0\) term cancels the \(\widetilde f_t(0)\) term on the other side of Weil's formula. The remaining terms give exactly the displayed identity. Thus no archimedean or trivial-zero contribution has been silently discarded.

The nontrivial-zero series converges absolutely because Proposition 1 gives a fourth-order vertical decay and the number of zeros through height \(T\) is \(O(T\log T)\). For the trivial zeros, support in \([1,2]\) gives

\[
\left|\sum_{k\ge1}H(-2k-1/2)e^{(-2k-1/2)t}\right|
\le
\|h\|_1\frac{e^{-(5/2)(t-2)}}{1-e^{-2(t-2)}}.
\]

In particular, this term is bounded for \(t\ge3\) and decays exponentially.

### Theorem 4: exact growth exponent

\[
\boxed{
\limsup_{t\to\infty}\frac{\log(1+|B(t)|)}{t}
=\Theta-\frac12.
}
\]

**Upper bound.** Proposition 3 and absolute summability give

\[
|B(t)|\le C_0e^{(\Theta-1/2)t}+C_1e^{-(5/2)(t-2)}
\quad(t\ge3).
\]

**Lower bound.** If the displayed limsup were smaller than \(\Theta-1/2\), choose a nonnegative number \(c\) strictly between them. Then \(B(t)=O(e^{ct})\), so its Laplace transform is holomorphic in \(\Re w>c\). Proposition 2 identifies this holomorphic function with a meromorphic function. By the definition of the supremum, some zero satisfies \(\Re\rho-1/2>c\). The meromorphic expression has there a pole at \(w=\rho-1/2\) with residue

\[
-m_\rho H(\rho-1/2)\ne0.
\]

This contradicts holomorphy. No rightmost zero is assumed to attain the supremum. When \(\Theta=1/2\), the nonnegative limsup and the upper bound already give equality.

### Corollary 5: equivalent forms of RH

\[
\boxed{
\mathrm{RH}
\iff B(t)=O(1)
\iff \forall\varepsilon>0,\ B(t)=O_\varepsilon(e^{\varepsilon t}).
}
\]

Subexponential growth forces \(\Theta=1/2\), and the functional equation excludes zeros to the left as well. Conversely, on RH the nontrivial-zero series in Proposition 3 is an absolutely and uniformly convergent sum of pure phases; hence it is bounded.

### Corollary 6: recovery of the zero multiset under RH

On RH,

\[
B(t)=-\sum_\gamma m_\gamma H(i\gamma)e^{i\gamma t}+o(1).
\]

The first term is uniformly almost periodic. For every real \(\omega\),

\[
\lim_{T\to\infty}\frac1T\int_0^T B(t)e^{-i\omega t}\,dt
=
\begin{cases}
-m_\omega H(i\omega),&\zeta(1/2+i\omega)=0,\\
0,&\text{otherwise}.
\end{cases}
\]

Uniform summability justifies exchanging the average and series; the trivial-zero remainder contributes zero to the limiting average. Since \(H(i\omega)\ne0\), all ordinates and multiplicities are recovered. The response attenuation is quantitatively fourth order, rather than an uncontrolled smoothing loss.

These are exact reconstruction and obstruction results. They do not establish the missing bound \(B(t)=O(1)\) from the arithmetic input.

## 4. The receiver is one fixed boundary profile of the finite prime operator

On \(L^2([0,t])\), extend functions by zero and let

\[
(S_af)(x)=\mathbf1_{[0,t]}(x-a)f(x-a),
\qquad
P_t=\sum_{\log n<t}\frac{\Lambda(n)}{\sqrt n}
(S_{\log n}+S_{\log n}^*).
\]

Define the real boundary profile

\[
f(s)=e^{-s}(q*q)(s-1/2).
\]

Its support is \([1/2,1]\), and \(h=f*f\). Place it at the two ends by

\[
(J_t^-f)(x)=f(x),\qquad(J_t^+f)(x)=f(t-x).
\]

For \(t>2\), the supports are separated. The reverse-shift contribution is zero, while direct substitution gives

\[
\langle J_t^+f,S_aJ_t^-f\rangle=h(t-a).
\]

Consequently

\[
\boxed{
B(t)=\langle J_t^+f,P_tJ_t^-f\rangle-e^{t/2}H(1/2).
}
\]

The same fixed profile is used at both boundaries, for every scale. The pole term is the rank-one boundary contribution because \(H(1/2)=F(1/2)^2\), where \(F\) is the Laplace transform of \(f\). The result identifies a specific matrix coefficient; it does not infer a global operator-norm bound or an unconditional self-adjoint realization of the zeta zeros from that coefficient.

## 5. Navier–Stokes: positive detection is not pairwise reconstruction

### Lemma 7: the secant criterion

For a linear map \(O:V\to W\) and subset \(C\subseteq V\),

\[
O|_C\text{ is injective}
\iff \ker O\cap(C-C)=\{0\}.
\]

This follows by writing \(O(c_1)=O(c_2)\) as \(c_1-c_2\in\ker O\). It is stronger than \(\ker O\cap C=\{0\}\). For the cone of positive semidefinite matrices, every symmetric matrix is a difference of two positive semidefinite matrices. A positive-cone kernel theorem therefore does not automatically prove full reconstruction on the cone.

### Theorem 8: explicit realizable positive stresses with identical scalar observations and different coarse futures

Work on the normalized torus \((\mathbb R/2\pi\mathbb Z)^3\), with viscosity \(\nu>0\), amplitude \(A>0\), integer \(N\ge2\), and \(\sigma\in\{+1,-1\}\). Take

\[
u^\sigma(x,0)=A e_2\cos(Nx_1)
+\sigma A e_3\cos(x_2-Nx_1).
\]

These divergence-free initial data generate explicit globally smooth triangular solutions. Set

\[
a(x_1,t)=Ae^{-\nu N^2t}\cos(Nx_1),
\]

and solve the linear advection–diffusion equation

\[
\partial_tv+a(x_1,t)\partial_2v
=\nu(\partial_1^2+\partial_2^2)v,
\qquad v(x_1,x_2,0)=A\cos(x_2-Nx_1).
\]

Then \(u^\sigma=(0,a,\sigma v)\), with constant pressure, solves unforced three-dimensional Navier–Stokes. The coefficient \(a\) is globally smooth and bounded, and the scalar linear equation has a global smooth periodic solution. Direct substitution verifies the reduction. This construction is not a singular solution and involves different fine initial data.

Let \(P=P_{\le1}\) be the exact Fourier projection and \(U^\sigma=Pu^\sigma\). At time zero,

\[
U^+=U^-=0.
\]

The resolved stresses are

\[
\boxed{
R^\sigma=P(u^\sigma\otimes u^\sigma)-U^\sigma\otimes U^\sigma
=\frac{A^2}{2}
\begin{pmatrix}
0&0&0\\
0&1&\sigma\cos x_2\\
0&\sigma\cos x_2&1
\end{pmatrix}.
}
\]

This formula follows from the two cosine-square identities and the cross-frequency relation \((N,0,0)+(-N,1,0)=(0,1,0)\). The eigenvalues are \(0\) and \((A^2/2)(1\pm\cos x_2)\); both stresses are pointwise positive semidefinite. A sharp Fourier projection does not produce positive covariance for every input; positivity is verified explicitly for this example.

At time zero both states have the same coarse velocity, pressure, active-pressure source, stress trace, and resolved energy flux:

\[
U^\sigma=0,\quad p^\sigma=0,\quad
\partial_i\partial_jR^\sigma_{ij}=0,\quad
\operatorname{tr}R^\sigma=A^2,\quad
-R^\sigma:\nabla U^\sigma=0.
\]

Nevertheless,

\[
\nabla\cdot R^\sigma=-\frac{\sigma A^2}{2}e_3\sin x_2
\]

is already solenoidal and resolved. The filtered momentum equation gives

\[
\boxed{
\partial_tU^\sigma(0)=\frac{\sigma A^2}{2}e_3\sin x_2.
}
\]

Thus the two positive stresses occupy the same scalar-observation fibre but determine opposite coarse accelerations. Their difference is an indefinite secant direction. There is no contradiction with a theorem detecting each nonzero positive stress relative to zero: the common energy reading is positive, not zero.

The fine scalar energy densities and dissipation densities of these two solutions agree even at later times, because their velocities differ only by the sign of the third component. No uniqueness failure for the same full initial datum is asserted.

### An explicit continuation receiver

Choose the divergence-free resolved test

\[
w(x)=e_3\sin x_2.
\]

Normalized integration gives

\[
\langle\partial_tU^\sigma(0),w\rangle=\frac{\sigma A^2}{4},
\qquad
\int(R^+-R^-):\nabla w\,dx=\frac{A^2}{2}\ne0.
\]

This is a concrete contextual separator. On the two-element domain of these solutions, the common scalar observation identifies both points, whereas the two-valued acceleration-sign reading separates them. That is a direct mathematical instance of the repository's descent/non-descent mechanism.

More generally, for the finite-dimensional space \(H_K\) of resolved divergence-free vector fields,

\[
\sup_{w\in H_K,\ \|w\|_2\le1}
\left|\int R:\nabla w\,dx\right|
=\|\mathbb P P_{\le K}\nabla\cdot R\|_2.
\]

The equality is integration by parts followed by Hilbert-space duality. The right side is the complete resolved solenoidal forcing, not the full stress. Adding these tests therefore reconstructs precisely the dynamically relevant instantaneous forcing quotient; it does not by itself control the time evolution of the unresolved stress.

## 6. Renormalized ancestry includes the scaling of the budget

Under parabolic blow-up rescaling around \((x_0,T_*)\),

\[
u_r(x,s)=r\,u(x_0+rx,T_*+r^2s),
\qquad p_r(x,s)=r^2p(x_0+rx,T_*+r^2s).
\]

Its gradient is \(r^2\nabla u\), and the space–time Jacobian is \(r^{-5}\). Consequently

\[
\boxed{
\int_{Q_1}|\nabla u_r|^2\,dx\,ds
=\frac1r\int_{Q_r}|\nabla u|^2\,dx\,dt.
}
\]

With compatible filtering, stresses, solenoidal forces, and fluxes scale respectively as \(r^2\), \(r^3\), and \(r^4\); integrated flux has the same \(r^{-1}\) prefactor as integrated dissipation.

A fixed positive normalized observation at scale \(r_j=2^{-j}\) therefore costs only order \(r_j\) in the physical dissipation budget. The sum \(\sum_jr_j\) is finite. Merely detecting a nonzero normalized event on every scale cannot contradict finite physical dissipation.

An explicit measure demonstrates the logical point. In \(Q_1=B_1\times(-1,0)\), let

\[
d\mu=(|x|^2+|t|)^{-2}\,dx\,dt.
\]

It is a finite positive measure with \(\mu(Q_1)=\pi^2\), and satisfies exactly

\[
\mu(Q_r)=r\mu(Q_1),\qquad0<r\le1.
\]

Hence every normalized reading \(r^{-1}\mu(Q_r)\) is the same positive number although the total measure is finite. This is not an NS-realizability claim. It refutes an inference from finite measure alone, and isolates the additional scale-critical depletion or rigidity input that a regularity argument needs.

## 7. Resulting theorem graph

The RH branch is

\[
\text{quantitative pairfield prefix}
\longrightarrow\Lambda\text{ prefix}
\longrightarrow\text{fixed boundary receiver trace }B
\longrightarrow\text{exact spectral growth exponent }\Theta-1/2.
\]

The receiver is explicitly nonvanishing and quantitatively invertible. The decisive remaining arithmetic estimate is \(B(t)=O(1)\), equivalently subexponential growth for every positive exponent. Its proof is not supplied by lossless reconstruction or by the receiver's multiplier bounds.

The NS branch is

\[
\text{fine solution}
\longrightarrow\text{positive stress and scalar observations}
\longrightarrow\text{realizable secant fibre}
\longrightarrow\text{solenoidal continuation response}.
\]

The explicit pair proves that scalar positive-defect detection is insufficient for continuation reconstruction. The adjoint tests repair the instantaneous forcing observation, but a singularity exclusion still requires a scale-compatible estimate controlling coherent nonlinear evolution and its correctly rescaled budgets. No emptiness theorem for the complete singular continuation fibre is established here.


---

# ORIGINAL S02 — Autocorrelation two-packet Weil criterion and exact triangular NS memory
Source path: `sources/S02_two_packet.md`; SHA-256: `9f945e269f69961766fa3b7291f4ea365878b4739c263a1596b10b5cb42d69c8`
Transfer status: Analytical source note; principal later Z/G/M0 definitions.

# Dissipative Continuation Memory and a Complete Two-Packet Weil Test

**Date:** 6 September 2026.

## Scope

This note develops two extensions of the preceding prime-receiver and Navier–Stokes observer calculations. The first is an exact arbitrary-depth continuation-separation theorem inside a globally smooth, unforced Navier–Stokes class, together with quantitative bounds and a passive memory realization. The second is a fixed two-packet specialization of the Weil positivity criterion, with a nonvanishing multiplier and an unconditionally positive, prime-free diagonal.

The arguments are mathematical derivations. They are not newly compiled Agda/Lean modules, and no originality-priority assertion is made. The accompanying executable verifies finite algebraic identities. Neither general three-dimensional Navier–Stokes regularity nor the Riemann hypothesis is established.

Repository reads are pinned to `64effa62411bad3c12d513b2df5a1e5e55946afb`. The relevant verified-source constructions are `MergingASeparatedPairBreaksAtTheSeparatingContinuation.agda` and `FutureSeparation.agda`. The former takes a separating continuation as input and rules out a decoder on a compression that merges its two source states. The latter distinguishes a witnessed finite separator from merely negated future equivalence. The present PDE construction supplies actual separating witnesses, not an inference from abstract non-equivalence alone.

## 1. An exact globally smooth class

Work on the normalized torus \((\mathbb R/2\pi\mathbb Z)^3\). Let \(\nu>0\), \(N\ge2\) and \(m\ge1\) be integers, and let \(A,C>0\). Define

\[
a(x_1,t)=A e^{-\nu N^2t}\cos(Nx_1).
\]

Let \(v\) solve

\[
v_t+a(x_1,t)v_{x_2}=\nu(v_{x_1x_1}+v_{x_2x_2}),
\qquad v(x_1,x_2,0)=C\cos(x_2-mNx_1).
\]

Then, for \(\sigma\in\{+1,-1\}\),

\[
u^\sigma=(0,a,\sigma v),\qquad p^\sigma=0
\]

solves unforced three-dimensional incompressible Navier–Stokes. Indeed, the divergence is zero; the second component solves the heat equation; the only nonzero convective term is \(\sigma a v_{x_2}\) in the third component; and that component has no \(x_3\) dependence, so its divergence is zero and pressure may be identically zero.

These solutions are smooth for all finite times. The coefficient \(a\) is smooth and bounded with all derivatives on each finite time interval. Differentiating the linear scalar equation, integrating by parts, and inducting in Sobolev order gives finite bounds at every order. This is a direct global existence argument for this triangular class, not an appeal to general 3D regularity.

## 2. Arbitrarily deep matching jets and a specified first separation

Let \(P=P_{\le1}\) be Fourier projection onto integer wavevectors of Euclidean length at most one, and set \(U^\sigma=Pu^\sigma\). Write

\[
v(x_1,x_2,t)=\Re\left[e^{ix_2}\sum_{k\in\mathbb Z}c_k(t)e^{ikNx_1}\right],
\qquad c_k(0)=C\delta_{k,-m}.
\]

The exact coefficient equations are

\[
\dot c_k=-\nu(1+N^2k^2)c_k-
\frac{iA e^{-\nu N^2t}}2(c_{k-1}+c_{k+1}).
\tag{2.1}
\]

The resolved velocity is

\[
U^\sigma(x,t)=\sigma e_3\Re[c_0(t)e^{ix_2}].
\]

### Theorem 2.1: arbitrary-depth jet separation

For every \(m\ge1\),

\[
c_0^{(j)}(0)=0\quad(0\le j<m),
\qquad c_0^{(m)}(0)=C\left(-\frac{iA}{2}\right)^m.
\tag{2.2}
\]

Consequently,

\[
\partial_t^jU^+(0)=\partial_t^jU^-(0)=0\quad(j<m),
\]

but

\[
\partial_t^mU^\sigma(x,0)=
\sigma C\left(\frac A2\right)^m e_3
\cos\left(x_2-\frac{m\pi}{2}\right).
\tag{2.3}
\]

**Proof.** A coupling in (2.1) moves the Fourier index by exactly one. Diffusion does not move it. Explicit time differentiation of the coupling coefficient also does not add an extra index move. Reaching index zero from \(-m\) therefore requires at least \(m\) coupling operations. At derivative order exactly \(m\), every operation must be a coupling and every move must be to the right. This unique word has coefficient \((-iA/2)^m\). An equivalent formal induction uses the Leibniz recursion

\[
c_k^{(r+1)}(0)=-\nu(1+N^2k^2)c_k^{(r)}(0)
-\frac{iA}{2}\sum_{\ell=0}^r\binom r\ell(-\nu N^2)^\ell
\bigl(c_{k-1}^{(r-\ell)}(0)+c_{k+1}^{(r-\ell)}(0)\bigr).
\]

This proves (2.2). Since the solutions are smooth through time zero, the nonzero leading derivative also proves that their resolved futures differ for all sufficiently small positive times. ∎

### Resolved stress jets also agree to arbitrary prescribed order

Define the exact stress

\[
R^\sigma=P(u^\sigma\otimes u^\sigma)-U^\sigma\otimes U^\sigma.
\]

The only sign-sensitive entries are the \((2,3)\) and \((3,2)\) entries, coming from \(P(av)\). Their low mode requires \(v\) to reach Fourier index \(\pm1\), which takes at least \(m-1\) couplings. Thus

\[
\partial_t^jR^+(0)=\partial_t^jR^-(0)
\qquad(0\le j\le m-2).
\tag{2.4}
\]

For any fixed jet depth \(J\), taking \(m=J+2\) therefore gives two globally smooth solutions with the same initial resolved-velocity and resolved-stress jets through order \(J\), and different resolved futures.

This refutes a universal closure based only on those specified finite initial jets. It does not refute every possible finite-dimensional encoding, does not assert equality of all possible observables, and does not assert equality of observation histories on a nontrivial time interval.

### Scalar readings can agree for the entire future

The sign change \(v\mapsto-v\) preserves the full pointwise fields \(|u|^2\) and \(|\nabla u|^2\). It also preserves \(|U|^2\), \(\operatorname{tr}R\), and the scalar resolved energy flux \(-R:\nabla U\). Pressure is zero for both solutions at all times.

The velocity gradient is

\[
\nabla u^\sigma=
\begin{pmatrix}
0&0&0\\
a_{x_1}&0&0\\
\sigma v_{x_1}&\sigma v_{x_2}&0
\end{pmatrix}.
\]

It is nilpotent. Consequently, with the usual velocity-gradient invariants,

\[
Q_{\rm inv}=-\tfrac12\operatorname{tr}((\nabla u)^2)=0,
\qquad R_{\rm inv}=-\det(\nabla u)=0
\]

for both solutions, at every space–time point. These equalities do not prevent the explicit continuation separation in (2.3).

## 3. Quantitative suppression of the hidden continuation

Let

\[
\beta(t)=\int_0^t A e^{-\nu N^2s}\,ds
=\frac{A}{\nu N^2}(1-e^{-\nu N^2t}).
\]

For integer \(m\ge0\), define

\[
I_m(b)=\sum_{r=0}^\infty
\frac{(b/2)^{m+2r}}{r!(m+r)!}.
\]

This is the modified Bessel function, but the displayed convergent series is the only fact about it needed below.

### Theorem 3.1: uniform viscous continuation bound

\[
|c_0(t)|\le C e^{-\nu t}I_m(\beta(t))
\tag{3.1}
\]

and independently

\[
|c_0(t)|\le C e^{-\nu t}.
\tag{3.2}
\]

In particular,

\[
|c_0(t)|\le C e^{-\nu t}
\min\left\{1,
\frac{(\beta(t)/2)^m}{m!}
\exp\left(\frac{\beta(t)^2}{4(m+1)}\right)\right\}.
\tag{3.3}
\]

**Proof of (3.1).** Expand the evolution of (2.1) by time-ordered Duhamel iteration, using the diagonal heat operator as the free evolution. A path of length \(n\) contributes at most

\[
C e^{-\nu t}\frac{\beta(t)^n}{2^n n!}.
\]

All heat factors combine to at most \(e^{-\nu t}\), since every diagonal decay rate is at least \(\nu\). The time-ordered product of the nonnegative amplitudes integrates to \(\beta(t)^n/n!\).

A path from \(-m\) to zero has length \(m+2r\), with \(r\) left moves and \(m+r\) right moves. There are \(\binom{m+2r}{r}\) such paths. Summing their absolute upper bounds yields exactly (3.1). The argument is uniform on finite Fourier truncations and passes to the bounded-perturbation evolution on \(\ell^2(\mathbb Z)\).

**Proof of (3.2).** The off-diagonal part of (2.1) is skew-adjoint. Therefore

\[
\frac12\frac d{dt}\sum_k|c_k|^2
=-\nu\sum_k(1+N^2k^2)|c_k|^2
\le-\nu\sum_k|c_k|^2.
\]

The initial norm is \(C\), proving (3.2).

Finally, \((m+r)!\ge m!(m+1)^r\) in the series for \(I_m\), giving (3.3). ∎

The asymptotic at zero is

\[
c_0(t)=\frac{C(-iA/2)^m}{m!}t^m+o(t^m),
\]

so the order of the path bound agrees with the exact first visible derivative.

**Consequence.** Arbitrarily many invisible derivatives do not imply an arbitrarily long physical memory. In this class, the relevant interaction amplitude is bounded by \(A/(\nu N^2)\), and distant hidden modes have factorially small influence on the fixed resolved mode. This is an actual stability estimate, not merely a statement that an inverse is unavailable.

For an arbitrary initial coefficient vector supported on \(|k|\ge m\), the same entrywise path bounds and Cauchy–Schwarz give the further estimate

\[
|c_0(t)|\le e^{-\nu t}\|c(0)\|_{\ell^2}
\left(2\sum_{k=m}^\infty I_k(\beta(t))^2\right)^{1/2}.
\tag{3.4}
\]

## 4. Exact non-Markovian closure and retained energy

Let \(x=c_0\), \(y=Qc\), where \(Q\) removes index zero. Let \(D\) be diagonal with entries \(1+N^2k^2\), and \(T\) the nearest-neighbor adjacency operator. Set

\[
L(t)=-\nu D-\frac{i\alpha(t)}2T,
\qquad \alpha(t)=Ae^{-\nu N^2t}.
\]

In resolved/fine blocks,

\[
\dot x=-\nu x+B(t)y,
\qquad \dot y=C(t)x+L_Q(t)y,
\qquad C(t)=-B(t)^*.
\tag{4.1}
\]

Here \(\|B(t)\|=\|C(t)\|=|\alpha(t)|/\sqrt2\).

Let \(V_Q(t,s)\) denote the homogeneous propagator generated by \(L_Q(t)=QL(t)Q\). Since every fine index satisfies \(|k|\ge1\),

\[
\|V_Q(t,s)\|\le e^{-\nu(1+N^2)(t-s)}.
\tag{4.2}
\]

Variation of constants gives the exact resolved equation

\[
\dot x(t)=-\nu x(t)+\eta(t)
+\int_0^t K(t,s)x(s)\,ds,
\tag{4.3}
\]

where

\[
\eta(t)=B(t)V_Q(t,0)y(0),
\qquad K(t,s)=B(t)V_Q(t,s)C(s).
\tag{4.4}
\]

The first term retains the original fine-state information. Deleting it would identify the initial sign-pair constructed in Section 2 and destroy exact continuation reconstruction.

### Quantitative memory bounds

\[
|K(t,s)|\le
\frac{|\alpha(t)\alpha(s)|}{2}
 e^{-\nu(1+N^2)(t-s)}
=rac{\alpha(s)^2}{2}
 e^{-\nu(1+2N^2)(t-s)}.
\tag{4.5}
\]

Consequently,

\[
\int_s^\infty |K(t,s)|\,dt
\le\frac{\alpha(s)^2}{2\nu(1+2N^2)}.
\tag{4.6}
\]

Also,

\[
|\eta(t)|\le
\frac{A}{\sqrt2}e^{-\nu(1+2N^2)t}\|y(0)\|.
\tag{4.7}
\]

Thus a valid exponential memory timescale is

\[
\tau_N=\frac1{\nu(1+2N^2)}.
\]

This is a bound on the specified class and specified resolved/fine split, not a universal turbulence-memory theorem.

### Theorem 4.1: integrated passivity of the memory

For any prescribed continuous resolved path \(x\), let \(y_x\) solve

\[
\dot y_x=L_Q(t)y_x+C(t)x(t),\qquad y_x(0)=0.
\]

Then

\[
\boxed{
\int_0^T\Re\left[
\overline{x(t)}\int_0^t K(t,s)x(s)\,ds\right]dt
=-\frac12\|y_x(T)\|^2
-\nu\int_0^T\langle Dy_x(t),y_x(t)\rangle dt\le0.
}
\tag{4.8}
\]

**Proof.** The fine energy identity is

\[
\tfrac12\frac d{dt}\|y_x\|^2
=-\nu\langle Dy_x,y_x\rangle+
\Re\langle y_x,Cx\rangle.
\]

Since \(C=-B^*\), the last term equals \(-\Re(\bar x By_x)\). Substitute the variation-of-constants expression for \(y_x\) and integrate. ∎

The memory can produce instantaneous backscatter. Formula (4.8) does not assert a pointwise sign of \(K(t,s)\). It proves the required sign for the accumulated quadratic work when the induced fine response starts from zero. Nonzero initial fine energy appears separately in \(\eta\).

This is the exact linear nonautonomous memory-elimination construction used in Mori–Zwanzig and generalized Langevin methods. The present additional information is the explicit PDE realization, the delay hierarchy, the path bound, and the quantified fine propagator for this class.

## 5. The precise term obstructing transfer to general NS secants

For two smooth NS solutions with the same viscosity and forcing, set

\[
z=u_1-u_2,\qquad \bar u=\frac{u_1+u_2}{2}.
\]

Their difference obeys

\[
z_t+\bar u\cdot\nabla z+z\cdot\nabla\bar u+\nabla\pi=\nu\Delta z,
\qquad \nabla\cdot z=0.
\]

Therefore

\[
\boxed{
\frac12\frac d{dt}\|z\|_2^2
+\nu\|\nabla z\|_2^2
=-\int z^\mathsf T S(\bar u)z\,dx,
\qquad S(\bar u)=\tfrac12(\nabla\bar u+\nabla\bar u^\mathsf T).
}
\tag{5.1}
\]

In the sign-pair of Section 1, \(z\) points in the third coordinate and \(S_{33}(\bar u)=0\). The strain pairing in (5.1) vanishes identically. That is why the skew-adjoint transfer and diffusion argument is valid there.

For the general problem this pairing is indefinite. In particular, the same Hilbert norm does not automatically make the fine propagator contractive.

For a fixed high-frequency orthogonal projection whose range has spatial frequencies of magnitude at least \(K\), the homogeneous projected linearized evolution does satisfy the explicit upper bound

\[
\|V_Q(t,s)\|
\le\exp\left[-\nu K^2(t-s)
+\int_s^t\|S(\bar u(\tau))^-\|_{L^\infty,\mathrm{op}}\,d\tau\right],
\tag{5.2}
\]

where \(S^-\) is the positive semidefinite negative part of the symmetric matrix. This follows directly from (5.1), Poincaré on the high-frequency range, and Grönwall. It is an estimate for a specified projected secant equation along already smooth trajectories, not an a priori bound on the strain integral.

Thus lifting the passive-memory proof to arbitrary NS requires controlling the signed strain interaction, or a stronger structure that implies such control. Neither equality of \(Q_{\rm inv},R_{\rm inv}\) nor positive energy readings supplies that estimate.

## 6. An elementary autocorrelation receiver for the Weil form

Use additive convolution. Let

\[
q(s)=4\mathbf1_{[0,1/4]}(s),
\qquad f(s)=e^{-4s}(q*q)(s),
\qquad g=f*\widetilde f,\quad \widetilde f(s)=f(-s).
\tag{6.1}
\]

Then \(f\) is real, nonnegative, continuous and piecewise smooth, supported on \([0,1/2]\), and belongs to \(H^1\). The autocorrelation \(g\) is real, nonnegative, even, \(C_c^2\), and supported in \([-1/2,1/2]\).

Define

\[
F(z)=\int f(s)e^{-zs}\,ds
=16\frac{(1-e^{-(z+4)/4})^2}{(z+4)^2},
\]

and

\[
\boxed{
G(z)=\int g(s)e^{-zs}\,ds=F(z)F(-z)
=256\frac{(1-2e^{-1}\cosh(z/4)+e^{-2})^2}{(16-z^2)^2}.
}
\tag{6.2}
\]

Apparent singularities are removable. The zeros lie on \(\Re z=\pm4\) at nonzero integer multiples of \(8\pi\) in the imaginary coordinate. Hence

\[
G(z)\ne0\qquad(|\Re z|\le1/2).
\tag{6.3}
\]

For real \(\gamma\),

\[
\boxed{
G(i\gamma)=256
\frac{|1-e^{-1-i\gamma/4}|^4}{(16+\gamma^2)^2}>0.
}
\tag{6.4}
\]

Uniformly for \(|\sigma|\le1/2\),

\[
|G(\sigma+i\gamma)|\asymp(1+\gamma^2)^{-2}.
\tag{6.5}
\]

Thus the receiver preserves every potential off-critical zero mode, has a four-derivative inverse loss in Sobolev norms, and has strictly positive real-frequency weights.

### Lemma 6.1: unconditional sector positivity

\[
\Re G(\sigma+i\gamma)>0
\qquad(|\sigma|\le1/2,\ \gamma\in\mathbb R).
\tag{6.6}
\]

**Proof.** Put \(r=e^{-1}\), \(z=\sigma+i\gamma\), and

\[
D(z)=1-2r\cosh(z/4)+r^2.
\]

The elementary estimates

\[
r<37/100,\qquad
\cosh(1/8)-1<1/125,\qquad
\sinh(1/8)<63/500
\]

give

\[
\Re D(z)\ge19549/50000,
\qquad |\Im D(z)|\le4662/50000.
\]

Hence \(|\arg D(z)|<6/25\). Also,

\[
\Re(16-z^2)\ge63/4+\gamma^2,
\qquad |\Im(16-z^2)|\le|\gamma|,
\]

so

\[
|\arg(16-z^2)|<13/100.
\]

Therefore

\[
|\arg G(z)|<2(6/25+13/100)=37/50<\pi/2.
\]

The series bounds used above are elementary: \(\sum_{j=0}^4 1/j!>100/37\); the tail-ratio bounds for the hyperbolic series give \(\cosh(1/8)-1<(1/128)/(1-1/768)<1/125\) and \(\sinh(1/8)<(1/8)/(1-1/384)<63/500\). ∎

## 7. The complete two-packet criterion

Let \(z_\rho=\rho-1/2\), with \(\rho\) ranging over distinct nontrivial zeta zeros and \(m_\rho\) their multiplicities. Set

\[
\mathcal Z(t)=\sum_\rho m_\rho G(z_\rho)e^{z_\rho t},
\qquad M=\mathcal Z(0).
\tag{7.1}
\]

The zero-location theorem, functional-equation symmetries and the standard \(O(T\log T)\) zero count imply that the sum converges absolutely on compact real \(t\)-intervals and that \(\mathcal Z\) is real and even. Lemma 6.1 gives

\[
M>0
\]

without RH, since the real parts of all summands at zero are strictly positive.

### A prime-free expression for the diagonal

Let \(\psi_\Gamma=\Gamma'/\Gamma\) denote the digamma function. The Weil explicit formula gives

\[
\boxed{
M=2G(1/2)+\frac1\pi\int_0^\infty
\left[\Re\psi_\Gamma(1/4+i\gamma/2)-\log\pi\right]
G(i\gamma)\,d\gamma.
}
\tag{7.2}
\]

There is no prime sum: \(g(\pm\log n)=0\) for every \(n\ge2\), because \(1/2<\log2\). The integral converges absolutely by (6.4) and logarithmic growth of the digamma function. Thus the diagonal is fixed independently of any large prime prefix.

### Theorem 7.1: two fixed packet shapes suffice

The following are equivalent:

\[
\mathrm{RH};
\tag{7.3a}
\]

\[
\begin{pmatrix}M&\mathcal Z(t)\\\mathcal Z(t)&M\end{pmatrix}\succeq0
\quad\text{for every }t\in\mathbb R;
\tag{7.3b}
\]

\[
|\mathcal Z(t)|\le M\quad\text{for every }t\in\mathbb R;
\tag{7.3c}
\]

\[
W\bigl((f+cT_tf)*\widetilde{(f+cT_tf)}\bigr)\ge0
\quad\text{for every }t\in\mathbb R,\ c\in\mathbb C,
\tag{7.3d}
\]

where \(T_tf(s)=f(s-t)\), tilde includes complex conjugation for complex inputs, and \(W\) is the centered Weil distribution with convention

\[
W(\phi)=\sum_\rho m_\rho\int\phi(s)e^{z_\rho s}\,ds.
\]

The admissible \(H^1\) piecewise smooth packets can equivalently be obtained by approximation from smooth compactly supported packets; the zero sums are absolutely convergent here.

**Proof of necessity.** Under RH, \(z_\rho=i\gamma\), so (6.4) and absolute convergence give

\[
|\mathcal Z(t)|\le\sum_\rho m_\rho G(i\gamma)=M.
\]

**Proof of sufficiency.** Define

\[
S(t)=\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(t-\log n).
\]

For \(t>1/2\), the explicit formula with its trivial terms retained is

\[
\mathcal Z(t)=e^{t/2}G(1/2)-S(t)-J(t),
\quad
J(t)=\sum_{k\ge1}G(2k+1/2)e^{-(2k+1/2)t}.
\tag{7.4}
\]

The positive remainder satisfies

\[
0<J(t)\le\|g\|_1
\frac{e^{-(5/2)(t-1/2)}}{1-e^{-2(t-1/2)}}.
\tag{7.5}
\]

For \(\Re w>1/2\),

\[
\int_0^\infty e^{-wt}[S(t)-e^{t/2}G(1/2)]dt
=G(w)\left[-\frac{\zeta'}{\zeta}(1/2+w)\right]
-\frac{G(1/2)}{w-1/2}.
\tag{7.6}
\]

All translates \(g(t-\log n)\) are supported in positive \(t\), so no endpoint truncation appears. If \(\mathcal Z\) is bounded, (7.4)–(7.5) make the left integrand in (7.6) bounded on the positive half-line. Its Laplace transform is therefore holomorphic for \(\Re w>0\). A zero with \(\Re\rho>1/2\) would give a pole at \(w=z_\rho\) with nonzero residue \(-m_\rho G(z_\rho)\), contradicting (6.3). Functional-equation symmetry excludes left-of-line zeros as well.

The matrix equivalence is elementary. Expanding (7.3d) gives

\[
M(1+|c|^2)+2\Re(c)\mathcal Z(t),
\]

which is nonnegative for every \(c\) exactly when \(|\mathcal Z(t)|\le M\). ∎

In particular, if RH fails, some test of the form \(f+T_tf\) or \(f-T_tf\) has negative Weil value. This is a completeness statement for one packet shape and its translates, not a proof that those values are nonnegative.

### Exact finite-arithmetic inequality

Combining (7.3c) and (7.4), RH implies and is implied by

\[
\boxed{
\left|
\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(t-\log n)
-e^{t/2}G(1/2)+J(t)
\right|\le M
\quad(t>1/2).
}
\tag{7.7}
\]

For the reverse implication only boundedness on this half-line is needed; compact-time continuity supplies the rest. Only the finite shell

\[
e^{t-1/2}\le n\le e^{t+1/2}
\]

contributes. The constant \(M\) is given by (7.2), and \(J\) is the explicit positive, rapidly convergent archimedean/trivial-zero remainder. The previous unspecified uniform bound is replaced by one fixed tolerance and one fixed two-packet Gram matrix.

The exact growth statement also persists:

\[
\limsup_{t\to\infty}\frac{\log(1+|\mathcal Z(t)|)}{t}
=\sup_\rho\Re\rho-\tfrac12.
\tag{7.8}
\]

The proof is the same absolute-summability upper bound and uncancelled-Laplace-pole lower bound as in the preceding receiver note. No zero is assumed to attain the supremum.

## 8. A finite-height stability estimate

Suppose all nontrivial zeros with \(|\Im\rho|\le T\), where \(T\ge2\), are on the critical line. Let

\[
M_T=\sum_{|\Im\rho|\le T}m_\rho G(i\Im\rho).
\]

Unconditional sector positivity implies \(0\le M_T\le M\). If

\[
|G(\sigma+i\gamma)|\le C_G(1+\gamma^2)^{-2},
\qquad N_*(Y)\le C_NY\log(2+Y),
\]

where \(N_*\) counts both signs and multiplicities, then dyadic summation gives

\[
\sum_{|\Im\rho|>T}m_\rho|G(z_\rho)|
\le\frac{2C_GC_N}{T^3}
\left[\frac87\log(2+T)+\frac{64}{49}\log2\right].
\tag{8.1}
\]

Consequently,

\[
\boxed{
|\mathcal Z(t)|\le M_T+
\frac{2C_GC_Ne^{|t|/2}}{T^3}
\left[\frac87\log(2+T)+\frac{64}{49}\log2\right].
}
\tag{8.2}
\]

For example, an error allowance \(\varepsilon\) is guaranteed whenever the explicit tail term in (8.2) is at most \(\varepsilon\). Suppressing constants, the corresponding range is \(|t|\lesssim6\log T-2\log\log T\). This is a finite-height-to-finite-scale theorem. It neither removes the residual tail nor infers RH from a finite verification.

One may take \(C_G=256(1+e^{-7/8})^4\); the chosen explicit zero-count bound supplies \(C_N\). No present numerical verification height is assumed in this note.

## 9. Established framework and exact boundary of transfer

The Weil positivity criterion and its continuous screw-function realization are existing results. Suzuki's 2023 paper proves that its explicit function \(\Psi\) is bounded if and only if RH holds, and also that pointwise nonnegativity of \(\Psi\) is equivalent to RH. Its significance here is not a newly discovered positivity criterion in general. The new work in this calculation is the specified autocorrelation receiver, sector estimate, fixed two-translate test, prime-free diagonal, and finite-height tail transfer.

Suzuki's 2026 operator framework proves positivity and simplicity of the bottom eigenvalue for sufficiently small support intervals and continuity of that eigenvalue in the interval parameter. Those are local/support-dependent results. They do not establish that the two-packet Gram matrix above remains positive at every separation.

For the NS class, passivity was derived from an already positive Hilbert energy and the exact cross-block identity \(C=-B^*\). For the Weil problem, the corresponding positive Hermitian form is precisely what must be established globally. Importing the NS energy argument without supplying that positivity would assume the desired arithmetic conclusion.

The substantial asymmetry is therefore explicit: a dissipative memory estimate has been proved on the NS class; the RH side has a sharpened and fully specified arithmetic target, not a proved all-scale estimate.

## References and verification

E. Bombieri, *Problems of the Millennium: the Riemann Hypothesis*, especially the explicit-formula and Weil-positivity discussion, Clay Mathematics Institute.

M. Suzuki, *Aspects of the screw function corresponding to the Riemann zeta-function*, Journal of the London Mathematical Society (2023), DOI 10.1112/jlms.12785; arXiv:2206.03682, Theorems 1.3, 1.6, and 1.7.

M. Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2, Theorems 1.3 and 1.4.

A. Gouasmi, E. J. Parish, and K. Duraisamy, *A priori estimation of memory effects in reduced-order models of nonlinear systems using the Mori–Zwanzig formalism*, Proceedings of the Royal Society A (2017), DOI 10.1098/rspa.2017.0385; arXiv:1611.06277.

E. J. Parish and K. Duraisamy, *Non-Markovian Closure Models for Large Eddy Simulations using the Mori–Zwanzig Formalism*, arXiv:1611.03311.

The script `check_algebra.py` verifies exact leading jets and matching stress jets for m=1,...,8, the path-count/Bessel coefficient identity, the nilpotent gradient invariants, finite Fourier cross-block adjoint and dissipativity identities, the response factorization, and the rational sector bounds. These finite checks support but do not replace the all-order analytic proofs above.


---

# ORIGINAL S03 — Common-source quadratic polarization, Beltrami control and coherent CRT histories
Source path: `sources/S03_common_source_quadratic_crt_RECONSTRUCTED.md`; SHA-256: `8f9da4e9603c02ee8abf65e394ed34f06d6e2fb6e659e1f6a3b749f42f1f143e`
Transfer status: Reconstructed from visible user note, not original attachment bytes.

# Reconstructed record: source-coherent quadratic dynamics, actual variations, and CRT histories

Provenance: reconstructed from the visible user-supplied note dated 6 September 2026, comparing repository commit `64effa62411bad3c12d513b2df5a1e5e55946afb`. This is a mathematical reconstruction, not a byte-exact export of the user's message. Its finite companion checks are bundled under `originals/conversation/ns_rh_source_audit/`.

## Quadratic realization fibre

For real vector spaces V,W and a quadratic diagonal Q(x)=b(x,x),

    S_Q(x,y) = (Q(x+y)-Q(x)-Q(y))/2

is symmetric bilinear. Every bilinear realization is uniquely `b=S_Q+a`, with `a` alternating. The realization fibre is the affine space modeled on `Hom(Lambda^2 V,W)`.

For nonzero x0 and any G with G x0=0, choose ell(x0)=1 and set

    a(x,y)=ell(x)G y-ell(y)G x.

Then `a(x0,-)=G`, while the quadratic diagonal is unchanged. Frozen off-source spectra can therefore change arbitrarily on a complement. The true derivative remains

    DQ(x)y=b(x,y)+b(y,x)=2S_Q(x,y).

This algebra does not claim every realization preserves a separately declared control interface or analytic norm.

## NS polarizations and actual variation

For smooth divergence-free fields,

    N(u)=P(u cross curl u)=-P((u dot grad)u),
    A_u v=P(u cross curl v),
    K_u v=P(v cross curl u).

Both satisfy `A_u u=K_u u=N(u)`, but

    DN(u)v=A_u v+K_u v
          =-P((u dot grad)v+(v dot grad)u).

A differentiable solution family therefore has variation

    v_t=nu Delta v+A_u v+K_u v.

Freezing either occurrence alone is not differentiation of the source.

In critical coordinates, Lambda=(-Delta)^(1/2), S=curl Lambda^-1, w=Lambda^(1/2)u,

    C_w v=Lambda^(1/2)P[(Lambda^-1/2 w) cross Lambda^(1/2)v].

The common-source law `C_w Lambda^-1 v=-C_v Lambda^-1 w` gives

    DQ(w)v=C_w S v+C_v S w
           =[C_w S-C_(Lambda S w)Lambda^-1]v.

Both displayed source factorizations reproduce Q on w; their sum is the true derivative.

## Beltrami exact control

On the 2pi torus, `E_lambda={u:curl u=lambda u}`. If u0 belongs to this eigenspace, `N(u0)=0` and

    u(t)=exp(-nu lambda^2 t)u0

is an actual global smooth NS solution. For u,v in the same eigenspace,

    A_u v=lambda P(u cross v),
    K_u v=-lambda P(u cross v),
    DN(u)v=0.

For p=e1, q=e2 and helical vectors

    h_p=(0,1,i)/sqrt2,
    h_q=(-1,0,i)/sqrt2,

plus conjugate negative modes for real fields, the k=p+q output satisfies

    h_p cross h_q=(i,-i,1)/2,
    Pi_-(k)(h_p cross h_q)
      =[i(1-1/sqrt2),-i(1-1/sqrt2),1-sqrt2]/4 !=0.

The frozen A term produces opposite-helicity output; K cancels it exactly. The actual family `exp(-nu t)(u+epsilon v)` remains positive helicity. Unequal curl lengths are a different case.

## Complete variational ancestry

For F(u)=Lu+S_Q(u,u), and mixed parameter derivatives U_I of a differentiable family on a common classical interval,

    d_t U_I = [L+2S_Q(u,-)]U_I
              + sum_(empty!=J proper subset I) S_Q(U_J,U_(I\J)).

For affine initial data U_i(0)=h_i and higher U_I(0)=0. The empty and full product-rule subsets give the true linearized generator. Alternating changes cancel at every order. No convergence of an infinite Taylor series or global continuation is inferred.

## Compatible CRT records

Let `C_m=lcm(1,...,m)`, C0=1, `O_m=Z/C_m Z`, with reduction `r_m:O_(m+1)->O_m`. For `P_n=prod_(m<n)O_m`, define

    (Delta_n x)_m=x_m-r_m(x_(m+1)).

The map

    Phi_n(x)=(x_(n-1), Delta_n x)

is an isomorphism to `O_(n-1) x prod_(m<n-1)O_m`. Its inverse reconstructs downward by `x_m=e_m+r_m(x_(m+1))`. Therefore

    ker Delta_n ~= O_(n-1),
    |ambient histories|=prod_(m<n)C_m,
    |compatible histories|=C_(n-1).

At n=4 the capacities are 1,1,2,6: 12 independent records but only 6 coherent histories. Uniform endpoint gives uniform marginals but joint entropy `log C_(n-1)`, not `sum log C_m`. Relative entropy against the independent product is the difference of these entropies.

The previous integer identity delta(n)=prod_(m<n)C_m remains a correct ambient-product identity. It does not count the coherent observation image and does not imply the harmonic/Chebyshev growth theorem or RH.

## Completion is larger than the original source image

The inverse limit of these residue rings is Z-hat. Write `C_m=2^(a_m)b_m`, b_m odd, and choose by CRT

    x_m=0 mod 2^(a_m),
    x_m=1 mod b_m.

This coherent profile has every finite prefix realized by an ordinary integer. A single integer realizing all levels would be divisible by every power of 2, hence zero, while also congruent to one mod3: impossible. Its fibre over the embedding Z->Z-hat is empty despite all finite compatibilities.

This does not refute a compact positive-measure argument on its declared weak-star compact fixed-mass source class. It warns that the admissible class must remain attached: smooth NS histories, generalized limits and their completions are different objects.

Repository source loci cited in the original user note: `ActionResidual.agda`, `Pairfield/DependentRootedHistoryFiber.lean`, and `FrontierIsWellFormed.agda`. The corrected statements preserve the earlier scoped symmetric all-history cubic NS calculations and source-specific return identities.


---

# ORIGINAL S04 — Poisson source spectrum, essential norm and auxiliary amplification controls
Source path: `originals/conversation/poisson_source_spectrum/poisson_source_spectrum.md`; SHA-256: `31399963344537e690f6e345163c1f897b9119a23f299856abd75a73de9e5af5`
Transfer status: Original mounted analytical note.

# Exact Poisson-source spectrum and normalization of the common-noise lift

6 September 2026

## Scope

This note proves an operator-norm and essential-spectrum statement for the canonical incompressible-fluid Poisson tensor, computes the identity defect of the common-noise tangent lift, and constructs its exact unital normalization. The stochastic statements hold on a closed interval on which the underlying periodic Navier–Stokes solution is smooth. They do not establish general global regularity or the Riemann hypothesis. No originality-priority claim or proof-assistant compilation is made.

## 1. The canonical source representation is isometric in maximum vorticity

Let H be the complexification of the mean-zero divergence-free L2 vector fields on the flat three-torus. Let P be the orthogonal Leray projection onto H. For a real smooth periodic divergence-free velocity u, define

    omega = curl u,
    Pi_u a = P(a cross omega),
    M = ||omega||_infinity.

The operator Pi_u is bounded and skew-adjoint. In fact,

    ||Pi_u||_(H -> H) = M,
    spectrum_essential(i Pi_u) = [-M,M].

Consequently

    ||Pi_u - Pi_v|| = ||curl(u-v)||_infinity.

The restriction to mean-zero velocities makes this representation injective.

### Proof

The pointwise cross-product inequality and contractivity of P give

    ||Pi_u a||_2 <= M ||a||_2.

For a unit direction n, write P_n = I - n n^T. The transverse principal symbol is

    a |-> P_n(a cross omega(x)),       a perpendicular to n.

Decompose omega into its parallel and perpendicular components relative to n. The cross product of the perpendicular component with a is parallel to n and is removed by P_n. Therefore

    P_n(a cross omega(x)) = (omega(x) dot n) (a cross n).

On the complexified transverse plane, multiplication of this operator by i has eigenvalues +omega(x) dot n and -omega(x) dot n.

Here is an explicit localization argument for the essential-spectrum assertion. Choose x0 where |omega(x0)|=M. For any lambda in [-M,M], choose a direction n and a transverse complex polarization b so that

    i P_n(b cross omega(x0)) = lambda b.

If necessary approximate n by rational directions and adjust lambda by a quantity tending to zero. Choose a smooth unit-L2 bump chi_l supported in a shrinking ball about x0. Modulate chi_l b by a periodic plane wave in the chosen rational direction, and project with P. For each fixed bump, let the modulation frequency tend to infinity before taking the next bump. The Fourier multiplier of P at a translated Fourier frequency converges to P_n. Dominated convergence of the Fourier coefficient square sum proves that both projections occurring in Pi_u are asymptotic to their transverse symbols. Shrinking the bump replaces omega(x) by omega(x0), with error at most its modulus of continuity on the bump.

The resulting normalized fields a_l satisfy

    a_l weakly -> 0,
    ||(i Pi_u - lambda I)a_l||_2 -> 0.

Weak convergence follows from shrinking support for the unprojected packets and their vanishing L2 projection error. These are singular Weyl sequences. Thus every lambda in [-M,M] belongs to the essential spectrum. The upper norm bound excludes spectrum outside this interval, proving both assertions. Linearity in u proves the distance identity.

The argument detects the exact maximum-vorticity quantity. It does not supply a bound for its evolution.

## 2. Common-noise lift on a smooth interval

Fix a smooth unforced NS solution u on [s,T], with viscosity nu>0. Put

    N(u) = -P((u dot grad)u),
    J_u = DN(u),
    L_u = J_u + nu Delta,
    D_j = partial_j.

The source-dependent Poisson naturality and translation identities are

    Pi_(N(u)) = J_u Pi_u + Pi_u J_u*,
    [D_j,Pi_u] = Pi_(D_j u).

They imply, on the smooth core,

    partial_t Pi_u = G_u(Pi_u),
    G_u(Q) = L_u Q + Q L_u* + 2 nu sum_j D_j Q D_j*.

Here D_j*=-D_j. Define R(t,s) by

    dR = L_u R dt + sqrt(2 nu) sum_j D_j R dW_j,
    R(s,s)=I.

Equivalently its Stratonovich drift is J_u. One concrete construction is

    R = T_b Y,
    b_t = sqrt(2 nu)(W_t-W_s),
    partial_t Y = T_(-b) J_u T_b Y,

where T_b is spatial translation. This is a pathwise linear transport equation with smooth spatial coefficients and time-continuous translations. Its L2 energy estimates give deterministic bounds for R and R inverse on [s,T]. Higher Sobolev bounds justify differentiation and stochastic pairings on smooth test fields.

The completely positive map

    E_(t,s)(Q) = expectation[R(t,s) Q R(t,s)*]

is well-defined weakly for every bounded Q on H. Its generator is G_u, interpreted on the smooth core. Moreover,

    expectation[R(t,s)] = V(t,s),
    E_(t,s)(Pi_(u(s))) = Pi_(u(t)),

where V is the actual NS tangent propagator. The second equality follows by matching the weak generator and initial data; equivalently, test against finite-rank smooth terminal operators propagated backward by the dual random evolution. This avoids invoking a bounded inverse of the parabolic propagator V.

## 3. The exact identity defect

Define the strain S_u=(grad u+grad u^T)/2. For divergence-free test fields,

    J_u a = -P((u dot grad)a + (a dot grad)u),
    J_u* a = P((u dot grad)a - (grad u)^T a).

Hence

    J_u+J_u* = -2 P S_u P.

At Q=I, the diffusion and common-noise quadratic variation cancel:

    G_u(I)
      = J_u+J_u* + 2 nu Delta + 2 nu sum_j D_j D_j*
      = -2 P S_u P.

Thus the positive map is not generally unital. If it is unital for every subinterval [s,t], differentiating at t=s gives P S_(u(s)) P=0 for every s. Localized transverse wave packets then give a^T S_(u(s))(x) a=0 for every real vector a: choose a frequency direction perpendicular to a. Therefore S_u=0. Periodicity and incompressibility imply

    integral |grad u|^2 = 2 integral |S_u|^2 = 0,

so u is spatially constant. Conversely a spatially constant unforced flow gives a translation propagator and the map is unital.

Therefore the whole two-parameter tangent channel is unital exactly for spatially constant flows. This assertion is about unitality on every subinterval, not an isolated endpoint equality.

## 4. Exact normalization and positive block transport

Let

    Q_(t,s) = E_(t,s)(I) = expectation[R R*].

The pathwise inverse bound implies Q_(t,s)>=c I for some c>0 on the fixed smooth interval. Define

    Psi_(t,s)(A) = Q_(-1/2) E_(t,s)(A) Q_(-1/2).

This map is completely positive and unital. Since i Pi_(u(s)) is self-adjoint with norm M_s,

    -M_s I <= i Pi_(u(s)) <= M_s I.

Transporting and normalizing proves

    ||Q_(-1/2) Pi_(u(t)) Q_(-1/2)|| <= M_s.

Equivalently, the positive initial block

    [ M_s I       i Pi_(u(s)) ]
    [ i Pi_(u(s)) M_s I       ]

is transported to

    [ M_s Q       i Pi_(u(t)) ]
    [ i Pi_(u(t)) M_s Q       ].

The source reconstruction remains exact:

    Pi_(u(t)) = Q_(1/2) Psi_(t,s)(Pi_(u(s))) Q_(1/2).

The normalized source is controlled in the transported order unit. This does not justify deleting Q or declaring a physical-norm contraction. In particular, a bound for Q may be substantially stronger than what is needed to control the contracted source expectation.

## 5. An exact globally smooth shear separates auxiliary amplification from source decay

Use normalized integration on the torus of side 2 pi. For A>0,

    u(t,x,y,z) = A exp(-nu t) sin(y) e1,
    p=0

is an exact globally smooth unforced NS solution. Its maximum vorticity and Poisson norm are

    ||curl u(t)||_infinity = ||Pi_(u(t))|| = A exp(-nu t).

Choose the mean-zero divergence-free test field

    v = (-sin(x+y), sin(x)+sin(x+y), 0).

Direct integration gives

    ||v||_2^2 = 3/2,
    ||grad v||_2^2 = 5/2,
    integral v^T S_(u(t)) v = -A exp(-nu t)/4.

Therefore

    d/dt <v,Q_(t,0)v>|_(t=0) = A/2 > 0.

The auxiliary positive order unit increases in this direction although the physical Poisson norm decreases exactly. The actual deterministic tangent also has

    d/dt ||V(t,0)v||_2^2|_(t=0) = A/2 - 5 nu,

which is positive for A>10 nu despite global smoothness of the base flow.

Thus replacing expectation[R Pi_initial R*] by a generic amplification estimate for expectation[R R*] can discard relevant cancellation even on an exactly solvable NS solution.

## 6. Algebraic stabilizer of the source identity

For any bounded self-adjoint H, B=Pi_u H satisfies

    B Pi_u + Pi_u B* = 0.

Accordingly, the Poisson-source covariance equation alone is insensitive to additions of this form to its linear generator. The actual tangent is fixed independently by differentiating N(u). The common-source identity and the specification of the true tangent must both be retained.

## Verification and ancestry

`check_identities.py` executes nine exact symbolic controls and computes exact rational finite-Fourier norm witnesses for the shear source. The displayed decimal norm ratios are square roots of rational values. These checks are not substitutes for the localization argument, stochastic domain argument, or a global continuation proof.

Classical ancestry: Peter Constantin and Gautam Iyer, *A stochastic Lagrangian representation of the three-dimensional incompressible Navier–Stokes equations*, Communications on Pure and Applied Mathematics 61 (2008), 330–345, DOI 10.1002/cpa.20192. The common-noise lift here uses the full Euler derivative; it is not identified with the stochastic Weber propagator without an additional argument.

The standard maximum-vorticity continuation framework originates with Beale, Kato and Majda, *Remarks on the breakdown of smooth solutions for the 3-D Euler equations*, Communications in Mathematical Physics 94 (1984), 61–66, DOI 10.1007/BF01212349; viscous Sobolev well-posedness and continuation use the corresponding energy and commutator estimates. The spectral norm theorem preserves the exact vorticity quantity appearing in that framework; it does not establish its integrability.


---

# ORIGINAL S05 — Actual source-preserving coadjoint/stochastic transport and compact tangent residual
Source path: `originals/conversation/source_image_transport/source_image_transport.md`; SHA-256: `ac0c3650ac8817f062a928de37f46adb67b4dcd02fbe8d7422a4b90ca8b02a34`
Transfer status: Original mounted analytical note.

# Source-preserving transport beneath the Navier–Stokes tangent lift

Date: 2026-09-06 (America/Los_Angeles).
Repository snapshot read: `avikj/metacircular-interaction-prototype`, commit `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

The results concern smooth mean-zero divergence-free fields on a flat three-torus. Stochastic constructions are restricted to a closed interval inside the classical lifetime of a prescribed deterministic Navier–Stokes solution. The linear Lie–Poisson/coadjoint structure and the stochastic Weber representation are classical. This note composes those structures with the previously established exact Poisson-source essential norm to obtain an operator-source/compact-residual decomposition. No originality-priority claim, proof-assistant compilation, global regularity theorem, or RH proof is asserted.

## 1. Definitions and the essential-norm input

Let H be the complexified mean-zero divergence-free L2 space and let P be its orthogonal Leray projection. For a real smooth source w, define

    Pi_w a = P(a cross curl w).

This is a bounded skew-adjoint operator. The previously established wave-packet calculation gives

    ||Pi_w|| = ||Pi_w||_essential = ||curl w||_infinity,
    spectrum_essential(i Pi_w) = [-||curl w||_infinity, ||curl w||_infinity].

For completeness, the transverse symbol at frequency direction n is

    P_n(a cross omega) = (omega dot n)(a cross n),    a perpendicular to n.

The eigenvalues of i times this symbol are +/- omega dot n. Localized high-frequency divergence-free wave packets at a maximum-vorticity point give singular Weyl sequences at every value of the displayed interval. The pointwise cross-product bound supplies the matching upper bound. This proves the essential-norm identity, not merely an estimate modulo compact operators.

Write K(H) for the compact operators and q:B(H)->B(H)/K(H) for the quotient. Consequently

    ||q(Pi_w-Pi_v)|| = ||curl(w-v)||_infinity.

In particular, the source image intersects K(H) only at zero. The mean-zero and divergence-free conditions make curl injective on the declared sources.

## 2. Every pair of source operators commutes modulo compact operators

**Theorem.** For smooth real u,w,

    [Pi_u,Pi_w] is compact.

**Proof without a pseudodifferential-calculus assumption.** First take trigonometric-polynomial vorticities. Pi is a finite sum of Fourier shifts. Write C_eta(a)=a cross eta, and P_k for the transverse projection at nonzero integer frequency k. For a pair of source frequencies p,q, the coefficient in the commutator at shift p+q is

    P_(k+p+q) C_(omega_u(p)) P_(k+q) C_(omega_w(q)) P_k
      - P_(k+p+q) C_(omega_w(q)) P_(k+p) C_(omega_u(p)) P_k.

For fixed p,q, as |k| tends to infinity the projections at shifted frequencies differ from P_k by O(1/|k|). The leading coefficient vanishes: on a transverse two-plane, both source symbols are scalar multiples of the same ninety-degree rotation. Thus every matrix coefficient of this finite-shift operator tends to zero at high frequency. Truncating its input frequencies approximates it in operator norm by finite-rank operators, proving compactness.

Approximate each smooth vorticity uniformly by its finite Fourier sums. The inequality ||Pi_u-Pi_v||<=||curl(u-v)||_infinity and norm-continuity of the commutator pass the conclusion to the limit. Zero-frequency conventions change only finitely many coefficients. QED.

Therefore the quotient source family commutes even though q remains isometric and injective on the source family. Static source faithfulness does not imply faithfulness of all operator interactions.

## 3. A named nonzero compact commutator

Use coordinates (x,y,z) of period 2pi and set

    u = sin(y) e_1,
    w = sin(z) e_2,
    a_N = cos(Nx) e_3,     N>=1.

Then Pi_u a_N=0 and Pi_w a_N=-cos(Nx)cos(z)e_2. Hence

    [Pi_u,Pi_w] a_N = P[cos(Nx)cos(y)cos(z)e_1]

and exact Fourier projection gives

    ( 2 cos(Nx)cos(y)cos(z)/(N^2+2),
      N sin(Nx)sin(y)cos(z)/(N^2+2),
      N sin(Nx)cos(y)sin(z)/(N^2+2) ).

For normalized torus integration,

    ||[Pi_u,Pi_w] a_N||_2^2 / ||a_N||_2^2 = 1/[2(N^2+2)].

Thus the commutator is nonzero. By Section 1 it is Pi_z for no declared source z. Also M_u w=Pi_w u=0 for this pair.

More generally, any nonzero compact K lies at positive operator-norm distance from the source image:

    inf_w ||K-Pi_w|| >= ||K||/2.

Indeed, ||Pi_w||=||q(Pi_w-K)||<=||Pi_w-K||, and the triangle inequality gives the conclusion. For the displayed commutator the lower bound is at least 1/(2 sqrt(6)). This is an operator-source exclusion, not an exclusion of a Navier–Stokes singularity.

## 4. The actual derivative and the coadjoint generator

Let [a,b]=(a dot grad)b-(b dot grad)a. Define

    M_u w = Pi_w u,
    N(u) = Pi_u u,
    J_u = DN(u) = M_u + Pi_u.

The pairing identity

    <a,Pi_w b> = -<w,[a,b]>

implies M_u*=ad_u, where ad_u(a)=[u,a]. Jacobi then gives, for every source w,

    M_u Pi_w + Pi_w M_u* = Pi_(M_u w).

Explicitly, pairing the left side with a,b gives

    -<w,[[u,a],b]+[a,[u,b]]>
      = -<w,[u,[a,b]]>
      = <a,Pi_(M_u w)b>.

Because Pi_u*=-Pi_u,

    J_u Pi_w + Pi_w J_u*
      = Pi_(M_u w) + [Pi_u,Pi_w].

This is the exact all-source residual formula. At w=u the residual is zero and it recovers actual source-sensitive Hamiltonian naturality. On arbitrary w the residual can be nonzero, compact, and outside the entire source image. M_u is the generator that intertwines the source representation for every source; J_u is the genuine derivative of the nonlinear velocity equation. Their roles are distinct.

## 5. A pathwise source-preserving lift

Fix a deterministic smooth NS solution u on [s,T] with viscosity nu>0. Drive both propagators below with the same three-dimensional Brownian path. In Stratonovich form, define

    dS = M_u S dt + sqrt(2nu) sum_j D_j S o dW_j,
    dR = J_u R dt + sqrt(2nu) sum_j D_j R o dW_j,
    S(s,s)=R(s,s)=I,

where D_j=partial_j. Their Ito drifts are M_u+nu Delta and J_u+nu Delta, respectively.

The translation noise can be removed by the common translation T_(sqrt(2nu)(W_t-W_s)). The remaining equations are pathwise deterministic linear transport systems with spatially smooth time-continuous coefficients. Forward/backward Sobolev estimates give bounded invertible propagators on the prescribed interval and uniform bounds sufficient for the weak identities and expectations used here.

The generator M_u is the projected one-form transport operator

    M_u w = -P[(u dot grad)w + (grad u)^T w].

Thus S is the coadjoint/Weber transport associated with a volume-preserving stochastic flow. With the sign convention above, its spatial flow can be taken to satisfy dX=u(X,t)dt-sqrt(2nu)dW; flipping Brownian sign recovers the usual convention.

Coadjoint naturality and [D_j,Pi_w]=Pi_(D_j w), followed by the Stratonovich product rule, prove the pathwise identity

    S(t,s) Pi_w S(t,s)* = Pi_(S(t,s)w)

for every initial source w. Both sides solve the same transported operator equation with the same initial value. In contrast to R, S preserves the physical source image separately for every noise realization.

For w_s=u(s), let w_t=S(t,s)u(s). Its mean solves

    partial_t E w_t = M_u E w_t + nu Delta E w_t.

The actual NS solution solves this same linear equation with the same initial data because M_u u=N(u). Hence

    E[S(t,s)u(s)] = u(t).

The mean of R solves the true linearized NS equation:

    E R(t,s) = V(t,s) = D Phi_NS(t,s)(u(s)).

The stochastic Weber mean representation is classical. The source-operator identity here records its full Poisson-tensor counterpart.

## 6. The tangent lift is the source-preserving lift plus a compact residual

For an arbitrary initial source w, write w_r=S(r,s)w and define

    K_(t,s)(w) = R(t,s)Pi_w R(t,s)* - Pi_(w_t).

The exact residual evolution is

    dK = (J_u K + K J_u* + [Pi_u,Pi_(w_t)])dt
           + sqrt(2nu) sum_j [D_j,K] o dW_j,
    K_s=0.

Variation of constants with the same noise gives

    K_(t,s)(w)
      = integral_s^t R(t,r)[Pi_(u(r)),Pi_(w_r)]R(t,r)* dr.

Every integrand is compact by Section 2. Bounded conjugation preserves compactness, and the smooth-interval bounds justify the operator-norm integral. Therefore K_(t,s)(w) is compact.

The resulting decomposition is

    R(t,s)Pi_w R(t,s)* = Pi_(S(t,s)w) + K_(t,s)(w),
    K_(t,s)(w) in K(H).

It is unique: equality Pi_a+K=Pi_b+L implies Pi_(a-b) compact, hence a=b and K=L. Source extraction is contractive in the maximum-vorticity norm, since

    ||curl a||_infinity = ||q(Pi_a+K)|| <= ||Pi_a+K||.

In particular,

    q(R Pi_w R*) = q(Pi_(S w)).

For the physical initial source w=u(s), the earlier covariance evolution gives E[R Pi_(u(s))R*]=Pi_(u(t)). Alternatively, taking expectations of the K equation gives a homogeneous equation because

    E[Pi_u,Pi_(w_t)] = [Pi_u,Pi_(E w_t)] = [Pi_u,Pi_u] = 0.

Its zero initial condition therefore gives

    E K_(t,s)(u(s)) = 0.

Thus the compact operator residual is exactly centered on the actual NS source. This cancellation is not obtained by bounding R R* or by declaring each random conjugate to be a source tensor.

## 7. Differentiating the source-preserving representation recovers the actual variation

For a differentiable family u_epsilon of classical NS solutions on a common interval, the representation reads

    u_epsilon(t)=E[S[u_epsilon](t,s)u_epsilon(s)].

Let v=partial_epsilon u_epsilon at zero and h=v(s). Both the input and the drift of S must be differentiated. If w_t=S[u](t,s)u(s), the derivative of the random transported source satisfies

    d(delta w) = (M_u delta w + M_v w_t)dt
                   + sqrt(2nu) sum_j D_j(delta w) o dW_j,
    delta w_s=h.

Taking expectations and using E w_t=u(t) yields

    v_t=(M_u+nu Delta)v + M_v u
       =(M_u+Pi_u+nu Delta)v
       =(J_u+nu Delta)v.

No source derivative has been dropped. S is not relabeled as the NS tangent; its source-dependent derivative produces that tangent.

## 8. A retained coadjoint constraint: helicity

Let H(w)=<w,curl w>/2. For w_t=S(t,s)w_s, the Casimir identity Pi_w curl w=0 and translation invariance give

    H(w_t)=H(w_s)

pathwise. For the physical source, write xi_t=w_t-u(t), so E xi_t=0. Quadratic polarization then gives

    H(u(t)) + E H(xi_t) = H(u(s)).

This retains helicity in the stochastic ancestry without asserting that H(xi_t) is nonnegative. It does not turn helicity into a coercive norm.

## 9. Finite parabolic rescaling and the limit boundary

For a torus of side L and r>0, use the rescaled torus of side L/r and define

    w_r(x)=r w(x0+rx),
    U_r f(x)=r^(3/2) f(x0+rx).

U_r is unitary and

    Pi_(w_r)=r^2 U_r Pi_w U_r^-1.

Combined with Brownian scaling and time rescaling, both propagators transform by U_r conjugation. The compact residual transforms as

    K_r = r^2 U_r K U_r^-1.

Thus source extraction, compactness, the residual identity, and the centered physical-source residual transport exactly at each finite renormalization step.

This does not justify erasing compact terms before taking a singular limit. Compactness is not closed in the strong operator topology: finite-rank projections can converge strongly to the identity. A coherent limiting witness must therefore retain the source, residual, and expectation/limit compatibility data. No singular-limit continuation theorem is derived from the finite-scale decomposition alone.

## 10. Verification and dependencies

The accompanying script executes 38 exact SymPy checks. It verifies the universal transverse symbol and its commutation, an explicit nonzero commutator, the coadjoint and tangent residual identities on finite Fourier fields, the common-noise Laplacian identity, and the exact high-frequency witness formula. Every generated Fourier mode is retained; there is no Galerkin cutoff. These checks support finite algebraic identities, not stochastic existence or compactness, whose arguments are above.

Repository source read at the stated snapshot:

- `formal/cubical/theorems/automata/ActionResidual.agda`: exact reconstruction of behavior from a declared predictor and its residual, with explicit composition hypotheses.
- `formal/cubical/theorems/residue/CurvatureCannotLiveOnTheImageOfAnExactCompression.agda`: intertwining and commuting source actions imply commutation on the realizable image. The present source-commutator theorem is an independent concrete operator result, not a claim that this generic theorem proves it automatically.

Classical ancestry:

- J. E. Marsden and A. Weinstein, *Coadjoint orbits, vortices, and Clebsch variables for incompressible fluids*, Physica D 7 (1983), 305–323.
- P. Constantin and G. Iyer, *A stochastic Lagrangian representation of the three-dimensional incompressible Navier–Stokes equations*, Communications on Pure and Applied Mathematics 61 (2008), 330–345; arXiv:math/0511067, especially Theorem 2.2 and Propositions 2.7 and 2.9.

The RH theorem graph is unchanged by these NS constructions: positivity of the actual continuous arithmetic moment kernel supplies its unique real spectral source and the receiver bound. A positive covariance map for NS is not a proof of that arithmetic positivity.


---

# ORIGINAL S06 — Receiver Sobolev inverse and full affine harmonic continuation fibre
Source path: `originals/conversation/receiver_inverse_harmonic_fibre/proof_note.md`; SHA-256: `6c1c73295e924f497d70d6ed3104fe78b166326ae39d39f984eefa60d574b409`
Transfer status: Original mounted note; legacy alias proof_note(2).

# Explicit receiver inversion and the harmonic fibre of renormalized NS sources

Repository snapshot: `avikj/metacircular-interaction-prototype`, `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

This note proves an explicit differential-delay inverse for the previously specified Weil packet, with a two-term exact truncation residual and convergence in a positive spectral majorant that does not assume RH. It also constructs smooth compactly supported divergence-free velocity fields whose Poisson source operators converge in operator norm, whose vorticity stays normalized and nonzero, but whose actual local NS vorticity derivatives remain separated by an arbitrary prescribed trace-free symmetric strain. The missing local source fibre is characterized and an exact boundary observer is given.

These are mathematical derivations using the classical Weil form and elementary differential/vector calculus. No proof of RH or global three-dimensional NS regularity, originality-priority claim, or proof-assistant compilation is made. The accompanying executable checks finite and symbolic identities, not PDE evolution or the analytic limit theorems.

## I. The fixed Weil receiver has an explicit inverse

Set

\[
\ell=\tfrac14,\qquad r=e^{-1},\qquad
q(x)=4\mathbf1_{[0,\ell]}(x),\qquad
k(x)=e^{-4x}q(x),\qquad h=k*k.
\]

Thus

\[
h(x)=e^{-4x}(q*q)(x),\qquad
H(z)=\int h(x)e^{-zx}\,dx
=16\frac{(1-e^{-(z+4)/4})^2}{(z+4)^2}.
\]

Write \(T_bv(x)=v(x-b)\), \(D=\partial_x\), and \(L=rT_\ell\). Distributionally,

\[
(D+4)k=4(\delta_0-r\delta_\ell),
\]

so

\[
\boxed{(D+4)^2h=16(\delta_0-2r\delta_\ell+r^2\delta_{2\ell}).}
\tag{1}
\]

Consequently convolution with \(h\), denoted \(C_h\), obeys

\[
(D+4)^2C_h=16(I-L)^2.
\tag{2}
\]

This is an identity of the actual fixed packet, not a generic nonvanishing-multiplier assertion.

### Finite-history inverse with an exact two-term boundary residual

For \(v\in C_c^\infty(\mathbb R)\), define

\[
f_N=\frac1{16}(D+4)^2\sum_{j=0}^N(j+1)L^jv,
\qquad v_N=h*f_N.
\]

The polynomial identity

\[
(1-X)^2\sum_{j=0}^N(j+1)X^j
=1-(N+2)X^{N+1}+(N+1)X^{N+2}
\tag{3}
\]

gives

\[
\boxed{
v_N=v-(N+2)e^{-(N+1)}T_{(N+1)/4}v
+(N+1)e^{-(N+2)}T_{(N+2)/4}v.
}
\tag{4}
\]

Equation (3) follows by induction: the difference of its right-hand sides at \(N+1\) and \(N\) is \((N+2)X^{N+1}(1-X)^2\). Thus the residual is exactly two known translates of the retained source. No unspecified remainder is introduced.

There is also an actual infinite inverse. Define

\[
\mathcal Rv=\frac1{16}(D+4)^2
\sum_{j\ge0}(j+1)e^{-j}T_{j/4}v.
\tag{5}
\]

For compactly supported \(v\), the sum is locally finite. It is smooth, has a lower-bounded support, and has an exponentially decreasing right tail, with at most a linear polynomial prefactor. Equation (4) proves

\[
\boxed{h*\mathcal Rv=v.}
\tag{6}
\]

This is a right inverse on the declared smooth compact-source class. It does not claim that the inverse source remains compactly supported. On exponentially weighted source spaces with weight exponent less than 4, the same series is convergent and provides the corresponding two-sided inverse whenever the derivatives belong to the declared spaces. In particular \(\|L\|\le e^{-1+\sigma/4}<1\) under a translation bound \(\|T_b\|\le e^{\sigma |b|}\), \(\sigma<4\).

### Convergence strong enough for the actual Weil form

Let \(z_\rho=\rho-1/2\), with distinct nontrivial zeta zeros indexed with multiplicities \(m_\rho\). For compact smooth \(v\), set

\[
V_v(z)=\int v(x)e^{-zx}\,dx,
\qquad \|v\|_{\mathcal Z}^2=\sum_\rho m_\rho|V_v(z_\rho)|^2.
\tag{7}
\]

This is a positive majorant seminorm. It does not presume positivity of the Weil form. Its finiteness follows from rapid vertical decay on the fixed strip and the classical zero-count estimate. The zero symmetries give

\[
Q_W(v,w)
=\sum_\rho m_\rho V_v(z_\rho)
\overline{V_w(-\overline{z_\rho})},
\]

hence

\[
|Q_W(v,w)|\le\|v\|_{\mathcal Z}\|w\|_{\mathcal Z}.
\tag{8}
\]

Only the unconditional strip \(|\Re z_\rho|\le1/2\) is needed for

\[
\|T_bv\|_{\mathcal Z}\le e^{|b|/2}\|v\|_{\mathcal Z}.
\tag{9}
\]

Combining (4) and (9),

\[
\boxed{
\|v_N-v\|_{\mathcal Z}\le\epsilon_N\|v\|_{\mathcal Z},
\qquad
\epsilon_N=(N+2)e^{-7(N+1)/8}+(N+1)e^{-7(N+2)/8}.
}
\tag{10}
\]

Therefore

\[
\boxed{
|Q_W(v_N,v_N)-Q_W(v,v)|
\le(2\epsilon_N+\epsilon_N^2)\|v\|_{\mathcal Z}^2.
}
\tag{11}
\]

No cancellation among the zeta modes is needed for this estimate, and no critical-line location is assumed.

### Any negative compact test can be compiled into a finite packet Gram test

Suppose \(Q_W(v,v)=-\delta<0\), \(v\in C_c^\infty\). Select a finite \(N\) satisfying

\[
(2\epsilon_N+\epsilon_N^2)\|v\|_{\mathcal Z}^2<\delta/2.
\]

Then \(Q_W(h*f_N,h*f_N)<-\delta/2\). Since

\[
h*f_N=\int f_N(t)T_th\,dt,
\]

it can be approximated in \(\|\cdot\|_{\mathcal Z}\) by finite sums

\[
p=\sum_{j=1}^m c_jT_{t_j}h.
\]

To justify the approximation, \(h\) itself has finite majorant norm because its transform has quadratic vertical decay. The map \(t\mapsto T_th\) is continuous in that norm by dominated convergence, uniformly bounded on compact \(t\)-intervals. Riemann sums for the compactly supported \(f_N\) therefore converge. For a sufficiently accurate sum, \(Q_W(p,p)<0\).

The nodes can be chosen in \(\mathbb Z\log2+\mathbb Z\log3\), since this set is dense, and coefficients can be approximated in \(\mathbb Q+i\mathbb Q\). Thus the map is a constructive source-to-finite-packet reduction, with its first truncation residual known exactly.

The corresponding Gram entries are the existing fixed receiver:

\[
Q_W(T_sh,T_th)=\mathcal Z(t-s),
\qquad
\mathcal Z(t)=\sum_\rho m_\rho H(z_\rho)H(-z_\rho)e^{z_\rho t}.
\]

Its explicit arithmetic formula, retained archimedean terms, CRT \(\Lambda\)-reconstruction, and quantitative Goldbach reconstruction remain unchanged. This does not prove the entries form positive Gram matrices. The prior two-packet criterion is not replaced by a stronger obligation; (4)--(11) supply an explicit inverse/continuity adapter for arbitrary test sources.

## II. The Poisson-source inverse can lose a harmonic strain even under operator-norm convergence

Let \(\mathbb P\) be the whole-space Leray projection on \(L^2_\sigma(\mathbb R^3)\). For a smooth compactly supported divergence-free velocity \(u\), let

\[
\Pi_ua=\mathbb P(a\times\operatorname{curl}u).
\]

The elementary bound

\[
\|\Pi_u-\Pi_v\|\le\|\operatorname{curl}(u-v)\|_\infty
\tag{12}
\]

is sufficient for the construction below. It is consistent with the previously obtained equality. Injectivity on the finite-energy source class does not assert continuity of its inverse into local velocity or strain.

### A compact remote source for any prescribed affine strain

Choose a nonzero real trace-free symmetric matrix \(A\). Let \(\chi\in C_c^\infty(\mathbb R^3)\) equal 1 on \(B_1\) and 0 outside \(B_2\). Put

\[
\Psi_A(x)=-\tfrac13x\times Ax,
\qquad
W_R^A=\operatorname{curl}[\chi(x/R)\Psi_A(x)].
\tag{13}
\]

The vector identity

\[
\operatorname{curl}\Psi_A=Ax
\]

uses \(\operatorname{tr}A=0\). Since \(A\) is symmetric, \(\operatorname{curl}(Ax)=0\). It follows that

\[
\begin{aligned}
\nabla\cdot W_R^A&=0,\
W_R^A(x)&=Ax\quad (|x|<R),\
W_R^A(x)&=0\quad (|x|>2R),\
\operatorname{supp}\operatorname{curl}W_R^A&\subset\{R\le|x|\le2R\}.
\end{aligned}
\tag{14}
\]

Homogeneity gives

\[
W_R^A(x)=R W_1^A(x/R),
\quad
\|\operatorname{curl}W_R^A\|_\infty=C_A,
\quad
\|W_R^A\|_2^2=R^5\|W_1^A\|_2^2.
\tag{15}
\]

### Many disjoint weak tails leave a finite strain in the core

Set \(R_{n,j}=4^{n+j}\), \(1\le j\le n\), and

\[
H_n=\frac1n\sum_{j=1}^nW_{R_{n,j}}^A.
\tag{16}
\]

The vorticity annuli in this sum are disjoint, so

\[
\boxed{
\|\operatorname{curl}H_n\|_\infty\le C_A/n\longrightarrow0.
}
\tag{17}
\]

But on \(B_{R_{n,1}}\), every summand equals \(Ax\), so

\[
\boxed{H_n(x)=Ax\quad\text{on }B_{R_{n,1}}.}
\tag{18}
\]

Thus \(H_n\to Ax\) smoothly on every compact subset, while \(\Pi_{H_n}\to0\) in operator norm. Each \(H_n\) remains a genuine smooth compactly supported finite-energy source. The local limit \(Ax\) is not a finite-energy source; that admissibility failure is the point.

### Keep the vorticity normalization and a nonzero core

Fix a unit vector \(\Omega\). A smooth compactly supported divergence-free \(v\) can be chosen with

\[
v(x)=\tfrac12\Omega\times x\quad (|x|\le1),
\qquad
\|\operatorname{curl}v\|_\infty=1.
\tag{19}
\]

For an explicit construction, choose a smooth nonincreasing \(\eta\) equal to 1 for \(s\le0\), equal to 0 for \(s\ge L\), and with \(-1\le\eta'\le0\). Take \(f(r)=\eta(\log r)/2\), with its constant smooth extension near zero, and \(v=f(|x|)\Omega\times x\). The vorticity components parallel/perpendicular to \(n=x/|x|\) are multiplied by \(2f\) and \(2f+rf'\), respectively. Their absolute values are at most 1.

Let \(U_n=v+H_n\). For large \(n\), the tail-vorticity supports are disjoint from the core support and \(C_A/n\le1\). Consequently

\[
\boxed{
\begin{aligned}
U_n(0)&=0,\\
\|\operatorname{curl}U_n\|_\infty&=1,\\
\operatorname{curl}U_n(0)&=\Omega,\\
\|\Pi_{U_n}-\Pi_v\|&\le C_A/n\to0,\\
U_n&\to v+Ax\quad\text{smoothly locally}.
\end{aligned}
}
\tag{20}
\]

This is neither loss of nonvanishing nor an unremoved constant-velocity/Galilean mode. The surviving missing part is an arbitrary trace-free symmetric strain.

### Actual NS first continuations remain separated

Let each field be initial data for its own classical NS solution, with fixed viscosity \(\nu>0\). At time zero,

\[
\partial_t\omega
=-(u\cdot\nabla)\omega+(\omega\cdot\nabla)u+\nu\Delta\omega.
\]

On \(B_1\), both sources have constant vorticity \(\Omega\). At the origin their velocity is zero. The core rotation contributes zero stretching because \(\Omega\times\Omega=0\). Hence

\[
\boxed{
\left.\partial_t\omega_{U_n}(0,t)\right|_{t=0}
-\left.\partial_t\omega_v(0,t)\right|_{t=0}
=A\Omega.
}
\tag{21}
\]

Choose \(A\Omega\ne0\). The difference is independent of \(n\). Thus convergence of the Poisson state in operator norm does not make this true local NS generator reading converge. This is a topological extension obstruction for the autonomous source-coordinate equation, not a contradiction of its exactness at each admissible source.

No convergence or common existence interval for these different NS solutions is needed for (21), and none is asserted.

### The construction can respect the inherited finite-energy scaling

Let \(R_n=R_{n,n}\). On the annulus \(R_n/2<|x|<R_n\), all smaller cutoff fields vanish and \(H_n=Ax/n\), while \(v=0\). This gives a lower bound of order \(R_n^5/n^2\) for \(\|U_n\|_2^2\). The geometric sum of the norms in (15) gives the matching upper bound. Thus

\[
\|U_n\|_2^2\asymp_A R_n^5/n^2.
\tag{22}
\]

Choose

\[
r_n=(1+\|U_n\|_2^2)^{-1}\to0,
\qquad u_n(x)=r_n^{-1}U_n(x/r_n).
\]

Then

\[
\boxed{
\|u_n\|_2^2=r_n\|U_n\|_2^2\le1,
\qquad
\|\operatorname{curl}u_n\|_\infty=r_n^{-2}.
}
\tag{23}
\]

Vorticity-peak renormalization by \(r_n\) returns exactly \(U_n\). The physical supports shrink, since \(r_nR_n\asymp n^2/R_n^4\to0\); the compact fields can also be periodized on one fixed torus for sufficiently large \(n\).

These are different smooth initial data, not one blow-up trajectory. Equations (20)--(23) establish only that nonzero peak normalization, Galilean centering, and the inherited global energy upper bound do not by themselves eliminate the harmonic tail. The common-initial-source and dynamical ancestry requirements remain additional requirements.

## III. Exact repair: vorticity and the normal boundary trace are jointly faithful

On a ball, two smooth divergence-free velocities with the same vorticity differ by

\[
u_1-u_2=\nabla\phi,\qquad\Delta\phi=0.
\tag{24}
\]

The potential is unique up to an additive constant. Thus the local fibre of the curl reading consists of harmonic gradients, not merely constant vectors. Fixing velocity at the center removes the degree-one potential part, but leaves the five-dimensional space \(\phi(x)=x^TAx/2\), \(A=A^T\), \(\operatorname{tr}A=0\), along with higher harmonic degrees.

If the normal velocity is also retained on the boundary, then \(\partial_n\phi=0\). Green's identity yields

\[
\int|\nabla\phi|^2=\int_{\partial B}\phi\partial_n\phi-\int\phi\Delta\phi=0.
\]

Therefore, on the realized data image,

\[
\boxed{
u\longmapsto(\operatorname{curl}u,\ u\cdot n|_{\partial B})
\quad\text{is injective on divergence-free fields}.
}
\tag{25}
\]

This is a reconstruction statement, not a claim that every independently specified pair of boundary/vorticity data is realizable.

For the quadratic harmonic component, an explicit observer suffices. If \(h=\nabla\phi\) is smooth and harmonic on \(B_R\), then

\[
\boxed{
\nabla^2\phi(0)
=\frac{15}{8\pi R}
\int_{\mathbb S^2}(h(Rn)\cdot n)
\left(nn^T-\frac13I\right)d\Omega(n).
}
\tag{26}
\]

The degree-two harmonic component is the only one that contributes, by spherical harmonic orthogonality. For \(h=Ax\), the formula follows from

\[
\int_{\mathbb S^2}n_in_jn_kn_l\,d\Omega
=\frac{4\pi}{15}(\delta_{ij}\delta_{kl}+\delta_{ik}\delta_{jl}+\delta_{il}\delta_{jk}).
\]

This observer is insensitive to a constant velocity and returns exactly the strain responsible for (21).

### Compatibility with the localized Betchov current

For \(\mathcal J_u=(\operatorname{cof}\nabla u)^Tu\), the established local identity is

\[
\omega^TS\omega=-4\det S+\frac43\nabla\cdot\mathcal J_u.
\tag{27}
\]

For a pure harmonic affine velocity \(u=Ax\), \(\omega=0\), but \(\det S=\det A\) need not vanish. Here

\[
\mathcal J_u=(\operatorname{cof}A)^TAx=(\det A)x,
\]

so \((4/3)\nabla\cdot\mathcal J_u=4\det A\) cancels the cubic term exactly. Omitting the boundary current would assign spurious enstrophy production to a zero-vorticity source.

## Dependency and verification ledger

Read at the pinned repository snapshot:

- `formal/cubical/theorems/automata/ActionResidual.agda`: an exact finite residual and its realized composition law.
- `formal/cubical/theorems/automata/FutureBehavior.agda`: observation agreement and action preservation are separate requirements; joint readings intersect future-equivalence relations.
- `formal/cubical/theorems/unplaced/ReceiverExponentFaithful.agda`: boundedness preservation/reflection in the abstract log-amplitude model; this is not the explicit differential-delay inverse proved in I.

The fixed packet, the previously established two-packet Weil criterion, and the earlier local cofactor-current identity are retained as inputs. Classical explicit-formula and Weil-form theory can be found in Masatoshi Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2. No numerical claims from that paper are used.

`checks.py` executes 31 exact symbolic/algebraic controls. The universal proofs of inverse convergence, the remote-tail construction, the energy scaling, and the joint boundary reconstruction are the arguments above. The finite checks are not substitutes for them.

The arithmetic adapter has a controlled vanishing residual on the full unconditional spectral strip. The NS source-coordinate completion, in contrast, has a harmonic fibre that remains dynamically visible even when the vorticity-operator difference tends to zero in norm. Neither statement supplies a final RH positivity proof or an NS blow-up exclusion.


---

# ORIGINAL S07 — Instantiated continuation fibres
Source path: `originals/conversation/instantiated_continuation_fibres/proof_note.md`; SHA-256: `246475b47b0de16b94b93f8a3555a8c0e6ddf28d3aeb09586964d26d15810755`
Transfer status: Original mounted note; legacy alias proof_note(1).

# Instantiated continuation fibres: a fixed Weil receiver and the localized strain current

Date: 2026-09-06.
Repository snapshot read: `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

This note instantiates existing observability and retained-residual constructions at specified arithmetic and fluid objects. The proofs use classical explicit-formula theory, an unconditional positive proportion of simple critical-line zeros, elementary entire-function zero counting, finite-dimensional Hermitian algebra, and smooth-core differential identities. No originality-priority claim, proof-assistant build, proof of RH, or proof of general NS regularity is made.

The inspected `ExcursionReturn.agda` already identifies an observability kernel with equality of all future observations. Its abstract compression identity is an input, not a new result of this note. The application proved below is that one particular arithmetic receiver has trivial future-observability kernel on compactly supported L2 test sources, even when only arbitrarily late translations are observed.

## 1. Fixed packet and the actual Weil form

Let

    q(x) = 4 1_[0,1/4](x),
    h(x) = exp(-4x) (q*q)(x),
    H(z) = integral h(x) exp(-zx) dx
         = 16 (1-exp(-(z+4)/4))^2/(z+4)^2.

The packet h is real, continuous, compactly supported in [0,1/2], and belongs to H1. Its transform has no zeros in |Re z|<=1/2 and is O((1+|Im z|)^(-2)) uniformly in that strip.

Write z_rho=rho-1/2 for distinct nontrivial zeta zeros, with multiplicity m_rho, and use

    W(phi) = sum_rho m_rho integral phi(x) exp(z_rho x) dx,
    Q(v,w) = W(v*tilde(w)),
    tilde(w)(x)=conjugate(w(-x)).

Thus Q is linear in its first argument. The Weil explicit formula supplies the arithmetic expression for W; the meromorphic continuation and zero symmetries of zeta are classical inputs, not consequences of a finite CRT calculation.

Set G(z)=H(z)H(-z). Explicitly,

    G(z) = 256 (1-2 exp(-1) cosh(z/4)+exp(-2))^2/(16-z^2)^2.

All displayed apparent poles are removable. The elementary sector estimates

    |arg(1-2 exp(-1) cosh(z/4)+exp(-2))| < 6/25,
    |arg(16-z^2)| < 13/100

on |Re z|<=1/2 imply |arg G(z)|<37/50<pi/2. Therefore

    M = Q(h,h) = sum_rho m_rho G(z_rho) > 0

unconditionally. The sum is real by conjugation symmetry and converges absolutely. It is prime-free in the explicit formula, because h*tilde(h) is supported in [-1/2,1/2] and log 2>1/2. Translation invariance gives Q(T_t h,T_t h)=M, where T_t h(x)=h(x-t).

## 2. A one-packet future-observability theorem

For compactly supported v in L2(R), define

    V_v(z) = integral v(x) exp(-zx) dx,
    R_v(z) = V_v(z) H(-z),
    O_v(t) = Q(v,T_t h).

For arbitrary compact L2 v, the final pairing can be defined by the absolutely convergent series

    O_v(t) = sum_rho m_rho R_v(z_rho) exp(z_rho t).

It agrees with the closed-form pairing whenever v belongs to the Weil form domain. Indeed, V_v is uniformly bounded on the shifted critical strip, H(-z) has quadratic vertical decay, and the usual zero count is O(T log T). Smooth approximation therefore passes to this series uniformly on compact real t-intervals, and the form-domain pairing agrees by its form-norm continuity.

### Theorem

For every real T0,

    [O_v(t)=0 for every t>T0] implies v=0.

Consequently, for the dense subgroup D=Z log 2+Z log 3,

    [O_v(t)=O_w(t) for every t in D with t>T0] iff v=w.

No positivity of the full Weil form is assumed.

### Proof

The estimate |O_v(t)|<=C_v exp(|t|/2) and absolute convergence give, for Re s>1/2,

    integral_0^infinity exp(-st) O_v(t+T0) dt
       = sum_rho m_rho R_v(z_rho) exp(z_rho T0)/(s-z_rho).

The series on the right converges normally on compact subsets avoiding its discrete pole set and defines a meromorphic function on the complex plane. At s=z_rho its residue is

    m_rho V_v(z_rho) H(-z_rho) exp(z_rho T0).

If the time response vanishes on the half-line, the meromorphic function vanishes identically. Nonvanishing of H(-z_rho) forces V_v(z_rho)=0 for every distinct zero.

If v is supported in [-a,a], then

    |V_v(z)| <= ||v||_1 exp(a |Re z|).

A nonzero entire function with this bound has O(R) zeros in a disk of radius R, counted with multiplicity: apply Jensen's formula around any point where it does not vanish, comparing radii R and 2R. But Conrey's unconditional positive-proportion theorem supplies at least c T log T distinct simple critical-line zeros up to height T. This is incompatible with the zero count for a nonzero V_v. Hence V_v is identically zero, and Fourier uniqueness gives v=0.

For the lattice assertion, continuity of O_v-O_w and density of D imply half-line vanishing, and the preceding result applies. In particular, every nonzero v is detected by some lattice translate beyond every prescribed T0. This is not a quantitative bound on the first detecting translate or its signal strength.

### Exact repository instantiation

Take the state type to be compactly supported L2 functions, the installed actions to be translations by plus or minus log 2 and log 3, and the current observation to be Q(v,h). Simultaneous translation invariance gives

    Q(T_(-t)v,h)=Q(v,T_t h).

The observability kernel / FutureEq of `ExcursionReturn.SetForm` is therefore equality on this state type. The arithmetic spectral and entire-function argument supplies the nontrivial hypothesis; no separate real-spectrum matching assumption is introduced.

## 3. Local null vectors have an explicit negative continuation

Let A_a be the self-adjoint operator associated with the closed Weil form on L2(-a,a), as in Suzuki's operator formulation. Extend its vectors by zero outside the interval. Suppose

    0 != v in Dom(A_a),    A_a v=0.

Then Q(v,v)=0. For every prescribed T0>a, the preceding theorem supplies t in D with t>T0 and

    c=Q(v,T_t h) != 0.

The supports of v and T_t h are disjoint. Put

    w = v - (c/M) T_t h.

The exact identity is

    Q(w,w) = -|c|^2/M < 0.

The two-vector Hermitian Gram matrix has entries

    [ 0       c ]
    [ conj(c) M ]

and determinant -|c|^2. Thus a localized null vector cannot remain null and orthogonal to every later translate of this one installed receiver. It generates a strictly negative form value on a larger but finite support interval.

The vector v need not be smooth. Its zero extension belongs to the form domain of every larger interval, because core approximations from (-a,a) retain exactly the same global quadratic form. The negative w can then be approximated in the larger form norm by smooth compactly supported tests; strict negativity persists. No smoothness of the null eigenfunction is assumed.

This is not a contradiction under failure of RH. It is a source-specific extraction of a negative continuation from an assumed local degeneracy.

### Multiplicity version

If dim ker A_a=m, choose a basis v_1,...,v_m. Their scalar receiver responses are linearly independent on every terminal half-line, by the injectivity theorem. Hence one can choose m sufficiently distant lattice translates of h for which the cross-pairing matrix is invertible.

After changing basis in the translate span, the Gram matrix on the resulting 2m-dimensional space is

    [ 0 I ]
    [ I D ],    D=D*.

The congruence by [[I,-D/2],[0,I]] converts this to [[0,I],[I,0]], whose inertia is (m,m). Therefore some finite larger interval has negative index at least m. No bound on the required larger interval is obtained.

## 4. The continuation read is an actual finite arithmetic shell

Let r_v=v*tilde(h), supported in [-a-1/2,a]. Its bilateral Laplace transform is R_v. For t>a, the exact explicit formula is

    O_v(t) = exp(t/2) R_v(1/2)
       - sum_n Lambda(n)/sqrt(n) r_v(t-log n)
       - sum_{k>=1} R_v(-(2k+1/2)) exp(-(2k+1/2)t).

Only

    exp(t-a) <= n <= exp(t+a+1/2)

can contribute to the prime sum. The last series is absolutely convergent because max supp r_v<=a and t>a. It is not presumed positive when v is arbitrary.

To derive the formula, translate r_v in the full Weil explicit formula. The value at zero and all positive-log prime arguments disappear for t>a. Expand the remaining archimedean kernel as sum_{k>=0} exp(-(2k+1/2)x); the k=0 term cancels the exp(-t/2) pole contribution. The remaining terms are exactly those displayed.

Each prime weight retains the established CRT ancestry:

    Lambda(n)=log(C_n/C_(n-1)),    C_n=lcm(1,...,n),

or, with compatible-reading probabilities pi_n,

    Lambda(n)=log(pi_(n+1)^2/(pi_n pi_(n+2))).

The checked `GoldbachReconstructionChain.goldbachTail_reconstruction_chain` provides the other exact route to these same weights from normalized quantitative Goldbach data. It does not replace the analytic inputs in Section 2.

Finite prime dependence does not make the unknown eigenfunction v a finite or automatically computable object. The statement is an exact finite-dimensional continuation witness with a finite arithmetic shell, not an executed RH certificate.

## 5. NS: the localized Betchov identity retains a specific current

For a smooth incompressible velocity on a periodic domain or a local Euclidean chart, set

    A=grad u,    S=(A+A^T)/2,    omega=curl u,
    J_u=cof(A)^T u.

Here A_ij=partial_j u_i and cof(A) is the matrix of signed minors, not its transpose.

The pointwise determinant identity and mixed-derivative cancellation give

    det A=det S + omega^T S omega/4,
    partial_j cof(A)_ij=0,
    div J_u=3 det A.

Consequently

    omega^T S omega = -4 det S + (4/3) div J_u.

For every compactly supported smooth cutoff chi,

    integral chi omega^T S omega
      = -4 integral chi det S
        -(4/3) integral grad chi . J_u.

The global periodic Betchov identity is only the chi=1 specialization. Localization does not remove the coupling without a residual: it moves the difference into this exact boundary current.

For a smooth NS solution, write e=|omega|^2/2. The pointwise balance is

    partial_t e - nu Delta e
      + div(u e -(4/3)J_u)
      = -4 det S - nu |grad omega|^2.

Equivalently, for a time-dependent cutoff,

    d/dt integral chi e + nu integral chi |grad omega|^2
      = integral e (partial_t chi + u.grad chi + nu Delta chi)
        -4 integral chi det S
        -(4/3) integral grad chi . J_u.

Under u_lambda(x,t)=lambda u(lambda x,lambda^2 t) and the transported cutoff chi_lambda(x,t)=chi(lambda x,lambda^2 t), the determinant integral and cofactor-boundary integral both scale by lambda^3. Neither is lower order than the other under parabolic renormalization.

On the declared mean-zero periodic source image, J_u is a derived reading of the lossless Poisson source via the Biot-Savart inverse. It is not an independently selectable boundary correction. These identities hold on the smooth core; passing them through a singular limit requires the relevant product and boundary convergence, not merely weak convergence of scalar readings.

## References and verification

Repository modules actually read include `ExcursionReturn.agda`, `GoldbachReconstructionChain.lean`, and `StrainInvariants_TheEvenMagnitudeIsBlindToTheOddShapeChargeAndNeitherFactorsThroughTheOther.agda`, pinned to the snapshot above.

J. B. Conrey, *More than two fifths of the zeros of the Riemann zeta function are on the critical line*, Journal fuer die reine und angewandte Mathematik 399 (1989), 1-26. DOI 10.1515/crll.1989.399.1. Its introduction states the positive-proportion result for simple critical-line zeros.

M. Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2, displayed manuscript version August 24, 2026. The explicit Weil distribution and localized closed-form/operator realization are used here.

`checks.py` executes eleven exact symbolic checks: the fixed packet transform, the negative continuation identity, its Gram determinant, the nullity block congruence and signature, the pointwise determinant identity, all three Piola rows, cofactor homogeneity, and the cofactor-current divergence. They do not verify the analytic zero-density or infinite-dimensional arguments, and no proof-assistant compilation was run.


---

# ORIGINAL S08 — Finite strain coordinates and actual Weil source signature
Source path: `originals/conversation/finite_strain_weil_signature/proof_note.md`; SHA-256: `19ace49ddcf9c84d1bdcab674cc5ab8e05b4d7ec31e7833dec194f72aabae896`
Transfer status: Original mounted note; legacy alias proof_note(3).

# Five-dimensional strain completion and the exact signature of the Weil form

Repository snapshot inspected: `avikj/metacircular-interaction-prototype`, commit `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope and inputs

This note proves two application-specific completion results. For whole-space incompressible velocity fields with bounded vorticity and globally bounded mean oscillation of the velocity gradient, the kernel of the vorticity reading consists exactly of affine harmonic velocities. After fixing translations, the unresolved source fibre has dimension five and has a canonical linear section given by mean strain. The bounded-mean-oscillation condition is inherited, with a scale-independent seminorm bound, from the smooth finite-energy sources used in vorticity normalization. The note also proves that all spectral coordinates of the Weil form are generated densely by translations of the previously fixed packet, identifies the full completed form as a reflection form on a weighted sequence Hilbert space, and computes its negative index exactly.

The endpoint singular-integral estimate, the John–Nirenberg theorem, classical zeta continuation and zero counting, and the Weil explicit formula are classical inputs. The proofs below spell out their application. No originality-priority claim, proof of global Navier–Stokes regularity, proof of RH, numerical zeta certificate, or Agda/Lean compilation is asserted. The attached script verifies algebraic identities and finite signature controls; it does not verify the analytical density and compactness arguments.

The inspected repository modules `Pairfield/LinearObservabilityKernel.lean` and `Pairfield/InvariantCorrectiveClosure.lean` provide the abstract observability-kernel transport and least corrective-channel closure. The results below supply concrete analytical kernels, sections, and dense realizations. The generic module statements do not themselves prove these application hypotheses.

# Part I. The whole-space NS source fibre is finite-dimensional in the inherited endpoint class

## 1. The inherited endpoint estimate

For a locally integrable matrix field F, let

\[
[F]_{\mathrm{BMO}}=\sup_B\fint_B|F-F_B|,
\qquad F_B=\fint_B F,
\]

where the supremum is over all Euclidean balls and any fixed finite-dimensional matrix norm may be used.

For a smooth divergence-free finite-energy velocity u on R3 with bounded vorticity \(\omega=\operatorname{curl}u\),

\[
\boxed{[\nabla u]_{\mathrm{BMO}}\le C\|\omega\|_\infty.}
\tag{1}
\]

The gradient is an order-zero Calderón–Zygmund transform of the vorticity:

\[
\partial_j u_i=\epsilon_{i\ell k}\partial_j\partial_\ell(-\Delta)^{-1}\omega_k.
\tag{2}
\]

A direct explanation of (1) is useful. For a ball B of radius R, split the source into its part on 2B and its complement. The local part is controlled in L2 by the bounded Fourier multiplier, so its mean oscillation on B is at most \(C\|\omega\|_\infty\). For the remote part, subtract its value at the centre. The derivative of the order-zero kernel is \(O(|y|^{-4})\), and therefore the change across B is bounded by

\[
C\|\omega\|_\infty\int_{|y|>2R}R|y|^{-4}\,dy
\le C\|\omega\|_\infty.
\]

Local delta terms in the multiplier are themselves L-infinity bounded. This proves the mean-oscillation estimate. On bounded sources without decay, the same kernel-subtraction construction defines the transform modulo an additive constant matrix.

The estimate is scale independent. For \(u_r(x)=r u(x_0+rx)\),

\[
[\nabla u_r]_{\mathrm{BMO}}=r^2[\nabla u]_{\mathrm{BMO}},
\qquad \|\operatorname{curl}u_r\|_\infty=r^2\|\omega\|_\infty.
\]

Thus a global vorticity normalization to at most one also gives a uniform BMO seminorm bound on the velocity gradient. For periodic sources on expanding tori, the periodic Calderón–Zygmund estimate has the same dilation-independent constant. On balls larger than a period, the zero-mean gradient and its cell L2 bound control the mean oscillation; on smaller balls the periodic singular-integral argument applies. Every local whole-space limit therefore inherits the global BMO bound, provided the local gradient limit exists. This is not a bound on the mean strain.

## 2. Harmonic BMO functions are constant

If f is entire harmonic and belongs to BMO(R3), the interior harmonic estimate gives, at every x and every R,

\[
|\nabla f(x)|\le\frac C R\fint_{B_R(x)}|f-f_{B_R(x)}|
\le\frac C R[f]_{\mathrm{BMO}}.
\]

Letting R tend to infinity proves that f is constant. The same conclusion applies to harmonic distributions, which are smooth by Weyl's lemma.

## 3. Complete kernel classification

Let

\[
\mathcal X=\{u\in W^{1,1}_{\mathrm{loc}}(\mathbb R^3;\mathbb R^3):
\operatorname{div}u=0,\ \operatorname{curl}u\in L^\infty,
\ [\nabla u]_{\mathrm{BMO}}<\infty\}.
\]

All gradients in this class belong locally to every finite Lp space by John–Nirenberg. Let \(S_u=(\nabla u+\nabla u^T)/2\).

### Theorem 1

\[
\boxed{
\ker(\operatorname{curl}:\mathcal X\to L^\infty)
=\{x\mapsto Ax+b:A=A^T,\ \operatorname{tr}A=0,\ b\in\mathbb R^3\}.
}
\tag{3}
\]

Proof. If h has zero divergence and curl, then \(\Delta h=0\). Every entry of \(\nabla h\) is entire harmonic and BMO, and is therefore constant. Hence \(h=Ax+b\). Zero curl makes A symmetric; zero divergence makes it trace-free. Conversely all these affine fields have zero curl and divergence, and constant gradient has zero BMO seminorm. This proves both inclusion directions.

The full kernel has dimension eight. Fixing translation leaves precisely \(\operatorname{Sym}_0(3)\), of dimension five. Higher harmonic multipoles, possible on a single ball, do not survive the global BMO gradient requirement.

## 4. A canonical split completion, with the exact source image retained

Let B be the unit ball centred at zero. Define

\[
b(u)=\fint_Bu,
\qquad A(u)=\fint_B S_u,
\qquad \mathcal N u=u-b(u)-A(u)x.
\tag{4}
\]

Then \(\mathcal N u\) is divergence free, has the same vorticity as u, and has zero mean velocity and zero mean strain on B. Further,

\[
\mathcal N^2=\mathcal N.
\]

If u and v have the same curl, Theorem 1 implies \(u-v=Ax+b\), and (4) subtracts exactly that difference. Thus \(\mathcal N u\) depends only on the vorticity.

Let \(\mathcal V=\operatorname{curl}(\mathcal X)\), the declared realized image. For \(\omega\in\mathcal V\), let \(\mathcal B_0\omega\) be the unique velocity with that curl and both normalized means zero. Then

\[
\boxed{
\mathcal X\simeq\mathcal V\times\operatorname{Sym}_0(3)\times\mathbb R^3,
\quad u\mapsto(\operatorname{curl}u,A(u),b(u)),
}
\tag{5}
\]

with inverse

\[
(\omega,A,b)\mapsto\mathcal B_0\omega+Ax+b.
\tag{6}
\]

This is an equivalence over the vorticity map. No surjectivity assertion about arbitrary independently prescribed fields has been substituted for membership in \(\mathcal V\). Every fibre is a torsor for the displayed eight-dimensional kernel; the normalized mean conditions select its unique representative.

Five additional real linear strain readings are minimal after translation is fixed: any linear observer with fewer than five scalar outputs has a nontrivial kernel on \(\operatorname{Sym}_0(3)\), whereas A(u) achieves injectivity on that fibre. This is a minimality statement for linear observers, not arbitrary set-theoretic encodings.

## 5. Stability of the completed inverse

The estimate (1) also holds for every u in \(\mathcal X\). To see this, form the Calderón–Zygmund gradient transform of its bounded vorticity modulo constants. The difference from \(\nabla u\) is a harmonic BMO matrix, hence constant. Thus their BMO seminorms coincide up to the universal transform estimate.

John–Nirenberg controls every finite Lp mean oscillation. The mean of the skew part of \(\nabla u\) is fixed by the mean vorticity, while the symmetric part is A(u). Comparing means over nested balls gives at most logarithmic growth in the radius ratio. Poincaré, with the mean velocity fixed on B, then yields, for every finite R and \(1<p<\infty\),

\[
\boxed{
\|u-v\|_{W^{1,p}(B_R)}
\le C_{p,R}\bigl(
\|\operatorname{curl}u-\operatorname{curl}v\|_\infty
+|A(u)-A(v)|+|b(u)-b(v)|\bigr).
}
\tag{7}
\]

Consequently strong vorticity convergence plus convergence of the eight finite coordinates implies local W1p convergence. This repairs the topology used in the remote-tail example: the vorticity can tend uniformly to zero while A remains a prescribed nonzero matrix, and the completed coordinate records exactly that matrix.

### Compactness version

Suppose \(u_n\in\mathcal X\), \(\sup_n\|\operatorname{curl}u_n\|_\infty<\infty\), and the coordinates A(u_n), b(u_n) are bounded. The preceding estimates give uniform W1p bounds on every ball. After a subsequence,

\[
u_n\to u\quad\text{in }C^\alpha_{\mathrm{loc}}\text{ for every }\alpha<1,
\]

and weakly in every finite local W1p space. The vorticity converges weak-star along a further subsequence; u has that vorticity and remains in \(\mathcal X\). If the vorticity weak-star limit and the limits of A and b are specified, uniqueness from (5) identifies every subsequential velocity limit, so the entire sequence converges locally in C-alpha.

This is a spatial compactness statement. It neither guarantees a nonzero weak vorticity limit, nor time compactness, nor convergence of every nonlinear derivative observable, nor boundedness of the finite coordinates along an actual singular trajectory.

## 6. Exact scale residual of the finite coordinates

Write \(A_R(u)=\fint_{B_R}S_u\), and similarly \(b_R(u)=\fint_{B_R}u\). Under \(u_r(x)=r u(rx)\),

\[
A_1(u_r)=r^2A_r(u),\qquad b_1(u_r)=r b_r(u).
\tag{8}
\]

The change of anchor is the exact cocycle

\[
A_R-A_s=(A_R-A_r)+(A_r-A_s).
\tag{9}
\]

It is this residual, not an asserted invariance of the unit-ball mean, that accompanies consecutive scale changes. BMO bounds its size by a constant times \(1+|\log(R/r)|\), multiplied by the vorticity bound; no sign is supplied.

## 7. Affine subtraction is not an NS symmetry: retain its metric and pressure

For a differentiable source history write

\[
u(x,t)=v(x,t)+A(t)x+b(t),\qquad A=A^T,\quad\operatorname{tr}A=0.
\]

The vorticity equation is exactly

\[
\partial_t\omega+(v+Ax+b)\cdot\nabla\omega
=(\nabla v+A)\omega+\nu\Delta\omega.
\tag{10}
\]

Thus deleting A removes actual stretching. The pressure also records the affine history. In particular, for arbitrary smooth A(t) symmetric trace-free and b(t),

\[
u=Ax+b,
\quad p=-\tfrac12x^T(A'+A^2)x-(b'+Ab)\cdot x
\tag{11}
\]

is an exact NS solution with zero vorticity. Unless trivial, it lies outside the finite-energy whole-space class. The compactified local equations alone do not recover the original global pressure selection.

There is an exact representation change instead of deletion. Let

\[
F'=AF,\quad F(s)=I,\qquad c'=Ac+b.
\]

Then det F=1. In coordinates \(x=F(t)y+c(t)\), put

\[
\widetilde v=F^{-1}v(Fy+c,t),
\quad\widetilde\omega=F^{-1}\omega(Fy+c,t).
\]

The transformed vorticity equation is

\[
\boxed{
\partial_t\widetilde\omega+
\widetilde v\cdot\nabla_y\widetilde\omega
=(\widetilde\omega\cdot\nabla_y)\widetilde v
+\nu(F^{-1}F^{-T}):\nabla_y^2\widetilde\omega.
}
\tag{12}
\]

The affine stretching cancels against differentiation of F-inverse. It reappears in the positive spatial metric \(g=F^TF\) and its inverse diffusion tensor. The vorticity reconstruction uses curl and Hodge operations for this transported metric; it is not legitimate to retain Euclidean curl in y coordinates. Both g and its inverse have determinant one, but their condition numbers need not remain bounded. This is lossless transport, not a dissipative estimate or a regularity conclusion.

# Part II. The completed Weil source space and its exact negative index

## 8. Definitions without RH

Let \(\Sigma\) be the set of distinct shifted nontrivial zeta zeros \(z=\rho-1/2\), with multiplicity m(z). It is a discrete subset of \(|\Re z|<1/2\), with polynomial-logarithmic counting growth. Define

\[
\theta z=-\overline z,
\quad\mathcal H=\ell^2(\Sigma,m),
\quad\langle a,b\rangle=\sum_zm(z)a_z\overline{b_z}.
\]

The scalar product is linear in its first entry. Let

\[
(Ja)_z=a_{\theta z}.
\tag{13}
\]

The functional equation gives \(m(\theta z)=m(z)\), so

\[
J^*=J,\qquad J^2=I.
\tag{14}
\]

For a compact smooth source v set

\[
(Ev)_z=V_v(z)=\int v(x)e^{-zx}\,dx.
\]

The actual centered Weil form is

\[
\boxed{Q_W(v,w)=\langle Ev,J Ew\rangle.}
\tag{15}
\]

The positive majorant is \(\|v\|_{\mathcal Z}=\|Ev\|_{\mathcal H}\). It is not an arithmetic positivity assumption. It dominates the absolute value of the form.

For completeness E is injective on compact smooth sources. Their transforms are entire of exponential type and a nonzero such transform has only O(R) zeros in disks of radius R by Jensen's formula. Unconditionally, a positive proportion of zeta zeros are simple and on the critical line; in particular there are at least c R log R distinct sample points. Vanishing of Ev forces V_v identically zero and then v=0 by Fourier uniqueness. This use of simple zeros does not assume RH.

## 9. The fixed packet is cyclic on every terminal half-line

Use

\[
h(x)=e^{-4x}(q*q)(x),\quad q=4\mathbf1_{[0,1/4]},
\quad H(z)=16\frac{(1-e^{-(z+4)/4})^2}{(z+4)^2}.
\tag{16}
\]

Its apparent pole at -4 is removable. Its zeros have real part -4, so H is nonzero on the shifted zeta strip. It decays quadratically in the imaginary coordinate there; consequently Eh is in \(\mathcal H\).

### Theorem 2

For every real T,

\[
\boxed{
\overline{\operatorname{span}\{E(T_t h):t>T\}}^{\mathcal H}
=\mathcal H.
}
\tag{17}
\]

The same assertion holds with t restricted to \(D=\mathbb Z\log2+\mathbb Z\log3\).

Proof. Suppose c is orthogonal to that orbit. For t>T,

\[
0=\sum_zm(z)H(z)\overline{c_z}\,e^{-zt}.
\tag{18}
\]

The coefficients are absolutely summable, because

\[
\sum_zm(z)|H(z)c_z|
\le\|Eh\|_{\mathcal H}\|c\|_{\mathcal H}.
\]

For Re s>1/2, taking a one-sided Laplace transform after T gives

\[
0=\sum_z\frac{m(z)H(z)\overline{c_z}e^{-zT}}{s+z}.
\tag{19}
\]

This series is normally convergent on every compact set away from the discrete pole set. It defines a meromorphic function. The residue at -z equals \(m(z)H(z)\overline{c_z}e^{-zT}\). Identity continuation and nonvanishing of H force every c_z to vanish. Therefore the orthogonal complement of the orbit span is zero.

The orbit is norm-continuous in t by dominated convergence on compact t-intervals. Restricting to the dense subgroup D leaves the same closed span.

Each translated packet is itself in the closure of E(Cc-infinity): convolve h with compact smooth approximate identities. Their transforms multiply H by factors tending pointwise to one and uniformly bounded on the shifted strip. Quadratic decay supplies a square-summable dominating sequence. Hence the majorant completion of Cc-infinity is exactly \(\mathcal H\). This proves the complete realization rather than simply defining a larger sequence space around the source image.

## 10. The complete source form is the reflection form

The preceding theorem proves

\[
\boxed{
\widehat{(C_c^\infty,\|\cdot\|_{\mathcal Z})}\simeq\mathcal H,
\qquad Q_W=\langle\,\cdot,J\cdot\,\rangle.
}
\tag{20}
\]

Every continuum of scale translations is represented by

\[
(U_ta)_z=e^{-zt}a_z,
\qquad\|U_t\|\le e^{|t|/2}.
\]

Their exact conservation law is

\[
U_t^*JU_t=J.
\tag{21}
\]

Under RH, every z is fixed by theta, so J=I and U is unitary in the positive majorant. If there is an off-critical pair, J has a negative eigendirection. The theorem does not replace J by I or supply positivity by defining a different scalar product.

## 11. Exact negative index

Define \(\operatorname{ind}_{-}(Q_W)\) as the supremum of dimensions of finite subspaces of Cc-infinity on which the form is negative definite. Then

\[
\boxed{
\operatorname{ind}_{-}(Q_W)
=\#\{\{z,\theta z\}:z\ne\theta z\}
=\#\{\rho:\zeta(\rho)=0,\ \Re\rho>1/2\}_{\mathrm{distinct}}.
}
\tag{22}
\]

Proof. A theta-fixed coordinate is positive. On each nonfixed pair, J is the two-by-two exchange matrix, with one positive and one negative eigendirection. A negative subspace injects into the negative spectral subspace via its orthogonal projection, proving the upper bound.

Conversely, choose any finite number of negative orthonormal eigenvectors of J. By (17), approximate each by the evaluation of a finite sum of translated packets. The resulting finite Gram matrix is arbitrarily close to minus the identity, hence remains negative definite. Smoothing the packet sources preserves this strict property. This supplies actual compact smooth source subspaces of every dimension up to the negative spectral dimension and proves equality.

The equality also holds if the test family is restricted to finite sums of the same packet at lattice shifts beyond any fixed T. Gaussian-rational coefficients can be used by another finite perturbation preserving strict negativity.

Multiplicity weights rescale coordinates but do not create new evaluation coordinates: the Weil form uses values, not a full jet at each multiple zero. Thus the count in (22) is of distinct reflection pairs. Nontrivial zeros have nonzero imaginary part, and conjugation pairs right-of-line zeros. When finite, the negative index is consequently even. Each distinct off-critical quartet contributes two negative directions; infinitely many such pairs give infinite negative index.

A spectral negative eigenvector need not itself be the transform of a compact source. Density, not a false surjectivity assertion on Cc-infinity, transports strict negativity to finite source witnesses.

## 12. Localized operator exhaustion

Let \(A_a\) be the self-adjoint operator of the localized closed Weil form on L2(-a,a), whose compactly supported smooth functions form a core. Its discrete spectrum has a finite number \(n_-(A_a)\) of negative eigenvalues. Form-domain inclusion makes this number nondecreasing with a. Every finite collection of compact test sources is contained in some finite interval, and every finite negative spectral subspace of a localized operator can be approximated in form norm by core functions. Therefore

\[
\boxed{
\lim_{a\to\infty}n_-(A_a)
=\operatorname{ind}_{-}(Q_W)
=\#\{\rho:\Re\rho>1/2\}_{\mathrm{distinct}}.
}
\tag{23}
\]

This is a signature/exhaustion theorem, not a proof that either side is zero. It identifies precisely which negative sectors cannot be dismissed as artifacts of an enlarged spectral carrier: each has actual finite, compact-source, fixed-packet witnesses. The explicit finite inverse of the packet, with its two retained boundary translates, remains a quantitative way of passing a given compact test to packet form.

# Joint status

On NS, the source completion supplies the complete harmonic kernel and a minimal five-scalar repair after translation, inside the BMO-gradient class inherited by globally vorticity-normalized sources. It does not bound the repaired coordinates, control their time evolution, eliminate vorticity loss in weak limits, or recover the global finite-energy pressure law from local data alone.

On RH, the receiver orbit densely generates the full majorant space, and the completed Weil form has exactly the reflection signature stated above. This does not prove the reflection is pointwise fixed. It eliminates an additional source-realizability ambiguity and computes the full negative index if off-line zeros exist.

No conclusion that either global target is nearly solved follows just from these completion theorems.

## References and exact repository loci

F. John and L. Nirenberg, On functions of bounded mean oscillation, Communications on Pure and Applied Mathematics 14 (1961), 415–426, DOI 10.1002/cpa.3160140317.

C. Fefferman and E. M. Stein, H^p spaces of several variables, Acta Mathematica 129 (1972), 137–193, DOI 10.1007/BF02392215. Classical singular-integral endpoint theory; the relevant near/far argument is included above.

J. B. Conrey, More than two fifths of the zeros of the Riemann zeta function are on the critical line, Journal für die reine und angewandte Mathematik 399 (1989), 1–26, DOI 10.1515/crll.1989.399.1. Used only for an unconditional positive proportion of distinct simple critical-line zeros.

M. Suzuki, Weil's quadratic form via the screw function, arXiv:2606.09096v2 (2026). Used for the localized closed Weil form, its core and self-adjoint discrete-spectrum realization. No conjectural large-support operator convergence is used.

Repository files read at the displayed snapshot:

`formal/lean/Pairfield/LinearObservabilityKernel.lean`

`formal/lean/Pairfield/InvariantCorrectiveClosure.lean`

The executable `checks.py` runs 32 exact algebraic checks. Its formal quartet labels are not claimed zeros of zeta. It verifies no infinite-dimensional estimate or PDE evolution.


---

# ORIGINAL S09 — Essential cross-helicity strain tomography and Hardy innovation
Source path: `originals/conversation/ns_rh_strain_symbol_hardy_innovation/proof_note.md`; SHA-256: `b23175d1efc70954277f562d4140835a8ab383d1d4f4dd5878022804a88a7656`
Transfer status: Original mounted note; legacy alias proof_note(4).

# Essential strain reconstruction and exact Hardy source recovery

Date: 2026-09-07.
Repository snapshot read: `avikj/metacircular-interaction-prototype`, `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

The results below are smooth periodic operator identities, principal-symbol and essential-norm theorems, and exact recovery/conditioning results for the specified arithmetic receiver. Classical pseudodifferential symbol theory, Hardy-space factorization, and an unconditional positive proportion of simple critical-line zeros are declared analytic inputs. The finite check script verifies algebraic identities, not these analytic inputs or global PDE continuation. No proof of RH or general Navier–Stokes regularity, originality-priority claim, or proof-assistant build is made.

The main NS result identifies the essential norm of the previously defined coadjoint cross-helicity block with one half of the pointwise strain spectral spread. Its full principal symbol reconstructs the strain, including the signed source-dependent stretching pairing. The RH result recovers the original received arithmetic signal directly from its positive two-time Hardy Gram kernel by a first-order differential operator; it does not first recover individual zeros. The finite-mode extraction problem has an exact Cauchy/Schur residual product, and its infinite system is individually minimal but not uniformly conditioned.

# I. Navier–Stokes: the essential cross-helicity operator is strain tomography

## 1. Declared generator and actual physical trajectory

On the flat three-torus let \(H\) be the complexification of mean-zero divergence-free \(L^2\) vector fields. Let \(\mathbb P\) be its orthogonal Leray projection, \(\Lambda=(-\Delta)^{1/2}\), and
\[
J=\operatorname{curl}\Lambda^{-1},\qquad P_\pm=\frac{I\pm J}{2}.
\]
All inverse multipliers act on nonzero Fourier modes.

For a real smooth divergence-free source velocity \(u\), write
\[
A=\nabla u,\qquad S=\frac{A+A^\top}{2},\qquad D_u=u\cdot\nabla.
\]
The coadjoint generator is
\[
M_uw=-\mathbb P\bigl(D_uw+A^\top w\bigr).
\]
This is not the full derivative of the autonomous Euler vector field. It is a specified source-dependent factorization satisfying
\[
M_uu=-\mathbb P((u\cdot\nabla)u)=N(u).
\]
Thus the actual NS trajectory in critical coordinates \(X=\Lambda^{1/2}u\) satisfies
\[
X_t=G_uX+\nu\Delta X,\qquad
G_u=\Lambda^{1/2}M_u\Lambda^{-1/2}.
\]
A parameter variation of the common source must still differentiate both source occurrences; nothing below freezes one occurrence and calls it the true variation.

Helicity conservation for prescribed coadjoint transport implies, on the smooth core,
\[
G_u^*J+JG_u=0.
\]
Set
\[
Q_u=\frac{G_u+G_u^*}{2},\qquad B_u=P_+G_uP_-.
\]
Then
\[
Q_u=\begin{pmatrix}0&B_u\\B_u^*&0\end{pmatrix}
\]
in the helical splitting. Although \(G_u\) is first order, \(Q_u\) and \(B_u\) are classical order-zero pseudodifferential operators.

## 2. Exact principal symbol

For a unit frequency direction \(n\), put \(P_n=I-nn^\top\). Regard the following matrix as acting on \(n^\perp\), or extend it by zero on \(\mathbb R n\):
\[
\boxed{
q_u(x,n)=-P_nS(x)P_n-\frac12(n^\top S(x)n)P_n.
}
\tag{1}
\]
This is the principal symbol of \(Q_u\).

To derive it, use \(D_u^*=-D_u\) and commutation of \(\Lambda\) with the Leray projector. The transport contribution to \(Q_u\) is
\[
\frac12\mathbb P\bigl(\Lambda^{-1/2}D_u\Lambda^{1/2}
-\Lambda^{1/2}D_u\Lambda^{-1/2}\bigr)\mathbb P.
\]
For a general weight exponent \(a\),
\[
\sigma_0([\Lambda^a,D_u]\Lambda^{-a})
=a\,n^\top S n.
\]
The displayed transport contribution therefore has symbol \(-\tfrac12(n^\top Sn)P_n\). The symmetric part of the matrix-multiplication terms has symbol \(-P_nSP_n\), proving (1).

There is an independent Fourier derivation. For a source mode \(u_p\), an input mode \(l\), and output \(k=l+p\), let \(r=(|k|/|l|)^{1/2}\). With \(p\cdot u_p=0\), the \(Q_u\) matrix coefficient is
\[
\frac i2P_k\left[
(r^{-1}-r)(u_p\cdot l)I-rpu_p^\top-r^{-1}u_pp^\top
\right]P_l.
\]
As \(l=Nn\),
\[
r^{-1}-r=-\frac{n\cdot p}{N}+O(N^{-2}),
\]
and the coefficient tends to the corresponding Fourier coefficient of (1).

Since \(\operatorname{tr}S=0\),
\[
\operatorname{tr}_{n^\perp}(P_nSP_n)=-n^\top Sn.
\]
Therefore (1) is minus the trace-free part of the strain restricted to the transverse plane. In an orthonormal transverse basis \((e_1,e_2)\),
\[
q_u|_{n^\perp}=
-\begin{pmatrix}
(S_{11}-S_{22})/2&S_{12}\\
S_{12}&-(S_{11}-S_{22})/2
\end{pmatrix}.
\tag{2}
\]
Its eigenvalues are
\[
\pm\sqrt{\bigl((S_{11}-S_{22})/2\bigr)^2+S_{12}^2}.
\]
For circular polarizations \(h_\pm=(e_1\pm ie_2)/\sqrt2\), the cross-helicity scalar symbol, up to the chosen helicity convention, is
\[
\langle h_+,q_uh_-\rangle
=-\frac{S_{11}-S_{22}}2+iS_{12}.
\]
Its modulus is precisely the transverse strain anisotropy.

## 3. Essential norm theorem

Let \(\lambda_1(x)\le\lambda_2(x)\le\lambda_3(x)\) be the strain eigenvalues. Then
\[
\boxed{
\|B_u\|_{\rm ess}=\|Q_u\|_{\rm ess}
=\frac12\max_x(\lambda_3(x)-\lambda_1(x)).
}
\tag{3}
\]
Here the essential norm of \(B_u:H_-\to H_+\) is its distance to compact operators between those Hilbert spaces.

The classical principal-symbol exact sequence identifies the norm modulo compact operators of an order-zero classical operator with the supremum of its principal-symbol norm. Apply its matrix-valued version and then the Leray/helicity corners. For any transverse plane, the restricted strain's eigenvalue spread is at most \(\lambda_3-\lambda_1\), by the Rayleigh principle. Equality is attained by the plane spanned by the extreme eigenvectors, with normal an intermediate eigenvector. Formula (2) contributes one half of this spread. Finally the off-diagonal block representation of \(Q_u\) gives equality of its essential norm and that of \(B_u\).

For trace-free symmetric matrices,
\[
\boxed{
\frac34\|S\|_{L^\infty,\rm op}
\le\|B_u\|_{\rm ess}
\le\|S\|_{L^\infty,\rm op}.
}
\tag{4}
\]
Indeed the extreme eigenvalues have opposite signs, and the smaller extreme magnitude is at least one half of the larger.

Consequently, compactness of \(B_u\) forces \(S=0\). On the torus this makes \(u\) spatially constant; mean zero gives \(u=0\). Thus vanishing or compactness of the arbitrary-input cross-helicity block is not an admissible general regularity target: every nonzero smooth mean-zero flow already has a noncompact cross-helicity block.

Similarly, integrability of this essential norm is equivalent, up to fixed constants, to integrability of the full strain supremum. The essential-norm reformulation does not by itself introduce a weaker depletion condition. Finite strain-supremum integral bounds the maximum vorticity by its maximum principle and gives the usual smooth continuation implication.

## 4. Full source recovery from the essential symbol

Let \(d\mu(n)=d\Omega(n)/(4\pi)\). Exact spherical second and fourth moments give
\[
\int_{\mathbb S^2}P_nSP_n\,d\mu(n)=\frac7{15}S,
\quad
\int_{\mathbb S^2}(n^\top Sn)P_n\,d\mu(n)=-\frac2{15}S.
\]
Thus
\[
\boxed{
S(x)=-\frac52\int_{\mathbb S^2}q_u(x,n)\,d\mu(n).
}
\tag{5}
\]
The strain's odd as well as even information is retained in this matrix-valued symbol. Taking only (3) discards its sign and orientation.

There is a finite reconstruction too. Define
\[
r_1=q_u(x,e_3)_{11},\quad r_2=q_u(x,e_3)_{12},\quad
r_3=q_u(x,e_2)_{11},\quad r_4=q_u(x,e_2)_{13},\quad
r_5=q_u(x,e_1)_{23}.
\]
Then
\[
S_{11}=-\tfrac23(r_1+r_3),\quad
S_{22}=\tfrac43r_1-\tfrac23r_3,\quad
S_{33}=-\tfrac23r_1+\tfrac43r_3,
\]
\[
S_{12}=-r_2,\quad S_{13}=-r_4,\quad S_{23}=-r_5.
\tag{6}
\]
Five scalar symbol readings reconstruct the five independent strain entries.

On the mean-zero periodic divergence-free source image,
\[
\Delta u=2\operatorname{div}S,
\qquad
u_{\rm rec}:=-2(-\Delta)^{-1}\operatorname{div}S=u.
\tag{7}
\]
Thus the essential class of the cross-helicity block is itself a faithful source coordinate. In particular,
\[
\|B_u-B_v\|_{\rm ess}
=\tfrac12\|\lambda_{\max}(S_{u-v})-\lambda_{\min}(S_{u-v})\|_\infty.
\]

## 5. The actual stretching pairing is a finite symbol observation

At a point with \(\omega\ne0\), set \(\xi=\omega/|\omega|\). Choose any orthonormal pair \(n_1,n_2\in\xi^\perp\). From (1),
\[
\xi^\top q_u(n_j)\xi=-\xi^\top S\xi-\tfrac12n_j^\top Sn_j.
\]
Since \(\{\xi,n_1,n_2\}\) is orthonormal and \(\operatorname{tr}S=0\),
\[
\boxed{
\xi^\top S\xi
=-\frac23\xi^\top\bigl(q_u(n_1)+q_u(n_2)\bigr)\xi.
}
\tag{8}
\]
This is an exact adapter from the essential cross-helicity carrier together with the physical vorticity direction to the stretching reading appearing in the peak-growth equation.

For the actual critical source \(X=\Lambda^{1/2}u\),
\[
\frac12\frac d{dt}\|X\|_2^2+\nu\|\Lambda X\|_2^2
=2\operatorname{Re}\langle X_+,B_uX_-\rangle.
\tag{9}
\]
Equations (8) and (9) are different actual-source contractions. A norm of \(B_u\) bounds both but discards their signed coupling; it cannot replace that coupling in an empty-fibre proof.

Under finite parabolic rescaling \(u_r(x,t)=r u(x_0+rx,t_0+r^2t)\),
\[
q_{u_r}(x,n,t)=r^2q_u(x_0+rx,n,t_0+r^2t),
\]
so (3), (5), (6), and (8) transport at every finite ancestry scale. No convergence of singular limits follows merely from these finite-scale identities.

# II. RH: recover the arithmetic source before trying to invert its spectral coordinates

## 6. The fixed receiver and two positive kernels

Let \(\Sigma\) denote distinct shifted nontrivial zeros \(z=\rho-\tfrac12\), with multiplicity \(m_z\). Define
\[
G(z)=256\frac{(1-2e^{-1}\cosh(z/4)+e^{-2})^2}{(16-z^2)^2},
\quad
Z(T)=\sum_{z\in\Sigma}m_zG(z)e^{zT}.
\]
The apparent poles of \(G\) are removable. It has no zero in \(|\Re z|\le1/2\), is real-even, and satisfies uniform fourth-order vertical decay on this strip. The known packet sector bound gives
\[
M_0:=Z(0)>0
\]
without RH. Standard zero counting gives
\[
\sum_zm_z(1+|z|^2)|G(z)|<\infty.
\]
Thus \(Z\in C^2(\mathbb R)\), with derivatives of order at most two bounded by a constant times \(e^{|T|/2}\).

Fix any \(s>1/2\), for example \(s=1\); this choice is unconditional. For real \(T,U\), define
\[
\mathsf H_s(T,U)=\int_0^\infty e^{-2st}Z(T+t)Z(U+t)\,dt,
\]
\[
\mathsf K_s(T,U)=\int_0^\infty t e^{-2st}Z(T+t)Z(U+t)\,dt.
\]
These are positive Gram kernels. The second is the polarized Hilbert–Schmidt Hankel pairing. The actual receiver is real, so the formulas coincide with the usual sesquilinear Gram convention on real observation times.

## 7. Exact source inverse by simultaneous time differentiation

Let
\[
\mathcal L_s=2s-\partial_T-\partial_U.
\]
Integration by parts, keeping the endpoint at zero and using exponential damping at infinity, gives
\[
\boxed{
\mathcal L_s\mathsf H_s(T,U)=Z(T)Z(U),
\qquad
\mathcal L_s\mathsf K_s(T,U)=\mathsf H_s(T,U).
}
\tag{10}
\]
Hence
\[
\boxed{
Z(T)=\frac{\mathcal L_s\mathsf H_s(T,0)}{M_0}
=\frac{\mathcal L_s^2\mathsf K_s(T,0)}{M_0}.
}
\tag{11}
\]
Derivatives in both variables are taken before setting \(U=0\).

No zero locations, Vandermonde inversion, or infinite modal conditioning estimate is needed for (11). The positive two-time arithmetic object reconstructs its original one-time source directly. This is an exact inverse in a differentiable-kernel topology, not a bounded inverse in an arbitrary weaker norm that ignores derivatives.

The primitive identity is the resolvent of simultaneous translation:
\[
\mathsf H_s=(2s-\mathcal D)^{-1}(Z\otimes Z),
\quad
\mathsf K_s=(2s-\mathcal D)^{-2}(Z\otimes Z),
\quad \mathcal D=\partial_T+\partial_U.
\]
The boundary forcing is rank one. For a nonzero real source the complete Gram kernel determines that source up to one global sign; \(M_0>0\) fixes it. For complex sources the analogous residual is one global phase.

On \(T>1/2\), the retained explicit formula reads
\[
Z(T)=e^{T/2}G(1/2)
-\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(T-\log n)-J_{\rm arch}(T),
\]
where \(g\) is the fixed compact autocorrelation and the last term retains the trivial-zero/archimedean contribution. Each prime sum is finite. Thus the inverse above is over the actual arithmetic source already reconstructed from quantitative Goldbach data; it does not replace that source by an arbitrary positive kernel.

# III. Individual spectral extraction has an exact residual, but no uniform conditioning

## 8. Finite normalized Hardy Gram determinants

For distinct \(z_1,\ldots,z_N\) in \(\Re z<s\), define
\[
h_{s,z}(t)=\sqrt{2(s-\Re z)}e^{-(s-z)t}.
\]
Their normalized Gram matrix is
\[
C_F(i,j)=\frac{2\sqrt{(s-\Re z_i)(s-\Re z_j)}}{2s-z_i-\overline{z_j}}.
\]
The Cauchy determinant formula gives
\[
\boxed{
\det C_F=\prod_{i<j}\frac{|z_i-z_j|^2}{|2s-z_i-\overline{z_j}|^2}.
}
\tag{12}
\]
Consequently, for a new distinct point \(z\),
\[
\boxed{
\operatorname{dist}\!\left(h_{s,z},\operatorname{span}\{h_{s,w}:w\in F\}\right)^2
=\frac{\det C_{F\cup\{z\}}}{\det C_F}
=\prod_{w\in F}\rho_s(z,w)^2,
}
\tag{13}
\]
where
\[
\rho_s(z,w)=\frac{|z-w|}{|2s-z-\overline w|}.
\]
This is the exact Hilbert-space residual after eliminating the old packet span. It is a Schur-complement identity, not an arbitrary numerical conditioning statistic.

For the functional-equation partner \(\theta z=-\bar z\),
\[
\rho_s(z,\theta z)^2=\frac{(\Re z)^2}{s^2}.
\]
Thus the previous two-point RH rank defect is the first member of the complete elimination-product law. It cannot be promoted to positivity failure: all distinct-mode Gram matrices here are strictly positive whether or not RH holds.

## 9. Infinite minimality

Fix a shifted zero \(z\) and let \(F\) exhaust all other distinct shifted zeros. Since \(s>1/2\), every depth \(s-\Re w\) stays in a fixed positive compact interval. Moreover
\[
1-\rho_s(z,w)^2
=\frac{4(s-\Re z)(s-\Re w)}{|2s-z-\overline w|^2}.
\]
The standard zero count implies
\[
\sum_{w\ne z}(1-\rho_s(z,w)^2)<\infty.
\]
No factor vanishes, so
\[
\boxed{
\operatorname{dist}\!\left(h_{s,z},
\overline{\operatorname{span}\{h_{s,w}:w\ne z\}}\right)^2
=\prod_{w\ne z}\rho_s(z,w)^2>0.
}
\tag{14}
\]
Each distinct mode has a nonzero orthogonal innovation and can individually be extracted by a bounded functional. Multiplicity remains a weight in the receiver; it does not create repeated independent exponential columns.

Under the Laplace realization, the closed span of these kernels is the Hardy model space \(K_{b_s}=H^2\ominus b_sH^2\), where \(b_s\) is the reduced Blaschke product with zeros \(s-\overline z\), each distinct zero used once. The Blaschke condition follows from the same summability. The complementary ambient causal space \(b_sH^2\) is not a source direction generated by these modes; it must not be identified with the coefficient-space observability kernel.

## 10. Uniform invertibility fails unconditionally

Conrey's positive-proportion theorem gives \(\gg T\log T\) distinct simple critical-line zeros through height \(T\). It follows that there are arbitrarily high pairs
\[
z=i\gamma,\qquad w=i\gamma',\qquad |\gamma-\gamma'|\to0.
\]
For such a pair,
\[
|\langle h_{s,z},h_{s,w}\rangle|
=\frac{2s}{\sqrt{4s^2+(\gamma-\gamma')^2}}.
\]
Its least Gram eigenvalue obeys
\[
\boxed{
\lambda_{\min}
=1-\frac{2s}{\sqrt{4s^2+(\gamma-\gamma')^2}}
\le\frac{(\gamma-\gamma')^2}{8s^2}\to0.
}
\tag{15}
\]
Thus there is no uniform lower Riesz bound for the full normalized zero-mode family. This ill-conditioning already occurs among zeros known to be on the critical line and cannot be treated as evidence of off-criticality.

The same counting theorem gives unit-height intervals containing arbitrarily many distinct critical-line zeros. Within any such interval,
\[
\operatorname{Re}C_F(i,j)\ge\frac{4s^2}{4s^2+1}.
\]
The all-ones Rayleigh quotient yields
\[
\lambda_{\max}(C_F)\ge\frac{4s^2}{4s^2+1}|F|\to\infty.
\]
So the unweighted normalized family has no uniform upper Bessel bound either.

The faithful receiver weights make the corresponding synthesis operator Hilbert–Schmidt, but an injective infinite-rank compact operator has no bounded inverse onto its range equipped with the ambient norm. Exact source recovery in (11) and exact mode-by-mode recovery in (14) must therefore be kept separate from uniform stable spectral reconstruction.

# IV. Consequences for the theorem graph

The source-dependent coadjoint cross-helicity block has not supplied a smaller norm obstruction than strain: its essential norm is exactly half the strain spectral spread. Its full symbol does, however, retain the signed information and gives the explicit stretching reconstruction (8). This supplies a precise infinitesimal bridge between the critical-helicity and vorticity-source descriptions without confusing arbitrary-input response with an actual source variation.

The positive Hardy and Bergman two-time kernels do not require an unknown infinite modal inversion to recover their original arithmetic receiver: (11) is an exact boundary-resolvent inverse. Extracting individual modes has the explicit product residual (13)-(14), while uniform conditioning fails even on critical-line data.

The remaining global implications are not asserted here. In NS one must control the physical source contractions while preserving the matched renormalized histories, rather than demand vanishing of an operator nonzero for every nontrivial flow. In RH the exact source and Gram reconstructions do not force the reflected-orbit Gram rank to collapse. Positivity of the well-damped Gram object remains compatible with off-critical zeros.

## Primary analytic references

S. T. Melo, *Norm closure of classical pseudodifferential operators does not contain Hörmander's class*, arXiv:math/0312261, especially Theorem 2 and Corollary 2. Matrix amplification and orthogonal pseudodifferential corners give the symbol-norm statement used here.

N. Nikolski, *Distance formulae and invariant subspaces, with an application to localization of zeros of the Riemann zeta-function*, Annales de l'Institut Fourier 45 (1995), 143–159, DOI 10.5802/aif.1451. The Hardy distance and invariant-subspace framework is classical.

J. B. Conrey, *More than two fifths of the zeros of the Riemann zeta function are on the critical line*, Journal für die reine und angewandte Mathematik 399 (1989), 1–26, DOI 10.1515/crll.1989.399.1. Only the unconditional positive proportion of distinct simple critical-line zeros is used, not any assertion about the remaining zeros.

## Verification

`checks.py` executes 20 exact symbolic controls. These include the critical-weight Fourier correction, the transverse symbol, its helical block and five-reading inverse, spherical tomography, two-direction stretching reconstruction, Hardy/Bergman source inverses, Cauchy determinants, and the finite innovation law. They are finite algebra checks, not an Agda/Lean build or a validation of the infinite analytic theorems.


---

# ORIGINAL S10 — Passive-work distinction and toroidal multipole blindness
Source path: `originals/conversation/passivity_toroidal_quadrupole/proof_note.md`; SHA-256: `d6764d2d263c402f31555e6368eee481259d38be61a1046e6afcb5696dbbccd1`
Transfer status: Original mounted note; legacy alias proof_note(5).

# Work balance and toroidal quadrupole selection

Date: 2026-09-07.
Repository source read at 168ea8e240524f898af4b0e9cf70297c38422f08.

## Scope

This note changes the mathematical description to passive input-output systems and spherical multipole analysis. It proves a finite-energy vorticity-shell separation result and the exact angular selection rule for central strain. It also translates the established fixed-receiver RH criterion into causal passivity. It does not prove RH or global Navier–Stokes regularity. No Agda/Lean build or numerical PDE evolution is claimed. The separate script checks finite polynomial identities; the infinite and PDE arguments below are analytic proofs.

## 1. Exactly which spherical polarization generates central strain

On R^3 use
u(x)=(4 pi)^(-1) integral omega(y) cross (x-y) / |x-y|^3 dy.
Assume initially smooth sufficiently decaying divergence-free vorticity and the corresponding finite-energy velocity. The derivative and angular identities may also be used with radial cutoffs on individual shells.

Writing y=r n, n in S^2, differentiation of Biot–Savart and symmetrization give
S(0) = (3/(8 pi)) p.v. integral_0^infinity dr/r integral_S2
[n tensor (n cross omega(r n)) + (n cross omega(r n)) tensor n] dOmega(n).

For A a real trace-free symmetric 3x3 matrix define
T_A(n)=n cross (A n).
This is a toroidal degree-two vector spherical harmonic:
T_A=(1/2) n cross grad_S(n^T A n).
It is tangential and has zero surface divergence.

For any vector field f on S^2, write
C(f)=integral_S2 [n tensor (n cross f)+(n cross f) tensor n] dOmega.
Then C(f) is symmetric trace-free, and
A:C(f)=-2 integral_S2 f dot T_A dOmega.

Consequently the central strain depends only on the orthogonal projection of each shell's vorticity onto the five-dimensional space {T_A:A in Sym_0(3)}. Other angular polarizations do not contribute to this instantaneous central strain reading.

The normalization is exact:
integral_S2 T_A dot T_B dOmega=(4 pi/5) tr(A B).
Thus the projection coefficient A_r is determined by
integral_S2 omega(r n) dot T_B(n) dOmega=(4 pi/5) tr(A_r B)
for all B in Sym_0(3). Equivalently A_r=-(5/(8 pi)) C(omega(r dot)).
The strain reconstruction is
S(0)=-(3/5) p.v. integral_0^infinity A_r dr/r.

No autonomous evolution law for the five shell coefficients is asserted. Other angular sectors can affect their future evolution.

## 2. All gradient moments can vanish while central strain is prescribed

Fix f in C_c^infinity((R,2R)), R>0, and A in Sym_0(3), and set
omega_A(r n)=f(r) T_A(n).
Equivalently omega_A(x)=f(|x|)|x|^(-2) x cross (A x).

This field is smooth compactly supported and divergence-free. Indeed x cross (A x) is tangent to spheres, and its Cartesian divergence vanishes because A is symmetric. Multiplication by a radial function preserves divergence-free-ness.

For every radius rho>0 and every smooth scalar test H,
integral_Brho omega_A dot grad H dx
= integral_boundary_Brho H omega_A dot n dS
  - integral_Brho H div omega_A dx
=0.

In particular EVERY harmonic-gradient moment is zero on EVERY concentric ball, not merely asymptotically or after selecting a favorable radius.

Nevertheless the central strain is
S_A(0)=-(3/5) A integral_0^infinity f(r) dr/r.
To check the coefficient, use
n cross (n cross A n)=n(n^T A n)-A n
and the exact spherical second and fourth moments. The angular tensor integral is
integral_S2 [n tensor (n cross T_A)+(n cross T_A) tensor n] dOmega
=-(8 pi/5) A.

Taking a nonzero radial integral realizes any prescribed trace-free symmetric central strain by selecting A.

The corresponding velocity u_A=curl(-Delta)^(-1)omega_A is smooth and finite-energy. Its vector potential has pure degree-two angular dependence. Inside the source-free ball |x|<R,
(-Delta)^(-1)omega_A(x)
=(1/5)(integral f(r) dr/r) x cross A x.
Since curl(x cross A x)=-3 A x,
u_A(x)=-(3/5)(integral f(r) dr/r) A x
there. In particular u_A(0)=0.

Outside the compact vorticity support the vector potential decays as O(|x|^-3) and the velocity as O(|x|^-4); finite energy follows. The compactly supported vorticity, rather than compact velocity, is the declared source here.

This proves an exact non-factorization: the complete family of centered-ball gradient moments does not determine central strain, even among smooth finite-energy sources.

## 3. Separation of actual NS initial continuations

Let v be smooth compactly supported divergence-free initial velocity whose vorticity is the constant nonzero vector omega_0 near the origin. Choose R beyond that neighborhood. Compare the two NS initial velocities v and v+u_A, each of which has a local classical evolution.

Their vorticities agree near the origin, and all centered-ball gradient moments of their vorticities agree because the added shell has every such moment zero. The added velocity vanishes at the origin, so their initial velocity values agree there too.

The actual vorticity equation is
partial_t omega=-(u dot grad)omega+(omega dot grad)u+nu Delta omega.
At time zero and the origin, the derivative difference is precisely
partial_t omega_(v+u_A)-partial_t omega_v
= S_A(0) omega_0
=-(3/5)(integral f(r) dr/r) A omega_0.
This is nonzero when A omega_0 != 0.

These are separate admissible initial-value problems. No common blow-up trajectory is constructed. The conclusion is that the proposed moment measurements are insufficient to reconstruct even this actual first continuation.

For f_R(r)=phi(r/R) with phi fixed in C_c^infinity((1,2)), the central strain and global vorticity supremum are independent of R up to the fixed amplitude A. The velocities scale as u_R(x)=R u_1(x/R), and their kinetic energies scale as R^5. They are thus consistent with the earlier energy-only affine-strain threshold. Above that scale the full vorticity reconstruction includes the shell; replacing it by its gradient moments would erase the shell's entire strain contribution.

## 4. An admissibility correction for higher remote jets

For a remote vorticity source with ||omega||_infinity<=1, supported outside B_R, an m-th velocity derivative, m>=2, obeys
|nabla^m u_far(0)|
<= C_m integral_R^infinity r^2 r^(-m-2) dr
= C_m/(m-1) R^(1-m).

Thus any R tending to infinity suppresses higher remote velocity jets under the global bounded-vorticity condition. The strain m=1 is the borderline logarithmic case.

The earlier cutoff realization of a fixed degree-m harmonic velocity jet has vorticity magnitude proportional to R^(m-1). For m>=2 it violates the global normalized bound as R grows. Its energy-only sharpness remains valid in that weaker class, but must not be called sharp for the full vorticity-normalized blow-up class.

## 5. The arithmetic receiver as a passive one-port

Assume the established receiver data: a continuous real even function Z with M_0=Z(0)>0; its received spectral expansion has nonzero weights at every shifted zeta zero; the fixed-receiver theorem states RH iff |Z(t)|<=M_0 for every t, equivalently iff Z is positive definite.

For compactly supported smooth input f define the zero-state causal output
y_f(t)=integral_-infinity^t Z(t-r) f(r) dr.
The net supplied work is
W(f)=Re integral_R conjugate(f(t)) y_f(t) dt.

Because Z is real and even,
2 W(f)=integral_R integral_R conjugate(f(t)) Z(t-r) f(r) dr dt.
All integrations are over a compact input square; no stability hypothesis is needed merely to define the work.

Therefore
RH iff W(f)>=0 for every compact smooth input f.

For the converse it is enough to approximate two unit-area impulses at times 0 and t, with the relative sign chosen to minimize work. The work tends to M_0-|Z(t)|. Thus passivity forces the established two-point RH inequality.

Under RH, Z(t)=sum_gamma c_gamma exp(i gamma t), with c_gamma=m_gamma G(i gamma)>0 and sum c_gamma=M_0. The oscillator realization
a_gamma'=i gamma a_gamma+f, a_gamma(-infinity)=0,
y=sum_gamma c_gamma a_gamma
has nonnegative storage
E=(1/2)sum_gamma c_gamma |a_gamma|^2
and exact supply identity
E'=Re(conjugate(f)y).
This storage representation is conditional on RH; it is not an arithmetic construction proving RH.

The Laplace transfer function, initially for Re p>1/2, is
F(p)=integral_0^infinity exp(-pt)Z(t)dt
=sum_z m_z G(z)/(p-z).
Under RH it extends to Re p>0 and Re F(p)>0. Conversely a holomorphic extension to the whole right half-plane excludes any shifted zero there, by the nonzero residues, and functional-equation reflection gives RH.

## 6. Why every positive damped-output tower can coexist with activity

For any real continuous impulse response Z of exponential type, all kernels
G_(n,s)(T,U)=integral_0^infinity t^n exp(-2st)Z(T+t)Z(U+t)dt
are positive semidefinite whenever convergent. That is squared-output positivity, not passivity.

Explicit control: Z_a(t)=cosh(a t), a>0.
Every above kernel is finite and positive for s>a. Yet opposite unit impulses at 0,T have limiting supplied work
1-cosh(aT)<0.
Thus an active hyperbolic system passes every convergent squared-output positivity test.

This example does not refute the arithmetic RH criterion. It proves that positivity supplied solely by damped squaring cannot yield the required signed supply inequality. The arithmetic content must enter before that sign is discarded.

## Conclusions

The NS calculation identifies the precise angular component that determines central strain: the toroidal quadrupole. It gives exact smooth finite-energy examples in which all harmonic-gradient measurements vanish while this component and the actual initial stretching are nonzero.

The RH translation identifies the signed quantity whose positivity is required: input-output work, not output squared. Its all-input passivity is the established fixed-receiver criterion in network language. No proof of the arithmetic supply inequality is supplied.

Primary background:
J. C. Willems, "Dissipative dynamical systems, Part I", 1972.
P. Constantin and C. Fefferman, "Direction of Vorticity and the Problem of Global Regularity for the Navier–Stokes Equations", 1993.
J. Novak, J.-L. Cornou, N. Vasset, "A spectral method for the wave equation of divergence-free vectors and symmetric tensors inside a sphere", arXiv:0905.2048.


---

# ORIGINAL S11 — Actual Xi-cardinal sources and renormalized toroidal strain current
Source path: `sources/S11_cardinal_and_current.md`; SHA-256: `8b2f79a0737c1d4a3641a909d72b94289eefacd4988971ec50d4a00180076848`
Transfer status: Recovered proof_note(6).md.

# Explicit spectral-source interpolation and the renormalized strain current

Date: 2026-09-07.
Repository snapshot inspected: `avikj/metacircular-interaction-prototype`, `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status

This note derives two additions to the existing theorem graph. The arithmetic addition is an explicit source realizing any finitely supported zero-coordinate vector, together with a global alternative for the localized Weil spectral bottom. The fluid addition is the exact evolution/current law of the already-identified toroidal quadrupole observer under time-dependent parabolic renormalization.

The arguments below use classical facts about the completed zeta function, the explicit formula, Fourier inversion, and smooth incompressible Navier–Stokes. They are mathematical proofs in the stated classes, not a proof-assistant build. No originality-priority claim, actual off-critical zeta zero, proof of RH, or exclusion of general NS blow-up is asserted. The executable companion checks finite algebra and differential identities only.

# I. Arithmetic: interpolate the actual source, not an independent spectrum

## 1. Retained objects

Use

\[
\xi(s)=\tfrac12s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s),
\qquad \Xi(z)=\xi(\tfrac12+z).
\]

Thus \(\Xi\) is even and entire, real on the real axis. Its zeros are exactly the shifted nontrivial zeros of zeta. Let \(\Sigma\) be the set of distinct zeros, \(m_z\) their multiplicities, and

\[
\theta z=-\overline z,
\qquad
\mathcal H=\ell^2(\Sigma,m),
\qquad (Ja)_z=a_{\theta z}.
\]

The Hilbert inner product is linear in the first argument. For compact smooth sources,

\[
V_f(z)=\int_{\mathbb R}f(x)e^{-zx}\,dx,
\qquad (Ef)_z=V_f(z),
\qquad
Q_W(f,g)=\langle Ef,J Eg\rangle_{\mathcal H}.
\tag{1}
\]

This is the actual Weil form, not a new definition of an unrelated RH slot. The prior work already supplies (1), the majorant norm, the fixed packet inverse, and the arithmetic/CRT/quantitative-Goldbach ancestry of its prime weights. The new construction below gives explicit preimages of the individual coordinate vectors in a larger, precisely specified source class, then returns to compact sources with the residual retained.

## 2. A source class stable under division by a finite zero divisor

Let \(\mathscr S_{\exp}\) consist of smooth functions for which

\[
\int_{\mathbb R}e^{A|x|}|f^{(k)}(x)|\,dx<\infty
\quad\text{for every }A>0\text{ and every integer }k\ge0.
\tag{2}
\]

On every fixed vertical strip, Stirling's formula for the gamma factor and the usual polynomial vertical-strip bounds for zeta give

\[
|\Xi(a+it)|\le C_{A}(1+|t|)^{N_A}e^{-\pi|t|/4},
\qquad |a|\le A,
\tag{3}
\]

for suitable constants. Removing finitely many zero factors and multiplying by a polynomial preserves a bound of this form. Apparent singularities at the removed zeros are filled by their analytic values.

If an entire \(F\) has (3) on every fixed vertical strip, set

\[
f(x)=\frac1{2\pi}\int_{\mathbb R}F(it)e^{itx}\,dt.
\tag{4}
\]

Contour shifting proves

\[
f^{(k)}(x)=\frac1{2\pi}\int_{\mathbb R}(a+it)^kF(a+it)e^{(a+it)x}\,dt.
\]

For positive \(x\), choose \(a\) negative; for negative \(x\), choose it positive. The horizontal sides vanish by (3). Choosing the shift larger than any prescribed exponential weight proves (2). Fourier uniqueness and analytic continuation then give \(V_f=F\).

No compact support is asserted for these inverse sources.

## 3. Explicit cardinal sources, with multiplicities retained

For each \(z\in\Sigma\), define

\[
\boxed{
I_z(w)=\frac{m_z!}{\Xi^{(m_z)}(z)}\,
       \frac{\Xi(w)}{(w-z)^{m_z}}.
}
\tag{5}
\]

The denominator in front is nonzero by the definition of multiplicity. The apparent singularity at \(w=z\) is removable. Consequently

\[
\boxed{I_z(v)=\mathbf1_{v=z}\quad(v\in\Sigma).}
\tag{6}
\]

Let \(f_z\in\mathscr S_{\exp}\) be the inverse Fourier source constructed in (4). Then

\[
\boxed{Ef_z=e_z.}
\tag{7}
\]

Thus a finitely supported coordinate vector \(a\) has the explicit source

\[
f_a=\sum_{z\in\operatorname{supp}a}a_zf_z,
\qquad Ef_a=a.
\tag{8}
\]

This construction does not assume that zeta zeros are simple, a maximal real part is attained, or other zeros can be discarded. All the other coordinates vanish because the same entire \(\Xi\) remains in the numerator.

For an off-line zero \(z=\alpha+i\gamma\), \(\alpha>0\), let \(m=m_z=m_{\theta z}\). Then

\[
a=\frac{e_z-e_{\theta z}}{\sqrt{2m}}
\quad\Longrightarrow\quad
\|a\|_{\mathcal H}=1,
\quad Ja=-a.
\tag{9}
\]

Its source is exactly

\[
f_a=\frac{f_z-f_{\theta z}}{\sqrt{2m}},
\qquad \langle Ef_a,J Ef_a\rangle=-1.
\tag{10}
\]

The pairing in (10) is first understood spectrally on the larger source class. The following cutoff construction returns it to the original compact smooth domain of the classical explicit formula.

## 4. The compactification error is a retained source coordinate

Choose \(\chi\in C_c^\infty(-1,1)\), \(0\le\chi\le1\), equal to one on \([-1/2,1/2]\). Write

\[
f_R=\chi(x/R)f,
\qquad r_R=f_R-f.
\]

For \(w=a+it\), \(|a|\le1/2\), two integrations by parts give

\[
|V_{r_R}(a+it)|
\le\frac{\epsilon_R}{1+t^2},
\quad
\epsilon_R=
\sum_{j=0}^{2}\|e^{|x|/2}r_R^{(j)}\|_{L^1}.
\tag{11}
\]

Indeed, applying \(1-\partial_x^2\) to \(e^{-ax}r_R\) gives
\(e^{-ax}[(1-a^2)r_R+2ar_R'-r_R'']\), whose \(L^1\) norm is bounded by \(\epsilon_R\).

The classical zero-count estimate makes

\[
C_\Sigma^2=\sum_{w\in\Sigma}\frac{m_w}{(1+|\Im w|^2)^2}<\infty.
\]

Hence the exact residual and its bound are

\[
Ef_R=Ef+Er_R,
\qquad
\|Er_R\|_{\mathcal H}\le C_\Sigma\epsilon_R.
\tag{12}
\]

For \(f\in\mathscr S_{\exp}\), for every \(L>0\) there is \(C_{f,L}\) such that

\[
\|Er_R\|_{\mathcal H}\le C_{f,L}e^{-LR}
\quad(R\ge1).
\tag{13}
\]

Cutoff derivatives only contribute polynomial factors in \(R^{-1}\); (2), with a larger exponential weight, absorbs them.

If \(Ef=a\) is the vector (9) and \(\delta=Er_R\), then

\[
Q_W(f_R,f_R)
=-1+2\Re\langle a,J\delta\rangle+\langle\delta,J\delta\rangle.
\tag{14}
\]

In particular \(\|\delta\|\le1/4\) gives

\[
\boxed{Q_W(f_R,f_R)\le-7/16.}
\tag{15}
\]

Thus an assumed off-line zero yields a compact smooth negative test without an unspecified density argument. The cutoff error is not removed from the source description.

The existing fixed-packet inverse then transports this compact negative test into finite combinations of translates of the already specified packet. Its prime weights remain the reconstructed \(\Lambda(n)\), including the archimedean and pole terms in the explicit formula. This is an existence/construction theorem from a hypothetical zero, not an executed numerical certificate.

## 5. Exponential spectral escape on expanding support intervals

Define the actual localized variational bottom

\[
\lambda_a=
\inf_{0\ne f\in C_c^\infty(-a,a)}
\frac{Q_W(f,f)}{\|f\|_2^2}.
\tag{16}
\]

The classical localized form theory identifies this with the lowest eigenvalue of its self-adjoint realization. For the argument below it is enough that \(\lambda_a\) is finite for each \(a\) and is nonincreasing as \(a\) increases.

Fix an off-line zero \(z=\alpha+i\gamma\), \(\alpha>0\), and \(0<\varepsilon<1\). Put

\[
g_{z,R}=\chi(x/R)f_z,
\qquad R=\varepsilon T,
\qquad (T_bf)(x)=f(x-b).
\]

Construct the compact source

\[
\boxed{
v_T=
\frac{e^{-zT}T_{-T}g_{z,R}
      -e^{\theta z\,T}T_Tg_{\theta z,R}}{\sqrt{2m}}.
}
\tag{17}
\]

Its support lies in \((-(1+\varepsilon)T,(1+\varepsilon)T)\). The source amplitudes have magnitude \(e^{-\alpha T}\), so

\[
\|v_T\|_2^2\le C_z e^{-2\alpha T}.
\tag{18}
\]

Without the cutoffs its evaluation vector would be exactly (9), because

\[
E(T_bf)(w)=e^{-wb}Ef(w).
\]

The unconditional critical strip gives
\(\|E(T_bf)\|\le e^{|b|/2}\|Ef\|\). Thus (13) implies

\[
\|Ev_T-a\|_{\mathcal H}
\le C_{z,L}e^{(1/2-\alpha)T-L\varepsilon T}.
\tag{19}
\]

Choose any \(L\) with \(L\varepsilon>1/2-\alpha\). Then \(Ev_T\to a\), so \(Q_W(v_T,v_T)\to-1\). Equations (18)–(19) prove, for all sufficiently large support parameters,

\[
\boxed{
\lambda_a\le-c_{z,\varepsilon}
\exp\!\left(\frac{2\alpha}{1+\varepsilon}a\right).
}
\tag{20}
\]

No dominant-zero assumption or cancellation estimate for the full exponential zero sum is used: the other coordinates were eliminated by the actual source (5), before translation and cutoff.

Let

\[
\delta=\sup\{\Re z:z\in\Sigma\}.
\]

Under failure of RH, \(\delta>0\), and (20) gives

\[
\boxed{
\liminf_{a\to\infty}\frac{\log(-\lambda_a)}a\ge2\delta.
}
\tag{21}
\]

This assertion is only made after \(\lambda_a\) has become negative.

## 6. The other branch: a concrete vanishing sequence

Let \(\varphi\in\mathscr S_{\exp}\) be the inverse source of \(\Xi\) itself. It is nonzero, but

\[
\boxed{E\varphi=0.}
\tag{22}
\]

The compact cutoffs \(\varphi_R=\chi(x/R)\varphi\) satisfy

\[
\|E\varphi_R\|\to0,
\qquad
\|\varphi_R\|_2\to\|\varphi\|_2>0.
\tag{23}
\]

Under RH, \(J=I\), so the localized forms are nonnegative. Their Rayleigh quotients on (23) tend to zero. Therefore

\[
\boxed{
\begin{array}{ll}
\mathrm{RH}:&\lambda_a\downarrow0,\\[2mm]
\neg\mathrm{RH}:&\lambda_a\downarrow-\infty,
\quad\text{with the exponential lower growth bound (21).}
\end{array}
}
\tag{24}
\]

In particular,

\[
\boxed{
\mathrm{RH}
\iff
\exists C\ge0\;\forall f\in C_c^\infty(\mathbb R),
\quad Q_W(f,f)\ge-C\|f\|_2^2.
}
\tag{25}
\]

Any global lower bound suffices; its constant need not be zero. More generally, a subexponential bound on the negative part of \(\lambda_a\) suffices by (21).

Equation (22) is an important domain distinction. Evaluation is faithful on the earlier compact-source class, but not on \(\mathscr S_{\exp}\). The larger source class has genuine invisible sources. The construction does not silently extend compact-source faithfulness, and (25) does not assert the existence of a closed global form on the original unweighted \(L^2(\mathbb R)\) carrier.

### Elementary arithmetic upper control on the escape exponent

For completeness, the full explicit formula yields a uniform finite-window lower bound of the form

\[
\lambda_a\ge-C(1+a)e^a.
\tag{26}
\]

Here is a direct proof. For \(h=f*\widetilde f\), \(h(0)=\|f\|_2^2\), \(|h(t)|\le h(0)\), and \(h\) is supported in \([-2a,2a]\). The two pole terms are bounded in absolute value by \(4\sinh(a)\|f\|_2^2\), by Cauchy–Schwarz for \(V_f(\pm1/2)\). The prime terms are bounded below by

\[
-2\|f\|_2^2\sum_{n\le e^{2a}}\frac{\Lambda(n)}{\sqrt n}
\ge-C(1+a)e^a\|f\|_2^2,
\]

using only \(\Lambda(n)\le\log n\). The archimedean integral has a global constant lower bound because its kernel

\[
k(t)=\frac{e^{t/2}}{e^t-e^{-t}}
\]

is positive and

\[
h(t)+h(-t)-2e^{-t/2}h(0)
\le2(1-e^{-t/2})h(0),
\]

with \(\int_0^\infty(1-e^{-t/2})k(t)dt<\infty\). Include the constant term at zero to obtain (26).

Together, under failure of RH,

\[
2\delta\le\liminf_{a\to\infty}\frac{\log(-\lambda_a)}a
\le\limsup_{a\to\infty}\frac{\log(-\lambda_a)}a\le1.
\tag{27}
\]

No assertion that the lower and upper exponents coincide is made.

# II. Navier–Stokes: evolve the strain-bearing observer through renormalization

## 7. The retained five-component source observer

For \(A\in\operatorname{Sym}_0(3)\), define

\[
T_A(n)=n\times An,\qquad n\in\mathbb S^2.
\]

The previous toroidal-selection calculation gives

\[
\int_{\mathbb S^2}T_A\cdot T_B\,d\Omega
=\frac{4\pi}{5}\operatorname{tr}(AB).
\tag{28}
\]

For a vorticity field \(\Omega\), let \(C_r\in\operatorname{Sym}_0(3)\) be determined by

\[
\int_{\mathbb S^2}\Omega(rn)\cdot T_A(n)\,d\Omega
=\frac{4\pi}{5}\operatorname{tr}(C_rA).
\tag{29}
\]

For the decaying whole-space Biot–Savart source, the central strain is

\[
S(0)=-\frac35\operatorname{p.v.}\int_0^\infty C_r\frac{dr}{r}.
\tag{30}
\]

On finite annuli, (29) defines the exact contribution whether or not an infinite integral has been justified. A separately retained harmonic/affine source component is not silently removed from the velocity or from its dynamics.

## 8. A time-dependent parabolic zoom of one actual solution

Let \(u(x,t)\) be a smooth NS solution, with viscosity \(\nu>0\), on the time interval considered. Choose a positive differentiable scale \(\rho(t)\) and a sufficiently differentiable center \(c(t)\). Set

\[
\frac{d\tau}{dt}=\rho(t)^{-2},
\quad
U(y,\tau)=\rho(t)[u(c(t)+\rho(t)y,t)-\dot c(t)],
\quad
\Omega(y,\tau)=\rho(t)^2\omega(c(t)+\rho(t)y,t),
\]

and

\[
\eta(\tau)=\frac{d\log\rho}{d\tau}=\rho\dot\rho.
\]

A direct chain rule in the actual vorticity equation gives

\[
\boxed{
\partial_\tau\Omega
=\operatorname{curl}(U\times\Omega)
+\nu\Delta\Omega
+\eta(y\cdot\nabla\Omega+2\Omega).
}
\tag{31}
\]

Equivalently, the first and last terms are
\(\operatorname{curl}((U-\eta y)\times\Omega)\). Constant frame acceleration contributes only a pressure gradient and does not enter (31).

The full \(U\) is retained. In particular, a harmonic strain present in a local limit is not omitted from \(\operatorname{curl}(U\times\Omega)\).

## 9. Projection commutes with angular diffusion, not with nonlinear evolution

The homogeneous polynomial \(x\times Ax\) is harmonic of degree two. Consequently each Cartesian component of \(T_A\) obeys

\[
\Delta_{\mathbb S^2}T_A=-6T_A.
\]

Applying (29) to (31) therefore gives the exact equation

\[
\partial_\tau C_r
=\nu\left(\partial_r^2C_r+\frac2r\partial_rC_r-\frac6{r^2}C_r\right)
+N_r+\eta(r\partial_rC_r+2C_r),
\tag{32}
\]

where the nonlinear source is specified, not free:

\[
N_r=\Pi_{2,\mathrm{tor}}
\big[\operatorname{curl}(U\times\Omega)(r\,\cdot,\tau)\big].
\tag{33}
\]

All omitted angular sectors can influence (33). Thus (32) is an exact projected law with a same-source forcing, not a closed five-variable model of NS.

## 10. The renormalized current in logarithmic radius

Put

\[
\ell=\log r,\qquad B(\ell,\tau)=C_{e^\ell}(\tau),
\qquad \mathcal N(\ell,\tau)=N_{e^\ell}(\tau).
\]

The radial diffusion term becomes

\[
e^{-2\ell}(B_{\ell\ell}+B_\ell-6B)
=\partial_\ell\left[e^{-2\ell}(B_\ell+3B)\right].
\]

Define the current

\[
\boxed{
\mathcal F(\ell,\tau)
=\nu e^{-2\ell}(B_\ell+3B)+\eta B.
}
\tag{34}
\]

Then (32) becomes the exact five-component balance

\[
\boxed{
(\partial_\tau-2\eta)B-\partial_\ell\mathcal F=\mathcal N.
}
\tag{35}
\]

This is the temporal ancestry law of the already constructed strain-bearing observer. The viscous contribution to its logarithmic primitive is a boundary current, with all coefficients fixed by the angular degree.

For a finite logarithmic interval \([L_-,L_+]\), set

\[
\mathcal S_{[L_-,L_+]}=-\frac35\int_{L_-}^{L_+}B\,d\ell.
\]

Integrating (35) gives

\[
\boxed{
(\partial_\tau-2\eta)\mathcal S_{[L_-,L_+]}
=-\frac35\int_{L_-}^{L_+}\mathcal N\,d\ell
-\frac35\,[\mathcal F]_{L_-}^{L_+}.
}
\tag{36}
\]

An intermediate boundary cancels exactly when adjacent annuli are joined. No boundary term is called lower order, no projected source is allowed to choose its own nonlinear forcing, and no independence of radii is assumed.

The integrating factor makes the time-history composition explicit. With

\[
\mu(\tau)=\exp\left(-2\int_{\tau_0}^{\tau}\eta(s)ds\right)
=\frac{\rho(\tau_0)^2}{\rho(\tau)^2},
\]

one has

\[
\mu(\tau_1)\mathcal S(\tau_1)-\mathcal S(\tau_0)
=-\frac35\int_{\tau_0}^{\tau_1}\mu(\tau)
\left(\int_{L_-}^{L_+}\mathcal N\,d\ell
+[\mathcal F]_{L_-}^{L_+}\right)d\tau.
\tag{37}
\]

Time subdivision also telescopes. Equations (36)–(37) are the explicit additive residual maps for this observer. They instantiate the repository's retained-residual/commutation pattern with a concrete smooth PDE calculation; the generic residual theorem alone is not being presented as that calculation.

## 11. The small-radius endpoint is local viscous strain, not zero

For a smooth velocity, angular parity and Taylor expansion give

\[
C_r=r^2C_2+O(r^4),
\qquad C_2=\frac13\Delta S(0).
\tag{38}
\]

One way to verify the coefficient is to apply (29) to the quadratic Taylor part of \(\operatorname{curl}U\), using the fourth spherical moments and \(\Delta U=-\operatorname{curl}\Omega\). Equivalently it is a universal identity on divergence-free cubic velocity jets.

Thus

\[
\lim_{\ell\to-\infty}\mathcal F(\ell,\tau)
=5\nu C_2
=\frac{5\nu}{3}\Delta S(0).
\tag{39}
\]

When the outer endpoint vanishes and all infinite integrals are justified, its contribution in (36) is therefore \(+\nu\Delta S(0)\), as required by the true strain equation. Simply deleting both endpoint currents would lose the local viscous term.

The companion script checks (38) on the full monomial basis of homogeneous quartic vector potentials. Their curls span divergence-free homogeneous cubic velocities: for a homogeneous divergence-free vector field of degree three, the elementary homotopy formula supplies a degree-four vector potential. The general proof is the linear Taylor/moment argument, not a numerical test of a few fluid evolutions.

## 12. Relation to the existing operator and continuation graph

Use the local algebraic symbol formula from the earlier essential cross-helicity calculation, \(q_U(x,n)=-P_nS_UP_n-\tfrac12(n^\top S_Un)P_n\), with \(P_n=I-nn^\top\). This does not assert a new whole-space operator-domain theorem. Its spherical average reconstructs the same strain via

\[
S_U(x)=-\frac52\int_{\mathbb S^2}q_U(x,n)\,d\mu(n),
\]

where \(d\mu\) is normalized spherical measure. Together with (30), at a decaying whole-space source,

\[
\int_{\mathbb S^2}q_U(0,n)\,d\mu(n)
=\frac6{25}\int_{\mathbb R}B(\ell)\,d\ell.
\tag{40}
\]

Thus the essential operator reading, the local strain, and the logarithmic vorticity-shell primitive are readings of one source. Equation (35) evolves the last of these without replacing the actual nonlinear generator by an arbitrary five-component action.

At every finite smooth renormalization, the candidate ancestry must include (31), (33), and (35)–(37) simultaneously, along with the already retained pressure/boundary data, source-dependent Poisson tensor, true derivative, and stochastic-source residual where that representation is used. A proposed limiting continuation is not authorized to erase the endpoint current or to replace \(\mathcal N\) by an independent field.

These identities do not establish tightness of the logarithmic-scale history, convergence of all nonlinear products through a singular limit, or an incompatibility that excludes every actual blow-up ancestry. Those conclusions are not assumed.

# Verification and source ledger

The repository source read in this run includes `formal/lean/Pairfield/LinearObservabilityKernel.lean` and `formal/cubical/theorems/automata/ActionResidual.agda`, at the pinned commit. The comprehensive conversation handoff and the subsequent notes on the fixed receiver, the Weil reflection signature, explicit receiver inversion, Poisson source transport, essential strain reconstruction, and toroidal quadrupole selection were also read. Their proved input maps are retained rather than replaced by the weaker abstract realization records.

The new compositions developed here are (5)–(25) and (31)–(40). Cardinal interpolation, Fourier contour shifting, residual telescoping, and spherical harmonic calculus are classical techniques; no claim of historical priority is made for their application here.

Classical references:

* NIST Digital Library of Mathematical Functions, Sections 25.4 and 5.11: completed-zeta reflection formulas and gamma asymptotics.
* Masatoshi Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2, manuscript version August 24, 2026: actual explicit formula, localized closed forms, self-adjoint realization, compact smooth form core, and localized spectral bottom.
* The prior collaboration's note *Five-dimensional strain completion and the exact signature of the Weil form*: the source evaluation/reflection representation retained in (1).
* The prior collaboration's note *Work balance and toroidal quadrupole selection*: the exact angular normalization and central-strain reconstruction retained in (28)–(30).

`checks.py` executes 115 exact finite/symbolic controls. Its zero divisor is an explicitly labeled synthetic polynomial, not zeta. It checks multiplicity normalization, all cardinal evaluations on that divisor, reflection and negative-coordinate identities, translation amplitudes, toroidal angular normalization, the radial/logarithmic current identities, and the complete cubic-jet control for the inner diffusive flux. It does not execute the analytic limit arguments, evaluate a purported off-critical zeta zero, integrate NS, or compile Agda/Lean.


---

# ORIGINAL S12 — Compact source-image rigidity and full nonlinear toroidal leakage
Source path: `sources/S12_source_image_and_quadrupole.md`; SHA-256: `051e440ce0083ae7087b9cfbf9b7a421b97af3ac6ac285b834ceb3f14f9e5a8f`
Transfer status: Recovered proof_note(7).md; strong complete radial-matrix theorem.

# Source-image rigidity for one Weil packet, and exact nonlinear leakage of the Navier–Stokes strain source

Date: 7 September 2026.
Repository inspected: `avikj/metacircular-interaction-prototype`, commit `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope and status

This note proves two source-level results, rather than identifying another abstract realization record with a physical or arithmetic theorem.

For RH, the linear zero-coordinate reflection of one explicit compact packet has a compactly supported source if and only if RH holds. The reconstruction fibre is exactly a singleton or empty. The proof uses the previously fixed packet, an unconditional positive proportion of distinct critical-line zeros, and elementary entire-function uniqueness. Every finite subset of the reflected interpolation constraints nevertheless has a smooth compact-source solution. On a fixed support interval, the exact minimum reconstruction cost diverges if an off-line zero is present.

For NS, the pressure coefficient -2/7 extends from a scalar radial profile times one fixed strain matrix to the complete toroidal degree-two source projection, with arbitrary noncommuting matrix-valued radial profiles. Thus the pressure residual is an explicit bilinear expression in the retained source and its complementary angular part. The actual NS nonlinearity emits a specified degree-four toroidal component from a nontrivial aligned quadrupole shell. The pure quadrupole source is therefore not an invariant state space, even though it has an exact instantaneous pressure formula.

A scope correction is necessary: the pressure-only five-dimensional ODE in earlier messages is conditional. At a finite smooth NS scale, the strain equation also contains the vorticity-square and viscous terms. These are kept explicitly below. No singular-limit affine ODE is asserted from spatial BMO convergence alone.

No proof of RH or of global three-dimensional NS regularity, originality-priority claim, or Agda/Lean build is made. The companion executable performs 147 exact finite/symbolic checks, including all polarized coefficients of the matrix-valued pressure identity.

# I. RH: one explicit source has a singleton-or-empty reflection fibre

## 1. Actual source and spectral maps

Let Sigma be the set of distinct shifted nontrivial zeta zeros z=rho-1/2, with multiplicity m(z), and let theta(z)=-conjugate(z). Put

    (Ef)(z) = integral_R f(x) exp(-z x) dx,
    (Ja)(z) = a(theta(z)).

For the source class C=L2_c(R), use the full sequence space C^Sigma as the immediate codomain. An arbitrary compact L2 source need not have square-summable evaluations. The previously fixed packet does, and on the completed Weil space H=l2(Sigma,m) the same J is a bounded self-adjoint involution.

The retained Weil identity is

    Q_W(f,g) = <Ef, J Eg>,

on its declared test/form domain. The original compact source image and its Hilbert completion must remain distinct.

Let Sigma_0={i gamma in Sigma} be the critical-line subset. The restricted evaluation

    E_0:C -> C^(Sigma_0)

is injective unconditionally. Indeed, the bilateral Laplace transform of a compact L2 source is entire of exponential type. If nonzero, Jensen's formula bounds its number of zeros in disks of radius R by O(R). An unconditional positive proportion of distinct simple critical-line zeta zeros supplies at least c R log R points in Sigma_0. Vanishing at all these points is therefore impossible unless the entire transform, and then the source, is zero.

Only a positive proportion is used; no assertion about the remaining zeros is imported. The primary input is Conrey (1989), whose introduction explicitly states simplicity and critical-line location for a positive proportion.

## 2. General source-image rigidity lemma

For any f,g in C,

    Eg = J Ef  ==>  E_0 g = E_0 f  ==>  g=f.

Consequently

    {g in C : Eg=J Ef}
      = {f} if J Ef=Ef,
      = empty otherwise.

Equivalently, writing X=E(C),

    X intersect JX = {a in X : Ja=a}.

Thus a linear reflection lift that preserves compact source realizability can only act as the identity on those sources. This is an image-side obstruction, not the separated-pair quotient obstruction. It is the diagram shape explicitly distinguished in Section 3 of `DescentObstructionUnified.agda`.

This J is NOT the usual conjugate-linear test involution. For f*(x)=conjugate(f(-x)),

    E(f*)(z) = conjugate((J Ef)(z)).

Forgetting the coefficient conjugation would incorrectly create a compact-source lift of J.

## 3. A single installed packet detects every nonfixed reflection pair

Use the existing packet

    h(x)=exp(-4x)(q*q)(x),    q=4 1_[0,1/4],
    H(z)=16 (1-exp(-(z+4)/4))^2/(z+4)^2.

It is real, supported on [0,1/2], and its transform is nonzero in |Re z|<=1/2. Translate by the already installed action a=log 2:

    p=T_a h,
    F(z)=Ep(z)=exp(-a z) H(z).

For z=sigma+i gamma in the shifted critical strip, put w=exp(-(z+4)/4). Then

    d/dsigma log|F(sigma+i gamma)|
      = -log 2 + Re[ w/(2(1-w)) - 2/(z+4) ].

Since Re(z+4)>0, the last reciprocal term has nonpositive contribution. Also

    |w|<=exp(-7/8)<1/2.

Therefore

    d/dsigma log|F(sigma+i gamma)|
      < -log 2 + 1/2 = -kappa <0,
    kappa=log 2-1/2.

The elementary strict inequalities can be checked without decimal arithmetic: the first three terms of exp(7/8) already exceed 2, and integral_1^2 dx/x>1/2.

For sigma>0 this yields

    |F(sigma+i gamma)| / |F(-sigma+i gamma)|
      <= exp(-2 kappa sigma)<1.

In particular F(z) differs from F(theta z) at EVERY off-line shifted zero, with a definite modulus gap. No dominance or cancellation assumption on a sum over zeros is used.

## 4. Single-packet reconstruction theorem

Define the actual coherent reconstruction fibre

    F_p = {g in L2_c(R) : Eg=J Ep}.

Then

    F_p = {p} under RH,
    F_p = empty under failure of RH.

Proof: under RH, theta fixes every z, so p is the source and E_0 gives uniqueness. Conversely any source g must equal p by the rigidity lemma. Hence F(z)=F(theta z) at every zero. The strict modulus separation just proved excludes every off-line pair.

Thus

    RH <=> J Ep belongs to the compact source image E(L2_c(R)).

The spectral datum J Ep exists unconditionally in the completed Weil space. The theorem asks whether it belongs to the ORIGINAL compact source image. Its existence in the completion is not the desired reconstruction theorem.

This does not replace the quantitative-Goldbach, CRT, receiver, Gram, or inertia maps. It uses their same arithmetic spectral source and the same fixed packet, but gives a different exact reading of the remaining obstruction.

## 5. All finite interpolation fibres remain inhabited

Let z_1,...,z_N be distinct spectral points, let y_1,...,y_N be arbitrary complex values, and fix any nonempty bounded open interval I. Choose psi in Cc-infinity(I), nonnegative and positive on a smaller open interval. Define

    G_ij = integral psi(x) exp(-z_i x) exp(-conjugate(z_j)x) dx.

Distinct exponential functions are linearly independent on an interval, so this Hermitian Gram matrix is positive definite. Solve Gc=y and put

    g(x)=psi(x) sum_j c_j exp(-conjugate(z_j)x).

Then g is smooth, compactly supported in I, and Eg(z_i)=y_i for every i.

In particular EVERY finite subset of the reflected constraints in F_p is solvable, even if F_p itself is empty. This is not a contradiction with finite negative Weil certificates: the diagrams are different. Arbitrary finite interpolation has no uniform source-norm constraint; a negative quadratic-form test has a different feasibility requirement.

## 6. Exact reconstruction cost at one offending zero

Fix a bounded interval I containing supp p, and suppose z_* is off the critical line. Put

    delta = F(theta z_*)-F(z_*) !=0.

Enumerate the distinct critical-line zeros as i gamma_1,i gamma_2,.... In L2(I), with scalar product linear in the first argument, define

    k_z(x)=exp(-conjugate(z)x),
    V_N=span{k_(i gamma_j):1<=j<=N},
    r_N=(I-P_(V_N))k_(z_*).

The critical-line uniqueness theorem implies closure(union V_N)=L2(I), hence ||r_N||_2 ->0. Distinct exponential independence gives r_N!=0 for every finite N.

The minimum-norm correction d satisfying

    Ed(i gamma_j)=0, j<=N,
    Ed(z_*)=delta

is exactly

    d_N = delta r_N / ||r_N||_2^2,
    min ||d||_2 = |delta|/||r_N||_2 -> infinity.

Proof: every feasible d lies in V_N-perp and <d,r_N>=delta. Cauchy-Schwarz gives the bound, with equality at d_N.

Thus, with fixed support, source norms MUST escape to infinity when finite reflected data are made coherent with more of the critical-line source readings. This is the precise compactness obstruction to turning the finite fibres into a global compact source.

# II. NS: the complete toroidal strain source and its pressure

## 7. Declared smooth source class

Work on R3 with smooth divergence-free velocities whose vorticity is compactly supported, or with decay and differentiability sufficient for the displayed Biot-Savart, pressure, and radial boundary operations. Fix an observation center, written as zero. These are finite smooth-source identities. Periodic global kernels require their own retained outer correction and are not silently substituted here.

For A in Sym_0(3), put T_A(n)=n cross (A n). Let F(r) in Sym_0(3) be the exact toroidal degree-two projection coefficient of omega(rn):

    integral_S2 omega(rn) dot T_A(n) dOmega
      = (4pi/5) tr(F(r)A).

Then

    omega_2(rn)=n cross(F(r)n),
    S_u(0)=-(3/5) integral_0^infinity F(r) dr/r.

The projected field is divergence-free. For a smooth source, F(r)=O(r^2) near zero. Define

    G(r)=(1/5)[r^(-5) integral_0^r s^4 F(s) ds
                         + integral_r^infinity F(s) ds/s].

Entrywise,

    G''+(6/r)G'=-F/r^2.

Set

    psi_2(x)=x cross(G(|x|)x),
    u_2=curl psi_2.

Then curl u_2=omega_2 and u_2 is the finite-energy Biot-Savart velocity of the projected vorticity. Moreover

    S_(u_2)(0)=-3G(0)=S_u(0).

For u_perp=u-u_2, the central strain is zero. Thus this is a linear source decomposition, not a decomposition of independently chosen strain and pressure values.

## 8. Full matrix pressure theorem

For any source v write

    H[v] = (Hess (-Delta)^(-1) tr((grad v)^2))(0)_0.

The subscript 0 means trace-free. This is the deviatoric physical pressure Hessian because -Delta p=tr((grad v)^2).

The following identity holds with ARBITRARY matrix-valued radial profiles G(r) in Sym_0(3):

    H[u_2] = -(2/7)(S_u(0)^2)_0.

In particular G(r), G'(r), and G''(r) need not commute; radial changes of eigenframe are fully retained.

### Explicit calculation

At a radius r put V=rG', W=r^2G'', and let n be a unit vector. Direct differentiation gives

    L=grad u_2(rn)
      = -3G-V -(4V+W)n n^T
        +(n^T V n)I +(n^T(W-V)n)n n^T +2n(Vn)^T.

For X circ Y=(XY+YX)/2, exact spherical moments give

    (1/4pi) integral_S2 (3nn^T-I) tr(L^2) dOmega
      = (12/35)[18G circ V +3G circ W+2V^2-V circ W]_0.

This is a quadratic identity in the 15 independent entries of G,V,W. The script verifies every diagonal and mixed polarized coefficient, not a random sample of matrices.

The pressure representation is the integral of this expression against dr/r. Its integrand is an exact derivative:

    18G circ G' +3rG circ G''+2r(G')^2-r^2G' circ G''
      = d/dr[(15/2)G^2+3rG circ G'-(r^2/2)(G')^2].

The outer boundary vanishes under the declared decay, and regularity removes all inner derivative terms. Hence

    H[u_2]=-(18/7)(G(0)^2)_0=-(2/7)(S_u(0)^2)_0.

This extends the earlier fixed-A radial calculation to the whole linear toroidal degree-two projection.

## 9. The actual pressure residual is a source cross-effect

Polarize H by

    H(v,w)=1/2[H[v+w]-H[v]-H[w]].

It is the Hessian reading of the bilinear pressure source tr((grad v)(grad w)). Therefore

    K[u]:=H[u]+(2/7)(S_u(0)^2)_0
          = 2H(u_2,u_perp)+H[u_perp].

This is the exact residual source map. Neither the radial orientation of the degree-two source nor any of its radial amplitudes has been lost. The remaining pressure is supplied only by its complementary source and the cross-interaction with that source.

No sign is claimed for this bilinear residual.

# III. The actual nonlinear action forces degree four

## 10. Aligned radial quadrupole and its emitted component

Let A be a nonzero real symmetric trace-free matrix. Let f be a nonzero, nonnegative smooth radial bump supported in an annulus, and take

    omega(rn)=f(r)T_A(n),
    u=curl[g(r) x cross(Ax)],
    g''+6g'/r=-f/r^2.

The finite-energy inverse has

    g(r)=(1/5)[r^(-5) integral_0^r s^4 f(s) ds
                       + integral_r^infinity f(s) ds/s]>0.

Write

    B=(A^2)_0,  s_A(n)=n^T A n,  q=tr(A^2),
    Y_4(n)=s_A(n)^2-(4/7)n^T B n-(2/15)q,
    T_4[A](n)=(1/4)n cross grad_S Y_4(n)
              =s_A(n)T_A(n)-(2/7)T_B(n).

The polynomial producing Y_4 is a homogeneous harmonic of degree four. T_4[A] is orthogonal to every toroidal degree-two field, and

    (1/4pi) integral_S2 |T_4[A]|^2 dOmega
      = (4/245)(tr A^2)^2>0.

The exact nonlinear vorticity source is

    curl(u cross omega)
       = beta_2(r) T_B(n) + beta_4(r) T_4[A](n),

where

    beta_2=(6/7)(5gf+2r g'f+r g f'),
    beta_4=3r g f'-6gf-r g'f.

One direct derivation writes

    u=-(3g+rg')Ax +(g'/r)(x^T A x)x,

then computes (omega dot grad)u-(u dot grad)omega. Before angular decomposition it is

    (6gf+2r g'f)T_B
      +(3r g f'-6gf-r g'f)s_A T_A.

The identity s_A T_A=(2/7)T_B+T_4[A] gives the displayed decomposition.

Viscosity preserves the degree-two angular sector:

    Delta(f(r)T_A(n))=(f''+2f'/r-6f/r^2)T_A(n).

Thus on the actual local classical NS continuation of this initial datum,

    P_(4,tor) partial_t omega |_(t=0) = beta_4 T_4[A].

## 11. Strict source-space non-invariance

The coefficient beta_4 cannot vanish identically for the declared nonnegative nonzero compact shell. On a connected interval where f>0, its vanishing would imply

    f'/f = 2/r + g'/(3g),
    f(r)=C r^2 g(r)^(1/3).

But g is strictly positive at every finite radius. At a finite boundary of that f-component, continuity and compact support force f to zero, whereas the displayed expression has a nonzero limit if C!=0. Contradiction.

Consequently

    ||P_(4,tor) partial_t omega(0)||_2^2
      = (16pi/245)(tr A^2)^2 integral_0^infinity r^2 beta_4(r)^2 dr
      >0.

A nontrivial aligned toroidal-quadrupole shell immediately leaves the pure degree-two source space under the true NS generator. This is an exact tangent-image obstruction, not a claim that an arbitrary pressure matrix can be selected.

The conclusion on the annulus is unchanged after adding a smooth compactly supported rotating velocity core entirely inside the inner radius: both that added velocity and its vorticity vanish on the annulus, so the annular nonlinear calculation is identical. Such a core can retain a nonzero normalized central vorticity value. This still describes genuine smooth initial data and their actual first continuations; it does not assemble them into a single blow-up trajectory.

The linear invariant-closure theorem in the repo is not being misapplied to a quadratic vector field. Here strict enlargement is proved directly by the nonzero projected derivative. A linear/Krylov realization would need its own declared lift.

## 12. Consistency with the instantaneous 5/7 strain drift

For the source-free core, S=-3g_0 A, omega=0, and Delta S=0. Integrating the degree-two nonlinear coefficient gives

    S'(0)=-(3/5) integral beta_2 dr/r B
         =-(45/7)g_0^2 B
         =-(5/7)(S^2)_0.

This agrees with the pressure theorem. But degree four is simultaneously emitted elsewhere. Thus the instantaneous 5/7 law does NOT prove that the source remains on a five-dimensional invariant manifold.

# IV. The correct residual for actual NS strain dynamics

## 13. Retain rotation and viscosity

Let S=sym grad u, Omega=skew grad u, and omega=curl u. Along the actual material derivative,

    D_t S=-(S^2)_0-(Omega^2)_0-H[u]+nu Delta S,
    (Omega^2)_0=(1/4)(omega tensor omega)_0.

Substituting the exact toroidal pressure split gives

    D_t S=-(5/7)(S^2)_0-K[u]
                 -(1/4)(omega tensor omega)_0+nu Delta S.

Define the full source-derived correction

    K_eff = K[u]+(1/4)(omega tensor omega)_0-nu Delta S.

Then the exact finite-scale law is

    D_t S=-(5/7)(S^2)_0-K_eff.

For q=tr S^2 and r=tr S^3,

    D_t r=-(5/14)q^2-3tr(S^2 K_eff).

The prior two spectral/three orientation decomposition on q^3-6r^2>0 can be applied to K_eff. Applied to pressure K alone, it omits actual NS terms unless the particular limiting procedure separately proves they vanish or moves them into another retained coordinate.

Therefore a nonzero periodic strain history with zero commuting/spectral part of K_eff is impossible. Recurrence forces a compensating component of the COMPLETE correction, not pressure alone. The pressure-only recurrence inference in the previous prose must remain conditional.

## 14. Finite renormalization and the unclaimed singular step

At a fixed center, parabolic rescaling

    u_rho(x,t)=rho u(rho x,rho^2 t)

carries S and omega with weight rho^2, H, K, K_eff with weight rho^4, and curl(u cross omega) with weight rho^4. The toroidal projection, bilinear pressure split, and emitted degree-four component commute with this finite coordinate change.

A time-dependent scale or center requires its exact extra transport terms; they may not be dropped. Passing to a singular witness additionally requires convergence of pressure, source products, and the chosen time history. Spatial BMO compactness alone does not supply the needed temporal convergence or justify differentiating the limiting affine coordinate.

The results above therefore add exact common-ancestry constraints at every finite stage, without claiming an ancient or recurrent limit has already been constructed.

# V. Verification and theorem-graph ledger

Repository sources read at the pinned commit:

- `formal/cubical/theorems/physics/QRClosure_TheRestrictedEulerQuotientClosesByRingIdentityAndThePressureHessianCouplingDoesNotDescendThroughIt.agda`. Algebraic pressure/viscous correction, not a PDE continuation theorem.
- `formal/cubical/theorems/physics/DescentObstructionUnified.agda`. Separated-pair descent and missed-image obstruction are distinct diagrams.
- `formal/lean/Pairfield/InvariantCorrectiveClosure.lean`. Linear corrective closure with explicit invariance hypotheses.

Saved source inputs retained:

- Comprehensive conversation handoff, 6 September 2026.
- `proof_note(1).md`, fixed compact Weil packet, actual evaluation map, and critical-line uniqueness argument.
- `proof_note(3).md`, completed reflection form, compact-source density, and affine source completion.
- `source_preserving_spectral_escape/proof_note.md`, exact arithmetic source interpolation and finite-scale logarithmic strain currents.

Primary background:

- J. B. Conrey, More than two fifths of the zeros of the Riemann zeta function are on the critical line, J. reine angew. Math. 399 (1989), 1–26, DOI 10.1515/crll.1989.399.1. Only the unconditional positive proportion of distinct simple critical-line zeros is needed.
- M. Suzuki, Weil's quadratic form via the screw function, arXiv:2606.09096. The actual Weil reflection/explicit-formula background is retained; no conjectural limit is used.
- M. Wilczek and C. Meneveau, Pressure Hessian and viscous contributions to velocity gradient statistics based on Gaussian random fields, arXiv:1401.3351. Relevant background for the familiar statistical -2/7 coefficient; not used as a proof of the deterministic source-projection identity derived here.

`checks.py` is an actual rerunnable file, not a placeholder. Its 147 controls include all 120 polarized pressure coefficients; the matrix boundary telescope; the full nonlinear l2/l4 split on arbitrary eigenvalues; orthogonality to every l2 coordinate; exact universal harmonic norms; the true rotation/viscous strain correction; and the packet logarithmic derivative. No purported off-critical zeta zeros are evaluated.

The unresolved conclusions are stated precisely: no compact source for the reflected packet has been constructed without RH, and no incompatibility has been proved for every full NS blow-up ancestry carrying the emitted complementary modes. These source-level statements identify concrete image and invariance constraints; they do not by themselves settle either global theorem.


---

# ORIGINAL S13 — Endpoint Xi support escape and exact H5 viscous strain memory
Source path: `originals/conversation/source_resolved_closure/proof_note.md`; SHA-256: `2d820c78027b28600bb92399cb681c2991d179ccb31c87cce23d74eced1daf56`
Transfer status: Original mounted note; several numbered aliases materialize to these same bytes.

# Actual-source interpolation and exact viscous quadrupole memory

Date: 2026-09-07.
Repository: `avikj/metacircular-interaction-prototype`.
Read snapshot: `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope and provenance

This is a completed set of analytic statements in declared source classes. It is not a proof of the Riemann hypothesis or global three-dimensional Navier–Stokes regularity. No proof-assistant build, numerical off-critical-zero certificate, or nonlinear PDE evolution is claimed.

The saved note **Explicit spectral-source interpolation and the renormalized strain current**, dated 2026-09-07 (library file `proof_note(6).md`), already supplies: entire cardinal interpolation using the actual completed zeta function; compactification with a retained error; a negative localized-Weil spectral-bottom alternative; and the exact same-source evolution of the toroidal quadrupole under moving rescaling. Those results are inputs, not inventions of this pass.

The new calculations below provide:

1. an explicit theta-source, two-sided Volterra implementation of the cardinal source, and double-exponential cutoff control;
2. the endpoint negative-eigenvalue bound `lambda_a <= -c_z a^(-sigma) exp(2 sigma a)` from any hypothetical zero `z=sigma+i gamma`, `sigma>0`;
3. the exact heat response and integrated memory of the strain-bearing toroidal quadrupole;
4. exact same-source Duhamel composition with NS forcing;
5. smooth finite-energy initial sources with fixed vorticity supremum and arbitrarily large instantaneous peak growth, while their freely diffusing quadrupole history has uniformly finite total response.

These are source constructions and evolution identities. They are not additional positive kernels whose positivity is then silently promoted to the target arithmetic or PDE statement.

The repository's `Ekatva` proves contractibility of the type of lossless completions over a fixed map. `ActionResidual` proves the exact realized-preservation hypothesis needed for a residual update. The present use does not ask either generic theorem to supply an analytic sign it does not state.

# Part I. RH: actual cardinal sources with a logarithmic support overhead

## 1. Conventions and the actual theta source

Set

\[
\xi(s)=\frac12s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s),
\qquad \Xi(z)=\xi(1/2+z).
\]

Let `Sigma` be the set of **distinct** zeros of `Xi`, with multiplicity `m_z`, and let

\[
\theta z=-\overline z,\qquad
\mathcal H=\ell^2(\Sigma,m),\qquad
(Ja)_z=a_{\theta z}.
\]

Use the inner product linear in the first argument. For a compact smooth source,

\[
V_f(w)=\int_{\mathbb R}f(x)e^{-wx}\,dx,
\qquad (Ef)_z=V_f(z),
\qquad Q_W(f,g)=\langle Ef,J Eg\rangle_{\mathcal H}.
\tag{1}
\]

Classical functional-equation symmetry preserves multiplicities. In particular `J` is a self-adjoint isometric involution. The classical explicit formula identifies (1) with the actual prime/archimedean Weil quadratic form. It is not a definition of an independent kernel bearing the same name.

For `x>=0`, define

\[
\varphi(x)=\sum_{n\ge1}
\left(4\pi^2n^4e^{9x/2}-6\pi n^2e^{5x/2}\right)
 e^{-\pi n^2e^{2x}},
\qquad \varphi(-x)=\varphi(x).
\tag{2}
\]

Then

\[
\boxed{\Xi(z)=\int_{\mathbb R}\varphi(x)e^{-zx}\,dx.}
\tag{3}
\]

Here is the normalization check. Write

\[
\psi(t)=\sum_{n\ge1}e^{-\pi n^2t},\qquad F(x)=e^{x/2}\psi(e^{2x}).
\]

The theta transformation gives `F(-x)=F(x)+sinh(x/2)`, hence `F'(0)=-1/4`, and `(D^2-1/4)F` is even. Direct differentiation gives exactly (2). The classical theta-integral formula for xi, followed by two integrations by parts, gives

\[
2\int_0^\infty (F''-F/4)\cosh(zx)\,dx
=-2F'(0)+2(z^2-1/4)\int_0^\infty F(x)\cosh(zx)\,dx
=\Xi(z).
\]

For every fixed derivative order `k` and every `0<c<pi`,

\[
|\varphi^{(k)}(x)|\le C_{k,c}\exp(-c e^{2|x|})
\quad (|x|\ge1).
\tag{4}
\]

This follows by differentiating the exponentially convergent series. Polynomial factors in `n` and `e^|x|` are absorbed by reducing the coefficient `pi` in the exponent. The extension through zero is smooth by the theta identity, not by an arbitrary even reflection of a nonsmooth germ.

## 2. Finite-zero division is equality of two actual source histories

For a complex number `z` and an integer `m>=1`, define

\[
(R^-_{z,m}\varphi)(x)
=\frac1{(m-1)!}\int_{-\infty}^{x}
 (x-y)^{m-1}e^{z(x-y)}\varphi(y)\,dy,
\tag{5}
\]

\[
(R^+_{z,m}\varphi)(x)
=\frac{(-1)^m}{(m-1)!}\int_x^\infty
 (y-x)^{m-1}e^{z(x-y)}\varphi(y)\,dy.
\tag{6}
\]

Both solve `(D-z)^m g=varphi`. Their difference is the explicit homogeneous solution

\[
\boxed{
R^-_{z,m}\varphi-R^+_{z,m}\varphi
=\frac{e^{zx}}{(m-1)!}
\sum_{j=0}^{m-1}\binom{m-1}{j}x^{m-1-j}(-1)^j\mu_j(z),
}
\tag{7}
\]

where

\[
\mu_j(z)=\int y^j e^{-zy}\varphi(y)\,dy=(-1)^j\Xi^{(j)}(z).
\]

Consequently the past and future source inverses agree precisely when

\[
\Xi(z)=\Xi'(z)=\cdots=\Xi^{(m-1)}(z)=0.
\tag{8}
\]

This is an explicit finite-dimensional boundary discrepancy, not an independently postulated inverse.

For an actual zero `z` of multiplicity `m_z`, put

\[
\boxed{
f_z=\frac{m_z!}{\Xi^{(m_z)}(z)}R^-_{z,m_z}\varphi
=\frac{m_z!}{\Xi^{(m_z)}(z)}R^+_{z,m_z}\varphi.
}
\tag{9}
\]

The agreed source decays superexponentially at both ends. Its bilateral transform is

\[
\boxed{
V_{f_z}(w)=I_z(w)
=\frac{m_z!}{\Xi^{(m_z)}(z)}\frac{\Xi(w)}{(w-z)^{m_z}}.
}
\tag{10}
\]

Every apparent singularity is removable. Therefore

\[
\boxed{Ef_z=e_z.}
\tag{11}
\]

Every other zero is eliminated by the **same actual `Xi` numerator**, not by independently assigning its coordinate zero. Multiplicities are retained exactly.

There is no assertion that `E` is injective on the enlarged source class: the nonzero source `varphi` itself satisfies `E varphi=0`. The construction (9) specifies a section on finite-coordinate vectors; it does not erase the source fibre or assert that the section is uniquely forced.

## 3. Double-exponential decay of the cardinal sources

Fix `z` and `m_z`. For `x>1` use the future representation (6), and for `x<-1` use the past representation (5). The inequality

\[
e^{2(x+t)}\ge e^{2x}(1+2t),\qquad t\ge0,
\]

bounds the polynomial Volterra weight by a convergent gamma integral. Together with (4), it proves that for some `kappa>0` and for any fixed finite derivative range,

\[
\boxed{
|f_z^{(j)}(x)|\le C_{z,j}\exp(-\kappa e^{2|x|})
\quad(|x|\ge1).
}
\tag{12}
\]

Derivatives can also be controlled recursively from `(D-z)^m f_z=const*varphi`. Constants may depend on the chosen zero and its multiplicity. No uniform control over all zeros is claimed.

Choose a smooth cutoff `chi_R` equal to one on `[-R,R]`, supported in `(-R-1,R+1)`, with derivatives through order two bounded independently of `R>=1`. Set

\[
g_{z,R}=\chi_R f_z,\qquad e_{z,R}=g_{z,R}-f_z.
\]

Then

\[
\sum_{j=0}^2\|e^{|x|/2}e_{z,R}^{(j)}\|_{L^1}
\le C_z\exp(-\kappa e^{2R}).
\tag{13}
\]

Two integrations by parts on every vertical line in `|Re w|<=1/2`, followed by the classical zero count, give

\[
\boxed{
\|Ee_{z,R}\|_{\mathcal H}
\le C_z\exp(-\kappa e^{2R}).
}
\tag{14}
\]

For example the square of the fixed summation constant is

\[
\sum_{w\in\Sigma}\frac{m_w}{(1+|\Im w|^2)^2}<\infty.
\]

The cutoff residue is part of the retained source equation
`E g_{z,R}=e_z+E e_{z,R}`.

## 4. An off-line zero forces endpoint-rate spectral escape

Assume an actual zero

\[
z=\sigma+i\gamma,\qquad \sigma>0,
\]

exists, and put `m=m_z=m_theta(z)`. The coordinate vector

\[
a_-=(e_z-e_{\theta z})/\sqrt{2m}
\]

has norm one and `J a_-=-a_-`.

Let `(T_bf)(x)=f(x-b)`. For a large positive `T`, define the **compact smooth actual source**

\[
\boxed{
v_T=\frac{e^{-zT}T_{-T}g_{z,R}
-e^{\theta z T}T_Tg_{\theta z,R}}{\sqrt{2m}}.
}
\tag{15}
\]

Without the cutoffs its evaluation vector is exactly `a_-`. With them,

\[
\|Ev_T-a_-\|\le C_z
\exp\big((1/2-\sigma)T-\kappa e^{2R}\big),
\tag{16}
\]

because translation by `b` multiplies a zero coordinate by `e^{-wb}` and all zero real parts lie in `[-1/2,1/2]`.

Choose

\[
R=\tfrac12\log(KT),\qquad \kappa K\ge1.
\tag{17}
\]

The right-hand side of (16) tends exponentially to zero. In particular, for large `T`,

\[
Q_W(v_T,v_T)\le-7/16.
\tag{18}
\]

Both coefficients in (15) have magnitude `e^{-sigma T}`, and translations preserve `L2`, so

\[
\|v_T\|_2^2\le C_z e^{-2\sigma T}.
\tag{19}
\]

The support lies in `[-T-R-1,T+R+1]`. Define

\[
\lambda_a=\inf_{0\ne f\in C_c^\infty(-a,a)}
\frac{Q_W(f,f)}{\|f\|_2^2}.
\]

For all sufficiently large `a`, set

\[
T=a-\tfrac12\log a-C_0
\]

with `C_0` large enough that `T+R(T)+1<a`. Equations (18)-(19) prove

\[
\boxed{
\lambda_a\le-c_z a^{-\sigma}e^{2\sigma a}
\quad(a\ge a_z).
}
\tag{20}
\]

This improves the saved `exp(2 sigma a/(1+epsilon))` bound: the exact exponential rate `2 sigma` now incurs only a polynomial loss. No rightmost zero is assumed to exist; this applies to every individual off-line zero.

A real odd version is obtained by adjoining the conjugate pair of sources and taking the appropriately normalized real odd part. The four nonzero target coordinates are proportional to

\[
e_z+e_{\bar z}-e_{-\bar z}-e_{-z};
\]

the same support and norm estimates apply.

### Bounded corrections cannot hide the bad sector

Suppose a family of self-adjoint operators `K_a` on the localized `L2` spaces satisfies

\[
Q_W(f,f)+\langle f,K_af\rangle\ge0
\quad(f\in C_c^\infty(-a,a)).
\]

If `||K_a||=exp(o(a))`, (20) excludes every `sigma>0`. Functional-equation reflection then gives RH. In particular a single bounded correction on the global `L2` space would suffice.

This statement does **not** construct such a correction from primes. It specifies exactly why a bounded residue in a proposed positive arithmetic realization would be enough, and why an exponentially growing correction cannot be silently regarded as harmless.

### Arithmetic source remains the same

The actual Weil functional is

\[
\begin{aligned}
W(h)={}&\int h(x)(e^{x/2}+e^{-x/2})\,dx
-\sum_{n\ge1}\frac{\Lambda(n)}{\sqrt n}\big(h(\log n)+h(-\log n)\big)\\
&-(\log4\pi+\gamma_E)h(0)
-\int_0^\infty\big(h(x)+h(-x)-2e^{-x/2}h(0)\big)
\frac{e^{x/2}}{e^x-e^{-x}}\,dx.
\end{aligned}
\tag{21}
\]

For `f` supported in `(-a,a)`, `h=f*tilde f` is supported in `(-2a,2a)`, so only primes/powers `n<exp(2a)` occur. Formula (20) therefore produces a genuine compact arithmetic test. The pole and archimedean terms remain in it. The repository's quantitative Goldbach reconstruction supplies these same `Lambda` values on its actual realized image; it is not used as a sign theorem.

# Part II. NS: solve the actual viscous strain channel

## 5. The strain-bearing observer already supplied by the handoff

Use a smooth whole-space, divergence-free vorticity `omega`, with its finite-energy Biot–Savart velocity and sufficient decay for the formulas below. For `B` trace-free symmetric, define

\[
T_B(n)=n\times Bn,\qquad n\in S^2.
\]

For a vector source `f`, define its toroidal quadrupole coefficient `A_f(r)` by

\[
\int_{S^2}f(rn)\cdot T_B(n)\,d\Omega
=\frac{4\pi}{5}\operatorname{tr}(A_f(r)B)
\quad\text{for every }B\in\operatorname{Sym}_0(3).
\tag{22}
\]

The retained exact angular calculation gives

\[
\boxed{S_u(0)=-\frac35\operatorname{p.v.}\int_0^\infty A_\omega(r)\frac{dr}{r}.}
\tag{23}
\]

This is an instantaneous linear reading of the full source. It does not assert nonlinear closure on the five coefficient functions.

## 6. The exact viscous attenuation factor

Define

\[
\boxed{
H_5(q)=\operatorname{erf}(q)
-\frac2{\sqrt\pi}e^{-q^2}\left(q+\frac23q^3\right)
=\frac{\gamma(5/2,q^2)}{\Gamma(5/2)}.
}
\tag{24}
\]

It satisfies

\[
H_5(0)=0,\qquad H_5(\infty)=1,\qquad
H_5'(q)=\frac8{3\sqrt\pi}q^4e^{-q^2}>0.
\tag{25}
\]

For `t>0`, the central strain of the freely diffusing velocity is

\[
\boxed{
S_{e^{\nu t\Delta}u_0}(0)
=-\frac35\int_0^\infty
H_5\!\left(\frac r{2\sqrt{\nu t}}\right)
A_{\omega_0}(r)\frac{dr}{r}.
}
\tag{26}
\]

### Proof by the regularized Newton potential

The heat-regularized Newton potential is

\[
\Phi_t(r)=\frac{\operatorname{erf}(r/(2\sqrt{\nu t}))}{4\pi r}.
\]

In its Hessian the isotropic term disappears on symmetrizing the Biot–Savart strain kernel. The coefficient of `n tensor n` is

\[
\Phi_t''(r)-\Phi_t'(r)/r
=\frac3{4\pi r^3}H_5\!\left(\frac r{2\sqrt{\nu t}}\right).
\tag{27}
\]

Insert (27) into the already-established angular identity (22)-(23). This proves (26), with its coefficient and sign fixed.

### Independent radial check

The l=2 toroidal coefficient evolves under heat by

\[
\partial_t A=\nu(A''+2A'/r-6A/r^2).
\]

Writing `A=r^2 b` changes this to seven-dimensional radial heat for `b`:

\[
\partial_t b=\nu(b''+6b'/r).
\]

The dual factor in (26) solves

\[
\partial_t H=\nu(H_{rr}-4H_r/r).
\tag{28}
\]

Both routes give the same response and retain the small-radius endpoint rather than deleting it.

## 7. Exact total strain memory of one radius

For every `r,nu>0`,

\[
\boxed{
\int_0^\infty
H_5\!\left(\frac r{2\sqrt{\nu t}}\right)\,dt
=\frac{r^2}{6\nu}.
}
\tag{29}
\]

More generally, if `-1<p<3/2`, Tonelli applied to the lower incomplete-gamma integral gives

\[
\boxed{
\int_0^\infty t^p
H_5\!\left(\frac r{2\sqrt{\nu t}}\right)dt
=\left(\frac{r^2}{4\nu}\right)^{p+1}
\frac{\Gamma(3/2-p)}{(p+1)\Gamma(5/2)}.
}
\tag{30}
\]

In particular the first temporal moment is `r^4/(24 nu^2)`; the second moment diverges. The kernel is not being replaced by exponential damping.

For an initial quadrupole with `int r ||A_omega0(r)|| dr < infinity`, Fubini gives the exact signed matrix identity

\[
\boxed{
\int_0^\infty S_{e^{\nu t\Delta}u_0}(0)\,dt
=-\frac1{10\nu}\int_0^\infty r A_{\omega_0}(r)\,dr.
}
\tag{31}
\]

Its absolute version is

\[
\int_0^\infty\|S_{e^{\nu t\Delta}u_0}(0)\|\,dt
\le\frac1{10\nu}\int_0^\infty r\|A_{\omega_0}(r)\|\,dr.
\tag{32}
\]

For aligned matrix sources of one sign, equality holds in (32).

## 8. Compose with the actual NS nonlinearity, not an independent forcing

On a common classical interval let

\[
\mathcal N(x,s)=\operatorname{curl}\bigl(u(x,s)\times\omega(x,s)\bigr).
\tag{33}
\]

Then

\[
\omega(t)=e^{\nu t\Delta}\omega_0
+\int_0^t e^{\nu(t-s)\Delta}\mathcal N(s)\,ds.
\]

At a fixed spatial center define `A_0(r)=A_omega0(r)` and `A_N(r,s)=A_N(s)(r)` using (22). Equation (26) gives

\[
\boxed{\begin{aligned}
S(0,t)=-\frac35&\int_0^\infty H_5\!\left(\frac r{2\sqrt{\nu t}}\right)
A_0(r)\frac{dr}{r}\\
-\frac35&\int_0^t\int_0^\infty
H_5\!\left(\frac r{2\sqrt{\nu(t-s)}}\right)
A_{\mathcal N}(r,s)\frac{dr}{r}\,ds.
\end{aligned}}
\tag{34}
\]

Every omitted angular component is still present through the same-source quadratic field (33). In particular `A_N` is not free input data, and (34) is not a closed five-variable model.

Where the right side of the following bound is finite,

\[
\boxed{
\int_0^T\|S(0,t)\|dt
\le\frac1{10\nu}
\left[\int_0^\infty r\|A_0(r)\|dr
+\int_0^T\int_0^\infty r\|A_{\mathcal N}(r,s)\|dr\,ds\right].
}
\tag{35}
\]

This is a response estimate at the declared center, not a uniform-in-space regularity theorem. A moving center requires the corresponding transported earlier sources; it cannot be substituted without changing the equation.

The full history composes by the actual heat semigroup and Duhamel integral. Under finite parabolic scaling, `r/sqrt(nu t)` is invariant. Under the outer Euler chart the same formula uses its transported effective viscosity. No singular-limit interchange is needed for these finite-stage statements.

## 9. Large instantaneous growth is compatible with fixed energy and fixed peak vorticity

Here is an exact source control against the claim that large directional bandwidth alone forces instantaneous viscous depletion at the peak.

Let

\[
A=\operatorname{diag}(1/2,1/2,-1),\qquad
0\le\phi\in C_c^\infty((1,2)),\quad\phi\ne0,\quad\|\phi\|_\infty\le1.
\]

At radii `R_j=4^{-j}`, define disjoint toroidal vorticity shells

\[
\omega_j(rn)=\phi(r/R_j)T_A(n).
\tag{36}
\]

Since `sup |T_A|=3/4`, the sum of any number of these disjoint shells has vorticity supremum at most `3/4`. Each shell generates the same positive axial central strain:

\[
S_j(0)e_3=c_0e_3,\qquad
c_0=\frac35\int_1^2\frac{\phi(q)}q\,dq>0.
\tag{37}
\]

Let `u_j` be its actual Biot–Savart velocity. Its `L2` norm is proportional to `R_j^(5/2)`, so

\[
\left\|\sum_{j=1}^N u_j\right\|_2
\le C\sum_{j=1}^N4^{-5j/2}
\le C/31.
\tag{38}
\]

Add a compactly supported solid-rotation core inside `B_{R_N/10}` with vorticity equal to `e_3` near zero and global vorticity at most one. Such a core can be made explicit as

\[
v_\varepsilon(x)=\frac12\chi(|x|/\varepsilon)e_3\times x,
\]

where `chi=1` near zero, is smooth compactly supported, is nonincreasing, and satisfies `0<=-r chi'(r)<=1`. Its vorticity is

\[
\chi\cos\vartheta\,n+
\left(\chi+\frac{r\chi'}2\right)(e_3-\cos\vartheta\,n),
\]

so its norm is bounded by one. Choosing a sufficiently long logarithmic cutoff interval gives all the required conditions. Its energy is `O(epsilon^5)`.

Set

\[
u_{0,N}=v_{\varepsilon_N}+\sum_{j=1}^N u_j.
\]

Then

\[
\boxed{
\|\operatorname{curl}u_{0,N}\|_\infty=1,\quad
u_{0,N}(0)=0,\quad
\operatorname{curl}u_{0,N}=e_3\text{ near }0,\quad
\sup_N\|u_{0,N}\|_2<\infty.
}
\tag{39}
\]

For its own classical NS evolution at any fixed viscosity `nu>0`,

\[
\boxed{
\partial_t\omega_N(0,0)=Nc_0e_3.
}
\tag{40}
\]

Indeed all spatial derivatives of vorticity vanish at the center, so advection and the viscous Laplacian vanish there; the solid rotation does not stretch its axis, and the N remote strains add.

The right lower derivative of the vorticity supremum is consequently at least `N c_0`. Thus instantaneous normalized peak growth is unbounded on this admissible smooth source class.

Energy can even be fixed **exactly**: replacing each initial velocity by `lambda_N u_{0,N}(x/lambda_N)` preserves its vorticity supremum and central strain while multiplying energy by `lambda_N^5`. Choose the positive `lambda_N` to give any prescribed positive kinetic energy.

These are different smooth initial sources, not successive stages of one blow-up trajectory. They show that instantaneous source algebra, finite energy, and a vorticity bound do not supply the missing temporal sign/depletion statement.

## 10. The same example has uniformly finite freely diffusing memory

For the freely diffusing shell sum, (31) gives

\[
\int_0^\infty S_N^{\mathrm{heat}}(0,t)\,dt
=-\frac{A}{10\nu}\left(\int_1^2 q\phi(q)dq\right)
\sum_{j=1}^N R_j^2.
\tag{41}
\]

But

\[
\sum_{j=1}^N R_j^2=\frac{1-16^{-N}}{15}\le\frac1{15}.
\]

Because all contributions are aligned and have one sign, the integrated norm also remains uniformly bounded. The radial solid-rotation core contributes no central strain under heat evolution.

Consequently

\[
\boxed{
S_N(0,0)\sim N
\quad\text{while}\quad
\int_0^\infty\|S_N^{\mathrm{heat}}(0,t)\|dt=O(1).
}
\tag{42}
\]

This is the distinction that a stationary bandwidth argument misses. Arbitrarily large instantaneous strain does not establish sustained nonlinear growth. The exact remaining history is the second line of (34), with (33) tying every contribution to the actual common solution.

# What is and is not closed

The RH construction eliminates every undesired spectral coordinate using an explicit source made from the actual theta kernel. It keeps the source cutoff residue and improves its support overhead to logarithmic size. The resulting endpoint negative-eigenvalue bound is proved from any hypothetical off-line zero. No global arithmetic lower bound or passive-storage identity is supplied.

The NS calculation solves the viscous response of the precise angular sector responsible for strain and integrates its memory exactly. It composes that response with the actual nonlinear source. It also gives a smooth finite-energy control showing why no pointwise bandwidth/depletion inference follows from the stated instantaneous data. No uniform temporal control of the common-source nonlinear term has been proved.

Lossless completion does not require reinvention in either argument. It also does not make the last two analytic signs true by itself. This note retains the sources and declares exactly which completed statements can be transported.

## Source ledger

Repository paths actually read during this pass:

- `formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda`
- `formal/cubical/theorems/automata/ActionResidual.agda`
- `formal/lean/Pairfield/GoldbachReconstructionChain.lean`
- `formal/lean/Pairfield/FinitePositiveExposedPoint.lean`

Other retrieved source:

- Saved **Explicit spectral-source interpolation and the renormalized strain current**, 2026-09-07, `proof_note(6).md`.
- Saved **Work balance and toroidal quadrupole selection**, 2026-09-07, mounted under `passivity_toroidal_quadrupole`.
- M. Suzuki, **Weil's quadratic form via the screw function**, arXiv:2606.09096v2, manuscript dated 24 August 2026. Used only for the actual classical Weil form, its compact smooth core, and the localized operator interpretation.
- NIST DLMF §§25.4 and 8.2, for completed-zeta reflection conventions and incomplete-gamma definitions.
- The theta functional equation, heat kernel, Biot–Savart formula, and elementary spherical-harmonic calculus are classical analytic inputs; their needed calculations are given above.

## Executed verification

`checks.py` is executable and records its own count. It ran 67 exact symbolic controls and 6 separately labelled numerical consistency checks at 45-decimal working precision. Its polynomial zero divisor is synthetic and explicitly not the zeta divisor. The numerical xi tests evaluate nonzero test arguments; they make no assertion of an off-critical zero.

The script checks finite source interpolation, multiplicity normalization, the homogeneous past/future discrepancy, the theta-kernel differential identity, the heat-regularized Hessian and radial response equations, the exact memory moments, and the geometric shell sums. The infinite analytic arguments are the proofs above, not consequences of the finite tests.

No repository mutation, no Agda/Lean build, and no background task were performed.


---

# ORIGINAL S14 — User synthesis: reflection-scale holonomy, strain coboundary and nonlinear memory
Source path: `sources/S14_user_holonomy_and_nonlinear_memory_RECONSTRUCTED.md`; SHA-256: `774dd7f1293bfe92efe8abe77d62fa309fb4d2715812589b2539bd86a4f2dbb8`
Transfer status: Reconstructed visible user synthesis; no claim of original attachment recovery.

# Reconstructed record: reflection-scale holonomy and nonlinear toroidal memory

Provenance: mathematical reconstruction of the long visible user-supplied synthesis, comparing `168ea8e240524f898af4b0e9cf70297c38422f08`. This is not a byte-exact original attachment. The canonical handoff incorporates subsequent corrections, especially signed radial spectra, actual directional work and first-return signs.

## RH loop, actual completed Weil source

On H=l2(Sigma,m), theta z=-conj z, J a(z)=a(theta z), QW(a,b)=<a,Jb>, and U_t a(z)=exp(-zt)a(z), retain

    U_t* J U_t=J.

The loop is

    H_t=J U_t J U_t^-1=diag(exp(2t Re z)).

On z=sigma+i gamma and theta z=-sigma+i gamma it is diag(exp(2sigma t),exp(-2sigma t)). Therefore RH iff H_t=I for one nonzero t; the group law and reflection give H_(t+s)=H_t H_s and J H_t J=H_t^-1.

With delta=sup|Re z|, for t>0,

    ||H_t||=exp(2t delta),
    delta=(1/(2t))log||H_t||.

Its derivative at zero is 2diag(Re z). A fixed faithful packet has H(z)!=0 at every actual zero, so H_t Eh=Eh iff RH. Its positive two-sided norm defect is

    ||U_t Eh||^2+||U_-t Eh||^2-2||Eh||^2
       =4 sum_z m(z)|H(z)|^2 sinh^2(t Re z).

This is positive and zero exactly on RH. The compact-source image theorem says the reflected specified packet has a compact lift iff RH. Completion-level reflection existence is not compact-source realizability. The opposite cycle orientation is the reciprocal positive operator.

## Strain potential coboundary

Let L=-Delta, B omega=S be Biot-Savart strain, and

    Pi_pot[omega]=B L^-1 omega=L^-1 S.

The actual vorticity equation omega_t=N-nu L omega, N=curl(u cross omega), gives

    partial_t Pi_pot[omega]=Pi_pot[N]-nu S.

Thus

    nu integral_(t0)^(t1) S(x,t)dt
       =Pi_pot[omega](x,t0)-Pi_pot[omega](x,t1)
        + integral Pi_pot[N](x,t)dt.

The toroidal coordinate is

    Pi_pot[omega](0)=-(1/10) integral_0^infinity r A_omega(r)dr.

Materially,

    nu S=-D_t Pi_pot[omega]+R,
    R=[u dot grad,Pi_pot]omega+Pi_pot[(omega dot grad)u].

Along a specified particle path, integrating keeps endpoint potential plus actual nonlinear residual. For directional stretching, later correction adds `2(D_t xi)^T Pi_pot xi` after contracting with xi; a closed potential alone is not a closed stretching-work loop.

Near/far Newton-kernel estimates give

    ||Pi_pot[omega]||infty
       <=C ||u||2^(4/5)||omega||infty^(1/5).

At the energy/vorticity chart the endpoint potential is uniformly bounded. This does not bound the nonlinear residual circulation.

## First nonlinear toroidal memory

For omega=f(r)T_A(n), A symmetric trace free,

    N=beta2 T_(A^2)_0+beta4 T4[A],
    beta2=(6/7)(5gf+2r g'f+r g f'),
    g''+6g'/r=-f/r^2.

Heat preserves angular degree. The future linear central-strain memory of this instantaneous nonlinear source sees beta2:

    integral_0^infinity B e^(nu t Delta)N(0)dt
      =-(1/(10nu)) integral r beta2(r)dr (A^2)_0.

Integrating by parts gives

    integral r beta2 dr=(6/7) I[f],
    I[f]=integral (9r g^2-r^3 g'^2)dr.

For a unit radial atom at s,

    g_s(r)=(1/5)s^-1 for r<s,
             (1/5)s^4 r^-5 for r>s.

The polarized radial form is

    I[f]=integral integral f(s)f(t)K(s,t)dsdt,
    K(s,t)=min(s,t)/(10 max(s,t))
       * [3-2(min(s,t)/max(s,t))^3].

K(s,t)>0, so nonzero nonnegative f implies I[f]>0 and the integrated source memory is

    -(3/(35nu)) I[f](A^2)_0.

Later exact signed-spectrum work proves that K is not a positive-semidefinite kernel on signed f. The original nonnegative-cone result remains valid, but emitted beta2/beta4 are signed and cannot be fed into it as positive inputs without an additional theorem.

## Geometric shell stack

For R_j=4^-j and nonnegative smooth phi supported in (1,2), let

    f_N(r)=sum_(j=1)^N phi(r/R_j),
    c_phi=integral_1^2 phi(q)dq/q.

Then S_N(0)=-(3/5)N c_phi A. Its instantaneous pure quadrupole feedback is

    S_N'(0)|pure=-(5/7)(S_N^2)_0
               =-(9/35)N^2 c_phi^2(A^2)_0.

Yet K(s,t)<=3min(s,t)/(10max(s,t)), so all self and cross-shell pairs satisfy

    I[f_N]<=C_phi sum_j j R_j^2
           <=C_phi (16/225).

Thus instantaneous strain grows like N, instantaneous quadratic feedback like N^2, but the complete future freely propagated memory of that snapshot nonlinear injection stays bounded independently of N. This is a genuine static-source calculation, not a conclusion about full future nonlinear regeneration.

The next actual first-return source is `P2 DN(a)[P4 N(a)]`. Its computed formula and all-time free response are in [S15]; the full source-coherent evaluator and midpoint storage identities are in [S17–S19].


---

# ORIGINAL S15 — Actual toroidal 2->4->2 return, sign examples and geometric-stack bound
Source path: `originals/conversation/toroidal_first_return/proof_note.md`; SHA-256: `ee526e2031e15c7b482fa4832b169c045f8559b6016fbc62262c18fe1b4bf867`
Transfer status: Original mounted note; timestamp aliases also existed.

# The actual toroidal 2 -> 4 -> 2 return: its radial operator, memory kernel, and sign

Date: 2026-09-07.
Repository read pin: `avikj/metacircular-interaction-prototype`, commit `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope and provenance

This note continues the user-supplied reflection-scale holonomy / nonlinear quadrupole memory calculation. The actual l=2/l=4 outgoing coefficients, toroidal strain selection, and free heat response are retained inputs. The new calculations are the full polarized l=4-to-l=2 return, its exact integrated free-response kernel, opposite-sign smooth-source examples, and a uniform geometric-stack bound for this next returned source.

No global NS regularity or RH proof is asserted. No Agda or Lean build and no nonlinear PDE simulation was executed. The calculation concerns smooth whole-space finite-energy sources. Compactly supported radial profiles in annuli are the principal class; a rapidly decaying smooth source is also used as a sign control, and its compact annular approximation is described below. These are actual initial data and actual initial variations, not a constructed singular solution.

Sources read:

* Repository `formal/cubical/theorems/automata/ExcursionReturn.agda`: checked ring/semigroup compression identity and observability equivalence. This is supplied machinery, not an analytic Navier-Stokes theorem.
* Saved `proof_note(7).md`, **Source-image rigidity and the exact nonlinear leakage...**, sections 7--14: toroidal degree-two source reconstruction, the full matrix pressure identity, actual outgoing coefficients beta2/beta4, and the distinction between a frozen factorization and the derivative of the common source.
* Saved `source_resolved_closure/proof_note.md`: actual Xi-cardinal sources; exact quadrupole heat response and integrated memory.
* The user's present note supplies the quadratic radial kernel K and signed strain-potential coboundary identity. Both are retained with their actual source hypotheses.

Classical context: the Mori--Zwanzig / excursion-return representation is an exact organizational identity, not an automatic sign or finite-memory theorem. See Gouasmi, Parish, Duraisamy, Proc. R. Soc. A 473 (2017), 20170385, doi:10.1098/rspa.2017.0385. None of the calculations below require an approximate orthogonal-dynamics model.

## 1. Retained angular conventions

Let A be a nonzero real symmetric trace-free 3x3 matrix. Write

    q = tr(A^2),  B = (A^2)_0,
    Y2(n) = n^T A n,
    T_A(n) = n cross (A n) = (1/2)n cross grad_S Y2,
    Y4(n) = Y2(n)^2 - (4/7)n^T B n - (2/15)q,
    T4[A](n) = (1/4)n cross grad_S Y4
              = Y2(n) T_A(n) - (2/7)T_B(n).

Y4 has scalar spherical degree four, and T4[A] has toroidal vector degree four. The fixed-centre projection P is onto the full toroidal degree-two vorticity space (arbitrary matrix-valued radial coefficients), not merely onto multiples of this one A. Put Q=I-P.

For a real radial f, set

    a(rn)=f(r)T_A(n).

Its actual finite-energy velocity is

    u_a = curl[g(r) x cross(Ax)],
    g''+6g'/r = -f/r^2,
    g(r)=(1/5)[r^(-5) integral_0^r s^4 f(s)ds
                         + integral_r^infinity f(s)ds/s].

The actual vorticity nonlinearity is

    N(omega) = curl(u_omega cross omega),
    u_omega = curl(-Delta)^(-1)omega.

The saved outgoing calculation is

    N(a)= beta2 T_B + beta4 T4[A],
    beta2=(6/7)(5gf+2rg'f+rgf'),
    beta4=3rgf'-6gf-rg'f.

Heat preserves the angular splitting. In particular Q N(a)=beta4 T4[A].

## 2. Positivity of the preceding radial kernel: exact domain and exact sign spectrum

The user-supplied first nonlinear-memory form is

    I[f]=integral integral f(s)f(t)K(s,t)dsdt,
    K(s,t)= min(s,t)/(10 max(s,t))
            *[3-2(min(s,t)/max(s,t))^3].

The kernel is strictly positive pointwise. Therefore I[f]>0 for nonzero f>=0. This does not assert positive semidefiniteness on signed sources.

Indeed, at radii 1 and 2 its Gram matrix is

    [[1/10, 11/80], [11/80, 1/10]],

whose eigenvalues are 19/80 and -3/80. Two opposite unit radial atoms have quadratic value -3/40. Replacing the atoms by sufficiently narrow smooth disjoint bumps preserves this strict negative value.

There is an exact Mellin-frequency classification. Set

    x=log r,  F(x)=e^x f(e^x).

Then

    I[f]=integral integral F(x)F(y) k(x-y)dxdy,
    k(x)=(1/10)(3 exp(-|x|)-2 exp(-4|x|)).

With Fourier convention Fhat(xi)=integral exp(-i xi x)F(x)dx,

    khat(xi)=(8-xi^2)/[(1+xi^2)(16+xi^2)],

and hence

    I[f]=(1/(2pi)) integral
         (8-xi^2)/[(1+xi^2)(16+xi^2)] * |Fhat(xi)|^2 dxi.

The form has positive log-radius frequencies |xi|<sqrt(8) and negative frequencies |xi|>sqrt(8).

The nonlinear source is not confined to nonnegative scalar injections even when the initial f is nonnegative. In the compact annular class g>0 and

    beta2=(6/7) r^(-4)g^(-1) d/dr[r^5 g^2 f],
    beta4=3r^3 g^(4/3) d/dr[f/(r^2 g^(1/3))].

For nonzero f>=0 both bracketed functions are positive somewhere and vanish at the endpoints of their support. Their derivatives, and thus beta2 and beta4, take both signs. This is a statement about the source-injection map, not by itself a claim that a scalar positivity cone for an evolution is noninvariant.

## 3. The exact first return must differentiate both source occurrences

For a smooth source a, the actual derivative is

    DN(a)[b] = curl(u_a cross b + u_b cross a).

Keeping only one summand is a frozen-input response and is not the required derivative.

Let F(omega)=nu Delta omega+N(omega), and let omega(t) solve the actual NS vorticity equation with omega(0)=a=Pa. Let p(t) solve the projected equation

    p'=nu Delta p+P N(p),  p(0)=a.

The two are compared only on a common classical interval. Since P commutes with Delta,

    (P omega)''(0)-p''(0) = P DN(a)[Q N(a)].

Consequently

    P omega(t)-p(t)=(t^2/2) P DN(a)[Q N(a)]+o(t^2).

Thus

    R24(a):=P DN(a)[Q N(a)]

is the actual first outward-and-return contribution. The equality does not assume that the degree-two sector is invariant or that an arbitrary linear operator describes the nonlinear flow.

## 4. Explicit radial/angular return operator

First take a general degree-four perturbation in the direction actually emitted by a:

    b(rn)=h(r)T4[A](n).

Write its vector potential as r^2 p(r)T4[A](n). Then

    p''+6p'/r-14p/r^2 = -h/r^2,
    p(r)=(1/9)[r^(-7) integral_0^r s^6 h(s)ds
                          + r^2 integral_r^infinity h(s)ds/s^3].

This is the regular finite-energy inverse; no independent harmonic solution is added.

### The return formula

    P DN(f T_A)[h T4[A]]
      = (4q/49) C[f,h](r) T_A(n),

where

    C[f,h] = 15gh+6rg'h+3rgh' + pf-rp'f-4rpf'.

For the actual first return, substitute h=beta4[f] and its corresponding p. The coefficient is cubic in the actual initial source.

### Derivation

A toroidal mode omega_l=f_l(r) n cross grad_S Y_l/l with vector potential p_l(r) n cross grad_S Y_l/l has velocity

    u_l= a_l Y_l n + b_l grad_S Y_l,
    a_l=-(l+1)p_l/r,
    b_l=-(p_l'+p_l/r)/l.

Here p_2=r^2g and p_4=r^2p, so

    a2=-3rg, b2=-(3rg+r^2g')/2,
    a4=-5rp, b4=-(3rp+r^2p')/4.

The only scalar angular coefficient needed is

    projection_l2(Y2 Y4)=(24/245)q Y2.

This follows from exact sphere moments; equivalently, for every trace-free symmetric C,

    integral Y2(A)Y4(A)Y2(C)
       = (24/245)q integral Y2(A)Y2(C).

For an angular product projected to degree L, integration by parts gives

    projection_L(grad_S Y_l dot grad_S Y_k)
      = [l(l+1)+k(k+1)-L(L+1)]/2 * projection_L(Y_lY_k),

and the gradient projection of Y_l grad_S Y_k has coefficient

    [L(L+1)+k(k+1)-l(l+1)]/[2L(L+1)].

For L=2 and (l,k)=(2,4), the relevant numbers are 10 and 5/3; with (l,k)=(4,2), they are 10 and -2/3.

Writing the poloidal l2 part of u_a cross b+u_b cross a as

    alpha(r)Y2 n + beta(r)grad_S Y2,

one obtains, with c=24/245,

    alpha=10 c q (b2 h/4+b4 f/2),
    beta=c q (-5 a2 h/12+a4 f/3).

Its curl is 2[(r beta)'-alpha]T_A/r. Substitution gives the displayed return formula.

## 5. Exact integrated viscous memory of the returned source

Let Bstr denote the Biot-Savart strain map acting on vorticity. For every toroidal degree-two source F(r)T_A,

    integral_0^infinity Bstr exp(nu t Delta)[F T_A](0)dt
       = -(1/(10nu)) integral_0^infinity rF(r)dr * A,

when the absolute radial moment is finite.

Apply this to the returned source. Define

    J24[f,h]=integral integral f(s)h(t)L24(s,t) dsdt.

Then

    integral_0^infinity Bstr exp(nu t Delta)
      P DN(f T_A)[h T4[A]](0) dt
       = -(6q/(245nu)) J24[f,h] A,

where the exact directional two-radius kernel is

    L24(s,t) =
      (3/5)(t/s)-(4/9)(t/s)^6,       0<t<=s,
      (5/9)(s/t)^3-(2/5)(s/t)^4,     0<s<=t.

Both formulas agree at s=t with value 7/45. Both are strictly positive for positive radii. The kernel is directional: s labels a degree-two source radius; t labels a degree-four source radius. It is not symmetrized by exchanging those roles.

### Radial computation

The exact integration-by-parts identity is

    r C[f,h]
      = 3[(3rg+r^2g')h+(3rp+r^2p')f]
        + d/dr[3r^2gh-4r^2pf].

The boundary term vanishes in the declared source class. The Green functions for unit radial atoms are

    g_s(r)=(1/5)[s^(-1), r<s; s^4 r^(-5), r>s],
    p_t(r)=(1/9)[r^2 t^(-3), r<t; t^6 r^(-7), r>t].

Thus

    L24(s,t)=3t g_s(t)+t^2g_s'(t)+3s p_t(s)+s^2p_t'(s),

which gives the two cases above directly. The matching value on the diagonal is unambiguous by continuity.

## 6. Opposite-sign controls using the same nonlinear ancestry

For the actual return, h=beta4[f]. Even though L24 is pointwise positive, beta4 need not be positive. The resulting memory is not always damping and not always amplifying.

### A. A positive smooth source with opposing returned memory

Take

    g(r)=(1+r^2)^(-2),
    f(r)=4r^2(r^2+7)/(1+r^2)^4 >0,
    h(r)=beta4[f](r)=-8r^4(7r^2+67)/(1+r^2)^7 <0.

These are smooth whole-space finite-energy data; f T_A is smooth at zero, and all displayed moments converge at infinity.

Pointwise positivity of L24 gives

    J24[f,beta4[f]]<0.

The initial central strain is S(0)=-3A, whereas the integrated free response of the returned source is a strictly positive multiple of A. Thus this particular returned contribution opposes the initial strain.

This example can be moved into the compact annular class: multiply f by smooth cutoffs which remove r<epsilon and r>R, with epsilon ->0 and R ->infinity. Recompute g from the actual Green inverse and h=beta4[f]. The small-r behavior f=O(r^2) and large-r behavior f=O(r^-4), together with the explicit Green and L24 kernels, give convergence of J24. Its strictly negative sign therefore persists for sufficiently wide compact annular cutoffs. No singular initial data are required.

### B. A thin nonnegative smooth shell with reinforcing returned memory

Let phi be nonnegative, smooth, compactly supported in (-1,1), and have integral one. Put

    f_epsilon(r)=epsilon^(-1) phi((r-1)/epsilon).

Every epsilon in (0,1/2) gives a smooth compact annular source. Let g_epsilon be its actual radial inverse and h_epsilon=beta4[f_epsilon]. Then

    J24[f_epsilon,h_epsilon] -> 151/225 >0.

Here is a derivation which avoids singular distribution products. Define

    W_f(t)=integral f(s)L24(s,t)ds.

Integration by parts gives

    J24[f,beta4[f]]
       = -integral f(t)[(9g+4tg')W_f+3tg W_f']dt.

On the support of the thin shell, set F_epsilon(t)=integral_0^t f_epsilon(s)ds. Uniformly there,

    g_epsilon=1/5+O(epsilon),
    t g_epsilon'=-F_epsilon+O(epsilon),
    W_f=7/45+O(epsilon),
    W_f'=-31/15+2F_epsilon+O(epsilon).

The two slopes of L24 in its second variable at the diagonal are -31/15 and -1/15. Substitution yields

    J24 = integral f_epsilon[24/25-(26/45)F_epsilon]dt+O(epsilon)
        = 24/25-13/45+O(epsilon)
        = 151/225+O(epsilon).

The initial strain tends to -(3/5)A, and the returned integrated memory is a negative multiple of A. It therefore reinforces the initial strain.

The peak vorticity of the unit-mass thin shell grows as epsilon shrinks. To compare sources with fixed vorticity supremum, multiply each source by a positive normalizing scalar. Both the initial strain and the cubic returned contribution retain their signs; the latter scales cubically. Thus the two signs are not an artifact of allowing only one amplitude normalization.

These statements concern the actual first-return source and its subsequent free heat response. They are not statements that the full nonlinear solution has monotonically increasing or decreasing strain.

## 7. The geometric stack remains bounded at this next returned-memory level

Take R_j=4^(-j) and

    f_N(r)=sum_{j=1}^N phi(r/R_j),
    phi>=0, phi smooth and compactly supported in (1,2).

Set h_N=beta4[f_N] using the full g_N of the entire stack, not isolated-shell approximations.

On shell j,

    |f_N|+|r f_N'| <= C_phi,
    |r g_N'| <= C_phi,
    |g_N| <= C_phi j,

and hence

    |h_N|<=C_phi j.

For s on shell i and t on shell j, the exact kernel obeys

    L24(s,t)<= (3/5)t/s       if i<j,
    L24(s,t)<= (5/9)(s/t)^3   if i>j,

with a bounded diagonal term. Integrating the shell lengths gives

    |J24[f_N,h_N]|
       <= C_phi sum_{j=1}^N j^2 R_j^2
       <= C_phi * 272/3375.

The final constant is

    sum_{j>=1}j^2 16^(-j)=272/3375.

Therefore

    sup_N || integral_0^infinity Bstr exp(nu t Delta) R24(a_N)(0)dt || < infinity

for fixed A and nu>0. All cross-shell interactions in this first returned source are included.

This can be strengthened from a signed integrated value to total variation of the free response. On shell j, the same formulae also give

    |r h_N'| <= C_phi j,
    |p_N|+|r p_N'| <= C_phi j.

For the first inequality use the radial g equation and the scale-uniform bounds on r f_N' and r^2 f_N''. For the second, insert |h_N|<=C_phi k on each shell into

    p_N=(1/9)[r^(-7) integral_0^r s^6h_N ds
                         +r^2 integral_r^infinity h_N ds/s^3],
    r p_N'=(1/9)[-7r^(-7) integral_0^r s^6h_N ds
                         +2r^2 integral_r^infinity h_N ds/s^3].

Both sums are geometric; unlike g_N, the l4 inverse attenuates both remote directions. Consequently

    |C[f_N,h_N](r)| <= C_phi j^2  on shell j,
    integral_0^infinity r |C[f_N,h_N](r)|dr
       <= C_phi sum_{j>=1}j^2 R_j^2 < infinity.

The nonnegative H5 heat kernel and its exact integrated lifetime therefore give the stronger result

    integral_0^infinity ||Bstr exp(nu t Delta) R24(a_N)(0)||dt
       <= (2q ||A||/(245nu)) integral_0^infinity r|C[f_N,h_N](r)|dr
       <= C(A,phi)/nu * 272/3375,

uniformly in N. This bound is on the integral of the norm; it does not depend on cancellation between different response times.

This extends the supplied bounded-memory calculation by one actual angular return, including total variation of its freely propagated response. It does not establish a uniform bound after arbitrarily many nonlinear returns or under nonlinear regeneration throughout time.

## 8. The actual time-ordered return coefficient

The snapshot calculation has an exact placement in the source-coherent history expansion. Let omega_epsilon solve NS from epsilon a on a common classical interval. Let E_l(t) be the radial heat semigroup

    exp[nu t(d_r^2+(2/r)d_r-l(l+1)/r^2)].

The first amplitude coefficient is

    w1(t)=E_2(t)f * T_A.

Its emitted degree-four coefficient is

    h4(t)=integral_0^t E_4(t-s) beta4[f_s] ds,
    f_s=E_2(s)f.

The cubic contribution which leaves degree two, propagates in degree four, and returns to degree two is exactly

    R3(t)=integral_0^t exp(nu(t-s)Delta)
                    P DN(w1(s))[h4(s)T4[A]] ds.

Equivalently, its radial coefficient is

    R3(t,r,n)=(4q/49) integral_0^t
          E_2(t-s) C[f_s,h4(s)](r) ds * T_A(n).

Every g_s and p_s in C is the specified finite-energy inverse of f_s and h4(s). The two velocity variations are both present. This is the actual cubic amplitude coefficient in the full NS expansion, not a guessed reduced memory law. Other cubic histories (those remaining in P) are separate terms and are not erased.

The expression can be derived directly by differentiating the mild equation with respect to epsilon. It claims the finite-order coefficient on a common classical interval, not convergence of an infinite series beyond that interval.

## 9. Strain-potential circulation versus actual stretching work

The user's field identity is valid with the smoothing strain potential Pcal=Bstr(-Delta)^(-1), on a class where the inverse is fixed:

    nu S=-D_t Pcal[omega]
          +[u dot grad,Pcal]omega
          +Pcal[(omega dot grad)u].

Set Rcal to the last two terms. If X follows a fluid path and xi=omega/|omega| is defined there, its actual stretching alpha=xi^T S xi satisfies

    nu integral alpha dt
      = [xi^T Pcal[omega] xi]_(initial)
        -[xi^T Pcal[omega] xi]_(final)
        +integral [xi^T Rcal xi+2 (D_t xi)^T Pcal[omega] xi]dt.

The last term is forced by differentiating the common direction as well as the source potential. A signed field circulation cannot be silently identified with the scalar work seen by a rotating vorticity direction, or with a time integral of a norm. Bounded endpoint potential does not remove this source-dependent term.

## 10. RH state retained without another equivalent reformulation

On the distinct shifted nontrivial zero carrier, with multiplicity weights and

    (U_t a)_z=exp(-zt)a_z,  (Ja)_z=a_(-conj z),

normal diagonal multiplication gives

    J U_t J U_t^(-1)=(U_t^*U_t)^(-1)
                    =diag(exp(2t Re z)).

This is the reciprocal orientation of the positive loop J U_t^(-1)J U_t=U_t^*U_t. The supplied holonomy norm and one-packet sinh-square formulas therefore remain correct. They characterize RH but do not establish identity of the loop; the compact-source lifting hypothesis remains a separate actual-source statement.

No new RH conclusion is inferred from positivity of the NS radial kernels. In particular, pointwise kernel positivity, positive semidefiniteness, signed input-output work, and a conserved indefinite form are kept as distinct assertions.

## 11. Result

The l=4 sector is not merely a place where information leaves the l=2 strain observer. It returns under the actual derivative of the common NS source. That first return has an explicit radial differential operator and a closed two-radius heat-memory kernel. For smooth nonnegative starting profiles, its integrated returned contribution can reinforce or oppose the initial strain. The geometric stack has uniformly bounded total free-response variation even at this first-return stage, but the actual causal coefficient retains both ordered time integrals.

This supplies an application-specific term for the requested excursion-return program. It does not replace the full nonlinear history with an invariant five-dimensional model and does not establish a global return bound.


---

# ORIGINAL S16 — Moving-peak heat control, signed radial spectrum and one-sided arithmetic escape
Source path: `sources/S16_moving_peak_and_signed_spectrum.md`; SHA-256: `41f980eae2bf56a826fbbdefdec8d8f00ede67537f3cc92f051a8d702a5cd0ca`
Transfer status: Recovered stronger parallel note dated research state Sept 7.

# Moving-peak control, the signed nonlinear-memory spectrum, and one-sided arithmetic escape

Date: 7 September 2026 (research state).
Repository checked: `avikj/metacircular-interaction-prototype`, default-branch commit
`168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

This note continues the user's assembled actual-endpoint graph. It does not reopen source
reconstruction or require a recurrent renormalized limit. The application assertions remain:

- `B_NS`: integrability of positive stretching at actual vorticity maxima of the one maximal NS history;
- `B_RH`: a tail bound for the actual faithful arithmetic receiver, not a substitute positive kernel.

The additions are:

1. A bound with **the spatial supremum inside the time integral** for every freely diffusing
   velocity source, and for the entire freely propagated response to its nonlinear velocity source.
   This repairs the fixed-centre quantifier problem without exchanging supremum and integration.
2. Direct control of the actual full NS evolution for small scale-critical energy–enstrophy
   product. Applying that classical bootstrap to the retained shell construction yields a family
   of globally smooth solutions with uniformly bounded total moving-peak stretching but arbitrarily
   large initial peak stretching. The small-data mechanism is classical; the uniform conclusion for
   this particular source family is the composition made here.
3. The exact **signed** Mellin spectrum of the nonlinear quadrupole-memory form, a sharp positive-cone
   coercivity bound, and a thin-shell theorem: the degree-two nonlinear forcing emitted from a
   nonnegative shell has strictly negative value under that memory form when the shell is thin enough.
   Thus pointwise positivity of its two-radius kernel cannot be iterated as unrestricted Gram positivity.
4. A self-contained Landau positivity argument applied to the faithful actual zeta receiver:
   an off-line zero forces exponentially large excursions in **both** signs. Any eventual one-sided
   polynomial bound for the same arithmetic discrepancy already implies RH.

None of these results supplies global NS regularity for arbitrary data or a proof of the required
one-sided arithmetic bound. No originality-priority claim or Agda/Lean build is made.

---

# I. A heat-response estimate with the correct moving-observer quantifier

Work on R^3, viscosity nu>0. Norms without a domain are whole-space norms. Write
`S_v=sym grad v`. The matrix norm inside Linfinity may be the Frobenius norm or operator norm;
universal constants absorb this finite-dimensional choice.

For a velocity source v define

    H_nu(v) = integral_0^infinity ||S_(exp(nu t Delta)v)||_infinity dt.

This is an integral of a spatial supremum. It dominates the observed absolute strain along
**every** measurable choice of centres and unit directions, including migrating maximizers.

## Theorem 1. Universal integrated heat-strain estimates

For v in H^1(R^3),

    H_nu(v) <= (C/nu) ||v||_2^(1/2) ||grad v||_2^(1/2).             (1)

If v is also bounded,

    H_nu(v) <= (C/nu) ||v||_2^(2/3) ||v||_infinity^(1/3).          (2)

For divergence-free finite-energy v with bounded vorticity,

    H_nu(v) <= (C/nu) ||v||_2^(4/5) ||curl v||_infinity^(1/5).     (3)

### Proof

Set tau=nu t, E=||v||_2 and W=||grad v||_2. Heat-kernel Young inequalities give

    ||grad exp(tau Delta)v||_infinity
       <= C min{ tau^(-3/4) W, tau^(-5/4) E }.

Split at tau_0=(E/W)^2. The first bound is integrable from zero and the second from tau_0 to
infinity. Their integrals are bounded by C sqrt(EW). This proves (1); v=0 is separate and trivial.

Using instead

    ||grad exp(tau Delta)v||_infinity <= C tau^(-1/2)||v||_infinity

for the short-time part, and splitting at tau_0=(E/||v||_infinity)^(4/3), proves (2).

For (3), the identity Delta v=-curl omega yields

    v=exp(s Delta)v + integral_0^s curl exp(tau Delta)omega dt.

Thus ||v||_infinity <= C(s^(-3/4)E+s^(1/2)||omega||_infinity). Optimizing s gives

    ||v||_infinity <= C E^(2/5)||omega||_infinity^(3/5).

Substitution into (2) proves (3). All of these are standard heat and interpolation arguments,
written here to retain the required order of the two observations.

## Theorem 2. All-angular nonlinear snapshot response

For a smooth divergence-free u in H^2, let

    N_u = -P[(u dot grad)u],

where P is the whole-space orthogonal Leray projection. This is the actual nonlinear velocity
source; curl N_u=curl(u cross omega). Put

    E=||u||_2, W=||omega||_2=||grad u||_2,
    P2=||grad omega||_2=||Delta u||_2.

Then

    H_nu(N_u) <= (C/nu) W P2.                                  (4)

### Proof

The Leray projector is contractive on L2 and homogeneous H1. Sobolev, interpolation and Agmon
inequalities give

    ||N_u||_2 <= C W^(3/2) P2^(1/2),
    ||grad N_u||_2 <= C W^(1/2) P2^(3/2).

For the second inequality, differentiate u dot grad u and use

    ||grad u||_4^2 <= C W^(1/2) P2^(3/2),
    ||u||_infinity <= C W^(1/2)P2^(1/2).

The latter inequality also has an elementary Fourier proof: split the inverse Fourier integral
at frequency R, use grad u in L2 below R and D^2u in L2 above R, obtaining
C(W R^(1/2)+P2 R^(-1/2)), and optimize. Apply (1) to N_u.

Equation (4) includes every angular channel, every spatial centre and every Leray/pressure
contribution. It is stronger than the earlier signed time integral at one centre of a pure
quadrupole response. It is still a response to one source snapshot, not an assertion that a
nonlinear NS trajectory equals that response.

## Theorem 3. Direct attachment to the actual maximal NS history

Let u be the smooth maximal solution on [0,T_*). Duhamel's identity is

    u(t)=exp(nu t Delta)u0 + integral_0^t exp(nu(t-s)Delta)N_(u(s)) ds.

For every T<T_*, Tonelli and (4) imply

    integral_0^T ||S_u(t)||_infinity dt
       <= H_nu(u0) + (C/nu) integral_0^T W(s) P2(s) ds.           (5)

In particular the user's actual peak-stretching channel obeys

    integral_0^T b_u(t) dt
       <= (C/nu) sqrt(E0 W0)
          + (C/nu) integral_0^T W(s) P2(s) ds.                  (6)

No trajectory of maximizers is selected or differentiated. No fixed-centre estimate is promoted
to a moving-centre estimate. The spatial supremum was present in H_nu from its definition.

This is a standard sufficient-control route, not a claim that the last integral is finite for
every maximal solution. It identifies an actual analytic upper bound for the assembled B_NS node.

## A complete first nonlinear Picard-response bound

Let v0(t)=exp(nu t Delta)u0 and

    v1(t)=integral_0^t exp(nu(t-s)Delta)N_(v0(s)) ds.

These are the free solution and its first nonlinear Duhamel correction, not the exact full solution.
The exact linear energy identities give

    integral_0^infinity W_(v0)^2 ds = E0^2/(2nu),
    integral_0^infinity P2_(v0)^2 ds = W0^2/(2nu).

Consequently

    integral_0^infinity ||S_(v1(t))||_infinity dt
       <= (C/nu^2) E0 W0.                                     (7)

This already includes time-varying replenishment from the freely evolving source, rather than
freezing N_u at time zero. Higher nonlinear corrections are not controlled by (7) alone.

---

# II. The actual Zeno-source family can be globally regular with uniformly bounded B_NS

## Theorem 4. Classical small energy–enstrophy bootstrap in endpoint form

There is a universal c_*>0 such that, for smooth rapidly decaying divergence-free initial data,

    eta0 := sqrt(E0 W0)/nu <= c_*                              (8)

implies a global classical solution and

    integral_0^infinity b_u(t)dt
      <= integral_0^infinity ||S_u(t)||_infinity dt
      <= C(eta0+eta0^2).                                      (9)

This uses only the ordinary energy/enstrophy estimates and the closing continuation argument
already supplied by the user.

### Proof on the maximal half-open interval

Energy gives

    E(t)^2 + 2nu integral_0^t W(s)^2 ds = E0^2.

The H1 energy identity and Holder–Sobolev yield

    (1/2)(W^2)' + nu P2^2
       <= ||u||_3 ||grad u||_6 P2
       <= C0 sqrt(EW) P2^2.

Choose c_* small enough that C0 sqrt(E0 W0)<=nu/2. A continuity bootstrap shows W(t)<=W0:
while W<=W0 and E<=E0, the right side can be absorbed, giving

    (1/2)(W^2)' + (nu/2)P2^2 <= 0.

Therefore the condition cannot fail at its first alleged failure time. On the entire maximal
interval,

    integral W^2 <= E0^2/(2nu),
    integral P2^2 <= W0^2/nu,
    integral W P2 <= E0 W0/(sqrt(2)nu).

Apply (6). If T_* were finite, integral_0^{T_*}b_u would be finite. The user's maximum-envelope
bound and classical continuation theorem contradict maximality. Thus T_*=infinity, and monotone
convergence in (5) gives (9).

There is no appeal to a recurrent limit, compactified pressure law, or a putative universal
contraction. The smallness hypothesis is explicit. This is not claimed as a historically new
small-data regularity theorem.

## Application to the retained shell construction

The earlier construction supplies smooth initial velocities w_N with

    ||curl w_N||_infinity=1,
    |curl w_N(0)|=1,
    b_(w_N)(0)>=c N-C,
    sup_N ||w_N||_2 ||curl w_N||_2 < infinity,

and in the stronger version uniform palinstrophy as well. A tiny rotating core fixes the unit
central vorticity; each exterior toroidal-quadrupole shell adds the same positive axial strain.
For every fixed N these are genuine smooth finite-energy initial data, not different snapshots
of one pre-existing solution.

To meet the endpoint graph's rapidly decaying initial-data class exactly, make the velocities
compactly supported before applying the following compression. The shell vector potential is
psi_N(x)=g_N(|x|) x cross(Ax). Outside all the shells,

    g_N(r)=d_N r^(-5), with sup_N |d_N|<infinity,

because d_N is a convergent sum of fifth powers of shell radii. Choose a smooth radial cutoff
chi(x/L) equal to one on B_L and zero outside B_(2L), and replace the shell velocity by
curl(chi(x/L)psi_N), leaving the compact rotating core unchanged. This agrees exactly with the
old velocity throughout the shells and at the origin. The new cutoff vorticity is supported
in L<|x|<2L and is bounded by C L^(-5) uniformly in N. Choose L once so this is below 1/2.
The resulting velocities are smooth and compactly supported, retain the unit central vorticity
and the exact diverging central strain, and retain uniformly bounded L2 velocity, L2 vorticity,
and palinstrophy. Denote this compact-velocity version again by w_N.

Fix one R>0 and compress the initial fields by

    w_(N,R)(x)=R w_N(x/R).

This preserves the vorticity amplitude and every initial pointwise strain value:

    curl w_(N,R)(x)=curl w_N(x/R),
    S_(w_(N,R))(0)=S_(w_N)(0).

But

    ||w_(N,R)||_2 = R^(5/2)||w_N||_2,
    ||curl w_(N,R)||_2 = R^(3/2)||curl w_N||_2.

Thus the product E0W0 is multiplied by R^4. Choose R sufficiently small once, independently of N,
so that (8) holds for every member of the family. Let u_(N,R) be each member's actual full NS
solution. Theorem 4 proves

    each u_(N,R) is globally smooth,
    sup_N integral_0^infinity b_(u_(N,R))(t)dt < infinity,
    b_(u_(N,R))(0) -> infinity.                               (10)

This is the precise source-family conclusion: arbitrarily large normalized initial peak
stretching from the geometric Zeno construction can coexist with a uniform bound for its total
actual nonlinear moving-peak stretching. The future source has not been replaced by free heat.

IMPORTANT: this R-compression is NOT the NS parabolic symmetry. Under the actual symmetry
u_lambda(x,t)=lambda u(lambda x,lambda^2 t), E0W0 is invariant. Our R-compression changes its
value and therefore constructs a restricted small-critical family; it does not transport an
arbitrary putative blow-up into the small-data class.

---

# III. The nonlinear quadrupole-memory kernel has a signed Mellin spectrum

Retain the actual aligned source from the saved degree-two/degree-four calculation:

    omega(rn)=f(r) T_A(n), T_A(n)=n cross A n, A in Sym_0(3),
    g(r)=(1/5)[r^(-5) integral_0^r s^4 f(s)ds + integral_r^infinity f(s)ds/s],
    g''+6g'/r=-f/r^2,
    beta2=(6/7)(5gf+2r g'f+r g f').

For f smooth and compactly supported away from zero, the radial nonlinear-memory form is

    I[f]=integral_0^infinity (9r g^2-r^3(g')^2)dr
        = double integral f(s) f(t) K(s,t) ds dt,

    K(s,t)=(m/(10M))[3-2(m/M)^3], m=min(s,t), M=max(s,t).         (11)

The first nonlinear *signed* heat-memory calculation was

    integral_0^infinity S_(heat of nonlinear vorticity source)(0)dt
       = -(3/(35nu)) I[f] (A^2)_0.                            (12)

Equation (12) is a particular signed source observation. It is not the absolute moving-centre
norm controlled in (4).

## Theorem 5. Exact spectral signature

Put ell=log r and define

    F(ell)=exp(ell) f(exp ell),
    b(ell)=exp(ell) g(exp ell).

Then

    F=(1-partial_ell)(4+partial_ell)b,
    I[f]=8||b||_2^2-||b'||_2^2.                               (13)

Equivalently, for the Fourier convention Fhat(xi)=integral exp(-i xi ell)F(ell)dell,

    I[f]=(1/(2pi)) integral
          [(8-xi^2)/((1+xi^2)(16+xi^2))] |Fhat(xi)|^2 dxi.     (14)

### Proof

The change of variables in the Green equation gives
F=4b-3b'-b''. The energy integrand becomes
9b^2-(b'-b)^2=8b^2-(b')^2+(b^2)'. Its boundary term vanishes. This proves (13).

Alternatively K(s,t)=k(log s-log t), where

    k(ell)=(3 exp(-|ell|)-2 exp(-4|ell|))/10.

The Fourier transform is

    khat(xi)=(1/10)[6/(1+xi^2)-16/(16+xi^2)]
            =(8-xi^2)/((1+xi^2)(16+xi^2)).

Plancherel gives (14).

Thus the form is positive in the low logarithmic-frequency band |xi|<sqrt(8) and negative in
|xi|>sqrt(8). Pointwise positivity K(s,t)>0 is NOT positive semidefiniteness on signed sources.

A finite exact control is already visible at radii 1 and 2:

    [K(1,1) K(1,2); K(2,1) K(2,2)]
      = [1/10 11/80; 11/80 1/10],
    determinant = -57/6400 <0.

The signed point-radius source delta_1-delta_2 has I=-3/40. The source delta_1-2delta_2 has
zero instantaneous central strain (integral f(r)dr/r=0) but I=-1/20. These point masses are
algebraic limiting controls, not smooth PDE initial data. Replacing them by narrow smooth bumps
and adjusting the second coefficient to preserve integral f/r=0 gives actual smooth finite-energy
sources with the same zero-strain condition and strictly negative memory.

## A sharp cone coercivity result

For f>=0, the old positivity conclusion is valid and can be strengthened:

    ||b'||_2^2 <= 4||b||_2^2,
    I[f] >= 4||b||_2^2.                                      (15)

The constant 4 is sharp under approximation by a shell concentrated at one radius.

To see this, let g_s denote the unit point-radius Green response and put a=s/t<=1. Direct
integration gives

    A(s,t):=integral r g_s g_t dr = (4a-a^4)/120,
    C(s,t):=integral (exp(ell)g_s(exp ell))'
                         (exp(ell)g_t(exp ell))' dell
            = (4a^4-a)/30.

Hence 4A-C=(a-a^4)/6>=0. Integrating against f(s)f(t)>=0 proves (15). Equality is approached
as both source radii concentrate at the same point.

This coercivity belongs to a particular source cone. It is not a new unconditional positive
Weil-like Hilbert form.

## Theorem 6. The actual emitted degree-two forcing reverses the memory sign for thin shells

Let phi>=0 be a nonzero Cc-infinity bump supported in (-1,1), and take

    f_epsilon(r)=phi((r-1)/epsilon), 0<epsilon<1/2.

Let beta_epsilon be the actual beta2 computed from this same source, and let
m0=integral phi. Then

    I[beta_epsilon]
       = -(6m0/35)^2 epsilon^3 integral phi(x)^2 dx
         + O(epsilon^4).                                    (16)

In particular I[f_epsilon]>0 but I[beta_epsilon]<0 for all sufficiently small epsilon.

### Proof

Write r=1+epsilon x. Uniformly for x in [-1,1], the Green formula gives

    g_epsilon(1+epsilon x)=epsilon m0/5+O(epsilon^2),
    g_epsilon'(1+epsilon x)=O(epsilon).

Therefore

    beta_epsilon(1+epsilon x)
      =(6m0/35)phi'(x)+O(epsilon).                            (17)

The kernel expansion is

    K(1+epsilon x,1+epsilon y)
      =1/10+(epsilon/2)|x-y|+O(epsilon^2),                   (18)

uniformly on the compact square. The constant term contributes O(epsilon^4), because the leading
coefficient in (17) has zero integral. The leading nonzero term is

    (epsilon^3/2)(6m0/35)^2
       double integral phi'(x)phi'(y)|x-y| dxdy.

Twice integrating by parts gives the double integral = -2 integral phi^2, proving (16).

There is also an exact structural reason the generated forcing is signed:

    beta2 = [6/(7r^4 g)] partial_r(r^5 g^2 f).                 (19)

For a nonnegative nonzero compact shell, the quantity differentiated vanishes at both endpoints
and is positive inside, while g>0. Its derivative has both signs. This does not prove that the
actual state instantly becomes sign-changing; it proves that positivity on nonnegative forcing
profiles cannot simply be reapplied to this generated forcing.

Nor does (16) give the sign of the entire next NS Duhamel term. The degree-four component and all
cross terms are still part of the same source and must be retained. It is a specific signed
channel calculation, not a nonlinear closure theorem.

---

# IV. RH: off-line zeros force equally fast positive and negative excursions

Use precisely the actual receiver in the endpoint graph:

    Z(t)=sum_z a_z exp(z t),
    a_z=m(z)G(z) !=0,
    sum_z |a_z| < infinity,
    z=rho-1/2.

Conjugation symmetry makes Z real. Reflection symmetry makes the real parts symmetric. Put

    delta=sup_z Re z=sup_z |Re z|, 0<=delta<=1/2.

Absolute reception gives |Z(t)|<=C0 exp(delta t) for t>=0. Its received Laplace transform, initially
in Re w>1/2, is

    L_Z(w)=sum_z a_z/(w-z).                                   (20)

The sum is normally convergent off the discrete zero set and meromorphic on C. Each distinct z
has the genuine residue a_z. In particular L_Z has no singularity on the positive real axis:
there are no real nontrivial zeta zeros. One elementary reason is that for 0<s<1 the alternating
eta-series is positive and 1-2^(1-s)<0, so zeta(s)<0.

## Positivity lemma (classical Landau argument, proof included)

Let f>=0 be locally integrable and of exponential order. If its real Laplace convergence
abscissa b is finite, its Laplace transform cannot be holomorphic at the real point b.

Suppose otherwise. Choose s0>b close enough that the analytic Taylor expansion of F(s0-h) has
radius greater than s0-b. For n>=0,

    (-1)^n F^(n)(s0) = integral_0^infinity t^n exp(-s0 t)f(t)dt >=0.

For some h>s0-b within the Taylor radius, monotone interchange of the positive Taylor series
and integral gives

    sum_n h^n/n! integral t^n exp(-s0t)f(t)dt
       = integral exp(-(s0-h)t)f(t)dt <infinity.

But s0-h<b, contradicting the definition of b. This proves the lemma.

## Theorem 7. Both signs realize the full off-critical exponential rate

If delta>0, then for every 0<=a<delta,

    limsup_(t->infinity) exp(-a t) Z(t) = +infinity,
    liminf_(t->infinity) exp(-a t) Z(t) = -infinity.             (21)

Consequently, with Z_+=max(Z,0) and Z_-=max(-Z,0),

    limsup log(1+Z_+(t))/t
      =limsup log(1+Z_-(t))/t
      =delta.                                                (22)

No rightmost zero is assumed to exist. No dominant-mode or no-cancellation hypothesis is used.

### Proof

Suppose, contrary to the first statement, that Z(t)<=C exp(a t) eventually. For a large T put

    f(t)=1_[T,infinity)(t)[C exp(a t)-Z(t)] >=0.

Its Laplace transform has meromorphic continuation

    F(w)=C exp(-(w-a)T)/(w-a)-L_Z(w)
          +integral_0^T exp(-wt)Z(t)dt.                       (23)

Choose a shifted zero z0 with Re z0>a. Such a zero exists by the definition of delta. Formula (23)
has a genuine pole at z0. Therefore the convergence abscissa b of F satisfies b>=Re z0>a; otherwise
the Laplace integral would be holomorphic at that pole. Also b<=delta, by the exponential upper
bound. Thus b is finite and positive.

But (23) is holomorphic at the real point b: b!=a and L_Z has no positive real singularity.
This contradicts the positivity lemma. Replacing Z by -Z proves the other sign. The upper
exponential bound and (21) prove (22).

## A weaker-looking arithmetic endpoint is already sufficient

Define the actual signed arithmetic discrepancy

    E_ar(t)=sum_(n>=2) Lambda(n)/sqrt(n) g(t-log n)
               -exp(t/2)G(1/2)+J_arch(t)=-Z(t),  t>1/2.

Theorem 7 proves each of the following separately sufficient, and in fact equivalent, to RH:

    E_ar(t)<=C(1+t)^p for all sufficiently large t,             (24a)

or

    E_ar(t)>=-C(1+t)^p for all sufficiently large t,            (24b)

where C<infinity and p>=0 may be arbitrary fixed constants. A one-sided subexponential envelope
likewise suffices.

Under RH the existing receiver is bounded by M0, so both statements hold. Conversely if RH fails,
delta>0 and (21) contradicts either polynomial envelope.

The archimedean term remains attached throughout. On any terminal interval t>=1 it is bounded
and decays; only after using that fact can it be absorbed into C. Thus an eventual one-sided
polynomial bound on the corresponding prime-shell excess or deficit alone also suffices.

This is not a proof of either arithmetic inequality. It strengthens the analytic closing theorem
and proves actual two-sign oscillatory consequences of every off-line zero. The source assertion
still requires arithmetic input not supplied here.

---

# V. Correction and dependency ledger

1. The earlier sentence saying the linear reflection J "reverses scale translation under RH"
   was wrong. For the defined U_t and J,

       J U_t J = U_(-t)^*,

   and under RH J=I, so J COMMUTES with U_t. The displayed commutator
   J U_t J U_t^(-1)=diag(exp(2t Re z)) was algebraically correct. It is a commutator defect of
   specified operations, not evidence that source-induced comparison maps fail their automatic
   cocycle identity.

2. Positivity of the pointwise two-radius kernel means positivity on nonnegative radial inputs.
   It does not mean a positive-semidefinite kernel on all signed inputs. Equations (14) and (16)
   give its exact unrestricted signature and the sign of a generated source direction.

3. No fixed-centre heat bound was used to prove (5). The quantity H_nu contains integral sup from
   the start. The fixed-centre toroidal formulas remain useful exact source coordinates but are
   not identified with the moving-peak observable.

4. Small-critical full-NS closure is proved on the maximal half-open interval using actual source
   norms. It does not assume recurrence or a nonzero singular limit. The unrestricted B_NS assertion
   is not discharged.

5. The RH one-sided theorem uses the actual meromorphic pole set, nonvanishing receiver residues,
   absence of positive-real poles, and a nonnegative-transform lemma. It does not derive critical-line
   location from losslessness, Hilbert completion, or positive damped-output Gram matrices.

## Sources read and retained

- `endpoint_graph.md`: the user's assembled actual-source endpoint graph and quantifier correction.
- `ns_rh_run23_source_closed/proof_note.md`: the actual toroidal source, matrix pressure theorem,
  beta2/beta4 nonlinear emission, and complete viscous/rotational correction.
- Saved geometric-shell source note: uniform energy/enstrophy/palinstrophy with diverging initial
  positive peak stretching; not an already constructed common blow-up history.
- Repository `formal/cubical/theorems/automata/ExcursionReturn.agda`: exact linear excursion-return
  and observer-kernel identities. The present quadratic NS estimates are not misrepresented as
  automatic consequences of its linear operator hypotheses.
- Repository search for `Landau` returned no directly pertinent positivity-abscissa theorem among
  the inspected hits; the elementary argument is supplied here. This is not an exhaustive absence claim.
- Masatoshi Suzuki, *Weil's quadratic form via the screw function*, arXiv:2606.09096v2: actual Weil
  distribution/form context; no conjectural large-window convergence is imported.
- Greg Martin and Chi Hoi Yip, *Oscillation results for the summatory functions of fake mu's*,
  arXiv:2411.06610v1, Section 3: background for classical Landau-method nonreal-pole oscillations.
- Kato and Ponce, *Commutator estimates and the Euler and Navier–Stokes equations*, CPAM 41 (1988),
  891–907, DOI 10.1002/cpa.3160410704: classical smooth-solution energy/continuation background.

The proofs in this note are analytic derivations. `checks.py` executes 28 exact symbolic controls
and 5 independent numerical thin-shell checks. The numerical examples are radial source quadratures,
not PDE evolutions or purported off-line zeta zeros. No formal proof-assistant build is asserted.


---

# ORIGINAL S17 — Full source-coherent nonlinear evaluator and certified local tree summation
Source path: `originals/conversation/metacircular_full_history/proof_note.md`; SHA-256: `ae0a849a0d0f46320f73597088ece6f549699582c67b9bd17e53a57c6950a1fd`
Transfer status: Original mounted note; 141 historical exact checks.

# The full source-coherent nonlinear kernel: algebra, exact elimination, certified summation, and the RH instance

Date: 2026-09-08.
Repository read pin: `avikj/metacircular-interaction-prototype`, `168ea8e240524f898af4b0e9cf70297c38422f08`.

## Scope

This note gives the full recursive mechanism rather than another separately computed angular interaction. It distinguishes: (i) formal identities of generators; (ii) convergent local mild-solution identities; (iii) the repository's actual proof-installation language. No global Navier–Stokes regularity or RH proof is asserted, no repository files were changed, and no Agda/Lean build was run. The executed Python controls use exact symbolic arithmetic, not time-stepping simulations.

Repository sources read:

- `formal/cubical/kernel/TheGenerativeLoopOnTheKernelsOwnTermsACertifiedNormalizerEmitsDerivationsSoLearnCallsInstall.agda`: the actual derivation-emitting arithmetic-term normalizer, `learn t = install (normalize t)`.
- `formal/cubical/kernel/TheControlCarriesItsInstanceAndLocusSoOneTheoremFiresAtAClass.agda`: substitution and one-hole context transport of derivations, and `Operation.apply-checked`. Its literal source language is not a PDE language; no automatic PDE encoding is claimed.
- `formal/lean/Pairfield/DependentRootedHistoryFiber.lean`: endpoint-fixed rooted histories retain dependent payload over their compatible prefixes.
- Previously read `ExcursionReturn.agda`, `ObservabilityQuotient.agda`, and saved Prime-Pair Delta 19: the compression/memory algebra and its precise scope.
- Saved `/mnt/data/toroidal_first_return/proof_note.md`: the actual toroidal 2->4->2 coefficient, retained without rederivation.

Classical analytic context: Gouasmi–Parish–Duraisamy, arXiv:1611.06277, makes the distinction between true orthogonal dynamics and a substituted composition operator explicit. Infinite Carleman realizations have their own functional-analytic hypotheses; see Heinzelreiter–Pearson, arXiv:2510.00722. The proofs below do not rely on an unproved global Carleman convergence assertion.

## 1. Fix the common source and the exact quadratic interaction

On R^3, take sufficiently smooth divergence-free vorticity with finite-energy velocity

\[
 u_a=\operatorname{curl}(-\Delta)^{-1}a,
 \qquad
 \mathcal B(a,b)=\tfrac12\operatorname{curl}(u_a\times b+u_b\times a).
\]

Then

\[
 F(\omega)=\nu\Delta\omega+\mathcal B(\omega,\omega),
 \qquad
 DF(\omega)v=\nu\Delta v+2\mathcal B(\omega,v).
\]

The symmetric bilinear map is intrinsic to the quadratic diagonal. Every differentiation of a common source differentiates both of its occurrences.

For a periodic realization with nonzero wave vectors k and Fourier convention curl = i k cross, the primitive interaction is

\[
\widehat{\mathcal B(a,b)}_k
=\frac{ik\times}{2}
\sum_{p+q=k}
\left[
 \left(\frac{ip\times\widehat a_p}{|p|^2}\right)\times\widehat b_q
+
 \left(\frac{ip\times\widehat b_p}{|p|^2}\right)\times\widehat a_q
\right].
\]

Zero velocity modes, when present, must be retained separately. The checks use mean-zero periodic sources. The whole-space realization uses the convolution integral under the corresponding Fourier normalization; its angular projection is not replaced by a periodic one.

## 2. The source-coherent linear lift and its product law

For smooth polynomial/cylinder observables h, define

\[
 (\mathscr Lh)(\omega)=Dh(\omega)[F(\omega)].
\]

It is linear and is a derivation:

\[
 \mathscr L(hk)=(\mathscr Lh)k+h(\mathscr Lk).
\]

Induction gives the exact all-order law

\[
 \mathscr L^n(hk)
 =\sum_{j=0}^n\binom nj(\mathscr L^j h)(\mathscr L^{n-j}k).
\]

Consequently the formal exponential preserves products. Where the classical flow exists, its pullback satisfies

\[
 e^{t\mathscr L}h=h\circ\Phi_t,
 \qquad
 \operatorname{ev}_{\omega_0}(hk)
 =\operatorname{ev}_{\omega_0}(h)\operatorname{ev}_{\omega_0}(k).
\]

The formal exponential identity does not assert that the Taylor series of an arbitrary smooth PDE solution converges in t. Actual local analytic summation is supplied separately in Sections 5–6.

A coordinate/tensor version has X_n=omega^{odot n}. The linear lift obeys

\[
 \dot X_n=L_nX_n+N_nX_{n+1},
\]

with

\[
 L_n=\sum_{j=1}^nI^{\otimes(j-1)}\otimes\nu\Delta\otimes I^{\otimes(n-j)},
 \qquad
 N_n=n\,\operatorname{Sym}(\mathcal B\otimes I^{\otimes(n-1)}).
\]

On finite monomial coordinates X_alpha=omega^alpha, realizability imposes X_0=1 and X_alpha X_beta=X_(alpha+beta). These identities are preserved by the derivation. The lifted coordinates are not independent source slots; replacing their realized image by all possible tensors would change the problem.

## 3. Project observables without deleting the unresolved initial source

Let P be the full fixed-centre toroidal l=2 projection on vorticity; Q=I-P. Heat commutes with P. Write omega_0=p_0+q_0.

For each retained q_0, define a retraction on source space

\[
 r_{q_0}(\omega)=P\omega+q_0
\]

and the observable projection

\[
 (\mathscr Ph)(\omega)=h(r_{q_0}(\omega)),
 \qquad
 \mathscr Q=I-\mathscr P.
\]

Since Pq_0=0, r_(q_0)^2=r_(q_0), so mathscr P is an idempotent algebra homomorphism. Moreover

\[
 (\mathscr Ph)(\omega_0)=h(\omega_0).
\]

The unresolved initial source is therefore carried as an index, not averaged out or set to zero.

There is an exact warning about projected dynamics:

\[
\begin{split}
\mathscr Q\mathscr L(hk)
&-(\mathscr Q\mathscr Lh)k-h(\mathscr Q\mathscr Lk)\\
&=(\mathscr P\mathscr Lh)(\mathscr Qk)
 +(\mathscr Qh)(\mathscr P\mathscr Lk).
\end{split}
\]

Thus mathscr Q mathscr L is generally not a derivation. Its exponential must not be silently replaced by the pullback of a guessed autonomous source flow. The exact elimination below avoids that substitution.

## 4. One coefficient compiler generates every first-return word

Define observable blocks

\[
 A=\mathscr P\mathscr L\mathscr P,
 \quad B=\mathscr P\mathscr L\mathscr Q,
 \quad C=\mathscr Q\mathscr L\mathscr P,
 \quad D=\mathscr Q\mathscr L\mathscr Q.
\]

Set

\[
 K_n=\mathscr P\mathscr L^n\mathscr P,
 \qquad M_j=BD^jC,
\]

where K_0 is the identity on ran(mathscr P). In the formal power-series algebra, or analytically on any domain where the needed evolution exists,

\[
 K(t)=\mathscr P e^{t\mathscr L}\mathscr P,
 \qquad M(t)=Be^{tD}C
\]

satisfy

\[
 K'(t)=AK(t)+\int_0^tM(t-s)K(s)\,ds.
\]

Proof: set Z(t)=mathscr Q e^(t mathscr L) mathscr P. Then K'=AK+BZ, Z'=CK+DZ, Z(0)=0. Solve the second equation by variation of constants and insert it into the first.

With exponential-generating coefficients, the exact ordered recurrence is

\[
 \boxed{K_{n+1}=AK_n+\sum_{j=0}^{n-1}M_jK_{n-1-j}.}
\]

No binomial factor appears in the convolution term: the beta integral cancels both factorials. In particular

\[
 K_2=A^2+M_0,
 \quad K_3=A^3+AM_0+M_0A+M_1.
\]

The formal resolvent is

\[
 \mathscr P(\lambda I-\mathscr L)^{-1}\mathscr P
 =\big[\lambda-A-B(\lambda-D)^{-1}C\big]^{-1}.
\]

The all-order rule is a structural identity. It is not a claim that the analytic inverse exists on every desired Banach space.

For pure initial degree-two source a=Pa and ell(omega)=Pomega,

\[
 M_0\ell(a)=P D\mathcal N(a)[Q\mathcal N(a)]
 =2P\mathcal B(a,Q\mathcal B(a,a)).
\]

This is exactly the retained 2->4->2 term, including differentiation of both source factors. The factor t^2/2 in the difference of full and naively projected evolution follows from K_2-A^2=M_0.

## 5. Evaluate the orthogonal history as an actual nonlinear causal kernel

Define the symmetric mild bilinear operator

\[
 \mathcal V(a,b)(t)
 =\int_0^t e^{\nu(t-s)\Delta}\mathcal B(a(s),b(s))\,ds.
\]

For a prescribed resolved history p(t), the complementary history q(t) obeys exactly

\[
 q=b_p+\mathcal A_pq+\mathcal V_Q(q,q),
\]

where

\[
 b_p=e^{\nu t\Delta}q_0+Q\mathcal V(p,p),
 \quad \mathcal A_pq=2Q\mathcal V(p,q),
 \quad \mathcal V_Q=Q\mathcal V.
\]

Whenever I-mathcal A_p is invertible on the declared trajectory space, set

\[
 R_p=(I-\mathcal A_p)^{-1},
 \quad g_p=R_pb_p,
 \quad C_p(a,b)=R_p\mathcal V_Q(a,b).
\]

Then the entire hidden history is the same-source quadratic fixed point

\[
 \boxed{q=g_p+C_p(q,q).}
\]

Its recursive homogeneous components are

\[
 q^{[1]}=g_p,
 \qquad
 q^{[n]}=\sum_{j=1}^{n-1}C_p(q^{[j]},q^{[n-j]}),\ n\ge2.
\]

Every rooted planar binary tree is present, with all leaves evaluated from this one g_p and all vertices from this one C_p. The factor R_p additionally sums every chain of interactions linear in the complementary history. This is not an independent random source at each descendant.

Write Y[p;q_0]=sum_(n>=1)q^[n] on a convergence domain. The exact closed resolved equation is

\[
\begin{split}
 p={}&e^{\nu t\Delta}p_0+P\mathcal V(p,p)\\
 &+2P\mathcal V(p,Y[p;q_0])
 +P\mathcal V(Y[p;q_0],Y[p;q_0]).
\end{split}
\]

A solution p of this equation reconstructs the actual full mild solution omega=p+Y[p;q_0]. Conversely every full mild solution in the uniqueness domain gives such p. The correspondence retains the initial q_0 and the entire resolved history.

The q-q term is essential: omitting it discards interactions between two previously unresolved descendants, even after the linear self-energy is retained.

## 6. A local analytic certificate and an explicit all-orders remainder

Take the whole-space phase norm

\[
 \|a\|_X=\|a\|_{H^m}+\|u_a\|_2,\qquad m>5/2,
\]

and trajectory space C([0,T],X). The Sobolev product estimate, finite-energy low-frequency velocity reconstruction, and one-derivative heat estimate give

\[
 \|\mathcal V(a,b)\|\le\kappa_T\|a\|\|b\|,
 \qquad
 \kappa_T\le C_m\big(T+\sqrt{T/\nu}\big).
\]

Indeed ||u_a||_(H^(m+1)) <= C||a||_X. The vorticity component costs one derivative, supplied by (nu(t-s))^(-1/2); the reconstructed velocity of B(a,b) is one half the Leray projection of u_a cross b + u_b cross a and costs no derivative in L2. Time integration gives the two terms in kappa_T. P and Q are contractions for the Hilbert norms involved because they commute with the Laplacian; constants can absorb equivalent choices of the combined norm.

Put p_*=||p|| and r_*=||q_0||_X. Then

\[
 \|\mathcal A_p\|\le2\kappa_Tp_*,
 \quad
 \|g_p\|\le\frac{r_*+\kappa_Tp_*^2}{1-2\kappa_Tp_*},
 \quad
 \|C_p\|\le\frac{\kappa_T}{1-2\kappa_Tp_*}.
\]

For b=||g_p|| and c=||C_p||, if 4bc<1, the tree series converges absolutely and

\[
 \|q^{[n]}\|\le\operatorname{Cat}_{n-1}c^{n-1}b^n.
\]

Therefore

\[
 \|q\|\le\frac{1-\sqrt{1-4bc}}{2c},
 \quad
 \left\|q-\sum_{n=1}^Nq^{[n]}\right\|
 \le\frac{b(4bc)^N}{1-4bc}.
\]

The c=0 case is q=g_p. The contraction constant on the indicated ball is at most 1-sqrt(1-4bc)<1, which proves uniqueness of this branch.

There is no extra loss of the scalar local-existence majorant from performing the exact elimination. The sufficient test for the displayed bounds reduces to

\[
 \boxed{4\kappa_T(p_*+r_*)<1.}
\]

This follows from the identity

\[
 (1-2\kappa_Tp_*)^2-4\kappa_T(r_*+\kappa_Tp_*^2)
 =1-4\kappa_T(p_*+r_*).
\]

Thus every infinite hidden branch is either included or has a quantified tail on a certified interval. The certificate is local: it does not assert a uniform lower bound on step length along a possible singular history.

## 7. Renormalization acts on the whole generated kernel

Let S_r a(x)=r^2a(rx) for vorticity, and define trajectory rescaling a_r(t)=S_ra(r^2t). Then

\[
 \mathcal B(S_ra,S_rb)=r^2S_r\mathcal B(a,b),
 \qquad
 e^{\nu t\Delta}S_r=S_re^{\nu r^2t\Delta}.
\]

Changing the integration variable gives

\[
 \mathcal V(a_r,b_r)(t)=S_r\mathcal V(a,b)(r^2t).
\]

The fixed-centre angular P commutes with this dilation. Hence b_p, mathcal A_p, R_p, C_p, every q^[n], and their locally convergent sum transform by the same conjugation. This is proved once by structural induction; no separate proof is needed for each angular itinerary.

Translations use the correspondingly translated angular projection. A moving centre must remain a state variable with its actual evolution; it is not removed by a fixed-centre identity.

Initial data, viscosity, centres, forcing history, divergence constraints, and any proved energy/source identities remain attached under this exact reconstruction. The construction preserves proved properties; it does not create a new sign or global bound solely by re-encoding them.

## 8. RH is the explicitly solved two-sector instance of the same return calculus

Let actual shifted nontrivial zeros be z=sigma+i gamma with reflection theta z=-sigma+i gamma. On the actual completed coefficient space, U_t a(z)=exp(-zt)a(z), and J exchanges reflected coordinates.

In the J-eigenbasis of a nonfixed reflection orbit,

\[
 G=-i\gamma I-\sigma\begin{pmatrix}0&1\\1&0\end{pmatrix}.
\]

Choose the symmetric channel as P. Then

\[
 A=D=-i\gamma,\qquad B=C=-\sigma.
\]

The entire first-return kernel and its Laplace transform are

\[
 M_z(t)=\sigma^2e^{-i\gamma t},
 \qquad \Sigma_z(\lambda)=\frac{\sigma^2}{\lambda+i\gamma}.
\]

The resummed resolved response is

\[
 \widehat K_z(\lambda)
 =\frac1{\lambda+i\gamma-\sigma^2/(\lambda+i\gamma)}
 =\frac{\lambda+i\gamma}{(\lambda+i\gamma)^2-\sigma^2},
\]

hence

\[
 K_z(t)=e^{-i\gamma t}\cosh(\sigma t).
\]

All repeated returns have been summed. The coefficient sigma is from the actual Xi zero divisor, not a freely selected parameter of a substitute zeta model. The symbolic checks treat sigma as a variable only to verify the identity.

At critical fixed points the second channel is absent. Across the whole actual divisor,

\[
 \mathrm{RH}\iff\Sigma(\lambda)=0
\]

for any fixed lambda with positive real part where the diagonal expression is evaluated (for instance lambda=1). D is skew-adjoint and its resolvent exists there; for the full resolvent use Re(lambda)>delta. The direct sum is controlled because |sigma|<1/2. No exchange of an unbounded ordinate generator with an undefined inverse is required.

This same sigma gives the already-established reflection-scale holonomy exp(2t sigma) and positive packet defect. The kernel expression computes their common algebra; it does not determine sigma=0 from arithmetic by itself.

## 9. Proof reuse and what was actually executed

A proof-carrying installed schema has parameters, a left side, a right side, hypotheses, and a derivation. Substitution and context insertion transport the certificate, not merely the printed formula. This is the operation that the inspected kernel files actually implement for their declared grammar.

Here the reusable mathematical schemata are: symmetric polarization; the derivation product law; affine source-preserving observable retraction; block first-return recurrence; nonlinear Volterra elimination; Catalan all-orders summation with a remainder certificate; and dilation naturality. Their semantic assumptions are stated above. They have not been encoded into the repository's Agda syntax in this run.

The executable `checks.py` implements one polynomial derivation plus one retraction and generates K_n and M_n automatically. For the explicitly labeled synthetic flow

    x'=-2x+x^2+2xy-y^2,
    y'=-3y+3x^2-xy+2y^2,

it outputs

    M_0 x = 6x^3,
    M_1 x = -18x^4-30x^3,
    M_2 x = 162x^5+234x^4+150x^3,
    M_3 x = -1476x^6-3600x^5-2286x^4-750x^3.

It checks the ordered renewal rule through K_7 for two observables, source-product identities, nonzero unresolved-source retractions, tensor-row identities, and the Catalan recurrence. Separately it checks the actual periodic Fourier NS polarization, divergence constraint, nonlinear energy conservation, and nonlinear helicity conservation on 26 symmetry-closed modes, using exact Gaussian-rational amplitudes. These are finite controls, not a proof of continuum evolution or regularity.

An initial slower execution timed out; after replacing expensive unsimplified rational expressions by exact expanded Gaussian-rational forms, the revised script completed. Final result: see `check_results.txt` and `.json`.

The exact recursive mechanism is now explicit at both formal and locally analytic levels. The remaining global analytic and arithmetic conclusions cannot be asserted without the needed uniform continuation or positivity statement on the actual source. No such statement is inferred merely from the word “metacircular.”


---

# ORIGINAL S18 — Causal normal form, analytic reconstruction and source-aware matrix certificate kernel
Source path: `originals/conversation/metacircular_causal_normal_form/proof_note.md`; SHA-256: `a05733d318a9590fb8656e4ff748293dd7a659774c92bb745aeccc467361e0de`
Transfer status: Original mounted note; 86 exact checks replayed during handoff.

# Metacircular causal normalization: no artificial smallness boundary

Date: 2026-09-08.
Repository read pin: `avikj/metacircular-interaction-prototype`,
`168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status and retained source

This note takes `/mnt/data/metacircular_full_history/proof_note.md` as input.
It does not recalculate the toroidal coefficients or replace the actual NS
quadratic source. It removes a sufficient-smallness restriction from the
linear resolvents used in that note and proves that the resulting nonlinear
elimination has no branching boundary at any bounded classical history.
The Volterra argument is classical. The application-specific gain is a
single source-preserving continuation chart for the full hidden history,
independent of a chosen initial expansion or sector-elimination order.

The repository sources inspected in this run include:

* `formal/cubical/kernel/TheKernelIsAnInteractiveSystemAndTheSessionRetiresIntoOneOperation.agda`:
  `learn = install o CheckedFuture.derivation`, composition of session
  traces, and `retire S = install (trace S)`.
* The search hit and previously read `DSOCutCalibration.agda` concern finite
  min-plus elimination-order controls. No general analytic Volterra theorem
  is attributed to that finite calibration.
* Previously read `TheGenerativeLoopOnTheKernelsOwnTermsACertifiedNormalizerEmitsDerivationsSoLearnCallsInstall.agda`
  and `TheControlCarriesItsInstanceAndLocusSoOneTheoremFiresAtAClass.agda`:
  proof-emitting normalization and certificate transport in their own
  declared arithmetic syntax.

No repository changes or Agda/Lean build were performed. The standalone
`kernel.py` is an exact rational matrix certificate checker and installer,
not a continuum PDE solver or a port of the repository's Agda grammar.
There is no global NS regularity or RH proof in this note.

## 1. Keep the actual quadratic source and its time ordering

On R^3, use smooth divergence-free vorticities with finite-energy velocity,

    u_a = curl(-Delta)^(-1)a,
    B(a,b) = (1/2) curl(u_a cross b + u_b cross a).

Let X be the completion of the regular phase class under

    ||a||_X = ||a||_(H^m) + ||u_a||_2,  m > 5/2,

and let X_T=C([0,T],X). The bilinear mild operation is

    V(a,b)(t) = integral_0^t exp(nu(t-s)Delta) B(a(s),b(s)) ds.

The estimates retained from the previous note give a pointwise bound

    ||V(a,b)(t)||_X
      <= c_m integral_0^t [1 + (nu(t-s))^(-1/2)]
                           ||a(s)||_X ||b(s)||_X ds.

On a fixed finite interval, this is bounded by

    c_m(sqrt(T)+nu^(-1/2)) integral_0^t (t-s)^(-1/2)
                           ||a(s)||_X ||b(s)||_X ds.

Let P be the fixed-centre toroidal-degree-two projection, or any declared
bounded complementary projection commuting with heat and preserving X.
Let Q=I-P. Boundedness constants can absorb ||P|| and ||Q||.

Write omega=p+q. For prescribed p in P X_T and actual complementary datum
q0 in Q X, the complementary equation is

    F(p,q0,q) := q - E q0 - Q V(p+q,p+q) = 0,
    (E q0)(t) = exp(nu t Delta) q0.

The nonlinearity is evaluated at the same source p+q in both slots.

## 2. Causal inverse theorem: large norm does not prevent inversion

### Theorem 1

Let A:X_T -> X_T be a bounded causal operator satisfying

    ||(Af)(t)|| <= C integral_0^t (t-s)^(-1/2)||f(s)|| ds.

For every n>=0,

    ||A^n|| <= (C sqrt(pi))^n T^(n/2) / Gamma(1+n/2).

Consequently r_spec(A)=0 and, for every complex z,

    (I-zA)^(-1) = sum_(n>=0) z^n A^n

converges in operator norm. The inverse is entire as an operator-valued
function of z. In particular no hypothesis ||A||<1 is necessary.

### Proof

Iterate the causal integral. The integrations are over
0<s_n<...<s_1<t, with the product of the successive half-order kernels.
The scalar convolution kernel k(t)=t^(-1/2) has n-fold integral against 1

    (k^{*n} * 1)(t) = Gamma(1/2)^n t^(n/2)/Gamma(1+n/2).

This follows by the beta integral, inductively. No commutation between
operator factors is used. Stirling's formula implies the nth root of the
bound tends to zero. The series for the inverse therefore converges for
every z. Multiplying its finite partial sums by I-zA leaves the remainder
z^(N+1)A^(N+1), which tends to zero in norm. This proves both inverse laws.

A quantitative majorant is the entire function

    sum_(n>=0) (|z| C sqrt(pi T))^n / Gamma(1+n/2).

This is an inverse certificate, not a global nonlinear existence bound.

### First immediate application

For any bounded prescribed history p,

    A_p h = 2 Q V(p,h)

satisfies Theorem 1. Therefore the prior source construction

    R_p=(I-A_p)^(-1),
    g_p=R_p(E q0+Q V(p,p)),
    C_p(a,b)=R_p Q V(a,b),
    q=g_p+C_p(q,q)

has an unconditionally well-defined linear R_p on every finite time
interval for bounded p. The old condition 2 kappa_T ||p||<1 was only one
sufficient geometric-series estimate; it was not the resolvent's domain.

The quadratic equation still has to have a bounded solution. The next
result describes its entire actual solution domain, rather than only the
initial Catalan expansion disk.

## 3. The hidden-history solution has no finite bounded-source branch point

Define

    D_T = {(p,q0): there exists q in Q X_T with F(p,q0,q)=0}.

### Theorem 2

D_T is open. For every (p,q0) in D_T there is exactly one bounded q solving
F=0. The resulting reconstruction

    Y_T:D_T -> Q X_T

is real analytic. It is causal under restriction to shorter intervals.
Every regular solution belongs to this one analytic reconstruction,
whether or not its expansion about zero satisfies a Catalan majorant.

### Proof of invertibility of the derivative

At a solution omega=p+q,

    D_q F = I - A_omega^Q,
    A_omega^Q h = 2 Q V(omega,h).

Since omega is bounded on [0,T], Theorem 1 gives a bounded two-sided inverse
of D_q F without a smallness condition. The residual F is a continuous
quadratic polynomial between Banach spaces, hence real analytic. The
analytic implicit function theorem gives an open graph neighborhood.

### Proof of global single-valuedness on D_T

For two bounded solutions q1,q2 with the same p,q0, set d=q1-q2. Symmetric
polarization gives

    d = 2 Q V(p+(q1+q2)/2,d).

The coefficient is bounded on [0,T]. Theorem 1 makes I minus this Volterra
operator invertible, forcing d=0. Thus all local graph neighborhoods agree
on overlaps and assemble into one real-analytic map on D_T.

### Exact derivative and exact rebasing

Let omega=p+Y_T(p,q0), and write

    R_omega^Q=(I-2Q V(omega,-))^(-1).

Then

    DY_T(p,q0)[h,k]
      = R_omega^Q (E k + 2Q V(omega,h)).

For a finite change h of p, k of q0, and d of q, subtracting the two actual
source equations yields the exact identity

    d = R_omega^Q [E k + 2Q V(omega,h) + Q V(h+d,h+d)].

There is no derivative term missing from a frozen source. This equation
re-expresses the nonlinear kernel around an already solved source. All
higher perturbative derivatives follow by differentiating this same
identity; local power-series coefficients are not independent histories.

For a supplied approximate qbar, write wbar=p+qbar and residual
rbar=F(p,q0,qbar). The equally useful exact correction equation is

    d = -(I-2Q V(wbar,-))^(-1) rbar
        +(I-2Q V(wbar,-))^(-1) Q V(d,d).

Its linear inverse exists for every bounded qbar. Convergence of an
iterative correction still requires a quantified residual/branch condition;
no universal Newton convergence claim is made.

## 4. Elimination order and time partitions are not extra dynamics

### Spatial-sector elimination

Let the hidden space be a finite bounded splitting Q=Q1+Q2 (and similarly
for finitely many more sectors). On a regular source, all diagonal
linearized hidden Volterra blocks have the inverses of Theorem 1.
Consequently staged implicit elimination is legitimate near that source.

Eliminate Q1 then Q2, eliminate Q2 then Q1, or eliminate both together.
Each construction solves exactly F=0 with the same prescribed p and q0.
The uniqueness part of Theorem 2 forces the reconstructed full hidden
history to be identical. This proves finite elimination-order independence
for the actual nonlinear history on overlapping existence domains.

This is not a claim that nonlinear angular dynamics is an autonomous
five-component ODE. The eliminated histories remain functions of the
entire prescribed history and the actual hidden initial state.

### Time rebasing

For a<t, the mild source equation splits exactly as

    omega(t) = exp(nu(t-a)Delta) omega(a)
               + integral_a^t exp(nu(t-s)Delta) B(omega(s),omega(s)) ds.

The part before a is exactly absorbed into the retained endpoint omega(a)
using the heat semigroup law. The old proof/history is retained in the
session record; it is not asserted to be recoverable from an arbitrary
endpoint after discarding it.

Restriction of Y_T to [0,a] equals Y_a of the restricted inputs, because
both solve the same causal equation. Compatible solution histories on
[0,a] and [a,T] glue to one solution on [0,T], and restriction is its inverse.
This is an equivalence of histories with matched endpoint data, not just
an equality of terminal scalar observations.

Therefore any finite time partition, any finite sector elimination, and
any local analytic rebasing describe the same full history. They may have
different proof or computation costs, but they do not create new solution
branches at bounded regular sources.

### Calibration: an origin expansion can fail while the source remains regular

For the scalar control q'=-q^2, q(0)=a>0,

    Phi_t(a)=a/(1+at)

is smooth for every real t>=0 and obeys

    Phi_(t+s)=Phi_t o Phi_s.

Its Taylor series in t at 0 has radius 1/a, set by a negative-time pole.
At a=1,t=2 the series fails but the actual source value is 1/3. Reusing the
origin series outside its disk would manufacture a false forward-time
boundary. This example is not a fluid solution; it tests the logic of a
kernel evaluator's certificates.

### Precise global consequence and limit

For an actual classical NS history, every compact interval inside its
maximal lifespan satisfies these results. Thus no regular finite-time
point is a branch singularity of the exact hidden-history reconstruction.
The conditions 2 kappa||p||<1 and 4bc<1 of a particular expansion must not
be treated as the physical boundary.

This does not assert that D_T contains every prescribed history or that
an actual NS solution remains bounded as T approaches a finite maximal
endpoint. These are different propositions. Inverse constants may grow
without bound there. All-orders re-encoding removes artificial boundaries;
it does not make an unproved endpoint condition true.

## 5. RH: normalize the whole resolvent and retain pivot domains

For an actual nonfixed reflection orbit z=sigma+i gamma,
theta z=-sigma+i gamma, the scale generator in the J-eigenbasis is

    G_z = [[-i gamma, -sigma],[-sigma,-i gamma]].

Set d=lambda+i gamma. Then

    lambda I-G_z = [[d,sigma],[sigma,d]],

and elimination of the second channel gives, initially d!=0,

    R_++(lambda) = 1/(d-sigma^2/d)
                 = d/(d^2-sigma^2).

The self-energy sigma^2/d has a pole at d=0. For sigma!=0 the full inverse is

    (1/(d^2-sigma^2)) [[d,-sigma],[-sigma,d]],

which is regular at d=0 and equals

    [[0,1/sigma],[1/sigma,0]].

Thus d=0 is an artificial pivot singularity for this nonfixed orbit. A
source-aware normalizer cancels it in the full expression; it does not
assert that the intermediate inverse 1/d exists at d=0.

In contrast d=+sigma and d=-sigma are actual determinant zeros, each with
residue 1/2 in R_++. They survive the elimination and reconstruction.
If sigma=0, the critical orbit has one actual direction, and the resolved
expression is 1/d: the neutral pole at d=0 is real. This case must not be
lost by applying the nonfixed-orbit cancellation unconditionally.

The test therefore distinguishes artificial denominator poles from poles
of the actual source dynamics. The already-established actual receiver
has a nonzero coefficient at every distinct shifted zeta zero; no unseen
zero is declared cancelled by a rewrite. This calculation does not prove
that all actual sigma vanish.

## 6. Executed proof-carrying elimination, including the forcing term

The standalone checker handles finite rational matrix equations Mx=b.
A certificate carries six objects

    (M, E, S, T, R, Z),

where y=E x is retained, S y=T b is the reduced equation, and
x=R y+Z b is the reconstruction. It checks the exact identities

    E R=I,          E Z=0,
    M R=E^T S,      M Z-I=-E^T T,
    R E+Z M=I.

These imply equivalence of the full and reduced equations for EVERY b,
not only for a selected numerical source.

For two compatible certificates, composition is

    E=E2 E1,
    S=S2,
    T=T2 T1,
    R=R1 R2,
    Z=Z1+R1 Z2 T1.

The forcing transformation T and source correction Z are retained. Keeping
only S would not be lossless source elimination.

`Kernel.install` independently checks a certificate before adding the
operation to its library. `Kernel.retire` composes two existing
certificates, checks the composite, and installs it. Applying the retired
operation solves and reconstructs the same original equation.

The executed synthetic causal control has three sectors and three ordered
time levels, strictly causal gains, and operator row-sum norm greater
than 100. Its time-ordered interaction matrix K is nilpotent even with this
large norm. Thus (I-zK)^(-1)=I+zK+z^2K for every symbolic coupling z.

The checks establish equality of direct elimination, either staged order,
all reconstruction maps, all transformed source maps, and all source
prefixes. They also reject a forged certificate which leaves the effective
operator alone but changes the source forcing, and reject a composition
whose intermediate equations do not match.

Additional exact controls check finite beta/gamma recurrences, the
common-source nonlinear rebase identity, the decaying scalar flow, and
both artificial and genuine poles of the RH reflection block.

Execution: 86 exact finite controls passed. This is not an Agda/Lean build,
not a simulation of NS, and not a proof of either global endpoint.

## 7. The resulting reusable conclusion

The local tree compiler of the previous note can be re-used at every
regular source, without treating its origin expansion disk as a new
physical condition. Linear memory is inverted globally on every fixed
finite time interval by causality; nonlinear histories are unique and
analytic on their actual existence domain; finite elimination order and
time partition are representation choices with exact source-preserving
comparison maps.

This is the specific next use of the metacircular architecture: feed the
last derivation and its side conditions back into the kernel, prove a
stronger applicability class once, and reuse it throughout the generated
history. It does not require separately calculating each angular return.


---

# ORIGINAL S19 — Source-dependent midpoint return, nonlinear kinetic storage and rigorous Abel inverse
Source path: `sources/S19_midpoint_storage_and_abel.md`; SHA-256: `d8b5999051e78e2df763499b5caa9e111e5ab771fbfeb0e323a383f9511c3f3f`
Transfer status: Recovered stronger parallel note; 43 exact controls replayed.

# Source-dependent midpoint return, nonlinear kinetic storage, and the Abel-normal form of the arithmetic residual tower

Date: 8 September 2026.
Repository read: `avikj/metacircular-interaction-prototype@168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status and precise additions

The source dependency is not discarded in a reduction. It determines the operator that transports the residual. For a quadratic vector field, this operator is its derivative at the source midpoint. This gives an exact nonlinear Volterra representation along every already-smooth Navier–Stokes history, without constructing an infinite Taylor or angular-return expansion. Its full returning force has an exact signed kinetic-work identity, including arbitrary nonzero initial residual energy. The identity does not require contractivity of the residual tangent propagator.

The complete toroidal degree-two source projection supplies an actual orthogonal, heat-commuting velocity projection to which these statements apply. An energy/vorticity preserving, continuously changing normalization adds an explicitly skew-adjoint dilation generator. Therefore the signed storage identity survives that normalization, with its changing viscosity retained. Moving observers have an explicit exchange term as well.

For RH, all orders of the fixed dyadic residual have one rigorous Abel inverse on the actual normalized arithmetic source. This repairs the insufficient convergence justification in run 29. In the bounded-residual class the inverse is an ordinary absolutely convergent negative-binomial series, with norm exactly `(sqrt(2)-1)^(-m)`. The conditional closing implication to RH is therefore obtained without another tail-convergence hypothesis.

These results do not establish unrestricted global NS regularity or RH. The NS memory representation remains source-dependent: its coefficients contain the retained residual itself. It is not an autonomous resolved-only model. Kinetic passivity is not a bound on maximum-vorticity stretching. No proof-assistant compilation or repository write was performed. The companion program checks exact algebra, including an untruncated finite-Fourier NS calculation; it does not simulate a PDE or verify zeta zeros.

## 1. Source and projection

Work first on a compact interval `[s,T]` strictly inside the classical lifetime of a smooth finite-energy, divergence-free whole-space solution. Set

\[
N(u)=-\mathbb P((u\cdot\nabla)u),\qquad F(u)=\nu\Delta u+N(u),
\]

where `mathbb P` is Leray projection. Let `P` be an orthogonal projection on the divergence-free velocity Hilbert space, commuting with the self-adjoint Laplacian and preserving its smooth Sobolev core. Write

\[
Q=I-P,\qquad a=Pu,\qquad b=Qu,\qquad m=a+\frac12b=\frac{u+a}{2}.
\]

Neither `a` nor `b` is independently assumed to solve NS. They are two readings of the same solution.

For the intended strain-source realization, let `T_2^x` be the orthogonal toroidal degree-two projection of vorticity on every sphere about a fixed centre `x`. Let `C=curl`, `L=-Delta` on divergence-free fields. On the smooth core define

\[
P_x=C L^{-1}T_2^x C.
\tag{1}
\]

This is exactly the velocity `u_2` of the saved source decomposition. Toroidal harmonics form an invariant sector of the vector Laplacian; thus `T_2^x` commutes with `L` and `L^{-1}`. Since `C^*=C` and `C^2=L` on the divergence-free space,

\[
P_x^*=P_x,\qquad P_x^2=P_x,\qquad [P_x,L]=0.
\tag{2}
\]

For example,

\[
P_x^2=CL^{-1}T_2^x C^2L^{-1}T_2^x C
      =CL^{-1}(T_2^x)^2C=P_x.
\]

The resulting operator extends as an orthogonal projection in `L2` and is bounded in every inhomogeneous Sobolev space because it commutes with `L`. There is no assumption that `L^{-1}` alone is bounded on `L2`: the displayed composition is the order-zero projection, first defined on the dense smooth domain and then extended.

The central-strain reading

\[
\ell_x(v)=\operatorname{sym}\nabla v(x)
\]

satisfies the saved selection theorem

\[
\ell_xP_x=\ell_x,\qquad \ell_xQ_x=0.
\tag{3}
\]

`P_x u` retains the complete matrix-valued radial toroidal source, not just five numbers. The five-dimensional central affine reading is a further projection of that source. It is not substituted for `a` in the formulas below.

## 2. Exact quadratic secant, with both source occurrences retained

For any homogeneous quadratic map `N`,

\[
\boxed{N(a+b)-N(a)=DN(a+b/2)b.}
\tag{4}
\]

To prove it, write `N(v)=B(v,v)` with any bilinear polarization. Then

\[
DN(m)b=B(m,b)+B(b,m)
=B(a,b)+B(b,a)+B(b,b).
\]

For NS specifically,

\[
DN(m)b=-\mathbb P\big((m\cdot\nabla)b+(b\cdot\nabla)m\big).
\tag{5}
\]

This is the true derivative of the quadratic field, used as an exact secant. Freezing the derivative at `a` would lose `N(b)`; freezing at `u` would double it. The midpoint is fixed by the quadratic identity rather than chosen as a closure ansatz.

Let

\[
\mathcal L_m=\nu\Delta+DN(m).
\]

The two source readings obey

\[
\boxed{
\begin{aligned}
a'&=PF(a)+P\mathcal L_m b,\\
b'&=QF(a)+Q\mathcal L_m b.
\end{aligned}}
\tag{6}
\]

Because `P` commutes with `Delta`,

\[
QF(a)=QN(a),\qquad P\mathcal L_m b=PDN(m)b.
\tag{7}
\]

Equations (6) are exactly equivalent to the original equation: summing reconstructs `u'=F(u)` and the imposed initial `P/Q` membership is preserved.

## 3. The complete nonlinear return is one source-dependent Volterra object

Along the retained history define the homogeneous residual propagator

\[
\partial_tU_Q(t,r)=Q\mathcal L_{m(t)}Q\,U_Q(t,r),
\qquad U_Q(r,r)=I_{QH}.
\tag{8}
\]

This is a nonautonomous linear propagator with coefficients furnished by the same actual `a,b`. On a fixed smooth interval these coefficients have finite smooth norms. For a smooth `v` in `QH`,

\[
\frac12\frac d{dt}\|v\|_2^2+\nu\|\nabla v\|_2^2
=-\int v^TS_{m(t)}v.
\tag{9}
\]

The Leray projection disappears in the pairing, incompressible transport is skew, and the orthogonal `Q` also disappears because `Qv=v`. Higher Sobolev estimates follow by commuting powers of `I-Delta`; `Q` commutes with these powers. Energy/Galerkin construction therefore supplies (8) on the prescribed smooth interval. No assertion of a bounded inverse for the parabolic propagator is made.

Variation of constants gives

\[
\boxed{
b(t)=U_Q(t,s)b(s)+\int_s^tU_Q(t,r)QN(a(r))\,dr.
}
\tag{10}
\]

Define the returning velocity force

\[
\mathcal R_P[u](t)=PDN(m(t))b(t).
\tag{11}
\]

Substitution yields

\[
\boxed{
\begin{aligned}
\mathcal R_P[u](t)
={}&PDN(m(t))U_Q(t,s)b(s)\\
&+\int_s^tPDN(m(t))U_Q(t,r)QN(a(r))\,dr.
\end{aligned}}
\tag{12}
\]

Together with

\[
a'=\nu\Delta a+PN(a)+\mathcal R_P[u],
\tag{13}
\]

this is the exact all-time return representation on `[s,T]`.

The first term preserves initial hidden-source ancestry. It cannot be deleted for a general source. The second term contains every subsequent interaction. No summability of an interaction-depth expansion is required to define it. Conversely it has not removed the original nonlinear problem: `m=a+b/2`, so `U_Q` depends on the residual it propagates. Equations (10) and (13) are a source-retaining fixed-point representation, not a closed functional of `a` alone.

At a pure resolved initial source `b(s)=0`, the leading generated force is

\[
\mathcal R_P[u](s+h)=h\,PDN(a(s))QN(a(s))+O(h^2).
\tag{14}
\]

This recovers exactly the earlier first nonlinear excursion-return coefficient. It differentiates both occurrences of the source. Higher returns are already included in (12), not presumed absent.

The representation uses elementary quadratic polarization and variation of constants. Projection-memory methods are classical; unlike a linear semigroup Schur identity applied to the original nonlinear state, every source dependence is explicitly retained here.

## 4. Full nonlinear returning memory has an exact kinetic-work law

The incompressible quadratic NS field obeys

\[
\langle v,N(v)\rangle_{L^2}=0
\tag{15}
\]

on the declared decaying smooth class. Also `a` and `b` are orthogonal and their gradients are orthogonal since `P` commutes with `Delta`.

From (4), (11), and (15),

\[
\begin{aligned}
\langle a,\mathcal R_P[u]\rangle
&=\langle a,N(a+b)-N(a)\rangle\\
&=\langle a,N(u)\rangle\\
&=-\langle b,N(u)\rangle.
\end{aligned}
\tag{16}
\]

The residual equation gives

\[
\frac12\frac d{dt}\|b\|_2^2+\nu\|\nabla b\|_2^2
=\langle b,N(u)\rangle.
\]

Consequently,

\[
\boxed{
\int_s^T\langle a(t),\mathcal R_P[u](t)\rangle\,dt
=\frac12\|b(s)\|_2^2-\frac12\|b(T)\|_2^2
-\nu\int_s^T\|\nabla b(t)\|_2^2\,dt.
}
\tag{17}
\]

When `b(s)=0`, the returning force performs nonpositive net work on `a`:

\[
\boxed{\int_s^T\langle a,\mathcal R_P[u]\rangle\,dt\le0.}
\tag{18}
\]

Equivalently, with output `y=-mathcal R_P[u]`, the residual subsystem is passive with supply `⟨a,y⟩` and storage `||b||²/2`, plus viscous dissipation. This identity holds for any sufficiently smooth prescribed resolved path `a` while its residual equation has a smooth solution, because the algebraic cancellations do not use the resolved equation.

For the actual full NS trajectory the total energy law further gives the cumulative-work bounds

\[
-\frac12\|a(s)\|_2^2
\le\int_s^T\langle a,\mathcal R_P[u]\rangle\,dt
\le\frac12\|b(s)\|_2^2.
\tag{19}
\]

These are bounds on net work, not its absolute variation.

### Why tangent amplification does not contradict (17)

The earlier secant equation between two independently chosen solutions has indefinite strain work. Equation (17) concerns a different diagram: one source split orthogonally, with its full nonlinear return retained. It does not assert that `U_Q` is contractive.

A finite control makes this explicit. The energy-preserving quadratic field

\[
N(x,y)=(-xy-y^2,\;x^2+xy)
\]

has, under prescribed visible input `x=1`, the damped hidden equation

\[
y'=1+(1-\nu)y,
\]

which has an amplifying homogeneous part when `nu<1`. Yet the returning visible force `r=-y-y²` satisfies exactly

\[
xr=-\frac d{dt}\frac{y^2}{2}-\nu y^2.
\]

Thus homogeneous hidden amplification and a passive full source response coexist. Bounding the propagator by a contraction would be a stronger and unnecessary requirement for (17).

## 5. Connection to the exact pressure/source graph

For the fixed-centre toroidal source projection, the saved pressure theorem states

\[
H[a]= -\frac27(S_u(x)^2)_0,
\]

and

\[
K[u]=H[u]+\frac27(S_u(x)^2)_0
=2H(a,b)+H[b].
\tag{20}
\]

At the centre, `a(x)=0`, `curl a(x)=0`, and `S_a(x)=S_u(x)`. The true nonlinear strain derivative for `a` is therefore

\[
\ell_xN(a)=-\frac57(S_u(x)^2)_0.
\tag{21}
\]

Using `ell_x P=ell_x` and the exact midpoint identity gives

\[
\boxed{
\ell_x\mathcal R_P[u]
=-(u\cdot\nabla S_u)(x)-K[u]
-\frac14(\omega(x)\otimes\omega(x))_0.
}
\tag{22}
\]

The pressure cross-effect, rotation-square term, and Eulerian transport are therefore one actual source-return contraction. They are not independent correction fields. Viscosity remains explicitly in (13); `ell_x Delta b=0` because the angular source complement is heat invariant.

This identity is valid separately at every fixed centre. Selecting a vorticity maximizer afterwards does not authorize interchanging a spatial supremum with the integrals in (12) or (17).

## 6. Continuously renormalized ancestry: the changing normalizer contributes skew transport

Choose a positive `C1` normalization rate `mu(t)` and a `C1` centre `c(t)`. Set

\[
r=\mu^{-2/5},\qquad A=\mu^{-3/5},\qquad
\frac{d\tau}{dt}=\mu,
\]

and

\[
V(y,\tau)=A(t)u(c(t)+r(t)y,t).
\tag{23}
\]

Direct change of variables gives

\[
\|V\|_2=\|u\|_2,
\qquad \operatorname{curl}_yV=\mu^{-1}\omega(c+ry,t).
\tag{24}
\]

The transformed PDE is exactly

\[
\boxed{
V_\tau=N(V)+\epsilon(\tau)\Delta V+K_\tau V,
}
\tag{25}
\]

where

\[
\epsilon=\nu\mu^{-1/5},\qquad
K_\tau=\beta\bigl(y\cdot\nabla+\tfrac32 I\bigr)+d\cdot\nabla,
\]

\[
\beta=-\frac25\frac{\mu'}{\mu^2},\qquad
d=\mu^{-3/5}c'(t).
\tag{26}
\]

The normalization leaves the nonlinear coefficient exactly one. Both the translation generator and `y·grad+3/2` are skew in `L2`, by integration by parts. The exact coefficient `3/2` is forced by the energy-preserving amplitude/length relation `A=r^(3/2)`.

Therefore (4), (6), and the residual Volterra representation apply with the time-dependent field

\[
F_\tau(v)=\epsilon(\tau)\Delta v+K_\tau v+N(v).
\]

Here the residual source is `QF_tau(a)`, including the observer-motion component `QK_tau a`; the returning force is `P( K_tau+DN(m))b`. For a fixed centre the dilation commutes with the angular projection, so it produces no cross-sector forcing. A moving centre generally does, and that term is retained.

The storage identity becomes

\[
\boxed{
\int_{\tau_s}^{\tau_T}\langle a,\mathcal R_{P,F}[V]\rangle\,d\tau
=\frac12\|b(\tau_s)\|_2^2-\frac12\|b(\tau_T)\|_2^2
-\int_{\tau_s}^{\tau_T}\epsilon(\tau)\|\nabla b\|_2^2\,d\tau.
}
\tag{27}
\]

It survives continuously changing normalization. No chart reset is secretly treated as zero energy cost.

Taking `mu=M(t)=||omega(t)||_infinity` on intervals where it is positive gives exact unit maximum vorticity. If `M` is only locally absolutely continuous, these identities hold almost everywhere. One can instead use a smooth positive gauge and retain its comparison to `M` explicitly. At every finite regular interval the original source and the gauge determine all coefficients.

The endpoint peak observable itself has exact scaling

\[
b_V(\tau)=\mu^{-1}b_u(t),\qquad
\boxed{\int b_V\,d\tau=\int b_u\,dt.}
\tag{28}
\]

Thus no recurrence or nonzero weak-limit construction is needed to formulate the actual remaining continuation assertion in this gauge.

### Changing projections directly

For a differentiable family of orthogonal heat-commuting projections `P(t)`, the source split obeys extra `P' u` terms. Since `PP'P=QP'Q=0`, the kinetic storage law is restored exactly by adding the observer-motion return `P'b`:

\[
\int\langle a,\mathcal R_P[u]+P'b\rangle
=\frac12\|b(s)\|_2^2-\frac12\|b(T)\|_2^2-\nu\int\|\nabla b\|_2^2.
\tag{29}
\]

This is a smooth-core identity whenever the indicated derivatives and pairings exist. It is not an assertion that an arbitrary path of vorticity maximizers is differentiable. Explicit translations give a permitted smooth moving frame; arbitrary maximizer selection still requires the correct supremum quantifier.

## 7. What the NS identity does and does not close

Equations (12) and (27) settle the all-order source-return assembly and its kinetic supply balance. The infinite return expansion need not be enumerated before these formulas can be used. A Borel bound on formal return coefficients is not a necessary intermediary to define the exact source-dependent memory.

They do not give the endpoint `int b_u < infinity`. Kinetic storage is not a coercive norm for peak strain or vorticity. In particular it cannot be transported into a critical storage inequality merely by relabeling the norm. The exact quantity in (22), contracted with actual vorticity directions and observed at actual peak locations, remains to be controlled. The earlier odd strain charges, pressure cross-effects, angular selection, and scale-time source constraints remain additional readings of this same return object.

No assertion from run 29's dynamic annular transport-diffusion estimate is used here. That estimate needs its own fully specified analytic justification. Also its displayed `4^{-m}` tail cannot be obtained from `(1+m/j_epsilon)4^{-m}` with a constant independent of `m` by simply dropping the polynomial factor; keeping that factor, or weakening the geometric exponent, is necessary. These facts do not affect the exact midpoint or storage identities.

# II. RH: all residual orders have one rigorously controlled inverse

## 8. Actual normalized arithmetic source

Retain the fixed source

\[
S(t)=\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(t-\log n),
\qquad L(t)=e^{t/2}G(1/2),
\]

with `a=log 2`, `c=sqrt 2` and

\[
A_m=(T_a-cI)^mS,
\qquad Y_k(t)=c^{-k}S(t+ka).
\tag{30}
\]

The exact finite-difference identity is

\[
\Delta^mY_k(t)=c^{-(k+m)}A_m(t+ka).
\tag{31}
\]

For the actual receiver, the saved explicit formula gives

\[
S(t)=L(t)-Z(t)-J_{arch}(t).
\]

Every shifted zero satisfies `Re z<1/2` and the received coefficients are absolutely summable. Thus

\[
c^{-k}Z(t+ka)
=\sum_z m_zG(z)e^{zt}\bigl(2^{z-1/2}\bigr)^k\longrightarrow0
\]

by dominated convergence. The archimedean tail also vanishes after normalization. Hence

\[
\boxed{Y_k(t)\to L(t)}
\tag{32}
\]

without RH or a uniform zero-free strip. For each fixed `t`, `x_k=Y_k(t)-L(t)` belongs to `c_0`.

## 9. The missing boundary argument in ordinary higher discrete integration

Convergence of `Y_k` alone does not imply convergence of

\[
\sum_k\binom{k+m-1}{m-1}\Delta^mY_k
\]

when `m>=2`. For example `x_k=(-1)^k/(k+1)` tends to zero, but the magnitude of the terms `(k+1)Delta²x_k` tends to four, so its ordinary series diverges. The geometric weight in the expression using `A_m` cannot be considered separately from the possible growth of `A_m` itself.

This identifies an insufficient step in run 29, not a counterexample to the actual prime-source formula. A stronger decay input could justify ordinary convergence for that source. The following Abel form requires only (32) and provides the needed inverse unconditionally.

## 10. Abel contracting homotopy on the actual source class

Let `T` be the forward shift on `c_0` and `0<=rho<1`. Define

\[
B_\rho=(1-\rho)T(I-\rho T)^{-1}
       =(1-\rho)\sum_{n\ge0}\rho^nT^{n+1}.
\tag{33}
\]

Then `||B_rho||<=1` and `B_rho x ->0` in `c_0` norm for every `x in c_0`. To prove strong convergence, split the weighted sum before an index beyond which all source coordinates are small; the finite initial contribution has prefactor `1-rho` and tends to zero.

The exact operator normal form is

\[
\boxed{
(I-\rho T)^{-m}(I-T)^m=(I-B_\rho)^m.
}
\tag{34}
\]

The right side tends strongly to the identity. Consequently,

\[
\boxed{
L(t)-S(t)
=(-1)^{m-1}c^{-m}
\lim_{\rho\uparrow1}\sum_{k\ge0}
\binom{k+m-1}{m-1}\left(\frac\rho c\right)^k
A_m(t+ka).
}
\tag{35}
\]

For every `rho<1`, the series converges absolutely because `Y` and its finite differences are bounded. This is a genuine source-preserving inverse with its limiting operation specified.

## 11. In the bounded-residual class, there is no additional convergence obligation

Suppose for some `m` and `t0`,

\[
B_m=\sup_{t\ge t_0}|A_m(t)|<\infty.
\]

Then (35) converges absolutely also at `rho=1`, with

\[
\boxed{
|L(t)-S(t)|\le\frac{B_m}{(c-1)^m}
=(\sqrt2+1)^mB_m,
\qquad t\ge t_0.
}
\tag{36}
\]

The scalar constant follows from

\[
c^{-m}\sum_{k\ge0}\binom{k+m-1}{m-1}c^{-k}
=(c-1)^{-m}.
\]

This is precisely the norm of `(cI-T_a)^{-m}` on bounded functions; constants show sharpness for that general bounded-function inverse.

Uniqueness also follows directly: a source difference `h` satisfying `(T_a-cI)^m h=0` has normalized values `c^{-k}h(t+ka)` polynomial in `k` of degree at most `m-1`. The inherited zero limit kills every such homogeneous ambiguity.

Since `L-S=Z+J_arch`, (36) gives bounded `Z` on the tail. The supplied Laplace-pole argument then yields RH. Thus the higher residual family is now a reusable, correctly scoped implication, not an infinite ladder of new representation tasks.

The pole-annihilating Mellin multiplier and finite quantitative-Goldbach ancestry of `A_m` are unchanged. No bound for any actual `A_m` has been proved here. Changing `m` adds vanishing moments but also the explicit inverse amplification `(sqrt2+1)^m`; it does not by itself discharge the arithmetic assertion.

## 12. Source/dependency ledger

Fresh reads at the pinned head:

* `TheGenerativeLoopOnTheKernelsOwnTermsACertifiedNormalizerEmitsDerivationsSoLearnCallsInstall.agda`: the actual kernel normalizer emits a derivation which `learn` supplies to `install`. Its concrete datatype is not identified with the PDE or arithmetic spaces above.
* `ExcursionReturn.agda`: the linear compression/return identity and set-level future-observability interpretation; its linear hypotheses are not silently applied to the NS state equation.
* The comprehensive conversation handoff and `endpoint_graph.md`: source equivalences carry predicates; they do not prove the source property.
* `continuation_memory_and_two_packet_weil.md`: the earlier passive triangular memory and the distinct general secant-strain obstruction.
* The saved run 23 source note: the full toroidal pressure theorem and actual angular nonlinear source.
* Saved run 29: higher arithmetic residuals and its limiting-convergence step, repaired by (35).

Primary background: Chorin, Hald and Kupferman, *Optimal prediction and the Mori–Zwanzig representation of irreversible processes*, PNAS 97 (2000), 2968–2973; Gouasmi, Parish and Duraisamy, *A priori estimation of memory effects in reduced-order models of nonlinear systems using the Mori–Zwanzig formalism*, Proc. R. Soc. A 473 (2017), 20170385. Projection memory and exact nonlinear reformulation are classical; the calculations here instantiate the retained NS source projection and the actual arithmetic residual tower.

Verification: `checks.py` is rerunnable. It checks the general quadratic midpoint identity, energy-preserving quadratic source work, projection-motion exchange, dynamic-normalization coefficients, Abel normal forms and inverse sums, and a genuinely three-dimensional finite-Fourier NS source without truncating any generated product modes. No new Lean/Agda theorem is claimed.


---

# ORIGINAL S20 — Dyadic pole residual and general toroidal radial marginality
Source path: `sources/S20_dyadic_and_radial_marginality.md`; SHA-256: `8ce3142d1c22c3e70e191b4581792ac4357711105fcb137ae31c6fc979eb59c0`
Transfer status: Recovered run26; use with later scope corrections.

# Dyadic pole-annihilating arithmetic residual and the unique marginal toroidal Navier–Stokes channel

Repository snapshot: `avikj/metacircular-interaction-prototype@168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status

This run composes the endpoint graph with two pieces of existing machinery instead of introducing
another reconstruction layer.

* On RH, the installed scale action `t -> t + log 2` is compared against the exact square-root
  scaling character of the zeta pole.  The resulting ActionResidual kills the `rho=1` main term
  identically but loses no nontrivial zero.  It produces a main-term-free finite prime-shell
  observable.  RH is equivalent to boundedness of this observable, and even one eventual
  one-sided subexponential bound suffices.

* On Navier–Stokes, the complete toroidal spherical-harmonic Biot–Savart inverse is written in
  log radius.  Its operator factors as
      (D-(l-2))(D+(l+3)).
  After the translation/gauge `l=1` mode is removed, `l=2` is the unique zero exponent:
  the unique marginal toroidal channel.  Every `l>=3` channel contracts under inward radial
  transport.  This proves that the logarithmic Zeno accumulation found earlier belongs
  specifically to the strain-bearing degree-two mode; emitted higher modes can matter only by
  returning nonlinearly to degree two.

Neither statement proves RH or unrestricted 3D Navier–Stokes regularity.  The new results reduce
the endpoint obligations and locate the exact scale channel in which a bad NS ancestry must keep
regenerating information.

---

# I. RH — subtract the exact scale character of the pole

## 1. Retained receiver

Use the saved compact autocorrelation `g`, its bilateral transform `G`, and

    Z(t) = sum_z m_z G(z) exp(z t),

where `z=rho-1/2` ranges over distinct shifted nontrivial zeta zeros with multiplicity.
The retained facts are:

1. `sum_z m_z |G(z)| < infinity`;
2. `G(z) != 0` throughout `|Re z|<1/2`;
3. for `t>1/2`,
       Z(t)=exp(t/2)G(1/2)-S(t)-J(t),
   where
       S(t)=sum_{n>=2} Lambda(n)n^(-1/2) g(t-log n)
   is a finite prime shell and `J(t)` is the explicit exponentially decaying trivial-zero /
   archimedean remainder;
4. the meromorphic Laplace transform of `Z` has a genuine pole at every shifted zero;
5. if an off-critical zero exists and
       delta=sup_z Re z > 0,
   then both signs of `Z` realize exponential rate `delta`.

The last point was proved by the one-sided Landau argument and does not assume a rightmost zero.

## 2. The installed dyadic ActionResidual

Let

    a = log 2

and define

    boxed:
    R_2(t) = Z(t+a) - sqrt(2) Z(t).                         (1)

This is exactly an action residual:
the actual next scale reading minus the prediction supplied by the pole/equilibrium scaling
character `exp(a/2)=sqrt(2)`.

On a spectral character `exp(z t)`,

    R_2 : exp(z t) |-> (2^z-sqrt(2)) exp(z t).             (2)

The pole character `z=1/2` is therefore annihilated exactly.

No shifted nontrivial zero is annihilated.  Indeed

    2^z=sqrt(2)

would imply, by taking absolute values,

    2^(Re z)=2^(1/2),

hence `Re z=1/2`, impossible for a nontrivial zero in the open critical strip.

The multiplier is uniformly bounded on the shifted strip, so the received coefficients remain
absolutely summable.

Thus the residual has exactly the same nontrivial pole set as the original receiver.

## 3. Meromorphic transform and unchanged off-line exponent

For general `a>0`, put

    R_a(t)=Z(t+a)-exp(a/2)Z(t).

For `Re w` initially large,

    L_{R_a}(w)
      = (exp(a w)-exp(a/2)) L_Z(w)
        - exp(a w) integral_0^a exp(-w s) Z(s) ds.          (3)

The second term is entire in `w`.  Hence the residue at a shifted zero `z` is

    m_z G(z) [exp(a z)-exp(a/2)],

which is nonzero.

Consequently the same Landau argument gives, under failure of RH, for every `0<=b<delta`,

    limsup exp(-b t) R_a(t)=+infinity,
    liminf exp(-b t) R_a(t)=-infinity.                      (4)

No dominant-mode assumption enters.

In particular `R_2` has the same exact two-sign exponential rate `delta`.

Under RH all `z=i gamma`, the received coefficient sequence is absolutely summable, and `R_2`
is bounded.

Therefore

    boxed:
    RH  <=>  R_2 is bounded on a terminal half-line.        (5)

More strongly, either one of the following alone implies RH:

    R_2(t) <= exp(o(t)),
    R_2(t) >= -exp(o(t))                                    (6)

eventually.  A polynomial one-sided bound is more than enough.

## 4. The main term disappears on the arithmetic side

Define the pure dyadic prime-shell residual

    boxed:
    A_2(t)=S(t+log 2)-sqrt(2)S(t).                           (7)

Because the pole term obeys the exact scale law

    exp((t+log2)/2)=sqrt(2) exp(t/2),

the explicit formula gives

    boxed:
    R_2(t) = -A_2(t)-J_2(t),                                (8)

where

    J_2(t)=J(t+log2)-sqrt(2)J(t)

decays exponentially.

Thus the large `exp(t/2)` term is not estimated or approximately cancelled.  It is removed
algebraically by the installed action residual.

Explicitly,

    A_2(t)
      = sum_n Lambda(n)/sqrt(n)
          [ g(t+log2-log n) - sqrt(2) g(t-log n) ].          (9)

Only the finite union of the two shells

    exp(t-1/2) <= n <= exp(t+1/2),
    2 exp(t-1/2) <= n <= 2 exp(t+1/2)

appears.

Every value therefore has finite quantitative-Goldbach ancestry through the already-proved
triangular reconstruction of `Lambda`.

Combining (4), (5), and the decay of `J_2`:

    boxed:
    RH
      <=>
    A_2(t)=O(1) on a terminal half-line,                    (10)

and each one-sided condition

    A_2(t) <= exp(o(t))                                      (11a)
or
    A_2(t) >= -exp(o(t))                                     (11b)

is separately sufficient for RH.

This is strictly cleaner than the preceding arithmetic endpoint
`S(t)-exp(t/2)G(1/2)+J(t)`: the new assertion contains no macroscopic main term whose
square-root-scale cancellation has to be proved.

## 5. Repository instantiation

`ActionResidual` formalizes the pattern

    residual = after - predict(before).

Here:

    state/action:        t -> t+log2,
    reading:             S(t),
    predictor:           y -> sqrt(2) y,
    residual:            A_2(t).

The predictor is not guessed: it is exactly the response character of the zeta pole.  The
nontrivial spectral characters are separated because `2^z-sqrt(2)` is nonzero on every shifted
nontrivial zero.

The residual therefore removes the equilibrium carrier while preserving the entire obstruction
spectrum.

---

# II. Navier–Stokes — the radial transport spectrum of every toroidal angular degree

## 6. General toroidal source

Let `Y_l` be a scalar spherical harmonic of degree `l>=1` and let `T_l` be its toroidal vector
harmonic.  Take

    omega_l(r,n)=f_l(r) T_l(n).

Write its finite-energy Coulomb/Biot–Savart vector potential in the form

    psi_l(r,n)=r^2 q_l(r) T_l(n).

The vector spherical-harmonic Laplacian gives

    boxed:
    q_l'' + (6/r)q_l'
      - [(l-2)(l+3)/r^2] q_l
      = -f_l/r^2.                                           (12)

The coefficient is

    l(l+1)-6=(l-2)(l+3).

For compactly supported radial source the unique regular finite-energy inverse is

    boxed:
    q_l(r)=1/(2l+1) [
       r^(-(l+3)) integral_0^r s^(l+2) f_l(s) ds
       + r^(l-2) integral_r^infinity f_l(s)s^(-(l-1)) ds
    ].                                                       (13)

For a unit radial atom at `s` this is

    q_l(r;s)=1/(2l+1) *
      { r^(l-2)s^(-(l-1)),  r<s,
        s^(l+2)r^(-(l+3)),  r>s. }                          (14)

The derivative jump is exactly `-1/s^2`, so (14) is the Green kernel for (12).

The previously derived kernels are recovered without adjustment:

    l=2:
      q_2(r;s)=1/(5s)            for r<s,
               s^4/(5r^5)       for r>s;

    l=4:
      q_4(r;s)=r^2/(9s^3)        for r<s,
               s^6/(9r^7)       for r>s.

Thus the `1/5` strain kernel and the `1/9` degree-four inverse are two members of one family.

## 7. Log-radius factorization

Put

    x=log r,
    Q_l(x)=q_l(exp x),
    F_l(x)=f_l(exp x).

Equation (12) becomes

    Q_l'' + 5 Q_l' -(l-2)(l+3) Q_l = -F_l,

hence

    boxed:
    (D-(l-2))(D+(l+3)) Q_l = -F_l,
    D=d/dx.                                                  (15)

This is the exact renormalized radial transport spectrum.

The two homogeneous exponents are

    lambda_in  = l-2,
    lambda_out = -(l+3).

A source shell lying outside the observation scale is therefore transmitted inward with factor

    exp[-(l-2) Delta x].                                    (16)

## 8. The unique marginal channel

Three cases have different physical meanings.

### l=1 — translation/gauge channel

Inside a remote `l=1` source shell, `q_1 ~ r^(-1)`.  Then the full vector potential is
`r^2 q_1 T_1 ~ r T_1 = x cross const`, whose curl is a constant velocity.
Its gradient and strain vanish.

This is exactly the translation degree removed by Lagrangian centering.

### l=2 — marginal strain channel

Here

    (D)(D+5)Q_2=-F_2.                                       (17)

The inward exponent is exactly zero.  A remote shell produces a constant interior `q_2`, hence
a linear interior velocity and a nonzero constant strain.

For a compact source,

    boxed:
    q_2(0)=1/5 integral_0^infinity f_2(r) dr/r.              (18)

In log radius this is the zero-frequency source moment.  It is the boundary residue of the
`D` factor in (17).

This is why every geometrically separated shell can contribute the same strain increment:
`dr/r` is the Haar measure of multiplicative scale.

### l>=3 — irrelevant inward channels

The inward exponent `l-2` is strictly positive.  A remote shell at radius `R` contributes at
radius `r<R`

    |q_l(r)| <= C_l ||f_l||_infinity (r/R)^(l-2).            (19)

The corresponding interior velocity is homogeneous of degree `l-1`; its strain is homogeneous
of degree `l-2` and vanishes at the centre.

Therefore:

    boxed:
    after quotienting translations, l=2 is the unique toroidal
    zero exponent / marginal channel for the central strain observer.   (20)

No topological `H^2` class is needed.  The special object is the literal zero eigenvalue of the
log-radius transport generator.

## 9. Geometric shell theorem

Let

    R_j=4^(-j)

and let the degree-l source on shell j have amplitude `a_j`, with

    |a_j| <= C(1+j)^m.

At a point `r` comparable to `R_k`, (13) gives

    |q_l(r)|
      <= C_l [
          sum_{j<k}|a_j| 4^(-(k-j)(l-2))
          + |a_k|
          + sum_{j>k}|a_j| 4^(-(j-k)(l+3))
        ].                                                   (21)

Hence

    l>=3:
      |q_l(r)| <= C_(l,m)(1+k)^m;                            (22)

while

    l=2:
      |q_2(r)| <= C_m(1+k)^(m+1).                            (23)

The marginal `l=2` inverse gains one additional logarithmic shell count.
Every higher angular inverse does not.

This explains, rather than merely rechecks, the first-return calculation already obtained:

* the original degree-two tower has `g_N ~ j` on shell j because all outer degree-two shells
  accumulate without attenuation;
* the emitted degree-four coefficient satisfies `h_N=beta4[f_N] ~ j`;
* its degree-four inverse remains `p_N ~ j`, not `j^2`, because `l=4` has inward exponent two;
* the returned degree-two source is therefore polynomial (`~j^2` in the proved bound), and its
  freely diffusing central-strain memory is weighted by `R_j^2`.

The saved first-return theorem indeed obtained

    sum_j j^2 R_j^2
      = sum_j j^2 16^(-j)
      = 272/3375 < infinity.

Equation (21) identifies the structural reason: the excursion sector does not itself carry the
marginal Zeno logarithm.

## 10. Exact excursion-return placement

Let `P` project vorticity onto the full toroidal `l=2` sector and `Q=I-P`.

Linear heat evolution preserves angular degree.  Thus linear evolution has no `Q -> P` return.

The actual quadratic NS generator does not preserve `P`: the retained source calculation gives

    Q N(f T_A)=beta4[f] T4[A] != 0

for every nontrivial nonnegative compact aligned shell.

The latest source calculation then gives the actual first return

    boxed:
    R_24(a)=P DN(a)[Q N(a)],                                 (24)

with its explicit radial operator and positive directional two-radius kernel.

Thus the source graph is now exact:

    marginal l=2
       --actual N--> contracting l=4 excursion
       --actual DN--> marginal l=2 return.                   (25)

This is the nonlinear application-specific realization of the excursion/return idea.  The
linear `ExcursionReturn.agda` identity is not being applied outside its hypotheses; rather, the
actual nonlinear derivative supplies the return term explicitly.

## 11. Consequence for a Type-II ancestry

The static Zeno mechanism lives entirely in the zero exponent of (17).

Higher angular sectors can be future-relevant, but they cannot store another unattenuated
logarithmic scale sum while they remain outside `P`.  They must return to `l=2` before they can
again exploit the marginal channel.

Moreover, any degree-two returned shell family with polynomial shell amplitudes `O(j^m)` has
finite free central-strain memory because the exact heat lifetime contributes `R_j^2`:

    sum_j j^m R_j^2 < infinity.                              (26)

The first actual `2 -> 4 -> 2` return satisfies this hypothesis and has already been proved with
total-variation memory bounded uniformly in the number of shells.

Therefore a hypothetical singular ancestry based on this scale geometry cannot be a finite static
angular excursion.  It must involve an infinite time-ordered regeneration mechanism that returns
complementary modes into the marginal `l=2` channel rapidly enough to overcome the `R_j^2`
viscous lifetime weights.

This is a substantially smaller continuation fibre than "arbitrary Type-II turbulence":

    boxed:
    bad ancestry
      => indefinitely repeated nonlinear return into the unique marginal
         strain-bearing scale channel.                      (27)

Controlling that infinite return/resummation is still open here; no finite-order calculation is
silently promoted to the full PDE.

---

# III. Shared scale-spectrum picture

The two lanes now have a literal common object: an action with a distinguished equilibrium
character and a residual transport spectrum.

RH:
    scale action on zero mode z       exponent Re z;
    desired condition                 every obstruction exponent is 0;
    dyadic residual                   kills the pole character 1/2 and keeps every zero.

NS:
    inward log-radius action on l     exponent l-2;
    translation quotient              removes l=1 gauge;
    unique physical neutral channel   l=2;
    nonlinear return                  moves information from contracting Q modes back to l=2.

The remaining hard statements are not reconstruction problems.  They are estimates on the actual
source residuals:

* arithmetic: control one side of the pure dyadic prime-shell residual (7);
* fluid: control the infinite time-ordered nonlinear return into the marginal degree-two channel.

That is the current endpoint cut.


---

# ORIGINAL S21 — Higher residuals and dynamic matching proposal
Source path: `sources/S21_higher_residuals_dynamic_matching.md`; SHA-256: `88a5dd6291784bcdf790b43caee928ed2dbe8447ce5ca6f2031f077badff0edb`
Transfer status: AUDIT: higher difference convergence repaired by S19; NS matching claims not promoted.

# Higher metacircular prime residuals and a dynamic matching barrier for record-normalized Navier–Stokes

Repository snapshot: `avikj/metacircular-interaction-prototype@168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status

This run continues from the assembled endpoint graph and the latest wavelet/resolvent and fine-frequency reductions.

New results:

1. The dyadic RH ActionResidual has a complete higher-order hierarchy. For every integer `m>=1`, the `m`-fold residual `(T_log2-sqrt(2))^m` is a compact multiplicative prime wavelet with **m exact Mellin vanishing moments at the pole**, while remaining nonzero at every nontrivial zeta zero. The m-th residual alone reconstructs the original normalized prime discrepancy by an explicit negative-binomial tail kernel. Thus RH is equivalently boundedness of any member of an arbitrarily high-cancellation family of finite prime-shell observables.

2. In the record-normalized NS ancestry, the inherited bounds `||Omega||_infinity <= 1`, `||V||_2 <= E` imply a paradifferential equation for each high vorticity annulus. Once `epsilon 4^k >> E+k`, diffusion acts faster than the local log-Lipschitz deformation. The dyadic vorticity block is then forced down to size `O((E+k)/(epsilon 4^k))`. The threshold `epsilon 4^k ~ k` is exactly the previously derived physical matching scale `r^2 log(1/r) ~ epsilon`. Frequencies a fixed number of octaves finer than this matching band have a geometrically summable strain tail, uniformly on bounded normalized-time intervals. Hence a bad ancestry cannot hide in arbitrarily fine static frequency texture: it must remain in the matching/coarse band or continuously re-inject high frequency on its own parabolic lifetime.

No proof of RH or unrestricted three-dimensional Navier–Stokes regularity is claimed.

---

# I. RH — an arbitrary-order residual hierarchy over the same actual prime source

## 1. The first residual and normalized orbit

Retain
\[
S(t)=\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}g(t-\log n),
\qquad a=\log2,\qquad c=\sqrt2.
\]

Let
\[
D_c=T_a-cI,
\qquad
A_m(t)=D_c^mS(t),\qquad m\ge1.
\tag{1}
\]

The normalized dyadic prime orbit is
\[
Y_k(t)=c^{-k}S(t+ka).
\tag{2}
\]

Let `Delta` denote forward difference in the discrete scale index. A direct induction gives
\[
\boxed{
\Delta^mY_k(t)=c^{-(k+m)}A_m(t+ka).
}
\tag{3}
\]

Thus the higher ActionResidual is not a new source. It is the m-th discrete derivative of the same normalized prime-shell history.

## 2. Exact reconstruction from the m-th residual alone

The retained spectral theorem gives
\[
Y_k(t)\longrightarrow L(t):=e^{t/2}G(\tfrac12)
\]
unconditionally as `k -> infinity`; all lower finite differences tend to zero as well.

Repeated discrete integration therefore yields
\[
\boxed{
L(t)-Y_0(t)
=
(-1)^{m-1}
\sum_{r=0}^{\infty}
\binom{r+m-1}{m-1}\Delta^mY_r(t).
}
\tag{4}
\]

Combining (3) and (4),
\[
\boxed{
e^{t/2}G(\tfrac12)-S(t)
=
(-1)^{m-1}2^{-m/2}
\sum_{r\ge0}
\binom{r+m-1}{m-1}
2^{-r/2}A_m(t+r\log2).
}
\tag{5}
\]

The inverse kernel grows only polynomially in `r` and is multiplied by the geometric `2^{-r/2}`. Hence it is absolutely summable for every fixed `m`.

This is an exact metacircular statement: the residual coordinate can be differentiated any finite number of times and still reconstructs the source discrepancy losslessly.

## 3. Compact multiplicative wavelets with arbitrarily many vanishing moments

Write `x=e^t`, and retain
\[
K(y)=y^{-1/2}g(-\log y),
\qquad
S(\log x)=x^{-1/2}\sum_n\Lambda(n)K(n/x).
\]

Define recursively
\[
\Psi_0=K,
\qquad
\Psi_{m+1}(y)=2^{-1/2}\Psi_m(y/2)-\sqrt2\,\Psi_m(y).
\tag{6}
\]

Then
\[
\boxed{
A_m(\log x)=x^{-1/2}\sum_n\Lambda(n)\Psi_m(n/x).
}
\tag{7}
\]

Every `Psi_m` is compactly supported in a finite union of multiplicative shells. Its Mellin transform is
\[
\boxed{
\mathcal M\Psi_m(s)
=
2^{m/2}(2^{s-1}-1)^mG(s-\tfrac12).
}
\tag{8}
\]

Therefore `s=1` is a zero of exactly order `m`:
\[
\boxed{
\int_0^\infty\Psi_m(y)(\log y)^r\,dy=0,
\qquad 0\le r<m.
}
\tag{9}
\]

These are Mellin moments, the natural moments for multiplicative scale.

Yet for every nontrivial zeta zero `rho`,
\[
\boxed{
\mathcal M\Psi_m(\rho)\ne0.
}
\tag{10}
\]
Indeed `G(rho-1/2) != 0`, and `2^(rho-1)=1` would force `Re rho=1`, impossible for a nontrivial zero.

Thus arbitrary finite cancellation at the pole can be installed **without deleting a single nontrivial zero coordinate**.

## 4. Every order is an RH-equivalent finite arithmetic endpoint

On the zero carrier, `A_m` multiplies the shifted-zero mode `e^{zt}` by
\[
(2^z-\sqrt2)^m.
\]
This multiplier is nonzero at every shifted nontrivial zero and bounded on the critical strip for fixed `m`. Hence the received divisor of `A_m` has exactly the same pole set and the same rightmost exponential abscissa as the original faithful receiver.

Therefore, for every fixed `m>=1`,
\[
\boxed{
\mathrm{RH}\iff A_m(t)=O(1)\quad(t\to\infty).
}
\tag{11}
\]

The one-sided Landau argument also survives unchanged: either eventual bound
\[
A_m(t)\le e^{o(t)}
\quad\text{or}\quad
A_m(t)\ge-e^{o(t)}
\tag{12}
\]
alone implies RH.

Every value of `A_m` uses finitely many prime shells and hence has finite quantitative-Goldbach ancestry.

The arithmetic proof target is therefore flexible rather than unique: one may choose as many exact multiplicative vanishing moments as are useful for an estimate, without changing the endpoint theorem.

---

# II. NS — the dynamic high-frequency barrier occurs at the same matching scale

## 5. Record-normalized equation and inherited dyadic bounds

At a vorticity record time retain the exact joint chart
\[
\|V(\tau)\|_2\le E,
\qquad
\|\Omega(\tau)\|_\infty\le1,
\qquad
\Omega=\operatorname{curl}V,
\tag{13}
\]
on the entire backward record ancestry, and
\[
\partial_\tau\Omega+V\cdot\nabla\Omega
=
\Omega\cdot\nabla V+\epsilon\Delta\Omega,
\qquad
\epsilon=\nu M^{-1/5}.
\tag{14}
\]

For a smooth Littlewood-Paley decomposition, Biot-Savart gives uniformly for `j>=0`
\[
\boxed{
\|\Delta_jV\|_\infty\le C2^{-j},
\qquad
\|\Delta_j\nabla V\|_\infty\le C.
}
\tag{15}
\]
The very low block is controlled by `E`.

Therefore
\[
\boxed{
\|\nabla S_{j-4}V\|_\infty\le C(E+j+1).
}
\tag{16}
\]

This is the frequency-local version of the inherited log-Lipschitz velocity modulus.

## 6. Paralinearize the actual vorticity generator

Let
\[
\Omega_j=\Delta_j\Omega.
\]
Using the divergence-free identity
\[
-(V\cdot\nabla)\Omega+(\Omega\cdot\nabla)V
=
\operatorname{curl}(V\times\Omega),
\]
Bony decomposition separates the only large low-high transport term:
\[
\boxed{
(\partial_\tau+S_{j-4}V\cdot\nabla-\epsilon\Delta)\Omega_j
=F_j.
}
\tag{17}
\]

The remaining terms satisfy
\[
\boxed{
\|F_j(\tau)\|_\infty\le C(E+j+1)
}
\tag{18}
\]
uniformly on the record ancestry.

The reason is source-level and scale-exact:

* the commutator with the low velocity costs `||grad S_{j-4}V||_infinity = O(E+j)`;
* a high velocity block has size `O(2^{-j})`, so after the one derivative in `curl(V x Omega)` a high-low interaction is `O(1)`;
* high-high interactions contributing to output frequency `2^j` carry the geometric factor `2^{j-k}` from the derivative acting after the product, and sum absolutely over `k>=j`.

No derivative of the merely bounded full vorticity is inserted as an independent hypothesis.

## 7. Diffusion beats deformation exactly when `epsilon 4^j` beats `j`

The transport field in (17) has Lipschitz rate `O(E+j)`. During one parabolic lifetime
\[
\tau_j=(\epsilon4^j)^{-1},
\tag{19}
\]
its flow distortion is therefore
\[
O\!\left(\frac{E+j}{\epsilon4^j}\right).
\]

Standard frequency-localized transport-diffusion estimates may be iterated on these parabolic subintervals. Consequently, once
\[
\boxed{
\epsilon4^j\ge A(E+j+1)
}
\tag{20}
\]
for a sufficiently large universal `A`, one obtains
\[
\boxed{
\|\Omega_j(\tau)\|_\infty
\le
C e^{-c\epsilon4^j(\tau-s)}\|\Omega_j(s)\|_\infty
+
C\frac{E+j+1}{\epsilon4^j}.
}
\tag{21}
\]

Equation (21) is the dynamic statement that was missing from the previous purely spatial fine-residual split.

The analytic input is the standard transport-diffusion / paradifferential estimate for an almost-Lipschitz velocity, applied only in the regime where one diffusion time is shorter than one local deformation time.

## 8. The threshold is exactly the previously discovered matching scale

Let `j_epsilon` be the least integer satisfying (20). Then
\[
\epsilon4^{j_\epsilon}\asymp E+j_\epsilon,
\tag{22}
\]
and as `epsilon -> 0`,
\[
\boxed{
j_\epsilon
=
\frac12\log_2\frac1\epsilon
+
\frac12\log_2\log\frac1\epsilon
+
O_E(1).
}
\tag{23}
\]

The corresponding physical scale in normalized coordinates is
\[
r_\epsilon=2^{-j_\epsilon},
\]
so
\[
\boxed{
r_\epsilon^2\asymp\frac{\epsilon}{\log(1/\epsilon)}.
}
\tag{24}
\]
Equivalently,
\[
\boxed{
\frac{r_\epsilon^2\log(1/r_\epsilon)}{\epsilon}\asymp1.
}
\tag{25}
\]

This is exactly the critical Lagrangian matching parameter derived previously from the log-Lipschitz velocity difference. The same scale has now been obtained independently as the point where **dyadic viscous damping overtakes nonlinear frequency deformation**.

That joint derivation is significant: the physical-space matching calculation and the frequency-space continuation calculation identify the same residual fibre.

## 9. Frequencies beyond the matching band are a contractive continuation fibre

For `m>=0` and `j>=j_epsilon+m`, (22) gives
\[
\frac{E+j+1}{\epsilon4^j}
\le
C(1+m/j_\epsilon)4^{-m}.
\tag{26}
\]

Since strain is an order-zero transform of vorticity on each annulus,
\[
\|\Delta_jS\|_\infty\le C\|\Omega_j\|_\infty.
\]

Summing (21) yields the post-relaxation tail estimate
\[
\boxed{
\|S_{\ge j_\epsilon+m}(\tau)\|_\infty
\le
C4^{-m}
+
\text{parabolically decaying transient}.
}
\tag{27}
\]

More robustly, on every normalized time interval `[s,s+L]`,
\[
\boxed{
\int_s^{s+L}
\|S_{\ge j_\epsilon+m}(\tau)\|_\infty\,d\tau
\le
C_E\left(L+\frac1{E+j_\epsilon+1}\right)4^{-m}.
}
\tag{28}
\]

The first term is the sustained nonlinear forcing; the second is the complete initial transient. The geometric factor comes from
\[
\sum_{n\ge m}4^{-n}=\frac43\,4^{-m}.
\]

Thus arbitrarily fine frequencies cannot carry an independent nonintegrable stretching history while (13) holds. Their full time-integrated strain tail is geometrically small beyond the matching band.

## 10. Corrected continuation fibre

The previous run reduced a bad ancestry to a generic “fine-frequency residual.” Equations (20)–(28) sharpen that considerably.

The fine sector splits into:

1. **matching band**
   \[
   j=j_\epsilon+O(1),
   \]
   where diffusion and nonlinear deformation genuinely compete;

2. **ultra-fine sector**
   \[
   j\gg j_\epsilon,
   \]
   which is dynamically contractive and has geometrically summable integrated strain unless it is freshly regenerated on each parabolic lifetime.

Hence
\[
\boxed{
\text{bad record ancestry}
\Longrightarrow
\begin{cases}
\text{persistent return into the matching/marginal band},\\
\text{or regeneration of ultra-fine source at rate }\gtrsim\epsilon4^j.
\end{cases}
}
\tag{29}
\]

This removes the possibility that a bad continuation simply stores arbitrary unresolved texture at frequencies much finer than the critical matching scale.

The remaining problem is still substantive: the matching/coarse strain can be logarithmically large, as the exact Zeno shell family demonstrates, and an infinite sequence of time-ordered returns may continually repopulate that band. No estimate here turns that last mechanism into a contradiction.

---

# III. The theorem graph after this run

## RH

The source can now be passed through any finite number of exact residual refinements:
\[
\text{quantitative Goldbach}\to\Lambda\to A_m\to\text{same nontrivial zero divisor}.
\]

Each refinement adds one Mellin vanishing moment at the pole and loses no zeta-zero coordinate. The inverse (5) proves that this is lossless at the normalized prime-discrepancy level.

## NS

Two independent calculations now meet at the same scale:
\[
\text{Lagrangian log-Lipschitz matching}
\quad\Longleftrightarrow\quad
\text{dyadic diffusion/deformation matching}
\]
through
\[
r^2\log(1/r)\asymp\epsilon.
\]

Below that scale the continuation fibre is contractive. Above it the earlier universal `Sym_0(3)` marginal strain channel and finite-return calculations remain the correct source description.

The current NS endpoint is therefore no longer “control all fine frequencies.” It is
\[
\boxed{
\text{control repeated nonlinear repopulation of the finite matching band.}
}
\]

That is the smallest source-coherent continuation fibre reached so far in this branch.


---

# ORIGINAL S22 — Direct quadratic Goldbach residual and all-depth source-dependent memory
Source path: `sources/S22_quadratic_goldbach_and_memory.md`; SHA-256: `1e518af138397a669e67a4b899d53a5f9411e54272add829829f2c7148d59cd6`
Transfer status: Arithmetic derivation retained; Gaussian-in-octave NS suppression remains AUDIT.

# Metacircular quadratic closure: a direct Goldbach scale residual for RH and one exact NS memory kernel for all excursion depth

Repository snapshot: `avikj/metacircular-interaction-prototype@168ea8e240524f898af4b0e9cf70297c38422f08`.

## Status

The high-level simplification is that both frontier objects are quadratic and therefore metacircular in the literal differential sense.

For a quadratic map Q,

    Q(x) = (1/2) DQ(x)[x].

The object generates the linear operator that transports the object.

This observation has two concrete consequences here.

* RH. The quantitative Goldbach field is already the square of the positive prime Laplace field. After its natural scaling normalization, RH is exactly a Hölder-scale statement for one dyadic ActionResidual of the Goldbach field itself. No reconstruction of Lambda, compact receiver, square root, or zero interpolation is needed in the final criterion.

* Navier-Stokes. Along one actual solution, the quadratic vorticity nonlinearity is exactly a self-generated linear nonautonomous operator. Therefore every excursion out of an observed sector and every return from it resums into one exact Feshbach/Mori-Zwanzig Volterra memory kernel. The previously computed 2->4->2 return is precisely the diagonal first term of this kernel. The all-depth Borel tree is an expansion of the same kernel, not an independent obligation.

A second NS refinement uses frequency locality: ultra-fine vorticity cannot be injected directly from the matching band. It must cross adjacent dyadic bands. Past the diffusion/deformation matching scale, every additional band incurs a geometric damping factor; iteration gives Gaussian-in-octave suppression of cascade-generated ultra-fine content.

No proof of RH or unrestricted 3D Navier-Stokes regularity is claimed.

---

# I. RH — work directly on the quantitative Goldbach square

## 1. The actual Goldbach Laplace field

Let

    R(N) = sum_{a+b=N} Lambda(a)Lambda(b)

be the actual quantitative Goldbach field and define, for t>0,

    A(t)   = sum_{n>=2} Lambda(n) exp(-nt),
    G_R(t) = sum_{N>=4} R(N) exp(-Nt).

Absolute convergence and the convolution identity give

    G_R(t) = A(t)^2.                                         (1)

Since A(t)>0, the positive root is canonical. The prime number theorem gives

    t A(t) -> 1  as t -> 0+.                                 (2)

Normalize the Goldbach field by its exact pole scaling:

    Gcal(t) = t^2 G_R(t) = (t A(t))^2.                       (3)

Then Gcal(t)->1.

## 2. The one-step metacircular residual

Apply the installed dilation t -> 2t and subtract the fixed-point prediction:

    r_G(t) = Gcal(2t) - Gcal(t).                             (4)

Equivalently,

    r_G(t) = 4 t^2 G_R(2t) - t^2 G_R(t)
           = 4 t^2 [G_R(2t) - (1/4)G_R(t)].                 (5)

Thus the predictor 1/4 is exactly the scaling character of the Goldbach pole t^-2.

Put

    Y(t)=t A(t)>0.

Then

    r_G(t) = [Y(2t)-Y(t)] [Y(2t)+Y(t)].                      (6)

Because Y(t)->1, the second factor tends to 2 and is bounded above and below away from zero for sufficiently small t. Therefore the Goldbach-square residual and the positive-root residual have exactly the same small-t decay exponent.

This is precisely the coordinate-fibre principle in ActionResidualCoordinateFibers: the square/root re-coordinate does not create or remove the residual obstruction on the realized positive source.

## 3. Exact RH criterion on the Goldbach field alone

### Theorem

RH is equivalent to

    for every epsilon>0,
    |r_G(t)| = O_epsilon(t^(1/2-epsilon)) as t->0+.          (7)

Equivalently,

    G_R(2t) - (1/4)G_R(t)
      = O_epsilon(t^(-3/2-epsilon)).                         (8)

This criterion uses only the quantitative Goldbach coefficients R(N).

### RH implies the residual estimate

For Re s>1,

    integral_0^infinity A(t) t^(s-1) dt
      = Gamma(s) [-zeta'(s)/zeta(s)].                        (9)

Under RH there are no zeros in any closed half-plane Re s>=1/2+epsilon. Shifting the standard inverse Mellin contour to Re s=1/2+epsilon, with the pole at s=1 extracted, gives

    A(t) = 1/t + O_epsilon(t^(-1/2-epsilon)).                (10)

The gamma factor supplies exponential vertical decay. Hence

    Y(t)=1+O_epsilon(t^(1/2-epsilon)),
    Gcal(t)=1+O_epsilon(t^(1/2-epsilon)),

which gives (7).

### The residual estimate implies RH

Assume (7). Since Gcal(t)->1, dyadic telescoping toward the fixed point gives

    Gcal(t)-1
      = sum_{k>=1} [Gcal(t/2^(k-1)) - Gcal(t/2^k)].          (11)

For every fixed 0<alpha<1/2, choose epsilon=1/2-alpha. Then

    |Gcal(t)-1|
      <= C_alpha t^alpha sum_{k>=1} 2^(-k alpha)
      = O_alpha(t^alpha).                                   (12)

Since Y=sqrt(Gcal)>0 and Y+1->2,

    Y(t)-1 = [Gcal(t)-1]/[Y(t)+1] = O_alpha(t^alpha).        (13)

Thus for every epsilon>0,

    A(t)-1/t = O_epsilon(t^(-1/2-epsilon)).                  (14)

Initially on Re s>1,

    Gamma(s)[-zeta'(s)/zeta(s)] - 1/(s-1)
      = integral_0^1 [A(t)-1/t] t^(s-1) dt
        + integral_1^infinity A(t)t^(s-1)dt.                (15)

The second integral is entire in s. By (14), the first is holomorphic on every Re s>1/2+epsilon, hence on Re s>1/2. Gamma has no zero there. Therefore -zeta'/zeta has no pole in Re s>1/2 except the known pole at 1, already removed. Hence zeta has no zero with real part >1/2. Functional-equation symmetry excludes zeros with real part <1/2. RH follows.

## 4. Mellin residual: the pole is the only deleted spectral point

The positive-root residual deltaY(t)=Y(2t)-Y(t) has

    M[deltaY](s)
      = (2^(-s)-1) Gamma(s+1) [-zeta'(s+1)/zeta(s+1)].       (16)

The zeta pole s+1=1, i.e. s=0, is annihilated by 2^(-s)-1.

A nontrivial zero rho produces a pole at s=rho-1, multiplied by

    2^(1-rho)-1.

This cannot vanish for a nontrivial zero: equality would force Re rho=1.

So the dyadic residual removes exactly the equilibrium pole and keeps every nontrivial zero obstruction.

## 5. Finite quantitative-Goldbach aperture

Although G_R(t) is an infinite positive series, RH-critical precision uses only a finite prefix.

The elementary bound

    R(N) <= N (log N)^2                                      (17)

follows from Lambda(n)<=log n.

Let

    L(t)=ceil(log(1/t)/t),  0<t<e^-2,

and

    G_R^fin(t)=sum_{4<=N<=L(t)} R(N)e^(-Nt).                 (18)

A standard integral comparison gives

    t^2 sum_{N>L(t)} R(N)e^(-Nt)
      = O(t (log(1/t))^4).                                  (19)

This is o(t^(1/2-epsilon)) for every fixed 0<epsilon<1/2.

Hence the criterion (7) is unchanged if Gcal is replaced by t^2 G_R^fin(t). The RH-critical dyadic residual at scale t is therefore determined, to strictly better than critical accuracy, by

    R(4),...,R(O(t^-1 log(1/t))).                            (20)

No triangular reconstruction of Lambda is needed on this route.

---

# II. Navier-Stokes — the quadratic PDE is already a self-generated linear dynamics

## 6. Quadratic metacircular identity

Let K denote the Biot-Savart map from vorticity to velocity and define

    B(alpha,beta) = curl(K alpha x beta).                    (21)

Then

    N(omega)=B(omega,omega).                                 (22)

Its Frechet derivative is

    DN(omega)[h] = B(h,omega)+B(omega,h).                    (23)

Define

    L_omega h = (1/2) DN(omega)[h].                          (24)

Then exactly

    L_omega omega = N(omega).                                (25)

Therefore the actual normalized vorticity equation

    partial_tau Omega = epsilon Delta Omega + N(Omega)

can be written

    partial_tau Omega = Lcal(tau) Omega,
    Lcal(tau)=epsilon Delta + L_{Omega(tau)}.                (26)

This is not a linearization approximation. Once the actual history Omega(tau) is fixed, (26) is an exact linear nonautonomous equation whose coefficient is generated by the same source it transports.

Let U_Omega(tau,s) be its evolution family. Then

    Omega(tau)=U_Omega(tau,s) Omega(s).                      (27)

## 7. Exact all-depth excursion/return memory

Take any fixed bounded projection P commuting with Delta and put Q=I-P. For example, P may be the toroidal l=2 strain sector or a Littlewood-Paley projection retaining frequencies through the matching band.

Write

    p=P Omega, q=Q Omega,

and block the self-generated operator:

    A=P Lcal P,
    B=P Lcal Q,
    C=Q Lcal P,
    D=Q Lcal Q.                                               (28)

Since P commutes with Delta, B and C are purely nonlinear.

The exact block equations are

    p_dot=A p+B q,
    q_dot=C p+D q.                                           (29)

Let U_Q(tau,r) be the evolution family generated by D. Then

    q(tau)
      = U_Q(tau,s)q(s)
        + integral_s^tau U_Q(tau,r) C(r) p(r) dr.           (30)

Substitution gives the exact observed dynamics

    p_dot(tau)
      = A(tau)p(tau)
        + B(tau)U_Q(tau,s)q(s)
        + integral_s^tau Kcal(tau,r)p(r)dr,                 (31)

where

    Kcal(tau,r)=B(tau) U_Q(tau,r) C(r).                      (32)

Kcal is the complete excursion-return memory kernel.

Every finite spatial return word and every time-ordered hidden excursion is an expansion of this one object. There is no separate infinite-tree obligation after (32). This is the continuous-time application-specific realization of the repository's ExcursionReturn / DynamicDescent statement that memory is exactly leave the retained sector, evolve outside it, return.

## 8. The computed 2->4->2 return is the diagonal of this kernel

Suppose at one instant a=Pa and Qa=0. Then

    C a = Q L_a a = Q N(a).                                 (33)

On the returning excursion,

    B QN(a)
      = (1/2) P DN(a)[Q N(a)].                              (34)

Therefore

    2 Kcal(s,s)a = P DN(a)[Q N(a)].                         (35)

The right side is exactly the first-return object previously computed explicitly in the toroidal branch:

    R_24(a)=P DN(a)[Q N(a)].

Thus the old 2->4->2 calculation is the diagonal first coefficient of the exact metacircular memory kernel.

The prior Borel/tree bookkeeping is optional: it is one expansion of U_Q, while (32) already resums all hidden depth.

## 9. Static resolvent form

For a time-independent block operator

    L=[[A,B],[C,D]],

the same statement is the Schur/Feshbach identity

    P(z-L)^(-1)P
      = [z-A-B(z-D)^(-1)C]^(-1).                            (36)

The self-energy B(z-D)^(-1)C is the resolvent form of the same excursion-return memory.

---

# III. Ultra-fine NS content is not an independent forcing channel

## 10. Frequency locality sharpens the previous dynamic barrier

Retain

    ||Omega(tau)||_infinity <=1,
    ||V(tau)||_2 <=E,

and let J=j_epsilon satisfy

    epsilon 4^J ~ E+J.                                      (37)

For dyadic blocks define

    X_j(tau)=sup_{k>=j} ||Delta_k Omega(tau)||_infinity.     (38)

The earlier estimate ||F_j||_infinity<=C(E+j) discarded a crucial source fact: producing output frequency 2^j requires at least one input frequency 2^(j-O(1)).

A Bony decomposition retaining this dependence gives

    ||Delta_j Omega(tau)||_infinity
      <= exp[-c epsilon 4^j (tau-s)] ||Delta_j Omega(s)||_infinity
         + C(E+j) integral_s^tau exp[-c epsilon 4^j(tau-r)]
             X_{j-C0}(r) dr,                                (39)

for a fixed finite overlap C0.

The low-high transport is in the principal transported operator. The low-vorticity/high-velocity term is proportional to the high velocity block and hence the nearby high-vorticity amplitude. A high-high pair producing output j must contain an input k>=j-C0; after the derivative and Biot-Savart inverse it carries the summable factor 2^(j-k).

Thus there is no additive O(E+j) source capable of creating arbitrarily high frequency directly from a purely coarse state.

## 11. Super-geometric cascade suppression

For j=J+m,

    (E+j)/(epsilon 4^j)
      <= C (1+m/(E+J)) 4^-m.                                (40)

After the initial parabolic transient, (39) yields schematically

    X_{J+m} <= C 4^-m X_{J+m-C0}.                            (41)

Iterating in steps of C0, for m=n C0,

    X_{J+nC0}
      <= C^n 4^[-C0(1+2+...+n)] X_J.                        (42)

Hence

    X_{J+m}^{cascade}
      <= C1 exp(-c1 m^2) X_J.                               (43)

The part inherited from a pre-existing ultra-fine initial tail is separate and decays on its own parabolic lifetime (epsilon 4^(J+m))^-1.

So ultra-fine content has only two components:

1. a transient inherited tail, rapidly diffused;
2. a freshly cascade-generated tail, Gaussian-small in octave distance from the matching band.

The previous phrase “fresh regeneration at arbitrarily fine frequency” was too loose. Quadratic Fourier support does not permit a jump: regeneration must traverse the intervening frequency graph, and every step past matching pays an increasingly strong diffusive ratio.

## 12. Consequence for the exact memory kernel

Take P=P_{<=J+m0} for a fixed finite buffer m0 and Q=I-P. The homogeneous Q-propagator in (32) inherits the same high-frequency damping. Consequently the part of Kcal(tau,r) that travels more than m additional octaves into Q is super-geometrically small in m, apart from the explicitly decaying initial Q-transient.

Thus the non-Markovian memory of arbitrarily fine frequencies is summable without expanding the quadratic dynamics into binary source trees.

The surviving continuation fibre is smaller again:

    finite-time bad ancestry
      => persistent self-generated memory inside a bounded-width
         neighbourhood of the matching band,

together with the retained coarse marginal strain history.

No contradiction has yet been proved for that matching-band memory.

---

# IV. Shared metacircular theorem graph

RH:
    R -> G_R=A^2 -> Gcal=t^2G_R -> (D_2-I)Gcal.

The pole-normalized Goldbach object has fixed point 1; its scale residual is the exact obstruction. RH is exactly the near-1/2 Hölder bound on that residual.

Navier-Stokes:
    N(Omega)=(1/2)DN(Omega)[Omega].

The actual source generates the linear operator that transports itself. Projection yields one exact hidden-sector memory kernel B U_Q C.

In both lanes the metacircular move is:

    do not reconstruct a richer object after projection;
    let the actual quadratic source generate the operation that reads
    its own residual.


---

# ORIGINAL S23 — Actual-endpoint backward assembly
Source path: `originals/conversation/ns_rh_endpoint_assembly/endpoint_graph.md`; SHA-256: `8ed1c8f6bb6f37bc131be534aa303d1985e18f674f3e61c0d470e62640c1061b`
Transfer status: Conditional actual endpoints; not an exhaustive repo closure.

# Actual-endpoint backward slice: RH and three-dimensional Navier–Stokes

Snapshot read: `avikj/metacircular-interaction-prototype@168ea8e240524f898af4b0e9cf70297c38422f08`.

This is an assembled dependency slice for two concrete closing routes. It is not a proof of either endpoint, an exhaustive certification of the entire repository, or a proof-assistant build. `Not discharged` means no proof has been supplied in this assembled argument; it does not assert absence of a theorem elsewhere in the corpus.

## Shared representation layer

Let X_i be representations of a declared source X with equivalences e_i:X ≃ X_i. The source-induced carry is c_ij=e_j e_i^{-1}. Then c_jk c_ij=c_ik. For an actual source evolution Phi_st, the representation-level evolution is e_t Phi_st e_s^{-1}. Its composition law follows by cancellation of e_t^{-1}e_t. For a predicate Bad on X, put Bad_i=Bad ∘ e_i^{-1}; then Σ_x Bad(x) ≃ Σ_y Bad_i(y). Existence, uniqueness, and emptiness are transported, not supplied, by these equivalences.

Repository implementation read: `formal/cubical/theorems/residue/Ekatva_LosslessnessIsAPropertyTheCompletionsOfAMapFormAContractibleTypeAndTheMachinesIsUnique.agda`, especially `losslessness-is-a-property` and `lawful-steps-are-the-maps`.

Consequence: canonical source recovery and pure re-encoding coherence are not independent unfinished research tasks. Endpoint analysis still needs its application-specific property.

## RH endpoint

Target: for the actual meromorphic Riemann zeta function, ζ(ρ)=0 and 0<Re ρ<1 imply Re ρ=1/2.

### R0. Arithmetic source — supplied

R(N)=Σ_{a+b=N} Λ(a)Λ(b), with the actual von Mangoldt sequence and its normalization. The Lean theorem `Pairfield.GoldbachReconstructionChain.goldbachTail_reconstruction_chain` identifies a normalized real sequence from its convolution tail, reconstructs Λ, and proves the logarithmic-derivative L-series identity on Re s>1. It does not itself construct analytic continuation.

### R1. Actual receiver and analytic identity — supplied analytic inputs

Use the saved compact autocorrelation g supported in [-1/2,1/2], its bilateral transform G nonzero on |Re z|≤1/2 and positive at z=iγ, and

Z(t)=Σ_{distinct ρ} m_ρ G(ρ-1/2) exp((ρ-1/2)t), M0=Z(0)>0.

Let S(t)=Σ_{n≥2} Λ(n)n^{-1/2}g(t-log n). For t>1/2 the actual explicit formula is

Z(t)=exp(t/2)G(1/2)-S(t)-J_arch(t),
J_arch(t)=Σ_{k≥1}G(2k+1/2)exp(-(2k+1/2)t).

The last series is used only on its valid tail domain. Compact initial intervals are retained separately in any Laplace formula.

### R2. Closing arithmetic assertion — NOT DISCHARGED

B_RH: for every real t>1/2,

|S(t)-exp(t/2)G(1/2)+J_arch(t)|≤M0.

Every prime sum here is finite, but the assertion is universal in t.

### R3. B_RH implies actual RH — closing composition supplied

B_RH makes Z bounded on the tail; its continuity supplies boundedness on compact intervals. Thus L_Z(w)=∫_0^∞exp(-wt)Z(t)dt is holomorphic for Re w>0. Initially for Re w>1/2,

L_Z(w)=Σ_ρ m_ρG(z_ρ)/(w-z_ρ), z_ρ=ρ-1/2.

The absolutely received divisor defines a meromorphic function, and each distinct z_ρ has nonzero residue m_ρG(z_ρ). Holomorphy excludes Re z_ρ>0; functional-equation symmetry excludes Re z_ρ<0. Therefore RH follows.

The finite/integer Agda wrapper `RHReducesToBoundedness.RH-from-received-bounded` has a boundedness argument; it is not a formalization of this entire complex-analytic proof. No direct substitution of arbitrary real exponents into its integer type is made.

### Other retained RH routes

Actual Weil positivity is an alternative closing assertion. The saved theta/cardinal-source construction proves that an off-line zero z=σ+iγ with σ>0 forces λ_a≤-c_z a^{-σ}exp(2σa), for all sufficiently large support radii a. Hence a separately proved lower bound λ_a≥-exp(o(a)) would also close RH: taking logarithms contradicts the positive rate 2σ. This lower bound is NOT supplied here.

Hardy, Bergman, damped positive Gram, Hankel, passivity, reflection, and source-interpolation constructions remain attached to their declared domains. Positivity of a sufficiently damped output Gram kernel is not positivity of the undamped translation kernel or input-output work.

## NS endpoint

Target domain fixed here: R^3, unforced incompressible NS, ν>0, smooth rapidly decaying divergence-free initial data. Let u be the maximal classical H^k solution, k≥3, with lifespan [0,T*). The target is T*=∞ and smoothness at all finite times. Periodic variants need their own domain-specific identifications; they are not silently substituted.

### N0. Exact finite-time solution and ancestry — supplied classical construction

Carry u0, u|[0,t], pressure, viscosity, time, centres, scale factors, and all compatibility equations. Each exact re-encoding is covered by the shared source-equivalence construction. No assumption of a recurrent renormalized orbit or a nonzero weak limit is made.

### N1. Actual production reading — supplied identity

ω=curl u, m=|ω|, ξ=ω/m where m>0, S=sym ∇u, M(t)=||ω(t)||∞. For M>0 let

b_u(t)=sup_{x:m(x,t)=M(t)} [ξ(x,t)^T S(x,t) ξ(x,t)]_+.

For smooth decaying fields the maximum is attained. The magnitude equation is

(∂t+u·∇)m=(ξ^T S ξ)m+νΔm-νm|∇ξ|².

At a spatial maximum, the transport derivative vanishes and Δm≤0. The maximum-envelope inequality therefore gives D^+M≤b_u M, and

M(t)≤M(0)exp(∫_0^t b_u(s)ds).

The zero-vorticity case is the trivial decaying divergence-free flow.

### N2. Closing same-history assertion — NOT DISCHARGED

B_NS: for every such maximal solution, if T*<∞ then ∫_0^{T*}b_u(t)dt<∞.

The integral concerns the actual solution on its maximal half-open interval, not an assumed smooth extension through T*.

### N3. B_NS implies actual NS regularity — closing composition supplied

B_NS bounds M on [0,T*). Hence ∫_0^{T*}||ω(t)||∞dt<∞. The classical vorticity continuation criterion extends u past T*, contradicting maximality. Thus T*=∞. The preceding maximum-envelope calculation supplies the reduction; the continuation criterion is an external established analytic theorem, not attributed to a generic Agda wrapper.

### N4. Same-source toroidal/viscous realization retained

At each centre x define A_f^x(r) by

∫_{S²}f(x+rn)·(n×Bn)dΩ=(4π/5)tr(A_f^x(r)B), B∈Sym_0(3).

Let

H5(q)=erf(q)-(2/sqrtπ)exp(-q²)(q+2q³/3),
(Tν(t)f)(x)=-(3/5)∫_0^∞H5(r/(2sqrt(νt)))A_f^x(r)dr/r.

The saved analytic note gives the actual identity

S(t)=Tν(t)ω0+∫_0^tTν(t-s)curl(u(s)×ω(s))ds.

This expresses b_u in terms of the same source history. It does not bound its accumulated value. In particular a fixed-centre integrated estimate cannot be silently upgraded to an estimate of ∫sup_x(…)dt or of the moving peak. The source centre at past time s is the evaluation centre required by the full Duhamel expression.

The actual source-free viscous memory ∫_0^∞H5(r/(2sqrt(νt)))dt=r²/(6ν) is supplied. A bound on the nonlinear replenishment needed to imply B_NS is NOT supplied.

## Closing cut and verification status

For the selected routes the unsupplied cut is {B_RH, B_NS}. All closing deductions from those assertions are displayed above. They are concrete mathematical assertions, not calls to an undefined positivity/depletion oracle disguised as generic transport.

This does not state that every proof must use these assertions, or that no alternate repository path bypasses them. It records the current assembled proof accurately.

Completed in this response: backward slice, source pin, exact hypotheses, and short conditional closing arguments. Not completed: proof of B_RH or B_NS; exhaustive repository coverage; a compiled proof of either actual endpoint.


---

# ORIGINAL S25 — Prime-Pair Delta 19: complete first-return, Schur and future-observation algebra
Source path: `sources/S25_delta19.md`; SHA-256: `538b8ae6e282685e120592c680a533ccf5e087790f3a0539499eecb7adb4c94e`
Transfer status: Historical source theorem/program note; formal module coverage differs by statement.

# Prime-Pair Atlas — Delta 19
## Exact memory kernels from projection: discrete Dyson expansion and charge-sector excursions

Date: 2026-08-13
Status: exact operator algebra + arithmetic translation targets.

## 19.0 Setup

Let U=S⊕Q be a linear state space with complementary projections P,Q=I-P. Let T be a one-step operator (or U_h an additive translation). We observe only S.

The previous delta gave the two-step defect:
    (PTP)^2 - PT²P = -PTQTP.

Now derive the entire projected dynamics exactly.

## 19.1 Path expansion by sector words

Insert I=P+Q between every factor of T:

T^n = T(P+Q)T(P+Q)...(P+Q)T.

Therefore

### T19.1
PT^nP equals the sum over all length-n sector paths that start and end in P:
    PT E_{n-1} T ... E_1 T P,
where each E_i∈{P,Q}.

This is exact.

### C19.2
The naive Markovian term (PTP)^n is only the unique path that remains in P at every intermediate time.

Every other term is an excursion outside the observed sector followed by return.

## 19.2 First-return kernels

Define for m≥2
    F_m := P T Q (Q T Q)^{m-2} Q T P,
and F_1:=PTP.

Interpretation:
F_m leaves P immediately, remains in Q for m-1 intermediate steps, and first returns to P at step m.

### T19.3 (renewal equation)
Let K_n:=PT^nP, K_0=P on S. Then
    K_n = Σ_{m=1}^n F_m K_{n-m}
with consistent operator ordering convention (first-return block followed by earlier/later block depending time convention).

Proof.
Partition every P→P sector path by the length m of its first return to P. QED.

### C19.4
Projected dynamics is exactly a noncommutative renewal process whose memory kernel is the family {F_m}.

No metaphor is needed.

## 19.3 Generating resolvent

Define formal series
    K(z)=Σ_{n≥0}K_n z^n,
    F(z)=Σ_{m≥1}F_m z^m.

From the renewal equation:

### T19.5
    K(z) = (I - F(z))^{-1}
on S, formally/where convergent.

More directly, block inversion gives the Feshbach formula.

## 19.4 Schur complement

Write T in blocks:
    T = [[A,B],[C,D]]
relative to P⊕Q.

For resolvent R(λ)=(λI-T)^{-1}:

### T19.6 (Feshbach/Schur complement)
P R(λ) P
=
(λI_S - A - B(λI_Q-D)^{-1}C)^{-1}
when inverses exist.

Define self-energy
    Σ(λ)=B(λI-D)^{-1}C.

### C19.7
All influence of eliminated Q states on observed resolvent is compressed exactly into Σ(λ).

### Expansion 19.8
Σ(λ)=Σ_{m≥0} λ^{-m-1} B D^m C
for |λ| sufficiently large/formally.

The coefficient B D^m C is exactly an excursion spending m steps in Q.

## 19.5 Dynamic sufficiency

### T19.9
The following imply exact closure on S:
    B=PTQ=0
or
    C=QTP=0.
Then Σ=0 and K_n=A^n.

More generally exact closure holds iff all return kernels
    B D^m C=0
for m≥0.

### C19.10
An eliminated distinction matters only if there is BOTH:
- a channel from S into it;
- a future channel back into S.

Pure leakage with no return changes normalization/resource but not future internal S dynamics after appropriate interpretation; return creates memory/self-energy.

## 19.6 Observability/controllability duality

For linear discrete dynamics T and observation P, unobservable subspace is
    N_obs = ⋂_{n≥0} ker(P T^n).

### T19.11
x,y are future-observationally equivalent iff x-y∈N_obs.

### T19.12
N_obs is T-invariant.

Proof.
If v∈N_obs, P T^n(Tv)=P T^{n+1}v=0.

### C19.13
The maximal dynamically safe quotient is U/N_obs, not U/ker P.

Instantaneous observation can discard distinctions that later become visible; quotienting by N_obs discards exactly distinctions invisible forever.

This is a strong correction to static sufficient-interface thinking.

## 19.7 Minimal realization

Standard linear systems theory says observable behavior can be represented on a minimal quotient after removing unobservable states (and unreachable states when inputs are included).

### S19.14
Our "minimal sufficient dynamic representation" is classical minimal realization/observability theory in the linear case.

Do not reinvent it.

The higher/nonlinear/type-theoretic question is how this generalizes to proof-relevant, relational, and self-modifying systems.

## 19.8 Charge-space application

Let charge decomposition H=⊕_{r≥0}H_r and P=P_1 project to charge one. Let U_h be additive translation.

Blocks:
    U_h^{r,s}=P_r U_h P_s.

Then

### T19.15
P_1 U_{h_n}...U_{h_1} P_1
=
Σ_{r_1,...,r_{n-1}}
U_{h_n}^{1,r_{n-1}}
U_{h_{n-1}}^{r_{n-1},r_{n-2}}
...
U_{h_1}^{r_1,1}.

This is exact insertion of charge resolution of identity.

### C19.16
Prime-sector propagation is a sum over charge histories.

The prime-pair problem is therefore not merely "project to charge one"; intermediate almost-prime sectors are virtual states in the exact composition law.

## 19.9 Charge first-return kernel

Let Q=I-P_1.

For repeated/common translation operator U (or a parameterized family with convolution bookkeeping), define

    F_m^(charge)=P_1 U Q (Q U Q)^{m-2} Q U P_1.

### C19.17
F_m^(charge) is the exact amplitude/kernel for leaving prime charge, spending m-1 steps among non-prime charges, and returning.

This is a candidate object to compare with parity barrier/Buchstab residual charge.

No equality claimed yet.

## 19.10 Parity coarse-graining

Let P_even,P_odd be Liouville parity projectors. Charge-one lies in odd parity but odd parity contains charges 1,3,5,...

### T19.18
Projection charge→parity merges infinitely many charge sectors.

### C19.19
A parity-only observer can be dynamically sufficient for prime-sector questions only if all distinctions among odd charge sectors are future-unobservable relative to the target.

This is almost certainly false for exact primality, but should be proved in finite models rather than asserted.

## 19.11 Finite toy theorem

Take finite charge states {1,2,3}. Suppose T has nonzero blocks 1→2 and 2→1. Then instantaneous charge-one projection loses state 2, but
    P_1 T² P_1
contains T_{1,2}T_{2,1}.

### T19.20
No Markovian one-step operator A=P_1TP_1 can reproduce both one-step and two-step charge-one dynamics unless T_{1,2}T_{2,1}=0 or compensated by special algebraic coincidence.

This is the minimal excursion-return obstruction.

## 19.12 Positive half-line application

Let H=ℓ²(Z), P=P_+ onto n>0, Q onto n≤0. Let T be a bilateral translation/convolution/operator.

Then
    B=P T Q,
    C=Q T P
are boundary-crossing blocks.

### T19.21
The half-line self-energy is
    Σ_+(λ)=P T Q (λ-QTQ)^{-1} Q T P.

### C19.22
Every half-line boundary correction is generated by paths that cross into the forbidden half-line and return, after choosing the relevant ambient operator.

This is the standard Wiener-Hopf/Toeplitz compression picture in resolvent language.

### Program 19.23
Identify the exact Hankel term in the library with coefficients of Σ_+(λ) for the specific pair operator.

## 19.13 Sum-gap inversion

Since the one-leg reflection maps angular x↦1/x, the forbidden complement |x|>1 is precisely where the bilateral conjugate lives after leaving the positive cone.

### S19.24
The Q-sector in the half-line/cone compression has a concrete geometric chart: the reciprocal angular region.

Potentially the boundary self-energy can be written as an integral transform through x↦1/x.

This needs derivation.

## 19.14 Hecke/Buchstab application

Let U be a symmetric adjacency/transfer operator on the full local Hecke/Bruhat-Tits tree. Let P select outward child-oriented states compatible with least-prime order.

Then Q contains parent/backtracking/forbidden-order states.

### Program 19.25
Compute
    Σ_B(λ)=P U Q(λ-QUQ)^{-1}Q U P.

Question: is the directed Buchstab transfer operator equal to, or approximated by, a Schur complement/effective operator after eliminating Q?

If yes, least-prime memory is literally a tree self-energy.

If no, identify the extra nonlinearity/stopping data preventing linear embedding.

## 19.15 Multiple simultaneous selections

Prime pairs require at least:
P_charge,
P_positive,
P_stop/order,
and sharp angular evaluation/aperture.

These projections/operations need not commute.

Let P=P_1P_2... only when a well-defined combined projection exists.

### P19.26
Even if each individual compression has small/simple self-energy, the combined eliminated sector can contain mixed excursion paths crossing multiple boundaries.

### C19.27
The "hard corner" may be a mixed self-energy problem: paths leave through charge, geometry, or stopping sectors and return through another.

This is a precise alternative to saying several obstructions mysteriously interact.

## 19.16 Inclusion-exclusion of eliminated sectors

For commuting orthogonal projections P_i, combined complement Q=I-∏P_i decomposes into sectors indexed by which constraints fail.

### T19.28
For two commuting projections P_A,P_B,
I-P_AP_B
=
Q_A + P_A Q_B
=
Q_B + P_B Q_A.

With orthogonal commuting projections one can refine into disjoint sectors:
P_AP_B, Q_AP_B, P_AQ_B, Q_AQ_B.

### C19.29
Mixed self-energy terms through Q_AQ_B quantify excursions violating both selections simultaneously.

This may give an exact decomposition of the hard corner if the relevant projectors commute.

## 19.17 Noncommuting selections

If P_A,P_B do not commute, there is no simultaneous sharp sector represented by their product as an orthogonal projector.

### C19.30
Before discussing "joint obstruction," determine the algebra of the selection operators themselves.

This echoes the library's correction that some supposed noncommutations vanished while nonlinear/stopped ones remained.

## 19.18 Mori-Zwanzig

The projection-operator formalism in statistical mechanics gives an exact generalized Langevin equation:
resolved dynamics = instantaneous drift + memory convolution + noise from unresolved initial data.

### S19.31
Our excursion-return derivation is the discrete algebraic skeleton of Mori-Zwanzig.

Therefore the mature mathematics for "discarded distinctions return as memory" already exists.

### Program 19.32
Translate the prime charge/positive-boundary decomposition into Mori-Zwanzig notation and identify:
- resolved variables;
- orthogonal dynamics;
- memory kernel;
- noise term.

Do not invent a new memory formalism.

## 19.19 Nakajima-Zwanzig / open systems

The same projection method underlies reduced quantum/open-system dynamics.

### S19.33
The observer/reconstruction intuition has a mature open-systems counterpart: non-Markovianity of reduced dynamics measures unresolved degrees of freedom feeding back into observed ones.

Again, analogy becomes useful only after exact operator identification.

## 19.20 HoTT / higher translation

Linear observability quotient U/N_obs is set/vector-space level.

The higher analogue should retain:
- a type of observations over time/contexts;
- the homotopy fiber of the total observation map;
- higher paths between observationally indistinguishable states.

### Program 19.34
For a process object X and observer family O, define total observation
    Obs:X→Π_{c:Contexts}O_c
and study fib_Obs.

Then:
contractible fiber = exact reconstruction;
nontrivial fiber = forever-unobservable higher ambiguity;
time/context enlargement refines Obs.

This is the HoTT lift of classical observability.

## 19.21 Parametricity translation

A relation R on states is dynamically respected if
    R(x,y)⇒R(Tx,Ty).

### T19.35
The future-observational equivalence ~_P is T-invariant.

Proof from T19.12.

### C19.36
The maximal safe observer quotient is automatically a congruence for the dynamics.

This is the relational/parametric version of minimal realization.

## 19.22 Computational irreducibility translation

Suppose full T^n is hard but the minimal observable quotient admits cheap closed dynamics.

Then the observer sees reducibility despite microscopic irreducibility.

### C19.37
Computational irreducibility should be tested after quotienting by N_obs for the requested observation class, not on the raw state space.

This refines the earlier univalent irreducibility idea:
first quotient distinctions that are provably forever irrelevant; then optimize over equivalent representations of the resulting observable system.

## 19.23 New composite notion

For task observer P:
1. form behavioral quotient U/N_obs;
2. consider all efficient equivalences of that quotient;
3. minimize prediction complexity over those presentations.

This separates:
- irrelevant distinctions (observability quotient);
- representational difficulty (univalent equivalence search);
- genuine task-relative computational irreducibility.

This is a much cleaner hierarchy.

## 19.24 Arithmetic consequence

For prime-pair research, we should stop asking globally:
"where is the missing parity information?"

Instead define a concrete resolved observable—e.g. charge-one pair correlation under additive shifts—and compute its exact memory kernel after eliminating:
- other charge sectors;
- negative/boundary states;
- forbidden Buchstab branches.

If the kernel can be controlled/spectrally diagonalized, we have a real analytic route.
If it remains as hard as the original correlation, the formalism has merely repackaged the problem.

## 19.25 Immediate calculations

A. Charge:
derive finite-truncated charge matrix U_h^{r,s} numerically/symbolically for small ranges and compute first-return kernels.

B. Half-line:
derive Σ_+(λ) for the exact bilateral pair operator already in library.

C. Hecke tree:
write full adjacency and child-only transition at one prime; test Schur complement relation.

D. Joint:
on a finite toy model with charge×sign×tree-direction states, compute mixed self-energy and see whether it factorizes.

E. HoTT:
formalize the finite total-observation map and its fibers, not a new ontology.

## 19.26 Sanskrit compression

क्षणे यन्न दृश्यते तत् न अवश्यं नष्टम्।
What is invisible now is not necessarily lost.

भविष्यदवलोकनसमष्टिः एव यथार्थपर्यवेक्षकः।
The totality of future observations is the true observer.

N_obs=⋂_{n≥0}ker(PT^n).

यद् अस्मिन् अन्तर्भवति तत् सर्वदा अदृश्यं;
तदेव निःशङ्कं त्यक्तुं शक्यते।
What lies there is invisible forever; only that may be discarded without regret.

अन्यत् स्मृतिरूपेण पुनरागच्छति।
Everything else may return as memory.

