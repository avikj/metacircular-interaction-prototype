# The finite-sieve martingale, the Buchstab window, and the parity threshold

This note joins the finite-adic/KMS layer of `ADELIC.md` and
`papers/crossover.md` to an actual finite observation window.  The main
correction is simple but consequential:

> The finite Euler product gives the right **local correlation**, but at
> polynomial sieve depth it does not give the right **one-body density** on
> `[1,X]`.  The missing factor is archimedean and is measured by Buchstab's
> function.

This separates three effects that were previously easy to conflate:

1. finite-place Hardy--Littlewood geometry;
2. archimedean finite-window normalization;
3. the parity sector which distinguishes primes from rough composites.

Everything through Section 7 is a theorem or an exact identity.  Section 8
marks the prior-art boundary and the genuinely open mixed-correlation term.

---

## 1. Exact finite harmonic martingale

For squarefree `W`, define the periodic density

\[
 \nu_W(n)=\frac{W}{\varphi(W)}\mathbf 1_{(n,W)=1}.
\]

Its exact Ramanujan expansion is

\[
 \boxed{
 \nu_W(n)=\sum_{q\mid W}\frac{\mu(q)}{\varphi(q)}c_q(n).
 }
\]

If `W | Q`, average functions modulo `Q` over lifts of a residue modulo `W`.
Then

\[
 \boxed{\mathbb E(\nu_Q\mid n\bmod W)=\nu_W.}
\]

Thus `(nu_W)` is literally a martingale on the inverse system of finite
residue rings.  Its Fourier shells are disjoint.  In particular, for every
integer `r >= 1`,

\[
 C_W^{(r)}:=\sum_{q\mid W}\frac{\varphi(q)}{\varphi(q)^{2r}}
 =\prod_{p\mid W}\left(1+(p-1)^{1-2r}\right),
\]

and for `W | Q` the `2r`-moment added by the new shell is exactly
`C_Q^(r)-C_W^(r)`.

For the fourth-order energy below, write

\[
 \mathcal C_W=\prod_{p\mid W}\left(1+\frac1{(p-1)^3}\right),
 \qquad
 \mathcal C_\infty=\prod_p\left(1+\frac1{(p-1)^3}\right)
 =2.3009615\ldots.
\]

The same local factor occurs for the four forms

\[
 L_1=x,\quad L_2=y,\quad L_3=z,\quad L_4=x+y-z,
\]

because their normalized `p`-adic density is
`1+(p-1)^(-3)`.

---

## 2. A fixed-sieve prime-tail theorem

For a finitely supported real sequence `f`, let

\[
 G_f(N)=\sum_{m+n=N}f(m)f(n),\qquad
 D_f(h)=\sum_n f(n)f(n+h).
\]

Additive Parseval gives the exact identity

\[
 \boxed{\sum_N|G_f(N)|^2=\sum_h|D_f(h)|^2.}
\]

Now fix squarefree `W` and put

\[
 f_{W,X}(n)=(\Lambda(n)-\nu_W(n))\mathbf1_{1\le n\le X}.
\]

### Theorem 2.1 (finite-sieve fourth-energy tail)

For fixed `W`, as `X -> infinity`,

\[
 \boxed{
 \sum_N|G_{f_{W,X}}(N)|^2
 =\sum_h|D_{f_{W,X}}(h)|^2
 =\frac23(\mathcal C_\infty-\mathcal C_W)X^3+o_W(X^3).
 }
\]

Equivalently,

\[
 \mathcal C_\infty-\mathcal C_W
 =\sum_{q\nmid W}^{\!*}\frac{\mu(q)^2}{\varphi(q)^3},
\]

so the leading energy is exactly the unresolved Ramanujan shell.

### Proof

Expand the fourth product over `Lambda-nu_W` on the four forms above.  The
all-`Lambda` term has Green--Tao local constant `C_infinity`.  Every proper
mixed term contains at most three Mangoldt forms.  Any three of the four
forms are linearly independent over every finite field, so primes outside
`W` contribute local factor one; primes dividing `W` contribute the common
factor `C_W`.  The coefficients of all proper mixed terms sum to `-1`, since
`(1-1)^4=0`.  The polytope on which all four forms lie in `[1,X]` has volume
`2X^3/3`.  The Green--Tao finite-complexity linear-forms theorem gives the
stated asymptotic.  The gap equality is Parseval.

This theorem is useful but it is not yet a prime-pair theorem: it measures an
`L^4` average, and `W` is fixed.  It does, however, turn the finite KMS/sieve
filtration into a quantitative orthogonal decomposition.

---

## 3. Polynomial depth: the missing archimedean factor

Let

\[
 w=X^{1/u},\qquad W=W(w)=\prod_{p\le w}p,
\]

with fixed `u >= 2`, and let `omega` be Buchstab's function.  If

\[
 \Phi(X,w)=\#\{n\le X:(n,W)=1\},
\]

then Buchstab and Mertens give

\[
 \Phi(X,w)\sim\frac{X\omega(u)}{\log w},\qquad
 \frac W{\varphi(W)}\sim e^\gamma\log w.
\]

Consequently

\[
 \boxed{
 \frac1X\sum_{n\le X}\nu_W(n)\longrightarrow e^\gamma\omega(u),
 }
\]

which is not one at fixed `u`.  The finite-adic density is normalized on a
complete residue ring, not on the positive interval `[1,X]`; the difference
is precisely an archimedean boundary effect.

This also gives the uncorrected variance law

\[
 \sum_{n\le X}|\Lambda(n)-\nu_W(n)|^2
 \sim v(u)X\log X,
\]

where

\[
 \boxed{
 v(u)=1-\frac{2e^\gamma}{u}
       +\frac{e^{2\gamma}\omega(u)}u.
 }
\]

In particular, the finite Euler-product tail from Theorem 2.1 cannot be
extrapolated unchanged to polynomial `w`.  A nonzero mean has entered before
any pair or zero statistic is considered.

---

## 4. Exact Buchstab normalization and variance

The correct finite-window rough density is

\[
 \widetilde\nu_{X,w}(n)
 =\frac{X}{\Phi(X,w)}
  \mathbf1_{1\le n\le X,(n,W)=1}.
\]

It has exact mean one on `[1,X]`.

### Theorem 4.1 (corrected variance)

For fixed `u > 2`,

\[
 \boxed{
 \sum_{n\le X}|\Lambda(n)-\widetilde\nu_{X,X^{1/u}}(n)|^2
 \sim\left(1-\frac1{u\omega(u)}\right)X\log X.
 }
\]

### Proof

Use

\[
 \sum_{n\le X}\Lambda(n)^2\sim X\log X,
 \quad
 \sum_{\substack{n\le X\\(n,W)=1}}\Lambda(n)\sim X,
 \quad
 \frac X{\Phi(X,w)}\sim\frac{\log X}{u\omega(u)}.
\]

The two cross terms and the rough square combine to one negative copy of the
last constant.

At `u=2` the displayed coefficient vanishes.  The next term is nonzero:

\[
 \boxed{
 \sum_{n\le X}|\Lambda(n)-\widetilde\nu_{X,\sqrt X}(n)|^2
 \sim\frac X{\log X}.
 }
\]

Indeed

\[
 c_X:=\frac X{\Phi(X,\sqrt X)}
 =\frac X{1+\pi(X)-\pi(\sqrt X)}
 =\log X-1-\frac1{\log X}+O((\log X)^{-2}),
\]

and direct expansion of the square gives the result.

---

## 5. The square-root threshold is exactly exhausted by the log weight

At `w=sqrt(X)`, an integer at most `X` with no prime factor at most `sqrt(X)`
is either `1` or a prime greater than `sqrt(X)`.  Put

\[
 r_X(n)=\mathbf1_{\{1\}\cup\{p:\sqrt X<p\le X\}}(n),
 \qquad
 a_X(n)=(\log n-c_X)r_X(n).
\]

Then the following pointwise identity is exact:

\[
 \boxed{
 \Lambda(n)-\widetilde\nu_{X,\sqrt X}(n)-a_X(n)
 =\sum_{\substack{p^k=n\\p\le\sqrt X}}\log p.
 }
\]

Thus restoring the natural logarithmic Hamiltonian on the rough support
removes every large prime exactly.  The residual has total mass
`X^(1/2+o(1))`; it contains no macroscopic zero field.  The parity-sensitive
bulk begins only for `u>2`, when semiprimes with both factors above
`X^(1/u)` enter the rough set.

This is a no-go result for one tempting interpretation of the critical
energy: at the square-root endpoint, the leading discrepancy is not a hidden
zeta-zero fluctuation.  It is the deterministic mismatch between a constant
sieve weight and `log p`.

---

## 6. Critical fourth energy

Let

\[
 g(x)=(1+\log x)\mathbf1_{(0,1)}(x),
 \qquad
 \mathcal I_{\rm arch}=\int_{\mathbb R}|(g*g)(s)|^2ds
 =0.1814745290\ldots.
\]

For `0<s<=1`, one convenient closed form is

\[
 (g*g)(s)=s\left((\log s)^2+1-\frac{\pi^2}{6}\right).
\]

### Theorem 6.1 (critical archimedean shape energy)

For

\[
 f_X=(\Lambda-\widetilde\nu_{X,\sqrt X})\mathbf1_{[1,X]},
\]

one has

\[
 \boxed{
 \sum_N|G_{f_X}(N)|^2
 =\sum_h|D_{f_X}(h)|^2
 \sim \mathcal C_\infty\mathcal I_{\rm arch}
       \frac{X^3}{(\log X)^4}.
 }
\]

The same leading term remains after subtracting the two disconnected
pairings.

### Proof

On primes `p=Xx>sqrt(X)`,

\[
 f_X(p)=\log p-c_X
 =\Lambda(p)\left(1-\frac{c_X}{\log p}\right),
\]

and

\[
 (\log X)\left(1-\frac{c_X}{\log(Xx)}\right)
 \longrightarrow1+\log x.
\]

Weighted Green--Tao for the four forms of Section 1, followed by partial
summation, gives the constant `C_infinity` times the archimedean convolution
integral.  The exact decomposition of Section 5 and Young's inequality show
that small-base prime powers and all mixed terms are negligible at this
scale.  Finally, the variance in Section 4 makes the two disconnected
contractions `O(X^2/(log X)^2)=o(X^3/(log X)^4)`.

Convergence is logarithmically slow.  `code/exp20_buchstab.py` compares the
finite-`X` energy both with the limiting constant and with the finite-window
archimedean profile; the latter explains the apparent pre-asymptotic excess.

---

## 7. The first shape response for fixed `u>2`

The first-order Buchstab formula is too coarse to see a `1/log X` profile.
De Bruijn's refined main term is required.  If `lambda=log w` and
`u_t=log(t)/lambda`, then uniformly near fixed `u>2`,

\[
 \Phi(t,w)=t\left(
 \frac{\omega(u_t)}\lambda
 -\frac{\omega'(u_t)}{\lambda^2}
 +o(\lambda^{-2})\right).
\]

The second term cancels when the cumulative density is differentiated, then
reappears through exact normalization at `X`.  For every `C^1` test function
compactly supported in `(0,1]`,

\[
 \boxed{
 \frac{\log X}{X}\sum_{n\le X}
 (\Lambda(n)-\widetilde\nu_{X,X^{1/u}}(n))h(n/X)
 \longrightarrow
 -\frac{u\omega'(u)}{\omega(u)}
 \int_0^1(1+\log x)h(x)\,dx.
 }
\]

The coefficient is the logarithmic scale derivative of the Buchstab flow.
The endpoint is singular: at `u=2`, the exact coefficient is `+1`, whereas
the right-hand limit from `u>2` is `-1`.  The jump is the entrance of the
semiprime layer.

---

## 8. Prior-art boundary and the open mixed expansion

Pandey--Woo, Proposition 2.3, deduced from Matthiesen's theorem on linear
correlations of multiplicative functions, proves that for any
finite-complexity system of linear forms the **leading** joint density of
`w`-rough values factorizes into

\[
 (e^\gamma\omega(u))^k\times\text{finite local density}.
\]

After normalizing by the true one-body rough density, the Buchstab factors
cancel, leaving precisely the finite Euler-product correlation.  This gives
the clean bridge to `papers/crossover.md`:

> The KMS/Hardy--Littlewood product is the normalized correlation skeleton;
> Buchstab's factor is the archimedean one-body compensation required to
> realize that skeleton in a polynomial finite window.

No new multidimensional Buchstab function is needed at leading order.  But
the available result has only relative `o(1)` error.  In the centered fourth
product, the order-one terms cancel, so it does not determine the next
coefficient.

For `2<u<3`, every rough integer below `X` is `1`, a prime, or a semiprime.
Since

\[
 A(u):=u\omega(u)=1+\log(u-1),
\]

primes and semiprimes occupy asymptotic fractions `1/A(u)` and
`(A(u)-1)/A(u)` of the rough set.  After scaling by `log X`, the centered
weights are respectively

\[
 \frac{A(u)-1}{A(u)},\qquad-\frac1{A(u)},
\]

whose conditional mean cancels exactly.  The live theorem target is therefore
not a leading-density formula but a sufficiently quantitative expansion of

\[
 \sum_{\mathbf n}
 \prod_{i\in B}\Lambda(L_i(\mathbf n))
 \prod_{j\notin B}\widetilde\nu_{X,w}(L_j(\mathbf n)),
 \qquad B\subseteq\{1,2,3,4\},
\]

through the first nonvanishing order after inclusion--exclusion.  This is the
precise point where the finite-adic correlation model, the archimedean
Buchstab response, and the parity barrier meet.

The qualitative factorization cannot supply that expansion, and taking the
fourth power of the one-body response would be an unjustified independence
assumption.  A marked version using
`z^{Omega(n)} 1_{P^-(n)>w}` may isolate the prime/semiprime labels; whether
Matthiesen's method yields the necessary quantitative uniformity is the next
prior-art/proof check.

---

## References

- N. G. de Bruijn, *On the number of uncancelled elements in the sieve of
  Eratosthenes*, Proc. Koninklijke Nederlandse Akademie van Wetenschappen
  **53** (1950), 803--812.
- B. Green and T. Tao, *Linear equations in primes*, Annals of Mathematics
  **171** (2010), 1753--1850.
- L. Matthiesen, *Linear correlations of multiplicative functions*, Proc.
  London Math. Soc. **121** (2020), 372--425.
- M. Pandey and K. Woo, *Small scale distribution of linear patterns of
  primes*, J. London Math. Soc. **110** (2024), e13001, Proposition 2.3.

