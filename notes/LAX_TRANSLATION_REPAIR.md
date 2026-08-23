# The lax translation net: performing the repair, and pricing it

**Source.** The human owner, `collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md`
**§D** (the translation gerbe $\mathbb G$, $\delta_{\mathfrak T}=\operatorname{cofib}$, the
operational rule) and triage **§J1**. The prior adjudication is
`notes/TRANSLATION_GERBE_ADJUDICATED.md` (seed 161) and its message
`collab/messages/0762-seed161-translation-gerbe.md`. **All three were read in full at the lines
used**, and the quotations below were checked against the files, not against summaries.
Nothing here amends the owner artifact; §J9's guard is in force.

That pass proved §D inconsistent as displayed (cofibre of an equivalence is $0$), identified the
forced repair as the owner's own $\Gamma_\Uparrow$ — downgrade $\simeq$ to a chosen
non-invertible 2-cell — and **did not perform it**. This note performs it.

**Substrate.** Reading, pen, one web search, three nLab HTML fetches. No Python written,
modified, or executed; no `MATH_ALLOW_PYTHON`. No Agda or Lean authored, none typechecked.
**No PDF was decoded and none is claimed** — in particular Bénabou 1972 (§7) is cited from
search metadata and is *not* read. Every example below is a **finite exhaustive verification**,
which `CLAUDE.md` records as proof. No number in this note was measured or fitted.

Seed 169, 2026-08-15.

---

## 0. Verdict, stated first

| question (mandate) | answer |
|---|---|
| Does the lax repair make $\delta_{\mathfrak T}$ non-vacuous? | **Yes**, and by a finite example (Thm 3.4). But the unit axioms force $\delta_{ijj}=\delta_{iij}=0$ always (Lem 3.3), so non-vacuity lives strictly on *pairwise-distinct* triples. |
| "$\delta_{\mathfrak T}$ non-trivial **exactly when** $\mu$ is not invertible" | **False as stated, and this is the mandate's own hint refuted** (Thm 3.5). One direction holds ($\delta\ne0\Rightarrow\mu$ not invertible). The converse fails: a finite pointed-set example has $\operatorname{cofib}(\mu)=0$, $\ker(\mu)=0$, and $\mu$ not invertible. |
| Was $\operatorname{cofib}$ a free advance over D0017's minus sign? | **No — the prior pass credited it without pricing it** (Thm 3.6). Under $\mathbf{Ab}$-enrichment $\operatorname{cofib}$ is a *complete* invertibility detector; under mere (H1) it is *sound but incomplete*. Generality of ambient and completeness of detection are traded one for one. |
| Is the tetrahedron expressible without a 3-cell? | **Yes, and this corrects the prior pass's Remark 5.2** (§2, (L3)). The lax associativity axiom is an **equation between parallel 2-cells**, available in any bicategory. Only *D0017's minus-sign form* of it needed additivity; the lax form needs nothing. |
| Does a classification survive? | **No cohomological one, and none was there to lose in the pseudo case either** (§6). Two theorems: (a) $\mathbf I\simeq\mathbf 1$, and pseudofunctors are invariant under source equivalence, so the *pseudofunctor* classification is **trivial** — every pseudo net is equivalent to a constant one; (b) lax functors are **not** source-equivalence-invariant, so the lax reading has content, but its comparisons form a **preorder, not an equivalence relation**, and nonabelian $H^\bullet$ needs a *group* of coboundaries. What replaces the class is an **object** (a Grothendieck-type representation), not a class. |
| Does holonomy survive? | **Half.** It survives as a *canonical non-invertible 2-cell* $h_\gamma:\mathfrak T_\gamma\Rightarrow\mathfrak T_{i_0i_0}$, and — a genuine gain — the tetrahedron makes $h_\gamma$ **independent of bracketing** (Thm 5.2), repairing prior Prop 5.1(3). What dies is Hol as a *group element* and as the predicate "$\ne1$": there is no inverse to compare against (Thm 5.4). The owner's rule survives in the amended form, not the displayed one. |
| Is "measure the kernel of $\mu$" the successor rule? | **Not on its own.** $\ker$ and $\operatorname{cofib}$ are the two *dual halves* and detect different failures (Thm 4.2); neither, nor both together, is complete (Thm 3.5). And a discrepancy the prior pass did not notice: §D's formula is a **cofibre**, while the corpus instance that motivated the prior pass's amendment (D0017's named kernels — torsion, $\pi_1(X)$) is a **fibre**. They are not the same invariant (§4.3). |

---

## 1. Hypotheses

**(H1)** $\mathcal B$ is a bicategory whose hom-categories are **pointed** (have a zero object
$0$) and have **finite pushouts**. This is the prior pass's (H1) and is what
$\operatorname{cofib}$ needs (nLab, *cofiber*: the pushout of $f$ along the map to the terminal
object).

**(H1$^\dagger$)** Additionally the hom-categories have **finite pullbacks**, so that
$\ker(f):=0\times_Bf$ exists. Only §4 uses this.

**(H2)** $\mathbf I$ is the **codiscrete groupoid** on the index set $I$: objects $i\in I$,
exactly one arrow $(i\!\to\!j)$ per ordered pair, composition $(j\!\to\!k)(i\!\to\!j)=(i\!\to\!k)$
strictly associative and unital. As a bicategory it has only identity 2-cells.

**Working model (M).** For all examples: $\mathcal B_{\mathrm{Set}_*}$ has object set $I$,
$\mathcal B(i,j)=\mathrm{Set}_*$ (pointed sets and pointed maps), and composition
$\wedge:\mathcal B(j,k)\times\mathcal B(i,j)\to\mathcal B(i,k)$ the smash product, with unit
$S^0=\{*,1\}$. This is a bicategory satisfying (H1) and (H1$^\dagger$): $\mathrm{Set}_*$ is
pointed (zero object $0=\{*\}$) and has all finite limits and colimits. In it,
$$\operatorname{cofib}(f:A\to B)=B/f(A),\qquad \ker(f)=f^{-1}(*),$$
so $\operatorname{cofib}(f)=0\iff f$ is **surjective**, and $\ker(f)=0\iff f^{-1}(*)=\{*\}$ —
which is *weaker* than injectivity. That gap is the engine of Thm 3.5.

---

## 2. The lax version, written out

### Definition 2.1 (lax translation net)
A **lax translation net** on $I$ in $\mathcal B$ consists of:

- **(D1)** for each $i\in I$ an object $\mathfrak L_i\in\mathcal B$;
- **(D2)** for each ordered pair a 1-cell $\mathfrak T_{ij}:\mathfrak L_i\to\mathfrak L_j$;
- **(D3)** for each ordered triple a **compositor** 2-cell
  $$\mu_{ijk}\;:\;\mathfrak T_{jk}\circ\mathfrak T_{ij}\;\Longrightarrow\;\mathfrak T_{ik},$$
  **not assumed invertible**;
- **(D4)** for each $i$ a **unitor** 2-cell
  $\iota_i:\operatorname{id}_{\mathfrak L_i}\Rightarrow\mathfrak T_{ii}$, not assumed invertible.

Subject to:

- **(L3) Associativity coherence — the tetrahedron.** For every quadruple $(i,j,k,l)$, the two
  routes from $\mathfrak T_{kl}\circ(\mathfrak T_{jk}\circ\mathfrak T_{ij})$ to
  $\mathfrak T_{il}$ **agree**:
  $$\mu_{ijl}\circ(\mu_{jkl}\star 1_{\mathfrak T_{ij}})\circ a^{-1}_{\mathfrak T_{kl},\mathfrak T_{jk},\mathfrak T_{ij}}
  \;=\;\mu_{ikl}\circ(1_{\mathfrak T_{kl}}\star\mu_{ijk}),$$
  where $a$ is $\mathcal B$'s associator. *(Left route: compose $jk$ with $kl$ first, then with
  $ij$. Right route: compose $ij$ with $jk$ first, then with $kl$.)*
- **(L4) Unit coherence.** For every ordered pair $(i,j)$,
  $$\mu_{ijj}\circ(\iota_j\star 1_{\mathfrak T_{ij}})=\ell_{\mathfrak T_{ij}},\qquad
  \mu_{iij}\circ(1_{\mathfrak T_{ij}}\star\iota_i)=r_{\mathfrak T_{ij}},$$
  with $\ell,r$ $\mathcal B$'s unitors.

**Normalised** means $\mathfrak T_{ii}=\operatorname{id}_{\mathfrak L_i}$ and
$\iota_i=\operatorname{id}$.

### Theorem 2.2 (this is exactly a lax functor)
Lax translation nets on $I$ in $\mathcal B$ are **precisely lax functors
$\mathfrak T:\mathbf I\to\mathcal B$**; normalised ones are precisely **normal** lax functors.

*Proof.* nLab, *lax functor* (HTML, read 2026-08-15): a lax functor is the definition at
*pseudofunctor* "with the natural isomorphisms merely natural transformations", with structural
cells oriented so that "cells map composites of images to images of composite", and a *normal*
lax functor "preserves identities strictly". nLab, *pseudofunctor* (HTML, read 2026-08-15): an
object map; hom-functors $P_{x,y}$; an identity 2-cell $P_{\mathrm{id}_x}:\operatorname{id}_{Px}
\Rightarrow P(\operatorname{id}_x)$; a composition 2-cell
$P_{f,g}:P(g)\circ P(f)\Rightarrow P(g\circ f)$; subject to associativity and unit coherence.
Match: objects $i\mapsto\mathfrak L_i$; on $\mathbf I$ each hom-category is terminal, so the
hom-functor is the single 1-cell $\mathfrak T_{ij}$ and functoriality is empty; the identity
2-cell is $\iota_i$ (D4); the composition 2-cell at the composable pair
$(i\!\to\!j,\,j\!\to\!k)$ is $\mu_{ijk}$ (D3), which has exactly the nLab orientation since
$(j\!\to\!k)\circ(i\!\to\!j)=(i\!\to\!k)$ in $\mathbf I$; associativity coherence is (L3), unit
coherence is (L4). Naturality of $\mu$ is vacuous ($\mathbf I$ has only identity 2-cells).
Conversely a lax functor restricts to exactly (D1)–(D4), (L3)–(L4). $\square$

### Remark 2.3 (correcting the prior pass's Remark 5.2 — the tetrahedron needs no 3-cell)
`TRANSLATION_GERBE_ADJUDICATED.md` Remark 5.2 observed that D0017 §E's quadruple condition
$$\delta\alpha_{ijkl}=\alpha_{ikl}\circ(\alpha_{ijk}\star1)-\alpha_{ijl}\circ(1\star\alpha_{jkl})$$
uses a **minus** between two *parallel* 2-cells, hence re-imports the $\mathbf{Ab}$-enrichment
that $\operatorname{cofib}$ had just removed, and concluded that "the coherent version of §D
requires either a tricategory / $(\infty,2)$-with-stable-homs, or an explicit 3-cell."

**That conclusion is too strong, and (L3) is the counterexample.** The correct coherence axiom
for a lax functor is an **equation** between the two parallel 2-cells, not a measurement of their
difference. An equation between parallel 2-cells is available in *any* bicategory: no
subtraction, no zero object, no 3-cell, no stability. D0017's form was a *quantified* version of
the axiom (measure how far the two routes differ), and it is that quantification — not the
tetrahedron — that needed additivity.

I record this as a correction and not a refutation of intent: Remark 5.2 was diagnosing D0017's
display, and about that display it is right. Standing check (c) applied to the prior pass's own
summary line, which says "the honest cofibre form needs a 3-cell": the honest form is (L3), and
it needs nothing.

### Corollary 2.4 (what is lost against Thm 3.1 of the prior pass)
With $\mu$ invertible and (L3), Def. 2.1 is a normalised **pseudofunctor** and the prior pass's
Thm 3.1 and Cor 3.2 apply verbatim (nonabelian Čech 2-cocycle; fibred category by Grothendieck).
Dropping invertibility keeps (L3), (L4), Thm 2.2 — and loses, in order, the cocycle groupoid
(§6), the Grothendieck *fibration* (§6.4), and the invertible holonomy (§5). Each loss is
located below.

---

## 3. $\delta_{\mathfrak T}$: non-vacuous, but a sound-and-incomplete detector

Throughout: $\delta_{ijk}:=\operatorname{cofib}(\mu_{ijk})$, computed in the hom-category
$\mathcal B(\mathfrak L_i,\mathfrak L_k)$, under (H1).

### Proposition 3.1 (soundness — one direction of the mandate's claim)
If $\mu_{ijk}$ is invertible then $\delta_{ijk}=0$. Equivalently: $\delta_{ijk}\ne0\Rightarrow
\mu_{ijk}$ is not invertible.

*Proof.* Prior pass Prop 4.1: in a pointed category with pushouts, $\operatorname{cofib}$ of an
isomorphism is the pushout of an iso along $A\to0$, which is $0$. $\square$

### Lemma 3.2 (the model (M) computes $\delta$ as non-factorisability)
In $\mathcal B_{\mathrm{Set}_*}$, a lax translation net is exactly a **category enriched in
$(\mathrm{Set}_*,\wedge,S^0)$ with object set $I$** — i.e. a category with hom-sets
$\mathfrak T_{ij}$, a distinguished zero morphism in each, composition $\mu$ and identities
$\iota$. Then
$$\delta_{ijk}=\mathfrak T_{ik}\big/\operatorname{im}\!\big(\mathfrak T_{jk}\wedge\mathfrak T_{ij}\xrightarrow{\ \mu\ }\mathfrak T_{ik}\big),$$
so **$\delta_{ijk}=0$ iff every translation $i\to k$ factors through $j$**, and $\delta_{ijk}$ is
the pointed set of those that do not.

*Proof.* Definition 2.1 in $\mathcal B_{\mathrm{Set}_*}$ unwinds term by term to the axioms of a
$\mathrm{Set}_*$-enriched category: (L3) is associativity of composition, (L4) is unitality, (D3)
is the composition map, (D4) picks out the identity. The displayed formula is the pushout
computation recorded under (M). $\square$

This is worth stating in the owner's vocabulary: **$\delta_{\mathfrak T}$ measures the meanings
available at $\mathfrak L_k$ from $\mathfrak L_i$ that cannot be reached by routing through
$\mathfrak L_j$.** That is a defect of the *composite route*, not of the direct one.

### Lemma 3.3 (the units force $\delta$ to vanish on degenerate triples)
For any lax translation net, $\delta_{ijj}=0$ and $\delta_{iij}=0$.

*Proof.* (L4) says $\mu_{ijj}\circ(\iota_j\star1)=\ell_{\mathfrak T_{ij}}$, an isomorphism. So
$\mu_{ijj}$ is a split epimorphism, hence its pushout along $\to0$ is $0$: given a split epi
$p$ with $ps=\mathrm{iso}$, the pushout $B\sqcup_A0$ receives $B$ and kills $\operatorname{im}p
\supseteq\operatorname{im}(ps)=B$. Same for $\mu_{iij}$ with $r$. $\square$

**So the non-vacuity question is entirely about pairwise-distinct triples**, and in particular
$|I|\ge3$ is necessary. The prior pass did not isolate this.

### Theorem 3.4 (non-vacuity: the repair works)
There is a lax translation net with $\delta_{ijk}\ne0$.

*Proof (finite exhaustive verification).* Work in (M) with $I=\{1,2,3\}$; by Lem. 3.2 it suffices
to give a $\mathrm{Set}_*$-enriched category on three objects. Take
$$\mathfrak T_{ii}=\{*,\mathrm{id}_i\},\quad \mathfrak T_{13}=\{*,f\},\quad
\mathfrak T_{ij}=\{*\}\ \text{for all other }i\ne j,$$
with composition: identities act as identities; every other composite is $*$. Associativity: any
triple composite either involves an identity (and is fixed by unitality) or has a factor in a
zero hom, hence is $*$ on both bracketings — checked over the finitely many index triples.
Unitality: by construction. So this is a $\mathrm{Set}_*$-enriched category. Now
$$\delta_{123}=\operatorname{cofib}\big(\mathfrak T_{23}\wedge\mathfrak T_{12}\to\mathfrak T_{13}\big)
=\operatorname{cofib}\big(\{*\}\to\{*,f\}\big)=\{*,f\}\ne0.\qquad\square$$

Interpretation: $f$ is a translation $\mathfrak L_1\to\mathfrak L_3$ that does **not** factor
through $\mathfrak L_2$. That is precisely §D's "translation is itself a knowledge-defect", made
into a computable pointed set. **§D's line 2 is no longer vacuous.**

### Theorem 3.5 (the mandate's "exactly when" is false)
$\delta_{ijk}=0$ does **not** imply $\mu_{ijk}$ invertible, under (H1). Nor does the conjunction
$\delta_{ijk}=0$ **and** $\ker\mu_{ijk}=0$ (under (H1$^\dagger$)).

*Proof (finite exhaustive verification).* In (M), $I=\{1,2,3\}$, take the enriched category
$$\mathfrak T_{12}=\{*,g_1,g_2\},\quad \mathfrak T_{23}=\{*,h\},\quad \mathfrak T_{13}=\{*,f\},$$
$hg_1=hg_2=f$, all identity homs $\{*,\mathrm{id}_i\}$, all remaining homs $\{*\}$, all other
composites $*$. Associativity and unitality hold: the only non-degenerate composable strings are
$h\circ g_r$ (length 2) and strings padded with identities; no length-3 string of non-identities
is composable (there is no non-zero hom out of $3$ or into $1$), so both bracketings of every
triple agree. Then
$$\mu_{123}:\ \mathfrak T_{23}\wedge\mathfrak T_{12}=\{*,\,h{\wedge}g_1,\,h{\wedge}g_2\}\longrightarrow\{*,f\}$$
sends both non-basepoint elements $h\wedge g_1,h\wedge g_2$ to $f$. Hence
$\operatorname{im}\mu_{123}=\mathfrak T_{13}$, so $\delta_{123}=0$; and
$\mu_{123}^{-1}(*)=\{*\}$, so $\ker\mu_{123}=0$; yet $\mu_{123}$ is not injective, hence not
invertible. $\square$

**Consequence for §D.** "$\delta_{\mathfrak T}\ne0\Rightarrow$ translation is a knowledge-defect"
is *sound*: a non-zero cofibre certifies a real failure. Its converse — which the mandate
asserted and which a reader of §D would naturally supply — is **false**: $\delta_{\mathfrak T}=0$
does **not** certify that the routes agree. §D's implication must not be silently upgraded to a
biconditional. This is standing check (e) — D0017 §F's exact error — arising a second time, now
in the successor structure, and I flag it as such rather than committing it.

### Theorem 3.6 (the price of $\operatorname{cofib}$, which the prior pass did not name)
1. If the hom-categories of $\mathcal B$ are **stable** (or abelian, for the 1-categorical
   statement), then $\operatorname{cofib}(\mu)=0\iff\mu$ is an equivalence: the fibre sequence
   $\ker\mu\to\mathfrak T_{jk}\mathfrak T_{ij}\to\mathfrak T_{ik}\to\operatorname{cofib}\mu$
   with vanishing cofibre forces the middle map to be an equivalence. So $\delta$ is a
   **complete** detector.
2. Under (H1) alone, $\delta$ is **sound but incomplete** (Prop. 3.1 + Thm 3.5).
3. Stability/abelianness is exactly the $\mathbf{Ab}$-enrichment that D0017 §C's minus sign
   required and that $\operatorname{cofib}$ was introduced to avoid.

Hence: **the move from minus to $\operatorname{cofib}$ buys ambient generality and pays for it
in detection fidelity, one for one.** The prior pass's Prop. 4.2 and its verdict
("$\operatorname{cofib}$ *is* the right operation… a genuine improvement") are correct about the
weakening of hypotheses and silent about the cost. Both halves should be on record. This is the
same shape as that pass's own Cor. 4.1.2 ("it cannot have both"), one level up: you cannot have
both a general ambient and a faithful defect.

---

## 4. Kernel versus cofibre: dual halves, neither complete

Assume (H1$^\dagger$). Write $\kappa_{ijk}:=\ker(\mu_{ijk})$.

### Theorem 4.1 (what each detects, in (M))
In $\mathcal B_{\mathrm{Set}_*}$:
- $\delta_{ijk}=\operatorname{cofib}\mu_{ijk}$ is the pointed set of translations $i\to k$ **not
  obtainable** by routing through $j$ — *the composite route is missing content*;
- $\kappa_{ijk}=\mu_{ijk}^{-1}(*)$ is the pointed set of composable pairs $(g:i\to j,\ h:j\to k)$
  whose composite is **zero** — *the composite route's content is annihilated by the direct one*.

*Proof.* The pushout and pullback formulas recorded under (M). $\square$

### Theorem 4.2 (independence)
$\delta$ and $\kappa$ are logically independent: each can vanish while the other does not.

*Proof (finite exhaustive verification, in (M), $I=\{1,2,3\}$).*
$\delta\ne0,\ \kappa=0$: Thm 3.4's example has $\mathfrak T_{23}=\{*\}$, so
$\mathfrak T_{23}\wedge\mathfrak T_{12}=0$ and $\kappa_{123}=0$ while $\delta_{123}\ne0$.
$\delta=0,\ \kappa\ne0$: take $\mathfrak T_{12}=\{*,g_1,g_2\}$, $\mathfrak T_{23}=\{*,h\}$,
$\mathfrak T_{13}=\{*,f\}$ with $hg_1=f$ and $hg_2=*$; associativity and unitality as in Thm 3.5
(no composable length-3 non-identity string). Then $\mu$ is surjective ($\delta=0$) and
$\mu^{-1}(*)\ni h\wedge g_2$, so $\kappa\ne0$. $\square$

### 4.3 A discrepancy between §D's formula and the corpus instance that motivated the amendment
The prior pass's §8 amendment reads: *"the content-bearing object is … the cofibre / kernel of the
comparison map once the routes have been made correct"*, and its evidence is
`notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` Cor. 1.1, which names, for each one-directional
arrow, **the kernel**: 2-cell homotopy, the $\pi_1$-action, torsion, $\pi_1(X)$.

By Thm 4.2 the slash in "cofibre / kernel" is **not** an equivalence of options. §D's
$\delta_{\mathfrak T}$ is a cofibre; the corpus's best instance produced fibres. They measure
opposite failures — *unreached meaning* versus *collapsed meaning*. So:

> **The prior pass's amendment is evidence for the fibre, while §D's formula is a cofibre. The
> single sharpest empirical instance in this corpus does not, in fact, instantiate the owner's
> displayed invariant; it instantiates its dual.**

I do not read this as refuting either. It says the successor rule must be **two-sided**:

> **Successor rule (offered, not asserted as the owner's).** For each comparison $\mu$: name
> $\operatorname{cofib}(\mu)$ (what the route through $j$ fails to reach) **and** $\ker(\mu)$
> (what it reaches and the direct translation forgets). Report both; neither alone, and not
> their conjunction, certifies agreement (Thm 3.5).

**Answer to mandate item 4:** "measure the kernel of $\mu_{ijk}$" is *half* of the correct
successor rule, is the half the corpus evidence supports, and is **not** the half §D wrote down.
It detects collapse and is blind to non-factorisability; the cofibre is blind the other way; and
Thm 3.5 shows their conjunction still fails to detect non-invertibility under (H1).

---

## 5. Holonomy: what survives the repair, and what does not

Let $\gamma=(i_0\to i_1\to\dots\to i_n=i_0)$, $n\ge1$, and
$\mathfrak T_\gamma:=\mathfrak T_{i_{n-1}i_n}\circ\cdots\circ\mathfrak T_{i_0i_1}$ (some
bracketing).

### Lemma 5.1 (iterated compositor)
For each bracketing $b$ of the string there is a 2-cell
$h^b_\gamma:\mathfrak T_\gamma^{(b)}\Rightarrow\mathfrak T_{i_0i_0}$ obtained by iterating
$\mu$. *Proof:* induction on $n$; $n=2$ is $\mu_{i_0i_1i_2}$, and a bracketing of length $n$
splits as $b_2\circ b_1$ at some point $i_m$, giving $\mu_{i_0i_mi_n}\circ(h^{b_2}\star h^{b_1})$
after the associator. $\square$

### Theorem 5.2 (the tetrahedron restores loop-dependence — prior Prop. 5.1(3) repaired)
$h^b_\gamma$ is independent of $b$. Write $h_\gamma$.

*Proof.* Induction on $n$. For $n=3$ the two bracketings are related by exactly (L3). For $n>3$,
any two bracketings are connected by a finite sequence of elementary re-bracketings (Mac Lane's
pentagon-style argument on the free magma / associahedron 1-skeleton), each of which is an
instance of (L3) whiskered by identities, and $\mathcal B$'s own associator coherence handles the
ambient reassociations. $\square$

**This is a positive result and it reverses a negative one.** The prior pass proved (Prop.
5.1(3)) that *absent* a quadruple condition, $\operatorname{Hol}$ depends on bracketing rather
than on the loop. (L3) is that condition, stated laxly, and it is available in any bicategory
(Rem. 2.3). So **the tetrahedron is not merely restorable after the lax repair — it is restorable
more cheaply than the prior pass believed.**

### Definition 5.3 (lax holonomy)
$\operatorname{Hol}_{\mathfrak T}(\gamma):=h_\gamma:\mathfrak T_\gamma\Rightarrow
\mathfrak T_{i_0i_0}$, a 2-cell of $\mathcal B(\mathfrak L_{i_0},\mathfrak L_{i_0})$. In the
normalised case $h_\gamma:\mathfrak T_\gamma\Rightarrow\operatorname{id}_{\mathfrak L_{i_0}}$.

### Theorem 5.4 (what dies)
1. **No group.** Concatenation gives $h_{\gamma'\gamma}=h$ of the concatenation, so loops at
   $i_0$ act as a **monoid**, not a group: $h_{\bar\gamma}$ for the reversed loop is *not*
   $h_\gamma^{-1}$, and in general there is no $\bar\gamma$ with $h_{\gamma}h_{\bar\gamma}$
   invertible. In (M), Thm 3.4's example has $\mathfrak T_{21}=\{*\}$, so every loop through $2$
   has $h_\gamma$ the zero map and no reversal repairs it.
2. **"$\operatorname{Hol}\ne1$" bifurcates.** The single predicate of §D splits into two
   inequivalent ones:
   - **(P1)** $\mathfrak T_\gamma\not\simeq\operatorname{id}_{\mathfrak L_{i_0}}$ — well-posed,
     but *not computed by the net's data*: it asserts the non-existence of some equivalence, and
     $h_\gamma$ is only one candidate;
   - **(P2)** $h_\gamma$ is not invertible — computed by the data, and strictly stronger
     information.
   (P2) $\not\Rightarrow$ (P1): in (M) take $\mathfrak T_{12}=\mathfrak T_{21}=S^0$ with
   $\mu_{121}$ the zero map $S^0\to\mathfrak T_{11}=S^0$ — then $\mathfrak T_\gamma=S^0=
   \mathfrak T_{11}$ (so (P1) fails) while $h_\gamma=0$ is not invertible (so (P2) holds).
   (Unit axioms constrain only $\mu_{ijj},\mu_{iij}$, not $\mu_{iji}$; associativity holds as all
   longer composites are covered by identities or land on $*$.)
3. **No number.** Prior Prop. 6.1(2) stands unchanged: no band, no trivialisation, no abelian
   coefficients.

### Corollary 5.5 (verdict on the mandate's sharpest question)
The repair does **not** destroy holonomy. It *demotes* it, by exactly the same move that saved
$\delta_{\mathfrak T}$: from an **invertible comparison against $1$** to a **chosen directed
comparison map**. The owner's operational rule — *do not erase the difference, measure the
holonomy* — survives its own repair **iff** "measure" is read as the prior pass already
insisted (*exhibit the comparison and name its cofibre*), and now additionally as §4.3 insists
(*and its kernel*). Read as "check whether $\operatorname{Hol}=1$", it does **not** survive:
Thm 5.4(2) shows that question has two inequivalent readings and the net's data answers only
the weaker-looking one.

**And the demotion is uniform.** $\delta_{ijk}$ and $h_\gamma$ are the same construction at
$n=2$ and general $n$; §D's two displays are one display. That unification is available only
after the lax repair — with $\simeq$ in place, both are trivial.

---

## 6. Does a classification survive? — No, and there was less to lose than advertised

### Theorem 6.1 (the pseudofunctor classification is *trivial*, not merely vacuous)
$\mathbf I$ is equivalent to the terminal category $\mathbf 1$. Hence restriction along
$\mathbf 1\hookrightarrow\mathbf I$ (pick any $i_0$) is a biequivalence
$$\mathrm{Pseudo}(\mathbf I,\mathcal B)\;\simeq\;\mathrm{Pseudo}(\mathbf 1,\mathcal B)\;=\;\mathcal B,$$
so **every pseudo translation net is equivalent to a constant one**, and the nonabelian Čech
2-class of §D's data (under the invertible reading) is **always trivial**.

*Proof.* $\mathbf I$ is a groupoid in which every pair of objects is joined by a unique
isomorphism and every object has trivial automorphism group; so the inclusion of any single
object is essentially surjective and fully faithful, i.e. an equivalence. Pseudofunctors and
pseudonatural transformations are invariant under equivalence of the source bicategory (the
$\mathrm{Pseudo}(-,\mathcal B)$ construction sends biequivalences to biequivalences), giving the
displayed biequivalence. $\square$

**This strengthens the prior pass's Cor. 3.3 from "the gerbe axioms hold vacuously" to "the
classification is trivial."** Not only do "locally non-empty" and "locally connected" say
nothing on the codiscrete index — the *class* the pseudofunctor reading was supposed to supply
is zero for every net. So the invertible reading of §D loses more than the prior pass recorded:
not just non-vacuity of $\delta$, but the entire classification, which is constantly trivial.

### Theorem 6.2 (the lax reading is *not* trivial, for the same structural reason)
Lax functors are **not** invariant under equivalence of the source. Concretely, in the model (M):
$\mathrm{Lax}(\mathbf 1,\mathcal B_{\mathrm{Set}_*})$ is the set of monoids-with-zero (a lax
functor from the terminal category is a monad in $\mathcal B$, here a monoid in
$(\mathrm{Set}_*,\wedge)$), while $\mathrm{Lax}(\mathbf I,\mathcal B_{\mathrm{Set}_*})$ with
$|I|=3$ is the class of $\mathrm{Set}_*$-enriched categories on three objects (Lem. 3.2). Thm
3.4's three-object example is not the restriction of any monoid: it has a non-zero hom
$1\to3$ and zero homs $1\to2$, $2\to3$, a configuration with no one-object counterpart.

*Proof.* Lem. 3.2 for the identification; Thm 3.4 for the example; the failure of restriction is
the finite check that no monoid $M$ yields all six off-diagonal homs equal. $\square$

**So the owner's $\Gamma_\Uparrow$ repair is forced twice over.** Once by Prop. 4.1 of the prior
pass (invertible $\Rightarrow\delta\equiv0$), and again by Thm 6.1 (invertible $\Rightarrow$ the
class is trivial anyway, because the index is codiscrete). **Laxness is not a concession; on a
codiscrete index it is the only source of content.** This is, I believe, the strongest available
defence of §D as written, and it is a defence of the *repaired* §D, not the displayed one.

### Theorem 6.3 (but there is no cohomology: comparisons form a preorder)
Let $\mathrm{Icon}(\mathfrak T,\mathfrak T')$ be the set of identity-on-objects comparisons
$\theta$: families $\theta_{ij}:\mathfrak T_{ij}\Rightarrow\mathfrak T'_{ij}$ with
$\theta_{ik}\circ\mu_{ijk}=\mu'_{ijk}\circ(\theta_{jk}\star\theta_{ij})$ and
$\theta_{ii}\circ\iota_i=\iota'_i$. Write $\mathfrak T\preccurlyeq\mathfrak T'$ if one exists.
Then:
1. $\preccurlyeq$ is a **preorder** (reflexive by identities, transitive by composition) and is
   **not symmetric**.
2. Consequently there is no quotient *set of classes*: nonabelian Čech $H^\bullet$ is defined as
   cocycles modulo the action of a **group** of $0$-cochains, and orbits of a group action
   partition. Here the acting structure is a **monoid** of non-invertible $\theta$, whose orbits
   do not partition; "cohomologous to the trivial net" is not an equivalence relation, so "the
   class of $\mathbb G$" does not denote.

*Proof of (1)'s asymmetry (finite exhaustive verification, in (M), $I=\{1,2,3\}$).* Let
$\mathfrak T^{\mathrm{o}}$ be the *zero net*: $\mathfrak T^{\mathrm{o}}_{ii}=\{*,\mathrm{id}_i\}$,
$\mathfrak T^{\mathrm{o}}_{ij}=\{*\}$ for $i\ne j$, all non-identity composites $*$ (a
$\mathrm{Set}_*$-enriched category: the discrete one with zeros adjoined). For any net
$\mathfrak T'$ with $\mathfrak T'_{ii}=\{*,\mathrm{id}_i\}$, the family
$\theta_{ii}(\mathrm{id}_i)=\mathrm{id}_i$, $\theta_{ij}=$ the unique pointed map
$\{*\}\to\mathfrak T'_{ij}$ satisfies both conditions (all constraints on off-diagonal components
have source containing a zero hom, hence both sides are $*$). So
$\mathfrak T^{\mathrm{o}}\preccurlyeq\mathfrak T'$ for all such $\mathfrak T'$. Conversely take
$\mathfrak T'$ = Thm 3.4's example: any $\theta':\mathfrak T'\to\mathfrak T^{\mathrm{o}}$ must
send $f\in\mathfrak T'_{13}=\{*,f\}$ into $\mathfrak T^{\mathrm{o}}_{13}=\{*\}$, so $\theta'$
exists — but it is not invertible, and no invertible comparison exists in either direction since
$|\mathfrak T'_{13}|\ne|\mathfrak T^{\mathrm{o}}_{13}|$. So $\preccurlyeq$ relates the two nets
in both directions **without** identifying them, which is exactly the failure of a preorder to be
an equivalence relation: $\preccurlyeq$-interrelated objects are not isomorphic, so the
$\preccurlyeq$-quotient is not a classification. $\square$

### 6.4 What replaces the class
Not a class but an **object**. Two facts, at different confidence:

- **Certain here.** Under (H1) and Def. 2.1, the invariant of a lax translation net that survives
  is the net itself up to *invertible* icon — an isomorphism, not a gauge class. The
  Grothendieck construction for a lax $\mathfrak T$ still produces a category over $\mathbf I$,
  but it is **not a fibration**: cartesian lifts require the compositors to be invertible, so the
  cleavage has no cartesian cells to be a cleavage *of*. Prior Cor. 3.2(3) therefore does **not**
  survive the repair.
- **Reported, not verified.** The literature records a replacement of the right shape: normal lax
  functors $D\to\mathbf{Prof}$ correspond to arbitrary functors into $D$, i.e. an equivalence
  between $\mathbf{Cat}/D$ and normal lax functors $D\to\mathbf{Prof}$ **with oplax
  transformations** — attributed to Bénabou, *Two constructions on lax functors*, CTGDC 13 (1972).
  **I did not read that paper: it is available only as a PDF and no PDF decoded in this session.**
  I record it as the classical locus and rely on nothing from it. Note that even as reported it
  confirms Thm 6.3's point: the classifying structure uses **oplax** (non-invertible)
  transformations, hence is a bicategory, not a set of classes.

### Theorem 6.5 (the clean statement the mandate asked for)
**The repair buys non-vacuity and loses the classification** — with one amendment the mandate did
not anticipate: on the codiscrete index there was no classification to lose, because the
pseudofunctor class is identically trivial (Thm 6.1). The accurate ledger is:

| reading of §D line 1 | $\delta_{\mathfrak T}$ | classification | $\operatorname{Hol}$ |
|---|---|---|---|
| $\simeq$ (pseudo) | $\equiv0$ (prior Prop 4.1) | exists, and is **trivial** for every net (Thm 6.1) | invertible; but every net is equivalent to a constant one, so $\operatorname{Hol}\simeq1$ always |
| chosen $\mu$ (lax) | non-vacuous (Thm 3.4), sound but incomplete (Thms 3.1, 3.5) | **none cohomological** (Thm 6.3); an object, not a class (§6.4) | survives as a directed 2-cell $h_\gamma$, bracketing-independent (Thm 5.2), not a group (Thm 5.4) |

The lax column is the only one in which §D says anything at all.

---

## 7. Prior art, named before the write-up

- **Bénabou**, *Introduction to bicategories* (1967) — bicategories, lax functors. **Not read.**
- **Bénabou**, *Two constructions on lax functors*, CTGDC 13 (1972) — located by web search
  2026-08-15; the $\mathbf{Cat}/D\simeq$ normal-lax-$D\to\mathbf{Prof}$ correspondence is
  attributed to it. **PDF; not decoded; not read; nothing above depends on it.**
- **nLab, *lax functor*** — HTML, read 2026-08-15. Source for Thm 2.2's definition, orientation
  convention, and "normal".
- **nLab, *pseudofunctor*** — HTML, read 2026-08-15. Source for the compositor/unitor data.
- **nLab, *Grothendieck construction*** — HTML, read 2026-08-15. Checked: it treats
  **pseudofunctors only**; it does not discuss lax sources. This is why §6.4's first bullet is
  argued directly rather than cited.
- **nLab, *cofiber*, *gerbe*, *bundle gerbe*** — read in the prior pass (seed 161) and relied on
  through it, not re-fetched.
- **Giraud** (1971), **Breen** (1994), **Murray** (1996), **Grothendieck** SGA1, **Street**'s
  orientals — named as classical loci; **none read**; no theorem number from any of them appears
  above. Street's orientals are the natural home for the $n$-fold coherence of Lem. 5.1 and I do
  not claim to have used them.

---

## 8. Scope: what this note does not settle

- **No site is supplied.** Everything above is on the codiscrete index. Whether a non-vacuous
  site on the space of vocabularies exists is exactly as open as the prior pass left it, and
  Thm 6.1 sharpens why it matters: on the codiscrete index the pseudo theory is empty, so any
  content in §D lives either in laxness or in a better site.
- **The ambient is hypothetical.** (H1)/(H1$^\dagger$) are my hypotheses; §D fixes no ambient.
  All examples are in one model (M), $\mathrm{Set}_*$-enriched categories. **A single model
  suffices for the negative results** (Thms 3.5, 4.2, 5.4, 6.3 are all counterexamples) and for
  the existence result (Thm 3.4); it does **not** license any claim about "typical" nets, and I
  make none.
- **Lemma 5.1/Thm 5.2's general-$n$ coherence** is proved by the standard associahedron induction
  and is stated at that level of detail; I have not written the full inductive bookkeeping, and I
  flag this as the one place above where I lean on a standard argument rather than exhibit it.
  The $n=3$ case, which is all §D's data needs, is exactly (L3) and is complete.
- **§C's $\rho(D\mathcal K)$ and §J5's $\chi_\alpha$: untouched.** Not measured, not
  rehabilitated, not identified with each other or with anything here.
- **§B's eight classes, §G's programme objects: untouched**, per §J3/§J7.
- **No empirical re-tally.** The prior pass's four instances are not re-examined; §4.3 uses only
  the *type* of invariant (fibre vs cofibre) named in its Cor. 1.1, which I verified by reading
  that pass, not by re-reading `OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` itself. **That is a
  second-hand link and is marked as such.**
- **Bénabou 1972 not read** (§7). §6.4's second bullet is reported, not verified.

---

## 9. Ledger

| Claim | Status | Where |
|---|---|---|
| Def. 2.1 (compositor + unitors + tetrahedron + unit coherence) is exactly a lax functor $\mathbf I\to\mathcal B$ | **Proved** | Thm 2.2 |
| The tetrahedron requires a 3-cell or stable homs | **Refuted** — it is an equation between parallel 2-cells, available in any bicategory; corrects prior Rem. 5.2 | Rem. 2.3 |
| $\mu$ invertible $\Rightarrow\delta_{ijk}=0$ | **Proved** | Prop. 3.1 |
| $\delta_{ijj}=\delta_{iij}=0$ always (units force it) | **Proved** | Lem. 3.3 |
| $\delta_{\mathfrak T}$ can be non-zero after the lax repair | **Proved** (finite verification) | Thm 3.4 |
| "$\delta_{\mathfrak T}\ne0$ **exactly when** $\mu$ not invertible" (the mandate's hint) | **Refuted**: converse fails even with $\ker=0$ | Thm 3.5 |
| $\operatorname{cofib}$ is a free advance over the minus sign | **Refuted as free**: complete under $\mathbf{Ab}$, incomplete under (H1); generality traded for fidelity | Thm 3.6 |
| $\ker$ and $\operatorname{cofib}$ detect the same thing | **Refuted**: logically independent, dual failures | Thms 4.1, 4.2 |
| §D's formula and the prior pass's motivating instance are the same invariant | **Refuted**: §D is a cofibre, the instance produced fibres | §4.3 |
| $h_\gamma$ depends on bracketing | **Refuted once (L3) is imposed** — repairs prior Prop. 5.1(3) | Thm 5.2 |
| $\operatorname{Hol}$ survives as a group element / as "$\ne1$" | **Refuted**: monoid, not group; the predicate bifurcates and the data answers only (P2) | Thm 5.4 |
| $\operatorname{Hol}$ survives as a directed comparison 2-cell | **Proved** | Def. 5.3, Cor. 5.5 |
| The pseudofunctor reading has a non-trivial class | **Refuted**: $\mathbf I\simeq\mathbf 1$, class trivial for every net | Thm 6.1 |
| The lax reading is likewise trivial | **Refuted**: lax functors are not source-equivalence-invariant | Thm 6.2 |
| A nonabelian cohomological classification survives laxness | **Refuted**: comparisons form a preorder; $H^\bullet$ needs a group of coboundaries | Thm 6.3 |
| The Grothendieck construction still gives a fibration | **Refuted**: no cartesian lifts without invertible $\mu$; prior Cor. 3.2(3) does not survive | §6.4 |
| "The repair buys non-vacuity and loses the classification" | **Proved, with an amendment**: there was no non-trivial classification to lose | Thm 6.5 |

**Overall.** Perform the owner's own $\Gamma_\Uparrow$ and §D becomes a **normal lax functor from
the codiscrete groupoid on the vocabularies into a bicategory with pointed, cocomplete-enough
hom-categories** — equivalently, in the working model, a category enriched in pointed sets, whose
$\delta_{ijk}$ is *the translations $i\to k$ that do not factor through $j$*. The repair is
**forced twice**: without it $\delta\equiv0$ (prior pass), and also the class is identically
trivial (Thm 6.1). What it buys is non-vacuity. What it costs is the classification — which, on
this index, was worth nothing anyway — and the *completeness* of $\delta$ as a detector, which
the prior pass credited without pricing. Holonomy is not destroyed; it is demoted by exactly the
same move that saved $\delta$, and it comes back **bracketing-independent**, which is more than
the prior pass expected. The owner's operational rule survives its own repair, in the two-sided
form: *name the comparison, and take both its cofibre and its kernel — and do not read either
vanishing as agreement.*
