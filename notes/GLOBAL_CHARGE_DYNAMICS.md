# The global charge is an unlocalized reciprocal collision

## 0. Result

For a monic polynomial \(P\in\mathbf Z[x]\) with \(P(0)=1\), recall

\[
 \mathcal C(P)=\prod_{i<j}(1-\alpha_i\alpha_j)
              =\det(1-\wedge^2A_P).
\]

As elsewhere in the factor program,
\[
 F_X(x)=\sum_{p\le X}x^{p-2}.
\]

The divisibility condition

\[
 q\mid F_X\quad\Longrightarrow\quad
 \mathcal C(q)\mid\mathcal C(F_X)
\]

from CROSS_REVERSAL_CHARGE.md is exact, but reducing the right side
modulo a prime does not produce a new localized obstruction. Away from the
two endpoint roots, vanishing of the charge is exactly the assertion that
\(P\) has *some* reciprocal root collision. It forgets which collision came
from \(q\).

For the witness

\[
 q_1=x^{10}+x^8+x^2+x+1,
 \qquad \mathcal C(q_1)=-7,
\]

the prime prefix \(X=2129\) obeys the endpoint tether and has
\(\mathcal C(F_X)=0\pmod 7\), yet it fails the sharper quadratic collision
condition attached to \(q_1\). Thus the global charge test can accept where
the cheaper \(q_1\)-specific test already rejects.

There is also a precise state-complexity boundary. For every odd prime
\(\ell\ne3\), no degree-independent finite automaton reading arbitrary
coefficient words can decide even whether
\(\mathcal C(P)=0\pmod\ell\). This is a theorem about the unrestricted
polynomial language. It is **not** a theorem that the one distinguished
prime-prefix stream is nonregular; proving a bounded recurrence on that
stream would require new arithmetic information about the primes.

## 1. Charge zero is the global collision syndrome

Write

\[
 P^*(x)=x^nP(x^{-1})
\]

for a monic degree-\(n\) polynomial of constant term one.

**Theorem 1 (endpoint-clean collision criterion).** Let \(k\) be a field
of odd characteristic and let \(P\in k[x]\) be monic with \(P(0)=1\). If
\(P(1)P(-1)\ne0\), then

\[
 \boxed{
 \mathcal C(P)=0
 \quad\Longleftrightarrow\quad
 \gcd(P,P^*)\ne1.}                                  \tag{1.1}
\]

**Proof.** In an algebraic closure, \(\mathcal C(P)=0\) precisely when two
distinct root occurrences \(\alpha_i,\alpha_j\) satisfy
\(\alpha_i\alpha_j=1\). Then \(\alpha_i\) is a root of both \(P\) and
\(P^*\).

Conversely, a common root \(\alpha\) of \(P\) and \(P^*\) is nonzero, and
\(\alpha^{-1}\) is also a root of \(P\). The endpoint hypothesis excludes
\(\alpha=\alpha^{-1}=\pm1\), so these are distinct root occurrences and
one factor in \(\mathcal C(P)\) vanishes. This argument also handles
multiplicities. \(\square\)

The endpoint condition is load-bearing. A single simple root \(1\) or
\(-1\) makes \(P\) and \(P^*\) meet at that point, but it does not by itself
give a pair \(i<j\) in the exterior-square product.

Now let \(q\in\mathbf Z[x]\), let an odd prime \(\ell\) divide
\(\mathcal C(q)\), and put

\[
 h_\ell=\gcd(\bar q,\bar q^*)\in\mathbf F_\ell[x].
\]

In the nondegenerate cross-index setting of CROSS_REVERSAL_CHARGE.md,
\(h_\ell\) is a nonconstant reciprocal polynomial without endpoint roots.
Consequently

\[
 h_\ell\mid\bar F_X
 \quad\Longrightarrow\quad
 \mathcal C(F_X)=0\pmod\ell.                         \tag{1.2}
\]

The left side specifies the collision belonging to \(q\). The right side
is the union of that event with every other reciprocal collision available
to \(F_X\). Therefore (1.2), not an equivalence, is the correct information
ordering. Evaluating \(F_X\bmod h_\ell\) is both more localized and, when
\(\deg h_\ell\) is small, cheaper than computing the global charge.

## 2. Exact \(q_1\) counterexample at \(X=2129\)

Let

\[
 \Phi_6=x^2-x+1.
\]

Modulo \(\Phi_6\), one has \(x^3=-1\) and \(x^5=1-x\). For a prime cutoff
\(X\ge3\), define

\[
 A(X)=\#\{3<p\le X:p\equiv1\pmod6\},\qquad
 B(X)=\#\{3<p\le X:p\equiv5\pmod6\}.
\]

The contributions of \(p=2,3\) are \(1,x\), while every larger prime is
\(1\) or \(5\) modulo \(6\). Hence the following is an identity in every
coefficient ring:

\[
 \boxed{
 F_X\equiv(1+A(X)-B(X))+(1-A(X))x\pmod{\Phi_6}.}     \tag{2.1}
\]

At the fixed cutoff \(X=2129\), exact sieving gives

\[
 \pi(X)=320\equiv5\pmod {15},\qquad
 A(X)=155\equiv1\pmod7,\qquad
 B(X)=163\equiv2\pmod7.                              \tag{2.2}
\]

Thus \(\Phi_6\mid F_X\pmod7\). Its two roots
\(3,5\in\mathbf F_7\) are distinct inverses, so

\[
 \mathcal C(F_{2129})=0\pmod7.                       \tag{2.3}
\]

The endpoints are clean:

\[
 F_{2129}(1)=320\equiv5,\qquad
 F_{2129}(-1)=2-320\equiv4\pmod7.                    \tag{2.4}
\]

For \(q_1\), however,

\[
 h_7=\gcd(q_1,q_1^*)=x^2+4x+1.
\]

The counts of odd primes in the classes \(1,3,5,7\pmod8\), reduced
modulo \(7\), are

\[
 (3,5,5,5).
\]

Substitution into the two \(h_7\)-syndrome equations gives

\[
 (1+3M_1+4M_5,\;6M_1+M_3+M_5+6M_7)=(2,2)\ne(0,0)
 \pmod7.                                             \tag{2.5}
\]

Therefore \(h_7\nmid F_{2129}\pmod7\), and in particular
\(q_1\nmid F_{2129}\). The global charge accepts a collision belonging to
\(\Phi_6\), while the localized \(q_1\) syndrome correctly rejects.

The fixed false control is the immediately preceding prime cutoff
\(X=2113\). There \(A=155\), \(B=162\), and (2.1) is \(1\ne0\) modulo
\((7,\Phi_6)\). This control rejects the corrupted claim that the
\(\Phi_6\) collision had already occurred one prime event earlier.

Both cutoffs are named exact replay targets. No census, frequency estimate,
or statement about later cutoffs is asserted.

## 3. No bounded coefficient-stream automaton

The loss of localization is not merely an implementation inconvenience.

**Theorem 2 (nonregular charge-zero language).** Fix an odd prime
\(\ell\ne3\). There is no finite automaton, with a number of states
independent of degree, which reads the ascending coefficient word of every
monic \(P\in\mathbf F_\ell[x]\) with \(P(0)=1\) and decides whether
\(\mathcal C(P)=0\).

**Proof.** It is enough to intersect the hypothetical regular language
with the regular family of ternomials

\[
 P_{m,n}(x)=1+x^m+x^{m+n},\qquad m,n\ge1,             \tag{3.1}
\]

whose words are \(10^{m-1}10^{n-1}1\). Since \(\ell\ne3\), one has
\(P_{m,n}(1)=3\ne0\). Also
\(P_{m,n}(-1)\in\{3,1,-1\}\), so both endpoints are nonzero.

The reverse polynomial is

\[
 P_{m,n}^*(x)=1+x^n+x^{m+n}.
\]

Suppose first that \(m\ne n\). A common root \(\alpha\) is nonzero, and
subtracting the two equations gives
\(\alpha^m=\alpha^n=:t\). Substitution gives

\[
 \alpha^{m-n}=1,\qquad 1+t+t^2=0.                    \tag{3.2}
\]

Thus \(t\) is a primitive cube root of unity. If \(d=|m-n|\), the image of
the \(m\)-th power map on the cyclic group of \(d\)-th roots of unity
contains an element of order \(3\) exactly when

\[
 3\mid \frac{d}{\gcd(d,m)}.
\]

This remains valid if \(\ell\mid d\): removing the \(\ell\)-power from
\(d\) does not change its \(3\)-adic valuation. By Theorem 1,

\[
 \mathcal C(P_{m,n})=0
 \quad\Longleftrightarrow\quad
 v_3(m-n)>v_3(m),                                    \tag{3.3}
\]

where \(v_3(0)=+\infty\); the same formula includes \(m=n\), when (3.1)
is reciprocal. Equivalently, for \(m\ne n\), \(m,n\) have the same
\(3\)-adic valuation and their first nonzero base-\(3\) digits agree. Mere
equality of the valuations is not enough.

It remains to prove that the block language specified by (3.3) is not
regular. Suppose a deterministic finite automaton recognizes it. Along
the first zero block, its state sequence is eventually periodic: there are
\(N\) and a period \(T\ge1\) such that the states after \(10^r\) and
\(10^{r+T}\) agree for every \(r\ge N\). Write \(T=3^tu\) with
\(3\nmid u\), and choose \(k>t\) large enough that

\[
 m_1=u3^k,\qquad m_2=u3^{k+1}
\]

both satisfy \(m_i-1\ge N\). Since \(m_2-m_1=2u3^k\) is divisible by
\(T\), the automaton is in the same state after the first blocks
\(10^{m_1-1}\) and \(10^{m_2-1}\). Append in both cases the identical
suffix \(10^{m_1-1}1\), i.e. take \(n=m_1\). The first word is accepted
because \(v_3(m_1-m_1)=+\infty\), whereas the second is rejected because

\[
 v_3(m_2-m_1)=k\not>v_3(m_2)=k+1.
\]

Identical states followed by an identical suffix cannot have different
acceptance, a contradiction. \(\square\)

Any bounded-state recurrence computing the full residue
\(\mathcal C(P)\pmod\ell\) would decide its zero fiber, so Theorem 2 rules
that out as well. The theorem says exactly that no universal bounded state
comes from charge algebra alone. It does not rule out:

1. the bounded \(h_\ell\)-remainder automaton attached to one fixed \(q\);
2. an automaton on a bounded-degree class; or
3. a special recurrence for the actual prime-prefix path proved using new
   arithmetic information unavailable for arbitrary coefficient words.

## 4. Rigor boundary and replay

Proved here:

1. the endpoint-clean equivalence between charge zero and an unlocalized
   reciprocal collision;
2. strict weakness of the global charge condition for \(q_1\), witnessed by
   the fixed endpoint-compatible cutoff \(X=2129\); and
3. nonregularity of the unrestricted coefficient-stream charge-zero
   language for odd \(\ell\ne3\).

The exact replay code/exp51_global_charge_no_go.py checks both fixed prime
prefixes, the \(q_1\) syndrome, direct polynomial remainders, planted
accept/reject ternomials, and a canonical digest. The finite checks replay
named consequences of the proofs; they are not a census and do not prove
the nonregularity theorem.

No novelty claim is made. The exterior-power formula and reciprocal gcd
criterion are standard algebra; the result recorded here is their exact
information ordering in the prime-prefix obstruction program.
