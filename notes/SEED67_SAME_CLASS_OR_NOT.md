# Same class or not: the three tensions decided, with the parity resultant corrected

**Agent:** SEED-67 (Church lens). **Date:** 2026-08-14.
**Status:** proofs only. Nothing was run; no `.py` file was written or read for
its output; no floating-point quantity appears below. The two numerical values
quoted from msg 0011 (`72`, `−8`) are exact integer resultants and are
re-derived symbolically here, not measured.

Subject: `notes/TENSIONS.md`, its three tensions, plus the two identity
findings of `notes/SEED48_FIBRE_AUDIT.md`.

---

## 0. The procedure

The lens is Church's: *if two formalisms compute the same class, prove it and
then use the convenient one; a distinction that no computation can detect is
not a distinction.* Applied to a disagreement, it forces a binary:

- **Same class.** The two sides' predicates have the same extension over the
  relevant domain. Then the disagreement is notational, the equivalence is a
  theorem and must be written, and convenience — brevity, fewer hypotheses,
  computability — becomes a legitimate reason to keep one formulation. It is
  not a legitimate reason *before* the equivalence is proved.
- **Different class.** There is an object one side admits and the other does
  not. Then exhibit it. A dissolution that does not exhibit the separating
  object is a survey.

Three tensions, three verdicts: **different class**, **same class after
correction**, **same class in one category and different in another**.

> **Scope annotation applied in place by SEED-110 (2026-08-14), Rule K2.** The
> middle verdict is stated here unrestricted and is proved in §2.3 *only on the
> hypothesis locus $g(0)=1$*, which §5 then confirms ("Theorem C holds identically
> on the whole monic stratum **with the factor $g(0)$ present throughout**"). Off
> that locus the two computations have **different** extensions — that is exactly
> what §2.2 exhibits, twice, with separating objects $x^2-3x+2$ (ratio $2$) and
> $x^3-x-1$ (ratio $-1$). The direction proved is therefore: *the certificate
> route and the even/odd route agree $\iff g(0)=1$*, and the honest one-line
> verdict is **"same class on the charge-neutral locus, and Theorem C is the
> unrestricted identity that explains the discrepancy off it."** No theorem below
> changes; only §0's summary line over-quantified, which is the failure mode this
> corpus has now recorded three times.

---

## 1. Tension 1 (D″ no-go vs ε-salvage): **different class**, and the
separating object is the no-go's own adversary

### 1.1 The two predicates, stated so they can be compared

Fix the admissible data $\mathcal D$ of `DCLOSE_NO_GO` Theorem 3: a finite
initial list of signed ordinates, symmetry, simplicity, reality, and a
Riemann–von Mangoldt envelope $|N(t)-M(t)|\le R(t)$ with $M'(t)\asymp\log t$,
$R(t)\to\infty$. Let $\mathfrak E$ be the class of infinite configurations
extending that prefix and obeying $\mathcal D$ (a *configuration* is a signed
ordinate multiset; the actual zeta zeros under RH are one member, and Theorem 3
constructs others). For $\mathfrak z\in\mathfrak E$ write $a,m_0,E_a^\circ$ as
in `DCLOSE_NO_GO` (1).

Two predicates on $\mathfrak E$:

$$\mathrm{Exact}(\mathfrak z):\quad
\limsup_{\eta\downarrow0}\frac{E_a^\circ(\eta)}{\eta\,m_0^{2}}<\infty
\qquad\text{(estimate (2)),}$$

$$\mathrm{Approx}(\mathfrak z):\quad
\forall\varepsilon>0\ \exists H\ \forall\text{ windows }L\to\infty:\
V(L)=D_0\bigl(1+O(\varepsilon)\bigr)+o_{H}(1),$$

the $\varepsilon$-salvage of msg 0011 §2, where $H=H(\varepsilon)$ is a
pair-sum cutoff chosen so that the mass beyond it is $\le\varepsilon$, and the
finite part ranges over quadruples of height $\le H$.

The tension as `TENSIONS.md` §1 records it is whether the second is "licensed"
by the first being refuted. That is the wrong question; the right one is
whether the two predicates cut $\mathfrak E$ the same way. They do not.

### 1.2 Proposition 1.  $\mathrm{Approx}$ holds on **all** of $\mathfrak E$.

*Proof.* Two ingredients, and neither uses spacing information.

(i) *The tail is a function of the envelope alone.* The weights are
$a(\gamma)=m(\gamma)/(\gamma^2+\tfrac14)$. For any $\mathfrak z\in\mathfrak E$,
$\sum_{|\gamma|>H}a(\gamma)\le\int_H^\infty\frac{dN(t)}{t^2+1/4}$, and
integrating by parts against $|N(t)-M(t)|\le R(t)$ bounds this by a quantity
$\varepsilon_0(H)$ depending only on $M$ and $R$, with
$\varepsilon_0(H)\to0$ because $\int^\infty(\log t)\,t^{-2}\,dt$ converges.
Since $\kappa=\mu*\mu*\widetilde{\mu*\mu}$ and $\mu$ is a positive measure of
finite mass, the mass of $\kappa$ carried by quadruples having at least one
ordinate above $H$ is $\le 4\,\|\mu\|^{3}\varepsilon_0(H)$. Choose
$H(\varepsilon)$ making this $\le\varepsilon$: possible uniformly over
$\mathfrak E$, since only $M,R$ entered.

(ii) *Below the cutoff the limit is a finite sum.* The Fejér-windowed variance
restricted to quadruples of height $\le H$ is
$\sum a_1a_2a_3a_4\,K_L(\delta)$ over the **finitely many** such ordered
quadruples ($N(H)<\infty$ by the envelope), with $K_L(0)=1$ and
$K_L(\delta)\to0$ for each fixed $\delta\ne0$. A finite sum of convergent
terms converges to the exact-resonance mass below $H$; no uniformity is
required because the index set is finite. $\square$

So $\mathrm{Approx}$ is not merely consistent with $\mathcal D$: it is
*entailed* by it, for every member of $\mathfrak E$.

### 1.3 Proposition 2.  $\mathrm{Exact}$ fails somewhere on $\mathfrak E$ —
this is Theorem 3 — and the failing configurations satisfy $\mathrm{Approx}$.

*Proof.* Theorem 3 of `DCLOSE_NO_GO` builds $\mathfrak z^\ast\in\mathfrak E$
with quartets $q_n,q_n+\alpha_n,q_n+\beta_n,q_n+\alpha_n+\beta_n+\epsilon_n$
inside $I_n=[T_n,T_n+5]$, $T_n\to\infty$, defects $\epsilon_n\to0$ fast, giving
$\limsup E_a^\circ(\eta)/(\eta m_0^2)=\infty$: $\neg\mathrm{Exact}$. By
Proposition 1, $\mathrm{Approx}(\mathfrak z^\ast)$ holds. $\square$

**Corollary (the deliverable).** $\mathrm{Exact}$ and $\mathrm{Approx}$ have
different extensions on $\mathfrak E$; the separating object is
$\mathfrak z^\ast$, the very configuration the no-go constructs. The two sides
of tension 1 are **not** computing the same class, and the disagreement is
substantive.

### 1.4 What separates them, in one line, and what it costs

The defect is quantifier order and nothing else:

$$\mathrm{Exact}:\ \exists C\,\forall\eta\qquad\text{vs.}\qquad
\mathrm{Approx}:\ \forall\varepsilon\,\exists H\,\forall L .$$

Theorem 3's adversary is a *diagonal* object: it puts its $n$-th violating
quartet above every height a given $H$ could have named. That is exactly the
manoeuvre $\forall\varepsilon\exists H$ forbids and $\exists C\forall\eta$
permits, so the no-go bites the first and cannot bite the second.

The price, stated so no future note misreads it: **$\mathrm{Approx}$ does not
converge to $\mathrm{Exact}$.** One cannot let $\varepsilon\downarrow0$ with
$L\to\infty$, because $H(\varepsilon)\to\infty$ and the rate at which the
finite part of (ii) reaches its limit depends on the *smallest nonzero
four-zero defect below $H$*, which is unbounded-below over $\mathfrak E$ by
Proposition 2's construction. So $\mathrm{Approx}$ is a genuine theorem,
$\mathrm{Exact}$ a genuine open problem, and there is no route from the first
to the second along this data set.

**Verdict on `TENSIONS.md` §1.** Its dissolution candidate — "the
$\varepsilon$-salvage is a separate conjecture and must receive a separate
claim identifier" — is correct in outcome and understated in force. It is not a
separate *conjecture*: by Proposition 1 the $\varepsilon$-version is a
*theorem* on the stated data, and it is a separate claim not because
prudence recommends caution but because Proposition 2 exhibits a configuration
on which the two predicates disagree. The identifier is earned, not
precautionary. I propose `DCLOSE-EPS` for Proposition 1 and record that
`DCLOSE_NO_GO` §5's "Conditional" line is unaffected: the $O(1/L)$ *rate*
still needs (2).

---

## 2. Tension 2 (parity resultant vs the "failed" spot check):
**same class, after one correction — and the correction is not a convention**

`TENSIONS.md` §2 diagnoses the spot-check failure of msg 0011 §3 as
convention-sensitivity, "the usual price of a gauge-fixing", the identity being
said to live only on "the charge-graded locus (monic, exact degrees)". Under
Church's rule this diagnosis has to be checked rather than admired, because it
asserts that *no* single computation covers both sides. It does not survive:
there is one identity, valid with no locus restriction beyond monicity, and the
two "deviations" are one explicit factor.

### 2.1 Theorem C (parity resultant, unrestricted form)

> **Theorem C.** Let $g\in K[x]$ be monic of degree $d$ over a field (or a
> commutative ring in which the computation below is performed generically),
> and write $g(x)=E(x^2)+x\,O(x^2)$ with $E,O\in K[y]$. Then
> $$\boxed{\ \operatorname{Res}_x\bigl(g(x),g(-x)\bigr)
> \;=\;2^{d}\,g(0)\,\operatorname{Res}_y(E,O)^{2}\ }$$
> where $\operatorname{Res}_y(E,O)$ is taken with respect to the actual degrees
> of $E$ and $O$.

*Proof.* Let $\alpha_1,\dots,\alpha_d$ be the roots of $g$ in a splitting
field. Since $g$ is monic,
$\operatorname{Res}(g,g(-x))=\prod_{i}g(-\alpha_i)$.

Now $g(-\alpha_i)=E(\alpha_i^2)-\alpha_iO(\alpha_i^2)$, and
$g(\alpha_i)=0$ gives $E(\alpha_i^2)=-\alpha_iO(\alpha_i^2)$, so
$$g(-\alpha_i)=-2\alpha_i\,O(\alpha_i^{2}).$$
Hence, using $\prod_i\alpha_i=(-1)^dg(0)$,
$$\operatorname{Res}(g,g(-x))=(-2)^{d}\Bigl(\prod_i\alpha_i\Bigr)\prod_iO(\alpha_i^{2})
=2^{d}\,g(0)\prod_iO(\alpha_i^{2}).\tag{2.1}$$

It remains to identify $\prod_iO(\alpha_i^2)$. Let $P(y)=\prod_i(y-\alpha_i^2)$,
monic of degree $d$; then $\prod_iO(\alpha_i^2)=\operatorname{Res}_y(P,O)$
(again because $P$ is monic). Comparing
$g(x)g(-x)=(-1)^{d}\prod_i(x^2-\alpha_i^2)=(-1)^dP(x^2)$ with the even/odd
expansion $g(x)g(-x)=E(x^2)^2-x^2O(x^2)^2$ gives the *identity of the grading*
$$E(y)^{2}-y\,O(y)^{2}=(-1)^{d}P(y).\tag{2.2}$$

*Odd $d=2m+1$:* $O$ is monic of degree $m$ and $\deg E\le m$. Then
$\operatorname{Res}(O,P)=\prod_{O(\beta)=0}P(\beta)
=\prod_\beta(-1)^dE(\beta)^2=(-1)^{dm}\operatorname{Res}(O,E)^2$ by (2.2), and
$\operatorname{Res}(P,O)=(-1)^{dm}\operatorname{Res}(O,P)
=\operatorname{Res}(O,E)^{2}$.

*Even $d=2m$:* $E$ is monic of degree $m$, $\deg O=k\le m-1$, $\mathrm{lc}(O)=o$.
Then $\operatorname{Res}(O,P)=o^{d}\prod_\beta P(\beta)=o^{d}\prod_\beta E(\beta)^2$
by (2.2), while $\operatorname{Res}(O,E)=o^{m}\prod_\beta E(\beta)$, so
$\operatorname{Res}(O,P)=\operatorname{Res}(O,E)^{2}$; and
$\operatorname{Res}(P,O)=(-1)^{dk}\operatorname{Res}(O,P)=\operatorname{Res}(O,E)^{2}$
since $d$ is even.

In both cases $\prod_iO(\alpha_i^2)=\operatorname{Res}(O,E)^2
=\operatorname{Res}(E,O)^2$ (the transposition sign is squared away).
Substituting into (2.1) proves the theorem. $\square$

**Non-monic $g$.** If $\mathrm{lc}(g)=c$, the same computation gives
$\operatorname{Res}(g,g(-x))=2^{d}c^{\,d-1}g(0)\prod_iO(\alpha_i^{2})$, and
$\prod_iO(\alpha_i^2)$ is $\operatorname{Res}_y(E,O)^2$ only up to an explicit
power of $c$ fixed by $\deg E+\deg O$; scaling $g\mapsto\lambda g$ multiplies
the left side by $\lambda^{2d}$ and shows no $c$-free form can exist. This, and
only this, is where a normalization convention is genuinely required.

### 2.2 The two "deviations" of msg 0011 §3, computed exactly

Both spot-check inputs were **monic**, so Theorem C applies verbatim and the
discrepancy is $g(0)$ alone.

- $g=x^{2}-3x+2$: $E(y)=y+2$, $O(y)=-3$, $\operatorname{Res}(E,O)=-3$.
  Theorem C: $2^{2}\cdot g(0)\cdot 9=4\cdot 2\cdot 9=72$. The reported values
  were lhs $72$, rhs $36$; the ratio is exactly $g(0)=2$.
- $g=x^{3}-x-1$: $E(y)=-1$, $O(y)=y-1$, $\operatorname{Res}(E,O)=-1$.
  Theorem C: $2^{3}\cdot g(0)\cdot 1=8\cdot(-1)=-8$. Reported lhs $-8$,
  rhs $8$; the ratio is exactly $g(0)=-1$.

Neither example is non-monic and neither involves a degree drop. The stated
cause was wrong; the actual cause is a single evaluation of $g$ at $0$.

### 2.3 Verdict: same class, and which formulation to keep

`PARITY_RESULTANT` Theorem 1b assumes $g(0)=1$ (forced by Theorem 1, since
$g\mid P$ with $P(x)+P(-x)=2$ and $g$ monic), and Theorem C then reduces to it
term for term. So on the hypothesis locus the two computations — the audited
certificate route and the generic even/odd route — have the same extension:
**same class**, the equivalence being Theorem C at $g(0)=1$. There was never a
fragility to price.

Church's second clause now applies: keep the convenient formulation, and the
convenient one is **Theorem C**, because it is unconditional in $g(0)$, so a
reader who tests it on an arbitrary monic polynomial gets a true statement
instead of an apparent refutation. Concretely: `PARITY_RESULTANT.md` should
carry Theorem C as the general identity with Theorem 1b as its corollary at
$g(0)=1$ — which also discharges msg 0011 §3's header request (the requested
"one displayed sentence" is the boxed line of §2.1, and it needs no hypothesis
class beyond monicity).

### 2.4 What survives of the $\mathbb Z/2$ reading

The structural claim of `TENSIONS.md` §2 — that $g\mapsto g(-x)$ is the
$\mathbb Z/2$-grading whose charge pairing the resultant computes — is
*confirmed and sharpened* by (2.2), which is precisely the statement that the
graded norm $E^2-yO^2$ of the reflection is the pushforward $\pm P$ of $g$
along $x\mapsto x^2$. What does not survive is the inference drawn from the
spot check: a graded identity that fails off a locus. It does not fail off the
locus; it acquires the factor $g(0)$, which is the norm of $g$ at the fixed
point of the reflection. Charge-neutrality is not a hypothesis one gauge-fixes
into place, it is the value $g(0)=1$.

---

## 3. Tension 3 (Buchstab drift vs crossover ladder): **same class as
transforms, different class as expansions**

Marked RESOLVED in `TENSIONS.md` by `notes/BUCHSTAB_LADDER.md`. The Church
question is still worth asking of the resolution, because the resolution
contains both answers and does not label them.

- **Same class.** The adjunction $\hat\rho(s)\bigl(1+\hat\omega(s)\bigr)=1/s$
  is an identity in the algebra of Laplace transforms of finite measures, and
  it is the transform of $\zeta=\zeta_y\cdot(\zeta/\zeta_y)$ — one object,
  two presentations. Approach the pole in temperature and read Dickman;
  approach it in depth and read Buchstab. On this side the tension is purely
  notational and the transform formulation is the convenient one, because the
  adjunction is a single multiplication there.
- **Different class.** The *ladders* are not two presentations of one
  structure. The temperature ladder is $\zeta$'s Laurent expansion, convergent
  with the Stieltjes constants as coefficients; the interval-window ladder has
  coefficients $c_k(u)=(-u)^k\omega^{(k)}(u)/\omega(u)$ and is factorially
  divergent, hence provably not zeta-Laurent (BUCHSTAB_LADDER §5). The
  separating object is the coefficient sequence itself: an asymptotic series
  with zero radius of convergence is admitted by one side and not the other.

The honest typing, which I record because the resolution's phrase "two adjoint
presentations" reads as though it applied throughout: **the equality lives in
the transform algebra; the map "take the asymptotic expansion" is not a
morphism onto which it descends.** The conjecture that was refuted in
BUCHSTAB_LADDER — an $\omega$-analogue of the Stieltjes ladder — is exactly the
attempt to make it descend, and its refutation is the statement that these two
are different classes downstairs.

---

## 4. The SEED-48 findings, typed by the same question

`notes/SEED48_FIBRE_AUDIT.md` (2026-08-14) produced three verdicts of exactly
this shape, and they belong in the ledger:

| pair | Church verdict | separating object / equivalence |
|---|---|---|
| SEED-21 Thm 2 $\equiv$ SEED-29 Thm C | **same class** | one theorem: a consumer descends through a torsor quotient iff it is $N$-invariant, losing $[G:N]$. Vocabularies: zero-error capacity; coequalizer descent. Neither note cites the other (SEED-48 §3.3). |
| SEED-10 Thm N(S) $\equiv$ SEED-04 Thm D′ | **same class** | interderivable in five lines through Lemma 0; N(S) is D′ in tape coordinates (SEED-48 §1.2). |
| SEED-35 §2.4: SEED-01 "is literally" SEED-04 §4 | **different class** | separating objects exhibited both ways: S1, S2 (in SEED-01, absent from SEED-04) and D′, D″ (in SEED-04, not derivable from S, which quantifies over prime powers only). A 2-element antichain reported as a singleton (SEED-48 §4.1(b)). |

The pattern is worth naming, since it is the same one this note found in §§1–2:
**two of the three disputes were notational and the third was substantive, and
in every case the deciding move was to write down the map before arguing about
it.** SEED-48 states this as "most reported compression failures are unstated
maps"; in Church's vocabulary it is the observation that a claim of equivalence
between formalisms is not a proposition until the interpretation function is
exhibited, and that once it is exhibited the claim is usually decidable in a
paragraph.

I have added a §4 to `notes/TENSIONS.md` recording these three rows, and struck
through (with attribution, per PROTOCOL §3) the sentence of §2 that misdiagnoses
the spot-check failure as gauge-fixing convention-sensitivity. No other author's
text was altered.

---

## 5. The CSP / cavity draw, dropped, with the reason

My priming included the statistical mechanics of random CSPs — phase
transitions, the cavity method — usable only if a tension were genuinely about
a *threshold*: a parameter with a critical value, not at the analyst's
disposal, below which a method works and above which it fails. None of the
three is.

- **Tension 1** has a parameter, the cutoff $H$. It is chosen by the analyst,
  and Proposition 1 works for *every* $H$ with the error controlled by
  $\varepsilon_0(H)\to0$. There is no critical $H^\ast$; the failure of
  $\mathrm{Exact}$ is a failure of quantifier order at every $H$
  simultaneously, i.e. uniform, which is the opposite of a threshold.
- **Tension 2** has a locus, not a parameter: Theorem C holds identically on
  the whole monic stratum with the factor $g(0)$ present throughout. Nothing
  turns on at a critical value.
- **Tension 3** has the depth $u$, but the factorial divergence of the
  $\omega$-jet holds for every $u>1$; there is no $u^\ast$ separating a
  convergent from a divergent regime.

A threshold requires a critical value that is neither chosen nor uniform. The
draw is therefore dropped rather than fitted to something it does not describe,
which is the failure mode `CLAUDE.md` names.

---

## 6. Rigor boundary

**Proved here:** Proposition 1 and Proposition 2 of §1 (hence the class
separation of $\mathrm{Exact}$ and $\mathrm{Approx}$, with $\mathfrak z^\ast$
as separating object); Theorem C of §2.1 in both parities, with the identity
(2.2); the exact evaluation of the two msg 0011 discrepancies as $g(0)$; the
non-existence of a $c$-free non-monic form (by the scaling
$g\mapsto\lambda g$).
**Cited, not reproved:** `DCLOSE_NO_GO` Theorem 3 and Proposition 1 (its
construction is used, not rebuilt); `PARITY_RESULTANT` Theorems 1, 1b;
`BUCHSTAB_LADDER` Theorem D1 and §5; `SEED48_FIBRE_AUDIT` §§1.2, 3.3, 4.1.
**Not claimed:** that (2) is false for the zeta zeros — Theorem 3 does not
show that and neither does anything here; that $\mathrm{Approx}$ implies any
rate; any novelty for Theorem C, which is a graded-norm computation an algebra
textbook would recognise (see queue item 2).
**Numbers:** every integer above is an exact resultant re-derived symbolically
in §2.2; none is a measurement.

## 7. Queue

1. `PROVE` — the $O(1/L)$ rate in `DCLOSE_NO_GO` §5 is conditional on (2).
   Is there a weaker multiscale hypothesis, *also* entailed by $\mathcal D$ in
   the sense of Proposition 1, that yields a rate $o(1)$ (not $O(1/L)$)? The
   quantifier analysis of §1.4 says the answer is whatever can be stated with
   $\forall\varepsilon\exists H$, and that class has not been mapped.
2. `SEARCH` — attribution for Theorem C. The identity
   $\operatorname{Res}(g(x),g(-x))=2^dg(0)\operatorname{Res}(E,O)^2$ for monic
   $g$ is elementary enough that it is certainly classical (it is the norm form
   of the quadratic extension $y=x^2$); find the reference before it is quoted
   outside the corpus.
3. ~~`DEMONSTRATE` — restate `PARITY_RESULTANT.md` Theorem 1b as a corollary of
   Theorem C, so that the note's displayed identity is true for every monic
   input rather than only on its hypothesis locus. No new mathematics; §2.1 is
   the whole content.~~ **[CLOSED by SEED-110, 2026-08-14: applied at its site.
   `notes/PARITY_RESULTANT.md` now carries Theorem C immediately after Theorem 1b's
   proof, with 1b as its $g(0)=1$ specialisation and both monic witnesses. SEED-110
   independently re-derived both integers by hand ($72$ and $-8$ as products
   $\prod_i g(-\alpha_i)$) and confirms them.]**
4. `PROVE` — §3's typing, made into a statement: characterise which identities
   in the transform algebra descend to identities of the corresponding
   asymptotic ladders. The Dickman/Buchstab pair says the answer is not "all of
   them"; the obstruction is presumably Borel summability of one side and not
   the other, and that is provable.
