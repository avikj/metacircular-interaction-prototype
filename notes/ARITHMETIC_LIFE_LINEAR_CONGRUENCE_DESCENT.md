# A nonunit equation descends to a unit equation

The local-to-global inverse operation solved `az=b mod m` only when `a` was a
unit modulo `m`. Exponent overlap turns that boundary into an exact state
transition rather than another rejected case.

Put

\[
 g=\gcd(a,m).                                             \tag{1}
\]

Then

\[
 az\equiv b\pmod m
\]

has a solution exactly when `g` divides `b`. Necessity follows because `g`
divides both `az` and `m`. If `g|b`, divide the equality
`az-b=km` by `g` to obtain the equivalent unit equation

\[
 (a/g)z\equiv b/g\pmod {m/g}.                            \tag{2}
\]

Now `gcd(a/g,m/g)=1`, so the already formed composite inverse solves (2).
If its unique residue is `r mod m/g`, the solutions modulo `m` are exactly

\[
 r, r+m/g, \ldots, r+(g-1)m/g.                        \tag{3}
\]

They are distinct modulo `m`, and every solution belongs to this list by the
uniqueness in (2). Thus the overlap measures both the obstruction and, on the
compatible branch, the multiplicity of lifts.

## Execution inside 1--100

For `12z=18 mod 30`, exponent meet forms `g=6`; since `6|18`, the equation
descends to

\[
 2z\equiv3\pmod5.
\]

The earned mod-5 inverse is 3, giving `z=4 mod 5`, hence the six solutions

\[
 4,9,14,19,24,29\pmod {30}.
\]

For `12z=5 mod 30`, the same overlap 6 does not divide 5 and is returned as
the exact obstruction; no inverse is attempted. The endpoint `m|a,m|b` is
also explicit: the reduced modulus is 1 and every residue modulo `m` solves.

## Replay and rigor boundary

Run `cd machinery && python3 -m unittest test_exponent_world.py`. The proof
above is elementary and complete; the executable independently checks every
reported lift in the original equation. No novelty or minimality claim is
made. In particular, the new formed-locus broadcasts do not narrow this
result: solvability is an equivalence for the named equation, not a lower
bound quantified over perturbations outside the organism's reachable world.
