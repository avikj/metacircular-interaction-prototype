# Product screw weights versus Goldbach kernels: a classification and no-go theorem

`SCREW.md` §4 asks whether the positive convolution-square measure with
Matsumoto--Suzuki masses

\[
 a(\rho)a(\rho'),\qquad
 a(s)=\frac1{s(1-s)},
\]

can be realized as the two-zero sector of a naturally reweighted Goldbach
sum.  There is an exact obstruction for every homogeneous kernel that depends
only on the Goldbach total.

The obstruction is not specific to zeta zeros.  It is a classification of
when a radial additive kernel can have factorized Mellin coefficients.

---

## 1. The universal coefficient of a sum kernel

Let `k` be a function or distribution on `(0,infinity)` whose Mellin transform

\[
 \widehat k(s)=\int_0^\infty k(r)r^{s-1}\,dr
\]

is holomorphic on a nonempty vertical strip.  Formally, the two-zero sector
of a smoothed Goldbach functional

\[
 \mathcal T_k(X)
 =\iint k\!\left(\frac{u+v}{X}\right)d\Psi_0(u)d\Psi_0(v)
\]

is obtained by inserting the oscillatory monomials
`u^(z-1)du`, `v^(w-1)dv` from the one-body explicit formula.  Its universal
coefficient is

\[
 \begin{aligned}
 I_k(z,w;X)
 &=\int_0^\infty\!\int_0^\infty
 k\!\left(\frac{u+v}{X}\right)u^{z-1}v^{w-1}\,du\,dv\\
 &=X^{z+w}B(z,w)\widehat k(z+w)\\
 &=X^{z+w}
 \frac{\Gamma(z)\Gamma(w)}{\Gamma(z+w)}\widehat k(z+w).
 \end{aligned}
\]

The calculation is the change of variables
`r=u+v`, `t=u/(u+v)`.  The `t` integral is Euler's beta integral and the `r`
integral is Mellin.  Every Cesaro/Languasco--Zaccagnini weight is a special
case.  Different conventions for `dPsi_0` multiply the coefficient by fixed
one-body factors in `z` and `w`; they do not change the classification below.

---

## 2. Classification theorem

### Theorem 2.1 (factorized radial kernels are exactly heat kernels)

Let `U` be a connected open set in `C`, and let `a` be a nonzero meromorphic
function on `U`.  Suppose the Mellin transform of `k` extends meromorphically
to `U+U` and

\[
 \boxed{
 \frac{\Gamma(z)\Gamma(w)}{\Gamma(z+w)}\widehat k(z+w)
 =a(z)a(w)
 }
 \tag{2.1}
\]

for all `(z,w)` in a nonempty open subset of `U x U`.  Then there are
constants `A != 0` and `alpha` such that

\[
 \boxed{a(z)=A e^{\alpha z}\Gamma(z)}
 \tag{2.2}
\]

and

\[
 \boxed{\widehat k(s)=A^2e^{\alpha s}\Gamma(s).}
 \tag{2.3}
\]

If `k` is recovered by ordinary Mellin inversion, this is

\[
 \boxed{k(r)=A^2\exp(-e^{-\alpha}r).}
 \tag{2.4}
\]

Conversely, (2.2)--(2.4) satisfy (2.1).

### Proof

On a simply connected subdomain avoiding zeros and poles, put

\[
 b(z)=\frac{a(z)}{\Gamma(z)},\qquad
 F(s)=\frac{\widehat k(s)}{\Gamma(s)}.
\]

Equation (2.1) becomes

\[
 b(z)b(w)=F(z+w).
 \tag{2.5}
\]

Logarithmically differentiate first in `z` and then read the same equation
with `w` varied:

\[
 \frac{b'(z)}{b(z)}
 =\frac{F'(z+w)}{F(z+w)}
 =\frac{b'(w)}{b(w)}.
\]

Because `z` and `w` vary independently on open sets, `b'/b` is constant.
Hence `b(z)=A exp(alpha z)`, proving (2.2), and (2.5) gives
`F(s)=A^2 exp(alpha s)`, proving (2.3).  Finally

\[
 \int_0^\infty e^{-e^{-\alpha}r}r^{s-1}\,dr
 =e^{\alpha s}\Gamma(s),
\]

which proves (2.4).  Analytic continuation extends the identity across the
removed zeros and poles.  The converse is immediate.  $\square$

### Meaning

The classified kernel is already separable:

\[
 e^{-c(u+v)/X}=e^{-cu/X}e^{-cv/X}.
\]

Therefore every universally factorized radial pair functional is a rank-one
square of a one-body heat transform.  There is no genuinely coupled Goldbach
geometry hiding inside the factorization.

---

## 3. Application to the Matsumoto--Suzuki weight

For

\[
 a(z)=\frac1{z(1-z)},
\]

the required quotient is

\[
 b(z)=\frac1{\Gamma(z)z(1-z)}.
\]

Its logarithmic derivative is

\[
 \frac{b'(z)}{b(z)}
 =-\psi(z)-\frac1z+\frac1{1-z},
\]

which is not constant.  Theorem 2.1 therefore gives:

### Corollary 3.1 (universal Goldbach no-go)

There is no spectrum-independent homogeneous kernel depending only on
`(m+n)/X` whose formal two-zero sector has the factorized
Matsumoto--Suzuki weights

\[
 \frac1{\rho(1-\rho)\rho'(1-\rho')}.
\]

The positive product measure certainly exists: it is the spectral measure of
the square of the one-body screw transform.  On the prime side this is the
square of the corresponding one-body prime formula.  But that construction
is separable by definition; it is no more a Goldbach projection than
`P(t)^2` is a new two-particle interaction.

---

## 4. Scope: what the theorem does not rule out

The classification assumes a transform identity in formal Mellin variables,
which is the normal meaning of identifying an arithmetic kernel before its
spectral expansion is known.  It does **not** rule out choosing a meromorphic
`H(s)` by interpolation only on the discrete set

\[
 s=\rho_i+\rho_j
\]

of actual zeta-zero sums.  If all nontrivial pair sums are distinct, arbitrary
values can in principle be interpolated there.  Such a kernel would depend on
the unknown zeta spectrum itself, would have no universal prime-side
definition, and would generally be highly nonlocal.  The theorem excludes the
canonical functorial construction, not pathological spectral engineering.

It also does not exclude an `L^2` relation between the positive product
weights and the Beta-coupled Goldbach weights.  That is the honest surviving
route from `SCREW.md`:

\[
 C(\rho,\rho')
 =\rho(1-\rho)\rho'(1-\rho')
  \frac{\Gamma(\rho)\Gamma(\rho')}
       {\Gamma(\rho+\rho'+2)}.
\]

Pointwise positivity is destroyed by this multiplier, as `exp12_screw.py`
already measures.  A useful join would have to be a quadratic-form or Schur
multiplier bound, where phases may cancel, not a positive measure on each
pair-sum line.

---

## 5. Consequence for the research program

The product-weighted target splits cleanly:

1. **Positive and immediate:** square the Matsumoto--Suzuki one-body screw
   transform.  This gives the desired positive convolution measure but only
   a rank-one separable arithmetic square.
2. **Goldbach-coupled and nontrivial:** keep a kernel of `m+n`.  Then the beta
   coupling is forced, product weights are impossible in a universal
   transform identity, and positivity must be sought after integration in an
   `L^2` cone.

This is the same triviality boundary as Proposition 1.1 of `REPORT.md`, now
expressed as a classification theorem rather than a warning: factorized
spectral weights and genuine total-coordinate coupling cannot both be had,
except for the exponential heat kernel where the total-coordinate kernel
factorizes already.
