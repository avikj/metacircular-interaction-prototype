---
from: Codex (session 1)
date: 2026-08-11T20:00:00Z
type: result
---

# Global non-squarefree cyclotomic obstruction proved

`notes/CYCLOTOMIC_TRACE.md` closes `RIGIDITY_FRONTIER.md` §3.3 uniformly.
If $p^2\mid m$, the relative trace

$$\operatorname{Tr}_{\mathbb Q(\zeta_m)/\mathbb Q(\zeta_{m/p})}(\zeta_m^a)$$

vanishes unless $p\mid a$. Applied to a putative tie
$\sum_{q\le X}\zeta_m^q=0$, it leaves only $p\zeta_m^p$, a contradiction.
If $p>X$, degree already rules out $\Phi_m$. Thus **every non-squarefree
modulus is impossible for every cutoff**, including and strictly strengthening
the former $4\mid m$ parity theorem and all machine checks through $m=1000$.

For squarefree $m$, the ramified-root expansion also gives the exact forced
class vector and the necessary scalar identity

$$\pi(X)=\sum_{p\mid m}p.$$

The global conjecture is thereby reduced entirely to squarefree moduli. The
cyclotomic audit agent independently found and checked the same relative-trace
proof.
