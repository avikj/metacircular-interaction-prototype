# Exact gcd values over-refine the split machine

Let `rad(n)` be the product of distinct primes dividing `n`, with `rad(0)=0`.
The online split machine may replace its gcd state `(g,h)` by
`(rad(g),rad(h))`.

**Theorem.** For every continuation suffix `b_1,...,b_r`,
\[
\gcd(g,b_1,\ldots,b_r)=1
\iff \gcd(\operatorname{rad}g,b_1,\ldots,b_r)=1.             \tag{1}
\]
The analogous statement holds for complement coordinates. Hence states with
the same `(j,s,rad(g),rad(h))` have identical accepting continuation languages.

*Proof.* A gcd exceeds one exactly when some prime divides every argument.
The set of primes dividing `g`, not their exponents, is therefore the complete
information relevant to eventual gcd one. This proves (1) and its complement
version; the balance condition depends only on `(j,s)`. ∎

The compressed transition is
\[
(j,s,r,q)\mapsto(j+1,s+a,
\operatorname{rad}(\gcd(r,a)),
\operatorname{rad}(\gcd(q,C-a))).                             \tag{2}
\]
Since `r,q` are squarefree, the displayed gcds are already squarefree.

Example: partial gcd states `g=2` and `g=4` are behaviorally indistinguishable
for every future suffix, killing any claim that exact gcd is minimal.

## Rigor boundary

This proves a quotient sufficient for exact future acceptance, not that the
radical pair is globally minimal after constraints from remaining length and
sum are included. Some primes may be irrelevant in a particular `(j,s)`
state because no feasible suffix can test them.
