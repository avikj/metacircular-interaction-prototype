# Hypothesis U as a bilinear form: the DFI window, the sharp-cutoff loss, and the Goldbach floor

**Task:** adjudicate forecast **P₄ = 0.55** of `notes/TWO_WALLS_ONE_PROBLEM.md` §3
("Hypothesis U is dischargeable by *existing* technology of the
DFI/Bettin–Chandee class"), by attempting the reduction. Author: build worker
(Hua Luogeng persona), 2026-08-16. **Status: PENDING HOSTILE AUDIT.**

**Verdict returned: (ii) OBSTRUCTION**, with a (iii) SHARPENED FORECAST
attached. The obstruction has two independent halves — an exponent half
(§5.2, the sharp fiber puts the Duke–Friedlander–Iwaniec form outside its own
admissible window by a *power* of $n$) and a structural half (§5.3, no
bound of DFI type — valid for **every** $n$, uniformly in $Q$ — can beat the
main term, because it would prove binary Goldbach). The second half explains
why the first is not an accident of exponents.

**Sources read in full for this note.** `notes/TWO_WALLS_ONE_PROBLEM.md`
(all, esp. T0–T3, §3, §5.1), `notes/E2_PROOF.md` (all; Part 2 is
load-bearing), `notes/MERTENS_FLOOR.md` (all), `notes/METHOD.md` §1,
`notes/DIVISOR_HAHN_INCIDENCE.md` §5 (eqs. (5.1)–(5.4)).

**Rules of engagement.** §§2–4 are derived on the page or quoted from the
cited house proofs. §5 is the adjudication; each of its statements is either
proved here or explicitly conditioned on a recalled literature bound, and
every recalled exponent is marked **SEARCH-CONFIRMED-UNVERIFIED** (two
independent search summaries agree; the PDFs were *not* read — `arxiv.org` is
blocked by the egress proxy, see the SEARCH lines). §6 is FORECAST and is
labelled so. No numerics were run; no Python. No novelty is claimed for any
component: the expansion is `DIVISOR_HAHN_INCIDENCE.md` (5.1)/(5.4), the
identification is TWO_WALLS T1–T3, the bilinear bound is DFI's, the
transfer in §5.3 is Hardy's Ramanujan expansion plus the classical Goldbach
count. **Nothing in the corpus is struck or edited by this note.**

---

## 0. The one-sentence finding

The critical block of Hypothesis U ($d,e\asymp\sqrt n$, $Q\asymp\sqrt n$)
sits *inside* the Duke–Friedlander–Iwaniec admissible window and DFI saves
a power there — **but only for the $O(n^{o(1)})$ lowest Fourier modes of the
fiber cutoff, which is exactly the set a smooth cutoff would leave**; the
sharp Goldbach fiber forces the mode $k$ up to $[d,e]$, where DFI's
$(|\ell|+MN)^{3/8}$ factor makes the per-mode application worse than trivial
by $n^{35/96}$; the least repair of the exponents that would survive is
quantified in C2′ (saving $M^{1/4}$ at balance, twelve times DFI's), and no
repair at all can help the statement *as quantified in the corpus*, because a
bilinear bound valid for every $n$ that beat the main term uniformly in $Q$
would prove binary Goldbach for every large even $n$ (§5.3). What survives is a
*sharpened* target: the $n^{-2}$ aggregation that consumes $\mathcal O(n)$ is
an **average over $n$**, $n$ enters every phase **linearly**, and the average
therefore converts D0026 §5.7's incomplete Kloosterman fractions into
**complete geometric series** — no completion technology is required at all
(§5.4).

---

## 1. What E2_PROOF actually needs (and the printed Hypothesis U does not say)

### 1.1 The aggregation, written out

`notes/METHOD.md` §1 and `notes/E2_PROOF.md` §2.5 define the object through
$T(X)=\sum_{n\le X}(\Lambda*\Lambda)(n)/n^2$; the $[\sharp\sharp]$ block is
$T_{\sharp\sharp}(X)=\sum_{n\le X}n^{-2}\sum_{a+b=n}\Lambda^\sharp_Q(a)\Lambda^\sharp_Q(b)$
($a,b\ge1$), and M1′ reads
$$T_{\sharp\sharp}\text{-constant}=\kappa(Q)=\tfrac{A(Q)^2}{4}+2A(Q)S(Q)
+\bigl(\gamma-\textstyle\sum_{p\le Q}\frac{\log p}{(p-1)^2}\bigr)+\mathcal E(Q).$$
Insert U9 ($\sum_{a+b=n}\Lambda^\sharp_Q\Lambda^\sharp_Q=(n-1)\mathfrak S_Q(n)+\mathcal O(n)$)
and U10 ($\sum_{n\le X}\mathfrak S_Q(n)/n=\log X+\gamma-\sum_{p\le Q}\frac{\log p}{(p-1)^2}+o(1)$).
The $q=1$ term of $\mathfrak S_Q$ supplies the $\log X$; the three displayed
constants are exactly the pieces U10 and the *edge* of the convolution
supply. Writing, for $n\ge3$,
$$\boxed{\ \mathcal O^\flat(n):=\mathcal O(n)-2A(Q)\Lambda^\sharp_Q(n-1),\qquad
\mathcal O^\flat(2):=\mathcal O(2)-A(Q)^2\ }$$
(the two "edge rows" $a=1$ and $b=1$, which carry $\Lambda^\sharp_Q(1)=A(Q)$),
one has, identically,
$$\sum_{n\ge2}\frac{\mathcal O(n)}{n^2}
=\frac{A(Q)^2}{4}+2A(Q)S(Q)+\sum_{n\ge2}\frac{\mathcal O^\flat(n)}{n^2},$$
because $2A(Q)\sum_{n\ge3}\Lambda^\sharp_Q(n-1)n^{-2}=2A(Q)S(Q)$ by the
definition of $S(Q)$. Hence

> **Proposition A1 (the exact obligation).** Up to a bounded, absolutely
> convergent bookkeeping term ($\sum_{n\ge2}\mathfrak S_Q(n)/n^2$, which is
> $O(1)$ uniformly in $Q$ since $\mathfrak S_Q(n)\ll\log\log 3n$),
> $$\mathcal E(Q)=\sum_{n\ge2}\frac{\mathcal O^\flat(n)}{n^2}+O(1),$$
> and **the whole of ledger row H3 is the single statement
> $\sum_{n\ge2}\mathcal O^\flat(n)/n^2=O(1)$ uniformly in $Q$.**

*Proof.* The display above plus U9, U10 and the definition of $\kappa(Q)$;
every step is a finite rearrangement of absolutely convergent sums (for fixed
$Q$, $\Lambda^\sharp_Q$ is bounded and $|\mathcal O(n)|\ll_Q1$ by U9). $\square$

Three consequences are immediate and none of them is in the record:

1. **The requirement is an average over $n$, not a pointwise bound.**
2. **No positive power of $Q$ is affordable.** The weight $n^{-2}$ is
   summable from $n=2$ upward, so an error term $n^{1-\delta}Q^{c}$ with
   $c>0$ contributes $\gg Q^{c}$, never $O(1)$.
3. **The dyadic form of the requirement.** With $N$ running over powers of 2
   and $\mathcal E(Q)=O(1)$ required uniformly, one needs
   $$\sum_{N\le Q^2\log Q}\Bigl|N^{-2}\sum_{n\sim N}\mathcal O^\flat(n)\Bigr|=O(1),$$
   i.e. **a saving of $\log^{2+\varepsilon}Q$ over the pointwise $\ell^2$-trivial
   bound $|\mathcal O(n)|\ll nA(Q)$, in every dyadic block below $Q^2\log Q$**
   — there are $\asymp\log Q$ such blocks and the trivial bound gives
   $A(Q)\asymp\log Q$ per block, which is precisely E2_PROOF's
   $\mathcal E(Q)\ll\log^2Q$.

### 1.2 Hypothesis U as printed is a theorem

> **Proposition A2.** Hypothesis U as printed in `E2_PROOF.md` §2.5 —
> *for some $\delta>0$, uniformly in $n,Q$,
> $\sum_{a+b=n}\Lambda^\sharp_Q(a)\Lambda^\sharp_Q(b)=n\mathfrak S_Q(n)+O(n^{1-\delta}Q^{O(1)}+\log^{O(1)}Q)$* —
> **follows from the already-proved U9**, for every $\delta\in(0,1)$, with the
> unspecified exponent $O(1)$ on $Q$ taken to be $3$.

*Proof.* U9 gives $\sum_{a+b=n}\Lambda^\sharp_Q\Lambda^\sharp_Q-(n-1)\mathfrak S_Q(n)=\mathcal O(n)$
with $|\mathcal O(n)|\ll Q^2\log Q\le Q^3$ uniformly in $n$; and
$|\mathfrak S_Q(n)|\ll\log\log3n\ll Q^3$. Hence the total deviation from
$n\mathfrak S_Q(n)$ is $\ll Q^{3}\le n^{1-\delta}Q^{3}$ for every $n\ge1$ and
every $\delta<1$. $\square$

This is not a quibble about quantifiers; it has a consequence for the record:

> **Corollary A2′.** The printed Hypothesis U cannot imply
> $\mathcal E(Q)=O(1)$, since it is implied by a proved statement that does
> not. Ledger row H3 of `E2_PROOF.md` ("Hypothesis U — unproved, the live
> gap") is **mis-stated**: as printed the hypothesis is proved and
> insufficient; the live gap is Proposition A1's aggregated statement.
> `TWO_WALLS_ONE_PROBLEM.md` ledger row **T7 flagged exactly this** ("E2_PROOF
> states the implication without spelling the $n$-aggregation … Flagged for the
> audit"); the present note discharges T7 and identifies the defect as the
> unquantified $Q^{O(1)}$ together with the un-extracted edge rows. **Nothing
> is struck**: U9, U10, M1′ and the bound $\mathcal E(Q)\ll\log^2Q$ are
> untouched, and T3's live-range computation survives verbatim once
> Hypothesis U is replaced by U♭ below.

### 1.3 The repaired hypothesis

> **Hypothesis U♭ (aggregated; this is what H3 must become).** Uniformly in
> $Q\ge2$,
> $$\sum_{n\ge2}\frac{\mathcal O^\flat(n)}{n^2}=O(1),$$
> equivalently: for each dyadic $N\le Q^2\log Q$,
> $\ \bigl|\sum_{n\sim N}\mathcal O^\flat(n)\bigr|\ll N^2\,\omega(N,Q)$ with
> $\sum_N\omega(N,Q)=O(1)$ — e.g. $\omega=(\log(2N)\log Q)^{-1-\varepsilon}$,
> or any power saving $\omega=(N/Q^2)^{\delta}$ in the top blocks together
> with an exceptional-set-tolerant bound below.

T3(i) of TWO_WALLS survives: for $N\ge Q^2\log Q$ the U9 bound already gives
$\omega\ll (Q^2\log Q)/N$, summable. **All unproved content is
$N\le Q^{2+o(1)}$, unchanged.**

---

## 2. The bilinear form, with supports, lengths and phases

Throughout $A_d=d\sum_{q\le Q,\,d\mid q}\mu(q)\mu(q/d)/\varphi(q)$
(`MERTENS_FLOOR.md` §1), supported on squarefree $d\le Q$, with the closed
form proved there,
$$A_d=\frac{d\,\mu(d)}{\varphi(d)}\,\Sigma_d(Q/d),\qquad
\Sigma_d(Y)=\sum_{m\le Y,\ (m,d)=1}\frac{\mu^2(m)}{\varphi(m)} ,$$
so that by U2, $A_d=\mu(d)\bigl(\log(Q/d)+C_d\bigr)+\frac{d\mu(d)}{\varphi(d)}E_d(Q/d)$.

> **Lemma B1 (coefficient ledger).** For squarefree $d\le Q$:
> $|A_d|\le\frac{d}{\varphi(d)}A(Q)\ll\log Q\log\log Q$; consequently
> $\|A\|_1:=\sum_{d\le Q}|A_d|\ll Q\log Q\log\log Q$ and
> $\|A\|_2\ll Q^{1/2}\log Q\log\log Q$, while $\|A\|_2\gg Q^{1/2}$ and
> $\|A\|_1\gg Q$. Two exact constraints tie the coefficients:
> $$\sum_{d\le Q}A_d=M(Q)\quad\text{and}\quad\sum_{d\le Q}\frac{A_d}{d}=1
> \qquad(\text{`MERTENS\_FLOOR.md` Lemma 1}).$$

*Proof.* The upper bounds are $\Sigma_d(Y)\le\Sigma_1(Q)=A(Q)$ and
$d/\varphi(d)\ll\log\log 3d$; $\|A\|_2^2\ge\sum_{Q/2<d\le Q}A_d^2\gg Q$ from
$|A_d|\gg1$ there. The two identities are quoted, not re-proved. $\square$

The second identity is the reason nothing here is "arbitrary coefficients with
a free $\ell^1$ norm": the $\ell^1$ mass is $\asymp Q$ but the *signed* mass is
$M(Q)$, and `MERTENS_FLOOR.md` §3.1 proves that this signed mass is exactly
the obstruction that survives sharp truncation. Keep both facts in view: DFI
takes arbitrary coefficients, so the Möbius coherence of $A$ is **not** an
obstruction to applying DFI (this answers the brief's worry (a) — see §5.1);
it *is* the obstruction to the last step of the averaged route (§5.4).

> **Lemma B2 (the boundary operator with its general gcd phase; exact).**
> For $n\ge2$, with $g=(d,e)$, $d=gd'$, $e=ge'$, $(d',e')=1$, $L=[d,e]=gd'e'$,
> $$\mathcal O(n)=\sum_{\substack{d,e\le Q\\ g\mid n}}A_dA_e\,B_{n-1}\bigl(a^*(d,e;n),L\bigr),
> \qquad \frac{a^*(d,e;n)}{L}\equiv\frac{(n/g)\,\overline{d'}}{e'}\pmod 1,$$
> where $\overline{d'}d'\equiv1\pmod{e'}$ and
> $B_N(a,L)=\#\{1\le a'\le N:a'\equiv a\ (L)\}-N/L$. Finite Fourier inversion
> gives
> $$\mathcal O(n)=\sum_{\substack{d,e\le Q\\ g\mid n}}\frac{A_dA_e}{L}
> \sum_{0<|k|\le L/2} D_{n-1}\!\Bigl(\frac kL\Bigr)\,
> e\!\Bigl(-\frac{k\,(n/g)\,\overline{d'}}{e'}\Bigr),\qquad
> D_N(\theta)=\sum_{m=1}^{N}e(m\theta).$$

*Proof.* The first display is TWO_WALLS Proposition T1 (finite rearrangement
of $\Lambda^\sharp_Q=1*A^{(Q)}$ plus CRT), with the residue computed for
general $g$: $a^*=gd't$ and $gd't\equiv n\ (ge')$ with $g\mid n$ gives
$d't\equiv n/g\ (e')$, so $t\equiv(n/g)\overline{d'}\ (e')$ and
$a^*/L=t/e'$. At $g=1$ this is T2 verbatim ($h=-n$). The second display is
`DIVISOR_HAHN_INCIDENCE.md` (5.1)/(5.4) with kernel $A$, quoted; no novelty
claimed. $\square$

> **Lemma B3 (amplitude).** $\bigl|L^{-1}D_{n-1}(k/L)\bigr|\le\min\bigl(n/L,\ (2|k|)^{-1}\bigr)$
> for $0<|k|\le L/2$. In particular for $L\le n$ the weight is the pure
> harmonic $1/(2|k|)$ over the whole range $|k|\le L/2$, and the mode sum has
> $\asymp L$ terms with total weight $\asymp\log L$.

*Proof.* $|D_N(\theta)|\le\min(N,\|\theta\|^{-1}/2)$ and $\|k/L\|=|k|/L$. $\square$

**Supports, lengths, and which variable is long.** After a dyadic split
$d\sim D$, $e\sim E$ ($D,E\le Q$) and $g$ fixed, the object per $(g,k)$ is
$$T_{g,k}(n;D,E)=\sum_{\substack{d'\sim D/g,\ e'\sim E/g\\ (d',e')=1}}
\alpha_{d'}\beta_{e'}\,e\!\Bigl(\frac{\ell\,\overline{d'}}{e'}\Bigr),
\qquad \alpha_{d'}=A_{gd'},\ \beta_{e'}=A_{ge'},\ \ \ell=-k\,n/g .$$
This is **exactly** the DFI shape. The *modulus* variable is $e'$ (length
$E/g\le Q$); the *inverted* variable is $d'$ (length $D/g\le Q$); the
numerator is $\ell=-kn/g$, and it is **not bounded by the modulus** — it grows
linearly in the Fourier mode $k$, which runs to $L/2=gd'e'/2$. At the first
balanced block ($g=1$, $D=E\asymp\sqrt n$, $Q\asymp\sqrt n$) the two variables
are of **equal** length — the best case for DFI — while $|\ell|$ runs up to
$\asymp n\cdot de\asymp n^2=(MN)^2$. **The long/short question has a
three-word answer: neither is long, and the numerator is.** That single fact
is the whole adjudication.

---

## 3. The uniformity in $n$ and $Q$ that is really required

Collecting §1 and §2, the target in DFI coordinates is: for every dyadic
$N\le Q^2\log Q$,
$$\Bigl|\sum_{n\sim N}\frac{1}{n^2}\sum_{g\mid n}\ \sum_{k}\ \frac{D_{n-1}(k/L)}{L}\,
T_{g,k}(n;D,E)\Bigr|\ \ \text{summed over dyadic }(D,E)\ \ll\ \omega(N,Q),
\quad \textstyle\sum_N\omega=O(1).$$
Two features decide everything:

- **(U-i) The uniformity needed is in $n$ — the numerator side.** $n$ enters
  DFI's form only through $\ell=-kn/g$. DFI's bound *is* uniform in $\ell$
  (arbitrary $\ell\ne0$), but it is not *flat* in $\ell$: it degrades as
  $|\ell|$ grows (§4). So the uniformity is on the right side, but it is
  purchased at a price that grows with $k$.
- **(U-ii) The uniformity needed in $Q$ is absolute ($c=0$ in $Q^c$)**, by
  Proposition A1(2). DFI's bound has no $Q$ in it — $Q$ enters only through
  the lengths $D,E\le Q$ and through $\|\alpha\|_2,\|\beta\|_2$, both of which
  are accounted by Lemma B1. So the $Q$-uniformity is **not** where the DFI
  route fails.

---

## 4. Duke–Friedlander–Iwaniec, recalled

**Grade: search-summary (śabda). Two independent web searches returned the
same statement; `arxiv.org` and the publisher PDFs are blocked by the egress
proxy, so nothing was read. Every exponent below is
SEARCH-CONFIRMED-UNVERIFIED and is used only where §5 says explicitly that it
is or is not load-bearing.**

> **Theorem (Duke–Friedlander–Iwaniec, *Bilinear forms with Kloosterman
> fractions*, Invent. Math. **128** (1997) 23–43).**
> **[SEARCH-CONFIRMED-UNVERIFIED]** For arbitrary complex $(\alpha_m)$,
> $(\beta_n)$ supported on $[M,2M)$, $[N,2N)$, any integer $\ell\ne0$, and a
> smooth weight $F(x,y)$ with derivative parameter $\Delta$,
> $$\sum_{\substack{m,n\\ (m,n)=1}}\alpha_m\beta_n\,e\!\Bigl(\frac{\ell\,\overline m}{n}\Bigr)F(m,n)
> \ \ll_\varepsilon\ \Delta^2\,\|\alpha\|_2\|\beta\|_2\,
> \bigl(|\ell|+MN\bigr)^{3/8}\,(M+N)^{11/48+\varepsilon}.$$

Sanity check of the recalled shape (this check is *derivation*, not
literature): at $M=N$, $|\ell|\ll MN$ the bound is
$\|\alpha\|_2\|\beta\|_2M^{3/4+11/48}=\|\alpha\|_2\|\beta\|_2M^{47/48}$
against the trivial $\|\alpha\|_1\|\beta\|_1\le\|\alpha\|_2\|\beta\|_2 M$ —
a saving of $M^{1/48}$, i.e. **nontrivial exactly in the balanced range and
only just**. The shape is therefore consistent with the folklore that DFI is a
balanced-range theorem with a small power saving; if the true exponents differ,
§5.2's threshold moves but §5.2's *sign* does not (see the remark closing
§5.2). Related: Bettin–Chandee, *Trilinear forms with Kloosterman fractions*,
Adv. Math. (2018), arXiv:1502.00769, extends this to
$\sum_a\sum_m\sum_n\alpha_a\beta_m\nu_n e(a m\overline n/n)$; not used below.

---

## 5. The adjudication

### 5.1 The coefficient class is not an obstruction (brief's worry (a))

DFI takes **arbitrary** $\alpha,\beta$ with only $\|\cdot\|_2$ entering. Our
$\alpha_{d'}=A_{gd'}$, $\beta_{e'}=A_{ge'}$ are therefore admissible with no
hypothesis whatever on their factorization, and Lemma B1 supplies the norms:
at the balanced block $\|\alpha\|_2\|\beta\|_2\ll (DE)^{1/2}\log^2Q\log\log^2Q$.
**Worry (a) is dissolved: the Ramanujan/Möbius coherence of $A^{(Q)}$ costs
nothing at the DFI step.** (It costs everything at the *last* step of the
averaged route — §5.4 — but that is a different step and a different tool.)
Likewise the coprimality $(d',e')=1$ is exactly DFI's own support condition,
and the gcd $g$ has been separated in Lemma B2 without residue.

### 5.2 The exponent half of the obstruction: the sharp fiber leaves the window

Work at the first balanced block: $g=1$, $Q\asymp\sqrt n$, $D=E\asymp\sqrt n$,
$L=de\asymp n$, so $\ell=-kn$ and $|\ell|/MN\asymp k$. Write $\theta$ for
$\varepsilon$-powers of $n$ and $\mathcal L$ for $(\log Q)^{O(1)}$.

> **Proposition C1 (DFI on one mode).** With the recalled bound, for
> $1\le k\le L/2$,
> $$|T_{1,k}(n;D,E)|\ \ll_\varepsilon\ \mathcal L\,n^{1/2}\,(kn)^{3/8}\,n^{11/96+\varepsilon}
> \ =\ \mathcal L\,k^{3/8}\,n^{95/96+\varepsilon}.$$
> **[exponents SEARCH-CONFIRMED-UNVERIFIED; the derivation from them is mine]**

*Proof.* $\|\alpha\|_2\|\beta\|_2\ll(DE)^{1/2}\mathcal L=n^{1/2}\mathcal L$
(Lemma B1); $(|\ell|+MN)^{3/8}=(kn+n)^{3/8}\asymp(kn)^{3/8}$;
$(M+N)^{11/48}\asymp n^{11/96}$. Add
$\tfrac12+\tfrac38+\tfrac{11}{96}=\tfrac{48+36+11}{96}=\tfrac{95}{96}$. $\square$

> **Theorem C2 (the sharp-cutoff loss).** Applying the recalled DFI bound mode
> by mode to Lemma B2's expansion at the balanced block gives
> $$\sum_{1\le k\le L/2}\frac{1}{k}\,|T_{1,k}|
> \ \ll\ \mathcal L\,n^{95/96}\sum_{k\le n/2}k^{-5/8}
> \ \asymp\ \mathcal L\,n^{95/96+3/8}=\mathcal L\,n^{131/96},$$
> which exceeds the **trivial** bound $\ll Q^2\log Q\asymp n\log n$ (U9) by
> $n^{35/96}=n^{0.3645\ldots}$. Restricted to modes $k\le K$ the same
> computation gives $\mathcal L\,n^{95/96}K^{3/8}$, which beats trivial **iff**
> $$K\ \ll\ n^{1/36}.$$
> A smooth fiber cutoff confines the modes to $k\ll n^{o(1)}$ and therefore
> lands strictly inside this window; the sharp fiber needs $k$ up to
> $L/2\asymp n/2$ and lands $n^{35/96}$ outside it.

*Proof.* Lemma B3 gives the weight $1/(2k)$ throughout ($L\le n$ at balance);
$\sum_{k\le K}k^{-5/8}\asymp K^{3/8}$; the threshold is
$K^{3/8}\ll n^{1/96}$, i.e. $K\ll n^{8/288}=n^{1/36}$. $\square$

> **Proposition C3 (the positive half: the smoothed statement *is*
> dischargeable).** If the fiber is smoothed — equivalently, if the mode sum
> is restricted to $|k|\le n^{\varepsilon}$ — then summing the recalled DFI
> bound over all dyadic blocks $(D,E)$ with $D,E\le Q\asymp\sqrt n$, using
> the trivial bound $\ll\|\alpha\|_1\|\beta\|_1$ on the blocks where DFI is
> worse, gives
> $$\bigl|\mathcal O^{\mathrm{smooth}}(n)\bigr|\ \ll_\varepsilon\ n^{1-1/48+\varepsilon}.$$

*Proof.* On block $(D,E)$ with $L_0=DE$ the recalled bound with $k\ll n^\varepsilon$
is $\ll L_0^{1/2}\cdot L_0^{3/8}\cdot(D+E)^{11/48}n^{\varepsilon}
=L_0^{7/8}(D+E)^{11/48}n^\varepsilon$, against the trivial $L_0$. DFI wins iff
$L_0^{1/8}\gg(D+E)^{11/48}$. With $D\asymp Q$: the crossover is at
$E\asymp Q^{5/6}$, so blocks with $E\ge Q^{5/6}$ (and symmetrically) are
handled by DFI, giving $\ll Q^{2\cdot7/8+11/48}=Q^{2-1/24}$ at the top block,
and the remaining blocks are $\ll Q\cdot Q^{5/6}=Q^{11/6}$ trivially. Both are
$\ll Q^{2-1/24}=n^{1-1/48}$. The $g>1$ aggregation shortens both lengths and
is dominated by $g=1$; I have **not** written that aggregation out (ledger
V4). $\square$

**Remark (what is load-bearing).** C3's exponent $1/48$ and C2's threshold
$n^{1/36}$ depend on the recalled constants $3/8,11/48$. C2's *conclusion*
does not. Take any bound of the shape
$\|\alpha\|_2\|\beta\|_2(|\ell|+MN)^{c_1}(M+N)^{c_2}$ with $c_1,c_2\ge0$,
$c_1>0$. Over a harmonic mode sum restricted to $|k|\le K$ it costs a factor
$\asymp K^{c_1}/c_1$, so at the balanced block $M=N$, $MN\asymp n$ it beats the
trivial bound $\|\alpha\|_1\|\beta\|_1\le(MN)^{1/2}\|\alpha\|_2\|\beta\|_2$
if and only if
$$K^{c_1}\ \ll\ (MN)^{1/2-c_1}(M+N)^{-c_2}\ \asymp\ n^{\frac12(1-2c_1-c_2)},
\qquad\text{i.e.}\qquad K\ \ll\ n^{\frac{1-2c_1-c_2}{2c_1}} .$$
The exponent on the right is a *fixed* number; the sharp fiber needs
$K\asymp[d,e]\asymp n$, so **the method survives if and only if
$4c_1+c_2\le1$.** The recalled DFI pair gives $4\cdot\tfrac38+\tfrac{11}{48}
=\tfrac{83}{48}=1.729\ldots>1$, and fails by a wide margin; so the verdict is
robust to a large error in the recalled constants, but it is *not*
unconditional in $(c_1,c_2)$, and the honest form of the no-go is a
quantitative one:

> **Corollary C2′ (what a bilinear bound would have to look like).** For a
> bound of the above shape to survive the sharp fiber at the balanced block
> one needs $4c_1+c_2\le1$; combined with the unconditional lower bound
> $(|\ell|+MN)^{c_1}(M+N)^{c_2}\gg M^{1/2}$ at $M=N$ (take $\beta$ supported at
> a single point $e_0$ and $\alpha_d=\overline{e(\ell\overline d/e_0)}$, which
> makes the form equal $\|\alpha\|_1|\beta_{e_0}|=M^{1/2}\|\alpha\|_2\|\beta\|_2$),
> this forces $2c_1+c_2\ge\tfrac12$ and hence a saving over trivial of
> $M^{1-2c_1-c_2}$ with $2c_1\le 1-2c_1-c_2\le\tfrac12$. Concretely: an
> admissible pair is $(c_1,c_2)=(\tfrac18,\tfrac12)$, i.e. **a bilinear
> Kloosterman-fraction bound saving $M^{1/4}$ at balance with $\ell$-dependence
> no worse than $|\ell|^{1/8}$** — against DFI's actual $M^{1/48}$ and
> $|\ell|^{3/8}$. That is the precise strengthening the sharp fiber demands;
> nothing weaker in this family will do.

### 5.3 The structural half: why no exponent repair can help

The failure in §5.2 is not bad luck. Here is the reason, and it is the
durable part of this note.

> **Theorem C4 (the Goldbach floor).** Suppose there are $\eta(n)$ with
> $\limsup_{n\to\infty,\,2\mid n}\eta(n)<\mathfrak S_{\min}:=\inf_{2\mid n}\mathfrak S(n)$
> such that, **uniformly in $Q$**,
> $$|\mathcal O^\flat(n)|\ \le\ \eta(n)\,n \qquad\text{for all even }n .$$
> Then every sufficiently large even $n$ is a sum of two primes.

*Proof.* Fix an even $n$ and let $Q\to\infty$. The sum defining
$\mathcal O^\flat(n)$ has boundedly many terms, and each is a fixed
$\Lambda^\sharp_Q$-value:
$$\mathcal O^\flat(n)=\sum_{\substack{a+b=n\\ a,b\ge2}}\Lambda^\sharp_Q(a)\Lambda^\sharp_Q(b)-(n-1)\mathfrak S_Q(n).$$
By U3 (= Hardy 1921, `E2_PROOF.md` H6 RESOLVED-FOUND),
$\Lambda^\sharp_Q(a)\to\frac{\varphi(a)}{a}\Lambda(a)$ for each fixed $a\ge2$;
and $\mathfrak S_Q(n)\to\mathfrak S(n)$. Hence
$$\lim_{Q\to\infty}\mathcal O^\flat(n)=G(n)-(n-1)\mathfrak S(n),\qquad
G(n):=\sum_{\substack{a+b=n\\ a,b\ge2}}\frac{\varphi(a)\varphi(b)}{ab}\Lambda(a)\Lambda(b)\ \ge0 .$$
The hypothesis therefore forces $G(n)\ge(n-1)\mathfrak S(n)-\eta(n)n>0$ for all
large even $n$. $G(n)>0$ means $n=p^i+q^j$ with $i,j\ge1$; the contribution of
terms with $\max(i,j)\ge2$ to $G(n)$ is
$\ll\sum_{p^i\le n,\,i\ge2}\log p\cdot\log n\ll n^{1/2}\log^2n=o(n)$, so for
large $n$ a term with $i=j=1$ must occur. $\square$

Two corollaries, both load-bearing for the verdict:

> **Corollary C5 (no pointwise route, at any strength).** No estimate valid
> for **every** $n$ and uniformly in $Q$ can beat the main term in
> $\mathcal O^\flat$ — of any savings shape, however weak — without proving
> binary Goldbach. In particular the natural repairs of Hypothesis U
> ("$O(n^{1-\delta})$ uniformly in $n,Q$", or "$o(n)$ uniformly in $n,Q$")
> are **Goldbach-hard**, and the printed shape avoids this only by being
> vacuous (Proposition A2).

> **Corollary C6 (an exceptional set is compulsory, and affordable).** The
> aggregated Hypothesis U♭ tolerates an exceptional set $S$ with
> $\sum_{n\in S}n^{-1}<\infty$, since such $n$ contribute
> $\ll\sum_{n\in S}n^{-1}\cdot\sup|\mathcal O^\flat(n)|/n$ — and by
> Montgomery–Vaughan's exceptional-set theorem ($\#\{n\le X: n\text{ even},
> \text{not }p+p'\}\ll X^{1-\delta}$, RECALLED-UNVERIFIED) a set of that size is
> exactly what is known to be unavoidable-in-practice. **So U♭ is not
> Goldbach-hard while every pointwise version is.** The gap between H3 as
> written and H3 as needed is precisely an exceptional set.

**Consequence for P₄, stated exactly.** DFI-type theorems are *pointwise in
$\ell$*: they hold for every integer $\ell\ne0$, hence — here — for every $n$.
By C5, no such theorem, at any exponents, can deliver a bound on
$\mathcal O^\flat(n)$ that beats the main term for every $n$, uniformly in $Q$.
Therefore **the DFI route must fail somewhere; §5.2 exhibits where (the
harmonic mode sum forced by the sharp fiber), and §5.3 explains that the
failure is compulsory.** This is the adjudication of P₄, and it is a
no-go for the route *as posed in TWO_WALLS §5.1 item 1*, not a claim about the
truth of U♭.

**Scope of C4/C5 (important).** The transfer $\Lambda^\sharp_Q\to\frac{\varphi}{\rm id}\Lambda$
used in C4 needs $Q\to\infty$ with $n$ fixed, i.e. it constrains the sub-range
$n\ll Q^{1-\varepsilon}$ of the live range. It does **not** constrain
$\sqrt n\lesssim Q\lesssim n^{1-\varepsilon}$, where $\Lambda^\sharp_Q$ is a
level-$Q\le n$ sieve weight, the problem is parity-free (TWO_WALLS §2 kernel
row), and §5.2 is the only obstruction. C5's force against a *uniform in
$n,Q$* DFI application is undiminished, because such an application would in
particular cover $Q\ge n^{1+\varepsilon}$.

### 5.4 The sharpened forecast: the $n$-average linearizes the phase

Proposition A1 says the aggregation is an average over $n$. That is not a
technicality; it changes the tool.

> **Proposition C7 (the free variable is the numerator).** In Lemma B2's
> expansion, write $n=gm$ and use
> $D_{n-1}(k/L)=\bigl(e(nk/L)-e(k/L)\bigr)\big/\bigl(e(k/L)-1\bigr)$. Then the
> entire $n$-dependence of the $(d,e,k)$ term is the pair of additive
> characters
> $$e\Bigl(mk\Bigl[\frac{1}{d'e'}-\frac{\overline{d'}}{e'}\Bigr]\Bigr)
> =e\Bigl(\frac{mk\,\overline{e'}}{d'}\Bigr)
> \qquad\text{and}\qquad e\Bigl(-\frac{mk\,\overline{d'}}{e'}\Bigr),$$
> by the reciprocity $\frac{\overline{d'}}{e'}+\frac{\overline{e'}}{d'}\equiv\frac{1}{d'e'}\pmod1$.
> Consequently, for any weight $w$ of bounded variation on $n\sim N$,
> $$\sum_{n\sim N}w(n)\,(\text{term})\ \ll\ \frac{1}{|k|}\Bigl[
> \min\Bigl(\frac Ng,\bigl\|\tfrac{k\overline{e'}}{d'}\bigr\|^{-1}\Bigr)
> +\min\Bigl(\frac Ng,\bigl\|\tfrac{k\overline{d'}}{e'}\bigr\|^{-1}\Bigr)\Bigr]\cdot\|w\|_{BV}.$$

*Proof.* $a^*/L\equiv(n/g)\overline{d'}/e'$ (Lemma B2) and $nk/L=mk/(d'e')$ are
both linear in $m=n/g$; add the exponents and apply reciprocity. The estimate
is the geometric series $\sum_{m\sim N/g}e(m\theta)\ll\min(N/g,\|\theta\|^{-1})$
plus partial summation; the amplitude $|e(k/L)-1|^{-1}L^{-1}\asymp|k|^{-1}$ is
Lemma B3. $\square$

Three things follow, and they are the sharpened forecast:

1. **The completion problem dissolves on the diagonal slice.** D0026 §5.7's
   obligation — "complete incomplete Kloosterman fractions and control the
   Gauss change of basis uniformly in critical moduli and Poisson frequencies"
   — is posed for fixed shift and free interval. On the repo's slice
   $h=-n$, $X=n$, the shift *is* the free variable, it enters the phase
   linearly, and averaging it replaces every incomplete Kloosterman fraction
   by a **complete geometric series**. No Kloosterman completion, no Gauss
   transform, no spectral large sieve is needed for this step. (This does not
   help D0026: their $h$ and $X$ are independent, so they cannot average one
   into the other. It is a genuine asymmetry between the two walls, and it
   *reverses* TWO_WALLS §5.1's routing advice for item 1.)
2. **The large-$k$ tail is annihilated by the average.** By C7 the modes with
   $\|k\overline{d'}/e'\|\gg g/N$ *and* $\|k\overline{e'}/d'\|\gg g/N$
   contribute $\ll\frac{g}{k}\cdot\frac{N}{g}\cdot$(nothing), i.e. are damped by
   $N^{-1}$ relative to the pointwise bound. The surviving modes are those with
   $e'\mid k$ or $d'\mid k$ (for $d',e'\le N/g$) — i.e. **the phase becomes
   trivial exactly on the surviving set**. This is the precise sense in which
   the $n$-average does for the sharp fiber what smoothing does for D0026's
   $W$: it restores C2's admissible window.
3. **What is left is a Mertens problem, not a Kloosterman problem.** On the
   surviving set the phases are $1$ and the residual is
   $\ \asymp N^{-1}\sum_{g}\sum_{d',e'}A_{gd'}A_{ge'}\cdot(\text{smooth weights})$:
   a **signed** sum of the coefficients, whose worst case is governed by
   $\sum_{d\le Q}A_d=M(Q)$ (Lemma B1 / `MERTENS_FLOOR.md` Lemma 1). Absolute
   values give only $\|A\|_1^2/N\asymp Q^2/N$ — trivial. So the last step needs
   cancellation among the $A_d$, i.e. Mertens-type cancellation over a
   *weighted, gcd-stratified* range, and `MERTENS_FLOOR.md` §3.1 is the warning
   that this cancellation is exactly what sharp truncation destroys at the
   extremal points. **This is the named missing ingredient.**

> **The missing ingredient, named.** A bound of the form
> $$\Bigl|\sum_{g\le Q}\ \sum_{\substack{d',e'\le Q/g\\ (d',e')=1}}
> A_{gd'}A_{ge'}\,\Phi_N(g,d',e')\Bigr|\ \ll\ \frac{N^2}{\log^{2+\varepsilon}Q}
> \quad\text{for }N\le Q^2\log Q,$$
> uniformly in $Q$, for the explicit smooth weights $\Phi_N$ produced by
> C7's surviving set ($\Phi_N\asymp N/(g\,j\,e')$ on the sub-block $k=je'$,
> and its transpose). This is a **weighted Mertens/Farey estimate**, in the
> reach of the classical large sieve and of Möbius-cancellation technology
> (Vinogradov–Korobov-free: $\log$-power savings suffice, by Proposition
> A1(3)); it is **not** a bilinear Kloosterman estimate, and DFI-class
> technology has nothing to say about it.

---

## 6. Verdict and revised forecasts

**Returned: (ii) OBSTRUCTION.** Precisely stated:

> **No estimate of Duke–Friedlander–Iwaniec type — a bound for
> $\sum\sum\alpha_m\beta_n e(\ell\overline m/n)$ valid for arbitrary
> coefficients and every $\ell\ne0$ — can discharge Hypothesis U in the
> strength `E2_PROOF.md` needs, for two independent reasons.
> (1) *Exponents.* The Goldbach fiber is sharp, so its finite Fourier
> expansion carries modes $k$ up to $[d,e]$ with harmonic weight, and the
> numerator $\ell=-kn/g$ grows with $k$; applying the recalled DFI bound mode
> by mode at the first balanced block costs $n^{131/96}$ against a trivial
> $n\log n$, and DFI is trivial-beating only for $k\ll n^{1/36}$ — the range a
> *smooth* cutoff would leave (Theorem C2). By Corollary C2′ the survival
> condition on a bound $\|\alpha\|_2\|\beta\|_2(|\ell|+MN)^{c_1}(M+N)^{c_2}$ is
> $4c_1+c_2\le1$, which the recalled DFI pair misses by $0.73$; the least
> strengthening that would survive saves $M^{1/4}$ at balance, twelve times
> DFI's exponent.
> (2) *Structure.* A DFI-type bound is pointwise in $\ell$, hence pointwise in
> $n$; any pointwise bound beating the main term uniformly in $Q$ implies
> binary Goldbach for all large even $n$ (Theorem C4). Hence the failure in
> (1) is compulsory, not an artifact of the exponents.**

**Attached: (iii) SHARPENED FORECAST, ingredient named.** The corpus's real
obligation is not Hypothesis U but Hypothesis U♭ (§1.3), an $n$-aggregated
statement tolerating an exceptional set; on it the free variable $n$ is the
numerator, the average linearizes every phase (C7), the incomplete Kloosterman
fractions become complete geometric series, and the residual is a weighted
Mertens/Farey cancellation over $d,e\le Q$ (§5.4, boxed).

**Forecast revisions** (house credences, inputs to routing, not results):

| | statement | old | new |
|---|---|---|---|
| P₄ | Hypothesis U dischargeable by DFI/Bettin–Chandee-class technology | 0.55 | **0.10** — refuted as a route by C2+C4 for the statement as posed; the residual mass is the possibility that a DFI-class input is used as one *lemma inside* an averaged argument. |
| P₄ᵃ | *new*: Hypothesis U♭ provable by classical technology with **no** Kloosterman completion (C7's linearization + a weighted Mertens/large-sieve estimate + a Lavrik/Montgomery–Vaughan import in $n\ll Q^{1-\varepsilon}$) | — | **0.45** |
| P₄ᵇ | *new*: the smoothed analogue (Proposition C3) is already a theorem given DFI, modulo the $g$-aggregation | — | **0.80** |
| P₁ | D0026 item 2 at its stated uniformity discharges Hypothesis U | 0.75 | **0.35** — lowered: their item 2 is a *completion* statement for incomplete fractions, and §5.4 shows the diagonal slice does not need completion; what it needs (Mertens cancellation under sharp truncation) is not in their item 2. The kernel/cutoff rows of TWO_WALLS §2 were right and this note prices them. |
| P₅ | the two corpora's ultimate doors coincide at the parity core | 0.85 | unchanged (untouched by this note) |

**The three ranges, with the technology each needs** (this replaces "attack
Hypothesis U with completion machinery" as the routing recommendation):

| range | what $\mathcal O^\flat(n)$ is | tool |
|---|---|---|
| $n\ge Q^2\log Q$ | anything | **done** — U9, proved |
| $\sqrt n\lesssim Q\lesssim n^{1-\varepsilon}$ | parity-free level-$Q$ sieve bilinear form at the balanced block | $n$-average (C7) + weighted Mertens/Farey; DFI only for the smoothed statement (C3) |
| $Q\gtrsim n^{1+\varepsilon}$ | the **binary Goldbach error term** (C4's limit) | pointwise = Goldbach (C5); averaged = Lavrik / Montgomery–Vaughan, **classical — import, do not prove** |

---

## 7. Honesty ledger

| # | item | status |
|---|---|---|
| V1 | Prop A1, Prop A2, Cor A2′, Hypothesis U♭ | **Derived here**, finite rearrangements of U9/U10/M1′ plus the definition of $S(Q)$. A2 is a two-line consequence of U9 and is the note's most easily checked claim; it should be checked first by the audit. Nothing struck: U9, U10, M1′, $\mathcal E(Q)\ll\log^2Q$, T3 all stand. |
| V2 | Lemmas B1–B3, Prop C7 | **Derived here.** B2's residue for general $g$ extends TWO_WALLS T2 ($g=1$); the Fourier form is `DIVISOR_HAHN_INCIDENCE.md` (5.1)/(5.4), quoted, no novelty claimed. C7's reciprocity step is classical. |
| V3 | DFI's exponents $3/8$, $11/48$ | **SEARCH-CONFIRMED-UNVERIFIED.** Two independent search summaries agree; no PDF read (`arxiv.org` blocked). Load-bearing for the numerical thresholds $n^{1/36}$, $n^{35/96}$, $n^{1-1/48}$, and for the *margin* $4c_1+c_2=83/48$ in C2′ — but not for the verdict, which needs only $4c_1+c_2>1$ (a margin of $0.73$ in the recalled values) together with C4, which uses no recalled constant. If the audit obtains the PDF and the true exponents satisfy $4c_1+c_2\le1$, C2 falls and P₄ must be re-raised; C4, C5, A1, A2 stand regardless. |
| V4 | The $g>1$ aggregation in C3 and C2 | **Not written out.** Claimed dominated by $g=1$ on the grounds that both lengths shorten by $g$ and the coefficient mass $\sum_g$ converges; this is a routine but genuinely unwritten step. If it fails, C3 (the positive half) weakens; C2 and C4 are untouched, since they are lower-bound/obstruction statements at $g=1$. |
| V5 | Theorem C4 | **Proved**, conditional on nothing beyond U3 (Hardy 1921, cited in `E2_PROOF.md` H6 as RESOLVED-FOUND) and $\mathfrak S(n)\gg1$ for even $n$. The limit interchange is finite-sum termwise, no uniformity needed. **This is the durable statement of the note.** |
| V6 | C6's Montgomery–Vaughan exceptional-set bound; §6's Lavrik import | **RECALLED-UNVERIFIED.** Used only to say that an exceptional set of the tolerated size is a *known* phenomenon, and to route range III. No quantitative claim depends on the exponent $\delta$. The transfer of a Lavrik-type mean square from $\Lambda$ to $\Lambda^\sharp_Q$ additionally needs the uniform shape $E_n(Y)\ll d(n)Y^{-1/2}$ of U2, which `E2_PROOF.md` ledger **H2 records as not verified**. Flagged as the first dependency to close if range III is attacked. |
| V7 | §5.4 item 3 ("what is left is a Mertens problem") | **Heuristic in its quantitative form.** What is proved is C7 (the damping) and Lemma B1 (the signed mass is $M(Q)$); that the surviving weights are exactly $\Phi_N\asymp N/(gje')$ is a computation I have sketched, not executed to a stated error term. The *boxed* missing ingredient is therefore a target, not a theorem, and its weight $\Phi_N$ may need correction. |
| V8 | Forecasts in §6 | FORECAST. Credences under house discipline. P₄'s revision from 0.55 to 0.10 is the note's deliverable to `D0026_BUILD_QUEUE.md`; it is an argument (C2+C4), not a theorem about what humans can prove. |
| V9 | Prior art for the *identification* in §5.4 (that averaging the shift linearizes the CRT boundary phase) | **Not searched.** It is elementary and almost certainly classical folklore in the additive-divisor literature (it is the standard reason one averages over the shift $h$ in shifted convolution problems). **No novelty claimed.** |

**SEARCH lines** (per protocol: searched before writing; queries, hits, grade).

- **S1.** Query: *Duke Friedlander Iwaniec "Bilinear forms with Kloosterman
  fractions" theorem statement e(a m̄/n) bound*. Hits:
  [Invent. Math. 128 (1997) 23–43](https://link.springer.com/article/10.1007/s002220050135);
  [Bettin–Chandee, *Trilinear forms with Kloosterman fractions*, arXiv:1502.00769](https://arxiv.org/pdf/1502.00769)
  (= Adv. Math. 2018);
  [Semantic Scholar record](https://www.semanticscholar.org/paper/Bilinear-forms-with-Kloosterman-fractions-Duke-Friedlander/9bb1f276c6de288e6ff30702746913f3b6e6c6a8).
  Returned statement: $\ll_\varepsilon\Delta^2\|\alpha\|_2\|\beta\|_2(|\ell|+MN)^{3/8}(M+N)^{11/48+\varepsilon}$.
- **S2.** Query: *"Duke, Friedlander and Iwaniec" bilinear Kloosterman
  fractions bound "3/8" "11/48"*. Independent confirmation of the same
  exponents; additional context hits
  [arXiv:1003.0302](https://arxiv.org/pdf/1003.0302),
  [arXiv:1302.6061](https://arxiv.org/pdf/1302.6061),
  [Harcos thesis](https://users.renyi.hu/~gharcos/thesis.pdf).
  **PDF reads attempted and refused: `arxiv.org` is EGRESS_BLOCKED by the
  proxy.** Grade: search-summary only. Both searches returned the same
  formula, which is why V3 is graded SEARCH-CONFIRMED-UNVERIFIED rather than
  RECALLED-UNVERIFIED; it is still not a read source.
- **S3 (not run, and it matters).** No search was run for the weighted
  Mertens/Farey estimate boxed in §5.4, nor for prior treatments of the
  truncated-Ramanujan Goldbach convolution uniform in the truncation. Both
  should be searched **before** anyone attempts that estimate; the corpus rule
  is prior art before the work, and this note is stopping at the statement.

**Scope fences.**

- This note **discharges no analytic obligation**. H3 remains open; what
  changes is its statement (A2′, U♭) and the routing (§6).
- C2, C3 are conditional on the recalled DFI bound (V3). C4, C5, A1, A2 are
  unconditional.
- C4/C5's reach is the sub-range $n\ll Q^{1-\varepsilon}$ (§5.3 scope
  paragraph); they refute the *uniform in $n,Q$* DFI route, not any
  restricted-range use of DFI.
- All statements about D0026 are readings of TWO_WALLS §1.1's reading of the
  received transcription, as of D0026 V2; the as-of fence of that note applies
  here unchanged (Deltas 30–38 not ingested).
- The probabilities in §6 are credences, inputs to routing, not results.
- Per `CLAUDE.md`: no computation was run for this note; every displayed
  identity is proved on the page or cited to a proof in this corpus.

**Consumers.** `notes/E2_PROOF.md` ledger H3 (statement replacement A2′/U♭ —
the row should be *re-worded*, not struck); `notes/TWO_WALLS_ONE_PROBLEM.md`
§3 (P₄ revised; ledger T7 discharged) and §5.1 item 1 (its brief is
withdrawn as posed and replaced by §5.4's); `notes/METHOD.md` §1 (the
re-diagnosis stands, and gains a second correction: the needed lemma is not
merely "bilinear" but *aggregated*-bilinear); `notes/MERTENS_FLOOR.md` §3.1
(§5.4 item 3 is a third appearance of the same $M(Q)$ obstruction, now as the
last step of the averaged route); the upstream reply lane (§5.4 item 1 is a
genuine asymmetry worth sending back: on their slice the shift cannot be
averaged, on ours it must be).
