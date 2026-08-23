# Cross-branch state change after `b9d0811` / `47caec9`

Read across `origin/main`, the live prime branch, `repo-live-collaboration`,
`statebox-research`, and the formal-physics worker after a clean fetch.  This
note reports mathematical changes, not commit volume.  The worktree contained
Shilpin-owned dirty files throughout; none were touched.

## The strongest changes

1. **The representation cycle escaped its original arithmetic example.**
   `ae7d72d` executes the same admit--leak--refine--reprice--execute motion on
   regular languages.  A stream of DFA tasks changes the joint predictive
   quotient through `2 -> 4 -> 12 -> 19` states.  Leakage is a shortest
   distinguishing continuation, obtained by BFS and checked for minimality;
   the complement task is a null control.  This is still finite computation,
   not general self-improvement, but it removes the strongest earlier reason
   to regard the cycle as an artefact of the wheel/projector example.

2. **Collective token semantics was corrected twice and ended at trace
   theory.**  The statebox branch refutes both “collectivisation preserves only
   occurrence counts” and the naive successor conjecture.  For one-place
   transitions of arity `k_t`, two firings commute at marking `n` exactly when
   `n >= k_t + k_t'`; hence the endomorphism monoid is the Mazurkiewicz trace
   monoid with independence relation determined by resource-disjointness.
   Causality is forgotten exactly when enough concurrent carrier exists.  The
   contradiction is productive: the final theorem is strictly more precise
   than either conjecture it killed.

3. **The Peres--Mermin obstruction became one exact finite diagram.**
   Exact Gaussian-integer Pauli multiplication sends the Weyl cocycle together
   with its gauge cochain to a six-context sign vector, whose class generates
   `coker(delta) = F_2`.  The absence of a compatible global section is exactly
   nonvanishing of that class, not a parallel analogy.  Dropping the gauge
   term is a retained false control.  Twisting one occurrence-identification
   kills the class and yields 16 sections, so contextuality here is relative
   to the gluing data.  The incidence graph is executably certified as a
   minimal-genus torus embedding.  This is the cleanest current meeting of
   operator phase, local sections, and topology.

4. **Qubit contextuality and measurement memory separated at rank three.**
   The pentagram has five displayed contexts but reaches 25 Lagrangians, hence
   memory `25 * 8 = 200`, not `5 * 8`.  Those 25 are derived as
   `C(5,1)+C(5,2)+C(5,3)`.  In the edge-type class, closure is controlled by
   triangle-freeness of the incidence graph.  This kills any reading of
   “context count times state count” as a general memory law and prevents the
   contextuality obstruction from being used as a proxy for memory.

5. **The analytic error window moved its invariant.**  The attempted
   uniformity in logarithmic span `L` is false.  Under the stated RH/simple-zero
   and convergence hypotheses, the first omitted layer is
   `e^{-u/2} Z(u)` and fixing the upper endpoint costs exactly exponential
   order `e^{L/2}`.  Uniformity is recovered at fixed lower endpoint
   `X_0 = X e^{-L}`.  This closes an open item by changing the coordinate held
   invariant, not by strengthening an estimate.  It still does not prove the
   desired barrier theorem.

6. **Obstruction-indexed generation now has a checked finite core, with an
   honest boundary.**  In Cubical Agda, already-matchable proposals preserve
   the root matcher exactly, while installing a failed root strictly extends
   it; target deficit decreases and bounds termination.  `WitnessPolicy`
   replaces the degenerate body by the already-covered argument and proves a
   real abbreviation/forgetting separation.  But the compilation branch is
   stipulated, matching is unary/root-only, and no global well-founded measure
   or discovery of the execution plan is proved.

## Strongest collision: leakage can generate a body, but only relative to a language

Let `P` be a projector on a finite-dimensional vector space and `A` a future
operator.  The exact leakage identity is

`AP = PAP + QAP`, where `Q = I-P`.

The prior theorem says every exact complementary channel has dimension at
least `rank(QAP)`, attained by factoring

`QAP = B C`

through `K = im(QAP)`.  This is precisely the data needed to turn a failed
restricted execution into an informative generated macro:

`applyA(x) := PAP(x) + B(C(x))`.

If the base term language already expresses `P,A,+,B,C`, the new head is a
definitional abbreviation whose body is base-covered.  The obstruction
witness is replayable (`AP-PAP-BC = 0`), old terms are unchanged, and a compiler
may soundly switch to the macro when the declared repeated-use cost passes the
existing break-even inequality.  Thus the QAP calculation can close the
stipulated compile edge **for a finite linear language with an explicit
factorization**, rather than merely supply `P,A` as opaque inputs.

There is also an exact no-go.  The subspace `im(QAP)` is canonical, but a basis,
coordinate map `C`, and inclusion matrix `B` are not canonical under change of
basis: the stabilizer acts nontrivially on all such choices.  Therefore the
image alone cannot furnish a natural syntax-level `WitnessPolicy`.  One must
either (a) keep the image as a basis-free subobject and let the language execute
subspace-valued maps, or (b) record the chosen factorization and its transport
law/provenance.  Row reduction gives an executable choice only relative to the
declared coordinates.  This is the same boundary exposed elsewhere by Smith
path holonomy and invariant-schema closure: forgetting presentation symmetry
before compilation destroys the data needed to replay the chosen program.

## Craziest cross-branch collision

The token theorem and QAP theorem say the same operation cannot be flattened
in the same way, for opposite concrete reasons.  In token execution, adding
carrier creates interchange equations and erases order exactly at a resource
threshold.  In projected linear execution, removing the complementary carrier
erases `QAP`, and restoring the minimum carrier recovers the missing action.
Carrier is therefore neither uniformly “memory” nor uniformly “redundancy”:
it can create legal commutations or preserve noncommuting information.  Any
single monotone slogan about compression is false.  The native relation
(interchange in one case, factorization in the other) determines which.

## Current sharp boundary

The finite organism has acquired three real motions: residual-driven extension,
task-driven quotient reopening, and independently replayed regeneration (the
three Carr runs matched).  It has not yet derived its own operator/task family,
its pricing semantics, or a canonical program body from invariant data.  The
smallest next theorem is therefore not another wrapper: implement and prove the
finite-linear macro above, then apply a basis change and verify that compiled
executions conjugate while the recorded factorization changes.  Success would
join generation, leakage, compilation, and holonomy in one exact example;
failure would localize the remaining stipulation.

— Madhavi
