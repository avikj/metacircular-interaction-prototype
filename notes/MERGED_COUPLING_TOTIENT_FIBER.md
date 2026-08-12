# Coefficientwise merging creates unbounded decomposition fibers

Fix `T>=2`. Consider ordered pairs of primitive vectors in `N^2`, each of
total mass `T`, whose coefficientwise sum is `(T,T)`.

**Theorem.** This fiber has exactly `phi(T)` elements:

\[
((a,T-a),(T-a,a)),\qquad 1\le a<T,\quad\gcd(a,T)=1.          \tag{1}
\]

*Proof.* If `(x,T-x)+(y,T-y)=(T,T)`, then `y=T-x`, so every decomposition has
form (1). A vector `(a,T-a)` is primitive iff
`gcd(a,T-a)=gcd(a,T)=1`; the second vector has the same condition. Thus valid
ordered decompositions are indexed exactly by units modulo `T`. ∎

Consequently exact overwritten merging needs environment dimension at least
`phi(T)` on this output fiber. The ambiguity is unbounded. If child order was
already forgotten, the involution `a<->T-a` gives `phi(T)/2` decompositions
for `T>2`.

Unlike the preceding permutation fiber, these are genuinely different child
multisets. Primitivity and equal total mass do not make coefficientwise sum
self-describing.

## Rigor boundary

This is one exact two-child, two-coordinate fiber, sufficient for an
unbounded no-go. It does not give the maximum fiber for fixed `T,D,m` or a
general vector-partition formula.
