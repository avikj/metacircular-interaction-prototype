# Causal memory and the two meanings of spacetime

## 1. The exact common object: a process with a cut

Take finite sets of past interventions (H) and future observations (F).
Let

\[
T:H\times F\longrightarrow K
\]

be the process table, with (K=\mathbb Q_{\geq0}) for exact classical
weights, (K=\mathbb C) for amplitudes, or a suitable operator space for a
quantum process.  A cut asks for a boundary (B) and a factorization

\[
T(h,f)=\sum_{b=1}^{d} A(h,b)B(b,f).                 \tag{1}
\]

The boundary is not an object placed between two already constituted worlds.
It is the datum through which composition across the cut is possible.

### Linear cut theorem

Over a field, the least possible (d) in (1) is

\[
\boxed{d=\operatorname{rank}T}.                     \tag{2}
\]

**Proof.** Any factorization (T=AB) through (K^d) has rank at most (d).
A rank factorization obtained from bases of the row and column spaces realizes
(d=\operatorname{rank}T). ∎

This one theorem has several readings:

- a **temporal cut** reads (d) as linear information that must persist from
  past to future;
- a **spatial cut** reads (d) as bond/interface dimension required to
  compose two regions;
- an **observer cut** reads rows as future response profiles and identifies
  histories that induce the same profile;
- a **tensor-network cut** reads (2) as the minimum exact bond dimension for
  that bipartition.

These are exact translations only at the underlying linear-factorization
level.  Their admissible factorizations differ.  A classical latent variable
requires nonnegative factors, so its true minimum is nonnegative rank, which
can exceed ordinary rank.  A quantum realization requires positive operators,
complete positivity, normalization, and causal constraints.  A physical
spacetime requires much more than any factorization rank.

`machinery/causal_memory.py` computes the rational cut rank exactly.  It also
computes the predictive quotient

\[
h\sim h'\quad\Longleftrightarrow\quad
P(F\mid h)=P(F\mid h'),                             \tag{3}
\]

the finite causal-state construction of computational mechanics.  The state
at a temporal boundary is therefore not necessarily the machine's internal
register.  It is the least retained distinction sufficient for the admitted
future questions.

## 2. Memory is a failure of factorization, relative to interventions

For a nonzero classical joint table, rank one is equivalent to

\[
P(H,F)=P(H)P(F),                                    \tag{4}
\]

so rank greater than one is a cross-cut dependence witness.  With an explicit
present variable (M), Markovity is the slice-wise statement

\[
P(H,F\mid M=m)=P(H\mid M=m)P(F\mid M=m)             \tag{5}
\]

for every live (m).  Each conditional matrix must have rank one.

The important negative control is tiny.  The tables

\[
T_{\rm corr}=\begin{pmatrix}1&0\\0&1\end{pmatrix},
\qquad
T_{\rm indep}=\begin{pmatrix}1&1\\1&1\end{pmatrix} \tag{6}
\]

have identical normalized one-time marginals, but ranks two and one.  No list
of single-time states or channels determines temporal memory.  Multi-time
intervention statistics are load-bearing.

Quantum mechanics strengthens this warning.  A process tensor/quantum comb
is a multilinear map from a sequence of inserted instruments to outcome
statistics, represented by a positive Choi operator with causal normalization
conditions.  Pollock et al.'s operational Markov condition and Taranto et
al.'s quantum Markov-order results show that quantum memory is
instrument-relative: outside the Markovian case there is no nontrivial finite
Markov order valid for every possible instrument family.  Thus “the system's
memory length” is generally not an observer-free scalar.

Primary sources: [quantum combs and the link product](https://arxiv.org/abs/0904.4483),
[operational quantum Markov condition](https://researchmgt.monash.edu/ws/portalfiles/portal/249230452/240666479_oa.pdf),
and [instrument-specific quantum Markov order](https://arxiv.org/abs/1805.11341).

## 3. Four notions that must not be collapsed

### Logical time

A computation supplies an order of composable transformations.  Sequential
depth, circuit depth, event-poset height, and number of rewrite steps are
different choices even before physics.  Independent events can commute, so a
partial order is more intrinsic than a chosen schedule.

### Thermodynamic time

Logical irreversibility is merging: several logical predecessors acquire one
successor.  Bennett's reversible computation shows that logical progress need
not itself dissipate (kT\log2) per step; the thermodynamic cost attaches to
erasure/reset under the physical assumptions of Landauer's principle.  A
reversible computer can have a perfectly definite computational order while
the computation alone supplies no thermodynamic arrow.

Primary sources: [Bennett's thermodynamics of computation review](https://research.ibm.com/publications/the-thermodynamics-of-computation-a-review)
and [reversible time/space tradeoffs](https://research.ibm.com/publications/timespace-trade-offs-for-reversible-computation).

### Causal time

A physical causal order says which events can influence which others.  In a
Lorentzian spacetime the causal order carries enormous geometric information;
causal-set theory investigates locally finite partial orders as fundamental
kinematics.  But an arbitrary computation DAG is not thereby a spacetime.  It
lacks, unless separately supplied or derived, volume calibration, manifoldlike
local neighborhoods, dimension, Lorentz symmetry, metric scale, matter
dynamics, amplitudes, and an empirical observable map.

Primary source: [Bombelli–Lee–Meyer–Sorkin, *Space-Time as a Causal Set*](https://doi.org/10.1103/PhysRevLett.59.521).

### Geometric space

In computation, “space” usually counts simultaneously retained registers or
tape cells.  In tensor networks, graph cuts count bonds.  In relativity,
spatial distance is induced on spacelike slices of a Lorentzian geometry, and
the slicing is not absolute.  These notions can constrain one another in a
physical implementation but are not definitionally identical.

The honest bridge is locality plus cut structure.  A local circuit has a
subsystem tensor factorization, an interaction graph, and propagation bounds.
A tensor network can encode entanglement so that cut capacity tracks entropy.
In holographic settings, special quantum states and dynamics support precise
geometry/entanglement relations; Van Raamsdonk's work argues that reducing
entanglement can disconnect semiclassical bulk regions.  This is powerful and
theory-specific, not a theorem that every entanglement graph is physical space.

Primary source: [Van Raamsdonk, *Building up spacetime with quantum entanglement*](https://arxiv.org/abs/1005.3035).

## 4. Computational spacetime versus physical spacetime

The strongest common diagram is

```text
local events + admissible composition
              |
              v
         causal partial order
              |
       choose a cut / boundary
              |
              v
  retained interface + residual correlations
```

For a computation this can already be complete: the event order and boundary
state determine how execution composes.  For physics it is only kinematics.
One must additionally explain why the order and event density approximate a
Lorentzian manifold, why quantum amplitudes obey the observed dynamics, how
rods and clocks arise, and which operational records define the geometry.

Therefore:

\[
\boxed{\text{computational spacetime is execution geometry; physical
spacetime is operational causal geometry with dynamics.}}                 \tag{7}
\]

Neither contains the other without a realization map.  A physical system can
implement many computational geometries.  One abstract computation can have
many physical embeddings with different energy, duration, distance, and
noise.  The map between them is itself a mathematical/experimental object.

## 5. The next exact construction

The cut-rank kernel suggests a **typed boundary spectrum**.  For every allowed
cut (C), retain not one number but

\[
(r_{\mathbb Q}(C),,r_+(C),,r_{\rm CP}(C),,I(C)),                       \tag{8}
\]

where ordinary rank measures linear factorization, nonnegative rank measures
classical latent-state cost, a positive/CP factorization invariant measures
quantum memory cost, and (I(C)) records which intervention family defined
the table.  Across nested cuts these data form a geometry of required
boundaries.  Temporal cuts expose memory flow; spatial cuts expose interface
capacity; failures of equality between the ranks expose precisely which kind
of realization adds structure.

The repo can compute the first coordinate now.  The next valuable theorem is
not “information is spacetime.”  It is a comparison theorem or strict
separation among these cut spectra on explicit processes, followed by a gluing
law under process composition.

**Quantum-coordinate correction (2026-08-13).** For a causally normalized
positive multi-time process, the relevant mature object is global quantum-comb
memory cost, not an unnamed cutwise `r_CP`. Independent per-step memory minima
can be mutually incompatible. See `QUANTUM_COMB_MEMORY_ROSETTA`; the present
classical tables do not yet form a quantum comb.

### 5.1 First strict classical separation

The smallest dimensions in which the first two coordinates differ are
realized by

\[
S=\begin{pmatrix}0&0&1&1\\1&0&0&1\\1&1&0&0\\0&1&1&0\end{pmatrix}. \tag{9}
\]

**Theorem.** `rank(S)=3` and `rank_+(S)=4`.

**Proof.** `row_1+row_3=row_2+row_4`, while the first-three-rows,
first-three-columns minor has determinant one. For the nonnegative lower bound,
select `(1,3),(2,4),(3,1),(4,2)`. Between every two selected positive entries,
at least one cross entry vanishes. A nonnegative rank-one summand positive at
both selections would make both cross entries positive, so no summand covers
two selections. Four summands are necessary and the four-row decomposition is
an upper bound. `square`

This is dimension-minimal. Nonnegative rank equals ordinary rank through rank
two ([Cohen--Rothblum 1993, Proposition 3.1](https://doi.org/10.1016/0024-3795(93)90224-C)). If one matrix dimension is at most three, a strict
example must therefore have ordinary rank three; the identity-times-matrix
factorization on the three-entry side is already a nonnegative factorization
of size three. Both dimensions must be at least four. The executable fooling-
set checker validates the explicit lower-bound certificate, not nonnegative
rank in general.

The gluing theorem in Section 7 supplies the exact ordinary-rank composition
law and its obstruction. Its aligned/orthogonal control also proves that even
the pair `(rank,rank_+)` of each component cannot determine the composite pair:
all component matrices there have `(1,1)`, while the composites have `(1,1)`
and `(0,0)`. Typed scalar spectra price boundaries but forget how their
subspaces and cones meet; compositional data must retain an identified
intermediate boundary or factor maps.

## 6. Prosthetic mathematical networks

Martin Fussenegger's mammalian synthetic-biology program supplies a concrete
engineering correction to the abstract process picture.  Its characteristic
object is not a detached logic gate but a **prosthetic gene network** embedded
in a living host: engineered cells sense endogenous disease signals, process
closed-loop control logic, secrete a therapeutic response, and encounter the
host state changed by that response.  The response is expressed in the same
biochemical world that supplies the next input.

The corresponding mathematical circuit is

\[
\text{encounter}
\to\text{distinction pressure}
\to\text{new exact observable}
\to\text{proved transformation}
\to\text{compiled capability}
\to\text{changed encounter}.                       \tag{9}
\]

This is not a biological metaphor for repository workflow.  It is an
engineering constraint on where computation lives.  The machine should implant
small exact circuits into mathematics' native metabolism—recursion,
factorization, quotient, duality, proof, counterexample—rather than reproduce
mathematics inside an external agent bureaucracy.  A useful circuit must have:

1. a mathematically native sensor;
2. an explicit response map;
3. a feedback path through which the response changes future inputs;
4. a homeostatic or directional variable declared independently of the sensor;
5. a boundary witness when the declared input/output vocabulary fails.

The zero-digit divisibility result is a minimal existing instance.  Compression
from the raw modulus failed; the dynamics (r\mapsto2r\bmod m) then generated
its own useful coordinates—transient contraction depth and stable-image size—
which exposed the law.  The response did not merely store an answer: it changed
the representation available to the next computation.

The missing operation remains sharply located.  Current machinery can choose
among declared probes and preserve an out-of-model outcome as formation
pressure.  It cannot yet construct a justified new probe vocabulary from that
pressure.  In Fussenegger's systems the designer supplies receptor and response
modules externally.  The stronger mathematical target is a circuit that can
form a new native sensor while preserving every old capability through an
explicit revision ledger.  Formation pressure authorizes that search; it does
not determine or validate the new sensor.

Primary descriptions: [Fussenegger's ETH profile](https://bsse.ethz.ch/people/detail-person.martin-fussenegger.html)
and [the group's prosthetic-network program](https://bsse.ethz.ch/research/research-groups/biotechnology-and-bioengineering.html).

## 7. Exact gluing law and its alignment defect

Let a process from past histories to an intermediate boundary be represented
by (A:K^M\to K^H), and a process from that boundary to future observations
by (B:K^F\to K^M).  Gluing contracts the shared boundary:

\[
T=AB:K^F\longrightarrow K^H.                       \tag{10}
\]

### Theorem 7.1 (cut-rank gluing defect)

Over a field,

\[
\boxed{
\operatorname{rank}(AB)
=\operatorname{rank}(B)
-\dim(\operatorname{im}B\cap\ker A).}
                                                               \tag{11}
\]

Equivalently,

\[
\operatorname{rank}(AB)
=\operatorname{rank}(A)
-\dim(\operatorname{row}A\cap\ker B^{\mathsf T}).              \tag{12}
\]

**Proof.** Restrict (A) to (operatorname{im}B). Its image is
(operatorname{im}(AB)) and its kernel is
(operatorname{im}B\cap\ker A). Rank--nullity gives (11). Applying
(11) to (B^{\mathsf T}A^{\mathsf T}) gives (12). ∎

**Machine-checked status (2026-08-14).**
`formal/pairfield/Pairfield/ProcessCutRankAdapter.lean`, imported by the Lean
root, defines the restriction of (A) to `range B`, checks its range and
kernel identifications, and proves (11) in additive and subtraction forms.
It then applies the same theorem to (B^{\mathsf T},A^{\mathsf T}), using
Mathlib's transpose-product and transpose-rank theorems, to prove (12).
Focused and aggregate builds pass; the adapter deliberately exports no
nonnegative-rank, completely-positive, or physical-geometric consequence.

Thus cut rank has an exact gluing law, but it is not a law on the two scalar
ranks alone.  The missing datum is the relative position of what one side
transmits and what the other side annihilates.  In site language, this is an
alignment obstruction at the overlap, not merely a size of either chart.

### Strict finite control

Take nonnegative matrices

\[
A=\begin{pmatrix}1&0\\0&0\end{pmatrix},\qquad
B_\parallel=\begin{pmatrix}1&0\\0&0\end{pmatrix},\qquad
B_\perp=\begin{pmatrix}0&0\\0&1\end{pmatrix}.                  \tag{13}
\]

All three have rank one.  Nevertheless

\[
\operatorname{rank}(AB_\parallel)=1,
\qquad
\operatorname{rank}(AB_\perp)=0.                               \tag{14}
\]

The first boundary image is aligned with the direction retained by (A); the
second lies wholly in its kernel. Consequently even equal component cut
spectra do not determine the glued execution geometry.  One must retain an
incidence/alignment datum or the actual factor maps.

This is also a strict limit on physical interpretation. The matrices in (13)
have no supplied event density, metric scale, Lorentzian neighborhood,
dynamics, or empirical realization map. The theorem governs linear execution
composition. It neither produces nor distinguishes physical geometries.

## Rigor boundary

Proved here: the linear cut theorem; rank-one independence for nonzero
classical tables; exact finite controls (6); predictive-profile quotient
computation; and the cut-rank gluing defect (11)--(12), a standard
rank--nullity identity specialized to process contraction.  Equations
(11)--(12) additionally have the checked Lean adapter cited in §7.

Cited established frameworks: causal states, reversible computation, quantum
combs/process tensors, quantum Markov order, causal-set kinematics.

Research synthesis: the typed boundary spectrum and the statement that the
same cut operation supplies a common skeleton for computational memory and
spatial interface; the prosthetic-network constraint (9) is a proposed design
principle, not an implemented autonomous formation theorem.  No claim is made that computation generates our physical
spacetime, that entanglement universally equals geometry, or that causal order
alone yields gravity.
