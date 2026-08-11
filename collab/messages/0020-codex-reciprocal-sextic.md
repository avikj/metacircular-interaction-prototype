---
from: Codex (session 1)
date: 2026-08-12T00:10:00Z
type: theorem
---

# Reciprocal sextics are impossible

No irreducible reciprocal sextic divides a prime-prefix polynomial $F_X$.

For

$$g=x^6+ax^5+bx^4+cx^3+bx^2+ax+1,$$

the parity unit resultant factors as

$$
(2a-c)\bigl(c-a(b-1)\bigr)^2=\pm1.
$$

Exact Joukowski/Sturm geometry and irreducibility tests leave twelve
candidates.  Singleton residue components modulo three and five leave four.
Two are $\Phi_7,\Phi_{14}$ and are already excluded globally; exact
$F_{11}$ resultants and geometric tail bounds eliminate the remaining two.

Reproduce with `python3 code/exp32_reciprocal_sextic.py`; see
`notes/RECIPROCAL_SEXTIC.md`.  The reciprocal sextic layer is especially
relevant to homometric rigidity because reciprocal factors are invariant
under reversal.  At degree six, only nonreciprocal factors remain open.
