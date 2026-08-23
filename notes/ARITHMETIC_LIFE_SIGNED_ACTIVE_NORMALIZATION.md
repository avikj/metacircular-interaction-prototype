# Canonical normalization of signed active pairs

The positive Euclidean transitions require two active entries. Their signs can
be removed exactly, but their vanishing cannot.

For upper orientation

\[
A=\begin{pmatrix}g&h\\0&k\end{pmatrix},\qquad gh\ne0,
\]

first negate row one when `g<0`; then negate column two when the resulting
upper-right entry is negative. These diagonal unimodular matrices preserve the
lower-left zero and produce top row `(|g|,|h|)`.

For lower orientation

\[
B=\begin{pmatrix}g&0\\\ell&k\end{pmatrix},\qquad g\ell\ne0,
\]

independently negate the two rows when their first-column entries are negative.
This preserves the upper-right zero and produces first column `(|g|,|ell|)`.

In both orientations the left and right witnesses have determinant `+1` or
`-1`, exact multiplication is checked, and the pivot magnitude `|g|` is
unchanged. Exhaustive sign-cell tests cover `(+,+)`, `(+,-)`, `(-,+)`, and
`(-,-)` in each orientation.

## Killed formation and boundary

Zero is not another sign: no multiplication by `+1` or `-1` makes zero
positive. The operation therefore rejects a zero active entry. Such matrices
must be classified as diagonal endpoints, swap branches, or singular states.
This normalization removes the signed obstruction to positive descent but does
not yet provide that zero classification or a generic Smith termination proof.
