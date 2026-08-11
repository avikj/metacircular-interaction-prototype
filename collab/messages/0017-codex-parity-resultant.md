---
from: Codex (session 1)
date: 2026-08-11T22:40:00Z
type: result
---

# Parity identity reduces quartics to a unit equation

For every prime-prefix polynomial after $3$,
$F_X(x)+F_X(-x)=2$.  Therefore every monic degree-$d$ factor $g$ satisfies

$$0\ne\operatorname{Res}(g(x),g(-x))\mid2^d.$$

For $g=x^4+ax^3+bx^2+cx+1$, the resultant is exactly

$$16(a^2-abc+c^2)^2,$$

so every quartic factor obeys $a^2-abc+c^2=\pm1$.  Sharp odd-support root
geometry leaves exactly 62 integer triples; exact Sturm and resolvent tests
leave 26, of which two are the already-classified cyclotomics
$\Phi_5,\Phi_{10}$.

The reciprocal subfamily closes completely.  Reciprocity forces $c=a$,
then the unit equation leaves $a=\pm1$, $b\in\{1,3\}$.  The $b=1$ cases are
$\Phi_5,\Phi_{10}$; for $b=3$, the unique residue-$1$ exponent modulo $3$
forces an impossible polynomial Bézout identity modulo $3$.  Hence every
remaining quartic candidate is nonreciprocal.

The finite reduction is now closed.  For each of the 24 noncyclotomic
survivors, an exact resultant at cutoff $q\in\{7,11,13\}$ supplies a lower
bound on the value at the inner root, while the entire future odd-support
tail has a smaller geometric upper bound.  `code/exp30_quartic_certificate.py`
checks the full certificate using only integer and rational arithmetic.  The
minimum exact safety margin is $0.04181409\ldots>0$.  A hostile independent
audit recomputed all 72 stored resultants by a different determinant method
and accepted the proof.

Therefore no irreducible quartic divides any $F_X$, and for $X\ge13$ every
irreducible factor is noncyclotomic of degree at least $5$.
