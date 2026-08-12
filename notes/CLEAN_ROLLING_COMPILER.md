# Clean fixed scheduling and subtractive center reuse do not freely compose

Two independently valid optimizations meet:

- rolling centers reuse a decreasing subtractive chain and stop after the
  successful digit;
- clean coherent compilation uses a fixed `p-1`-test schedule per digit,
  unqueries each response, and retains no response transcript.

They cannot both be applied unchanged.

## Exact incompatibility

At level `ell`, with prefix `a` and scale `s=p^ell`, candidate centers are

\[
C_d=M-a-ds,qquad 0\le d\le p-2.                  \tag{1}
\]

Suppose the true digit is `d<=p-3`. The early-stopping rolling protocol ends
at `C_d`; this is exactly the next level's zeroth center, so no mutation is
needed. A fixed schedule instead continues through `C_(p-2)`. Its next-level
zeroth center is still `C_d`, and therefore

\[
C_d-C_{p-2}=(p-2-d)s>0.                            \tag{2}

\]

The fixed schedule must jump upward. It is no longer the single decreasing
subtractive chain of `ADAPTIVE_CENTER_CHAIN`.

**Theorem.** For `p>=3`, no implementation can simultaneously use the fixed
`p-1` candidate order, retain only its final center at each level, and realize
every inter-query center transition by subtracting the current scale. The
counterbranch is any digit `d<=p-3`.

For `p=2` there is one tested candidate and the obstruction is absent. For any
`p`, it is also absent on the branches `d=p-2` (next center repeats) and
`d=p-1` (one further subtraction).

## The two honest compilations

1. **Branch-retaining rolling schedule.** Stop after success. Preserve the
   chosen digit/active program counter, unquery before mutating the center, and
   keep the subtractive chain. Worst-case counts remain those already proved,
   but the variable schedule is part of the state.
2. **Branch-oblivious clean schedule.** Test all `p-1` candidates, immediately
   unquery each response, and reconstruct or reversibly update the next center
   from the retained prefix rather than claiming monotone chain reuse. This is
   `CLEAN_REVERSIBLE_VALUATION_PROGRAM`; its arithmetic center cost requires a
   separate circuit accounting.

Thus response-history cleanup and power/center pebbling share a causal seam.
Their Pareto choices are not a Cartesian product: erasing the branch schedule
removes exactly the information that tells the arithmetic state where to stop.

## Rigor boundary

Equation (2) proves the incompatibility under the stated fixed-order and
subtractive-transition contract. The executable enumerates branches only as a
falsifier. No lower bound is claimed for arbitrary reversible arithmetic
circuits, alternate candidate orders, or approximate protocols.

