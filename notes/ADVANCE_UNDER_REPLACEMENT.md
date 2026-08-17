# Which hypothesis of the no-go must be dropped: Advance, conjunct by conjunct

**Status.** Proved. Five theorems, one finite exhaustive check, one clean negative,
and one located discrepancy between two owner artifacts that only the owner can
settle.

**Verdict in one line — and check it against the body, not against itself:** of the
five conjuncts of D0016 §G's $\operatorname{Advance}$, **exactly one is a function of
the defect** ($\operatorname{SearchSep}$, and it is a function of the *whole holonomy
family*, not of a single $\delta_\sigma$ — which is why Theorem F does not reach it and
a strengthened Theorem F′ does); **one is a function of a component disjoint from
$\delta$** ($\operatorname{Verify}$); **three are undefined as written**, of which two
are type-correct only as functions of the *pair* and one only as a comparison against a
*fixed external* datum. Consequently $\operatorname{Advance}$ is **not** decidable from
§8's step classification — not because the classification is too weak but because four
of five conjuncts have no definition to decide. The strengthening the mandate asked for
exists and is Theorem 3: **$\operatorname{SearchSep}(\mathcal T_\alpha)=1$ makes an
Incomparable step impossible**, so on the Advance-relevant runs §8.3's empty-handed case
is empty. And Theorem 5: **along a run where $\operatorname{SearchSep}$ holds at both
ends, $\delta$ is constant** — the defect carries exactly zero progress information on
precisely the runs the framework cares about.

**Source and credit.** The framework, the signature, the $\operatorname{Advance}$
predicate and the widening-observable clause are the **repository owner's**:
`collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md` **§F, §G** and
`collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md` **§D**. I derive
from them and amend nothing. Where two owner artifacts differ (§7 below) I name the
place and stop; the resolution is the owner's.

**Predecessors.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` (seed148) and
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md` (seed149), the latter carrying Theorems A–F
and the §8 proposal that this note tests. Both re-derived in §1 rather than trusted.

---

## 0. Standing hypotheses

Inherited verbatim from seed149 §1, plus two new ones that the present question forces
into the open.

- **(H1)** $\mathcal C=(X,\mathcal T,e)$ a Chu space, $e:X\times\mathcal T\to Q$; finite
  wherever a count or a counterexample is asserted.
- **(H2)** $x\sim_S x'\iff\forall t\in S,\ e(x,t)=e(x',t)$, for $S\subseteq\mathcal T$.
- **(H3)** A charted structure supplies holonomies $\mathfrak h_\sigma\in\operatorname{Aut}(X)$.
- **(H4)** $D_\sigma(x)=\{t: e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$ and
  $\delta_\sigma(S)=\{x: D_\sigma(x)\cap S\ne\emptyset\}$.
- **(H5)** Replacement: $\mathcal T_\alpha\rightsquigarrow\mathcal T_{\alpha+1}$ with both
  inside **one** ambient test universe and one $e$. Incomparable pairs allowed.
- **(H6) Fixed carrier.** $X_{\alpha+1}=X_\alpha$, or else a canonical
  $\iota:X_\alpha\to X_{\alpha+1}$ along which $\sim_{\alpha+1}$ is pulled back. Every
  statement comparing $\sim_{\mathcal T_\alpha}$ with $\sim_{\mathcal T_{\alpha+1}}$
  needs this, and §7 is precisely about when the framework supplies it.
- **(H7) Holonomy-richness.** The charted structure realises every transposition of $X$
  as some $\mathfrak h_\sigma$. Theorem E's converse and Theorem 2 below need it;
  Theorems A–C, E-forward, F, F′ do not.

**(H6) and (H7) are new here.** Seed149 used (H7) implicitly inside Theorem E's
(c)$\Rightarrow$(a) and did not name it as a hypothesis on the *framework*; (H6) it did
not need, because it never crossed a stage boundary. Both are load-bearing below.

---

## 1. Verification: Theorems C and F re-derived, not cited

Per the mandate. I re-proved both from (H1)–(H4) without consulting seed149's proofs
while doing so, then compared.

### 1.1 Theorem C (the exact replacement criterion) — correct.

Write $\delta_\sigma(\{t\})=\{x: t\in D_\sigma(x)\}$. Since
$D_\sigma(x)\cap\bigcup_j S_j\ne\emptyset$ iff $D_\sigma(x)\cap S_j\ne\emptyset$ for some
$j$, we get $\delta_\sigma(\bigcup_j S_j)=\bigcup_j\delta_\sigma(S_j)$ (Theorem A), so
$\delta_\sigma(S)=\bigcup_{t\in S}\delta_\sigma(\{t\})$. Hence for any $A\subseteq X$,
$$\delta_\sigma(S)\subseteq A\iff\forall t\in S:\ \delta_\sigma(\{t\})\subseteq A
\iff S\subseteq\delta^*_\sigma(A),\qquad \delta^*_\sigma(A):=\{t:\delta_\sigma(\{t\})\subseteq A\},$$
which is the adjunction $\delta_\sigma\dashv\delta^*_\sigma$ (Theorem B). Putting
$A=\delta_\sigma(S)$:
$$\delta_\sigma(S')\subseteq\delta_\sigma(S)\iff S'\subseteq\delta^*_\sigma\delta_\sigma(S)=:C_\sigma(S),$$
and unwinding, $C_\sigma(S)=\{t:\forall x,\ t\in D_\sigma(x)\Rightarrow D_\sigma(x)\cap S\ne\emptyset\}$.
**Verified, in four lines, with no appeal to comparability of $S,S'$.** The joint form
over $\sigma$ follows by intersecting, as seed149 states.

### 1.2 Theorem F (no monotone function of a single defect) — correct.

Let $\mathfrak h$ be a fixed-point-free involution of $X$, $|X|=2n$, orbit set $O$.
(i) *Invariance.* $x\in\delta_{\mathfrak h}(\{t\})$ iff $e(\mathfrak hx,t)\ne e(x,t)$;
substituting $\mathfrak hx$ and using $\mathfrak h^2=1$ gives the identical condition, so
membership is constant on orbits.
(ii) *Realisation.* With $Q=\{0,1\}$, $\mathcal T\leftrightarrow O$, and
$e(x,t_\omega)=1$ iff $x$ is the chosen representative $r_\omega$, else $0$: for
$x\in\omega$ exactly one of $x,\mathfrak hx$ equals $r_\omega$, so the two values differ
and $x\in\delta(\{t_\omega\})$; for $x\notin\omega$ both values are $0$. Hence
$\delta(\{t_\omega\})=\omega$, and by Theorem A $S\mapsto\delta(S)$ is a **bijection**
$\mathcal P(\mathcal T)\to\{\mathfrak h\text{-invariant subsets}\}$.
(iii) *No-go.* If $\varphi:\mathcal P(X)\to L$ satisfies
$\varphi(\delta_{\mathfrak h}(S'))\le\varphi(\delta_{\mathfrak h}(S))$ for **all** $S,S'$,
then for invariant $A,B$ pick realisers both ways round; antisymmetry of $\le$ in the
poset $L$ gives $\varphi(A)=\varphi(B)$. **Verified.**

**One scope remark seed149 states correctly and which I underline because §4 turns on
it:** Theorem F's $\varphi$ takes as argument **one** set $\delta_{\mathfrak h}(S)$, at
**one** holonomy. It says nothing about functionals of the family
$\bigl(\delta_{\mathfrak h}(S)\bigr)_{\mathfrak h}$. That gap is not an oversight — by
Theorem E, uniform-in-holonomy monotonicity *does* exist along $\sqsubseteq$ — but it is
exactly wide enough for $\operatorname{SearchSep}$ to slip through, and §2 closes it.

---

## 2. Theorem F′: the family version, and the realisation lemma it needs

**Lemma 1 (every resolving power is realised; classical).** For every equivalence
relation $E$ on $X$ there is a Chu space over some $Q$ and a single test $t_E$ with
$\sim_{\{t_E\}}=E$.

*Proof.* Take $Q=X/E$ and $e(x,t_E)=[x]_E$. Then $e(x,t_E)=e(x',t_E)$ iff $x\mathbin{E}x'$.
$\square$

This is the kernel–partition correspondence ("every equivalence relation on $X$ arises
as the kernel of a function", Wikipedia *Kernel (set theory)*); **I claim no novelty for
Lemma 1**, only for its use here.

**Theorem F′ (no monotone function of resolving power).** Let $\Psi$ be any function of
the *whole holonomy family* of defects — equivalently, by seed149's Remark 1.1, any
function of $\sim_S$ — valued in a poset $L$, such that for **all** Chu spaces and all
$S,S'$ in a common universe, $\Psi(\sim_{S'})\le\Psi(\sim_S)$. Then $\Psi$ is constant on
the equivalence lattice of $X$.

*Proof.* Given equivalences $E,E'$ on $X$, Lemma 1 realises both by single tests inside
one Chu space (take $\mathcal T=\{t_E,t_{E'}\}$, $Q=(X/E)\sqcup(X/E')$, and let each test
carry its own class map; then $\sim_{\{t_E\}}=E$, $\sim_{\{t_{E'}\}}=E'$). Applying the
hypothesis with $(S,S')=(\{t_E\},\{t_{E'}\})$ and again with the roles swapped gives
$\Psi(E')\le\Psi(E)\le\Psi(E')$. $\square$

**Why F′ and not F is the operative no-go.** Remark 1.1 says $\delta_\sigma(S)$ depends
on $S$ only through $\sim_S$, so *every* candidate progress measure the framework could
build from its own observables — including ones reading all holonomies at once — is a
$\Psi$. Theorem F rules out the single-holonomy ones; Theorem F′ rules out the rest.
**Ground:** Lemma 1 plus antisymmetry in $L$; nothing else. **Scope:** $S,S'$ inside one
test universe with one $e$ (H5); Theorem F′ is silent the moment (H5) or (H6) fails, and
§7 is about exactly that.

---

## 3. The five conjuncts

$$\operatorname{Advance}(\Diamond_\alpha)\iff
\operatorname{Verify}(\Pi_\alpha)=1
\wedge \operatorname{SearchSep}(\mathcal T_\alpha)=1
\wedge \operatorname{PreserveProv}=1
\wedge \operatorname{UsefulEscape}>0
\wedge \operatorname{DeclaredBoundaryPreserved}=1$$
(D0016 §G, verbatim.)

**A preliminary that changes the whole question, and which I state before the table
because the table is misleading without it.** $\operatorname{Advance}$ is written as a
predicate on a **single stage** $\Diamond_\alpha$, not on a step
$\Diamond_\alpha\to\Diamond_{\alpha+1}$. A one-place predicate is not a monotone
quantity, and Theorems F and F′ are statements about monotonicity across a step.
**Theorem F therefore does not refute $\operatorname{Advance}$; it refutes one reading of
it** — the reading in which a stage is certified to advance by comparing its defect to
the previous stage's. Seed149's Corollary F.1 says precisely this and does not overstate
("cannot be licensed by any comparison of $\delta$ across a replacement"). I record that
the announced $\Rightarrow$ was not silently upgraded there, and I do not upgrade it
here. The classification below is therefore of each conjunct's **type**, and the Theorem
F/F′ verdict attaches only to the conjuncts one might try to read as progress.

The mandate's trichotomy (i)/(ii)/(iii) is **not exhaustive**, and saying so is part of
the deliverable. Two further types occur:

- **(0)** function of a stage component **disjoint from $\delta$** — unary, and outside
  the reach of F and F′ for type reasons, not for mathematical ones;
- **(ii′)** function of the pair (**fixed external declaration**, current stage) — a
  comparison against an anchor rather than against the predecessor.

| conjunct | function of $\delta$? | type | F / F′ verdict |
|---|---|---|---|
| $\operatorname{Verify}(\Pi_\alpha)=1$ | **No** — of $\Pi_\alpha$ | (0) | untouched; but no verification relation is given in D0016, so **undefined as written** |
| $\operatorname{SearchSep}(\mathcal T_\alpha)=1$ | **Yes** — of the holonomy family (Thm 2) | (i), unary | **F does not apply** (F is single-holonomy); **F′ does**: not monotone under unrestricted replacement. Monotone along $\sqsubseteq$ (Thm 4). Decidable from §8's datum |
| $\operatorname{PreserveProv}=1$ | No | **(iii)** undefined; only type-correct completion is (ii) | F, F′ silent |
| $\operatorname{UsefulEscape}>0$ | No, as intended; **yes if ever defined via $\delta$** | **(iii)** undefined; intended (ii) | F, F′ **fatal to any $\delta$-based or $\sim$-based definition** |
| $\operatorname{DeclaredBoundaryPreserved}=1$ | No | **(ii′)** | F, F′ silent — and this is the **only** conjunct whose shape can carry progress |

Now the justifications, one by one.

### 3.1 $\operatorname{Verify}(\Pi_\alpha)=1$ — type (0), undefined as written.

$\Pi_\alpha$ is the sixth component of $\Diamond_\alpha=(X,\mathcal F,\mathcal T,e,\rho,\Pi,\mathcal O)$
(D0016 §A). $\operatorname{Verify}$ is a predicate on that component. It is not a
function of $\delta$, and the separation is the owner's own: §G's box
$\delta=0\not\Rightarrow\operatorname{Advance}$ is exactly the assertion that the
$\Pi$-conjunct is independent of the $\delta$-data. **Ground for calling it undefined:**
D0016 nowhere gives a verification relation, a proof calculus, or a type for $\Pi_\alpha$.
I resist the tempting identification with $\delta^{\mathrm{proof}}_\sigma$ (the second
component of §B's vector defect): nothing in the transmission connects them, and
inventing the link would be exactly the translation-is-not-a-result move D0016 §J6
forbids.

### 3.2 $\operatorname{SearchSep}(\mathcal T_\alpha)=1$ — type (i), and it *is* a function of $\delta$.

Reading fixed as in seed148 §5: $\operatorname{SearchSep}(S)=1$ iff $S$ separates the
points of $X$, i.e. $\sim_S=\Delta_X$.

**Theorem 2 (SearchSep is the defect family's top).** Assume (H7). Then
$$\operatorname{SearchSep}(S)=1\iff \forall\,\mathfrak h\in\operatorname{Aut}(X)\setminus\{1\}:\ \delta_{\mathfrak h}(S)\ne\emptyset.$$

*Proof.* ($\Rightarrow$) If $\sim_S=\Delta$ and $\mathfrak h\ne1$, pick $x$ with
$\mathfrak hx\ne x$; then $\mathfrak hx\not\sim_S x$, so $x\in\delta_{\mathfrak h}(S)$.
($\Leftarrow$) If $\sim_S\ne\Delta$, take $x\ne x'$ with $x\sim_S x'$ and put
$\mathfrak h=(x\,x')\ne1$. For $y\notin\{x,x'\}$, $\mathfrak hy=y$ so $y\notin\delta$; for
$y\in\{x,x'\}$, $\mathfrak hy\sim_S y$ so $y\notin\delta$. Hence
$\delta_{\mathfrak h}(S)=\emptyset$ with $\mathfrak h\ne1$. $\square$

*Hypothesis actually used:* only that the transpositions are available as holonomies —
(H7). **If the charted structure realises fewer holonomies, the $(\Leftarrow)$ direction
fails and $\operatorname{SearchSep}$ is strictly stronger than what $\operatorname{Ob}$
sees.** Seed149's §8.4 asserted "$\operatorname{SearchSep}$ is the top element of
$\sqsubseteq$" — true, and Theorem 2 is the sharper statement that under (H7) it is also
readable off the obstruction. This is where seed149 was silent about (H7); I name it.

**Corollary 2.1.** $\operatorname{SearchSep}$ is a $\Psi$ in the sense of Theorem F′
(it is a function of $\sim_S$), and it is **not constant**
($\operatorname{SearchSep}(\emptyset)=0$ for $|X|\ge2$; $=1$ for a separating $S$).
Hence by F′ it is **not monotone under unrestricted replacement** — in either
direction. Directly: $S$ separating $\rightsquigarrow S'=\emptyset$ drops it, and the
reverse raises it. So the conjunct is a genuine constraint at a stage and carries
**zero** information about the next stage, absent a restriction on the step.

### 3.3 $\operatorname{PreserveProv}=1$ — type (iii), and its arity is missing.

In D0016 §G this conjunct is written **with no argument at all** — unlike
$\operatorname{Verify}(\Pi_\alpha)$ and $\operatorname{SearchSep}(\mathcal T_\alpha)$.
That is not a transcription slip to be repaired by an agent; it is the state of the
artifact, and per the provenance rule I do not supply the argument. What can be said
exactly: *preservation* is a two-place notion, so **the only type-correct completion is
(ii)**, a predicate on the pair $(\Diamond_\alpha,\Diamond_{\alpha+1})$ — or, reading
§B's $\delta^{\mathrm{prov}}_\sigma$, on the pair of provenance components. Being a pair
predicate, it is outside F and F′. **But escaping a no-go is not the same as being
available:** an undefined conjunct is not decidable by any datum whatever, and §5 turns
on this.

### 3.4 $\operatorname{UsefulEscape}>0$ — type (iii), intended (ii), and the dangerous one.

This is the only conjunct with an **order** in it ($>0$), hence the only one shaped like
a progress measure — which makes it the one Theorem F′ was written for. Its intended
content is legible from D0016 §H: brilliance $=\operatorname{EscapeValue}$(internal
recursive path), trapped-light $\iff\Delta\partial_{\mathrm{future}}=0$,
productive-reflection $\iff\Delta\partial_{\mathrm{future}}\ne0\wedge\operatorname{Verify}=1$.
So the intended type is (ii): a difference of boundaries across a step, $\partial\Diamond$
being $\int^{(f,t)}e(f,t)$ (§B) — a function of the Chu datum, not of $\delta$.

**Proposition 3 (the trap).** If $\operatorname{UsefulEscape}$ is ever given a definition
as a poset-valued function of $\delta_\sigma(\mathcal T_\alpha)$, or of
$\sim_{\mathcal T_\alpha}$, together with the requirement that it be non-increasing (or
non-decreasing) across arbitrary replacements, then by Theorem F (resp. F′) it is
constant, hence either always $>0$ or never — and the conjunct is vacuous or
unsatisfiable.

*Proof.* Immediate from F, F′. $\square$

**Ground and limit:** Proposition 3 is a conditional about definitions not yet made. It
does not refute the conjunct; it fences it. Two escapes remain open and I do not choose
between them: define $\operatorname{UsefulEscape}$ from $\partial$ (outside $\delta$), or
restrict the steps (§4).

*One sentence on D0018 §J5, per mandate item 4:* $\chi_\alpha=\Delta\operatorname{Reach}/\Delta\operatorname{Kill}$
is the same shape as $\operatorname{UsefulEscape}$ — a ratio of stage-differences with an
asserted trichotomy — so Proposition 3 is the general reason its numerator and
denominator cannot be supplied by any function of $\delta$ or of $\sim$; I neither
measure nor rehabilitate it, and I add nothing further about it.

### 3.5 $\operatorname{DeclaredBoundaryPreserved}=1$ — type (ii′), and the way out.

"Declared" is the operative word: the boundary is fixed **in advance**, externally, not
recomputed at each stage. So this conjunct compares $\Diamond_{\alpha+1}$ with a datum
that does not move. Theorems F and F′ both require the two compared objects to range
freely over the realisable values; against a **fixed** anchor $\partial_{\mathrm{decl}}$
the realisability argument has no purchase — one may not "swap the roles of $S$ and
$S'$", because one of the two is not a stage.

**This is the answer to "which hypothesis to drop".** The no-go's hypothesis is not that
progress is measured by $\delta$; it is that progress is measured *relatively*, between
two freely-varying stages. Drop **relativity of the comparison base** and a $\delta$-based
measure returns at once: for fixed $\partial_{\mathrm{decl}}$, the predicate
$S\mapsto[\,\sim_S\subseteq\sim_{\partial_{\mathrm{decl}}}\,]$ *is* monotone along
$\sqsubseteq$ and is not constant. Alternatively drop **unrestrictedness** of the
replacement, which is §8's route. These are the only two hypotheses of F′, and each
gives back exactly what it removes.

---

## 4. Testing seed149 §8 against $\operatorname{Advance}$ — and one real strengthening

§8's proposal: record $\sim_{\mathcal T_\alpha}$ and classify each step as
$\operatorname{Refine}$ ($\sim_{\alpha+1}\subseteq\sim_\alpha$),
$\operatorname{Blunt}$ ($\sim_\alpha\subseteq\sim_{\alpha+1}$), or
$\operatorname{Incomparable}$. All of §4 assumes **(H5) and (H6)**.

**4.1 What §8 claims, exactly.** §8.1–8.4 claim sufficiency for licensing "*$\delta$
moved monotonically, uniformly in the holonomy*" and nothing more; §8.2's converse claim
is that no weaker datum does. **Both are correct at that scope, and neither mentions
$\operatorname{Advance}$.** I record this because the note's own status line ("§8 says
exactly what that datum is") could be read as a claim about $\operatorname{Advance}$; the
body does not make it. Standing check (c) applied to a predecessor: no refutation found
here.

**4.2 Is $\operatorname{Advance}$ decidable given the classification? No — and the
obstruction is not the classification.**

**Theorem 4 (what the datum decides).** Given $\sim_{\mathcal T_\alpha}$ and
$\sim_{\mathcal T_{\alpha+1}}$:
1. $\operatorname{SearchSep}(\mathcal T_\alpha)$ is decided outright — it is the test
   $\sim_{\mathcal T_\alpha}=\Delta_X$, and the datum *contains* $\sim$, which is strictly
   more than the three-way classification.
2. $\operatorname{SearchSep}$ is an **up-set** for $\sqsubseteq$:
   $\operatorname{Refine}\wedge\operatorname{SearchSep}(\mathcal T_\alpha)=1
   \Rightarrow\operatorname{SearchSep}(\mathcal T_{\alpha+1})=1$; and
   $\operatorname{Blunt}\wedge\operatorname{SearchSep}(\mathcal T_\alpha)=0
   \Rightarrow\operatorname{SearchSep}(\mathcal T_{\alpha+1})=0$.
3. The remaining four conjuncts are **not** decided, for the reasons of §3.1, §3.3, §3.4 —
   three are undefined and one ($\operatorname{Verify}$) is a property of a component the
   datum does not mention.

*Proof.* (1) is the definition. (2): $\operatorname{Refine}$ says
$\sim_{\alpha+1}\subseteq\sim_\alpha=\Delta$, and $\Delta$ is the bottom of the
equivalence lattice, so $\sim_{\alpha+1}=\Delta$; the second half is the contrapositive
of the same with the inclusion reversed. (3): there is nothing to prove, and that is the
point. $\square$

**Corollary 4.1.** $\operatorname{Advance}$ is **not** decidable from §8's datum, and
would not be decidable from *any* datum about $(\mathcal T_\alpha,\mathcal T_{\alpha+1})$,
because $\operatorname{Verify}$, $\operatorname{PreserveProv}$,
$\operatorname{UsefulEscape}$ and $\operatorname{DeclaredBoundaryPreserved}$ are not
functions of the test sets at all. **The right conclusion is not that §8 is too weak but
that §8 answers a different question than $\operatorname{Advance}$ asks** — and seed149
did not claim otherwise. What §8 delivers to $\operatorname{Advance}$ is exactly one
conjunct, decided completely.

**4.3 The strengthening: on $\operatorname{Incomparable}$ steps something *does* follow,
namely that they cannot occur.**

**Theorem 3 (SearchSep forbids incomparability).** Assume (H5), (H6). If
$\sim_{\mathcal T_\alpha}=\Delta_X$ — i.e. $\operatorname{SearchSep}(\mathcal T_\alpha)=1$
— then for **every** $\mathcal T_{\alpha+1}$ the step is $\operatorname{Blunt}$. Dually,
if $\sim_{\mathcal T_\alpha}=\nabla_X$ (the instrument separates nothing) then every step
is $\operatorname{Refine}$. Hence
$$\operatorname{Incomparable}\ \Longrightarrow\ \Delta_X\subsetneq\sim_{\mathcal T_\alpha}\subsetneq\nabla_X ,$$
and in particular $\operatorname{Incomparable}\Rightarrow\operatorname{SearchSep}(\mathcal T_\alpha)=0
\Rightarrow\neg\operatorname{Advance}(\Diamond_\alpha)$.

*Proof.* $\Delta_X$ is the least and $\nabla_X$ the greatest element of the equivalence
lattice on $X$, so $\Delta_X\subseteq\sim_{\alpha+1}$ and $\sim_{\alpha+1}\subseteq\nabla_X$
hold unconditionally. Comparability follows in each case. The last implication is the
contrapositive of the first together with the $\operatorname{SearchSep}$ conjunct of
$\operatorname{Advance}$. $\square$

**Proposition 3.1 (minimality, by finite exhaustion).** Incomparable steps require
$|X|\ge3$. *Proof.* The equivalence relations on a $2$-element set are exactly $\Delta$
and $\nabla$ — two of them, listed — and $\Delta\subseteq\nabla$, so the lattice is a
chain and no two elements are incomparable. On $|X|=3$ the partitions $\{12\mid3\}$ and
$\{13\mid2\}$ are incomparable. $\square$ (A complete check of a $2$-element case, hence
proof per `CLAUDE.md`, not a measurement.)

**Reading.** §8.3 says: on Incomparable steps the framework gets nothing. That is
**true and stays true**. Theorem 3 adds that on the runs $\operatorname{Advance}$ is
about, the case is **empty**: an Advancing stage is separating, and no step out of a
separating stage is incomparable. So §8.3 is not refuted; its scope is shown to be
disjoint from $\operatorname{Advance}$'s.

**4.4 The price: $\delta$ is constant along Advancing runs.**

**Theorem 5.** Assume (H5), (H6). If $\operatorname{SearchSep}(\mathcal T_\alpha)=1$ and
$\operatorname{SearchSep}(\mathcal T_{\alpha+1})=1$, then $\sim_{\mathcal T_\alpha}=\sim_{\mathcal T_{\alpha+1}}=\Delta_X$,
hence $\delta_\sigma(\mathcal T_{\alpha+1})=\delta_\sigma(\mathcal T_\alpha)$ for **every**
holonomy $\sigma$, and $\operatorname{Ob}(\mathcal T_{\alpha+1})=\operatorname{Ob}(\mathcal T_\alpha)$.
Consequently, along any run on which $\operatorname{Advance}$ holds at every stage, the
obstruction is **constant in $\alpha$**.

*Proof.* Both are $\Delta_X$, so the step is simultaneously Refine and Blunt and, by
seed149's Remark 1.1 ($\delta_\sigma(S)$ depends on $S$ only through $\sim_S$), the two
defects coincide at each $\sigma$. Iterate. $\square$

**This is the clean negative of the note.** Not merely "$\delta$ is not a progress
measure under replacement" (Theorem F) but: *on exactly the runs the framework certifies
as advancing, $\delta$ does not move at all.* It is D0016 §G's own box
$\delta=0\not\Rightarrow\operatorname{Advance}$ pushed to its limit: not only does
vanishing curvature fail to be truth, but **curvature is informationally inert along
Advancing runs**, and any progress the framework claims must come from the four non-$\delta$
conjuncts — which are the four that are undefined.

*Scope, stated plainly:* Theorem 5 assumes (H6), a fixed carrier. §7 is about whether the
framework supplies it, and if it does not, Theorem 5 lapses along with Theorems F and F′.

---

## 5. Where the mandate's trichotomy needed repair

For the record, since the deliverable was to be exact about (i)/(ii)/(iii):

- No conjunct is *only* a function of the pair $(\mathcal T_\alpha,\mathcal T_{\alpha+1})$.
  The two that are pair-shaped ($\operatorname{PreserveProv}$, $\operatorname{UsefulEscape}$)
  are pairs of **stages**, of which the test sets are one component among seven.
- Exactly one conjunct is a function of $\delta$, and it is a function of the family, not
  of a single $\delta_\sigma$ — so it needed Theorem F′, not Theorem F. Had I applied
  Theorem F to it directly I would have committed the error the mandate warned of:
  using a single-holonomy no-go against a holonomy-uniform object.
- The fifth type, (ii′), is not in the trichotomy and is the only one that survives with
  progress-carrying capacity.

---

## 6. Does $\Phi$ produce comparable steps? — first, a notation collision in the source

D0018 §D's clause is
$$\mathcal O_\alpha\subseteq\mathcal O_{\alpha+1},\qquad
\operatorname{Obs}_{\mathcal O_\alpha}(X_\alpha)=0\ \not\Rightarrow\ \operatorname{Obs}_{\mathcal O_{\alpha+1}}(X_\alpha)=0,$$
with $\Phi=$ *दृश्यभेदक्षेत्रविस्तारः*, the widening of the field of visible distinction.

**Observation (not a correction — the artifacts are the owner's).** $\mathcal O_\alpha$
carries **two different meanings** across the transmissions. In D0016 §B,
$\mathcal O_\alpha:=\int^{\sigma\in N(\mathcal F_\alpha)}\delta_\sigma$ — the
*obstruction*, an output. In D0018 §D, $\mathcal O_\alpha$ is what
$\operatorname{Obs}_{\mathcal O_\alpha}(-)$ is *indexed by* and satisfies
$\mathcal O_\alpha\subseteq\mathcal O_{\alpha+1}$ — an *observable/test collection*, an
input. These are not the same type; under the D0016 reading "$\mathcal O_\alpha\subseteq\mathcal O_{\alpha+1}$"
would be an assertion that obstructions grow, which is not what §D's gloss says. **I work
under the D0018 §D reading — $\mathcal O$ as observables, i.e. in the role of
$\mathcal T$ — and flag that the identification of the two $\mathcal O$'s is the owner's
to make or refuse.**

**Theorem 6 ($\Phi$, as described in D0018 §D, produces only comparable steps).** Under
that reading and (H6): $\mathcal O_\alpha\subseteq\mathcal O_{\alpha+1}$ implies
$\sim_{\mathcal O_{\alpha+1}}\subseteq\sim_{\mathcal O_\alpha}$, i.e.
$\mathcal O_\alpha\sqsubseteq\mathcal O_{\alpha+1}$: the step is $\operatorname{Refine}$.
Hence $\delta_\sigma(\mathcal O_\alpha)\subseteq\delta_\sigma(\mathcal O_{\alpha+1})$ for
every $\sigma$, and **no step of $\Phi$ is Incomparable**.

*Proof.* $\sim_S=\bigcap_{t\in S}\sim_{\{t\}}$ is antitone in $S$, so
$S\subseteq S'\Rightarrow\sim_{S'}\subseteq\sim_S$ (seed149 Lemma 6.2). The defect
inclusion is Theorem E(a)$\Rightarrow$(b), whose proof does not use (H7). $\square$

**Corollary 6.1 (the owner's non-implication is a theorem, and it is the dual of §G's
box).** $\operatorname{Obs}_{\mathcal O_\alpha}(X_\alpha)=0\not\Rightarrow\operatorname{Obs}_{\mathcal O_{\alpha+1}}(X_\alpha)=0$
is exactly the assertion that $\operatorname{Refine}\Rightarrow\delta\uparrow$ weakly and
that the rise can be strict. Both halves now have proofs: the monotone half is Theorem 6;
strictness is witnessed by seed148's E1 read backwards (a constant column adjoined to a
non-constant one, $\mathfrak h=\mathrm{sw}$: $\delta=\emptyset$ on the smaller set, $=X$
on the larger). D0016 §G's $\operatorname{Shrink}(\mathcal T)\Rightarrow\delta\downarrow$
and D0018 §D's widening clause are therefore **one statement seen from its two sides**,
and the statement is Theorem E.

---

## 7. Is Theorem F vacuous for the framework? — the exact answer, and it is a discrepancy

Theorem 6 says: *if* the step is $\Phi$ *and* $\Phi$ is enlargement *and* the carrier is
fixed, then the replacement is comparable, Theorem F′'s "unrestricted" hypothesis fails,
and the no-go is **vacuous**. Three conditionals, and the framework satisfies at most the
third. Taking them in turn:

**7.1 The step is not $\Phi$.** D0016 §E defines the step functor as
$$\mathfrak F_\alpha:=\ulcorner-\urcorner_\alpha\circ\vee_\alpha\circ\Phi_\alpha\circ\Gamma_\alpha\circ\delta_\alpha\circ\partial_\alpha .$$
D0018 §D defines it as $\mathfrak F:=\Phi\circ\Gamma\circ\partial$. **These differ by
$\vee$ and $\ulcorner-\urcorner$**, and the difference is decisive:

**Proposition 7 ($\vee$ destroys the comparison).** $\vee:\mathcal F_\alpha\rightleftarrows\mathcal T_\alpha$
with $e^\vee(t,f)=e(f,t)$ transposes the two sorts. After a $\vee$, the test set of the
successor stage is (built from) the *object* set of the predecessor. Hence
$\mathcal T_{\alpha+1}$ and $\mathcal T_\alpha$ do not lie in a common test universe:
**(H5) fails, $\sqsubseteq$ is undefined between them, and the step is neither
Comparable nor Incomparable — the comparison has no truth value.**

*Proof.* $\sqsubseteq$ is defined (Definition 6.1 of seed149) only for subsets of one
$\mathcal T$ with one $e$; $\sim_{\mathcal T_{\alpha+1}}$ after a transposition is an
equivalence on $\mathcal F_\alpha$, not on $X_\alpha$. There is no canonical map along
which to pull it back — the Chu duality is a symmetry, not a morphism of one sort. $\square$

**7.2 $\Phi$ itself is not described as enlargement in D0016.** D0016 §D's fourth factor
is $\Phi_{\mathrm{cut}}$, "**recut** of $(\mathcal F,\mathcal T,e)$, adjoining Fourier,
Mellin, $(-)^\vee$, Loc, Lift, Quot, Scale, Loop, Witness, Continuation". *Recut* is
replacement, and the list contains $(-)^\vee$ and $\operatorname{Quot}$ — a duality and a
quotient, neither of which enlarges $\sim$-resolution in the required direction. And
D0016 §F states the alternative in as many words: $\mathcal T_\alpha\subseteq\mathcal T_{\alpha+1}$
**or not**.

**7.3 $\Gamma$ moves the carrier.** Even in D0018's leaner $\mathfrak F=\Phi\circ\Gamma\circ\partial$,
$\Gamma$ adjoins cells: $X^+_\alpha=X_\alpha\amalg^h_{\partial\mathcal O_\alpha}\Gamma_\alpha\langle\mathcal O_\alpha\rangle$
(D0016 §C), and D0018 §D writes $(X_{\alpha+1},\mathcal O_{\alpha+1})=\mathfrak F(X_\alpha,\mathcal O_\alpha)$.
So $X$ changes and (H6) fails for $\mathfrak F$ — while holding for $\Phi$ alone, which is
precisely what "$\Phi$ does not change the object" says. **The owner's clause is a
statement about $\Phi$, and it is being asked to do the work of a statement about
$\mathfrak F$.** There is a repair, and I state it as a conditional rather than assert it:

**Proposition 8 (comparability restorable along $\iota$).** Suppose (a) the pushout
supplies $\iota:X_\alpha\to X_{\alpha+1}$, and (b) every observable in
$\mathcal O_\alpha$ arises as the $\iota$-restriction of an observable in
$\mathcal O_{\alpha+1}$. Then $\iota^*\!\sim_{\mathcal O_{\alpha+1}}\ \subseteq\ \sim_{\mathcal O_\alpha}$
on $X_\alpha$, and the step is Refine after pullback.

*Proof.* If $x\,(\iota^*\!\sim_{\alpha+1})\,x'$ then $\iota x\sim_{\mathcal O_{\alpha+1}}\iota x'$,
so all observables of $\mathcal O_{\alpha+1}$ agree on them; by (b) every observable of
$\mathcal O_\alpha$ is such an observable restricted along $\iota$, so all of those agree
too, i.e. $x\sim_{\mathcal O_\alpha}x'$. $\square$

Hypothesis (b) is **not** given by D0016 or D0018; it is the exact extra assumption under
which the widening clause survives a carrier change. I flag it as the smallest thing the
framework would need to add, and I do not assume it elsewhere.

**7.4 The verdict.** Stated at the generality I can defend, with the announced arrows
kept as arrows:

> **Theorem F/F′ is neither fatal to the framework nor irrelevant to it. It is
> *conditionally vacuous*, and the condition is a discrepancy between two owner
> transmissions.** Under D0018 §D's dynamics ($\mathfrak F=\Phi\circ\Gamma\circ\partial$,
> $\mathcal O_\alpha\subseteq\mathcal O_{\alpha+1}$, $\Phi$ object-preserving), plus
> Proposition 8(b) to survive $\Gamma$, every step is Refine (Theorem 6), the
> unrestricted-replacement hypothesis is never met, and the no-go says nothing.
> Under D0016 §E's dynamics ($\mathfrak F$ containing $\vee$ and $\ulcorner-\urcorner$,
> $\Phi_{\mathrm{cut}}$ a *recut*, §F's explicit "or not"), the steps are not comparable —
> indeed after $\vee$ they are not even *comparable-or-not*, since (H5) fails and the
> relation is undefined (Proposition 7). There the no-go bites, and bites harder than
> stated, because a framework whose successive instruments cannot be compared has no
> progress criterion of *any* shape, $\delta$-based or not.

**The single decision this puts to the owner:** *is $\Phi_{\mathrm{cut}}$ an enlargement
of the observable field, or a recut of it, and does the step functor contain $\vee$?*
D0018 §D and D0016 §D/§E/§F answer differently. Everything above is a conditional on that
answer, and I have not chosen it.

---

## 8. Scope limits, and non-comparability with other passes

- **(H6) everywhere.** Theorems 3, 4, 5, 6 compare equivalence relations on one carrier.
  Without a fixed $X$ or Proposition 8's $\iota$, they lapse. Theorems F, F′ need only
  (H5).
- **(H7) for Theorem 2 only.** If the charted structure realises fewer holonomies than the
  transpositions, Theorem 2's $(\Leftarrow)$ fails and $\operatorname{SearchSep}$ is
  strictly stronger than the obstruction can see; Theorem 3 is unaffected (its proof uses
  only lattice bounds).
- **Definitions I did not supply.** $\operatorname{Verify}$, $\operatorname{PreserveProv}$,
  $\operatorname{UsefulEscape}$, $\operatorname{DeclaredBoundaryPreserved}$ are left
  undefined, deliberately. Every statement about them above is either a type statement or
  a conditional on a future definition (Proposition 3).
- **Untouched.** D0018 §J5's $\chi_\alpha$ (one sentence in §3.4 and no more); the ordinal
  ladder §C; $\delta_\triangleleft/\delta_\triangleright$ (D0018 §C); the Yang–Baxter
  defect; the Tate construction §E; D0017 §F entirely.
- **No numbers.** This note contains no measurement, no fitted constant, no
  floating-point quantity, and no comparison of counts with any other pass — there is
  nothing here to compare, and I make no cross-pass numerical claim.
- **No machine verification.** No Agda or Lean was authored; there is no toolchain in
  this container and **no typechecking is claimed**. Every proof is finite and hand-checked;
  Proposition 3.1's $|X|=2$ case is a complete two-element enumeration, written out.
- **No Python.**

---

## 9. Prior art, searched before writing

Searched: "every equivalence relation arises as kernel of a test set / partition lattice /
monotone progress measure / no ranking function exists" and two refinements toward
verification and testing. What the results give:

- **Lemma 1 is textbook.** The kernel–partition correspondence — *"every function gives
  rise to an equivalence relation as kernel, and conversely every equivalence relation on
  $X$ arises as the kernel of a function"* — is stated on Wikipedia's *Kernel (set theory)*
  and in standard notes (Terek, *Equivalence relations, quotients, and examples*). **No
  novelty claimed for Lemma 1**; the novelty, if any, is that this triviality is what
  kills every resolving-power progress measure (Theorem F′).
- **The partition/equivalence lattice** and its bounds $\Delta,\nabla$ — used in Theorems
  3, 4 — are classical (PlanetMath, *partitions form a lattice*). Ellerman's *The Logic of
  Partitions* (arXiv 0902.1950) is the systematic dual-to-subsets treatment; my
  $\sqsubseteq$ is its refinement order, and "$\operatorname{SearchSep}$ = the discrete
  partition" is its bottom element. Located by search; I read the abstract listing only,
  and quote no numbered result from it.
- **"Questions as cognitive filters"** (arXiv 2506.22735) surfaced as treating questions
  as partitions — the same move as tests-as-resolving-power. **Located by title only, not
  read**; I make no claim about its content and no claim of independence from it.
- **Progress measures / ranking functions.** The verification literature (parity games,
  progress measures) uses *well-founded* codomains; Theorem F′'s codomain is an arbitrary
  poset and the obstruction is realisability, not well-foundedness. I found no statement
  of the form "no non-constant monotone functional exists on a lattice all of whose pairs
  are jointly realisable" — it is a two-line triviality once posed, and I assume it is
  folklore rather than claim it.
- **Not re-searched:** Galois connections, FCA, Chu spaces — seed149 §10 did that work,
  I read it, and Theorems A–C, E are cited from there as classical.

**What is new here, honestly and briefly.** (1) Theorem F′, the family/resolving-power
version of seed149's Theorem F, and the observation that F alone does not reach
$\operatorname{SearchSep}$. (2) Theorem 2, $\operatorname{SearchSep}$ as a functional of
the defect family, with (H7) isolated. (3) Theorem 3 — separating instruments admit no
incomparable successor — and Theorem 5, that $\delta$ is constant along Advancing runs.
(4) The conjunct classification, including the two types the mandate's trichotomy lacked.
(5) The location of the $\Phi$ discrepancy (§7) and the notation collision in
$\mathcal O_\alpha$ (§6). Items (1)–(3) are elementary; I would rather say so than
decorate them.

---

## 10. What this note licenses

> Of D0016 §G's $\operatorname{Advance}$, one conjunct is a function of the defect
> ($\operatorname{SearchSep}$), one is a function of a disjoint component
> ($\operatorname{Verify}$), and three are undefined; the no-go of seed149 §7 refutes only
> the reading in which progress is certified by comparing defects across a step, and it
> needs strengthening to F′ before it reaches $\operatorname{SearchSep}$ at all. Given the
> recorded resolving power, $\operatorname{SearchSep}$ is decided completely and the other
> four are decided not at all, so $\operatorname{Advance}$ is not decidable — for want of
> definitions, not for want of data. On the runs where it holds, incomparable steps cannot
> occur and the defect does not move. And whether the no-go applies to the framework at
> all turns on a question the transmissions answer two ways: whether $\Phi$ enlarges the
> observable field or recuts it, and whether the step functor contains the Chu duality.

Not licensed: any claim about $\chi_\alpha$; any claim about stages with unrelated test
universes beyond Proposition 7's negative; any claim that supplying the four missing
definitions is *possible*, let alone easy.

---

*Framework, $\operatorname{Advance}$, and the widening-observable clause: the repository
owner, D0016 §G and D0018 §D, 2026-08-14. Theorems A–F and the §8 proposal: seed149,
`notes/CHANGING_TESTS_VERSUS_SHRINKING.md`. Theorems C and F re-derived here; Lemma 1,
Theorems 2–6, Propositions 3, 3.1, 7, 8: this note. No experiment was run.*
