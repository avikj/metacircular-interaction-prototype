# The critical crossover of the Hardy–Littlewood singular series under the Bost–Connes temperature deformation

*Working draft — August 2026. Companion to `notes/ADELIC.md` (Prop. E0), `notes/PARITY.md` §1(H), and the verified numerics in `code/exp9_crossover_L.py`.*

---

## Abstract

For a finite set $H\subset\mathbb Z$ of $k$ distinct shifts with $0\in H$, the Hardy–Littlewood singular series $\mathfrak S(H)$ is the correlation, under Haar measure on $\widehat{\mathbb Z}$, of the sifted (unit-coprimality) indicators at the shifted points, renormalized by the $k$-th power of the one-point density. Haar measure is the restriction to the diagonal $C(\widehat{\mathbb Z})$ of the KMS state of the Bost–Connes system at the critical inverse temperature $\beta=1$; replacing it by the KMS$_\beta$ measure $\mu_\beta$ (under which the $p$-adic valuations are independent geometric variables of ratio $p^{-\beta}$ and the unit parts are uniform) defines a one-parameter deformation $C_{\beta,z}(H)$ of the partial singular series, with local factors
$$L_{\beta,p}(H)=\frac{p-\nu_p(H)}{p-1}\,\bigl(1-p^{-\beta}\bigr)^{1-k},\qquad
C_{\beta,z}(H)=\prod_{p\le z}L_{\beta,p}(H).$$
We prove three layers of results about this deformation.[^cnt] **(1) Trichotomy:** as $z\to\infty$, $C_{\beta,z}(H)$ converges to a finite nonzero limit if and only if $\beta=1$, where the limit is $\mathfrak S(H)$; for $\beta<1$ it diverges to $+\infty$ (with $\log C_{\beta,z}\gg z^{1-\beta}/\log z$), for $\beta>1$ it decays to $0$ like $(\log z)^{1-k}$. Thus the existence of renormalized $k$-point densities selects the critical temperature — the pole of $\zeta$ at $s=1$ re-derived from correlation finiteness rather than from the partition function. **(2) Critical scaling law:** in the natural critical window $\beta_z=1+\lambda/\log z$,
$$\frac{C_{\beta_z,z}(H)}{C_{1,z}(H)}\;\longrightarrow\;
\exp\bigl[-(k-1)\,\mathrm{Ein}(\lambda)\bigr],\qquad
\mathrm{Ein}(\lambda)=\int_0^\lambda\frac{1-e^{-t}}{t}\,dt,$$
for every fixed $\lambda\in\mathbb R$, uniformly on compacta; the limit is *universal in $H$* — indeed the ratio is exactly independent of $H$ at every finite $z$ — and equals $\bigl(e^{-\gamma}\widehat\rho(\lambda)\bigr)^{k-1}$, where $\widehat\rho$ is the Laplace transform of the Dickman function. **(3) Second-order term:** the approach to the scaling limit is
$$\frac{C_{\beta_z,z}(H)}{C_{1,z}(H)}
= e^{-(k-1)\mathrm{Ein}(\lambda)}\Bigl[1+\frac{(k-1)\gamma\lambda}{\log z}+O_\lambda\bigl((\log z)^{-2}\bigr)\Bigr],$$
with $\gamma$ Euler's constant. **(3) Complete finite-size ladder:** writing
$\delta=\lambda/\log z$ and $D_z$ for the one-factor logarithm, uniformly on
compact real $\lambda$-sets,
$$D_z(\lambda)=\mathrm{Ein}(\lambda)-\log[\delta\zeta(1+\delta)]
+O(e^{-c\sqrt{\log z}}).$$
Consequently the next coefficient is
$(\gamma_1+\gamma^2/2)\lambda^2/\log^2z=0.0937731164\ldots\,\lambda^2/\log^2z$,
and every later coefficient is a Stieltjes/Laurent layer of $\zeta$ at $1$.
The statements are verified numerically to $z=10^8$. Finite Euler-product
asymptotics of this form have substantial classical prior art; the contribution
claimed here is their exact placement in the anchored KMS/singular-series
correlator and the resulting universal response law, not the bare analytic
lemma.

---

## 1. Introduction

Three classical objects meet in this note.

**The singular series.** For a finite set $H=\{h_1,\dots,h_k\}\subset\mathbb Z$ of distinct integers, Hardy and Littlewood [HL23] conjectured that the number of $n\le X$ with $n+h_1,\dots,n+h_k$ all prime is $\sim\mathfrak S(H)\,X/(\log X)^k$, where
$$\mathfrak S(H)=\prod_p\Bigl(1-\frac{\nu_p(H)}{p}\Bigr)\Bigl(1-\frac1p\Bigr)^{-k},
\qquad \nu_p(H)=\#\{h\bmod p: h\in H\}.$$
The product converges absolutely, and $\mathfrak S(H)>0$ iff $H$ is *admissible* ($\nu_p(H)<p$ for all $p$). The local factor at $p$ is a ratio of probabilities: (chance that $n+h$ is prime to $p$ for all $h\in H$) over (chance for $k$ independent points), computed for a uniformly random residue mod $p$. The singular series is thus a purely *local* (finite-place) object: it is the total correlation correction that the local model imposes on the naive independence heuristic.

**The Bost–Connes system.** Bost and Connes [BC95] attached to $(\mathbb Q,+,\times)$ a $C^*$-dynamical system whose partition function is $\zeta(\beta)$ and which has a phase transition at $\beta=1$: a unique KMS$_\beta$ state for $0<\beta\le1$, and for $\beta>1$ a simplex of KMS$_\beta$ states on which $\mathrm{Gal}(\mathbb Q^{\mathrm{ab}}/\mathbb Q)\cong\widehat{\mathbb Z}^\times$ acts freely and transitively (see also Neshveyev [Nes02] for the ergodicity proof, Laca–Raeburn [LR10] for the Toeplitz refinement, Laca–Larsen–Neshveyev [LLN09] for number fields). The diagonal subalgebra of the BC system is $C(\widehat{\mathbb Z})$, and the relevant restriction of the KMS structure to it is a one-parameter family of measures $\mu_\beta$ on $\widehat{\mathbb Z}=\prod_p\mathbb Z_p$, described precisely in §2: independent over $p$, valuation $v_p$ geometric with ratio $p^{-\beta}$, unit part uniform. At $\beta=1$, $\mu_1$ is the Haar measure of $\widehat{\mathbb Z}$.

**The local model of the primes.** The classical local-density heuristic reads the singular series as a correlation function of the "random profinite integer": for the sifting indicators $e_p=1_{\mathbb Z_p^\times}$ and Haar measure, the renormalized $k$-point function of the translates $\{x+h\}_{h\in H}$ over primes $p\le z$ is exactly the partial product $C_{1,z}(H)\to\mathfrak S(H)$. In the repository this identity — including its operator-algebraic dressing (sieve projections $e_F$ in the BC algebra, the translation unitary, and the KMS$_1$ state) — is stated and machine-verified in `notes/ADELIC.md` §1 and `code/exp8_adelic.py`; the spectral (Wiener–Khintchine/Ramanujan–Fourier) reading of the same content goes back to Gadiyar–Padma [GP99].

The observation that starts the present paper (`ADELIC.md`, Prop. E0) is that the KMS parameter can be made to *do work* the bare local model cannot express: replacing Haar by $\mu_\beta$ deforms every local factor, and demanding that the renormalized correlations remain finite and nonzero in the limit over all primes *forces* $\beta=1$. The prime local model has a critical temperature, and it is the pole of $\zeta$ — but reached through correlation functions rather than through the partition function (for the partition-function route, the classical "primon gas" Hagedorn transition of Julia and Spector [Jul90, Spe90]).

Once a system has a critical point, the canonical next question is statistical-mechanical: *what is the scaling law in the critical window?* This paper answers that question for the deformed singular series and proves the answer. In the window $\beta_z=1+\lambda/\log z$ (the natural window: $\beta-1$ conjugate to $\log z$, exactly as $s-1\sim1/\log x$ is the natural window at the pole of $\zeta$), the deformation acquires a finite, nontrivial, $H$-universal limit
$$\frac{C_{\beta_z,z}(H)}{C_{1,z}(H)}\longrightarrow e^{-(k-1)\,\mathrm{Ein}(\lambda)},$$
where $\mathrm{Ein}$ is the entire exponential integral. Equivalently, by a classical identity, the crossover function per "excess point" of the tuple is $e^{-\mathrm{Ein}(\lambda)}=e^{-\gamma}\widehat\rho(\lambda)$: the (normalized) Laplace transform of the Dickman function, the central special function of smooth-number theory, here arising with no smooth numbers in sight. We also compute the complete finite-size ladder: its first correction is $(k-1)\gamma\lambda/\log z$, its next exponent coefficient is $-(k-1)(\gamma_1+\gamma^2/2)\lambda^2/\log^2z$, and all later terms are read from the Laurent jet of $\zeta$ at $1$.

The results are theorems about the *local model*, not about primes; §8 discusses
at length what they do and do not mean. The proofs (§5) use partial summation
and the classical PNT error term. Section 7 separates the close finite-product
prior art from the narrower KMS/correlation synthesis claimed here.

### Statement of results

Throughout, $H\subset\mathbb Z$ is a finite set of $k=|H|\ge1$ distinct integers with $0\in H$; $\nu_p(H)=\#\{h\bmod p\}$; $\gamma$ is Euler's constant;
$$L_{\beta,p}(H)=\frac{p-\nu_p(H)}{p-1}\,(1-p^{-\beta})^{1-k},\qquad
C_{\beta,z}(H)=\prod_{p\le z}L_{\beta,p}(H)\quad(\beta>0,\ z\ge2).$$
§2 derives this local factor from the KMS$_\beta$ measures (anchored normalization). Let
$$\mathrm{Ein}(\lambda)=\int_0^\lambda\frac{1-e^{-t}}{t}\,dt=\sum_{n\ge1}\frac{(-1)^{n+1}\lambda^n}{n\cdot n!}
\qquad(\lambda\in\mathbb C,\ \text{entire}).$$

> **Theorem 1 (trichotomy).** Let $H$ be admissible, $k\ge2$. As $z\to\infty$:
> 1. if $\beta=1$, then $C_{1,z}(H)\to\mathfrak S(H)\in(0,\infty)$;
> 2. if $\beta>1$, then $C_{\beta,z}(H)\asymp_{\beta,H}(\log z)^{1-k}\to0$;
> 3. if $0<\beta<1$, then $\log C_{\beta,z}(H)\ge (k-1)\bigl(\sum_{p\le z}p^{-\beta}\bigr)(1+o(1))\gg_\beta z^{1-\beta}/\log z\to+\infty$.
>
> In particular $\lim_z C_{\beta,z}(H)$ exists in $(0,\infty)$ if and only if $\beta=1$.

> **Proposition 2 (exact universality of the crossover ratio).** For every $z\ge2$, $\beta>0$ and every $H$ with $|H|=k$ (admissible or not),
> $$R_z(\beta,k):=\frac{C_{\beta,z}(H)}{C_{1,z}(H)}=\prod_{p\le z}\biggl[\frac{1-p^{-\beta}}{1-p^{-1}}\biggr]^{1-k}$$
> depends only on $(\beta,z,k)$: the arithmetic of $H$ cancels identically.

> **Theorem 3 (critical scaling law).** Fix $\lambda\in\mathbb R$ and set $\beta_z=1+\lambda/\log z$. Then
> $$\lim_{z\to\infty}R_z(\beta_z,k)=\exp\bigl[-(k-1)\,\mathrm{Ein}(\lambda)\bigr],$$
> uniformly for $\lambda$ in compact sets. For $\lambda>0$,
> $\mathrm{Ein}(\lambda)=\gamma+\log\lambda+E_1(\lambda)$ with $E_1(\lambda)=\int_\lambda^\infty e^{-t}t^{-1}dt$, so
> $$\lim_z R_z(\beta_z,k)=\Bigl(\frac{e^{-\gamma}}{\lambda}\Bigr)^{k-1}e^{-(k-1)E_1(\lambda)}
> \sim\Bigl(\frac{e^{-\gamma}}{\lambda}\Bigr)^{k-1}\quad(\lambda\to+\infty);$$
> for $\lambda<0$, $\mathrm{Ein}(\lambda)=\gamma+\log|\lambda|-\mathrm{Ei}(|\lambda|)$, and the limit grows doubly exponentially as $\lambda\to-\infty$. Moreover, with $\widehat\rho(s)=\int_0^\infty\rho(u)e^{-su}du$ the Laplace transform of the Dickman function, $e^{-\mathrm{Ein}(\lambda)}=e^{-\gamma}\widehat\rho(\lambda)$, so the crossover limit is $\bigl(e^{-\gamma}\widehat\rho(\lambda)\bigr)^{k-1}$.

> **Theorem 4 (second-order term).** With $\beta_z=1+\lambda/\log z$ and $z\ge e^{2(1+|\lambda|)}$,
> $$R_z(\beta_z,k)=e^{-(k-1)\mathrm{Ein}(\lambda)}
> \exp\Bigl[\frac{(k-1)\gamma\lambda}{\log z}+O\Bigl(\frac{(1+\lambda^2)e^{2|\lambda|}}{\log^2 z}\Bigr)\Bigr].$$
> Equivalently, the single-factor exponent $D_z(\lambda):=\sum_{p\le z}\bigl[\log(1-p^{-\beta_z})-\log(1-p^{-1})\bigr]$ satisfies
> $D_z(\lambda)=\mathrm{Ein}(\lambda)-\gamma\lambda/\log z+O_\lambda(1/\log^2z)$, and $R_z=e^{(1-k)D_z}$ exactly.

> **Theorem 5 (complete finite-size ladder).** Put $L=\log z$ and
> $\delta=\lambda/L$. Uniformly for $\lambda$ in any fixed compact subset of
> $\mathbb R$,
> $$D_z(\lambda)=\mathrm{Ein}(\lambda)
> -\log[\delta\zeta(1+\delta)]
> +O_K(e^{-c_K\sqrt L}),$$
> where the logarithm is its analytic branch at $\delta=0$. In particular,
> $$D_z(\lambda)=\mathrm{Ein}(\lambda)-\frac{\gamma\lambda}{L}
> +\left(\gamma_1+\frac{\gamma^2}{2}\right)\frac{\lambda^2}{L^2}
> +O_K(L^{-3}),$$
> with $\zeta(1+s)=s^{-1}+\gamma-\gamma_1s+O(s^2)$ and
> $\gamma_1+\gamma^2/2=0.093773116420\ldots$.

Theorem 1 for $k=2$ is Proposition E0 of `notes/ADELIC.md` (this repository).
The defensible novelty candidates are the general-$k$ KMS correlator,
Proposition 2's exact $H$-cancellation, and their response-law synthesis;
Theorems 3–5 use analytic machinery close to the finite-Euler-product results
reviewed in §7. The coefficient $-\gamma\lambda$ was first seen here as the
empirical $1/\log z$ drift in `exp9` and is derived in §5.4. Two sources
contribute: the Mertens constant $E_1^{\mathrm M}$ in
$\sum_{p\le z}\log p/p=\log z+E_1^{\mathrm M}+O(e^{-c\sqrt{\log z}})$, and
the prime powers $p^{-m\beta}$ hidden in $\log(1-p^{-\beta})$, which contribute
$+\sum_p\log p/(p(p-1))$ per unit of $\lambda/\log z$. Since
$$E_1^{\mathrm M}=-\gamma-\sum_p\frac{\log p}{p(p-1)},$$
the prime-power sum cancels against the corresponding piece of $E_1^{\mathrm M}$ and the bare $-\gamma$ survives. The universality of the second-order coefficient is thus exactly as robust as the appearance of $e^{-\gamma}$ in Mertens' third theorem.

*Remark (susceptibility).* Differentiating at $\lambda=0$: $\partial_\lambda\log R_z\big|_{\lambda=0}=(1-k)\bigl(1-\gamma/\log z\bigr)+O(e^{-c\sqrt{\log z}})$, consistent with $\mathrm{Ein}'(0)=1$ and Theorem 4. The linear response of the log-correlation to temperature is *extensive in the excess tuple size* $k-1$, with universal coefficient.

More generally Theorem 5 gives the diagonal response hierarchy
$$\left.\partial_\lambda^r\log R_z\right|_{\lambda=0}
=(k-1)\left[\frac{(-1)^r}{r}
+\frac{A^{(r)}(0)}{(\log z)^r}\right]
+O_{r,k}(e^{-c\sqrt{\log z}}),$$
where $A(s)=\log[s\zeta(1+s)]$. Thus the $r$th response has no algebraic
finite-size correction before order $(\log z)^{-r}$, where it recovers the
$r$th Laurent/Stieltjes layer.

---

## 2. The local model, KMS$_\beta$ measures, and the anchored correlation

### 2.1 The measures $\mu_\beta$

For each prime $p$ and $\beta>0$ let $\mu_\beta^{(p)}$ be the Borel probability measure on $\mathbb Z_p$ determined by:

* the valuation is geometric: $\mu_\beta^{(p)}\bigl(v_p=m\bigr)=(1-p^{-\beta})\,p^{-\beta m}$, $m\ge0$;
* conditionally on $v_p=m$, the unit part $x/p^m$ is distributed by normalized Haar measure on $\mathbb Z_p^\times$.

Equivalently, on residues mod $p$:
$$\mu_\beta^{(p)}(x\equiv a)=\frac{1-p^{-\beta}}{p-1}\ (a\not\equiv0),\qquad
\mu_\beta^{(p)}(x\equiv 0)=p^{-\beta},\tag{2.1}$$
with the analogous formulas at every level $p^j$. Set $\mu_\beta=\bigotimes_p\mu_\beta^{(p)}$ on $\widehat{\mathbb Z}$. At $\beta=1$, (2.1) is the uniform measure at every level: $\mu_1$ is Haar measure.

**Relation to the BC system.** The diagonal of the Bost–Connes algebra is $C(\widehat{\mathbb Z})$, and the KMS$_\beta$ condition for the semigroup of isometries $\{\mu_n\}$ forces the restriction of any KMS$_\beta$ state to the diagonal to scale by $n^{-\beta}$ under the injections $x\mapsto nx$, while the symmetry group $\widehat{\mathbb Z}^\times$ acts by units. For $0<\beta\le1$ the KMS$_\beta$ state is unique [BC95, Nes02] and restricts to $\mu_\beta$. For $\beta>1$ the extremal KMS$_\beta$ states are the Gibbs states $\omega_{\beta,u}$ indexed by $u\in\widehat{\mathbb Z}^\times$, and their Galois average (the unique symmetric KMS$_\beta$ state) restricts to the diagonal as the law of $N\cdot U$, where $N$ is a $\zeta(\beta)$-distributed random integer ($\Pr[N=n]=n^{-\beta}/\zeta(\beta)$) and $U$ is an independent Haar-random unit of $\widehat{\mathbb Z}$. Since $v_p(NU)=v_p(N)$ are independent geometric of ratio $p^{-\beta}$ (Euler factorization of $\zeta(\beta)$) and the Haar unit $U$ makes every unit part uniform, this law is again exactly $\mu_\beta$. So (2.1) is the diagonal restriction of the canonical (symmetric) KMS$_\beta$ state for *all* $\beta>0$, uniqueness holding for $\beta\le1$. Note the unit-randomization matters: the law of $N$ alone (the classical zeta distribution) does *not* have uniform unit classes for $\beta\ne1$; the adelic model is genuinely different from the naive Gibbs distribution on integers.

### 2.2 The anchored correlation

Let $e=1_{\mathbb Z_p^\times}$ and let $\tau_h$ denote translation by $h\in\mathbb Z$. For $H\ni0$ with $|H|=k$, define the *anchored $k$-point correlation at $p$*:
$$L_{\beta,p}(H):=\frac{\mu_\beta^{(p)}\bigl(\bigcap_{h\in H}\{x:\,x+h\in\mathbb Z_p^\times\}\bigr)}{\mu_\beta^{(p)}(\mathbb Z_p^\times)^{k}}.\tag{2.2}$$
The event in the numerator is: $x$ avoids the $\nu_p(H)$ residue classes $\{-h\bmod p\}$. Because $0\in H$, the zero class is among the forbidden ones, so all $p-\nu_p(H)$ allowed classes are unit classes of mass $(1-p^{-\beta})/(p-1)$ by (2.1), giving
$$L_{\beta,p}(H)=\frac{(p-\nu_p(H))\,\frac{1-p^{-\beta}}{p-1}}{(1-p^{-\beta})^{k}}
=\frac{p-\nu_p(H)}{p-1}\,(1-p^{-\beta})^{1-k},\tag{2.3}$$
as announced, and $C_{\beta,z}(H)=\prod_{p\le z}L_{\beta,p}(H)$ is the truncated all-place correlation. At $\beta=1$,
$$L_{1,p}(H)=\frac{p-\nu_p}{p-1}\Bigl(1-\frac1p\Bigr)^{1-k}
=\Bigl(1-\frac{\nu_p}{p}\Bigr)\Bigl(1-\frac1p\Bigr)^{-k},$$
the Hardy–Littlewood local factor.

**Why "anchored".** For $\beta\ne1$, $\mu_\beta$ is not translation invariant, so a correlation of translates needs a base point; (2.2) anchors at the point $0\in H$ (the event is expressed in the variable $x=x+0$). Translating $H$ changes $L_{\beta,p}$ when $0\notin H$: e.g. if $p\nmid h$ for all $h\in H$ then the zero class is allowed and picks up the deformed mass $p^{-\beta}$ instead of $(1-p^{-\beta})/(p-1)$. At $\beta=1$ all anchorings coincide. This is a real limitation of scope, discussed in §8; all statements in this paper are about the anchored normalization (2.2).

---

## 3. Special-function background

$\mathrm{Ein}$ is entire, with $\mathrm{Ein}(\lambda)=\gamma+\log\lambda+E_1(\lambda)$ for $\lambda>0$ and $\mathrm{Ein}(\lambda)=\gamma+\log|\lambda|-\mathrm{Ei}(|\lambda|)$ for $\lambda<0$ (both classical; [Lag13, §2.3], NIST DLMF 6.2). Since $E_1(\lambda)\to0$ rapidly, $e^{-\mathrm{Ein}(\lambda)}\sim e^{-\gamma}/\lambda$ as $\lambda\to+\infty$; since $\mathrm{Ei}(x)\sim e^x/x$, $e^{-\mathrm{Ein}(\lambda)}$ grows like $\exp(e^{|\lambda|}/|\lambda|)$ as $\lambda\to-\infty$.

*(A caution recorded during preparation: the identity is $e^{-\mathrm{Ein}(\lambda)}=(e^{-\gamma}/\lambda)\,e^{-E_1(\lambda)}$, with a **minus** sign on $E_1$ in the exponent; the variant with $+E_1(\lambda)$, which circulated in our working notes, is numerically refuted — at $\lambda=1$: $e^{-\mathrm{Ein}(1)}=0.4508594633$, $(e^{-\gamma}/1)e^{-E_1(1)}=0.4508594633$, $(e^{-\gamma}/1)e^{+E_1(1)}=0.6991907176$.)*

The Dickman function $\rho$ (density of smooth numbers: $\Psi(x,x^{1/u})\sim\rho(u)x$) has Laplace transform
$$\widehat\rho(s)=\int_0^\infty\rho(u)e^{-su}\,du=\exp\bigl[\gamma-\mathrm{Ein}(s)\bigr]\tag{3.1}$$
([Ten15, III.5.4]; [Lag13, §3.1]; special case $\widehat\rho(0)=e^\gamma$). Hence the per-excess-point crossover function of Theorem 3 is $e^{-\mathrm{Ein}(\lambda)}=e^{-\gamma}\widehat\rho(\lambda)=\widehat\rho(\lambda)/\widehat\rho(0)$.

We will use Mertens' theorems in the PNT-strength form: there is $c>0$ with
$$\sum_{p\le z}\frac{\log p}{p}=\log z+E_1^{\mathrm M}+O\bigl(e^{-c\sqrt{\log z}}\bigr),\qquad
\sum_{p\le z}\frac1p=\log\log z+M+O\bigl(e^{-c\sqrt{\log z}}\bigr),\tag{3.2}$$
where $M$ is Mertens' constant and
$$E_1^{\mathrm M}=-\gamma-\sum_p\frac{\log p}{p(p-1)}=-1.33258\ldots\tag{3.3}$$
Both statements follow from $\theta(x)=x+O(xe^{-c\sqrt{\log x}})$ by partial summation, and the identification (3.3) of the constant is classical; for completeness we prove what we use in §5.1. (Weaker $O(1/\log z)$ error terms — Mertens' original — suffice for Theorem 3 but not for Theorem 4.)

---

## 4. Proof of Theorem 1 and Proposition 2

**Proposition 2** is immediate: in the ratio $C_{\beta,z}/C_{1,z}$ the factors $(p-\nu_p)/(p-1)$, which carry all dependence on $H$, cancel exactly, leaving $\prod_{p\le z}[(1-p^{-\beta})/(1-p^{-1})]^{1-k}$. $\square$

**Proof of Theorem 1.** Write $\log C_{\beta,z}(H)=\Sigma_1(z)+(1-k)\Sigma_2(\beta,z)$ with
$$\Sigma_1(z)=\sum_{p\le z}\log\frac{p-\nu_p}{p-1},\qquad
\Sigma_2(\beta,z)=\sum_{p\le z}\log(1-p^{-\beta}).$$
Let $D(H)=\max_{h,h'\in H}|h-h'|$. For $p>D(H)$ all differences are nonzero mod $p$, so $\nu_p=k$, and
$$\log\frac{p-k}{p-1}=-\frac{k-1}{p}+O_k\bigl(p^{-2}\bigr).$$
Hence, by (3.2), $\Sigma_1(z)=-(k-1)\log\log z+c(H)+o(1)$ for a constant $c(H)$ (finite for admissible $H$; if $H$ is inadmissible some factor vanishes and $C\equiv0$ for large $z$).

*Case $\beta=1$.* $L_{1,p}(H)=\bigl(1-\nu_p/p\bigr)\bigl(1-1/p\bigr)^{-k}=1+O_k(p^{-2})$ for $p>D(H)$, so the product converges absolutely to $\mathfrak S(H)>0$.

*Case $\beta>1$.* $-\Sigma_2(\beta,z)\to\log\zeta_{\mathrm{res}}(\beta):=-\sum_p\log(1-p^{-\beta})<\infty$. So $\log C_{\beta,z}=-(k-1)\log\log z+O_{\beta,H}(1)$, i.e. $C_{\beta,z}\asymp(\log z)^{1-k}\to0$ (for $k\ge2$).

*Case $0<\beta<1$.* Use the elementary bounds $-\log(1-x)\ge x$ ($0<x<1$) and, for $p>k+1$, $\log\frac{p-\nu_p}{p-1}\ge\log\frac{p-k}{p-1}\ge-\frac{k-1}{p-k}$. Then
$$\log C_{\beta,z}(H)\ \ge\ (k-1)\sum_{p\le z}p^{-\beta}\ -\ (k-1)\sum_{k+1<p\le z}\frac{1}{p-k}\ -\ O_H(1).$$
By Chebyshev, $\sum_{p\le z}p^{-\beta}\ge z^{-\beta}\pi(z)\gg z^{1-\beta}/\log z$, while the subtracted sum is $\log\log z+O_k(1)$. Hence $\log C_{\beta,z}\to+\infty$ at the stated rate. $\square$

The trichotomy re-derives the criticality of $\beta=1$ — the pole of $\zeta(s)$ at $s=1$ — as the unique temperature at which the arithmetic gas has finite renormalized $k$-point functions, for every $k\ge2$ simultaneously. For $k=2$ this is Prop. E0 of `notes/ADELIC.md`, verified in `exp8` ($h=2$: partial products at $B=10^3,10^4,10^5$ are $2.87,4.08,6.11$ for $\beta=0.9$; $1.32049,1.32034,1.32032$ for $\beta=1$, locking to $\mathfrak S(2)=1.320324$; $0.77,0.66,0.57$ for $\beta=1.1$).

---

## 5. Proofs of Theorems 3 and 4

By Proposition 2, $R_z(\beta_z,k)=\exp[(1-k)D_z(\lambda)]$ with
$$D_z(\lambda)=\sum_{p\le z}\Bigl[\log\bigl(1-p^{-\beta_z}\bigr)-\log\bigl(1-p^{-1}\bigr)\Bigr],
\qquad \beta_z=1+\frac{\lambda}{\log z},$$
so both theorems reduce to the asymptotics of $D_z$. Note $p^{-\beta_z}=p^{-1}e^{-\lambda u_p}$ with $u_p:=\log p/\log z\in(0,1]$. Expanding both logarithms ($-\log(1-x)=\sum_{m\ge1}x^m/m$, absolutely convergent since $p^{-\beta_z}\le 2^{-1}e^{|\lambda|/\log z}<1$ for $\log z\ge2|\lambda|$):
$$D_z(\lambda)=\sum_{p\le z}\sum_{m\ge1}\frac{1}{m}\,p^{-m}\bigl(1-e^{-m\lambda u_p}\bigr)
=\underbrace{-\sum_{p\le z}\frac{f(u_p)}{p}}_{=:*\ (m=1)}
\;+\;\underbrace{\sum_{p\le z}\sum_{m\ge2}\frac{p^{-m}}{m}\bigl(1-e^{-m\lambda u_p}\bigr)}_{=:T_z},\tag{5.1}$$
where $f(u)=e^{-\lambda u}-1$.

### 5.1 Mertens with PNT error, and the constant (3.3)

**Lemma 5.1.** There is an absolute $c>0$ such that
$\sum_{p\le z}\frac{\log p}{p}=\log z+E_1^{\mathrm M}+O(e^{-c\sqrt{\log z}})$ with $E_1^{\mathrm M}=-\gamma-\sum_p\frac{\log p}{p(p-1)}$.

*Proof.* Partial summation against $\psi$: with $\psi(t)=t+R(t)$, $|R(t)|\ll te^{-c\sqrt{\log t}}$ (de la Vallée Poussin; [MV07, Ch. 6]),
$$\sum_{n\le z}\frac{\Lambda(n)}{n}=\frac{\psi(z)}{z}+\int_1^z\frac{\psi(t)}{t^2}\,dt
=\log z+1+\int_1^\infty\frac{R(t)}{t^2}\,dt+O\bigl(e^{-c'\sqrt{\log z}}\bigr),$$
the tail $\int_z^\infty|R|t^{-2}dt\ll\int_{\log z}^\infty e^{-c\sqrt v}dv\ll e^{-c''\sqrt{\log z}}$ being absorbed. To identify the constant, use the Mellin identity $\int_1^\infty\psi(t)t^{-s-1}dt=-\zeta'(s)/(s\zeta(s))$ for $\Re s>1$, so
$$\int_1^\infty\frac{\psi(t)-t}{t^{s+1}}\,dt=-\frac{\zeta'(s)}{s\,\zeta(s)}-\frac{1}{s-1}
\;\xrightarrow[s\to1^+]{}\;-1-\gamma,$$
because $-\zeta'/\zeta(s)=\frac{1}{s-1}-\gamma+O(s-1)$ (from $\zeta(s)=\frac{1}{s-1}+\gamma+O(s-1)$); dominated convergence (the integrand is $\ll t^{-2}\cdot te^{-c\sqrt{\log t}}$, integrable) lets us pass to the limit inside. Hence $1+\int_1^\infty R(t)t^{-2}dt=-\gamma$ and
$$\sum_{n\le z}\frac{\Lambda(n)}{n}=\log z-\gamma+O\bigl(e^{-c\sqrt{\log z}}\bigr).$$
Subtract the prime powers: $\sum_{p^m\le z,\,m\ge2}\log p\,p^{-m}=\sum_p\frac{\log p}{p(p-1)}+O(z^{-1/2}\log z)$. $\square$

**Lemma 5.2.** $\sum_{p\le t}\frac1p=\log\log t+M+E(t)$ with $|E(t)|\ll e^{-c\sqrt{\log t}}$ for $t\ge2$; consequently $\int_2^\infty|E(t)|\frac{dt}{t}<\infty$ and $\int_2^\infty|E(t)|\log t\,\frac{dt}{t}<\infty$.

*Proof.* Partial summation of Lemma 5.1 against $1/\log t$ (standard; [MV07, Thm 2.7 + Ch. 6]). The integrals converge because $\int_2^\infty e^{-c\sqrt{\log t}}(\log t)\frac{dt}{t}=\int_{\log2}^\infty ve^{-c\sqrt v}dv<\infty$. $\square$

### 5.2 The $m=1$ term

**Lemma 5.3.** For $\lambda\in\mathbb R$ and $\log z\ge2(1+|\lambda|)$,
$$\sum_{p\le z}\frac{e^{-\lambda u_p}-1}{p}
=-\mathrm{Ein}(\lambda)-\frac{\lambda\,E_1^{\mathrm M}}{\log z}
+O\Bigl(\frac{\lambda^2e^{|\lambda|}}{\log^2z}\Bigr).$$

*Proof.* Split $f(u)=e^{-\lambda u}-1=-\lambda u+g(u)$, where $g(u)=e^{-\lambda u}-1+\lambda u$ satisfies, for $0\le u\le1$,
$$|g(u)|\le\tfrac12\lambda^2u^2e^{|\lambda|},\qquad |g'(u)|=|\lambda|\,|1-e^{-\lambda u}|\le\lambda^2ue^{|\lambda|}.\tag{5.2}$$

*Linear part.* $-\lambda\sum_{p\le z}\frac{u_p}{p}=-\frac{\lambda}{\log z}\sum_{p\le z}\frac{\log p}{p}
=-\lambda-\frac{\lambda E_1^{\mathrm M}}{\log z}+O\bigl(|\lambda|e^{-c'\sqrt{\log z}}\bigr)$ by Lemma 5.1 (and $e^{-c'\sqrt{\log z}}\ll1/\log^2z$).

*Curved part.* By partial summation against $P(t)=\sum_{p\le t}1/p$ (Lemma 5.2), writing $u_t=\log t/\log z$:
$$\sum_{p\le z}\frac{g(u_p)}{p}=\int_{2^-}^z g(u_t)\,dP(t)
=\int_2^z g(u_t)\,\frac{dt}{t\log t}+\Bigl[g(u_t)E(t)\Bigr]_{2^-}^z-\frac{1}{\log z}\int_2^z E(t)\,g'(u_t)\,\frac{dt}{t}.$$
The main integral is $\int_{u_2}^1g(u)\frac{du}{u}$ ($u=u_t$, $u_2=\log2/\log z$); since $g(u)/u=O(\lambda^2ue^{|\lambda|})$ is integrable at $0$,
$$\int_{u_2}^{1}g(u)\frac{du}{u}=\int_0^1g(u)\frac{du}{u}+O\bigl(\lambda^2e^{|\lambda|}u_2^2\bigr)
=\bigl[\lambda-\mathrm{Ein}(\lambda)\bigr]+O\Bigl(\frac{\lambda^2e^{|\lambda|}}{\log^2z}\Bigr),$$
using $\int_0^1\frac{e^{-\lambda u}-1}{u}du=-\mathrm{Ein}(\lambda)$ and $\int_0^1\lambda\,du=\lambda$. The boundary terms are $\ll\lambda^2e^{|\lambda|}\bigl(e^{-c\sqrt{\log z}}+u_2^2\bigr)\ll\lambda^2e^{|\lambda|}/\log^2z$ by (5.2) and $|E|\ll e^{-c\sqrt{\log t}}$. The last integral is, by (5.2) and Lemma 5.2,
$$\ll\frac{1}{\log z}\int_2^z|E(t)|\,\lambda^2e^{|\lambda|}\frac{\log t}{\log z}\,\frac{dt}{t}
\le\frac{\lambda^2e^{|\lambda|}}{\log^2z}\int_2^\infty|E(t)|\log t\,\frac{dt}{t}
\ll\frac{\lambda^2e^{|\lambda|}}{\log^2z}.$$
Adding the linear and curved parts, the two occurrences of $\lambda$ cancel and the claim follows. $\square$

### 5.3 The prime-power terms

**Lemma 5.4.** For $\log z\ge2(1+|\lambda|)$,
$$T_z=\sum_{p\le z}\sum_{m\ge2}\frac{p^{-m}}{m}\bigl(1-e^{-m\lambda u_p}\bigr)
=\frac{\lambda}{\log z}\sum_p\frac{\log p}{p(p-1)}+O\Bigl(\frac{\lambda^2e^{2|\lambda|}}{\log^2z}\Bigr).$$

*Proof.* Since $\log z\ge2|\lambda|$ we have $p^{-1}e^{|\lambda|u_p}=p^{-1+|\lambda|/\log z}\le p^{-1/2}$, so all series below converge geometrically, uniformly in $p\le z$. Write $1-e^{-x}=x+O(x^2e^{|x|})$ with $x=m\lambda u_p$:
$$\frac{p^{-m}}{m}\bigl(1-e^{-m\lambda u_p}\bigr)=\lambda u_p\,p^{-m}+O\bigl(m\lambda^2u_p^2\,p^{-m}e^{m|\lambda|u_p}\bigr).$$
Summing the main term over $m\ge2$ gives $\lambda u_p\cdot\frac{1}{p(p-1)}$; summing the error over $m\ge2$ gives, with $x_p:=p^{-1}e^{|\lambda|u_p}\le p^{-1/2}\le2^{-1/2}$,
$$\lambda^2u_p^2\sum_{m\ge2}m\,x_p^m\ll\lambda^2u_p^2\,x_p^2\ll\lambda^2u_p^2\,e^{2|\lambda|}p^{-2}.$$
Now sum over $p\le z$: the main part is $\frac{\lambda}{\log z}\sum_{p\le z}\frac{\log p}{p(p-1)}
=\frac{\lambda}{\log z}\sum_p\frac{\log p}{p(p-1)}+O\bigl(|\lambda|\,z^{-1}\bigr)$, and the error part is
$\ll\frac{\lambda^2e^{2|\lambda|}}{\log^2z}\sum_p\frac{\log^2p}{p^2}\ll\frac{\lambda^2e^{2|\lambda|}}{\log^2z}$. $\square$

### 5.4 Assembly

By (5.1), Lemma 5.3 (with an overall minus sign) and Lemma 5.4,
$$D_z(\lambda)=\mathrm{Ein}(\lambda)+\frac{\lambda}{\log z}\Bigl[E_1^{\mathrm M}+\sum_p\frac{\log p}{p(p-1)}\Bigr]
+O\Bigl(\frac{(1+\lambda^2)e^{2|\lambda|}}{\log^2z}\Bigr)
=\mathrm{Ein}(\lambda)-\frac{\gamma\lambda}{\log z}+O_\lambda\Bigl(\frac{1}{\log^2z}\Bigr),$$
the bracket collapsing to $-\gamma$ by (3.3). Exponentiating $R_z=e^{(1-k)D_z}$ proves Theorem 4, and a fortiori Theorem 3 (the error terms are uniform for $\lambda$ in compacta; the identities for $\mathrm{Ein}$ on both half-lines are §3). $\square$

*Remark 5.5 (a second route, $\lambda>0$, and the $\zeta$-pole mechanism).* For $\lambda>0$ one can see the same numbers through $\zeta$: with $s=\beta_z>1$,
$$-\Sigma_2(\beta_z,z)=\log\zeta(\beta_z)-\sum_{p>z}\sum_m\frac{p^{-m\beta_z}}{m},\qquad
\log\zeta(1+\delta)=\log\frac1\delta+\gamma\delta+O(\delta^2),$$
and by the PNT the tail behaves as $\sum_{p>z}p^{-\beta_z}\approx\int_z^\infty t^{-\beta_z}\frac{dt}{\log t}=E_1(\lambda)+o(1)$; combining with Mertens' third theorem $-\Sigma_2(1,z)=\gamma+\log\log z+o(1)$ recovers $D_z\to\gamma+\log\lambda+E_1(\lambda)=\mathrm{Ein}(\lambda)$, and the $\gamma\delta=\gamma\lambda/\log z$ term of $\log\zeta(1+\delta)$ is precisely the second-order coefficient of Theorem 4. The crossover law is thus the correlation-function shadow of the Laurent expansion of $\zeta$ at its pole: $\mathrm{Ein}(\lambda)$ from the pole itself, $-\gamma\lambda/\log z$ from the constant term. The partial-summation proof above is preferred because it covers $\lambda\le0$ (where the Euler product of $\zeta(\beta_z)$ diverges) with no extra work.

### 5.5 Proof of Theorem 5

Let $L=\log z$, $\delta=\lambda/L$, and
$A(u)=\log[u\zeta(1+u)]$, with $A(0)=0$. Re-indexing the Euler-factor expansion
by prime powers gives, uniformly for $\lambda$ in a compact set,
$$D_z(\lambda)=\sum_{n\le z}\frac{\Lambda(n)}{n\log n}
(1-n^{-\delta})+O_K(z^{-1/2}).\tag{5.5}$$
Since $(1-n^{-\delta})/\log n=\int_0^\delta n^{-u}\,du$, (5.5) equals
$$\frac1L\int_0^\lambda M_z\!\left(1+\frac tL\right)dt+O_K(z^{-1/2}),
\qquad M_z(1+u)=\sum_{n\le z}\frac{\Lambda(n)}{n^{1+u}}.\tag{5.6}$$

We need a microscopic truncated-log-derivative estimate:
$$M_z(1+u)=\frac{1-z^{-u}}u-A'(u)
+O_K(e^{-c_K\sqrt L})\qquad(|u|\le K/L).\tag{5.7}$$
To prove it uniformly on both sides of the pole, write
$R(x)=\psi(x)-x\ll xe^{-a\sqrt{\log x}}$ and apply Stieltjes integration.
For $u>0$ the infinite $R$-integral is $-A'(u)$ directly. For either sign,
put $x=e^y$ and Taylor-expand $e^{-uy}$ only through
$N=\lfloor a\sqrt L/8\rfloor$. On $0\le y\le L$, $|uy|\le K$ and the remainder
is $O_K(K^{N+1}/(N+1)!)$. For $j\le N$,
$$\int_L^\infty e^{-a\sqrt y}y^j\,dy
\ll L^{j+1/2}e^{-a\sqrt L};$$
after multiplication by $|u|^j/j!$ these tails sum to
$O_K(e^{-c_K\sqrt L})$. The full moments are the Taylor coefficients of the
analytic function $-A'(u)$, proving (5.7). This optimal-truncation step is
essential: fixed-order moment asymptotics alone cannot simply be resummed.

Substituting (5.7) into (5.6), the first term integrates to
$\mathrm{Ein}(\lambda)$ and the second to $-A(\lambda/L)$, proving the closed
form. Finally,
$$A(s)=\gamma s-\left(\gamma_1+\frac{\gamma^2}{2}\right)s^2
+\left(\frac{\gamma_2}{2}+\gamma\gamma_1+\frac{\gamma^3}{3}\right)s^3+\cdots,$$
which proves the displayed coefficient and the entire Stieltjes correction
ladder. $\square$

---

## 6. Numerical verification

All computations are reproducible from `code/exp9_crossover_L.py` (original experiment) and were re-run and extended for this draft (products over exact prime lists to $z=10^6$; sieved to $z=10^8$ for the second-order test). Machine-checks of the special-function identities: $\mathrm{Ein}$ by quadrature vs. $\gamma+\log\lambda+E_1(\lambda)$ ($\lambda>0$) and $\gamma+\log|\lambda|-\mathrm{Ei}(|\lambda|)$ ($\lambda<0$) agree to $\le3\cdot10^{-16}$.

**Theorem 3 (scaling law).** Ratios $R_z(\beta_z,k)$ (exactly $H$-independent, Prop. 2); Richardson extrapolation in $1/\log z$ from $z=10^5,10^6$:

| $k$ | $\lambda$ | $z=10^3$ | $10^4$ | $10^5$ | $10^6$ | extrap. | predicted $e^{-(k-1)\mathrm{Ein}(\lambda)}$ |
|---|---|---|---|---|---|---|---|
| 2 | $-1$ | 3.46323 | 3.51420 | 3.55264 | 3.58127 | 3.72442 | 3.73558 |
| 2 | $0.5$ | 0.66742 | 0.66145 | 0.65765 | 0.65502 | 0.64185 | 0.64157 |
| 2 | $1$ | 0.48788 | 0.47910 | 0.47361 | 0.46985 | 0.45106 | 0.45086 |
| 2 | $2$ | 0.31250 | 0.30141 | 0.29464 | 0.29006 | 0.26719 | 0.26733 |
| 3 | $-1$ | 11.99398 | 12.34960 | 12.62126 | 12.82550 | 13.84670 | 13.95453 |
| 3 | $0.5$ | 0.44545 | 0.43752 | 0.43251 | 0.42905 | 0.41177 | 0.41161 |
| 3 | $1$ | 0.23802 | 0.22954 | 0.22431 | 0.22076 | 0.20303 | 0.20327 |
| 3 | $2$ | 0.09766 | 0.09085 | 0.08681 | 0.08414 | 0.07076 | 0.07147 |

All eight cases land on the prediction to 3–4 decimals after extrapolation; the residual $\sim10^{-4}$–$10^{-3}$ is the $O(1/\log^2z)$ term that Richardson in $1/\log z$ does not remove, consistent with Theorem 4's error term.

**Theorems 4–5 (finite-size ladder).** Exact $D_z(\lambda)$ against $\mathrm{Ein}(\lambda)-\gamma\lambda/\log z$; recall the prediction $(D_z-\mathrm{Ein}(\lambda))\log z\to-\gamma\lambda=\mp0.57722\ (\lambda=\pm1)$, $-1.15443\ (\lambda=2)$:

| $\lambda$ | quantity | $z=10^4$ | $10^5$ | $10^6$ | $10^7$ | $10^8$ | predicted |
|---|---|---|---|---|---|---|---|
| $1$ | $(D_z-\mathrm{Ein})\log z$ | $-0.55954$ | $-0.56684$ | $-0.57014$ | $-0.57135$ | $-0.57213$ | $-0.57722$ |
| $1$ | residual $\times\log^2z$ | $0.163$ | $0.119$ | $0.098$ | $0.094$ | $0.094$ | bounded |
| $-1$ | $(D_z-\mathrm{Ein})\log z$ | $0.56266$ | $0.57808$ | $0.58280$ | $0.58274$ | $0.58220$ | $0.57722$ |
| $-1$ | residual $\times\log^2z$ | $-0.134$ | $0.010$ | $0.077$ | $0.089$ | $0.092$ | bounded |
| $2$ | $(D_z-\mathrm{Ein})\log z$ | $-1.10512$ | $-1.11973$ | $-1.12749$ | $-1.13154$ | $-1.13440$ | $-1.15443$ |
| $2$ | residual $\times\log^2z$ | $0.454$ | $0.400$ | $0.372$ | $0.369$ | $0.369$ | bounded |

The first-order coefficient converges to $-\gamma\lambda$. The rescaled residual
converges, by Theorem 5, to
$(\gamma_1+\gamma^2/2)\lambda^2=0.0937731164\ldots\lambda^2$; the earlier
$0.0925$ estimate was finite-$z$ bias. `code/exp23_third.py` independently
checks the coefficient, the next Stieltjes term, and the closed form to $z=10^8$.
The Mertens constant enters as claimed: the independent check
$\sum_{p\le10^6}\log p/p-\log(10^6)=-1.331925$ against
$-\gamma-\sum_p\frac{\log p}{p(p-1)}=-1.332582$ (literature value
$-1.3325822757\ldots$).

---

## 7. Related work and novelty assessment

The searches below (August 2026; queries combining the concepts pairwise and by function-identity) found **no statement of Theorems 3–4 in any guise, and no deformation of the Hardy–Littlewood singular series by a temperature/KMS parameter**. We list everything relevant found, and why it is or is not prior art.

1. **Bost–Connes phase transition** [BC95]; Neshveyev's ergodicity proof ([arXiv:math/0002141](https://arxiv.org/abs/math/0002141)); Laca–Raeburn's Toeplitz-algebra phase diagram ([arXiv:0907.3760](https://arxiv.org/abs/0907.3760)); Laca–Larsen–Neshveyev on number fields; the recent supercritical analyses (e.g. [arXiv:2503.03033](https://arxiv.org/abs/2503.03033)); Cuntz's $Q_{\mathbb N}$ and Crisp–Laca boundary quotients. These give the KMS classification and the $\beta=1$ transition of the *states* — the deformation parameter and measures $\mu_\beta$ used here are exactly theirs. None computes tuple correlations of sifted indicators under KMS$_\beta$, and none contains a singular-series crossover. *Framework, not prior art.*
2. **Primon/Riemann gas Hagedorn transition** (Julia; Spector; expository accounts, e.g. [the primon-gas literature](https://arxiv.org/pdf/1101.3116)): criticality of $\beta=1$ via divergence of $\zeta(\beta)$ — the partition-function shadow of our Theorem 1, with no correlation content and no scaling window. *Precedent for the critical temperature only.*
3. **Gadiyar–Padma** ([arXiv:hep-th/9806061](https://arxiv.org/abs/hep-th/9806061); Physica A 269 (1999) 503; [Ramanujan–Fourier/Wiener–Khintchine papers](https://eudml.org/doc/262036)): the spectral reading of Hardy–Littlewood as a correlation of the local model. Closest in spirit at $\beta=1$; contains no deformation parameter, no phase transition, no scaling law. *Prior art for the $\beta=1$ identity (as already credited in `notes/ADELIC.md`), not for the deformation.*
4. **Dickman transform identity** $\widehat\rho(s)=e^{\gamma-\mathrm{Ein}(s)}$: classical ([Lagarias, arXiv:1303.1856](https://arxiv.org/abs/1303.1856), §3.1; [Tenenbaum, GSM 163](https://www.ams.org/books/gsm/163/), III.5; [Encyclopedia of Math, "Dickman function"](https://encyclopediaofmath.org/wiki/Dickman_function)). The crossover *function* is therefore a known special function of analytic number theory. This is the most important contact point: it shows our limit function is natural, and it is honestly *prior art for the function, not for the theorem* — no statement connecting it to singular series or KMS deformations exists in the sources found.
5. **Finite Euler products near the pole.** Ramanujan's partial-Euler-product
formula already contains the $\operatorname{Li}/\operatorname{Ei}$ transition;
see the modern account in [Sheth, IMRN 2025](https://doi.org/10.1093/imrn/rnaf214),
Remark 2.6. Gonek's finite-Euler-product work
([arXiv:0704.3448](https://arxiv.org/abs/0704.3448)) and the
Gonek–Hughes–Keating hybrid Euler–Hadamard product give, uniformly near the
pole, a partial product equal to $\zeta(s)$ times an exponential-integral
factor. This is close analytic prior art for Theorem 5: the bare
$\zeta\times E_1$ structure and its Taylor coefficients are established
machinery. What is not found there is the anchored KMS tuple correlator, exact
$H$-cancellation, or the response-law interpretation. The coefficient
$\gamma_1+\gamma^2/2$ is therefore a routine Laurent-jet consequence, not a
standalone novelty claim.
6. **Smooth-number saddle-point analysis** (Hildebrand–Tenenbaum, Trans. AMS 296 (1986); modern refinements, e.g. [arXiv:2408.16576](https://arxiv.org/abs/2408.16576), [arXiv:2409.05761](https://arxiv.org/abs/2409.05761)): the truncated Euler product $\zeta(s,y)=\prod_{p\le y}(1-p^{-s})^{-1}$ analyzed precisely in the regime $(s-1)\log y$ bounded — the same analytic engine as our Lemmas 5.1–5.4, and the deeper reason the Dickman transform appears in both places. *Prior art for the analytic lemma-layer, not for the correlation-theoretic statement.*
7. **Mertens-theorem literature**: quantitative and dissected forms ([Rosser–Schoenfeld]; [\"Mertens' prime product formula, dissected\", Integers 21A (2021)](https://math.colgate.edu/~integers/graham17/graham17.pdf); [Kowalski's exposition](https://blogs.ethz.ch/kowalski/2009/04/25/the-mertens-formula/)); Mertens for Beurling primes ([Cambridge Core](https://www.cambridge.org/core/services/aop-cambridge-core/content/view/ACD8741993142EB30BC9B9C5B04AF890/S0008439500006871a.pdf/on_mertens_theorem_for_beurling_primes.pdf)) and for the Selberg class ([arXiv:1311.0754](https://arxiv.org/abs/1311.0754)). Supplies (3.2)–(3.3); contains no deformed-correlation statement.
8. **Singular-series statistics**: Gallagher's averages; Montgomery–Soundararajan moments; sums of singular series ([arXiv:2301.06095](https://arxiv.org/abs/2301.06095), [Stanford thesis](https://purl.stanford.edu/mz553sv1729)); tails of the singular product ([Functiones et Approximatio](https://projecteuclid.org/journals/functiones-et-approximatio-commentarii-mathematici/volume-56/issue-1/The-tail-of-the-singular-series-for-the-prime-pair/10.7169/facm/1602.pdf), [arXiv:2606.28832](https://arxiv.org/pdf/2606.28832)); distribution of Euler products ([arXiv:0805.4682](https://arxiv.org/abs/0805.4682)). All study $\mathfrak S$ at $\beta=1$ (averages over $H$, tails over $p$); none deforms the measure. *Not prior art.*
9. **Zeros-to-twin-primes correspondences** (Bogomolny–Keating; [arXiv:1903.07057](https://arxiv.org/abs/1903.07057); [arXiv:1208.3374](https://arxiv.org/abs/1208.3374)): a different bridge (archimedean/zero side); no local-measure deformation. *Not prior art.*
10. Direct phrase searches — "deformed singular series", "temperature-deformed primes", "beta-deformed Hardy–Littlewood", KMS + prime tuples, critical temperature + twin primes, exponential integral + singular series — returned nothing relevant beyond the above (queries logged in the session; representative hit lists: [k-tuples surveys](https://arxiv.org/abs/1910.02636), [MathWorld](https://mathworld.wolfram.com/k-TupleConjecture.html), [Grokipedia KMS](https://grokipedia.com/page/KMS_state)).

**Verdict.** The analytic crossover and Stieltjes ladder are close consequences
of established finite-Euler-product machinery. The defensible novelty candidate
is narrower: the trichotomy, exact $H$-cancellation, and universal response law
inside the anchored Bost–Connes/Hardy–Littlewood correlator. This remains a new
statement assembled from known technology pending expert literature review; it
is not evidence toward the prime-tuple conjectures themselves.

---

## 8. What this does and does not mean

**It is a statement about the local model.** $C_{\beta,z}(H)$ is a correlation of coprimality events on $\widehat{\mathbb Z}$, not a count of prime tuples. At $\beta=1$ the local model's predictions coincide with the (unproved) Hardy–Littlewood conjecture; away from $\beta=1$ we know of *no* arithmetic sequence whose tuple statistics the deformed products predict. In particular, nothing here bears on the existence of infinitely many prime tuples, on minor arcs, or on the parity problem (`notes/PARITY.md` §2 locates exactly what the local model cannot see, and that analysis applies verbatim at every $\beta$). The theorems say: *if* one insists on carrying the KMS temperature of the BC system down to the level of sieve-type correlations, *then* criticality is forced (Theorem 1) and the critical window has a universal, explicitly computable scaling theory (Theorems 3–4). The value of the statement is structural: it is the first point in this program where the KMS parameter does quantitative work that the undeformed local model cannot even express, and the answer connects two previously separate appearances of $e^{\gamma}$-type constants (Mertens; Dickman) through the singular series.

**Anchored, not stationary.** For $\beta\ne1$ the measures $\mu_\beta$ are not translation invariant, and (2.2) normalizes at the anchor $0\in H$. A "stationary" alternative — e.g. averaging the anchor over residues, or normalizing by $\prod_h\mu_\beta(\mathbb Z_p^\times-h)$ — changes the local factors at the finitely many $p$ dividing differences of $H$, and (for the averaged version) reintroduces $H$-dependence into the crossover ratio at order $p^{-\beta}-p^{-1}$ per prime. All such variants agree at $\beta=1$ and have the same critical trichotomy (the divergence mechanism is the $(1-p^{-\beta})^{1-k}$ envelope, which no renormalization convention touches); the exact $H$-universality of Proposition 2, however, is a feature of the anchored convention. We regard the anchored form as canonical because it is the direct transcription of the BC correlator $\mu_\beta(e_F\tau_he_F)/\mu_\beta(e_F)^2$ of `notes/ADELIC.md` §1, but the convention-dependence should be stated plainly rather than hidden.

**The deformation is not the zeta distribution.** As noted in §2.1, for $\beta>1$ the diagonal measure is the law of $N\cdot U$ ($N$ zeta-distributed, $U$ a Haar unit), not of $N$ itself; the Haar unit factor is what makes unit classes exactly uniform and the local factors exactly (2.3). Statements in the probabilistic literature about the zeta distribution (e.g. independence of prime valuations, Golomb-type constructions) concern $N$ alone and do not contain (2.3).

**Physical reading, with care.** The trichotomy is a correlation-function version of the Hagedorn phenomenon: above the critical temperature ($\beta<1$) the renormalized pair density diverges, below it ($\beta>1$) it dies at rate $(\log z)^{1-k}$ — the gas is "too cold to correlate at unit density." The scaling combination $\lambda=(\beta-1)\log z$ is a finite-size scaling variable with the cutoff $z$ as system size; $-\mathrm{Ein}(\lambda)$ is then the "free-energy shift per excess tuple point" and the Mertens-constant term $\gamma\lambda(k-1)/\log z$ is the leading finite-size correction. We use this language as bookkeeping, not as physics: no Hamiltonian statistical mechanics of actual primes is implied.

**What would upgrade it.** Three directions would convert the statement from structural to arithmetical. (i) A weighted-count theorem: show that some genuine prime-tuple statistic — e.g. tuple counts weighted by $n^{-(\beta_z-1)}$ up to height $x=z^{O(1)}$, sieved to level $z$ — has the crossover of Theorem 3 as its main-term deformation; the fundamental-lemma regime of sieve theory seems wide enough for the upper-bound half of such a statement. (ii) The graded ($\mathbb Z/2$-parity) extension of `notes/PARITY.md` §2.2: does the crossover law survive, or acquire a sector term, in the parity-graded algebra? (iii) The Beurling test: for a Beurling system with $\zeta_P(s)\sim A/(s-1)$, the same proof gives the same $\mathrm{Ein}(\lambda)$ (the crossover is universal across Beurling systems satisfying a PNT with Mertens-type constants), which suggests the right generality of the statement is "any abstract arithmetic semigroup at its zeta pole" — worth writing down if a referee asks what the theorem depends on: it depends on the pole, and on nothing else about $\mathbb Q$.

---

## References

- [BC95] J.-B. Bost, A. Connes, *Hecke algebras, type III factors and phase transitions with spontaneous symmetry breaking in number theory*, Selecta Math. (N.S.) 1 (1995), 411–457.
- [Nes02] S. Neshveyev, *Ergodicity of the action of the positive rationals on the group of finite adeles and the Bost–Connes phase transition theorem*, Proc. AMS 130 (2002); [arXiv:math/0002141](https://arxiv.org/abs/math/0002141).
- [LR10] M. Laca, I. Raeburn, *Phase transition on the Toeplitz algebra of the affine semigroup over the natural numbers*, Adv. Math. 225 (2010), 643–688; [arXiv:0907.3760](https://arxiv.org/abs/0907.3760).
- [LLN09] M. Laca, N. S. Larsen, S. Neshveyev, *On Bost–Connes type systems for number fields*, J. Number Theory 129 (2009), 325–338.
- [HL23] G. H. Hardy, J. E. Littlewood, *Some problems of 'Partitio Numerorum' III: On the expression of a number as a sum of primes*, Acta Math. 44 (1923), 1–70.
- [GP99] H. G. Gadiyar, R. Padma, *Ramanujan–Fourier series, the Wiener–Khintchine formula and the distribution of prime pairs*, Physica A 269 (1999), 503–510; [arXiv:hep-th/9806061](https://arxiv.org/abs/hep-th/9806061).
- [Jul90] B. Julia, *Statistical theory of numbers*, in Number Theory and Physics, Springer Proc. Phys. 47 (1990).
- [Spe90] D. Spector, *Supersymmetry and the Möbius inversion function*, Comm. Math. Phys. 127 (1990), 239–252.
- [HT86] A. Hildebrand, G. Tenenbaum, *On integers free of large prime factors*, Trans. AMS 296 (1986), 265–290.
- [Ten15] G. Tenenbaum, *Introduction to Analytic and Probabilistic Number Theory*, 3rd ed., GSM 163, AMS (2015).
- [Lag13] J. C. Lagarias, *Euler's constant: Euler's work and modern developments*, Bull. AMS 50 (2013), 527–628; [arXiv:1303.1856](https://arxiv.org/abs/1303.1856).
- [MV07] H. L. Montgomery, R. C. Vaughan, *Multiplicative Number Theory I: Classical Theory*, Cambridge (2007).
- [RS62] J. B. Rosser, L. Schoenfeld, *Approximate formulas for some functions of prime numbers*, Illinois J. Math. 6 (1962), 64–94.
- [Gon12] S. M. Gonek, *Finite Euler products and the Riemann hypothesis*,
  Trans. AMS 364 (2012), 2157–2191;
  [arXiv:0704.3448](https://arxiv.org/abs/0704.3448).
- [GHK07] S. M. Gonek, C. P. Hughes, J. P. Keating, *A hybrid Euler–Hadamard
  product for the Riemann zeta function*, Duke Math. J. 136 (2007), 507–549.
- Repository companions: `notes/ADELIC.md` (Prop. E0, exp8 verification),
  `notes/PARITY.md` §1(H) (audit), `notes/K2.md` §II (independent derivation),
  `code/exp9_crossover_L.py`, and `code/exp23_third.py` (numerics to $z=10^8$).


---

**Cross-verification note.** Theorem 5 was independently derived by fleet-k2,
Codex, and two proof-audit agents. The original fixed-order derivation had one
real gap—summing asymptotics without uniformity—which the optimal-truncation
argument in §5.5 repairs. The coefficient is verified computationally to
$3\cdot10^{-6}$ at $z=10^8$ in `code/exp23_third.py`.

[^cnt]: **Correction by addition, 2026-08-15 (claude, Erdős lineage; papers sweep).** The count and the labels disagree with the list that follows: the abstract announces "three layers" and then enumerates **four** items, of which two are both labelled **(3)** ("Second-order term" and "Complete finite-size ladder"). Read *four* layers, the last relabelled **(4)**; they correspond to Theorems 1, 3, 4 and 5 of §1 (with Proposition 2 supplying the exact $H$-cancellation that makes layer (2) well posed). No mathematical statement is affected — Theorem 5 is proved in §5.5 and checked in §6 — but a count is a claim, and this one was wrong as written.
