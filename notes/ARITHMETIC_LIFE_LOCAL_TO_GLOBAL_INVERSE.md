# Local inverse lifting becomes composite division

The arithmetic process had already formed four ingredients: prime-exponent
coordinates, division modulo an earned prime sensor, adaptive prime-power
refinement, and incremental kuṭṭaka gluing. Their first exact composition is
division modulo a formed composite integer.

Let

\[
 m=\prod_i p_i^{e_i},\qquad \gcd(a,m)=1.                 \tag{1}
\]

Exponent coordinates decide the unit condition in (1): the supports of
`v(a)` and `v(m)` must be disjoint. For each earned mod-`p_i` sensor, Bézout
descent forms an inverse `x` modulo `p_i`. If `ax=1-E` with `p_i^k|E`, set

\[
 x'=x(2-ax)=x(1+E).                                      \tag{2}
\]

Then `1-ax'=E^2`, so (2) lifts an inverse modulo `p_i^k` to one modulo
`p_i^{2k}`. Reducing at the requested exponent gives a precision-doubling
chain ending at `p_i^{e_i}`. The prime powers are pairwise coprime, so the
incremental kuṭṭaka update glues their local inverses to one residue modulo
`m`; generalized CRT proves existence and uniqueness.

## The 1--100 execution

After the encounter with 91 has earned the prime sensors through 7, exponent
formation gives `72=2^3 3^2`. Bézout first gives `5^-1=1 mod 2` and
`5^-1=2 mod 3`. Precision doubling produces

\[
 5^{-1}=5\pmod 8,\qquad 5^{-1}=2\pmod 9.
\]

Kuṭṭaka glues these to

\[
 \boxed{5^{-1}=29\pmod {72}},
\]

and the newly formed action solves `5z=17 mod 72` as `z=61`. Thus later
unit equations modulo 72 no longer invoke a fresh Euclidean descent against
72; they use the composed inverse.

The nonunit branch is equally structural. For `a=6,m=72`, exponent supports
meet first at 2, emitting the exact obstruction before any lifting or gluing.

## Replay

Run `cd machinery && python3 -m unittest test_exponent_world.py`. The tests
check the local residues, every lift exponent, the glued inverse, the induced
linear solver, the shared-prime obstruction, and the unearned-sensor gate. The
last control uses `77=7*11`: recursive formation recognizes the prime cofactor
11 without automatically installing mod 11, so the missing memory is a
reachable state rather than a manually corrupted one.

## Rigor boundary

Proved above: Newton/Hensel precision doubling for inverses; the unit criterion
from unique factorization; local-to-global existence and uniqueness by CRT.
Executed exactly: the complete `5 mod 72` formation trace and controls.
No novelty is claimed. The causal requirement that prime sensors be earned is
a property of this process, not a hypothesis of modular inversion. The method
does not yet choose among lifting, direct extended Euclid, or other algorithms
by a proved cost comparison.
