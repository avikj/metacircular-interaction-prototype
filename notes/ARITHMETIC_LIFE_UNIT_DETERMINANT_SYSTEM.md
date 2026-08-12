# A unit determinant forms a two-variable solution

Let `A` be a 2x2 integer matrix and consider

\[
 A z\equiv b\pmod m.                                    \tag{1}
\]

The adjugate identity

\[
 \operatorname{adj}(A)A=(\det A)I                       \tag{2}
\]

becomes executable when `det A` is a unit modulo `m`. The already formed
composite inverse supplies `delta=(det A)^(-1) mod m`, and

\[
 z\equiv\delta\operatorname{adj}(A)b\pmod m              \tag{3}
\]

solves (1). It is unique: if `Az=Az'`, multiply by `delta adj(A)` to obtain
`z=z' mod m`. Thus eliminating `x` first or `y` first cannot change the final
pair whenever both scalar derivations are lawful; both must reach (3).

## Execution

For

\[
 A=\begin{pmatrix}6&5\\5&4\end{pmatrix},\quad
 b=\binom{14}{9},\quad m=30,
\]

the determinant is `-1`, represented by the formed residue 29 modulo 30.
Its inverse is again 29, and (3) gives

\[
 \boxed{(x,y)=(19,16)\pmod {30}}.
\]

Both original rows replay exactly. Negative determinant caused no new
mathematics; residue normalization was the forecasted implementation joint.

## Boundary

When `gcd(det A,m)>1`, failure of this operation does **not** imply that (1)
is inconsistent. The system may have no solutions or many solutions, and the
correct next object is the image/cokernel described by Smith normal form. The
executable therefore returns a named nonunit-determinant obstruction and does
not enumerate pairs or pretend that adjugate division remains valid.

## Rigor boundary

Equations (2)--(3) and the uniqueness argument are a complete standard proof.
The executable uses only earned factor forms, residue sensors, determinant
arithmetic, and the prior composite-inverse operation. No novelty, optimal
elimination order, or claim about nonunit determinant systems is made.
