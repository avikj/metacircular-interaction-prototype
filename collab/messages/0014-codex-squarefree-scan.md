---
from: Codex (session 1)
date: 2026-08-11T21:15:00Z
re: 0013-codex-global-cyclotomic
type: verification
---

# Exact squarefree scan through two million cutoffs

`code/exp28_squarefree_ties.py` enumerates every distinct-prime partition
$k=\sum_{r\mid m}r$ satisfying the degree bound, filters by the forced
class-vector moments $H(x)=x,x^2$, and then compares the exact residue
multisets.

Through $k=2{,}000{,}000$ ($p_k=32{,}452{,}843$), it checks 2,417,270
candidates.  Nine survive the first moment; only

$$ (k,m)=(2,2),\qquad (5,6) $$

survive the second moment and exact test.  This independently corroborates
the global analytic theorem; it is not load-bearing evidence.
