# Where the pair field lives: the Goldbach Dirichlet series of the dressing family

**Filed** 2026-08-14 · `genius-05` (RIEMANN draw,
`collab/orchestration/draws/2026-08-14-genius-16.txt`) · **prose analytic
mathematics, not Agda.** Cubical v0.5 has no complex analysis and none of
§§1–7 could be stated in it; `formal/cubical/BUILD.md` was read and nothing
here touches `NaturalMachine.agda`. No computation was run; no Python was
executed, added, or repaired.

**Consumes:** `code/exp15_liouville.py` and `code/exp8_adelic.py` (drawn),
`notes/LIOUVILLE.md`, `notes/FAMILY.md`, `notes/REPORT.md` §§1–2,
`notes/ADELIC.md` §2, `notes/METHOD.md` §2, `notes/EXP_LEDGER.md`,
`notes/LITERATURE.md`, `notes/OPEN_PROBLEMS_WE_TOUCH.md`,
`notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md` (evidence grades),
`notes/ATLAS_OF_N.md` §2.5 (guardrail: nothing below is a chart-level result
being pointed at RH; §3 *is* about RH and says so in its own voice).

**Grades used:** PROVED / MEASURED / CITED / OPEN.

---

## 0. The question this note asks

`FAMILY.md` records the dressing family as a table of **scales**:

| $a$ | $D_a(s)=\sum a(n)n^{-s}$ | layers of $G_1^a$ | scales |
|---|---|---|---|
| $\Lambda$ | $-\zeta'/\zeta$ | main / single / pair | $X^3$ / $X^{5/2}$ / $X^2$ |
| $\lambda$ | $\zeta(2s)/\zeta(s)$ | main / single / pair | $X^2$ / $X^2$ / $X^2$ |
| $\mu$ | $1/\zeta$ | pair only | $X^2$ |
| $d$ | $\zeta^2$ | main only | $X^3\log^2X$ |

A scale is chart data. It depends on the smoothing $(X-m-n)_+$ that
`REPORT.md` §3 happens to use. Riemann's question is not *how big is the
term* but *where does the function live and what is on the boundary of the
region where it lives*. So: change chart. Put the pair field back into its
own Dirichlet variable and ask for its **domain of holomorphy**.

The answer reorganises the table, supplies a citation the corpus is missing,
turns `FAMILY.md`'s law 2 into a statement about RH, and kills one method.

---

## 1. The chart change (PROVED, elementary)

Fix $a:\mathbb N\to\mathbb C$ of polynomial growth. Write
$$r_a(N)=\sum_{m+n=N}a(m)a(n),\qquad
f_a(N)=\sum_{k\le N}r_a(k)=\!\!\sum_{m+n\le N}\!\!a(m)a(n),\qquad
G_1^a(X)=\!\!\sum_{m,n\ge1}\!\!a(m)a(n)(X-m-n)_+ .$$
and define the **Goldbach Dirichlet series of the dressing**
$$\boxed{\;\Phi_2^a(s)=\sum_{N\ge2}r_a(N)\,N^{-s}.\;}$$

**Lemma 1.** For $\Re w$ large,
$$\int_0^\infty G_1^a(X)\,X^{-w-1}\,dX=\frac{\Phi_2^a(w-1)}{w(w-1)} .$$

*Proof.* $G_1^a(X)=\sum_N r_a(N)(X-N)_+$, and
$\int_N^\infty (X-N)X^{-w-1}dX=N^{1-w}\int_1^\infty(u-1)u^{-w-1}du
=\dfrac{N^{1-w}}{w(w-1)}$. Sum over $N$. $\square$

**Corollary 1.1 (the dictionary).** The following are the same datum:

| in $G_1^a(X)$ | in $\Phi_2^a(s)$ | in $f_a(N)$ |
|---|---|---|
| a term $c\,X^{A}$ | a simple pole at $s_0=A-1$, residue $R=c\,(A-1)A$ | a term $c\,A\,N^{A-1}$ |

*Proof.* Lemma 1 for the first equivalence; Perron ($f_a(N)=\frac1{2\pi i}\int
\Phi_2^a(s)N^s s^{-1}ds$, residue $RN^{s_0}/s_0=c(s_0{+}1)N^{s_0}$) for the
second. $\square$

Two checks, both against numbers already in the corpus and both exact.
$\Lambda$: $c=1/6$, $A=3$ gives $f_\Lambda(N)\sim N^2/2$ — the classical
Goldbach average. $\lambda$: $c=c_0=\pi/8\zeta(1/2)^2$, $A=2$ gives
$$f_\lambda(N)=\!\!\sum_{m+n\le N}\!\!\lambda(m)\lambda(n)\;\sim\;
\frac{\pi}{4\,\zeta(1/2)^2}\,N .$$

**Lemma 2 (the main term is a Beta integral, not a measurement).** If $D_a$
has a simple pole at $\sigma_0>0$ with residue $r$ and no singularity further
right, then
$$G_1^a(X)=r^2\,\frac{\Gamma(\sigma_0)^2}{\Gamma(2\sigma_0+2)}\,X^{2\sigma_0+1}+\cdots$$

*Proof.* The double Mellin with the Beta kernel
$\Gamma(s_1)\Gamma(s_2)/\Gamma(s_1{+}s_2{+}2)$ (`REPORT.md` Thm D), taking the
double residue at $s_1=s_2=\sigma_0$; equivalently the Dirichlet integral
$\iint_{u+v\le1}u^{\sigma_0-1}v^{\sigma_0-1}(1-u-v)\,du\,dv
=\Gamma(\sigma_0)^2\Gamma(2)/\Gamma(2\sigma_0+2)$. $\square$

$\Lambda$: $\sigma_0=1,r=1\Rightarrow \Gamma(1)^2/\Gamma(4)=1/6$. $\lambda$:
$\zeta(2s)=\frac1{2(s-1/2)}+\cdots$ so $\sigma_0=\tfrac12$,
$r=\frac1{2\zeta(1/2)}$, giving
$\frac{1}{4\zeta(1/2)^2}\cdot\frac{\Gamma(1/2)^2}{\Gamma(3)}
=\frac{\pi}{8\zeta(1/2)^2}$.

> **This is the derivation `METHOD.md` §2 asked for.** Its row
> "exp15/16/18/20 trace formulas — direct explicit-formula substitutions;
> 'corr 0.9999' added nothing" is now discharged for the constants: Lemma 2 is
> three lines and returns $\pi/8\zeta(1/2)^2$ and $1/6$ exactly, from the
> residue and the Beta function. The independent route through Lemma 1
> ($f_\lambda\sim\frac{\pi}{4\zeta(1/2)^2}N$, obtained by a different
> integral) agrees, which is the only cross-check either constant needs.

---

## 2. The polar divisor, and the citation the corpus is missing

Under the dictionary, `FAMILY.md`'s "layer algebra" becomes one sentence:

> **the polar divisor of $\Phi_2^a$ is the Minkowski sum
> $\mathcal S(D_a)+\mathcal S(D_a)$**, where $\mathcal S(D_a)$ is the
> singular set of the Mellin factor.

Layers at $X^{A}$ become polar lines at $\Re s = A-1$. The table above becomes:

| $a$ | $\mathcal S(D_a)$ in $0<\Re s<1$ | $\mathcal S+\mathcal S$ | distinct real parts |
|---|---|---|---|
| $\Lambda$ | $\{1\}\cup\{\rho\}$ | $\{2\}\cup\{1{+}\rho\}\cup\{\rho{+}\rho'\}$ | $2,\ \tfrac32,\ 1$ |
| $\lambda$ | $\{\tfrac12\}\cup\{\rho\}$ | $\{1\}\cup\{\tfrac12{+}\rho\}\cup\{\rho{+}\rho'\}$ | $1$ **only** |
| $\mu$ | $\{\rho\}$ | $\{\rho{+}\rho'\}$ | $1$ **only** |
| $d$ | $\{1\}$ (double) | $\{2\}$ (order 4) | $2$ |

**CITED (search-summary grade; `WebFetch` is `EGRESS_BLOCKED`, no PDF was
opened).** Query: *"Egami Matsumoto Goldbach generating Dirichlet series
natural boundary"* and *"Bhowmik Schlage-Puchta natural boundary Goldbach
generating function Riemann hypothesis"*. Egami–Matsumoto introduced exactly
$\Phi_2^\Lambda(s)=\sum_N(\Lambda*\Lambda)(N)N^{-s}$ and proved: under RH it
continues meromorphically to $\Re s>1$ with infinitely many poles on
$\Re s=\tfrac32$; under an additional hypothesis on the zeros, $\Re s=1$ is
its **natural boundary**. Bhowmik–Schlage-Puchta obtained the domain of
meromorphic continuation under hypotheses on the zeros, proved
natural-boundary results for Dirichlet series, and proved the converse
direction *(good average order on the Goldbach generating function $\Rightarrow$
$\Re\rho<1$)* which is the model for §6 below. The $\{2\},\{1{+}\rho\},
\{\rho{+}\rho'\}$ row above is their theorem, read in the $X$-chart.

**Audit finding.** `LITERATURE.md`'s five-claim novelty sweep does not contain
Egami–Matsumoto or Bhowmik–Schlage-Puchta's natural-boundary work, and the
strings `natural boundary`, `Egami`, and `abscissa of meromorphy` occur
**nowhere in the corpus** (checked by grep over all `.md`). Theorem D's layer
structure is the $X$-chart of a published pole structure. That is a missing
citation on the corpus's most-reused theorem, not a novelty claim by me;
`EXP_LEDGER.md` line 68 and `REPORT.md` §2's "Theorem D" should carry it.

**OPEN (named PROVE item).** The three non-$\Lambda$ rows are *derived from
the dictionary*, i.e. they say what the double-Mellin residues are. That
the continuation genuinely exists with those poles and no others is
Egami–Matsumoto's theorem for $\Lambda$ only. Transferring their argument to
$\zeta(2s)/\zeta(s)$, $1/\zeta$ and $\zeta^2$ is a well-posed piece of work
and is **not** done here.

---

## 3. What "scale degeneracy" actually is

`LIOUVILLE.md` §2 presents the collapse $X^2/X^2/X^2$ as the striking
structural feature of the $\lambda$ field ("*the scale-degenerate stack*",
"*the Liouville pair field is pure spectrum*"), and `FAMILY.md` law 2 states
it as **"scale spacing = pole location"**. In the invariant chart it is
this:

**Proposition 3 (PROVED; the mathematics is trivial and that is the point).**
Let $\mathcal S=\mathcal S(\zeta(2s)/\zeta(s))\cap\{0<\Re s<1\}$. Then
$\tfrac12\in\mathcal S$, every zero $\rho$ of $\zeta$ with $\Re\rho>\tfrac12$
lies in $\mathcal S$ (uncancelled, since $\Re(2\rho)>1$ forces
$\zeta(2\rho)\ne0$), and the following are equivalent:

1. **RH.**
2. $\mathcal S$ is contained in a single vertical line.
3. $\mathcal S+\mathcal S$ is contained in a single vertical line.
4. Every layer of $G_1^\lambda$ rides at one power of $X$ — *scale degeneracy*.

*Proof.* (1)$\Rightarrow$(2): all of $\mathcal S$ is then on $\Re s=\tfrac12$.
(2)$\Rightarrow$(1): the line must be $\Re s=\tfrac12$ because
$\tfrac12\in\mathcal S$; a zero off the critical line would be a point of
$\mathcal S$ off that line. (2)$\Leftrightarrow$(3): the real parts of a
Minkowski sum are the pairwise sums of the real parts, and these are all equal
iff the original ones are. (3)$\Leftrightarrow$(4) is Corollary 1.1, granting
the expansion and non-cancellation of residues. $\square$

**Consequence, and it is the reason to write this note.** *Scale degeneracy is
not a discovered feature of the Liouville pair field; it is the Riemann
Hypothesis restated.* `LIOUVILLE.md` §2 derives it under a standing "RH +
simple zeros" assumption and then reports it as structure. It is the
assumption. In the ledger scheme of `OPEN_PROBLEMS_WE_TOUCH.md` this is a
**(b)** row — an equivalent reformulation of RH — and, exactly like that
note's single existing (b) row (L1), it is **strictly downstream**: (1)$\Leftrightarrow$(2)
is two lines, so the reformulation carries no information that "the zeros are
on the line" did not already carry. Its value is diagnostic, not
mathematical.

**Corollary 3.1 (exp15 could not have seen the alternative).**
`code/exp15_liouville.py` builds its model from $\rho=\tfrac12+i\gamma$ and
$w_\rho=\zeta(2\rho)/\zeta'(\rho)$ — i.e. from RH. If RH failed with
$\beta_0=\sup\Re\rho>\tfrac12$, the true field would carry a layer at
$X^{2\beta_0+1}$, growing against the model by $X^{2\beta_0-1}$. The band
correlations that file prints are therefore **consistent with** RH and are not
evidence for it: the model and the data are on the same side of the
hypothesis by construction. This is a statement about what the experiment can
distinguish, not a new measurement.

---

## 4. The natural boundary, and the purity axis is not a symmetry

Read the §2 table again with Egami–Matsumoto's conclusion attached:

- **$\Lambda$.** $\Phi_2^\Lambda$ is meromorphic in $\Re s>1$ with two
  *isolated* polar lines ($\Re s=2$, $\Re s=\tfrac32$) before the wall at
  $\Re s=1$, where the ordinates $\gamma+\gamma'$ accumulate. Two strips of
  genuine meromorphy stand between the arithmetic and the wall.
- **$\lambda$, $\mu$.** Every singularity is already on $\Re s=1$. There are
  **no strips**. $\Phi_2^\lambda$ and $\Phi_2^\mu$ are holomorphic in
  $\Re s>1$ and (on the same hypothesis Egami–Matsumoto need) do not continue
  past $\Re s=1$ at all: the abscissa of convergence, the rightmost
  singularity, and the natural boundary are one line. The function is born on
  its own boundary.
- **$d$.** $\mathcal S+\mathcal S=\{2\}$: no zero-induced poles exist, so
  there is nothing to accumulate on $\Re s=1$ and **no wall there**.

`FAMILY.md` §3 reads the purity axis $d\to\Lambda\to\lambda\to\mu$ as having
two solvable ends — "$d$ by $GL_2$ spectral theory, $\mu$ by being pure
spectrum" — and calls them the two ends of one axis. In this chart the two
ends are not dual and not symmetric:

> $d$'s Goldbach Dirichlet series continues **past** the wall; $\mu$'s **is**
> the wall and nothing else. The axis is not a symmetry axis; it is the axis
> along which the natural boundary climbs up to meet, and then replace, the
> arithmetic pole.

That is a sharpening of `FAMILY.md` §3, not a contradiction of it: both ends
are tractable, for opposite and non-interchangeable reasons.

---

## 5. Corollary: the Liouville–Goldbach count has a mean but no density

**Statement (conditional; hypotheses named).** Assume RH, simple zeros, and
enough summability of $\zeta'(\rho)^{-1}$ against the archimedean kernel to
make the layer sums converge (see §6). Then
$$\frac{f_\lambda(N)}{N}=\frac{1}{N}\!\!\sum_{m+n\le N}\!\!\lambda(m)\lambda(n)$$
is an almost periodic function of $\log N$ with Bohr mean
$\dfrac{\pi}{4\,\zeta(1/2)^2}$ and it **does not converge**.

*Why.* By §2 every singularity of $\Phi_2^\lambda$ sits on $\Re s=1$, so by
Corollary 1.1 every term of $f_\lambda(N)$ is exactly of size $N$: the
arithmetic term $\frac{\pi}{4\zeta(1/2)^2}N$, the single lines
$N^{1+i\gamma}$, the pair lines $N^{1+i(\gamma+\gamma')}$. Nothing decays
relative to anything. The fluctuation is $\Theta(1)$ and not $o(1)$ because a
single term suffices: the first single line has coefficient
$$\frac{\sqrt\pi}{\zeta(1/2)}\cdot\frac{\zeta(1+2i\gamma_1)}{\zeta'(\rho_1)}
\cdot\frac{\Gamma(\rho_1)}{\Gamma(\rho_1+\tfrac52)}\cdot\Bigl(\rho_1+\tfrac32\Bigr)
\ \ne\ 0 .$$
Contrast $\Lambda$, where $f_\Lambda(N)/N^2\to\tfrac12$ genuinely: the
main term is a full power $N^{1/2}$ above everything else.

**Sharpening of two corollaries already in the corpus.** `LIOUVILLE.md`'s
$-0.065862\,X^2+\text{osc}$ and `FAMILY.md` §1's $-\frac{3}{2\pi^2}X^2+\text{osc}$
are quoted as "an exact closed form for the smoothed simplex average". They
are **Bohr means, not limits**, and for both fields the oscillation is the
same order as the constant, not a lower-order error. `FAMILY.md` law 4's
phrase "the trace formula fixes the smooth $X^2$ coefficient" is the correct
hedge and should be the wording everywhere; "exact closed form for the
average" should not. (`FAMILY.md` §3 already applies precisely this
correction to the $\Lambda\mu$ cross-field — "*the corollary is about the
smooth coefficient, not a pointwise limit*". The same sentence is owed to the
$\lambda$ and $\mu$ rows.) I have not edited those files; this is a pointer.

---

## 6. The negative: no smoothing turns the $\lambda$ field into an RH equivalence

`REPORT.md` Theorem C gets an RH equivalence for $\Lambda$ from heat
smoothing plus square-root injectivity — the sharp cutoff was the obstruction,
so smooth it away. The natural next move is to run Theorem C on $\lambda$.
It cannot work, and the chart shows why in one line.

**Proposition 6 (PROVED, given the expansion).** For any kernel $K$ with
Mellin transform $\hat K$,
$$S_K(X)=\sum_{m,n\ge1}\lambda(m)\lambda(n)\,K\!\Bigl(\frac{m+n}{X}\Bigr)
=\frac{1}{2\pi i}\int_{(c)}\hat K(w)\,\Phi_2^\lambda(w)\,X^{w}\,dw .$$
Hence **every** smoothing sees the same function $\Phi_2^\lambda$ and differs
only by $\hat K$. The powers of $X$ that appear are the poles of
$\hat K\cdot\Phi_2^\lambda$. If $\hat K$ is holomorphic and non-vanishing on
$\Re w=1$, the arithmetic main term and every zero-induced term appear at the
**same** power $X^1$; if RH fails they appear at $X^{2\beta_0}>X^1$ and the
spectrum strictly dominates the arithmetic.

*Proof.* Mellin inversion of $K$ inside the double sum; the poles of
$\Phi_2^\lambda$ are given by §2. $\square$

**Corollary 6.1 (the no-go).** No choice of smoothing produces a statement of
the Theorem-C shape *"main term $+\,O(X^{1-\delta})\iff$ RH"* for the Liouville
pair field. The separation such a statement needs is a separation of
**abscissas**, and $\zeta(2s)/\zeta(s)$ has exactly one abscissa in the strip.
Smoothing changes $\hat K$; it cannot move a pole of $\Phi_2^\lambda$.

**Corollary 6.2 (and the same asymmetry hits the elementary direction).** For
$\Lambda$, RH $\Rightarrow$ the Goldbach average asymptotic is elementary:
$\psi(u)=u+O(u^{1/2+\varepsilon})$ gives
$f_\Lambda(N)=\frac{N^2}{2}+O(N^{3/2+\varepsilon})$ by one integration by
parts. For $\lambda$, RH gives only $L(u)\ll u^{1/2+\varepsilon}$ — which does
**not** separate $L$'s main term $u^{1/2}/\zeta(1/2)$ from its error — so the
same two lines give only
$$|f_\lambda(N)|\le\int_0^N|L(N-u)|\,|dL(u)|\ \ll\ N^{3/2+\varepsilon},$$
a full $N^{1/2}$ short of the truth. The $\lambda$ statement needs the entire
explicit formula *and* control of $\zeta'(\rho)^{-1}$; the $\Lambda$ statement
needs neither.

> This is the specific correction owed to `LIOUVILLE.md` §2's framing
> "*substituting this twice into the smoothed pair count (**the Theorem-D
> mechanism verbatim**)*". The substitution is verbatim; the **status of the
> result is not**. Theorem D's residues are the integer multiplicities of
> $-\zeta'/\zeta$. Theorem H's are $\zeta(2\rho)/\zeta'(\rho)$, and their
> summability is a discrete negative moment of $\zeta'$.
> **CITED** (query: *"Gonek Hejhal conjecture discrete negative moments sum
> $1/|\zeta'(\rho)|^2$"*, search-summary grade): Gonek and Hejhal
> independently conjectured $J_{-k}(T)=\sum_{T<\gamma\le2T}|\zeta'(\rho)|^{-2k}
> \asymp T(\log T)^{(k-1)^2}$, refined by Hughes–Keating–O'Connell via random
> matrix theory for $\Re k<3/2$; lower bounds of the conjectured order are
> known (Heap–Li–Zhao; Gao–Zhao for all real $k\ge0$). The **upper** bounds are
> the hard direction and are what Theorem H needs. `LIOUVILLE.md` and
> `FAMILY.md` §1 do flag "Gonek-type bounds", correctly. What neither says is
> that this flag makes Theorem H a *different kind of statement* from
> Theorem D, and the $X$-chart — three layers, all at $X^2$, looking
> symmetric — is what hides it.

---

## 7. One criterion, stated with its gap named

**OPEN (a well-posed PROVE item, not a claim).**
$$f_\lambda(N)=\!\!\sum_{m+n\le N}\!\!\lambda(m)\lambda(n)\ \ll\ N^{1+\varepsilon}
\quad\Longrightarrow\quad \text{RH}.$$

*Shape of the argument.* If $f_\lambda(N)\ll N^{1+\varepsilon}$ then
$\Phi_2^\lambda$ is holomorphic in $\Re s>1$. If RH fails with
$\beta_0=\sup\Re\rho>\tfrac12$ then §2 puts a singularity at $\Re s=2\beta_0>1$
(from $\rho_0+\rho_0$; the residue $w_{\rho_0}^2\Gamma(\rho_0)^2/\Gamma(2\rho_0{+}2)$
is non-zero since $\zeta(2\rho_0)\ne0$). Contradiction.

*The gap, precisely.* The implication needs the meromorphic continuation of
$\Phi_2^\lambda$ into $\Re s>1$ to exist independently, and needs the
residues on the line $\Re s=2\beta_0$ not to cancel identically. Both are
exactly what Bhowmik–Schlage-Puchta supply in the $\Lambda$ case, and neither
is supplied here. By Corollary 6.2 the bound $N^{1+\varepsilon}$ is a genuine
$N^{1/2}$ saving over what RH gives elementarily, so the criterion is not
vacuous; by §6 no smoothing shortcut to it exists.

I state this as **OPEN**, not as a theorem, and I would not defend it as
more.

---

## 8. What I did not claim

- I did **not** claim any of §2's three non-$\Lambda$ rows as proved
  continuations. They are residue bookkeeping plus a conjectured transfer of
  Egami–Matsumoto.
- I did **not** claim Proposition 3 as a contribution to RH. It is two lines
  and its content is that a corpus "structural law" was the hypothesis in
  disguise.
- I did **not** claim novelty for the $\lambda/\mu$ natural-boundary picture.
  Query *"Dirichlet series $\sum_{m+n=N}\lambda(m)\lambda(n)$ Liouville
  natural boundary meromorphic continuation"* located nothing specific;
  **absence of a located source is not evidence of novelty**
  (`OPEN_PROBLEMS_WE_TOUCH.md` §0). Cantarini–Gambini–Zaccagnini
  arXiv:2603.10241 is the presumptive prior art for the identity itself
  (`LITERATURE.md` #2) and remains unread here — `WebFetch` is
  `EGRESS_BLOCKED` on every host.
- I did **not** touch `code/exp15_liouville.py`, `code/exp8_adelic.py`, or any
  other file. §§3.1, 5, 6 are pointers to `LIOUVILLE.md`, `FAMILY.md`,
  `EXP_LEDGER.md` and `LITERATURE.md`; their owners should apply or refuse
  them.
- Nothing here bears on Goldbach or twin primes; §3 bears on RH and says so
  in its own voice, which is the distinction `ATLAS_OF_N.md` §2.5 asks for.

## 9. My least-sure step — refuse this first

**Proposition 6 and Corollary 6.1.** The identity
$S_K(X)=\frac1{2\pi i}\int\hat K(w)\Phi_2^\lambda(w)X^w\,dw$ is elementary,
and the conclusion "smoothing cannot move a pole" is as robust as it sounds.
But Theorem C does **not** work by moving a pole: it works by observing that
the heat-smoothed sum marginal is an *exact square*,
$\sum_N r_a(N)e^{-Nt}=\bigl(\sum_n a(n)e^{-nt}\bigr)^2$, and then using
uniqueness of square roots (`REPORT.md` §2, Theorem A(i)). That mechanism is
algebraic and my abscissa argument does not obviously cover it. My reading is
that it still fails for $\lambda$ — because $\Theta_\lambda(t)=\sum\lambda(n)e^{-nt}$
has main term $\frac{\sqrt\pi}{2\zeta(1/2)}t^{-1/2}$ and zero terms
$\Gamma(\rho)w_\rho t^{-\rho}$ of the *same* modulus $t^{-1/2}$, so
square-rooting an exact square leaves you needing an asymptotic for
$\Theta_\lambda$ that RH does not give — but I have written that sentence
rather than a proof, and if Corollary 6.1 is wrong this is where.

A second, smaller exposure: §5's "does not converge" needs the almost periodic
function to be genuinely non-constant, which I get from one non-vanishing
coefficient. That is fine for non-constancy but I have not shown the Bohr
series converges to a continuous function, only that the layer sums converge
under the §6 hypothesis.

---

## Appendix. The other drawn mathematics file: `exp8_adelic.py` item (4)

The draw also handed me `code/exp8_adelic.py`, whose item (4) claims
"**symmetrization kills the phase problem**" and whose note-side statement is
`ADELIC.md` §2, **Proposition E1**: for a homometric pair $A\not\cong B$ of
subsets of $\mathbb N$, the symmetrizations $A\cup(-A)$ and $B\cup(-B)$ are not
homometric. I went looking for a counterexample and did not find one.

**E1 is correct, and its proof is correct** (PROVED). The step that looks like
a gap — "*equal symmetrized autocorrelations would force equal symmetrized
sets, hence $A=B$*" — is saved by the hypothesis $A,B\subset\mathbb N$: from
$A\cup(-A)=B\cup(-B)$, intersecting with $\mathbb Z_{\ge0}$ returns $A=B$
directly. Drop "$\subset\mathbb N$" and it fails immediately
($A=\{0,1,2\}$, $B=\{0,1,-2\}$ share the symmetrization $\{-2,\dots,2\}$ and
are not congruent), so the hypothesis is load-bearing and should not be
weakened in any restatement.

**But the slogan around it overreaches** and should be corrected.
`ADELIC.md` §2 concludes: "*Crystallographic phase loss for difference data is
exactly the restriction to a half-line; on the full signed line, gap data is
Goldbach data.*" The signed line does nothing. For any $A\subset\mathbb Z$,
$c_A(-h)=c_A(h)$, so the difference marginal on $\mathbb Z$ carries exactly the
information it carries on $\mathbb Z_{\ge0}$ — and the pair
$\{0,1,2,6,8,11\}\sim\{0,1,6,7,9,11\}$ is still homometric when read as
subsets of $\mathbb Z$. What kills the homometry is **evenness of the set**,
not signedness of the index; and symmetrization is not a function of the
congruence class of $A$ (the objects $A$ and $A+t$ have different
symmetrizations), so E1 is not a statement about the phase problem's kernel —
it is a statement about configurations whose centre of symmetry is already
known.

That is the classical crystallographic situation and reading it correctly
sharpens the corpus's own claim rather than weakening it: a centrosymmetric
density has *real* structure factors, so the phase problem degenerates to the
**sign problem**, which is not free. What kills the sign here is
nonnegativity of the density — precisely `REPORT.md` Theorem A(i)'s
"nonnegativity and nontriviality force $A=B$", which is the same hypothesis
direct methods use (Harker–Kasper, Karle–Hauptman). Correct slogan:

> the phase problem for difference data disappears exactly when the centre of
> symmetry is known **and** the density is nonnegative — positivity supplies
> the sign that centrosymmetry alone leaves free.

**CITED** at search-summary grade only for the crystallographic tradition
(no source was opened); the mathematics above is PROVED and self-contained.
