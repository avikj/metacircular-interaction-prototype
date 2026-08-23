# Forgetting can create reversible effective dynamics

## 1. Observation-relative action algebra

Let the free monoid `A*` act on a finite set `X`.  For an observation `O`,
write

\[
x\sim_Oy\iff O(xw)=O(yw)\qquad(w\in A^*).
\]

Suppose `P=h O`: `P` deliberately forgets distinctions made by `O`.

**Theorem 1 (contravariant state refinement).** There is a canonical
surjection

\[
q:X/{\sim_O}\twoheadrightarrow X/{\sim_P}.
\]

**Proof.** If `x~_O y`, then for every `w`, applying `h` to
`O(xw)=O(yw)` gives `P(xw)=P(yw)`.  Hence `~_O` refines `~_P`, which is
exactly the asserted quotient map. ∎

Let `M_O` be the transformation monoid induced by `A*` on `X/~_O`.

**Theorem 2 (forgetful action quotient).** There is a canonical surjective
monoid homomorphism

\[
\pi:M_O\twoheadrightarrow M_P
\]

characterized by `q m = pi(m) q`.

**Proof.** Every word preserves both future-equivalence relations and hence
acts on both quotients.  If two words induce the same transformation on the
fine quotient, composing with the surjection `q` shows that they induce the
same transformation on the coarse quotient.  Thus the map is well-defined.
It preserves composition because both actions come from word composition.
Every element of `M_P` is induced by a word, and the same word gives a
preimage in `M_O`, proving surjectivity. ∎

Adding observations therefore refines predictive states and may split
effective actions.  Forgetting observations performs the exact reverse:
states and actions can both merge.  This is not merely a smaller data
structure; algebraic properties need not reflect backward through the
surjection.

## 2. A nonunit becomes a unit

Take

\[
X=\{0,1,2\},\qquad e(0)=0,\quad e(1)=0,\quad e(2)=2.
\]

Under the identity observation `O(x)=x`, the predictive quotient is `X`
itself and its action monoid is `{1,e}`.  The action `e` is a nonidentity
idempotent, so this monoid is not a group and has no faithful representation
by closed unitaries: `U_e^2=U_e` would force `U_e=I`.

Now forget only the distinction between `0` and `1`:

\[
P(0)=P(1)=0,\qquad P(2)=1.
\]

The two predictive states are `{0,1}` and `{2}`.  On them, `e` acts as the
identity.  Thus `M_P` is the trivial group and admits a faithful closed-unitary
representation.  The physical action did not reverse its microscopic
collapse.  Rather, relative to the retained question, it destroys no
accessible distinction and is exactly reversible.

Three states are minimal for this nontrivial version: a proper quotient of a
two-state system has only one predictive state.  The three-state example still
retains a real binary distinction after the reversal.

This sharpens `UNITARY_SYNTACTIC_MONOID_NO_GO`: closed-unitary realizability is
not a property of the raw action alone.  It is a property of the action monoid
after an observation family has declared which distinctions must remain
available.

## 3. What this changes in execution

More observation can require an open-system implementation because it insists
that a dissipated distinction remain recoverable.  A coarser task may compile
the same physical action as a closed reversible primitive.  Consequently the
machine must not route every task through its richest accumulated quotient.
It should retain the rich model and provenance while executing each task on
the coarsest predictive quotient sufficient for that task.

Retention and execution therefore point in opposite directions:

- memory keeps the richer observation and its derivation so the distinction
  can be reopened;
- execution forgets exactly those distinctions irrelevant to the current
  continuation language, potentially changing a non-group action algebra into
  a group quotient.

Neither direction dominates.  Permanent erasure destroys optionality; always
executing at maximal resolution destroys valid compression and can impose
irreversibility that the current task does not contain.

## Rigor boundary

The two finite action theorems and the three-state example are proved above.
`machinery/observation_forgetting.py` constructs both predictive quotients,
enumerates their finite transformation monoids, and checks the induced
surjection.  Five exact tests include the false control rejecting an
observation that does not factor through the rich one.

No claim is made that microscopic thermodynamic dissipation is reversed,
that information should be permanently deleted, or that a coarse model is
sufficient for undeclared future tasks.  “Reversible” here means faithfully
closed-unitary realizable for the effective finite action monoid, exactly as
scoped in `UNITARY_SYNTACTIC_MONOID_NO_GO.md`.
