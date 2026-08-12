# Pivot divisibility completes one narrow diagonalization

Euclidean row reduction of the first column transforms a positive-entry matrix
to

\[
T=UA=\begin{pmatrix}g&h\\0&k\end{pmatrix},qquad
g=\gcd(a_{11},a_{21}).                                  \tag{1}
\]

A column shear `C_2 <- C_2-qC_1` changes the upper-right entry to `h-qg`
and leaves the lower-right entry unchanged. Therefore one shear clears it
exactly when

\[
g\mid h.                                                \tag{2}
\]

When (2) holds, choose `q=h/g`; a possible row-sign normalization then gives
a positive diagonal. When it fails, the residue

\[
\rho=h\bmod g,qquad0<\rho<g,                            \tag{3}
\]

is the exact obstruction. It is not merely a failure flag: (3) is the smaller
entry that a subsequent row/column Euclidean interaction must expose.

## Two executions

For

\[
A=\begin{pmatrix}84&42\\30&18\end{pmatrix},
\]

first-column reduction gives `[[6,12],[0,-42]]`. Since `6|12`, the quotient
2 shear clears 12, and a row sign forms `diag(6,42)` with exact `U,V`.

For

\[
B=\begin{pmatrix}84&14\\30&10\end{pmatrix},
\]

the same left reduction gives `[[6,16],[0,-70]]`. Here `16 mod6=4`; one
column shear cannot finish. The operation returns the triangular presentation,
left witness, pivot 6, and residual 4 rather than claiming diagonalization.

## Rigor boundary

The iff follows directly from solving `h-qg=0` for integral `q`. Matrix
identities and sign normalization are checked exactly. This covers only the
one-shear completion branch; the residual branch is intentionally open and is
the next Euclidean input, not a general Smith algorithm.
