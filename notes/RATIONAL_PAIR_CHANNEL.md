# Rational phases on the genuine pair channels

## 1. The exact graded theorem

Write \(e_q(x)=\exp(2\pi i x/q)\). Let \(R\) be a commutative
\(\mathbb C\)-algebra with an involution, let \(u_n\in R\), and put

\[
 A_{a/q}(z)=\sum_{n\geq1}u_ne_q(an)z^n.
\]

The first identity below is an identity in \(R[[z]]\), so it requires no
analytic convergence. The second is either a finite Laurent-polynomial
identity, or, when \(R\) is normed, an absolutely and locally uniformly
convergent identity if \(0<r<1\) and
\(\sum_n\lVert u_n\rVert r^n<\infty\).

**Theorem 1 (pair-phase factorization).** For every \(N\geq2\),

\[
 \boxed{
 [z^N]A_{a/q}(z)^2
 =e_q(aN)\sum_{m+n=N}u_mu_n.}
 \tag{1.1}
\]

For every \(h\geq0\),

\[
 \boxed{
 [e^{ih\theta}]\,|A_{a/q}(re^{i\theta})|^2
 =e_q(ah)\sum_{n\geq1}u_{n+h}\overline{u_n}\,r^{2n+h}.}
 \tag{1.2}
\]

Here \([e^{ih\theta}]\) means the coefficient multiplying
\(e^{ih\theta}\). Thus the orientation in (1.2) is \(m-n=h\), not
\(n-m=h\). Both formulas follow by multiplying the series: on the indicated
grade the phase is respectively \(e_q(a(m+n))=e_q(aN)\) and
\(e_q(a(m-n))=e_q(ah)\).

For \(u_n=\Lambda(n)\), (1.1) is the exact holomorphic Goldbach channel. A
sharp finite gap identity and its Abel-smoothed version are

\[
 \begin{aligned}
 D_h(X)&=\sum_{n\leq X-h}\Lambda(n+h)\Lambda(n)\\
 &=e_q(-ah)[e^{ih\theta}]
 \left|\sum_{n\leq X}\Lambda(n)e_q(an)e^{in\theta}\right|^2,       \tag{1.3}\\
 D_h(r)&=\sum_{n\geq1}\Lambda(n+h)\Lambda(n)r^{2n+h}\\
 &=e_q(-ah)[e^{ih\theta}]|A_{a/q}(re^{i\theta})|^2,\qquad 0<r<1.  \tag{1.4}
 \end{aligned}
\]

No limit \(r\uparrow1\) is asserted. A scalar square formed after discarding
the \(z\)- or angular grade is an all-pairs rank-one carrier; it does not
select a Goldbach sum or a fixed gap.

## 2. Exact character and local-prime block

The character expansion has a small but essential imprimitive correction.
Assume \((a,q)=1\), and define

\[
 A_{a,q}(z)=\sum_{n\geq1}\Lambda(n)e_q(an)z^n,\qquad
 A_\chi(z)=\sum_{n\geq1}\Lambda(n)\chi(n)z^n.
\]

If \(\chi\pmod q\) is induced by the primitive character \(\chi^*\) of
conductor \(f\mid q\), put

\[
 \begin{aligned}
 E_{\chi;q}(z)
  &=\sum_{\substack{p\mid q\\p\nmid f}}(\log p)
    \sum_{k\geq1}\chi^*(p)^kz^{p^k},\\
 B_{\chi;q}(z)&=A_{\chi^*}(z)-E_{\chi;q}(z)=A_\chi(z),\\
 P_{a,q}(z)&=\sum_{p\mid q}(\log p)
    \sum_{k\geq1}e_q(ap^k)z^{p^k},\\
\alpha_\chi(a)&=\frac{\tau_q(\overline\chi)\chi(a)}{\varphi(q)},\qquad
\tau_q(\overline\chi)=\sum_{x\bmod q}\overline{\chi(x)}e_q(x).
 \end{aligned}                                                    \tag{2.1}
\]

Character orthogonality on the units, followed by restoring the prime powers
supported on \(p\mid q\), gives the coefficientwise identity

\[
 \boxed{
 C_{a,q}(z):=\sum_{\chi\bmod q}\alpha_\chi(a)B_{\chi;q}(z)
              +P_{a,q}(z)=A_{a,q}(z).}                            \tag{2.2}
\]

It holds in \(\mathbb C[[z]]\), and absolutely for \(|z|<1\). Consequently

\[
 \sum_{m+n=N}\Lambda(m)\Lambda(n)
 =e_q(-aN)[z^N]C_{a,q}(z)^2,                                     \tag{2.3}
\]

where the complete holomorphic character block is

\[
 \boxed{
 C_{a,q}^2=
 \sum_{\chi,\psi\bmod q}\alpha_\chi(a)\alpha_\psi(a)
 B_{\chi;q}B_{\psi;q}
 +2P_{a,q}\sum_{\chi\bmod q}\alpha_\chi(a)B_{\chi;q}
 +P_{a,q}^2.}                                                     \tag{2.4}
\]

All ordered cross-character pairs occur.  The corresponding Hermitian block
at \(z=re^{i\theta}\) is

\[
 \boxed{
 \begin{aligned}
 |C_{a,q}|^2={}&
 \sum_{\chi,\psi\bmod q}
 \alpha_\chi(a)\overline{\alpha_\psi(a)}
 B_{\chi;q}\overline{B_{\psi;q}}\\
 &+\left(\sum_\chi\alpha_\chi(a)B_{\chi;q}\right)\overline{P_{a,q}}
 +P_{a,q}\overline{\left(\sum_\psi\alpha_\psi(a)B_{\psi;q}\right)}
 +|P_{a,q}|^2.
 \end{aligned}}                                                  \tag{2.5}
\]

The conjugate coefficient must not be silently dropped.  If the second
character is relabeled by \(\overline\psi\), then

\[
 \overline{\alpha_\psi(a)}
 =\psi(-1)\alpha_{\overline\psi}(a),                              \tag{2.6}
\]

because
\(\overline{\tau_q(\overline\psi)}=\psi(-1)\tau_q(\psi)\). Thus the phrase
“\((\chi,\overline\psi)\) block” carries a parity factor unless (2.5) is
kept in its unrelabelled form.

The ungraded scalar \(C_{a,q}(r)^2\) is not itself a Goldbach number, but it
is not meaningless: the retained radial variable makes it the aggregate
generating function

\[
 C_{a,q}(r)^2=\sum_{N\geq2}e_q(aN)
 \left(\sum_{m+n=N}\Lambda(m)\Lambda(n)\right)r^N.                \tag{2.7}
\]

By contrast, a compensated scalar such as \(\Phi_{a,q}(X)^2\) has already
discarded this grade and needs an independent projector before it can encode
a fixed \(N\).

## 3. Finite projectors, reduction, and the no-wrap boundary

For finitely supported sequences \(x_n,y_n\), set
\(F_b=\sum_nx_ne_q(bn)\) and \(G_b=\sum_ny_ne_q(bn)\). Exact finite Fourier
inversion gives

\[
 \begin{aligned}
 \sum_{m+n\equiv N\;(q)}x_my_n
  &=\frac1q\sum_{b\bmod q}e_q(-bN)F_bG_b,                         \tag{3.1}\\
 \sum_{m-n\equiv h\;(q)}x_m\overline{y_n}
  &=\frac1q\sum_{b\bmod q}e_q(-bh)F_b\overline{G_b}.             \tag{3.2}
 \end{aligned}
\]

These project a congruence class, not an integer equality.  They become an
equality projector only under an explicit no-wrap hypothesis—for example,
when the possible values of \(m+n\) lie in an interval of length \(<q\) that
contains only \(N\) in its residue class. Without no-wrap, use the formal
coefficient in (1.1) or the continuous angular coefficient in (1.2).

A mode \(b/q\) with \(d=(b,q)>1\) must first be reduced to
\(a/r=(b/d)/(q/d)\). Its character expansion and its local correction use
the true denominator \(r\), not all primes dividing the unreduced \(q\).

## 4. Spectral reading and analytic boundary

For a primitive \(\chi^*\), the exponentially smoothed character signal has,
on \(\Re w>0\), the standard schematic explicit formula

\[
 A_{\chi^*}(e^{-w})=
 \frac{\mathbf1_{\chi^*=1}}w
 -\sum_{\rho_{\chi^*}}\Gamma(\rho_{\chi^*})w^{-\rho_{\chi^*}}
 +\text{explicit conductor/gamma/trivial-zero terms}.             \tag{4.1}
\]

On closed subsectors of the right half-plane its zero sum is absolutely and
locally uniformly convergent, by the exponential decay of
\(\Gamma(\sigma+it)\)
and the standard zero count.  Substitution into (2.4) produces sums
\(\gamma_\chi+\gamma_\psi\); substitution into (2.5) produces differences
\(\gamma_\chi-\gamma_\psi\). These are spectral expansions of the two exact
graded channels.  They do not eliminate coefficient extraction, angular
extraction, or the minor-arc remainder.

Only the principal character contributes a pole.  Its reduced-mode
coefficient is \(\mu(q)/\varphi(q)\), while \(E_{\chi;q}\) and \(P_{a,q}\)
are pole-free.  Hence the pole--pole major-arc layer has coefficient
\(\mu(q)^2/\varphi(q)^2\); summing reduced additive modes supplies the
Ramanujan factor \(c_q(N)\) in the sum channel or \(c_q(h)\) in the difference
channel.  This is the classical Hardy--Littlewood layer.  Summing the full
exact identities over modes would merely duplicate the same arithmetic
coefficient; the singular series appears only after retaining the pole
major-arc layer and controlling what remains.

## 5. Computational falsifiers

`code/exp43_rational_pair_channel.py` verifies (1.1)--(1.2) in integer group
rings for many moduli and arbitrary signed real sequences.  It deliberately
remains a historical test of the basic phase identities.

`code/exp44_rational_pair_characters.py` is the stronger exact test.  In the
cyclotomic Gaussian ring \(\mathbb Q(i,\zeta_6)\), it checks the primitive and
imprimitive character decomposition modulo \(6\), both deleted-Euler and
local-prime blocks, the full holomorphic and Hermitian pair orientations, and
the two finite residue projectors.  Complex weights make the wrong
conjugation orientation detectably false.

## 6. Prior-art boundary

The graded identities and character orthogonality above are elementary and
are not novelty claims.  Hardy--Littlewood's circle method is the classical
source of the rational-mode/pole decomposition.  Helfgott's
[*Major arcs for Goldbach's problem*](https://arxiv.org/abs/1305.2897)
develops the relevant Dirichlet-character explicit formulas with uniform
major-arc control.  Bhowmik--Halupczok--Matsumoto--Suzuki
([arXiv:1704.06103](https://arxiv.org/abs/1704.06103)) relate averaged
Goldbach representations in progressions directly to Dirichlet \(L\)-zeros.
The difference channel is the classical Wiener--Khintchine identity;
Gadiyar--Padma
([DOI 10.1016/S0378-4371(99)00171-5](https://doi.org/10.1016/S0378-4371(99)00171-5))
already apply Ramanujan--Fourier/Wiener language to prime pairs.  The useful
contribution here is therefore architectural and corrective: it states the
projector, conjugation, local-factor, and convergence boundaries needed to
connect these classical layers without turning an unconstrained square into
a Goldbach theorem.
