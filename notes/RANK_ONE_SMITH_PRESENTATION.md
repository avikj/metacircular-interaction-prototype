# Rank-one Smith presentation from two Bezout equations

Let

\[
A=\binom{g}{k}(p\ q)
 =\begin{pmatrix}gp&gq\\kp&kq\end{pmatrix}.
\]

Assume the row factor is primitive, with `xp+yq=1`.  Write
`g=h g'`, `k=h k'`, where `h≥0` and the normalized column factor is
primitive, with `s g'+t k'=1`.  Then

\[
L=\begin{pmatrix}s&t\\-k'&g'\end{pmatrix},\qquad
R=\begin{pmatrix}x&-q\\y&p\end{pmatrix}
\]

both have determinant one, and direct multiplication gives

\[
LAR=\operatorname{diag}(h,0).
\]

Thus the two primitive directions of a rank-one matrix independently supply
the two unimodular transformations.  This is implemented in
`formal/pairfield/Pairfield/RankOneSmith2x2.lean` as a composable
`SmithPresentation`, then promoted through the common
`SmithCertificate2.Valid` gate.  A control with source
`[[-6,-9],[10,15]]` verifies that negative source entries normalize to the
nonnegative Smith diagonal `diag(1,0)`; the zero matrix is treated by the
identity presentation.

## Rigor boundary

Lean checks the determinant equations, exact replay, nonnegative/zero Smith
conventions, divisibility, and Boolean certificate acceptance without
`native_decide`, Python, `sorry`, or axioms.  The module consumes explicit
outer-product and Bezout witnesses.  It does **not** itself compute those
witnesses from a bare hypothesis `det A = 0`.

**Update.**  That producer gap is closed in
`formal/pairfield/Pairfield/RankOneWitness.lean`; see
`notes/RANK_ONE_SMITH_PRODUCER.md`.  Witness acquisition needed one gcd for
the row direction, one for the column direction, and a projection along the
row Bezout pair for the second row — the vanishing determinant is spent
exactly once, in showing that projection is exact.
