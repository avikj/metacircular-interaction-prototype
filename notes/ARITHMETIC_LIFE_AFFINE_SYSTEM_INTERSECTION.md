# Solved affine equations compose as aligned cosets

For one equation `az=b mod m`, gcd descent returns either an obstruction or a
single solution coset

\[
 z\equiv r\pmod M,\qquad M=m/\gcd(a,m).                 \tag{1}
\]

Equation (1), not the number of representatives modulo `m`, is the complete
downstream meaning of the equation: an integer solves the original equation
if and only if it belongs to this coset. Consequently a finite system in one
unknown is exactly the intersection of its cosets.

Given two accumulated states `z=r mod M` and `z=s mod N`, generalized CRT
gives the complete composition law:

\[
 \gcd(M,N)\mid(s-r)                                      \tag{2}
\]

if and only if the intersection is nonempty. When (2) holds, kuṭṭaka forms
one coset modulo `lcm(M,N)`; otherwise `(gcd(M,N),s-r)` is an exact alignment
defect. Induction composes any finite list. Coefficients are unnecessary for
future intersections because the equivalence defining (1) has already
transported the full solution set, but they remain attached as causal
provenance.

## Execution

The two nonunit equations

\[
 12z\equiv18\pmod {30},\qquad18z\equiv12\pmod {42}
\]

first descend to `z=4 mod5` and `z=3 mod7`. Kuṭṭaka intersects them as

\[
 \boxed{z\equiv24\pmod {35}}.
\]

Direct substitution checks both original equations. Conversely, the system
`z=4 mod6`, `z=3 mod8` fails because `gcd(6,8)=2` does not divide `3-4=-1`.
The obstruction retains the accepted equation, rejected equation, accumulated
state, and difference rather than collapsing to a Boolean failure.

The first executable replay failed before reaching this mathematics because
forming 42 can recognize its prime cofactor 7 without installing mod 7 as a
sensor. The repaired execution first encounters 91, thereby earning every
prime residue sensor through 7. This is the forecast's causal-provenance
branch: the theorem needs no sensor hypothesis, but this organism refuses to
invoke an inverse in a chart it has not yet learned to observe.

An equation whose reduced modulus is 1 contributes the universal coset and is
neutral under intersection; this endpoint is tested explicitly.

## Rigor boundary

The proof is the solution-set equivalence for each gcd descent followed by the
generalized CRT theorem already proved in `KUTTAKA_CONGRUENCE_UPDATE`. The
executable rechecks the final representative in every original equation.
No novelty, complexity optimality, or minimal-chart claim is made. This is a
one-variable affine system; coupled systems in several unknowns require
Smith/Hermite normal form rather than repeated scalar CRT.

## Formal boundary (2026-08-14)

`formal/pairfield/Pairfield/IncrementalCRTAdapter.lean` checks the complete
extensional intersection and obstruction theorem once equations have already
been reduced to coset states. Its success theorem is over the full integer
cosets, and its failure record retains the signed gcd/difference certificate;
it also exposes a checked Bézout coefficient pair.

It does not yet formalize the preceding affine reduction
`a*z ≡ b [ZMOD m] ↔ z ≡ r [ZMOD m/gcd m a]`, retain the accepted and rejected
source equations, or connect its coefficient pair to an explicit
reconstruction formula for the returned residue. Those are proof-relevant
execution data, whereas the current adapter checks their downstream
extensional quotient. Sensor availability remains an external causal gate,
not a consequence of CRT.
