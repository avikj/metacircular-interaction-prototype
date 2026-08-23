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

## The antisymmetry (proved by exhaustion for z ≤ 13, derivation owed)

At every z checked, and in three wall-classes (a = 1; a = 105; a = 2):

    E(H) + E((P/2 − 1) − H) = 0   for every H — exactly.

Verified at all H over the period (hence proved for these z: the
check is the complete case analysis). The extremes therefore come in
±pairs at reflected window sizes (z = 7: ±41/14 at H = 42, 167).
A general derivation from S's evenness and its behavior under the
half-period shift is owed and is one page of residue bookkeeping;
until written, the claim's scope is exactly z ≤ 13, a ∈ {1, 2, 105}.

## Rigor boundary

- **Proved (exhaustive, complete per z)**: the table; the
  antisymmetry for the listed z and a.
- **Owed**: the general antisymmetry derivation; the ½Σ|R| comparison
  runner; z = 17 (P = 510510 — minutes compiled, the next term).
- **Refused**: any fitted growth law from five points.
