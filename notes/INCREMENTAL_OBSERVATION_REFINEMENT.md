# Incremental observations refine only previously unresolved classes

Let a monoid `A*` act on `X`. For an observation family `O`, define
\[
x\sim_O y\iff o(xw)=o(yw)\quad(o\in O,w\in A^*).             \tag{1}
\]
Add observations `N` and write `O'=O union N`.

**Theorem 1 (localized refinement).**
\[
\sim_{O'}=\sim_O\cap\sim_N.                                  \tag{2}
\]
Hence the refined quotient `Q_{O'}` has a canonical surjection to `Q_O`, and
only pairs inside one old class can require new distinguishing histories. An
old class `B` splits by the signatures
\[
x\mapsto(n(xw))_{n\in N,w\in A^*},\qquad x\in B.             \tag{3}
\]

*Proof.* Equation (2) is immediate from the universal quantifiers in (1).
Containment `sim_{O'} subset sim_O` gives the quotient map. Pairs in distinct
old classes already have an old distinguishing observation/history, so new
search is necessary only within each old block; equality of (3) is exactly the
new relation restricted to that block. ∎

For history equivalence, define `u approx_O v` when every state, continuation,
and old observation gives equal outputs. Then similarly
\[
\approx_{O'}=\approx_O\cap\approx_N.                          \tag{4}
\]

**Theorem 2 (syntactic quotient transport).** The refined syntactic monoid
`M_{O'}=A*/approx_{O'}` maps surjectively onto `M_O` by `[w]_{O'}->[w]_O`.
Thus adding observations can split effective actions but cannot identify two
actions previously distinguished.

These statements answer the incremental question in
`GENERATED_ACTION_COMPLETION` at the exact algebraic level. They do not promise
that computing (3) is finite when `X` or the quotient is infinite. For finite
systems, refinement work can be restricted to old blocks; unaffected blocks
and their old certificates persist.

## Split-machine instance

The one-step and two-step split quotients show the direction physically. A
terminal task sees only accept/reject. Allowing one earlier coordinate exposes
the full coprimality mask and splits that Boolean quotient into several
predictive classes. The earlier quotient remains its canonical image; the new
distinguishing witness is an explicit feasible coordinate `a` where masks
differ.

## Rigor boundary

This is a set-theoretic/action theorem. It proves localization and canonical
surjections, not a sublinear update algorithm, minimal changed-region data
structure, or behavior under removal of observations.
