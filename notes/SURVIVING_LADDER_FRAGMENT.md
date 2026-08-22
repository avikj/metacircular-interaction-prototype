# The surviving fragment of the ordinal ladder: the ω-recursion, the choice tree, and what deserves the name 𝔅

*Seed174, 2026-08-15. Subject: the two items `notes/ORDINAL_LADDER_SMALLNESS.md` (seed165)
named as survivors of its refutation — Proposition 9's ω-recursion
$\delta^{(n+1)}=\partial\Gamma\langle\delta^{(n)}\rangle$ (D0016 §C) and Theorem 3's partial repair
"$\mathfrak F^2$ is covariant". Sources read in full: `notes/ORDINAL_LADDER_SMALLNESS.md`,
`collab/messages/0766-seed165-ordinal-ladder.md`,
`collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md` §§A–G,
`collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md` §D,
`notes/FOUR_REPAIR_MODES.md` §1 and Theorems 1, 2, 3, 6.*

**Credit and provenance.** $\Diamond_\alpha$, $\partial$, $\delta$, $\Gamma$, $\Phi$, $\vee$,
$\ulcorner-\urcorner$, $\mathfrak F$, the ladder, the closure claim, the continuation rule and the
saturation clause are the **repository owner's** (D0016, D0018). The four repair modes and the torsor
theorem are the owner's classification made precise in `notes/FOUR_REPAIR_MODES.md`. The refutations
of §§1–6 of `notes/ORDINAL_LADDER_SMALLNESS.md` are seed165's. I derive from all of these, amend
nothing, and where I correct a *prior agent* note I say so in those words.

---

## 0. Verdict table

| # | question | verdict |
|---|---|---|
| 1.1 | Prop 9's claim that the ω-recursion is a *sequence* needing none of (W2)–(W5) | **CONFIRMED**, with the reading of $\partial$ made explicit (§1.1) |
| 1.2 | Prop 9's claim that its **colimit** exists under "$\Gamma_{\widehat{\phantom X}}$ + fixed coefficient tower" | **TRUE AND VACUOUS** — the direct system exists, and every $\delta^{(n)}$ dies in it (Thm A). Prior-agent correction, false-grounds class |
| 1.3 | $\mathfrak F^2$ is covariant | **CONFIRMED** as variance arithmetic, **conditional on $\mathfrak F$ being a functor, which it is not** (§2.1) |
| 2.1 | the even sub-ladder is a diagram | **REFUTED** — (W3) was necessary, not sufficient; (W1), (W2), (W4), (W5) survive into it unchanged (Thm B) |
| 2.2 | the even sub-ladder has a colimit | **REFUTED under D0016 §E; VACUOUS under D0018 §D** (Cor B.1) — under the reading that needs it, four obstructions remain; under the reading that repairs them, $\mathfrak F$ is already covariant and no sub-ladder is needed |
| 3.1 | the recursion defines a tree, not a sequence | **PROVED** (Prop C) |
| 3.2 | the tree is finitely branching, ≤ 4 modes ⇒ ≤ $4^n$ paths | **PARTIAL — the hint is false in general**: degree is $4\cdot|V^\Gamma|$; finitely branching **iff** $V^\Gamma$ finite; $\le 4^n$ **iff** $V^\Gamma=0$ (Prop C) |
| 3.3 | König's lemma gives termination information on the tree | **REFUTED** — the tree has **no leaves** ($\Gamma_\circlearrowleft$ is unconditionally available), so König's hypothesis is met by a constant branch and its conclusion is one we already exhibited (Prop D) |
| 3.4 | König gives anything on the **pruned** tree | **PROVED** — pointwise stabilisation ⇒ *uniform* stabilisation bound (Thm E). This is the one genuine use of König here |
| 4.1 | $\operatorname{Fix}(\mathfrak F^2)\ne\emptyset$ under §E | **REFUTED** by the same rank argument (Cor F.1); inherits seed165's universe soft spot |
| 4.2 | an object deserves the name $\mathbb B$ | **PARTIAL, and this is the positive result**: $\mathbb B^b$ per branch (non-canonical) and $\mathbb B^T$ over the whole choice tree (canonical), both under stated hypotheses (Thm F) |
| 4.3 | $\mathbb B^T$ is a closure, a fixed point, or self-improving | **NOT CLAIMED, and not available** (§4.3) |

Thirteen entries. Two are corrections of a prior *agent* note (1.2, 3.2); one (3.2) is a correction of
the mandate's own parenthetical guess, which standing check (a) exists to license.

---

## 1. The ω-recursion, verified and made precise

### 1.1 What Proposition 9 gets right

D0016 §C displays
$$\partial\Gamma_\alpha\langle\delta^{(n)}\rangle=\delta^{(n+1)},\qquad
\delta^{(0)}\xrightarrow{\Gamma}\chi^{(1)}\xrightarrow{\partial}\delta^{(1)}\to\cdots$$
Seed165 Prop 9 says this defines a sequence for $n<\omega$ once (Γ1) mode and (Γ2) lift are fixed,
"without any of (W2)–(W5): it needs no functoriality, no variance, no ambient, because it is a
recursion on *elements*, not on categories."

**I re-derived this and it is correct, with one thing that must be said aloud.** The $\partial$ in
this display is **not** §B's $\partial\Diamond_\alpha:=\int^{(f,t)}e_\alpha(f,t)$, whose domain is a
whole septuple. It is the boundary operator of the cell complex, since $\Gamma_\alpha$ lands in
$\operatorname{Cell}(\mathcal C_{\alpha+1})$ and $\partial$ is applied to a cell. This is the *same*
overloading seed165 recorded (its §1 preamble) for $\delta\circ\partial$, appearing a second time and
in a place where it is benign: with $\partial$ read as the cell boundary, $\delta^{(n)}\mapsto
\Gamma\langle\delta^{(n)}\rangle\mapsto\partial\Gamma\langle\delta^{(n)}\rangle$ type-checks. **Prop 9
is sound under that reading and under no other**, and it does not say so. I record this as a
sharpening, not a refutation: the proposition's conclusion stands.

The "no ambient" clause is also correct and worth stating carefully, because it is the whole reason
the fragment survives: a *sequence* is a function $n\mapsto\delta^{(n)}$, and its values are permitted
to live in different groups $A_0,A_1,A_2,\dots$. Nothing forces one ambient. That is exactly why
(W4) — the hypothesis that breaks the transfinite ladder — is not needed here. The recursion is a
recursion in the ordinary, well-founded, $\omega$-indexed sense, and needs only that each step's data
be supplied.

### 1.2 Correction: the colimit clause of Prop 9 is true and empty

Prop 9 continues: "Its colimit $\delta^{(\omega)}:=\operatorname{colim}_n(\partial\Gamma)^n\delta$
exists whenever the $\partial\Gamma$-images form a direct system in one fixed group — which they do
if $\Gamma$ is fixed to the mode $\Gamma_{\widehat{\phantom X}}$ with a fixed coefficient tower."

This is where the too-strong lemma is hiding, and it is hiding in the survivor rather than in the
demolition.

### Theorem A (in the completion mode, the ω-colimit of the defect sequence is trivial or undefined).
*Fix the mode to $\Gamma_{\widehat{\phantom X}}$ and let $V_0\subseteq V_1\subseteq V_2\subseteq\cdots$
be the coefficient tower it requires, with transition maps $\iota_n:V_n\to V_{n+1}$ and induced
$\iota_{n*}:H^1(\Gamma,V_n)\to H^1(\Gamma,V_{n+1})$. Then:*
1. *$\iota_{n*}[\delta^{(n)}]=0$ for every $n$;*
2. *consequently, either the family $\{\delta^{(n)}\}$ is a cocone over the direct system — which
   requires $\iota_{n*}[\delta^{(n)}]=[\delta^{(n+1)}]$ and therefore forces $[\delta^{(n)}]=0$ for
   all $n\ge1$, the ladder being constant from stage 1 — or it is not, in which case
   $\{\delta^{(n)}\}$ is a family of elements of different groups with **no colimit to take**.*
*In neither case does $\delta^{(\omega)}$ carry information not already present at stage 1.*

**Proof.** (1) is the definition of the mode. `notes/FOUR_REPAIR_MODES.md` Theorem 1: a completion
$\widehat f=f+R$ with $\widehat f|\gamma=\widehat f$ exists **iff** $[D]=0$ in $H^1(\Gamma,V)$; and
Theorem 2: $\Gamma_{\widehat{\phantom X}}$ is $\Gamma_\varnothing$ "bought honestly", i.e. the class is
killed by passing to a larger coefficient module $V\to V'$ with $\iota_*[D]=0$, the mode's
availability hypothesis being exactly that the enlargement has been made. So the tower is chosen
stage by stage precisely so that $\iota_{n*}$ annihilates $[\delta^{(n)}]$; that is what makes the
mode applicable at stage $n$ at all.

(2) A colimit of *elements* along a direct system means an element of
$\operatorname{colim}_nH^1(\Gamma,V_n)$ represented by a compatible family, i.e. one satisfying
$\iota_{n*}[\delta^{(n)}]=[\delta^{(n+1)}]$. Combined with (1) this gives $[\delta^{(n+1)}]=0$ for
every $n\ge0$. Without compatibility there is no diagram of elements and no colimit; the groups have
a colimit, the elements do not. $\square$

**Filed as a false-GROUNDS finding against a prior agent note, in the class standing check (d)
predicts.** Prop 9's clause is *true*: the $\partial\Gamma$-images do form a direct system in the
completion mode. What is false is the impression that this makes $\delta^{(\omega)}$ a meaningful
limit object. The very hypothesis that makes the direct system exist — that each stage's class dies
in the next coefficients — is the hypothesis that empties it. This is the same shape as seed165's own
Theorem 4/5 pair (one hypothesis, a flattering consequence and two unflattering ones), turned on the
note itself.

**Corollary A.1 (a second, independent refutation of D0018 §D's saturation clause).** D0018 §D
asserts $\partial\mathfrak R_\omega=0\Rightarrow$ संतृप्तिः. Seed165 Theorem 10 refuted it from
$\Phi$'s widening. Theorem A refutes it a second way, from **inside the surviving fragment**: in the
completion mode the antecedent is automatic — every defect class dies in the next coefficients by
construction — so the criterion declares saturation on every run, including runs that are visibly not
saturated because each stage produced a fresh nonzero $\delta^{(n+1)}$ in its own coefficients.
**A halting criterion whose antecedent is a definitional consequence of the step is not a halting
criterion.** The two refutations are independent: Thm 10 uses $\Phi$ and $\mathcal O$, this uses
$\Gamma$ and the coefficients, and neither is needed for the other.

### 1.3 When does the recursion terminate, stabilise, or run forever? — by mode

The mandate asks for termination conditions. They are entirely determined by which of the four modes
is in force, and the classification is clean. Availability hypotheses are
`notes/FOUR_REPAIR_MODES.md` §1.1, quoted not paraphrased.

| mode | availability | behaviour of the ω-recursion |
|---|---|---|
| $\Gamma_\circlearrowleft$ ($D\mapsto[D]\in H^1$) | **none — always available** | passes a cocycle to its class; a class is already a class, so the step is idle from $n=1$: the sequence **stabilises at $n=1$**, and is constant thereafter |
| $\Gamma_\varnothing$ ($[D]\mapsto0$) | needs a killing datum | $\delta^{(1)}=0$ by construction: **terminates at $n=1$**, at the price the mode's third column names (the invariant, hence any theorem using it) |
| $\Gamma_{\widehat{\phantom X}}$ (complete in enlarged coefficients) | $[D]=0$ in $H^1(\Gamma,V)$, arranged by enlargement | runs forever as a sequence of *elements of a growing tower*; its colimit is trivial or undefined (Thm A). **Non-terminating and non-informative** |
| $\Gamma_\Uparrow$ ($D\mapsto$ a 2-cell) | ambient admits enrichment **and** the coherence tower can be filled | **the only mode in which the recursion is genuinely infinite and genuinely informative** — and its $\delta^{(n)}$ are the coherence data $\alpha_{012},\beta_{0123},\dots$ of D0018 §D |

**The finding of §1.3, stated flatly.** *Three of the four modes make the ω-recursion trivial —
stabilising at step 1, terminating at step 1, or non-informative — and the fourth is exactly the
coherence tower whose termination `notes/FOUR_REPAIR_MODES.md` §1.2 declines to settle and seed165's
scope note excludes as "a different non-termination question".* So the surviving fragment's entire
non-trivial content sits in the one mode that no artifact in this corpus has analysed. That is not a
demolition of the fragment; it is a statement of where its content is, and it converts a vague
`PROGRAMME` item into a single named question: **does the $\Gamma_\Uparrow$ coherence tower
terminate?** Mac Lane coherence answers it in the monoidal case, $A_\infty$/operadic machinery in
general; I prove nothing about it and claim nothing about it.

---

## 2. The even sub-ladder

### 2.1 $\mathfrak F^2$ is covariant — verified, and its scope stated

$\vee$ reverses Chu transforms (Barr; Pratt — standard knowledge, no source read), so
$\mathfrak F=\ulcorner-\urcorner\circ\vee\circ\Phi\circ\Gamma\circ\delta\circ\partial$ has exactly one
contravariant factor and is contravariant; a composite of two contravariant functors is covariant.
**The variance arithmetic is correct.** But it is arithmetic *about functors*, and its hypothesis is
that $\mathfrak F$ is a functor of some variance. Seed165 Theorems 1 and 2 say it is not one of
either variance. So the statement verified is:

> *If* $\mathfrak F$ is a contravariant functor, *then* $\mathfrak F^2$ is a covariant one.

with an antecedent the same note refutes. Seed165 states the fragment honestly — "once §1.4's domain
problem is solved" — but names only §1.4. The next theorem says which obstructions actually survive,
which is the question the mandate asks and which that note left open (its §7 item 4, "Unexamined").

### Theorem B (variance was necessary, not sufficient: four obstructions survive into the even sub-ladder).
*Let $\mathfrak G:=\mathfrak F^2$ and consider the even family $\{\Diamond_{2\gamma}\}$ under D0016 §E.
Of the five hypotheses (W1)–(W5) of `notes/ORDINAL_LADDER_SMALLNESS.md` §2, passing to $\mathfrak G$
discharges **(W3) and only (W3)**. Specifically:*
- ***(W1) survives.** $\mathfrak G$ contains $\Gamma$ twice; each occurrence needs a mode and a lift
  (seed165 Thm 1). The even sub-ladder therefore needs **two** choices per step, not zero.*
- ***(W2) survives, and is fatal.** $\operatorname{Obs}$ is not functorial (seed165 Thm 2), so
  $\mathfrak F$ is defined **on objects only** and has no action on morphisms. A composite of two
  object-assignments is an object-assignment. "$\mathfrak G$ is covariant" is then a statement with no
  subject: there is no $\mathfrak G(u)$ whose direction could be forward. The obstruction is
  per-application and $\mathfrak G$ applies it twice.*
- ***(W4) survives.** $\mathfrak G_\alpha:\mathcal C_\alpha\rightsquigarrow\mathcal C_{\alpha+2}$.
  Doubling the step doubles the universe jump; $\mathfrak G$ is no more an endofunctor than
  $\mathfrak F$ is.*
- ***(W5) survives**, being a property of the ambient and untouched by which functor is iterated.*

**Proof.** Each clause is immediate from the cited theorem plus the observation that $\mathfrak G$ is
the twofold composite, so every factor of $\mathfrak F$ occurs in $\mathfrak G$ with its hypotheses
intact. For (W2): a functor is an assignment on objects *and* arrows satisfying two equations; if
$\mathfrak F$ has no arrow part then neither does $\mathfrak F\circ\mathfrak F$, and variance is a
property of the arrow part. $\square$

**Corollary B.1 (the even sub-ladder has no colimit, and the fragment has no application).**
*Under D0016 §E, $\operatorname{hocolim}_{\gamma<\lambda}\Diamond_{2\gamma}$ is not defined: by (W2)
there are no connecting morphisms at all, and by (W4) there is no category to index into. Under
D0018 §D's step $\mathfrak F=\Phi\circ\Gamma\circ\partial$ — no $\vee$ — $\mathfrak F$ is already
covariant, so the even sub-ladder is the ladder and the fragment says nothing. Hence: **the reading
in which $\mathfrak F^2$-covariance is needed is the reading in which it is insufficient, and the
reading in which it is sufficient is the one in which it is unnecessary.***

This answers the mandate's second bullet: **no, the even sub-ladder does not have a colimit**, and
the reason is that the other obstructions were never specific to the odd steps. Variance was one of
four independent failures; repairing it leaves three. I record that seed165 stated its fragment with
appropriate hedging and did not claim otherwise — this is a completion of an item it filed
`PROVE`/Unexamined, not a correction of it.

---

## 3. The choice tree

### Proposition C (the recursion is a tree; its branching, exactly).
*By seed165 Theorem 1, $\Gamma$ requires at each step (Γ1) a mode
$m\in\{\Gamma_\varnothing,\Gamma_\circlearrowleft,\Gamma_{\widehat{\phantom X}},\Gamma_\Uparrow\}$ and
(Γ2) a normalising lift, the set of which is empty or a torsor under $V^\Gamma$
(`notes/FOUR_REPAIR_MODES.md` Thm 3). Hence $\delta^{(n+1)}$ is a function of $\delta^{(n)}$ **and**
of the pair $(m,\ell)$, and the recursion defines a rooted tree $T$: nodes are finite choice
sequences $s=\langle(m_0,\ell_0),\dots,(m_{n-1},\ell_{n-1})\rangle$, ordered by prefix, carrying
defects $\delta^{(s)}$. The out-degree of a node is*
$$\deg(s)=\sum_{m\ \mathrm{available\ at}\ s}\#\{\text{lifts for }m\}\ \le\ 4\cdot|V^\Gamma|,$$
*with $\#\{\text{lifts}\}\in\{0\}\cup\{|V^\Gamma|\}$ by the torsor dichotomy. Consequently:*
- *$T$ is **finitely branching iff $V^\Gamma$ is finite at every node**;*
- *$\deg\le4$, and hence at most $4^n$ nodes at depth $n$, **iff $V^\Gamma=0$** — exactly the
  condition under which `notes/FOUR_REPAIR_MODES.md` Theorem 3 says reconstructibility holds on the
  nose;*
- *$T$ is uncountably branching whenever $V^\Gamma$ is infinite, e.g. $V^\Gamma\cong\mathbb C$ for the
  weight-0 smooth-function coefficients that appear in that note's Corollary 2.1.*

**Proof.** The tree structure is the definition of a recursion with a parameter chosen at each step;
the degree count is (Γ1) and (Γ2) and the torsor dichotomy. $\square$

**This corrects the mandate's parenthetical guess, and standing check (a) is why I state it rather
than adopt it.** "Four modes per step ⇒ at most $4^n$ paths" is **false in general**: it holds
exactly when $V^\Gamma=0$. It is *true in the corpus's motivating instance*, where $V_0$ is the
degree-$\le k-2$ polynomials for $\Gamma=\mathrm{SL}_2(\mathbb Z)$ and $k\ge4$, since that
representation has no nonzero invariants; and it is *false at the very next stage* of the same
example, where $V$ is enlarged to the smooth functions and constants become invariant. So the number
of choices is not a constant of the framework: **it changes along the ladder, and it changes for the
same reason the ladder's coefficient tower grows.** A count without its stage-dependence is the same
error `CLAUDE.md` names for a constant without its scaling.

### Proposition D (König's lemma is applicable and content-free on $T$).
*$\Gamma_\circlearrowleft$ has availability hypothesis "**none — always available**"
(`notes/FOUR_REPAIR_MODES.md` §1.1). Hence $\deg(s)\ge1$ for every node: $T$ **has no leaves**, so $T$
is infinite. König's lemma (finitely branching + infinite ⇒ an infinite branch exists) therefore
applies whenever $V^\Gamma$ is finite, and yields an infinite branch we have already exhibited by
hand — the constant branch that chooses $\Gamma_\circlearrowleft$ at every step. It yields nothing
else.*

**Proof.** Immediate. $\square$

I state this as a refutation of my own mandate's suggestion because it is one, and because the reason
is instructive: **König's lemma extracts an infinite object from the failure of finiteness, and here
finiteness never had a chance to fail informatively.** The lemma is a tool for trees whose leaves mean
something. To use it one must first make termination *be* leafhood.

### Theorem E (the one genuine use of König: pointwise stabilisation ⇒ uniform stabilisation).
*Let $T^\ast\subseteq T$ be the **pruned** tree: keep an edge $s\to s\frown(m,\ell)$ only if the step
is progressing, i.e. $\delta^{(s\frown(m,\ell))}\ne\delta^{(s)}$ under the identification in force at
$s$; a node with no progressing successor is a leaf, and leaves are exactly the stabilisation points.
Assume $V^\Gamma$ is finite at every node, so $T^\ast$ is finitely branching with
$\deg\le4\cdot|V^\Gamma|$. Then:*
$$\text{every choice sequence stabilises}\iff T^\ast\ \text{is finite}\iff \exists N<\omega\ \text{such that every run stabilises within}\ N\ \text{steps}.$$
*Equivalently, in the form that is usable: **either some choice sequence runs forever without
stabilising, or stabilisation is uniformly bounded.** There is no intermediate case in which every
run stabilises but the stabilisation times are unbounded.*

**Proof.** ($\Leftarrow$ both directions) trivial. ($\Rightarrow$) Every branch of $T^\ast$ is finite,
i.e. $T^\ast$ has no infinite branch; $T^\ast$ is finitely branching; by König's lemma
(contrapositive) $T^\ast$ is finite. A finite tree has finite height $N$, and every run is a branch,
hence of length $\le N$. $\square$

**This is the strongest statement I have about termination of the surviving fragment, and I want its
strength and its weakness both on the record.** Its strength: it converts a $\forall\exists$
statement (for every run there *is* a stabilisation time) into a single uniform bound, which is
exactly the kind of upgrade a compactness argument is for, and it is a statement the framework cannot
make about the transfinite ladder at all. Its weakness: the hypothesis "$V^\Gamma$ finite at every
node" fails in the corpus's own running example the moment the coefficients are enlarged
(Prop C), and Theorem A says the completion mode is precisely the mode that enlarges them. **So the
one place König bites is the one place the corpus's own instance does not reach.** I do not know
whether the hypothesis can be weakened; I have not tried a fan-theorem-style argument on the
uncountably branching case and I claim nothing there.

---

## 4. What deserves the name 𝔅

### 4.1 What does not

- **$\operatorname{Fix}(\mathfrak F)$** — empty (seed165 Thm 5).
- **Corollary F.1: $\operatorname{Fix}(\mathfrak F^2)$ is also empty.** Under the universe-raising
  hypothesis, $\mathfrak F^2$ carries $\mathcal U_\alpha$ to $\mathcal U_{\alpha+2}$; a fixed point
  would lie in $\mathcal U_{\alpha+2}\setminus\mathcal U_{\alpha+1}$ and in $\mathcal U_\alpha$,
  contradicting well-foundedness of universe membership. Proof identical to seed165 Thm 5. **So
  "a fixed point of $\mathfrak F^2$ relative to a chosen mode sequence" — one of the three candidates
  the mandate names — does not exist under §E**, and the sub-ladder does not rescue it.
- **$\operatorname{Closure}_{\mathscr L}(\Diamond_0)$** — not generated by $\Diamond_0$, since the
  choice sequence is an independent input (seed165 Thm 1). Proposition C is the sharp form: the
  closure of $\Diamond_0$ under $\mathscr L$ is a *tree*, and calling it an object requires selecting
  a branch.
- **$\int^{\alpha\in\mathbf{Ord}_{<\kappa}}\Diamond_\alpha$ for $\kappa>\omega$** — available only at
  the large-cardinal price of (S2) (seed165 Thm 7).

### 4.2 What does: two objects, both weaker than $\mathbb B$, both existing

Work under the hypotheses that are actually obtainable — which are D0018 §D's step, not D0016 §E's:

> **(H1)** $\mathfrak F=\Phi\circ\Gamma\circ\partial$ (D0018 §D): no $\vee$, no
> $\ulcorner-\urcorner$. Then $\mathfrak F$ is covariant and does not move the ambient.
> **(H2)** (W2) repaired: $\operatorname{Obs}$ replaced by the full $\mathcal I_n$, or the ambient
> restricted to a subcategory on which every $\mathcal I_n(\varphi)$ is injective on nonzero classes.
> **(H3)** The ambient $\mathcal C$ is cocomplete, or at least has colimits of the shapes named below.
> **(H4)** $V^\Gamma$ is a set at every node, so the tree $T$ of Proposition C is a small category.

Note that (H1)–(H4) are *hypotheses I am adding*, three of which seed165 already named as (W2)–(W5);
none is supplied by any transmission. Under them:

### Theorem F (the branch colimit and the tree colimit).
1. ***Per branch.** Let $b$ be an infinite branch of $T$, i.e. a choice sequence
   $\langle(m_n,\ell_n)\rangle_{n<\omega}$. The stages along $b$ form a genuine direct
   $\omega$-system $\Diamond^{(b\restriction0)}\to\Diamond^{(b\restriction1)}\to\cdots$ in $\mathcal C$,
   and*
   $$\mathbb B^b:=\operatorname*{hocolim}_{n<\omega}\Diamond^{(b\restriction n)}$$
   *exists by (H3). It is **not canonical**: distinct branches give distinct objects, and nothing in
   the framework selects a branch.*
2. ***Over the tree.** $T$, ordered by prefix, is a small poset. The assignment $s\mapsto
   \Diamond^{(s)}$ with the step maps on edges is a **functor $T\to\mathcal C$ with no coherence
   condition to check**, because between comparable nodes of a tree there is exactly one chain; a
   tree-shaped diagram is free on its edges. Hence*
   $$\mathbb B^T:=\operatorname*{colim}_{s\in T}\Diamond^{(s)}$$
   *exists by (H3)+(H4), and it **is canonical**: the choices have been absorbed into the index
   rather than made. For every branch $b$ there is a canonical map $\mathbb B^b\to\mathbb B^T$,
   induced by the inclusion of the chain $b$ as a subdiagram.*

**Proof.** (1) Under (H1) each step is a morphism in one fixed category and composition along the
chain is defined; (H2) supplies the arrow part; the diagram is of shape $\omega$, and (H3) gives the
colimit. (2) A poset diagram is a functor as soon as an arrow is assigned to each covering relation
and the assigned composites agree along every pair of parallel chains; in a tree there are no
parallel chains, so the condition is empty. Smallness is (H4). The map $\mathbb B^b\to\mathbb B^T$ is
the universal property of $\mathbb B^b$ applied to the restriction of $\mathbb B^T$'s cocone. $\square$

**$\mathbb B^T$ is the object I offer as the strongest true statement in the neighbourhood of the
owner's $\mathbb B$**, and I want it read with its limitations attached:

- It is a colimit over a **tree, not over an ordinal**. $T$ is connected but **not filtered** — two
  siblings have no common upper bound — so $\mathbb B^T$ inherits *none* of the good behaviour of a
  filtered colimit. In particular it commutes with nothing in general, and no accessibility argument
  applies to it. Kelly's transfinite construction of free algebras
  (nLab, *transfinite construction of free algebras*, read 2026-08-15) requires a locally presentable
  ambient, a **covariant endofunctor of a fixed category**, and accessibility — which is precisely
  seed165 Theorem 8's four hypotheses; $\mathbb B^T$ satisfies none of the parts about convergence
  and does not pretend to.
- Its content is exactly: *the universal recipient of every repair history, glued where the histories
  agree.* That is a real object and a modest one.
- It is **not** a fixed point, **not** a closure of $\Diamond_0$ under $\mathscr L$, and there is no
  claim that $\mathscr L(\mathbb B^T)\simeq\mathscr L(\Diamond_0)$.

### 4.3 The strongest true statement, in one sentence

> **Under D0018 §D's step (no $\vee$, no $\ulcorner-\urcorner$), a functorial obstruction, a
> cocomplete ambient, and $V^\Gamma$ a set, the repair process has a canonical colimit
> $\mathbb B^T$ over its own choice tree; it receives every branch colimit $\mathbb B^b$; it is not a
> fixed point of anything, it is not generated by $\Diamond_0$ alone in the sense the closure claim
> asserts (the tree is the generation, the object is only its colimit), and the index is a tree of
> height $\omega$, not an ordinal of height $\kappa$.**

That is much weaker than $\mathbb B$, and it is the expected shape of the result. The single most
useful thing it does is relocate the framework's ambition: **the owner's $\mathbb B$ wants to be an
object that improves itself; what exists is an index that records how it was improved, and a colimit
over that index.** The self-improvement is in $T$, not in $\mathbb B^T$.

---

## 5. What is not recoverable — for the successor, so this is not retried

Each of these was examined here or in `notes/ORDINAL_LADDER_SMALLNESS.md` and found unavailable. A
successor should re-open one only with a *new hypothesis*, named.

1. **$\mathbb B=\operatorname{Closure}_{\mathscr L}(\Diamond_0)$ as an object.** The choice tree is
   irreducible (Prop C). Not recoverable without a canonical mode-and-lift selection rule, which is
   extra structure no transmission supplies.
2. **Any fixed point: $\operatorname{Fix}(\mathfrak F)$, $\operatorname{Fix}(\mathfrak F^2)$, or of
   $\mathfrak F^k$ for any $k$**, under §E's universe-raising. Same rank argument, $k$ times
   (Cor F.1). *Scope: this and only this depends on seed165's flagged soft spot, §6 below.*
3. **A colimit of the even sub-ladder under §E.** Three obstructions survive $\mathfrak F^2$
   (Thm B). Not recoverable by any further even/odd bookkeeping, since (W1), (W2), (W4) are
   per-application.
4. **$\delta^{(\omega)}$ as an informative invariant in the completion mode.** Trivial or undefined
   (Thm A). Not recoverable inside that mode.
5. **D0018 §D's saturation clause in either direction.** Two independent refutations (seed165
   Thm 10; Cor A.1 here).
6. **Termination information from König's lemma on the unpruned tree.** No leaves (Prop D). Only
   the pruned form (Thm E) carries content.
7. **The transfinite extension past $\omega$ without a large-cardinal hypothesis.** Seed165 Thm 6/7,
   unchanged.

---

## 6. Scope limits and honesty ledger

- **Nothing here was computed.** No Python, no script, no numerical experiment, no measured or fitted
  quantity, no floating point. No Agda or Lean was authored and nothing is claimed typechecked. No
  PDF was decoded; the one external source consulted is the nLab page named in §4.2, which rendered
  and which I read. Barr/Pratt on Chu duality, König's lemma, Mac Lane coherence and Gödel's second
  incompleteness theorem are quoted from standard knowledge and flagged as such.
- **Prior art was searched before writing, not after** (`CLAUDE.md`): König's lemma, well-founded
  recursion, ω-chain colimits, and Kelly's transfinite construction. The last is the closest prior
  art to §4 and it *does not apply* — its hypotheses are seed165 Theorem 8's, and $\mathbb B^T$ is a
  non-filtered tree colimit precisely because those hypotheses are unavailable. I found no prior art
  for "colimit over the choice tree of a non-deterministic repair process" and I did not search
  exhaustively for one; the construction is elementary enough that its novelty is not a claim I make.
- **Prior claims were verified by reading the source, not the summary.** All four mandated documents
  were read in full or, for the transmissions, in the named sections plus their surrounding context
  (`D0016` §§A–G entire, `D0018` §D entire). `notes/FOUR_REPAIR_MODES.md` §1 and Theorems 1, 2, 3, 6
  were read and re-quoted; Theorems A and C rest on them and would fall if they fell.
- **Dependence on seed165's flagged soft spot.** That note reads "raises universe level" as universe
  *membership*, and flags this as its largest soft spot. **Only Corollary F.1 and item 2 of §5 depend
  on it.** Theorem A, Theorem B, Proposition C, Proposition D, Theorem E and Theorem F are
  independent of it: Thm B's (W4) clause needs only that the ambient *moves*, in any formalisation;
  the rest never mention universes. If $\ulcorner-\urcorner$ is instead an internal Gödel quotation
  and fixed points exist, §§1–3 and §4.2 stand unchanged and item 2 of §5 must be re-opened.
- **What I did not treat.** $\otimes$, $\operatorname{holim}$, D0016 §H's gem invariants, §I,
  the individual $\Phi$-factors, the Yang–Baxter defect, D0016 §F's Chu core, and the $\Gamma_\Uparrow$
  coherence tower — the last being, by §1.3, where the fragment's remaining content lives, and which
  I flag as the successor's target rather than pretend to have addressed. **I did not touch
  D0018 §J5's $\chi_\alpha$ or D0019 §C's $\rho(D\mathcal K)$, and I make no identification between
  them**; a prior pass showed they are not the same quantity.
- **Weakest step here.** Theorem F(2)'s claim that a tree-shaped diagram is free on its edges is
  correct for a poset diagram, but it presumes the tree order is the *only* order relation among the
  stages — i.e. that two distinct choice sequences never produce comparable stages that ought to be
  identified. If the framework wants $\Diamond^{(s)}\simeq\Diamond^{(s')}$ for distinct $s,s'$ with
  the same defect, the index is a quotient of $T$, the freeness argument lapses, and coherence
  conditions reappear. **I have not examined that quotient and $\mathbb B^T$ is stated for the free
  tree only.** This is the place to attack this note.
- **Concluding generalisation, offered as such and subject to audit.** Across §§1–4 the pattern is
  that every fragment seed165 certified survives as a *statement about the index* and none survives
  as a statement about an *object*: the ω-recursion is a tree, the even sub-ladder is a re-indexing
  that repairs nothing else, and the strongest $\mathbb B$-like object is a colimit whose interest is
  entirely carried by the shape it is taken over. If that generalisation is right, the framework's
  next move is combinatorial rather than categorical — analyse $T$ — and the way to test it is §1.3's
  single question about $\Gamma_\Uparrow$.
