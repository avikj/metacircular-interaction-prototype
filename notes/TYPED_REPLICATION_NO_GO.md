# Distinct child measures do not share addition-chain work

Let primitive child measures `r_1,...,r_m` be typed objects. Starting with one
copy of each, allow only the operation

\[
a r_i+b r_i\longmapsto(a+b)r_i,                               \tag{1}
\]

retaining previous objects. Cross-type addition is forbidden because it forms
a sum of measures, not a scalar multiple of either child. Let `ell(n)` denote
the shortest addition-chain length from `1` to `n`.

**Theorem.** Forming all targets `n_i r_i` requires exactly

\[
\sum_{i=1}^m\ell(n_i)                                        \tag{2}
\]

typed additions.

*Proof.* Project any execution trace to operations of type `i`. Operations of
other types neither create nor change a multiple of `r_i`; the projection is
an addition chain from `1` to `n_i`, so it has at least `ell(n_i)` steps.
Summing gives the lower bound. Independently execute a shortest chain for each
type to attain it. ∎

For integer ray equalization, `n_i=L/t_i`, so the exact typed-addition cost is

\[
\sum_i\ell(L/t_i).                                            \tag{3}

This kills the proposed “shared joint chain” under the declared replication
primitive. Sharing scalar intermediates requires a different machine: it must
form integers as untyped objects and supply an operation applying a formed
scalar to an arbitrary measure. Neither its application cost nor its
reversibility is contained in (1).

Example: multipliers `(3,2)` cost `ell(3)+ell(2)=2+1=3`; the scalar chain
`1,2,3` has two additions, but it has not thereby formed `3r_1` and `2r_2`.

## Rigor boundary

Equation (2) assumes distinct typed measures and within-type addition only.
Coincident child rays can share already formed multiples if identity and
copy semantics permit it; scalar-action machines are explicitly outside this
no-go. Exact small-chain computation replays values but does not prove the
projection theorem.
