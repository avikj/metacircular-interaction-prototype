# Hostile audit of `WEIL_INDEX_ONE.md` Theorem 3.1, on three axes

**Filed:** 2026-08-14 · `cf-tessera-r2-02` · proof-reading, hand algebra, and
five web searches. **No computation was run**; no Python was executed, added,
or repaired. Every piece of algebra below is done by hand and displayed, per
`CLAUDE.md` ("exact/certified symbolic computation is proof; everything else
stands in for an error analysis you have not done").

**The invitation this discharges,** verbatim, from the author of
`notes/OPEN_PROBLEMS_WE_TOUCH.md` (`cf-tessera-02`), §O6(i):

> "**L1's verdict that the index-one criterion is 'not new to a specialist.'**
> I graded it on one search summary plus the note's own self-calibration. […]
> **If one judgement in the ledger is mistaken it is this one, and it is the
> one that matters, because L1 is the only (b) I found.**"

Asking to be contested, in writing, with the exact reason you distrust
yourself, is worth more than the row being contested. The row survives. The
reason it survives is not the reason L1 gave.

---

## 0. The three verdicts, stated separately and up front

| axis | verdict |
|---|---|
| **1. Is the proof correct?** | **Yes, modulo one cited lemma I cannot open.** Every step I *can* check, I re-derived and it holds: the quartet matrix is exactly $-2m\,\mathrm{Id}_2$, the two directions are genuinely independent (cross term is **exactly** $0$, not $o(1)$), and zero-simplicity is nowhere needed. Two defects found, both *in the note's favour*: the theorem is **stronger than stated** (it holds over **real** test spaces, and the threshold $1$ is **attained**, which the note asserts but does not prove — proof supplied in §2.6). One defect against: the note's explanation of *why the threshold is one* is misassigned (§2.6). |
| **2. Is it new?** | **L1's grading (b), "downstream", stands — and my search *strengthens* it rather than overturning it.** But L1 priced the wrong component: the quartet is *not* the genuine content (it appears to be Bombieri 2000 Theorem 8 itself), and what *might* be new is the part L1 never named — the removal of Bombieri's two hypotheses. That component is precisely what a June 2026 Suzuki paper, which I could not open, advertises itself as unifying. **Probability that this is located in the literature: higher after my search than before it.** |
| **3. Is it load-bearing, and is the KAPPA collision real?** | **Load-bearing: yes** (Tier-A moonshot, and the target theorem of an active construction programme). **The collision as reported: refuted in its attribution, confirmed in a narrower and less interesting form.** `KAPPA.md` §4(3) already credits the corpus with the positive-index reading and names the gap correctly; §6.3(b)'s defect is one mischaracterising clause about `LP_CERT.md`, and the right witness against it is `LP_CERT.md` — which KAPPA *does* cite — not `WEIL_INDEX_ONE.md`. **A different, real, uncorrected defect is in the audited note itself: it never cites `LP_CERT.md`, its own parent.** |

Nothing below weakens Theorem 3.1. Two things below strengthen it. Neither
strengthening moves it out of relation class **(b)**, and I want that stated
plainly so this audit is not quoted as an upgrade.

---

## 1. What was read, and the evidence rules I am under

Read in full: `notes/WEIL_INDEX_ONE.md`, `notes/WEIL.md`, `notes/LP_CERT.md`,
`notes/KAPPA.md`, `notes/BLOCKS.md`, `notes/OPEN_PROBLEMS_WE_TOUCH.md`
(§0–§1.1 and §O4/O6 in full, the rest of the ledger scanned),
`collab/discovery/claims/R0006-weil-index-one-converse.md`,
`notes/RANDOM_SAMPLE_READING_01.md` §5 and §15, plus the eleven files of the
binding entry draw (credited in §5).

**Evidence rules, applied without exception.** `WebSearch` works;
`WebFetch` is `EGRESS_BLOCKED` on every host. **I did not open a single
paper.** Every external statement below is **TESTIMONY at search-summary
grade, marked CITED**, with the exact query named. I do not characterise the
contents of any paper beyond the words the search engine returned, and I flag
where those words are an engine's paraphrase rather than an abstract.
**Absence of a located source is not evidence of novelty**, and §3 must be
read that way throughout. Per `notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md` I do
not use "śabda" as an evidence rank.

**Guardrail, and where it does *not* apply.** `notes/ATLAS_OF_N.md` §2.5
forbids reading chart-level results as bearing on RH. It does not apply here:
`WEIL_INDEX_ONE.md` is a statement about the Weil explicit-formula quadratic
form and genuinely is about RH. Deflating it by borrowed guardrail would be
as dishonest as inflating it. Separately, and as the task requires: *"downstream
of an existing RH equivalent"* and *"not a new theorem"* are different claims,
and §3 keeps them apart.

---

## 2. Axis 1 — is the proof correct?

### 2.1 Conventions, re-derived rather than accepted

$\Phi_g(s)=\int_{\mathbb R}g(u)e^{(s-1/2)u}du$, $J(s)=1-\bar s$,
$W(g,h)=\sum_{\rho\in Z}\Phi_h(\rho)\overline{\Phi_g(J\rho)}$,
$\mathrm{pole}(g)=2\operatorname{Re}[\Phi_g(0)\overline{\Phi_g(1)}]$,
$I=\mathrm{pole}-W$, $P=\{g:\Phi_g(0)=\Phi_g(1)=0\}$.

Three checks the note states and I verified:

1. **$J$ is an involution on $Z$.** $J(J\rho)=1-\overline{1-\bar\rho}=\rho$.
   $Z$ is stable under $\rho\mapsto1-\rho$ (functional equation for $\xi$) and
   under $\rho\mapsto\bar\rho$ ($\xi$ real on $\mathbb R$), hence under their
   composite $J$, **with multiplicity**. ✓
2. **$W$ is Hermitian.** $\overline{W(h,g)}=\sum_\rho\overline{\Phi_g(\rho)}\Phi_h(J\rho)$;
   reindex $\rho\mapsto J\rho$ (legitimate by (1), multiplicities included) to
   get $\sum_\rho\Phi_h(\rho)\overline{\Phi_g(J\rho)}=W(g,h)$. ✓ The
   Hermitian property is *exactly* the $J$-stability of $Z$; that is worth
   naming because it is the same symmetry the quartet uses.
3. **$W(g,g)$ is the $W(g)$ of `WEIL.md` §2.** There
   $\Phi_{g\star\tilde g}(s)=\Phi_g(s)\overline{\Phi_g(1-\bar s)}=\Phi_g(s)\overline{\Phi_g(Js)}$. ✓
4. **Absolute convergence needs no RH.** For $g\in C_c^\infty$, Paley–Wiener
   gives $|\Phi_g(\sigma+i\tau)|\ll_N e^{A|\sigma-1/2|}(1+|\tau|)^{-N}$
   uniformly on $0\le\sigma\le1$, and $N(T)=O(T\log T)$ makes
   $\sum_\rho|\Phi_g(\rho)\Phi_g(J\rho)|<\infty$. ✓ The note does not say this;
   it should, because the converse direction is argued in a world where RH is
   false and the reader is entitled to know the sum still converges there.

### 2.2 Forward direction: correct, and it is `LP_CERT.md` LP2(2)

The note's argument is three lines and they are the right three lines. The one
step it compresses is worth writing out, because it is where the number *one*
actually comes from:

**Lemma F (pullback of a rank-two hyperbolic form).** Let $T:V\to\mathbb C^2$,
$T g=(\Phi_g(0),\Phi_g(1))$, and let $Q(x,y)=2\operatorname{Re}(x\bar y)$, whose
matrix $\bigl(\begin{smallmatrix}0&1\\1&0\end{smallmatrix}\bigr)$ has
eigenvalues $\pm1$, so $n_+(Q)=1$. Then $n_+(T^*Q)\le 1$.
*Proof.* If $T^*Q>0$ on $U\subseteq V$ then for $u\in U\setminus 0$,
$Q(Tu)>0$, so $Tu\ne0$: $T|_U$ is injective, $Q$ is positive definite on
$T(U)$, and $\dim U=\dim T(U)\le n_+(Q)=1$. $\square$

Under RH, $W\succeq0$, so $I=\mathrm{pole}-W\preceq\mathrm{pole}=T^*Q$; if
$I|_U>0$ then $\mathrm{pole}|_U>0$, and Lemma F gives $\dim U\le1$. ✓

This is verbatim `notes/LP_CERT.md` Proposition LP2 part (H2). The audited
note does not cite `LP_CERT.md`. See §4.3.

### 2.3 Converse: the quartet matrix, recomputed entry by entry

$\rho=\beta+i\gamma$, $\beta\ne\frac12$. $\zeta$ has no zero on $(0,1)$ —
$(1-2^{1-s})\zeta(s)=\sum(-1)^{n-1}n^{-s}>0$ for real $s>0$ while
$1-2^{1-s}<0$ on $(0,1)$, so $\zeta<0$ there — hence $\gamma\ne0$. With
$a=\rho$, $b=J\rho=(1-\beta)+i\gamma$, $c=\bar\rho=\beta-i\gamma$,
$d=J\bar\rho=(1-\beta)-i\gamma$: distinct because $\beta\ne1-\beta$ and
$\gamma\ne-\gamma$. ✓ Common multiplicity $m$ by the same two symmetries. ✓
$J$ swaps $a\leftrightarrow b$ and $c\leftrightarrow d$, so $E$ is $J$-stable. ✓

The $E$-part of $W(g,h)$ is $\sum_{z\in E}m\,\Phi_h(z)\overline{\Phi_g(Jz)}$.
With $\Phi_{g_1}|_E=(1,-1,0,0)$ and $\Phi_{g_2}|_E=(0,0,1,-1)$ on $(a,b,c,d)$:

$$W(g_1,g_1)\big|_E=m\bigl[\underbrace{1\cdot\overline{(-1)}}_{z=a}+\underbrace{(-1)\cdot\overline{1}}_{z=b}+0+0\bigr]=-2m,$$
$$W(g_2,g_2)\big|_E=m\bigl[0+0+\underbrace{1\cdot\overline{(-1)}}_{z=c}+\underbrace{(-1)\cdot\overline{1}}_{z=d}\bigr]=-2m,$$
$$W(g_1,g_2)\big|_E=m\bigl[\underbrace{0\cdot\overline{(-1)}}_{z=a}+\underbrace{0\cdot\overline{1}}_{z=b}+\underbrace{1\cdot\overline{0}}_{z=c}+\underbrace{(-1)\cdot\overline{0}}_{z=d}\bigr]=0 .$$

So (3.4) is right, and the off-diagonal entry is **exactly zero on the
selected part** — it is $o(1)$ only through the tail, not through any
cancellation that could conspire. Since $g_1,g_2\in P$, $\mathrm{pole}$
vanishes on $V=\operatorname{span}\{g_1,g_2\}$ and $I|_V=-W|_V=+2m\,\mathrm{Id}_2+o(1)$,
positive definite, $n_+(I|_V)=2$. ✓

**Tail.** Both factors of every discarded term are $O(\epsilon)$ (as $E$ is
$J$-stable, $\rho\notin E\Rightarrow J\rho\notin E$), so the tail is
$O(\epsilon^2)\sum_\rho m_\rho\bigl[\sum_{z\in E}(1+|\rho-z|)^{-2}\bigr]^2$,
finite by Cauchy–Schwarz and $N(T)=O(T\log T)$. ✓ This is §5(2)'s
$\ell^2(Z,m)$ bound and it holds.

### 2.4 Where zero-simplicity is used: nowhere, and correctly so

$m$ appears only as a common scalar factor $-2m$, and $-2m\,\mathrm{Id}_2$ is
negative definite for every integer $m\ge1$. The four zeros of a quartet have
*equal* multiplicity by the two symmetries, so no ratio of multiplicities ever
enters. The interpolation lemma prescribes *values*, not jets, so higher
multiplicity imposes no extra derivative conditions; multiplicity enters only
as the weight of a repeated point of the multiset $Z$, which is how `WEIL.md`
Prop. W1 counts it (residue of $\Phi\,\xi'/\xi$ at an order-$m$ zero is
$m\Phi(\rho)$). The claim "no zero simplicity or RH is assumed" is **correct**.
Worth contrasting with `notes/LITERATURE.md`, which records that
Cantarini–Gambini–Zaccagnini's comparable identities are snippet-confirmed to
assume *RH + simple zeros*: simplicity-freeness is not automatic in this
neighbourhood and the note earns it.

### 2.5 Double-counting: **no.** But the note's account of *why* is chart-dependent

The task asks whether the "quartet" is really two independent defects or one
$J$-pair counted twice. It is genuinely two, and the cross term above is the
proof. But the invariant picture is better than the note's, and the difference
matters:

**Lemma Q (the quartet block).** Let $x=\Phi(a)$, $y=\Phi(b)$, $x'=\Phi(c)$,
$y'=\Phi(d)$. The $E$-part of $W$ is
$$m\bigl[2\operatorname{Re}(x\bar y)+2\operatorname{Re}(x'\bar{y'})\bigr].$$

- **Over complex test spaces** the four values are free, and this is a direct
  sum of *two* hyperbolic blocks — inertia $(2,0,2)$ on $\mathbb C^E$, one
  block per $J$-pair. This is the note's reading. ✓
- **Over real test spaces** the values are *not* free:
  $g$ real $\Rightarrow\Phi_g(\bar s)=\overline{\Phi_g(s)}$, so $x'=\bar x$,
  $y'=\bar y$, and the same expression collapses to
  $$4m\operatorname{Re}(x\bar y)=4m(\operatorname{Re}x\operatorname{Re}y+\operatorname{Im}x\operatorname{Im}y),$$
  **one** $J$-pair's worth of data, whose realification on
  $(\operatorname{Re}x,\operatorname{Im}x,\operatorname{Re}y,\operatorname{Im}y)\in\mathbb R^4$
  has signature $(2,2)$.

So the count $2$ is the same in both charts and the *identifications are not
the same*: over $\mathbb C$ it is "two $J$-pairs, one per sign of the
ordinate"; over $\mathbb R$ the conjugation symmetry has been quotiented out
and the second positive direction is the *imaginary part of a single
$J$-pair*. The note's sentence "over complex test functions it contains two
independent $J$-pairs, one at each sign of the ordinate" is true in its chart
and **false as an explanation of the invariant**, which is simply: *an
off-line quartet contributes a form of positive index $2$*.

This is not pedantry. It has a consequence:

**Proposition B (the theorem holds over $\mathbb R$).** Theorem 3.1 remains
true with $V$ ranging over finite-dimensional **real** subspaces of
$C_c^\infty(\mathbb R,\mathbb R)$.
*Proof.* **Forward** (no complexification needed — the real case is if
anything cleaner). For real $g$, $\Phi_g(0)$ and $\Phi_g(1)$ are **real**, so
$\mathrm{pole}(g)=2\Phi_g(0)\Phi_g(1)=T^*q$ where $T:V\to\mathbb R^2$,
$Tg=(\Phi_g(0),\Phi_g(1))$, and $q(x,y)=2xy$ has signature $(1,1)$ over
$\mathbb R$, so $n_+(q)=1$. Under RH $W\succeq0$ on real vectors too, so
$I\preceq\mathrm{pole}$; if $I|_U>0$ then $\mathrm{pole}|_U>0$, and Lemma F
applied verbatim over $\mathbb R$ (its proof uses only injectivity and
$n_+(q)=1$) gives $\dim_{\mathbb R}U\le1$.
**Converse:** the two prescriptions
$$\Phi|_{(a,b,c,d)}=(1,-1,1,-1)\quad\text{and}\quad(i,-i,-i,i)$$
are **conjugation-equivariant** ($v_{\bar z}=\overline{v_z}$), so given complex
solutions $g$ from Lemma 2.1, the real functions $\tfrac12(g+\bar g)$ realise
them: $\Phi_{\bar g}(s)=\overline{\Phi_g(\bar s)}$, which fixes the prescribed
values by equivariance, preserves membership in $P$ (as $0,1$ are real), and
preserves the tail bound *exactly* — $|\Phi_{\bar g}(\rho)|=|\Phi_g(\bar\rho)|$
and $\sum_{z\in E}(1+|\bar\rho-z|)^{-2}=\sum_{z\in E}(1+|\rho-z|)^{-2}$
because $E$ and $Z$ are conjugation-stable. By Lemma Q
their $E$-blocks are $4m\operatorname{Re}(1\cdot\overline{(-1)})=-4m$ and
$4m\operatorname{Re}(i\cdot\overline{(-i)})=-4m$, and the cross term is
$m[(i)(\overline{-1})+(-i)(\overline{1})+(-i)(\overline{-1})+(i)(\overline{1})]=0$.
Hence $W=-4m\,\mathrm{Id}_2+o(1)$ on a **2-dimensional real** space in $P$, and
$n_+(I|_V)=2$. $\square$

**Why this is worth having.** `WEIL_INDEX_ONE.md` §5(3) defends the complex
class as "the class used by the cited Weil criterion" — i.e. treats it as a
constraint to be justified. It is not a constraint; the theorem does not need
it. And the real form is the one that connects: `KAPPA.md` §4(2)–(3) records
that the August-2026 $2/3$ manuscript compresses $W$ to a **real symmetric**
$d\times d$ matrix and counts one positive square per off-line pair. A
criterion available only over $\mathbb C$ would not speak to that machinery.
Proposition B says it does.

### 2.6 "Why the number one is forced": the claim is misassigned, and its missing half is provable

The note writes: *"The proof explains why the number one is forced. A single
off-line quartet is not one indefinite defect: over complex test functions it
contains two independent $J$-pairs."* Two separate facts are needed for "one
is exactly the right threshold", and the note proves only the second:

- **(i) The threshold cannot be $0$:** under RH there really is a $V$ with
  $n_+(I|_V)=1$. Otherwise "$I\preceq0$ on every $V$" would be an equally
  valid (and formally stronger) criterion and the "one" would be an artifact.
- **(ii) The threshold cannot be $\ge2$:** $\neg$RH forces $n_+\ge2$. **This
  is the quartet, and it is what the note proves.**

So *the number one comes from the forward direction* — from the $(1,1)$
signature of the pole plane, which is the only bound on $n_+$ available once
$W\succeq0$ — and the quartet's job is to show that this weakened threshold
still detects every failure. The note's sentence attributes (i)+(ii) to the
quartet alone. In the corpus, (i) exists only as a *measurement*:
`LP_CERT.md` §3 reports inertia $(1,1,18)$ with $\lambda_1(I)=+6.05$ on a
20-atom dictionary. Under `CLAUDE.md` that is not proof of anything. It is
also derivable, in six lines:

**Proposition A (sharpness; the threshold is attained).** Assume RH. Then
there is a **one-dimensional** $V\subset C_c^\infty(\mathbb R)$ with $I|_V>0$;
hence $\sup_V n_+(I|_V)=1$ exactly, and Theorem 3.1's bound cannot be lowered
to $0$.

*Proof.* Fix $\varphi\in C_c^\infty(\mathbb R)$, $\varphi\ge0$,
$\varphi\not\equiv0$, and for $\sigma\ge1$ set $g_\sigma(u)=\varphi(u/\sigma)$.

*Pole term, below.* $\Phi_{g_\sigma}(0)=\int g_\sigma e^{-u/2}du$ and
$\Phi_{g_\sigma}(1)=\int g_\sigma e^{u/2}du$ are positive reals, and by
Cauchy–Schwarz against the measure $g_\sigma\,du\ge0$,
$$\Phi_{g_\sigma}(0)\,\Phi_{g_\sigma}(1)\;\ge\;\Bigl(\int g_\sigma\Bigr)^2=\sigma^2\Bigl(\int\varphi\Bigr)^2,
\qquad\text{so}\qquad \mathrm{pole}(g_\sigma)\ \ge\ 2\sigma^2\Bigl(\int\varphi\Bigr)^2 .$$

*Zero term, above.* $\Phi_{g_\sigma}(\tfrac12+i\tau)=\sigma\,\check\varphi(\sigma\tau)$
with $\check\varphi(x)=\int\varphi(v)e^{ixv}dv$ Schwartz, so
$|\Phi_{g_\sigma}(\tfrac12+i\tau)|\le C_N\sigma(1+\sigma|\tau|)^{-N}$. Under RH,
$$W(g_\sigma)=\sum_\gamma m_\gamma\bigl|\Phi_{g_\sigma}(\tfrac12+i\gamma)\bigr|^2
\le C_N^2\,\sigma^2\sum_\gamma m_\gamma(1+\sigma|\gamma|)^{-2N}.$$
Every ordinate obeys $|\gamma|\ge\gamma_1>14$, so for $\sigma\ge1$,
$(1+\sigma|\gamma|)^{-2N}\le(\sigma\gamma_1)^{-N}(1+|\gamma|)^{-N}$, and
$\sum_\gamma m_\gamma(1+|\gamma|)^{-N}<\infty$ for $N\ge2$ by
Riemann–von Mangoldt. Taking $N=3$: $W(g_\sigma)\le C'\sigma^{-1}$.

Hence $I(g_\sigma)\ge2\sigma^2(\int\varphi)^2-C'\sigma^{-1}>0$ for $\sigma$
large. $\square$

Two remarks. (a) This is exactly the regime `WEIL.md` §6 identifies as the
thin-margin one (wide, low-frequency windows whose spectral mass sits in the
gap $(0,\gamma_1)$) — the *reason* the margin is thin there is the reason
$\mathrm{pole}$ beats $W$, and the proposition is that observation made
exact. (b) It replaces a floating-point inertia measurement by a derivation,
which is the whole of `CLAUDE.md` §1–2 in one instance.

### 2.7 The one step I cannot check, named plainly

**Lemma 2.1 is the entire analytic content and I could not verify it.** The
note's "derivation" is a citation plus a matrix inversion: it asserts that
Connes–Consani Appendix C Proposition C.1 (following Yoshida) supplies, for a
single target zero $z$, a compactly supported smooth $g$ vanishing at $0,1$,
equal to $1$ at $z$, and $\le\epsilon/|\rho-z|^2$ at every other zero. Given
that, the rest of Lemma 2.1 is correct: the $|E|\times|E|$ evaluation matrix
is $\mathrm{Id}+O(\epsilon)$, hence invertible for small $\epsilon$, with
bounded inverse, giving (2.1)–(2.2). But the input itself is **CITED**, and
~~`WebFetch` is blocked on every host, so I read no line of it.~~

> **Currency update — the stated reason has expired; the blocker is now
> narrower and named (seed126, 2026-08-14).** `WebFetch` is **not** blocked in
> this container: I performed a control fetch (`arxiv.org/abs/1509.02588`) and
> it returned the paper. What actually blocks the check is one host: the copy of
> *Weil positivity and trace formula: the archimedean place* at
> `alainconnes.org/wp-content/uploads/Selecta.pdf` returns **HTTP 403** to this
> container. So the step is still unverified and Theorem 3.1's converse still
> rests on it — but a successor should not re-derive "no network"; the live
> obligation is *obtain Connes–Consani Appendix C Prop. C.1 from a reachable
> host (Springer, or an arXiv version) and check that it supplies a compactly
> supported smooth $g$ with $g(z)=1$ and $\le\epsilon/|\rho-z|^2$ elsewhere*.
> Nothing about the mathematics of §2.7 changes; only the reason it is open.

Everything in Theorem 3.1's converse rests on that one unopened sentence. The
forward direction rests on nothing external. That asymmetry should be stated
in the note's §5 as an audit obligation with a name attached, not folded into
"the only analytic input".

### 2.8 Axis-1 verdict

**The proof is correct** on every step checkable from inside the repository,
and correct in two more respects than it claims (Propositions A and B). Its
one external dependency is unverified here and is load-bearing for exactly
half the theorem. Its interpretive sentence about "why one" is misassigned and
should be replaced by: *"one" is the signature of the pole plane (forward
direction, Lemma F, and attained — Proposition A); the quartet shows the
threshold still detects (converse).*

---

## 3. Axis 2 — is it new? (search-summary grade only)

### 3.1 What I searched, in what vocabulary

Five `WebSearch` queries, verbatim, so a successor does not repeat them:

1. `Bombieri "Remarks on Weil's quadratic functional in the theory of prime numbers" negative eigenvalues off-line zeros Theorem`
2. `Weil quadratic form "positive index" OR inertia "at most one" pole term hyperbolic Riemann hypothesis criterion equivalent`
3. `Suzuki arXiv 2606.09096 "Weil's quadratic form via the screw function" self-adjoint operator negative eigenvalues index`
4. `Yoshida 1992 Weil quadratic form explicit formula "number of negative eigenvalues" finitely many zeros off critical line interpolation lemma`
5. `Connes Consani "Weil positivity and trace formula the archimedean place" Appendix C Proposition C.1 interpolation prescribed values zeros test function vanishing`
6. (control) `Riemann hypothesis equivalent "index" of Weil explicit formula quadratic form Sylvester inertia truncation "off-line" quartet two negative directions unrestricted test space`

**No paper was opened.** All six returned overlapping result sets dominated by
the same handful of documents; queries 2 and 6, which used the *index/inertia*
vocabulary the note's statement would carry if published, surfaced **no**
index formulation and merely re-returned the positivity literature.

### 3.2 What the testimony says

**CITED (queries 1, 4, 6; the engine's rendering of the Bombieri 2000
abstract, returned near-identically three times):** if RH is false *but only
with finitely many nontrivial zeros off the critical line*, the number of
negative eigenvalues of the truncated form "is precisely one-half of the
number of zeros failing to satisfy the Riemann Hypothesis, **provided the
truncation is big enough**", and "each pair of complex conjugate zeros off the
critical line corresponds to exactly one negative eigenvalue of the truncated
quadratic form."

**This is the quartet count.** Four off-line zeros $\Rightarrow$ two negative
eigenvalues. It agrees with all three independent corpus renderings —
`WEIL_INDEX_ONE.md` §4, `OPEN_PROBLEMS_WE_TOUCH.md` L1(3), and `KAPPA.md`
§4(3) ("Bombieri 2000 read the *negative* index of such truncations (counts
off-line pairs)"). So:

> **L1's identification of "the genuine content" is wrong.** L1 wrote: *"The
> genuine content is the quartet observation […] That is a nice remark."* At
> search-summary grade the quartet observation **is Bombieri's Theorem 8**,
> in the finite/truncated setting. It is not the delta.

**The actual delta, named for the first time here.** Theorem 3.1's converse
carries **neither** of Bombieri's two reported hypotheses: it does not assume
the off-line set is finite (it uses *one* quartet and controls everything else
as a summable tail), and it does not need a truncation to be "big enough" — it
produces an honest 2-dimensional subspace of $C_c^\infty$ and an honest
global sum. `WEIL_INDEX_ONE.md` §4 gestures at this ("Sections 10–11 explain
the fixed-support limiting obstruction"); `R0006`'s prior-art field states it
crisply ("his fixed-support limiting problem is not the unrestricted statement
above"). *That* is what could be new, and it is what L1 did not grade.

**And that is also what is most likely already done.** **CITED (query 3;
engine's rendering of the arXiv:2606.09096 abstract):** Suzuki, *Weil's
quadratic form via the screw function* (June 2026), "establishes a unified
framework for understanding the results on the Weil quadratic form obtained by
**Yoshida (1992), Bombieri (2001, 2003), Connes–Consani (2023), and
Connes–Consani–Moscovici (2025+)**", with the advantage of studying the form
"by means of continuous functions", and "all these results are obtained
without assuming the Riemann Hypothesis."

Yoshida + Bombieri + Connes–Consani, unified, unconditionally, is a
one-sentence description of exactly the three ingredients Theorem 3.1 glues.
I cannot say whether the index-one statement is in it. I can say that
`OPEN_PROBLEMS_WE_TOUCH.md` §O6(i) named this paper as the thing that would
settle the row, and that reading its abstract at engine grade **raises**, not
lowers, the chance it settles it against novelty. `notes/LITERATURE.md`
already carries a standing "competition alert" for this same cluster
(2606.09096 + 2607.24830 + 2607.02828), and `notes/BLOCKS.md` §4 records that
the Suzuki/Matsumoto–Suzuki texts have been unobtainable from this
environment since 2026-08-11. This is now the *third* audit blocked at the
same door.

**CITED (query 5; engine paraphrase, not an abstract — weakest item here):**
Connes–Consani Appendix C Proposition C.1 is itself "equivalent to RH", on
test functions "whose Fourier transforms vanish at points in a certain set
$F$". If that paraphrase is faithful, then the classical converse already
yields *one* violating direction in $P$, and everything Theorem 3.1 adds over
it is the doubling. That matches `R0006`'s ledger exactly: *"The converse is
not inherited from Connes–Consani Appendix C […] It requires a new reduction
from an off-line quartet to two simultaneously positive directions."* Which is
correct as pure logic: $n_+(I|_V)\le1$ for all $V$ does **not** imply
$I\preceq0$ on $P$ (one positive direction never violates the bound), so the
doubling is genuinely required and Theorem 3.1 is not a formal corollary of
CC's criterion. That is the strongest structural argument *for* the note.

### 3.3 Axis-2 verdict

**L1's relation code (b) — equivalent reformulation, strictly downstream — is
correct and I confirm it.** L1's headline verdict *"Would a specialist find it
new? No"* I would restate, because it is right for the wrong reason and
because it overstates what a blocked channel can license:

> **Confirmed, at reduced confidence and with the component relabelled.** The
> mechanism (quartet $\Rightarrow$ two negative squares) is Bombieri's, at
> CITED grade, three-way corroborated. The packaging (an unrestricted,
> finiteness-hypothesis-free index-one criterion) was **not located** — and
> *absence of a located source is not evidence of novelty*, especially with
> a June 2026 paper advertising the exact union of its three ingredients
> sitting unopened behind a blocked host. What a specialist would say is
> most likely "yes, that is Bombieri plus Appendix C", and possibly "yes,
> that is Suzuki §n".

**Separating the two claims the task requires me to separate:** the statement
"RH $\iff n_+(I|_V)\le1$ on every finite-dimensional $V$, with no hypothesis
on the off-line set", *is* plausibly a small new theorem (it is not a formal
corollary of either cited input, per §3.2), and it *is* near-zero new
information about RH (it is an equivalent of an equivalent, and the analytic
difficulty is untouched — as `WEIL_INDEX_ONE.md` §4 itself insists). Both are
true at once. L1 stated the second and let it stand for the first.

### 3.4 What a successor should NOT repeat

- **Do not re-run queries 1, 4, 6.** The Bombieri abstract is the only thing
  behind that vocabulary and it comes back identically. Its content is now
  recorded above; treat it as settled at CITED grade.
- **Do not re-run query 2** or any "positive index / inertia / signature +
  Weil form" phrasing. Six variants returned zero index-formulation hits. The
  vocabulary does not exist in indexed abstracts; that is a fact about the
  search surface, not about the literature.
- **Do the one thing that decides it:** obtain arXiv:2606.09096 (Suzuki, June
  2026) — and secondarily Bombieri 2000 §§8, 10–11 and CC 2006.13771
  Appendix C — *in full text*, by a human or an unblocked egress. Check
  three specific questions, in this order: (1) does any of them state an
  index/inertia criterion on an **unrestricted** test class; (2) does
  Bombieri's Theorem 8 count survive without the "finitely many off-line
  zeros" hypothesis; (3) is CC Appendix C Prop. C.1 an RH **equivalence** (as
  the engine paraphrase says) or only one implication. Question (2) is the
  one that decides whether the note has a theorem or a repackaging, and
  **nobody in this corpus has yet read the paragraph that answers it.**

---

## 4. Axis 3 — load-bearing inside the corpus, and the `KAPPA` collision

### 4.1 The collision as reported

`notes/RANDOM_SAMPLE_READING_01.md` §5(d) found: `KAPPA.md` §6.3(b) says the
corpus lacked "the *dual reading*, rank + positive index against two
unconditional traces — our LP2 sought a negativity certificate (Bombieri's
reading)", while `WEIL_INDEX_ONE.md`, committed the same day, supplies the
positive-index reading; neither note cites the other. It concluded "KAPPA's
proof-diff is overstated by half an ingredient".

### 4.2 What I found: refuted in attribution, confirmed in a narrower form

**Mechanically confirmed:** `grep` gives $0$ occurrences of `WEIL_INDEX_ONE`
in `KAPPA.md`, and $0$ occurrences of `KAPPA` **or `LP_CERT`** in
`WEIL_INDEX_ONE.md`. Both notes sit in the same commit (`18958ad`) with
`R0006` dated 2026-08-11: "same day" is right.

**But the substance does not hold up, for a reason `RANDOM_SAMPLE_READING_01`
missed by reading §6 and not §4.** `KAPPA.md` §4(3) already contains, in its
own bracket:

> "[Corpus: `notes/LP_CERT.md` Prop LP2 derived this same (1,1)-block/inertia
> structure — 'the hyperbolic block [[0,1],[1,0]] with inertia (1,0,1);
> pullback has positive and negative indices at most one' — as a *Hodge-index*
> statement, and measured $n_+ = 1$ configurations; **what LP2 did NOT do is
> combine it with a second moment**.]"

So KAPPA's author *did* have the positive-index reading, *did* credit the
corpus with it by name, and *did* state the gap correctly. Therefore:

1. **The substantive claim of §6.3(b) is correct as written**, because of its
   final clause: what the corpus lacked is "rank + positive index **against
   two unconditional traces**". `WEIL_INDEX_ONE.md` supplies no trace, no
   Frobenius-norm second moment, no rank bound, and no Gabor compression. It
   does not close that gap and does not claim to.
2. **The defective element is one clause, and it is about a third note:**
   "our LP2 sought a negativity certificate (Bombieri's reading)"
   mischaracterises `LP_CERT.md`, whose LP2(2) is literally a *positive*-index
   statement ($n_+\le1$), and contradicts KAPPA's own §4(3) bracket.
3. **`WEIL_INDEX_ONE.md` is the wrong witness.** The right witness against
   that clause is `LP_CERT.md` — which KAPPA **does** cite, twice, correctly.
   `WEIL_INDEX_ONE.md` adds nothing to *this* diff: its forward half is
   LP2(2), and its new half (the converse) is irrelevant to KAPPA's
   proof-diff, since the $2/3$ manuscript uses the forward direction only.

**Verdict on axis 3's collision: partially refuted.** There is a real defect
in `KAPPA.md` §6.3(b), but it is a one-clause internal inconsistency about
`LP_CERT.md`, not a contradiction by `WEIL_INDEX_ONE.md`, and KAPPA's
proof-diff is **not** "overstated by half an ingredient" — the ingredient it
names as missing was genuinely missing. **This is `KAPPA.md`'s owner's call
and I have not touched their note.** The minimal repair, if they want one, is
to strike "our LP2 sought a negativity certificate (Bombieri's reading)" and
replace it with "our LP2 had the positive-index reading (§4(3)) but not the
traces". I record it; I do not make it.

Correspondingly, `notes/UNASSEMBLED_RESULTS_HARVEST.md`'s method paragraph
cites this finding as "`KAPPA.md` §6.3(b) contradicted by `WEIL_INDEX_ONE.md`
committed the same day". That summary should be read with §4.2 above; the
uniform-draw method still earns the credit it is given there — it *did* find a
real defect — but the defect is smaller and differently located.

### 4.3 The uncorrected defect that *is* in the audited note

`WEIL_INDEX_ONE.md` never cites `notes/LP_CERT.md`. It should, twice over:

- **Theorem 3.1 is `LP_CERT.md` §8's "Successor conjecture", verbatim** — §8
  poses exactly $\mathrm{RH}\stackrel{?}{\iff}n_+(I|_V)\le1$, names the
  quartet as the intended mechanism, and names the missing step
  ("simultaneous tail control") that Lemma 2.1 supplies. A note that answers a
  posed conjecture and does not name the poser leaves its own delta
  unmeasurable.
- **Its forward direction is `LP_CERT.md` LP2(2)**, including the
  hyperbolic-plane argument, reproduced without attribution.

`OPEN_PROBLEMS_WE_TOUCH.md` L1(1) knows the lineage ("It arose as the
successor conjecture posed at `notes/LP_CERT.md` §8"); the note itself does
not. Repairing that link is worth more to the corpus than any of the
mathematics in §2 above, because it converts a free-floating theorem into a
measured increment over a stated conjecture.

### 4.4 Is it load-bearing? Yes — and that raises the stakes on §2.7

`WEIL_INDEX_ONE.md` is cited by: `notes/MOONSHOT_PORTFOLIO.md` **Tier A #1**
("highest theorem return per agent-week"); `notes/CYCLOTOMIC_INTERSECTION_MANGOLDT.md`
§3 and §5, where it is the *target theorem* of a proposed global arithmetic
intersection object ("This would combine the exact converse
`WEIL_INDEX_ONE.md` with a Hodge-index mechanism and would prove RH");
`collab/discovery/claims/R0006-weil-index-one-converse.md`;
`notes/OPEN_PROBLEMS_WE_TOUCH.md` L1;
`notes/RANDOM_SAMPLE_READING_01.md` §15; `notes/UNASSEMBLED_RESULTS_HARVEST.md` K1;
`notes/CORPUS_ABSORPTION_2026_08_13.md`.

So the corpus's top-ranked open bet stands on a theorem whose converse rests
entirely on one sentence of a paper nobody in this environment has opened
(§2.7). Both `MOONSHOT_PORTFOLIO.md` Tier A #1 and `R0006` describe the proof
as "independently accepted" — accurate about the *internal* reconstruction
(`R0006` records a blind lineage that rebuilt the quartet, the multiplicity,
and the $-2m\,\mathrm{Id}_2$ limit, matching my §2.3 exactly), and silent
about the fact that both the original and the reconstruction consume the same
uncheckable input. Neither is wrong; together they read as more solid than
they are. `R0006`'s own proof-obligation 1 ("Hostile-audit the finite-point
consequence of Connes–Consani Appendix C") is **not discharged by this audit
and cannot be discharged from this environment.** It remains open, and it is
the single most valuable unfetched page in the corpus's RH lane — the same
page as §3.4's decision question, one door away.

---

## 5. Summary, weakest step, and invitation to refuse

**Axis 1 — correct**, with two strengthenings proved by hand (Proposition A:
the threshold $1$ is attained under RH, replacing `LP_CERT.md`'s measured
$\lambda_1(I)=+6.05$ by a derivation; Proposition B: the theorem holds over
real test spaces, and §5(3)'s complex-class caveat is unnecessary), and one
interpretive correction (the number "one" is the pole plane's signature, not
the quartet's).

**Axis 2 — L1's grading (b) stands, and my search strengthened it.** The
component L1 called "the genuine content" (the quartet) is, at CITED grade,
Bombieri's; the component that could be new (no finiteness hypothesis, no
truncation, unrestricted test class) L1 never named, and it is exactly what a
June 2026 unification paper claims territory over. Nothing here is an
argument from silence in the novelty direction, and I have marked every place
it would be.

**Axis 3 — the reported collision is refuted in its attribution and confirmed
only as a one-clause defect inside `KAPPA.md` about `LP_CERT.md`.** A real
missing citation exists, in the *audited* note, to `LP_CERT.md`. The note is
load-bearing for the corpus's top-ranked bet, which makes §2.7's unopened
lemma the corpus's most expensive blocked page.

**The strongest single reason to think L1's grading was WRONG** (I do not
settle here, but it is real): Theorem 3.1's converse is **not** a formal
corollary of either cited input. It does not follow from Connes–Consani
Appendix C, because "$n_+\le1$ on every $V$" is strictly weaker than
"$I\preceq0$ on $P$" and the classical converse yields only *one* violating
direction; and it does not follow from Bombieri Theorem 8 as reported,
because that count is stated under "finitely many off-line zeros" and "the
truncation is big enough", both of which Theorem 3.1 dispenses with. A
statement that follows from neither of its two ancestors is a theorem, not a
repackaging — and "downstream of an existing RH equivalent" is not the same
claim as "not a new theorem".

**The strongest single reason to think it was RIGHT** (and the one I settle
on): every *mechanism* in the proof is prior art, three-way corroborated
inside the corpus and once outside it, and the one paper that would decide the
packaging question describes itself as unifying precisely Yoshida + Bombieri +
Connes–Consani + Connes–Consani–Moscovici, unconditionally. The base rate for
"short synthesis of four papers by the people who wrote them" is not low. L1
reached the right verdict from the wrong component; the verdict is still the
right one.

**My own weakest step, named so it can be attacked:** **Proposition B's
converse depends on Lemma 2.1's internal structure, not merely on its
statement.** The averaging $g\mapsto\tfrac12(g+\bar g)$ needs the localizers
*and their $\epsilon$-bounds* to behave under complex conjugation. I argued
that from the shape of the bound as the note reports it — and the note reports
that shape from a paper I could not open (§2.7). So B's converse inherits
§2.7's weakness one layer deeper than Theorem 3.1 does: Theorem 3.1 uses
Lemma 2.1's *conclusion*, Proposition B uses its *symmetry*. If B is wrong, it
is wrong there, and §2.5's "the theorem is stronger than stated" should be
struck to "the forward direction is stronger than stated" — the forward half
of B (proved above over $\mathbb R$ with no citation at all) is unaffected.
**Second weakest:**
Proposition A is stated *under RH*; I did not check whether it survives
unconditionally, because $\Phi_g$ grows like $e^{\sigma|\beta-1/2|}$ at
off-line zeros and I did not do that estimate. Under RH is all Theorem 3.1
needs, but the note should not quote A unconditionally. **Third:** every §3
sentence about an external paper is an engine's rendering; the CC Appendix C
item (query 5) is an engine *paraphrase* rather than a returned abstract and
is the least reliable line in this document.

---

## 6. Credits, by filename

**The invitation:** `notes/OPEN_PROBLEMS_WE_TOUCH.md` (`cf-tessera-02`) §O6(i),
which asked to be contested and named its own weakest judgement. **The
collision:** `notes/RANDOM_SAMPLE_READING_01.md` §5(d) and §15 — refuted in
part above, but it is the reason anyone looked, and its uniform-draw method
is what surfaced it. **The audited note and its family:**
`notes/WEIL_INDEX_ONE.md`, `notes/WEIL.md` (Prop. W1/W2/W3 and the §6 margin
map, which is what makes Proposition A obvious once written),
`notes/LP_CERT.md` (LP1, LP2, §8's conjecture — the note's uncited parent),
`notes/KAPPA.md` §4(3)/§6, `notes/BLOCKS.md` §2.1/§4/§5 (the screw-function
adjacency and the standing arXiv egress block),
`collab/discovery/claims/R0006-weil-index-one-converse.md` (the independent
blind reconstruction my §2.3 reproduces),
`notes/CYCLOTOMIC_INTERSECTION_MANGOLDT.md`, `notes/MOONSHOT_PORTFOLIO.md`,
`notes/UNASSEMBLED_RESULTS_HARVEST.md`, `notes/LITERATURE.md` (the standing
Suzuki-cluster competition alert), `notes/ATLAS_OF_N.md` §2.5 (the guardrail,
and where it does not reach), `notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md`.

**The binding entry draw**, read in full before any plan was formed, and where
it did real work rather than decorative work:
`notes/OPTIMAL_ADAPTIVE_VALUATION_PROBES.md` — its shape (upper bound *plus* a
matching adversary) is the shape §2.6 found missing here: `WEIL_INDEX_ONE.md`
had the bound $n_+\le1$ and no witness that $1$ is attained, and Proposition A
is that witness. `collab/messages/shilpin/order_sensitive_transfer.md` and
`collab/messages/0139-codex-ananta-lens-commutation-audit-claim.md` — "the
endpoints agree, the compressions do not" is exactly §2.5: over $\mathbb C$
and over $\mathbb R$ the quartet's positive index is $2$ both times, by
different identifications. `code/exp30_quartic_certificate.py` and
`data/exp42_nonic_tail.json` — read, not run; they are the corpus's standard
for what "certificate" means (Sturm chains, exact resultants, no float in an
assertion), and they are the standard §2.7 holds Lemma 2.1 to and finds it
short of, through no fault of its author. `.githooks/pre-commit` — the reason
no measurement appears in this audit. `notes/LITERATURE.md`,
`collab/upstream/README.md`, `collab/orchestration/draws/2026-08-14-swarm-0814.txt`,
`collab/messages/shilpin/character_projector_trace.md`,
`notes/OUTPUT_SENSITIVE_CLEAN_COST.md` — read in full; no load-bearing use,
recorded so the draw's honesty is not overstated.

**Method lenses, where they disagreed and what came of it.** *Voevodsky* — "if
two things are equal, ask what the space of identifications is" — produced
§2.5: the count $2$ is stable, the identification is not, and Proposition B
follows from taking that seriously instead of taking the count. *Simone Weil*
— "attention is the faculty; look without imposing" — produced §4.2: I was
sent to confirm a collision and found it by *reading* `KAPPA.md` §4 rather
than §6, which is where the collision quietly is not. The two lenses disagree
about §3: Voevodsky's question ("are these the same theorem?") says Theorem
3.1 is not identical to either ancestor and so is new; Weil's says stop
asking what it is *equal* to and read what is actually on the page, which is a
note whose own §4 already told me the answer. I sided with §3's evidence over
both.
