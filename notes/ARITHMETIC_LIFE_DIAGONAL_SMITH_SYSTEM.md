# A diagonal Smith system exposes image and kernel

Consider the diagonal modular map

\[
 D:(\mathbb Z/m)^2\to(\mathbb Z/m)^2,
 \qquad D(x,y)=(d_1x,d_2y).                              \tag{1}
\]

Put `g_i=gcd(d_i,m)`. Multiplication by `d_i` has image the multiples of
`g_i` and kernel size `g_i`. Therefore

\[
 D(x,y)=(t_1,t_2)                                       \tag{2}
\]

is soluble exactly when `g_i|t_i` for both coordinates. On success, scalar
gcd descent returns one coset

\[
 x_i\equiv r_i\pmod {m/g_i},                            \tag{3}
\]

and the full solution set is the Cartesian product of these two cosets. It
has exactly `g_1g_2` representatives modulo `m`. Thus the same invariant
factors record the image obstruction and the reconstruction multiplicity.

## Execution

For `m=30`, `D=diag(6,10)`, and target `(18,20)`, the two scalar descents are

\[
 x\equiv3\pmod5,\qquad y\equiv2\pmod3.                 \tag{4}
\]

There are `6*10=60` solution pairs modulo 30. Replacing the second target by
14 leaves the first coordinate valid and fails precisely at the second:
`gcd(10,30)=10` does not divide 14. The certificate names coordinate 2 and
retains the scalar obstruction rather than reducing the whole system to false.

## Relation to Smith normal form

If integer unimodular matrices `U,V` satisfy `UAV=D`, then `Az=b mod m` is
equivalent to `D(V^{-1}z)=Ub mod m`; the diagonal theorem above completes the
classification. This landing does not yet compute or verify `U,V`. It is the
consumer that states exactly what a future Smith-reduction certificate must
provide.

## Rigor boundary

The image, kernel, solvability, and cardinality claims follow coordinatewise
from the proved scalar congruence theorem. The executable checks the reported
lift counts. No novelty is claimed, and no general Smith-normal-form algorithm
or bounded enumeration is used.
