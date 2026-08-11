# Rational phases on the genuine pair channels

## Exact algebra

Let $(u_n)_{n\geq1}$ be any sequence for which the following series converge,
and for $(a,q)=1$ put

\[
A_{a/q}(z)=\sum_{n\geq1}u_n e_q(an)z^n.
\]

The same one-body series produces the constrained sum and constrained
difference channels, but the rational phase itself factors completely through
the constrained coordinate.

**Proposition (pair-phase factorization).**

\[
\boxed{
[z^N]A_{a/q}(z)^2
=e_q(aN)\sum_{m+n=N}u_mu_n.}
\tag{1}
\]

For $0<r<1$ and $h\geq0$,

\[
\boxed{
[e^{ih\theta}]\,|A_{a/q}(re^{i\theta})|^2
=e_q(ah)\sum_{n\geq1}u_{n+h}\overline{u_n},r^{2n+h}.}
\tag{2}
\]

Both identities are immediate: in (1), $m+n=N$ makes
$e_q(am)e_q(an)=e_q(aN)$; in (2), the $h$th angular Fourier coefficient has
$m-n=h$ and therefore phase $e_q(ah)$.

For $u_n=\Lambda(n)$, (1) is the holomorphic Goldbach channel and (2) is a
radially smoothed Hermitian gap channel.  No RH, circle-method estimate, or
probabilistic heuristic is involved.

## What this corrects

Squaring a compensated scalar such as $\Phi(X)$ creates an all-pairs rank-one
carrier.  It does not impose $m+n=N$.  Equations (1)--(2) show the correct
constraint mechanisms:

- coefficient extraction in one complex variable imposes a sum;
- angular Fourier extraction of a Hermitian square imposes a difference.

They also prevent another overinterpretation.  At a single additive rational
mode, the pair twist carries only $N\bmod q$ or $h\bmod q$; it does not by
itself reveal how the two summands occupy residue classes.  The richer
Dirichlet-$L$ cross-spectrum appears after expanding each one-body
$A_{a/q}$ into characters:

\[
A_{a/q}=\frac1{\varphi(q)}
\sum_{\chi\bmod q}\tau(\bar\chi)\chi(a)A_\chi
+\text{the explicit }p\mid q\text{ correction}.
\]

The Goldbach square then contains all ordered pairs $(\chi,\psi)$; the gap
channel contains $(\chi,\bar\psi)$ with the Hermitian orientation.  Thus the
sum/difference zero spectra in `RATIONAL_FIBER_SPECTRUM.md` are real, but they
are cross-character expansions of one exact constrained generating function,
not an additional pair observable supplied by the rational phase.

## Computational consequence

For a fixed modulus, compute the one-body character signals once.  Goldbach
and gaps are two coefficient-extraction operators on their quadratic products.
This yields a natural CPU shard indexed by

\[
(q,a,\chi,\psi,\text{zero block},\text{coefficient range}),
\]

while keeping the final inverse character/Fourier projection exact.  The
hard analytic obligation remains a uniform bound on the tails and minor-arc
remainder.  The algebra does not solve it.

`code/exp43_rational_pair_channel.py` checks (1)--(2) over integer group rings
for many moduli and arbitrary signed sequences, so no floating root of unity
or prime heuristic is load-bearing.

## Prior-art boundary

These are elementary generating-function/Fourier identities and are not
novel.  Their value is corrective and architectural: they locate exactly
where the true pair constraint enters the rational-fiber program and prevent
an unconstrained square from being marketed as Goldbach information.

