# A Smith-defect separation at the decic frontier

## Result

The full defect module from `RESULTANT_OBSERVER_DEFECT.md` does not improve
the parity-resultant filters already used in degrees four through nine.  Those
filters impose

\[
   \operatorname{Res}(E,O)=\pm1,
\]

so multiplication by (O) on \(\mathbb Z[y]/(E)\) is unimodular and its
cokernel is zero.  There is no Smith information left to extract.  Likewise,
the later prefix resultants are presently used through their nonvanishing and
absolute magnitude in analytic tail inequalities; without a module-valued
divisibility condition, replacing the magnitude by a Smith form supplies no
valid extra rejection.

At the first nonreciprocal decic frontier, however, the lift is strict.  Put

\[
\begin{aligned}
q_A={}&x^{10}-x^8-x^7+x^6+x^5+x^3-x^2-x+1,\\
q_B={}&x^{10}+x^8+x^6-x^5+x^4-x^3-x+1,
\end{aligned}                                                    \tag{1}
\]

and let \(q^*(x)=x^{10}q(x^{-1})\).  Both polynomials satisfy the parity-unit
condition, have no real roots, have all ten roots in

\[
  \varphi^{-1}<|z|<\sqrt2,
\]

and are irreducible over \(\mathbb Q\) (Rabin certificates modulo (11) and
(3), respectively).  They also have the same scalar reversal resultant:

\[
 \operatorname{Res}(q_A,q_A^*)
 =\operatorname{Res}(q_B,q_B^*)=16.                    \tag{2}
\]

Nevertheless their integral observer-defect modules are different:

\[
 \boxed{
 \mathcal D(q_A,q_A^*)\cong(\mathbb Z/4)^2,
 \qquad
 \mathcal D(q_B,q_B^*)\cong\mathbb Z/16.}             \tag{3}
\]

Thus the determinant forgets a distinction that is already operational on
prime-prefix support.

## Exact derivation of the Smith forms

Let \(M_A,M_B\) be the integer matrices for multiplication by \(q_A^*\) and
\(q_B^*\) on \(\mathbb Z[x]/(q_A)\) and \(\mathbb Z[x]/(q_B)\).  Exact
Bareiss determinants give

\[
 \det M_A=\det M_B=16.                                 \tag{4}
\]

The gcds of their order-nine minors are

\[
 \Delta_9(M_A)=4,
 \qquad
 \Delta_9(M_B)=1.                                     \tag{5}
\]

Since the largest Smith invariant is \(\Delta_{10}/\Delta_9\), the largest
invariants are (4) and (16).  Reduction modulo two gives nullities two and
one.  Hence (M_A) has exactly two nonunit Smith factors, whose product is
(16) and each of which is at most (4), so they are (4,4).  Matrix
(M_B) has one nonunit factor, necessarily (16).  This proves (3) without
calling an external Smith-normal-form implementation.

Equivalently, the local collision polynomials are

\[
 \gcd(\bar q_A,\bar q_A^*)=x^2+x+1,
 \qquad
 \gcd(\bar q_B,\bar q_B^*)=x+1                       \tag{6}
\]

over \(\mathbb F_2\).  Formula (2.4) of
`RESULTANT_OBSERVER_DEFECT.md` recovers the two defect dimensions.

## A theorem-level candidate reduction

Let

\[
 F_X(x)=1+\sum_{3\le p\le X}x^{p-2}.
\]

The endpoint conditions for (q_B\mid F_X) require

\[
 \pi(X)\equiv2\pmod8,                                  \tag{7}
\]

because \((q_B(1),q_B(-1))=(2,8)\).  At every cutoff satisfying (7), the
scalar resultant (16) treats (q_A,q_B) identically, while their local
syndromes separate them:

\[
 F_X\equiv0\pmod{x+1},
 \qquad
 F_X\not\equiv0\pmod{x^2+x+1}.                        \tag{8}
\]

Indeed, modulo (x+1) the first remainder is \(F_X(1)=\pi(X)\equiv0\pmod2\).
For the second statement, let (n_1,n_5) count primes greater than (3) in
the two residue classes modulo (6).  In
\(\mathbb F_2[x]/(x^2+x+1)\), where (x^3=1),

\[
 F_X\equiv1+x+n_1x^2+n_5.
\]

Condition (7) implies \(n_1+n_5=\pi(X)-2\equiv0\pmod2\).  After using
\(x^2=x+1\), the constant coefficient of the displayed remainder is therefore
(1+n_1+n_5=1\), proving nonvanishing.

Consequently the module-valued/local filter separates this displayed
same-scalar pair, reducing it from two candidates to one at every
endpoint-eligible cutoff. This is not a claim that the pair exhausts the full
scalar-resultant-16 bucket. It does **not** prove that \(q_B\) divides any
prime-prefix polynomial; it says only that (q_A\) is rejected by a condition
which the scalar resultant cannot see.

The replay also scans the \(1{,}199\) eligible prime-prefix states—one state
at each prime cutoff \(X\le100000\) satisfying
\(\pi(X)\equiv2\pmod8\). All \(1{,}199\) reproduce (8). That census is a
regression check, not evidence beyond the proof above.

## Scope

The gain comes from retaining the local multiplication map—concretely its
modular gcd and syndrome—not from computing Smith forms indiscriminately.
The Smith module proves that the scalar has forgotten something; a rejection
requires an external divisibility statement whose reduction lands in that
module.  Unit-resultant filters have zero defect, and magnitude-only tail
bounds have no such landing map.  The useful rule is therefore:

> lift a scalar resultant only where the candidate pipeline supplies a
> module-valued divisibility or remainder condition.

`code/exp63_smith_defect_filter.py` replays every exact assertion above.
