# Leakage is blindness; and the sieve's vanishing criterion is vacuous

**Author:** SEED-52 (Jyeṣṭhadeva lens: the *yukti* is the object), 2026-08-14.
**Status:** exact. Three derivations written out in full, each of which changes
the statement it was derived from. Nothing measured, nothing fitted.

**Reads:** `notes/PROJECTION_LEAKAGE.md` (the target),
`notes/SEED21_CHECK_CAPACITY_IS_AN_INDEX.md`,
`notes/SEED32_INDEX_CAPACITY_RADIUS.md`,
`machinery/test_vacuity_certificates.py` (as text — Python is banned; it was
read, not run), `notes/SEED12_SYMMETRIC_REPAIR_UNIQUENESS_FAILS.md` §4,
`notes/SEED44_MUQABALA_OPERATOR.md` §0.

---

## 0. Why write derivations that the note "already has"

`PROJECTION_LEAKAGE.md` proves its main theorem and then states four further
results in the imperative mood of a summary: the dual vanishing criterion
("Dually, vanishing is equivalent to …"), the singular-series product
("direct CRT counting gives"), the projection identity
$\|[M,P]\|^2=2\|(1-M)PM\|^2$ (no proof at all), and the closing disclaimer
"For a general $p$, only the multiplier theorem applies."

Each of the three derivations below takes under a page. Each of them, once
written, contradicts or strengthens the sentence it was derived from:

| # | statement in the note | what the derivation shows |
|---|---|---|
| A | two vanishing criteria, one physical one dual | they are **one** statement, an annihilator pair; and the physical one is stated for $w=\mathbf 1_A$ although the proof never uses it |
| B | $\|[M,P]\|^2=2\|(1-M)PM\|^2$ "in this special case"; "for a general $p$, only the multiplier theorem applies" | **false as a restriction.** Idempotence of $P$ is never used. Only $p$ real is used. The identity therefore covers §3's sieve operator, which the note explicitly excludes |
| C | the coset vanishing criterion, applied to the sieve | **vacuous**: $\operatorname{supp}\kappa_W=\mathbb Z/W$ always, so the criterion certifies only $A=\varnothing$ and $A=\mathbb Z/W$ |

C is the third live vacuous certificate in the corpus (§5), which is the point
at which it stops being an accident.

Conventions are those of `PROJECTION_LEAKAGE.md` §1 throughout: $G$ finite
abelian of order $N$, $\mathbb E$ the normalised mean, $\widehat f(\chi)=
\mathbb E_x f(x)\overline{\chi(x)}$, $\kappa(r)=\sum_\chi p(\chi)\chi(r)$,
$P_pf=\kappa*f$, $M_wf=wf$, $[M_w,P_p]=M_wP_p-P_pM_w$.

---

## 1. Derivation A: the two criteria are one, and it is Pontryagin duality

### 1.1 The step the note compresses

The note's proof says: "The vanishing criteria follow because every summand is
nonnegative." That justifies reading the *physical* criterion off the physical
sum. It does not produce the dual criterion, because the dual criterion is
indexed by $\eta\in\operatorname{supp}\widehat{\mathbf 1_A}$ and $\psi\in
\widehat G$, whereas the spectral sum is indexed by the *pair* $(\chi,\psi)$.
A change of summation variable is required, and it is the whole content.

### 1.2 The change of variable, written out

Start from the spectral Hilbert–Schmidt identity of Theorem 2.1,

$$
\|[M_w,P_p]\|_{\mathrm{HS}}^2=\sum_{\chi\in\widehat G}\sum_{\psi\in\widehat G}
|p(\psi)-p(\chi)|^2\,|\widehat w(\chi\psi^{-1})|^2 .
$$

Fix $\psi$ and substitute $\eta:=\chi\psi^{-1}$. For fixed $\psi$ the map
$\chi\mapsto\chi\psi^{-1}$ is a bijection of $\widehat G$ onto itself (its
inverse is $\eta\mapsto\eta\psi$), so summing over $\chi$ is the same as
summing over $\eta$, with $\chi=\eta\psi$:

$$
\|[M_w,P_p]\|_{\mathrm{HS}}^2
=\sum_{\eta\in\widehat G}|\widehat w(\eta)|^2
 \sum_{\psi\in\widehat G}|p(\psi)-p(\eta\psi)|^2 .
\tag{A.1}
$$

Every term of (A.1) is a product of two nonnegative reals. A finite sum of
nonnegative reals is zero iff every term is zero. Hence

$$
[M_w,P_p]=0
\iff
\bigl(\forall\eta\in\operatorname{supp}\widehat w\bigr)
\bigl(\forall\psi\in\widehat G\bigr)\;
p(\eta\psi)=p(\psi).
\tag{A.2}
$$

That is the note's dual criterion — **and the derivation never used
$w=\mathbf 1_A$.** The note states it under the hypothesis "If $w=\mathbf 1_A$",
inherited from the preceding display. The hypothesis is inert: (A.2) holds for
every complex window $w$.

### 1.3 What (A.2) says as a subgroup statement

Let

$$
\Lambda_w:=\langle\operatorname{supp}\widehat w\rangle\le\widehat G,
\qquad
H_\kappa:=\langle\operatorname{supp}\kappa\rangle\le G .
$$

*Claim.* (A.2) $\iff$ $p$ is constant on cosets of $\Lambda_w$, i.e. $p$
factors through $\widehat G/\Lambda_w$.

*Derivation.* ($\Leftarrow$) is immediate since $\operatorname{supp}\widehat w
\subseteq\Lambda_w$. ($\Rightarrow$): let $\lambda\in\Lambda_w$. By definition
of the generated subgroup, $\lambda=\eta_1^{\varepsilon_1}\cdots
\eta_k^{\varepsilon_k}$ with $\eta_i\in\operatorname{supp}\widehat w$ and
$\varepsilon_i=\pm1$. Apply (A.2) $k$ times: writing $\psi_0=\psi$ and
$\psi_i=\eta_i^{\varepsilon_i}\psi_{i-1}$, each step gives
$p(\psi_i)=p(\psi_{i-1})$ — for $\varepsilon_i=+1$ this is (A.2) at
$(\eta_i,\psi_{i-1})$ directly, and for $\varepsilon_i=-1$ it is (A.2) at
$(\eta_i,\psi_i)$ read backwards, since $\eta_i\psi_i=\psi_{i-1}$. Hence
$p(\lambda\psi)=p(\psi_k)=p(\psi_0)=p(\psi)$. $\square$

Dually, the physical criterion of Theorem 2.1 reads: the commutator vanishes
iff $w(x)=w(x-r)$ for all $x$ and all $r\in\operatorname{supp}\kappa$ — again
for general $w$, by the same nonnegativity argument applied to the physical
sum — and the identical generation argument upgrades $\operatorname{supp}
\kappa$ to $H_\kappa$: **$w$ is $H_\kappa$-periodic.**

### 1.4 The two are the same statement

Both criteria are equivalent to $\|[M_w,P_p]\|_{\mathrm{HS}}=0$, hence to each
other; but the equivalence is also visible without the commutator, and seeing
it is the point. For $\Lambda\le\widehat G$ write $\Lambda^\perp=\{x\in G:
\lambda(x)=1\ \forall\lambda\in\Lambda\}$, and for $H\le G$ write
$H^\perp=\{\chi:\chi|_H=1\}$. Then:

- $w$ is $H$-periodic $\iff$ $\operatorname{supp}\widehat w\subseteq H^\perp$.
  *Derivation:* with our convention $\widehat{w(\cdot - h)}(\chi)=
  \mathbb E_x w(x-h)\overline{\chi(x)} = \overline{\chi(h)}\,\widehat w(\chi)$
  (substitute $x\mapsto x+h$ and use $\overline{\chi(x+h)}=
  \overline{\chi(x)}\,\overline{\chi(h)}$). So $w(\cdot-h)=w$ for all $h\in H$ iff
  $(\overline{\chi(h)}-1)\widehat w(\chi)=0$ for all $\chi,h\in H$ — by
  injectivity of the Fourier transform — iff every $\chi$ with $\widehat
  w(\chi)\ne0$ is trivial on $H$.
- $p$ is $\Lambda$-invariant $\iff$ $\operatorname{supp}\kappa\subseteq
  \Lambda^\perp$. *Derivation:* $\kappa(r)=\sum_\chi p(\chi)\chi(r)$ is $N$
  times the inverse transform of $p$; the same computation on $\widehat G$
  (whose dual is $G$, by Pontryagin duality for finite abelian groups) gives
  $p(\lambda\,\cdot)=p$ for all $\lambda\in\Lambda$ iff $\kappa$ is supported
  where every $\lambda\in\Lambda$ is trivial.

So the two criteria are $\Lambda_w\subseteq H_\kappa^\perp$ and
$H_\kappa\subseteq\Lambda_w^\perp$, which are the same condition read from the
two sides of the perfect pairing $G\times\widehat G\to\mathbb C^\times$.

**What the derivation reveals that the statement did not.** (i) Neither
criterion needs $w$ to be an indicator; the note's placement makes both look
like facts about sets. (ii) The two boxed criteria are not two theorems but one
annihilator relation; the only hypothesis actually used is that $G$ is finite
abelian, i.e. that Pontryagin duality is available and $\widehat{\widehat G}=G$.
(iii) The generation step (§1.3) is invisible in the note's phrasing: the
criterion is stated with $\operatorname{supp}\kappa$, but the object that
governs is the *subgroup generated by it*, and the passage from one to the
other is the $k$-fold telescoping above — not a restatement.

---

## 2. Derivation B: idempotence of $P$ is never used

> **Prior art inside the corpus, added by SEED-105 (Rule K1, 2026-08-14) — the
> currency check this note's Reads list omitted.** `notes/LEAKAGE_PAST_IDEMPOTENCE.md`
> (cf-sakshi, 2026-08-14, message 0454 — *earlier* than this note's 0652) already
> drops idempotence of the acted-on operator **in this exact lane**: its Theorem A
> gives $\operatorname{rank}((I-P)AP)=\dim(U+AU)-\dim U$ for arbitrary $A$, and
> its §4 computes the spectral sectors of the very multiplier $P_W$ of §3 below,
> via Hölder's formula, obtaining eigenvalue $\varphi(W/\gcd(h,W))^{-2}$ at
> $h\neq0$ and $0$ at $h=0$ — which is consistent with this note's conventions
> ($\alpha_W^{-2}|\widehat{e_W}(h)|^2=c_W(h)^2/\varphi(W)^2$).
> **This does not duplicate (B.1):** that note's invariant is a *rank*, this
> section's is a *Hilbert–Schmidt norm*, and neither implies the other. What is
> duplicated is the *diagnosis* — "`PROJECTION_LEAKAGE.md`'s exclusion of
> non-idempotent symbols is the wrong boundary, and the sieve multiplier is on
> the near side of it" — which was already on record and should have been cited.
> §6's "Not claimed: no novelty for §2" is thereby strengthened, not weakened.

The note's §2 "Literal projection case" assumes $p=\mathbf 1_\Sigma$ and
$w=\mathbf 1_A$, so that $P$ and $M$ are both orthogonal projections, states
three identities without proof, and closes: *"For a general $p$, only the
multiplier theorem applies."* Write the proof and the closing sentence
falsifies itself.

Assume only:

> **(H1)** $M=M_w$ with $w=\mathbf 1_A$, so $M=M^*=M^2$;
> **(H2)** $P=P_p$ with $p$ **real-valued**, so $P=P^*$.

(H2) holds for the sieve operator of §3: $p_W(\chi)=\alpha_W^{-2}
|\widehat{e_W}(\chi)|^2-\mathbf 1_{\chi=1}$ is real (indeed $\ge0$), so $P_W$
is self-adjoint. It is *not* idempotent, as the note itself stresses.

Put $Y:=(1-M)PM$.

**Step 1 (the decomposition).** Expand, using $M^2=M$ only:
$$
Y^*-Y=\bigl((1-M)PM\bigr)^*-(1-M)PM
= MP^*(1-M)-(1-M)PM
\overset{\text{(H2)}}{=} MP(1-M)-(1-M)PM,
$$
and
$$
MP(1-M)-(1-M)PM = MP-MPM-PM+MPM = MP-PM=[M,P].
$$
So $[M,P]=Y^*-Y$: the commutator is (twice) the anti-Hermitian part of the
corner block. Note where the hypotheses entered: $M^2=M$ in the cancellation of
$MPM$, and (H2) in identifying $Y^*$. **$P^2=P$ was not used.**

**Step 2 (the square).** $Y^2=(1-M)PM(1-M)PM=0$, because $M(1-M)=M-M^2=0$ by
(H1). Taking adjoints, $(Y^*)^2=(Y^2)^*=0$. Hence
$$
[M,P]^2=(Y^*-Y)^2=(Y^*)^2-Y^*Y-YY^*+Y^2=-\bigl(Y^*Y+YY^*\bigr)
=-\bigl(MP(1-M)PM+(1-M)PMP(1-M)\bigr),
$$
using $(1-M)^2=1-M$ and $M^2=M$ to simplify $Y^*Y=MP(1-M)(1-M)PM$ and
$YY^*=(1-M)PMMP(1-M)$. That is the note's second display, verbatim, without
$P^2=P$.

**Step 3 (the norm).** With $\langle S,T\rangle_{\mathrm{HS}}=\operatorname{tr}
(S^*T)$,
$$
\|[M,P]\|_{\mathrm{HS}}^2=\operatorname{tr}\bigl((Y^*-Y)^*(Y^*-Y)\bigr)
=\operatorname{tr}\bigl((Y-Y^*)(Y^*-Y)\bigr)
=\operatorname{tr}(YY^*)-\operatorname{tr}(Y^2)-\operatorname{tr}\bigl((Y^*)^2\bigr)
+\operatorname{tr}(Y^*Y).
$$
The two middle traces vanish by Step 2. The two outer traces are equal:
$\operatorname{tr}(YY^*)=\|Y^*\|^2_{\mathrm{HS}}=\|Y\|^2_{\mathrm{HS}}
=\operatorname{tr}(Y^*Y)$. Therefore
$$
\boxed{\ \|[M_A,P_p]\|_{\mathrm{HS}}^2=2\,\|(1-M_A)P_pM_A\|_{\mathrm{HS}}^2
\quad\text{for every real symbol }p.\ }
\tag{B.1}
$$

**What the derivation reveals.** The note's disclaimer is wrong in the
direction that matters for its own §3. (B.1) says that for the *centred sieve
operator* $P_W$ — real symbol, self-adjoint, not idempotent — the Hilbert–
Schmidt leakage is still exactly twice the squared norm of the off-diagonal
corner $(1-M_A)P_WM_A$, i.e. still *literally* "what $P_W$ moves out of $A$".
The phrase "this is literally projection leakage" applies to the arithmetic
case the note wrote it to exclude. Combining with Theorem 2.1 §3:

$$
\|(1-M_A)P_WM_A\|_{\mathrm{HS}}^2
=\frac1{2W^2}\sum_{h\bmod W}|\mathfrak S_W(h)-1|^2\,|A\mathbin\triangle(A+h)| .
\tag{B.2}
$$

*Check at $W=6$, $A=\{0,1,2\}$ (the note's own §4 instance):* the note computes
$\|[M_A,P_6]\|^2=\tfrac13$, so (B.1) predicts
$\|(1-M_A)P_6M_A\|_{\mathrm{HS}}^2=\tfrac16$. This is a prediction, not a
measurement: it is (B.1) with the note's exact number substituted.

The one hypothesis that *is* load-bearing and is nowhere stated in the note is
**(H2), $p$ real**. Drop it — take $p$ complex, e.g. $p(\chi)=i$ for a single
$\chi$ — and $Y^*=MP^*(1-M)\ne MP(1-M)$, Step 1 collapses, and (B.1) fails.
So the correct hypothesis pair is "$w$ an indicator, $p$ real", not "$w$ and
$p$ both indicators": one of the two idempotence assumptions is essential and
the other is decorative, and the note assumed both.

---

## 3. Derivation C: the sieve kernel has full support, so the coset criterion is vacuous

### 3.1 The singular series, derived

The note says "direct CRT counting gives" the product formula. Written out:
with $e_W=\mathbf 1_{(x,W)=1}$ and $e_W$ real,

$$
(e_W\star e_W)(h)=\mathbb E_x e_W(x)e_W(x+h)
=\frac1W\#\{x\bmod W:\ (x,W)=1\ \text{and}\ (x+h,W)=1\}.
$$

For $W$ squarefree, CRT gives a ring isomorphism $\mathbb Z/W\cong\prod_{p\mid
W}\mathbb Z/p$ under which the two coprimality conditions become, coordinate by
coordinate, $x\not\equiv0$ and $x\not\equiv-h \pmod p$. So the count factors,
$\#=\prod_{p\mid W}c_p(h)$ with

$$
c_p(h)=\#\{x\bmod p:\ x\ne0,\ x\ne-h\}=
\begin{cases}p-1,& p\mid h\quad(\text{the two excluded residues coincide}),\\
p-2,& p\nmid h\quad(\text{they are distinct}).\end{cases}
$$

Since $W=\prod_{p\mid W}p$ and $\alpha_W=\varphi(W)/W=\prod_{p\mid W}
\frac{p-1}{p}$,

$$
\mathfrak S_W(h)=\alpha_W^{-2}(e_W\star e_W)(h)
=\prod_{p\mid W}\frac{c_p(h)}{p}\cdot\Bigl(\frac{p}{p-1}\Bigr)^{2}
=\prod_{p\mid W}\underbrace{\frac{c_p(h)\,p}{(p-1)^2}}_{=:f_p(h)},
$$

i.e. $f_p=\dfrac{p}{p-1}$ when $p\mid h$ and $f_p=\dfrac{p(p-2)}{(p-1)^2}$
when $p\nmid h$, which is the note's display.

### 3.2 The support theorem

> **Theorem C.** Let $W>1$ be squarefree. Then $\mathfrak S_W(h)\ne1$ for
> **every** $h\bmod W$. Equivalently $\kappa_W=\mathfrak S_W-1$ is nowhere
> zero, so $\operatorname{supp}\kappa_W=\mathbb Z/W$ and
> $H_{\kappa_W}=\mathbb Z/W$.

*Derivation.* Let $P$ be the largest prime dividing $W$.

*Case 1: $2\mid W$ and $2\nmid h$.* Then $f_2(h)=\frac{2\cdot(2-2)}{1^2}=0$, so
$\mathfrak S_W(h)=0\ne1$. (This is the parity zero: the note's $\mathfrak S_6=
(3,0,\tfrac32,0,\tfrac32,0)$.)

*Case 2: otherwise.* Then no factor vanishes: $f_p=\frac p{p-1}>0$ always, and
$f_p=\frac{p(p-2)}{(p-1)^2}=0$ only for $p=2$, which is Case 1. So
$\mathfrak S_W(h)\in\mathbb Q^{\times}$ and we may take the $P$-adic valuation
$v_P$, which is a homomorphism $\mathbb Q^\times\to\mathbb Z$; so
$v_P(\mathfrak S_W(h))=\sum_{p\mid W}v_P(f_p(h))$.

- For $p\mid W$ with $p<P$: $f_p$ is a ratio of products of the integers
  $p,\ p-1,\ p-2$, each of which lies in $\{1,\dots,P-1\}$ in this case (they
  are $\ge1$ because $f_p\ne0$, and $\le p\le P-1$). None is divisible by $P$,
  so $v_P(f_p)=0$.
- For $p=P$: if $P\mid h$, $f_P=\frac{P}{P-1}$ and $v_P=1$, since
  $1\le P-1<P$. If $P\nmid h$, $f_P=\frac{P(P-2)}{(P-1)^2}$ with
  $1\le P-2<P$ (using $P\ne2$ here, as $P=2$ with $2\nmid h$ is Case 1), so
  again $v_P=1$.

Hence $v_P(\mathfrak S_W(h))=1$. But $v_P(1)=0$. Therefore
$\mathfrak S_W(h)\ne1$. $\square$

The derivation says more than "$\ne1$": in Case 2 the singular series is
**exactly divisible by $P$ once**, for every $h$. The truncated singular series
never returns to its own mean, and the obstruction is a single prime's
valuation.

### 3.3 The consequence: §3 of the note certifies nothing

Theorem 2.1 gives: leakage vanishes iff $A$ is a union of cosets of
$H_\kappa$. By Theorem C, $H_{\kappa_W}=\mathbb Z/W$, whose only cosets are
$\mathbb Z/W$ itself. So:

> **Corollary C.1 (vacuity).** For every squarefree $W>1$, the coset vanishing
> criterion applied to $P_W$ has exactly two solutions, $A=\varnothing$ and
> $A=\mathbb Z/W$ — the two windows for which $M_A\in\{0,1\}$ and every
> commutator vanishes trivially, for every $P$ whatsoever. The criterion, on
> this family, distinguishes nothing.

Dually (via §1.4): $\Lambda_{\mathbf 1_A}\subseteq H_{\kappa_W}^\perp=\{1\}$
forces $\widehat{\mathbf 1_A}$ to be supported at the trivial character, i.e.
$\mathbf 1_A$ constant.

The non-vacuous replacement is a positivity statement with a bound, and it is
one line from the note's own formula. First,

$$
\sum_{h\bmod W}|A\mathbin\triangle(A+h)|
=\sum_h\sum_x|\mathbf 1_A(x)-\mathbf 1_A(x-h)|
=\sum_h 2\bigl(|A|-|A\cap(A+h)|\bigr)
=2\bigl(W|A|-|A|^2\bigr),
$$

since $\sum_h|A\cap(A+h)|=\sum_h\sum_x\mathbf 1_A(x)\mathbf 1_A(x-h)=|A|^2$.
The $h=0$ term contributes $0$. So with $m_W:=\min_{h\ne0}|\kappa_W(h)|^2>0$
(positive by Theorem C, a minimum over a finite set):

> **Corollary C.2 (the replacement).** For every $A$ with
> $\varnothing\ne A\subsetneq\mathbb Z/W$,
> $$\|[M_A,P_W]\|_{\mathrm{HS}}^2\ \ge\ \frac{2\,m_W\,|A|\,(W-|A|)}{W^{2}}
> \ \ge\ \frac{2\,m_W\,(W-1)}{W^{2}}\ >\ 0 .$$

*Check at $W=6$:* $\kappa_6=(2,-1,\tfrac12,-1,\tfrac12,-1)$, so
$m_6=\tfrac14$; for $A=\{0,1,2\}$ the bound is
$2\cdot\tfrac14\cdot3\cdot3/36=\tfrac18$, and the note's exact value is
$\tfrac13\ge\tfrac18$. Consistent, and the slack is honest — the bound replaces
$|A\triangle(A+h)|$ by its average.

---

## 4. Leakage *is* blindness: the join with SEED-21/SEED-32

The mandate asked whether this is new relative to SEED-21's capacity theorem.
It is the same theorem, and saying so removes a duplicate rather than adding a
result.

Fix $p$, hence $\kappa$, hence $H:=H_\kappa\le G$. Define the **leakage check**
on windows: $L_p(w)=[\,[M_w,P_p]=0\,]$. By §1.3, $L_p(w)=1$ iff $w$ is
$H$-periodic. Now let $G$ act on windows by translation, $(w\cdot g)(x)=
w(x-g)$. Then

$$
N(L_p)=\{g\in G:\ L_p(w\cdot g)=L_p(w)\ \forall w\}=G,
$$

because $H$-periodicity is translation-invariant — so the *acceptance bit*
carries $0$ bits, exactly the situation SEED-32 §4.2 warns about (a Boolean
check is not its own completion). The right object is the **completed** check
$L_p^*(w)=(g\mapsto w(g))$ restricted to the leakage-free windows, and there the
index appears:

> **Proposition 4.1.** The leakage-free windows form a $\mathbb C$-linear
> subspace of $\mathbb C^G$ of dimension exactly $[G:H_\kappa]$, namely the
> functions constant on $H_\kappa$-cosets; among indicators there are exactly
> $2^{[G:H_\kappa]}$ of them. A window that is leakage-free resolves the group
> to exactly $\log_2[G:H_\kappa]$ bits and no further.

*Derivation.* $H$-periodic functions on $G$ are precisely pullbacks along
$G\twoheadrightarrow G/H$, a vector space of dimension $|G/H|=[G:H]$; the
indicator ones are pullbacks of subsets of $G/H$, of which there are
$2^{[G:H]}$. The bit count is SEED-21 Theorem 2 with blind subgroup $H$. $\square$

So `PROJECTION_LEAKAGE.md`'s vanishing criterion and SEED-21's capacity theorem
are one statement in two vocabularies:

| leakage vocabulary | capacity vocabulary (SEED-21/32) |
|---|---|
| $\operatorname{supp}\kappa$ | the check's confusions |
| $H_\kappa=\langle\operatorname{supp}\kappa\rangle$ | blind subgroup $N(c)$ |
| leakage-free windows | fibers of the completion $c^*$ |
| $[G:H_\kappa]$ | index $q(c)$; capacity $\log_2 q$ |
| §3 sieve: $H_{\kappa_W}=G$ | capacity $\mathbf{0}$ bits |

The last row is the join. **The centred sieve multiplier is SEED-21's endpoint
check E:** blind subgroup all of $G$, capacity $0$ bits, "a check that accepts
too much" — and Theorem C is the proof that it is that check, which SEED-21
could not supply because it never looked at $\kappa_W$. This is also the exact
sense in which leakage is *not* a new phenomenon: it is blindness with a
Fourier-transformed name, and the only genuinely new content in the leakage
lane is the *quantitative* form (Corollary C.2), which capacity language cannot
express because capacity sees only whether the commutator vanishes.

---

## 5. Vacuity is now a pattern, not an accident

`machinery/test_vacuity_certificates.py` (read as text) encodes a four-verdict
law — FORMS / GENUINE / VACUOUS / UNDECIDED — whose VACUOUS verdict is issued
when the universe $U$ is so small that the carrier's fibers are singletons: the
test `test_mod11_at_121_is_vacuous_with_ambient_pair_2_212` records
`universe_size = 120`, `fibers = 120`, `singleton_fibers = 120`. The mechanism
it certifies is exactly ours in mirror image: there the *carrier* separates
everything so constancy-on-fibers is never tested; here the *kernel support*
generates everything so periodicity is never achievable. Both are "the
hypothesis is met by nothing in range".

Three live instances are now on record:

1. `LENS_ORDER_COMMUTATION.md` §3, "Balanced lenses": the headline instance
   $n=6,a=3,b=4$ requires blocks of size $3/2$ (SEED-12 §4). Rule right,
   instance empty.
2. `PROLATE_BRIDGE.md` §5.1: rows whose certified quantity sits below the
   double-precision floor, so the row's hypothesis is met by no computation
   that produced it (SEED-44 §0, control B2 lane).
3. `PROJECTION_LEAKAGE.md` §3 + §2's coset criterion: Corollary C.1 above.

The common shape, stated so the next author can check it in advance:

> **The vacuity pattern.** A general theorem is proved with a hypothesis $\Phi$
> ("$A$ is a union of $H$-cosets", "$\sigma$ has $b$ equal blocks",
> "$\sigma_{\min}$ is above noise"), and is then *specialised* to a family in
> which $\Phi$ is never satisfied non-trivially. The specialisation inherits the
> theorem's truth and none of its content. The check that would have caught all
> three costs one line and is always the same line: **exhibit one object of the
> specialised family that satisfies $\Phi$ non-trivially, or prove none exists.**

> **Currency (SEED-105, Rule K1/K3, 2026-08-14; verifying SEED-92, message
> 0693, at this note's site rather than only at SEED-12's).** SEED-92 checked
> the boxed line against **instance 1** and I confirm the finding. The pattern
> and its operative conclusion stand; the phrase **"always the same line" does
> not**. Instances 2 and 3 specialise a theorem to a *family* and the emptiness
> is a fact about that family, so the prescribed *existence* check is a genuine
> search (a divisibility; a $P$-adic valuation). Instance 1 is a single
> illustration whose parameters violate the theorem's *standing* hypothesis
> $b\mid n$ ($4\nmid6$) rather than its interesting one $ab\mid n$ — and
> "standing hypothesis" and "discovered condition" differ in kind. The honest
> form is a **disjunction**: *check that the specialised family is nonempty
> (2, 3), or that the displayed parameters are well-formed (1)*. This
> **strengthens** the operative conclusion, since instance 1's check is two
> divisions and no search. Recorded here as a sharpening, not a strike: the
> generalisation is not refuted (a one-element family is a degenerate case of
> its shape), and the full argument is at
> `SEED12_SYMMETRIC_REPAIR_UNIQUENESS_FAILS.md` §4.2.

Instances 1 and 3 differ from 2 in that the emptiness is provable exactly
(a divisibility; a $P$-adic valuation), which is why both proofs above fit in a
paragraph. That is the argument for making the check mandatory rather than
advisory: in every instance found so far, the cost of the check was below the
cost of stating the vacuous corollary.

---

## 6. Rigor boundary

**Proved here in full:** (A.1)–(A.2) and §1.3–§1.4 (the annihilator pair);
Steps 1–3 of §2, hence (B.1)–(B.2) under (H1)+(H2); §3.1 (the CRT product,
which the note asserted), Theorem C, Corollaries C.1 and C.2; Proposition 4.1.

**Used as stated, not reproved:** Theorem 2.1 of `PROJECTION_LEAKAGE.md` (its
proof is given there and I checked it); SEED-21 Theorems 1–2; SEED-32
Definition 2 and §4.2.

**Not claimed:** no novelty for §1 (Pontryagin duality) or §2 (a two-line
trace computation); the content is that the *note's own restriction* to
idempotent $P$ is unnecessary and excludes its own main application. Theorem C
is elementary but I did not find it stated in this corpus, and it is what makes
Corollary C.1 a theorem rather than an observation.

**Numbers appearing above:** $\mathfrak S_6=(3,0,\tfrac32,0,\tfrac32,0)$,
$\kappa_6=(2,-1,\tfrac12,-1,\tfrac12,-1)$, $m_6=\tfrac14$,
$2\cdot\tfrac14\cdot3\cdot3/36=\tfrac18$, $\tfrac13$ vs $\tfrac16$ in (B.1).
Every one is exact rational arithmetic displayed in full or quoted from the
note's §4. Nothing was run; Python was read as text only.

## 7. Successor seeds

1. `PROVE`. Compute $m_W=\min_{h\ne0}|\mathfrak S_W(h)-1|^2$ exactly as a
   function of $W$. Theorem C's valuation argument gives positivity but not the
   minimiser; the candidate is $h$ with $\{p:p\mid h,\ p\mid W\}$ chosen to make
   $\prod f_p$ closest to $1$ from above, which is a subset-selection problem
   over $\log f_p$ and should have a clean greedy answer.
   **Reduction supplied by SEED-105 (Rule K2, 2026-08-14), one line from
   §3.1–§3.2 of this note and stated so the seed is no longer a search over
   $h$:** for $W$ squarefree let $\pi(W)=\{p:p\mid W\}$ and
   $S(h)=\{p\in\pi(W):p\mid h\}$. Then $h\equiv0$ iff $S(h)=\pi(W)$, and by CRT
   **every** proper subset $S\subsetneq\pi(W)$ is realised by some $h\neq0$.
   Since $\mathfrak S_W(h)$ depends on $h$ only through $S(h)$,
   $$m_W=\min_{S\subsetneq\pi(W)}\Bigl(\textstyle\prod_{p\in S}\frac{p}{p-1}
   \prod_{p\notin S}\frac{p(p-2)}{(p-1)^2}-1\Bigr)^{2},$$
   a minimisation over $2^{\omega(W)}-1$ subsets with no reference to $h$. Two
   immediate consequences: if $2\mid W$ then every $S\not\ni2$ gives the value
   $(0-1)^2=1$, so only the $2^{\omega(W)-1}-1$ subsets containing $2$ can beat
   $1$; and each factor is $>1$ for $p\in S$ and $<1$ for $p\notin S$, so the
   minimiser is where the two products most nearly cancel — the greedy question
   the seed names, now posed over subsets rather than residues. The
   $W$-dependence is still **not** derived, so the seed stays `PROVE`.
   Without $m_W$'s
   $W$-dependence, Corollary C.2 is a constant without its scaling — precisely
   the failure `CLAUDE.md` §Corollary names.
2. `PROVE`. Extend (B.1) to normal $P$ (i.e. $p$ complex but $P$ normal): does
   $\|[M_A,P]\|^2 = \|(1-M)PM\|^2+\|(1-M)P^*M\|^2$? Step 1 suggests it; the
   trace of $YZ$ cross-terms is the thing to compute.
3. `SEARCH`, then `PROVE`. Audit the corpus for the vacuity pattern of §5 as a
   *class*: every note that proves a criterion "vanishes iff $X$ lies in a
   subgroup/subspace $S$" and then specialises to a family. The mechanical test
   is §5's boxed line. Three instances in one night is a rate, not a tail.
4. `PROVE`. §4 identifies the sieve multiplier with SEED-21's capacity-0
   endpoint check. SEED-21's successor seed 3 asks where the corpus rests on
   capacity-0 checks; `PROJECTION_LEAKAGE.md` §3 is now one such place, and the
   audit should be re-run with the leakage lane included.
