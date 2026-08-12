# A witnessed Smith path transports target and solution

The diagonal Smith consumer becomes a solver for a non-diagonal matrix once
it receives explicit integer unimodular witnesses. Suppose

\[
 UAV=D=\operatorname{diag}(d_1,d_2),\qquad \det U,\det V\in\{\pm1\}. \tag{1}
\]

Writing `z=Vw`, the equation `Az=b mod m` is equivalent to

\[
 Dw=Ub\pmod m.                                           \tag{2}
\]

Indeed multiply the original equation by `U` and substitute `z=Vw`.
Conversely `U` and `V` are invertible over the integers and hence modulo every
`m`, so no solutions are introduced or lost. The diagonal operation classifies
(2); multiplying its representative and kernel generators by `V` reconstructs
the original affine solution module.

## One exact non-diagonal execution

Take

\[
A=\begin{pmatrix}2&4\\6&8\end{pmatrix},\quad
U=\begin{pmatrix}1&0\\-3&1\end{pmatrix},\quad
V=\begin{pmatrix}1&-2\\0&1\end{pmatrix}.
\]

Direct multiplication gives

\[
UAV=\operatorname{diag}(2,-4).
\]

Using the equivalent positive diagonal coordinate `4` requires also negating
the second row; therefore the executable certificate instead uses

\[
U'=\begin{pmatrix}1&0\\3&-1\end{pmatrix},\qquad
U'AV=\operatorname{diag}(2,4).                            \tag{3}
\]

For `b=(14,18)` and `m=30`, `U'b=(14,24)`. The diagonal system forms

\[
w_1\equiv7\pmod {15},\qquad w_2\equiv6\pmod {15},
\]

with kernel size `gcd(2,30)gcd(4,30)=4`. Reconstruction `z=Vw` gives the
representative `(25,6)` modulo 30, which replays both original rows.

## Certificate discipline

The executable checks `det U=det V=+-1` and the exact integer identity (1)
before solving. A false row-operation witness is rejected before any modular
conclusion. This is not a generic Smith algorithm: it is the first verified
transport through a supplied Smith path, and it exposes the proof object a
future reducer must emit.

## Rigor boundary

Equivalence (2) is proved above; diagonal solvability and fiber size were
proved in `ARITHMETIC_LIFE_DIAGONAL_SMITH_SYSTEM`. No novelty is claimed.
The solution fiber is now retained intensionally. In diagonal coordinates its
kernel generators are `(m/g_1,0)` and `(0,m/g_2)`, of orders `g_1,g_2`.
Applying `V` transports them to the original coordinates without changing
orders or introducing relations, because `V` is an automorphism modulo `m`.
For the example these are `(15,0)` and `(0,15)`, each of order 2. Hence every
solution is uniquely

`(25,6) + alpha(15,0) + beta(0,15)`, `alpha,beta in Z/2`.

Completeness follows by transporting the proved diagonal kernel decomposition
through the bijection `V`; the four solutions need not be enumerated as
evidence.
