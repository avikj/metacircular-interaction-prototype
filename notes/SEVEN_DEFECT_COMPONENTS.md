# The seven components of $\delta_\sigma$: what they are, what they cannot be, and why seven does no work

**Seed164, 2026-08-15.** Question and framework: the repository owner, D0016 §B
(`collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md`). This note derives
from that artifact and does not amend it.

**Item worked.** `notes/OWNER_TRANSMISSIONS_LEDGER.md` §1.12 — *"the seven components:
**OPEN**. What would settle it: a statement of what each component *is* as a function of
$(X,\mathcal T,e,\rho)$; at present they are seven names."* Nobody had looked.

**Predecessors read in full before writing** (standing check (b): every claim attributed
below was verified by reading the file, not by reading a summary of it):
`notes/SHRINKING_TESTS_LOWER_CURVATURE.md` (Def. 1.1–1.7, Thm 1–5, Thm 3/Cor 4.2, E1, E2,
E2′, §5A, §6, §7, §7A);
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md` (Thm A–F, Def. 6.1, Thm E, Prop. 6.3);
`notes/ADVANCE_CONJUNCTS_DEFINED.md` (Def. 1–5, Lem. 2, Prop. 2–3, Thm K and Cor. K.1–K.3);
`notes/OWNER_TRANSMISSIONS_LEDGER.md` §1.1–§1.14.

---

## Verdict summary

| D0016 §B claim | Verdict |
|---|---|
| $\delta_\sigma$ is a 7-tuple: what structure? | **PROVED: a product of *heterogeneously typed* lattices, not a filtration.** §2, §6. |
| $\delta_\sigma=0\not\Leftarrow\delta^{\mathrm{base}}_\sigma=0$ | **PARTIAL, split named.** TRUE and already proved (Thm 3/E2/E2′ of the predecessor) when $\delta^{\mathrm{base}}$ is a *proper* sub-family of components; **FALSE** when the components are jointly exhaustive. §3, Thm 1. |
| $\pi\mathfrak H_\sigma=1\wedge\widetilde{\mathfrak H}_\sigma\ne1\Rightarrow$ hidden curvature | **CLASSICAL — it is the predecessor's Thm 3 restated.** Not a strictly stronger claim, not a different one. §4. Per D0016 §J6 and the corpus rule, *translation is not a result.* |
| Seven components, well-defined | **PARTIAL: 4 of 7 have a referent** ($\mathrm{sem}$ outright; $\mathrm{proof},\mathrm{boundary},\mathrm{prov}$ on named added data). $\mathrm{charge}$ has **no referent**. $\mathrm{resource}$, $\mathrm{info}$ have no referent, and their only natural completions are **functions of $\delta^{\mathrm{sem}}$** (§5.6–5.7). |
| Seven components, independent | **PROVED for the definable pair** $(\mathrm{sem},\mathrm{prov})$: all four vanishing patterns realised on $|X|=2,|\mathcal T|=1$. §6. **REFUTED for $(\mathrm{sem},\mathrm{info})$** under any full-support measure. §5.7. |
| Seven components, exhaustive | **OPEN and not settleable as posed** — exhaustiveness $\iff$ joint injectivity of a decomposition of $Q$ that nobody has supplied. §3, Cor. 1.2. |
| **Does "seven" do any work?** | **NO.** §3 Thm 1 shows every claim in §B is a statement about one projection and its complement. Two coordinates suffice for all of it; the number 7 is inert. §7. |

---

## 1. What the language already fixes, and what §B adds

The Chu language settled by the two predecessor notes is:

- $\mathcal C=(X,\mathcal T,e)$, $e:X\times\mathcal T\to Q$ (Def. 1.1);
- $\sim_S$ for $S\subseteq\mathcal T$ (Def. 1.2), $\rho$ and $\mathfrak h_\sigma\in\operatorname{Aut}(X)$ (Def. 1.3–1.4);
- the **resolution** $r=(S,\pi)$ with $S\subseteq\mathcal T$, $\pi:Q\to Q_r$ any function, and
  $$\delta^r_\sigma=\{x\in X:\exists t\in S,\ \pi e(\mathfrak h_\sigma x,t)\ne\pi e(x,t)\},$$
  ordered by $r'\preceq r$ iff $S'\subseteq S$ and $\pi'=\varphi\pi$ (Def. 4.1);
- Thm 3: $r'\preceq r\Rightarrow\delta^{r'}_\sigma\subseteq\delta^{r}_\sigma$.

**This is exactly the language a component projection speaks.** A "component" of $\delta_\sigma$
is nothing other than a resolution. §B adds one thing and one thing only: the assertion that
there is a *distinguished family* of seven of them. So the whole content of §B is:

> what happens to $\delta$ when it is read through a **family** of resolutions rather than one?

That question has a complete answer, and it is short.

---

## 2. The structure question: product, filtration, or list?

**Definition 2.1 (component family).** A *component family* is a set
$R=\{r_k=(S_k,\pi_k)\}_{k\in K}$ of resolutions of $\mathcal C$. It induces
$$\delta^R_\sigma:=\bigl(\delta^{r_k}_\sigma\bigr)_{k\in K}\ \in\ \prod_{k\in K}\mathcal P(X),$$
ordered componentwise. Write $\delta^{\mathrm{tot}}_\sigma:=\delta^{(\mathcal T,\mathrm{id}_Q)}_\sigma$.

**Proposition 2.2 (it is a product, and the order is forced).** $\prod_k\mathcal P(X)$ with the
componentwise order is the unique order on tuples making each coordinate projection monotone
and making $\delta^R$ monotone in $R$ under $\preceq$ coordinatewise. There is no filtration:
a filtration would require the coordinates to be linearly comparable, and §6 exhibits two
coordinates that are incomparable in both directions on a two-point Chu space.

*Proof.* Componentwise order is the product in the category of posets, so monotonicity of the
projections is its universal property. Incomparability is §6. $\square$

**Remark 2.3 (the type hygiene the transmission omits — and it is not a quibble).** $\delta^R_\sigma$
is a product of *seven different sets*, only the first of which is $\mathcal P(X)$:
$\delta^{\mathrm{proof}}$ (§5.2) is naturally valued in $\mathcal P(\Pi)$, the powerset of the
*proof record set*, and $\delta^{\mathrm{boundary}}$ (§5.4) in $\mathcal P(D_{\mathrm{sep}}\sqcup D_{\mathrm{id}})$.
Consequently:

- "$\delta_\sigma=0$" is meaningful (each factor has a bottom, namely $\emptyset$), and
- $\mathfrak H_\sigma\ominus1$ is **not** meaningful componentwise: there is no $\ominus$, no
  norm, no scalar shadow $\|\cdot\|$ comparable across coordinates, and no way to add the
  seven numbers. Any future statement of the form "the defect is large in the resource
  coordinate and small in the semantic one" is asking for an order between incomparable
  types, and is not licensed.

So the answer to *product / filtration / list* is: **product of heterogeneously typed
bounded lattices.** The mandate asks whether that reading makes §B's non-implication
"trivially true but empty". It does not — but for a reason more interesting than the mandate's,
and it is the next section.

---

## 3. The theorem: exhaustiveness dissolves hidden curvature

This is the note's content. It is a two-line proof and an exact converse by finite construction.

**Definition 3.1 (uniform family; joint injectivity).** $R=\{(S,\pi_k)\}_{k\in K}$ is *uniform*
if all components use the same test set $S$. The family $\{\pi_k\}$ is *jointly injective* on $Q$
if $\pi_k q=\pi_k q'$ for all $k$ implies $q=q'$ — equivalently, $\langle\pi_k\rangle:Q\to\prod_kQ_k$
is injective; equivalently, $R$ is a *point-separating (initial) source* on $Q$ in the standard
categorical sense.

**Theorem 1 (join formula, and the exact dichotomy).** Let $R=\{(S,\pi_k)\}_{k\in K}$ be uniform.
Then for every $\sigma$
$$\bigcup_{k\in K}\delta^{(S,\pi_k)}_\sigma\ \subseteq\ \delta^{(S,\mathrm{id})}_\sigma,$$
with **equality for every $\mathcal C$, every $\rho$ and every $\sigma$ if and only if
$\{\pi_k\}_{k\in K}$ is jointly injective.**

*Proof.* ($\subseteq$) Each $(S,\pi_k)\preceq(S,\mathrm{id})$, so this is Thm 3 of the
predecessor applied $k$-fold, then unioned.

($\Leftarrow$, equality under joint injectivity.) Let $x\in\delta^{(S,\mathrm{id})}_\sigma$,
witnessed by $t\in S$ with $e(\mathfrak h_\sigma x,t)\ne e(x,t)$. By joint injectivity these two
values of $Q$ are separated by some $\pi_k$, so $x\in\delta^{(S,\pi_k)}_\sigma$.

($\Rightarrow$, failure of joint injectivity gives a witness.) Suppose $q\ne q'$ with
$\pi_kq=\pi_kq'$ for all $k$. Put $X=\{x_0,x_1\}$, $\mathcal T=S=\{t\}$, $e(x_0,t)=q$,
$e(x_1,t)=q'$; $I=\{0,1\}$, $\rho_{01}=\mathrm{sw}$, $\rho_{10}=\mathrm{id}$, and
$\sigma=(0,1,0)$, so $\mathfrak h_\sigma=\mathrm{sw}$ (Rem. 5.3 of the predecessor). Then
$e(\mathfrak h_\sigma x_0,t)=q'\ne q=e(x_0,t)$, so $\delta^{(S,\mathrm{id})}_\sigma=\{x_0,x_1\}$,
while $\pi_ke(\mathfrak h_\sigma x_i,t)=\pi_ke(x_i,t)$ for every $k$ and every $i$, so
$\delta^{(S,\pi_k)}_\sigma=\emptyset$ for all $k$. The union is empty and the total is not.
$\square$

**Corollary 1.1 (hidden curvature, exactly characterised).** For a uniform family $R$, the
configuration *"every component vanishes but the total does not"* — D0016 §B's
$\pi\mathfrak H_\sigma=1\wedge\widetilde{\mathfrak H}_\sigma\ne1$, read over the whole family —
is **realisable iff $\{\pi_k\}$ is not jointly injective**, and is then realisable on a Chu
space with $|X|=2$, $|\mathcal T|=1$.

**Corollary 1.2 (the transmission cannot have both, stated precisely).** Read §B's tuple as the
*definition* of $\delta_\sigma$ — i.e. the seven components are claimed **exhaustive**, so that
knowing the tuple is knowing the defect. Exhaustiveness in the only sense that makes that claim
true is joint injectivity of $\{\pi_k\}_{k=1}^7$. But then, by Theorem 1,
$$\delta^R_\sigma=0\ \iff\ \delta^{\mathrm{tot}}_\sigma=0,$$
and hidden curvature over the full family is **impossible**. Conversely, if hidden curvature over
the full family occurs, the seven components are **not** exhaustive: the tuple is a lossy
instrument and $\delta_\sigma$ is not recoverable from it.

So §B's two displays are not in contradiction, but they are in *tension*, and the tension is
resolved in exactly one way: **§B's $\pi$ must be a projection onto a proper sub-family.**

**Corollary 1.3 (the non-implication, split named — this is the PARTIAL).** Let
$J\subsetneq K$ and $\delta^{\mathrm{base}}_\sigma:=(\delta^{r_k}_\sigma)_{k\in J}$.
1. If $J=K$ (or more generally if $\{\pi_k\}_{k\in J}$ is already jointly injective), then
   $\delta_\sigma=0\Leftarrow\delta^{\mathrm{base}}_\sigma=0$ **holds**, and §B's non-implication
   is **FALSE**.
2. If $\{\pi_k\}_{k\in J}$ is not jointly injective, the non-implication **holds**, and the
   forward implication $\delta_\sigma=0\Rightarrow\delta^{\mathrm{base}}_\sigma=0$ also holds
   (Cor. 4.2 of the predecessor). So D0016's one-directional arrow is correctly oriented —
   *and this was already established*; see §4.

*(Standing check (e). Corollary 1.3(2) is an implication with a stated one-directional
converse-failure. I have not upgraded it to a biconditional, and Theorem 1's "if and only if"
is quantified over all $\mathcal C,\rho,\sigma$ — it is **not** an iff at a fixed Chu space,
where a non-injective family can perfectly well have $\bigcup_k\delta^{r_k}=\delta^{\mathrm{tot}}$
by accident. That quantifier is load-bearing and is stated in the theorem.)*

**Remark 1.4 (non-uniform families).** If the $S_k$ differ, $\bigcup_k\delta^{(S_k,\pi_k)}_\sigma
\subseteq\delta^{(\bigcup_kS_k,\mathrm{id})}_\sigma$ still holds and can be strict *even for a
jointly injective $\{\pi_k\}$* — the gap now comes from the test coordinate rather than the value
coordinate. This is not a third phenomenon: $(S_k,\pi_k)\preceq(\bigcup S_k,\mathrm{id})$ in the
predecessor's single order, which unifies the two directions (its §4). It is the reason §4 below
returns CLASSICAL.

---

## 4. Is the hidden-curvature claim the predecessor's result restated? Yes.

The mandate asks whether §B's $\pi\mathfrak H_\sigma=1\wedge\widetilde{\mathfrak H}_\sigma\ne1$
is `SHRINKING_TESTS_LOWER_CURVATURE.md`'s result, a strictly stronger one, or a different one.
I read §4 (Def. 4.1, Thm 3, Cor. 4.2) and §5 (E2, E2′) and compared them line by line.

**It is that result.** Precisely:

- E2 (§5) is the case $\pi:Q\to\{*\}$, one test, $|X|=2$: $\delta^{\mathrm{base}}=\emptyset$,
  $\delta^{\mathrm{tot}}=X$. The predecessor's own text names it: *"This is the transmission's
  hidden curvature ($\pi\mathfrak H_\sigma=1\wedge\widetilde{\mathfrak H}_\sigma\ne1$), now with
  a two-by-one witness."* The identification is the predecessor's, not mine.
- E2′ (§5, seed148's, restored by the seed150 merge) is the case $Q=\{0,1\}^2$ read as
  $(\mathrm{sem},\mathrm{prov})$ with $\pi$ the first coordinate — i.e. it is *already* a
  component-projection instance, and the predecessor says so: *"its projection is the shape the
  transmission's seven components actually have."*
- Cor. 4.2 gives the direction of the arrow, and the ledger records it at §1.1 as **PROVED**.

**Therefore the hidden-curvature claim, taken alone, is CLASSICAL within this corpus**: adopting
the vocabulary "$\delta^{\mathrm{charge}}$" for "$\pi_3\circ e$" gains notation and nothing else,
which is D0016 §J6's own prohibition. What is **not** a restatement, and is this note's
contribution, is the *converse* direction — Theorem 1's characterisation of exactly when hidden
curvature is possible, and Corollary 1.2's consequence that the exhaustiveness of the seven
components and the existence of hidden curvature are mutually exclusive. The predecessor
exhibits a witness; it does not characterise the witnesses, and §6 of it says so
(*"I do not prove the seven components are independent, well defined, or exhaustive"*).

---

## 5. Component-by-component: definable / definable-with-added-datum / no referent

The verdicts. Each names the datum, and each says which corpus file supplies it.

### 5.1 $\delta^{\mathrm{sem}}$ — **DEFINABLE** in the fixed language, no added datum.
$\delta^{\mathrm{sem}}_\sigma:=\delta^{(\mathcal T,\mathrm{id}_Q)}_\sigma=\{x:\mathfrak h_\sigma x\not\sim_{\mathcal T}x\}$,
Def. 1.5 of the predecessor. This is the separation defect already formalised there, and it is
the one component with no interpretive slack. Valued in $\mathcal P(X)$.

### 5.2 $\delta^{\mathrm{proof}}$ — **DEFINABLE WITH ADDED DATUM: the proof-record set $\Pi_\alpha$.**
`ADVANCE_CONJUNCTS_DEFINED.md` Def. 1 supplies it: a proof record is a pair $\pi=(c_\pi,S_\pi)$,
a claim of the form $\operatorname{sep}(x,x')$ or $\operatorname{id}(x,x')$ together with the
support set $S_\pi\subseteq\mathcal T$ discharging it; Def. 2 gives $\operatorname{Verify}$. Then
$$\delta^{\mathrm{proof}}_\sigma:=\{\pi\in\Pi:\operatorname{Verify}(\pi)=1\ \text{but}\ \operatorname{Verify}(\mathfrak h_\sigma\!\cdot\!\pi)=0\},$$
where $\mathfrak h_\sigma\!\cdot\!\pi$ transports the claim along the holonomy
($\operatorname{sep}(x,x')\mapsto\operatorname{sep}(\mathfrak h_\sigma x,\mathfrak h_\sigma x')$).
Valued in $\mathcal P(\Pi)$, **not** $\mathcal P(X)$ (Rem. 2.3).

*Honest note.* $\Pi$ is D0016's own ($\Pi_\alpha$ is a coordinate of $\Diamond_\alpha$ in §A),
so this datum is not smuggled; but its *type* — records with claims and supports — is
seed154/seed158's reconstruction, not the owner's, and the owner has not confirmed it.

### 5.3 $\delta^{\mathrm{charge}}$ — **NO REFERENT.**
I searched D0016 (all of §A–§J), D0017 and D0018 as ledgered, and the five adjudicating notes.
No conserved quantity, no group of values, no current, nothing that could be a charge is
introduced anywhere. The nearest object is the $Q$-valued evaluation itself, but making
"charge" a synonym for $e$ duplicates $\delta^{\mathrm{sem}}$. **Stated flatly: this component
is a name with nothing under it, and no reading I could construct gave it independent content.**
It is the one component I would ask the owner to define before any further work on §B.

### 5.4 $\delta^{\mathrm{boundary}}$ — **DEFINABLE WITH ADDED DATUM: the declared boundary.**
`ADVANCE_CONJUNCTS_DEFINED.md` Def. 5: $\partial_{\mathrm{decl}}=(D_{\mathrm{sep}},D_{\mathrm{id}})$,
two sets of pairs from $X$ declared in advance to be kept separate / kept identified. Then
$$\delta^{\mathrm{boundary}}_\sigma:=\{(x,x')\in D_{\mathrm{sep}}:\mathfrak h_\sigma x\sim_{\mathcal T}\mathfrak h_\sigma x'\}\ \sqcup\ \{(x,x')\in D_{\mathrm{id}}:\mathfrak h_\sigma x\not\sim_{\mathcal T}\mathfrak h_\sigma x'\}.$$
$\delta^{\mathrm{boundary}}_\sigma=\emptyset$ for all $\sigma$ is exactly
$\operatorname{DeclaredBoundaryPreserved}$ read across the holonomy family.

*Warning inherited, and it is serious.* Cor. K.1 of that note proves
$\operatorname{DeclaredBoundaryPreserved}$ **collapses** — on a stage with the hypotheses (H6),
(H6i) it is implied by the other conjuncts and adds nothing. I have not re-derived Theorem K
here and do not restate it as mine; I flag that whatever survives of $\delta^{\mathrm{boundary}}$
as an *independent* coordinate is exactly what survives that collapse, which is an open question
this note does not answer.

### 5.5 $\delta^{\mathrm{prov}}$ — **DEFINABLE WITH ADDED DATUM: the citation/provenance ledger; and yes, it is $\operatorname{PreserveProv}$'s defect — with one type mismatch that must be declared.**
The mandate asks whether $\delta^{\mathrm{prov}}$ is the defect of $\operatorname{PreserveProv}$.
Reading `ADVANCE_CONJUNCTS_DEFINED.md` §5: $\operatorname{PreserveProv}^{\mathrm{rig}}$ (Def. 3a)
asks for $j:\Pi_\alpha\to\Pi_{\alpha+1}$ with $c_{j\pi}=\iota\cdot c_\pi$ and $S_{j\pi}$ an
$\iota$-lift of $S_\pi$. Its defect is
$$\delta^{\mathrm{prov}}:=\{\pi\in\Pi_\alpha:\text{no }\iota\text{-lift of }(c_\pi,S_\pi)\text{ exists at }\alpha+1\},$$
and $\delta^{\mathrm{prov}}=\emptyset\iff\operatorname{PreserveProv}^{\mathrm{rig}}=1$. So: **yes.**

**The mismatch, stated rather than papered over.** $\operatorname{PreserveProv}$ is *binary on a
step* $\alpha\to\alpha+1$ — that note verifies the arity twice, once by type-correctness and once
from D0018 §A's clause list प्रमाणरक्षा. But $\delta^{\mathrm{prov}}_\sigma$ is indexed by a
**simplex** $\sigma\in N(\mathcal F_\alpha)$, inside a single stage. The two agree only under the
added identification *chart index $=$ stage*, i.e. $\rho_{\alpha,\alpha+1}=\iota$. That
identification is nowhere made in D0016; it is available (§C's ladder is a diagram over ordinals,
and a diagram has a nerve) but it is an **added datum**, and under it a simplex of length $>1$ is
a composite of several steps, so $\delta^{\mathrm{prov}}_\sigma$ becomes the defect of a
*composite* of $\operatorname{PreserveProv}$ obligations, not of one. Also inherited: that note's
Prop. 2 shows the rigid reading implies only the $\operatorname{sep}$-half of the free reading
and **not** the $\operatorname{id}$-half — so $\delta^{\mathrm{prov}}$ has two inequivalent
definitions and the transmission chooses neither.

### 5.6 $\delta^{\mathrm{resource}}$ — **NO REFERENT in the fixed language; and its natural completion is not independent.**
Nothing in $(X,\mathcal T,e,\rho)$ is a cost. The obvious added datum is a weighting
$w:\mathcal T\to M$ into an ordered monoid, giving
$\delta^{\mathrm{res}}_\sigma(x)=\sum_{t\in D_\sigma(x)}w(t)$ over the detector set $D_\sigma(x)$
of Def. 1.6. **But then it is a function of $D_\sigma$, hence of $\delta^{\mathrm{sem}}$'s
underlying data**, and if $w$ is strictly positive, $\delta^{\mathrm{res}}_\sigma(x)=0\iff x\notin\delta^{\mathrm{sem}}_\sigma$
— an identical vanishing locus. So a positively-weighted resource defect adds a *magnitude* but
no new *vanishing*, and §B's claims are all claims about vanishing.

*Not to be confused with:* the complexity figures in `ADVANCE_CONJUNCTS_DEFINED.md` §4.3, §5.4
($O(|\Pi_\alpha|\cdot|S|\cdot|X_\alpha|)$ and so on). Those are costs *of the checker*, not
defects of $\sigma$; they do not instantiate this component and I record the distinction because
they are the only cost-shaped objects in the corpus and would otherwise be miscited as a referent.

### 5.7 $\delta^{\mathrm{info}}$ — **NO REFERENT; and its natural completion is provably dependent.**
Requires a measure $\mu$ on $X$. Any of the standard completions — the $\mu$-mass of the defect
locus, or the entropy drop $H_\mu(X/\!\sim_{\mathcal T})-H_\mu(X/\!\sim_{\mathcal T}\!\vee\,\mathfrak h_\sigma^{*}\!\sim_{\mathcal T})$ —
satisfies, for $\mu$ of full support:

**Proposition 5.7.1.** $\mu(\delta^{\mathrm{sem}}_\sigma)=0\iff\delta^{\mathrm{sem}}_\sigma=\emptyset$
(full support, $X$ finite), so $\delta^{\mathrm{info}}_\sigma=0\iff\delta^{\mathrm{sem}}_\sigma=0$.

*Proof.* Full support means $\mu(A)=0\iff A=\emptyset$ for $A\subseteq X$ finite. $\square$

**Consequence, and it is the sharpest negative here: $(\mathrm{sem},\mathrm{info})$ is a
dependent pair.** Its vanishing patterns realise only $2$ of the $4$ possibilities, so the
seven components are **not** independent under any full-support informational reading, and
$\delta^{\mathrm{info}}$ cannot be a coordinate of a product decomposition in the sense of §3.
This is an unconditional refutation of independence *for this pair*, and it needs no measurement:
it is one line of measure theory. Escaping it requires a $\mu$ with a null set — i.e. declaring
some points unobservable — which is a *test-set* decision in disguise and is governed by Thm 1
of the predecessor, not by a new coordinate.

**Tally: 1 definable, 3 definable-with-added-datum, 1 with no referent at all
($\mathrm{charge}$), 2 with no referent whose only natural completions are functions of
$\delta^{\mathrm{sem}}$ ($\mathrm{resource}$, $\mathrm{info}$).**

---

## 6. A concrete tuple-valued instance: two components, one vanishing and one not

A finite example is proof here. The mandate asks for one; I give all four vanishing patterns,
because exhibiting *one* pattern shows nothing about structure while exhibiting all four shows
the pair is a product and not a filtration.

**Setting.** $X=\{a,b\}$, $\mathcal T=\{t\}$, $Q=\{0,1\}^2$ read as $(\mathrm{sem},\mathrm{prov})$,
$\pi_1,\pi_2$ the coordinate projections, $I=\{0,1\}$, $\rho_{01}=\mathrm{sw}$,
$\rho_{10}=\mathrm{id}$, $\sigma=(0,1,0)$, so $\mathfrak h_\sigma=\mathrm{sw}$ (Rem. 5.3 of the
predecessor). Each row of the table gives $\bigl(e(a,t),e(b,t)\bigr)$. Since $\mathfrak h_\sigma=\mathrm{sw}$,
$\delta^{(\{t\},\pi_k)}_\sigma=X$ if $\pi_k$ separates the two values and $\emptyset$ otherwise
(§5A Step 2 of the predecessor), so each entry is one comparison.

| # | $e(a,t)$ | $e(b,t)$ | $\delta^{\mathrm{sem}}_\sigma$ | $\delta^{\mathrm{prov}}_\sigma$ | $\delta^{\mathrm{tot}}_\sigma$ |
|---|---|---|---|---|---|
| P1 | $(0,0)$ | $(0,0)$ | $\emptyset$ | $\emptyset$ | $\emptyset$ |
| P2 | $(0,0)$ | $(1,0)$ | $\{a,b\}$ | $\emptyset$ | $\{a,b\}$ |
| **P3** | $(0,0)$ | $(0,1)$ | $\emptyset$ | $\{a,b\}$ | $\{a,b\}$ |
| P4 | $(0,0)$ | $(1,1)$ | $\{a,b\}$ | $\{a,b\}$ | $\{a,b\}$ |

All four evaluations per row are displayed by the two coordinate comparisons; the check is
finite and complete.

**P3 is the requested instance**: $\delta^{\mathrm{sem}}_\sigma=\emptyset$ while
$\delta^{\mathrm{prov}}_\sigma\ne\emptyset$ — one component vanishing, one not, on a
$2\times1$ Chu space. **P3 is E2′ of the predecessor** (seed148's, restored in the seed150
merge), and I claim no novelty for it; it is reproduced because the mandate asks for a
concrete instance and because P2 and P4 are needed for what follows.

**Proposition 6.1 (the pair is a product, not a filtration).** P2 and P3 together show
$\delta^{\mathrm{sem}}_\sigma$ and $\delta^{\mathrm{prov}}_\sigma$ are incomparable in both
directions across instances: neither $\delta^{\mathrm{sem}}\subseteq\delta^{\mathrm{prov}}$
nor the reverse holds uniformly. All four patterns of $\{0,\ne0\}^2$ occur at
$|X|=2$, $|\mathcal T|=1$, $|Q|=4$. Hence no filtration, no spectral-sequence-like tower, and
no order relation between the two coordinates. $\square$

**Proposition 6.2 (and here the join formula is visible).** In every row,
$\delta^{\mathrm{tot}}_\sigma=\delta^{\mathrm{sem}}_\sigma\cup\delta^{\mathrm{prov}}_\sigma$,
as Theorem 1 requires: $\{\pi_1,\pi_2\}$ is jointly injective on $\{0,1\}^2$. **So this family
exhibits no hidden curvature over the full pair** — consistent with Cor. 1.2, and the reason
P3 reads as hidden curvature only when $\delta^{\mathrm{prov}}$ is *not reported*. That is the
whole phenomenon: hidden curvature is a fact about the reporting, not about $\rho$.

**Minimality.** $|X|\ge2$ and $|Q|\ge2$ by Thm 5 of the predecessor; two components separating
distinct pairs of values require $|Q|\ge4$ for P4 to be realisable alongside P2, P3. Row P3
alone needs only $|Q|=4$ as displayed and the predecessor records (correctly) that E2 at
$|Q|=2$ is smaller. **No minimality is claimed for the table as a whole.**

---

## 7. Does "seven" do any work? No, and this is the finding to carry forward

Every claim in D0016 §B is, by Theorem 1, a statement about **one** projection $\pi$ and the
complementary information $\mathrm{id}/\pi$:

- the non-implication (Cor. 1.3) needs a proper sub-family — any one will do;
- hidden curvature (Cor. 1.1) needs failure of joint injectivity — a *binary* condition;
- the product structure (Prop. 2.2, Prop. 6.1) is exhibited already at two coordinates.

Nothing in §B distinguishes $7$ from $2$, and nothing in the corpus supplies a reason for the
number. Three of the seven ($\mathrm{charge},\mathrm{resource},\mathrm{info}$) have no referent,
and two of those three, once given their natural completions, are functions of a fourth. **The
honest reading of §B is therefore: a two-coordinate phenomenon (reported / withheld), correctly
identified by the owner, written with seven names of which four are placeholders.** The
phenomenon is real and is proved; the septuple is not yet an object.

Ledger §1.12's *"what would settle it"* is now partly discharged: §5 states what each component
*is* as a function of $(X,\mathcal T,e,\rho)$ where such a function exists, and names the missing
datum where it does not.

---

## 8. Prior art, searched before writing

- **Chu spaces**: Chu 1979 (in Barr, *\*-Autonomous Categories*, LNM 752); Barr 1991/1996;
  Pratt 1992–1999. *Separated* $=$ rows distinct, *extensional* $=$ columns distinct. Cited
  from the standard statements and from the predecessor's §7, which traced them; **I opened no
  new source on Chu spaces and no PDF decoded in this container.**
- **Joint injectivity / initial (point-separating) sources**: the notion in Def. 3.1 is entirely
  standard — a source $\{f_k:A\to A_k\}$ is *point-separating* iff the induced map to the product
  is injective (Adámek–Herrlich–Strecker, *Abstract and Concrete Categories*, ch. on sources;
  cited from its standard statement, text not opened). **Theorem 1 is therefore classical in
  substance**: it is the observation that the defect functor $\delta^{(S,-)}_\sigma$ carries a
  point-separating source to a jointly-epic family of subsets. I claim no novelty for the
  mechanism; what I claim is the *application* — Cor. 1.2's mutual exclusivity of
  exhaustiveness and hidden curvature, which is what settles §B — and that is elementary.
- **Within this corpus**: Thm 3 and E2/E2′ of `SHRINKING_TESTS_LOWER_CURVATURE.md` are the prior
  art for §4 and are credited as such rather than rediscovered. Theorem E of
  `CHANGING_TESTS_VERSUS_SHRINKING.md` (the resolving-power preorder $\sqsubseteq$ is the
  coarsest relation making $\delta$ monotone uniformly in $\mathfrak h$) is the test-coordinate
  analogue of Theorem 1's value-coordinate statement; the two are not the same theorem
  (one quantifies over holonomies, the other over value-projections) but they are the same
  *shape*, and I record the parallel rather than claiming Theorem 1 as unrelated.

A web search was run for the joint-injectivity/Chu combination before writing; it returned the
standard categorical statements and Pratt's Chu notes and nothing on defect tuples. No PDF was
decoded; no source is claimed as read that was not.

---

## 9. Scope limits

Stated as such, per the mandate's standing check (g).

1. **Uniformity.** Theorem 1's equality clause assumes all components share $S$ (Def. 3.1).
   The non-uniform case is Rem. 1.4 and is *not* characterised here; only the inclusion survives.
2. **Vanishing, not magnitude.** Every verdict above concerns whether components are $\emptyset$.
   §B's $\ominus1$ is read observationally, following the predecessor's §0(2); under a
   normed or spectral reading of $\ominus$ **nothing here applies**, and no such reading exists
   in the corpus.
3. **Heterogeneous types are not reconciled.** Rem. 2.3 shows the seven factors are different
   sets. I do not construct a common home for them and I do not believe one is available without
   an added datum.
4. **The Collapse is inherited, not re-proved.** §5.4's warning rests on Cor. K.1 of
   `ADVANCE_CONJUNCTS_DEFINED.md`, which I read but did not re-derive. If Theorem K is wrong,
   §5.4's warning is wrong; §5.4's *definition* is unaffected.
5. **Three components remain undefined and I did not define them.** $\mathrm{charge}$ outright;
   $\mathrm{resource}$ and $\mathrm{info}$ have completions given only to prove them dependent,
   not to adopt them. Adopting them is the owner's call.
6. **The ordinal ladder, $\mathfrak F$, $\Gamma$, the closure claim, the Yang–Baxter defect:
   untouched here, as in every predecessor.** Ledger §1.13–§1.14 stand.
7. **Nothing was measured.** No experiment was run; no floating-point number appears above; no
   Python was executed and none exists for this note; no Agda or Lean was authored or
   typechecked (there is no toolchain in this container). Every proof is finite and elementary:
   Theorem 1 is two inclusions and a two-point construction, §6 is a four-row table of
   coordinate comparisons.

---

## 10. What this note licenses

> A tuple-valued defect is a product of resolutions, and it has content exactly to the extent
> that the reported projections **fail** to be jointly injective. If they are jointly injective,
> the total defect is the union of the components and hidden curvature cannot occur; if they are
> not, the tuple is a lossy instrument and the total defect is not recoverable from it. Hidden
> curvature is therefore a property of the *report*, not of the connection — the same lesson as
> *zero curvature is not truth*, one level up: **zero reported curvature is not zero curvature,
> and the two coincide exactly when the report is complete.**

Not licensed: any claim about magnitudes of components; any claim about $\mathrm{charge}$; any
claim that the number seven is significant; any claim about non-uniform component families
beyond the inclusion of Rem. 1.4.

---

*Question and framework: the repository owner, D0016 §B, 2026-08-14. Prior art within the
corpus: seed146, seed148, seed150 (`SHRINKING_TESTS_LOWER_CURVATURE.md`), seed153
(`CHANGING_TESTS_VERSUS_SHRINKING.md`), seed154/seed158 (`ADVANCE_CONJUNCTS_DEFINED.md`),
seed157 (`OWNER_TRANSMISSIONS_LEDGER.md`). E2′ (row P3) is seed148's and is credited, not
reclaimed. Theorem 1, Cor. 1.1–1.3, Prop. 5.7.1, Prop. 6.1–6.2, and the component triage of §5:
seed164.*
