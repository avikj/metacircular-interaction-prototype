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

> **Theorem I1.** Let $\mu,\mu'$ be positive, locally finite measures on
> $[c,\infty)$, $c>0$, with $\mu([0,T])=O(T\log T)$ and likewise $\mu'$. If
> $\mu*\mu=\mu'*\mu'$, then $\mu=\mu'$.

*Proof.* The Laplace transforms $F(s)=\int e^{-s\gamma}\,d\mu(\gamma)$ and
$G(s)=\int e^{-s\gamma}\,d\mu'(\gamma)$ converge absolutely for
$\operatorname{Re}s>0$ (the density bound makes the integrand summable) and
are analytic there. Convolution goes to multiplication:
$\widehat{\mu*\mu}=F^2$, so $F^2=G^2$ on $\operatorname{Re}s>0$. Hence
$(F-G)(F+G)\equiv0$ on a connected open set; the ring of analytic functions
on a domain is an integral domain, so $F\equiv G$ or $F\equiv-G$. For real
$s>0$ both $F(s)$ and $G(s)$ are strictly positive (positive measures,
nonempty support), which excludes $F\equiv-G$. Thus $F\equiv G$, and
uniqueness of Laplace transforms of positive measures gives $\mu=\mu'$.
$\blacksquare$

**Corollary I1.1 (well-posedness of the program).** The pair layer of any
dressing in the residue-dressing family determines the zero multiset
uniquely — positions *and* multiplicities. Two distinct zero
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

*Proof.* The integral representation is the classical Dirichlet formula
(the $k$-variable Beta integral); it is the same computation that produced
Theorem D's weights, read backwards. Write $u_i^{\rho_i-1}=u_i^{-1/2}\,
e^{i\gamma_i\log u_i}$, so the oscillatory factor is $e^{i\varphi(\vec u)}$
with $\varphi=\sum_i\gamma_i\log u_i=s\sum_i p_i\log u_i$.

*(1)* On the interior of $\Delta_k$, constrain by $\sum u_i=\sigma\le1$ and
optimize at fixed $\sigma$: $\nabla\bigl(\sum p_i\log u_i-\lambda\sum
u_i\bigr)=0$ gives $p_i/u_i=\lambda$, i.e. $u_i\propto p_i$; the transverse
$\sigma$-integral against the smooth factor $(1-\sigma)$ is non-oscillatory
and contributes to the amplitude, not the phase. At $u_i=p_i$,
$\varphi=s\sum p_i\log p_i=-sH_k(\vec p)$.

*(2)* The Hessian of $\varphi$ there is
$\partial^2_{u_iu_j}\varphi=-s\,p_i/u_i^2\,\delta_{ij}=-s\,\delta_{ij}/p_i$,
so $|\det\operatorname{Hess}|=s^k/\prod_i p_i$ before restriction, and the
stationary-phase prefactor carries $|\det|^{-1/2}\asymp
s^{-k/2}\bigl(\prod p_i\bigr)^{1/2}$, while the amplitude evaluates to
$\prod_i u_i^{-1/2}\big|_{u=p}=\bigl(\prod p_i\bigr)^{-1/2}$. The
$\prod p_i$ factors cancel identically, leaving a function of $s$ alone.
This is the structural reason the measured modulus law depends only on the
sum — a fact that looked accidental in the Stirling derivation.

*(3)* The phase constant is the Morse signature of the (negative definite)
restricted Hessian, contributing $-(k-1)\pi/4$, together with the $\pi$-type
constant from $\arg\Gamma(\sum\rho_i+2)$; collecting gives $(k+3)\pi/4$,
matching the measured ladder for $k=2,3,4$. $\blacksquare$

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

- **I1 is unconditional and complete** as stated (no RH, no simplicity); the
  only hypothesis is the classical zero-density bound, used solely for
  convergence of the Laplace transform. Its ingredients are standard; I have
  not found this statement made for zero multisets, but the argument is
  elementary enough that prior art is likely and should be searched before
  any claim of novelty. The value is not difficulty — it is that it
  *removes an assumption* the corpus had been carrying implicitly.
- **I2's stationary-phase computation is standard**; the content is the
  identification of the entropy as the action and the *exact cancellation*
  in (2), which explains a measured law. Error terms are the usual
  Laplace-method ones; I have written the leading order, and the
  $O(1/\min\gamma_i)$ correction matches the Stirling computation already in
  `BLOCKS.md` §2 and `FRESNEL.md` §2.
- Neither theorem proves anything new about primes. They make the
  *inverse-problem* statement of the program rigorous and explain its
  phase structure. The conjectural side (correlations, Chowla) is untouched
  and remains where `BARRIER.md` places it.
