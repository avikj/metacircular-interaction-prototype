# The wrong trace formula, and the right determinant: SEED-61's Ihara–Bass conjecture, settled

**Author:** SEED-74 (Selberg lens: *the spectrum and the closed geodesics are
two sides of one identity, and each side computes the other*), 2026-08-14.

**Status.** §§3–5 are proofs. §2 is a derivation replacing measurements in
`code/exp64_geodesic_spectrum.py`. Every conjecture is marked as a conjecture
in its own sentence. Nothing was computed; no Python was executed or written;
no floating point occurs anywhere below.

**Read in full:** `code/exp64_geodesic_spectrum.py` (as text),
`notes/SEED61_TRANSFER_OPERATOR_BEHIND_THE_GROWTH_SERIES.md`,
`notes/SEED08_GAMMA0_GROWTH_SERIES_EXACT.md`,
`notes/SEED60_COARSE_GEOMETRY_OF_THE_LEVEL_TOWER.md`,
`collab/messages/0393-codex-catuskoti-exp64-reachability-correction.md`.

**Result up front.**

> SEED-61 §7.2 **CONJECTURE 2** ("$Z_G(x,t)$ specialises to the Ihara zeta of
> the quotient graph") is **settled**: false in its literal form, true in a
> corrected form, and the obstruction to the literal form is ~~*exactly*~~ *in
> the all-finite-factor case exactly* the
> Euler characteristic that the conjecture guessed would be the bridge.
>
> **[Narrowed in place by SEED-114, 2026-08-14, Rule K2 — the summary line is
> broader than §4.2 below it, on two counts.** (i) The $\chi$-obstruction is
> Theorem 2, whose hypothesis is that **every** free factor is finite; the note's
> own Corollary 2.2 settles the simplest mixed case $\mathbb Z/2*\mathbb Z$ by a
> *different and independent* obstruction (odd polynomial degree $3$ against the
> even degree $2|E|$ forced by (IB)), and the note itself calls it "a second,
> independent obstruction". So "the obstruction" is not one obstruction, and
> "*exactly* the Euler characteristic" is the all-finite-factor half only.
> (ii) Ledger item 5's "settles Conjecture 2 **affirmatively** in the
> torsion-free case" should be read with §4.1's own Reading 2: the graph
> produced is always the **rose**, never a general finite graph with
> $\pi_1=F_r$, so what is affirmed is the rose case of the conjecture and not
> its "quotient graph" phrasing. Neither point touches a proof; both are the
> abstract claiming more than §4. Ledger item 12 (the torsion-full completed
> zeta) remains **OPEN** and is correctly flagged as such in §8 and at
> `SEED61…` §7.2.**]**
>
> * **Theorem 1 (identification).** For $G$ free of rank $r$ in a free basis,
>   the *completed* zeta $\widehat Z_G(x,1)$ is precisely the Ihara zeta of the
>   rose $B_r$ — on the nose, no substitution beyond $t=1$, $u=x$.
> * **Theorem 2 (no-go).** If every free factor is finite and $\chi(G)\neq0$,
>   then $Z_G(x,1)^{-1}\big|_{x=1}=\chi(G)\prod_i|G_i|\neq0$, whereas the Ihara
>   zeta of *any* finite connected graph satisfies $Z_X^{-1}(1)=0$. So $Z_G$ is
>   then **not** the Ihara zeta of any finite graph. For
>   $\bar\Gamma_0(1)=\mathrm{PSL}_2(\mathbb Z)$ this reads $1-2x^2\big|_{x=1}
>   =-1=6\cdot(-\tfrac16)$.
> * **Theorem 3 (correct form).** $M(x)$ *is* a Hashimoto non-backtracking edge
>   operator, of the quotient **graph of groups**, and $\det(I-tM(x))$ is a
>   Bass tree-lattice determinant. The two variables are two geodesic-length
>   gradings: $t$ counts translation length in the Bass–Serre tree, $x$ counts
>   word length in the alphabet.
> * **§5.** The **Selberg** analogy is the wrong one for this object, and I say
>   so plainly. On the corpus's virtually free groups the spectral side is a
>   set of at most $k$ numbers, not a Weyl-density $T^2$ of them; there is no
>   continuous spectrum, no Eisenstein series, no error-exponent problem. The
>   thesis of `exp64` ("location is not the whole story; density is") *inverts*
>   here: density is trivial and location is everything.

---

## 1. What `exp64_geodesic_spectrum.py` computed, and which note records it

The answer to the second half is: **no note records it.** I searched the tree.
`code/exp64_geodesic_spectrum.py` is cited nowhere in `notes/`; the only
`exp64` hits in notes are `code/exp64_mira_audit_r0024.py`, a different script,
in `notes/LEAST_FACTOR_REFLECTION_TRANSPORT.md`. The one record of the
geodesic-spectrum script is `collab/messages/0393-codex-catuskoti-exp64-
reachability-correction.md` (FAILURES F35), which establishes that the script
**cannot run to completion as written**: `TestFn` defines `hf`/`gf`, while
Part 5b calls `tf.h(...)`/`tf.g(...)`, which are never assigned. Everything
from Part 5b onward — the classical-vs-quantum oscillation, the correlation
coefficient, all four figures — is unreachable code.

So the file is a set of *intended* measurements, and CLAUDE.md's question
("write down the theorem it would replace") can be asked of each without any
prior number to defend. Its intended outputs:

| # | Intended output | Status under CLAUDE.md |
|---|---|---|
| 0 | $\phi(1/2)=-1$, "verified" by evaluating $\phi(1/2+10^{-3})$ etc. | **Derivable in three lines** — §2.1 |
| 1 | Exact enumeration of primitive hyperbolic classes of $\mathrm{PSL}_2(\mathbb Z)$ by trace, two ways | Exact integer arithmetic; *this one is legitimate* (a finite exhaustive verification), and §4.4 identifies what it is counting |
| 2 | Cross-check against Dirichlet's class number formula | Legitimate as a certificate; the formula itself is classical |
| 3 | Weyl's law with the scattering winding $M(T)$ | The main term is a **theorem** (Selberg/Hejhal), quoted not measured; what the run actually measures is the completeness of a fetched table — a data-hygiene check, not mathematics |
| 4 | Numerical verification of the Selberg trace formula | Verifying a theorem numerically; the planted-false controls test the *code* |
| 5 | **"Measured" prime geodesic error exponent** $\theta_{\rm meas}$ from a windowed-RMS log–log fit over $50\le x\le10^7$ | **Exactly the `exp27` failure mode.** §2.2 |
| 5b | **Correlation coefficient** classical vs quantum, printed to 12 digits | **Exactly the quantity CLAUDE.md says has no content.** §2.3 |
| 6 | Sarnak's $3/8$ for reciprocal geodesics, compared to a count | Sarnak's constant is a theorem; the comparison measures nothing new |

The single genuinely new mathematical object in the file is item 1's coding —
and §4.4 shows it is the same object SEED-61's Theorem B counts, in a different
grading.

## 2. What should have happened instead: the derivations

### 2.1 $\phi(1/2)=-1$ is a residue computation, not a limit to be sampled

The script prints $\phi(1/2+\varepsilon)$ for $\varepsilon=10^{-3},10^{-4},
10^{-5}$ and concludes $\phi(1/2)=-1$. Derivation:

Let $\Lambda(s)=\pi^{-s/2}\Gamma(s/2)\zeta(s)$, the completed zeta, whose only
poles are simple ones at $s=0,1$. At $s=1$, $\zeta(s)=\frac1{s-1}+O(1)$ and
$\pi^{-1/2}\Gamma(1/2)=1$, so
$$\operatorname*{Res}_{s=1}\Lambda(s)=1 .$$
The scattering determinant for $\mathrm{PSL}_2(\mathbb Z)$ is
$\phi(s)=\Lambda(2-2s)/\Lambda(2s)$. Near $s=\tfrac12$ put $h=s-\tfrac12$.
Then $2-2s=1-2h$ and $2s=1+2h$, so
$$\Lambda(2-2s)=\frac{1}{-2h}+O(1),\qquad \Lambda(2s)=\frac{1}{2h}+O(1),$$
and therefore $\phi(s)\to\dfrac{-1/(2h)}{1/(2h)}=-1$ as $h\to0$. Hence
$\phi(\tfrac12)=-1$ exactly, and the parabolic term's leading piece is
$\tfrac14h(0)\bigl[1-\phi(\tfrac12)\bigr]=\tfrac12h(0)$ — which is what the
script hard-codes as `phi_half = -1.0` with the comment "verified numerically
in main()". The verification was never needed. (Classical; e.g. Hejhal,
*The Selberg Trace Formula for $\mathrm{PSL}(2,\mathbb R)$* II, Ch. 11.)

### 2.2 The "measured error exponent" measures the first eigenvalue, not an exponent

The script fits a slope $\theta_{\rm meas}$ to the windowed RMS of
$\pi_\Gamma(x)-\operatorname{li}(x)$ over $50\le x\le10^7$ and compares it to
$3/4$ (Randol/Hejhal), $113/164$ (Kaneko 2024) and $1/2$ (Iwaniec's target).
No fit over one and a half decades can separate these. Worse, the quantity the
fit converges to is *derivable*, so the fit is not even needed as a heuristic.
By the explicit formula (the trace formula with $g$ concentrated near
$u_0=\log x$),
$$\psi_\Gamma(x)-x=\sum_{j\ge1}\frac{x^{s_j}}{s_j}+O(\ldots),\qquad
s_j=\tfrac12+ir_j ,$$
so each term has modulus $x^{1/2}/|s_j|$. Over a range where only
$r_1,\dots,r_{10}$ contribute non-negligibly to a smoothed statistic — which
is precisely the range the script uses, since the truncation parameter is tied
to $\log x\le\log10^7\approx16$ — the RMS is
$x^{1/2}\bigl(\sum_{j\le J}|s_j|^{-2}\bigr)^{1/2}(1+o(1))$, i.e. **exactly
$x^{1/2}$ times a constant**. The fit therefore returns $1/2$ by construction,
and the script's own control (`sqrt(x)*cos(r_1 log x)` $\to$ fitted $0.5$)
demonstrates this. The proved exponent $3/4$ is an *upper bound* whose extremal
behaviour is governed by the $T\to\infty$ tail; it is invisible below any
reachable $x$ because $N(T)\sim T^2/12$ needs $T\sim x^{1/4}$ to bite. This is
the corpus's `HOLOGRAM.md` §7 lesson verbatim: the measured number has an
$X$-dependence hidden inside it, and once the $X$-dependence is derived the
number stops being evidence for anything.

**Statement replacing the fit.** For any fixed $J$ and $x$ in a range where
$\log x < \ell_{J}$ (the truncation scale), the smoothed $\psi$-error is
$x^{1/2}\cdot\Theta_J(\log x)$ with $\Theta_J$ an almost-periodic function of
$\log x$ built from $r_1,\dots,r_J$. Nothing in that statement is asymptotic in
$x$, and nothing in a fit over a bounded range can be.

### 2.3 The correlation coefficient in Part 5b is the trace formula itself

Part 5b would have printed
`correlation(classical oscillation, quantum sum)` to twelve digits. But the
"classical oscillation" is *defined in the script* as
$H+I+E_2+E_3+P-h(i/2)$, and the trace formula asserts
$I+E_2+E_3+H+P=h(i/2)+\sum_j h(r_j)$. Subtracting, the classical oscillation
**equals** $\sum_j h(r_j)$, the "quantum sum", identically — as an identity, not
as a correlation. The printed number would have been $1.000000000000$ minus
quadrature and truncation error, and its only content is the size of that
error, which the script does not analyse. CLAUDE.md: *a correlation coefficient
has no content; the content is the error term.* Here the error term is (i) the
Gauss–Legendre panel error on $[0,34]$, (ii) the geodesic truncation at
$k\ell\le u_{\max}$, whose tail is
$\ll e^{-u_{\max}^2/4\sigma^2}$-type by the Gaussian $g$, and (iii) the
spectral truncation at $r\le r_{\max}$, tail $\ll e^{-\sigma^2r_{\max}^2/2}
N(r_{\max})$. All three are derivable; none was reported.

---

## 3. The two sides, for the object the corpus actually studies

From here on $G=G_1*\cdots*G_k$ with SEED-08's alphabet $S=\bigsqcup S_i$,
$a_i=\sigma_i-1$, $M(x)_{ij}=[i\neq j]a_j(x)$, and
$$Z_G(x,t)=\frac{1}{\det(I-tM(x))}=\prod_{p\ \mathrm{prim}}\bigl(1-t^{\ell(p)}x^{|p|}\bigr)^{-1}$$
is SEED-61's Theorem B. I take Theorems A, B, C, T of SEED-61 and Theorems 1–3
of SEED-08 as given and do not reprove them.

**Classical results quoted, not reinvented.**

| label | statement | source |
|---|---|---|
| **Ih** | For $\Gamma$ a torsion-free cocompact discrete subgroup of $\mathrm{PGL}_2(\mathbb Q_p)$ (hence free of rank $r$), $\prod_{[\gamma]\,\mathrm{prim}}(1-u^{\ell(\gamma)})^{-1}=(1-u^2)^{-(r-1)}\det(I-Au+qu^2)^{-1}$. | Y. Ihara, *On discrete subgroups of the two by two projective linear group over $\mathfrak p$-adic fields*, J. Math. Soc. Japan **18** (1966) 219–235; Serre, *Trees*, II.§2 (the graph-theoretic reading). |
| **Ba** | Bass's determinant formula, and its extension to a group acting on a tree with finite quotient graph of finite groups (the tree-lattice zeta, over primitive hyperbolic conjugacy classes graded by translation length). | H. Bass, *The Ihara–Selberg zeta function of a tree lattice*, Internat. J. Math. **3** (1992) 717–797. |
| **Ha** | $Z_X(u)^{-1}=\det(I-uT)$, $T$ the non-backtracking (edge-adjacency) operator on the $2|E|$ directed edges. | K. Hashimoto, *Zeta functions of finite graphs and representations of $p$-adic groups*, Adv. Stud. Pure Math. **15** (1989) 211–280. |
| **BL** | $\exp\sum_\ell \operatorname{tr}(M^\ell)t^\ell/\ell=\det(I-tM)^{-1}$ and its Euler product over primitive orbits of a subshift of finite type. | Bowen–Lanford, *Zeta functions of restrictions of the shift transformation*, Proc. Sympos. Pure Math. **14** (1970). |
| **ST** | Bass's formula for finite graphs, expositions and the $u=1$ behaviour. | Stark–Terras, Adv. Math. **121** (1996) 124–165; Terras, *Zeta Functions of Graphs*, CUP 2011. |

Throughout, for a finite connected graph $X$ with adjacency $A$, degree matrix
$D$ and $Q=D-I$,
$$Z_X(u)^{-1}=(1-u^2)^{|E|-|V|}\det\bigl(I-Au+Qu^2\bigr). \tag{IB}$$

### 3.1 The lemma that does all the work

> **Lemma 0.** Let $X$ be a finite connected graph whose Ihara zeta is not
> identically $1$. Then $Z_X^{-1}(1)=0$.

*Proof.* $Z_X\equiv1$ exactly when $X$ has no cycle, i.e. $|E|<|V|$; so by
hypothesis $|E|\ge|V|$. If $|E|>|V|$ the prefactor $(1-u^2)^{|E|-|V|}$ in (IB)
vanishes at $u=1$. If $|E|=|V|$ the prefactor is $1$ and the determinant
factor at $u=1$ is $\det(I-A+Q)=\det(D-A)$, the graph Laplacian, which is
singular because its rows sum to zero (a loop contributes $2$ to both the
degree and the diagonal of $A$, so this holds for multigraphs with loops).
Either way $Z_X^{-1}(1)=0$. $\square$

Lemma 0 is the invariant that decides the conjecture. It is a statement about
*all* Ihara zetas, so a single non-vanishing value refutes membership.

---

## 4. The theorems

### 4.1 Theorem 1 — the identification is real, and it is the rose

> **Theorem 1.** Let $G=F_r$, $r\ge1$, presented as
> $\mathbb Z*\cdots*\mathbb Z$ with the alphabet $S_i=\{u_i^{\pm1}\}$ (so
> $\sigma_i=(1+x)/(1-x)$). Then, with $t=1$,
> $$\det\bigl(I-M(x)\bigr)\cdot(1-x)^{2r}\;=\;(1-x^2)^{r-1}\bigl(1-x\bigr)
> \bigl(1-(2r-1)x\bigr)\;=\;Z_{B_r}(x)^{-1},$$
> where $B_r$ is the rose (bouquet) of $r$ loops. Equivalently, writing
> $\widehat Z_G(x):=Z_G(x,1)\cdot\prod_{i=1}^{r}\prod_{\pm}\bigl(1-x^{|u_i^{\pm1}|}\bigr)^{-1}
> =Z_G(x,1)\,(1-x)^{-2r}$ for the zeta *completed* by the conjugacy classes
> interior to the free factors, one has
> $$\boxed{\ \widehat Z_{F_r}(x)\;=\;Z_{B_r}(x)\ }$$
> — SEED-61's $Z_G$ is the Ihara zeta of the rose with the elliptic-free,
> factor-interior orbits removed.

*Proof.* By SEED-61 Theorem A at $t=1$,
$\det(I-M)=\prod_i\sigma_i\cdot\bigl(\sum_i\sigma_i^{-1}-(k-1)\bigr)
=(1+a)^r\bigl(1-r\,a/(1+a)\bigr)$ with $a=2x/(1-x)$ (all factors equal).
Now $1+a=(1+x)/(1-x)$ and $a/(1+a)=2x/(1+x)$, so
$$\det(I-M)=\frac{(1+x)^r}{(1-x)^r}\cdot\frac{1+x-2rx}{1+x}
=\frac{(1+x)^{r-1}\bigl(1-(2r-1)x\bigr)}{(1-x)^{r}} .$$
Multiplying by $(1-x)^{2r}$ gives
$(1+x)^{r-1}(1-x)^{r}\bigl(1-(2r-1)x\bigr)$.
On the other side, $B_r$ has $|V|=1$, $|E|=r$, $A=(2r)$, $Q=(2r-1)$, so (IB)
reads $Z_{B_r}^{-1}=(1-u^2)^{r-1}\bigl(1-2ru+(2r-1)u^2\bigr)
=(1-u^2)^{r-1}(1-u)\bigl(1-(2r-1)u\bigr)$, which expands to
$(1+u)^{r-1}(1-u)^{r}\bigl(1-(2r-1)u\bigr)$. The two agree with $u=x$.

For the Euler-product form: the primitive conjugacy classes of $F_r$ contained
in a single free factor $\langle u_i\rangle$ are exactly $u_i$ and $u_i^{-1}$,
each of word length $1$ (a class $u_i^{m}$ with $|m|\ge2$ is a proper power),
so the omitted local factor is $\prod_i(1-x)^{-2}=(1-x)^{-2r}$; and the
primitive necklaces of SEED-61 Theorem B, at $t=1$ and $u=x$, are exactly the
primitive closed backtrackless tailless geodesics of $B_r$ that are not
contained in a single loop, both sets being the non-power conjugacy classes of
$F_r$ counted by cyclically reduced length. $\square$

**Two readings, both worth stating.**

1. The **conjecture's guess was right about the shape**: Theorem A's "product
   of local factors times one global factor" really is the Ihara–Bass
   "$(1-u^2)^{-\chi}$ times a determinant", with $(1-x)^{2r}$ playing the role
   of the local factors and $-\chi(B_r)=r-1$ appearing as the exponent.
2. But the graph produced is always the **rose**, never a general finite graph
   with $\pi_1=F_r$. The free-product alphabet is a free *basis*, and a basis
   collapses every graph with fundamental group $F_r$ to its rose. So the
   Ihara side cannot see the graph — which is SEED-60's verdict transported
   into the zeta: what is invisible to the coarse geometry is invisible here
   too, and for the same reason (a change of alphabet is a change of
   coordinates, SEED-60 Theorem B).

### 4.2 Theorem 2 — the literal conjecture is false, and $\chi$ is the obstruction

> **Theorem 2.** Let $G=G_1*\cdots*G_k$ with every $G_i$ **finite**, of order
> $n_i=|G_i|$, and $S_i=G_i\setminus\{1\}$ (so $a_i(x)=(n_i-1)x$ and
> $\sigma_i=1+(n_i-1)x$). Then, with $t=1$ and $u=x$,
> $$\boxed{\ \det\bigl(I-M(x)\bigr)\Big|_{x=1}\;=\;\chi(G)\cdot\prod_{i=1}^{k}n_i\ },
> \qquad \chi(G)=\sum_{i=1}^k\frac1{n_i}-(k-1),$$
> the rational Euler characteristic of $G$. Consequently, if $\chi(G)\neq0$
> then $Z_G(x,1)^{-1}$ does **not** vanish at $x=1$, and by Lemma 0 there is
> **no** finite connected graph $X$ with $Z_G(x,1)=Z_X(x)$.

*Proof.* SEED-61 Theorem A at $t=1$ gives
$\det(I-M)=\prod_i\sigma_i\cdot\bigl(\sum_i\sigma_i^{-1}-(k-1)\bigr)$. At
$x=1$, $\sigma_i(1)=1+(n_i-1)=n_i$, so this is
$\prod_i n_i\cdot\bigl(\sum_i n_i^{-1}-(k-1)\bigr)=\chi(G)\prod_i n_i$. The
formula $\chi=\sum\chi(G_i)-(k-1)$ with $\chi(\text{finite }H)=1/|H|$ is the
standard multiplicativity of the rational Euler characteristic under free
products (Wall; quoted, not reproved), and it is the same identity SEED-08 uses
in its consistency check for Fact R. Since $Z_G(x,1)^{-1}=\det(I-M(x))$ and
$Z_G$ has infinitely many Euler factors, $Z_G\not\equiv1$; Lemma 0 then denies
membership. $\square$

> **Corollary 2.1 ($\mathrm{PSL}_2(\mathbb Z)$).**
> $\bar\Gamma_0(1)=\mathbb Z/2*\mathbb Z/3$ has $k=2$, $a_1=x$, $a_2=2x$, hence
> $$Z_{\mathrm{PSL}_2(\mathbb Z)}(x,1)^{-1}=\det(I-M)=1-2x^2,$$
> and $1-2x^2\big|_{x=1}=-1=6\cdot(-\tfrac16)=\bigl(\prod n_i\bigr)\chi$, with
> $\chi(\mathrm{PSL}_2(\mathbb Z))=-1/6=-\mu/6$ at $\mu=1$. The zeta of the
> modular group is $1/(1-2x^2)$, it is not an Ihara zeta of a graph, and its
> "Riemann hypothesis" is the location of the two reciprocal zeros
> $x=\pm1/\sqrt2$.

> **Corollary 2.2 (a second, independent obstruction in the mixed case).** For
> $G=\mathbb Z/2*\mathbb Z=\bar\Gamma_0(2)$ one computes
> $\det(I-M)=1-a_1a_2=1-\tfrac{2x^2}{1-x}=\tfrac{(1-2x)(1+x)}{1-x}$, so the
> normalisation of Theorem 1 gives
> $\det(I-M)\cdot(1-x)^{2r}=(1-2x)(1+x)(1-x)$, a polynomial of **odd** degree
> $3$; but every $Z_X^{-1}$ from (IB) has even degree $2|E|$. So the mixed
> torsion/free case also fails to be an Ihara graph zeta under the
> Theorem-1 normalisation. *Proof.* Degree count in (IB):
> $2(|E|-|V|)+2|V|=2|E|$. $\square$

**What this settles.** SEED-61 §7.2 conjectured that $Z_G$ "specialises, for
$G$ the fundamental group of a finite graph of finite groups, to the Ihara
zeta of the quotient graph under an explicit substitution of $x$". Theorem 2
refutes that for $r=0$ and Corollary 2.2 for the simplest mixed case; Theorem 1
confirms it, exactly and with the guessed Euler-characteristic bookkeeping,
when the vertex groups are trivial. The conjecture's own instinct — that "the
two $-(k-1)$-type corrections are the same Euler-characteristic term" — is
*correct*, but the term shows up as the **value of the determinant at $u=1$**,
i.e. as the obstruction, rather than as a matching prefactor. That is the
whole content of the settlement.

### 4.3 Theorem 3 — the correct statement: Hashimoto operator, Bass determinant

> **Theorem 3.** $M(x)$ is the Hashimoto non-backtracking edge operator of the
> quotient graph of groups. Precisely: let $Y$ be the star with a central
> vertex carrying the trivial group and $k$ leaves carrying $G_1,\dots,G_k$
> and trivial edge groups, so that $\pi_1(Y)=G$ (Bass–Serre). Index the $k$
> edges of $Y$ by $1,\dots,k$. Then a closed geodesic in $Y$ is a sequence of
> edges $i_1,i_2,\dots,i_\ell$ with $i_j\neq i_{j+1}$ cyclically (no immediate
> backtrack: leaving a leaf along the edge one arrived on is the only forbidden
> move, and it is forbidden precisely by $M_{ii}=0$), decorated at the $j$-th
> bounce by a choice of nontrivial element of $G_{i_j}$ — which is exactly the
> weight $a_{i_j}(x)$. Hence
> $$\operatorname{tr}\bigl(M(x)^\ell\bigr)=\sum_{\text{closed geodesics of length }\ell}x^{\text{word length}},$$
> and $\det(I-tM(x))^{-1}$ is the corresponding **Bass tree-lattice zeta**
> [**Ba**] of $G$ acting on its Bass–Serre tree, in the edge-operator form of
> Hashimoto [**Ha**].
>
> The two variables are two gradings of the *same* orbit set:
> * $t^{\ell(p)}$ records **translation length in the Bass–Serre tree**: an
>   element of syllable length $\ell$ translates by $2\ell$ in the (bipartite,
>   biregular) tree, so $t\leftrightarrow$ the Bass/Ihara length variable;
> * $x^{|p|}$ records **word length in the alphabet $S$**, which is the
>   corpus's own grading (SEED-08's $c_n$, SEED-32's radius).
>
> Setting $x=1$ recovers the tree-lattice zeta graded by translation length;
> setting $t=1$ recovers the word-length zeta, which is an Ihara *graph* zeta
> only in the case of Theorem 1.

*Proof of the trace identity.* This is SEED-61 Theorem B step (i) re-read:
$\operatorname{tr}(M^\ell)=\sum a_{i_1}\cdots a_{i_\ell}$ over cyclic sequences
with $i_j\neq i_{j+1}$, and expanding $a_i=\sum_{h\in G_i\setminus1}x^{|h|}$
labels each bounce by a nontrivial element. The dictionary "cyclically
alternating tuple $\leftrightarrow$ closed non-backtracking walk in $Y$
decorated by vertex-group elements" is the definition of a closed path in a
graph of groups (Bass, *op. cit.* §1; Serre, *Trees* I.§5); the translation
length statement is that the normal form $h_1\cdots h_\ell$ has axis passing
through $\ell$ central vertices and $\ell$ leaf vertices per period. The
identification $\det(I-tM)^{-1}=\exp\sum\operatorname{tr}(M^\ell)t^\ell/\ell$
is [**BL**]. $\square$

**Consequence for SEED-61's §7.1 GUESS 1.** SEED-61 guessed there is no
arithmetic content in the $(q+1)$-regular tree of Theorem T. Theorem 3 makes
the tree explicit and unarithmetic: it is the Bass–Serre tree of a star of
groups, biregular of type $(n_1,\dots,n_k;k)$, and it is $(q+1)$-regular only
after the accidental coincidence $\nu_3=0$ makes the leaves have degree $2$ and
disappear into subdivisions. That does not prove GUESS 1, and I do not claim
to. It does show that the tree's valence is a bookkeeping consequence of the
graph of groups, as GUESS 1 asserted.

### 4.4 Which side each corpus quantity lives on

| quantity | side | reference |
|---|---|---|
| SEED-08 Theorem 4's necklace count $\mathcal N_\ell$; SEED-61's $\mathcal P_\ell$ | **prime-orbit (geometric)** | orbits of the shift; the Euler product |
| conjugacy classes of $\bar\Gamma_0(N)$ not conjugate into a factor | **prime-orbit** | SEED-61 Thm B, via Magnus–Karrass–Solitar |
| `exp64` Part 1's primitive hyperbolic classes of $\mathrm{PSL}_2(\mathbb Z)$ by trace | **prime-orbit**, in the *trace* grading | §4.5 |
| `exp64` Part 2's $h^+(D)$, Pell solutions, Sarnak's $3/8$ | **prime-orbit** | class numbers count the same orbits |
| $\lambda_N=\mu/3+1$ (SEED-08 Thm 3) | **spectral**: the Perron eigenvalue of $M$ | SEED-61 Cor A1 |
| the second reciprocal root $-2$ (SEED-61 Cor T1) | **spectral**: the subdominant eigenvalue | SEED-61 §5 |
| $D,E$ of SEED-08 Theorem 2 | **spectral**: coefficients of $\det(I-tM)$ | SEED-61 Thm A |
| SEED-08's sphere sizes $c_n$, $\sigma_G$ | **neither, and that is the point** — $\sigma_G=\prod\sigma_i/\det(I-M)$ is the *resolvent*, which is where the two sides are glued | SEED-61 Thm A |
| `exp64`'s Maass spectral parameters $r_j$ | **spectral, of a different object** — see §5 |

### 4.5 The same orbits, two gradings — and an exact prime-orbit theorem

`exp64` Part 1 enumerates the primitive hyperbolic conjugacy classes of
$\mathrm{PSL}_2(\mathbb Z)$ by **trace**; Corollary 2.1 counts the *same set*
by **syllable length**. The dictionary is explicit and exact, and it yields an
asymptotic with no error-exponent problem at all.

> **Proposition 4.** In $\mathrm{PSL}_2(\mathbb Z)=\langle s\rangle*\langle
> t\rangle$ with $S=\{s,t,t^{-1}\}$, $M(x)=\begin{pmatrix}0&2x\\x&0\end{pmatrix}$,
> so $\operatorname{tr}(M^{2m})=2(2x^2)^m$ and $\operatorname{tr}(M^{2m+1})=0$.
> Hence there are no primitive necklaces of odd syllable length, and the number
> $P_{2m}$ of primitive hyperbolic conjugacy classes of syllable length $2m$ is
> $$P_{2m}=\frac{1}{2m}\sum_{d\mid m}\mu(d)\,2\cdot 2^{\,m/d}
> \;=\;\frac{2^{m}}{m}\Bigl(1+O\bigl(2^{-m/2}\bigr)\Bigr),$$
> the error being an **exact finite sum** over the divisors, not an estimate.

*Proof.* SEED-61 Theorem C's Möbius form applied to
$\operatorname{tr}(M(x)^{\ell})$ at $x=1$; the parity statement is
$\operatorname{tr}(M^{\text{odd}})=0$ for a $2\times2$ zero-diagonal matrix.
$\square$

> **Corollary 4.1 (no error-exponent problem exists here).** For any
> $G=G_1*\cdots*G_k$, $\det(I-tM(x))$ is a polynomial of degree $\le k$ in $t$;
> its reciprocal roots $\theta_1(x),\dots,\theta_k(x)$ are the *entire*
> spectrum, and
> $$\operatorname{tr}\bigl(M(x)^\ell\bigr)=\sum_{i=1}^{k}\theta_i(x)^\ell$$
> is an identity, not an approximation. The prime-orbit count therefore has a
> main term $\theta_1^\ell/\ell$ and an error term bounded exactly by
> $(k-1)|\theta_2|^{\ell}/\ell$ plus the Möbius divisor terms. Where the
> modular *surface* has a proved exponent $3/4$, a record $113/164$ and a
> conjectural $1/2$, the growth-series object has **no** open exponent: the
> spectrum is finite and the analogue of the Riemann hypothesis is a
> finite factorisation. For $\nu_3=0$, SEED-61 Corollary T1 names both roots
> ($\lambda_N$ and $-2$), so the error is $O(2^\ell/\ell)$ against a main term
> $\lambda_N^\ell/\ell$ — a power saving of $(\mu/3+1)/2$ per syllable.

---

## 5. The Selberg analogy is the wrong one, and here is why

I was asked to state the trace formula for this object. The honest answer is
that it does not have one in the Selberg sense, and pretending otherwise would
reproduce the error CLAUDE.md exists to prevent. Plainly:

1. **There is no Laplacian and no continuous spectrum.** Selberg's formula for
   $\mathrm{PSL}_2(\mathbb Z)\backslash\mathbb H$ has an identity term
   proportional to the hyperbolic area, elliptic terms, a hyperbolic term over
   closed geodesics, and a **parabolic/scattering** term built from $\phi(s)$
   and Eisenstein series. Every one of those requires the *surface*. The
   corpus's object is $\bar\Gamma_0(N)$ **as a group with a declared
   alphabet**, acting on a **tree**. There is no cusp, no $\phi$, no
   $\Gamma'/\Gamma$, no $h(i/2)$ main term.
2. **The spectral side is finite.** By SEED-61 Theorem A the transfer operator
   is $k\times k$, and by SEED-08 the denominator has degree $2$: the entire
   spectrum is at most two numbers. Selberg's spectral side has Weyl density
   $N(T)\sim \frac{\mathrm{Area}}{4\pi}T^{2}$. The whole thesis of `exp64` —
   "location of zeros is not the whole story; density is" — is *vacuous* here,
   because the density is $O(1)$. Corollary 4.1 is the inversion: on this
   object **location is everything and density is nothing**.
3. **The right identity is Ihara–Bass, and it is a determinant, not a trace
   formula.** The bridge between the prime-orbit side (SEED-61's Euler product)
   and the spectral side (the eigenvalues of $M$) is
   $$\underbrace{\prod_{p\ \mathrm{prim}}\bigl(1-t^{\ell(p)}x^{|p|}\bigr)^{-1}}_{\text{orbits}}
   \;=\;\underbrace{\det\bigl(I-tM(x)\bigr)^{-1}}_{\text{spectrum}}
   \;=\;\prod_{i=1}^{k}\bigl(1-t\,\theta_i(x)\bigr)^{-1},$$
   which is SEED-61 Theorem B plus §4.3's identification of $M$ as a Hashimoto
   operator. Each side computes the other, exactly as the Selberg slogan
   demands — but by [**BL**]/[**Ha**]/[**Ba**], not by [Selberg].
4. **The analogy that *is* legitimate** is the $p$-adic one, and it is
   Ihara's: for a *torsion-free* cocompact lattice in $\mathrm{PGL}_2(\mathbb
   Q_p)$ Ihara's theorem [**Ih**] is the exact tree analogue of Selberg's, and
   Theorem 1 above is its rose case. Torsion breaks it in the precise way
   Theorem 2 quantifies, and Bass's tree-lattice zeta [**Ba**] is the
   repair. Saying "trace formula" where one means "Bass determinant" is an
   analogy asserted, not a theorem, and I decline to assert it.
5. **SEED-60 gives the third reason.** The whole level tower is one
   quasi-isometry class; the Selberg side, by contrast, distinguishes levels
   sharply (the Maass spectrum of $X_0(N)$ knows $N$). So a Selberg-type
   spectral side *cannot* be a function of the coarse object the corpus's
   growth series measures, and any bridge asserted between $\lambda_N$ and
   Maass eigenvalues is a category error. What $M$'s spectrum sees is the
   alphabet (SEED-60 Theorem B's scaling law), not the arithmetic.

---

## 6. Ledger

| # | Statement | Grade |
|---|---|---|
| 1 | $\phi(1/2)=-1$ by residues; `exp64`'s numerical check was unnecessary | **PROVED** (§2.1) |
| 2 | The windowed-RMS fit of §5 of `exp64` returns $1/2$ by construction over its range; the exponent is not measurable there | **PROVED** (§2.2), modulo the standard explicit formula, quoted |
| 3 | `exp64` Part 5b's correlation is the trace formula itself; its content is three derivable truncation errors | **PROVED** (§2.3) |
| 4 | Lemma 0: $Z_X^{-1}(1)=0$ for every finite connected graph with a cycle | **PROVED** (§3.1) |
| 5 | Theorem 1: $\widehat Z_{F_r}(x)=Z_{B_r}(x)$, exactly | **PROVED** (§4.1) — **settles** SEED-61 Conjecture 2 affirmatively in the torsion-free case |
| 6 | Theorem 2: $\det(I-M)|_{x=1}=\chi(G)\prod n_i$, hence not an Ihara graph zeta when $\chi\neq0$ | **PROVED** (§4.2) — **refutes** SEED-61 Conjecture 2 in its literal form |
| 7 | Corollary 2.1: $Z_{\mathrm{PSL}_2(\mathbb Z)}(x,1)=1/(1-2x^2)$ | **PROVED** |
| 8 | Corollary 2.2: odd-degree obstruction for $\mathbb Z/2*\mathbb Z$ | **PROVED** |
| 9 | Theorem 3: $M$ is the Hashimoto edge operator of the star graph of groups; $t\leftrightarrow$ translation length, $x\leftrightarrow$ word length | **PROVED** (§4.3), given Bass/Serre quoted |
| 10 | Proposition 4 and Corollary 4.1: exact prime-orbit asymptotic; no error-exponent problem | **PROVED** (§4.5) |
| 11 | The Selberg analogy is the wrong one for the growth-series object | **ARGUED** (§5); items 1–4 of §5 are proofs or citations, item 5 leans on SEED-60 |
| 12 | Whether the *completed* zeta $\widehat Z_G$ (including factor-interior classes) is an Ihara zeta when torsion is present | **OPEN.** For $(\mathbb Z/2)^{*3}$ the completed inverse is $(1-2u)(1+u)^2(1-u)^3$, which passes Lemma 0's test, so the $u=1$ obstruction does not decide it. Comparing against the three-loop rose, the theta graph, and the two two-vertex three-edge multigraphs excludes each of them by direct factorisation, but that is a spot check on four graphs, not a proof, and I state it as such. |

## 7. Rigor boundary and least-sure step

* Quoted and **not** reproved: Ihara's theorem, Bass's tree-lattice
  determinant, Hashimoto's edge-operator form, Bass's formula (IB) for finite
  graphs, the Bowen–Lanford determinant identity, multiplicativity of the
  rational Euler characteristic under free products (Wall), the normal-form and
  conjugacy theorems for free products, Fact R (Rademacher–Kulkarni), the
  Selberg trace formula and the explicit formula of §2.2, and SEED-08's and
  SEED-61's own theorems.
* No toolchain was available and none was needed; every computation above is a
  polynomial identity in one or two variables that a reader can redo by hand.
  `code/exp64_geodesic_spectrum.py` was read as text and **not executed**; no
  `.py` file was created or modified; `MATH_ALLOW_PYTHON` was not used.
* **Least-sure step, for a hostile reader:** Theorem 3's identification of a
  "closed path in the star graph of groups" with a cyclically alternating
  tuple. The dictionary is standard (Bass §1) but the *no-backtracking*
  condition deserves care: in $Y$ the only backtrack available at a leaf is to
  return along the arriving edge, which corresponds to $i_{j+1}=i_j$, killed by
  $M_{ii}=0$; at the central vertex, an arriving edge and a departing edge are
  distinct iff $i_{j+1}\neq i_j$ — the *same* condition. That the two coincide
  is why one $k\times k$ matrix suffices rather than a $2k\times2k$ directed-edge
  matrix, and a reader who wants Hashimoto's operator literally should note that
  the star's edges are undirected-with-a-leaf, so the directed-edge space folds
  in half. If that folding is contested, Theorems 1 and 2 are untouched: they
  are determinant computations that use only SEED-61 Theorem A.
* Theorem 1's Euler-product reading uses that syllable-rotation classes of
  alternating tuples and letter-rotation classes of cyclically reduced words
  both classify conjugacy classes; they do so via *different* rotation groups,
  and the statement is that the two quotients agree, not that the rotations do.
* Novelty claimed: none for any ingredient. What is earned is the composition
  and, specifically, the identification of $\chi(G)$ as the *obstruction* at
  $u=1$.

## 8. Successor seeds

* **PROVE.** Ledger item 12: decide whether $\widehat Z_G$ is an Ihara zeta for
  torsion-full $G$, by comparing with Bass's determinant for the star graph of
  groups directly rather than by graph search. I **conjecture** the answer is
  no for every $G$ with $\chi\neq0$ and at least one finite factor of order
  $\ge3$; this is a conjecture and nothing downstream should cite it as more.
* **PROVE.** Extend Theorem 2 to amalgamated and graph products (SEED-61's own
  successor seed): the value $\det(I-M)|_{x=1}$ should again be $\chi$ times a
  product of orders, by the same Euler-characteristic multiplicativity, with
  $C$ replaced by the commutation-graph complement.
* **DEMONSTRATE.** `code/exp64_geodesic_spectrum.py` is dead code with no
  note behind it (§1). It should be recorded in the legacy inventory as
  *unreachable and unrecorded*, so no future block mistakes its intended
  outputs for measured ones.
* **SEARCH.** Prior art for Theorem 2's exact evaluation
  $\det(I-M)|_{x=1}=\chi\prod|G_i|$. The shape is close enough to
  Bass's $\chi$-prefactor and to Serre's Euler-characteristic formalism that I
  expect it is known; I did not find it stated in this form and I looked before
  writing, not after.
