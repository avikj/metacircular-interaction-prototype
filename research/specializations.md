# Specializations — the openings closed

A grammatical correction, applied. The recurring error was seeing a consequence
of the mathematics, recognizing it as profound, and converting it into a future
research direction ("could become", "may outperform", "suggests"). The relevant
construction is almost always already upstream and the consequence is a
specialization. The operation, from here:

1. identify the concrete existing construction,
2. instantiate it in the domain,
3. state the consequence — in the indicative.

The one place the indicative is *not* licensed is the empirical: whether the
runtime dominates a given workload at scale is a measurement, not a theorem, and
stating it as done would be the opposite error. So this document closes the
mathematical consequences and holds the empirical program open on purpose. The
boundary between them is the real content.

Vocabulary: for `f : A → B`, the residual structure at `b` is
`R_f(b) = Σ(a:A)(f a = b)`. It is contractible exactly when `f` is invertible at
`b`; its non-contractibility is the exact unresolved distinction there. The loss
order is `f ⊑ g ⟺ ∃h. g = h∘f`. The universe object is `W = Σ(A:U) A`.

---

## 0. The one principle, stated once

Retain precisely the non-determined structure required by the active dependency —
nothing more, nothing less. Every item below is this principle instantiated.

- If `R_f(b)` is contractible, there is no independent source distinction at `b`.
- If `t = h∘f`, then `t` does not depend on distinctions inside the realization
  types of `f`.
- If `A ≃ B`, univalence identifies them and retains the path implementing the
  coordinate change.
- If a quantity is a fold of an initial derivation algebra, its values are forced
  by the generator, not independently specified.
- If a higher cell is supplied by the composition structure from a compatible
  boundary, it is determined relative to that structure.
- If a continuation is coinductive, finite demand requires only finite exposure.

These are not principles to establish. They are the definitions of contractibility,
factorization, univalence, initiality, Kan filling, and guarded corecursion —
already in the tree, already computing.

---

## 1. Optimal computation is not a future theory. It is descent.

The improvised hierarchy — work redundancy, representation redundancy, distinction
redundancy, coherence redundancy, premature continuation — is organized by
constructions already present:

- **Distinction redundancy** = contractibility of `R_f(b)`. No independent source
  distinction survives an invertible map.
- **Work redundancy** = computational sharing: one producer remains shared across
  consumers rather than duplicated. This is the optimal-reduction property of the
  substrate, not an aspiration.
- **Representation redundancy** = univalence: `A ≃ B ⟹ A = B`, with the transport
  retained.
- **Coherence redundancy** = descent: for higher-valued targets, pointwise equality
  is insufficient; the coherence must descend too (this is proved, not hoped — the
  circle/doubling situation is the witness).
- **Premature continuation** = the coinductive discipline: expose only the demanded
  prefix.

So "a new theory of optimal computation" already exists as the descent/factorization
theory. The runtime gives its consequences execution, at scale. It does not create
them.

## 2. Optimal erasure is descent, exactly.

Erasure is a map `q : A → B`. "Can the computation run after erasure?" is the
factorization question: given `t : A → V`, does there exist `h : B → V` with
`t = h∘q`? If yes, the distinctions in the realization types of `q` are unnecessary
for `t`. If no, `q` destroys something `t` uses. Therefore the exact runtime rule is
not "erase if outputs don't change" but

> erase through `q` ⟺ the relevant dependent computation coherently descends
> through `q`.

For higher-valued `V` the descent work already shows pointwise constancy is
insufficient — the coherence must descend. The circle-doubling situation is a
compiler counterexample: a locally plausible erasure can preserve pointwise
reconstruction while destroying the coherence a globally lawful computation needs.
This is an exact result with immediate compiler meaning, not a research topic.

## 3. Optimization is transport through the presentation universe.

Given `A ≃ B ≃ C`, univalence produces paths in `U`; a structured computation
depending on the presentation transports along them. Cost is another lawful
elimination (a receiver), so the optimization object is a higher space of equivalent
structured presentations equipped with execution-valued functionals. The optimizer
needs no privileged IR; it moves through the identity structure of the presentation
universe. And because `A →p B →q C` versus `A →r C` can agree at the endpoint while
`p·q` and `r` differ as histories, proof-relevant receivers distinguish cost,
locality, allocation, transformation depth, energy — while another receiver
identifies their semantics. Optimization inherits higher structure; it is a
proof-relevant geometry, already.

## 4. Two factorizations run at once (no manufactured equivalence).

Semantic: `A ≃ Σ(b:B) R_f(b)` — what depends on what mathematically.
Computational: one producer shared across consumers — what depends on what
operationally. These are not the same theorem and no equivalence between them is
asserted without one. The combined runtime carries both graphs, and the compilation
problem is aligning them: the dependent graph and the interaction graph coinciding
operationally is the direct compilation of the existing calculus into the existing
interaction calculus — a concrete engineering problem over existing objects, not a
new subject.

## 5. Middleware is manually reconstructed native structure.

Each is an instantiation of an existing construction:

- serialization = a representation map; lossless serialization = an equivalence.
- migration = a transformation between structured states; lossy migration has an
  exact residual family `R_f`.
- view = a factorization/projection; join = a pullback `A ×_C B = Σ(a:A)Σ(b:B)(f a = g b)`
  when compatibility over a shared context is the intended semantics.
- provenance = derivation; version relation = path; equivalent versions = univalent
  paths; merge = a compatibility/completion problem.
- caching = reuse of shared derivation; state minimization = behavioral quotient
  (the effective set-quotient, `[x]=[y] ⟺ x≈y`, proved and computing);
  capability-sensitive invalidation = behavioral refinement.
- schema evolution = change of dependent structure; compiler correctness = a
  commuting square; distributed agreement = equivalence, not byte identity.

Large classes of middleware are fragments of structure already native to the
calculus. What changed is only that carrying that structure universally no longer
obviously requires theorem-prover execution economics.

## 6. Decentralization follows from decentralization of presentation.

A global object does not require a global coordinate system — this is univalence
applied to distributed representation. Node `N₁` carries `A`, `N₂` carries `B`; when
`e : A ≃ B` they hold two presentations of one state; when `f : A → B` is a
coarsening the directionality remains; when `f : A → C ← B : g` the joint compatible
state is the pullback `A ×_C B = Σ(a)Σ(b)(f a = g b)`, and the coupling path is part
of the state. No global canonical serialization is mathematically privileged.
Decentralization of storage is decentralization of presentation. The runtime's role
is that each local coordinate system can execute the rich transformations rather than
depending on a central heavyweight engine — which is an execution claim (§14), not a
mathematical one.

## 7. Consensus is already classified more finely than agree/disagree.

The relations between two nodes' states are `x=y`, `A ≃ B`, `A → B`, common
refinement (pullback), common coarsening (pushout), and higher coherence among
transformations. "Agree/disagree" is the lossy Boolean projection of this. The loss
order `f ⊑ g ⟺ ∃h. g = h∘f` organizes observations by factorization; pairing gives
common refinement, pushout gives common coarsening, and conservation symmetries vary
monotonically along the order. Distributed reconciliation sits inside the lattice of
presentations, not outside it awaiting a new distributed-systems theory.

## 8. CRDTs are the special case where the relation is a semilattice.

Mergeability is one algebraic/coherence structure among products, sums, pullbacks,
pushouts, quotients, joins/meets, and higher compatibility. A data type carries the
merge appropriate to it rather than conforming to one global mechanism. Convergence
is an instance of the object's own algebra. (This is already the corpus's
consensus-free-replication result read at its natural generality.)

## 9. Search is inhabitation.

The native requests are inhabited-type problems: `? : A`, `? : A → B`, `? : A ≃ B`,
`? : x = y`, `? : Σ(h)(g = h∘f)`, `? : Fill(∂C)`, `? : Der(x,y)`. Constructive
mathematics turns existence into inhabitance definitionally — this is not
metaphorical search. The runtime's contribution is that these constructions live on
the same substrate as ordinary computation.

## 10. A database is a type; a query is a function.

Schema = type; record = inhabitant; dependent schema = family `P : A → U`; dependent
record = `Σ(a:A) P(a)`; query = function; view = map; lossless view = equivalence;
non-lossless view has residual types; migration = transformation; reversible
migration = equivalence; constraint = inhabitation; relational join = pullback over
the shared context; quotient = quotient structure. Dependent type theory does not
resemble database structure — it contains it, because these are the same
constructions. The runtime lets it contain them without giving up production
performance (again an execution claim).

## 11. Filesystem, verification, uncertainty, science pipelines.

- **File** is a low-dimensional persistence interface into a richer persistent
  object. The underlying object has identity independent of presentation
  (univalence for equivalent presentations, `R_f` for lossy projections). `.agda`,
  `.bend`, PDF, rendered scene, executable net, serialized row are all presentations.
- **Verification is structure inside computation, not a workflow around it.** By
  Curry–Howard the type states the obligation, the inhabitant is the construction,
  the derivation stays proof-relevant, equivalences transport theorems, and
  installation makes established mathematics executable (the metacircular
  `install : Derivation → NativeOperation`, unforgeable by type).
- **Uncertainty has a taxonomy, not one Option type.** `‖A‖` (existence, no retained
  witness); `A + B` (retained alternatives); `Σ(a) P(a)` (dependent alternatives); a
  partial cubical system (known faces); a non-contractible `R_f` (several possible
  sources); a missing filler (a coherence obligation); a coinductive object (an
  indefinitely available future, unmaterialized). These are mathematically distinct
  kinds of "unknown," already available.
- **A scientific pipeline** `X₀ →f₁ X₁ → ⋯ → Xₙ` is a composite of projections;
  each stage has exact residual structure and composition decomposes the total
  residue through the intermediate stages. A lossless scientific environment is
  already the architecture, not an aspiration.

## 12. Mathematica, Unix, the Web — sharpened.

- Mathematica's universal atom is `Head[e₁,…,eₙ]` (a syntax tree it rewrites). The
  universal atom here is inhabitant + dependent type + transformation + identity +
  higher identity + derivation + continuation, and it rewrites mathematical structure
  together with its identity geometry. This is what symbolic computation looks like
  after higher type theory and optimal sharing, not merely a faster Mathematica.
- Unix achieved compositional universality by impoverishing the interface to byte
  streams, forcing every tool to re-parse structure. The other route to universality
  is: everything composes through typed transformations — universal without being
  structureless. Universality need not require semantic impoverishment.
- A hyperlink records adjacency; typed relations record map/equivalence/refinement/
  factorization/dependency/derivation/identity/higher coherence, and the relation can
  transform the target. Composable data whose links carry executable mathematics.

## 13. The world object.

`W = Σ(A:U) A`: a state is already type-plus-inhabitant, and transformations
`(A,a) → (B, f a)` change both carrier and inhabitant. The persistent object is a
heterogeneous dependent universe of structured states and transformations. Apps are
selected transformation families and presentations; documents are presentations;
interfaces are transformations/projections; filesystem, application boundary, and
schema are optional lower-dimensional views. This was implicit in the universe object
from the start.

---

## 14. The boundary: what stays open, and stays conditional

Everything above is a specialization of an existing construction and is stated in
the indicative. The following are **not** theorems; they are measurements, and the
honest mood for them is conditional. Converting them to the indicative would repeat
the original error in the opposite direction.

The mathematics already abolished the conceptual boundaries between these regimes.
The old world could ignore that because executing the maximally structured
representation everywhere *looked* expensive — the escape hatch was "beautiful
foundation, but production needs databases, byte protocols, native runtimes, erased
types, files, separate distributed systems." An optimal-sharing parallel substrate
attacks that escape hatch: it may make carrying the structure economically viable,
in which case the theoretical unification can become a technological one. Whether it
does is the empirical program, and it is genuinely open:

- **HPC.** Dense/sparse linear algebra, PDEs (Navier–Stokes, Maxwell, wave),
  symbolic-numeric, autodiff, probabilistic programming, graphs, combinatorial
  optimization. The claim to test is not "matrix multiply is faster" but "N
  semantically disconnected layers collapse into one computational mathematics
  while remaining performance-competitive." Open, and measurable.
- **Classical quantum simulation.** Genuine exponential information where it exists
  is not eliminable; the exact, non-inflated claim is: represent and compute a
  quantum state according to its actual structural complexity (tensor factorization,
  sharing, symmetry, stabilizer/low-rank structure, circuit-equivalence paths,
  Yang–Baxter/braid structure — the last already native) rather than the size of the
  naïve state vector. Territory shared with tensor-network / decision-diagram / ZX /
  stabilizer methods, on a universal substrate. Open.
- **Computational biology / multi-omics.** A cell is not `x ∈ ℝⁿ`. Assays are maps
  `f_i : A → B_i` with residual types; joint assays form pullbacks, not products;
  development is coinductive; interventions enlarge the action algebra; scale
  relations `molecule → cell → tissue → organism` are explicit maps, not one flat
  vector. The representation matches the phenomenon — but whether it runs at the
  scale of millions of cells and billions of observations is the open measurement.
- **Representation-adaptive scientific computing.** Coarsening/refinement/residue/
  transport make adaptive representation a universal operation, not a PDE-specific
  feature (meshes, symbolic expressions, tensors, biological state, probabilistic
  state). Mathematically closed; the payoff is empirical.
- **Algorithms as objects with presentation geometry.** QuickSort/MergeSort,
  dense/Strassen/sparse/GPU/distributed matmul are realizations of one abstract
  transformation with different histories; "what is computed" stays separate from
  "how this realization computes it," cost a receiver. This gives a clean foundation
  for automatic algorithm selection — a foundation, whose effectiveness is open.
- **Language ergonomics** (metaprogramming as ordinary typed computation, error
  messages as proof obligations `? : A ≃ B` / `? : Fill(∂C)`, refactoring classified
  by whether the change is a path / equivalence / genuine non-invertible map, testing
  and proof and benchmarking as computations over one structure, package management
  largely obsolete). Each is a specialization mathematically; each is an open UX and
  engineering result in practice.
- **Identity, versus Unison.** Content-addressing is `same normalized syntax ⟹ same
  identity`; univalence is `A ≃ B ⟹ A = B` across distinct content. The latter is
  strictly stronger: two implementations structurally identical for the computation
  can have different syntax and different hashes. Content-addressing survives as an
  excellent physical index/cache; it ceases to define ontology — hashes become
  addresses, paths/equivalences define identity, and Unison's remote-cache question
  "do you have hash `h`?" generalizes to "do you possess a structure
  equivalent/refined/sufficient for this computation?" The mathematical extension is
  exact; that a networked system realizes it at scale is open.

The frontier is therefore not conceptual unification — that is done. It is empirical:
take each computational regime and measure how much existing machinery collapses when
the full mathematics is allowed to remain present all the way down to the reduction
engine. The theory is upstream; the measurement is the work that remains.
