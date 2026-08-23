# Theorem E2b proved: blockwise asymptotics by real-variable convolution

Discharges the residual obligation of `notes/METHOD.md` §3 item 3 — the
one gap `notes/E2_PROOF.md` left open in its Part 1, ledger row **G3**:

> *"Contour-shift/growth estimates converting E2a's pole data into E2b's
> asymptotics with the stated errors — **Not reproduced.** Cited as
> Languasco–Zaccagnini applied blockwise; the transfer is believed but not
> checked in detail. The one genuine piece of unwritten work here."*

That transfer is no longer load-bearing. This note proves Theorem E2b's
three block asymptotics **directly**, by an elementary real-variable
route: an exact convolution identity per block, the truncated von Mangoldt
explicit formula in each flat factor, exact reflection-formula moduli for
the $\Gamma$-weights, and Riemann–von Mangoldt counting for the zero-pair
tails. No contour is shifted; no growth estimate on $\zeta'/\zeta$ along
horizontal segments is needed; the errors come out *sharper* than E2b's
stated $X^{\varepsilon}$'s (explicit powers of $\log X$). As a by-product,
E2a's residue table — signs, the factor $2$, the weights
$\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$ — is confirmed by an
independent derivation, and E2_PROOF's ledger G4 (coincident poles)
becomes moot for E2b: the asymptotic is an absolutely convergent sum over
*zero pairs*, so no grouping of coincident frequencies is ever performed.

**What measured/heuristic claim this replaces.** The asymptotic content of
exp11's block spectral measurement ("corr 1.0000") was converted by
`E2_PROOF.md` into the unconditional support theorem E2a plus an
asymptotic statement E2b whose proof was *cited, not written*. This note
writes it. Nothing numerical remains load-bearing anywhere in the E2
chain; there are **no numerics in this note**.

Sibling queue note: item 1's residual (uniformity in $L$ of the
$\mathrm{Smooth}/E$ terms of Theorem B1, `BARRIER_UNIFORM.md` ledger U5)
is a separate lane and is not touched here.

---

## 1. Setup

Fix $Q\ge1$ for the whole note. As in `E2_PROOF.md` §1.0:
$$\Lambda^\sharp(n)=\Lambda^\sharp_Q(n)=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(n),
\qquad \Lambda^\flat=\Lambda-\Lambda^\sharp,\qquad P_Q=\prod_{p\le Q}p,$$
with partial sums
$$\psi^\sharp(t)=\sum_{n\le t}\Lambda^\sharp(n),\qquad
\psi^\flat(t)=\sum_{n\le t}\Lambda^\flat(n)=\psi(t)-\psi^\sharp(t).$$
The blocks of $G_1(X)=\sum_{m,n\ge1}\Lambda(m)\Lambda(n)(X-m-n)_+$ are
$$[\alpha\beta](X)=\sum_{m,n\ge1}\Lambda^\alpha(m)\Lambda^\beta(n)(X-m-n)_+,
\qquad \alpha,\beta\in\{\sharp,\flat\},$$
an exact bilinear decomposition. $\rho=\beta_\rho+i\gamma$ runs over
nontrivial zeros of $\zeta$ **with multiplicity** (so a zero of
multiplicity $m_\rho$ appears $m_\rho$ times in every sum; this is the
convention of the explicit formula, and it is what makes E2a's residues
$-2m_\rho/(\rho(\rho+1)(\rho+2))$ and $m_\rho m_{\rho'}W(\rho,\rho')$ come
out automatically below). RH ($\beta_\rho=\tfrac12$) is assumed exactly
where E2b assumed it: in §4–§5. §§2–3.1 are unconditional.

> **Theorem (E2b, now proved).** Fix $Q\ge1$, assume RH. For $X\ge3$,
> with $W(\rho,\rho')=\dfrac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}$:
> $$\boxed{\begin{aligned}
> [\sharp\sharp](X)&=\frac{X^3}{6}+O_Q\!\left(X^2\right),\\
> [\sharp\flat](X)+[\flat\sharp](X)&=-2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}+O_Q\!\left(X^2\log^2X\right),\\
> [\flat\flat](X)&=\sum_{\rho,\rho'}W(\rho,\rho')\,X^{\rho+\rho'+1}+O_Q\!\left(X^{3/2}\log^4X\right),
> \end{aligned}}$$
> both zero sums being absolutely convergent (Lemmas C4(iii), C6). This is
> `E2_PROOF.md` Theorem E2b with each $O(X^{2+\varepsilon})$,
> $O(X^{3/2+\varepsilon})$ sharpened to an explicit power of $\log$.

---

## 2. The convolution identity

**Lemma C1.** Let $f,g$ be arithmetic functions supported on
$\{1,2,\dots\}$, with partial sums $F(t)=\sum_{n\le t}f(n)$,
$G(t)=\sum_{n\le t}g(n)$. Then for every $X\ge0$,
$$\sum_{m,n\ge1}f(m)\,g(n)\,(X-m-n)_+\;=\;\int_0^X F(u)\,G(X-u)\,du .$$

*Proof.* All sums are finite ($m,n\le X$). Expand the right side:
$$\int_0^X\Bigl(\sum_m f(m)\mathbf 1[m\le u]\Bigr)\Bigl(\sum_n g(n)\mathbf 1[n\le X-u]\Bigr)du
=\sum_{m,n}f(m)g(n)\,\operatorname{meas}\{u\in[0,X]:\,m\le u\le X-n\},$$
by Fubini for finite sums; the measure of the interval $[m,X-n]$ is
$(X-m-n)_+$. $\square$

Substituting $u\mapsto X-u$ shows the right side is symmetric in $(F,G)$;
hence
$$[\sharp\flat]+[\flat\sharp]=2\int_0^X\psi^\sharp(u)\,\psi^\flat(X-u)\,du,\qquad
[\flat\flat]=\int_0^X\psi^\flat(u)\,\psi^\flat(X-u)\,du,\qquad
[\sharp\sharp]=\int_0^X\psi^\sharp(u)\,\psi^\sharp(X-u)\,du.$$

*Corpus prior art:* the $[\flat\flat]$ case appears in
`LENS_REGULARITY.md` Prop. 6 (proved there by Riemann–Stieltjes parts and
used only with crude discrepancy bounds); the identity in this symmetric
form, and its use to extract main terms, are what is added here.

## 3. The two partial-sum laws

### 3.1 The sharp factor is linear, exactly, at every $Q$ — unconditional

**Lemma C2.** For all $t\ge0$,
$$\psi^\sharp(t)=t+E^\sharp(t),\qquad
|E^\sharp(t)|\le C_Q:=\max_{0\le r<P_Q}\Bigl|\sum_{a\le r}\Lambda^\sharp(a)-r\Bigr|<\infty .$$

*Proof.* $\Lambda^\sharp$ is $P_Q$-periodic (each $c_q$ with $q\le Q$
squarefree is $q$-periodic and $q\mid P_Q$), and its mean over a period is
exactly $1$ for every $Q$ (`E2_PROOF.md` Lemma 1(i):
$\sum_{a\bmod q}c_q(a)=q\,\mathbf 1_{q=1}$, so only $q=1$ contributes to
the mean). Write $t=kP_Q+r$, $k\in\mathbb Z_{\ge0}$, $0\le r<P_Q$; then
$$\psi^\sharp(t)=k\sum_{a=1}^{P_Q}\Lambda^\sharp(a)+\sum_{a\le r}\Lambda^\sharp(a)
=kP_Q+r+\Bigl(\sum_{a\le r}\Lambda^\sharp(a)-r\Bigr)=t+E^\sharp(t). \qquad\square$$

$C_Q$ is a finite constant depending only on $Q$ (crudely
$C_Q\le P_Q(1+\max_a|\Lambda^\sharp(a)|)$). No uniformity in $Q$ is
claimed or needed — E2b is a fixed-$Q$ statement (`E2_PROOF.md` G7).

### 3.2 The flat factor is a truncated zero sum plus $O_Q(\log^2X)$

**Import (truncated explicit formula; Davenport §17).** For $x\ge2$,
$T\ge2$,
$$\psi_0(x)=x-\sum_{|\gamma|\le T}\frac{x^\rho}{\rho}-\log2\pi-\tfrac12\log(1-x^{-2})+R(x,T),$$
$$|R(x,T)|\ \ll\ \frac{x}{T}\log^2(xT)+(\log x)\min\Bigl(1,\frac{x}{T\langle x\rangle}\Bigr),$$
with $\langle x\rangle$ the distance from $x$ to the nearest prime power
and $\psi_0$ the jump-midpoint normalization, so $|\psi-\psi_0|\le\tfrac12\Lambda(x)\le\tfrac12\log x$
pointwise. The implied constant is absolute. (Standard; **imported, not
re-proved** — ledger row L3.)

**Import (Riemann–von Mangoldt).**
$N(T)=\frac{T}{2\pi}\log\frac{T}{2\pi}-\frac{T}{2\pi}+O(\log T)$, whence

**Lemma C4.** Unconditionally: (i) $N(t+1)-N(t)\ll\log(2+t)$;
(ii) $\sum_{0<\gamma\le T}\gamma^{-1}\ll\log^2T$ for $T\ge2$;
(iii) $\sum_{\gamma>T}\gamma^{-3}\ll T^{-2}\log(2T)$ for $T\ge2$, and in
particular $\sum_\rho|\rho(\rho+1)(\rho+2)|^{-1}\le2\sum_{\gamma>0}\gamma^{-3}<\infty$
(using $|\rho|,|\rho+1|,|\rho+2|\ge|\gamma|$).

*Proof.* (i) is the difference of $N$ at neighbouring arguments. (ii),
(iii) are partial summation against $dN$:
$\sum_{0<\gamma\le T}\gamma^{-1}=N(T)T^{-1}+\int_{\gamma_1}^{T}N(t)t^{-2}dt
\ll\log T+\int_2^T\frac{\log t}{t}dt\ll\log^2T$, and
$\sum_{\gamma>T}\gamma^{-3}=-N(T)T^{-3}+3\int_T^\infty N(t)t^{-4}dt
\ll\int_T^\infty t^{-3}\log t\,dt\ll T^{-2}\log(2T)$. $\square$

**Lemma C3 (flat partial sums, truncation at $T=X$; RH used only for the
corollary).** Let $X\ge3$ and set
$$S(u):=\sum_{|\gamma|\le X}\frac{u^\rho}{\rho}\qquad(0\le u\le X).$$
Then
$$\psi^\flat(u)=-S(u)+r(u),\qquad |r(u)|\ \ll_Q\ \log^2X
\quad\text{uniformly for }0\le u\le X.$$
Under RH, moreover $|S(u)|\le u^{1/2}\sum_{|\gamma|\le X}|\rho|^{-1}\ll u^{1/2}\log^2X$,
hence $|\psi^\flat(u)|\ll_Q(1+u^{1/2})\log^2X$ on $[0,X]$.

*Proof.* For $2\le u\le X$, apply the import with $x=u$, $T=X$:
$$\psi^\flat(u)=\psi(u)-\psi^\sharp(u)
=\bigl(\psi(u)-\psi_0(u)\bigr)+\psi_0(u)-u-E^\sharp(u)
=-S(u)+r(u),$$
$$r(u)=\bigl(\psi-\psi_0\bigr)(u)-\log2\pi-\tfrac12\log(1-u^{-2})+R(u,X)-E^\sharp(u).$$
Each piece is $\ll_Q\log^2X$: $|\psi-\psi_0|\le\tfrac12\log u\le\tfrac12\log X$;
the two elementary terms are $O(1)$; $|R(u,X)|\ll\frac uX\log^2(uX)+\log u\cdot1\ll\log^2X$
(the $\min(1,\cdot)$ factor is simply bounded by $1$ — at truncation
height $T=X$ the prime-power spikes never need finer treatment); and
$|E^\sharp|\le C_Q$. For $0\le u<2$: $\psi(u)=0$, so
$\psi^\flat(u)=-\psi^\sharp(u)=O_Q(1)$; and under RH
$|S(u)|\le u^{1/2}\sum_{|\gamma|\le X}|\rho|^{-1}$ with $u^{1/2}\le\sqrt2$
and, by C4(ii) and $|\rho|\ge|\gamma|$,
$\sum_{|\gamma|\le X}|\rho|^{-1}\le2\sum_{0<\gamma\le X}\gamma^{-1}\ll\log^2X$;
hence $r=\psi^\flat+S\ll_Q\log^2X$ on $[0,2)$ as well. Note the
$\sum|\rho|^{-1}$ bound is unconditional; RH enters only through
$|u^\rho|=u^{1/2}$, here and in the displayed corollary. $\square$

## 4. The $\Gamma$-weights: exact moduli and pair tails (RH)

Under RH write $\rho=\tfrac12+i\gamma$, $\rho'=\tfrac12+i\gamma'$.

**Lemma C5 (exact modulus bound).** For all real $\gamma,\gamma'$, with
$t=\gamma+\gamma'$,
$$\bigl|W(\rho,\rho')\bigr|=\frac{|\Gamma(\tfrac12+i\gamma)||\Gamma(\tfrac12+i\gamma')|}{|\Gamma(3+it)|}
\ \le\ 2\pi\,e^{-\frac{\pi}{2}\left(|\gamma|+|\gamma'|-|t|\right)}\,\max(1,|t|)^{-5/2}.$$
The exponent is $0$ when $\gamma,\gamma'$ have the same sign and equals
$-\pi\min(|\gamma|,|\gamma'|)$ when they have opposite signs.

*Proof.* Reflection formulas give the exact moduli
$$|\Gamma(\tfrac12+i\gamma)|^2=\frac{\pi}{\cosh\pi\gamma},\qquad
|\Gamma(it)|^2=\frac{\pi}{t\sinh\pi t},$$
and $\Gamma(3+it)=(2+it)(1+it)(it)\Gamma(it)$ yields the closed form
$$|\Gamma(3+it)|^2=\frac{\pi\,t\,(4+t^2)(1+t^2)}{\sinh\pi t}\qquad(t\ne0),$$
which extends continuously to $\Gamma(3)^2=4$ at $t=0$. Numerator bound:
$\cosh\pi\gamma\ge\tfrac12e^{\pi|\gamma|}$, so
$|\Gamma(\tfrac12+i\gamma)|\le\sqrt{2\pi}\,e^{-\pi|\gamma|/2}$; the
product of the two numerator factors is $\le2\pi e^{-\pi(|\gamma|+|\gamma'|)/2}$.
Denominator bound: for $|t|\ge1$, $\sinh\pi|t|\le\tfrac12e^{\pi|t|}$ and
$|t|(4+t^2)(1+t^2)\ge|t|^5$ give $|\Gamma(3+it)|\ge\sqrt{2\pi}\,|t|^{5/2}e^{-\pi|t|/2}\ge|t|^{5/2}e^{-\pi|t|/2}$;
for $|t|\le1$, $(4+t^2)(1+t^2)\ge4$ and the monotone decrease of
$x/\sinh x$ give $|\Gamma(3+it)|^2\ge4\pi/\sinh\pi>1$, so
$|\Gamma(3+it)|\ge1\ge e^{-\pi|t|/2}$. In both ranges
$|\Gamma(3+it)|\ge\max(1,|t|)^{5/2}e^{-\pi|t|/2}$. Divide. Finally
$|\gamma|+|\gamma'|-|\gamma+\gamma'|$ is $0$ for equal signs and
$2\min(|\gamma|,|\gamma'|)$ for opposite signs. $\square$

**Lemma C6 (pair tails).** Assume RH. For $T\ge2$,
$$\sum_{\substack{(\rho,\rho')\\ \max(|\gamma|,|\gamma'|)>T}}|W(\rho,\rho')|
\ \ll\ T^{-1/2}\log^2T .$$
In particular (taking any fixed $T$) $\sum_{\rho,\rho'}|W|<\infty$.

*Proof.* Split by signs; by the symmetry $W(\bar\rho,\bar\rho')=\overline{W(\rho,\rho')}$
it suffices to treat $\gamma,\gamma'>0$ (same sign) and
$\gamma>0>\gamma'$ (mixed, then double).

*Same sign.* Here $|W|\le2\pi\,\max(1,s)^{-5/2}$ with $s=\gamma+\gamma'$,
and $\max(|\gamma|,|\gamma'|)>T$ forces $s>T$. The number of ordered
pairs with $s\in[n,n+1)$ is at most
$\sum_{0<\gamma<n+1}\#\{\gamma'\in[n-\gamma,\,n+1-\gamma)\}\ll N(n+1)\log(2+n)\ll n\log^2 n$
by C4(i). Hence the same-sign tail is
$\ll\sum_{n\ge T-1}n\log^2n\cdot n^{-5/2}\ll T^{-1/2}\log^2T$.

*Mixed sign.* Write $\gamma'=-\delta$, $\delta>0$; then
$|W|\le2\pi e^{-\pi\min(\gamma,\delta)}\max(1,|\gamma-\delta|)^{-5/2}$.
By symmetry assume $\gamma=\max(\gamma,\delta)>T$ and sum over $\delta$:

- $\delta\le\gamma/2$: then $\min=\delta$ and $|\gamma-\delta|\ge\gamma/2$.
  $\sum_{\delta}e^{-\pi\delta}$ converges to an absolute constant (C4(i)
  against the exponential; the least ordinate exceeds $14$), so these
  terms contribute $\ll\sum_{\gamma>T}(\gamma/2)^{-5/2}\log\gamma\ll T^{-3/2}\log T$
  after C4(i) on $\gamma$.
- $\gamma/2<\delta\le2\gamma$: then $\min\ge\gamma/2$; there are
  $\ll\gamma\log\gamma$ such $\delta$, each term
  $\le2\pi e^{-\pi\gamma/2}$, total
  $\ll\sum_{\gamma>T}\gamma\log^2\gamma\,e^{-\pi\gamma/2}\ll e^{-T}$.
- $\delta>2\gamma$: then $\min=\gamma$ and $|\gamma-\delta|\ge\delta/2$,
  giving $\ll\sum_{\gamma>T}e^{-\pi\gamma}\log\gamma\sum_{\delta>2\gamma}(\delta/2)^{-5/2}\log\delta\ll e^{-T}$.

All mixed contributions are $\ll T^{-3/2}\log T$. Total:
$\ll T^{-1/2}\log^2T$. $\square$

**Lemma C7 (Beta integrals).** For $\Re a,\Re b>0$:
$\int_0^X u^{a-1}(X-u)^{b-1}du=\frac{\Gamma(a)\Gamma(b)}{\Gamma(a+b)}X^{a+b-1}$.
In particular, for a nontrivial zero $\rho$ (so $\Re\rho>0$):
$$\frac1\rho\int_0^X v^{\rho}(X-v)\,dv=\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)},
\qquad
\frac1{\rho\rho'}\int_0^X u^{\rho}(X-u)^{\rho'}du=\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}\,X^{\rho+\rho'+1},$$
using $\Gamma(a+1)=a\Gamma(a)$ twice in the second identity. (Standard;
one-line proof by scaling $u=Xv$ and the Euler Beta integral.) $\square$

## 5. Proof of the Theorem

Throughout, $X\ge3$, $T=X$, $S$ and $r$ as in Lemma C3, and all implied
constants depend on $Q$ alone.

### 5.1 $[\sharp\sharp]$

By C1 and C2,
$$[\sharp\sharp]=\int_0^X\bigl(u+E^\sharp(u)\bigr)\bigl(X-u+E^\sharp(X-u)\bigr)du
=\int_0^Xu(X-u)\,du+O\bigl(C_QX^2+C_Q^2X\bigr)
=\frac{X^3}{6}+O_Q(X^2). \qquad\square$$

### 5.2 $[\sharp\flat]+[\flat\sharp]$

By C1 (symmetric form) and C2, substituting $v=X-u$ in the main piece:
$$[\sharp\flat]+[\flat\sharp]
=2\int_0^X\psi^\sharp(u)\,\psi^\flat(X-u)\,du
=2\int_0^X(X-v)\,\psi^\flat(v)\,dv+2\int_0^XE^\sharp(X-v)\,\psi^\flat(v)\,dv.$$
The second integral is, by C3's corollary,
$\ll C_Q\int_0^X(1+v^{1/2})\log^2X\,dv\ll X^{3/2}\log^2X$. In the first,
insert $\psi^\flat=-S+r$:
$$2\int_0^X(X-v)\,r(v)\,dv\ \ll\ \log^2X\cdot X^2,$$
and, termwise over the **finite** sum $S$ (no interchange issue), by C7:
$$-2\sum_{|\gamma|\le X}\frac1\rho\int_0^X(X-v)v^\rho\,dv
=-2\sum_{|\gamma|\le X}\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}.$$
Complete the sum: under RH $|X^{\rho+2}|=X^{5/2}$, so by C4(iii) the tail
is
$$2\Bigl|\sum_{|\gamma|>X}\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}\Bigr|
\le2X^{5/2}\sum_{|\gamma|>X}|\gamma|^{-3}\ll X^{5/2}\cdot X^{-2}\log X=X^{1/2}\log X,$$
and the completed sum converges absolutely (C4(iii)). Collecting:
$$[\sharp\flat]+[\flat\sharp]
=-2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}+O_Q\bigl(X^2\log^2X\bigr). \qquad\square$$

### 5.3 $[\flat\flat]$

By C1, $[\flat\flat]=\int_0^X\psi^\flat(u)\psi^\flat(X-u)\,du$; insert
$\psi^\flat=-S+r$ in **both** factors:
$$[\flat\flat]=\int_0^XS(u)S(X-u)\,du
\;-\;\int_0^XS(u)r(X-u)\,du-\int_0^Xr(u)S(X-u)\,du
\;+\;\int_0^Xr(u)r(X-u)\,du .$$

**Main term.** $S$ is a finite sum, so termwise integration is licensed by
linearity, and C7 gives
$$\int_0^XS(u)S(X-u)\,du
=\sum_{|\gamma|,|\gamma'|\le X}\frac1{\rho\rho'}\int_0^Xu^{\rho}(X-u)^{\rho'}du
=\sum_{|\gamma|,|\gamma'|\le X}W(\rho,\rho')\,X^{\rho+\rho'+1}.$$
Under RH $|X^{\rho+\rho'+1}|=X^2$, so completing the double sum costs, by
Lemma C6 with $T=X$,
$$X^2\sum_{\max(|\gamma|,|\gamma'|)>X}|W(\rho,\rho')|\ \ll\ X^2\cdot X^{-1/2}\log^2X=X^{3/2}\log^2X,$$
and the completed double sum converges absolutely (C6).

**Cross terms.** By C3, $|S(u)|\ll u^{1/2}\log^2X$ and $|r|\ll\log^2X$,
so each cross integral is
$\ll\log^2X\cdot\log^2X\int_0^Xu^{1/2}du\ll X^{3/2}\log^4X$.

**Remainder.** $\int_0^X|r(u)||r(X-u)|du\ll X\log^4X$.

Collecting:
$$[\flat\flat]=\sum_{\rho,\rho'}W(\rho,\rho')\,X^{\rho+\rho'+1}
+O_Q\bigl(X^{3/2}\log^4X\bigr). \qquad\blacksquare$$

## 6. Consistency, and what this settles

1. **Theorem D recovered with a written proof.** Adding the three blocks
   (the decomposition is exact) gives, under RH,
   $$G_1(X)=\frac{X^3}{6}-2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}
   +\sum_{\rho,\rho'}\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}
   +O\bigl(X^2\log^2X\bigr),$$
   i.e. `REPORT.md` Theorem D (Languasco–Zaccagnini $k=1$), whose corpus
   status was "rederived" with the derivation compressed to one sentence.
   The $k=0$ analogue is Fujii's formula (`SCREW.md` (1.2)). Note
   `REPORT.md` prints the error as $O(X^2)$ "smooth deterministic terms";
   what is *proved* here is $O_Q(X^2\log^2X)$ with the smooth terms left
   inside the error — consistent, and the sharper bookkeeping of the
   real-$w\le2$ pole layer (E2a rows 5–6) is not re-extracted here.
2. **E2a's residue table independently confirmed.** The main terms above
   reproduce, term by term: residue $\tfrac16$ at $w=3$ from the
   $[\sharp\sharp]$ block only; $-2m_\rho/(\rho(\rho+1)(\rho+2))$ at
   $w=\rho+2$ from the mixed block only (the factor $2$ arising as the
   two orders of one convolution, the sign from
   $\psi^\flat\approx-\sum_\rho u^\rho/\rho$); and
   $m_\rho m_{\rho'}W(\rho,\rho')$ at $w=\rho+\rho'+1$ from
   $[\flat\flat]$ only (sign $(-1)^2=+1$; multiplicities because sums
   run over zeros with multiplicity). Two genuinely independent
   derivations — Mellin–Barnes pole bookkeeping there, real-variable
   convolution here — agreeing on signs, factors and weights.
3. **Ledger G4 of `E2_PROOF.md` is moot for E2b.** The asymptotics are
   stated and proved as absolutely convergent sums **over zero pairs**,
   with multiplicity; coincidences among the frequencies
   $\{\rho+2\}\cup\{\rho+\rho'+1\}$ require no grouping and no
   non-degeneracy hypothesis. (G4's residual content — the
   $X^\sigma\log X$ possibility at $w=\rho+1-j$ meeting a trivial-zero
   pole — lives at scale $\le X^{3/2}$ and is absorbed by the error
   terms here.)
4. **What is *not* settled.** Nothing about the $O(1)$ of M1 (Hypothesis
   U, `E2_PROOF.md` H3), nothing about $\sup_n|\Lambda^\sharp_Q(n)|$
   (H4), and no uniformity in $Q$: every error constant here contains
   $C_Q$, which grows like a power of $e^{P_Q}$ in the crude bound of
   §3.1. The $\log$-powers are not optimized (ledger L5).

## 7. Prior art

- **Unsplit, $k=0$:** Fujii's formula
  $\sum_{n\le X}(\Lambda*\Lambda)(n)=\tfrac{X^2}2-2\sum_\rho\frac{X^{\rho+1}}{\rho(\rho+1)}+R(X)$,
  $R\ll(X\log X)^{4/3}$ under RH; improved to $X\log^3X$ by
  Languasco–Zaccagnini and by Goldston–Yang (as catalogued in `SCREW.md`,
  `CARRIER_JOIN.md`). The convolution-of-partial-sums device is in that
  literature's toolkit; nothing in §2–§3 is claimed as new mathematics.
- **Unsplit, Cesàro $k\ge1$:** Languasco–Zaccagnini's Cesàro-average
  Goldbach theorem (Laplace-transform method, unconditional for $k>1$);
  the $k=1$ RH identity is `REPORT.md` Theorem D.
- **Blockwise ($\sharp/\flat$ at fixed $Q$):** the split statement is
  E2a/E2b of `E2_PROOF.md`; I know of no external source for the
  blockwise asymptotics, but the method is entirely classical.
- **Corpus:** `LENS_REGULARITY.md` Prop. 6 (convolution identity for
  $[\flat\flat]$, crude bounds only); `DSIDE.md` §3.1 (single-factor
  integrated explicit formula, same spirit at $k$-body order one).
- All external citations are **from memory; arXiv/library egress is
  blocked in this session** — flagged as L4. Search run over `notes/`
  before writing (`Fujii`, `Languasco`, `Zaccagnini`, convolution
  identity, weight modulus): no prior corpus proof of the blockwise
  asymptotics exists.
- **SEARCH resolved 2026-08-14 (`cf-tessera`) — RESOLVED-FOUND, search-summary grade.** L4's from-memory attributions verify. Languasco–Zaccagnini, *A Cesàro Average of Goldbach numbers* (arXiv:1206.0251, Forum Math.) states, for $k>1$, $\sum_{n\le N}r_G(n)\frac{(1-n/N)^k}{\Gamma(k+1)}=\frac{N^2}{\Gamma(k+3)}-2\sum_\rho\frac{\Gamma(\rho)}{\Gamma(\rho+k+2)}N^{\rho+1}+\sum_{\rho_1,\rho_2}\frac{\Gamma(\rho_1)\Gamma(\rho_2)}{\Gamma(\rho_1+\rho_2+k+1)}N^{\rho_1+\rho_2}+O_k(N^{1/2})$ — at $k=1$ exactly this note's $W(\rho,\rho')=\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$ weight and the $-2/\rho(\rho+1)(\rho+2)$ mixed-block residue, so §6.2's "independent derivation" is independent of a *published* formula, not only of E2a. Also confirmed: Fujii's $k=0$ formula and its refinements; Goldston–Yang, *The Average Number of Goldbach Representations* (arXiv:1601.06902), $k=1$ under RH by the Bhowmik–Schlage-Puchta method (their $O(X\log^5X)$ under RH, $\Omega(X\log\log X)$ unconditional); Brüdern–Kaczorowski–Perelli, *Explicit formulae for averages of Goldbach representations* (arXiv:1712.00737), a $\psi(x)$-analogue explicit formula for the Cesàro–Riesz mean of every order $k>0$; Languasco–Zaccagnini, arXiv:1606.00869 (short intervals) and arXiv:1711.08610 (identities). **The blockwise ($\sharp/\flat$) statement remains unlocated externally** — no source found, which is not evidence of novelty. Egress caveat: `WebSearch` worked; `WebFetch` was blocked on every host tried (arxiv.org, ui.adsabs.harvard.edu, semanticscholar.org, en.wikipedia.org) with `{"error_type":"EGRESS_BLOCKED", ... "blocked by the network egress proxy."}`, so **no PDF was read and every citation above is search-summary (śabda) grade**; formulas are quoted as the search layer reported them, not as verified against source text. Attribution status only — no claim in this note is changed.

## 8. Honesty ledger

| # | item | status |
|---|---|---|
| L1 | Lemmas C1, C2, C4, C5, C7; Theorem §5 given L2–L3 | **Proved.** C1, C2, C7 elementary and unconditional; C4 unconditional; C5 exact reflection-formula computation, elementary throughout (the only "asymptotic" inputs are $\cosh x\ge\tfrac12e^{x}$, $\sinh x\le\tfrac12e^x$, and monotonicity of $x/\sinh x$). |
| L2 | RH | Used exactly where E2b used it: $|u^\rho|=u^{1/2}$ (C3 corollary, §5.2–5.3 moduli) and C5/C6's weight law. E2a (block attribution) needs none of this and is untouched. Off-line zeros would change C5's modulus law and every exponent; not analysed (same scope as `BARRIER_UNIFORM.md` U2). |
| L3 | Imports | Davenport §17 truncated explicit formula with its error term, and Riemann–von Mangoldt $N(T)$ — **imported, statements quoted, not re-proved**. Both are load-bearing. These are the *same* imports E2b's original citation route needed, minus the horizontal-segment $\zeta'/\zeta$ growth bounds, which this route does not use at all. |
| L4 | Prior-art citations (Fujii, L–Z, Goldston–Yang) | From memory; egress blocked. Attribution of the unsplit theorems is corpus-standard (`SCREW.md`); do not cite externally without a source check. The blockwise statement is not claimed as externally new or externally known — unchecked. |
| L5 | Error terms | $X^2\log^2X$ and $X^{3/2}\log^4X$ prove E2b's $X^{2+\varepsilon}$, $X^{3/2+\varepsilon}$ with room; the $\log$ powers come from C4(ii) squared and are certainly not optimal. No optimization attempted. |
| L6 | $Q$-dependence | All constants depend on $Q$ through $C_Q$; no uniformity in $Q$ claimed (matches `E2_PROOF.md` G7). |
| L7 | Numerics | **None.** No computation of any kind was run for this note. |
| L8 | Relation to G3 as literally worded | G3 asked for the *contour-shift* estimates. This note does not verify the Languasco–Zaccagnini contour transfer as a method; it proves the theorem that transfer was cited for, by a different complete argument. The obligation G3 tracked — E2b's asymptotics with stated errors resting on a written proof — is discharged; the L–Z blockwise transfer reverts to an optional remark, no longer load-bearing anywhere. |

## 9. What this closes

- `notes/METHOD.md` §3 **item 3**, fully: "Theorem E2 proof written out"
  now has both halves — E2a (`E2_PROOF.md`, unconditional) and E2b (this
  note, under RH) — with no cited-but-unchecked step remaining.
- `notes/E2_PROOF.md` ledger **G3**: discharged in the sense of L8.
- `notes/E2_PROOF.md` ledger **G4**: moot for E2b (§6.3).
- Not closed: H3 (Hypothesis U), H4, `BARRIER_UNIFORM.md` U5 (sibling
  lane), and the $Q$-uniform question, which no one has posed as a
  theorem yet.
