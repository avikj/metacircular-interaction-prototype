# Adaptive valuation centers form themselves by subtraction

Fix `R_k=Z/p^kZ`. Assume the power ladder

\[
1,p,p^2,\ldots,p^k
\]

is already formed. Represent the zero center by the positive integer `p^k`.
The optimal digit protocol knows a prefix `a=r mod p^ell` and tests digits
`d=0,...,p-2` with the positive center

\[
C_{\ell,d}=p^k-a-dp^\ell.                         \tag{1}
\]

It queries the valuation of `r-C_{ell,d}`; this is equivalent to the prior
`r+c` convention after replacing `c` by `-C` modulo `p^k`.

## Chain theorem

**Theorem.** Along every branch of the adaptive protocol, the distinct queried
centers form a strictly decreasing positive chain. The first center is the held
value `p^k`, and every later distinct center is obtained from the preceding
one by one restricted subtraction of a held power `p^ell`. Consequently a
branch using `Q` queries needs at most `Q-1` new center-forming operations.
When a successful digit repeats the same center at the next level, its already
observed depth can also be reused rather than queried again. The worst branch
uses

\[
Q=k(p-1),\qquad F=k(p-1)-1.                         \tag{2}
\]

*Proof.* At fixed level `ell`, consecutive candidates satisfy

\[
C_{\ell,d+1}=C_{\ell,d}-p^\ell.                    \tag{3}
\]

If digit `d<=p-2` succeeds, the new prefix is `a'=a+dp^ell`; its next-level
zeroth center is

\[
C_{\ell+1,0}=p^k-a'=C_{\ell,d},                    \tag{4}

\]

already held, and the previous response supplies its depth without another
experiment. If every test fails, the inferred digit is `p-1`, so

\[
C_{\ell+1,0}=p^k-a-(p-1)p^\ell
             =C_{\ell,p-2}-p^\ell,                 \tag{5}
\]

one further subtraction. Thus every new distinct center after the first
extends the same chain by one subtraction.

Positivity holds because every queried prefix candidate is strictly below
`p^(ell+1)<=p^k`; at the terminal level its complement is at least one. The
initial center `C_{0,0}=p^k` is already in the power ladder. Hence `F<=Q-1`.
The all-`p-1` residue never repeats a center, forces `p-1` queries at every
level, and attains both equalities in (2). ∎

## What the operation changes

Generic binary construction would price each branch-selected center largely
from scratch. The exact recurrence shows that this is the wrong state model:
the preceding experiment leaves precisely the arithmetic object needed to
form the next experiment. Query choice and formation history compose.

The power ladder remains a prerequisite and is priced separately. If only
`p` is held, repeated multiplication forms it in `k-1` additional operations;
other power-chain conventions give another typed coordinate. The theorem does
not hide that cost inside center formation.

## Rigor boundary

The chain identity, positivity, and exact branch count are proved above. Tests
replay every residue in bounded rings. Operation count treats restricted
subtraction as unit cost and assumes persistent intermediates and the power
ladder; bit complexity, garbage collection, noisy sensing, and parallel center
installation are outside scope.
