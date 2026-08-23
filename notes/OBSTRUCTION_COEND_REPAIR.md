# $\mathcal O_\alpha=\int^{\sigma\in N(\mathcal F_\alpha)}\delta_\sigma$: the realization repair, tested and refused; what survives is a family

*seed180, 2026-08-15. Carries out the one item `notes/BOUNDARY_REPAIR_PRICED.md` §3.1
priced but did not perform — "(N1) is not verified" — and its own scope limit 3.
Owner artifact `collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md`
§§A, B, C is derived from and quoted, never rewritten. No Python; no numerical
computation; no Agda or Lean authored; no PDF decoded.*

**Headline, split because the answer is split.**

1. **The ground holds.** $\mathcal O_\alpha$ fails the occurrence test independently of
   $\partial$, and the $\vee$-diagonal repair provably cannot reach it (§1). Re-derived, not
   assumed.
2. **The priced repair is ill-formed as priced, and the defect is the same one it was meant to
   cure.** `BOUNDARY_REPAIR_PRICED.md` §3.1's **(N1) has the variance backwards**: it asks for
   $\delta_\bullet:\Delta^{op}\to Q_\alpha$ **simplicial**, but $N(\mathcal F)_\bullet$ is
   *already* contravariant in $[n]$, so both factors of $N(\mathcal F)_n\cdot\delta_n$ would sit
   in the same variance and the display fails the occurrence test **again, one level up**. The
   realization coend requires $\delta_\bullet$ **cosimplicial**, $\Delta\to Q_\alpha$ (§2.1).
3. **$\delta_\bullet$ is not simplicial, and I say which operators fail.** **Degeneracies act,
   exactly and unconditionally** — $\delta_{s_j\sigma}=\delta_\sigma$, proved for arbitrary
   $\rho$ and both available readings of $\mathfrak H$ (Prop. 2). **Faces act in neither
   variance**, refuted by a **single** charted Chu space with $|X|=2$, $|\mathcal T|=1$,
   $|I|=4$, exhibiting both failures at once (Prop. 3). So $\delta$ is a functor on the
   degeneracy half of the simplex category and on no more.
4. **And even granting simpliciality, the copower is the wrong shape.** $N(\mathcal F)_n\cdot
   \delta_n=\coprod_{\sigma\in N_n}\delta_n$ forces $\delta_n$ to be **independent of
   $\sigma$** — so the repaired $\mathcal O_\alpha$ would be a function of the *homotopy type of
   the nerve* and of a $\sigma$-blind object, carrying **no information about which simplices
   have defect**. That is an independent and decisive objection, and it does not need
   (N1) at all (§2.2). The intended object, $\coprod_{\sigma\in N_n}\delta_\sigma$, is a
   *twisted* coproduct and is not a copower.
5. **What serves.** The **family** $\mathcal O_\alpha:=(\delta_\sigma)_{\sigma\in
   N(\mathcal F_\alpha)}$ — which is what `SHRINKING_TESTS_LOWER_CURVATURE.md` Def. 1.5 and
   `SEVEN_DEFECT_COMPONENTS.md` Def. 2.1 have been using all along, under the same glyph, without
   ever invoking §B's coend. Its coproduct shadow over **non-degenerate** simplices is
   well-defined **because of** Prop. 2, which is the one place degeneracy-invariance earns
   something (§4). The face-poset colimit is **refuted** (§4.2), not merely unavailable.
6. **Containment: the same partition as for $\partial$, and for the same reason.** No fleet
   theorem uses §B's $\mathcal O$; four items inherit and are *strengthened*; one prior ground —
   `SHRINKING_TESTS_LOWER_CURVATURE.md`'s scalar shadow $\|\mathcal O(S)\|$ — is **refuted**, by
   a corollary of Prop. 2 (§5.3), while the theorem it decorates is untouched.

---

## 0. Ground check, before building (standing check (d))

Tonight's rule is that false grounds outnumber false claims four to one. Three grounds were
re-derived rather than taken.

**0.1 The occurrence failure for $\mathcal O$, re-derived.** D0016 §B:
$$\mathcal O_\alpha:=\int^{\sigma\in N(\mathcal F_\alpha)}\delta_\sigma .$$
For $\int^{c\in\mathcal C}F(c,c)$ to denote one needs a functor
$F:\mathcal C^{op}\times\mathcal C\to\mathcal D$, the coend being the coequalizer
$$\coprod_{u:c\to c'}F(c',c)\rightrightarrows\coprod_c F(c,c)\to\int^cF(c,c),$$
whose two maps act on one of *two* occurrences of the bound variable. In
$\int^{\sigma}\delta_\sigma$ the variable $\sigma$ occurs **once**. Neither parallel map can be
written. **Confirmed independently of `BOUNDARY_OPERATOR_TYPING.md` §2's table.** Two further
defects compound it and are worth naming separately, because they are not the same defect:

- $N(\mathcal F_\alpha)$ is a **simplicial set**, not a category. "$\sigma\in N(\mathcal F_\alpha)$"
  ranges over the elements of a graded set. A coend is indexed by a *category*; the display does
  not say which one. (Candidates: the category of elements $\mathrm{el}(N\mathcal F)$; the
  simplex category $\Delta$; the discrete category on $\coprod_nN_n$. They give three different
  objects, and §2 shows two of them empty of content.)
- $\delta_\sigma$ is not typed. D0016 §B says $\delta_\sigma:=\mathfrak H_\sigma\ominus1$ and
  that it is a **7-vector**; `SEVEN_DEFECT_COMPONENTS.md` Rem. 2.3 proves the seven factors are
  *heterogeneously typed*, so "$\delta_\sigma$ an object of $Q_\alpha$" is already a
  simplification, and the one I work under (as does the whole corpus).

**0.2 The $\vee$-repair provably does not reach $\mathcal O$ — and the reason is shape, not
just unavailability.** `BOUNDARY_REPAIR_PRICED.md` §3.1 asserts this; here is the derivation.
The $\vee$-diagonal works by supplying a functor $\vee:\mathcal T^{op}\to\mathcal F$ and forming
$E=e\circ(\vee\times1):\mathcal T^{op}\times\mathcal T\to Q$. It needs **two** index categories,
one to be turned into the opposite of the other, and an integrand **already** functorial in two
separate arguments. $\delta$ has one index and one argument. There is nothing for $\vee$ to
transpose: $\vee^*$ applied to a one-argument family is that family reindexed, and reindexing a
functor $\mathcal C\to Q$ along $\mathcal C^{op}\to\mathcal C$ still leaves each occurrence
single. **Formally:** for any functor $v:\mathcal C^{op}\to\mathcal C$ and any
$F:\mathcal C\to Q$, the assignment $c\mapsto F(vc)$ is a functor $\mathcal C^{op}\to Q$ — one
variance, one occurrence — and $\int^cF(vc)$ fails the occurrence test for the same reason
$\int^cF(c)$ does. **So the two displays of §B are not two instances of one defect with one
cure: $\partial$ integrates over a product and is repaired by a diagonal; $\mathcal O$
integrates over a nerve and admits no diagonal at all.** $\square$

**0.3 The two readings of the holonomy, and why nothing below turns on the difference.**
D0016 §B, as transcribed, reads
$$\mathfrak H_\sigma:=\rho_{i_0i_n}\rho_{i_{n-1}i_n}\cdots\rho_{i_0i_1},$$
with **no inverse on the long edge**. `SHRINKING_TESTS_LOWER_CURVATURE.md` Def. 1.4 — the
corpus's working definition, and the one every fleet theorem uses — reads
$$\mathfrak h_\sigma:=\rho_{i_0i_n}^{-1}\,\rho_{i_{n-1}i_n}\cdots\rho_{i_0i_1},$$
and calls it "the transmission's $\mathfrak H_\sigma$". These are **not the same formula**, and
the difference is not cosmetic: only the second is the descent obstruction (only the second
gives $\mathfrak h=\mathrm{id}$ for all $\sigma$ iff $\rho$ is a cocycle, which Def. 1.4 asserts
and which is false for the first — under the first, a $1$-simplex has
$\mathfrak H_{(i_0,i_1)}=\rho_{i_0i_1}^2$, which a cocycle does not make trivial).

**I report the discrepancy and do not conclude from it.** Per the standing consequence recorded
at D0016 §D, this archive is a transcription that has been proved lossy once and is under a
fidelity audit with further candidate gaps; a missing $^{-1}$ is exactly the kind of loss a
transcription produces, and the corpus's reading is the mathematically live one. It is the
owner's to resolve. **Everything proved below is stated so that it holds under both readings**,
and §3's counterexample is built inside $\operatorname{Aut}(X)\cong\mathbb Z/2$, where the two
formulas literally coincide because $g^{-1}=g$. That is deliberate.

---

## 1. What the display would have to mean

Write $I:=\operatorname{Ob}\mathcal F_\alpha$, and take $N(\mathcal F_\alpha)$ with
$n$-simplices $\sigma=(i_0,\dots,i_n)$ — the Čech/indiscrete nerve of Def. 1.3 of
`SHRINKING_TESTS_LOWER_CURVATURE.md`, $N_n=I^{n+1}$, with
$$d_j(i_0,\dots,i_n)=(i_0,\dots,\widehat{i_j},\dots,i_n),\qquad
s_j(i_0,\dots,i_n)=(i_0,\dots,i_j,i_j,\dots,i_n).$$
(If $\mathcal F_\alpha$ carries non-identity arrows and $N$ is its ordinary nerve, everything in
§2 and §4 is unchanged and §3's counterexample still lives inside it, since the indiscrete nerve
on $I$ maps to it; §6.2 records the scope.)

Defect, in the corpus's fixed reading of $\ominus$ (observational, Def. 1.5):
$$\delta_\sigma\;:=\;\delta^S_\sigma\;=\;\{x\in X:\mathfrak h_\sigma x\not\sim_S x\}\ \subseteq X,$$
so $Q_\alpha=(\mathcal P(X),\subseteq)$ — **a poset**, in which a morphism $A\to B$ exists iff
$A\subseteq B$ and is then unique. This matters in §3: over a poset, "no functorial relation"
and "no inclusion" are the same statement, so a negative can be made *exhaustive* rather than
merely "no map was found".

---

## 2. The realization repair: two independent failures

### 2.1 Failure I — the variance is backwards, and it is the same defect one level up

**Proposition 1.** The display $\int^{[n]\in\Delta}N(\mathcal F_\alpha)_n\cdot\delta_n$ is
well-formed **only if $\delta_\bullet$ is a cosimplicial object $\Delta\to Q_\alpha$**. Under
`BOUNDARY_REPAIR_PRICED.md` §3.1's (N1) — "$\{\delta_\sigma\}$ assembles into a simplicial
object $\delta_\bullet:\Delta^{op}\to Q_\alpha$" — the display is **not a coend**.

*Proof.* The integrand must be a functor $\Delta^{op}\times\Delta\to Q_\alpha$, i.e. the bound
variable occurs once contravariantly and once covariantly. $N(\mathcal F_\alpha)_\bullet$ is a
simplicial set, i.e. a functor $\Delta^{op}\to\mathbf{Set}$: **contravariant**. Hence the second
factor must be **covariant**. If $\delta_\bullet$ is also contravariant, both occurrences of
$[n]$ have the same variance, neither parallel map of the coequalizer can be written, and the
occurrence test fails exactly as it did for the unrepaired display. $\square$

**This is not a quibble about which functor category the letters live in; it is the whole
mechanism.** In the standard realization $|X|=\int^{[n]\in\Delta}\Delta[n]\odot X_n$ the
*simplicial* factor is $X_n$ and the *cosimplicial* factor is the standard simplex $\Delta[n]$
— the geometry, not the data. (nLab, "geometric realization", read directly this pass; the page
gives $|K^\bullet|=\int^{[n]}\mathrm{st}([n])\cdot K^n$ and
$|X|=\int^{[n]\in\Delta}\Delta[n]\odot X_n$, with $K^n,X_n$ contravariant and
$\mathrm{st}([n]),\Delta[n]$ covariant.) So in
$N(\mathcal F)_n\cdot\delta_n$ the nerve occupies the *simplicial* slot and $\delta_\bullet$ is
being asked to play the role of **the standard simplex** — a cosimplicial frame. §3 asks
whether the defect can be one. **(N1) as stated in the source pass is corrected, not merely
verified; and the correction is in the direction that makes it harder.**

*Attribution, per standing check (c) and (e).* `BOUNDARY_REPAIR_PRICED.md` §3.1's own sentence
— "the bound variable $[n]$ occurs twice, contravariantly in $\delta_n$ and covariantly in
$N(\mathcal F_\alpha)_n$" — is **refuted by the variance of the nerve**, which is not a matter
of convention: $N(\mathcal F)$ is a simplicial set. That note's *conclusion* (a realization
coend is the shape the nerve is asking for) survives; its *assignment of variances* does not.
Its verdict "candidate, unverified" was correctly labelled, and §6 of that note listed exactly
this as its open obligation.

### 2.2 Failure II — the copower is $\sigma$-blind, and this does not depend on §2.1 or §3

**Proposition 2′ (the shape objection).** Let $Q_\alpha$ be tensored over $\mathbf{Set}$ and let
$\delta_\bullet:\Delta\to Q_\alpha$ be *any* cosimplicial object. Then
$$\mathcal O_\alpha=\int^{[n]\in\Delta}N(\mathcal F_\alpha)_n\cdot\delta_n$$
depends on $\rho$ **not at all**: it is a functor of the simplicial set $N(\mathcal F_\alpha)$
and of $\delta_\bullet$ separately.

*Proof.* $N_n\cdot\delta_n=\coprod_{\sigma\in N_n}\delta_n$: every copy of the coproduct is the
**same object** $\delta_n$, indexed by $\sigma$ but not depending on it. The coend is a colimit
of a diagram in which $\rho$ appears nowhere, since $\delta_n$ is by hypothesis a function of
$[n]$ alone. Two charted Chu spaces with the same $\mathcal F_\alpha$ and different $\rho$ —
e.g. §3's, with $\rho\equiv\mathrm{id}$ against §3's $\rho$ — give the same value. $\square$

**Consequence, and it is the decisive one.** $\delta$'s entire content is the assignment
$\sigma\mapsto\delta_\sigma$; a copower cannot carry it. The object the transmission wants at
level $n$ is $\coprod_{\sigma\in N_n}\delta_\sigma$ — a coproduct of a **family varying over the
index set**, i.e. a colimit over the discrete category $N_n$ of a functor $N_n\to Q_\alpha$.
That is a *twisted* coproduct, not a copower, and (N2)'s tensoring does not supply it: tensoring
gives $S\cdot q$ for a set $S$ and a **fixed** $q$. Assembling those levels into a single object
requires the family $\sigma\mapsto\delta_\sigma$ to be functorial on the category of elements
$\mathrm{el}(N\mathcal F)$ — which is §3's question, now arrived at from a second direction.

**So the realization repair is refused twice over, and the two refusals are independent:** even
if §3 had returned "yes, $\delta_\bullet$ is simplicial", Proposition 2′ would still hold, and
even if the variance of §2.1 is waved through, Proposition 2′ still holds. I record this
because it means the deliverable does not rest on §3 alone.

---

## 3. Is $\delta_\bullet$ simplicial? Degeneracies yes, faces no — exhibited

### 3.1 Degeneracies act, exactly, and under both readings of $\mathfrak H$

**Proposition 2 (degeneracy invariance).** For every charted Chu space $(\mathcal C,I,\rho)$,
every $\sigma=(i_0,\dots,i_n)\in N(I)$, every $0\le j\le n$ and every $S\subseteq\mathcal T$:
$$\mathfrak h_{s_j\sigma}=\mathfrak h_\sigma,\qquad\text{hence}\qquad
\delta^S_{s_j\sigma}=\delta^S_\sigma .$$
This holds for the corpus reading $\mathfrak h_\sigma=\rho_{i_0i_n}^{-1}\rho_{i_{n-1}i_n}\cdots
\rho_{i_0i_1}$ and, verbatim, for the archive reading
$\mathfrak H_\sigma=\rho_{i_0i_n}\rho_{i_{n-1}i_n}\cdots\rho_{i_0i_1}$.

*Proof.* $s_j\sigma=(i_0,\dots,i_j,i_j,\dots,i_n)$ has the same **first** vertex $i_0$ and the
same **last** vertex $i_n$ for every $j\in\{0,\dots,n\}$, so the long-edge factor
($\rho_{i_0i_n}^{-1}$, resp. $\rho_{i_0i_n}$) is unchanged. Its consecutive-edge product is the
consecutive-edge product of $\sigma$ with one extra factor $\rho_{i_ji_j}$ inserted, and
$\rho_{ii}=\mathrm{id}$ by Def. 1.3. An identity factor inserted into a product in
$\operatorname{Aut}(X)$ changes nothing. Hence the two automorphisms are equal, hence so are
their defect loci, which are functions of the automorphism and $S$ alone (Def. 1.5). $\square$

**Note what this is and is not.** It is *equality*, not merely a map — the strongest possible
form. It is unconditional on $\rho$: no cocycle condition, no invertibility beyond
$\rho_{ij}\in\operatorname{Aut}(X)$, no hypothesis on $X$, $\mathcal T$, $Q$. It says
$\delta$ **factors through the degeneracy quotient**: $\delta$ is a functor on
$\mathrm{el}(N\mathcal F)$ restricted to the wide subcategory generated by the degeneracies (all
of whose induced maps are identities), so it is constant on degeneracy-orbits.

### 3.2 Faces act in neither variance — one Chu space, both failures

**Proposition 3.** There is a charted Chu space with $|X|=2$, $|\mathcal T|=1$, $|Q|=2$,
$|I|=4$, and two simplices in it, such that
$$\delta_{d_0\sigma}\not\subseteq\delta_\sigma
\qquad\text{and}\qquad
\delta_{\tau}\not\subseteq\delta_{d_0\tau}.$$
Hence there is **no natural assignment of maps along faces in either variance**: since
$Q_\alpha=(\mathcal P(X),\subseteq)$ is a poset, a morphism exists iff the inclusion holds, and
both inclusions fail in one and the same space. $\delta_\bullet$ is therefore **not** a
simplicial object, and **not** a cosimplicial one either.

*Construction (finite, exhaustive, checkable by hand).* Let $X=\{a,b\}$, so
$\operatorname{Aut}(X)=\{\mathrm{id},\mathrm{sw}\}\cong\mathbb Z/2$, which I write additively:
$\mathrm{id}=0$, $\mathrm{sw}=1$. Let $\mathcal T=S=\{t\}$, $Q=\{0,1\}$, $e(a,t)=0$,
$e(b,t)=1$; then $\sim_S$ is equality, so
$$\delta_\sigma=\begin{cases}X,&\mathfrak h_\sigma=\mathrm{sw},\\ \emptyset,&\mathfrak h_\sigma=\mathrm{id}.\end{cases}$$
Let $I=\{0,1,2,3\}$ and set $\rho_{13}=\rho_{31}=\mathrm{sw}$ and $\rho_{ij}=\mathrm{id}$ for
every other pair (including $\rho_{ii}=\mathrm{id}$, as required).

Since $\operatorname{Aut}(X)$ is abelian of exponent $2$, $g^{-1}=g$, and both readings of the
holonomy collapse to the same additive expression
$$\mathfrak h_{(i_0,\dots,i_n)}=\rho_{i_0i_n}+\sum_{k=0}^{n-1}\rho_{i_ki_{k+1}}\pmod 2 .$$
**This is why the counterexample is built here: §0.3's transcription ambiguity cannot affect
it.**

Now compute. Put $\sigma=(0,1,2,3)$ and $\tau=(1,2,3)$.

| simplex | $\mathfrak h$ | $\delta$ |
|---|---|---|
| $\sigma=(0,1,2,3)$ | $\rho_{03}+\rho_{01}+\rho_{12}+\rho_{23}=0+0+0+0=0$ | $\emptyset$ |
| $d_0\sigma=(1,2,3)=\tau$ | $\rho_{13}+\rho_{12}+\rho_{23}=1+0+0=1$ | $X$ |
| $d_1\sigma=(0,2,3)$ | $\rho_{03}+\rho_{02}+\rho_{23}=0$ | $\emptyset$ |
| $d_2\sigma=(0,1,3)$ | $\rho_{03}+\rho_{01}+\rho_{13}=0+0+1=1$ | $X$ |
| $d_3\sigma=(0,1,2)$ | $\rho_{02}+\rho_{01}+\rho_{12}=0$ | $\emptyset$ |
| $d_0\tau=(2,3)$ | $\rho_{23}+\rho_{23}=0$ | $\emptyset$ |
| $d_1\tau=(1,3)$ | $\rho_{13}+\rho_{13}=0$ | $\emptyset$ |
| $d_2\tau=(1,2)$ | $\rho_{12}+\rho_{12}=0$ | $\emptyset$ |

**Both failures, read off the table.**

- **Covariant (simplicial-object) direction fails.** A simplicial object $\delta_\bullet$ with
  $\delta_\sigma$ at $\sigma$ would give, along $d_0$, a map $\delta_\sigma\to\delta_{d_0\sigma}$,
  i.e. $\delta_\sigma\subseteq\delta_{d_0\sigma}$ — but at $\tau$: $X\not\subseteq\emptyset$.
- **Contravariant (cosimplicial) direction fails.** A cosimplicial structure would give
  $\delta_{d_0\sigma}\to\delta_\sigma$, i.e. $\delta_{d_0\sigma}\subseteq\delta_\sigma$ — but at
  $\sigma$: $X\not\subseteq\emptyset$.

Both in the *same* space, with the *same* face operator $d_0$, at adjacent dimensions.
$\square$

**Which simplicial identity fails?** None does — and saying so precisely is the deliverable.
The simplicial identities are equations *among given operators*; here the operators do not
exist. The exact statement is:

> **Corollary 3.1 (the partition of the simplex category).** Let $\Delta_{\mathrm{surj}}\subseteq
> \Delta$ be the wide subcategory of surjections (degeneracies) and $\Delta_{\mathrm{inj}}$ that
> of injections (faces); by Eilenberg–Zilber every map of $\Delta$ factors uniquely as a
> surjection followed by an injection. Then $\sigma\mapsto\delta_\sigma$ extends to a functor on
> the part of $\mathrm{el}(N\mathcal F)$ lying over $\Delta_{\mathrm{surj}}$ — where every
> induced map is an **identity** (Prop. 2) — and extends over **no** face operator in either
> variance (Prop. 3). $\delta$ is a *degeneracy-invariant graded family*, and nothing more.

**Why this is the expected answer, once seen.** $\mathfrak h_\sigma$ is a holonomy: it is
manufactured out of a *path* from $i_0$ to $i_n$ compared against the *direct edge*. Deleting an
interior vertex changes the path; deleting an end vertex changes the comparison edge *and* the
basepoint. Neither operation has a canonical effect on "how far the round trip is from the
identity", and the failure is not near-miss: the two 3-simplices above differ from their faces by
everything. Repeating a vertex, by contrast, inserts $\rho_{ii}=\mathrm{id}$ and changes nothing.
**Degeneracies are the operators that do not move the path; faces are the ones that do.** A
$\delta$ that responded functorially to faces would be a *cocycle condition in disguise* — and
if $\rho$ were a cocycle, $\mathfrak h\equiv\mathrm{id}$ and every $\delta_\sigma$ would be
empty. So the obstruction to simpliciality is not incidental to the object: **$\delta$ is
functorial along faces exactly when it is trivial.** That is the sharpest form of the negative
and it is worth stating as such.

**Proposition 4 (the sharp form).** Suppose $\rho$ satisfies the cocycle condition
$\rho_{jk}\rho_{ij}=\rho_{ik}$. Then $\mathfrak h_\sigma=\mathrm{id}$ and $\delta_\sigma
=\emptyset$ for every $\sigma$ (Def. 1.4), so $\delta_\bullet$ is the constant simplicial object
at $\emptyset$ — trivially simplicial and trivially cosimplicial, and $\mathcal O_\alpha$ is
$\emptyset$ under every candidate reading. *Proof.* Immediate from Def. 1.4 and Def. 1.5.
$\square$ **So (N1) is not an open hypothesis one might hope to discharge: on the nose it is
satisfiable only in the case where the whole apparatus has nothing to measure.** I do not claim
the converse (that simpliciality *implies* $\rho$ is a cocycle); Prop. 3 refutes simpliciality
for one non-cocycle $\rho$, Prop. 4 confirms it for cocycles, and the intermediate classification
is not attempted (§6.4).

---

## 4. What serves instead — three candidates, tested rather than assumed

### 4.1 The coproduct over non-degenerate simplices — **AVAILABLE**, and Prop. 2 is what makes it canonical

$$\mathcal O^{\amalg}_\alpha:=\coprod_{\sigma\in N(\mathcal F_\alpha)^{\mathrm{nd}}}\delta_\sigma
\qquad\left(=\ \bigcup_\sigma\delta_\sigma\ \text{ when }Q_\alpha=(\mathcal P(X),\subseteq)\right).$$

No simplicial structure is needed: a coproduct over a set requires only that the set be small
and $Q_\alpha$ have coproducts. **And the restriction to non-degenerate simplices is not an
arbitrary truncation but the canonical one, by Proposition 2**: every simplex is uniquely
$\sigma=\alpha^*\sigma^{\mathrm{nd}}$ with $\alpha$ a surjection (Eilenberg–Zilber), and
$\delta_\sigma=\delta_{\sigma^{\mathrm{nd}}}$, so the non-degenerate coproduct loses no value
and no repetition is discarded arbitrarily. This is the one thing degeneracy-invariance buys,
and it is worth having.

**Price, and it is real:** a coproduct has no coherence. $\mathcal O^{\amalg}$ knows *which*
defect loci occur and nothing about how they sit over the nerve; it is a colimit over a discrete
category and forgets the whole simplicial shape. It is exactly as much structure as the family
(§4.3) with the indexing thrown away, and strictly less.

### 4.2 The colimit over the poset of simplices under face maps — **REFUTED**

This candidate does not merely lack coherence: **the diagram does not exist.** A colimit over
the face-poset requires, for each face relation $d_j\sigma\le\sigma$, a morphism
$\delta_{d_j\sigma}\to\delta_\sigma$ in $Q_\alpha$. Proposition 3 exhibits $d_0\sigma$ with
$\delta_{d_0\sigma}=X\not\subseteq\emptyset=\delta_\sigma$, and over a poset that is not "no
canonical map" but "no map". **So this candidate is refuted, not merely unpriced** — and it is
refuted by the same table that refutes simpliciality, which is why it was worth testing rather
than assuming.

### 4.3 $\mathcal O$ as a family — **AVAILABLE, and it is what the corpus already uses**

$$\boxed{\ \mathcal O_\alpha\ :=\ (\delta_\sigma)_{\sigma\in N(\mathcal F_\alpha)}\ \in\ \prod_{\sigma}Q_\alpha\ }$$

**Checked by reading, per the mandate and standing check (b).**
`notes/SHRINKING_TESTS_LOWER_CURVATURE.md` Def. 1.5: *"The total obstruction is
$\mathcal O(S):=(\delta^S_\sigma)_{\sigma\in N(I)}$, ordered componentwise by inclusion."*
`notes/SEVEN_DEFECT_COMPONENTS.md` Def. 2.1 does the same one level down, for the seven
components: $\delta^R_\sigma:=(\delta^{r_k}_\sigma)_{k\in K}\in\prod_k\mathcal P(X)$, with
Prop. 2.2 proving the componentwise order is the *forced* one. **The mandate's guess is
confirmed by the text: the corpus has been using the family reading throughout, under the same
glyph $\mathcal O$, and has never once evaluated §B's coend.**

This is well-defined with no hypothesis beyond $N(\mathcal F_\alpha)$ being a set and each
$\delta_\sigma$ existing. It is a product, not a colimit, so it needs no cocompleteness; it is
the terminal thing one can say about a family with no functoriality. **It is the object that
serves, and it serves because §3 shows there is nothing stronger available.**

Note the *type* consequence for §C, and it is not small: $\Gamma_\alpha:\mathcal O_\alpha\to
\operatorname{Cell}(\mathcal C_{\alpha+1})$ then has as its domain a **family**, so $\Gamma$ is
a map out of a product — i.e. it must either be evaluated simplex-by-simplex (a family of
$\Gamma_\sigma$'s, with a coherence problem across $\sigma$ that §3 shows has no simplicial
solution) or be a genuine function of the whole tuple. D0016 §C decides neither. This is a
*second* missing datum for $\Gamma$, alongside the two named in
`ORDINAL_LADDER_SMALLNESS.md` Theorem 1 ((Γ1) mode selection, (Γ2) normalisation), and it is
independent of both. I do not develop it (§6.5).

---

## 5. The hypothesis list, in the style of (M1)–(M7)

What the realization repair would need, numbered, with each hypothesis's status after §§2–3.
This is the "price the copower" deliverable.

**(O1) $\mathcal F_\alpha$ has a small set of objects, and $N(\mathcal F_\alpha)_n$ is a set for
every $n$.** Otherwise the copower is indexed by a proper class. §A gives $\mathcal F_\alpha$
no type; this is the exact analogue of (M1) for $\mathcal T_\alpha$, and is likewise **not named
anywhere in the transmission**. *Status: a new cost, and unstated.*

**(O2) $\delta_\bullet$ is a COSIMPLICIAL object $\Delta\to Q_\alpha$.** Forced by the variance
of $N(\mathcal F_\alpha)_\bullet$ (Prop. 1). *Status: this is the corrected form of
`BOUNDARY_REPAIR_PRICED.md` (N1), which asked for the opposite variance.*
**REFUTED by Prop. 3** — the faces act in neither variance.

**(O3) $Q_\alpha$ is tensored over $\mathbf{Set}$**, i.e. copowers $S\cdot q=\coprod_Sq$ exist
for every $S=N(\mathcal F_\alpha)_n$. This is `BOUNDARY_REPAIR_PRICED.md` (N2), and it is a
hypothesis of a *different kind* from (M4): (M4) asks for one coequalizer, (O3) asks for
$\aleph_0$-many possibly-infinite coproducts, one per dimension, indexed by $|I|^{n+1}$.
Over $Q_\alpha=(\mathcal P(X),\subseteq)$ a copower $S\cdot A$ is $A$ if $S\ne\emptyset$ (a
poset has no non-trivial coproducts of equal objects) — **so over the corpus's own $Q$, (O3)
holds and is vacuous**, which is a second reason the copower cannot carry $\sigma$. *Status:
holds cheaply; and cheapness is bad news here.*

**(O4) $Q_\alpha$ admits the coend's coequalizer**, $\coprod_{u:[m]\to[n]}N_n\cdot\delta_m
\rightrightarrows\coprod_{[n]}N_n\cdot\delta_n$. $\Delta$ is small, so $Q_\alpha$ cocomplete
suffices and is not necessary. *Status: a cost, and §A assigns $Q_\alpha$ no type at all — the
same gap (M4) records.*

**(O5) $\delta_n$ is independent of $\sigma\in N(\mathcal F_\alpha)_n$.** Forced by the copower
(Prop. 2′): $N_n\cdot\delta_n$ has one object repeated, not a family. *Status: **REFUTED as a
faithful reading** — under (O5) the repaired $\mathcal O_\alpha$ is independent of $\rho$ and
therefore of everything §B's $\delta$ means. This is the hypothesis that kills the repair even
if (O2) were granted.*

**(O6) If (O5) is refused, the required datum is a functor $\delta:\mathrm{el}(N\mathcal F)^{op}
\to Q_\alpha$ on the category of elements**, and the object is
$\operatorname{colim}$ or $\coprod$ over it, not a copower. *Status: **REFUTED by Prop. 3** for
the face part; **available and trivial** for the degeneracy part (Prop. 2, Cor. 3.1). This is
the exact partition of what is and is not available.*

**(O7) For any homotopy-invariant reading — which §C requires, since it writes
$\delta^{(\lambda)}:=\operatorname{hocolim}_{\beta<\lambda}\delta^{(\beta)}$ — one needs
$Q_\alpha$ a model (or at least a homotopical) category and $\delta_\bullet$ **Reedy
cofibrant** in $Q_\alpha^{\Delta}$.** $\Delta$ is a Reedy category with degree $=n$; the strict
coend computes the homotopy colimit only under a latching-map cofibrancy condition. *Status:
un-instantiable, since (O2) fails; recorded because it is the hypothesis a reader who repairs
(O2) would meet next, and because §C's `hocolim` makes it non-optional rather than an extra
refinement.* Note the interaction: `ORDINAL_LADDER_SMALLNESS.md` already refutes the
$\operatorname{hocolim}$ of §E on independent (size, no-fixed-domain) grounds, so (O7) is not
the binding constraint there.

**Summary of the list.** (O1), (O4) are ordinary unstated costs of the same kind the
$\partial$-repair incurred. (O3) holds and is vacuous. (O2) and (O5) are each independently
**refuted**, and either alone is fatal. (O6) names the only surviving fragment — the degeneracy
half — and (O7) is downstream of a hypothesis that does not hold. **The realization repair is
not "priced but unverified"; it is priced, verified, and refused.**

---

## 6. Containment: does anything proved depend on $\mathcal O_\alpha$?

Traced by reading each file, not by grep alone. The partition is the same shape as
`BOUNDARY_OPERATOR_TYPING.md` §4's, and for the same underlying reason.

### 6.1 Independent — every fleet theorem

- **`SHRINKING_TESTS_LOWER_CURVATURE.md`.** Theorems 1–5, Cor. 2.3, Prop. 3.4, E1, E2, E2′. Its
  $\mathcal O(S)$ is **its own Def. 1.5, the family** — not §B's coend, which the note never
  writes. Theorem 1's content ("$\delta^{S'}_\sigma\subseteq\delta^S_\sigma$ for every $\sigma$,
  hence $\mathcal O(S')\le\mathcal O(S)$ componentwise") is a **componentwise** statement,
  which is exactly what the family reading supports and what no coend is needed for. **Fully
  independent.** (One decoration is not: §5.3 below.)
- **`SEVEN_DEFECT_COMPONENTS.md`.** Theorem 1, Cor. 1.1–1.3, Prop. 2.2, 5.7.1, 6.1–6.2, the
  §5 component triage. All are statements about $\delta^{(S,\pi)}_\sigma$ at a **fixed** $\sigma$
  or about the product over components $k\in K$; none integrates over $N(\mathcal F)$.
  Its $\mathcal O$-shaped object is Def. 2.1's product. **Fully independent.**
- **`CHANGING_TESTS_VERSUS_SHRINKING.md`.** Theorems A–F. Its $\operatorname{Ob}(-)$ is its own
  operator built from $\delta$ and its Theorem B's Galois adjunction, *not* §B's
  $\int^\sigma\delta_\sigma$ — this equivocation was already flagged by
  `BOUNDARY_OPERATOR_TYPING.md` §4.1 and I confirm it rather than rediscover it.
  **Fully independent.**
- **`ADVANCE_CONJUNCTS_DEFINED.md`, `GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`,
  `FOUR_REPAIR_MODES.md`.** Theorem U, K, D; the density/codensity identification; Theorems 1–6
  on $H^1(\Gamma,V)$. None mentions $\mathcal O_\alpha$ as an obstruction object. (In
  `FOUR_REPAIR_MODES.md` the one occurrence, line 72, is D0018 §D's
  $\operatorname{Obs}_{\mathcal O_\alpha}$ — see §5.2.) **Fully independent.**

### 6.2 Inherits the defect — and every item is *strengthened*, exactly as for $\partial$

- **D0016 §C's $\Gamma_\alpha:\mathcal O_\alpha\to\operatorname{Cell}(\mathcal C_{\alpha+1})$
  and $X^+_\alpha:=X_\alpha\amalg^h_{\partial\mathcal O_\alpha}\Gamma_\alpha\langle\mathcal
  O_\alpha\rangle$.** The mandate's framing is right: **no $\mathcal O$, no domain for $\Gamma$,
  no input to the generation step.** But the conclusion this licenses is *stronger* than the
  existing one, not in tension with it. `ORDINAL_LADDER_SMALLNESS.md` Theorem 1 opens "*Let
  $\mathcal O_\alpha$ be a defect and $\Gamma_\alpha:\mathcal O_\alpha\to\operatorname{Cell}$…*"
  and proves $\Gamma$ is not a function, by (Γ1) mode selection and (Γ2) normalisation — its
  proof runs entirely inside `FOUR_REPAIR_MODES.md`'s $H^1(\Gamma,V)$ and **never opens
  $\mathcal O_\alpha$**. So Theorem 1 is *hypothetical in $\mathcal O$* and survives verbatim;
  what the present note adds is that its hypothesis is itself unmet under §B's display, so
  $\Gamma$ fails to be a function for a **third**, prior reason. *Verdict: unchanged, ground
  deepened.* And §4.3 adds a fourth datum ($\Gamma$ out of a family) that is independent of
  (Γ1)–(Γ2).
- **D0016 §C's $\partial\Gamma_\alpha\langle\delta^{(n)}\rangle=\delta^{(n+1)}$ and the
  $\delta\to\chi\to\delta$ ladder.** Already PROGRAMME (ledger §1.13, `ORDINAL_LADDER` Thms 4,
  6–8). Now additionally without a defined $\mathcal O$ at the $\Gamma$ step. *Unchanged.*
- **`UNTOUCHED_REGIONS_ADJUDICATED.md` line 340 / ledger §3.x: "no proof that $\Gamma$ is well
  defined on $\mathcal O_\alpha$".** This note says why in a strictly stronger form: it is not
  that the proof is missing, it is that the **domain** is. *Strengthened.*

### 6.3 The one prior ground refuted, and it is a decoration rather than a theorem

**`SHRINKING_TESTS_LOWER_CURVATURE.md` Def. 1.5's scalar shadow.** That note defines, "when $X$
and $N(I)$ are finite", $\|\mathcal O(S)\|:=\sum_\sigma|\delta^S_\sigma|$, and Theorem 1 adds
"(finite case) $\|\mathcal O(S')\|\le\|\mathcal O(S)\|$".

**Corollary 5.3 (of Proposition 2).** $N(I)$ is **never** finite for $I\ne\emptyset$ — it has
simplices in every dimension, and for $|I|\ge2$ it has *non-degenerate* simplices in every
dimension (e.g. the alternating $(i,i',i,i',\dots)$). Moreover, by degeneracy invariance, if
$\delta^S_\sigma\ne\emptyset$ for a single $\sigma$ then $\delta^S_{s_{j_1}\cdots s_{j_k}\sigma}
=\delta^S_\sigma\ne\emptyset$ for infinitely many distinct simplices. Hence
$$\|\mathcal O(S)\|=\begin{cases}0,&\text{if }\delta^S_\sigma=\emptyset\text{ for all }\sigma,\\
\infty,&\text{otherwise.}\end{cases}$$
**The scalar shadow is a two-valued predicate, not a count.** $\square$

**What this does and does not touch, stated carefully (this is the standard of care the mandate
names in check (d)).** Theorem 1's substance — $\delta^{S'}_\sigma\subseteq\delta^S_\sigma$ for
every $\sigma$, and $\mathcal O(S')\le\mathcal O(S)$ componentwise — is **untouched**: it is
proved simplex-by-simplex from Def. 1.6 and needs no finiteness and no shadow. Its parenthetical
"(finite case) $\|\mathcal O(S')\|\le\|\mathcal O(S)\|$" is **true but empty**: it reads
$0\le0$, $0\le\infty$, or $\infty\le\infty$, and its finiteness hypothesis is unsatisfiable.
I do **not** amend that note; I record the correction here, openly, for its author or the next
ledger — the same procedure `BOUNDARY_REPAIR_PRICED.md` §3.3 used for
`ORDINAL_LADDER_SMALLNESS.md` Theorem 3.

*A caveat that keeps this honest:* if a future pass restricts the shadow to **non-degenerate**
simplices, $\|\cdot\|$ becomes a genuine count in each dimension, still infinite in total for
$|I|\ge2$ unless truncated. The repair is available and is one line; I do not make it, because
choosing the truncation is a decision, not a theorem.

### 6.4 The $\mathcal O$ equivocation, confirmed and not resolved

`ADVANCE_UNDER_REPLACEMENT.md` §6 records that $\mathcal O_\alpha$ **carries two meanings**: in
D0016 §B it is the *obstruction*, an **output**; in D0018 §D it is what
$\operatorname{Obs}_{\mathcal O_\alpha}(-)$ is indexed by, satisfying $\mathcal O_\alpha
\subseteq\mathcal O_{\alpha+1}$ — an *observable collection*, an **input**, in the role of
$\mathcal T$. I read that passage in full and **confirm it**. It matters here: everything the
corpus proves under the heading "$\mathcal O$" — that note's Theorem 6, Cor. 6.1,
`ORDINAL_LADDER_SMALLNESS.md` §376–391, `FOUR_REPAIR_MODES.md` line 72 — is about the **D0018
observable-collection reading**, which is a subset of tests and is **entirely untouched** by
§B's coend failing. That is a large part of why the containment holds, and it is not the same
reason as for $\partial$: for $\partial$ the fleet worked from §F; for $\mathcal O$ the fleet
worked from §F *and* from D0018 §D's homonym.

### 6.5 The partition

| | count | items |
|---|---|---|
| **independent of §B's $\mathcal O$** | 6 notes, all theorems | SHRINKING (Thms 1–5 componentwise, E1–E2′), SEVEN_DEFECT_COMPONENTS (Thm 1, Cor 1.1–1.3, Props 2.2/5.7.1/6.1–6.2), CHANGING (Thms A–F; its $\operatorname{Ob}$ is its own), ADVANCE_CONJUNCTS (Thms U, K, D), GENERABILITY, FOUR_REPAIR_MODES (Thms 1–6) |
| **independent because they use D0018 §D's homonym** | 3 items | ADVANCE_UNDER_REPLACEMENT Thm 6 + Cor 6.1; ORDINAL_LADDER §§376–391; FOUR_REPAIR_MODES line 72 |
| **inherits the defect, all strengthened or unchanged** | 3 items | D0016 §C's $\Gamma$ typing and pushout; §C's ladder identity; UNTOUCHED_REGIONS/ledger's "no proof $\Gamma$ well defined on $\mathcal O_\alpha$" |
| **ground refuted** | 1 decoration | SHRINKING Def. 1.5's $\|\mathcal O(S)\|$ (Cor. 5.3); the theorem it decorates is untouched |
| **needs restating** | 0 | — |

> **The containment sentence.** *The fleet's theorems are untouched because the fleet, again
> without declaring it, used $\mathcal O$ as a **family** and never as a coend — and because the
> transmissions' second $\mathcal O$, D0018 §D's observable collection, is a different object
> that never needed one.* Every theorem above is componentwise in $\sigma$ or is about tests.
> §B's $\int^\sigma$ enters the corpus only where a note reports something unavailable.

I offer this as a description of these six notes and of D0016 §§B–C and D0018 §D, and of nothing
else; §7.6 says what would refute it.

---

## 7. Scope limits (standing check (g))

1. **Propositions 1, 2, 2′, 4 and Cor. 3.1, 5.3 are exact symbolic arguments.** Proposition 3 is
   a finite construction over $|X|=2$, $|\mathcal T|=1$, $|I|=4$, verified exhaustively by hand;
   the table displays every computation it uses.
2. **The nerve.** §§1, 3 work with the Čech/indiscrete nerve $N_n=I^{n+1}$ of
   `SHRINKING_TESTS_LOWER_CURVATURE.md` Def. 1.3, which is what the corpus means by
   $N(\mathcal F_\alpha)$ and is the only reading under which $\mathfrak H_\sigma$'s displayed
   formula (indices $i_0\dots i_n$, all pairs $\rho_{ij}$) type-checks. If $\mathcal F_\alpha$ is
   a genuine category and $N$ its ordinary nerve, Props. 1, 2′ and Cor. 3.1 are unaffected
   (they are about variance and copowers), Prop. 2 is unaffected (degeneracies still insert
   identities), and Prop. 3's counterexample still embeds, since the indiscrete category on $I$
   is a category. **I have not checked what $\mathfrak H_\sigma$ would mean for a nerve with
   non-identity arrows between distinct objects and a separate $\rho$**; that is a genuine
   ambiguity in §A/§B and is the owner's.
3. **The transcription discrepancy of §0.3 is reported, not resolved**, per the standing
   consequence at D0016 §D. All results hold under both readings; Prop. 3 is built in
   $\mathbb Z/2$ precisely so that the two readings coincide there.
4. **The converse of Prop. 4 is not claimed.** I show: cocycle $\Rightarrow$ trivially
   simplicial; and one non-cocycle $\rho$ $\Rightarrow$ not simplicial. Which $\rho$ between
   these give a simplicial $\delta$ is not classified. Standing check (e): the announced relation
   is $\Rightarrow$ in each direction stated, never $\leftrightarrow$.
5. **§4.3's consequence for $\Gamma$ (a map out of a family) is named and not developed.** It is
   a fourth missing datum for $\Gamma$ beyond `ORDINAL_LADDER_SMALLNESS.md` Theorem 1's two and
   this note's third; developing it is a separate item.
6. **The containment analysis covers the six notes listed plus D0016 §§B–C and D0018 §D.** It is
   not a repository-wide audit. I traced every occurrence of `mathcal O` and `𝓞` in `notes/` and
   read each hit in context; a note that names the object differently could escape that. What
   would refute §6.5's sentence: a single fleet theorem whose *statement* requires
   $\int^{\sigma}\delta_\sigma$ as a single object rather than the family — and the natural place
   to look is anything built on §C's generation step, which nobody has built on.
7. **I did not re-verify `BOUNDARY_OPERATOR_TYPING.md` §4's or `BOUNDARY_REPAIR_PRICED.md` §5's
   containment tables**; §6 here is an independent trace for $\mathcal O$, not a re-audit of
   $\partial$. Prop. 1 amends `BOUNDARY_REPAIR_PRICED.md` §3.1's variance claim, and I amend it
   here, openly, rather than editing that note.
8. **D0018 §J5's $\chi_\alpha$ and D0019 §C's $\rho(D\mathcal K)$ are untouched** and are not
   identified with anything. The $\rho$ of this note is D0016 §B's transport datum and is a
   different symbol. Nothing above measures, fits, or rehabilitates any quantity; no correlation
   and no fitted constant appears.
9. **Nothing is machine-checked.** No Agda or Lean authored, no Python written or run, no
   numerical computation, no PDF decoded. Prior art (§8) was searched before writing.
10. **§9's generalisation is mine and is offered for audit** (standing check (f)).

---

## 8. Prior art, searched before the write-up

- **Coends and realization.** nLab, *geometric realization*, **read directly this pass**: the
  page gives $|K^\bullet|=\int^{[n]\in S}\mathrm{st}([n])\cdot K^n$ and, for simplicial objects,
  $|X|=\int^{[n]\in\Delta}\Delta[n]\odot X_n$, with the simplicial factor contravariant and the
  cosimplicial factor covariant. This is the source for Prop. 1 and is quoted, not paraphrased.
- **Simplicial objects, nerves, Eilenberg–Zilber.** The unique factorisation of a simplex as a
  degeneracy applied to a non-degenerate simplex (used in §4.1 and Cor. 3.1) is the standard
  Eilenberg–Zilber lemma; cited from its standard statement, **no text opened, no PDF decoded**.
- **Copowers/tensorings.** $S\cdot q=\coprod_Sq$; a category tensored over $\mathbf{Set}$ is one
  with small coproducts. Standard; used from the statement.
- **Segal conditions and Reedy categories** were checked as candidate rescues and are **not**
  used: a Segal condition is a property of a simplicial object, so it presupposes the structure
  §3 refutes; Reedy cofibrancy (O7) is downstream of (O2) and likewise un-instantiable. Recorded
  so the next pass does not re-test them.
- **Čech cohomology / descent.** $\mathfrak h_\sigma$ is the standard holonomy of a $1$-cochain
  and $\delta_\sigma=0$ for all $\sigma$ is the cocycle condition (Def. 1.4 of the predecessor
  says so). The observation that a holonomy is *not* functorial along faces is classical in
  substance — it is why Čech theory works with the *coboundary* $\check\delta$ on cochains
  rather than with holonomies on simplices. **I claim no novelty for the mechanism**; what is
  new here is the application: Props. 2–4 and the resulting refusal of the realization repair.
- **Within this corpus.** `BOUNDARY_REPAIR_PRICED.md` §3.1 is the proximate predecessor and is
  corrected in one clause and confirmed in its verdict; `SHRINKING_TESTS_LOWER_CURVATURE.md`
  Def. 1.3–1.6 supply every definition used; `SEVEN_DEFECT_COMPONENTS.md` supplies the family
  reading and the type hygiene of Rem. 2.3.

---

## 9. Concluding generalisation, offered as such

`BOUNDARY_REPAIR_PRICED.md` §7 proposed: *in D0016, every operator displayed with an index and
no codomain fails by arity; every operator displayed with a codomain and no hypotheses fails by
a missing hypothesis.* This pass supplies a case that **confirms the letter and refines the
mechanism**. $\mathcal O$ is of the first kind and did fail by arity. But its repair failed for
a reason the dichotomy does not predict, and which I think is the more useful law:

> **A coend can only assemble data that already varies functorially over its index. Where the
> transmission writes $\int$, the index is a *shape* — a product, a nerve, an ordinal — and the
> integrand is a *family* attached to that shape's elements. The two are compatible exactly when
> the family is a functor on the shape. $\partial$'s family ($e$) is a functor and needed only a
> diagonal; $\mathcal O$'s family ($\delta$) is a functor on the degeneracies and on nothing
> else, and no diagonal, copower or enrichment can supply the missing half.**

And the sharper corollary, which is the thing I would carry forward: **$\delta$ becomes
functorial along faces exactly when $\rho$ is a cocycle, i.e. exactly when $\delta$ is zero.**
The obstruction to assembling the obstruction *is* the obstruction. That is not a slogan
substituting for a theorem: it is Props. 3 and 4, in that order.

The test that refutes it: a non-cocycle $\rho$ for which $\sigma\mapsto\delta_\sigma$ *is*
functorial along all faces in one variance — which would also settle §7.4's open classification.
I looked only inside D0016 §§A–C and the corpus's fixed reading of $\ominus$.

---

*seed180, 2026-08-15. Verdicts: §0 ground CONFIRMED, and the $\vee$-repair proved unable to
reach $\mathcal O$ · §2.1 (N1)'s variance REFUTED — the realization coend needs $\delta_\bullet$
COsimplicial · §2.2 the copower is $\sigma$-blind, an independent refusal · §3 $\delta_\bullet$
is NOT simplicial: degeneracies act by equality, faces act in NEITHER variance (one finite
counterexample, both failures) · §4 the family reading SERVES and is what the corpus already
uses; the face-poset colimit is REFUTED · §5 hypotheses (O1)–(O7), with (O2) and (O5) each
independently fatal · §6 the fleet's theorems are CONTAINED; one decoration
($\|\mathcal O(S)\|$) refuted by Cor. 5.3, the theorem it decorates untouched.*

---

## 10. Addendum (2026-08-15, Mac Lane lane): the SHARP FORM, both directions, and a correction to §9's slogan

*Added by a later pass, by addition only; nothing above is altered. Everything in
this section is machine-checked in `formal/cubical/SimplicialDefectFailure.agda`
(`--cubical --safe`, no postulates, no holes, exit 0 under Agda 2.6.3 + cubical
v0.5 in this container; the pin 2.8.0/v0.9 is unrun here, as
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.1 records for every module).*

§7.4 declines the converse of Prop. 4 and §9 offers the slogan
*"δ becomes functorial along faces exactly when ρ is a cocycle, i.e. exactly
when δ is zero"*. The converse is now proved — **and the slogan is
variance-dependent, which the note did not anticipate.** The two variances give
opposite answers.

**Theorem A (simplicial variance — the slogan is a theorem).** Suppose
$\delta_\sigma\subseteq\delta_{d_0\sigma}$ for every $\sigma$ (only $d_0$, so
strictly weaker than simpliciality). Then $\delta_\sigma=\emptyset$ for every
$\sigma$; if the tests separate, $\mathfrak h_\sigma=\mathrm{id}$ for every
$\sigma$, and under the corpus reading that is exactly
$\rho_{jk}\rho_{ij}=\rho_{ik}$.
*Proof.* Iterating $d_0$ carries any $\sigma$ to a $0$-simplex, and
$\mathfrak h_{(i)}=\mathrm{cap}(\rho_{ii})\cdot e=\mathrm{cap}(e)\cdot e=e$; the
chain of inclusions gives $\delta_\sigma\subseteq\delta_{\mathrm{id}}=\emptyset$.
$\square$ (`covariant⇒trivial`, `covariant⇒holonomy-trivial`,
`CocycleExtraction.Corpus.trivial⇒cocycle`.) The only hypothesis on the long
edge is $\mathrm{cap}(e)=e$, true under **both** readings of §0.3, so Theorem A
is archive-agnostic in the same sense §3 is.

**Theorem B (cosimplicial variance — the slogan is FALSE).** There is a charted
Chu space whose $\rho$ is **not** a cocycle, with $\delta_{\sigma_0}\neq\emptyset$
for $\sigma_0=(0,1,0)$, and with $\delta_{d_j\sigma}\subseteq\delta_\sigma$ for
**every** $\sigma$ and **every** $j$. Chart: $X=\mathbb Z$, $\rho_{ij}\in
\operatorname{Aut}(X)$ translation by $1$ for $i\neq j$ and by $0$ for $i=j$,
$I=\{0,1\}$, tests separating (so $\delta_\sigma=\emptyset\iff\mathfrak h_\sigma=0$).
*Proof.* Write $t(\sigma)$ for the number of consecutive-vertex changes and
$\varepsilon(\sigma)\in\{0,1\}$ for the long-edge indicator; then
$\mathfrak h_\sigma=-\varepsilon+t$ (corpus) or $\varepsilon+t$ (archive). So the
locus $\delta=\emptyset$ is $\{t=\varepsilon\}$ — the **block** simplices
$i\cdots i\,j\cdots j$ — in the corpus reading, and $\{t=0\}$ — the **constant**
simplices — in the archive reading. Both loci are closed under deleting a vertex,
which is precisely $\delta_{d_j\sigma}\subseteq\delta_\sigma$. $\square$
(`Cosimplicial-sharp-fails-corpus`, `Cosimplicial-sharp-fails-archive`.)

**Consequences, stated so neither theorem is over-read.**

1. §9's closing slogan holds in the **simplicial** variance and fails in the
   **cosimplicial** one. Since §2.1 shows the realization coend needs the
   *cosimplicial* variance, the sharp form does **not** close (O2) by itself:
   what closes the repair is §2.2's $\sigma$-blindness objection, which no
   functoriality result touches. §2.1 and §2.2 stand unamended.
2. **(O6) is amended.** Its face part is refuted *for the $\rho$ of §3.2*, not
   for all charts: Theorem B exhibits a chart where the face part of (O6) holds
   in the cosimplicial variance with $\rho$ not a cocycle. Since
   $Q_\alpha=(\mathcal P(X),\subseteq)$ is **thin**, the inequalities *are* a
   functor — every diagram in a thin category commutes — so this is a genuine
   functor $\mathrm{el}(N\mathcal F)^{op}\to Q_\alpha$, not merely a set of
   inequalities. §7.4's open classification is thereby half-answered: in the
   simplicial variance the answer is "only cocycles" (Theorem A); in the
   cosimplicial variance the non-cocycle solutions are non-empty (Theorem B) and
   the full classification is still open.
3. **The §0.3 discrepancy is not resolved, and is now a pair of theorems.**
   Under the corpus reading, trivial holonomy $\iff$ cocycle; under the archive
   reading it gives instead $\rho_{ij}^2=e$ on every $1$-simplex together with
   $\rho_{ik}\rho_{jk}\rho_{ij}=e$ — a different condition, and the exact content
   of §0.3's observation that a $1$-simplex carries $\rho^2$
   (`CocycleExtraction.Archive.trivial⇒involutive`, `…trivial⇒closed`). Which
   reading D0016 §B intends remains the owner's, per §7.3.
4. **Cor. 5.3 is now a checked term** (`shadow-support-infinite`): one simplex
   with nonempty defect forces an $\mathbb N$-indexed family of pairwise distinct
   simplices — its iterated degeneracies — all carrying the *same* defect, so
   $\|\mathcal O(S)\|\in\{0,\infty\}$ is a two-valued predicate, not a count.
5. **Scope.** Theorem B's chart is infinite ($X=\mathbb Z$); no claim is made
   that a finite chart with the same property exists, and §3.2's finite
   counterexample is untouched. Theorem A assumes only $d_0$-functoriality and
   the poset structure of $Q_\alpha$ (transitivity and reflexivity of $\subseteq$).
   Nothing here re-audits §6's containment table, and nothing measures anything.
