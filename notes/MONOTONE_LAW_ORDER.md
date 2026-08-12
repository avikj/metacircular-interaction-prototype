# Monotone laws align sensing order with center geometry

Let the conditional child law at a reached prefix be

\[
\pi_0\ge \pi_1\ge\cdots\ge\pi_{p-1}\ge0.                  \tag{1}
\]

As in `CENTER_ORDER_LATENCY`, schedules begin at local center `0`, test
`p-1` children, infer the last, and charge signed-scale motion by line
distance.

## Simultaneous optimum

**Theorem.** The canonical schedule

\[
\sigma=(0,1,\ldots,p-1)                                      \tag{2}
\]

minimizes expected query count and expected center motion separately among
all schedules. Its costs are

\[
\mathbb E Q=\sum_{d=0}^{p-2}(d+1)\pi_d+(p-1)\pi_{p-1},       \tag{3}
\]

\[
\mathbb E S=\sum_{d=0}^{p-1}d\pi_d.                          \tag{4}
\]

Consequently it minimizes `E[Q+lambda S]` for every `lambda>=0`.

*Proof.* Every schedule assigns the query-cost multiset
`1,2,...,p-2,p-1,p-1` to the children. The rearrangement exchange from
`EXPECTED_QUERY_ORDER`, together with (1), proves that (2) minimizes queries.

For motion, fix outcome `d`. Every execution path begins at center `0` and,
including the inferred-child move, ends at center `d`. The triangle inequality
gives realized motion at least `|d-0|=d`. Canonical order travels monotonically
from `0` to `d`, attaining this bound for every outcome simultaneously.
Taking expectation gives (4) and proves motion optimality. ∎

This removes the exponential Bellman state under a structural law, not a
memory budget. At every prefix satisfying (1), the same argument applies;
linearity then proves global optimality for an arbitrarily dependent residue
law whose conditional children decrease canonically at every reached node.

## Equality and scope

Uniqueness is not claimed. Query ties permit permutations within equal-cost or
equal-probability positions. Motion equality only requires every positive-mass
outcome's executed path to be geodesic; zero-mass branches are unrestricted.
For strictly positive laws, a schedule attaining (4) cannot make a positive
move and later move left before stopping on any positive-mass tested child,
but this observation is not needed for optimality.

The theorem fails without alignment between probability and geometry. The law
`(2,7,1)/10` from `SURVIVAL_PATH_DP` uniquely exposes interior-first order
`102` for `lambda=1/10`. Thus monotonicity is a sufficient structural
condition, not a generic conclusion about line metrics.

## Rigor boundary

The result uses declared conditional probabilities, unit-cost signed moves of
the held scale, and the compulsory inferred-child center formation. It makes
no statistical claim that arithmetic residue laws are monotone, no uniqueness
claim, and no extension to subtraction-only motion.

