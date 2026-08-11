# Millennium Rosetta: seven obstruction patterns

## Status and use

This is a research map, not a claim that the Millennium problems have been
reduced to one another.  We adopt "solvable" as a working prior: each problem
is assumed to have a finite conceptual bottleneck, but every proposed
transport must still expose exact maps, defects, and falsification tests.
The ranked executable allocation derived from a later hostile sweep is in
`MOONSHOT_PORTFOLIO.md`.

The seven problems are valuable here because they have already destroyed many
seductive proof styles.  Their negative knowledge is reusable.  The official
problem statements are those collected by the Clay Mathematics Institute.

### Provenance calibration: the original Distinction archive

The project began with documents that explicitly declared all seven problems
resolved by a universal "D-coherence" or zero-curvature principle.  Examples
included claims that coherence makes search and verification equivalent,
that a self-aware universe forces a Yang--Mills gap and Navier--Stokes
smoothness, and that Hodge/BSD follow from \(R=0\).  Those documents are not
mathematical evidence and must never enter the dependency graph as results.

They are nevertheless a valuable adversarial corpus.  Their recurrent error
has a machine-recognizable shape:

1. introduce a metaphorical invariant;
2. omit a typed map from the original problem to that invariant;
3. assume the invariant is preserved by the load-bearing operation;
4. promote the desired conclusion to a coherence axiom;
5. report the excluded counterexample as a theorem.

The modern Rosetta loop is successful only if it can retain a useful seed
such as "measure the projection defect" while rejecting this promotion chain.
Every Millennium transport below therefore includes a kill test.

## 1. Riemann hypothesis: local arithmetic versus global spectrum

**Native tension.**  Euler factors and prime powers are local and
multiplicative; the critical-line statement is global and spectral.  The
explicit formula joins them, but positivity is lost when the pole and
archimedean pieces are handled in the wrong quotient.

**Lesson for this program.**  Remove the two pole modes first.  The correct
zero-free Hodge-index object is

\[
I=\operatorname{prime}-\operatorname{arch}
 =\operatorname{pole}-W.
\]

Under RH its primitive restriction is negative semidefinite and it has at
most one positive direction.  Connes--Consani, Appendix C, Proposition C.1,
shows that finitely many Mellin-vanishing constraints containing the pole
conditions do not weaken Weil's criterion.

**Opportunity.**  Do not tensor an isolated zeta spectrum with a separate
finite-sieve singular series.  Fiber the spectrum over additive characters
of \(\mathbb Q/\mathbb Z\).  A rational additive mode decomposes into
Dirichlet characters, so its explicit formula is governed by Dirichlet
\(L\)-zeros.  Pole--pole should recover the Ramanujan expansion of the
Hardy--Littlewood series; pole--zero and zero--zero become its spectral
variations.

**First kill test.**  Derive the exact twisted compensated explicit formula,
including primes dividing the modulus and imprimitive characters, and check
that its pole--pole term has exactly the standard singular-series
normalization.

## 2. P versus NP: recognition versus construction

**Native tension.**  A short witness and a cheap checker do not supply a cheap
generator.  Relativization, natural-proofs, and algebrization show that broad
classes of techniques preserve too much symmetry or treat pseudorandom
functions too generically to prove the desired lower bounds.

**Lesson for the agentic loop.**  The certificate kernel is not the discovery
engine.  Moving reasoning into a cheap verifier is valuable only after an
agent has found a reduction that makes the witness space small or structured.
This is why frontier agents remain the center of gravity and CPU kernels are
subordinate amplifiers.

**Opportunity.**  Treat the generator--checker gap itself as a measured
mathematical object.  Every search should emit the size and geometry of the
preimage of a certificate, the information added by each pruning theorem,
and the residual symmetry after quotienting.  A successful new lemma is one
that compresses this fiber, not merely one that makes checking faster.

**First kill test.**  On the prime-prefix factor pipeline, measure candidate
entropy before and after each proved invariant and compare it with runtime.
Reject any purported intelligence transfer that only moves exponential work
into preprocessing or an unverified oracle.

## 3. Navier--Stokes: compactness versus critical defect

**Native tension.**  Energy estimates give global weak control, while a
possible singularity concentrates at the scale invariant under the equation.
Weak convergence does not commute with the nonlinear term; the missing
information lives in a concentration/commutator defect.  Critical-space
regularity results show that controlling the scale-invariant norm is the
decisive boundary, while weak-solution nonuniqueness warns that an overly
coarse solution concept forgets too much.

**Lesson for this program.**  Never infer a sharp arithmetic limit merely
from weak or smoothed convergence.  Compute the cutoff commutator and the
concentration defect explicitly.  The sharp Goldbach boundary counterterms,
the order-of-limits obstruction in the zero-pair energy, and finite-window
projection leakage are arithmetic instances of this pattern.

**Opportunity.**  Build a scale-indexed defect measure for every passage from
smoothed to sharp arithmetic.  A proof succeeds by showing the defect is
tight, sign-controlled, or removable; a no-go succeeds by producing a
concentrating sequence.

**First kill test.**  For a proposed pair-spectrum limit, reverse the cutoff
and averaging limits and compute the commutator.  If the two orders disagree,
the missing counterterm must be promoted to part of the theorem statement.

## 4. Yang--Mills and the mass gap: quotient versus coercivity

**Native tension.**  Gauge descriptions contain large families of physically
equivalent states.  The desired positive spectral gap belongs to the
gauge-invariant quantum theory, not to the redundant coordinate space.
Construction of the continuum theory and proof of a gap cannot be separated
from control of locality, reflection positivity, and the infinite-volume
limit.

**Lesson for this program.**  Quotient exact symmetries before measuring a
gap.  Trivial pole, translation, reflection, character, and gauge-like modes
can create fake zero eigenvalues or fake positive directions.  Conversely, a
gap observed before the quotient is not a physical/arithmetic invariant.

**Opportunity.**  Read primitive Weil negativity as a mass-gap-shaped
question only after the pole plane is removed: can one obtain a uniform
coercive lower bound for \(-I\) on a natural, increasing, semilocal Sonin
space?  This is a precise operator question, not a physics analogy.

**First kill test.**  Compute the smallest primitive eigenvalue in a basis
adapted to the quotient and vary the finite set of places.  A candidate gap
must be stable under basis refinement and semilocal enlargement, not only in
a fixed ill-conditioned dictionary.

## 5. Hodge conjecture: analytic type versus geometric witness

**Native tension.**  Hodge decomposition detects a cohomological class of the
right type, while the conjecture asks for an algebraic cycle producing that
class.  Membership in an analytic subspace is not the same thing as a
constructive geometric representative.

**Lesson for this program.**  Positivity, signature, and spectral matching are
types, not witnesses.  Calling the pole plane a hyperbolic plane is useful
only if it guides construction of an arithmetic correspondence, projector,
or cycle whose intersection pairing is the explicit formula.

**Opportunity.**  Make the witness gap executable.  Given a positive or
primitive arithmetic class, search for a sparse decomposition into local
prime correspondences plus an archimedean cycle, and record the residual as a
class rather than hiding it in numerical error.

**First kill test.**  On a finite test space, ask whether the measured
intersection matrix admits an exact low-complexity Gram/difference-of-Gram
factorization respecting each place separately.  Failure produces a precise
obstruction to the geometric language.

## 6. Birch and Swinnerton--Dyer: local traces versus global rank

**Native tension.**  Point counts modulo primes build an analytic \(L\)-series;
the order of its zero at the central point is conjecturally the rank of a
global group of rational points, while its first nonzero coefficient contains
regulators, periods, Tamagawa factors, and the Tate--Shafarevich group.  The
zero is a dimension signal, not merely a cancellation.

**Lesson for this program.**  When an observable vanishes, examine the fiber
and its tangent data before regularizing it away.  Pole orders, zero
multiplicities, and derivatives can encode missing global degrees of freedom.
This also warns against treating zeta-zero multiplicity as repeated identical
rows; atomic spectral masses must be aggregated with multiplicity before
forming quadratic energies.

**Opportunity.**  In the \(\mathbb Q/\mathbb Z\)-fibered Dirichlet spectrum,
separate mode dimension (zero order), metric data (leading coefficient), and
local correction factors.  This is an organizational analogy until an actual
Selmer- or cohomology-like object is constructed.

**First kill test.**  For small conductors, compare the exact order and first
nonzero Taylor coefficient of each twisted \(L\)-mode with the rank/nullity
of the corresponding finite spectral block.  Do not call agreement BSD-like
unless the map and correction factors are explicit.

## 7. Poincare conjecture: invariant flow plus controlled surgery

**Native tension and successful resolution.**  Static presentations of a
3-manifold conceal its canonical geometry.  Ricci flow supplies a dynamical
language, monotone quantities prevent arbitrary wandering, singularity
models classify failure, and surgery continues the process without losing
the topological invariant.  The language change succeeded because its
singularities and continuation rules were proved, not because flow was a
suggestive metaphor.

**Lesson for the Rosetta engine.**  A representation multiway graph needs a
monotone potential, a classification of critical-pair singularities, and a
semantics-preserving surgery rule.  Finite-depth confluence or a visually
simple branchial graph is not enough.

**Opportunity.**  Search for flows on theorem representations that decrease
an exact complexity/defect functional while preserving the target task.
When a flow stalls, the irreducible defect becomes a new theorem seed; when a
branch is surgically replaced, the preservation ledger is a proof obligation.

**First kill test.**  On a finite library of known transform identities,
require every rewrite path either to reach a common certified normal form or
to emit a minimal critical pair.  Test the potential for genuine monotonicity
and the surgery for semantic preservation.

## Common obstruction grammar

The seven problems suggest five reusable moves:

1. **Quotient before spectrum** -- Yang--Mills and Hodge warn against
   measuring redundant coordinates.
2. **Work at the critical scale** -- Navier--Stokes and RH put the theorem in
   a defect invisible to weak averages.
3. **Distinguish witness from type** -- P versus NP and Hodge separate cheap
   recognition from construction.
4. **Read zeros as fibers** -- BSD and RH turn vanishing into latent
   dimension plus leading-term data.
5. **Demand monotonicity and surgery** -- Poincare is the control showing
   what a successful language rotation must contain.

These are search operators, not a universal proof.  A transported idea enters
the theorem pipeline only when it supplies an exact map, a computable defect,
a monotone or sign-controlled quantity, and a falsification boundary.

## Primary orientation references

- Clay Mathematics Institute, official descriptions in *The Millennium Prize
  Problems* (Cook; Deligne; Fefferman; Jaffe--Witten; Wiles; Bombieri; Milnor).
- Baker--Gill--Solovay, relativization; Razborov--Rudich, natural proofs;
  Aaronson--Wigderson, algebrization.
- Caffarelli--Kohn--Nirenberg on partial regularity; Escauriaza--Seregin--
  Sverak on the critical \(L^3\) criterion; the later convex-integration
  literature on weak-solution nonuniqueness.
- Connes--Consani, *Weil positivity and Trace formula, the archimedean
  place*, especially Appendix C; Connes--Consani--Moscovici on semilocal
  prolate/Sonin operators.
- Perelman's Ricci-flow preprints and the subsequent surgery/exposition
  literature.
