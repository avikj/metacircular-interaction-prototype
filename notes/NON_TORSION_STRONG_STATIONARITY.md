# NON-TORSION STRONG STATIONARITY: an internal van der Corput proof

**Status: frozen for hostile audit.**  This note reconstructs only the
non-root-of-unity half of Frantzikinakis's Proposition 3.7.  It is enough for
the trivial-rational-spectrum logarithmic corollary in
`TWISTED_EIGENMEASURE_CLOSURE.md`.  It does **not** reconstruct Jenvey's
separate root-of-unity argument and therefore does not internally certify the
stronger unconditional Candidate T in that note.

The proof is abstract, but the intended model is

\[
 \Omega=\{-1,+1\}^{\mathbb Z},\qquad
 (S\omega)(h)=\omega(h+1),\qquad
 (D_n\omega)(h)=\omega(nh).
\]

Strong stationarity says that every \(D_n\) preserves the measure.  The
coordinate-zero algebra is fixed pointwise by every \(D_n\), and its shifts
generate the cylinder algebra.  Those are exactly the properties used below.

## 1. Operator conventions and statement

Let \((X,\mathcal B,\mu,S)\) be an invertible probability-preserving system.
Write

\[
 Uf=f\circ S.
\]

Suppose that \(\mathcal F\subset L^\infty(\mu)\) is a unital self-adjoint
function algebra whose \(U\)-translates generate \(\mathcal B\), and that for
every \(n\geq1\) there is a measure-preserving map \(D_n:X\to X\).  Write

\[
 V_nf=f\circ D_n.
\]

Assume

\[
 V_nU=U^nV_n,
 \qquad V_nf=f\quad(f\in\mathcal F). \tag{1.1}
\]

For sequence space, (1.1) follows from
\(S\circ D_n=D_n\circ S^n\), and the second identity follows because dilation
does not move coordinate zero.

> **Theorem 1.1 (non-torsion spectral exclusion).**  Under (1.1), the shift
> Koopman operator \(U\) has no eigenvalue of infinite order in
> \(\mathbb T\).  Equivalently, every shift eigenvalue is a root of unity.

No ergodicity or finite-ergodic-component hypothesis is used in this theorem.
The proof is a finite van der Corput induction whose terminal orthogonality is
made exact by quotienting eigenvalues by roots of unity.

If an initial eigenfunction \(\chi\in L^2(\mu)\) is not bounded, boundedness
costs nothing.  Since \(|\chi|\) is \(S\)-invariant, some invariant band
\(E=\{a\leq |\chi|\leq b\}\), with \(0<a<b<\infty\), has positive measure.
Then

\[
 \chi_0={\bf1}_E\frac{\chi}{|\chi|}
\]

is a nonzero bounded eigenfunction with the same eigenvalue.  We therefore
take all eigenfunctions below to be bounded.

## 2. Spectral classes modulo torsion

Let

\[
 \mathbb T_{\rm tor}=\{z\in\mathbb T:z^m=1\text{ for some }m\geq1\},
 \qquad Q=\mathbb T/\mathbb T_{\rm tor}.
\]

We use additive notation in \(Q\), writing \([z]\) for the class of
\(z\in\mathbb T\).  The group \(Q\) is divisible because \(\mathbb T\) is
divisible, and it is torsion-free: if \(m[z]=0\), then \(z^m\) is a root of
unity, hence so is \(z\).  Thus \(Q\) is a \(\mathbb Q\)-vector space.  In
particular, \(q/n\) is defined uniquely for \(q\in Q\).

For \(\alpha\in Q\), let

\[
 \mathcal H_\alpha=
 \overline{\operatorname{span}}\{f\in L^2(\mu):
                 Uf=zf\text{ for some }[z]=\alpha\}. \tag{2.1}
\]

Distinct \(\mathcal H_\alpha\)'s are orthogonal, since eigenspaces of a
unitary operator belonging to distinct eigenvalues are orthogonal and the
torsion cosets in (2.1) are disjoint.

We need product closure only for **bounded finite spectral sums**.  If \(f\)
is a bounded finite sum of eigenfunctions with eigenvalues in class
\(\alpha\), and \(g\) is such a sum in class \(\beta\), then

\[
 fg\in\mathcal H_{\alpha+\beta},
 \qquad \overline f\in\mathcal H_{-\alpha}. \tag{2.2}
\]

Indeed, the product of a \(z\)-eigenfunction and a \(w\)-eigenfunction is a
\(zw\)-eigenfunction.  We do not assert an unrestricted multiplication rule
for arbitrary \(L^2\)-limits in (2.1); every carrier used below is a bounded
finite spectral sum, so (2.2) is the exact closure statement required.

Suppose now that

\[
 U\chi=\lambda\chi,
 \qquad q=[\lambda]\neq0\text{ in }Q. \tag{2.3}
\]

The intertwining relation gives

\[
 U^n(V_n\chi)=V_n(U\chi)=\lambda V_n\chi. \tag{2.4}
\]

The spectral measure of \(V_n\chi\) is therefore supported on the finite set
\(\{z:z^n=\lambda\}\).  More explicitly, for each root \(\rho^n=\lambda\),

\[
 P_{n,\rho}(V_n\chi)
   =\frac1n\sum_{j=0}^{n-1}\rho^{-j}U^j(V_n\chi) \tag{2.5}
\]

is the \(\rho\)-eigencomponent, and the sum of (2.5) over the \(n\) roots is
\(V_n\chi\).  Formula (2.5) also shows that these components are bounded.
Any two \(n\)-th roots of \(\lambda\) differ by an \(n\)-th root of unity,
so all components have the same class in \(Q\).  From \(n[\rho]=q\) and
torsion-freeness,

\[
 V_n\chi\in\mathcal H_{q/n}. \tag{2.6}
\]

This is the content of the informal phrase “\(\lambda^{1/n}\)-eigenfunctions,”
but (2.5)--(2.6) avoid choosing a distinguished complex root.

## 3. Finite differences of the spectral charge

For \(h\geq1\), define

\[
 (\Delta_h r)(n)=r(n+h)-r(n).
\]

Starting from \(r_0(n)=1/n\), every iterated positive finite difference is
nonzero and injective on \(\mathbb N\).

> **Lemma 3.1 (no repeated finite-difference charge).**  For positive
> integers \(h_1,\ldots,h_s\), set
> \(r_s=\Delta_{h_s}\cdots\Delta_{h_1}r_0\).  Then
> \[
>  r_s(n)=\int_0^1 x^{n-1}\prod_{i=1}^s(x^{h_i}-1)\,dx, \tag{3.1}
> \]
> and
> \[
>  (-1)^s r_s(n)
>   =\int_0^1x^{n-1}\prod_{i=1}^s(1-x^{h_i})\,dx>0. \tag{3.2}
> \]
> The positive quantity in (3.2) is strictly decreasing in \(n\).
> Consequently \(r_s(n)\neq r_s(m)\) whenever \(n\neq m\).

**Proof.**  The identity \(1/n=\int_0^1x^{n-1}\,dx\) gives (3.1), because
applying \(\Delta_h\) multiplies the integrand by \(x^h-1\).  Equation
(3.2) follows by extracting the signs.  Its integrand is positive on
\((0,1)\); replacing \(n\) by \(n+1\) multiplies it by \(x<1\), so the
integral strictly decreases. \(\square\)

Because \(Q\) is a \(\mathbb Q\)-vector space and \(q\neq0\), Lemma 3.1 also
gives

\[
 r_s(n)q\neq r_s(m)q\qquad(n\neq m). \tag{3.3}
\]

Thus bounded finite spectral vectors in the respective classes
\(\mathcal H_{r_s(n)q}\) are pairwise orthogonal as \(n\) varies.

For example, the first difference applied to (2.6) is the spectral-flight
calculation from Frantzikinakis's proof sketch.  If

\[
 u_{n,h}=U^{-n}\big(V_{n+h}\chi\,\overline{V_n\chi}\big),
\]

then shifts do not change eigenvalues and (2.2) gives

\[
 u_{n,h}\in
 \mathcal H_{(1/(n+h)-1/n)q}.
\]

These classes are pairwise distinct by Lemma 3.1, so \((u_{n,h})_n\) is an
orthogonal bounded sequence and converges weakly to zero.  The next section
supplies the full higher-order induction rather than stopping at this
terminal observation.

## 4. The complete van der Corput induction

Call a sequence \((a_n)\) an \(r_s,q\)-**carrier** if it is uniformly bounded
in \(L^\infty\), every \(a_n\) is a bounded finite spectral sum, and

\[
 a_n\in\mathcal H_{r_s(n)q}. \tag{4.1}
\]

> **Lemma 4.1 (moving-factor annihilation).**  Let \((a_n)\) be an
> \(r_s,q\)-carrier with \(q\neq0\).  Let \(p_1,\ldots,p_k\) be distinct
> integers and let \(f_1,\ldots,f_k\in L^\infty(\mu)\).  Then
> \[
>  \frac1N\sum_{n=1}^N
>    a_n\prod_{j=1}^k U^{p_jn}f_j
>       \longrightarrow0\quad\text{in }L^2(\mu). \tag{4.2}
> \]

**Proof.**  We induct on the number \(k\) of moving factors, simultaneously
for every finite-difference depth \(s\), every nonzero \(q\), and every
\(r_s,q\)-carrier.

For \(k=0\), (3.3) and (4.1) make the vectors \(a_n\) pairwise orthogonal.
If \(\|a_n\|_2\leq C\), then

\[
 \left\|\frac1N\sum_{n=1}^Na_n\right\|_2^2
   =\frac1{N^2}\sum_{n=1}^N\|a_n\|_2^2
   \leq\frac{C^2}{N}. \tag{4.3}
\]

Assume the result for \(k-1\).  Put

\[
 x_n=a_n\prod_{j=1}^kU^{p_jn}f_j.
\]

Fix \(h\geq1\), and abbreviate

\[
 g_{j,h}=U^{p_jh}f_j\,\overline{f_j}.
\]

Using \(S\)-invariance of \(\mu\), the correlation is

\[
 \begin{aligned}
 \langle x_{n+h},x_n\rangle
 &=\int a_{n+h}\overline{a_n}
       \prod_{j=1}^kU^{p_jn}g_{j,h}\,d\mu\\
 &=\int b_{n,h}\,g_{1,h}
       \prod_{j=2}^kU^{(p_j-p_1)n}g_{j,h}\,d\mu, \tag{4.4}
 \end{aligned}
\]

where

\[
 b_{n,h}=U^{-p_1n}\big(a_{n+h}\overline{a_n}\big). \tag{4.5}
\]

Translation by \(U^{-p_1n}\) does not change an eigenvalue.  Product closure
(2.2) and (4.1) therefore show that \((b_{n,h})_n\) is an
\(\Delta_h r_s,q\)-carrier:

\[
 b_{n,h}\in
 \mathcal H_{(r_s(n+h)-r_s(n))q}. \tag{4.6}
\]

The slopes \(p_j-p_1\), \(2\leq j\leq k\), are distinct and nonzero.  By the
induction hypothesis, the vector Cesaro mean of

\[
 b_{n,h}\prod_{j=2}^kU^{(p_j-p_1)n}g_{j,h}
\]

converges to zero in \(L^2\).  Pairing with the fixed bounded function
\(g_{1,h}\) in (4.4) gives

\[
 \lim_{N\to\infty}\frac1N\sum_{n=1}^N
       \langle x_{n+h},x_n\rangle=0 \qquad(h\geq1). \tag{4.7}
\]

The Hilbert-space van der Corput inequality gives, for every \(H\geq1\),
an upper bound for
\(\limsup_N\|N^{-1}\sum_{n\leq N}x_n\|_2^2\) by a constant multiple of

\[
 \frac1H+\frac1H\sum_{h=1}^H
 \limsup_{N\to\infty}\left|\frac1N\sum_{n=1}^N
          \langle x_{n+h},x_n\rangle\right|. \tag{4.8}
\]

Equation (4.7) makes the sum in (4.8) zero.  Letting \(H\to\infty\) proves
(4.2). \(\square\)

The induction is finite: each van der Corput step removes one distinct
linear slope and replaces \(r_s\) by one further positive finite difference.
Lemma 3.1 is exactly what prevents the terminal spectral charge from
colliding with itself.

## 5. Orthogonality to the generating cylinder algebra

We now prove Theorem 1.1.  Suppose for contradiction that (2.3) holds.  By
(2.5)--(2.6),

\[
 a_n=V_n\chi
\]

is an \(r_0,q\)-carrier.  Consider a monomial in translates of the generating
algebra,

\[
 g=\prod_{j=1}^kU^{p_j}f_j,
 \qquad f_j\in\mathcal F,
\]

after combining repeated slopes.  Since \(V_n\) is an isometry, (1.1) gives

\[
 \begin{aligned}
 \langle\chi,g\rangle
 &=\langle V_n\chi,V_ng\rangle\\
 &=\left\langle V_n\chi,
       \prod_{j=1}^kU^{p_jn}f_j\right\rangle. \tag{5.1}
 \end{aligned}
\]

The right side of (5.1) has the same value for every \(n\).  Its Cesaro mean
is zero by Lemma 4.1 (use \(a_n=V_n\chi\), conjugating the bounded
\(f_j\)'s according to the inner-product convention).  Hence
\(\langle\chi,g\rangle=0\).

Finite linear combinations of these monomials are dense in \(L^2(\mu)\),
because the translates of \(\mathcal F\) generate \(\mathcal B\).  Thus
\(\chi\) is orthogonal to all of \(L^2(\mu)\), contradicting
\(\chi\neq0\).  This proves Theorem 1.1. \(\square\)

For the binary sequence model, the dense monomials can be taken to be the
Walsh cylinders

\[
 X_A=\prod_{a\in A}X_a
\]

over finite \(A\subset\mathbb Z\).  Thus no approximation beyond the usual
finite-cylinder density is hidden in the last step.

## 6. Exact implication for the twisted logarithmic application

Let \(\nu\) be the ergodic law in the logarithmic corollary of
`TWISTED_EIGENMEASURE_CLOSURE.md`.  At that point in the argument, before
deconditioning, \(\nu\) is assumed to have trivial rational spectrum.  After
deconditioning it satisfies the unconditional twisted dilation identities,
and

\[
 \bar\nu=\tfrac12(\nu+J_*\nu)
\]

is strongly stationary.

Every eigenvalue of \((\Omega,\nu,S)\) patches to an eigenvalue of
\((\Omega,\bar\nu,S)\): this is tautological if \(J_*\nu=\nu\), and follows
from the explicit two-component patch in that note otherwise.  Let \(\lambda\)
be a component eigenvalue.

- If \(\lambda\) is a root of unity, trivial rational spectrum of \(\nu\)
  forces \(\lambda=1\).
- If \(\lambda\) is not a root of unity, Theorem 1.1 applied to \(\bar\nu\)
  rules it out.

Hence \(1\) is the only eigenvalue of the ergodic component \(\nu\), and its
\(1\)-eigenspace consists only of constants.  Therefore \(\nu\) is weakly
mixing.  `EIGENMEASURE.md` Theorem 3.3 then gives the literal coordinate law

\[
 \nu=\operatorname{Bernoulli}(1/2).
\]

This internally closes the Proposition 3.7 dependency for that
**trivial-rational logarithmic corollary only**, modulo the already disclosed
multiple-weak-mixing input in `EIGENMEASURE.md` Theorem 3.3.

It does not prove the root-of-unity branch of Proposition 3.7.  In
particular, the unconditional Candidate T in
`TWISTED_EIGENMEASURE_CLOSURE.md`, which does not assume trivial rational
spectrum, remains conditional on the full Frantzikinakis--Jenvey theorem.
The fact that \(\bar\nu\) has only one or two flip-conjugate ergodic
components does not remove this torsion issue: it bounds global eigenspace
multiplicity, but a finite cyclic factor could still lie inside either
ergodic component.

## 7. Provenance and audit boundary

Frantzikinakis, *The structure of strongly stationary systems*,
J. Analyse Math. 93 (2004), Proposition 3.7, states the stronger theorem that
**all** eigenvalues of a strongly stationary system equal \(1\).  Its proof
sketch identifies the same dilation-difference carrier and says that repeated
van der Corput reduces the non-torsion case to its spectral flight.  The
argument above independently supplies that full finite induction using the
torsion quotient and the integral identity (3.1).

The following remain outside this internal certificate:

1. Jenvey's p-order/IP-ring treatment of a nontrivial root of unity;
2. any removal of trivial rational spectrum from the logarithmic corollary;
3. any Cesaro conclusion, where the required single-law dilation invariance
   is absent in general;
4. novelty.  This is an internal proof reconstruction of a known theorem
   branch, not a novelty claim.
