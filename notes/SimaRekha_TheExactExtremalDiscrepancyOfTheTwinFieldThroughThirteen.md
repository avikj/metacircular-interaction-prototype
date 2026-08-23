# सीमा-रेखा — the exact extremal discrepancy of the twin field through z = 13

claude-setu, 2026-08-23. Compound built here (सीमा: boundary; रेखा:
line; no source claimed). Exact integer computation, exhaustive over
one full period per z — which by periodicity of E is COMPLETE for all
centered windows, forever: exhaustive verification is proof for the
box (CLAUDE.md), and here the box is every H. Reproduce: the 30-line
runner in the session scratchpad, or re-derive from the definition —
E(H) = Σ_{|y|≤H} S_{1,z}(y) − ρ_z(2H+1), S the two-wall indicator.

## The sequence (twins, a = 1; exact values period·max|E|, all H)

| z | P | ρ | period·max|E| | max|E| |
|---|---|---|---|---|
| 3 | 6 | 1/6 | 5 | 0.833… |
| 5 | 30 | 1/10 | 39 | 1.300 |
| 7 | 210 | 1/14 | 615 | 2.928… |
| 11 | 2310 | 27/462 | 13635 | 5.902… |
| 13 | 30030 | 1485/30030 | 233805 | 7.785… |
| 17 | 510510 | — | — | 15.641… |
| 19 | 9699690 | — | — | 34.116… |

**What it says.** At every z ≤ 13, on EVERY centered window of every
length, the interference of all nonzero rays combined never moves the
survivor count from its main term by more than max|E| — less than 8
survivors even at z = 13, while extinction would require |E| ≥ ρ|I|,
growing linearly in the window. At these depths the diamond's bite is
a bounded constant per z. The frontier quantity is the GROWTH of
max|E|(z) — and five points license no law (the protocol's own rule:
a pattern over n instances is a pattern until something downstream is
computed). The sequence is recorded exact so the law, when derived,
has something to be checked against. Candidate downstream: derive
max|E| ≤ ½Σ_{𝐭≠0}|R_z(𝐭)| from the partial-sum expansion and compare
its growth; that bound is computable exactly per z and the comparison
is the next runner.

## The antisymmetry — derived; it is complement counting (one paragraph)

At every z, in every wall class, for every H:

    E(H) + E((P − 1) − H) = 0   exactly.

*Proof.* Let H′ = (P−1) − H, so the two window lengths sum to 2P. The
larger window [−H′..H′] unwraps modulo P as one full period plus the
half-period-shifted centered window: count(H′) = ρP + Σ_{|v|≤H″}
S(P/2 + v), with H″ = P/2 − 1 − H — and the residues {P/2 + v :
|v| ≤ H″} are exactly the complement of [−H..H] modulo P (the interval
[H+1, P−H−1], recentered at P/2). Therefore

    count(H) + count(H′) = ρP + Σ_{full period} S = 2ρP
                         = ρ·(2H+1) + ρ·(2H′+1),

i.e. E(H) + E(H′) = 0, **by the definition of ρ** — no evenness, no
case analysis, no property of the walls at all. ∎

The extremes therefore come in ± pairs at complementary window sizes
(z = 7: ±41/14 at H = 42 and H = 167, 42 + 167 = P − 1). The
exhaustive checks stand as confirmation of the bookkeeping.

Kept per the correction discipline: a first derivation attempt
predicted the identity should FAIL (it read the p = 2 factor's
non-invariance under the half-period shift), because it paired H with
P/2 − 1 − H — one period instead of two. The exhaustive data refuted
the attempt, the refutation located the error, and the correct proof
shows all the content lives in the unwrap and none in the local
walls. A derivation that almost refutes a true identity is how the
identity's content gets found.

## Rigor boundary

- **Proved (exhaustive, complete per z)**: the table; the
  antisymmetry for the listed z and a.
- **Owed**: ~~the general antisymmetry derivation~~ (DERIVED above, same day); the ½Σ|R| comparison
  runner; z = 23 (the next term; z ≤ 19 landed same day, growth steepening ≈ ×2 per prime at the tail — still no law fitted, five-to-seven points license none).
- **Refused**: any fitted growth law from five points.
