# Successor formation generates monotone conditional digit laws

Fix `1<=N<=p^k` and choose `R` uniformly from the successor-formed set

\[
I_N=\{0,1,\ldots,N-1\}\subset\mathbb Z/p^k\mathbb Z.         \tag{1}
\]

Digits are learned from low to high.

## Quotient-interval theorem

Let `u` be a reached prefix of length `ell`, represented by
`0<=u<p^ell`. The members of `I_N` with this prefix are exactly

\[
u+p^\ell t,\qquad 0\le t<T_u,                                \tag{2}
\]

where

\[
T_u=\left\lfloor\frac{N-1-u}{p^\ell}\right\rfloor+1.        \tag{3}
\]

Write `T_u=qp+a`, with `0<=a<p`. Then the conditional counts of the next
digit are

\[
n_d(u)=
\begin{cases}
q+1,&0\le d<a,\\
q,&a\le d<p.
\end{cases}                                                   \tag{4}
\]

*Proof.* Congruence to `u mod p^ell` gives the unique representation (2), and
the upper bound gives (3). The next digit is `t mod p`. In the initial interval
`0<=t<T_u`, every residue occurs `q` times and the first `a` residues occur
once more. ∎

Thus at every reached prefix

\[
P(D_\ell=0\mid u)\ge\cdots\ge P(D_\ell=p-1\mid u).           \tag{5}
\]

By `MONOTONE_LAW_ORDER`, canonical order `0,1,...,p-1` minimizes expected
queries and signed-scale motion separately at every node, hence globally.
Successor formation therefore generates the exact probability/geometry
alignment required to collapse the scheduling Pareto frontier.

## Closed finite cost formulas

Let `n_(ell,d)` count members of `I_N` whose `ell`th digit is `d`. Put

\[
B=p^{\ell+1},\quad A=p^\ell,\quad N=cB+s,quad0\le s<B.
\]

Then

\[
n_{\ell,d}=cA+\min\{A,\max(0,s-dA)\}.                        \tag{6}
\]

For `q_p(d)=d+1` when `d<=p-2` and `q_p(p-1)=p-1`, the optimal expected
forward-query and motion costs are exactly

\[
\mathbb E Q=\frac1N\sum_{\ell=0}^{k-1}\sum_{d=0}^{p-1}
n_{\ell,d}q_p(d),                                             \tag{7}
\]

\[
\mathbb E S=\frac1N\sum_{\ell=0}^{k-1}\sum_{d=0}^{p-1}
n_{\ell,d}d.                                                  \tag{8}
\]

Equation (8) uses signed motion: canonical execution for output digit `d`
travels the geodesic distance `d` from the current prefix center, including
the inferred last child. Clean oracle invocations are `2 E Q` under per-query
uncomputation.

At `N=p^k`, every conditional digit law is uniform, so canonical order is
optimal but nonunique in query cost; its motion remains pointwise geodesic.
At `N=1`, every digit is zero and `(E Q,E S)=(k,0)`.

## Rigor boundary

Uniform measure on a successor initial interval is load-bearing. A translated
cyclic interval may rotate the favored digit block, and an arbitrary formed
subset need not satisfy (5). The theorem concerns signed held-scale motion,
not the subtraction-only compiler. Computation exhaustively replays (3)--(8)
for bounded parameters but is not the proof.

