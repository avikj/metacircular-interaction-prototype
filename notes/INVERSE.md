# The inverse problem, solved in theory: uniqueness by Laplace, structure by WKB

*No numerics in this note.* The corpus has measured a great deal; two of the
things it measured are consequences of short proofs that were never written.
Writing them changes the status of the program: the "read the zeros off the
primes" enterprise becomes a **well-posed inverse problem** (Theorem I1),
and the entropy phase law D‴ becomes a **structural identity** rather than
an asymptotic coincidence (Theorem I2).

---

## 1. Theorem I1 — the sum-spectrum determines the zeros

Let $\mu=\sum_i\delta_{\gamma_i}$ be the counting measure of the positive
ordinates of a self-dual $L$-function's nontrivial zeros (with
multiplicity; no hypothesis on where the zeros lie beyond $\gamma_i>0$ and
the classical density $N(T)\asymp T\log T$). The **sum spectrum** is the
additive convolution $\mu*\mu$, i.e. the multiset $\{\gamma_i+\gamma_j\}$
with multiplicity — precisely the frequency data of the pair layer of every
field in `FAMILY.md`.

> **Theorem I1 (essentially classical — attribution below).** Let $\mu,\mu'$ be
> positive locally finite measures on $\mathbb R$ with support bounded below.
> If $\mu*\mu=\mu'*\mu'$ then $\mu=\mu'$.

*Proof (three lines, no growth hypothesis).* The convolution algebra of
measures supported in a half-line is an **integral domain**: Titchmarsh's
theorem gives $\inf\operatorname{supp}(\mu*\nu)=\inf\operatorname{supp}\mu+
\inf\operatorname{supp}\nu$. From $\mu*\mu=\mu'*\mu'$ we get
$(\mu-\mu')*(\mu+\mu')=0$, so one factor vanishes; positivity kills
$\mu+\mu'=0$ unless both are zero. $\blacksquare$

**Attribution (prior-art search, resolved).** This is **known**, and the
earlier draft's Laplace-transform proof was the long way round:

- Titchmarsh, *Proc. LMS* (2) **25** (1926) 283–302; **Weiss**, *Proc. AMS*
  **19** (1968) 75–79 (measures on LCA groups); Lions, Mikusiński for
  multi-dimensional versions.
- The deautoconvolution literature has studied exactly $x*x\mapsto x$ for
  thirty years, calling the sign ambiguity "twofoldness":
  **Gerth–Hofmann–Birkholz–Koke–Steinmeyer**, *Inverse Probl. Sci. Eng.* **22**
  (2014) 245–266, **Thm 4.2** is I1 for densities (+positivity to kill the
  sign).
- **Gorenflo–Hofmann**, *Inverse Problems* **10** (1994) 353–373, **Thm 1** is
  *strictly stronger*: a nonnegative $x$ with $0\in\operatorname{supp}x$ is
  determined by $x*x$ **restricted to half its support range**.
- The discrete case is **Lambek–Moser (1959)**, via
  $f_A(x)^2-f_A(x^2)=2f_{A(2)}(x)$ — so `REPORT.md`'s Theorem A(1) is 1959
  folklore, and should say so.

**Two hypotheses the earlier draft imported unnecessarily.** $c>0$ does no
work (any support bounded below, by translation), and the $N(T)=O(T\log T)$
density bound is an *artifact of the Laplace proof* — needed only for
convergence. Via Titchmarsh, I1 holds for all positive locally finite measures
with support bounded below, **no density hypothesis whatsoever**. The note
previously advertised that bound as "the only hypothesis"; it is not a
hypothesis of the theorem at all.

**Which hypotheses are load-bearing (counterexamples).**

- **Support bounded below is essential.** Two distinct symmetric lattice laws
  on $\mathbb R$ with equal self-convolution: $\varphi_X$ = period-2 extension
  of $1-|t|$ on $[-1,1]$, $\varphi_Y$ = period-4 extension of $1-|t|$ on
  $[-2,2]$, so $\varphi_X=|\varphi_Y|$ and $\varphi_X^2=\varphi_Y^2$ while
  $X\ne_d Y$. Both have unbounded two-sided support and non-analytic
  characteristic functions — precisely what a half-line excludes. (Khinchin–
  Feller family; verified by construction.)
- **The diagonal is essential — and its absence genuinely kills uniqueness.**
  **Selfridge–Straus**, *Pacific J. Math.* **8** (1958) 847–856: an
  $n$-multiset is determined by its *diagonal-free* pairwise sums **iff $n$ is
  not a power of two**. Explicitly $\{0,3,5,6\}$ and $\{1,2,4,7\}$ share
  $\{3,5,6,8,9,11\}$; Gordon–Fraenkel–Straus give three mutually
  indistinguishable $8$-multisets. So $\mu*\mu$ — *including* the $2\gamma_i$
  terms — is exactly the right object, and dropping the diagonal fails on
  sizes $4,8,16,\dots$
- **Positivity is essential**: without it, exactly the $\pm\mu$ ambiguity.
- **Partial data**: Gorenflo–Hofmann Thm 2 — observing $x*x$ only on the lower
  half of its range with $0\notin\operatorname{supp}x$ admits *infinitely many*
  solutions. Relevant here, since the corpus's data is band-limited: knowing
  the sum spectrum on $[2c,2c+L]$ recovers $\mu$ only given
  $c=\inf\operatorname{supp}\mu$ exactly.

**Corollary I1.1 (uniqueness — *not* well-posedness).** *Relabelled after
audit: Hadamard well-posedness needs stability, which fails here.* The exact
prior art for the missing half is **Gorenflo–Hofmann 1994, Lemma 6**: the
nonnegative deautoconvolution problem is **locally ill-posed everywhere**
(inversion rates: Fleischer–Hofmann, *Inverse Problems* **12** (1996) 419–435).
That is the correct citation home for this corpus's Theorem K / conditioning
row — and it means the slogan "uniqueness is free, conditioning is
everything" is a **restatement of a known result, not a discovery here**.
A second overreach, corrected: I1 says *if* the data equals $\mu*\mu$ exactly
then $\mu$ is determined; it says nothing about whether observed data has that
form, so it does **not** discharge the sumset assumption of `BLIND.md` — it
only makes the inversion well-defined once that assumption is granted.
Further caveat:
I1′ recovers $\mu$ from the **ordered** pair multiset $\{\gamma_i+\gamma_j\}_{i,j}$
including the diagonal $i=j$. If the observed pair layer is instead the
unordered off-diagonal multiset $\{\gamma_i+\gamma_j\}_{i<j}
=\tfrac12(\mu*\mu-D_\#\mu)$, that is a different functional equation and I1′
does not discharge it directly — it must be proved separately or the diagonal
identified independently. **[RESOLVED, negatively — `notes/OFFDIAGONAL_NO_GO.md`,
cf-prouhet 2026-08-18.** The off-diagonal functional equation is
$(f_A-f_B)(f_A+f_B)=p(x^2)\ne0$, so the integral-domain step of I1 gives
nothing, and there is a classical **infinite** counterexample: the evil and
odious numbers (Thue–Morse / Prouhet 1851) are distinct sets with support
bounded below and *identical* off-diagonal pairwise-sum multisets. So the
diagonal is load-bearing: no purely off-diagonal uniqueness theorem exists, and
the "diagonal is essential" bullet above is not a finite-$n$ artifact — it
persists to the infinite zero-side regime. Any pipeline observing only the
off-diagonal pair layer supplies the diagonal implicitly and must say from
where.]** Subject to that, the pair layer of any dressing in
the residue-dressing family determines the zero multiset uniquely — positions *and* multiplicities. Two distinct zero
configurations cannot produce the same Goldbach-type pair spectrum. In
particular the chain inversion used to extract $\gamma_1,\dots,\gamma_4$
from Möbius data (`BLIND.md`) is not an ansatz: it is the constructive form
of a uniqueness theorem, and its structural assumption ("the atom set is a
sumset") is exactly the hypothesis I1 discharges.

**Corollary I1.2 (simplicity is detectable).** Since $\mu$ is recovered
*with multiplicity*, the sum spectrum distinguishes simple zeros from
multiple ones. Any dressing whose pair layer is observed to arbitrary
precision decides zero simplicity — no separate hypothesis needed at the
level of information (only at the level of resources, cf. §3).

**Remark (why sums and not differences).** The identical argument fails for
the difference spectrum $\mu\star\tilde\mu$: there $F(s)\overline{F(\bar s)}$
appears, no integral-domain factorization is available, and indeed
uniqueness is *false* — this is the classical homometry of `REPORT.md`
Theorem A(ii). So the corpus's oldest theorem (sum marginals are rigid,
difference marginals are not, proved there for finite subsets of $\mathbb Z$)
holds verbatim **on the zero side**, by the same mechanism, for measures on
$\mathbb R$. Theorem A and Theorem I1 are one statement in two categories:
$$\text{primes: } A(x)^2 \text{ determines } A(x)
\qquad\longleftrightarrow\qquad
\text{zeros: } F(s)^2 \text{ determines } F(s).$$
The holomorphic/Hermitian dichotomy is not an analogy between the two sides
of the Laplace bridge; it is the *same* square-root rigidity applied twice.

---

## 2. Theorem I2 — why the phase is an entropy

The measured law (`BLOCKS.md` §2, `FAMILY.md` §2.3) is
$$W_k=\Gamma(2)\frac{\prod_{i=1}^k\Gamma(\rho_i)}{\Gamma(\sum_i\rho_i+2)}
=(2\pi)^{\frac{k-1}{2}}s^{-\frac{k+3}{2}}
e^{-i\left(sH_k(\vec p)+\frac{(k+3)\pi}{4}\right)}\bigl(1+O(\min_i\gamma_i^{-1})\bigr),$$
$\rho_i=\tfrac12+i\gamma_i$, $s=\sum\gamma_i$, $p_i=\gamma_i/s$,
$H_k(\vec p)=-\sum p_i\log p_i$. It was verified by Stirling and by
numerics. Here is what it *is*.

> **Theorem I2 (the weight is a semiclassical simplex integral).** $W_k$ is
> exactly the Dirichlet integral over the standard simplex,
> $$W_k=\int_{\Delta_k}\prod_i u_i^{\rho_i-1}\Bigl(1-\sum_i u_i\Bigr)\,du ,$$
> and in polar simplex coordinates it **factors exactly** into a radial Beta
> factor and an angular simplex integral, whose large-$s$ evaluation gives:
> 1. the **phase is the action**: the angular factor has a genuine interior,
>    nondegenerate stationary point at $w_i=p_i$ on $\{\sum w=1\}$, with
>    stationary value $-s\,H_k(\vec p)$ — the entropy is the classical action
>    of the constraint geometry. (There is *no* interior stationary point on
>    $\Delta_k$ itself; the naive application fails, see the proof.)
> 2. the **modulus is splitting-blind** because the half-density amplitude
>    $\prod_i p_i^{-1/2}$ and the *restricted* $(k-1)\times(k-1)$ Hessian
>    determinant $|\det M|^{-1/2}=s^{-(k-1)/2}(\prod_i p_i)^{1/2}$ cancel
>    exactly — and in fact splitting-blindness holds *exactly*, not just
>    asymptotically (see the upgrades below);
> 3. the **Maslov constant** $(k+3)\pi/4$ decomposes as $(k-1)\pi/4$ from the
>    $(k-1)$ negative Hessian eigenvalues plus $\pi$ from the two powers of
>    $1/(is)$ in the radial Beta factor.

*Proof (corrected; the first version was invalid — see below).* The Dirichlet
identity is exact as stated ($\Gamma(2)$ and the exponent $2-1=1$ are right;
convergent since $\operatorname{Re}\rho_i=\tfrac12>0$). The key move is that in
polar simplex coordinates $u=\sigma w$, $\sum w_i=1$, $du=\sigma^{k-1}d\sigma\,dw$,
**the integral factors exactly** — not asymptotically:
$$W_k=\underbrace{\int_0^1\sigma^{S-1}(1-\sigma)\,d\sigma}_{=\,\frac{\Gamma(2)\Gamma(S)}{\Gamma(S+2)}=\frac{1}{S(S+1)}}
\cdot\underbrace{\int_{\{\sum w=1\}}\prod_i w_i^{\rho_i-1}dw}_{=\,\prod_i\Gamma(\rho_i)/\Gamma(S)},
\qquad S=\sum_i\rho_i=\tfrac k2+is.$$

*Radial factor:* a non-stationary endpoint with a simple amplitude zero at
$\sigma=1$, giving $1/(S(S+1))\sim(is)^{-2}$ — modulus $s^{-2}$, phase $-\pi$.
*Angular factor:* a genuine **interior, nondegenerate $(k-1)$-dimensional**
stationary point. In free coordinates $w_1,\dots,w_{k-1}$ ($w_k=1-\sum_{a<k}w_a$),
$\partial_a\varphi=s(p_a/w_a-p_k/w_k)=0\iff w=p$, with $\varphi(p)=-sH_k(p)$ and
$$M_{ab}=-s\Bigl(\frac{\delta_{ab}}{p_a}+\frac1{p_k}\Bigr),\qquad
\det M=\frac{(-s)^{k-1}}{\prod_{i=1}^{k}p_i}\quad(\text{matrix-determinant lemma}),\quad M\prec0.$$
The **cancellation is then exact for every $k$**: amplitude
$\prod_{i\le k}p_i^{-1/2}$ times $|\det M|^{-1/2}=s^{-(k-1)/2}(\prod_{i\le k}p_i)^{1/2}$
equals $s^{-(k-1)/2}$, with the $p_k$ factor supplied by the elimination of
$w_k$. Maslov: $-(k-1)\pi/4$ from the $(k-1)$ negative eigenvalues, $-\pi$ from
the two powers of $1/(is)$ in the radial Beta factor, total $-(k+3)\pi/4$.
$\blacksquare$

**Three errors in the first version, recorded.** (i) It claimed a "unique
stationary point on $\Delta_k$". There is **no interior stationary point at
all**: $\nabla\psi=(p_1/u_1,\dots)$ is nowhere zero on $\operatorname{int}\Delta_k$,
and $u=p$ lies on the face $\sum u_i=1$ where the amplitude $(1-\sum u_i)$
*vanishes*. (ii) It asserted the transverse $\sigma$-integral is
"non-oscillatory and contributes to the amplitude, not the phase" — false:
$\partial_\sigma\Phi|_{\sigma=1}=s\ne0$, it is maximally oscillatory, and it
supplies exactly the missing $s^{-2}$ and $e^{-i\pi}$. (iii) It used the
unrestricted $k\times k$ Hessian at a non-critical point, giving $s^{-k/2}$
instead of $s^{-(k-1)/2}$; the $\prod p_i$ matched by coincidence, so the
cancellation conclusion was right *by luck* while the $s$-power could never
close. The final formula was therefore imported from Stirling, not derived.
It is now derived.

**Two exact upgrades the corrected route yields.** Since
$|\Gamma(\tfrac12+i\gamma)|=\sqrt{\pi/\cosh\pi\gamma}$ is *exact*, the modulus is
splitting-blind **exactly**, not merely to leading order:
$$|W_k|=(2\pi)^{\frac{k-1}{2}}s^{-\frac{k+3}{2}}\prod_j\bigl(1+e^{-2\pi\gamma_j}\bigr)^{-1/2}
e^{-d_k/s^2+O(s^{-4})},$$
the $\vec p$-dependence being $\le e^{-2\pi\gamma_{\min}}<10^{-38}$. And the
$O(1/\min\gamma_i)$ phase error is explicit:
$$\arg W_k=-sH_k(\vec p)-\frac{(k+3)\pi}{4}+\frac1{24}\sum_j\frac1{\gamma_j}
+\frac{c_k}{s}+O(\gamma_{\min}^{-3}),\qquad c_2=\tfrac{37}{12},$$
which independently re-derives the $37/12$ of `FRESNEL.md` §2 and locates where
$\vec p$ re-enters (at order $1/s$, via $\tfrac1{24s}\sum p_j^{-1}$). Validity
requires $\gamma_{\min}\to\infty$, not merely $s\to\infty$; and $\gamma_i>0$ for
all $i$ is essential (mixed signs restore $e^{-\frac\pi2(\sum|\gamma_j|-|s|)}$,
and the saddle leaves the simplex).

**What I2 buys, conceptually.** The pair field's phase geometry is a
*thermodynamic formalism*: the simplex is the space of splittings, the
entropy is the rate function, the zeros are the conjugate momenta, and
$\log X$ is the time. Theorem G's Fresnel chirp is then nothing but the
Gaussian (quadratic) fluctuation around the equal-split equilibrium
$p_i=1/k$, and the Cornu diffraction measured in exp17/exp22 is the
transverse fluctuation integral of the same saddle. Every phase-side result
on this branch is one saddle point and its neighbourhood.

**Corollary I2.1 (the $k$-body ladder is forced).** Nothing about $k=2$ was
special: the same saddle gives $H_k$, the $(k+3)\pi/4$ ladder and the
$s^{-(k+3)/2}$ modulus for every $k$, with the same cancellation. The
"hierarchy" measured in exp22 is a theorem about Dirichlet integrals.

---

## 3. The two theorems together: uniqueness vs. conditioning

The program now has the standard shape of an inverse problem, with both
halves proved or bounded:

| question | answer | status |
|---|---|---|
| does the data determine the zeros? | **yes, uniquely, with multiplicity** | Theorem I1 — *classical* (Titchmarsh; Gerth et al.) |
| how stable is the determination? | ill-posed; exponentially so in the height | *classical* (Gorenflo–Hofmann Lemma 6); rate: Theorem K/K0 |
| why do the weights look like that? | one saddle point on the simplex | Theorem I2, proved |

Uniqueness is *free*; conditioning is *everything*. That is the honest
mathematical content of the depth law: the arithmetic contains the entire
zero spectrum exactly (I1), and releases it at a cost exponential in the
height (K). The barrier is not informational but computational — which is
exactly the resource-bounded Chaitin reading of `HOLOGRAM.md` §2, now
resting on a proof rather than on measurements.

## 4. Honesty ledger

- **I1 is classical** (Titchmarsh 1926 / Weiss 1968; Gerth et al. 2014 Thm 4.2;
  weaker than Gorenflo–Hofmann 1994 Thm 1). The corpus's contribution here is
  *zero*; what the search bought is the correct proof (three lines, no growth
  hypothesis), the sharp counterexamples, and the discovery that the
  conditioning half is also known (Gorenflo–Hofmann Lemma 6). Recorded as a
  rediscovery, per protocol. Its ingredients are standard; I have
  not found this statement made for zero multisets, but the argument is
  elementary enough that prior art is likely and should be searched before
  any claim of novelty. The value is not difficulty — it is that it
  *removes an assumption* the corpus had been carrying implicitly.
- **I2's stationary-phase computation is *not* standard here** — that is the
  interesting part. The naive interior application is invalid (no interior
  critical point; the amplitude vanishes on the relevant face), and only the
  exact radial/angular factorization makes the saddle legitimate. The first
  version of this note got the right answer with an invalid derivation. Error terms are the usual
  Laplace-method ones; I have written the leading order, and the
  $O(1/\min\gamma_i)$ correction matches the Stirling computation already in
  `BLOCKS.md` §2 and `FRESNEL.md` §2.
- Neither theorem proves anything new about primes. They make the
  *inverse-problem* statement of the program rigorous and explain its
  phase structure. The conjectural side (correlations, Chowla) is untouched
  and remains where `BARRIER.md` places it.
