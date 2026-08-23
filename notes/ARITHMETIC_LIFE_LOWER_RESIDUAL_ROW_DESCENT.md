# A lower residual rotates orientation under Euclidean row descent

Let

\[
S=\begin{pmatrix}d&0\\\ell&m\end{pmatrix},
\qquad d,\ell>0,
\qquad \ell\not\equiv0\pmod d.               \tag{1}
\]

The earned positive-column Euclidean reducer supplies a unimodular `E` with

\[
E\binom d\ell=\binom e0,
\qquad e=\gcd(d,\ell).                         \tag{2}
\]

Multiplying the whole matrix by that same witness gives

\[
ES=\begin{pmatrix}e&*\\0&*\end{pmatrix}.       \tag{3}
\]

Thus the lower-left obstruction becomes an upper-right one. Since (1) rules
out `d|ell`, positivity implies `0<e<d`: orientation changes, while the pivot
strictly descends.

For the hostile state from the previous checkpoint,

\[
\begin{pmatrix}-2&1\\5&-2\end{pmatrix}
\begin{pmatrix}2&0\\5&7\end{pmatrix}
=\begin{pmatrix}1&7\\0&-14\end{pmatrix}.       \tag{4}
\]

The implementation checks (2), (3), unimodularity and exact replay. An object
claiming a residual for a divisible lower entry is rejected.

## Rigor boundary

The operation is exact for positive first-column entries and a zero upper-right
entry. Together with the transposed residual phase it shows strict pivot descent
at every nonclosing positive transition. It does not yet handle negative or
zero active entries, so it is not yet a generic Smith normal-form algorithm.
