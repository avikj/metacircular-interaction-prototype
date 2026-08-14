# RESULT — exact output-sensitive rolling-cost conservation

Literal no-redraw Draw 14 selected the existing source note
`notes/OUTPUT_SENSITIVE_CLEAN_COST.md`. That note is preserved unchanged. The
new companion leaf and ledger make its finite branchwise arithmetic visible to
Lean without importing the separate average-count claims.

For a supplied list of bounded digits `Fin p`, `p ≥ 2`, the leaf defines the
declared early-stopping query count `q`, forward queries `Q`, clean oracle uses
`O = 2Q`, nonterminal maximal-digit omissions, and rolling center
subtractions `S`. It checks the subtraction-free conservation law

```text
S + trace.length = Q + omitted.
```

The theorem includes the empty trace. The all-zero endpoint gives
`Q=k`, `O=2k`, `S=0`. For `k>0`, the all-maximal endpoint has exactly `k-1`
nonterminal omissions and gives
`Q=k(p-1)`, `O=2k(p-1)`, `S=k(p-1)-1`.

Summing the pointwise law over an arbitrary finite population of equal-length
traces yields

```text
sum S + population.card * k = sum Q + sum omitted.
```

Only equal trace length is assumed; there is no probability law or digit
frequency formula. A concrete `p=3`, `k=1`, digit-`2` control checks that the
signed-geodesic digit sum is `2` while rolling `S` is `1`, so these two cost
conventions cannot be silently identified.

Focused replay:

```text
cd formal/pairfield
lake env lean Pairfield/OutputSensitiveCleanCost.lean
exit 0, no output
```

The first replay exposed proof-engineering only: a nonexistent projection from
the natural-number bound to positivity and insufficient explicit zero-digit
simplification. Both were repaired without changing a definition or theorem
statement. Shannon independently replayed and hostile-reviewed the final
query convention, conservation orientation, endpoint arithmetic (including
`p=2`, `k=1`), population summation, killer control, and scope: PASS, no
blocker.

The checked object is a finite cost ledger on an already supplied trace. It
does not construct or verify the scheduler, trace realization, cache
semantics, response distribution, average digit counts, alternative order,
reversible gate accounting, or a Pareto theorem. In particular `O=2Q` remains
the declared compute/uncompute convention, not a compiled circuit result.

Draw provenance: frozen origin
`fc62041fb5427116b3adb7c3afe107a05c4f8cdb`, tree
`a34bbeb5c4e27ba9635e1bbbec820cf8d2f440e3`; 1,131-path C-sorted tracked
semantic frame under `formal/`, `notes/`, and `papers/`, excluding build
products and thirteen prior samples; frame SHA-256
`0a6dfd550d9c3b76cf6e20c6eacd454497677a7f543484d8723373b720bc6656`;
rejection limit `4294966845`; sole `/dev/urandom` uint32 `2791198049`, zero
rejections, index 887 (position 888); selected blob
`a52b99a6941bf3b631e731cb70a0a3c3c2052219`. No redraw.
