# Fillability as a success predicate: $\Gamma_\Uparrow$ is $\Pi^0_2$, not $\Sigma^0_1$, and the dividing line for quantitative defects is arity, not zero

*Successor to `notes/COHERENCE_AND_FLOW_SLOTS.md` (seed 172), which proved that
$\Gamma_\Uparrow$ is not an instance of the transport schema, and to
`notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` (seed 156), which proved that the four
transport modes share the success predicate "membership in a distinguished singleton".
The ordinal ladder $\delta^{(0)}\xrightarrow{\Gamma}\chi^{(1)}\xrightarrow{\partial}\delta^{(1)}\to\cdots$,
the equation $\partial\Gamma_\alpha\langle\delta^{(n)}\rangle=\delta^{(n+1)}$, the homotopy
colimit at limit ordinals and the advance rule $\partial\delta^{(\lambda)}\ne0\Rightarrow\lambda\mapsto\lambda+1$
are the human owner's (D0016 §C), quoted and derived from, never rewritten. The four modes and
their names are the owner's (D0018 §B). Everything below is proof, refutation and scope-fixing.
Nothing here restates a transmission as a result.*

Seed 177, 2026-08-15.

---

## 0. What is settled here

| claim | status |
|---|---|
| "$\Gamma_\Uparrow$ preserves the defect under truncation" (seed 172 Prop 2.2's load-bearing step) | **verified, and its ground repaired** (§1.1): the truncation that recovers the defect is the *2-cell-forgetting* one, and it works because the adjunction is **free**. The other truncation — the homotopy category — *kills* the defect, and seed 172's proof does not exclude it. I supply the exclusion (Clause D′) |
| "$\operatorname{YB}_\delta$ has no $H^1$ beneath it" (seed 172 Thm 3.3(a)) | **verified, and strengthened** (§1.2): the correct reason is not only that Shapiro has no input but that the one available quotient — conjugacy — **fixes the identity**, so the distinguished element is unreachable from outside the orbit |
| the success predicate of $\Gamma_\Uparrow$, stated exactly | **done** (§2): it is **two** predicates, $\mathrm{Fill}_{\mathrm{term}}$ and $\mathrm{Fill}_\infty$, and $\mathrm{Fill}_{\mathrm{term}}\Rightarrow\mathrm{Fill}_\infty$ **strictly** ($A_\infty$) |
| logical complexity | **classified relative to a stated effectivity hypothesis** (§3): $\mathrm{Fill}_{\mathrm{term}}$ is $\Sigma^0_1$ (semi-decidable, finitely certifiable); $\mathrm{Fill}_\infty$ is $\Pi^0_2$ under finite branching, $\Sigma^1_1$ without it, and $\Sigma^1_1$ in the owner's *ordinal* ladder as literally written |
| can $\Gamma_\Uparrow$'s success be *reported*? | **yes for termination, no for coherence** (§3.4) — and the substitute is a *theorem about the ambient*, not a check on the data. Hence $\Gamma_\Uparrow$ **fails clause (ii) of `QUANT…` Def 4.0.1**, not only clause (iv) |
| seed 156 Thm A's $\Gamma_\Uparrow$ case | **corrected** (§3.5): "the obstruction is the distinguished element **at each level**" is a quantified conjunction of singleton-memberships, which is not itself a singleton-membership. The summary line claims more than the body proves |
| is the cost ever bounded? | **yes, and by exactly one hypothesis that is a theorem** (§4): $n$-truncation of the ambient forces $\delta^{(n+1)}=0$. Nilpotence does **not** bound the tower — it bounds the branching, which is a different service (§4.2) |
| is the bounded regime satisfied by a corpus defect? | **yes, by the only live one** (§4.3): $\operatorname{YB}_\delta(R)\ne1$ filled in a monoidal **2**-category has a tower of length $\le2$; what remains is one equation, and which equation is an open `SEARCH` |
| **does $\Gamma_\Uparrow$ act on quantitative defects?** | **no — and by a different theorem** (§5): it escapes Thm A (it presupposes no zero) and is still caught by **Thm B** (arity). Thm B never uses the zero hypothesis, only unarity |
| is "distinguished singleton" still the right dividing line? | **no; it was the right line for the four transports only** (§5.3). The line that covers all five is **the arity of the repair certificate** |

**Scope limits, up front.** (i) §3's complexity classification is relative to Effectivity Hypothesis (E) of §3.1 — a recursively presented ambient with an r.e. cell set at each level. Without (E) the question is not one of the arithmetical hierarchy at all, and I say so rather than quietly assuming a presentation. (ii) The $\Pi^0_2$-**hardness** of $\mathrm{Fill}_\infty$ is given as a reduction *sketch* (§3.3) and I do not claim completeness. The upper bounds are proved. (iii) There is no formalism in this corpus in which 2-cells, ordinals and homotopy colimits are simultaneously objects; §2's tower is stated at the generality of D0016 §C's own display, which is a display and not a definition. Everything I prove about it is proved from the display plus a stated reading, and §2.4 states the reading. (iv) No computation, no Python, no numerics, no fitted quantity, no correlation. No Agda or Lean authored; nothing typechecked. (v) D0018 §J5's $\chi_\alpha$ and D0019 §C's $\rho(D\mathcal K)$ are untouched and are **not** identified with each other — nor with D0016 §C's $\chi^{(n)}$, which is a third and unrelated use of the letter and which §2.1 renames for exactly that reason.

**A notation discrepancy, reported and not concluded from (standing check (b)).** My tasking names the tower $\delta^{(0)}\to\alpha^{(1)}\to\delta^{(1)}\to\alpha^{(2)}\to\cdots$. The archive `collab/upstream/raw/D0016-…md` §C displays it as $\delta^{(0)}\xrightarrow{\Gamma}\chi^{(1)}\xrightarrow{\partial}\delta^{(1)}\xrightarrow{\Gamma}\chi^{(2)}\to\cdots$ — the intermediate terms are $\chi$, not $\alpha$. The archive is a transcription and **has been proved lossy once** (D0016 §D's restored transcription correction). I therefore report the difference and conclude nothing from it: I use the archive's $\chi$, note that $\alpha$ is D0017 §C's letter for a 2-cell filler and that the two readings agree in content, and flag that if the owner's original writes $\alpha$ the substitution is harmless. What would *not* be harmless, and what I avoid, is treating $\chi^{(n)}$ as D0018 §J5's $\chi_\alpha$.

---

## 1. Verification of the two load-bearing steps

Tonight's standing check (d) — false grounds outnumber false claims four to one — is the reason this section exists. Both steps survive; both had a gap; the second gap changes how the result should be quoted.

### 1.1 "$\Gamma_\Uparrow$ preserves the defect under truncation" — verified, ground repaired

**What is claimed.** `FOUR_REPAIR_MODES.md` §1.1 (column *preserves*: "everything (no information discarded)") and §1.2 ("the old situation is recovered by truncating"). Seed 172's Prop 2.2 uses it in the form: *the defect is recoverable from the output, so $F(\varphi)(D)=0$ with $D\ne0$ is impossible.*

**Re-derivation.** Let $\mathfrak X$ be a category containing a parallel pair $u,v:A\rightrightarrows B$ with $u\ne v$, and let $\mathfrak X[\alpha]$ be the 2-category (bicategory) obtained by **freely** adjoining an invertible 2-cell $\alpha:u\Rightarrow v$. Freeness is the operative word and neither predecessor states it: the free adjunction of 2-cells to a 1-category adds no 1-cells and imposes no relations among 1-cells, so the underlying 1-category is unchanged,
$$U\bigl(\mathfrak X[\alpha]\bigr)=\mathfrak X,\qquad\text{hence}\qquad u\ne v\ \text{in}\ U(\mathfrak X[\alpha]).$$
So under the *cell-forgetting* truncation $U$, the defect $\delta_\Diamond=u\ominus v\ne0$ is recovered on the nose. **The claim is verified.**

**The gap, and it is real.** There is a *second* truncation, and it does the opposite. Let $\operatorname{ho}(\mathfrak X[\alpha])$ be the homotopy category: same objects and 1-cells, with 1-cells identified when connected by a 2-cell. In $\operatorname{ho}(\mathfrak X[\alpha])$ we have $u=v$, i.e. $\delta_\Diamond\mapsto0$. So the composite
$$\varphi:\ \mathfrak X\ \hookrightarrow\ \mathfrak X[\alpha]\ \twoheadrightarrow\ \operatorname{ho}(\mathfrak X[\alpha])$$
**is** a morphism of ambients under which the defect's image vanishes — precisely the transport schema. A reader who supplies this $\varphi$ refutes Prop 2.2 as written, because Prop 2.2 says only "the defect is recoverable, so no $F$ can send it to zero", and $F=\pi_0\mathrm{Hom}$ does send it to zero.

**The repair, which I state as a clause because it is the same clause seed 172 already needed elsewhere.**

> **Clause D′ (degenerate collapse, for success predicates).** A success predicate $F(\varphi)(D)=0$ does not count as certifying a repair if $F\circ\varphi$ annihilates *every* defect of its type, independently of any hypothesis on the datum. Formally: $F$ must be selective — there must exist $D'$ in the same slot with $F(\varphi')(D')\ne0$ for the corresponding $\varphi'$.

This is Clause D of `COHERENCE_AND_FLOW_SLOTS.md` §1.3 (a transport whose target retains none of the structure the defect was a defect *of* is no repair), transposed from the *target* to the *defect functor*, where it belongs. Under Clause D′ the $\operatorname{ho}$ dressing is excluded: $\operatorname{ho}(\mathfrak X[\alpha])$ identifies $u$ and $v$ for **every** parallel pair whatever, so its "success" is unconditional, carries no information about whether the coherence tower can be filled, and would certify the repair of a defect that has not been repaired. Without Clause D′ every operation whatsoever is a repair, by choosing $F\equiv0$.

**Verdict.** Prop 2.2 stands, with its proof completed at two points that were load-bearing and unstated: (a) the truncation is the free/cell-forgetting one, and freeness is what makes recovery hold; (b) the homotopy-truncation dressing must be excluded, and Clause D′ excludes it. **Note what the repair also gives, positively:** $\Gamma_\Uparrow$ followed by homotopy-truncation *is* a transport, and it is $\Gamma_\varnothing$ — kill the defect by declaring $u=v$, at the cost of discarding $\alpha$. So the corpus's two moves on a failed equation are exactly $\Gamma_\Uparrow$ (adjoin, keep) and $\Gamma_\Uparrow$-then-$\operatorname{ho}$ (adjoin, discard) $=\Gamma_\varnothing$, and the difference between them is whether the filler is retained. That is a cleaner statement of the $\mathcal C$/$\mathcal X$ separation than §2.1 of the predecessor achieved, and it is the same separation.

### 1.2 "$\operatorname{YB}_\delta$ has no $H^1$ beneath it" — verified, and the reason is stronger than stated

**What is claimed.** `COHERENCE_AND_FLOW_SLOTS.md` §3.3(a): seed 162's universality of the coefficient slot (Shapiro; every structural defect dies in a coinduced module) "does not apply here, because its input is a cocycle and $\operatorname{YB}_\delta$ is an element of a group with no $H^1$ beneath it". This is the note's own crux, and my tasking says it is doing heavy load-bearing work. It is.

**Re-derivation, from the definitions.** Why can coefficient enlargement kill a *cocycle*-shaped defect at all? Because $Z^1$ and $B^1$ grow at different rates: for $\iota:V_0\hookrightarrow V$ one has $Z^1(\Gamma,V_0)\subseteq Z^1(\Gamma,V)$ and $B^1(\Gamma,V_0)\subseteq B^1(\Gamma,V)$, and a $D$ outside $B^1(\Gamma,V_0)$ may lie in $B^1(\Gamma,V)$ — Corollary 2.1 of `FOUR_REPAIR_MODES.md`, the Eichler instance, is exactly a witness that this happens. So the mechanism of the coefficient slot is: *the equivalence relation on defect values gets coarser when the ambient grows*.

$\operatorname{YB}_\delta(R)$ has no such structure. Its value set is a group $G=\operatorname{Aut}(V^{\otimes3})$, its distinguished element is $1$, and an ambient enlargement is a homomorphism $\iota:G\to G'$. Then $\iota(g)=1\iff g\in\ker\iota$; for injective $\iota$ (i.e. an enlargement under which the original ambient survives — Clause D again) $\iota(g)\ne1$ whenever $g\ne1$. That is seed 163's Thm 7 and I verified its one-line proof.

**Where I add to it, because "no $H^1$" is a statement about an absence and absences are exactly what standing check (b) says must not be concluded from.** There *is* something beneath $\operatorname{YB}_\delta$: seed 163's Thm 5 proves the element is well defined only up to **conjugacy**, so the honest defect value is the conjugacy class $[\operatorname{YB}_\delta(R)]\in G/\!\sim$, and passing to it is $\Gamma_\circlearrowleft$. The gauge quotient exists. So the claim cannot be "nothing lies beneath"; it must be, and I prove it in this form:

> **Proposition 1.2.** *Let $G\le G'$ with $g\in G$, $g\ne1$. Then $[\iota(g)]\ne[1]$ in $G'/\!\sim$. Hence neither the gauge quotient nor any faithful enlargement, nor the two composed in either order, sends the defect to its distinguished element.*
>
> **Proof.** Conjugation by any $h\in G'$ is an automorphism of $G'$ and therefore fixes $1$; so $h\iota(g)h^{-1}=1$ forces $\iota(g)=1$, which forces $g=1$ by injectivity. $\square$

**This is the sharper form of "no $H^1$ beneath it", and it is what the exclusivity argument actually needs.** The cocycle case is exactly the case where the analogue of Prop 1.2 *fails*: the coboundary relation $D\sim D+\partial R$ is **not** induced by automorphisms of the value set fixing $0$, it is a quotient by a subgroup that grows with the ambient, and that is precisely why enlargement can reach the distinguished element there and cannot here. Say it as a slogan and it stops being mysterious: **a defect is enlargement-repairable exactly when its triviality relation grows with the ambient; conjugacy does not grow, coboundary does.** Seed 172's crux survives, with a proof that no longer rests on the absence of an $H^1$ but on a positive property of the quotient that *is* there.

---

## 2. The success predicate, stated exactly

### 2.1 The tower

From D0016 §C, verbatim: $\Gamma_\alpha:\mathcal O_\alpha\to\operatorname{Cell}(\mathcal C_{\alpha+1})$;
$X^+_\alpha:=X_\alpha\amalg^h_{\partial\mathcal O_\alpha}\Gamma_\alpha\langle\mathcal O_\alpha\rangle$;
$\partial\Gamma_\alpha\langle\delta^{(n)}\rangle=\delta^{(n+1)}$; the ladder
$\delta^{(0)}\xrightarrow{\Gamma}\chi^{(1)}\xrightarrow{\partial}\delta^{(1)}\xrightarrow{\Gamma}\chi^{(2)}\xrightarrow{\partial}\delta^{(2)}\to\cdots$;
$\delta^{(\lambda)}:=\operatorname{hocolim}_{\beta<\lambda}\delta^{(\beta)}$; and
$\partial\delta^{(\lambda)}\ne0\Rightarrow\lambda\mapsto\lambda+1$.

Three readings must be fixed before anything can be proved, and I fix them explicitly rather than inherit them.

- **(R1)** $\chi^{(n+1)}=\Gamma\langle\delta^{(n)}\rangle$ is the **chosen filler** at stage $n$: a cell of $\mathcal C_{n+1}$ whose boundary is $\delta^{(n)}$. It is a choice; the owner's arrow $\xrightarrow{\Gamma}$ is not single-valued unless the filler is unique. **(To avoid the collision flagged in §0, I write $\chi^{(n)}$ only in this sense and never abbreviate it to $\chi$.)**
- **(R2)** $\delta^{(n+1)}=\partial\chi^{(n+1)}$ is the **residual obligation** of that choice — the next failed equation, generated by the filler. This is the owner's own equation and it is the exact statement of the cost.
- **(R3)** $\delta^{(n)}=0$ means: the level-$n$ obstruction is the distinguished element of the level-$n$ obstruction set (identity 2-cell / zero class / trivial group element, according to level).

### 2.2 The two predicates

**Definition 2.2.1 (the tower of a defect).** For a defect $\delta$ in an ambient $\mathfrak X$ admitting cell-adjunction at every level, a **filling sequence of length $\beta$** is a family $(\chi^{(\gamma+1)})_{\gamma<\beta}$ with $\partial\chi^{(\gamma+1)}=\delta^{(\gamma)}$ for each $\gamma$, $\delta^{(\gamma+1)}:=\partial\chi^{(\gamma+1)}$'s successor obligation as in (R2), and $\delta^{(\lambda)}=\operatorname{hocolim}_{\gamma<\lambda}\delta^{(\gamma)}$ at limits. Write $T(\mathfrak X,\delta)$ for the tree of filling sequences ordered by extension.

**Definition 2.2.2 (the two success predicates).**
$$
\boxed{\ \mathrm{Fill}_{\mathrm{term}}(\mathfrak X,\delta)\ :\Longleftrightarrow\ \exists\beta\ \exists\ \text{a filling sequence of length }\beta\ \text{with}\ \delta^{(\beta)}=0\ }
$$
$$
\boxed{\ \mathrm{Fill}_\infty(\mathfrak X,\delta)\ :\Longleftrightarrow\ T(\mathfrak X,\delta)\ \text{has a branch of length}\ \mathrm{Ord}\ \text{— i.e. a total choice function}\ \gamma\mapsto\chi^{(\gamma+1)}\ \text{filling every level}\ }
$$

**Proposition 2.2.3.** $\mathrm{Fill}_{\mathrm{term}}\Rightarrow\mathrm{Fill}_\infty$, and the implication is **strict**.

**Proof.** ($\Rightarrow$) If $\delta^{(\beta)}=0$ then the identity cell fills level $\beta$ and every level above, since $\partial(\mathrm{id})$ is again distinguished; extend the sequence by identities. (Strictness) An $A_\infty$-algebra is a filled tower that never terminates: nLab, *A-infinity-algebra*, read — the operations $D_k:V^{\otimes k}\to V$ run "and so forth, indefinitely", with $D_3$ the associator, $D_4$ the pentagonator, and "this tower does not terminate". Every level is filled; no level is $0$. $\square$

**This is the whole point of the section and I state it flatly: fillability is not eventual vanishing.** Seed 172's §3.1 availability column says "the coherence tower must be fillable" and seed 156's Thm A reads that as "the obstruction is the distinguished element at each level". Those are $\mathrm{Fill}_\infty$ and (a level-wise reading of) $\mathrm{Fill}_{\mathrm{term}}$ respectively, and Prop 2.2.3 says they are different predicates. The one that means *coherence* is $\mathrm{Fill}_\infty$.

### 2.3 The template row

In the five-column form of `COHERENCE_AND_FLOW_SLOTS.md` §3.1, with the success and cost columns now discharged rather than named:

| column | content |
|---|---|
| **domain** | pairs $(\mathfrak X,\delta)$: $\mathfrak X$ an ambient admitting cell-adjunction at every level; $\delta=\delta^{(0)}$ a **failed equation between parallel cells**, i.e. $u,v:A\rightrightarrows B$ with $u\ne v$ (equivalently a non-distinguished element of the level-0 obstruction set). *Not* a magnitude, and not a bound — see §5 |
| **codomain** | the tower $T(\mathfrak X,\delta)$, an ordinal-indexed tree of pairs $(\mathfrak X_\gamma,\delta^{(\gamma)})$ with $\mathfrak X_{\gamma+1}=\mathfrak X_\gamma\amalg^h_{\partial\mathcal O}\Gamma\langle\mathcal O\rangle$ and $\delta^{(\gamma+1)}=\partial\Gamma\langle\delta^{(\gamma)}\rangle$ (D0016 §C), $\operatorname{hocolim}$ at limits |
| **operation** | one step: $(\mathfrak X_\gamma,\delta^{(\gamma)})\mapsto(\mathfrak X_{\gamma+1},\delta^{(\gamma+1)})$ by a **chosen** filler $\chi^{(\gamma+1)}$. Multivalued: the operation is a relation, not a function, unless fillers are unique |
| **availability** | the enrichment must exist. **This is the only availability hypothesis that is checkable from the data**; fillability is *not* an availability hypothesis, it is the success predicate, and §3 shows why the two cannot be conflated |
| **success** | $\mathrm{Fill}_\infty$ (Def 2.2.2), with $\mathrm{Fill}_{\mathrm{term}}$ as the strictly stronger terminating case. **Not** membership in a distinguished singleton: it is a quantification over a family of such memberships (§3.5) |
| **cost** | exactly one new obligation per application, one level up: $\delta^{(\gamma+1)}=\partial\chi^{(\gamma+1)}$. **Preserves** everything (§1.1, by freeness); **destroys** flatness — every equation downstream of $u=v$ becomes an obligation. Bounded iff §4.1's hypothesis holds |

### 2.4 The reading I am imposing, stated because it is the note's weakest joint

D0016 §C is a display, not a definition: it does not say what category $\delta^{(n)}$ lives in for each $n$, what $\partial$ is at each level, or in what sense the $\operatorname{hocolim}$ is taken. (R1)–(R3) are my reading; they are the reading under which the display's own equation $\partial\Gamma\langle\delta^{(n)}\rangle=\delta^{(n+1)}$ is a definition of $\delta^{(n+1)}$ rather than a constraint on it. **Every theorem below is a theorem about the tower so read**, and a reader who reads $\partial$ as a constraint rather than a definition gets a different object — one in which the tower may fail to exist at all, which is a *stronger* failure than anything I classify. I flag that as the alternative and do not pursue it.

---

## 3. The logical complexity

### 3.1 The effectivity hypothesis

A complexity classification is meaningless without a presentation, and supplying one is not optional:

> **Hypothesis (E).** $\mathfrak X$ is given by a recursive presentation: the set of $k$-cells at each level is recursively enumerable uniformly in $k$, the boundary maps $\partial$ are computable, and the predicate "$\delta^{(\gamma)}=0$" is decidable (or at least $\Sigma^0_1$, by search for a derivation of the equation).

Under (E) the questions become arithmetical. Without (E) they are not questions of the arithmetical hierarchy at all, and I say so rather than pretend the hierarchy applies to an arbitrary ambient. (E) is satisfied by the finitely-presented cases the corpus actually contains — §4.3's monoidal 2-category with one generating $R$ is finitely presented.

### 3.2 Upper bounds (proved)

**Theorem 3.2 (complexity of the two predicates, under (E)).**
*(a) Restricted to towers of finite length, $\mathrm{Fill}_{\mathrm{term}}$ is $\Sigma^0_1$.*
*(b) If $T(\mathfrak X,\delta)$ is finitely branching (finitely many fillers per level, up to the equivalence used) and the fill-check is decidable, $\mathrm{Fill}_\infty$ is $\Pi^0_2$.*
*(c) Without finite branching, $\mathrm{Fill}_\infty$ is $\Sigma^1_1$.*
*(d) For the tower as D0016 §C literally writes it — indexed by ordinals, with $\operatorname{hocolim}$ at limits — $\mathrm{Fill}_{\mathrm{term}}$ is $\Sigma^1_1$.*

**Proof.**
(a) $\mathrm{Fill}_{\mathrm{term}}$ restricted to $\beta<\omega$ reads $\exists n\ \exists(\chi^{(1)},\dots,\chi^{(n)})\ [\text{each }\chi\text{ fills}\ \wedge\ \delta^{(n)}=0]$. The bracket is decidable (or $\Sigma^0_1$) by (E), and the prefix is a block of number quantifiers over codes of finite tuples. By the Wikipedia *Arithmetical hierarchy* article, read: "$\Sigma^0_1$ sets of numbers are those definable by a formula of the form $\exists n_1\cdots\exists n_k\psi$" with $\psi$ having only bounded quantifiers, and these "are exactly the recursively enumerable sets". A $\Sigma^0_1$ matrix under existential number quantifiers is $\Sigma^0_1$. $\square$
(b) By (E) and finite branching, $T$ is a computable finitely-branching tree. König's lemma: $T$ has an infinite branch iff $T$ is infinite, i.e. iff $\forall n\,\exists$ a node at level $n$ — a $\forall\exists$ prefix over a decidable matrix, which is $\Pi^0_2$ (the same source: a $\Pi^0_2$ formula "begins with universal quantifiers and alternates one time"). $\square$
(c) With infinitely many fillers per level König fails, and $\mathrm{Fill}_\infty$ retains its native form $\exists f\,\forall n\,[\,f\!\restriction\! n\in T\,]$: a function quantifier over an arithmetical matrix, i.e. $\Sigma^1_1$. $\square$
(d) "$\exists$ an ordinal $\beta$" ranging over (codes for) recursive ordinals is an existential quantifier over well-orderings; "is a well-ordering" is $\Pi^1_1$, so the whole is $\Sigma^1_1$. $\square$

**The step from (b) to (c) is the one worth flagging, because it is where an intuition fails.** Finite branching is not a technicality: it is exactly the hypothesis that makes "every level can be filled" equivalent to "there is a coherent way to fill every level". Without it a tower can have a filler at every level and no branch — every partial choice eventually strands. That is the precise sense in which "the obstruction vanished at each stage" does not imply "the tower can be filled", and it is the distinction the tasking asked to be honoured.

### 3.3 Lower bound (sketch, and labelled as one)

$\Pi^0_2$-hardness of $\mathrm{Fill}_\infty$: from a $\Pi^0_2$ statement $\forall n\,\exists k\,R(n,k)$ with $R$ decidable, build a presentation whose level-$n$ obstruction $\delta^{(n)}$ admits a filler iff $\exists k\,R(n,k)$, by making the filler at level $n$ a cell whose existence is witnessed by a $k$ with $R(n,k)$ (adjoin one generating cell per pair $(n,k)$ with $R(n,k)$, with boundary $\delta^{(n)}$). Then the tower is fillable to every level iff $\forall n\,\exists k\,R(n,k)$; the tree is linear up to equivalence, so branch $=$ infinite. **I have not verified that this presentation satisfies (E) with a decidable fill-check, nor that the induced $\partial$ is the one D0016 §C's equation demands, and I therefore claim hardness as a sketch and completeness not at all.** What the sketch is enough for is the negative that the deliverable needs, and that negative follows from the upper bounds alone: see §3.4.

### 3.4 Can $\Gamma_\Uparrow$'s success be *reported*?

This is the deliverable, and it splits.

**(i) Termination can be reported.** $\mathrm{Fill}_{\mathrm{term}}$ is $\Sigma^0_1$: a success has a **finite certificate** — the filling sequence $\chi^{(1)},\dots,\chi^{(\beta)}$ together with the equality $\delta^{(\beta)}=0$ — which a referee checks in finite time. This is the same shape of certificate as the other four modes' ($R$ with $\partial R=-D$), and it is unilateral in the sense of `QUANT…` Criterion 2.2.2. **Failure, however, cannot be reported**: $\Sigma^0_1$ is not co-r.e., so "this tower does not terminate" has no finite certificate from the data.

**(ii) Coherence cannot be reported.** $\mathrm{Fill}_\infty$ is at best $\Pi^0_2$, which is neither r.e. nor co-r.e.; **neither success nor failure has a finite certificate computed from the data.** No effective procedure, however long it runs, reports "the tower can be filled". This is a strictly stronger negative than "the availability cannot be checked by a finite computation" (`FOUR_REPAIR_MODES.md` §1.2, which flagged it without locating it): a $\Sigma^0_1$ predicate also cannot be checked by a *finite* computation, but it can be *confirmed* by an unbounded one. $\Pi^0_2$ cannot even be confirmed.

**(iii) And yet coherence is reported all the time — by a theorem, not by a check.** Mac Lane's coherence theorem, the $A_\infty$/operadic machinery, Stasheff and Boardman–Vogt's strictification ("Every $A_\infty$-space is weakly homotopy equivalent to a topological monoid", nLab, read) are finite certificates for $\Pi^0_2$ statements. They are certificates *about the ambient*, valid for a whole class of towers at once, not computations on the datum $\delta$.

**Consequence, and it is the classification result.**

> **Theorem 3.4.** *Under (E), $\Gamma_\Uparrow$ fails clause (ii) of `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Definition 4.0.1 — "a stated availability hypothesis checkable from the data" — whenever its success is read as $\mathrm{Fill}_\infty$. Its success is certifiable only by a theorem quantified over ambients, never by an inspection of the defect.*
>
> **Proof.** Clause (ii) asks for a predicate on the datum that can be checked. By Thm 3.2(b,c) $\mathrm{Fill}_\infty$ is $\Pi^0_2$ or worse; a $\Pi^0_2$ predicate is not decidable and not semi-decidable, so no check exists. $\square$

So $\Gamma_\Uparrow$ fails **two** of Def 4.0.1's four clauses — (ii) here, and (iv) in §3.5 — and seed 156's own definition therefore does not admit it as a repair mode. This is not a defect of that definition; it is the exact measure of how different $\Gamma_\Uparrow$ is from the four, and it is the answer the tasking asked for: **a repair mode whose success predicate is not effectively checkable is not a mode in the sense the other four are; it is a mode-shaped object whose success is a theorem rather than a certificate.**

### 3.5 A correction to seed 156's Theorem A, per standing check (c)

`QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` §0 lists: "all four modes presuppose an attainable distinguished zero — **proved** (Thm A)". Its body proves this for three modes by exhibiting the singleton, and for $\Gamma_\Uparrow$ it says: "the success predicate **at each level** is 'the obstruction is the distinguished element'", explicitly inheriting the predecessor's limitation.

That is a **quantified conjunction** of singleton-memberships, $\forall\gamma\,[\delta^{(\gamma)}\in\{0\}]$ — or, under $\mathrm{Fill}_{\mathrm{term}}$, an existential one. Neither is itself membership in a distinguished singleton of a value set: there is no single value set, and there is a quantifier. The summary line claims more than the body proves, and the body is right: the phrase "at each level" is the whole gap, and Thm 3.2 measures it — the gap is exactly one alternation of the arithmetical hierarchy, from $\Sigma^0_1$/decidable up to $\Pi^0_2$.

**What survives of Theorem A.** Its three transport cases are untouched and correct. Its fourth case should be quoted as: *$\Gamma_\Uparrow$'s success is a quantification over distinguished-singleton memberships, one per level, and is therefore not of the same logical type as the other three.* Corollary A.1's use of it (§5 below) survives in a form that does not need it at all.

---

## 4. The cost, and when it is bounded

### 4.1 The one hypothesis that bounds it, and it is a theorem

**Theorem 4.1 (truncation bounds the tower).** *Let $\mathfrak X$ be $n$-truncated: all $k$-cells for $k>n$ are identities (equivalently, the level-$k$ obstruction set is the distinguished singleton for $k>n$). Then for every defect $\delta^{(0)}$ and every choice of fillers, $\delta^{(\gamma)}=0$ for all $\gamma>n$. Hence $\mathrm{Fill}_{\mathrm{term}}$ holds with $\beta\le n+1$, the tower has length $\le n+1$, and under (E) $\mathrm{Fill}_\infty$ is **decidable** by bounded search.*

**Proof.** $\delta^{(\gamma+1)}=\partial\chi^{(\gamma+1)}$ is a $(\gamma+2)$-cell (D0016 §C, reading (R2)). For $\gamma+2>n$ the only such cell is the identity, which is the distinguished element, so $\delta^{(\gamma+1)}=0$. Decidability: by Thm 3.2(a) the predicate is $\Sigma^0_1$ with the existential quantifier now bounded by $n+1$, and a bounded existential over a decidable matrix is decidable. $\square$

This is short, and it is the whole positive content of the cost question: **the tower is bounded exactly when the ambient has no room above it.** The cost of $\Gamma_\Uparrow$ is unbounded in general because the ambient is unbounded; truncate the ambient and the cost is paid in at most $n+1$ instalments, and — this is the part worth having — the success predicate drops from $\Pi^0_2$ all the way to decidable. **Truncation is what converts $\Gamma_\Uparrow$ into a mode in seed 156's sense.**

### 4.2 Nilpotence does *not* bound the tower — it bounds the branching

The tasking offers nilpotence as a candidate. It is the wrong service, and testing it rather than using it (standing check (a)) is what shows why.

nLab, *nilpotent space*, read: a connected space is nilpotent if "its fundamental group $\pi_1(X)$ is a nilpotent group" and the lower-central-style sequence $N_{0,n}:=\pi_n(X)$, $N_{k+1,n}:=\{gn-n\}$ "terminates". **The sequence that terminates is the one measuring the $\pi_1$-action on $\pi_n$, for each fixed $n$ — not the Postnikov tower.** Nilpotent spaces have infinite Postnikov towers in general (spheres are simply connected, hence nilpotent, and their Postnikov towers do not terminate). The nLab page states nothing about Postnikov finiteness for nilpotent spaces, and I report that as a limit of what I read, not as an absence in the literature.

**What nilpotence does give, and it is the useful thing.** It makes each stage of the tower principal and the relevant obstruction groups tractable (finitely generated in the finite-type case), which is exactly the hypothesis of **finite branching** in Theorem 3.2(b). So:

> **Corollary 4.2.** *Nilpotence (with finite type) is a hypothesis about $\mathrm{Fill}_\infty$'s **complexity**, not about the tower's **length**: it buys the passage from $\Sigma^1_1$ to $\Pi^0_2$ (Thm 3.2(c)$\to$(b)), and nothing more. Truncation buys the passage from $\Pi^0_2$ to decidable (Thm 4.1). The two hypotheses do different jobs and a reader who expects nilpotence to terminate the tower will be wrong.*

Stated at the strength of the reading above: Corollary 4.2 is an accurate description of which hypothesis feeds which theorem of §3, and it is not a theorem about nilpotent spaces, whose Postnikov behaviour I did not verify in a source.

### 4.3 Is the bounded regime satisfied by a corpus defect? Yes — by the only live one

$\Gamma_\Uparrow$ has exactly one exhibited corpus instance: `COHERENCE_AND_FLOW_SLOTS.md` Thm 3.3(e), filling
$R_{12}R_{23}R_{12}=R_{23}R_{12}R_{23}$ with an invertible 2-cell
$\Upsilon:R_{12}R_{23}R_{12}\Rightarrow R_{23}R_{12}R_{23}$ in a **monoidal 2-category**.

A monoidal 2-category is 2-truncated: its 3-cells are identities. By Theorem 4.1 with $n=2$:

> **Corollary 4.3.** *The tower of $\operatorname{YB}_\delta(R)\ne1$ filled in a monoidal 2-category has length $\le2$: $\delta^{(0)}$ is the failed braid relation, $\chi^{(1)}=\Upsilon$, $\delta^{(1)}=\partial\Upsilon$ is a single 3-dimensional obligation, and $\delta^{(2)}=0$ is forced. So $\mathrm{Fill}_{\mathrm{term}}$ reduces to **one equation**, $\delta^{(1)}=0$, and under (E) it is decidable.*

**And here the corpus's own honesty ledger bites, correctly.** Which equation $\delta^{(1)}=0$ is, is exactly seed 163's open `SEARCH` item: `CENTRE_AND_YANG_BAXTER_DEFECT.md` §4.2 records that it read the nLab page for *braided monoidal 2-category*, that the page did **not** state the axioms, and that the Zamolodchikov tetrahedron equation is therefore asserted as **located lineage only**. I inherit that at the same strength and no higher. So the accurate report is:

**the cost of $\Gamma_\Uparrow$ on the corpus's one live defect is bounded, and bounded at 2 — the bound is a theorem (4.1) that needs no source; the *identity* of the single residual obligation is a citation the corpus has not yet read.** Those are two different debts and conflating them would be exactly the error this repo audits for.

**One conflation to forbid explicitly.** `CENTRE_AND_YANG_BAXTER_DEFECT.md` Thm 6 proves a *different* finiteness: $\operatorname{YB}_\delta(R)=1$ on three strands already gives $B_n$-representations for all $n$, so "the transmission's single defect is not a first term of a tower". That is finiteness in the **strand** direction. Corollary 4.3 is finiteness in the **coherence-level** direction. They are independent, they are proved by different arguments, and Thm 6 says nothing about whether $\partial\Upsilon=0$. Neither implies the other.

**Other corpus defects.** `FOUR_REPAIR_MODES.md` §4.1's carry cocycle: $\Gamma_\Uparrow$ is "available in principle (carry as the associator of a monoidal structure on digit words)"; the ambient is a monoidal 1-category, 1-truncated, so by Thm 4.1 the tower has length $\le2$ and $\delta^{(1)}=0$ is the pentagon. That is the classical picture and it is a check on Thm 4.1 rather than a new result. §4.2's action residual: the note itself observes $\Gamma_\Uparrow$ is "strictly worse here, since the completion is universal and finite". §4.3's shifted-prime barrier: §5 below.

---

## 5. Does $\Gamma_\Uparrow$ act on quantitative defects?

### 5.1 The question is genuinely reopened

`QUANT…` Corollary A.1 concluded that no mode acts on a quantitative defect *because* all four have success predicate $\delta\in\{0\}$, which a quantitative defect never attains. §2 and §3 have just established that $\Gamma_\Uparrow$'s success is **not** $\delta\in\{0\}$. So Cor A.1's reason does not apply to it, and the question must be re-answered rather than inherited. (This is the tasking's point and it is a fair one: Cor A.1's proof reads "the first three have success predicate $\delta\in\{0\}$" — it names three, then includes $\Gamma_\Uparrow$ among them via Thm A, whose fourth case §3.5 has just qualified.)

### 5.2 The answer: no, and by two independent obstructions

**Obstruction 1 — the domain, not the success predicate (this is the "different reason").**

$\Gamma_\Uparrow$'s domain (§2.3) is a **parallel pair**: two named cells $u,v:A\rightrightarrows B$ between the same objects, with $u\ne v$. Its operation is to adjoin $\alpha:u\Rightarrow v$. A quantitative defect has no such presentation. Take `QUANT…` §5.3's paradigm, `SEED43_KAPPA_RESOLVENT_POLES.md` §7: the defect is that Lemma 3.2 "is an inequality, not a constant" — a gap between a bound $C_+$ and a construction $C_-$. There are no two parallel cells here to fill between: an inequality $C_-\preceq\delta\preceq C_+$ is not the assertion $u=v$ of two morphisms, and the failure of $C_-=C_+$ is not a failed equation *in an ambient* but a statement about magnitudes in an ordered set. Where the other four modes fail on the **codomain** (they cannot reach the required value), $\Gamma_\Uparrow$ fails **before it starts**, on the domain.

The failure survives the obvious repair attempt, and it is worth carrying it out because the attempt is what a reader will make. *Force it*: name the two sides, "the claimed asymptotic" $u$ and "the truth" $v$, adjoin $\alpha:u\Rightarrow v$. What has been produced is a *name for the discrepancy*. The 2-cell carries no bound; it certifies nothing about $|u-v|$; and every downstream consumer that needed an estimate now consumes a symbol. That operation is not a repair, and it is already classified: it is `QUANT…` §4.2's $\Gamma_{\!\downarrow}$ at best — hygiene, acting on the report of the defect and not on the defect — and $\Gamma_\varnothing$ at worst.

**Obstruction 2 — Theorem B, which never needed Theorem A.**

`QUANT…` Theorem B: *a unary partial operation on defect-carrying data can produce at most one of $C_+,C_-$ from $x$ alone*, because the two are statements of opposite variance in $\delta$ and are logically independent; if the operation outputs the pair it outputs information not determined by its input, i.e. it is a choice.

**Theorem B applies to $\Gamma_\Uparrow$ verbatim, and its proof uses nothing about distinguished zeros.** $\Gamma_\Uparrow$ is unary: it takes $(\mathfrak X,\delta)$ and returns a tower. So it cannot produce a bilateral certificate. And the one feature that distinguishes $\Gamma_\Uparrow$ from the others — that it is **choice-laden**, the filler $\chi^{(1)}$ being chosen and not determined (reading (R1)) — is precisely the escape hatch Theorem B's proof already anticipates and closes: an operation that supplies the missing member of the pair by *choice* is $\Gamma_\varnothing$'s situation, not a repair. Concretely, for $\Gamma_\Uparrow$ to close a quantitative gap the chosen filler would have to encode the missing bound. Say it plainly:

> **The filler would have to be the proof.** A 2-cell that certifies $C_-=C_+$ is not a coherence datum; it is the theorem, smuggled in as a choice. And CLAUDE.md's whole position is that at that point one should write the theorem.

### 5.3 The dividing line, corrected

**Theorem 5.3.** *With $\Gamma_\Uparrow$ admitted as a fifth operation with a second kind of success predicate, the criterion "presupposes an attainable distinguished zero" is **no longer** the dividing line for quantitative defects; the criterion that survives, and that covers all five uniformly, is **the arity of the repair certificate** (`QUANT…` Criterion 2.2.2 and Theorem B).*

**Proof.** The four transports are excluded from quantitative defects by Thm A + Cor A.1 (zero unattainable) and also by Thm B (unarity). $\Gamma_\Uparrow$ is **not** excluded by Thm A — its success is $\mathrm{Fill}_\infty$, which presupposes no attainable zero (Prop 2.2.3: an $A_\infty$ tower succeeds with no level ever zero) — and **is** excluded by Thm B, and independently by the domain obstruction of §5.2. So Thm A's criterion separates four of five; Thm B's separates five of five. $\square$

**Reading, and this is the note's classification finding.** Seed 156 offered Thm A/Cor A.1 as the *explanation* of seed 152 §4.3 and proved Thm B as a second, apparently redundant theorem. Theorem 5.3 says the redundancy was the other way round: **Theorem B was the load-bearing one all along, and Theorem A was the special case that happened to cover the four modes then known.** Thm A explains why the four transports miss; Thm B explains why *any* unary repair operation misses, including ones not yet named. It is the more robust statement, it was already proved, and it was under-used by its own author's summary line (standing check (c) again, and this is the second instance in this note).

**Consequence for future modes.** A sixth operation, with whatever exotic success predicate, is excluded from quantitative defects as soon as it is unary. To reach a quantitative defect an operation would have to be **binary in its certificate** — to take, or produce, a bound and a construction together — and no such thing is an operation on defect-carrying data; it is a pair of theorems. That is the sharpest form of `QUANT…` §4.3's negative, and it no longer depends on Definition 4.0.1's clause (iv), which was that negative's stated weak point.

---

## 6. Prior art

Searched **before** writing (CLAUDE.md's ordering), HTML only; **no PDF was decoded and none is claimed.**

- **Wikipedia, *Arithmetical hierarchy*.** Read. Supplied verbatim: the $\Sigma^0_1$ prefix form and "these are exactly the recursively enumerable sets"; that a $\Pi^0_2$ formula "begins with universal quantifiers and alternates one time"; and "the Turing computable sets … are exactly the sets at level $\Delta^0_1$". These ground Thm 3.2(a),(b) and §3.4's reportability claims. The page's treatment of $\Sigma^1_1$ is thin (a table entry, "lightface analytic"); I therefore use $\Sigma^1_1$ only in its unambiguous direction — as an upper bound, from the shape of the quantifier prefix — and claim no completeness at that level.
- **nLab, *obstruction theory*.** Read. It treats the lifting problem against a single Postnikov stage: "If $F\to A$ … is a stage $\tau_{\le n+1}B\to\tau_{\le n}B$ in the Postnikov tower of an object $B$, then the lifting problem is that of lifting through the Postnikov tower of $A$", with "the universal obstruction class … classified $\tau_{\le n+1}B\to\tau_{\le n}B$ as a $\pi_{n+1}B$-principal $\infty$-bundle". **Ground caveat (standing check (d)):** the returned content does **not** discuss when such a tower of successive obstructions terminates, nor stage-by-stage accumulation. So the classical frame supplies the *shape* of §2's tower and supplies **nothing** about §4's termination question, which is why Thm 4.1 is proved from D0016 §C's own equation and not cited.
- **nLab, *A-infinity-algebra*.** Read. Supplied: the operations $D_k:V^{\otimes k}\to V$ with $D_3$ "the associator", $D_4$ "the pentagonator", "and so forth, indefinitely"; "this tower does not terminate"; and the strictification theorems (Kadeishvili–Merkulov; Stasheff, Boardman–Vogt: "Every $A_\infty$-space is weakly homotopy equivalent to a topological monoid"). This is the ground for Prop 2.2.3's strictness and for §3.4(iii)'s point that coherence is certified by theorems.
- **nLab, *nilpotent space*.** Read. Supplied the definition quoted in §4.2, and — this is the load-bearing part — the page states **nothing** about Postnikov-tower finiteness, which I report as a limit of my reading rather than as an absence in the literature.
- **Not searched, and flagged as the gap:** whether "fillability of a coherence tower, classified in the arithmetical hierarchy" is prior art. The obvious places are the recursion-theoretic study of word problems for higher categories and the reverse-mathematics literature on $\Pi^0_2$ statements (`QUANT…` §7.3 already carries a `SEARCH` item pointing there). I did not look, and §7 carries it forward. **What I claim as this note's contribution, if anything is:** the location of $\Gamma_\Uparrow$'s success at $\Pi^0_2$ rather than $\Sigma^0_1$, the observation that this is exactly the failure of Def 4.0.1 clause (ii), and Theorem 5.3.
- Postnikov towers, $k$-invariants, the Whitehead tower, Mac Lane coherence, Street's orientals: the frame within which §2's tower sits. Named as located lineage; of these I read only the two nLab pages above, and Street's orientals I did not read in any source.

---

## 7. Queue

1. **`PROVE`** — Complete §3.3's $\Pi^0_2$-hardness reduction: verify that the exhibited presentation satisfies (E) and that its $\partial$ is the one D0016 §C's equation requires. A completeness result would upgrade §3.4(ii) from "not reportable" to "provably not reportable at any lower level".
2. **`SEARCH`** — Kapranov–Voevodsky's axioms in a source that renders as HTML, to identify Corollary 4.3's single residual obligation $\delta^{(1)}=\partial\Upsilon$. This is seed 163 §5.2 restated with a sharper target: it is now known to be **one** equation, not a tower, so the search has a definite object.
3. **`PROVE`** — Is $\mathrm{Fill}_\infty$ ever *strictly* between $\Pi^0_2$ and decidable for a corpus ambient, i.e. is there a corpus defect whose ambient is untruncated but finitely branching? If not, §4's dichotomy (truncated $\Rightarrow$ decidable; else $\Sigma^1_1$) is the whole story for this corpus.
4. **`PROVE`** — Clause D′ (§1.1) is stated and used once. Does seed 172's Thm 3.3 need it anywhere else, and does seed 162's Def 3.0.2 need it in the same place Clause D is needed? If the two clauses are instances of one clause about the selectivity of repair certificates, that is the right formulation and it should replace both.
5. **`PROVE`** — Theorem 5.3 says arity is the dividing line. Is there a *non-unary* operation on defect-carrying data at all — one whose domain is a pair of data — and if so does it evade Theorem B? `QUANT…` §7.1's $k$-ary question is the same question from the certificate side.
   *Partially discharged, 2026-08-15, in `formal/cubical/NaturalMachine/ArityOfRepair.agda` (checked, `--safe`, no postulates).* Three answers, all as terms: (i) arity **within the same input type** never helps — an $n$-ary operation on structural presentations is refuted for every $n$ by diagonal application (`no-nary-bilateral`); (ii) a **heterogeneous** binary operation, taking the presentation together with a construction, does exist and is sound and tight (`binary-heterogeneous-works`), so the line really is arity and not impossibility; (iii) but *any* such operation's second argument must already separate data of equal presentation and unequal magnitude (`second-argument-separates`) — the formal form of §5.2's "the filler would have to be the proof". What remains open is whether a corpus operation of that shape exists that is not simply a pair of theorems.

## 8. Honesty ledger

- **Nothing computed.** No Python, no numerics, no fitted constant, no correlation, no measurement. No Agda or Lean authored; nothing claimed typechecked.
- **D0018 §J5's $\chi_\alpha$ and D0019 §C's $\rho(D\mathcal K)$ are untouched, and are not identified with each other.** D0016 §C's $\chi^{(n)}$ is a third, unrelated symbol; §2.1 (R1) fixes its meaning locally and §0 flags the collision explicitly so that no later pass reads $\chi^{(n)}$ as $\chi_\alpha$.
- **Files read in full, not summarised:** `CLAUDE.md`; `notes/COHERENCE_AND_FLOW_SLOTS.md`; `collab/messages/0773-seed172-coherence-flow-slots.md`; `notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md`; `notes/FOUR_REPAIR_MODES.md`; `notes/CENTRE_AND_YANG_BAXTER_DEFECT.md`. Read at the cited sections: `collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md` §B, §C, §D, §G. Every file the tasking named exists and was opened (standing check (b)).
- **Grounds, by strength.** §1.1, §1.2 (Prop 1.2), Prop 2.2.3, Thm 3.2, Thm 3.4, Thm 4.1, Cor 4.3 and Thm 5.3 are proved here from definitions and from the owner's displays, and I stand behind them. §3.3's hardness is a **sketch, labelled as one, and nothing depends on it**. §4.2's Corollary is a statement about which hypothesis feeds which theorem of §3, not a theorem about nilpotent spaces. §2.4 states the reading of D0016 §C under which everything else is proved, and names the alternative reading I did not pursue.
- **On the two verifications I was told to perform (standing check (d)).** Both claims are **true**; both **grounds were incomplete**, which is exactly the ratio the tasking predicted. The truncation step needed freeness plus the exclusion of the homotopy-truncation dressing (Clause D′); without the exclusion, seed 172's Prop 2.2 is refutable in one line by a reader who supplies $F=\pi_0\mathrm{Hom}$. The "no $H^1$ beneath" step needed replacing an absence by a presence: conjugacy is what lies beneath, and the operative fact is that conjugation fixes the identity (Prop 1.2), not that nothing is there. **A note that quotes seed 172's crux as "there is no $H^1$" and stops has quoted an absence; Prop 1.2 is what it should quote.**
- **Corrections to notes I build on, per standing check (c).** Two, both of summary lines against their own bodies. (a) `QUANT…` §0's "all four modes presuppose an attainable distinguished zero — proved" overstates its own §3, whose $\Gamma_\Uparrow$ case proves a quantified conjunction of singleton-memberships and says so; §3.5 states the corrected form. (b) The same note's Cor A.1 is offered as *the* explanation of seed 152 §4.3, while its own Theorem B is the more robust explanation and does not need Theorem A; §5.3 promotes it. Neither correction weakens either note's verdict; both change what may be quoted from them.
- **On the tasking's hints (standing check (a)).** Three were offered and all three were tested rather than used. *Nilpotence* as a termination hypothesis: **refuted** (§4.2) — it bounds branching, not length, and the source read says nothing about Postnikov finiteness. *A truncated ambient*: **confirmed and proved** (Thm 4.1), and it is the only one of the three that bounds the cost. *A Postnikov-finite target*: this is the same hypothesis as truncation for the purpose at hand, and I have not distinguished them; if a reader means by "Postnikov-finite" something weaker than $n$-truncation — finitely many *nonzero* homotopy groups in an untruncated ambient — then Thm 4.1 does **not** apply to it, because $\delta^{(\gamma+1)}$ is a cell, not a homotopy class, and I record that as an untested case rather than claim it.
- **On the concluding generalisation (standing check (f)).** Theorem 5.3 — "arity, not zero, is the dividing line" — is offered at the generality of: five operations, two independent obstructions for the fifth (§5.2), and Theorem B's proof, which I re-read and which uses only unarity and the independence of upper and lower bounds. It is **not** a claim that no operation reaches quantitative defects; it is the claim that no *unary* one does, and queue item 5 is the honest form of the residual doubt. §3's complexity classification is relative to (E) and to §2.4's reading, and outside those it is not a claim at all.
- **Scope, restated (standing check (g)).** No formalism here contains 2-cells, ordinals and homotopy colimits simultaneously; the tower is D0016 §C's display under a stated reading. The complexity results are about *presentations*, not about ambients as such. Corollary 4.3's bound of 2 is a theorem; the identity of the residual obligation at level 1 is an unread citation, and the two must not be reported as one result.

*Credit: the ordinal ladder, the equation $\partial\Gamma\langle\delta^{(n)}\rangle=\delta^{(n+1)}$, the homotopy colimit at limits and the advance rule are the human owner's (D0016 §C); the four modes and their names are the owner's (D0018 §B); $\operatorname{YB}_\delta$ is the owner's (D0016 §D). $\Gamma_\Uparrow$ and the naming of its unbounded cost are seed 152's; the structural/quantitative criterion, Theorems A and B and Definition 4.0.1 are seed 156's; Clause D, Prop 2.2 and the exclusive witness for the coherence slot are seed 172's. This note supplies: Clause D′ and the repair of Prop 2.2's ground; Prop 1.2 in place of the absence-argument beneath $\operatorname{YB}_\delta$; the two fillability predicates and their strict separation; the complexity classification and the resulting failure of Def 4.0.1 clause (ii); the truncation bound on the cost and its application to the corpus's one live instance; and Theorem 5.3, which replaces the distinguished-singleton dividing line by the arity of the certificate.*
