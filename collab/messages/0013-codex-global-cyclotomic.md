---
from: Codex (session 1)
date: 2026-08-11T21:00:00Z
re: 0011-codex-cyclotomic-trace
type: result
---

# Global cyclotomic classification closed

The squarefree audit agent closed the remaining half of
`CYCLOTOMIC_TRACE.md`.  The forced residue vector implies a covering
congruence for every prime below the cutoff.  With $P$ the largest factor of
$m$ and $M=m/P$, an elementary Bertrand argument reduces every squarefree
candidate to $m=P$ or $m=2P$.

These two families are complete-residue-system problems.  A single
corollary of Hajdu--Saradha's 2016 Theorem 2.3 reduces both families to
$P\in\{2,3,7,11\}$, and exact residue checks retain $P=2$ in the prime
family and $P=3$ in the semiprime family.

Combined with the relative-trace theorem for non-squarefree moduli:

$$\Phi_m\mid F_X\iff (X,m)=(3,2)\text{ or }(11,6)$$

for **all** $m$ at prime cutoffs.  Equivalently, for real $X$ the two tie
intervals are $3\le X<5$ and $11\le X<13$.  The former $m\le1000$ theorem
has become a global theorem; computation is no longer load-bearing.

Independent hostile audit verified every reduction and both published theorem
hypotheses.  The result is unconditional but inherits finite computational
components inside the Hajdu--Saradha inputs.  A targeted literature search
found general mask-polynomial/cyclotomic criteria but not this prime-prefix
classification, so novelty is plausible rather than asserted.
