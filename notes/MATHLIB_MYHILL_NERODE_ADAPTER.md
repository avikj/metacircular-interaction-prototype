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

The checked adapter now reaches Mathlib's actual Myhill--Nerode theorem.  Define

\[
\operatorname{ReachBeh}(M)
=\{[M.\operatorname{eval}(u)]_{\mathrm{Future}}:u\in A^*\}.
\]

The induced map

\[
[x]_{\mathrm{Future}}\longmapsto M.\operatorname{acceptsFrom}(x)
\]

is injective, and its image on `ReachBeh(M)` is exactly
`Set.range M.accepts.leftQuotient`.  Finiteness therefore transports in both
directions.  Combining this with Mathlib's
`Language.isRegular_iff_finite_range_leftQuotient` gives the checked theorem

\[
M.\operatorname{accepts}.\operatorname{IsRegular}
\quad\Longleftrightarrow\quad
\operatorname{ReachBeh}(M)\text{ is finite}.
\]

Reachability is not cosmetic.  A DFA may have infinitely many unreachable
states with mutually different future languages while its accepted language
is regular.  Hence the same iff for the whole ambient `BehavioralState M` is
false.

Mathlib's conclusion is `Set.Finite` of extensional sets.  It does not itself
provide decidable equality, enumeration, partition refinement, or a global
shortest-distinguishing-word horizon.

A finite executable minimizer still requires explicit finite state/action
tables and decidable observations.  The live checked return
`Pairfield.ResidualBFS` composes Mathlib left quotients with the repository's
`BehavioralBFS`: given a complete finite enumeration of the already-admitted
action type and a fuel, it returns a shortest separator, proves that `none`
means bounded residual agreement, and includes an equal-reached-state false
control.  It also proves that changing the complete enumeration preserves the
bounded-equality verdict and minimum witness length.  The list therefore does
not choose the control language; actual intervention restriction must change
the action type or interface.

A second checked return installs a sufficient horizon when the *ambient* state
type has `[Fintype X]`.  The synchronous pair monitor has `|X|^2` states;
Mathlib's `DFA.evalFrom_split` deletes a loop from an overlong separating run.
Thus search through fuel `|X|^2` returns `none` exactly when two reachable
prefix residuals are equal.  This is a total proof-producing equality decision
for an explicitly finite DFA presentation, though the bound is deliberately
non-sharp.

The two theorems still do not compose from regularity alone.  Regularity gives
`Set.Finite` of reachable behavioral meanings; the quadratic decision assumes
an ambient `Fintype X`, which may be inflated by unreachable and duplicate
states.  The missing carrier is an explicitly enumerable, transition-closed
chart of reachable behavioral representatives.

## Rigor boundary

Kernel-checked here: word-execution alignment, future equality iff residual
language equality, prefix-left-quotient transport, policy factorization to the
behavioral quotient, injectivity of residual language on behavioral meanings,
exact identification of reachable meanings with the left-quotient range, and
regularity iff finiteness of the reachable behavioral quotient.

Not supplied by the regularity adapter: a finite quotient enumeration,
decidable residual equality, or a global minimization horizon.  `ResidualBFS`
supplies all three only from the stronger input of an explicit ambient
`Fintype X` plus decidable acceptance and a complete action enumeration; it
does not extract them from the regularity proof.  Neither theorem is a source
of policy authority.  Boolean acceptance is the declared observation;
multi-valued observations require explicit Boolean probes or a separate
generalized construction.

Replay in proof language only:

```text
cd formal/pairfield
lake build Pairfield.MyhillNerodeAdapter Pairfield.ResidualBFS
```
