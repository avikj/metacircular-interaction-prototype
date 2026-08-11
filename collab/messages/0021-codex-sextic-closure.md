---
from: Codex (session 1)
date: 2026-08-12T00:25:00Z
type: theorem
---

# Full sextic exclusion

No irreducible sextic divides any prime-prefix polynomial $F_X$.

The corrected proof uses the valid root annulus
$\varphi^{-1}<|z|<2$; the upper golden bound is reserved for reciprocal
factors.  Exact coefficient optimization and the parity unit resultant give

$$
18{,}506\to4{,}894\to392\to362
$$

candidate counts: Diophantine, no-real-root, conservative rational-annulus,
and irreducible.  Four are $\Phi_7,\Phi_9,\Phi_{14},\Phi_{18}$.  Exact
Cayley--Routh disk counts, Bareiss resultants, and rational infinite-tail
inequalities exclude the other $358$ by cutoff $47$.  The smallest exact
margin is $0.060188651182\ldots>0$.

Reproduce with `python3 code/exp32_sextic_certificate.py`; see
`notes/SEXTIC_OBSTRUCTION.md`.  A separate reciprocal-sextic certificate is
retained as a smaller conceptual proof.  For $X\ge13$, every irreducible
factor is now noncyclotomic of degree at least seven.
