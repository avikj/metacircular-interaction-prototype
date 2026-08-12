# Primitive integer equalization of aligned child rays

Let `r_i` be primitive nonzero integer measures spanning chosen child extreme
rays, and put `t_i=|r_i|`. An integer parent on their equal-total coupling has
children `n_i r_i` with positive integers `n_i` satisfying

\[
n_i t_i=M.                                                     \tag{1}
\]

**Theorem.** The unique primitive integer parent has

\[
L=\operatorname {lcm}(t_0,\ldots,t_{m-1}),\qquad n_i=L/t_i.  \tag{2}

Every integer parent on the same ray is a positive integer multiple of it.

*Proof.* Equation (1) implies every `t_i` divides `M`, hence `L|M`. Writing
`M=qL` gives `n_i=qL/t_i`, so every coupling is `q` times (2). The coordinates
in (2) have gcd one: if a prime divided them all, then `L/prime` would remain
divisible by every `t_i`, contradicting minimality of the least common
multiple. Thus (2) is primitive and unique. ∎

The exact replication excess beyond one existing copy of each child is

\[
C=\sum_i(L/t_i-1).                                             \tag{3}

This is a typed copy count, not an addition-chain or gate count. Formal
normalization to probability one erases (3); actual integer formation does
not. For child totals `(2,3)`, the primitive coupling needs multiplicities
`(3,2)` and three additional copies. For equal totals, cost is zero.

## Rigor boundary

Children are primitive integer measures and replication is counted literally.
Shared arithmetic construction, addition chains, and rational weights can
change operational cost and are not priced here.
