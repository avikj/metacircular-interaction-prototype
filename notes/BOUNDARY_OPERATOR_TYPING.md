# The boundary operator ∂ of D0016 §B: the ill-typing confirmed, its ground corrected, and the blast radius measured

**Status.** The claim is **confirmed** — $\partial$ as displayed in D0016 §B is not a coend,
and the refutation is a one-line occurrence count, which is exact symbolic reasoning and
therefore proof. **A saving reading exists**, it is supplied by the transmission's own §E, and
it changes the display rather than merely reinterpreting it. **The containment result is the
deliverable and it is good news**: of the five fleet notes the mandate names, four are
*entirely* independent of $\partial$, and the fifth depends on it only in one paragraph whose
conclusion is a *negative about $\partial$* and is strengthened rather than weakened. One
downstream result — the prior pass's own refutation of §H's dichotomy — must be **restated
from categorical to conditional**, and it survives the restatement under every candidate
repair.

**One correction to the ground of the claim I was sent to check**, per standing check (d).
Both prior statements of the degeneracy compute the wrong object. `UNTOUCHED_REGIONS_ADJUDICATED.md`
§5 says the colimit is $\coprod_{(f,t)}e(f,t)\cong\mathcal F\times\mathcal T$;
`ADVANCE_CONJUNCTS_DEFINED.md` §6.3(b) says it is a coproduct "whose only invariant is a
cardinality — a cardinality of the index set". Neither holds without an unstated hypothesis on
$Q_\alpha$, and the true statements (§3 below) are both sharper and, in one case, worse for
the transmission than what was claimed. The headline of each is right; the arithmetic under it
is not. That is the fourth time in this corpus a true claim has been found resting on a false
ground, and the first time tonight that the correction makes the claim *stronger*.

**Source.** Repository owner, `collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md`
§§A, B, E, F, H, I, J4, and `D0018` §D. Owner artifact: this note derives from it, quotes it,
and rewrites nothing. Every display below is transcribed, not paraphrased.

**No Python was written or run. No Agda or Lean was authored. No PDF was decoded.** Mac Lane
CWM ch. IX §§5–6 (ends and coends), Bénabou's profunctors, and the co-Yoneda lemma are used
from their standard statements, which I write out where used.

---

## 0. The two displays, transcribed

D0016 §A:

$$\Diamond_\alpha=\bigl(X_\alpha,\mathcal F_\alpha,\mathcal T_\alpha,e_\alpha,\rho_\alpha,\Pi_\alpha,\mathcal O_\alpha\bigr),
\qquad e_\alpha:\mathcal F_\alpha\times\mathcal T_\alpha\to Q_\alpha$$

D0016 §B:

$$\partial\Diamond_\alpha:=\int^{(f,t)\in\mathcal F_\alpha\times\mathcal T_\alpha}e_\alpha(f,t),
\qquad
\mathcal O_\alpha:=\int^{\sigma\in N(\mathcal F_\alpha)}\delta_\sigma .$$

D0016 §E, which is the material that matters for the repair:

$$\vee:\mathcal F_\alpha\rightleftarrows\mathcal T_\alpha,\qquad e^\vee(t,f):=e(f,t),
\qquad
\mathfrak F_\alpha:=\ulcorner-\urcorner_\alpha\circ\vee_\alpha\circ\Phi_\alpha\circ\Gamma_\alpha\circ\delta_\alpha\circ\partial_\alpha .$$

---

## 1. The criterion, stated so the verdict is checkable without me

**Definition (coend, as I use it).** Let $\mathcal C$ be small and $F:\mathcal C^{op}\times\mathcal C\to\mathcal D$
a functor. The coend $\int^{c\in\mathcal C}F(c,c)$ is the coequalizer

$$\coprod_{u:c\to c'}F(c',c)\ \rightrightarrows\ \coprod_{c}F(c,c)\ \longrightarrow\ \int^{c}F(c,c),$$

the two maps being $F(u,1)$ and $F(1,u)$. Mac Lane, CWM ch. IX §6; standard statement, no text
opened.

**The operative test, and it is purely syntactic.** In $\int^{c}F(c,c)$ the bound variable $c$
occurs **exactly twice** in the integrand, once contravariantly and once covariantly. That is
not a convention; it is what makes the two parallel maps of the coequalizer exist. A bound
variable occurring **once** has no diagonal to be restricted to and no pair of maps to
coequalize. So:

> **Occurrence test.** $\int^{c}E$ is well-formed as a coend only if $c$ occurs twice in $E$,
> in opposite variances.

---

## 2. Verdict on §B's $\partial$: ill-typed, confirmed

**Proposition 1.** $\int^{(f,t)\in\mathcal F_\alpha\times\mathcal T_\alpha}e_\alpha(f,t)$ is
not a coend, for any $\mathcal F_\alpha$, $\mathcal T_\alpha$, $Q_\alpha$ and any functorial
structure whatever on $e_\alpha$.

*Proof.* Put $\mathcal C:=\mathcal F_\alpha\times\mathcal T_\alpha$, so the bound variable is
the pair $c=(f,t)$. A coend over $\mathcal C$ requires a functor
$F:\mathcal C^{op}\times\mathcal C\to\mathcal D$ — that is, a functor of **four** arguments
$(f^-,t^-,f^+,t^+)$, evaluated on the diagonal $F\bigl((f,t),(f,t)\bigr)$. The transmission
supplies $e_\alpha$, a functor of **two** arguments. There is no diagonal, because there is
nothing off it: $e_\alpha(f,t)$ is already the whole integrand and each of $f,t$ occurs once.
By the occurrence test the display fails. $\square$

**And it fails in a way that no enrichment repairs.** `ADVANCE_CONJUNCTS_DEFINED.md` §6.3(b)
locates the gap as "the enriching category of $e$ and the functoriality making $\int^{(f,t)}$
a coend rather than a coproduct". Proposition 1 says this is not the whole gap and not the
operative half of it: functoriality of $e_\alpha$ in each variable is *necessary* and is
*not sufficient*, because the defect is arity, not enrichment. Supplying $Q_\alpha$ with all
colimits and making $e_\alpha$ a functor still leaves each variable occurring once. **The
missing datum is a diagonal, i.e. an identification of $\mathcal F_\alpha$ with
$\mathcal T_\alpha^{op}$** — which is exactly what §3.1 below supplies and §6.4(ii) of that
note did not name.

**This is not a slip local to $\partial$.** The same occurrence test applied to the rest of the
signature:

| display | source | bound variable occurs | verdict |
|---|---|---|---|
| $\int^{(f,t)\in\mathcal F\times\mathcal T}e(f,t)$ | §B | once (each) | **not a coend** |
| $\int^{\sigma\in N(\mathcal F_\alpha)}\delta_\sigma$ | §B | once | **not a coend** |
| $\mathbb B=\int^{\alpha\in\mathbf{Ord}_{<\kappa}}\Diamond_\alpha$ | §E | once | **not a coend** |
| $\int^{i}\bigl(\mathfrak M_i^\vee\otimes\mathfrak M_i\bigr)$ | §I | **twice**, opposite variances | well-typed |

So the transmission's $\int^{-}$ is a generic *assemble-over-the-index* operator everywhere
except §I, where it is a genuine coend — and §I is precisely the one place a prior pass
checked the variance before believing it (`UNTOUCHED_REGIONS_ADJUDICATED.md` §9.1). **This is
the same shape of finding as the ledger's "$-$" observation** (ledger §2.1, §2.9 and
`UNTOUCHED_REGIONS_ADJUDICATED.md` §14.2: three occurrences of a subtraction in settings that
supply no subtraction, one correction rather than three). Two symbols, one habit: a
notation is being used for its *shape* — difference, assembly — in settings that do not supply
the operation the shape names. I record the parallel and claim nothing beyond these two
symbols.

---

## 3. Is there a reading that saves it? Yes — one, and it is the owner's own §E

### 3.1 The $\vee$-diagonal reading (the saving reading)

§E supplies $\vee:\mathcal F_\alpha\rightleftarrows\mathcal T_\alpha$ with
$e^\vee(t,f)=e(f,t)$. Suppose — and this is an addition, flagged as such in §3.4 — that $\vee$
is an equivalence

$$\vee:\ \mathcal T_\alpha^{op}\ \xrightarrow{\ \simeq\ }\ \mathcal F_\alpha .$$

Put $\mathcal C:=\mathcal T_\alpha$. Then $\mathcal F_\alpha\simeq\mathcal C^{op}$ and
$e_\alpha$ becomes a functor $\mathcal C^{op}\times\mathcal C\to Q_\alpha$ — that is, a
**$Q_\alpha$-valued profunctor $\mathcal C\kern1pt⇸\kern1pt\mathcal C$** — and

$$\boxed{\ \partial\Diamond_\alpha\ :=\ \int^{t\in\mathcal T_\alpha}e_\alpha(\vee t,\,t)\ }$$

is a bona fide coend: the **trace** of the endoprofunctor $e_\alpha$. It is the standard
categorical trace, it exists whenever $Q_\alpha$ is cocomplete, and by co-Yoneda it is the
composite of $e_\alpha$ with the identity profunctor along its diagonal. Under this reading
$\partial$ genuinely *assembles the matrix modulo the morphisms*, which is the legible intent
of §B.

**What the reading costs, stated plainly because it is not free.**

1. **The index changes.** The coend is over $\mathcal T_\alpha$, **not** over
   $\mathcal F_\alpha\times\mathcal T_\alpha$. §B's display must be *rewritten*, not merely
   reread. The product index is precisely the error, and no reinterpretation of the integrand
   removes it.
2. **A hypothesis is added.** §E writes $\vee$ with harpoons and gives $e^\vee$ as the
   transposed matrix. That is the **Chu involution on spaces** — it swaps the two sides of the
   triple $(X,\mathcal T,e)$ — and it is *not* the assertion that the two indexing categories
   are opposite to one another. In the standard Chu setting the identification is natural
   (tests are $Q$-valued functionals on points, points are $Q$-valued functionals on tests),
   and that is why I call this the saving reading rather than an invention. But the
   transmission as written leaves $\mathcal F_\alpha$ and $\mathcal T_\alpha$ unrelated
   categories, and **whether $\vee$ is an equivalence is a question for the owner, not a
   theorem** (`UNTOUCHED_REGIONS_ADJUDICATED.md` §16: choosing among readings is a decision).
3. **$Q_\alpha$ must be cocomplete**, or at least admit the one coequalizer. §A gives no type
   for $Q_\alpha$ at all; §F treats it as a bare set of values.

### 3.2 The profunctor reading *without* $\vee$ does not save it

Type $e_\alpha:\mathcal F_\alpha^{op}\times\mathcal T_\alpha\to Q_\alpha$, a profunctor
$\mathcal F_\alpha⇸\mathcal T_\alpha$. **No trace is available**: a profunctor has a trace only
when its source and target categories coincide, and $\int^{f}e(f,t)$ is still ill-formed
because $f$ still occurs once. What a profunctor between *different* categories supports is
**composition** with another profunctor, $\int^{t}P(f,t)\otimes R(t,g)$ — where the bound
variable $t$ occurs twice, once in each factor, which is why *that* coend is legitimate and
this one is not.

So the profunctor typing gives $e_\alpha$ its correct **type** and gives $\partial$ **no
value**. Taken alone as a repair it says $\partial\Diamond_\alpha:=e_\alpha$, i.e. $\partial$
is the identity on the Chu datum and contributes nothing to the composite $\mathfrak F$. It is
a prerequisite for §3.1, not an alternative to it. Named as a candidate in the mandate, tested,
and rejected as a standalone repair.

### 3.3 The plain-colimit reading, and the degeneracy computed correctly

Drop the coend and read $\partial\Diamond_\alpha:=\operatorname*{colim}_{\mathcal F_\alpha\times\mathcal T_\alpha}e_\alpha$,
$e_\alpha$ a diagram into a category $Q_\alpha$. This is well-formed. Here is what it is, and
here both prior statements of the degeneracy need correcting.

**Proposition 2 ($Q_\alpha$ a bare set of values).** Let $Q_\alpha$ be a set regarded as a
discrete category, $\mathcal F_\alpha,\mathcal T_\alpha$ discrete (a *bare* Chu space, D0016
§F). Then $\operatorname*{colim}e_\alpha$ **exists if and only if $e_\alpha$ is constant**, and
then equals its constant value.

*Proof.* Let $D:I\to Q$ with $I$ discrete and $Q$ discrete. A cocone to $z$ is a family of
morphisms $D(i)\to z$; in a discrete category the only morphisms are identities, so a cocone
exists iff $z=D(i)$ for every $i$, which forces $D$ constant. If $D\equiv q$, the identity
cocone to $q$ is universal: any other cocone has vertex $q$ and its mediating map is
$1_q$. If $D$ is non-constant no cocone exists, so no colimit does. $\square$

That is a finite exhaustive argument, hence proof per `CLAUDE.md`, and it is **worse for the
transmission than "degenerate"**: on the literal §F reading, $\partial\Diamond_\alpha$ is not
degenerate, it is **undefined on every Chu space that distinguishes anything at all** — which
is every space §F cares about.

**Proposition 3 ($Q_\alpha$ a poset / value quantale — the reading under which $\int$ has a
chance).** With $Q_\alpha$ a poset and $\mathcal F_\alpha,\mathcal T_\alpha$ discrete,

$$\partial\Diamond_\alpha=\bigvee_{f\in\mathcal F_\alpha,\ t\in\mathcal T_\alpha}e_\alpha(f,t).$$

For $Q_\alpha=\mathbf 2=\{0<1\}$: $\partial\Diamond_\alpha=1$ iff some matrix entry is $1$.

*Proof.* A colimit in a poset is a least upper bound; over a discrete index it is the join of
the values. $\square$

**Corollary 3.1 (what this does to §H).** Under Proposition 3 with $Q=\mathbf 2$,
$\Delta\partial_{\mathrm{future}}=0$ on **every** step between two Chu spaces that are not
identically $0$. So §H's *trapped-light* holds on essentially every step and
*productive-reflection* on essentially none: the pair is not merely non-exhaustive
(`UNTOUCHED_REGIONS_ADJUDICATED.md` §7), it is **constant**. A predicate that is constant on
its intended domain is not a criterion.

**The correction to the two prior grounds, stated exactly.**
`UNTOUCHED_REGIONS_ADJUDICATED.md` §5 asserts
$\coprod_{(f,t)}e(f,t)\cong\mathcal F\times\mathcal T$. That holds only if every $e(f,t)$ is a
**singleton set** — i.e. only if $Q_\alpha$ is taken inside $\mathbf{Set}$ with every value
terminal, a hypothesis nowhere stated and false for the $Q=\{0,1\}$ of §F and of every witness
in the corpus. `ADVANCE_CONJUNCTS_DEFINED.md` §6.3(b) asserts the coproduct's "only invariant
is a cardinality — a cardinality of the index set"; if the values are genuine sets the
cardinality is $\sum_{(f,t)}|e(f,t)|$, not $|\mathcal F\times\mathcal T|$, and if they are
elements of a bare set the coproduct is not formed at all (Proposition 2). Both headlines —
*ill-typed as a coend*, *degenerate or worse as a colimit on bare Chu spaces* — **stand**.
Both computations offered as their ground **do not**, and Propositions 2 and 3 replace them.

### 3.4 Summary of §3

There is **exactly one** reading that leaves $\partial$ with content, it is §3.1, it requires
an identification the transmission gestures at in §E and does not assert, and it requires the
display's index to be changed. Everything else is well-formed and empty.

---

## 4. Containment: which fleet results depend on $\partial$

This is the deliverable. I read each note named in the mandate and traced every occurrence of
$\partial$ and of $\int^{-}$ in it.

### 4.1 Independent of $\partial$ — nothing to restate

**`notes/SHRINKING_TESTS_LOWER_CURVATURE.md`.** Theorems 1–5 and the witnesses E1, E2, E2′.
Every one is stated in $(X,\mathcal T,e)$, the separation relations $\sim_S$, the holonomy
$\mathfrak h_\sigma$ and the defect $\delta_\sigma(S)=\{x:D_\sigma(x)\cap S\ne\emptyset\}$ —
i.e. in D0016 **§F**, the Chu core, and in §B's *holonomy* clause, which is a product of
$\rho$'s and involves no integral. $\partial$ occurs in the note at exactly three lines (615,
620, 759) and all three are inside its own "what this does not prove" and
"untouched" lists — $\partial\delta^{(\lambda)}\ne0\Rightarrow\lambda\mapsto\lambda+1$ and
$\mathbb B=\int^\alpha\Diamond_\alpha$, both explicitly disclaimed there.
**Fully independent.**

**`notes/CHANGING_TESTS_VERSUS_SHRINKING.md`.** Theorems A–F. The boundary operator occurs
zero times: line 362 is the phrase "partial order" and line 539 is $\mathbb B=\int^\alpha\Diamond_\alpha$
in the untouched list. Its $\operatorname{Ob}(-)$ is the note's own operator built from
$\delta$ and the Galois adjunction of its Theorem B, **not** §B's $\int^{\sigma}\delta_\sigma$.
**Fully independent.**

**`notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`.** $\delta_\lhd,\delta_\rhd$ are D0018 §C's
$\operatorname{cofib}(\operatorname{hocolim}_{J_X}\mathfrak M_i\to X)$ and
$\operatorname{fib}(X\to\operatorname{holim}_{J_X}\mathfrak M_i)$; the identification with the
density comonad and codensity monad and the three-object separation witness use no coend of
§B's kind, and the one coend in its neighbourhood (co-Yoneda) is of the **well-typed** family
of §2's table. Its only mention of a boundary is line 284, "$\partial\mathfrak r_\omega=0$:
untouched". **Fully independent.**

**`notes/FOUR_REPAIR_MODES.md` — and this one needs saying out loud.** The note is full of
$\partial$: $B^1=\{\partial R:\gamma\mapsto R|\gamma-R\}$, $\partial R=-D$,
$\operatorname{Code}(\widehat X/X)=\partial(\widehat f-f)$, $D=-\partial g^*$. **This is the
group-cohomology coboundary $\partial:V\to Z^1(\Gamma,V)$, a different operator wearing the
same glyph.** It is defined in the note itself, at its §1, with no reference to D0016 §B, and
Theorems 1–6 are statements about $H^1(\Gamma,V)$. A reader auditing the blast radius by
grepping for `\partial` would wrongly count this note as the most affected in the corpus; it
is the least. **Fully independent, and the equivocation is flagged so the next pass does not
have to rediscover it.**

**`notes/ADVANCE_CONJUNCTS_DEFINED.md` — all of its theorems.** Lemma 0, Lemma 1's identity,
Definitions 1, 2, 3a, 5, Propositions 1–4, **Theorem U**, **Theorem K** with Corollaries
K.1–K.3, and **Theorem D**. Every one is a statement about $\sim_{\mathcal T}$, $\sim_{S}$,
$\iota$, $\Pi$ and $\mathfrak h_\sigma$.

**On Theorem U specifically, since the mandate asks and since the mandate's framing of it is
not quite the note's.** The mandate says "its Theorem U is about $\partial$-differences". It is
not. Theorem U reads: *let $U$ depend on the step only through
$(\sim_{\mathcal T_\alpha},\iota,\sim_{\mathcal T_{\alpha+1}})$; then $U$ is constant on steps
whose ends satisfy $\operatorname{SearchSep}$ with $\iota=\mathrm{id}$.* Its proof is two
lines and substitutes $\Delta_X$ for both relations. $\partial$ appears in that note only at
**§6.1**, where §H's gloss is cited as evidence for the *type* of $\operatorname{UsefulEscape}$
(binary on a step), and at **§6.3(b)/§6.4(ii)**, where reading $\partial$ is considered as an
*evasion* of Theorem U and reported unavailable. **Theorem U survives entirely, and the
present note strengthens it**: evasion (b) is not merely unavailable for want of an
enrichment, it is unavailable because the object it would read is not defined.
(Standing check (a): I checked the mandate's characterisation against the text and it is the
text that governs.)

### 4.2 Inherits the defect

- **D0016 §H clauses 5 and 6** (*trapped-light*, *productive-reflection*). Already PROGRAMME
  (`UNTOUCHED_REGIONS_ADJUDICATED.md` §§5–6) for want of $\Delta$ and
  $\partial_{\mathrm{future}}$. The present note upgrades the *reason*: the base symbol
  $\partial$ has no well-formed definition either, so the completion problem is one level
  deeper than recorded. Verdict unchanged; ground deepened.
- **D0016 §I's $\partial X\ne0\Rightarrow\Gamma\langle\partial X\rangle$ and
  $\partial X\ne0\Rightarrow$ मा निरोधः.** Already PROGRAMME/not-truth-apt
  (`UNTOUCHED_REGIONS_ADJUDICATED.md` §12); now additionally without a defined antecedent.
- **`ADVANCE_CONJUNCTS_DEFINED.md` §6.3(b) and §6.4(ii).** Conclusions **survive and are
  strengthened**; their stated grounds are replaced by §3.3 above. §6.4(ii)'s "the enrichment
  making $\partial$ a coend" should read "**the identification $\mathcal F\simeq\mathcal T^{op}$
  and the enrichment**", per §2's last paragraph — the enrichment alone does not suffice.
- **`ADVANCE_UNDER_REPLACEMENT.md` §3.4** types $\operatorname{UsefulEscape}$ as "a difference
  of boundaries across a step, $\partial\Diamond$ being $\int^{(f,t)}e(f,t)$ — a function of
  the Chu datum, not of $\delta$". **The typing survives every candidate repair** (§3.1, §3.3
  both make $\partial\Diamond$ a function of the Chu datum alone); the appeal to §B's display
  as a *definition* does not.

### 4.3 Would need restating — one item, and it survives the restatement

**`UNTOUCHED_REGIONS_ADJUDICATED.md` §7, the REFUTED dichotomy.** Its truth table has
$\Delta\partial_{\mathrm{future}}$ as a column. If $\partial$ does not denote, the column has
no values and one cannot refute a dichotomy between two undefined predicates: as stated,
categorically, the refutation is **vacuous**. It must be restated as a conditional:

> **Restatement.** *Under any completion of $\partial$ and $\Delta$ making
> $\Delta\partial_{\mathrm{future}}$ a two-valued function of the Chu datum, §H clauses 5 and 6
> are not a dichotomy: the cell $(\Delta\partial\ne0,\operatorname{Verify}=0)$ is unnamed and
> cannot be excluded, because $\operatorname{Verify}$ is a function of $\Pi$ and
> $\Delta\partial$ is a function of the Chu datum, and $\Pi$ is not part of the Chu datum.*

**And the restatement is robust**: readings §3.1, §3.2 and §3.3 all make $\partial\Diamond$ a
function of $(\mathcal F,\mathcal T,e)$ alone and none of them touches $\Pi$, so the
disjointness that carries the argument holds under all three. So §7's finding needs its
quantifier moved and loses nothing else. It is the **only** result in the corpus I found that
requires any restatement at all — and, per Corollary 3.1, under the colimit reading the pair
fails even harder, being constant rather than merely non-exhaustive.

### 4.4 The partition, and the sentence that explains it

| | count | items |
|---|---|---|
| **independent of $\partial$** | 5 notes, all theorems | SHRINKING (Thms 1–5, E1–E2′), CHANGING (Thms A–F), GENERABILITY (identification + separation), FOUR_REPAIR_MODES (Thms 1–6; different $\partial$), ADVANCE_CONJUNCTS (Lem 0–1, Defs 1–5, Props 1–4, Thms U, K, D) |
| **inherits the defect** | 4 items, all already PROGRAMME or already negative | D0016 §H cl. 5–6; §I's two $\partial X\ne0$ displays; ADVANCE_CONJUNCTS §6.3(b)/§6.4(ii) *(strengthened)*; ADVANCE_UNDER_REPLACEMENT §3.4's citation *(typing survives)* |
| **needs restating** | 1 | UNTOUCHED_REGIONS §7, categorical → conditional; survives under all three readings |

> **The containment sentence.** *The fleet's theorems are untouched because the fleet, without
> ever declaring it, worked from D0016 §F and never from §B.* Every theorem in the five notes
> is stated in the Chu core — points, tests, $e$, $\sim_S$, holonomy — and $\partial$ enters
> the corpus only where a note is *reporting that something is unavailable*. The defect is
> real, it is at the base of the displayed edifice, and the edifice the fleet actually built
> does not rest on that base.

I offer this as a description of these five notes and the four transmissions' §§B/E/H/I, and
of nothing else; §5.4 says what would refute it.

---

## 5. The minimal repair, priced

### 5.1 Recommended: **P1**, the $\vee$-diagonal (§3.1)

Replace §B's first display by
$\partial\Diamond_\alpha:=\int^{t\in\mathcal T_\alpha}e_\alpha(\vee t,t)$, under
(i) $\vee:\mathcal T_\alpha^{op}\simeq\mathcal F_\alpha$, (ii) $e_\alpha$ functorial in each
variable, (iii) $Q_\alpha$ cocomplete.

**Cost.** One rewritten index, one hypothesis on $\vee$ that §E half-supplies, one type for
$Q_\alpha$ that §A omits entirely.
**Preserves.** $\partial$ as a genuine coend with a non-degenerate value; the intended reading
of §B (assemble the matrix modulo the morphisms); the well-typedness of $\mathfrak F$'s first
factor, hence of $\mathfrak F=\ulcorner-\urcorner\circ\vee\circ\Phi\circ\Gamma\circ\delta\circ\partial$
and of D0018 §D's $\mathfrak F=\Phi\circ\Gamma\circ\partial$; the possibility that
$\Delta\partial_{\mathrm{future}}$ carries information, hence the possibility of completing
§H clauses 5–6.
**Breaks.** Nothing downstream — by §4, nothing downstream uses $\partial$.

**What I explicitly do *not* claim, because overselling this is the obvious temptation.** P1
does **not** define $\operatorname{UsefulEscape}$. Theorem U is untouched by it (Theorem U is
about $\sim$-expressible measures and P1 changes no $\sim$). What P1 does is **reopen** evasion
(b) of `ADVANCE_CONJUNCTS_DEFINED.md` §6.3, not complete it. Whether $\Delta\partial$ under P1
is non-vacuous on Advancing runs is **open**, and there is a live reason for pessimism: on a
stage with $\operatorname{SearchSep}$, that note's Lemma 1 shows the defect degenerates to the
holonomy support, and the analogous computation for the trace of $e_\alpha$ has not been done
here and is not done by P1. P1 buys well-formedness. It does not buy content, and it does not
touch the ordinal ladder, $\kappa$, smallness, or whether $\Gamma$ is defined on
$\mathcal O_\alpha$ — all still PROGRAMME (ledger §1.13).

**And it is a decision, not a theorem.** Whether $\vee$ is an equivalence
$\mathcal T^{op}\simeq\mathcal F$ is the owner's to say. If it is not, P1 is unavailable and
the honest position is P3.

### 5.2 **P2**, "coend over one variable only" — not an independent option

Tested as the mandate asks. It is unavailable as stated: **neither** variable occurs twice, so
there is no single variable to integrate over. To make one occur twice you must identify
$\mathcal F$ with $\mathcal T^{op}$ — which *is* P1. So P2 is not a weaker alternative to P1;
it is P1 with its hypothesis suppressed. Recorded so it is not proposed again.

### 5.3 **P3**, plain colimit, accepting degeneracy

**Cost.** By Proposition 2, on the literal §F reading ($Q$ a bare set) $\partial\Diamond$ is
**undefined** except on constant $e$; by Proposition 3, on the poset reading it is the join of
all entries, and by Corollary 3.1 $\Delta\partial$ is then identically $0$ between non-zero
spaces.
**Preserves.** Well-formedness, and only in the poset case.
**Breaks.** §H clauses 5–6 (constant, hence not criteria); §I's $\partial X\ne0$ displays
(antecedent almost always true or always false); the ladder
$\partial\Gamma\langle\delta^{(n)}\rangle=\delta^{(n+1)}$, since $\delta^{(n+1)}$ would be a
single join-value rather than a defect family, contradicting §B's own vector-valued $\delta$.
**Verdict.** Reject as a repair; **record** as the reading under which §B is literally true and
carries no information, since a reader who declines P1's hypothesis lands here and should know
what it costs.

### 5.4 **P4**, profunctor typing alone

Rejected as a repair of $\partial$ (§3.2: it gives $\partial$ no value and makes it the
identity on the Chu datum, so $\mathfrak F$ loses a factor). **Adopted as the correct type of
$e_\alpha$**, which P1 requires in any case.

---

## 6. Scope limits

1. **The refutation in §2 is syntactic and complete; nothing else here is that secure.**
   Proposition 1 needs no hypothesis about $\mathcal F,\mathcal T,Q$ and is checkable in one
   line by anyone.
2. **§3.1 is a *reading*, not a reconstruction of intent.** I do not claim the owner meant the
   $\vee$-diagonal. I claim it is the only reading in which $\partial$ has content, and that
   the material it needs is in §E.
3. **Propositions 2 and 3 assume $\mathcal F_\alpha,\mathcal T_\alpha$ discrete** — the "bare
   Chu space" of §F. If they carry morphisms, the colimit is the set of entries modulo the
   equivalence the morphisms generate, which is a real object; the transmission nowhere says
   they carry morphisms, and §F's definition supplies none.
4. **The containment analysis covers the five notes named in the mandate plus
   `ADVANCE_UNDER_REPLACEMENT.md` §3 and the ledger entries they cite.** It is not a
   repository-wide audit. A note I did not read may use $\partial$; what I claim is that these
   five do not, and I traced every occurrence in each.
5. **§4.4's containment sentence is my generalisation and is offered for audit**, per standing
   check (f). It is a claim about five notes. It would be refuted by a single fleet theorem
   whose statement requires §B's $\partial$ — and the natural place to look is anything built
   on the ordinal ladder, which nobody has built on.
6. **I did not adjudicate $\mathcal O_\alpha=\int^{\sigma\in N(\mathcal F_\alpha)}\delta_\sigma$
   beyond §2's table.** It fails the same occurrence test; whether it has its own saving
   reading (the nerve suggests a simplicial-object reading rather than a coend) is not worked
   here and is a separate item.
7. **D0018 §J5's $\chi_\alpha$ and D0019 §C's $\rho(D\mathcal K)$ were not touched**, per
   mandate. Nothing above measures, fits, or rehabilitates any quantity.
8. **Nothing is machine-checked.** No Agda or Lean authored, no Python written or run, no PDF
   decoded, no external text opened. Mac Lane CWM ch. IX §§5–6 is used from the standard
   statement of the coend coequalizer, written out in §1.

---

## 7. What this note licenses

> $\partial$ as displayed in D0016 §B is not a coend, and the reason is arity rather than
> enrichment: each bound variable occurs once. The same test fails $\mathcal O_\alpha$ and
> $\mathbb B$ and passes §I, so this is a habit of notation and not a slip. One reading saves
> it — $\int^{t}e(\vee t,t)$, requiring $\vee$ to be an equivalence
> $\mathcal T^{op}\simeq\mathcal F$ — and it changes the index rather than the reading of the
> integrand. Read instead as a plain colimit, $\partial\Diamond$ is *undefined* on bare Chu
> spaces over a bare value set, and is the join of all matrix entries over a value poset, in
> which case $\Delta\partial\equiv0$ and §H's two clauses are constants. **And essentially
> nothing the fleet proved is affected**, because every theorem in the five notes examined is
> stated in the Chu core §F: four notes are wholly independent, the fifth depends on $\partial$
> only in a paragraph that reports $\partial$ unusable and is strengthened by this, and exactly
> one prior finding — the refutation of §H's dichotomy — needs its quantifier changed and
> survives every candidate repair.

**Not licensed:** any claim that P1 defines $\operatorname{UsefulEscape}$, that it makes
$\Delta\partial$ informative, that it touches Theorem U, or that it advances the ordinal
ladder; any claim about the owner's intent for $\vee$; any claim that the corpus outside these
five notes is $\partial$-free.

---

*Written by seed170, 2026-08-15, from the owner's transmission D0016 §§A, B, E, F, H, I, J4.
Notes read: `notes/UNTOUCHED_REGIONS_ADJUDICATED.md` (in full),
`notes/ADVANCE_CONJUNCTS_DEFINED.md` (in full), `notes/SHRINKING_TESTS_LOWER_CURVATURE.md`,
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md`, `notes/FOUR_REPAIR_MODES.md`,
`notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`, `notes/ADVANCE_UNDER_REPLACEMENT.md` §3,
`collab/messages/0761-seed160-untouched-regions.md`. The ill-typing was first observed by
seed160 in passing, and independently by the `ADVANCE_CONJUNCTS_DEFINED.md` pass at its §6.3(b)
before that; what is new here is the arity diagnosis,
the $\vee$-diagonal reading, Propositions 2–3 correcting both prior computations of the
degeneracy, and the containment partition. No experiment was run.*
