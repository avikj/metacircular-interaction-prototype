# A direct 2×2 Smith capability on the unit-determinant branch

For an integer `2×2` matrix `A` with `det(A)=1`, the adjugate identity gives

\[
\operatorname{adj}(A)A=A\operatorname{adj}(A)=I.
\]

Hence no generic normalization is needed: choose

\[
L=\operatorname{adj}(A),\qquad D=I,\qquad R=I.
\]

Then `D=LAR`, both presentation changes are integral inverses, and `D` is the
Smith endpoint. For every integral target `b`, the unique integral solution is
`x=adj(A)b`.

`Pairfield.DirectSmith2x2` checks a dependent capability containing `L,R,D`,
the replay equation, both inverse equations, the solver, its specification,
and uniqueness. It imports matrix adjugate identities, not a Smith normalizer.

## Common certificate adapter and determinant minus one

The direct construction now inhabits the repository's common
`Pairfield.SmithCertificate2.Valid` contract. The adapter converts `A` and its
adjugate to the concrete row-major certificate carrier, sets `(d₁,d₂)=(1,1)`,
and proves replay, unimodularity, positivity, and divisibility in that one
shared validity proposition.

The adjacent stratum `det(A)=-1` is equally closed without normalization:

\[
L=-\operatorname{adj}(A),\qquad D=I,\qquad R=I,
\]

because `adj(A)A=A adj(A)=-I`. Lean checks its common certificate validity,
solver correctness, and uniqueness. Together the two branches cover every
unimodular integer `2×2` matrix.

## Exact boundary

For a full-rank nonunit `2×2` matrix, the gcd `g` of all entries and determinant
magnitude determine only the invariant factors `d₁=g`, `d₂=|det A|/g` (when
the standard divisibility condition is stated). They do not determine the
presentation transforms `L,R`: matrices with the same invariants can differ
by unimodular row/column actions, and target execution requires those actions.
Thus extended-gcd/determinant invariants can classify the diagonal type but
cannot compile a general target-transforming capability without retaining
Bezout/presentation witnesses or performing normalization.

## Rigor boundary

Both unimodular-sign constructions are Lean-checked with no Python dependency.
The nonunit paragraph states the exact interface obstruction; it is not a
formal impossibility theorem about every specialized matrix family.

Replay: `cd formal/pairfield && lake env lean Pairfield/DirectSmith2x2.lean`.
