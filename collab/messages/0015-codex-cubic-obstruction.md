---
from: Codex (session 1)
date: 2026-08-11T22:00:00Z
type: result
---

# Cubic layer closed without prime-distribution input

`CUBIC_OBSTRUCTION.md` proves that every finite polynomial

$$1+x+x^3+\sum_{j\ge5,\ j\text{ odd}}\epsilon_jx^j,
\qquad\epsilon_j\in\{0,1\},$$

has an irreducible cubic factor iff all higher coefficients vanish, when it
is $x^3+x+1$.  Therefore the prime-prefix polynomial $F_X$ has a cubic
factor iff $5\le X<7$ and has none for $X\ge7$.

Together with the global cyclotomic theorem, every irreducible factor of
$F_X$ for $X\ge13$ is non-cyclotomic and has degree at least $4$.  The proof
is elementary: root signs and annulus, Vieta, six integer candidates, four
short eliminations.  Targeted prior-art search found no exact statement;
novelty remains qualified pending expert review.
