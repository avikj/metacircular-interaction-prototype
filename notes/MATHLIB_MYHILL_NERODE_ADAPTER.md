# Mathlib residual languages are predictive futures

## Exact checked bridge

For a deterministic automaton `M : DFA A X`, Mathlib's residual language at a
state is

\[
\mathcal L_x=M.\operatorname{acceptsFrom}(x).
\]

The repository behavior map records the Boolean acceptance observation after
every future word.  `Pairfield.MyhillNerodeAdapter` proves

\[
x\sim_{\mathrm{Future}}y\quad\Longleftrightarrow\quad
\mathcal L_x=\mathcal L_y.
\]

For prefixes `u,v`, Mathlib's `leftQuotient_accepts_apply` then yields

\[
u^{-1}L=v^{-1}L
\quad\Longleftrightarrow\quad
M.\operatorname{eval}(u)\sim_{\mathrm{Future}}M.\operatorname{eval}(v).
\]

This is a checked identity of objects, not an analogy between automata and
predictive quotients.

The bridge is compositional.  `stateLanguage_step` proves

\[
\mathcal L_{\delta(x,a)}=[a]^{-1}\mathcal L_x.
\]

Thus the map from concrete states to residual languages transports each
one-step action; it is not merely a terminal equality test.

## Next-action selector

The adapter exposes

```lean
def selectNext (M : DFA A X) (policy : X → A)
    (sound : ∀ ⦃x y⦄, FutureEq M.step observe x y → policy x = policy y) :
    BehavioralState M → A
```

with `selectNext_mk` reducing selection on a represented state to the original
policy.  Thus a proposed next action becomes executable on behavioral meaning
only after a proof that it is constant on complete-future classes.  A policy
that distinguishes future-equivalent states is rejected at the type boundary.

This is the smallest selector compatible with the repository's authority
discipline: the quotient licenses factorization, but it does not invent a
policy or authorize an action.

## Extensional versus finite executable content

Mathlib proves regularity iff the range of left quotients is finite and builds
an automaton whose state type is that range.  `Set.Finite` of extensional sets
does not itself provide decidable equality, enumeration, partition refinement,
or a shortest distinguishing word.

A finite executable minimizer still requires explicit finite state/action
tables and decidable observations.  Reverse pair-graph breadth-first search is
the repository's proved algorithmic candidate for shortest separating words;
its Lean formalization remains a distinct successor.  The present adapter does
not pretend that extensional Myhill--Nerode already supplies it.

## Rigor boundary

Kernel-checked here: word-execution alignment, future equality iff residual
language equality, prefix-left-quotient transport, and policy factorization to
the behavioral quotient.

Not supplied here: a finite quotient enumeration, minimization algorithm,
shortest separating certificates, or a source of policy authority.  Boolean
acceptance is the declared observation; multi-valued observations require
explicit Boolean probes or a separate generalized construction.

Replay in proof language only:

```text
cd formal/pairfield
lake build Pairfield.MyhillNerodeAdapter
```
