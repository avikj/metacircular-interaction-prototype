# Changing the tests versus shrinking them

**Status.** Proved, with three finite counterexamples (two of them exhaustively
minimal). **Verdict in one line:** under *shrinking* the defect is monotone
(predecessor note, verified below); under *replacement* it is monotone **exactly**
when the new test set lies in a computable closure of the old (Thm C), the
inclusion order is **not** the right order (Thm E), and **under unrestricted
replacement there is no monotone quantity at all** (Thm F) — so D0016 §G's slogan
does not extend to §F's "$\mathcal T_\alpha\subseteq\mathcal T_{\alpha+1}$ **or
not**" without adding a comparison datum the framework does not currently carry.
§8 says exactly what that datum is, and does not smuggle in anything else.

**Source of the question.** The repository owner, `collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md`,
**§F** — *मापनक्षेत्रम् अपि परिवर्तते*, the measurement domain itself changes —
and §G's boxed $\operatorname{Shrink}(\mathcal T)\Rightarrow\delta\downarrow$. The
framework, the signature and the slogan are the owner's; D0017 §J2's warning about
conflating halves of a correspondence is the owner's too and is honoured in §9.
Everything below §0 is derived from those artifacts and does not amend them.

**Predecessor.** `notes/SHRINKING_TESTS_LOWER_CURVATURE.md` (seed148), whose §6
names this case as its own scope limit: *"Def. 1.7 covers $\mathcal T'\subseteq\mathcal T$
only … Nothing here bears on that case, which is the interesting one for §C."*
That note is verified in §0 below; its theorems stand, one of its remarks and one
line of its covering message do not.

---

## 0. Verification of the predecessor

Read in full, and every proof re-derived rather than trusted.

**0.1 Theorem 1 (shrink $\Rightarrow$ $\delta$ non-increasing) — correct.** With
$D_\sigma(x)=\{t : e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$ and
$\delta^S_\sigma=\{x : D_\sigma(x)\cap S\ne\emptyset\}$, the four lines are:
$S'\subseteq S$, so $D_\sigma(x)\cap S\supseteq D_\sigma(x)\cap S'$, so
non-emptiness of the latter forces non-emptiness of the former. Verified.

**0.2 Theorem 2 (difference formula) and Cor. 3.1 — correct, and the iff is
earned.** $x\in\delta^S_\sigma\setminus\delta^{S'}_\sigma$ iff
$D_\sigma(x)\cap S\ne\emptyset$ and $D_\sigma(x)\cap S'=\emptyset$, which is
exactly $\emptyset\ne D_\sigma(x)\cap S\subseteq S\setminus S'$. This is an
equality of sets, so both directions of "strict iff …" are the same computation;
the note does not overstate. Verified.

**0.3 Theorem 5 (minimality of E1) — correct, count re-done independently.**
Bounds $|X|\ge2$ (else $\operatorname{Aut}(X)=1$), $|Q|\ge2$ (else no detector),
$|\mathcal T|\ge2$ (else no nonempty proper subset): all three verified. At
$(|X|,|\mathcal T|,|Q|)=(2,2,2)$ with $\mathcal T'=\{t_2\}$ and
$\mathfrak h=\mathrm{sw}$, a column $t$ gives $\delta^{\{t\}}=X$ if non-constant
and $\emptyset$ if constant, so the requirement is "$t_2$ constant and $t_1$
non-constant" $=2\times2=4$ of $16$. The four are $\bigl((0,1),(0,0)\bigr)$,
$\bigl((1,0),(0,0)\bigr)$, $\bigl((0,1),(1,1)\bigr)$, $\bigl((1,0),(1,1)\bigr)$;
the row swap flips both columns, the $Q$ swap flips both columns, and these two
together with the identity carry the first onto the other three. One orbit.
Verified, including the "all isomorphic to E1" clause.

**0.4 Correction — Remark 2.2 of the predecessor is imprecise as stated.** It
says: *"The complementary map $S\mapsto\;\sim_S$ is antitone and is the polar; the
pair $(\operatorname{Sep},\sim)$ is the standard Birkhoff polarity."* A Birkhoff
polarity is a pair of **antitone** maps; $\operatorname{Sep}$ is monotone, so
$(\operatorname{Sep},\sim)$ is not one. What is true, and is what the note needed:
$\sim_S$ is the polar of $S$ **for the complementary relation** $R^{c}$
("$t$ does not separate $(x,x')$"), i.e. $\sim_{(-)}$ is one half of the Birkhoff
polarity of $R^{c}$. $\operatorname{Sep}$ is the *complement* of that polar, not a
polar. No theorem of the predecessor depends on the misstatement — Theorem 1 is
proved directly from Def. 1.6, not from Rmk 2.2 — so the verdict stands and only
the ground is repaired. §3 below supplies the adjunction $\operatorname{Sep}$ and
$\delta$ actually satisfy, which is a **monotone** Galois connection, not a
polarity; that is the correct structural home for Theorem 1.

**0.5 Correction — the covering message `0749-seed148` overstates in its subject
line.** It says the drop is strict *"iff some discarded test is the SOLE witness
of a displaced point."* That is Cor. 3.1, which is the case
$|S\setminus S'|=1$. For $|S\setminus S'|\ge2$ the "iff" is false left-to-right:
take $X=\{x_0,x_1\}$, $\mathcal T=\{t_1,t_2\}$ both columns non-constant,
$\mathfrak h=\mathrm{sw}$, $S=\mathcal T$, $S'=\emptyset$. The drop is strict
($X\to\emptyset$), yet neither discarded test is anybody's sole witness —
$D_\sigma(x)=\{t_1,t_2\}$ for both points. The correct condition is Theorem 2's:
some point's *entire* $S$-detector set is discarded. The message's own body states
Theorem 2 correctly; it is the summary line that is wrong. (Standing check (c):
summary refuted by its own body. Verdict preserved, statement corrected.)

**Conclusion of §0.** The predecessor's Theorems 1–5 and both counterexamples are
correct as written. Two repairs: Rmk. 2.2's classification of the polarity, and
the covering message's strictness slogan. Neither disturbs any proved statement.

---

## 1. Setting and standing hypotheses

I keep the predecessor's definitions verbatim and add nothing to them.

**(H1)** $\mathcal C=(X,\mathcal T,e)$ is a Chu space, $e:X\times\mathcal T\to Q$,
with $X,\mathcal T,Q$ **finite** wherever a counterexample or a cardinality is
asserted; the positive theorems (A–C, E, and the adjunction) hold for arbitrary
sets, with "complete lattice" read as full powerset.

**(H2)** For $S\subseteq\mathcal T$: $x\sim_S x'\iff \forall t\in S,\ e(x,t)=e(x',t)$.

**(H3)** A charted structure supplies $\mathfrak h_\sigma\in\operatorname{Aut}(X)$
for $\sigma\in N(I)$ (Def. 1.3–1.4 of the predecessor). Where a theorem quantifies
over *all* holonomies I say so explicitly; Theorem E does, Theorems A–D do not.

**(H4)** $D_\sigma(x):=\{t\in\mathcal T : e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$,
and
$$\delta_\sigma(S)\;=\;\{x\in X : D_\sigma(x)\cap S\ne\emptyset\},\qquad
\operatorname{Ob}(S):=\bigl(\delta_\sigma(S)\bigr)_{\sigma\in N(I)} .$$

**(H5) Replacement.** $\operatorname{Replace}$ is the passage
$\mathcal T\rightsquigarrow S'$ with $S'\subseteq\mathcal T$ **arbitrary** —
in particular $S'$ and the incumbent $S$ may be incomparable. This is the reading
of D0016 §F's "**or not**". The ambient $\mathcal T$ is a common universe of
tests; the genuinely fibred case, where two stages do not even share a test
universe, is **out of scope** (§9).

*Remark 1.1.* $\delta_\sigma(S)$ depends on $S$ **only through $\sim_S$**:
$x\in\delta_\sigma(S)\iff(\mathfrak h_\sigma x,x)\notin\;\sim_S$. Every structural
statement below is therefore really a statement about the map
$S\mapsto\;\sim_S$ into the partition lattice of $X$. This is the observation that
makes §6 possible and it is why inclusion is the wrong order.

---

## 2. The lattice, and what $\delta$ does to joins

$(\mathcal P(\mathcal T),\subseteq)$ is a complete Boolean lattice with
$\vee=\cup$, $\wedge=\cap$. The first question of the mandate — *is
$\delta_\sigma(S\cup S')$ determined by $\delta_\sigma(S)$ and $\delta_\sigma(S')$?*
— has a clean affirmative answer, and the corresponding question for $\cap$ has a
clean negative one (§5).

**Theorem A (join-preservation; $\delta$ is determined by singletons).**
For every $\sigma$ and every family $\{S_j\}_{j\in J}$ of subsets of $\mathcal T$,
$$\delta_\sigma\Bigl(\bigcup_{j} S_j\Bigr)=\bigcup_{j}\delta_\sigma(S_j),
\qquad\text{in particular}\qquad
\delta_\sigma(S)=\bigcup_{t\in S}\delta_\sigma(\{t\}),\qquad \delta_\sigma(\emptyset)=\emptyset .$$
The same holds componentwise for $\operatorname{Ob}$.

*Proof.* $D_\sigma(x)\cap\bigcup_j S_j\ne\emptyset$ iff $D_\sigma(x)\cap S_j\ne\emptyset$
for some $j$. The empty family gives $\delta_\sigma(\emptyset)=\emptyset$. $\square$

**Corollary A.1.** $\delta_\sigma:\mathcal P(\mathcal T)\to\mathcal P(X)$ is a
**complete join-homomorphism**, hence monotone — which re-proves the predecessor's
Theorem 1 as a special case ($S'\subseteq S\Rightarrow S=S'\cup S$). It is **not**
a lattice homomorphism (§5) and **not** injective (predecessor Cor. 3.2).

**Corollary A.2 (the defect of a union is never a surprise).** $\operatorname{Ob}$
carries the join of test sets to the join of obstructions. Consequently *adding*
tests can only raise the defect, and raises it by exactly
$\delta_\sigma(S'\setminus S)\setminus\delta_\sigma(S)$. Union is therefore not
where the difficulty of §F lies; the difficulty is that replacement is not a
union.

---

## 3. Is $\operatorname{Ob}(-)$ a closure operator, a Galois connection, or neither?

**Answer: none of the three as posed, and precisely one of them after the type is
fixed.** $\operatorname{Ob}$ has domain $\mathcal P(\mathcal T)$ and codomain
$\prod_\sigma\mathcal P(X)$; a closure operator is an endomap, so
$\operatorname{Ob}$ is not one, for type reasons alone. It is not an antitone
Birkhoff polarity either (it is monotone). What it *is*:

**Theorem B (the adjunction).** Define
$$\delta^{*}_\sigma:\mathcal P(X)\to\mathcal P(\mathcal T),\qquad
\delta^{*}_\sigma(A):=\{t\in\mathcal T : \delta_\sigma(\{t\})\subseteq A\}
=\{t : \forall x,\ t\in D_\sigma(x)\Rightarrow x\in A\}.$$
Then $\delta_\sigma\dashv\delta^{*}_\sigma$ is a **monotone Galois connection**:
$$\delta_\sigma(S)\subseteq A \iff S\subseteq\delta^{*}_\sigma(A).$$
Consequently $C_\sigma:=\delta^{*}_\sigma\circ\delta_\sigma$ is a closure operator
on $\mathcal P(\mathcal T)$ — extensive, monotone, idempotent — and
$\delta_\sigma\circ C_\sigma=\delta_\sigma$.

*Proof.* By Theorem A, $\delta_\sigma(S)\subseteq A$ iff
$\delta_\sigma(\{t\})\subseteq A$ for every $t\in S$, iff $S\subseteq\delta^*_\sigma(A)$.
That is the adjunction. Extensivity, monotonicity and idempotence of the composite
of an adjoint pair are the standard consequences (Ore 1944; see §10). Finally
$\delta_\sigma C_\sigma=\delta_\sigma$ because for any adjunction
$\delta\delta^*\delta=\delta$. $\square$

**Explicitly.**
$$\boxed{\;C_\sigma(S)=\{\,t\in\mathcal T\;:\;\forall x,\ t\in D_\sigma(x)\Rightarrow D_\sigma(x)\cap S\ne\emptyset\,\}\;}$$
— *the tests that are redundant given $S$*: every point $t$ can detect is already
detected by something in $S$.

**Corollary B.1 (the largest instrument with a given defect).** $C_\sigma(S)$ is
the largest $S''\subseteq\mathcal T$ with $\delta_\sigma(S'')=\delta_\sigma(S)$,
and $\delta_\sigma(S'')=\delta_\sigma(S)$ iff $C_\sigma(S'')=C_\sigma(S)$. The
fibres of $\delta_\sigma$ are exactly the intervals $[\,\cdot\,,C_\sigma(S)]$
meeting the closed sets.

*Proof.* $\delta_\sigma(S'')\subseteq\delta_\sigma(S)\iff S''\subseteq C_\sigma(S)$
by Theorem B with $A=\delta_\sigma(S)$; take $S''=C_\sigma(S)$ for the maximality
and note $\delta_\sigma C_\sigma=\delta_\sigma$. $\square$

**Corollary B.2 (criticality, re-derived).** $t$ is $\sigma$-critical in $S$
(predecessor Cor. 3.1) iff $t\notin C_\sigma(S\setminus\{t\})$.

**Definition B.3 (joint closure).** $C(S):=\bigcap_{\sigma\in N(I)}C_\sigma(S)$.
This is the closure operator of the tupled adjunction
$\operatorname{Ob}\dashv\operatorname{Ob}^{*}$,
$\operatorname{Ob}^{*}\bigl((A_\sigma)_\sigma\bigr)=\bigcap_\sigma\delta^{*}_\sigma(A_\sigma)$,
$\operatorname{Ob}$ being a complete join-homomorphism into
$\prod_\sigma\mathcal P(X)$ by Theorem A. In particular $C$ **is** idempotent —
which does not follow from intersecting closure operators in general, and is here
inherited from the adjunction rather than assumed.

So the honest classification: **$\operatorname{Ob}$ is the left adjoint of a
monotone Galois connection; the closure operator lives downstairs on test sets and
is redundancy-saturation.** This is the structure the predecessor's Rmk. 2.2 was
reaching for and misnamed (§0.4).

---

## 4. Replacement: the exact criterion

**Theorem C (replacement comparison).** For arbitrary $S,S'\subseteq\mathcal T$
— comparable or not — and a fixed charted structure:
$$\delta_\sigma(S')\subseteq\delta_\sigma(S)\iff S'\subseteq C_\sigma(S),
\qquad\qquad
\operatorname{Ob}(S')\le\operatorname{Ob}(S)\iff S'\subseteq C(S).$$

*Proof.* Theorem B with $A=\delta_\sigma(S)$ gives
$\delta_\sigma(S')\subseteq\delta_\sigma(S)\iff S'\subseteq\delta^*_\sigma\delta_\sigma(S)=C_\sigma(S)$.
For the joint statement apply the same to $\operatorname{Ob}\dashv\operatorname{Ob}^*$. $\square$

**Corollary C.1 (Theorem 1 of the predecessor, generalised).** $S'\subseteq S$
implies $S'\subseteq C(S)$ by extensivity, so shrinking is the special case. The
converse fails: $C(S)$ is in general strictly larger than $S$, so there are
replacements $S'\not\subseteq S$ that still do not raise the defect — precisely
those that add only redundant tests.

**Corollary C.2 (an exact, checkable test for §F).** Whether a change of
measurement domain $\mathcal T_\alpha\rightsquigarrow\mathcal T_{\alpha+1}$ lowers
or raises the obstruction is decided by a finite membership check
$\mathcal T_{\alpha+1}\subseteq C(\mathcal T_\alpha)$, and the check depends on the
holonomy. This is the sharpest positive statement available *for a fixed $\rho$*.
It is **not** a law about instruments: §6 shows what a law about instruments must
look like, and §7 shows that without one there is nothing.

---

## 5. Meets fail, and by exactly how much

**Proposition D.0 (one direction is automatic).** $\delta_\sigma(S\cap S')\subseteq
\delta_\sigma(S)\cap\delta_\sigma(S')$, by monotonicity. **Hence the converse
question posed in the mandate is answered in the negative unconditionally:** it is
*impossible* to have $\delta_\sigma(S\cap S')\ne\emptyset$ while
$\delta_\sigma(S)=\delta_\sigma(S')=\emptyset$. No example need be sought.

**Theorem D (exact defect of the meet).**
$$\bigl(\delta_\sigma(S)\cap\delta_\sigma(S')\bigr)\setminus\delta_\sigma(S\cap S')
=\{\,x : D_\sigma(x)\cap S\ne\emptyset,\ D_\sigma(x)\cap S'\ne\emptyset,\ D_\sigma(x)\cap S\cap S'=\emptyset\,\}.$$
It is nonempty in general, so $\delta_\sigma$ does **not** preserve meets and is
not a lattice homomorphism.

*Proof.* Unfold the three memberships; the displayed set is the conjunction of the
first two with the negation of the third. Non-emptiness: Example E3. $\square$

### E3 — $\delta(S\cap S')=\emptyset$ with both $\delta(S),\delta(S')\ne\emptyset$

$X=\{x_0,x_1\}$, $Q=\{0,1\}$, $\mathcal T=\{t_1,t_2\}$, both columns non-constant,
e.g.

| | $t_1$ | $t_2$ |
|---|---|---|
| $x_0$ | 0 | 0 |
| $x_1$ | 1 | 1 |

$\mathfrak h_\sigma=\mathrm{sw}$ (realised as in the predecessor's Rmk. 5.3 with
two charts). Then $D_\sigma(x_0)=D_\sigma(x_1)=\{t_1,t_2\}$. With $S=\{t_1\}$,
$S'=\{t_2\}$: $\delta_\sigma(S)=\delta_\sigma(S')=X\ne\emptyset$ while
$S\cap S'=\emptyset$ and $\delta_\sigma(\emptyset)=\emptyset$. Six evaluations,
all displayed.

**Theorem D.1 (minimality of E3, by exhaustion).** Suppose $X,\mathcal T,Q$,
$\mathfrak h\in\operatorname{Aut}(X)$ and $S,S'\subseteq\mathcal T$ satisfy
$\delta(S\cap S')=\emptyset\ne\delta(S)$ and $\delta(S')\ne\emptyset$ with $S,S'$
incomparable. Then $|X|\ge2$, $|Q|\ge2$, $|\mathcal T|\ge2$, and E3 attains all
three. At $(|X|,|\mathcal T|,|Q|)=(2,2,2)$ **exactly $4$ of the $16$ Chu matrices
work, falling into exactly $2$ isomorphism classes.**

*Proof.* *(Bounds.)* $|Q|=1\Rightarrow D_\sigma\equiv\emptyset$;
$|X|=1\Rightarrow\operatorname{Aut}(X)=1\Rightarrow\mathfrak h=\mathrm{id}$; each
contradicts $\delta(S)\ne\emptyset$. Incomparable $S,S'$ require
$|\mathcal T|\ge2$.

*(Exhaustion at $(2,2,2)$.)* Incomparable subsets of a $2$-element $\mathcal T$
are forced to be $\{t_1\},\{t_2\}$, so $S\cap S'=\emptyset$ and
$\delta(S\cap S')=\emptyset$ automatically. $\mathfrak h=\mathrm{id}$ gives
$\delta\equiv\emptyset$, so $\mathfrak h=\mathrm{sw}$, under which
$\delta(\{t\})=X$ iff column $t$ is non-constant and $\emptyset$ otherwise. The
requirement is therefore: **both** columns non-constant, i.e. each of $t_1,t_2$
lies in $\{(0,1),(1,0)\}$ — $2\times2=4$ of the $4\times4=16$ matrices.

*(Two classes, not one.)* Write $a=(0,1)$, $b=(1,0)$; the four matrices are the
column pairs $(a,a),(a,b),(b,a),(b,b)$. An isomorphism may permute $X$, $Q$ and
$\mathcal T$, and must conjugate $\mathrm{sw}$ to $\mathrm{sw}$ (both available
permutations of $X$ do). Swapping the two rows flips **both** columns
simultaneously ($a\leftrightarrow b$ in each), and so does swapping $0\leftrightarrow1$
in $Q$; swapping $t_1\leftrightarrow t_2$ (together with $S\leftrightarrow S'$)
exchanges the two coordinates. Orbits: $\{(a,a),(b,b)\}$ and $\{(a,b),(b,a)\}$.
The separating invariant is whether $t_1\sim_{\mathcal T}t_2$ (equal columns) or
not. Two classes. $\square$

*Remark D.2.* The predecessor's E1 had a **single** isomorphism class at
$(2,2,2)$; E3 has two. The difference is real and is the reason I re-enumerated
rather than citing: the constraint there is "one constant, one not" (an ordered
condition, killed by the $\mathcal T$-swap into one orbit), here it is "both
non-constant" (a symmetric condition, leaving the $\mathcal T$-swap free to act
non-transitively).

### E4 — the meet may be nonempty and still strictly smaller

E3 has $S\cap S'=\emptyset$, where the failure is arguably degenerate. It is not.

$X=\{x_0,x_1,x_2\}$, $Q=\{0,1\}$, $\mathcal T=\{t_1,t_2,t_3\}$,
$\mathfrak h_\sigma=(x_0\,x_1\,x_2)$, columns

| | $t_1$ | $t_2$ | $t_3$ |
|---|---|---|---|
| $x_0$ | 0 | 0 | 0 |
| $x_1$ | 1 | 1 | 0 |
| $x_2$ | 1 | 1 | 1 |

Computing $D_\sigma(x)=\{t : e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$ entry by entry:
$x_0$: $e(x_1,-)=(1,1,0)$ vs $(0,0,0)$, so $D_\sigma(x_0)=\{t_1,t_2\}$.
$x_1$: $e(x_2,-)=(1,1,1)$ vs $(1,1,0)$, so $D_\sigma(x_1)=\{t_3\}$.
$x_2$: $e(x_0,-)=(0,0,0)$ vs $(1,1,1)$, so $D_\sigma(x_2)=\{t_1,t_2,t_3\}$.
Take $S=\{t_1,t_3\}$, $S'=\{t_2,t_3\}$, so $S\cap S'=\{t_3\}$. Then
$$\delta_\sigma(S)=\delta_\sigma(S')=X,\qquad \delta_\sigma(S\cap S')=\{x_1,x_2\}\subsetneq X,$$
with $x_0$ the witness of Theorem D ($D_\sigma(x_0)$ meets $S$ and $S'$ but not
$S\cap S'$).

**Proposition D.3 (minimality of E4 in all three parameters).** For strict
inclusion $\delta_\sigma(S\cap S')\subsetneq\delta_\sigma(S)\cap\delta_\sigma(S')$
with $S\cap S'\ne\emptyset$ one needs $|Q|\ge2$, $|\mathcal T|\ge3$ and $|X|\ge3$;
E4 attains all three.

*Proof.* $|Q|\ge2$ as before. Two incomparable subsets of a $2$-element set have
empty intersection, so $|\mathcal T|\ge3$. For $|X|\le2$: $|X|=1$ forces
$\mathfrak h=\mathrm{id}$; $|X|=2$ forces $\mathfrak h\in\{\mathrm{id},\mathrm{sw}\}$
and, under $\mathrm{sw}$, $D_\sigma(x_0)=D_\sigma(x_1)=\{t : t\text{ non-constant}\}$,
so $\delta_\sigma$ takes only the values $\emptyset$ and $X$ and cannot be
strictly between. Hence $|X|\ge3$. $\square$

*Scope note.* I exhibit E4 and prove its parameters minimal; I have **not**
enumerated the isomorphism classes at $(3,3,2)$ and make no uniqueness claim
there, unlike for E3.

---

## 6. The right order: resolving power, and it is forced

Theorems C–D are statements *about one holonomy*. D0016 §F is a statement about
*instruments*: the framework wants to compare $\mathcal T_\alpha$ with
$\mathcal T_{\alpha+1}$ before knowing $\rho$. That demand has a unique answer.

**Definition 6.1 (resolving-power preorder).** For $S,S'\subseteq\mathcal T$,
$$S\sqsubseteq S'\quad:\Longleftrightarrow\quad \sim_{S'}\;\subseteq\;\sim_{S}$$
("$S'$ separates everything $S$ separates, and possibly more"). This is a
preorder, not a partial order: $S\sqsubseteq S'\sqsubseteq S$ iff
$\sim_S=\sim_{S'}$.

**Lemma 6.2.** $S\subseteq S'\Rightarrow S\sqsubseteq S'$, and the converse fails
(add a duplicate column). $S\mapsto\;\sim_S$ carries $\cup$ to $\cap$ of
equivalence relations (the meet in the partition lattice); it does **not** carry
$\cap$ to the partition-lattice join, and that failure is Theorem D again.

*Proof.* First clause: $\sim_{S'}\subseteq\sim_S$ is the predecessor's Lemma 2.1.
Second: $\sim_{S\cup S'}=\;\sim_S\cap\sim_{S'}$ directly from (H2). Third: the
join of equivalence relations requires transitive closure, and E4 exhibits the
gap. $\square$

**Theorem E (the comparison invariant, and its uniqueness).** Let
$\mathcal C=(X,\mathcal T,e)$ be a Chu space with $X$ having at least two elements,
and $S,S'\subseteq\mathcal T$. The following are equivalent.

  **(a)** $S\sqsubseteq S'$, i.e. $\sim_{S'}\subseteq\;\sim_S$.
  **(b)** For **every** $\mathfrak h\in\operatorname{Aut}(X)$,
  $\;\delta_{\mathfrak h}(S)\subseteq\delta_{\mathfrak h}(S')$.
  **(c)** For every $\mathfrak h$ in the set of transpositions of $X$,
  $\;\delta_{\mathfrak h}(S)\subseteq\delta_{\mathfrak h}(S')$.

Hence $\sqsubseteq$ is the **coarsest** (largest) relation on test sets under which
the defect is monotone uniformly in the holonomy: any relation with that property
is contained in $\sqsubseteq$.

*Proof.* (a)$\Rightarrow$(b): if $x\in\delta_{\mathfrak h}(S)$ then
$\mathfrak h x\not\sim_S x$; contrapositive of (a) gives
$\mathfrak h x\not\sim_{S'}x$, i.e. $x\in\delta_{\mathfrak h}(S')$.
(b)$\Rightarrow$(c) is trivial.
(c)$\Rightarrow$(a): suppose $\sim_{S'}\not\subseteq\sim_S$, witnessed by $x\ne x'$
with $x\sim_{S'}x'$ and $x\not\sim_S x'$. Let $\mathfrak h=(x\,x')$. Then
$\mathfrak h x=x'\not\sim_S x$, so $x\in\delta_{\mathfrak h}(S)$; and
$\mathfrak h x=x'\sim_{S'}x$, so $x\notin\delta_{\mathfrak h}(S')$. Thus
$\delta_{\mathfrak h}(S)\not\subseteq\delta_{\mathfrak h}(S')$, contradicting (c).
The uniqueness clause is exactly (c)$\Rightarrow$(a). $\square$

Note the **direction**: refining the instrument makes $\delta$ go **up**, not
down. Shrinking is the case $S'\subseteq S$ read backwards, and D0016 §G's
$\downarrow$ is the shadow of this.

**Definition/Proposition 6.3 (the $\sqsubseteq$-closure is classical).** Put
$$A(S):=\{\,t\in\mathcal T\;:\;\sim_S\;\subseteq\;\sim_{\{t\}}\,\}.$$
Then $A$ is a closure operator, $S\sqsubseteq S'\iff S\subseteq A(S')$, and
$$A(S)=\bigcap_{\mathfrak h\in\operatorname{Aut}(X)}C_{\mathfrak h}(S).$$
So the holonomy-free comparison invariant is exactly the holonomy-uniform
intersection of the redundancy closures of §3.

*Proof.* $S\sqsubseteq S'$ iff $\sim_{S'}\subseteq\sim_{\{t\}}$ for every $t\in S$
(since $\sim_S=\bigcap_{t\in S}\sim_{\{t\}}$), i.e. $S\subseteq A(S')$; that
$A$ is a closure operator follows, being the closure of a Galois connection
(it is the derivation-closure of the formal context $(X\times X,\mathcal T,R^{c})$
with $R^{c}$ = "$t$ does not separate the pair", §10). For the last identity:
$t\in\bigcap_{\mathfrak h}C_{\mathfrak h}(S)$ means
$\delta_{\mathfrak h}(\{t\})\subseteq\delta_{\mathfrak h}(S)$ for all $\mathfrak h$
(Theorem B), which by Theorem E applied to the pair $(\{t\},S)$ is
$\{t\}\sqsubseteq S$, i.e. $t\in A(S)$. $\square$

---

## 7. Without the invariant there is nothing

The mandate asks whether, under replacement, *any* monotone quantity survives. The
answer is no, and it is not a gesture.

**Lemma 7.1 (realisability).** Let $X$ be finite with $|X|=2n$, $n\ge1$, and let
$\mathfrak h$ be a fixed-point-free involution of $X$, with orbit set $O$
($|O|=n$). Then:
1. For every $t$, $\delta_{\mathfrak h}(\{t\})$ is a union of $\mathfrak h$-orbits;
   hence so is every $\delta_{\mathfrak h}(S)$.
2. There is a Chu space with $Q=\{0,1\}$ and $\mathcal T$ in bijection with $O$
   such that $\delta_{\mathfrak h}(\{t_\omega\})=\omega$ for each orbit $\omega$,
   and therefore $S\mapsto\delta_{\mathfrak h}(S)$ is a **bijection** from
   $\mathcal P(\mathcal T)$ onto the lattice of $\mathfrak h$-invariant subsets of $X$.

*Proof.* (1) $x\in\delta_{\mathfrak h}(\{t\})$ iff $e(\mathfrak h x,t)\ne e(x,t)$;
applying this to $\mathfrak h x$ and using $\mathfrak h^2=\mathrm{id}$ gives
$e(x,t)\ne e(\mathfrak h x,t)$, the same condition. So the membership is constant
on orbits. (2) Choose a representative $r_\omega$ in each orbit and set
$e(x,t_\omega)=1$ if $x=r_\omega$, else $0$. For $x\in\omega$: exactly one of
$x,\mathfrak h x$ is $r_\omega$, so the values differ and $x\in\delta(\{t_\omega\})$.
For $x\notin\omega$: both values are $0$. Hence $\delta(\{t_\omega\})=\omega$, and
Theorem A gives $\delta(S)=\bigcup_{t_\omega\in S}\omega$, which is a bijection onto
unions of orbits. $\square$

**Theorem F (no monotone quantity under unrestricted replacement).** Fix
$n\ge1$ and the Chu space of Lemma 7.1(2). For **every** pair $(A,B)$ of
$\mathfrak h$-invariant subsets of $X$ there exist $S,S'\subseteq\mathcal T$ with
$\delta_{\mathfrak h}(S)=A$ and $\delta_{\mathfrak h}(S')=B$. Consequently, if
$\varphi$ is any function of the defect (any $\varphi:\mathcal P(X)\to L$, $L$ a
poset) such that
$$\text{for all Chu spaces, all }\mathfrak h,\text{ and all }S,S':\qquad \varphi(\delta_{\mathfrak h}(S'))\le\varphi(\delta_{\mathfrak h}(S)),$$
then $\varphi$ is constant on the $\mathfrak h$-invariant subsets — for $n\ge1$
this already forces $\varphi(\emptyset)=\varphi(X)$, and for $n\ge2$ it forces
$\varphi$ constant on the whole Boolean lattice of orbit-unions.

*Proof.* The first clause is Lemma 7.1(2). For the second: given $A,B$ invariant,
pick $S,S'$ realising them, obtaining $\varphi(B)\le\varphi(A)$; swapping the roles
of $S,S'$ gives $\varphi(A)\le\varphi(B)$. Hence $\varphi(A)=\varphi(B)$ for all
invariant $A,B$; with $n\ge2$ these are $2^{n}\ge4$ sets spanning the orbit
Boolean algebra. $\square$

**Corollary F.1 — the consequential answer for D0016 §G.** The predicate
$\operatorname{Advance}$ cannot be licensed by any comparison of $\delta$ across a
replacement of the test set, because *no* function of $\delta$ is monotone under
replacement. In particular:
- $\delta$ decreasing across $\alpha\mapsto\alpha+1$ is evidence of nothing when
  $\mathcal T_\alpha\not\supseteq\mathcal T_{\alpha+1}$;
- $\delta$ increasing is likewise evidence of nothing;
- $\|\mathcal O\|$ (the predecessor's scalar shadow) is no better: it is a function
  of $\delta$, hence covered by Theorem F.

The framework therefore **needs a comparison invariant it does not currently
have**, and the slogan $\operatorname{Shrink}(\mathcal T)\Rightarrow\delta\downarrow$
must not be cited across §F's "**or not**".

---

## 8. Exactly what would have to be added — and nothing else

Stated as a proposal, marked as a proposal, and justified by Theorem E rather than
by taste. I add **one** datum and derive its consequences; I do not invent a
second.

> **Proposed amendment to D0016 §F (mine, not the owner's).** Equip the passage
> $\mathcal T_\alpha\rightsquigarrow\mathcal T_{\alpha+1}$ with the recorded
> equivalence relations $\sim_{\mathcal T_\alpha}$ on $X$, and classify each step as
> $$\operatorname{Refine}:\ \sim_{\mathcal T_{\alpha+1}}\subseteq\;\sim_{\mathcal T_\alpha},
> \qquad
> \operatorname{Blunt}:\ \sim_{\mathcal T_\alpha}\subseteq\;\sim_{\mathcal T_{\alpha+1}},
> \qquad
> \operatorname{Incomparable}:\ \text{neither}.$$

Under this single addition:

- **(8.1)** $\operatorname{Refine}\Rightarrow\delta\uparrow$ and
  $\operatorname{Blunt}\Rightarrow\delta\downarrow$, both weakly, both for every
  holonomy, by Theorem E(a)$\Rightarrow$(b). $\operatorname{Shrink}$ is a special
  case of $\operatorname{Blunt}$ (Lemma 6.2), so §G's boxed claim survives, now as
  a corollary of a statement that also covers non-inclusions.
- **(8.2)** No weaker datum suffices. By Theorem E(c)$\Rightarrow$(a), any
  classification licensing "$\delta$ moved monotonically, uniformly in $\rho$" must
  refine $\sqsubseteq$. So this is not one choice among many; it is the unique
  coarsest one.
- **(8.3)** On $\operatorname{Incomparable}$ steps the framework gets nothing, by
  Theorem F, and must say so. If a particular $\rho$ is in hand, Theorem C still
  decides the step by the finite check $\mathcal T_{\alpha+1}\subseteq C(\mathcal T_\alpha)$
  — but that is a fact about $\rho$, not about the instrument, and must be reported
  as such.
- **(8.4)** §G's $\operatorname{SearchSep}$ conjunct is the top element of
  $\sqsubseteq$. The predecessor's Prop. 3 ($S$ separating $\Rightarrow$
  ($\delta_\sigma(S)=0\iff\mathfrak h_\sigma=\mathrm{id}$)) is the statement that
  the defect is faithful exactly at that top. Everywhere else it is a shadow, and
  Theorem F measures how long the shadow can be.

**What I am *not* adding.** No metric, no norm, no cardinality-based progress
measure, no ordinal assignment. Theorem F rules out all of them uniformly, so
proposing one would be exactly the error `CLAUDE.md` was written against.

---

## 9. Scope limits

- **Common test universe assumed.** (H5) puts $S,S'$ inside one $\mathcal T$ with
  one $e$. The genuinely fibred case — stages with unrelated test universes,
  compared only through a Chu transform $(f_o,f_a)$ — is **not** treated. Theorem E
  would then need the comparison to be pulled back along $f_a$, and I have not done
  that. This is the same limit the predecessor's §6 records, moved one step out.
- **$\operatorname{Aut}(X)$, not arbitrary endomaps.** Theorem E's
  (c)$\Rightarrow$(a) uses transpositions; if the transport maps $\rho_{ij}$ are
  allowed to be non-invertible the implication (a)$\Rightarrow$(b) is unaffected
  (its proof never inverts) but the uniqueness clause needs re-checking against the
  larger class. I have not done it and do not claim it.
- **Finiteness.** Theorems A, B, C, E, and Prop. 6.3 hold for arbitrary sets.
  Theorem F and all counterexamples are finite by construction.
- **The rest of D0016 and all of D0017.** The ordinal ladder §C, $\mathfrak F$,
  $\mathbb B=\int^\alpha\Diamond_\alpha$, the Yang–Baxter defect, the seven
  components of $\delta_\sigma$, and the four undefined conjuncts of
  $\operatorname{Advance}$ are untouched. D0017's §F correspondence — the question
  whether the bridge from the geometric half to the logical half is a theorem or a
  pun — is untouched; nothing here bears on it, and per D0017 §J6 I have not
  relabelled anything in its vocabulary.
- **No machine verification.** No Agda or Lean was authored; no typechecking is
  claimed (there is no toolchain in this container). Every proof above is finite and
  checked by hand; Theorem D.1 is a complete enumeration of $16$ matrices, written
  out and reproducible by reading it.
- **No Python, no measurement, no fitted constant, no floating-point number.**

---

## 10. Prior art, searched before writing

What I **actually read**, in HTML: the nLab page *Galois connection*; the Wikipedia
pages *Galois connection*, *Formal concept analysis*; the nLab page *relation*;
`arxiv.org/html/2412.11478` (*Properties preserved by classes of Chu transforms*),
Definitions 2.4 and 2.8; and search-result excerpts on Jónsson–Tarski boolean
algebras with operators. **I read no PDF** — they do not decode here — so Birkhoff
1940, Ore 1944, Jónsson–Tarski 1951, Wille 1982 and Ganter–Wille are cited from
their standard statements as reported by the pages above, and I quote no numbered
result from any of them.

- **Theorem A + Theorem B are classical.** "$f$ preserves all joins if and only if
  $f$ has a right adjoint" is stated verbatim on Wikipedia's *Galois connection*;
  the composite of a monotone Galois connection being a closure operator is stated
  on both nLab (*"$I_E\circ V_E$ and $V_E\circ I_E$ are closure operators (idempotent
  monads)"*) and Wikipedia (*"the composition $GF$ … the associated closure
  operator"*), attributed to Ore, *Galois Connexions*, Trans. AMS (1944), with
  Birkhoff's *Lattice Theory* (1940) as the earlier source. My $\delta\dashv\delta^*$
  is the existential-image/universal-preimage adjunction $\langle R\rangle\dashv[\breve R]$
  of a relation, the poset shadow of Jónsson–Tarski's boolean algebras with
  operators (1951). **I claim no novelty for §2–§3.**
- **Proposition 6.3's closure $A$ is the FCA attribute closure** of the formal
  context whose objects are pairs from $X$ and whose incidence is "$t$ does not
  separate this pair"; Wikipedia's *Formal concept analysis* states *"The derivation
  operators define a Galois connection between sets of objects and of attributes"*
  and describes attribute implications and the canonical basis (Wille 1981/1982;
  Ganter–Wille). $S\sqsubseteq S'\iff S\subseteq A(S')$ is then the implication
  relation of that context — folklore in FCA.
- **Chu spaces.** `arxiv.org/html/2412.11478` Def. 2.4 gives separated and
  extensional, and Def. 2.8 gives *"restriction in the second sort"* — a Chu
  transform with $X=Y$, $B\subseteq A$, $f=\mathrm{id}_X$, $g=\mathrm{id}_B$ — which
  is exactly $\operatorname{Shrink}$. That paper's Prop. 3.13 concerns preservation
  of regressive-flow formulas under such restrictions, not defects, and I found in
  it **no order on test sets by resolving power**. Barr's Chu construction (1979)
  and Pratt's development are cited from the same secondary reading, not from a text
  I opened.

**What, if anything, is new.** Honestly: very little, and I would rather say so.

1. Theorem E's **converse** — that $\sqsubseteq$ is the *coarsest* relation making
   $\delta$ monotone uniformly in the holonomy, proved by transpositions — I did not
   find stated. The forward direction is trivial and surely folklore.
2. Theorem F, that unrestricted replacement admits no monotone quantity, with the
   orbit realisation lemma. Elementary; likely folklore in a form I did not locate.
3. The two exhaustive minimality counts (Thm D.1, four matrices in **two**
   isomorphism classes, versus the predecessor's four in **one**), and Prop. D.3.
4. The identification $A=\bigcap_{\mathfrak h}C_{\mathfrak h}$ (Prop. 6.3) tying the
   holonomy-dependent redundancy closure to the holonomy-free FCA closure.

Everything else is a rediscovery, labelled as one.

---

## 11. What this note licenses, at the generality I can defend

> If the defect is read as *the set of points on which the tests can see the
> holonomy move them*, then: the defect of a union of test sets is the union of the
> defects; the defect of an intersection is generally strictly smaller than the
> intersection of the defects; a replacement lowers the defect for a **given**
> holonomy exactly when the new tests are redundant relative to the old; a
> replacement lowers the defect for **every** holonomy exactly when the new
> instrument is blunter in the resolving-power preorder; and across a replacement
> that is neither refinement nor blunting, no function of the defect is monotone at
> all.

Not licensed: anything about the ordinal ladder; anything about defects measured by
norms, spectra or probabilities; anything about stages that do not share a test
universe; anything at all about D0017 §F.

---

*Question and framework: the repository owner, D0016 §F and §G, 2026-08-14.
Verification of the predecessor, Theorems A–F, Prop. 6.3 and Examples E3–E4: this
note. No experiment was run.*
