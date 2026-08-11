# Sharp Goldbach cutoff: canonical distribution, positive-cone edges, and an infinite-energy boundary

This note answers the standing escalation after the $k=2$ Cesàro replication:
what remains at the unsmoothed endpoint $k=0$?  There is a canonical
distributional zero-pair field, but not a pointwise double series, and the
absolute-energy variance method of `APPENDIX_D.md` provably breaks there.

The exact sharp explicit formula, including its incomplete-beta edge terms, is
prior art due to Cantarini.  The contribution here is to isolate the Riesz
descent, its regularity threshold, and the order-of-limits obstruction in the
language of the pair-field program.

## 1. Riesz descent defines the sharp pair field

Assume RH and write $\rho=\tfrac12+i\gamma$.  For $k\ge0$, set

$$W_k(\gamma,\gamma')=
\frac{\Gamma(\rho)\Gamma(\rho')}
{\Gamma(\rho+\rho'+k+1)}.$$

At Cesàro level $k=1$ the pair field

$$A_1(u)=\sum_{\gamma,\gamma'}W_1(\gamma,\gamma')
e^{i(\gamma+\gamma')u}$$

converges absolutely.  The Gamma recurrence gives

$$W_0=(\rho+\rho'+1)W_1=(2+i(\gamma+\gamma'))W_1.$$

> **Theorem 1 (canonical sharp distribution).** Define
> $$A_0=(2+\partial_u)A_1.$$
> Then
> $$A_0=\lim_{\varepsilon\downarrow0}
> \sum_{\gamma,\gamma'}W_0(\gamma,\gamma')
> e^{i(\gamma+\gamma')u-\varepsilon(|\gamma|+|\gamma'|)}$$
> in $\mathcal D'(\mathbb R)$.  In $X=e^u$ coordinates,
> $$X A_0(\log X)=\partial_X\!left[X^2A_1(\log X)\right].$$

This is exactly the distributional Riesz descent

$$\partial_X\frac{(X-n)_+^1}{\Gamma(2)}
=\frac{(X-n)_+^0}{\Gamma(1)}.$$

Thus the formal $k=0$ residue layer has a canonical meaning, but only after
specifying distributional convergence (or an equivalent Abel prescription).

## 2. The convergence and regularity thresholds are sharp

Stirling gives, for same-sign ordinates in a dyadic block of height $T$,

$$|W_0(\gamma,\gamma')|\asymp
|\gamma+\gamma'|^{-3/2},$$

while opposite signs are exponentially suppressed.  Since a dyadic square
contains $\asymp T^2\log^2T$ zero pairs,

$$\sum_{\gamma,\gamma'\asymp T}|W_0|^p
\asymp T^{2-3p/2}\log^2T.$$

> **Proposition 2.** The sharp weights satisfy
> $$W_0\in\ell^p\quad\Longleftrightarrow\quad p>\frac43.$$
> In particular $W_0\in\ell^2\setminus\ell^1$.

The same dyadic estimate gives the Hölder--Zygmund regularity

$$A_1\in C_*^{1/2-\varepsilon},
\qquad A_0\in C_*^{-1/2-\varepsilon}$$

for every $\varepsilon>0$.  The sharp pair layer is naturally a
negative-regularity distribution, not a pointwise almost-periodic function.

## 3. The positive cone produces exact edge counterterms

The bare homogeneous $W_0$ series is not the exact sharp Goldbach formula.
Cantarini's $k=0$ formula contains the combined kernel

$$\begin{aligned}
K_N(a,b)={}&\frac{\Gamma(a)\Gamma(b)}{\Gamma(a+b+1)}\\
&-\frac{B_{1/N}(b+1,a)+B_{1/2}(a,b+1)}{b}\\
={}&\frac1b\int_{1/2}^{1-1/N}t^{a-1}(1-t)^b\,dt.
\end{aligned}\tag{3.1}$$

The incomplete beta terms therefore remove the forbidden boundary faces of
the completed additive simplex.  They are the exact analytic trace of the
positive-cone obstruction, not arbitrary regularization.  The sharp pair term
is a symmetrically interpreted sum of

$$2(2N)^{\rho+\rho'}K_N(\rho,\rho'),$$

together with explicit archimedean and edge terms. Brüdern--Kaczorowski--Perelli
accordingly call the naive $k=0$ double-residue formula purely formal; their
simple homogeneous pair sum is absolutely convergent only for $k>1/2$.

## 4. Absolute near-diagonal energy diverges at every resolution

For a fixed frequency resolution $\eta>0$, define the absolute energy

$$E^{\rm abs}_0(\eta)=
\sum_{|\gamma_i+\gamma_j-\gamma_k-\gamma_l|\le\eta}
|W_{0,ij}W_{0,kl}|.$$

> **Theorem 3 (sharp variance no-go).** For every $\eta>0$,
> $$E^{\rm abs}_0(\eta)=\infty.$$
> More quantitatively, truncation at zero height $H$ satisfies
> $$E^{\rm abs}_{0,\le H}(\eta)\gg
> \eta(\log H)^5.$$
> The divergence remains after deleting the diagonal.

*Proof.* Restrict both ordinates to $[T,2T]$.  There are
$\asymp T^2\log^2T$ pairs of weight $\asymp T^{-3/2}$, so their total
variation in a frequency interval of length $O(T)$ is

$$M_T\asymp T^{1/2}\log^2T.$$

Partition the interval into $O(T/\eta)$ bins.  Cauchy--Schwarz gives within-bin
energy at least

$$\frac{M_T^2}{O(T/\eta)}\gg\eta\log^4T.$$

The diagonal contribution in that block is only
$O(T^{-1}\log^2T)$, hence is negligible. Summing over disjoint dyadic blocks
up to $H$ gives the stated $\eta(\log H)^5$ lower bound. $\square$

Thus the absolute-energy/Fejér method in `APPENDIX_D.md` cannot be desmoothed to
$k=0$.  A local square of $A_0$ is not canonical; a sharp covariance requires
an additional spectral mollifier or genuinely new cancellation/correlation
input.

## 5. The two limits do not commute

Let $A_{0,T}$ truncate ordinates at height $T$ and average its square over a
log-window of length $L$.

- If $L\to\infty$ first, unequal frequencies disappear; then $T\to\infty$
  can leave the finite $\ell^2$ diagonal, modulo exact additive collisions.
- If $T\to\infty$ at fixed resolution $1/L$, the absolute off-diagonal energy
  grows at least $(\log T)^5/L$.

Any “sharp variance constant” must therefore specify a two-parameter limit and
an additive-collision hypothesis. It is not automatically an arithmetic
dyadic-variance theorem. The appearance of a fifth logarithm is structurally
suggestive of the $\log^5$ scales in sharp Goldbach error bounds, but no causal
derivation is claimed.

Finally, there is no information-theoretic rigidity gain:
$G_0(N)-G_0(N-1)=R(N)$, so the sharp cumulative field is equivalent to the
original Goldbach multiplicities.

## 6. Prior art

- J. Brüdern, J. Kaczorowski, A. Perelli, *Explicit formulae for averages of
  Goldbach representations*, [arXiv:1712.00737](https://arxiv.org/abs/1712.00737).
- M. Cantarini, *A note on the Goldbach counting function*,
  [arXiv:1801.08475](https://arxiv.org/abs/1801.08475).

**Verdict.** The exact sharp edge formula is prior art. The useful theorem for
this program is the boundary statement: canonical distributional descent
survives, while absolute local energy does not.
