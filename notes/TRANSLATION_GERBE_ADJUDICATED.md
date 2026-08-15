# The translation gerbe, adjudicated

**Source of the question.** The human owner, `collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md`,
**§D** — the translation gerbe $\mathbb G$, the defect
$\delta_{\mathfrak T}=\operatorname{cofib}(\mathfrak T_{jk}\mathfrak T_{ij}\to\mathfrak T_{ik})$,
and the operational rule *"if $A\to B\to C$ and $A\to C$ give different meanings, do not
erase the difference — measure the holonomy."* The owner's own triage §J1 poses the
adjudication question in exactly the sharp form used here: *whether $\mathbb G$ is genuinely
a gerbe (a stack, locally non-empty and locally connected) or only a 2-cocycle condition is
checkable and is not established by the notation.* The framework, the notation and the
operational rule are the owner's. What follows is proof, refutation, naming, and an
empirical test of the rule against this repository's own record. Nothing below amends the
artifact; §J9's guard (no relabelling of corpus results in this vocabulary) is in force.

**Substrate.** Reading, pen, `WebFetch`. No Python written, modified or executed; no
`MATH_ALLOW_PYTHON`. No Agda or Lean authored, none typechecked. **No PDF was decoded and
none is claimed.** Every citation below is either nLab HTML read in this session, or a
statement named without a theorem number.

Seed 161, 2026-08-15.

---

## 0. Verdict, stated first

| claim | status |
|---|---|
| $\mathbb G$ is a gerbe | **Not established, and not statable as posed** (§2). No site, no topology, no descent condition, no band. "Locally non-empty" and "locally connected" have no referent. |
| $\mathbb G$ is a bundle gerbe with a class in $H^3$ | **Refuted as a reading** (§2.4). §D's data sits on triple overlaps with no coefficient object and no quadruple-overlap associativity; its natural degree is 2, not 3. |
| The data as given is a normalised **pseudofunctor** (equivalently: a nonabelian Čech 2-cocycle on the codiscrete cover; equivalently, via Grothendieck, a fibred category) | **Yes, and this is the correct name** (§3), *provided* the comparison 2-cells are invertible and the tetrahedron is imposed. |
| $\mathfrak T_{jk}\mathfrak T_{ij}\simeq\mathfrak T_{ik}$ **and** $\delta_{\mathfrak T}\ne0$ | **Inconsistent as displayed** (Prop. 4.1): under §D's own line 1, $\delta_{\mathfrak T}=0$ identically, so line 2's hypothesis is vacuous. The repair is D0018 §B's $\Gamma_\Uparrow$: downgrade $\simeq$ to a chosen, not-necessarily-invertible 2-cell. |
| $\operatorname{cofib}$ is the right operation | **Yes, and it is a genuine improvement on D0017 §C's minus sign** (§4.2) — it needs pointedness + pushouts on 2-cells, not additivity. The ambient must be a bicategory enriched in pointed categories with pushouts. |
| The tetrahedron condition on $\delta_{ijk}$ is stated | **No — dropped.** D0017 §E stated it; D0019 §D does not, and it is not implied. The "$\dots$" in the tuple $\mathbb G$ is load-bearing (§5). Without it there is no cocycle, no class, no well-defined holonomy. |
| $\operatorname{Hol}_{\mathbb G}(\gamma)$ is a measurable quantity | **No.** It is a well-posed *predicate* ("not equivalent to the identity"), not a number (§6). Any number attached to it here would be fitted. |
| Operational rule: route-differences are holonomy, not error | **Not refuted, but its yield is low and its correct form is weaker** (§7–§8). Of four route-differences examined by reading, **three were plain errors, correctly erased**; two carried genuine holonomy — and in the sharpest case the holonomy was *not in the disagreement* but in the **kernel of the comparison map**, obtainable only after the error was erased. |

---

## 1. Hypotheses, and what the symbols are taken to mean

§D fixes no ambient category, so as in `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md`
§1 every statement below carries its own hypotheses. I read the symbols in the only ways
that make them denote.

- $I$ is a set of indices; $\mathfrak L_i$ ("vocabularies", "languages") are objects of some
  ambient $\mathcal B$.
- $\mathfrak T_{ij}:\mathfrak L_i\to\mathfrak L_j$ are 1-cells of $\mathcal B$.
- $\mathfrak T_{jk}\circ\mathfrak T_{ij}\simeq\mathfrak T_{ik}$: a comparison 2-cell
  $\alpha_{ijk}:\mathfrak T_{jk}\mathfrak T_{ij}\Rightarrow\mathfrak T_{ik}$. Whether it is
  invertible is the whole question of §4.
- $\operatorname{cofib}$: the pushout of a morphism along the map to a terminal/zero object.
  nLab, *cofiber* (read as HTML, 2026-08-15): a cofibre is defined "for a morphism
  $f:A\to B$ in a category with a terminal object", as the pushout of $f$ with the terminal
  morphism; in an additive category it is the cokernel. So $\operatorname{cofib}(\alpha_{ijk})$
  requires the **hom-category** $\mathcal B(\mathfrak L_i,\mathfrak L_k)$ to be pointed and
  to have pushouts.

**(H1)** $\mathcal B$ is a bicategory **enriched in pointed categories with finite pushouts**.
Every statement mentioning $\operatorname{cofib}$ assumes (H1); no statement not mentioning
it does.

**(H2)** Where I speak of a gerbe I use Giraud's definition as recorded by nLab, *gerbe*
(read as HTML, 2026-08-15): a gerbe is **a stack which is locally non-empty and locally
connected**; equivalently, in an $(\infty,1)$-topos, an object that is 1-truncated and
1-connective — it maps to the terminal object by an effective epimorphism and its 0th
categorical homotopy group is terminal. $G$-gerbes are classified by **first
$\mathbf{AUT}(G)$-nonabelian cohomology**, and each carries a **band** in outer-automorphism
cohomology.

**(H3)** Where I speak of a bundle gerbe I use Murray's definition as recorded by nLab,
*bundle gerbe* (read as HTML, 2026-08-15): a surjective submersion $\pi:Y\to X$, a principal
$U(1)$-bundle $L\to Y\times_XY$, a multiplication
$\mu:\pi_{12}^*L\otimes\pi_{23}^*L\to\pi_{13}^*L$ over the triple fibre product, satisfying
associativity over the **quadruple** fibre product; the resulting cocycle takes values in
$H^3(X;\mathbb Z)$ — the Dixmier–Douady class. Murray 1996.

---

## 2. Is $\mathbb G$ a gerbe? — No, and the obstruction is not a missing theorem but a
missing site

### Theorem 2.1 (the gerbe conditions are not false; they are not statable)
Let $\mathbb G=(\{\mathfrak L_i\},\{\mathfrak T_{ij}\},\{\delta_{ijk}\},\{\Gamma\delta_{ijk}\},\dots)$
be the data of D0019 §D and nothing more. Then neither "locally non-empty" nor "locally
connected" is a proposition about $\mathbb G$.

*Proof.* Both predicates quantify over a covering family in a Grothendieck topology on a
site $\mathcal S$, and both are predicates of a *fibred category* $\mathcal F\to\mathcal S$.
§D supplies: a set $I$; for each $i$ an object $\mathfrak L_i$; for each ordered pair a 1-cell;
for each ordered triple a defect. It supplies no base object $X$ of which the $\mathfrak L_i$
are local pieces, no map $\coprod_i U_i\to X$, no pullback along which to restrict, and hence
no notion of "cover". A predicate whose quantifier has empty vocabulary is not a false
statement; it is not a statement. $\square$

**Remark 2.1.1.** This is not pedantry about rigour; it is the difference between the two
things §J1 asks us to distinguish. A gerbe is a *stack*: a global object whose local
sections are compared. A 2-cocycle is *the comparison data alone*. §D has the second and
calls it the first. The transmission's own §J9 says an unexamined translation with
$\delta_{\mathfrak T}\ne0$ is a defect rather than a restatement; the same standard applied
to §D's own word "gerbe" is what this note is.

### Theorem 2.2 (exactly what would have to be added)
The following list is necessary and, taken together, sufficient to upgrade $\mathbb G$ to a
gerbe in the sense of (H2). Each item is missing from §D.

1. **A site.** A category $\mathcal S$ of "contexts" with a Grothendieck topology, and a
   covering family $\{U_i\to X\}_{i\in I}$ indexed by $I$. Without this, item 2 has no
   domain. *(Candidate in this corpus: none. The index set of vocabularies has no proposed
   topology, and the natural one — the codiscrete/chaotic one, where every family covers —
   makes items 3 and 4 trivially true and hence content-free; see Cor. 3.3.)*
2. **A fibred category** $\mathcal F\to\mathcal S$ with $\mathcal F_{U_i}\ni\mathfrak L_i$,
   with $\mathfrak T_{ij}$ realised as comparison over $U_i\times_XU_j$ — i.e. the
   $\mathfrak T_{ij}$ must be **transition data over overlaps**, not arbitrary morphisms
   between global objects. §D's $\mathfrak T_{ij}:\mathfrak L_i\to\mathfrak L_j$ has the
   wrong shape: it is a morphism between the fibres, not an object of a fibre over an overlap.
3. **The stack condition (2-descent).** Descent data glue, uniquely up to coherent iso.
   This is the condition that is *never* automatic and that §D never mentions.
4. **Local non-emptiness and local connectedness.** After 1–3: every $U$ has a cover on
   which $\mathcal F$ has a section, and any two sections are locally isomorphic.
5. **A band.** The sheaf $U\mapsto\operatorname{Aut}(\mathfrak L|_U)$ together with the
   descent datum identifying these up to inner automorphism. The band is what makes the
   classifying $H^2$ exist; without it "the class of the gerbe" has no coefficients.

*Proof of necessity.* Each is part of (H2)'s definition or of the classification statement
in (H2). Sufficiency is the definition itself. $\square$

### Corollary 2.3 (what $\mathbb G$ is *not* missing)
None of items 1–5 is an analytic difficulty. They are all *choices of data*. So the correct
disposition of "is $\mathbb G$ a gerbe?" is **not** "unproved conjecture" but **"under-specified
definition"** — the same disposition `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §7
gave D0017's ordinal ladder, and the same one §J5 gives $\rho(D\mathcal K)$.

### 2.4 The degree is wrong for a bundle gerbe, and the word does not choose

D0019 §D's phrase "the knowledge gerbe" is compatible with two classical objects of
*different cohomological degree*, and the notation selects neither:

- A **Giraud gerbe** (H2) is classified in degree 2 — $H^2$ with coefficients in a band,
  i.e. $H^1$ of the automorphism 2-group.
- A **bundle gerbe** (H3) carries the Dixmier–Douady class in $H^3(X;\mathbb Z)$; its
  defining data is a *bundle* $L$ on the double overlap, a multiplication $\mu$ on the
  triple overlap, and associativity on the **quadruple** overlap.

**Proposition 2.4.** §D's data has the index-degree of a Giraud/nonabelian 2-cocycle, not of
a bundle gerbe.

*Proof.* Match indices. In (H3), the coefficient object $L$ lives on **double** overlaps and
the coherence $\mu$ on **triple** ones. In §D the 1-cells $\mathfrak T_{ij}$ live on doubles
and the comparison $\delta_{ijk}$ on triples — so far parallel. But (H3) additionally
requires the associativity of $\mu$ on quadruples, and it requires $L$ to be a *principal
$U(1)$-bundle*, i.e. a coefficient object with an abelian structure group, which is what
produces the integral degree-3 class. §D has neither: no quadruple condition (§5), and the
$\mathfrak T_{ij}$ are arbitrary 1-cells with no structure group. Hence the $H^3$ reading is
unavailable. What survives is the degree-2 reading, where $\{\delta_{ijk}\}$ is a
(nonabelian, and in §D's own display *non-invertible*) 2-cochain. $\square$

**This is the sharp form of "boxing the word does not supply the descent data":** the box
does not even fix the degree of the class it promises.

---

## 3. What the data *is*: a pseudofunctor, and that is a real structure

Grant §D the repair of §4.1 below in the direction that keeps a classical object: take the
$\alpha_{ijk}$ **invertible** and impose the tetrahedron of §5. Then:

### Theorem 3.1 (correct naming)
Let $\mathbf I$ be the codiscrete (chaotic) groupoid on $I$: one object per $i$, exactly one
arrow $i\to j$ for each pair. The data
$\bigl(\{\mathfrak L_i\},\{\mathfrak T_{ij}\},\{\alpha_{ijk}\}\bigr)$ with $\alpha_{ijk}$
invertible, satisfying the tetrahedron and the normalisation $\mathfrak T_{ii}=\operatorname{id}$,
is **precisely a normalised pseudofunctor (weak 2-functor) $\mathbf I\to\mathcal B$**.

*Proof.* nLab, *pseudofunctor* (HTML, 2026-08-15): a pseudofunctor $P:\mathcal C\to\mathcal D$
of bicategories consists of an object map; hom-functors; an invertible **unitor** 2-cell per
object; an invertible **compositor** natural isomorphism per composable pair; subject to
associativity and unit coherence. Match: object map $i\mapsto\mathfrak L_i$; hom-functors
determined on the unique arrows by $\mathfrak T_{ij}$; unitor supplied by normalisation;
**compositor $=\alpha_{ijk}$**; associativity coherence $=$ the tetrahedron. Conversely a
normalised pseudofunctor out of $\mathbf I$ restricts to exactly this data. $\square$

### Corollary 3.2 (three equivalent classical names for the same thing)
Under the hypotheses of Thm 3.1, $\mathbb G$ is equivalently:
1. a normalised pseudofunctor $\mathbf I\to\mathcal B$;
2. a **nonabelian Čech 2-cocycle** on the codiscrete cover indexed by $I$ — the
   $\mathfrak T_{ij}$ are the transition 1-cells, the $\alpha_{ijk}$ the 2-cocycle,
   the tetrahedron the cocycle identity;
3. via the **Grothendieck construction**, a category (2-category) fibred over $\mathbf I$,
   with $\alpha$ the cleavage's failure to be a splitting.

**So: §D's associator is the compositor of a pseudofunctor.** That is the answer to the
mandate's question, and it is worth more than the word "gerbe", because it is *true*, it is
*standard*, and it comes with the coherence theorem the transmission needs and does not state.

### Corollary 3.3 (why the codiscrete index makes the gerbe conditions vacuous)
On $\mathbf I$ every object is connected to every other by a 1-cell, so "locally connected"
holds trivially, and each $\mathfrak L_i$ is a section, so "locally non-empty" holds
trivially. Hence on the only topology $\mathbb G$ currently carries, the two gerbe axioms
are **true and empty**. A reading on which the words hold is available; it is the reading on
which they say nothing. This is the precise sense in which granting the word costs the
structure.

**Prior art named, as required before write-up.** Giraud, *Cohomologie non abélienne*
(Grundlehren 179, 1971) — the definition of gerbe and of the band; Breen, *On the
classification of 2-gerbes and 2-stacks* (Astérisque 225, 1994) — the nonabelian 2-cocycle
description and the tetrahedron; Murray, *Bundle gerbes* (1996) — the $H^3$/Dixmier–Douady
presentation; Grothendieck, SGA1 Exp. VI — fibred categories, cleavage, the construction
bearing his name; Bénabou 1967 — bicategories and lax functors. **None of these was read as
a PDF and none is quoted by theorem number**; the definitions above are quoted from the nLab
HTML pages named in (H2), (H3) and Thm 3.1, which did decode.

---

## 4. The coherence claim: refuted as displayed, and repaired

### Proposition 4.1 (the two displayed lines of §D are inconsistent)
Assume (H1). If $\mathfrak T_{jk}\circ\mathfrak T_{ij}\simeq\mathfrak T_{ik}$ is read as
§D's line 1 asserts — the comparison 2-cell $\alpha_{ijk}$ is an **equivalence** in the
hom-category — then
$$\delta_{\mathfrak T}=\operatorname{cofib}(\alpha_{ijk})\;=\;0\quad\text{for every }i,j,k.$$
Hence §D's line 2, *"$\delta_{\mathfrak T}\ne0\Rightarrow$ translation is itself a
knowledge-defect"*, has an antecedent that the previous line has just made false, and the
implication is vacuous.

*Proof.* In a pointed category with pushouts, the cofibre of an isomorphism $f:A\to B$ is the
pushout of $A\to B$ along $A\to 0$, which is $0$ (pushout of an iso along anything is the
pushout of the identity, i.e. the other corner: $0\sqcup_A B\cong 0$ since $A\cong B$). Same
argument in the homotopy-coherent setting for an equivalence, the cofibre being invariant
under equivalence of arrows. $\square$

**Corollary 4.1.1 (the forced repair, and it is the owner's own $\Gamma_\Uparrow$).** For §D
to have content, $\simeq$ in line 1 must be weakened to *"there is a chosen comparison 2-cell
$\alpha_{ijk}$, not assumed invertible"*. This is exactly D0018 §B's mode $\Gamma_\Uparrow$ —
"replace a failed equation by a chosen 2-cell" — as made precise in `notes/FOUR_REPAIR_MODES.md`
§1.2, together with its stated cost: *every composite that previously commuted on the nose
now needs a filler, and those fillers need fillers.* §5 is that cost, unpaid.

**Corollary 4.1.2.** With $\alpha_{ijk}$ non-invertible, Thm 3.1 no longer applies verbatim:
one has a **lax** 2-functor $\mathbf I\to\mathcal B$, not a pseudofunctor. So the transmission
must choose: *invertible* comparisons (pseudofunctor, classical, but $\delta_{\mathfrak T}\equiv0$
and §D is empty) or *non-invertible* ones (lax functor, $\delta_{\mathfrak T}$ meaningful, but
no gerbe, no class, and coherence unresolved). **It cannot have both, and the display asks for
both.** This is the same failure shape as D0017 §F's silent upgrade of $\Rightarrow$ to
$\leftrightarrow$ (standing check (e)), running in the opposite direction: here an inequality
of strength is created by asserting an equivalence one line before measuring its failure.

### 4.2 Is $\operatorname{cofib}$ the right operation? — Yes, and it is a real advance

D0017 §C wrote $\delta_\Diamond=(h\circ f)-(k\circ g)$, and
`notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §1 records the cost: the minus sign forces
$\hom(x,w)$ to be an abelian group, i.e. **enrichment in $\mathbf{Ab}$**, which a general
bicategory does not have. D0019 replaces the minus by $\operatorname{cofib}$.

**Proposition 4.2.** $\operatorname{cofib}$ strictly weakens the ambient requirement, and
recovers the minus sign in the stable case.
1. $\operatorname{cofib}$ needs only (H1): hom-categories pointed with pushouts. Additivity
   is not required; no subtraction, no negatives, no inverses.
2. If the hom-categories are additive, $\operatorname{cofib}=\operatorname{coker}$ (nLab,
   *cofiber*), so $\operatorname{cofib}(\alpha)$ recovers "$\alpha$ up to the image", which
   in a stable setting is the difference $\mathfrak T_{ik}-\mathfrak T_{jk}\mathfrak T_{ij}$
   up to the shift $[1]$.
3. Hence the D0017 display is the additive special case of the D0019 display.

*Proof.* (1) is the quoted definition; (2) is the quoted additive special case together with
the standard identification of the cofibre sequence in a stable setting; (3) is (2). $\square$

**Verdict on the mandate's question:** $\operatorname{cofib}$ **is** the right operation, and
the correct ambient is not "a general bicategory" but a bicategory enriched in pointed
categories with pushouts — canonically, an $(\infty,2)$-category with stable hom-$\infty$-categories.
D0019 §D is, on this one point, a genuine improvement over D0017 §E, and the improvement
should be credited: the fleet's earlier objection to the minus sign is **answered** by the
new display, not merely restated in it.

---

## 5. The tetrahedron: not stated, not implied, and load-bearing

D0017 §E did state a quadruple-overlap condition:
$$\delta\alpha_{ijkl}=\alpha_{ikl}\circ(\alpha_{ijk}\star1)-\alpha_{ijl}\circ(1\star\alpha_{jkl}).$$
**D0019 §D contains no quadruple index anywhere.** The only trace is the ellipsis in
$\mathbb G=(\{\mathfrak L_i\},\{\mathfrak T_{ij}\},\{\delta_{ijk}\},\{\Gamma\delta_{ijk}\},\dots)$.

### Proposition 5.1 (the ellipsis is load-bearing)
Without a quadruple-overlap condition on $\{\alpha_{ijk}\}$:
1. There is no **cocycle**, hence no cohomology class, hence nothing for $\mathbb G$ to be
   classified by, in any degree.
2. There is no **coherence**, hence no Grothendieck construction (Thm 3.1's hypothesis fails)
   and no well-defined composite of three or more translations up to canonical isomorphism.
3. Consequently $\operatorname{Hol}_{\mathbb G}(\gamma)$ depends on the *bracketing* of
   $\gamma$, not only on $\gamma$ — so "the holonomy of a loop" is not a function of the loop.

*Proof.* (1) A cocycle condition is by definition an identity on $(n+1)$-fold overlaps for
$n$-cochains; $\{\alpha_{ijk}\}$ is a 2-cochain, so its condition lives on quadruples, and
none is imposed. (2) Thm 3.1 requires associativity coherence, which is that condition. (3)
For a loop $i\to j\to k\to l\to i$ the two bracketings of the composite are related by
$\alpha$'s applied in two orders; the assertion that these agree *is* the tetrahedron. Absent
it, the two comparisons are two different 2-cells and nothing identifies them. $\square$

### Remark 5.2 (and D0017's version is not usable here either)
D0017's tetrahedron uses a **minus** between two 2-cells, and so re-imports the additivity
requirement that §4.2 has just been credited with removing. The cofibre repair does *not*
apply verbatim: $\alpha_{ikl}\circ(\alpha_{ijk}\star1)$ and $\alpha_{ijl}\circ(1\star\alpha_{jkl})$
are parallel 2-cells, and comparing two parallel 2-cells requires a **3-cell**, not a cofibre —
unless one is again in a setting where hom-categories are stable, in which case
$\operatorname{cofib}$ of the comparison is available and the correct statement is that this
cofibre vanishes. **So the coherent version of §D requires either a tricategory / $(\infty,2)$-
with-stable-homs, or an explicit 3-cell.** Neither is supplied. This is stated as the missing
datum, not as a refutation: nothing here shows the condition is false, only that it is absent.

---

## 6. Holonomy: a predicate, not a number

$\operatorname{Hol}_{\mathbb G}(\gamma)$ for a loop $\gamma=(i_0\to i_1\to\dots\to i_n=i_0)$
is the composite $\mathfrak T_{i_{n-1}i_n}\cdots\mathfrak T_{i_0i_1}$ compared with
$\mathfrak T_{i_0i_0}=\operatorname{id}$, via the chosen $\alpha$'s.

**Proposition 6.1.** Under (H1) and §D's data:
1. "$\operatorname{Hol}_{\mathbb G}(\gamma)\ne1$" is a **well-posed predicate**: the
   composite is or is not equivalent to the identity 1-cell.
2. It is **not a group element**, and has no numerical value. It is an object of a
   hom-category, determined only up to non-canonical isomorphism and (by Prop. 5.1(3))
   only up to bracketing.
3. Therefore *"measure the holonomy"* does not denote a measurement. It denotes:
   **exhibit the cofibre and name it.**

*Proof.* (1) is the definition of equivalence. (2): a group of holonomies requires the
automorphisms of the fibre to be identified along the loop by a *chosen trivialisation*
(the band, item 5 of Thm 2.2) and requires abelian coefficients for the value to be a number;
neither is present. Cf. `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Thm 1(a): even in
the classical $U(1)$ case, $\operatorname{Hol}$ and $F_\nabla$ are related only by a
one-directional implication with kernel $\pi_1$. (3) follows. $\square$

**This is a feature, not a defect, under `CLAUDE.md`.** A number attached to
$\operatorname{Hol}_{\mathbb G}$ at this stage would be fitted, would have no derived error
term, and would hide its scaling — the `HOLOGRAM.md` §7 failure exactly. The operational rule
is stronger, not weaker, when read as *"name the cofibre"* rather than *"report a number"*.

**On §J5 (one sentence, as instructed).** I do not touch $\rho(D\mathcal K)$; my only bearing
on it is that §D's $\operatorname{Hol}$ fails to be numerical for the *same structural reason*
$\rho(D\mathcal K)$ does — no norm, no linearisation, no basepoint — and I do **not** settle
whether $\rho(D\mathcal K)$ and $\chi_\alpha$ are the same quantity.

---

## 7. The operational rule, tested against this repository's record

The rule: *if $A\to B\to C$ and $A\to C$ give different meanings, do not erase the difference —
measure the holonomy.* This fleet has been running $\mathfrak T_{ij}$ all night. Four
route-differences, each **verified by reading the file**, not by trusting a summary.

### 7.0 A prior check, discharged
The mandate points at `notes/UNTOUCHED_REGIONS_ADJUDICATED.md`. **That file does not exist**
(`ls`, 2026-08-15). Its verdict is therefore neither verified nor relied on here. The
minus-sign finding attributed to it does exist, in
`notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §1 (first bullet), and is used above with
that attribution. Standing check (b) discharged, and it caught a phantom.

### 7.1 Instance A — the two proofs of the shrink theorem. **Mixed: one erasure correct, one difference correctly preserved.**
Read: `collab/messages/0751-seed150-shrink-theorem-reconciliation.md` in full, and
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md` §0.

Route 1 (seed148): strictness as an implication, $\delta^{S'}_\sigma\subsetneq\delta^S_\sigma
\iff\exists x:\emptyset\ne W_\sigma(x)\cap S\subseteq S\setminus S'$.
Route 2 (seed146): strictness as a set equality,
$\delta^S_\sigma\setminus\delta^{S'}_\sigma=\{x:\emptyset\ne D_\sigma(x)\cap S\subseteq S\setminus S'\}$.

**(i) The difference in the theorem was zero.** $W_\sigma=D_\sigma$ verbatim; Prop. 3A.1 of
the referee report shows Route 1 is the existential shadow of Route 2. Erasure correct.
$\delta_{\mathfrak T}=0$ for this translation.

**(ii) A second, genuine difference in the same pair was *not* erased, and should not have
been.** The two agents read D0016 §G's $\operatorname{SearchSep}$ differently — seed148
absolutely (unary: $\mathcal T_\alpha$ separating), seed146 relatively (binary:
$\operatorname{SearchSep}_{\mathcal T}(\mathcal T')$). The referee (§4) established: the
literal reading is the unary one, the binary one is a *generalisation*, **both carry content**
(Prop. 3.4 under one, $\delta$-faithfulness under the other), and the counterexample E1
falsifies the conjunct under both. This is **genuine holonomy**: the difference is information
about the *transmission's underspecification*, and it would have been destroyed by picking one
reading. It was preserved. Classification: **(ii)**.

**(iii) A third difference was destroyed by the file system, not by mathematics.** Commit
`e08c07ab` overwrote seed148's 337-line note wholesale (447 insertions, 329 deletions, no
merge, no conflict markers). Cor. 2.3 and Prop. 3.4 survived only in git history. This is not
mathematical holonomy; it is process failure — and it is the strongest empirical case in this
corpus for the rule's *operational* half. I record it as such and do not inflate it into a
mathematical instance.

**Honest deflation, from the referee's own §5 and adopted here:** two routes agreeing carries
information only in proportion to the chance that an error would have been independent. For a
one-line monotonicity that chance is near zero. So $\delta_{\mathfrak T}=0$ in instance A(i)
is **weak evidence of correctness**, and the transmission's rule says nothing about this case
because there was no difference to preserve.

### 7.2 Instance B — Birkhoff polarity vs. Galois connection. **(i) Plain error, correctly erased.**
Read: `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` §0.4 and §3.

Route 1 (Chu-space/separation vocabulary): "$(\operatorname{Sep},\sim)$ is the standard
Birkhoff polarity."
Route 2 (order theory): a Birkhoff polarity is a pair of **antitone** maps; $\operatorname{Sep}$
is **monotone**; hence it is not one.

Route 2 is right and Route 1 is wrong — flatly, on the definition. **Erasure correct.** Note
what the erasure produced: Theorem B, the monotone Galois connection
$\delta_\sigma\dashv\delta^*_\sigma$, the closure operator
$C_\sigma(S)=\{t:\forall x,\ t\in D_\sigma(x)\Rightarrow D_\sigma(x)\cap S\ne\emptyset\}$, and
Corollaries B.1–B.2. **That productivity is not holonomy.** It is what repairing a false ground
normally does, and calling it holonomy would be exactly the inflation §J9 warns against. This
is also a clean instance of standing check (d): the *verdict* (Theorem 1) was right, the
*ground* was false. Classification: **(i)**.

### 7.3 Instance C — a displayed formula against its own prose. **(i) Plain error, correctly erased.**
Read: `collab/messages/0760-seed159-structural-in-disguise.md` front-matter and §1, against
`notes/FOUR_REPAIR_MODES.md` §2.

Two routes to "seed 152's Cor. 2.2": via the **displayed formula** and via the **prose**. Seed
159's audit found the displayed formula is a *non-implication* and is not what the dependent
theorem uses; the prose (monotonicity of $\operatorname{Obs}$ in the test family) is, and is
true and proved. The display was struck with attribution. Classification: **(i)** — and an
instance of standing check (c) in its purest form, a summary refuted by its own body, running
between two *registers* of one document rather than two agents.

### 7.4 Instance D — $\Rightarrow$ versus $\leftrightarrow$ in D0017. **(i) at the level of the claim; (ii) at the level of the kernels — and this is the best instance in the corpus.**
Read: `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §0, §2, §5, §8.

Route 1 (D0017 §E): $F_\nabla\ne0\Rightarrow\operatorname{Hol}_\nabla(\gamma)\ne1$ — an
implication.
Route 2 (D0017 §F): $F_\nabla\leftrightarrow(\operatorname{Hol}_\nabla(\gamma)-1)$ — a
biconditional.

The difference is a **plain error**: three explicit counterexamples (flat connection on $S^1$
with $\theta_0\notin2\pi\mathbb Z$; the Möbius bundle, torsion; the $\pi_1$-action on $\pi_2$)
refute three of the four arrows as biconditionals. Erasure correct: **(i)**.

**But the erasure left a residue that is exactly what the rule demands.** Corollary 1.1 does
not merely delete the arrows; it names, for each, the **kernel** of the one-directional
comparison map: 2-cell homotopy; the $\pi_1$-action / non-simplicity; **torsion**; $\pi_1(X)$.
That is precisely $\delta_{\mathfrak T}$ for the translations Chu $\to$ homotopy $\to$ Čech
$\to$ curvature $\to$ holonomy — information *about the vocabularies*, not about the claim,
which would have been lost by writing only "§F is false". Classification of the residue:
**(ii), genuine holonomy**, and the corpus's cleanest confirmation that the operational rule
has content.

Note also that Theorem 4 of that note — no restriction-natural bridge between locally-trivial
and locally-stable obstructions — is a *proof that a particular $\mathfrak T$ does not exist*.
That is the fourth possible disposition of a route-difference, alongside error, holonomy, and
agreement, and §D does not list it.

---

## 8. What the empirical test establishes

**Tally (not a sample; see the scope limit).** Four route-differences examined by reading:
three were plain errors correctly erased (B, C, D-as-stated, and A(i) had no difference at
all); two carried genuine holonomy (A(ii), D's kernels); one was destroyed by a silent
overwrite (A(iii)) and recovered only from git.

**The rule is not refuted.** Two genuine instances exist and both were found by agents who
declined to erase.

**But its correct form is weaker than §D's, in a way §D's display hides.** In the sharpest
instance, D, the holonomy was **not in the disagreement**. The disagreement was simply an
error. The holonomy appeared only *after* the error was erased, as the **kernel of the
comparison map** that replaced the false biconditional. So:

> **Amendment (offered, not asserted as the owner's).** The content-bearing object is not the
> difference between two routes; it is $\operatorname{cofib}$ / the kernel of the comparison
> map *once the routes have been made correct*. "Do not erase the difference" is right as
> operational hygiene and wrong as a classification: most observed differences in this corpus
> **were** errors, and erasing them was the precondition for finding the holonomy, not its
> alternative.

This is consistent with §D's own algebra, and is arguably what §D means: $\delta_{\mathfrak T}$
is defined as a cofibre of a *comparison*, not as a *discrepancy between claims*. The
operational gloss is looser than the formula. **The formula is the better half of §D.**

**Standing check (f), self-applied.** The amendment in the box is a generalisation from four
instances chosen by the mandate, not drawn at random, in one repository, over one night. It is
subject to audit and I claim no denominator. A reader who examined a random sample and found
the ratio inverted would refute it, and I have not run that sample.

---

## 9. Scope: what this note does not settle

- **§G's $\Theta_\infty$, $\mathcal Q_\infty$, $\mathbb U$, $\mathfrak F_\Omega$,
  $\mathfrak M_\infty$: untouched, and left as PROGRAMME** exactly as §J7 has them. No
  convergence, no smallness, no ambient category. Nothing above upgrades any of them, and
  §6's negative result about $\operatorname{Hol}$ should not be read as bearing on them.
- **§C's $\rho(D\mathcal K)$: not measured, not rehabilitated, not identified with
  $\chi_\alpha$.** One sentence in §6, as instructed.
- **§B's eight classes: untouched.** §J3's prediction that they collapse is not tested here.
- **Whether a site on the space of vocabularies exists** that makes Thm 2.2 items 1–5
  fillable non-trivially. I show the codiscrete choice is vacuous (Cor. 3.3); I do not show
  no good choice exists, and I suspect the interesting content of §D is exactly there.
- **The tetrahedron's truth**, in either D0017's additive form or a 3-cell form: I show it is
  absent and load-bearing (§5), not that it fails.
- **Giraud 1971, Breen 1994, Murray 1996, Grothendieck SGA1, Bénabou 1967 were not read.**
  They are named as the classical loci. Definitions are quoted from the nLab HTML pages cited
  in (H2), (H3) and Thm 3.1. No theorem number from any of these works appears above, and no
  PDF decoded.
- **The empirical tally is not a random sample** and supports no rate.

---

## 10. Ledger

| Claim | Status | Where |
|---|---|---|
| "Locally non-empty"/"locally connected" are statable of $\mathbb G$ | **Refuted** (no site) | Thm 2.1 |
| Exactly five data would upgrade $\mathbb G$ to a gerbe | **Proved** (necessity + sufficiency by definition) | Thm 2.2 |
| $\mathbb G$'s natural degree is 3 (bundle gerbe / Dixmier–Douady) | **Refuted** | Prop 2.4 |
| $\mathbb G$ (with invertible $\alpha$ + tetrahedron) $=$ normalised pseudofunctor $\mathbf I\to\mathcal B$ | **Proved** | Thm 3.1, Cor 3.2 |
| On the codiscrete index the gerbe axioms hold vacuously | **Proved** | Cor 3.3 |
| §D lines 1 and 2 are jointly consistent | **Refuted**: line 1 forces $\delta_{\mathfrak T}\equiv0$ | Prop 4.1 |
| $\operatorname{cofib}$ is the right operation, and improves on D0017's minus | **Proved** | Prop 4.2 |
| The tetrahedron is stated or implied in §D | **Refuted**: absent, and load-bearing | Prop 5.1 |
| $\operatorname{Hol}_{\mathbb G}$ is a number | **Refuted**: a predicate, valued in a hom-category | Prop 6.1 |
| Operational rule has empirical content in this corpus | **Confirmed, twice** (A(ii), D-kernels) | §7.1, §7.4 |
| Most observed route-differences were holonomy | **Refuted**: three of four were plain errors | §8 |
| Corrected rule: the holonomy is the kernel of the comparison *after* repair | **Offered, audit-subject** | §8 box |

**Overall.** $\mathbb G$ is not a gerbe; it is, at best and after one forced repair, a
**normalised pseudofunctor out of the codiscrete groupoid on the index set of vocabularies** —
equivalently a nonabelian 2-cocycle, equivalently a fibred category via Grothendieck — with
its compositor written $\alpha_{ijk}$ and its failure written $\delta_{\mathfrak T}$. Naming it
so is not a demotion. It supplies the coherence theory, the classification, and the tetrahedron
that the word "gerbe" only gestures at, and it makes the transmission's best idea —
$\operatorname{cofib}$ in place of a minus sign — do the work it is capable of. The operational
rule survives, with its yield measured and its statement amended.
