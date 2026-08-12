# The minimal record for the totient split fiber

For the merged output `(T,T)`, ordered primitive equal-mass decompositions are
\[
D_a=((a,T-a),(T-a,a)),\qquad a\in U_T=(\mathbb Z/T\mathbb Z)^\times.
\]

**Theorem.** The unit residue `a` is a coarsest exact side record for ordered
reversal. Its alphabet has size `phi(T)`. If child order is irrelevant, the
coarsest record is the orbit `[a]={a,-a}` in `U_T/{\pm1}`; for `T>2` its
alphabet has size `phi(T)/2`.

*Proof.* Reading the first coordinate of the first child recovers `a`, and
`a` reconstructs `D_a`, so the record is sufficient. Conversely all `D_a`
map to the same merged output, hence any zero-error record must distinguish
every ordered fiber element and needs at least `phi(T)` values. After quotient
by child exchange, `D_a` and `D_b` agree exactly when `b=a` or `b=-a`; the same
injectivity argument proves the unordered statement. For `T>2`, no unit is
fixed by negation, since `2a=0 mod T` and `gcd(a,T)=1` would imply `T|2`. ∎

The missing state is therefore not an arbitrary partition certificate but a
projective unit residue. In this family, merging converts visible primitive
children into one element of the arithmetic quotient `U_T/{±1}`.

## Rigor boundary

This coarsest-record theorem is restricted to the symmetric two-coordinate
fiber `(T,T)`. General merged vectors may have stabilizers and decomposition
spaces not governed by a unit group.
