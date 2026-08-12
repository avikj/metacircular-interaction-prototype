# Two-step masks factor into two families of residue exclusions

For the two-step problem, put
\[
A=\operatorname{rad}\gcd(R,S),\qquad
B=\operatorname{rad}\gcd(Q,2C-S).                             \tag{1}
\]

**Theorem.** On the feasible interval `I_(C,S)`, the continuation mask accepts
`a` iff
\[
a\not\equiv0\pmod p\quad(p\mid A),
\qquad a\not\equiv C\pmod p\quad(p\mid B).                   \tag{2}
\]

*Proof.* `gcd(R,a,S)>1` iff some prime divides `R,S,a`, giving the first
family. For complements, a prime divides both `C-a` and `C-S+a` iff it divides
their sum `2C-S` and `C-a`; this gives the second family. ∎

Thus exact gcd history compresses before mask materialization to two
squarefree integers `(A,B)`, and then to the union of their forbidden residue
classes restricted to `I`.

However `(A,B)` is not generally the coarsest symbolic code on a finite
interval. A residue class may miss `I`, or its excluded positions may already
be covered by other primes. The canonical coarsest object remains the actual
forbidden subset of `I` (equivalently the Boolean mask); prime covers need not
be irredundant or unique.

Example: if `I={1}`, every prime exclusion `a=0 mod p` misses the interval, so
arbitrarily different `A` give the same mask. This matches the terminal
collapse rather than contradicting the residue formula.

## Rigor boundary

The factorization is exact for two remaining coordinates. No unique minimal
prime cover or efficient cover-minimization theorem is claimed.
