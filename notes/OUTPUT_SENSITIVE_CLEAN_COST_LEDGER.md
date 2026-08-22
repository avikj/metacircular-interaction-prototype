# Output-sensitive clean-cost ledger

Status: **checked finite trace identity**.

`formal/pairfield/Pairfield/OutputSensitiveCleanCost.lean` formalizes the
arithmetic cost equations declared in `OUTPUT_SENSITIVE_CLEAN_COST.md` without
editing that sampled source. A trace is a finite list of intrinsically bounded
digits `Fin p`, with `p ≥ 2`.

For the declared early-stopping query count `q`, the leaf defines

```text
Q = sum q(d),
O = 2 Q,
omitted = number of nonterminal maximal digits,
S = sum (q(d)-1) + omitted.
```

The checked per-trace conservation law is the subtraction-free identity

```text
S + trace.length = Q + omitted.
```

It includes the empty trace. For nonempty length `k`, the two endpoint controls
recover the source formulas exactly:

```text
all zero:     Q = k,       O = 2k,       S = 0;
all maximal:  Q = k(p-1), O = 2k(p-1),  S = k(p-1)-1.
```

The missing terminal boundary is explicit: the all-maximal trace has exactly
`k-1` nonterminal omissions.

## Finite-population identity

For any finite population of equal-length traces, summing the branchwise law
gives

```text
sum S + population.card * k = sum Q + sum omitted.
```

This is a finite algebraic identity. It neither chooses nor assumes a
distribution on traces, and it does not import the digit-frequency formulas
from `SUCCESSOR_PREFIX_LAW.md`.

## Killer control: two cost notions differ

At `p=3`, length one, and digit `2`, the leaf checks

```text
signed geodesic motion = 2,
rolling center subtractions S = 1.
```

There is no nonterminal boundary in this trace. The difference already comes
from the within-level conventions, so the signed-geodesic statistic from the
successor-prefix discussion cannot be substituted for the rolling subtraction
count in the sampled note.

## Scope

The definitions are an exact finite cost ledger on a supplied digit trace.
They do not implement the clean scheduler, prove that an executable machine
realizes every trace, formalize response caching, assign a probability law,
derive average digit counts, compare alternative test orders, count reversible
gates, or prove a global Pareto theorem. `O = 2Q` is the declared clean
compute/uncompute accounting convention, not a compiled circuit-cost result.

No aggregate import is added. The theorem is elementary; no novelty is
claimed beyond making the repository's branchwise rolling-cost invariant and
its separation from signed-geodesic motion checker-visible.

## Draw 14 provenance

Literal no-redraw Draw 14 froze origin
`fc62041fb5427116b3adb7c3afe107a05c4f8cdb`, tree
`a34bbeb5c4e27ba9635e1bbbec820cf8d2f440e3`. The 1,131-path C-sorted tracked
`.agda`/`.lean`/`.md` frame under `formal/`, `notes/`, and `papers/` excluded
build paths and the thirteen prior sampled objects; SHA-256 was
`0a6dfd550d9c3b76cf6e20c6eacd454497677a7f543484d8723373b720bc6656`.
The rejection limit was `4294966845`; the sole `/dev/urandom` uint32
`2791198049` was accepted with zero rejections at zero-based index 887
(position 888), selecting `notes/OUTPUT_SENSITIVE_CLEAN_COST.md`, blob
`a52b99a6941bf3b631e731cb70a0a3c3c2052219`. There was no redraw.
