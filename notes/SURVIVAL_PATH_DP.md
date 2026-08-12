# Survival-weighted dynamic program for valuation schedules

Fix one prefix, child probabilities `pi_0,...,pi_(p-1)`, and a price
`lambda>=0` for signed held-scale motion. A schedule is a permutation
`sigma=(sigma_1,...,sigma_p)`, with `sigma_p` inferred after the first `p-1`
tests fail. Put `sigma_0=0` and

\[
W_t=\sum_{d\notin\{\sigma_1,\ldots,\sigma_{t-1}\}}\pi_d.     \tag{1}
\]

Thus `W_t` is the probability that execution reaches stage `t`.

## Survival identity

**Theorem 1.** The schedule's expected costs are

\[
\mathbb E Q=\sum_{t=1}^{p-1}W_t,                              \tag{2}
\]

and

\[
\mathbb E S=\sum_{t=1}^{p}W_t
 |\sigma_t-\sigma_{t-1}|.                                    \tag{3}

*Proof.* Query `t<=p-1` is issued exactly when none of the earlier tested
children is the outcome, an event of probability `W_t`. The motion edge into
`sigma_t` is traversed under the same condition. This includes `t=p`: after
all tested children fail, the sole surviving outcome is inferred and its
center is formed. Summing indicators gives (2)--(3). ∎

The identity exposes the correct state variable: not elapsed position alone,
but the set of probability masses already resolved.

## Exact Bellman recurrence

For a tested set `A` and current center `j`, let

\[
W(A)=\sum_{d\notin A}\pi_d                                  \tag{4}

\]

and let `F(A,j)` be the minimum *unnormalized* expected future cost on paths
whose outcome has survived `A`. If one child `o` remains, set

\[
F(A,j)=\lambda\pi_o|o-j|.                                    \tag{5}

If at least two remain, then

\[
F(A,j)=\min_{h\notin A}
 \left[W(A)(1+\lambda|h-j|)+F(A\cup\{h\},h)\right].          \tag{6}

The exact optimum is `F(emptyset,0)`.

*Proof.* Every unresolved outcome pays for the next query and edge to `h`,
giving the first term in (6). Outcome `h` then stops; all other probability
mass is represented exactly by the successor state. When only `o` remains,
there is no further query, but its final center motion is compulsory, giving
(5). Bellman's principle proves the claim. ∎

Memoization has at most `p 2^p` states and `p` transitions per state, hence
time `O(p^2 2^p)` and space `O(p2^p)`. This improves factorial enumeration
without asserting polynomial complexity.

## The interval restriction is false

An endpoint-removal or interval-expansion rule would require the first tested
child of `{0,1,2}` to be `0` or `2`. Take

\[
(\pi_0,\pi_1,\pi_2)=(2,7,1)/10,\qquad \lambda=1/10.          \tag{7}

\]

The complete ternary table from `CENTER_ORDER_LATENCY` gives the unique
minimum at order `102`:

\[
(\mathbb EQ,\mathbb ES)=(13/10,15/10),\qquad
\mathbb E(Q+S/10)=29/20.                                     \tag{8}

The other order beginning at `1` costs `147/100`, and every endpoint-first
order costs still more. Thus even on a line an optimal stopped path can begin
at an interior child. Probability-weighted latency defeats interval geometry.

## Rigor boundary

The recurrence is exact for the signed-scale model and a declared local law.
It does not prove hardness, polynomial solvability, or optimality under the
subtraction-only compiler. The executable comparison against all permutations
is a finite falsifier/replay, not the proof.

