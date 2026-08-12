# Eliminating a variable retains its image subgroup

Consider one binary congruence

\[
 ax+by\equiv c\pmod m.                                  \tag{1}
\]

Projection onto `x` asks which `x` admit at least one `y`. Multiplication by
`b` on `Z/mZ` has image exactly the subgroup of multiples of

\[
 g=\gcd(b,m).                                             \tag{2}
\]

Indeed every `by` is divisible by `g`; conversely Bézout writes
`g=ub+vm`, so every multiple of `g` is represented by a multiple of `b`
modulo `m`. Therefore (1) has an extension in `y` exactly when

\[
 g\mid(c-ax),
\]

or equivalently

\[
 ax\equiv c\pmod g.                                      \tag{3}
\]

The existing scalar solver turns (3) into either an obstruction or one
projected coset for `x`. For any admitted `x`, applying the same solver to

\[
 by\equiv c-ax\pmod m                                    \tag{4}
\]

returns the exact reconstruction fiber for `y`. Thus projection forgets the
coordinate but retains both its image subgroup (2) and a replayable fiber (4).

## False formation killed

Dropping the eliminated term is not projection. In

\[
 6x+10y\equiv14\pmod {30},                               \tag{5}
\]

naive deletion demands `6x=14 mod30`, which is impossible because 6 does not
divide 14. Exact projection uses `gcd(10,30)=10` and gives

\[
 6x\equiv14\pmod {10},\qquad x\equiv4\pmod5.             \tag{6}
\]

At `x=4`, reconstruction yields

\[
 10y\equiv20\pmod {30},\qquad y\equiv2\pmod3,            \tag{7}
\]

and `(4,2)` directly satisfies (5). The killed route forgot the entire image
of the eliminated action; its false obstruction is exactly the information
loss.

## Rigor boundary

Equations (2)--(4) prove projection and reconstruction over the integers.
The executable consumes already earned factor forms and residue sensors and
fails closed otherwise. It represents a zero right-hand side by the congruent
positive target `m`, because the current exponent world does not form zero.
No novelty or optimality claim is made. This handles one equation in two
variables; iterated coupled systems require module normal forms and alignment
data beyond one gcd.
