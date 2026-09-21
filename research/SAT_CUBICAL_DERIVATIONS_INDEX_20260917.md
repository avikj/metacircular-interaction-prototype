# SAT cubical derivation series — index

Read in this order:

1. `SAT_CUBICAL_GEODESIC_NOTES_20260916.md` — original persistent conversation notebook; its §8–9 forced-crossing sketch is superseded by the exact derivations below.
2. `SAT_CUBICAL_EXACT_DERIVATIONS_20260917.md` — Boolean vertex cube, partial-assignment intersections, exact inclusion–exclusion, quotient by identical intersections, disjoint-block counterexample, section calculus. The file ends mid-§8 because the connector write hit its payload boundary; continue immediately with Part II.
3. `SAT_CUBICAL_EXACT_DERIVATIONS_20260917_PART2.md` — checked complete-future quotient, bounded horizon closure, fixed-order residual width, inner-product exponential-vs-constant chart control, mutual action simulation, local potential/geodesic theorem.
4. `SAT_CUBICAL_EXACT_DERIVATIONS_20260917_PART3.md` — distinction between semantic carrier cardinality and metric path length, tribonacci sliding-clause family, exact local obligation potential, proof-relevant separator certificates.
5. `SAT_CUBICAL_EXACT_DERIVATIONS_20260917_PART4.md` — violation multiplicity, minimum 8-clause UNSAT theorem, exact overlap excess, factorial-moment/intersection tower, SAT as alternating moment projection.
6. `SAT_CUBICAL_EXACT_DERIVATIONS_20260917_PART5.md` — SAT decision versus witness fibre, truncation geometry, vector/Pareto geodesic certificates.

## Current compact mathematical state

For 3CNF violating cubes `V_α` in `Q_N`, with `ν(x)=#{α:x∈V_α}` and `M_r=Σ_x C(ν(x),r)`:

```math
M_1=m2^{N-3},
```

```math
M_r=\sum_{|T|=r,\;T\ compatible}2^{N-r(T)},
```

and

```math
#SAT(F)=\sum_{r=0}^m(-1)^rM_r.
```

For UNSAT:

```math
m\ge 8,
```

with equality iff every Boolean vertex violates exactly one clause; more generally

```math
\sum_x(ν(x)-1)=(m-8)2^{N-3}.
```

These are semantic cube identities, not automatically cost lower bounds. Exact controls prove that exponentially many vertices/intersections/residuals can collapse under product factoring or coordinate change.

The metric lower-bound theorem is local: a potential `Φ` with `Φ(t)=0` and `Φ(u)≤w(u,v)+Φ(v)` on every primitive edge lower-bounds every terminal path. Equality edge-by-edge on the native path proves exact geodesicity. In vector cost, the statement holds componentwise.

Thus a genuine exponentiality certificate for a one-bit Boolean observation is a proof-relevant cubical potential whose value is exponential and whose local edge law is proved against the actual primitive interaction geometry. The useful geometric realization is a packing of terminal-relevant nonfillable boundary distinctions together with a proved bound on how many such distinctions one paid primitive interaction can discharge.

Do not regress to assignment count, raw cube dimension, clause-subset count, or a fixed coordinate filtration as if any were intrinsic cost.
