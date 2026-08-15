# Quantitative versus structural defects: a criterion, a no-go, and a corpus census

*Successor to `notes/FOUR_REPAIR_MODES.md` (seed 152), which derived the fourfold
$\Gamma_\varnothing,\Gamma_\Uparrow,\Gamma_\circlearrowleft,\Gamma_{\widehat{\phantom X}}$
from the human owner's transmission `collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md`
§B, flagged by its own triage §J1 as the most actionable content of D0016–D0018. **The four
modes, their names, the completion mode's Eichler spelling, and the injunction "first classify
$D_g$, only then complete" are the owner's.** What is below addresses the one thing seed 152's
§4.3 found and did not settle: that the fourfold is silent on the analytic half of this corpus.
Nothing here restates the transmission as a result (D0018 §J8).*

Seed 156, 2026-08-15.

---

## 0. What is settled here

| claim | status |
|---|---|
| the candidate framing "structural = group-valued, quantitative = order-valued" | **refuted as stated** (§2.1): $\mathbb Z$ is both, and both directions fail |
| replacement criterion: **structural = repair certified by ONE witness; quantitative = repair requires a MATCHED PAIR** | proposed, with hypotheses (§2.2), and used throughout |
| all four modes presuppose an attainable distinguished zero | **proved** (Thm A) |
| therefore no mode of the four kinds acts on a quantitative defect, except $\Gamma_\varnothing$ by fiat | **proved** (Cor A.1); this explains, rather than merely records, seed 152 §4.3 |
| a unary operation cannot discharge a bilateral certificate | **proved** (Thm B), under a stated definition of "mode" |
| **is there a fifth mode?** | **no**, under the definition of §4.0 — and the analytic candidates that look like modes are the existing four applied to the *observable field* (Thm C) |
| corpus balance | among **363** tagged queue items, a 1-in-5 subsample gives **21 structural : 6 quantitative** among genuine defects, with **31 items that are not defects at all** (§5) |
| one corpus item that is quantitative in form and has an attainable zero | found: `GENERATIVE_LOOP_IS_LEARNING.md` §7.1 (§4 → §3.1) |

**Scope limits, stated up front.** (i) The criterion of §2.2 is a criterion about *repair
certificates*, not about value sets; it is falsifiable and I give the test. (ii) The no-go
theorems are relative to a definition of "repair mode" that I supply in §4.0 and that the owner's
§B does not supply; a fifth mode under a different definition is not excluded, and I say so
rather than claiming more. (iii) The corpus census is a **textual census** — a finite,
reproducible classification of grep output — not a measurement; but it is a census of *tag
lines*, and 15 of 73 sampled lines were truncated past legibility and are excluded from the
ratio, which I report rather than hide. (iv) No Agda or Lean authored; nothing typechecked.
(v) D0018 §J5's $\chi_\alpha$ is a flagged fitted-quantity hazard and is untouched here; §5's
census is a count of exhaustively-enumerated text, not a fitted ratio, and it comes with its
denominator.

---

## 1. Verification of what I build on

The mandate is explicit that inherited grounds are checked more often false than inherited
claims. Two claims of `FOUR_REPAIR_MODES.md` are load-bearing below; I re-derive both.

**1.1 The torsor (that note's Thm 3), re-derived.** Let $V$ be an abelian $\Gamma$-module,
$f$ in an ambient with $f|\gamma-f=D_\gamma$, and let
$\mathcal C(f)=\{R\in V:\ (f+R)|\gamma=f+R\ \forall\gamma\}$. For $R\in\mathcal C(f)$:
$(f+R)|\gamma-(f+R)=D_\gamma+(R|\gamma-R)=0$, so $\partial R=-D$. If $R,R'\in\mathcal C(f)$ then
$\partial(R-R')=0$, i.e. $R-R'\in V^\Gamma$; conversely $R+z$ for $z\in V^\Gamma$ has
$\partial(R+z)=\partial R=-D$. So $\mathcal C(f)$ is empty or a $V^\Gamma$-torsor. **Verified.**
Consequence used below: "$X$ known $+$ $D$ known $\Rightarrow\widehat X$ reconstructible" is false
without a chosen lift, and the failure is a torsor ambiguity — a *structural* residue, not a
quantitative one. That distinction is the subject of this note and the example is well chosen.

**1.2 The $\operatorname{Ext}^1$ counterexample (that note's Thm 4′), re-derived.**
$\operatorname{Ext}^1_{\mathbb Z}(\mathbb Z/p,\mathbb Z/p)\cong\mathbb Z/p$: apply
$\operatorname{Hom}(-,\mathbb Z/p)$ to $0\to\mathbb Z\xrightarrow{p}\mathbb Z\to\mathbb Z/p\to0$,
giving $\mathbb Z/p\xrightarrow{p=0}\mathbb Z/p\to\operatorname{Ext}^1(\mathbb Z/p,\mathbb Z/p)\to0$,
so $\operatorname{Ext}^1\cong\mathbb Z/p$. The class $c\in\mathbb Z/p$ corresponds to the pushout
of $0\to\mathbb Z\xrightarrow{p}\mathbb Z\to\mathbb Z/p\to0$ along $1\mapsto c$; for $c\ne0$ the
pushout is $0\to\mathbb Z/p\to\mathbb Z/p^2\to\mathbb Z/p\to0$, because multiplication by $c$ is
an automorphism of $\mathbb Z/p$ and pushing out along an automorphism of the kernel changes the
class by that unit while leaving the middle term isomorphic. Hence all $p-1$ nonzero classes have
middle term $\mathbb Z/p^2$. **Verified**, and note precisely what it does and does not give: the
extensions are non-isomorphic *as extensions with identity on the ends*, and isomorphic once
automorphisms of the ends are allowed. That is the exact statement seed 152 needs and it is the
statement I use.

**1.3 What I did not verify.** The `CarryObstruction.agda` and `ACTION_RESIDUAL_FORMATION.md`
readings of seed 152 §4.1–4.2 are not re-checked here; I do not use them. The four corpus notes
of §4 below are read at the cited line ranges only, and I state for each what I read.

---

## 2. The criterion

### 2.0 Setup

**Definition 2.0.1 (defect datum).** A *defect datum* is a tuple
$\mathcal D=(\mathrm{Ob},\Delta,\delta,\mathrm{Rep},\mathcal O)$ where $\mathrm{Ob}$ is a class of
objects, $\Delta$ a set of *defect values*, $\delta:\mathrm{Ob}\to\Delta$, $\mathrm{Rep}\subseteq\Delta$
the *repaired* values, and $\mathcal O$ a set of partial operations $\mathrm{Ob}\rightharpoonup\mathrm{Ob}$
(possibly changing the ambient) that are the moves available. An object $x$ is *repairable* if some
composite in $\mathcal O$ carries $x$ to some $y$ with $\delta(y)\in\mathrm{Rep}$.

The four modes are exactly elements of $\mathcal O$ in the case $\Delta=Z^1(\Gamma,V)$ or $H^1(\Gamma,V)$,
$\mathrm{Rep}=\{0\}$.

### 2.1 The candidate framing is false as stated

The mandate offers, to test and not assume: *structural defects are valued in a group and vanish
or don't; quantitative defects are valued in an ordered set and admit only approximation.*

**Proposition 2.1.** The value set does not decide the classification. Both directions fail.

*Proof.* (a) *Order-valued with an attainable, self-certifying zero.* Take
`GENERATIVE_LOOP_IS_LEARNING.md` §7.1: the defect is the slack
$\mathrm{deficit}(V,t)-\mathrm{chainLen}(ch)\in\mathbb N$, order-valued, and the note computes it
exactly — it is the total multiplicity over-count $\sum_{a\in\mathrm{alph}(t)\setminus V}(m_t(a)-1)$,
which vanishes iff $t$ is multiplicity-free on its missing letters. The zero is attainable,
characterised, and certified by one witness (the exact count). Nothing about it is approximate.
(b) *Group-valued with no attainable zero.* Take $\Delta=H^1(\Gamma,V)$ with $\mathcal O$ containing
only the identity and $\Gamma_\circlearrowleft$ — i.e. no coefficient enlargement is available. For
$[D]\ne0$ the defect is group-valued and simply cannot be repaired; "approximation" is unavailable too,
so it is neither structural-in-the-useful-sense nor quantitative. (c) $\mathbb Z$ is simultaneously a
group and totally ordered, so no property of the value set alone can separate the two cases. $\square$

The framing is nonetheless pointing at something true; (c) says only that it points at it with the
wrong hand. What matters is not what $\Delta$ *is* but what a *certificate of repair* looks like.

### 2.2 The replacement criterion

**Definition 2.2.1 (certificate).** A *repair certificate* for $x\in\mathrm{Ob}$ is a finite datum
$C$ from which $\delta(y)\in\mathrm{Rep}$ is verifiable for the repaired $y$.

**Criterion 2.2.2 (arity of the certificate).**
- $\mathcal D$ is **structural** iff $\mathrm{Rep}$ is a singleton $\{0\}$ and repair admits a
  **unilateral** certificate: a single witness $C$ whose verification is an equality check.
  Paradigm: $R$ with $\partial R=-D$ (`FOUR_REPAIR_MODES.md` Thm 1). Verification is
  $D+\partial R=0$; nothing else is needed and nothing is left over.
- $\mathcal D$ is **quantitative** iff repair admits only a **bilateral** certificate: a pair
  $(C_+,C_-)$ of opposite type — an upper bound *and* a construction attaining it, an estimate
  *and* a matching example — whose verification is a comparison $C_-\preceq\delta\preceq C_+$
  together with $C_-=C_+$. Paradigm: proving an exponent optimal.

**Test (this is what makes the criterion a criterion and not a vibe).** Given a defect, ask:
*what would I have to hand a referee for them to agree it is repaired?* If one object suffices and
checking it is solving an equation, the defect is structural. If the referee needs two objects of
opposite type and checking them is comparing two inequalities, it is quantitative. If the referee
needs one object but checking it is comparing an inequality to nothing — an upper bound with no
lower bound in sight — the defect is quantitative and *unilaterally certified only in one
direction*, which is the ordinary state of an error term.

**Remark 2.2.3 (why "cohomological home" is narrower than "structural").** Having a cohomological
home is sufficient for structural, not necessary. §2.1(a) is structural on Criterion 2.2.2 — one
witness, an equality check — with no group action in sight. I flag this because the mandate's
phrasing ("has a cohomological home it was never given") invites conflating the two, and §4 finds
exactly one item where the distinction does the work.

**Remark 2.2.4 (on the residue).** The two cases differ in what *survives* repair. Structural
repair leaves a torsor ambiguity (§1.1): the repaired object is non-unique but every choice is
equally repaired. Quantitative repair leaves nothing ambiguous and everything provisional: the
"repaired" bound is a value that a later theorem can improve. Ambiguity without provisionality
versus provisionality without ambiguity. I offer this as a description, not as a second criterion.

---

## 3. The no-go

### Theorem A (all four modes presuppose an attainable zero)

*Each of the four modes of D0018 §B is a partial operation whose domain or codomain is defined by
membership in a distinguished singleton $\{0\}\subseteq\Delta$.*

**Proof.** Case by case, from the definitions in `FOUR_REPAIR_MODES.md` §1.1.

$\Gamma_{\widehat{\phantom X}}$: by Thm 1 of that note (re-derived at §1.1 above), $\widehat f=f+R$
exists iff $[D]=0$. Availability *is* a zero test; the mode is a partial function with domain
$B^1(\Gamma,V)$, and $B^1$ is by definition the fibre of $[\,\cdot\,]$ over $0$.

$\Gamma_\varnothing$: its action is $[\delta]\mapsto0$ by the transmission's own table. The
codomain is the singleton.

$\Gamma_\circlearrowleft$: it is total as a map $Z^1\to H^1$, but it is a *repair* only when the
class is zero — that note's Thm 6(iii): "$\Gamma_\circlearrowleft$ repairs $\delta$ iff $[\delta]=0$,
i.e. iff there was nothing to repair." As an operation it always applies; as a repair its success
predicate is again membership in $\{0\}$.

$\Gamma_\Uparrow$: it replaces the failed equation $f=g$ by a 2-cell $\alpha:f\Rightarrow g$. The
situation is repaired when the coherence tower is filled — i.e. when every higher filler exists,
equivalently when the obstruction to filling at each level is the distinguished (identity/zero)
element of the relevant obstruction group. This is the one mode `FOUR_REPAIR_MODES.md` §1.2
declines to prove theorems about, and I inherit that limitation: what I use is only that the
success predicate at each level is "the obstruction is the distinguished element", which is
constitutive of what filling a coherence tower means. $\square$

**Corollary A.1 (no mode acts on a quantitative defect).** *Let $\mathcal D$ be quantitative in the
sense of Criterion 2.2.2, so that no element of $\mathrm{Rep}$ is attained by any composite in
$\mathcal O$. Then $\Gamma_\circlearrowleft$, $\Gamma_{\widehat{\phantom X}}$ and $\Gamma_\Uparrow$
never report success, and $\Gamma_\varnothing$ reports success only by adjoining a hypothesis that
asserts the unattained value.*

**Proof.** Immediate from Theorem A: the first three have success predicate $\delta\in\{0\}$, which
by hypothesis is not attained. $\Gamma_\varnothing$ is not a map out of $Z^1$ at all
(`FOUR_REPAIR_MODES.md` Thm 6(ii)) but a choice of added datum; adding the datum "$\delta=0$" is
available always, at the cost of conditionality. $\square$

**This is exactly seed 152 §4.3, now with a reason.** That note found by inspection that for the
shifted-prime barrier of `SEED64_BOUNDARY_FACTORIZATION_AT_U2.md` §4, three modes are inapplicable
and $\Gamma_\varnothing$ "fits" only as *assume Elliott–Halberstam*. Corollary A.1 says this was not
a feature of that example. It is what happens to every quantitative defect, and the Elliott–Halberstam
move is the general shape of the degenerate case: $\Gamma_\varnothing$ with an unproved conjecture as
the killing datum.

### Theorem B (a unary operation cannot discharge a bilateral certificate)

*Let $\mathcal D$ be quantitative, so repair requires a certificate pair $(C_+,C_-)$ with
$C_-\preceq\delta\preceq C_+$ and $C_-=C_+$. Let $\Gamma_\ast$ be any unary partial operation on
defect-carrying data. Then $\Gamma_\ast$ can produce at most one of $C_+,C_-$ from $x$ alone; in
particular it cannot certify repair unless the other member is already available, in which case the
repair was not effected by $\Gamma_\ast$.*

**Proof.** A certificate $C_+$ is a proof of $\delta\preceq C_+$ and $C_-$ a proof of
$C_-\preceq\delta$; these are statements of opposite variance in $\delta$, and are logically
independent — for any candidate value $v$ there exist defect data agreeing with $x$ on all
$\preceq$-upper information and differing on lower information (take $\Delta$ with two elements
incomparable below $v$; both admit the same upper bounds). Hence no function of $x$ alone determines
both. If $\Gamma_\ast$ outputs the pair, it outputs information not determined by its input, i.e.
it is not a function of $x$ — it is a choice, which is $\Gamma_\varnothing$'s situation, and by
Thm 6(ii) of `FOUR_REPAIR_MODES.md` not natural. $\square$

**Hypothesis flagged.** Theorem B assumes that "repair" of a quantitative defect *means* closing
the gap, i.e. $\mathrm{Rep}$ is the diagonal $C_-=C_+$. If one instead calls "repair" any
$\preceq$-improvement, then trivially unary operations repair — and equally trivially they never
finish, because $\preceq$ has no top. Both readings say the same thing about the four modes; I have
chosen the reading on which the statement has content.

---

## 4. Is there a fifth mode? No.

### 4.0 What would count

The transmission gives no definition of "mode". I supply one, and everything in §4 is relative to it:

**Definition 4.0.1.** A *repair mode* is (i) a partial operation on defect-carrying data, (ii) with a
stated availability hypothesis checkable from the data, (iii) with a stated cost — what is
destroyed or owed, and (iv) whose success predicate is membership in a distinguished element of the
value set. This is abstracted from the four rows of `FOUR_REPAIR_MODES.md` §1.1, which have exactly
these four columns.

Clause (iv) is where the mandate's question lives. By Theorem A the four satisfy it; by Corollary
A.1 a quantitative defect has no such distinguished attainable element. So a fifth mode would have
to either supply one, or abandon (iv) and thereby not be a mode in the sense the other four are.

### 4.1 The candidates, taken seriously

**(a) Sharpen the error term.** Availability hypothesis: none checkable. Cost: none stated. Operation
on the defect: none — the object is unchanged; what changes is what is known about it. Verdict: *not
a mode; it is proving a theorem*, and CLAUDE.md's whole position is that this is the honest move.

**(b) Pass to a smoothed or averaged statistic.** This is the strongest candidate: it has a genuine
availability hypothesis (the smoothing must be admissible for the application), a genuine cost (loss
of pointwise information), and it does produce a new object. But: it does not repair the defect —
it removes the tests that detect it. By Corollary 2.2 of `FOUR_REPAIR_MODES.md` (widening the
*observable* field can only reveal obstructions; observables are tests, not coefficients), narrowing
the observable field can only conceal them. **Smoothing is $\Gamma_\varnothing$ performed on the
observable field**: kill the class by declining to test for it. Its honest version displays the
smoothing, exactly as $\Gamma_\varnothing$'s honest version displays the killing datum, and that is
why "we prove it for a smoothed count" is publishable and "we assume it" is not.

Averaging is the same operation read covariantly: passing to the mean is passing to the image in the
coinvariants for the averaging group. That is $\Gamma_\circlearrowleft$ — quotient to a class — with
the averaging group as gauge. It is honest for the same reason $\Gamma_\circlearrowleft$ is: the
quotient is forced once the gauge is named.

**(c) Change the norm.** Same analysis as (b): a norm is a family of tests. Changing it is
$\Gamma_\varnothing$ or $\Gamma_\circlearrowleft$ on the observable field depending on whether the
new tests are fewer or are a quotient of the old.

**(d) Restrict the range.** $\Gamma_\varnothing$ on the observable field, with the restriction as the
displayed datum. Cost: every downstream statement inherits the restriction — which is precisely
`SEED57_HONEST_HYPOTHESES_AND_INTERPOLATION_ERROR.md`'s standing complaint, quoted at §4.2(d) below.

**Theorem C.** *Each of (b), (c), (d) is one of the existing four modes applied to the observable
field rather than to the coefficient module; (a) is not an operation on the defect at all. Hence,
under Definition 4.0.1, no fifth mode arises from the standard analytic repertoire.*

**Proof.** By the classification in (b)–(d): each names a change of the family of tests, and a change
of tests is either a restriction (fewer tests: $\Gamma_\varnothing$, killing by not looking) or a
quotient (tests identified: $\Gamma_\circlearrowleft$). $\Gamma_{\widehat{\phantom X}}$ has no
observable-field analogue because enlarging the tests can only reveal (Cor 2.2 of the predecessor
note), and $\Gamma_\Uparrow$ requires a 2-cell, which the observable field does not carry unless it
is itself categorified — in which case the mode is $\Gamma_\Uparrow$ and not a new one. (a) changes
no object. $\square$

### 4.2 The one candidate with the right *character*, and why it still is not a mode

There is a fifth operation in this corpus's actual practice, and it is CLAUDE.md's own: **restore a
constant's parameter dependence.** "A number without its $X$-dependence is worse than no number,
because it looks like knowledge" (CLAUDE.md, on `HOLOGRAM.md` §7); and `SEED57` §7's queue item
says it in the same words: *"a second-order coefficient quoted without its $p$-restriction is the
same failure as one quoted without its $X$-dependence."*

Call it $\Gamma_{\!\downarrow}$: replace a defect value $\delta\in\mathbb R$ by the function
$\eta\mapsto\delta(\eta)$ it always was. It has an availability hypothesis (the parameters must be
identifiable), a cost (every downstream statement acquires the parameter), and it produces a new
object. It even has the *exact* character of $\Gamma_\circlearrowleft$, dualised:
$\Gamma_\circlearrowleft$ passes from a cocycle to its class by taking a quotient that is forced;
$\Gamma_{\!\downarrow}$ refuses a quotient that was taken illegitimately — the evaluation of a
function at an unstated point.

**And it is still not a repair mode**, for a reason I want stated flatly rather than hedged: it does
not act on the defect, it acts on the *report* of the defect. Before and after $\Gamma_{\!\downarrow}$
the mathematical situation is identical; what changes is that the written statement stops being
false. It fails clause (iv) of Definition 4.0.1 outright — there is no distinguished value to reach,
because the operation's target is a category error and not a defect. **It is hygiene, and hygiene is
not repair.** I record it here because it is the only candidate I found that survives clauses
(i)–(iii), and because a future reader who tries to make it the fifth mode should meet this
paragraph first.

### 4.3 The negative, stated

**There is no fifth repair mode.** Quantitative defects are repaired only by proof: by producing the
bilateral certificate of Criterion 2.2.2, which by Theorem B no unary operation can produce. Every
operation that looks like a mode is either one of the four applied to the observable field
(Theorem C), or hygiene (§4.2), or a theorem (§4.1(a)).

**Prior art, searched before this was written.** The nearest existing frame is Tao's *soft
analysis / hard analysis* dichotomy: soft analysis concerns existence, uniqueness, finiteness,
compactness; hard analysis concerns estimates, rates, bounds. That is the same cut, drawn on
*statements* rather than on *defects*, and it is prior art for the cut and not for anything proved
here. **It also supplies the strongest objection to §4.3, which I state rather than avoid:** Tao's
point is that the two sides are *inter-translatable* — compactness-and-contradiction turns
qualitative statements into uniform quantitative ones, and limiting arguments go back. If the
translation exists, is the structural/quantitative distinction real?

**Answer:** the translation moves *statements*; it does not move *repair operations*, and it is
lossy in exactly the direction that matters. Compactness-and-contradiction produces a bound with
**no effective constant** — it certifies $C_+$ exists without exhibiting it, so it does not produce
the certificate of Criterion 2.2.2. The existence of an ineffective translation is therefore
consistent with Theorem B and does not weaken it; what it shows is that the *statement* can be moved
across the cut while the *certificate* cannot, which is a sharper way to say what the cut is.
I claim this as an argument, not as a reading of Tao, whose blog post I have from search-result
summary only and did not fetch in full.

---

## 5. Four quantitative defects from the corpus, by a stated rule

**Sample rule, fixed before looking at any of the notes.** (1) Extract every occurrence of a queue
tag with `grep -rhoE '`(PROVE|SEARCH|DEMONSTRATE)`[^|]{0,150}' notes/*.md` — 363 occurrences, in
lexicographic file order. (2) Take every fifth, positions $n\equiv1\pmod5$ — 73 items. (3) Classify
each (§5.1). (4) The quantitative ones, in occurrence order, dropping any already struck through as
`DONE` and any tagged `DEMONSTRATE` (a demonstration request is not a defect), are the sample. This
yields exactly four, which is the number asked for; I did not tune the rule to reach it, and I record
that the rule's step (4) exclusions were what made the count four rather than six.

The four: `GENERATIVE_LOOP_IS_LEARNING.md:525`, `SEED32_INDEX_CAPACITY_RADIUS.md:542`,
`SEED43_KAPPA_RESOLVENT_POLES.md:321`, `SEED57_HONEST_HYPOTHESES_AND_INTERPOLATION_ERROR.md:409`.
For each I read the cited line and its immediate context only, and I state that as the ground.

### 5.1 (a) `GENERATIVE_LOOP_IS_LEARNING.md` §7.1 — **structural in disguise. This is the find.**

*What I read:* `generative-loop` proves `chainLen ch ≤ deficit V t`; the note states the truth is the
equality $\texttt{chainLen ch}=\lvert\mathrm{alph}(t)\setminus V\rvert$, because `probe` returns an
uncovered letter, `extend` installs exactly it, and the loop halts when none remains; `deficit`
over-counts by the multiplicity of each missing letter.

*Verdict.* Presents as quantitative — an inequality that is not tight — and is not. The slack is
$\mathrm{deficit}-\mathrm{chainLen}=\sum_{a\in\mathrm{alph}(t)\setminus V}(m_t(a)-1)$, an exactly
identified quantity vanishing precisely when $t$ is multiplicity-free off $V$. Certificate: one
witness (the exact count), verified by an equality. **Structural by Criterion 2.2.2.**

The mechanism is worth naming because it will recur: the defect was an artefact of the *weaker
statement*, not of the object. The inequality had slack because it compared `chainLen` to the wrong
quantity — a multiset cardinality where a set cardinality was meant. In the language of the modes,
this is $\Gamma_\circlearrowleft$: the repair is to quotient the multiset by multiplicity and take
the class, which is exactly the underlying set. **A corpus item whose queue tag says "replace the
inequality by the exact step count" and whose actual content is "pass to the coinvariants of the
multiplicity action".** I do not claim a cohomological home for it (Remark 2.2.3): I claim an
attainable, self-certifying zero, which is what the criterion asks for.

*Methodological consequence.* Criterion 2.2.2 must be applied to the **sharpest available
statement** of the defect, not to the one in the queue. Applied to the queue line, (a) reads
quantitative; applied to the note's own next paragraph, it is structural. Any census that skips this
step over-counts quantitative defects, and I flag §5.2's numbers as subject to that bias.

### 5.2 (b) `SEED32_INDEX_CAPACITY_RADIUS.md` §item 3 — **structural, and it was already stated as such.**

*What I read:* "Proposition 4.1 says the witness radius is the covering radius minus the singleton
indicator… Is the general statement — for a checked torsor with a free alphabet,
$W=R-[\text{top class is a singleton}]$ — true beyond $\mathbb Z/m$? The proof of 4.1 uses only
$\lambda(r,s)=\min(d(r),d(s))$, which needs the check to be a point-indicator. State the hypothesis
exactly."

*Verdict.* **Structural.** The defect is not a gap between $W$ and $R$ — that gap is *known
exactly*, it is a $\{0,1\}$-valued indicator. The defect is the unstated scope of a hypothesis, and
its certificate is unilateral: exhibit the hypothesis under which the proof of 4.1 goes through, and
the equality check is that $\lambda(r,s)=\min(d(r),d(s))$ holds. Radii and capacities are integers,
which is why this reads quantitative to a keyword scan and is not; it is Proposition 2.1(c) in the
wild.

### 5.3 (c) `SEED43_KAPPA_RESOLVENT_POLES.md` §7 — **irreducibly quantitative, but of the good kind (bilateral, with $C_-$ already in hand).**

*What I read:* Lemma 3.2 is "an inequality, not a constant"; the completion-of-square route
$\|R\|_F^2\ge2\langle R,S\rangle-\|S\|_F^2$ with the stated $S$ reproduces the right-hand side and
**attains equality at exp47's D2 configuration**, but the cross term
$c\langle Q,\Pi_{\operatorname{ran}P}\rangle$ is not sign-definite; the queue item is to close that
gap and "retire exp47's D1 random-instance block".

*Verdict.* **Quantitative**, and it is the cleanest illustration in the sample of Criterion 2.2.2's
arity test. The certificate is explicitly bilateral and the note knows it: $C_-$ exists (the D2
configuration attaining equality — a construction), $C_+$ is the sought inequality, and repair is
their meeting. No mode acts here: there is no group, no class, and Corollary A.1 applies verbatim.
$\Gamma_\varnothing$'s degenerate form would be to assume the cross term sign-definite, which is
exactly the move the note declines.

Note also what the item *replaces*: "30 random rational instances is not a proof". That is
CLAUDE.md's rule enforced inside a note, and it is the correct diagnosis — a numerical run standing
in for a $C_+$ that has to be derived.

### 5.4 (d) `SEED57_HONEST_HYPOTHESES_AND_INTERPOLATION_ERROR.md` §7 — **neither: a hygiene item.**

*What I read:* "`PROVE` — propagate §6.1's $\eta$-dependent bound into `FRESNEL.md` together with
SEED-24's boxed C1 form. A second-order coefficient quoted without its $p$-restriction is the same
failure as one quoted without its $X$-dependence."

*Verdict.* **Neither structural nor quantitative — it is §4.2's $\Gamma_{\!\downarrow}$.** The bound
already exists with its $\eta$; the defect is that a downstream note carries the value without the
dependence. Nothing is obstructed and nothing needs improving; a true statement is written falsely
elsewhere. Its certificate is neither unilateral nor bilateral but editorial. That this item was
selected by an arithmetic rule and turned out to be the live corpus instance of the operation I had
already isolated on general grounds in §4.2 is the one piece of luck in this note, and I flag it as
luck rather than as evidence: $n=1$.

### 5.5 Sample verdict

Four items chosen by rule: **two structural** ((a) presenting as quantitative — the valuable find;
(b) presenting as quantitative because its values are integers), **one irreducibly quantitative**
(c), **one neither** (d). The lexical marks of quantitativeness — an inequality, a radius, a
coefficient — identified the class correctly in **one** of four cases. That is the finding of §5 and
it is a warning about §6.

---

## 6. Corpus balance

**Counting rule.** Unit of count: one occurrence of a queue tag `PROVE`/`SEARCH`/`DEMONSTRATE` in
`notes/*.md`, as extracted by the §5 command. **Denominator: 363.** Subsample: the 73 items at
positions $n\equiv1\pmod5$. Of these, **15 were truncated past legibility** by the 150-character
window (bare "`PROVE`." and similar) and are **excluded**, leaving 58 classified. Classification
into structural / quantitative / neither by Criterion 2.2.2 applied to the tag line's text.

| class | count (of 58 legible) |
|---|---|
| structural — existence, construction, identity, scope-of-hypothesis, formalisation of a definition | **21** |
| quantitative — a bound to be tightened, a rate, an exponent, an optimality question | **6** |
| neither — prior-art debts (`SEARCH`), corpus audits, restatement chores, evaluation tasks ("compute this diameter") | **31** |

**Reading, with the caveats first.** (i) The classification is from tag lines, and §5 showed that
tag lines misclassify: applied to the four items of §5 the line-level reading got one of four right,
and it erred *toward* quantitative every time. So **21:6 is a lower bound on the structural share**,
not an estimate of it. (ii) 15/73 illegible is 20% of the subsample; a different window changes the
denominator. (iii) The subsample is systematic, not random, and the corpus is sorted by filename, so
any correlation between filename and subject leaks in. This is why I give the rule and the raw
counts and not a fitted fraction.

**Answer to the mandate's question.** Of the 27 sampled items that are genuine defects, roughly
**four in five are structural** and one in five quantitative; and — the larger fact — **more than
half of the live queue (31 of 58) is not a defect at all**: it is prior-art debt, audit work, and
evaluation tasks, on which the §B classification has no purchase and is not meant to have any.

So D0018 §B's coverage of this corpus is: **strong on the majority of genuine defects, silent on
about a fifth of them, and orthogonal to more than half of the queue.** That is a better result for
the transmission than seed 152's §4.3 suggested — that note's sample of three happened to include
the analytic lane, where quantitative defects concentrate, and generalised from it. **The
generalisation "quantitative defects are most of this corpus" is not supported by this census; what
is supported is "quantitative defects are most of the *analytic* corpus", which is a much narrower
claim.** I record that as a correction to a note I am building on, per standing check (c): its
summary line said "most of the analytic corpus" and its §4.3 body said "the majority of the analytic
corpus", while the message file's reportable finding said "most of this corpus's analytic side" —
the bodies were right and any reader who compressed them to "most of this corpus" would be wrong.

---

## 7. Queue

1. **`PROVE`** — Criterion 2.2.2's arity test is stated for certificates; is there a defect whose
   repair certificate is $k$-ary for $k\ge3$? If not, prove the dichotomy is exhaustive; if so, the
   structural/quantitative cut is the $k=1$/$k=2$ case of something longer.
2. **`PROVE`** — Sweep the corpus for the §5.1 pattern: queue items reading "replace the inequality
   by the exact value" whose slack is an identified invariant. Each is a structural defect wearing a
   quantitative tag, and §5 found one in a sample of four.
3. **`SEARCH`** — Is the arity-of-certificate criterion prior art under another name? The obvious
   places are effective-vs-ineffective bounds in analytic number theory and the reverse-mathematics
   literature on $\Pi^0_2$ versus $\Sigma^0_1$ statements; I searched only Tao's soft/hard
   dichotomy and did not fetch it in full.
4. **`PROVE`** — §4.2's $\Gamma_{\!\downarrow}$: is "restore the parameter dependence" ever
   *unavailable*, i.e. is there a corpus constant whose dependence is not identifiable? If never,
   it is pure hygiene as claimed; if sometimes, clause (ii) of Definition 4.0.1 bites and it is
   closer to a mode than §4.2 concedes.

## 8. Honesty ledger

- Nothing computed. No Python, no numerics, no fitted constant. §5–§6's counts are a finite
  exhaustive extraction of text by a stated command, reproducible verbatim, and every number is
  reported with its denominator and its exclusions. §6 deliberately reports counts and refuses a
  fraction beyond "roughly four in five", because the sampling bias of §6(i) is real and one-sided.
- D0018 §J5's $\chi_\alpha$ is untouched; it remains a flagged fitted-quantity hazard and nothing
  here should be read as defining $\Delta\operatorname{Reach}$ or $\Delta\operatorname{Kill}$.
- No Agda or Lean authored; nothing claimed typechecked.
- **Grounds.** §1.1 and §1.2 are re-derived here and I stand behind them. §3's Theorem A leans on
  `FOUR_REPAIR_MODES.md` Thms 1 and 6, which I re-derived (Thm 1) and did not re-derive (Thm 6(ii),
  (iii)); Thm 6(iii) is used and is a one-line restatement of Thm 1, so it inherits the check.
  §4's Theorem C leans on that note's Cor 2.2 (observables are tests, coefficients are not), which
  I did **not** re-derive; if Cor 2.2 is wrong, Theorem C's classification of smoothing is wrong.
  **[RE-DERIVED by seed 159, 2026-08-15. Cor 2.2 HOLDS, both halves, and Theorem C is now fully
  grounded. Coefficient half: $\iota:V_0\to V$ is $\Gamma$-equivariant and additive, hence induces
  a chain map on cochains commuting with $\partial$, hence a group homomorphism
  $\iota_*:H^1(\Gamma,V_0)\to H^1(\Gamma,V)$, hence $[D]=0\Rightarrow\iota_*[D]=0$; the converse
  fails (Cor 2.1, Eichler), which is the asserted one-sidedness. Scope note: this is a statement
  about a *fixed* cocycle, not about the size of $H^1$ — enlarging $V$ may well create obstructions
  for *other* objects, and "widening coefficients can only kill" is false read as a statement about
  $H^1$ itself. Seed 156 uses it only on fixed defects, so the use is sound. Observable half: with
  $\operatorname{Obs}_S(X)$ the set of tests in $S$ that $X$ fails, $S\subseteq S'$ gives
  $\operatorname{Obs}_S\subseteq\operatorname{Obs}_{S'}$ immediately; with $\operatorname{Obs}$ read
  as the distinguishability defect $\delta_{\mathfrak h}$, the same monotonicity is
  `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` Lemma 6.2 + Theorem E(a)$\Rightarrow$(b), whose proof
  I read and re-checked (both directions of E are correct; (c)$\Rightarrow$(a) via the transposition
  $(x\,x')$ is right). **One refinement, and it matters for how Cor 2.2 should be quoted:** the
  *displayed formula* of Cor 2.2 is a **non**-implication, which by itself is strictly weaker than
  and of a different type from what Theorem C uses. Theorem C needs the positive monotonicity
  $\operatorname{Obs}_S\subseteq\operatorname{Obs}_{S'}$ — stated in Cor 2.2's **prose** ("more tests
  can only fail more") and proved in `CHANGING_TESTS_VERSUS_SHRINKING.md`. A reader who took the
  displayed non-implication as the content of Cor 2.2 would have a non-sequitur at Theorem C. The
  prose is the load-bearing half and it is true.]**
  §5's four verdicts rest on the cited line ranges only; I did not read the four notes in full and
  do not assert their theorems.
- **Definitional dependence, flagged as the main scope limit.** §4's negative is relative to
  Definition 4.0.1, which is mine and not the owner's. A reader who defines "mode" without clause
  (iv) will find fifth modes easily — smoothing, averaging, restriction — and will be describing
  something real; they will not be describing the thing the four modes are. The whole force of
  "there is no fifth mode" is carried by clause (iv), and I would rather say that than let the
  negative look stronger than it is.
- **On the concluding generalisation** (standing check (f)): §6's claim that the transmission
  covers the corpus better than seed 152 suggested rests on a systematic 1-in-5 subsample of tag
  lines with a 20% illegibility rate and a demonstrated one-sided misclassification bias. It is
  offered at that generality. What is *not* subject to that caveat is Corollary A.1 and Theorem B,
  which are proofs from definitions and do not depend on any count.
- Prior art (Tao, soft/hard analysis) was searched **before** this was written, and appears in §4.3
  as both the located frame and the strongest objection, with its answer.

*Credit: the fourfold, its names, the Eichler spelling of $\Gamma_{\widehat{\phantom X}}$, and the
discipline "first classify, then complete" are the human owner's (D0018 §B, triage §J1). The
observation that the fourfold is silent on quantitative defects is seed 152's
(`notes/FOUR_REPAIR_MODES.md` §4.3); this note supplies its reason, its criterion, its no-go, and
its correction.*
