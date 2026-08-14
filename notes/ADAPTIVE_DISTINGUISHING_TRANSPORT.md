# Adaptive distinguishing transport: the free current output is a fibre split

**Status.** Lean-checked timing and residual-language adapter.  The extremal
quadratic bound discussed in §4 is classical prior art and is **not** proved
here.  No novelty is claimed.

## 1. Two conventions that must not be identified silently

The repository's finite experiment tree observes a Moore-style state output.
For a state `x`, its native trace is

\[
  q(x)\ ::\ \operatorname{responses}(T,x).
\]

The current output `q(x)` is available before the first action and costs zero.
Classical adaptive distinguishing sequences are usually stated for a Mealy
machine: an input is applied and then its transition output chooses the next
branch.  Consequently the post-action response tree need not distinguish two
states whose current Moore outputs already differ.

Define `IdentifiesInitialFibers(T)` by

\[
 q(x)=q(y),\qquad
 \operatorname{responses}(T,x)=\operatorname{responses}(T,y)
 \quad\Longrightarrow\quad x=y.
\]

Lean checks the exact equivalence

\[
  \operatorname{Injective}(x\mapsto q(x)::\operatorname{responses}(T,x))
  \quad\Longleftrightarrow\quad
  \operatorname{IdentifiesInitialFibers}(T).
\]

Thus the convention change adds no action to the height.  It first partitions
the candidate states by their free current output and asks the post-action
tree to identify states inside each fibre.

## 2. Residual-language form

For Mathlib's DFA `M` and prefixes `p,r`, the existing adapter proved

\[
 M.accepts.leftQuotient\ p=M.accepts.leftQuotient\ r
 \quad\Longleftrightarrow\quad
 \text{every finite native adaptive trace agrees at }M.eval\ p,M.eval\ r.
\]

The new timing adapter splits the right side exactly:

\[
\begin{aligned}
 M.accepts.leftQuotient\ p=M.accepts.leftQuotient\ r
 \quad\Longleftrightarrow\quad &
 q(M.eval\ p)=q(M.eval\ r)\\
 &\land\ \text{every post-action response tree agrees.}
\end{aligned}
\]

The proof consumes the already checked Mathlib/native theorem rather than
defining another search.  Forward transport takes the head and tail of each
equal trace.  Reverse transport rebuilds the trace from the equal current bit
and equal response tail.  Branch advance remains Mathlib's exact theorem
`Language.leftQuotient_append`.

This retains the right carrier: the prefix left quotient.  It also exposes the
right cost convention: free present output followed by paid post-action
responses.

## 3. Designed annihilation

Take two states `false,true`, identity dynamics, and observation equal to the
state.  The empty native tree identifies both states immediately because its
traces are `[false]` and `[true]`.  Its post-action response function is
constant `[]`, hence not injective.

Lean checks both statements.  Therefore the naive translation

> native identification iff the post-action tree is injective on the whole
> state set

is false.  Fibrewise injectivity is not wording hygiene; it is the missing
coordinate forced by the smallest legal example.

The existing all-reachable four-state control also passes the corrected
translation: its depth-two native tree identifies every initial-output fibre
with no height correction.

## 4. Prior-art boundary and the actual continuation

A standard-name search for **adaptive distinguishing sequence** located David
Lee and Mihalis Yannakakis, *Testing Finite-State Machines: State
Identification and Verification*, IEEE Transactions on Computers **43**
(1994), 306–320, DOI `10.1109/12.272431`.  The publisher/metadata abstract
states that existence can be decided in polynomial time and that, if an
`n`-state FSM has an adaptive distinguishing sequence, one of height at most
`n(n-1)/2` can be constructed; the bound is best possible.  An accessible
survey by Lee and Yannakakis also states that not every reduced FSM has one.

**Evidence grade:** bibliographic metadata and search-extracted abstract/survey
text; the primary paper itself was not read in this session.  These facts are
attributional constraints, not dependencies of §§1–3.

The repository's next task is therefore not to rediscover a quadratic bound.
It is to reconstruct the splitting-tree theorem in the present convention:

1. candidate states begin already split by the free current observation;
2. branch states are Mathlib prefix left quotients, not unnamed rows;
3. an action is admissible only when it does not irreversibly merge two live
   same-response residuals;
4. existence of pairwise separators does not by itself assert existence of a
   globally safe adaptive tree;
5. the returned tree must retain the residual and branch witnesses that make
   each split replayable.

Only after those points are checked does it make sense to compare the
classical extremal height with the repository's exact uniform horizon
`H_uniform` and ask for the largest attained difference.

The first continuation is now checked.  Define an action to be **safe at the
root** when, for every two reached prefixes with the same free current output,
equality of the two residuals after that action forces equality of the two
original residuals.  Then

```text
prefixResidualSafeAction_of_query_separates
```

proves that every adaptive query tree separating all prefix residuals must
have a safe root action.  The proof is local and exact: equality of the
advanced Mathlib left quotients makes the response-selected child traces
equal; the common current output completes equality of the root traces.

A reachable three-state control rejects a proves-too-much version.  One action
first reaches the second hidden residual, a second action merges the two
hidden states, and a third distinguishes their original residuals.  Lean
checks that the merge action is unsafe and hence that no choice of subtrees can
turn a tree rooted there into a residual separator.  This is the first checked
splitting-tree obstruction; it is not yet the Lee--Yannakakis existence
algorithm or quadratic bound.

The recursive invariant is now checked in
`Pairfield.AdaptiveResidualPartition`.  A **live cell** is a set of reached
prefixes whose observation history is still identical.  At a leaf, its
residuals must be homogeneous.  At a query, the root action must be safe and
the false/true subtrees must carry the same certificate on the corresponding
advanced response cells.  Lean proves the exact characterization

```text
tree.ResidualSplitting M cell
  ↔ tree.SeparatesPrefixResidualsOn M cell
```

whenever the cell's current output is constant.  Globally, prefix-residual
separation is equivalent to carrying this certificate on both initial fibres
of the free current bit.  The all-reachable `1/1/2` witness is a positive
control: its depth-two tree carries the complete recursive certificate.  The
symbolic `LinearAdaptiveGap` family is a second positive control: for every
`n` and every omitted hidden state, its depth-`n-1` tree carries the same
certificate.  Under `n ≥ 2` that family has exact costs `(1,1,n-1)`, so the
adaptive-minus-uniform gap is unbounded on reachable Mathlib residual
presentations.

This removes a hidden strengthening from the earlier informal continuation.
The continuations do not need to separate a union of candidates that were
already distinguished by prior observations.  The live cells retain that
history, so every recursive obligation is imposed exactly on candidates still
capable of collision.

## 5. Replay and rigor boundary

Checked declarations are in
`formal/pairfield/Pairfield/AdaptiveDistinguishingTransport.lean` and
`formal/pairfield/Pairfield/AdaptiveResidualSplitting.lean`, with the recursive
certificate in `formal/pairfield/Pairfield/AdaptiveResidualPartition.lean`:

- `BoolExperimentTree.identifiesAll_iff_identifiesInitialFibers`;
- `leftQuotient_eq_iff_current_and_all_adaptive_responses_eq`;
- `done_identifies_by_free_output`;
- `done_postResponses_not_injective`;
- `prefixResidualSafeAction_of_query_separates`;
- `merge_not_safe`;
- `no_residual_separator_rooted_at_merge`;
- `BoolExperimentTree.residualSplitting_iff_separatesOn`;
- `BoolExperimentTree.separatesPrefixResiduals_iff_initialSplitting`;
- `adaptiveTree_initialResidualSplitting`;
- `omitOneTree_initialResidualSplitting`.

Replay:

```sh
cd formal/pairfield
lake build Pairfield.AdaptiveDistinguishingTransport
lake build Pairfield.AdaptiveResidualSplitting
lake build Pairfield.AdaptiveResidualPartition
lake build Pairfield
```

The first theorem, the residual equivalence, and both hostile controls are
Lean-checked.  The Lee--Yannakakis construction, its `n(n-1)/2` bound, its
tight family, and polynomial runtime are cited prior art and remain
unformalized here.
