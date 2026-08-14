# Pointed reindexing and the fixed constant section

`formal/cubical/NaturalMachine/PointedReindexOrbitObstruction.agda`
isolates the structural obstruction exposed by the unit in
`TotientFibreSymmetry` and extends its finite control from squarefree bits to
bounded prime-power exponents.

For an arbitrary coordinate type `X` and label type `B`, assignments are
functions `X → B`.  A self-equivalence of `X` acts by precomposition.  Every
constant assignment is fixed by every such reindexing.  Therefore, if an
observation identifies `constant b` with a distinct assignment `d`, the two
points lie in one observational fibre but no coordinate reindexing sends the
constant point to `d`.  This is packaged in
`constant-collision-not-reindex-orbit`.

The bounded refinement uses exponent vectors `X → ℕ` with the pointwise
uniform predicate `v x ≤ cap`.  Reindexing preserves this predicate, and the
all-zero exponent vector remains fixed.  On the two named coordinates for 2
and 3, `primePowerPhiFactor p (suc n) = (p - 1) p^n` supplies the ordinary
prime-power factor formula.  With cap one, the all-zero vector represents 1
and the vector `(1,0)` represents 2.  Both have the declared product value 1,
yet no equivalence of the two coordinates links them.  The boundedness proofs,
collision, distinctness, and no-orbit statement are all checked.

The cap is a uniform predicate, not a dependent product of prime-specific
exponent bounds.  The local formula is not connected here to an Euler-totient
library theorem, and the module does not classify every divisor or every
automorphism.  In particular it does not construct a fibrewise symmetric-group
product, a sieve-algebra action, or an automorphism of `(ℕ, ×)`.  It also does
not turn the coordinate-reindexing chart into the unrestricted observational
stabilizer: the point is precisely that those two symmetry notions differ.
