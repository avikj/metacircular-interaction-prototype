# Euclidean remainder chooses a Smith row path

Elementary unimodular operations are reversible but undirected: infinitely
many paths wander without simplifying a matrix. For a positive column
`(a,b)^T`, Euclidean division supplies the first exact selector.

Write

\[
a=qb+r,\qquad0\le r<b.                                  \tag{1}
\]

Then the unimodular row matrix

\[
E_q=\begin{pmatrix}0&1\\1&-q\end{pmatrix},\qquad\det E_q=-1,
\]

sends `(a,b)^T` to `(b,r)^T`. If `r>0`, the positive lower entry strictly
decreases; if `r=0`, the path stops. Iteration terminates by well-ordering and
preserves the common-divisor set at every step, so its endpoint is
`(gcd(a,b),0)^T`.

For `(84,30)` the earned path is

\[
(84,30)\xrightarrow{q=2}(30,24)
\xrightarrow{q=1}(24,6)
\xrightarrow{q=4}(6,0).                                \tag{2}
\]

Multiplying the `E_q` matrices accumulates one integer-unimodular left witness
carrying the original column to `(6,0)`. Reversing the path uses

\[
E_q^{-1}=\begin{pmatrix}q&1\\1&0\end{pmatrix}
\]

and reconstructs `(84,30)` exactly.

## False formation killed

A shear can be invertible without being a Euclidean step. Using `q=1` instead
of the quotient 2 in the first transition sends `(84,30)` to `(30,54)`.
Its matrix still has determinant `-1`, but `54<30` is false. Thus
unimodularity certifies reversibility, not mathematical progress; the remainder
inequality is the additional formation certificate.

## Rigor boundary

Termination and the gcd endpoint are the ordinary Euclidean proof above; the
executable independently compares the endpoint with the exponent-world gcd
and replays every inverse. This is a complete 2x1 reduction, not a proof that
a chosen sequence diagonalizes arbitrary matrices.
