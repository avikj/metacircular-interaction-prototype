# The four undefined conjuncts of Advance: three definitions, one clean negative, and a collapse theorem

**Status.** Proved. Two prior theorems re-derived from scratch; one new identification
lemma; three definitions given with independence witnesses; one clean negative
(`UsefulEscape` admits no definition of the required kind in the Chu language); one
collapse theorem that governs all four at once; a decidability verdict with its exact
scope.

**Verdict in one line — check it against §§4–8, not against itself.** The escape route the
prior pass found — *anchor the comparison to a fixed external datum instead of to the
predecessor stage* — **generalises to all four conjuncts, and to none of them for free**:
it makes each definable, but a second theorem (§7, the Collapse) shows that any conjunct
expressible as a function of $(\sim_{\mathcal T_\alpha},\text{anchor})$ is, on precisely
the stages where $\operatorname{SearchSep}$ holds, **decided by the anchor alone**. What
survives the collapse is not the anchoring but the **granularity** of the anchor: a
conjunct has content on Advancing runs iff its definition quantifies over *proper subsets*
of $\mathcal T_\alpha$ (citations) or over data outside the Chu structure altogether (a
declared code). So: $\operatorname{Verify}$ and $\operatorname{PreserveProv}$ are defined
and non-trivial **only in their citation-rigid readings**;
$\operatorname{DeclaredBoundaryPreserved}$ is defined but **collapses to a property of the
declaration**; $\operatorname{UsefulEscape}$ **has no definition in the language** and
needs a datum the framework does not carry. With the definitions in hand,
$\operatorname{Advance}$ is **decidable on ledgered stages and is not a function of
$\Diamond_\alpha$ at all** (§8) — and decidability is not progress (§9).

**Source and credit.** $\operatorname{Advance}$, its five conjuncts, the signature
$\Diamond_\alpha$, the gem invariants and the widening-observable clause are the
**repository owner's**:
`collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md` **§A, §B, §F, §G, §H**
and `collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md` **§A, §D**. I derive
from them and amend nothing. Two arguments below turn on owner text the previous pass did
not use: **D0018 §A's four preservation clauses** supply the missing argument list of
$\operatorname{PreserveProv}$ (§5.1), and **D0018 §A's $\operatorname{gain}(\sigma)$**
is the only candidate anchor for $\operatorname{UsefulEscape}$ that is not fitted (§6.4).

**Predecessors.** `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` (seed149, Theorems A–F, the §8
proposal) and `notes/ADVANCE_UNDER_REPLACEMENT.md` (seed154, Theorems F′, 2–6). Theorems 3
and 5 of the latter are re-derived in §2 rather than cited, per mandate.

---

## 0. Standing hypotheses

Inherited from seed154 §0, unchanged, and I re-list them because §7 and §8 turn on which
are in force.

- **(H1)** $\mathcal C=(X,\mathcal T,e)$ a Chu space, $e:X\times\mathcal T\to Q$; finite
  wherever a count or a counterexample is asserted.
- **(H2)** $x\sim_S x'\iff\forall t\in S,\ e(x,t)=e(x',t)$.
- **(H3)** Holonomies $\mathfrak h_\sigma\in\operatorname{Aut}(X)$.
- **(H4)** $D_\sigma(x)=\{t:e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$,
  $\delta_\sigma(S)=\{x:D_\sigma(x)\cap S\ne\emptyset\}$.
- **(H5)** Replacement inside one ambient test universe with one $e$.
- **(H6)** Fixed carrier, or a canonical $\iota:X_\alpha\to X_{\alpha+1}$ along which
  $\sim_{\alpha+1}$ is pulled back. **New sub-hypothesis used below: (H6i)** $\iota$ is
  *injective*. Seed154 did not need it; §7.2 does, and I flag where.
- **(H7)** Holonomy-richness (every transposition realised). Used only where named.

**The language.** By *the Chu language* $\mathscr L_{\mathrm{Chu}}$ I mean exactly what the
earlier notes fixed: $X$, $\mathcal T$, $e$, the relations $\sim_S$ for $S\subseteq\mathcal T$,
the defects $\delta_\sigma$, the obstruction $\operatorname{Ob}$, the closure operators
$C_\sigma$ of Theorem C, and the resolving-power preorder $S\sqsubseteq S'\iff\ \sim_{S'}\subseteq\sim_S$.
Nothing else. When a definition below needs more, I say what and call it a *further datum*.

---

## 1. The kernel remark, stated once because everything uses it

**Lemma 0 (defects are a function of resolving power).** For every $\sigma$ and every
$S\subseteq\mathcal T$,
$$\delta_\sigma(S)=\{x\in X:\ \mathfrak h_\sigma x\not\sim_S x\}.$$

*Proof.* $x\in\delta_\sigma(S)$ iff $\exists t\in S$ with $e(\mathfrak h_\sigma x,t)\ne e(x,t)$,
which is the negation of $\mathfrak h_\sigma x\sim_S x$. $\square$

This is seed149's Remark 1.1; I restate it as a lemma because it is the reason
"$\delta$-based" and "$\sim$-based" are the *same* restriction, and every no-go below is
really about $\sim$.

---

## 2. Verification of the two inherited theorems, re-derived

Per mandate. I proved both from (H1)–(H6) and then compared with seed154.

### 2.1 seed154 Theorem 3 (SearchSep forbids incomparability) — correct.

*Claim.* If $\sim_{\mathcal T_\alpha}=\Delta_X$ then for every $\mathcal T_{\alpha+1}$ the
step is $\operatorname{Blunt}$ ($\sim_\alpha\subseteq\sim_{\alpha+1}$); dually for $\nabla_X$.
Hence $\operatorname{Incomparable}\Rightarrow\operatorname{SearchSep}(\mathcal T_\alpha)=0$.

*Proof.* $\sim_{\mathcal T_{\alpha+1}}$ is an equivalence relation on $X$, hence reflexive,
hence contains $\Delta_X=\sim_{\mathcal T_\alpha}$. That is literally the definition of
$\operatorname{Blunt}$. The dual: every equivalence relation is contained in $\nabla_X$.
Comparability in both cases; contrapositive gives the last clause. $\square$

**Verified**, and the proof uses *only* that $\Delta_X,\nabla_X$ are the bounds of the
equivalence lattice — not (H7), not Theorem 2, not the realisability Lemma. Seed154's
proof is the same one. **No circularity:** Theorem 3 does not invoke Theorem 5, and
Theorem 5 does not invoke Theorem 3.

*One arrow-direction check (standing check (e)).* Seed154 writes
$\operatorname{Incomparable}\Rightarrow\Delta_X\subsetneq\sim_{\mathcal T_\alpha}\subsetneq\nabla_X$
as an implication and **not** as a biconditional. The converse is false: $|X|=3$,
$\sim_\alpha=\{12\mid3\}$ is strictly between the bounds, and the step to
$\sim_{\alpha+1}=\nabla$ is $\operatorname{Blunt}$, not Incomparable. Seed154 did not claim
otherwise. No upgrade found.

### 2.2 seed154 Theorem 5 ($\delta$ constant along Advancing runs) — correct, and sharpenable.

*Claim.* $\operatorname{SearchSep}$ at both ends $\Rightarrow$
$\delta_\sigma(\mathcal T_{\alpha+1})=\delta_\sigma(\mathcal T_\alpha)$ for every $\sigma$.

*Proof.* Both $\sim$'s equal $\Delta_X$; apply Lemma 0 to each. $\square$

**Verified.** And Lemma 0 gives more than constancy — it gives the value:

**Lemma 1 (identification of the defect on a separating stage).** If
$\operatorname{SearchSep}(\mathcal T_\alpha)=1$ then for every $\sigma$
$$\delta_\sigma(\mathcal T_\alpha)=\operatorname{supp}(\mathfrak h_\sigma):=\{x:\mathfrak h_\sigma x\ne x\},$$
and hence $\operatorname{Ob}_\alpha=\int^{\sigma}\operatorname{supp}(\mathfrak h_\sigma)$
depends only on the chart $\rho_\alpha$, not on the instrument $\mathcal T_\alpha$ at all.

*Proof.* $\sim_{\mathcal T_\alpha}=\Delta_X$, so $\mathfrak h_\sigma x\not\sim x$ iff
$\mathfrak h_\sigma x\ne x$; substitute into Lemma 0. $\square$

This is strictly stronger than "constant" and it is what makes §6's negative sharp: on a
separating stage the defect is not merely uninformative about progress, it is *not a
function of the instrument*. Seed154 asserted constancy; the identification is new here
and is a one-line consequence of a lemma seed154 already had. **Ground:** Lemma 0 and (H2).

---

## 3. The design constraints, stated as obligations

A candidate definition $P$ for a conjunct must meet all of:

- **(C1) Typed.** $P$ has a declared arity and every argument is a component the framework
  either carries or is told to carry.
- **(C2) Expressed in $\mathscr L_{\mathrm{Chu}}$**, or else the further datum is named.
- **(C3) Non-vacuous and non-trivial.** There is a stage/step where $P$ holds and one where
  it fails — exhibited, finitely, not asserted.
- **(C4) Not true by construction.** $\operatorname{Advance}$ must not become derivable from
  the other conjuncts or from the definition's own shape. Where it does, I reject the
  definition and say so.
- **(C5) Survives Theorems F, F′ and seed154 Theorem 5.** F/F′ kill monotone functions of
  $\sim$ alone; seed154 Theorem 5 kills *any* function of $\sim$ on Advancing runs, monotone or not
  (§7). This is a stronger filter than F′ and it is the operative one here.

(C3) is the classical *vacuity* requirement of temporal model checking — Beer, Ben-David,
Eisner and Rodeh, *Efficient Detection of Vacuity in Temporal Model Checking* (CAV'97 /
FMSD 18(2), 2001; I read the Toronto course PDF's abstract and problem statement via
search summary, not the full paper — see §10). I import the standard, not a result.

---

## 4. $\operatorname{Verify}(\Pi_\alpha)=1$

### 4.1 Type

Unary on a stage — the owner writes the argument, and it is $\Pi_\alpha$, the sixth
component of $\Diamond_\alpha$ (D0016 §A). D0016 supplies no type for $\Pi_\alpha$ and no
verification relation; that is the whole of the difficulty. **The minimal typing under
which $\operatorname{Verify}$ is a predicate at all**, and the one I adopt, is that a proof
is a *claim together with its citations*.

**Definition 1 (proof record, claim, citation).** A *proof record* at stage $\alpha$ is a
pair $\pi=(c_\pi,S_\pi)$ with $S_\pi\subseteq\mathcal T_\alpha$ (the *citation*, the tests
the proof actually invokes) and $c_\pi$ a *claim*, one of
$$\operatorname{sep}(x,x')\quad\text{or}\quad\operatorname{id}(x,x'),\qquad x,x'\in X_\alpha .$$
$\Pi_\alpha$ is a finite set of proof records.

**Definition 2 ($\operatorname{Verify}$).**
$$\operatorname{Verify}(\Pi_\alpha)=1\iff\forall\pi\in\Pi_\alpha:\quad
\begin{cases} x\not\sim_{S_\pi}x' & \text{if }c_\pi=\operatorname{sep}(x,x')\\
x\sim_{S_\pi}x' & \text{if }c_\pi=\operatorname{id}(x,x').\end{cases}$$

**(C2).** Definition 2 is in $\mathscr L_{\mathrm{Chu}}$: it uses only $\sim_S$ for
$S\subseteq\mathcal T_\alpha$. The *further datum* is not a new mathematical primitive but a
**record**: the stage must carry, for each proof, which tests it cited and what it claimed.
The framework as typed in D0016 §A does not carry it; §8 prices this.

**Why the citation, and not "$\Pi_\alpha$ is verified by $\mathcal T_\alpha$".** Because the
latter is exactly what Theorem K destroys (§7). The citation is a *proper subset* of the
instrument, and $\operatorname{SearchSep}$ constrains $\sim_{\mathcal T_\alpha}$ while
saying nothing whatever about $\sim_{S}$ for $S\subsetneq\mathcal T_\alpha$. This is the
whole trick and it recurs in §5.

### 4.2 Non-vacuity, non-triviality, and independence — finite witnesses

Let $Q=\{0,1\}$.

**(W1) fails, with $\operatorname{SearchSep}=1$.** $X=\{x,y\}$, $\mathcal T=\{t_1,t_2\}$,
$e(x,t_1)=0,\ e(y,t_1)=1,\ e(x,t_2)=e(y,t_2)=0$. Then $\sim_{\mathcal T}=\Delta_X$, so
$\operatorname{SearchSep}=1$. Take $\Pi=\{(\operatorname{sep}(x,y),\{t_2\})\}$. Since
$\sim_{\{t_2\}}=\nabla_X$ we have $x\sim_{\{t_2\}}y$, so $\operatorname{Verify}(\Pi)=0$.

**(W2) holds, same Chu space.** $\Pi'=\{(\operatorname{sep}(x,y),\{t_1\})\}$:
$e(x,t_1)\ne e(y,t_1)$, so $\operatorname{Verify}(\Pi')=1$.

**(W3) holds, with $\operatorname{SearchSep}=0$.** $X=\{x,y,z\}$, $\mathcal T=\{t\}$ with
$e(x,t)=0$, $e(y,t)=1$, $e(z,t)=1$. Then $\sim_{\mathcal T}=\{x\mid yz\}\ne\Delta$, so
$\operatorname{SearchSep}=0$; and $\Pi=\{(\operatorname{sep}(x,y),\{t\}),(\operatorname{id}(y,z),\{t\})\}$
verifies.

**Proposition 1.** $\operatorname{Verify}$ (Definition 2) is non-vacuous and non-trivial,
and is **logically independent** of $\operatorname{SearchSep}$: all four combinations of
truth values are realised. *Proof.* (W1) gives $(\operatorname{Verify},\operatorname{SearchSep})=(0,1)$;
(W2) gives $(1,1)$; (W3) gives $(1,0)$; and (W3) with the citation of its first record
replaced by $\emptyset$ gives $(0,0)$, since $\sim_\emptyset=\nabla_X$. These are complete
finite checks on three- and two-element sets, hence proof per `CLAUDE.md`, not measurement. $\square$

**(C4): does $\operatorname{Advance}$ become true by construction?** No. (W1) is a stage at
which $\operatorname{SearchSep}=1$ and $\operatorname{Verify}=0$, so
$\operatorname{Advance}$ fails there; the definition therefore does not make the conjunct a
consequence of the others. Nor is it satisfied by everything, by (W1). **Accepted.**

**(C5).** $\operatorname{Verify}$ is a function of the pair $(\Pi_\alpha,e_\alpha)$ and
*not* a function of $\sim_{\mathcal T_\alpha}$ — (W1) and (W2) have the same Chu space,
hence the same $\sim_{\mathcal T}$, the same $\delta$-family and the same
$\operatorname{Ob}$, and differ in $\operatorname{Verify}$. Theorems F, F′ and seed154 Theorem 5
therefore do not reach it. **This is the escape of the prior pass, generalised**: $\Pi_\alpha$
is the fixed anchor, and it is fixed *relative to the stage*, which is enough, because the
comparison is between the anchor and a sub-instrument rather than between two stages.

### 4.3 What it costs

Each stage must record: for every proof, the set of tests it used and the pair of points it
claims about. Formally, an injection $\Pi_\alpha\to\mathcal P(\mathcal T_\alpha)\times\bigl((X\times X)\sqcup(X\times X)\bigr)$.
Checking is $O(|\Pi_\alpha|\cdot\max_\pi|S_\pi|)$ evaluations of $e$. No history is needed:
$\operatorname{Verify}$ is genuinely unary.

---

## 5. $\operatorname{PreserveProv}=1$

### 5.1 Type — the prior pass's typing is confirmed, and the owner supplies the argument list

Seed154 §3.3 observes that D0016 §G writes this conjunct **with no argument**, and argues
that "preservation" is two-place so the only type-correct completion is a predicate on the
pair. **I verify this and I can now do better than infer it**, because D0018 §A states the
clause list explicitly for a *step*:
$$\text{अर्थरक्षा}\wedge\text{भेदरक्षा}\wedge\text{प्रमाणरक्षा}\wedge\text{रूपपुनर्जननम्},$$
glossed by the owner as *preserve meaning ∧ preserve distinction ∧ preserve proof ∧
regenerate form*, attached to $\mathfrak L_{\alpha+1}=\mathfrak C(\mathfrak L_\alpha\cup\ulcorner\Delta_\alpha\urcorner)$
— that is, to the transition $\alpha\to\alpha+1$. **$\operatorname{PreserveProv}$ is
प्रमाणरक्षा, and the owner's own presentation gives it a step as argument.** So the type is
binary on a step, confirmed twice over, and it is not my invention.

*Ambiguity I do not silently resolve.* "Prov" reads either as **provability** (D0018 §A's
प्रमाण) or as **provenance** (D0016 §B's $\delta^{\mathrm{prov}}_\sigma$). I take the first
as primary, on the ground that D0018 §A names it in a clause list of exactly this shape. The
second reading has the *same arity and the same shape* — a map of origin-tagged records
preserving origins — so nothing below depends on the choice except the reading of $\Pi$.
I flag it and do not choose for the owner.

### 5.2 Two definitions, and they are not equivalent

Fix (H6): $\iota:X_\alpha\to X_{\alpha+1}$. Write $\iota\cdot\operatorname{sep}(x,x')
:=\operatorname{sep}(\iota x,\iota x')$, likewise for $\operatorname{id}$.

**Definition 3a (citation-rigid).** $\operatorname{PreserveProv}^{\mathrm{rig}}(\Diamond_\alpha\to\Diamond_{\alpha+1})=1$
iff there exists $j:\Pi_\alpha\to\Pi_{\alpha+1}$ with, for every $\pi\in\Pi_\alpha$:
1. $c_{j\pi}=\iota\cdot c_\pi$, and
2. $S_{j\pi}$ is an *$\iota$-lift* of $S_\pi$: every $t\in S_\pi$ has some $t'\in S_{j\pi}$
   with $e_{\alpha+1}(\iota x,t')=e_\alpha(x,t)$ for all $x\in X_\alpha$, and every
   $t'\in S_{j\pi}$ arises this way from some $t\in S_\pi$.

**Definition 3b (free re-citation).** $\operatorname{PreserveProv}^{\mathrm{free}}=1$ iff
for every $\pi\in\Pi_\alpha$ with $\operatorname{Verify}_\alpha(\pi)=1$:
$c_\pi=\operatorname{sep}(x,x')\Rightarrow\iota x\not\sim_{\mathcal T_{\alpha+1}}\iota x'$, and
$c_\pi=\operatorname{id}(x,x')\Rightarrow\iota x\sim_{\mathcal T_{\alpha+1}}\iota x'$.

**Lemma 2 (rigid preserves verification pointwise).** Under Definition 3a,
$\iota^*\!\sim_{S_{j\pi}}\ =\ \sim_{S_\pi}$ on $X_\alpha$, for every $\pi$. Hence
$\operatorname{Verify}_\alpha(\Pi_\alpha)=1$ and $\operatorname{PreserveProv}^{\mathrm{rig}}=1$
imply that every $j\pi$ verifies at stage $\alpha+1$.

*Proof.* If $\iota x\sim_{S_{j\pi}}\iota x'$ then all $t'\in S_{j\pi}$ agree on them; by
condition 2 every $t\in S_\pi$ is $e$-matched by some such $t'$, so $x\sim_{S_\pi}x'$;
conversely by the other half of condition 2. Both claim forms then transport. $\square$

**Proposition 2 (the implication holds one way and for one claim form only — stated as an
arrow, not a biconditional).** $\operatorname{PreserveProv}^{\mathrm{rig}}=1$ implies the
$\operatorname{sep}$-half of $\operatorname{PreserveProv}^{\mathrm{free}}=1$, and **does not**
imply its $\operatorname{id}$-half.

*Proof.* Sep: $x\not\sim_{S_\pi}x'$ gives, by Lemma 2, $\iota x\not\sim_{S_{j\pi}}\iota x'$,
and $\sim_{\mathcal T_{\alpha+1}}\subseteq\sim_{S_{j\pi}}$ since $\sim$ is antitone in the
test set; so $\iota x\not\sim_{\mathcal T_{\alpha+1}}\iota x'$. Id: from
$\iota x\sim_{S_{j\pi}}\iota x'$ nothing follows about the finer $\sim_{\mathcal T_{\alpha+1}}$.
Counterexample: $X_\alpha=X_{\alpha+1}=\{x,y\}$, $\iota=\operatorname{id}$,
$\mathcal T_\alpha=\{t_2\}$ constant, $\mathcal T_{\alpha+1}=\{t_2,t_1\}$ with $t_1$
separating; $\pi=(\operatorname{id}(x,y),\{t_2\})$ verifies at $\alpha$, $j\pi=\pi$ is a
rigid lift, and $x\not\sim_{\mathcal T_{\alpha+1}}y$. $\square$

*(Standing check (e). I record explicitly that Proposition 2 is an implication with a named
exception, and that I have not upgraded it. The asymmetry is real: separation claims are
monotone under refinement, identification claims are monotone under blunting, and no single
step is monotone for both unless $\sim$ is unchanged.)*

**Proposition 3 (sufficient conditions).**
(a) $\mathcal T_\alpha\subseteq\mathcal T_{\alpha+1}$ with $\iota$ the identity and
$e_{\alpha+1}$ extending $e_\alpha$ $\Rightarrow$ $\operatorname{PreserveProv}^{\mathrm{rig}}=1$
(take $j$ the identity on records).
(b) $\operatorname{Refine}$ $\Rightarrow$ the $\operatorname{sep}$-half of
$\operatorname{PreserveProv}^{\mathrm{free}}$; $\operatorname{Blunt}$ $\Rightarrow$ its
$\operatorname{id}$-half. *Proof:* antitonicity of $\sim$ in $S$ and the definitions of
Refine/Blunt. $\square$

### 5.3 Non-vacuity and (C4)

**(W4) fails.** $X=\{x,y\}$, $\iota=\operatorname{id}$, $\mathcal T_\alpha=\{t_1,t_2\}$ as
in (W1), $\Pi_\alpha=\{(\operatorname{sep}(x,y),\{t_1\})\}$ (verified);
$\mathcal T_{\alpha+1}=\{t_2\}$ — a *recut* in D0016 §D's sense, which discards $t_1$. Then
no $t'\in\mathcal T_{\alpha+1}$ is an $\iota$-lift of $t_1$, so no $j$ exists and
$\operatorname{PreserveProv}^{\mathrm{rig}}=0$; and $x\sim_{\mathcal T_{\alpha+1}}y$, so
$\operatorname{PreserveProv}^{\mathrm{free}}=0$ too.
**(W5) holds.** The same with $\mathcal T_{\alpha+1}=\{t_1,t_2,t_3\}$, $t_3$ arbitrary:
Proposition 3(a). $\square$

**(C4).** $\operatorname{Advance}$ is not true by construction: (W4) is a step whose source
stage has $\operatorname{SearchSep}=1$ and $\operatorname{Verify}=1$ and at which
$\operatorname{PreserveProv}$ fails. **Accepted, in the rigid reading.** The free reading is
rejected in §7.2, for a reason that is not (C4) but the Collapse.

### 5.4 Cost

Both readings need the citation record of §4.3 at **both** stages, plus the transport datum:
$\iota$, and — for the rigid reading — the witnessing map $j$ and the lift correspondence on
tests. In practice this is exactly a *provenance ledger*: every test at $\alpha+1$ records
which test at $\alpha$ it re-presents, if any. Checking rigid preservation given $j$ is
$O(|\Pi_\alpha|\cdot|S|\cdot|X_\alpha|)$; without $j$ it is a search over maps
$\Pi_\alpha\to\Pi_{\alpha+1}$, finite and therefore decidable, but not cheap. Recording $j$
is the difference between checking and searching, and it costs one field per proof.

---

## 6. $\operatorname{UsefulEscape}>0$ — the clean negative

### 6.1 Type

Binary on a step. Ground: D0016 §H, the owner's gloss —
trapped-light $\iff\Delta\partial_{\mathrm{future}}=0$, productive-reflection
$\iff\Delta\partial_{\mathrm{future}}\ne0\wedge\operatorname{Verify}=1$. A $\Delta$ of a
stage quantity is a step quantity. It is the only conjunct carrying an order ($>0$), hence
the only one shaped like a progress measure.

### 6.2 The negative

**Theorem U (no $\sim$-expressible $\operatorname{UsefulEscape}$).** Assume (H5), (H6). Let
$U$ assign to each step a value in a poset with a distinguished element $0$, and suppose $U$
depends on the step only through the triple $(\sim_{\mathcal T_\alpha},\iota,\sim_{\mathcal T_{\alpha+1}})$
— equivalently, by Lemma 0, only through the two defect families. Then $U$ takes **one and
the same value** $u^\star$ on every step whose two ends both satisfy
$\operatorname{SearchSep}$ and whose $\iota$ is the identity. Consequently, restricted to the
steps of a run on which $\operatorname{Advance}$ holds at every stage, the conjunct
"$U>0$" is **satisfied by all of them** (if $u^\star>0$) or **by none** (otherwise): it is
vacuous or unsatisfiable, and in neither case is it a criterion.

*Proof.* By §2.2, $\operatorname{SearchSep}$ at an end forces $\sim=\Delta_X$ there. So for
every such step the argument triple is $(\Delta_X,\operatorname{id},\Delta_X)$, one fixed
tuple; $U$ is a function of it. $\square$

**Ground and strength.** Theorem U does **not** use Theorems F or F′, and it does not assume
$U$ monotone. It is strictly stronger than Proposition 3 of seed154 on this point: F′ kills
*monotone* functions of resolving power; Theorem U kills *all* functions of resolving power,
on the runs at issue, because the argument is constant there. This is the promised
strengthening and it is where the mandate's question — does the fixed-anchor escape
generalise? — gets its sharp answer for this conjunct: **no anchor helps, because it is the
non-anchor argument that has collapsed.**

### 6.3 The two evasions, and why both fail

**(a) Read $e$ beyond $\sim$.** One could count independent tests,
$\operatorname{Res}(\mathcal T):=|\mathcal T/\!\sim_{\mathcal T\text{-dual}}|$, using D0016 §F's
dual separation $t\sim_T t'\iff\forall x\,e(x,t)=e(x,t')$ — the column-deduplication half of
Pratt's *biextensional collapse*. This is not a function of $\sim_X$ and so escapes both F′
and Theorem U.

**Proposition 4 (and it should not be used).** $\operatorname{Res}$ is not invariant under
recoding of $Q$, hence is a property of the presentation and not of the instrument's power
to distinguish. *Proof.* $X=\{x,y\}$, $\mathcal T=\{t_1,t_2\}$, $Q=\{0,1\}$, with columns
$e(-,t_1)=(0,1)$ and $e(-,t_2)=(1,0)$. Both induce the partition $\{x\mid y\}$; the columns
differ, so $\operatorname{Res}=2$. Apply the bijection $0\leftrightarrow1$ of $Q$ to the
$t_2$ column only — a relabelling of that test's readout, which changes no distinction the
test makes — and the columns coincide: $\operatorname{Res}=1$. $\square$
A quantity that moves when one renames a dial's markings is not measuring the dial.
**Rejected.**

**(b) Read the boundary $\partial$.** D0016 §B defines $\partial\Diamond_\alpha=\int^{(f,t)\in\mathcal F\times\mathcal T}e(f,t)$.
This is a coend, and a coend requires the enrichment: which category $e$ lands in, and what
the functoriality of $e$ in $(f,t)$ is. **D0016 supplies neither.** Over a bare set $Q$ with
$\mathcal F\times\mathcal T$ discrete the coend degenerates to a coproduct
$\coprod_{(f,t)}e(f,t)$, whose only invariant is a cardinality — and a cardinality of the
index set, at that, so $\Delta\partial\ne0$ reduces to "the stage changed size", which is
satisfied by every non-trivial recut and fails (C3)'s non-triviality in the direction of
being satisfied by too much. **A $\partial$-based definition is possible in principle and is
unavailable in fact**, and the missing datum is exactly: *the enriching category of $e$ and
the functoriality making $\int^{(f,t)}$ a coend rather than a coproduct.* That is the
smallest thing the framework would have to add. I state it as the gap and do not fill it.

### 6.4 What would suffice, and the side condition without which it is worthless

The one candidate anchor in the owner's own text that is exact rather than fitted is D0018
§A:
$$\operatorname{gain}(\sigma)=L(\mathfrak Q)-L(\mathfrak Q\mid\sigma)-L(\sigma),\qquad
\operatorname{gain}(\sigma)>0\Rightarrow\sigma\in\mathfrak L_{\alpha+1}.$$

**Definition 4 (conditional, not adopted here).** Fix, *in advance and for the whole run*, a
computable code $L$. Put $\operatorname{UsefulEscape}(\alpha\to\alpha+1):=\sum_{\sigma\in\mathfrak L_{\alpha+1}\setminus\mathfrak L_\alpha}\operatorname{gain}(\sigma)$.

**Proposition 5 (the side condition, and it is the whole content).** Definition 4 satisfies
(C1)–(C3) and evades Theorem U — $\operatorname{gain}$ is not a function of $\sim$ — **iff
$L$ is declared before the run**. If $L$ is permitted to be chosen at or after the step,
then for any step introducing at least one new sign $\sigma$ one may choose $L$ assigning
$\sigma$ a short code and $\mathfrak Q\mid\sigma$ a shorter description, making
$\operatorname{gain}(\sigma)>0$; the conjunct is then satisfiable at every step by
construction and (C4) is violated.

*Proof.* The "only if" is the displayed construction; the "if" is that with $L$ fixed,
$\operatorname{gain}$ is a determinate integer-valued function of the two stages, and both
signs occur (a sign that is longer than the compression it buys has $\operatorname{gain}<0$). $\square$

**Verdict for $\operatorname{UsefulEscape}$, stated as a negative because that is what it
is.** *There is no definition of $\operatorname{UsefulEscape}$ in $\mathscr L_{\mathrm{Chu}}$
that is non-vacuous on Advancing runs.* Theorem U is the proof. The further datum required is
**one of**: (i) a run-fixed code $L$, giving Definition 4 with Proposition 5's side
condition; or (ii) the enrichment making $\partial$ a coend, giving a
$\Delta\partial_{\mathrm{future}}$ reading per D0016 §H. The framework as transmitted carries
neither. **I define nothing here and I adopt nothing**; Definition 4 is stated as a
conditional so the owner can supply or refuse $L$.

*On D0018 §J5.* $\chi_\alpha$ is untouched: not measured, not rehabilitated, not cited as
support for anything above. Proposition 5 is the general statement of why a
declared-in-advance $L$ and a fitted post-hoc one are different objects, and it is the reason
I gave $\operatorname{UsefulEscape}$ a side condition rather than a value.

---

## 7. $\operatorname{DeclaredBoundaryPreserved}=1$, and the Collapse that governs all four

### 7.1 Type and definition

Type (ii′) of seed154: binary on (fixed external declaration, current stage) — *not* on a
pair of stages. "Declared" is the operative word; the anchor does not move.

**Definition 5.** A *declared boundary* is a pair $\partial_{\mathrm{decl}}=(D_{\mathrm{sep}},D_{\mathrm{id}})$
of disjoint sets of unordered pairs from $X_0$: the distinctions that must be kept and the
identifications that must be kept. With $\iota_\alpha:X_0\to X_\alpha$ the composite
transport,
$$\operatorname{DeclaredBoundaryPreserved}(\Diamond_\alpha)=1\iff
\begin{cases}\forall\{x,x'\}\in D_{\mathrm{sep}}:&\iota_\alpha x\not\sim_{\mathcal T_\alpha}\iota_\alpha x'\\
\forall\{x,x'\}\in D_{\mathrm{id}}:&\iota_\alpha x\sim_{\mathcal T_\alpha}\iota_\alpha x'.\end{cases}$$

**(C2)** satisfied, with the further datum being $\partial_{\mathrm{decl}}$ and $\iota_\alpha$
— both external to the Chu space and both, by hypothesis, fixed.
**(C3)** Witnesses: with $X=\{x,y\}$ and $D_{\mathrm{sep}}=\{\{x,y\}\}$, the stage of (W1)
satisfies it and the stage $\mathcal T=\{t_2\}$ of (W4) does not.
**(C4)** Not true by construction: the same two stages.

**Monotonicity, for the record.** The $D_{\mathrm{sep}}$ half is an up-set for $\sqsubseteq$
(preserved by Refine); the $D_{\mathrm{id}}$ half is a down-set (preserved by Blunt).
Together the predicate is monotone in neither direction — correct behaviour for an anchor,
which is a *constraint*, not a *measure*. Seed154 §3.5's observation that
$S\mapsto[\sim_S\subseteq\sim_{\partial_{\mathrm{decl}}}]$ is monotone and non-constant is the
$D_{\mathrm{sep}}$-only special case, and it is right at that scope.

### 7.2 The Collapse

Here is the theorem the mandate's question was really asking for, and its answer is not the
comfortable one.

**Theorem K (Collapse).** Assume (H6), (H6i). Let $P$ be any predicate on stages of the form
$$P(\Diamond_\alpha)=\widehat P\bigl(\sim_{\mathcal T_\alpha},A\bigr)$$
for a datum $A$ that does not depend on $\alpha$ (a *fixed anchor*, of any kind: a
declaration, a code, a history-independent parameter). Then on every stage at which
$\operatorname{SearchSep}(\mathcal T_\alpha)=1$,
$$P(\Diamond_\alpha)=\widehat P(\Delta_X,A),$$
**a function of the anchor alone**. In particular $P$ is constant along any run on which
$\operatorname{Advance}$ holds, it distinguishes no two such stages, and as a conjunct of
$\operatorname{Advance}$ it is either implied by $\operatorname{SearchSep}$ or contradicts it.

*Proof.* $\operatorname{SearchSep}(\mathcal T_\alpha)=1$ means $\sim_{\mathcal T_\alpha}=\Delta_X$
by definition; substitute. (H6i) is used only to know that the pulled-back relation on the
common carrier is still $\Delta$. $\square$

**Corollary K.1 ($\operatorname{DeclaredBoundaryPreserved}$ collapses).** On a stage with
$\operatorname{SearchSep}=1$:
$$\operatorname{DeclaredBoundaryPreserved}(\Diamond_\alpha)=1\iff D_{\mathrm{id}}\subseteq\Delta_{X_0},$$
i.e. iff the declaration demanded no non-trivial identification. Hence within
$\operatorname{Advance}$ the conjunct is **vacuous** when $D_{\mathrm{id}}$ is trivial and
makes $\operatorname{Advance}$ **unsatisfiable** when it is not. It never discriminates
between two Advancing stages.

*Proof.* $\sim_{\mathcal T_\alpha}=\Delta$: the $D_{\mathrm{sep}}$ clause holds
automatically (any two distinct points are separated, using (H6i) for
$\iota_\alpha x\ne\iota_\alpha x'$), and the $D_{\mathrm{id}}$ clause holds iff every
declared identification is of a point with itself. $\square$

**Corollary K.2 (the free reading of $\operatorname{PreserveProv}$ collapses).** If
$\operatorname{SearchSep}$ holds at both ends of a step and $\iota$ is injective, then
$\operatorname{PreserveProv}^{\mathrm{free}}=1$ for every $\operatorname{sep}$-claim, and
holds for $\operatorname{id}$-claims iff there are no non-diagonal ones. So Definition 3b
adds nothing to $\operatorname{Advance}$. *Proof.* As Corollary K.1, applied at $\alpha+1$. $\square$

**Corollary K.3 (the free reading of $\operatorname{Verify}$ collapses).** Had we defined
$\operatorname{Verify}$ by "every claim of $\Pi_\alpha$ is verified by the whole instrument
$\mathcal T_\alpha$", then $\operatorname{SearchSep}(\mathcal T_\alpha)=1$ would imply
$\operatorname{Verify}(\Pi_\alpha)=1$ for all $\operatorname{sep}$-claims. **This is why
Definition 2 cites a subset.** $\square$

### 7.3 What the Collapse means — the honest reading

The prior pass identified the right escape hatch and drew the wrong boundary around it.
Anchoring against a fixed external datum does make the conjuncts **definable** — that much
generalises, and §§4, 5, 7.1 are three instances of it. It does **not** make them
**informative**, because the argument they are anchored *against* — $\sim_{\mathcal T_\alpha}$
— is pinned to $\Delta_X$ by the $\operatorname{SearchSep}$ conjunct sitting beside them in
the same conjunction. $\operatorname{SearchSep}=1$ is an extremely strong demand: it says the
instrument is already maximal in the lattice. Everything expressible through $\sim$ is then
determined, and Theorem K is just that observation taken seriously.

**So the surviving criterion is not "anchored" but "sub-instrumental or extra-structural":**

| conjunct | anchored? | argument that survives $\operatorname{SearchSep}$ | verdict |
|---|---|---|---|
| $\operatorname{Verify}$ (Def. 2) | yes, to $\Pi_\alpha$ | $\sim_{S_\pi}$ for $S_\pi\subsetneq\mathcal T_\alpha$ | **survives** — sub-instrumental |
| $\operatorname{PreserveProv}^{\mathrm{rig}}$ (Def. 3a) | yes, to $(\Pi_\alpha,j)$ | the lift relation on tests | **survives** — sub-instrumental |
| $\operatorname{PreserveProv}^{\mathrm{free}}$ (Def. 3b) | yes | none | collapses (Cor. K.2) |
| $\operatorname{UsefulEscape}$ | — | none in $\mathscr L_{\mathrm{Chu}}$ | **no definition exists** (Thm U); needs $L$ or the enrichment |
| $\operatorname{DeclaredBoundaryPreserved}$ (Def. 5) | yes, to $\partial_{\mathrm{decl}}$ | none | collapses (Cor. K.1) |

$\operatorname{SearchSep}$ is not one conjunct among five. It is a hypothesis strong enough
to trivialise every sibling conjunct that speaks only of the whole instrument.

---

## 8. Is $\operatorname{Advance}$ decidable?

**Definition 6 (ledgered stage / ledgered step).** A *ledgered stage* is
$\Diamond_\alpha$ together with $\Pi_\alpha$ in the sense of Definition 1. A *ledgered step*
is a ledgered stage at each end together with $\iota$, the transport $j:\Pi_\alpha\to\Pi_{\alpha+1}$
with its test-lift correspondence, the declared boundary $\partial_{\mathrm{decl}}$ with
$\iota_\alpha$, and (if the owner supplies it) the run-fixed code $L$.

**Theorem D (verdict, two halves).**

**(a) $\operatorname{Advance}$ is not a function of $\Diamond_\alpha$.** Two ledgered stages
with the *same* septuple $(X,\mathcal F,\mathcal T,e,\rho,\Pi,\mathcal O)$ except for the
ledger differ in $\operatorname{Advance}$. *Proof:* (W1) and (W2) have identical
$X,\mathcal T,e$ and identical claim sets, differing only in the citation field, and give
$\operatorname{Verify}=0$ and $=1$. Since $\Pi_\alpha$ as typed in D0016 §A carries no
citation field, the septuple does not determine $\operatorname{Advance}$. $\square$
**Hence no datum about $(\mathcal T_\alpha,\mathcal T_{\alpha+1})$ decides it** — seed154's
Corollary 4.1 confirmed, now with a witness rather than by absence of definitions.

**(b) On ledgered stages with $X,\mathcal T,\Pi,\partial_{\mathrm{decl}}$ finite and $L$
computable, $\operatorname{Advance}$ is decidable.** *Proof.* Conjunct by conjunct:
$\operatorname{SearchSep}$ is $\sim_{\mathcal T_\alpha}=\Delta_X$, decided by $\le\binom{|X|}{2}|\mathcal T|$
evaluations of $e$. $\operatorname{Verify}$ (Def. 2) is decided by $\sum_\pi|S_\pi|$
evaluations. $\operatorname{PreserveProv}^{\mathrm{rig}}$ (Def. 3a) with $j$ recorded is
decided by checking conditions 1–2, finitely; with $j$ unrecorded it is an existential over
the finite set of maps $\Pi_\alpha\to\Pi_{\alpha+1}$, hence still decidable (and this is the
only conjunct whose cost is exponential in the ledger rather than polynomial — recording $j$
removes that). $\operatorname{DeclaredBoundaryPreserved}$ (Def. 5) is decided by
$|D_{\mathrm{sep}}|+|D_{\mathrm{id}}|$ separation tests. $\operatorname{UsefulEscape}$ is
decided iff Definition 4's $L$ is supplied and computable; **without $L$ it is not decided,
because it is not defined** (Theorem U). $\square$

**The verdict, stated at the generality I can defend.**

> With Definitions 1, 2, 3a and 5, **four of the five conjuncts of D0016 §G become decidable
> predicates on ledgered stages and steps, and the fifth does not**, because
> $\operatorname{UsefulEscape}$ has no definition in the Chu language at all (Theorem U) and
> the framework supplies neither of the two data that would give it one. So
> $\operatorname{Advance}$ is decidable **conditionally on the owner declaring a code $L$ in
> advance** (Definition 4, Proposition 5), and is **undecided — indeed undefined —
> otherwise**. It is in no case a function of $\Diamond_\alpha$ as D0016 §A types it
> (Theorem D(a)): the septuple must be extended by the citation, transport and declaration
> ledger, and that extension is the real cost of the criterion.
>
> Further, of the four conjuncts that are or can be defined, **two do no work**: given
> $\operatorname{SearchSep}$, $\operatorname{DeclaredBoundaryPreserved}$ is decided by the
> declaration alone (Cor. K.1) and the free reading of $\operatorname{PreserveProv}$ is
> automatic (Cor. K.2). $\operatorname{Advance}$ is therefore, on its intended runs,
> effectively the three-conjunct predicate
> $\operatorname{SearchSep}\wedge\operatorname{Verify}\wedge\operatorname{PreserveProv}^{\mathrm{rig}}$,
> plus a fourth conjunct awaiting a declared code.

---

## 9. Decidable is not progress — the scope limit that matters most

Every conjunct above is a predicate on a step. Nothing above produces a **well-founded
measure**, and the classical point is that a step predicate and a termination argument are
different objects: Floyd's method (*Assigning Meanings to Programs*, 1967) and Turing's 1949
note require a map into a well-founded order that strictly decreases, and this is what
progress measures in the verification literature supply. Theorem F′ of seed154 says no such
map exists as a function of resolving power; Theorem U here says the same on Advancing runs
without even the monotonicity hypothesis. **So $\operatorname{Advance}$, even fully defined
and decided at every step, licenses no claim that the run converges, saturates, or reaches
$\mathbb B$.** The transmission's $\operatorname{hocolim}_\alpha$ is not underwritten by
$\operatorname{Advance}$, and I claim no such underwriting.

**Other scope limits.**
- **(H6i) is new and load-bearing** in Corollaries K.1–K.2. If the transport $\iota$ is
  non-injective — and $\Gamma$'s pushout gives no guarantee that it is — the collapse
  arguments lapse, and so does seed154 Theorem 5 with them.
- **Definition 1 is a choice.** $\Pi_\alpha$ may be intended as something richer than
  claims-with-citations. What I prove is: (i) *some* citation-like record is necessary, since
  without one Corollary K.3 makes $\operatorname{Verify}$ vacuous; (ii) claims-with-citations
  is *sufficient* to make it non-vacuous. I do not claim it is the owner's intent.
- **The provability/provenance ambiguity of §5.1 is unresolved** and is the owner's.
- **Everything is conditional on §7 of seed154's discrepancy** — whether $\Phi_{\mathrm{cut}}$
  enlarges or recuts, and whether $\mathfrak F$ contains $\vee$. If $\vee$ is present, (H5)
  fails, $\sqsubseteq$ has no truth value across the step, and Definitions 3a and 5 lose their
  arguments along with everything else. That question is still open and still the owner's.
- **Untouched:** D0018 §J5's $\chi_\alpha$; the ordinal ladder D0016 §C;
  $\delta_\triangleleft/\delta_\triangleright$; the Yang–Baxter defect; the Tate construction;
  D0017 entirely.
- **No numbers, no measurement, no fitted constant, no floating point, no Python. No Agda or
  Lean authored; no typechecking claimed.** Every witness (W1)–(W5) and Propositions 1, 4 are
  complete finite enumerations on sets of size $\le3$, written out.

---

## 10. Prior art, searched before writing

Searched: vacuity in verification; biextensional collapse; proof-carrying certificates and
preservation of certificates across a change of theory; progress measures and termination
orders. What I actually read, and at what depth:

- **Vacuity.** Beer, Ben-David, Eisner, Rodeh, *Efficient Detection of Vacuity in Temporal
  Model Checking* (CAV'97, LNCS 1254, 279–290; FMSD **18**(2):141–163, 2001). I read a search
  summary of the abstract and problem statement (antecedent failure; a formula valid for the
  wrong reason), not the paper — the copies located are PDFs, which do not decode here, and I
  claim no acquaintance with the construction of $w(\phi)$. My requirement (C3) is their
  standard, imported; **no novelty claimed** for the idea that a criterion satisfied for the
  wrong reason is a defect.
- **Biextensional collapse.** Pratt's Chu-space notes and the standard definition — a Chu
  space is *separable* when rows are distinct, *extensional* when columns are distinct,
  *biextensional* when both, and the collapse deduplicates rows and columns. Read via search
  summaries of Pratt's Stanford notes and the nLab *Chu construction* page; I quote no
  numbered result. This is the source of §6.3(a)'s $\operatorname{Res}$, and Proposition 4 is
  the observation that the column half of the collapse is not $Q$-recoding-invariant — which
  I assume is folklore, and state as folklore.
- **Proof-carrying code / certificates.** The certificate-transport pattern of Definition 3a
  — carry the evidence with the object and re-check it after the transformation — is exactly
  PCC's, and incremental/abstraction-carrying code (Albert et al., *Some Issues on Incremental
  Abstraction-Carrying Code*, arXiv cs/0701111) is the literature on *preserving* certificates
  across a change. **Located by search, abstracts only.** I claim no novelty for the pattern;
  what is new here is only that citation-rigidity is what stops the conjunct collapsing
  (Cor. K.3), which is a statement about this framework.
- **Progress measures and termination.** Floyd 1967, Turing 1949, and ordinal-indexed
  termination; §9 uses them only to state a scope limit. **Not re-searched:** Galois
  connections, FCA, partition lattices, Ellerman — seed149 §10 and seed154 §9 did that, I read
  both, and Lemma 0 and the lattice bounds are cited from there as classical.

**What is new here, briefly.** (1) Lemma 1: the defect on a separating stage *equals* the
holonomy support, so it is not a function of the instrument at all. (2) Theorem U: no
$\sim$-expressible $\operatorname{UsefulEscape}$, proved without monotonicity — strictly
stronger than the F′ route. (3) Theorem K, the Collapse, and its three corollaries: the
fixed-anchor escape confers definability but not information, and the real dividing line is
sub-instrumental versus whole-instrument. (4) Definitions 1, 2, 3a, 5, with independence
witnesses. (5) Theorem D(a): $\operatorname{Advance}$ is not a function of the D0016 §A
septuple — witnessed, not inferred from missing definitions. Items (1)–(3) are elementary
once posed; I would rather say so.

---

## 11. What this note licenses

> Give $\Pi_\alpha$ a citation field and the framework acquires two working conjuncts;
> withhold it and $\operatorname{Verify}$ and $\operatorname{PreserveProv}$ are vacuous the
> moment $\operatorname{SearchSep}$ holds. Give $\operatorname{DeclaredBoundaryPreserved}$
> its natural fixed-anchor definition and it is decided by the declaration alone.
> $\operatorname{UsefulEscape}$ has no definition in the Chu language, and the two data that
> would supply one — a run-fixed code, or the enrichment that makes $\partial$ a coend —
> are both absent from the transmissions. $\operatorname{Advance}$ is decidable on stages
> extended by a ledger, undecidable-because-undefined without a declared code, and never a
> function of $\Diamond_\alpha$ as typed. And decidability is not descent: no well-founded
> measure has been produced, and none exists in the resolving-power language.

Not licensed: any claim that Definitions 1–5 are the owner's intent; any claim about
$\chi_\alpha$; any claim that a run satisfying $\operatorname{Advance}$ at every stage
converges to anything.

---

*Framework, $\operatorname{Advance}$, the four preservation clauses and $\operatorname{gain}$:
the repository owner, D0016 §A/§B/§F/§G/§H and D0018 §A/§D, 2026-08-14. Theorems A–F: seed149.
Theorems F′, 2–6 of the prior pass: seed154; its Theorems 3 and 5 re-derived in §2 above.
Lemma 1, Theorems U, K, D, Propositions 1–5, Definitions 1–6: this note. No experiment was run.*
