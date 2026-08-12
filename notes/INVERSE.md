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

> **Theorem I1′ (sharpest form; corrected after audit).** Let $\mu,\mu'$ be
> positive Borel measures on $[0,\infty)$ with $\mu*\mu=\mu'*\mu'=:\sigma$.
> Suppose $\int e^{-\lambda t}d\sigma(t)<\infty$ for some $\lambda>0$. Then
> $\mu=\mu'$.

*Proof.* Tonelli: $\int e^{-\lambda t}d\sigma=F(\lambda)^2=G(\lambda)^2$, so
both Laplace transforms are finite (hence both measures locally finite). For
real $u\ge\lambda$, $F(u),G(u)\in[0,\infty)$ and $F(u)^2=G(u)^2$, so **$F=G$
pointwise** on $[\lambda,\infty)$. Tilt: $dm=e^{-\lambda\gamma}d\mu$,
$dm'=e^{-\lambda\gamma}d\mu'$ are finite; pushing forward under
$x=e^{-\gamma}\in(0,1]$ converts $\int e^{-u\gamma}dm=\int e^{-u\gamma}dm'$
($u\ge0$) into equality of all moments on $[0,1]$, and Weierstrass gives
$m=m'$, hence $\mu=\mu'$. $\blacksquare$

**Corrections to the first version** (all from adversarial re-derivation):

- The earlier proof asserted that positivity "excludes $F\equiv-G$". **False**:
  if $F=-G$ then $F\le0$ and $F\ge0$, so the branch *degenerates* to
  $F\equiv G\equiv0$ rather than being excluded — and $\mu=0$ was admitted by
  the hypotheses. The theorem survives (the degenerate branch still gives
  $\mu=\mu'$), but the sentence was wrong.
- The whole integral-domain / identity-theorem apparatus is **superfluous**.
  Nonnegativity on the real axis gives $F=G$ pointwise; no complex analysis is
  needed anywhere.
- Hypotheses were over-strong: "and likewise $\mu'$" is implied
  ($\mu'([0,T])^2\le\sigma([0,2T])\le\mu([0,2T])^2$), $c>0$ is unnecessary
  (only support in $[0,\infty)$ is used), and $O(T\log T)$ is enormously
  stronger than required — any $O(e^{\lambda T})$ works. The natural hypothesis
  is on the **data** $\sigma$, not on the unknowns.

**What is actually load-bearing — not positivity, one-sidedness.** The earlier
write-up attributed the rigidity to the integral-domain step. It does not live
there. Positivity alone is insufficient: on $\mathbb T=\mathbb R/\mathbb Z$,
$d\mu=(1+2a\cos2\pi x)dx$ and $d\mu'=(1-2a\cos2\pi x)dx$ ($0<a\le\tfrac12$) are
both positive, distinct, and satisfy $\hat\mu(n)^2=\hat\mu'(n)^2$ for all $n$,
hence $\mu*\mu=\mu'*\mu'$. **Convolution square roots of positive measures are
not unique in general.** I1′ is a theorem about the half-line — the order
structure, not the sign — which is the correct moral and sharpens the
comparison with Theorem A: there too the ordering of the support does the work.

**Corollary I1.1 (well-posedness of the program).** *Caveat added after audit:*
I1′ recovers $\mu$ from the **ordered** pair multiset $\{\gamma_i+\gamma_j\}_{i,j}$
including the diagonal $i=j$. If the observed pair layer is instead the
unordered off-diagonal multiset $\{\gamma_i+\gamma_j\}_{i<j}
=\tfrac12(\mu*\mu-D_\#\mu)$, that is a different functional equation and I1′
does not discharge it directly — it must be proved separately or the diagonal
identified independently. Subject to that, the pair layer of any dressing in
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
> and its large-$s$ asymptotics is the stationary-phase (WKB) evaluation of
> that integral, in which:
> 1. the **phase is the action** $\varphi(\vec u)=s\sum_i p_i\log u_i$, whose
>    unique stationary point on $\Delta_k$ is $u_i=p_i$ with stationary value
>    $-s\,H_k(\vec p)$ — the entropy is the classical action of the
>    constraint geometry;
> 2. the **modulus is splitting-blind** because the half-density amplitude
>    $\prod_i u_i^{-1/2}$ and the Hessian determinant cancel exactly at the
>    stationary point;
> 3. the **Maslov constant** $(k+3)\pi/4$ is the signature of that Hessian
>    plus the $\Gamma(\sum\rho_i+2)$ boundary contribution.

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
| does the data determine the zeros? | **yes, uniquely, with multiplicity** | Theorem I1, proved unconditionally |
| how stable is the determination? | exponentially ill-conditioned in the height | Theorem K/K0, superresolution bounds |
| why do the weights look like that? | one saddle point on the simplex | Theorem I2, proved |

Uniqueness is *free*; conditioning is *everything*. That is the honest
mathematical content of the depth law: the arithmetic contains the entire
zero spectrum exactly (I1), and releases it at a cost exponential in the
height (K). The barrier is not informational but computational — which is
exactly the resource-bounded Chaitin reading of `HOLOGRAM.md` §2, now
resting on a proof rather than on measurements.

## 4. Honesty ledger

- **I1′ is unconditional**; the density bound is *not needed* and the $\mu'$
  hypothesis is redundant. The rigidity comes from one-sidedness, not
  positivity (circle counterexample above). Its ingredients are standard; I have
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
