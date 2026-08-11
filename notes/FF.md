# The function-field pair field: exact shell theorem and the infinity-place boundary

This note gives the honest function-field calibration of the prime-pair
formalism.  The basic zeta function of \(\mathbf F_q[T]\) is genus zero and
has no numerator zeros.  That kills the one-body zero block, but it does
**not** kill pair fluctuations.  Those fluctuations live in the nontrivial
additive Fourier modes of a degree shell.  Sawin--Shusterman control one of
these pair channels by geometry on auxiliary, growing-dimensional objects;
their theorem is not a formal consequence of the Riemann hypothesis for the
base affine line.

Throughout, \(q\) is a prime power,

\[
  V_n=\{a\in\mathbf F_q[T]:\deg a<n\},\qquad |V_n|=q^n,
\]

and \(\Lambda\) is the polynomial von Mangoldt function, extended from monic
polynomials to all nonzero polynomials by invariance under multiplication by
a unit.  Thus \(\Lambda(cP^r)=\deg P\) for \(c\in\mathbf F_q^\times\) and
monic irreducible \(P\), and it is zero otherwise.  Put

\[
  a_n(x)=\Lambda(T^n+x),\qquad x\in V_n.
\]

This is a von-Mangoldt-weighted theorem.  It counts prime powers as well as
primes; the prime-count version is stated separately below.

## 1. Exact shell pair theorem

Define the equal-shell sum and difference marginals

\[
 R_n(s)=\sum_{x\in V_n}a_n(x)a_n(s-x),\qquad
 C_n(h)=\sum_{x\in V_n}a_n(x)a_n(x+h).
\]

For an additive character \(\chi\in\widehat V_n\), use the unnormalized
Fourier transform

\[
 \widehat a_n(\chi)=\sum_{x\in V_n}a_n(x)\overline{\chi(x)}.
\]

### Theorem 1 (genus-zero shell pair theorem)

For every prime power \(q\) and every \(n\ge1\):

1. **Exact one-body mass**
   \[
     \sum_{x\in V_n}a_n(x)=q^n.
   \]

2. **Holomorphic/Hermitian pair spectra**
   \[
     \widehat R_n(\chi)=\widehat a_n(\chi)^2,
     \qquad
     \widehat C_n(\chi)=|\widehat a_n(\chi)|^2.
   \]

3. **Exact common mean and exact common fluctuation energy**
   \[
     \frac1{q^n}\sum_{s\in V_n}R_n(s)
     =\frac1{q^n}\sum_{h\in V_n}C_n(h)=q^n,
   \]
   and
   \[
   \boxed{
     \sum_s|R_n(s)-q^n|^2
     =\sum_h|C_n(h)-q^n|^2
     =q^{-n}\sum_{\chi\ne1}|\widehat a_n(\chi)|^4.}
   \]

4. **The pair fluctuation is nonzero although the base zeta has no zeros.**
   If \(\pi_q(d)\) is the number of monic irreducibles of degree \(d\), then
   \[
     C_n(0)=\sum_{d\mid n}d^2\pi_q(d),
   \]
   hence
   \[
     \Delta_n:=C_n(0)-q^n
       =\sum_{d\mid n}d(d-1)\pi_q(d)>0\qquad(n\ge2).
   \]
   Quantitatively,
   \[
   \boxed{
     \sum_h|C_n(h)-q^n|^2
     =\sum_s|R_n(s)-q^n|^2
     \ge \frac{q^n}{q^n-1}\,\Delta_n^2.}
   \]

#### Proof

The affine-line zeta identity is

\[
 Z_{\mathbf F_q[T]}(u)
 =\sum_{f\,\operatorname{monic}}u^{\deg f}
 =\frac1{1-qu}.
\]

Taking its logarithmic derivative gives

\[
 \sum_{f\,\operatorname{monic}}\Lambda(f)u^{\deg f}
 =\frac{qu}{1-qu}=\sum_{n\ge1}q^n u^n,
\]

which proves (1).  Part (2) is the convolution theorem.  For the correlation,
write \(y=x+h\); then

\[
 \sum_h C_n(h)\overline{\chi(h)}
 =\left(\sum_xa_n(x)\chi(x)\right)
  \left(\sum_ya_n(y)\overline{\chi(y)}\right)
 =|\widehat a_n(\chi)|^2,
\]

because \(a_n\) is real.  The trivial Fourier coefficient is \(q^n\), so
Fourier inversion gives the common mean.  Parseval then gives the common
fourth-moment formula in (3).

A monic degree-\(n\) prime power is uniquely \(P^{n/d}\), where \(P\) is a
monic irreducible of degree \(d\mid n\).  This proves the formula for
\(C_n(0)\).  The familiar identity

\[
 q^n=\sum_{d\mid n}d\pi_q(d)
\]

then gives the formula for \(\Delta_n\); it is positive for \(n\ge2\) because
there exist degree-\(n\) irreducibles.  Finally, Parseval applied to \(a_n\)
gives

\[
 \sum_{\chi\ne1}|\widehat a_n(\chi)|^2
 =q^n\bigl(C_n(0)-q^n\bigr)=q^n\Delta_n.
\]

Cauchy--Schwarz over the \(q^n-1\) nontrivial characters, followed by the
fourth-moment identity in (3), gives

\[
 q^{-n}\sum_{\chi\ne1}|\widehat a_n(\chi)|^4
 \ge \frac{q^n}{q^n-1}\Delta_n^2.
 \qquad\square
\]

The theorem separates two statements that were previously being conflated.
The genus-zero zeta function makes the **total shell mass** exact.  It says
nothing by itself about the nontrivial additive characters, and those modes
carry all nonconstant Goldbach/gap data.

## 2. The infinity-place theorem: when Goldbach really is a gap

The finite-place reflection \(x\mapsto-x\) is not the whole story over
\(\mathbf F_q[T]\).  One must also specify the type at the place infinity:
degree and leading coefficient.

For \(A\in V_n\), define the opposite-leading Goldbach mass

\[
 \mathcal G_n^{+-}(A)=
 \sum_{\substack{f+g=A\\
                  \deg f=\deg g=n\\
                  \operatorname{lc}(f)=1,\ \operatorname{lc}(g)=-1}}
       \Lambda(f)\Lambda(g).
\]

### Theorem 2 (global reflection with the infinity type included)

For every \(A\in V_n\),

\[
 \boxed{\mathcal G_n^{+-}(A)=C_n(-A).}
\]

#### Proof

Write \(f=T^n+x\).  Since \(f+g=A\), the polynomial \(-g=f-A\) is monic of
degree \(n\), and unit invariance gives \(\Lambda(g)=\Lambda(-g)\).  Hence

\[
 \mathcal G_n^{+-}(A)
 =\sum_{\substack{f\,\operatorname{monic}\\ \deg f=n}}\Lambda(f)\Lambda(f-A)
 =C_n(-A).\qquad\square
\]

Thus sum and difference are globally identical only after reflection also
matches the infinity component.  Ordinary fixed gaps preserve the monic
degree-\(n\) shell.  Reflection turns the second prime into an anti-monic
degree-\(n\) prime, and their sum cancels at infinity.  This is the exact
function-field version of the positive-cone/archimedean obstruction in
`ADELIC.md`.

For comparison, two monic degree-\(n\) summands have target leading
coefficient \(2\) in odd characteristic; their count is \(R_n(s)\) for the
target \(2T^n+s\).  The common convention in polynomial Goldbach instead
fixes a monic target \(F\) of degree \(n\) and takes monic summands of degrees
\(n\) and \(n-1\).  Its von Mangoldt mass is

\[
 \mathcal B_n(F)=
 \sum_{g\in\mathcal M_{n-1}}\Lambda(g)\Lambda(F-g),
\]

where \(\mathcal M_j\) denotes the monic degree-\(j\) polynomials.  It is not
the correlation \(C_n\), because it couples two different infinity shells.
Nevertheless its ensemble mean is again exact:

\[
 \boxed{\frac1{q^n}\sum_{F\in\mathcal M_n}\mathcal B_n(F)=q^{n-1}.}
\]

Indeed, for fixed \(g\in\mathcal M_{n-1}\), translation \(F\mapsto F-g\)
permutes \(\mathcal M_n\), and the two shell masses are \(q^n\) and
\(q^{n-1}\).

## 3. Sawin--Shusterman inside the pair field

Let \(p\) be an odd prime, let \(q\) be a power of \(p\), and assume

\[
 q>685090p^2.
\]

For nonzero \(A\in\mathbf F_q[T]\), put

\[
 \mathfrak S_q(A)=
 \prod_P(1-|P|^{-1})^{-2}
 \left(1-|P|^{-1}-|P|^{-1}\mathbf1_{P\nmid A}\right),
\]

where \(P\) ranges over monic irreducibles and \(|P|=q^{\deg P}\).  This is
the finite-place local density: the two forbidden residues modulo \(P\)
coalesce exactly when \(P\mid A\).

Sawin--Shusterman, Theorem 6.3, proves that there is \(\lambda>0\) such that,
for monic \(A\) with \(0\le\deg A<n\),

\[
 \boxed{
 C_n(A)=\mathfrak S_q(A)q^n+O_q\bigl(q^{(1-\lambda)n}\bigr).}
\]

Their Theorem 1.1 states the corresponding prime count for every fixed
nonzero shift:

\[
 \#\{f\in\mathcal M_n:f, f+A\text{ irreducible}\}
 \sim \mathfrak S_q(A)\frac{q^n}{n^2}.
\]

The first display is already a \(\Lambda\)-identity and therefore includes
prime powers.  The second is a statement about irreducibles only.  They
agree asymptotically because non-prime prime powers in a degree shell number
\(O_q(q^{n/2})\), but they should not be silently identified.

Combining their theorem with Theorem 2 gives the exact solved crossed-infinity
Goldbach channel

\[
 \boxed{
 \mathcal G_n^{+-}(-A)
 =\mathfrak S_q(A)q^n+O_q\bigl(q^{(1-\lambda)n}\bigr).}
\]

This corollary is a synthesis, not a new estimate: all analytic depth is
Sawin--Shusterman's; the new value is locating precisely which Goldbach
fiber their fixed-gap theorem controls under reflection.

### What their geometry actually contributes

The proof is not "Weil RH for \(\mathbf A^1\), therefore twins."  The
genus-zero zeta identity supplied only the trivial Fourier mode in Theorem 1.
Sawin--Shusterman first cross the parity barrier analytically: polynomial
differentiation and Pellet's formula turn the Möbius sign, on fixed-derivative
subspaces, into shifted quadratic Dirichlet characters.  A convolution
identity then reduces the von Mangoldt correlation to distribution estimates
beyond level \(1/2\).  The necessary cancellation comes from trace formulas
for auxiliary sheaves.  Deligne's weight bounds control Frobenius eigenvalues,
but because the dimension grows with \(n\), this is useful only after deep
vanishing-cycle arguments bound the cohomological range and the Betti
numbers.  Those vanishing and complexity bounds are the genuinely hard
input.

So the correct hierarchy is

\[
 \text{base genus-zero zeta}
 \;<\;
 \text{nontrivial additive pair modes}
 \;<\;
 \text{auxiliary sheaf cohomology controlling those modes}.
\]

RH is present in the last step as Deligne purity/weights, not as a list of
zeros of \(Z_{\mathbf F_q[T]}\).

## 4. Boundary of the solved-model claim

Three different statements must remain separate.

1. **Established exactly here:** the shell Fourier identities, common
   fourth-moment energy, quantitative nonzero fluctuation, infinity-type
   reflection, and exact ensemble mean of the asymmetric Goldbach mass.
2. **Established by Sawin--Shusterman:** the fixed-field, fixed-gap
   Hardy--Littlewood asymptotic above (with a power saving), plus Chowla under
   their hypotheses.  Their Remark 1.2 says their proof also establishes a
   function-field Goldbach analogue and can treat more general linear forms.
3. **Not licensed by the displayed fixed-gap theorem alone:** a pointwise
   asymptotic for every convention called "binary polynomial Goldbach."
   One must specify leading coefficients, the two degree shells, how the
   target varies with \(n\), and the required uniformity.  The crossed-infinity
   channel follows immediately by Theorem 2; the conventional
   degree-\((n,n-1)\) channel does not follow from reflection and should be
   cited to a theorem with that precise normalization.  Bender--Pollack prove
   that conventional asymptotic in the different regime where \(q\) is large
   compared with \(n\).  Effinger--Hayes concerns the **three-primes** problem
   and is not a citation for a fixed-field binary asymptotic.

This fence is not pedantry.  In the function-field model, "positivity at
infinity" is the discrete datum consisting of degree and leading coefficient.
Changing it changes the problem.

## References and prior-art status

- W. Sawin and M. Shusterman, *On the Chowla and twin primes conjectures
  over \(\mathbf F_q[T]\)*, Annals of Mathematics **196** (2022), 457--506,
  [doi:10.4007/annals.2022.196.2.1](https://doi.org/10.4007/annals.2022.196.2.1).
  Theorem 1.1 is the prime count; Theorem 6.3 is the weighted correlation;
  Remark 1.2 records the Goldbach/general-linear-forms extension.
- E. Kowalski, *Binary additive problems for polynomials over finite fields*,
  Bourbaki Seminar, Exp. 1193 (2021),
  [PDF](https://www.bourbaki.fr/TEXTES/Exp1193-Kowalski.pdf).  This is a
  detailed guide to the derivative trick, trace formula, cohomological
  vanishing, and Betti-number issue.
- A. O. Bender and P. Pollack, *On quantitative analogues of the Goldbach and
  twin prime conjectures over \(\mathbf F_q[t]\)*,
  [arXiv:0912.1702](https://arxiv.org/abs/0912.1702).  Their individual
  Goldbach asymptotic is in the large-\(q\)-relative-to-degree regime.
- D. R. Hayes and G. W. Effinger, *Additive Number Theory of Polynomials over
  a Finite Field*, Oxford, 1991.  Its Goldbach theorem is ternary.

Theorem 1 is elementary finite harmonic analysis plus the affine zeta
identity.  Theorem 2 is elementary but is the important synthesis: it makes
the place at infinity explicit.  No novelty is claimed for the Fourier
identities themselves.  The potentially useful contribution is the combined
diagnosis: a zero-free one-body zeta coexists with quantitatively forced pair
fluctuations, and the geometry solving fixed gaps acts on auxiliary pair-mode
cohomology rather than on the base zeta spectrum.
