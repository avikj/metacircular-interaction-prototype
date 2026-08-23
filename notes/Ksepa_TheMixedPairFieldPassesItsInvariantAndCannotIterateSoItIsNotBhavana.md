# क्षेप — the mixed pair field passes its invariant and cannot iterate, so it is not bhāvanā

*Lane opened to test one identification: `notes/INDRA_CROSS.md` Theorem I's
mixed pair field against Brahmagupta's **bhāvanā** (ब्राह्मस्फुटसिद्धान्त १८.६४–६५,
628 CE). The identification is **REJECTED**, at a named place, and the
rejection is worth more than the fit would have been: locating where it fails
gives an exact closed form for every $k$, settles two standing `PROVE` items,
and sorts the corpus's three live depth laws.*

**Checked term:** `formal/cubical/Ksepa_ThePassedInvariantComposesAndTheGradingIteratesOnlyIfItIsACharacter.agda`
— `--cubical --safe`, no postulates, no holes, wired into `Everything.agda`
(line 1104), whole-corpus check exit 0.

---

## 0. The claim under test, and the verdict

Theorem I (`INDRA_CROSS.md` §0) gives, for non-principal primitive
$\chi_1,\chi_2$ under GRH + simple zeros,
$$G_1^{\chi_1,\chi_2}(X)=\sum_{\rho\in Z(\chi_1)}\sum_{\rho'\in Z(\chi_2)}
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}+B(X)+E(X),$$
with unit weights and frequency set $\{\gamma_i^{\chi_1}+\gamma_j^{\chi_2}\}$
— *"a sum spectrum that belongs to no single $L$-function, only to the pair"* —
and a §1.1 crossing table with cells that are **empty** (no $X^3$, no
$X^{5/2}$: both Mellin factors are poleless).

Bhāvanā composes two solutions of $x^2-Ny^2=k$ into a third that neither had,
and the क्षेप multiplies: $k_3=k_1k_2$. Bilinear; invariant belongs to neither
factor. The shapes rhyme, and the lane's mandate was to decide whether the
rhyme is an identification.

**REJECTED.** The two laws agree on everything except the one property
bhāvanā exists for, and it is the property that makes bhāvanā *useful*:

> **Bhāvanā's composite is a solution of the same equation, so it can be
> composed again. That is the cakravāla.** The pair field's composite is an
> atom of a *different graded piece*, and it cannot.

§1 makes "cannot" exact. §2 gives the exact kernel identity the analysis
turns on. §3 and §4 are the by-products, which are the actual yield.

---

## 1. THEOREM (क्षेप, checked in Agda). Iteration holds exactly when the grading is a character.

Both objects are instances of one skeleton. Fix a commutative monoid of
frequencies $(M,\oplus,\mathbf 0)$ and of values $(G,\otimes)$; a per-**input**
invariant $u:M\to G$ and a per-**output** grading $g:M\to G$; and set
$$W(a,b)=\bigl(u(a)\otimes u(b)\bigr)\otimes g(a\oplus b).$$

- **क्षेप-१** (unconditional, `ksepa-1`): the input halves always split off,
  $W(a,b)\otimes W(c,d)=\bigl(u_au_bu_cu_d\bigr)\otimes\bigl(g(a\oplus b)\otimes g(c\oplus d)\bigr)$.
- **क्षेप-२/३** (`ksepa-2`, `ksepa-3`): "$g(x)\otimes g(y)$ depends only on
  $x\oplus y$" $\iff$ $g(x)\otimes g(y)=g(x\oplus y)\otimes g(\mathbf 0)$,
  i.e. $g$ is a character twisted by $g(\mathbf 0)$.
- **क्षेप-४** (`ksepa-4`): that condition *makes* the four-fold kernel iterate —
  $W_4(a,b,c,d)=\bigl(W(a,b)\otimes W(c,d)\bigr)\otimes h(a\oplus b\oplus c\oplus d)$,
  a factor of the **total frequency alone**.
- **क्षेप-५** (`ksepa-5`, under cancellation of $\otimes$): iteration *forces*
  it back.

So iteration $\iff$ character. **Brahmagupta sits at $g\equiv\mathbf 1$,** where
the condition is free — and that freedom is the entire cyclic method: the
composite carries a $k$ of the same kind as its inputs, so Bhāskara can pick
the next partner and iterate.

**The pair field sits at $g(s)=1/\Gamma(3+is)$, which is not a character in $s$,
because $\Gamma$ is not an exponential.** Concretely the obstruction is visible
and does not vanish:
$$\frac{W_4(\gamma_1,\gamma_2,\gamma_3,\gamma_4)}{W_2(\gamma_1,\gamma_2)\,W_2(\gamma_3,\gamma_4)}
=\frac{\Gamma(3+is_{12})\,\Gamma(3+is_{34})}{\Gamma(4+is)},\qquad s=s_{12}+s_{34},$$
which depends on the **splitting** $(s_{12},s_{34})$ and not on $s$ alone.
Bhāvanā's ratio is $1$. **That is the whole difference, and it is the place the
identification dies.**

*That $g$ is not a character is not a gesture at $\Gamma$: the character law
$g(x)g(y)=g(x+y)g(0)$ reads $\Gamma(3+ix)\Gamma(3+iy)=2\,\Gamma(3+i(x+y))$, and
at $x=y$ real, by $|\Gamma(3+it)|\sim\sqrt{2\pi}\,t^{5/2}e^{-\pi t/2}$, the left
side is $\asymp2\pi x^{5}e^{-\pi x}$ against the right side's
$\asymp2\sqrt{2\pi}\,(2x)^{5/2}e^{-\pi x}$ — a ratio $\asymp x^{5/2}\to\infty$.
It fails by an unbounded factor, not marginally.*

*Scope, stated because the Agda cannot say it:* the module holds no analysis
and instantiates nothing. It fixes the criterion; the analytic verdict
($\Gamma$ is not an exponential) is checked by hand against a checked criterion.

### 1.1 What the owner's picture says, and it is the same sentence

Mid-lane the owner gave the physical reading: a diamond orb, light flowing
throughout by **total internal reflection**, *"no energy created but light
passed."* That is this theorem in one clause.

**भावना means production** — *bringing into being*. Bhāvanā *makes* a solution
neither input had, and the made thing is of the same kind, so it can make
another. **Total internal reflection passes.** Nothing is created; the light
that leaves is the light that entered, redistributed. Theorem I's unit weights
are exactly "no energy created": residue $1$ at every zero, which is why
Theorem I needs no Gonek-type bound where the Möbius field (Theorem H′) does.

The pair field is passage, not production. A passed beam exits; it does not
re-enter as a new source. **REJECTED for that reason**, and the picture named
the reason before the algebra did.

Two further readings, marked as readings and not as results:
- *"surface looks smooth but diamond internally"* — the corpus measured
  $\sqrt{2\pi}\,s^{-5/2}$ (the smooth surface) and missed the exact rational
  faceting $(1+s^{-2})(1+4s^{-2})$, which is `SEED13_D3PRIME_EXACT.md`'s whole
  finding: the stated error was two orders too weak.
- *"time is like fluid in there"* — D‴'s entropy phase $-sH(p)$, $p=\gamma/s$:
  the Beta integral localises at $m^*=pX,\ n^*=(1-p)X$, so **each zero claims a
  share of $X$ proportional to its frequency**. That is `BLOCKS.md` §2's own
  sentence.

---

## 2. THEOREM (exact, no hypotheses). The $k$-fold kernel factors by inspection.

Not asymptotic, not conditional, not new mathematics — a definition read in the
right coordinates, recorded because the corpus has been reading it in $(s,\delta)$
where it looks coupled.

With $\rho_j=\tfrac12+i\gamma_j$ and $s=\sum_j\gamma_j$, the $k$-fold Cesàro
kernel of `BARRIER.md` B1 is
$$W_k(\vec\gamma)=\frac{\prod_{j=1}^k\Gamma(\rho_j)}{\Gamma(\sum_j\rho_j+2)}
=\frac{\prod_{j=1}^k\Gamma(\tfrac12+i\gamma_j)}{\Gamma(\tfrac k2+2+is)}.$$

**Because $\sum_j\rho_j+2=\tfrac k2+2+is$ depends on $\vec\gamma$ only through
$s$**, the kernel is *manifestly* of the §1 shape, with
$u(t)=\Gamma(\tfrac12+it)$ per ordinate and $g_k(s)=1/\Gamma(\tfrac k2+2+is)$
per composite. No Stirling, no error term, both signs, all real $\gamma_j$.

**Corollary (exact modulus, every $k$, both parities).** By the reflection
formula $|\Gamma(\tfrac12+it)|^2=\pi/\cosh\pi t$,
$$\boxed{\;|W_k(\vec\gamma)|^{2}
=\frac{\pi^{k}}{\bigl(\prod_{j=1}^{k}\cosh\pi\gamma_j\bigr)\;\bigl|\Gamma(\tfrac k2+2+is)\bigr|^{2}}\;}$$
and the denominator peels by the functional equation:
$$k\ \text{even}\ (n=\tfrac k2+2):\quad
|W_k|^2=\frac{\pi^{k-1}\,\sinh(\pi s)}{\bigl(\prod_j\cosh\pi\gamma_j\bigr)\,s\,\prod_{j=1}^{n-1}(j^{2}+s^{2})},$$
$$k\ \text{odd}\ (m=\tfrac{k+3}2):\quad
|W_k|^2=\frac{\pi^{k-1}\,\cosh(\pi s)}{\bigl(\prod_j\cosh\pi\gamma_j\bigr)\,\prod_{j=0}^{m-1}\bigl((j+\tfrac12)^{2}+s^{2}\bigr)}.$$

At $k=2$ the even line reads
$\pi\sinh(\pi s)\big/\bigl[\cosh\pi\gamma\cosh\pi\gamma'\,s(1+s^2)(4+s^2)\bigr]$,
which is `SEED13_D3PRIME_EXACT.md` **Lemma 1** verbatim, via
$\cosh\pi s+\cosh\pi\delta=2\cosh\pi\gamma\cosh\pi\gamma'$. Lemma 1 is
SEED-13's, adversarially re-derived in SEED-24; **no priority is claimed for
it here.** What is claimed is the reading that generalises it.

**Both of `SEED71_PAIR_WEIGHT_IS_NOT_A_FORM_FACTOR.md`'s theorems are one line
from this reading, which is the argument that it is the right one.** Its
Theorem A ($|W|$ a function of $s$ alone up to per-ordinate factors) is
"$\cosh$ is even and the denominator sees only $s$". Its Theorem B
($\partial_\delta\arg W=\tfrac12\log(\gamma/\gamma')$) is: the numerator's phase
$\theta(\gamma)+\theta(\gamma')$, $\theta(t)=\arg\Gamma(\tfrac12+it)$, is
separable, the denominator's contributes nothing at fixed $s$, and
$\tfrac{\partial}{\partial\delta}=\tfrac12(\partial_\gamma-\partial_{\gamma'})$
with $\theta'(t)\sim\log t$. Likewise `FRESNEL.md` Theorem G is the Stirling
expansion of the *same* separable numerator, with the coupling living entirely
in $-\arg\Gamma(3+is)$.

### 2.1 This settles a standing open `PROVE` item, and the obstruction was a coordinate artifact

`notes/SEED24_VERIFICATION_OF_SEED13.md` §5.4/§8, re-queued in
`notes/SEED77_BLOCKS_POSTCONDITION.md`:

> "For **odd** $k$ the denominator argument is a half-integer and one uses
> $|\Gamma(\tfrac12+is)|^2=\pi/\cosh\pi s$ instead; the product-to-sum collapse
> then does *not* occur, and $|W_k|^2$ is a ratio of $\cosh$'s rather than a
> closed form of Lemma 1's shape. **This is a real limitation** … Recorded as an
> open `PROVE`."
> — and SEED-13 §5, `PROVE — the odd-$k$ exact modulus (SEED-24 §8)`.

**CLOSED, affirmatively, and the "limitation" is not one.** The boxed corollary
is exact for every $k$ of either parity; the odd case is displayed above. The
parity split is real but harmless: it decides *which reflection formula peels
the denominator*, and **it never touches the numerator**, which is a product of
per-ordinate factors for every $k$ by inspection.

The apparent obstruction came from working in $(s,\delta)$ and waiting for a
product-to-sum collapse. **Lemma 1's shape *is* a ratio of $\cosh$'s** — that is
what $\cosh\pi s+\cosh\pi\delta=2\cosh\pi\gamma\cosh\pi\gamma'$ says. In
$(\gamma,\gamma')$ the numerator is already a product and there is nothing to
collapse. A page of algebra; no computation was run, and none is proposed.

### 2.2 This also closes `INDRA_CROSS.md` caveat 6 (the dark sub-band), for every $k$

`INDRA_CROSS.md` §5 caveat 6: *"no replacement theorem is offered for **why**
the small-difference sub-band is dark beyond the kernel modulus computation,
and the sub-band itself was measured on one character ($\chi_5$) only."*

**THEOREM (exact).** $|W_k(\vec\gamma)|^{2}\cdot\bigl|\Gamma(\tfrac k2+2+i\sum_j\gamma_j)\bigr|^{2}$
is invariant under every sign flip $\gamma_i\mapsto-\gamma_i$.

*Proof.* $\cosh$ is even; the numerator of the boxed corollary does not see the
signs. $\square$

So **all** sign dependence of the $k$-fold weight sits in the denominator, as a
function of the *signed* sum alone, and the suppression relative to the
all-same-sign configuration with the same $|\gamma_j|$ is exactly
$$\frac{|W_k(\vec\gamma)|^{2}}{|W_k(|\vec\gamma|)|^{2}}
=\frac{\bigl|\Gamma(\tfrac k2+2+i\sum_j|\gamma_j|)\bigr|^{2}}{\bigl|\Gamma(\tfrac k2+2+is)\bigr|^{2}}
\;\asymp\;\Bigl(\tfrac{\sum_j|\gamma_j|}{|s|}\Bigr)^{k+3}e^{-\pi\left(\sum_j|\gamma_j|-|s|\right)}.$$

The darkness is **not** a property of the numerator — which is always
$\asymp(2\pi)^k e^{-\pi\sum|\gamma_j|}$, exponentially small for every
configuration. It is the **failure of the denominator's $e^{-\pi|s|}$ to cancel
it**, and the exponent is exactly $\pi\bigl(\sum_j|\gamma_j|-|\sum_j\gamma_j|\bigr)$:
$2\pi$ times the negative mass of the tuple. At $k=2$, opposite signs, this is
$2\pi\min(|\gamma|,|\gamma'|)$, matching `INDRA_CROSS.md` §1.4(ii)'s measured
$|W|\asymp e^{-\pi\min}$ and its $5\cdot10^5$ suppression. **Now derived for all
$k$, exactly, from one character-free identity, where the note had it measured
on $\chi_5$ alone.**

---

## 3. THEOREM. Which depth law applies, and the rule that decides it

The corpus carries three answers for depth and cites them interchangeably
(`HOLOGRAM.md`). Sorted:

| content | law | site | status |
|---|---|---|---|
| zero **locations** | $X\sim\mathrm{poly}(T)$ | K(b) | live |
| **sum**-spectrum atoms as separated lines | $\exp\Theta\bigl(T^{1/2}\log^{3/2}T\bigr)$ | K′, §7 | live |
| **difference**-spectrum atoms as separated lines | $\exp\Theta(T)$ | §5 correction | live |
| — | $\exp(cT\log^{2}T)$ | K(b), original | **RETRACTED** by §7 |

**The rule, and §2 proves it rather than asserting it.** K′'s threshold is
$A(\delta L)^{2p-1}\gtrsim\varepsilon=e^{-L/2}$ with $A$ the atom amplitude, and
§2 gives $A$ exactly. The atom densities agree to leading order — both
$\asymp T\log^2T/(4\pi^2)$ — so **only the amplitude differs**, and by §2.2 the
amplitude is decided by one thing: whether the numerator's $e^{-\pi\sum|\gamma_j|}$
is cancelled.

> **Sum spectrum $\Rightarrow$ signs agree $\Rightarrow$ cancellation is exact
> $\Rightarrow$ $|W|$ polynomial $\Rightarrow$ $\log A=O(\log T)$ $\Rightarrow$ K′.**
> **Difference spectrum $\Rightarrow$ signs disagree $\Rightarrow$
> $\log A\approx-\pi T$ $\Rightarrow$ $\exp\Theta(T)$.**

Applied to the lane:

- `BARRIER.md`'s $\sigma_k$ is defined as the $k$-fold **sum**-spectral measure
  (`HOLOGRAM.md` §5's correction is explicit that BARRIER is right and HOLOGRAM
  drifted). Anything citing $\sigma_k$ takes **K′**.
- `INDRA_CROSS.md`'s mixed $(\chi_3,\chi_4)$ field is a **sum** spectrum
  $\{\gamma_i+\gamma_j\}$ → **K′**.
- The $(\chi,\bar\chi)$ field is a **difference** spectrum → $\exp\Theta(T)$ —
  *except* that §1.4(ii)'s retraction is exactly the observation that a complex
  $\chi$'s string carries both signs, so half its "difference" atoms are
  same-sign in the kernel and are sum-like. **The label on the spectrum does not
  decide the law; the signs of the ordinates entering the kernel do.** §2.2 is
  the statement of that in closed form, and it is why the draft's "dark field"
  was wrong.
- **Scope, `HOLOGRAM.md` §3.1, which every citation must carry:** all of this is
  about resolving *individual pair atoms as separated spectral lines within a
  windowed-linear read-off*. Correlation **statistics** are accessible at
  polynomial depth (Montgomery's $F(\alpha,T)$, proved for $|\alpha|<1$ under
  RH; Goldston–Montgomery). Stated broadly the depth claim contradicts
  Montgomery.

**A depth figure quoted without saying (i) sum or difference and (ii) atoms or
statistics is not a number.** That is the same defect as a constant quoted
without its $X$-dependence, one level up.

### 3.1 Sites found still carrying the retracted law, and struck

Four, none a bare repetition, all struck in place with attribution rather than
deleted (`HOLOGRAM.md`'s own two and `BARRIER.md`'s one were struck earlier):

| site | what it said | why it was more than a stale citation |
|---|---|---|
| `notes/BLIND.md`:108 | "the depth law survives with a **better constant**" | K′ moved the **exponent**, by a power of $T$ — and the paragraph's own subject is separating the Fourier constant from the information exponent |
| `notes/CARRIER_JOIN.md`:524 | correlations are bulk at $\exp(cT\log^2T)$ | its §4 object is the mixed-sign sector, so the successor is §5's $\exp\Theta(T)$, not §7's |
| `notes/CARRIER_JOIN.md`:567 | prices "the mixed-sign (difference/pair-correlation) sector" at the retracted figure | **names its own sector correctly and then prices it with the wrong law**; the true wall is a whole power of $T$ higher than the naive repair |
| `notes/NEGATIVE_KNOWLEDGE_IS_TYPED.md`:68 | uses the law as its worked **T3 budget-absence** example | the classification survives (the retraction replaces the bound, not the certificate) — and a bound wrong because nobody checked its scaling is the cleanest T3 instance that note has |

The pattern is worth naming, because it is the argument for §3's rule: **not one
of these four is repaired by swapping in K′.** Two of them need the
*sum-or-difference* distinction to be repaired at all, and one of them had
already written the distinction into its own sentence. A depth figure travels
without the sector it prices, and that is what makes it re-quotable.

---

## 4. What this does and does not say about Theorem I

**Not disturbed.** Theorem I, Proposition N, the $q=12$ net, the layer ledger,
every measurement in `INDRA_CROSS.md` §§2–4. Nothing here is analytic.

**Sharpened.** Theorem I's §1.1 crossing table is a **product of singularity
source sets**, $S_1\times S_2$ with residues multiplying — real bilinearity,
real multiplicative invariant. The empty cells are just $1\notin S_i$. That much
*is* bhāvanā-shaped and §1 checks the shape. What is absent is the third leg:
**a composite of the same kind**. `FAMILY.md` §2 law 1 composes *singularity
sources*; the output is a *layer*, and layers are not sources. The natural
operation on dressings, $D_{\chi_1}+D_{\chi_2}=-(L_1L_2)'/(L_1L_2)$, takes the
**union** of zero sets, not the sumset — so the sumset never arises from an
internal law at all. It arises from the external pairing $(X-m-n)_+$, which is
where the grading $1/\Gamma(\tfrac k2+2+is)$ comes from, and the grading is the
obstruction.

**Named honestly against prior work in this corpus.** `SEED13_D3PRIME_EXACT.md`
§4 already wrote *"No, $W$ is not a Pell form and I will not pretend
otherwise. What transfers is method"* — taking from cakravāla the move of
composing an inexact object with an exactly-known one so the defect divides
out. **That rejection is correct and this note does not improve on it.** What
is added is one level down: SEED-13 rejected *"$W$ is a Pell form"*; this note
tests the weaker and more plausible claim *"the pair-field composition has
bhāvanā's shape"*, finds that it does at क्षेप-१–३, and finds it fails at
क्षेप-४–५. The weaker claim needed its own refutation because it was the one
that would have been believed.

---

## 5. Ledger

| # | claim | grade |
|---|---|---|
| 1 | Iteration $\iff$ character grading | **THEOREM** — `Ksepa_…agda`, `ksepa-1`…`ksepa-5`, `--safe`, no holes |
| 2 | $W_4/(W_2W_2)=\Gamma(3+is_{12})\Gamma(3+is_{34})/\Gamma(4+is)$, not a function of $s$ | **THEOREM** — §1, one line from the definition |
| 3 | Theorem I's field is **not** bhāvanā | **REJECTED** — §1, §4; fails at iterability, which is bhāvanā's purpose |
| 4 | $W_k=\prod_j\Gamma(\tfrac12+i\gamma_j)\big/\Gamma(\tfrac k2+2+is)$, factored, exact, all $k$ | **THEOREM** — §2, by inspection |
| 5 | exact $\lvert W_k\rvert^2$, both parities | **THEOREM** — §2; closes SEED-24 §8 / SEED-77's open `PROVE` |
| 6 | odd-$k$ "limitation" is a coordinate artifact | **THEOREM** — §2.1 |
| 7 | sign flips move only the denominator; suppression $=\pi(\sum\lvert\gamma_j\rvert-\lvert s\rvert)$ | **THEOREM** — §2.2; closes `INDRA_CROSS` caveat 6 for all $k$ |
| 8 | sum ⇒ K′, difference ⇒ $\exp\Theta(T)$, $\exp(cT\log^2T)$ retracted | **THEOREM** given K′/§5 as stated (which are derived *scaling laws*, not theorems about primes — `HOLOGRAM.md` §4) |
| 9 | the diamond/total-internal-reflection reading | **READING**, marked as such in §1.1; the mathematics is §1 and stands without it |

**Pramāṇa.** §§1–2 and their corollaries: *anumāna*, and for §1 the stronger
grade of a checked term. §3's table: *anumāna* over `HOLOGRAM.md`'s own derived
scalings, inheriting their honesty ledger unrepaired. No *pratyakṣa* in this
note: **no computation was run and none is proposed.** §4's attribution of the
prior rejection to SEED-13 is *pratyakṣa* on the file, quoted verbatim.

---

## 6. What I tried and could not do

1. **I could not save the identification, and I tried the two obvious repairs.**
   (a) Rescale each atom by a per-ordinate factor to absorb the grading —
   fails, because the grading depends on the *composite* and $\Gamma$ is not an
   exponential, which is exactly क्षेप-२. (b) Move to a graded algebra where
   $\sigma_j*\sigma_k=\sigma_{j+k}$ — the *frequencies* convolve, but the
   *weights* do not: that is claim 2, and it is the same wall.
2. **I did not determine whether the grading obstruction has arithmetic
   content.** $\Gamma(\tfrac k2+2+is)$ is the Cesàro/Beta smoothing order $j=1$
   (SEED-13 §2: the $5\pi/4$ is the shift artifact $(a-\tfrac12)\pi/2$ at
   $a=3$). It is plausible that a different smoothing makes $g$ a character and
   the field iterable, and that this is what a Riesz mean of the right order
   does. `notes/BARRIER_UNIFORM.md` U7 already records that the Cesàro order
   must rise with $k$ (Languasco–Zaccagnini arXiv:1206.0251; Cantarini
   arXiv:1607.05629; arXiv:2012.02503). **`PROVE` — is there a smoothing order
   for which $g_k$ is a character in $s$? If yes, the field iterates and the
   identification is repaired at that order; if no, prove no.** I could not
   settle it and I did not guess.
3. **I did not verify the prior-art status of §2's factorization.** It is a
   definition read in different coordinates and is almost certainly known; no
   search was run. Absence of a search is not evidence of novelty
   (`LITERATURE.md` protocol). **`SEARCH`.**
4. **My sweep for surviving citations of the retracted depth law is not
   exhaustive.** Four are struck (§3.1); I searched `notes/` and `papers/` for
   the LaTeX forms of $\exp(cT\log^2T)$ and $T\log^2T$ and filtered the ones
   already marked. That misses paraphrase, `collab/`, `site/`, and every
   non-`.md` carrier. **`SEARCH` — and by grep it will always be partial,
   because the failure mode is a figure quoted without its sector, not a
   string.**
5. **I did not touch `exp29_ltower_stats`'s re-derivation** (`INDRA_CROSS` §2.0,
   still owed by that lane), nor `B2`/`B1″`/`U1`, whose retraction sites
   (`METHOD.md` lines 230–238, `BARRIER_SMOOTH_TERM.md`) are a separate audit I
   opened and did not close.
6. **The Agda proves the criterion, not the instance.** No Agda in this
   repository can hold $\Gamma$. The step "$g(s)=1/\Gamma(3+is)$ is not a
   character" is a hand check (§1) against a checked criterion, and I am saying
   so rather than letting the green stand for more than it covers.

---

## 7. On the certificates of this lane, checked rather than assumed

The brief flagged that a note whose only verification is a script nobody can
run is asserting a provenance. Checked for this lane, and the finding is
narrower than the worry:

- **Every script and datum `INDRA_CROSS.md` names is present on disk** —
  `code/exp58_indra_cross.py`, `exp20_dirichlet.py`, `exp16_mobius.py`,
  `exp18_cross.py`, `exp29_ltower_stats.py`, `exp12_krein.py`,
  `exp41_superres.py`; all six `data/exp58_*.npy`; both `figures/exp58_*.png`;
  and the audited `data/chi3_zeros_deep.npy`. 136 files under `code/`, 539
  under `machinery/`.
- **The ban is live and is enforced mechanically.**
  `.claude/hooks/no-python.sh` is wired `PreToolUse` and **fired in this lane**
  on an accidental invocation. That contradicts `CLAUDE.md`'s struck paragraph
  — *"working mechanical gates on Python in this repository: zero"* — which is
  false for this gate. **A claim about which hooks are wired is a claim about
  the repository, and this one is stale in the direction that matters.**
- So the honest statement is **not** "the certificate is missing" but: *the
  certificate exists as a file and cannot be executed under the current gate.*
  Those are different defects. The first is a fabricated provenance; the second
  is an artifact that has become **read-only evidence** — inspectable, not
  re-runnable, and therefore *śabda* on the run rather than *pratyakṣa* for any
  future reader.
- **This note adds nothing to that pile.** No computation was run here and none
  is proposed; every claim in §§1–2 is a proof or a checked term.

*Not done:* I did not enumerate which of the ~675 scripts are cited as the
**sole** verification of a note, nor which are missing from disk. **`SEARCH`.**

---

*Filed 2026-08-22. The picture in §1.1 is the owner's, given mid-lane; it named
the refutation before the algebra reached it, and it is recorded as its source
rather than absorbed.*
