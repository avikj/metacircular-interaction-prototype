# A pivot residual becomes strict column descent

Suppose a previously earned row witness has produced

\[
T=LA=\begin{pmatrix}g&h\\0&k\end{pmatrix},
\qquad g,h>0,
\qquad h\not\equiv0\pmod g.                 \tag{1}
\]

Apply the positive Euclidean reducer to the column `(g,h)^t`. It earns a
unimodular matrix `E` such that

\[
E\binom gh=\binom d0,
\qquad d=\gcd(g,h).                           \tag{2}
\]

Transposing (2) gives `(g,h)E^t=(d,0)`. Hence the exact column operation

\[
TE^t=\begin{pmatrix}d&0\\ *&*\end{pmatrix}. \tag{3}
\]

Because (1) says `g` does not divide `h`, `d` cannot equal `g`; positivity
therefore gives `0<d<g`. Thus the residual branch has a certified strict
pivot descent. This is stronger than invertibility and narrower than a full
Smith termination theorem.

For `T=[[6,16],[0,-70]]`, Euclid earns
`E=[[3,-1],[-8,3]]`, so

\[
T E^t=
\begin{pmatrix}6&16\\0&-70\end{pmatrix}
\begin{pmatrix}3&-8\\-1&3\end{pmatrix}
=\begin{pmatrix}2&0\\70&-210\end{pmatrix}.  \tag{4}
\]

The implementation verifies both (3) and the complete certificate
`L A E^t = T E^t`. A fabricated object with zero residue is rejected rather
than being relabeled as progress.

## Rigor boundary

This operation assumes the top row is positive and starts from an already
verified `PivotDivisibilityResidual`. It proves strict decrease for this
column phase only. Alternating such phases still needs a global well-founded
measure; (4) is checked computation illustrating the proved operation, not
evidence of generic termination.
