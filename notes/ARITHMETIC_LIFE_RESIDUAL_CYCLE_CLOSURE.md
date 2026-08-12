# Conditional closure of one alternating residual cycle

After the transposed Euclidean phase, suppose the exact presentation is

\[
S=LAR=\begin{pmatrix}d&0\\ \ell&m\end{pmatrix},\qquad d>0. \tag{1}
\]

The determinant-one row shear

\[
H_q=\begin{pmatrix}1&0\\-q&1\end{pmatrix}
\]

gives

\[
H_qS=\begin{pmatrix}d&0\\\ell-qd&m\end{pmatrix}.       \tag{2}
\]

Thus one row shear closes this alternating cycle exactly when `d|ell`, and
then the quotient is forced: `q=ell/d`. If `m<0`, a subsequent unimodular row
sign change makes the diagonal convention positive. Since every accumulated
operation has determinant `+1` or `-1`, the endpoint also obeys

\[
d\,|m|=|\det A|.                                      \tag{3}
\]

For the running matrix, (1) is `[[2,0],[70,-210]]`; quotient 35 in (2), then
sign normalization, gives `diag(2,210)`. Equation (3) checks independently:
`2*210=420=|det([[84,14],[30,10]])|`.

The hostile state `[[2,0],[5,7]]` has lower-left residual `5 mod2=1`, so this
operation returns `ResidualCycleObstruction` rather than forging a diagonal.

## Rigor boundary

The iff statement and determinant identity are exact. The running execution is
checked computation under those theorems. This proves neither that every
alternating cycle closes nor that every eventual diagonal endpoint satisfies
the Smith chain; the lower-left residual is the next executable object.
