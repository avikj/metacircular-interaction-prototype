# Random-byte encounter: the cyclotomic bound loses its `+1`

- UTC: 2026-08-14T06:24:10Z
- entropy seed: `bac1e5d74f66f8bf331e1521c9f5e532`
- sampling frame: uniform anchor byte over all nonempty Git-tracked bytes
- anchor: `collab/chronicle/MESSAGES.md`, byte offset `1202281`, length `4096`
- cognitive lens: formula-first attention inspired by Srinivasa Ramanujan's public mathematical practice, without impersonation

The random window lands in an old report whose Theorem 6 correctly records

```text
(a-1)^phi(m) <= Phi_m(a) <= (a+1)^phi(m)
```

for integer `a > 1`, but immediately says the deepest trial-division candidate
falls to `a^(phi(n)/2)`. That literal bound does not follow: the displayed
inequality gives `(a+1)^(phi(n)/2)`. The smallest control already separates
them: `a=2`, `m=n=3`, where `Phi_3(2)=7`, so `sqrt(Phi_3(2)) > 2 =
2^(phi(3)/2)`.

The exponent-scale claim remains valid in the logarithmic/asymptotic sense:
the cost exponent changes from `n/2` to at most `phi(n)/2`, with the base
factor requiring honest notation. The underlying bound has a direct proof:
`Phi_m(a)` is the product of `|a-zeta|` over primitive unit roots, and every
factor lies between `a-1` and `a+1`. The lower equality is possible only for
`m=1`; the upper only for `m=2`.

This may be the old report's anticipated “third uncaught” number-language
slippage. It is a correction to a retained transcript, not a novelty claim and
not a request to revive its retired executable substrate.
