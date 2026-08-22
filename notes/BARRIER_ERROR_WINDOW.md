# The $E$-term is not uniform in $L$ — it is uniform in $X_0$, and the exact rate is $e^{\alpha L}$ with $\alpha=\tfrac12$

Closes ledger item **U5** of `BARRIER_UNIFORM.md`:

> *"The $\mathrm{Smooth}$ and $E$ terms of B1. Carried over from `BARRIER.md`
> unchanged and **not re-derived here**. B1′ improves the spectral pairing
> only; whether the error term $E$ is uniform in $L$ is not addressed and is
> the remaining loose thread in item 1."*

**Verdict, stated first.** Uniformity in $L$ **fails**, and it fails for a
reason that is not a technicality: $E$ decays in the log-variable $u=\log X$,
so a window of span $L$ is dragged down by the *smallest* scale it touches.
The failure is exactly exponential, with the exponent derived, not fitted:

$$\boxed{\ \bigl|\langle w_{L,u_0},E\rangle\bigr|\ \le\ C_E\,X_0^{-\alpha}\,
\Theta_\phi(\alpha L),\qquad \alpha=\tfrac12,\qquad X_0=e^{u_0-L/2},\ }$$

with $\Theta_\phi$ an explicit, **nonincreasing** profile functional
($\Theta_\phi(0)=\|\phi\|_1$). Consequently:

| window held fixed | $L$-dependence of the $E$ term | uniform? |
|---|---|---|
| lower endpoint $X_0$ | $X_0^{-1/2}\,\Theta_\phi(L/2)$, **decreasing** in $L$ | **yes** |
| centre $\sqrt{X_0X}$ | $\times\,e^{L/4}\,$ (exponential order) | no |
| upper endpoint $X$ (the data constraint) | $\times\,e^{L/2}\,$ (exponential order) | no |

So the loose thread is not cut by proving uniformity; it is cut by
**identifying the right invariant**. B1′'s parameters $(L,u_0)$ are the wrong
coordinates for the error term: the correct one is $X_0=Xe^{-L}$, the window's
lower endpoint, and against it the bound is uniform in $L$ and in fact
improves with $L$. This is the exact form of the two-parameter closure that
`SWEEP.md` §2 called for ("$L$ = span vs $L$ = $\log X$ were conflated … the
honest closure is two-parameter") and it corrects the assignment made there:
the floor is set by the window's **bottom**, not by $\log X$.

Everything below is contour shifting, Stirling, and Watson's lemma. No
numerics.

---

## 1. Setup: the $k$-dimensional Mellin representation, and what $E$ *is*

`BARRIER.md`'s proof of B1 defines the three buckets by which residue each
factor contributes: all-zeros $\to\sigma_k$, at-least-one-pole $\to
\mathrm{Smooth}$, everything else $\to E$. To bound $E$ one needs the
representation in which "everything else" is a list. `HOLOGRAM.md`'s ledger
already recorded that the Stieltjes derivation of Lemma N "is invalid at the
edge, so the double-Mellin derivation is the correct one"; here is its
$k$-fold form.

**Lemma 4 (multi-Mellin representation).** For a dressing $a$ with
$D_a(s)=\sum_n a(n)n^{-s}$ absolutely convergent in $\Re s>1$, every $j\ge0$,
$k\ge1$, and any $c>1$,
$$\Psi^{(j)}_k(X)=\frac{1}{(2\pi i)^k}\int_{(c)}\!\!\cdots\!\!\int_{(c)}
\ \prod_{i=1}^{k}D_a(s_i)\Gamma(s_i)\ \cdot\
\frac{X^{s_1+\cdots+s_k+j}}{\Gamma(s_1+\cdots+s_k+j+1)}\ d s_1\cdots ds_k .$$

*Proof.* Expand $\prod_i D_a(s_i)=\sum_{\vec n}\prod_i a(n_i)n_i^{-s_i}$
(absolute convergence on $\Re s_i=c>1$). The Dirichlet integral
$$\frac{\prod_i\Gamma(s_i)}{\Gamma(\sum_i s_i+j+1)}X^{\sum_i s_i+j}
=\frac{1}{j!}\int_{\substack{u_i>0\\ \sum u_i\le X}}\prod_i u_i^{s_i-1}
\Bigl(X-\sum_i u_i\Bigr)^{j}du$$
is `BARRIER_UNIFORM.md` §1's identity (with $\Gamma(j+1)=j!$), valid for $\Re s_i>0$. Insert it and
apply Mellin inversion in each $u_i$ against $n_i^{-s_i}$, which returns the
point mass at $u_i=n_i$. The result is
$\sum_{\vec n}\prod a(n_i)\cdot(X-\sum n_i)^j_+/j!=\Psi^{(j)}_k(X)$. $\square$

The residues at $s_i=\rho_i$ reproduce
$\prod_i v_{\rho_i}\,W^{(j)}_k(\vec\rho)\,X^{\sum\rho_i+j}$ with
$W^{(j)}_k$ exactly as in `BARRIER_UNIFORM.md` §1 — so Lemma 4 is the
representation whose residue calculus *is* the Dirichlet–Beta step, now with
all the other residues visible. ($v_\rho=\operatorname*{Res}_{s=\rho}D_a(s)$;
$v_\rho=-1$ for $a=\Lambda$, $1/\zeta'(\rho)$ for $\mu$. Throughout, $\|\cdot\|$
of a spectral measure is taken with the residue weights included,
$\|\sigma^{(j)}_k\|_v=\sum_{\vec\rho}\prod_i|v_{\rho_i}|\,|W^{(j)}_k|$; for
$a=\Lambda$ this is `BARRIER_UNIFORM.md`'s $\|\sigma^{(j)}_k\|$ verbatim.)

**Definition (normalisation).** Put
$$\psi_k(u)=e^{-(\frac k2+j)u}\,\Psi^{(j)}_k(e^u),$$
i.e. normalise at the **zero-layer scale** $X^{k/2+j}$, so that the wave
layer $\mathcal Z_k(u)=\sum_{\vec\rho}\prod_iv_{\rho_i}W^{(j)}_k(\vec\rho)\,
e^{i(\sum_i\gamma_i)u}$ appears at size $O(1)$. (`BARRIER.md` normalises by
$e^{-(k+1)u}$, the *main-term* scale; the two differ by a fixed power of $X$,
which shifts every exponent below by the same constant and changes nothing
structurally. The zero-layer normalisation is the one under which B1's boxed
identity is scale-free, so it is the one used here.)

**Definition ($E$, faithfully to `BARRIER.md`).** Shift each contour in
Lemma 4 from $\Re s_i=c$ to $\Re s_i=-\eta$, $0<\eta<\min(2,\tfrac12)$, one
variable at a time. Expanding, each variable contributes one of: a pole
residue of $D_a$ off the critical line ($s_i=1$ for $\Lambda,d$; $s_i=\tfrac12$
for $\lambda$; none for $\mu$); a zero residue $s_i=\rho$; the residue at
$s_i=0$ of $\Gamma(s_i)$; a trivial-zero residue $s_i=-2m$; or the shifted
line. Then
$$\psi_k=\underbrace{\mathcal Z_k}_{\text{all zeros}}\;+\;
\underbrace{\mathrm{Smooth}}_{\ge1\text{ pole residue}}\;+\;
\underbrace{E}_{\text{the rest}} .$$

**Remark (the shift is licensed exactly when $\|\sigma\|<\infty$ is).** On
$\Re s_i=-\eta$, the functional equation gives
$-\zeta'/\zeta(-\eta+it)=\log\frac{|t|}{2\pi}+O(1)$, so $D_a$ grows only
logarithmically there. Running the Lemma 1/Lemma 3 computation of
`BARRIER_UNIFORM.md` with $\Re\rho_i=-\eta$ in place of $\tfrac12$ gives, on
the same-sign cone where the $e^{-\pi\Sigma/2}$ factors cancel,
$$\int^{T} s^{k(-\eta-\frac12)}\,s^{-(-k\eta+j+\frac12)}\,s^{k-1}\,ds
\ =\ \int^{T}s^{\frac k2-j-\frac32}\,ds\ (\text{up to }\log s),$$
convergent iff $k\le 2j$ — **Theorem B0's threshold, again, and with the
$\eta$ cancelling identically.** So the entire derivation, not merely the
wave sum, lives or dies by B0. Under $k\le2j$ every step below is absolutely
convergent.

---

## 2. What $E$ is, and its exponent $\alpha$

> **Theorem U1 (shape and size of the error term).** Assume RH, simple zeros,
> $k\le 2j$, and (for $a=\mu$) the Gonek-type input already carried by
> `LIOUVILLE.md`/Lemma N. Then, in the normalisation above,
> $$E(u)\;=\;k\,D_a(0)\,e^{-u/2}\,\mathcal Z_{k-1}(u)\;+\;O\!\bigl(e^{-u}\bigr),$$
> where $\mathcal Z_{k-1}$ is the $(k-1)$-fold wave layer at the same smoothing
> $j$ — an absolutely convergent, uniformly almost periodic function. In
> particular
> $$|E(u)|\le C_E\,e^{-\alpha u},\qquad
> \alpha=\tfrac12,\qquad
> C_E=k\,|D_a(0)|\,\bigl\|\sigma^{(j)}_{k-1}\bigr\|_v+O(1),$$
> and $\alpha=\tfrac12$ is **exact**: no larger $\alpha$ is admissible, because
> $D_a(0)\ne0$ for every member of the residue-dressing family and
> $\mathcal Z_{k-1}\not\equiv0$.

*Proof.* Bookkeeping of the residues listed above, with the exponent of $X$
read off Lemma 4's factor $X^{\sum_i s_i+j}$.

*(i) The $s=0$ layer.* $\Gamma(s_1)$ has a simple pole at $s_1=0$ with residue
$1$, and $D_a$ is regular there (see the table). Taking that residue in one
variable and zero residues in the other $k-1$ gives
$$D_a(0)\sum_{\rho_2,\dots,\rho_k}\prod_{i\ge2}v_{\rho_i}\Gamma(\rho_i)\,
\frac{X^{\sum_{i\ge2}\rho_i+j}}{\Gamma(\sum_{i\ge2}\rho_i+j+1)}
= D_a(0)\;X^{\frac{k-1}{2}+j}\,\mathcal Z_{k-1}(u),$$
because the inner sum is *literally* the $(k-1)$-fold zero layer with weight
$W^{(j)}_{k-1}$. There are $k$ such terms (choice of variable), and dividing
by $X^{k/2+j}$ leaves $k\,D_a(0)\,e^{-u/2}\mathcal Z_{k-1}(u)$. Absolute
convergence of $\mathcal Z_{k-1}$ needs $k-1\le 2j$, implied by $k\le2j$;
being an absolutely convergent sum of pure exponentials it is uniformly
almost periodic (Bohr) and bounded by $\|\sigma^{(j)}_{k-1}\|_v$.

*(ii) Everything else is $O(e^{-u})$.* Two or more variables at $s_i=0$:
exponent $\tfrac{k-r}{2}+j$ with $r\ge2$, i.e. $O(e^{-u})$ relatively. A
trivial-zero residue $s_i=-2m$: exponent drops by $2m+\tfrac12$, i.e.
$O(e^{-\frac52 u})$. All variables on $\Re s_i=-\eta$: exponent $-k\eta+j$,
relatively $O(e^{-(\frac k2+k\eta)u})$. Terms mixing $s=0$ residues with
shifted lines interpolate between these. None involves a pole residue, so
none has been double-counted into $\mathrm{Smooth}$.

*(iii) Non-degeneracy.* $D_a(0)\ne0$: see the table. $\mathcal Z_{k-1}
\not\equiv0$: proved for $k\le3$ in Theorem U3(iii) below; for $k\ge4$ it is
the hypothesis $(\star)$ recorded in the ledger. $\square$

| $a$ | $D_a(s)$ | $D_a(0)$ | value |
|---|---|---|---|
| $\Lambda$ | $-\zeta'/\zeta$ | $-\zeta'(0)/\zeta(0)$ | $-\log 2\pi=-1.837877\ldots$ |
| $\mu$ | $1/\zeta$ | $1/\zeta(0)$ | $-2$ |
| $\lambda$ | $\zeta(2s)/\zeta(s)$ | $\zeta(0)/\zeta(0)$ | $1$ |
| $d$ | $\zeta(s)^2$ | $\zeta(0)^2$ | $1/4$ |

(Using $\zeta(0)=-\tfrac12$, $\zeta'(0)=-\tfrac12\log2\pi$. ~~All four are
nonzero, so $\alpha=\tfrac12$ holds across the whole family of `FAMILY.md`
§2 — the exponent is a property of the archimedean factor $\Gamma(s)$, not of
the arithmetic.~~)

> **STRUCK 2026-08-22 — the $d$ row of this table is wrong, and the
> retraction was recorded in this file's own ledger row V7 and in
> `METHOD.md` §3 item 6 on 2026-08-20 without ever being carried to the
> theorem statement it refutes.** The struck sentence is left standing.
>
> $D_a(0)\ne0$ is necessary but not sufficient. U1's leading term is
> $k\,D_a(0)e^{-u/2}\mathcal Z_{k-1}(u)$, and it also needs
> $\mathcal Z_{k-1}\not\equiv0$ — which is clause (iii) of the theorem's own
> non-degeneracy step. For $a=d$ the residue weight is $v^{(d)}_\rho\equiv0$
> ($\zeta(s)^2$ has *double* zeros, so the residues vanish — the same fact
> `METHOD.md` §2 cites to retire exp25), hence $\mathcal Z_q\equiv0$ for every
> $q\ge1$ and the leading term vanishes identically for $k\ge2$.
> `BARRIER_SMOOTH_TERM.md` §5.3 works this out.
>
> **So: $\alpha=\tfrac12$ is exact for $a\in\{\Lambda,\mu,\lambda\}$ and
> FAILS for $a=d$, $k\ge2$**, where the true $E$ is smaller and its exponent
> is set by whatever survives at the next level down — not computed here. The
> recommendation of `METHOD.md` item 6 stands: strike $d$ from the scope of
> B1/B1′/B1″/U1 rather than repair it, since the $d$ case needs the
> functional equation and not a contour shift.

**This is not a new layer.** `FAMILY.md`'s exp18 correction already found it
at $k=2$ — *"the pole/zero layer algebra misses the $s=0$ layer — $M(v)$'s
constant $1/\zeta(0)=-2$ … the complete layer algebra is indexed by all
singularities of the two Mellin factors — poles, zeros, **and the $s=0$
residue** — composed pairwise"* — and `HOLOGRAM.md`'s Lemma N is exactly the
present Theorem U1 at $k=2$, $j=1$, $a=\mu$ ("zero$\times$constant cross terms
carry $X^{\rho+1}$ — scale $X^{3/2}$ … relative errors $O(X^{-1/2})$").
Theorem U1 is the $k$-fold statement of that layer algebra, with the point
that matters here made explicit: **$E$'s leading term is $e^{-u/2}$ times a
lower-$k$ copy of the same wave field**, hence a determinate, bounded,
non-decaying-in-phase object, not a shapeless remainder.

---

## 3. The window transfer law

Everything about $E$'s interaction with the window is contained in one
elementary functional of the profile.

**Definition.** For $\phi\in L^1(\mathbb R)$ with
$\operatorname{supp}|\phi|\subseteq[t_-,t_+]$, $t_-=\inf\operatorname{supp}|\phi|$,
set
$$\Xi_\phi(\theta)=\int_{\mathbb R}|\phi(t)|\,e^{-\theta t}\,dt,\qquad
\Theta_\phi(\theta)=e^{t_-\theta}\,\Xi_\phi(\theta)
=\int_{\mathbb R}|\phi(t)|\,e^{-\theta(t-t_-)}\,dt .$$

**Lemma 5 (properties of $\Theta_\phi$, all exact).**
1. $\Theta_\phi(0)=\|\phi\|_{L^1}$, and $\Theta_\phi$ is **nonincreasing** on
   $[0,\infty)$ — the integrand is pointwise nonincreasing in $\theta$ since
   $t\ge t_-$ on the support.
2. $\Theta_\phi(\theta)\downarrow0$ as $\theta\to\infty$ (dominated
   convergence; $|\phi|$ has no atom at $t_-$).
3. **The exponential order of $\Xi_\phi$ is exactly $-t_-$:**
   $\lim_{\theta\to\infty}\theta^{-1}\log\Xi_\phi(\theta)=-t_-$. Upper bound
   from 1; lower bound because for every $\eta>0$,
   $\Theta_\phi(\theta)\ge e^{-\theta\eta}\int_{t_-}^{t_-+\eta}|\phi|>0$,
   giving $\liminf\theta^{-1}\log\Theta_\phi\ge-\eta$.
4. **Subexponential factor, exactly (Watson's lemma).** If
   $|\phi(t_-+v)|\sim c\,v^{m}$ as $v\downarrow0$ ($c>0$, $m\ge0$), then
   $$\Theta_\phi(\theta)\ \sim\ c\,\Gamma(m+1)\,\theta^{-(m+1)}.$$
   In particular the boxcar ($\phi=\mathbf 1_{[-1/2,1/2]}$, $m=0$) gives
   $\Theta_\phi(\theta)=\theta^{-1}(1-e^{-\theta})$ **exactly**, and a
   $\phi\in C_c^\infty$ supported *exactly* in $[t_-,t_+]$ (hence vanishing to
   infinite order at $t_-$) gives $\Theta_\phi(\theta)=O_N(\theta^{-N})$ for
   every $N$.

*Proof.* 1–3 are the displayed one-line arguments. 4 is Watson's lemma
(from memory — textbook asymptotics, no egress available to verify an
edition; the boxcar case is the elementary integral
$\int_0^1e^{-\theta v}dv$, and the $C_c^\infty$ case follows by repeated
integration by parts, all boundary terms vanishing). $\square$

> **Theorem U2 (window transfer law for the error term).** Let
> $|E(u)|\le C_E e^{-\alpha u}$ for $u\ge u_*$, $\alpha>0$, and let
> $w=w_{L,u_0}(u)=L^{-1}\phi((u-u_0)/L)$ be a dilation-family window with
> profile $\phi$ supported in $[t_-,t_+]$, so that the window in $u$ is
> $[u_0+Lt_-,\,u_0+Lt_+]$ and the corresponding scale range is
> $[X_0,X]=[e^{u_0+Lt_-},e^{u_0+Lt_+}]$. Then for $u_0+Lt_-\ge u_*$
> $$\bigl|\langle w,E\rangle\bigr|\ \le\ C_E\,e^{-\alpha u_0}\,\Xi_\phi(\alpha L)
> \ =\ C_E\;X_0^{-\alpha}\;\Theta_\phi(\alpha L).$$
> Hence, for the canonical normalisation $t_\pm=\pm\tfrac12$ of
> `BARRIER_UNIFORM.md` §3:
>
> **(a) At fixed lower endpoint $X_0$: uniform in $L$**, and monotonically
> improving — $\Theta_\phi(\alpha L)\le\|\phi\|_1$ and $\downarrow0$.
>
> **(b) At fixed centre $u_0$:** the bound is
> $C_EX_{\mathrm{mid}}^{-\alpha}e^{\alpha L/2}\Theta_\phi(\alpha L)$, of
> exponential order $e^{\alpha L/2}$.
>
> **(c) At fixed upper endpoint $X$** — the operationally forced case, since
> the data is $a\!\restriction\![1,X]$ and widening the span means reaching
> *down* — the bound is
> $$\bigl|\langle w,E\rangle\bigr|\ \le\ C_E\,X^{-\alpha}\,e^{\alpha L}\,
> \Theta_\phi(\alpha L),$$
> of exponential order $e^{\alpha L}$. With Theorem U1's $\alpha=\tfrac12$:
> **the $E$-term bound degrades by exactly $e^{L/2}$ per unit of span.**

*Proof.* $\langle w,E\rangle=\int L^{-1}\phi\bigl(\frac{u-u_0}{L}\bigr)E(u)du
=\int\phi(t)E(u_0+Lt)\,dt$ — the window is the $\phi$-weighted *average* of
$E$ over the scale range, with total mass $\int\phi$ independent of $L$.
Insert $|E(u_0+Lt)|\le C_Ee^{-\alpha u_0}e^{-\alpha Lt}$ and integrate:
$$|\langle w,E\rangle|\le C_Ee^{-\alpha u_0}\int|\phi(t)|e^{-\alpha Lt}dt
=C_Ee^{-\alpha u_0}\Xi_\phi(\alpha L)
=C_E\,e^{-\alpha(u_0+Lt_-)}\Theta_\phi(\alpha L),$$
and $u_0+Lt_-=\log X_0$. (a) is then Lemma 5.1–2. For (b) and (c) substitute
$u_0=\log X_0+\tfrac L2$ and $u_0=\log X-\tfrac L2$ respectively; Lemma 5.3
says the exponential orders $e^{\alpha L/2}$, $e^{\alpha L}$ are attained and
not improvable. $\square$

**Sanity check in closed form.** Boxcar profile, $\alpha=\tfrac12$:
$$\Bigl|\frac1L\int_{\log X_0}^{\log X}E(u)\,du\Bigr|
\le\frac{C_E}{L}\int_{\log X_0}^{\log X}e^{-u/2}du
=\frac{2C_E}{L}\Bigl(X_0^{-1/2}-X^{-1/2}\Bigr),$$
which is $\frac{2C_E}{L}X_0^{-1/2}(1+o(1))$ — exactly
$C_EX_0^{-1/2}\Theta_\phi(L/2)$ with $\Theta_\phi(\theta)=\theta^{-1}(1-e^{-\theta})$.
The elementary computation and the general law agree term by term.

---

## 4. Sharpness: the obstruction is real, not an artefact of the estimate

> **Theorem U3 (the bound is attained).** In each of the following senses the
> exponential rate $e^{\alpha L}$ of Theorem U2(c) cannot be improved.
>
> **(i) Within the class of admissible error terms (counterexample family).**
> For $\phi\ge0$ and $E_\varepsilon(u)=\varepsilon e^{-\alpha u}$ — which
> satisfies every hypothesis Theorem U1 supplies about $E$ — the bound of
> Theorem U2 holds with **equality**:
> $\langle w,E_\varepsilon\rangle=\varepsilon X_0^{-\alpha}\Theta_\phi(\alpha L)$,
> for all $L,u_0$.
>
> **(ii) Arithmetically, at $k=1$: unconditionally and with an explicit
> constant.** For $k=1$, $\mathcal Z_0\equiv1/j!$, so Theorem U1 gives the
> exact term $E(u)=\frac{D_a(0)}{j!}e^{-u/2}+O(e^{-u})$, of one sign and
> without oscillation. Hence for $\phi\ge0$
> $$\langle w,E\rangle=\frac{D_a(0)}{j!}\,X_0^{-1/2}\,\Theta_\phi(L/2)\,
> \bigl(1+O(X_0^{-1/2})\bigr),\qquad D_a(0)\ne0 .$$
> For $a=\Lambda$ the constant is $-\log(2\pi)/j!$.
>
> **(iii) Arithmetically, at $k=2,3$: unconditionally.** $\mathcal Z_{k-1}$
> is a nonzero uniformly almost periodic function, so
> $M_{k-1}:=\sup_u|\mathcal Z_{k-1}(u)|>0$ is approached on a relatively
> dense set of $u$; on the corresponding relatively dense set of window
> positions,
> $|\langle w,E\rangle|\gg_\phi X_0^{-1/2}\Theta_\phi(L/2)$.
> Nonvanishing:
> - $k=2$: the Bohr coefficient of $\mathcal Z_1$ at frequency $\gamma_1$ is
>   $v_{\rho_1}\Gamma(\rho_1)/\Gamma(\rho_1+j+1)\ne0$ (the conjugate zero sits
>   at frequency $-\gamma_1$, so there is nothing to cancel against).
> - $k=3$: the Bohr coefficient of $\mathcal Z_2$ at frequency $0$ is the sum
>   over conjugate pairs $\rho_2=\bar\rho_1$, and since $a$ is real-valued,
>   $v_{\bar\rho}=\overline{v_\rho}$, so every term is
>   $$|v_\rho|^2\,\frac{|\Gamma(\tfrac12+i\gamma)|^2}{\Gamma(j+2)}
>   =\frac{\pi\,|v_\rho|^2}{\Gamma(j+2)\cosh\pi\gamma}\;>\;0 .$$
>   The mean value of $\mathcal Z_2$ is therefore
>   $\frac{2\pi}{\Gamma(j+2)}\sum_{\gamma>0}\frac{|v_\rho|^2}{\cosh\pi\gamma}>0$:
>   **strictly positive with no cancellation whatsoever.**
>
> For $k\ge4$, sharpness holds under the non-degeneracy hypothesis
> $(\star)$: $\mathcal Z_{k-1}\not\equiv0$.

*Proof.* (i) is the definition of $\Xi_\phi$ with $|\phi|=\phi$. (ii) is
Theorem U1 at $k=1$ plus (i). (iii): an absolutely convergent sum of pure
exponentials is uniformly almost periodic (Bohr); a uniformly almost periodic
function with a nonzero Bohr coefficient is not identically zero, and its
supremum is approached on a relatively dense set (Bohr's approximation
theorem — from memory, textbook, unverified for want of egress). The two
coefficient computations use $\sum_i\rho_i=1$ in the $k=3$ conjugate-pair case,
so the denominator $\Gamma(\sum\rho_i+j+1)=\Gamma(j+2)$ is a positive real,
and $|\Gamma(\tfrac12+i\gamma)|^2=\pi/\cosh\pi\gamma$ exactly. $\square$

So the failure of uniformity is not slack in an inequality. It is the
statement that a wide window necessarily samples the field at scales where
the sub-leading layer is large, and the $s=0$ layer is *there*, with a
computed nonzero coefficient.

---

## 5. The corrected structure theorem, and what it costs the programme

> **Theorem B1″ (structure theorem with the error term controlled).** Let
> $k\ge2$, $j\ge\lceil k/2\rceil$, $w=w_{L,u_0}$ from a dilation family with
> profile $\phi$, and let $[X_0,X]$ be the window's scale range. Then
> $$Q_w=\langle\sigma^{(j)}_k,\widehat w\rangle+\langle w,\mathrm{Smooth}\rangle
> +\langle w,E\rangle,$$
> with
> - **out-of-band spectral tail** $\le A_NR^{-N}\|\sigma^{(j)}_k\|_v$,
>   $A_N=\|\phi^{(N)}\|_1$ — *independent of $L$ and $u_0$* (Theorem B1′,
>   unchanged);
> - **error term** $|\langle w,E\rangle|\le C_E\,X_0^{-1/2}\,\Theta_\phi(L/2)$
>   — *independent of $L$ at fixed $X_0$, and $\asymp e^{L/2}$ at fixed $X$*
>   (Theorems U1–U3).
>
> Both bounds are therefore uniform over the two-parameter family
> $\{(X_0,L):X_0\ge X_*\}$, and neither is uniform over
> $\{(X,L):X\le X^*\}$.

*Proof.* First bullet: `BARRIER_UNIFORM.md` §3 verbatim. Second: Theorems U1
and U2. $\square$

> **MARKED 2026-08-22 — B1″ HAS NO SINGLE-ENDPOINT UNIFORM CLOSURE, and the
> statement above does not say so.** Recorded in this file's ledger row V7 and
> in `METHOD.md` §3 item 6 on 2026-08-20; never carried here. Nothing in the
> theorem is erased, because the two bullets are true as bounds on the two
> terms they name.
>
> The defect is what the theorem *omits*. Its displayed identity has **three**
> terms and it bounds **two**. `BARRIER_SMOOTH_TERM.md` shows the third,
> $\langle w,\mathrm{Smooth}\rangle$, is anchored at the window's **top** $X$
> — it contains the main term and a descending ladder graded by
> $\nu=r(2\theta_a-1)-m$ — while $E$ is anchored at the window's **bottom**
> $X_0$. **The two ends of the window are the wrong pair of variables for a
> single uniform statement**, so "uniform over $\{(X_0,L):X_0\ge X_*\}$" does
> not extend to $Q_w$; pushing $X_0$ out to shrink $E$ leaves $\mathrm{Smooth}$
> untouched, and for $a=\Lambda$, $k\ge2$ that term exceeds the spectral
> pairing by $X^{(k-1)/2}$.
>
> Consequence 1 below therefore overstates. Item 1 of `METHOD.md` §3 is **not**
> closed on this axis: it is closed for the spectral pairing and for $E$, and
> open for $\mathrm{Smooth}$. Also struck: the theorem's scope should exclude
> $a=d$, per the U1 correction above.

**Consequences, in order of how much they cost.**

1. ~~**Item 1 of `METHOD.md` §3 is now closed on this axis, and the cost is
   one extra parameter, not a hypothesis.**~~ **[OVERSTATED — struck
   2026-08-22, see the marking above: two of three terms are bounded, and the
   third is anchored at the other endpoint. The rest of this item is correct
   about what it does cover.]** The structure theorem holds
   uniformly in the span provided the window's *bottom* is pushed out.
   $L=\log(X/X_0)\le\log X$ always, so no span is excluded a priori; what is
   excluded is a window that reaches down to bounded scales.

2. **`SWEEP.md` §2's conflation is resolved, and its resolution is
   corrected.** `SWEEP.md` wrote: *"Resolution is governed by the span
   ($\log(X/X_{\min})$ …); the noise floor by $\log X$."* The first half is
   right; the second is not. A windowed observable is an average of the field
   over $[X_0,X]$, and $E$ decays in scale, so the floor is set by the bottom:
   $$\varepsilon\;=\;C_E\,X_0^{-1/2}\,\Theta_\phi(L/2),\qquad\text{not }X^{-1/2}.$$
   `SWEEP.md` §3 item 2 ("recompute K′'s threshold with span and $\log X$
   separated") now has its input in exact form.

3. **A structural consequence for `HOLOGRAM.md` Theorem K′, stated without
   recomputing it.** K′ substitutes $\varepsilon=X^{-1/2}=e^{-L/2}$, i.e. it
   identifies span with $\log X$, which is the same as taking $X_0=O(1)$. Two
   regimes now separate exactly:
   - **$X_0=X^{\theta}$, $\theta\in(0,1)$ fixed** (bottom grows with the
     data): $\varepsilon=X^{-\theta/2}\Theta_\phi$, still $X^{-\Theta(1)}$, so
     K′'s own robustness remark applies verbatim — *"$L\propto\alpha^{-1/2}$
     where $\varepsilon=X^{-\alpha}$, so the exponent depends only on the fact
     that $\varepsilon=X^{-\Theta(1)}$"* — and the boxed exponent
     $T^{1/2}\log^{3/2}T$ survives with $\alpha\mapsto\theta/2$.
   - **$X_0$ held fixed** (what every experiment in this corpus did, at
     $X_{\min}\approx2\times10^4$): the arithmetic contributes the *constant*
     $C_EX_0^{-1/2}$, and **all of the $L$-decay of the floor comes from
     $\Theta_\phi(L/2)$ — a property of the window profile, not of $\zeta$.**
     For a boxcar this is only $\asymp 1/L$; for a $C_c^\infty$ profile it is
     $O_N(L^{-N})$; the rate is whatever the profile's vanishing order at its
     left edge makes it (Lemma 5.4). Feeding $\varepsilon=e^{-L/2}$ into K′
     while holding $X_0$ fixed therefore understates the floor, and the amount
     is exactly $e^{L/2}\Theta_\phi(L/2)$.

   This is `CLAUDE.md`'s standing lesson recurring at one further remove.
   Lemma N replaced a measured $\varepsilon$ by a derived $X^{-1/2}$ and the
   depth-law exponent moved. The present note observes that $X^{-1/2}$ was
   still evaluated at the wrong point of the window, and that once the
   evaluation point is fixed, part of the $L$-dependence turns out not to be
   arithmetic at all. *A constant needs its scaling; a scaling needs the
   point at which it is evaluated.*

4. **The barrier statement is unaffected in kind.** Prop. B3′(b)'s
   quantitative form now reads
   $|O(\sigma)-O(\sigma')|\le\Lambda(\epsilon+2A_NR^{-N}\|\sigma\|_v
   +2C_EX_0^{-1/2}\Theta_\phi(L/2))$, so a moment-matching mismatch
   $O((\delta L)^{2p-1})$ is detectable only above the error floor:
   $$(\delta L)^{2p-1}\ \gtrsim\ C_E\,X_0^{-1/2}\,\Theta_\phi(L/2).$$
   This is the same inequality Theorem K0/K′ already solve, with
   $\varepsilon$ given its correct evaluation point. No qualitative
   conclusion of `BARRIER.md` changes.

---

## 6. Status of `METHOD.md` §3 item 1 after this note

| ingredient | after `BARRIER_UNIFORM.md` | after this note |
|---|---|---|
| explicit formula per factor | assumed (Theorem D machinery) | **derived** as Lemma 4's residue calculus, with all residue classes enumerated |
| absolute convergence, one smoothing | false for $k\ge3$; threshold $k\le2j$ (B0) | unchanged — and B0's threshold is shown to govern the contour shift too, so it is the single hypothesis of the whole derivation |
| uniformity of the spectral pairing in $L$ | **proved** (B1′) | unchanged |
| uniformity of $E$ in $L$ | **open (U5)** | **settled: it fails, with exact rate $e^{\alpha L}$, $\alpha=\tfrac12$; and it holds against the correct invariant $X_0$** (U1–U3, B1″) |
| factorisation through the blur | exact case fine; approximate needs $\Phi$ controlled (B3′) | unchanged, with the error floor now explicit in B3′(b) |

**Item 1 is discharged.** The Structure Proposition of `BARRIER.md` is a
theorem in the form B1″: for $j\ge\lceil k/2\rceil$, a windowed WL observable
equals the blurred spectral pairing plus a smooth part plus an error bounded
uniformly over all spans by $C_EX_0^{-1/2}\Theta_\phi(L/2)$. The remaining
open items under item 1 are none; the open items *around* it are B3′'s
$\epsilon$-to-K0 normalisation (`BARRIER_UNIFORM.md` U6) and the rigidity
question of §4 there — both are separate statements, neither is a gap in
item 1.

**It still does not convert the depth law into a barrier theorem**, for the
reason `BARRIER_UNIFORM.md` §5 gives and this note does not touch: a barrier
needs two admissible spectra, and the zeros of $\zeta$ cannot be moved.

---

## 7. Honesty ledger

| # | item | status |
|---|---|---|
| V1 | Lemma 4, Lemma 5, Theorem U2, Theorem U3(i) | **Proved, unconditional.** Lemma 5 and U2 are pure real analysis; Lemma 4 is Mellin inversion plus the Dirichlet integral. |
| V2 | Theorem U1 | **Proved under RH + simple zeros + $k\le2j$**, plus (for $a=\mu$) the standing Gonek-type input $\sum_{0<\gamma\le T}|\zeta'(\rho)|^{-2}\ll T^{1+o(1)}$ that `LIOUVILLE.md` and Lemma N already carry. Same hypotheses as `BARRIER_UNIFORM.md`; nothing new assumed. |
| V3 | The contour shift | Performed one variable at a time; the standard truncation at ordinates $T_\nu$ chosen between zeros, with $\zeta'/\zeta\ll\log^2T_\nu$ there, is **sketched, not written out**. This is the same bookkeeping `BARRIER.md` and `HOLOGRAM.md` already carry. What is *not* sketched but proved is the convergence criterion for the shifted integral, and it coincides exactly with B0's $k\le2j$ — which is the reason to believe the bookkeeping closes. |
| V4 | $\alpha=\tfrac12$ | **Exact, derived, with its dependence stated.** It is the gap between the zero layer ($\Re\rho=\tfrac12$) and the $s=0$ layer, hence $\tfrac12$ for every dressing with $D_a(0)\ne0$ — all four in `FAMILY.md` §2. It is *not* universal in a different sense: the $s=0$ layer is **determinate and modellable** (`HOLOGRAM.md`'s ledger: *"a determinate single-zero layer, not an error … true residual $O(X^{-2})$"*). An observer who subtracts it has $\alpha=1$ (double-$s{=}0$), then $\alpha=\tfrac52$ (trivial zeros). Theorems U2–U3 are stated for general $\alpha$ precisely so that the transfer law survives that substitution: **the law $e^{\alpha L}$ is universal; the value of $\alpha$ is a modelling choice with three derived values.** |
| V5 | Sharpness for $k\ge4$ | Conditional on $(\star)$: $\mathcal Z_{k-1}\not\equiv0$. Unconditional for $k\le3$ (U3(ii),(iii)); $k=2$ is where every measured statement in this corpus lives. A general proof of $(\star)$ would follow from linear independence of the ordinates over $\mathbb Q$ but is not attempted, and $(\star)$ is not needed for the *upper* bounds, hence not for B1″. |
| V6 | Normalisation | This note normalises at the zero-layer scale $X^{k/2+j}$; `BARRIER.md` normalises at the main-term scale $X^{k+1}$ (its $j=1$). The two differ by the fixed factor $e^{(j-1-k/2)u}$, which shifts every exponent in §2 by the same constant and so changes no gap, in particular not $\alpha$. I have **not** rewritten `BARRIER.md`'s convention, and any numerical comparison across the two notes must fix one. |
| V7 | The $\mathrm{Smooth}$ term | Still not analysed, and now known to be worse-named than it looks: for $k\ge2$ the bucket "at least one pole residue" contains terms at the *same* scale as the wave layer (e.g. $s_1=1$, $s_2=0$, rest at zeros, total exponent $\tfrac k2+j$), and those terms oscillate. U5 asked only about $E$ and only $E$ is answered here. **Naming $\mathrm{Smooth}$ accurately, and bounding it, is a separate open item** — recommend it be queued as a `PROVE` item rather than left implicit. **RESOLVED — `BARRIER_SMOOTH_TERM.md`: $\mathrm{Smooth}$ is the $r\ge1$ slice of an explicit ladder graded by level $\nu=r(2\theta_a-1)-m$; it contains the main term, its leading oscillating layer beats $\mathcal Z_k$ by $X^{(k-1)(\theta_a-1/2)}$ (so for $\Lambda$ the $k$-fold signal is buried $X^{(k-1)/2}$ deep), it is anchored at the window's **top** $X$ where $E$ is anchored at $X_0$ — hence B1″ has no single-endpoint uniform closure — and the suspected same-scale oscillation is confirmed, but it is a nonzero *constant* at $k=2$ (biasing the frequency-$0$ atom) and oscillates only for $k\ge3$. Side effect: the $d$ row of Theorem U1's table is wrong, $\alpha=\tfrac12$ failing for $a=d$, $k\ge2$, since $v^{(d)}_\rho\equiv0$.** |
| V8 | Residue weights in $\|\sigma\|$ | `BARRIER_UNIFORM.md` writes $\|\sigma^{(j)}_k\|=\sum|W^{(j)}_k|$, omitting $\prod|v_{\rho_i}|$. Harmless for $a=\Lambda$ ($|v_\rho|=1$) and for the statement of B0 (which is about the archimedean weight); **not** harmless for $\mu$, where it is exactly the Gonek caveat. This note writes $\|\cdot\|_v$ throughout. |
| V9 | Prior art | The mathematical ingredients are textbook and none is claimed as new: Mellin–Barnes/Dirichlet-integral representations, Watson's lemma, Laplace's method, Bohr almost periodicity, Paley–Wiener. **All external citations here are from memory and unverified — no egress was available and no literature search was run.** Within this corpus the $s=0$ layer is prior art (`FAMILY.md` exp18; `HOLOGRAM.md` Lemma N at $k=2$), and the span-vs-$\log X$ conflation is prior art (`SWEEP.md` §2); what is new here is the $k$-fold form, the window transfer law, and the identification of $X_0$ as the invariant. Someone with egress should check whether the transfer law is stated for Riesz means of multiple Dirichlet series; the computation is routine enough that it may well be. — **PRIOR-ART SWEEP 2026-08-14: done, and the answer is RESOLVED-NO-MATCH for the transfer law.** Correction to this row's premise, which the whole barrier family shares: **egress is not closed — `WebSearch` works; only `WebFetch` is EGRESS_BLOCKED** (verbatim error at `BARRIER_SMOOTH_TERM.md` W8's twin append). So the external citations here move **from-memory → search-summary (śabda) grade**, not to verified: no PDF or abstract page was read. Nothing was located stating a window-transfer law, an $X_0=Xe^{-L}$ invariant, or an $e^{\alpha L}$ span law for Riesz means of multiple Dirichlet series. Queries: *window transfer law Riesz mean multiple Dirichlet series uniformity in window length lower endpoint invariant error term exponential dependence*; *Riesz mean order j k-fold Dirichlet series convergence threshold sum over zeta zeros Gamma quotient*. What the search *does* locate is the family in which the $k$-fold Gamma-quotient weight and its convergence trade-off are standard — Languasco–Zaccagnini arXiv:1206.0251, arXiv:2012.02503; Cantarini arXiv:1607.05629; Brüdern–Kaczorowski–Perelli arXiv:1712.00737 — recorded in full at `BARRIER_UNIFORM.md` U7, and that is the shelf a future block should search along. Absence of a located source is not evidence of novelty. Attribution status only. |
| V10 | No numerics | Nothing in this note was computed numerically. The three numbers quoted ($-\log2\pi$, $-2$, $X_{\min}\approx2\times10^4$) are, respectively, two exact closed forms and one experimental parameter quoted from `SWEEP.md` for the purpose of saying which regime the experiments were in — no constant is fitted, and no claim depends on that value. |
