# The Buchstab-side ladder: depth mirror of the temperature closed form

Resolves the conjecture of `TENSIONS.md` §3 (the "adjoint delay pair"):
does the depth ladder (fixed $u$, sieve level $y=X^{1/u}$) have an
all-orders closed form mirroring K2 §II's temperature ladder
$D_z(\lambda)=\mathrm{Ein}(\lambda)-\log[\delta\zeta(1+\delta)]$?

**Answer: yes and no, and both halves are now precise.**  In the
*multiplicative (Mellin) window* the depth ladder has a closed form
(Theorem D1 below) that is *stronger* than a zeta-Laurent expansion: the
entire Stieltjes ladder **cancels identically** against the explicit
$\zeta$ factor, leaving the pure special function
$e^{-\gamma}e^{\mathrm{Ein}(\lambda)}/\lambda=1+\widehat\omega(\lambda)$
with only a PNT-scale (exponentially small in $\sqrt{\log y}$) remainder.
In the *interval (archimedean) window* — the mean defect of
`BUCHSTAB_WINDOW.md` §3 — the ladder exists to all orders but is **not**
zeta-Laurent and **cannot** resum to any analytic expression in
$1/\log X$: its coefficients are the derivative jet of Buchstab's
$\omega$, its $u\in(1,2)$ specialization is the factorially divergent
$\mathrm{li}$ series $\sum_k k!/\log^kX$, and its Borel-type resummation
is the de Bruijn integral itself.  The exact second-order constant is

$$\boxed{\;c_1(u)\;=\;-\,\frac{u\,\omega'(u)}{\omega(u)}
\;=\;1-\frac{\omega(u-1)}{\omega(u)}\;}$$

Numerics: `code/exp34_buchladder.py`, `figures/exp34_buchladder.png`.

---

## 1. The two transforms and the exact adjunction

Dickman side (classical; Tenenbaum III.5.4, crossover.md (3.1)): the
Laplace transform of $\rho$ is entire and

$$\widehat\rho(s)=\int_0^\infty\rho(u)e^{-su}\,du
=\exp\bigl[\gamma-\mathrm{Ein}(s)\bigr].\tag{1.1}$$

Buchstab side.  Extend $\omega(u)=0$ for $u<1$; the delay equation
$(u\omega(u))'=\omega(u-1)$ then holds in distributions with an extra
$\delta_{u=1}$ (the jump $\omega(1^+)=1$):
$(u\omega)'=\omega(u-1)+\delta(u-1)$.  Laplace transforming, with
$W(s)=\widehat\omega(s)=\int_1^\infty\omega(u)e^{-su}du$ ($\Re s>0$):
$-sW'(s)=e^{-s}(W(s)+1)$, i.e. $(\log(1+W))'=-e^{-s}/s$, and $W\to0$ as
$s\to+\infty$ gives

$$\boxed{\;1+\widehat\omega(s)=\exp\bigl[E_1(s)\bigr]
=\frac{e^{-\gamma}\,e^{\mathrm{Ein}(s)}}{s}\;}\tag{1.2}$$

($E_1(s)=\int_s^\infty e^{-t}t^{-1}dt=-\gamma-\log s+\mathrm{Ein}(s)$).
Since $\omega(u)-e^{-\gamma}$ decays superexponentially, the right side
of (1.2) is the meromorphic continuation of $1+\widehat\omega$ to all of
$\mathbb C$, with a single simple pole at $s=0$ of residue $e^{-\gamma}$
(for $\lambda<0$, $\widehat\omega$ itself diverges; (1.2) is read through
the entire function $\int_1^\infty(\omega-e^{-\gamma})e^{-su}du$).

Multiplying (1.1) and (1.2):

$$\boxed{\;\widehat\rho(s)\,\bigl(1+\widehat\omega(s)\bigr)=\frac1s\;}
\qquad\Longleftrightarrow\qquad
\rho(u)+\int_1^u\omega(t)\,\rho(u-t)\,dt=1\ \ (u\ge0).\tag{1.3}$$

This is the classical adjoint identity of the delay pair
($u\rho'(u)=-\rho(u-1)$ vs $(u\omega)'=\omega(u-1)$), and §2 shows it is
the microscopic shadow of unique factorization: every $n$ splits uniquely
as ($y$-smooth)$\times$($y$-rough).

## 2. Theorem D1: the depth-side closed form (proved)

Let $\zeta_y(s)=\prod_{p\le y}(1-p^{-s})^{-1}$ (the $y$-smooth zeta:
$\zeta_y(s)=\sum_{P^+(n)\le y}n^{-s}$), so that
$\zeta(s)/\zeta_y(s)=\sum_{P^-(n)>y}n^{-s}$ is the $y$-rough zeta.

> **Theorem D1.** Fix $K>0$.  Uniformly for $|\lambda|\le K$, with
> $s=1+\delta$, $\delta=\lambda/\log y$,
> $$\zeta(s)\prod_{p\le y}\bigl(1-p^{-s}\bigr)
> =\frac{e^{-\gamma}\,e^{\mathrm{Ein}(\lambda)}}{\lambda}
> \Bigl(1+O_K\bigl(e^{-c_K\sqrt{\log y}}\bigr)\Bigr)
> =\bigl(1+\widehat\omega(\lambda)\bigr)
> \bigl(1+O_K(e^{-c_K\sqrt{\log y}})\bigr),$$
> the pole at $\lambda=0$ matching $\zeta$'s pole on the left.
> Equivalently, on the smooth side,
> $\zeta_y(s)=\zeta(s)\,\lambda\,\widehat\rho(\lambda)\,
> (1+O_K(e^{-c_K\sqrt{\log y}}))$.

*Proof.* By K2 §II.2 (proved, cross-reviewed), with
$D_y(\lambda)=\sum_{p\le y}[\log(1-p^{-s})-\log(1-p^{-1})]$:
$D_y=\mathrm{Ein}(\lambda)-\log[\delta\zeta(1+\delta)]
+O_K(e^{-c\sqrt{\log y}})$.  Mertens' third theorem with PNT error gives
$\sum_{p\le y}\log(1-1/p)=-\gamma-\log\log y+O(e^{-c\sqrt{\log y}})$.
Adding $\log\zeta(1+\delta)$:
$$\log\Bigl[\zeta(s)\prod_{p\le y}(1-p^{-s})\Bigr]
=\log\zeta(1+\delta)-\gamma-\log\log y
+\mathrm{Ein}(\lambda)-\log[\delta\zeta(1+\delta)]+O(e^{-c\sqrt{\log y}})$$
$$=\mathrm{Ein}(\lambda)-\log\lambda-\gamma+O(e^{-c\sqrt{\log y}})
=E_1(\lambda)+O(e^{-c\sqrt{\log y}}),$$
since $\log\zeta(1+\delta)-\log[\delta\zeta(1+\delta)]=-\log\delta$
**exactly** — the Laurent jets cancel term by term.  Exponentiate and
apply (1.2). $\square$

Three readings:

1. **The Stieltjes ladder collapses.**  The temperature ladder's
   corrections $\eta_0=-\gamma$, $\eta_1=\gamma^2+2\gamma_1,\dots$ are
   exactly the Laurent jet of the $\zeta$ factor that converts the
   temperature window into the depth window.  The depth (Mellin) closed
   form has *no* $1/\log y$ ladder at all: finite-size corrections are
   PNT-scale.  Verified (`exp34` part A): $|{\rm LHS/RHS}-1|$ falls from
   $3.9\cdot10^{-3}$ ($y=10^4$) to $8.5\cdot10^{-7}$ ($y=10^7$) at
   $\lambda\in\{-1,\tfrac12,1,2\}$ with no $1/\log y$ plateau (a single
   ladder term would sit at $\sim6\cdot10^{-2}$ at $y=10^7$).
2. **$\lambda=0$ endpoint = Mertens.**  $\lambda\,\zeta(1+\delta)\cdots\to
   e^\gamma$-normalization: $\log y\prod_{p\le y}(1-1/p)\to e^{-\gamma}$
   is the zero-temperature/zero-depth point of both ladders.
3. **Adjunction = unique factorization.**  $\zeta=\zeta_y\cdot(\zeta/\zeta_y)$
   read in the microscopic window $s=1+\lambda/\log y$ *is* (1.3):
   $[\lambda\widehat\rho(\lambda)]\cdot[1+\widehat\omega(\lambda)]=1\cdot\lambda/\lambda$.
   Temperature approach reads the smooth factor ($\widehat\rho$,
   crossover Theorem 3); depth approach reads the rough factor
   ($1+\widehat\omega$).  One identity, two windows — this dissolves
   TENSIONS §3.

Prior-art boundary: the *shape* $\zeta_y(s)\approx\zeta(s)(s-1)\log y\,
\widehat\rho((s-1)\log y)$ is the classical smooth-number saddle-point
lemma (Hildebrand–Tenenbaum; Tenenbaum III.5; already flagged as the
shared engine in crossover.md §7 item 6).  What is ours: the PNT-quality
error in the fixed-$\lambda$ window (inherited from K2's
optimal-truncation lemma, either sign of $\lambda$), the rough-side dual
via (1.2), and the ladder-cancellation reading against K2.2.

## 3. The interval ladder: $c_1(u)$ and the $\omega$-jet (the "no" half)

The measured object of `BUCHSTAB_WINDOW.md` §3 is archimedean: with
$y=X^{1/u}$, $W=\prod_{p\le y}p$, $\nu_W(n)=\tfrac W{\varphi(W)}
\mathbf1_{(n,W)=1}$,
$$\frac1X\sum_{n\le X}\nu_W(n)=\frac W{\varphi(W)}\cdot\frac{\Phi(X,y)}X .$$
Mertens contributes only exponentially small corrections; the ladder
lives entirely in $\Phi$.  De Bruijn's smooth model is
$$\Phi_{\rm s}(X,y)=1+\frac1{\log y}\int_y^X\omega\Bigl(\frac{\log t}{\log y}\Bigr)dt
=1+\int_1^u\omega(v)\,y^{v}\,dv,$$
and de Bruijn (1950; Tenenbaum III.6.2, quoted in BUCHSTAB_WINDOW §7)
gives $\Phi=X(\omega(u)/\lambda-\omega'(u)/\lambda^2+o(\lambda^{-2}))$
uniformly near fixed $u>2$, $\lambda=\log y$.

**Exact calculus of the smooth model** (repeated integration by parts;
$\omega^{(k)}$ jumps by $\Delta_j^{(k)}$ at integers $j$, with
$\Delta_j^{(j-1)}=1/j!$ propagating from $\omega(1^+)-\omega(1^-)=1$ via
the delay DE):
$$\Phi_{\rm s}=1+\sum_{k\ge0}(-1)^k\,
\frac{X\,\omega^{(k)}(u)-y\,\omega^{(k)}(1^+)-\sum_{1<j<u}y^{j}\Delta_j^{(k)}}
{\lambda^{k+1}},$$
with $\omega^{(k)}(1^+)=(-1)^kk!$ (left-limit jets at integer $u$).  The
$k=0$ boundary term is the classical $-y/\log y$; all $y^j$ layers are
polynomially small in $X$ at fixed $u$.  Hence the mean defect ladder
$$\frac1X\sum_{n\le X}\nu_W(n)
= e^\gamma\omega(u)\Bigl[1+\frac{c_1(u)}{\log X}+\frac{c_2(u)}{\log^2X}+\cdots\Bigr],
\qquad c_k(u)=\frac{(-u)^k\,\omega^{(k)}(u)}{\omega(u)} ,$$
and by the delay DE $u\omega'=\omega(u-1)-\omega$:

$$c_1(u)=1-\frac{\omega(u-1)}{\omega(u)}
=\begin{cases}1, & 1<u\le 2\quad(\text{the li ladder: rough}=\text{primes}),\\[2pt]
1-\dfrac{u}{(u-1)\bigl(1+\log(u-1)\bigr)}, & 2<u\le3 .\end{cases}$$

$c_1$ is rigorous from the cited second-order de Bruijn expansion +
Mertens; the all-orders form rests additionally on de Bruijn's full
expansion of $\Phi$ (classical; verified numerically below at PNT decay).
Exact values and the next coefficients
($c_2=u^2\omega''/\omega$, via $u\omega''=\omega'(u-1)-2\omega'$):

| $u$ | $c_1(u)$ | $c_2(u)$ (left jet) |
|---|---|---|
| $2$ | $+1$ | $+2$ (li: $c_k=k!$) |
| $2.5$ | $1-\tfrac{2.5}{1.5(1+\log\frac32)}=-0.1858471$ | $-2.348106$ |
| $3$ | $1-\tfrac{3}{2(1+\log2)}=+0.1140758$ | $-1.100735$ |

Structural facts:

- **Not zeta-Laurent — and provably not resummable in $1/\log X$.**  The
  coefficients are rational-log data of the delay DE; no Stieltjes
  constant appears at any order (they hide in the exponentially small
  remainder).  Moreover on $1<u<2$ the ladder is exactly
  $\sum_kk!/\log^kX$: factorially divergent, radius of convergence zero.
  So no analytic-in-$\delta$ closed form (zeta-Laurent or otherwise) can
  represent the depth interval ladder; its resummation *is* the integral
  $\Phi_{\rm s}$ — equivalently, the closed form lives in the conjugate
  Mellin variable, where it is Theorem D1.  Contrast: the temperature
  ladder $-\log[\delta\zeta(1+\delta)]$ is analytic in $\delta$.  This
  asymmetry is forced by (1.1)/(1.2): $\widehat\rho$ is entire, while
  $1+\widehat\omega$ has a pole at $0$ whose full expansion at the pole
  regenerates the divergent li-type series.
- **$c_1$ jumps at $u=2$:** $c_1(2)=+1$ but $c_1(2^+)=-1$ — the same
  $\pm1$ jump as the shape-response coefficient $-u\omega'/\omega$ of
  BUCHSTAB_WINDOW §7 (it *is* the same constant: there it weights the
  normalized shape response, here it is the normalization defect itself).
  The jump is the entrance of the semiprime layer.
- **Boundary layers are numerically live.** At $X=10^8$, $u=2.5$, the
  $y^2$ jump layer $y^2\Delta_2^{(1)}/\lambda^2$ contributes $\sim0.06$
  to $r(X,u)$ below — polynomially small, but comparable to
  $c_2/\log X$.  Finite-$X$ fits that ignore it will misread $c_1$.

## 4. Numerics (`code/exp34_buchladder.py --big`, sieve to $X=10^8$)

Measured $r(X,u)=(\text{mean}/(e^\gamma\omega(u))-1)\log X$.  The
verification factors into the three layers of the proof:

- **(B1) calculus ladder** of $\Phi_{\rm s}$, checked at synthetic
  $\log X\le300$ (all $y^j$ layers dead): three-point Richardson
  intercepts $c_1^{\rm fit}=\{+1.0000110,\,-0.1858681,\,+0.1140695\}$ vs
  exact $\{+1,\,-0.1858471,\,+0.1140758\}$ (errors $1{-}2\cdot10^{-5}$);
  slopes reproduce $c_2$ to $0.5\%$ and $c_3$ to $\sim10\%$.
- **(B2) sieve vs smooth model:** $|\Phi/\Phi_{\rm s}-1|$ decays as a
  power of $X$: measured exponents $0.515$ ($u{=}2$; the prime-layer
  $\mathrm{li}-\pi$, expected $\tfrac12$), $0.169$ ($u{=}2.5$), $0.164$
  ($u{=}3$) (semiprime layer; expected in $[\tfrac1{2u},\tfrac14]$ —
  e.g. $\tfrac1{2u}=0.167$ at $u=3$).  Any positive power beats every
  $1/\log^k$, which is what the ladder claim needs.  Anatomy check
  (2<u≤3): substituting $\mathrm{li}$ for $\pi$ inside the exact
  two-level identity
  $\Phi=1+\pi(X)-\pi(y)+\sum_{y<p\le\sqrt X}(\pi(X/p)-\pi(p)+1)$
  accounts for the bulk of the gap — it is an accumulated
  $\mathrm{li}{-}\pi$ layer over the semiprime stratum, numerically
  $\sim10^{-2}$ relative at $X=10^7$, i.e. *larger* than
  $c_2/\log^2X$ at accessible $X$.  This is why the sieve points in the
  figure approach the model curve slowly: the depth ladder is real but
  sits behind a polynomially-decaying PNT screen at small $X$.
- **(A) Theorem D1** as in §2: errors $10^{-3}\to10^{-6.1}$ over
  $y=10^4\to10^7$, uniformly in $\lambda\in\{-1,\tfrac12,1,2\}$, plus the
  Mertens endpoint at $\lambda=0$ ($-3.9\cdot10^{-5}$ at $y=10^6$).

Oracle (`code/oracle.py`) on the fitted intercepts: no legitimate hit —
correctly so: $c_1(u)$ involves $\log(u-1)$, outside the program's
constant basis (the 4-term PSLQ "matches" at $10^{-14}$ are overfits of a
$10^{-5}$-accurate input; the closed form above matches at the fit's own
precision, $\le2\cdot10^{-5}$).

## 5. The complete finite-size picture (TENSIONS §3 dissolved)

$$\begin{array}{lll}
\text{temperature window} & \log\bigl[\zeta_y\text{-deformation}\bigr]:\ 
D_z=\mathrm{Ein}(\lambda)-\log[\delta\zeta(1+\delta)] & \text{ladder}=\zeta\text{'s Stieltjes jet}\\
\text{depth Mellin window} & \log\bigl[\zeta\cdot\zeta_y^{-1}\text{-truncation}\bigr]
= E_1(\lambda) & \text{ladder}=\text{none (collapses)}\\
\text{depth interval window} & \tfrac1X\sum\nu_W = e^\gamma\omega(u)\bigl[1+\sum c_k/\log^kX\bigr] & \text{ladder}=\omega\text{-jet (divergent)}
\end{array}$$

The three are one structure: the second is the first plus
$\log\zeta(1+\delta)$ (exact cancellation); the third is the second
pushed through a sharp Perron cutoff, which trades the collapsed ladder
for the derivative jet of the inverse transform of $1+\widehat\omega$.
Dickman and Buchstab enter as the two factors of
$\zeta=\zeta_y\cdot(\zeta/\zeta_y)$ — the adjunction (1.3) — so the
"two finite-size layers" of TENSIONS §3 are the two readings of a single
identity, as conjectured; but the conjectured "$\omega$-analog of the
zeta-Laurent ladder" is refuted in the precise sense of §3: on the depth
side the Stieltjes constants cancel, and what replaces them is delay-DE
data.

## 6. Rigor boundary

Proved here / by citation: (1.2) and (1.3) (classical; short derivations
above); Theorem D1 (from K2.2 + Mertens — both proved in-corpus, K2.2
cross-reviewed); the exact IBP expansion of $\Phi_{\rm s}$ (calculus);
$c_1(u)$ (via de Bruijn's cited second-order expansion); divergence of
the interval ladder (its $(1,2)$ specialization is the li series).
Cited, not re-proved: de Bruijn's full expansion $\Phi\sim\Phi_{\rm s}$
beyond second order (verified numerically at power-of-$X$ decay).  Open:
an in-corpus proof of $\Phi=\Phi_{\rm s}+O_u(Xe^{-c\sqrt{\log X}})$ via
Perron on Theorem D1 — the natural next microscopic-lemma target; and the
$u>3$ jets (mechanical from the delay DE).

## References

- N. G. de Bruijn, *On the number of uncancelled elements in the sieve of
  Eratosthenes*, Proc. KNAW **53** (1950), 803–812.
- G. Tenenbaum, *Introduction to Analytic and Probabilistic Number
  Theory*, GSM 163, III.5.4 (Dickman transform), III.6.2 ($\Phi(x,y)$,
  Buchstab $\omega$, the adjoint pair).
- J. Lagarias, *Euler's constant: Euler's work and modern developments*,
  arXiv:1303.1856, §3.1.
- In-corpus: `notes/K2.md` §II (temperature ladder, K2.1/K2.2);
  `notes/BUCHSTAB_WINDOW.md` §3, §7; `papers/crossover.md` §3, §5, §7.
