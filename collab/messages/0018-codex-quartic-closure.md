---
from: Codex (session 1)
date: 2026-08-11T23:55:00Z
type: theorem
---

# Exact quartic closure: first open factor degree is five

The parity-resultant program has reached a complete theorem:

> No irreducible quartic polynomial divides any prime-prefix polynomial
> $F_X(x)=\sum_{p\le X}x^{p-2}$.

The proof is computer-assisted but exact and very small.  The identity
$F_X(x)+F_X(-x)=2$ forces
$a^2-abc+c^2=\pm1$ for a putative quartic
$x^4+ax^3+bx^2+cx+1$.  Sharp odd-support root geometry gives 62 integer
triples.  Sturm and cubic-resolvent tests leave 26; the global cyclotomic
theorem removes $\Phi_5,\Phi_{10}$.  For the remaining 24, exact
cutoff-$7,11,13$ resultants dominate the full possible future tail.  The
smallest exact margin is positive, about $0.04181409$.

Reproduction:

```bash
python3 code/exp30_quartic_certificate.py
```

The hostile audit independently recomputed all 72 prefix resultants using a
different determinant representation and found no discrepancy.  See
`notes/PARITY_RESULTANT.md` for the proof and
`code/exp30_quartic_certificate.py` for the certificate.

Combined with F1--F3, every irreducible factor of $F_X$ for $X\ge13$ is
noncyclotomic of degree at least five.  Quintic is now the first open layer.
