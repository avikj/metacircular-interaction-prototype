# Joint valuation-query and center-motion order

The probability-optimal child order need not respect the subtractive center
chain. This note prices both coordinates without collapsing them.

At a prefix of length `ell`, identify the local child centers with
`0,...,p-1`. A move `i -> j` costs `|i-j|` signed applications of the held
scale `p^ell`. A schedule is a permutation

\[
\sigma=(\sigma_1,\ldots,\sigma_p),
\]

whose first `p-1` children are tested and whose last child is inferred. The
path begins at local center `0`. It stops at a successful tested child; after
all failures it makes the final move to the inferred child.

## Prefixwise path-latency theorem

For child `d`, let `q_sigma(d)=min(sigma^{-1}(d),p-1)`. Its motion cost is

\[
s_\sigma(d)=
\begin{cases}
\displaystyle\sum_{i=1}^{t}|\sigma_i-\sigma_{i-1}|,
 &d=\sigma_t,\ t<p,\\[6pt]
\displaystyle\sum_{i=1}^{p}|\sigma_i-\sigma_{i-1}|,
 &d=\sigma_p,
\end{cases}                                                   \tag{1}
\]

where `sigma_0=0`.

**Theorem.** For any declared distribution on `Z/p^kZ` and any `lambda>=0`,
the minimum of

\[
\mathbb E[Q+\lambda S]                                       \tag{2}
\]

over prefix-adaptive schedules is the sum over positive-mass prefixes `u` of

\[
P(u)\min_{\sigma\in S_p}
 \sum_{d=0}^{p-1}P(D_\ell=d\mid u)
 \bigl(q_\sigma(d)+\lambda s_\sigma(d)\bigr).                \tag{3}
\]

*Proof.* Query cleanup occurs before every center mutation, so a tested
success leaves no response scratch. An inferred outcome is moved explicitly
to its child center. Hence every branch ends at the learned center. Under the
center identity from `ADAPTIVE_CENTER_CHAIN`, that center is exactly the
zeroth candidate center for the extended prefix at level `ell+1`. Thus the
next node always begins in the same normalized state `0`, independent of the
schedule used above it. Linearity of expectation now gives (3), and each
finite minimum may be chosen independently. ∎

This is a finite weighted stopped-path-latency problem on a line. It is not
the rearrangement problem of query cost alone: the order affects both arrival
times and traveled distance.

## Complete ternary envelope

Put `(x,y,z)=P(D=0,1,2 | u)`. The six local orders have costs:

| order | expected queries | expected signed-scale moves |
|---|---:|---:|
| `012` | `2-x` | `y+2z` |
| `021` | `2-x` | `3y+2z` |
| `102` | `2-y` | `2x+y+4z` |
| `120` | `2-y` | `4x+y+2z` |
| `201` | `2-z` | `4x+5y+2z` |
| `210` | `2-z` | `4x+3y+2z` |

Therefore `021` is dominated by `012`, `201` by `210`, and between the two
orders beginning at `1`, `102` is better when `z<=x`, while `120` is better
when `x<=z`. The exact scalarized lower envelope is

\[
\min\left\{
2-x+\lambda(y+2z),
2-y+\lambda\min(2x+y+4z,4x+y+2z),
2-z+\lambda(4x+3y+2z)
\right\}.                                                     \tag{4}
\]

For `(x,y,z)=(1,2,7)/10`, query-only optimization chooses `210`, whereas
positive motion prices can expose `012`. The transition occurs where the
corresponding affine functions in (4) cross; no exchange rate is privileged.

## Rigor boundary

The theorem assumes both addition and subtraction of a held scale have unit
cost. The earlier monotone compiler allowed subtraction only; under that
stricter operation set, nonmonotone schedules may be infeasible rather than
expensive. We prove scalarized expected-cost optimality, not a universal
choice of `lambda`, gate-level reversibility cost, or an efficient algorithm
for large `p`. Computation only replays the finite formulas and compositional
identity.

