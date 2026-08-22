# Shrinking tests lower curvature — weakly, and exactly when

**Provenance and repair notice (referee, seed150, 2026-08-14).** This note is a
*merge*. Two agents attacked D0016 §J2 independently and without sight of each
other:

- **seed148** (message `0749-seed148-shrinking-tests-theorem.md`) wrote the
  first version of this file, committed at `5bc5c505` (337 lines). Its notation:
  $\operatorname{Det}_\sigma(S)$ for the defect locus, $W_\sigma(x)$ for the
  witness set.
- **seed146** (message `0747-seed146-shrinking-tests-theorem.md`) wrote a second
  version and, at commit `e08c07ab`, **overwrote seed148's file wholesale**
  (447 insertions, 329 deletions — not a merge, a replacement). Its notation:
  $\delta^S_\sigma$, $D_\sigma(x)$.

Neither agent knew this had happened; seed146's overwrite was silent. The body
below is seed146's text (retained as the spine, because it is the more complete
of the two), with seed148's distinct contributions restored and attributed:
**Cor. 2.3**, **Prop. 3.4**, **Rem. 5.4**, and **Ex. E2′**. Sections **3A** and
**5A** are the referee's own and were not in either agent's note. Everything in
seed148's version that this file does not carry is still recoverable at
`git show 5bc5c505:notes/SHRINKING_TESTS_LOWER_CURVATURE.md`.

Referee verdict on the substance: the two agents' strictness conditions are the
**same statement** (§3A); the exhaustive count **holds** (§5A, recomputed from
scratch); the SearchSep definition is **not circular but is a generalisation of
the transmission's literal unary predicate**, and the refutation survives both
readings (§5, Rem. 5.5).

**Status.** Proved. The monotonicity is **weak**, not strict, and cannot be made
strict; the exact difference set is computed (Thm 2), which is the only part
that carries content. The non-implication δ = 0 ⇏ Advance is **refuted as an
implication** by a finite counterexample, minimal in $(|X|,|\mathcal T|,|Q|)$
and — under the hypothesis that holonomy is invertible — unique up to
isomorphism at those minimal parameters (Thm 5, exhaustive check over the $16$
cases; Rem. 5.2 records that uniqueness, though not minimality, fails if
invertibility is dropped). §J3's non-implication falls out
as the second coordinate of the same lemma (Thm 3, Ex. E2).

**Substance: classical.** Theorems 1 and 3 are the monotone half of a Birkhoff
polarity and are standard. See §7 for what, if anything, is new — the honest
answer is: the difference formula and the minimality count, both elementary.

**Source of the question.** `collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md`
(the owner's transmission, 2026-08-14), §G and §J2/§J3. The framework, the
signature, the slogan *zero curvature is not truth*, and the identification of
this as the first `PROVE` item are the owner's. Everything below §1 is derived
from that artifact and does not amend it.

---

## 0. What the transmission fixes and what it does not

§G asserts

$$\operatorname{Shrink}(\mathcal T)\Rightarrow\delta\downarrow,\qquad \delta=0\not\Rightarrow\operatorname{Advance},$$

and §J2 records, correctly, that *"the exact statement (which order, which ↓,
strict or weak) is not written down anywhere above."* It is not. Neither is
$\ominus$, nor the sense in which $\delta_\sigma$ is a number rather than an
automorphism. So the first obligation is definitional, and the definitions
below are **mine**, not the owner's; they are chosen to be the weakest ones
under which the slogan is true, so that the theorem is not won by stipulation.

Three things had to be pinned down.

1. **The order on defects.** Inclusion of subsets of $X$ (with cardinality as a
   scalar shadow). Not a norm, not a metric — those would require choices the
   transmission does not make.
2. **The sense of $\ominus 1$.** Observational: $\mathfrak h_\sigma \ominus 1$
   is not "the automorphism minus the identity" (there is no subtraction in
   $\operatorname{Aut}(X)$) but *the locus at which the tests can see that
   $\mathfrak h_\sigma$ is not the identity.* This is forced: $\delta$ must
   depend on $\mathcal T$ or the claim is vacuous.
3. **Strictness.** Weak. See §3, where the failure of strictness is exhibited
   and the exact criterion for strict decrease is proved.

---

## 1. Definitions

**Definition 1.1 (Chu space).** A Chu space over a value set $Q$ is a triple
$\mathcal C = (X,\mathcal T,e)$ with $e : X\times\mathcal T\to Q$. Elements of
$X$ are *points*, of $\mathcal T$ are *tests*. (Barr's $\mathrm{Chu}(\mathbf{Set},Q)$;
Pratt's matrix presentation, rows $=$ points, columns $=$ tests.)

**Definition 1.2 (separation).** For $S\subseteq\mathcal T$,
$$x\sim_S x' \iff \forall t\in S,\; e(x,t)=e(x',t).$$
This is an equivalence relation on $X$ (not merely a preorder: it is the kernel
of $x\mapsto e(x,-)|_S$). The mandate says "preorder"; the honest statement is
that it is an equivalence, and I use that.

**Definition 1.3 (charted Chu space).** A *charted* Chu space is
$(\mathcal C, I, \rho)$ where $I$ is an index set and
$\rho_{ij}\in\operatorname{Aut}(X)$ for $i,j\in I$, with $\rho_{ii}=\mathrm{id}$.
$N(I)$ denotes the nerve: simplices are tuples $\sigma=(i_0,\dots,i_n)$.

*Remark.* The transmission's $\rho_\alpha$ are transition maps between charts
$X_i$. Taking all $X_i = X$ is the case after a choice of trivialisation; for a
simplex based at $i_0$ the holonomy lands in $\operatorname{Aut}(X_{i_0})$
anyway, so nothing below is lost. I do **not** treat the case where the charts
carry *different* test sets; that is a genuine generalisation and is out of
scope (§6).

**Definition 1.4 (holonomy).** For $\sigma=(i_0,\dots,i_n)\in N(I)$,
$$\mathfrak h_\sigma := \rho_{i_0i_n}^{-1}\,\rho_{i_{n-1}i_n}\cdots\rho_{i_0i_1}\;\in\;\operatorname{Aut}(X).$$
$\mathfrak h_\sigma = \mathrm{id}$ for all $\sigma$ iff $\rho$ is a cocycle
($\rho_{jk}\rho_{ij}=\rho_{ik}$); this is the standard descent obstruction, and
it is the transmission's $\mathfrak H_\sigma$.

**Definition 1.5 (observable defect).** For $S\subseteq\mathcal T$,
$$\boxed{\;\delta^S_\sigma \;:=\; \{\,x\in X \;:\; \mathfrak h_\sigma x \not\sim_S x\,\}\;\subseteq X.\;}$$
The *total obstruction* is $\mathcal O(S):=(\delta^S_\sigma)_{\sigma\in N(I)}$,
ordered componentwise by inclusion. When $X$ and $N(I)$ are finite, write the
scalar shadow $\|\mathcal O(S)\| := \sum_\sigma|\delta^S_\sigma|$.

**Definition 1.6 (detector set).** For $x\in X$ and $\sigma$,
$$D_\sigma(x) := \{\,t\in\mathcal T : e(\mathfrak h_\sigma x, t)\ne e(x,t)\,\}.$$
Thus $x\in\delta^S_\sigma \iff D_\sigma(x)\cap S \ne \emptyset$. This
reformulation is the whole engine; everything in §2–§3 is a remark on it.

**Definition 1.7 (Shrink).** $\operatorname{Shrink}$ is the passage
$\mathcal T\rightsquigarrow\mathcal T'$ with $\mathcal T'\subseteq\mathcal T$.
This is the reading §F licenses ("$\mathcal T_\alpha\subseteq\mathcal T_{\alpha+1}$
**or not**"); the case where $\mathcal T'\not\subseteq\mathcal T$ is *not*
Shrink and nothing here applies to it. I flag that because §F explicitly warns
that the measurement domain itself changes, and the theorem below does **not**
cover that case.

---

## 2. Monotonicity

**Lemma 2.1 (coarsening).** If $S'\subseteq S\subseteq\mathcal T$ then
$\sim_S \;\subseteq\; \sim_{S'}$ as relations: $S$-indistinguishability implies
$S'$-indistinguishability.

*Proof.* If $e(x,t)=e(x',t)$ for all $t\in S$, then in particular for all
$t\in S'\subseteq S$. $\square$

**Theorem 1 (Shrink $\Rightarrow$ $\delta\downarrow$; weak).**
Let $(\mathcal C,I,\rho)$ be a charted Chu space and $S'\subseteq S\subseteq\mathcal T$.
Then for every $\sigma\in N(I)$,
$$\delta^{S'}_\sigma \;\subseteq\; \delta^{S}_\sigma,$$
hence $\mathcal O(S')\le\mathcal O(S)$ componentwise, and (finite case)
$\|\mathcal O(S')\|\le\|\mathcal O(S)\|$. In particular
$\delta^{\emptyset}_\sigma=\emptyset$ for every $\sigma$, whatever $\rho$ is.

*Proof.* $x\in\delta^{S'}_\sigma$ means $D_\sigma(x)\cap S'\ne\emptyset$
(Def. 1.6). Since $S'\subseteq S$, $D_\sigma(x)\cap S\supseteq D_\sigma(x)\cap S'\ne\emptyset$,
so $x\in\delta^S_\sigma$. The last clause: $D_\sigma(x)\cap\emptyset=\emptyset$
always. $\square$

That is the theorem. It is one line, as §J2 predicted, and the prediction that
it is *immediate* was right. **The inequality is $\le$, not $<$**, and §3 shows
it cannot be improved to $<$: the slogan's "$\downarrow$" must be read as
non-increase.

**Corollary 2.3 (the degenerate shrink; seed148, Cor. 2.1 of the overwritten
version).** Take $S'=\emptyset$. Then $\sim_\emptyset$ is the total relation and
$\delta^{\emptyset}_\sigma=\emptyset$ **for every holonomy datum whatsoever**,
however wild $\mathfrak h_\sigma$ is. So $\delta=0$ is unconditionally
purchasable by shrinking, and therefore carries by itself exactly zero
information about $\mathfrak h_\sigma$. That is शून्यवक्रता $\ne$ सत्य, proved,
and it is proved *without any counterexample at all* — the counterexample in §5
is needed only for the sharper claim with $\mathcal T'\ne\emptyset$.

*(Referee's note: this is the cleanest single sentence in either agent's work
and it was lost in the overwrite. It is a one-line consequence of the last
clause of Theorem 1, but stating it as the headline is seed148's, and it is the
right headline.)*

**Remark 2.2 (why it is a Galois connection).** Consider the polarity between
$\mathcal T$ and the set $P$ of ordered pairs from $X$, with
$t \mathrel{R} (x,x') \iff e(x,t)\ne e(x',t)$ ("$t$ separates"). Then
$S\mapsto \operatorname{Sep}(S):=\{(x,x') : \exists t\in S,\, tR(x,x')\}$ is the
monotone existential image, and $\delta^S_\sigma$ is the pullback of
$\operatorname{Sep}(S)$ along $x\mapsto(\mathfrak h_\sigma x, x)$. Monotonicity
of an existential image is Theorem 1. The complementary map
$S\mapsto\;\sim_S$ is antitone and is the polar; the pair
$(\operatorname{Sep},\;\sim)$ is the standard Birkhoff polarity. Nothing here is
new — see §7.

> **[Correction carried here 2026-08-15 (Claude, Opus lineage; reach audit
> `notes/CORRECTION_REACH_AUDIT.md`), by addition — the remark above is
> unaltered.]** The last claim is **imprecise as stated**, per
> `notes/CHANGING_TESTS_VERSUS_SHRINKING.md` §0.4: "A Birkhoff polarity is a
> pair of **antitone** maps; $\operatorname{Sep}$ is monotone, so
> $(\operatorname{Sep},\sim)$ is not one. What is true, and is what the note
> needed: $\sim_S$ is the polar of $S$ **for the complementary relation**
> $R^{c}$ …; $\operatorname{Sep}$ is the *complement* of that polar, not a
> polar." That note adds: "No theorem of the predecessor depends on the
> misstatement — Theorem 1 is proved directly from Def. 1.6, not from Rmk 2.2 —
> so the verdict stands and only the ground is repaired," and its §3 supplies
> the **monotone** Galois connection that is the correct structural home for
> Theorem 1. This is carried here because the correction had not reached the
> remark: `notes/APOHA_AND_POLARITY.md` §3 records a later pointer that cites
> this remark as *the* polarity and notes that doing so "repeats the corrected
> error". The correct target for that citation is
> `CHANGING_TESTS_VERSUS_SHRINKING.md` Prop. 6.3.

---

## 3. The exact strictness criterion — the content

Weak monotonicity alone does not license *"zero curvature is not truth"*: one
also needs to know *when* shrinking actually buys a lower defect, and when it
buys nothing. The following is an equality, not a bound.

**Theorem 2 (difference formula).** For $S'\subseteq S\subseteq\mathcal T$ and
any $\sigma$,
$$\boxed{\;\delta^S_\sigma\setminus\delta^{S'}_\sigma \;=\; \bigl\{\,x\in X \;:\; \emptyset\ne D_\sigma(x)\cap S \subseteq S\setminus S'\,\bigr\}.\;}$$
Consequently:

1. $\delta^{S'}_\sigma \subsetneq \delta^{S}_\sigma$ **iff** there exists a
   point $x$ whose entire $S$-detector set is destroyed by the shrink, i.e.
   $\emptyset\ne D_\sigma(x)\cap S\subseteq S\setminus S'$.
2. $\delta^{S'}_\sigma = \delta^{S}_\sigma$ **iff** every $S$-detected point
   retains at least one detector in $S'$.

*Proof.* $x\in\delta^S_\sigma\setminus\delta^{S'}_\sigma$ iff
$D_\sigma(x)\cap S\ne\emptyset$ and $D_\sigma(x)\cap S'=\emptyset$. The second
condition says $D_\sigma(x)\cap S$ meets no element of $S'$, i.e.
$D_\sigma(x)\cap S\subseteq S\setminus S'$. Conjoining gives the displayed set.
(1) and (2) are the non-emptiness and emptiness of that set. $\square$

**Corollary 3.1 (criticality of a single test).** Removing one test $t$ from
$S$ strictly lowers $\delta_\sigma$ **iff** $t$ is the *unique* detector of some
point: $\exists x,\; D_\sigma(x)\cap S=\{t\}$. Otherwise $\delta_\sigma$ is
unchanged.

*Proof.* Theorem 2 with $S'=S\setminus\{t\}$: the difference set is
$\{x : \emptyset \ne D_\sigma(x)\cap S\subseteq\{t\}\}$. $\square$

**Corollary 3.2 (strictness is impossible in general).** The map
$S\mapsto\delta^S_\sigma$ is monotone but not injective. Any $S$ containing a
*redundant* test — one detecting no point that is not detected by another test
in $S$, and in particular any test that detects nothing — can be deleted with
$\delta_\sigma$ constant. Hence **§G's $\downarrow$ is weak and no hypothesis
short of criticality makes it strict.**

*Proof.* Immediate from Cor. 3.1; a witness is Example E1 below with the roles
of $t_1,t_2$ exchanged (delete the constant column $t_2$: $D_\sigma(x)=\{t_1\}$
for both points, $t_2$ is nobody's detector, $\delta$ unchanged). $\square$

**Corollary 3.3 (total collapse).** $\delta^{S}_\sigma=\emptyset$ for all
$\sigma$ iff $\mathfrak h_\sigma = \mathrm{id}$ modulo $\sim_S$ for all $\sigma$;
this holds *unconditionally* for $S=\emptyset$, and more generally whenever
$\mathfrak h_\sigma$ preserves every $\sim_S$-class setwise. In particular
vanishing of the obstruction is a statement about $S$ at least as much as about
$\rho$.

This is the precise form of the slogan. The obstruction $\mathcal O$ is not an
invariant of $(\rho, X)$; it is an invariant of $(\rho, X, S)$, and it is
monotone in $S$ with the exact defect-loss given by Theorem 2.

---

**Proposition 3.4 (when $\delta=0$ *is* truth; seed148's Prop. 3, restored).**
Call $S$ *separating* if $\sim_S$ is equality on $X$. If $S$ is separating then
$$\delta^S_\sigma=\emptyset \iff \mathfrak h_\sigma=\mathrm{id}_X.$$

*Proof.* ($\Leftarrow$) trivial. ($\Rightarrow$) $\delta^S_\sigma=\emptyset$ says
$\mathfrak h_\sigma x\sim_S x$ for all $x$; separation makes $\sim_S$ equality,
so $\mathfrak h_\sigma x = x$. $\square$

This is the exact converse of Cor. 2.3 and it is what identifies §G's
$\operatorname{SearchSep}$ conjunct: **a report of $\delta=0$ is evidence about
$\rho$ precisely to the extent that the instrument is certified separating.**
Read this way §G's anti-degeneracy clause is not an extra axiom but the
contrapositive of Cor. 2.3. Seed148 flagged this as the only sentence it could
not find already written down; the referee agrees it is a corollary rather than
a discovery, and it is folklore in FCA (a separating context is a *clarified*
one), but it is the load-bearing corollary here.

---

## 3A. Referee: are the two agents' strictness conditions the same statement?

They were reported in different shapes — seed148's is an existential
implication, seed146's an equality of sets — and the mandate forbids assuming
agreement because both said "sole witness". They agree, and here is the
verification rather than the assertion.

**The two definitions coincide verbatim.** Seed148:
$W_\sigma(x)=\{t\in\mathcal T: e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$.
Seed146 (Def. 1.6): $D_\sigma(x)=\{t\in\mathcal T: e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$.
Same set, two names. Below, $D=W$.

**Seed148's claim (A).** $\delta^{S'}_\sigma\subsetneq\delta^{S}_\sigma
\iff \exists x:\ \emptyset\ne W_\sigma(x)\cap S\subseteq S\setminus S'$.

**Seed146's claim (B).** $\delta^{S}_\sigma\setminus\delta^{S'}_\sigma
= \{x : \emptyset\ne D_\sigma(x)\cap S\subseteq S\setminus S'\}$.

**Proposition 3A.1.** (B) $\Rightarrow$ (A), and (A) is exactly the
non-emptiness shadow of (B). Hence the two agents proved the same theorem, B in
the stronger (set-valued) form.

*Proof.* By Theorem 1, $\delta^{S'}_\sigma\subseteq\delta^{S}_\sigma$ always;
therefore the inclusion is proper iff the difference set is non-empty. (B)
computes that difference set; asserting it is non-empty is verbatim (A). For the
converse direction, (A) alone does not recover (B): (A) says the difference is
inhabited, (B) says *which* points inhabit it. So (B) is strictly more
informative and (A) is its existential quantification. $\square$

**Proposition 3A.2 (the one step that could have gone wrong, checked).** The
passage from "$D_\sigma(x)\cap S'=\emptyset$" — which is what
$x\notin\delta^{S'}_\sigma$ literally says — to
"$D_\sigma(x)\cap S\subseteq S\setminus S'$" uses the hypothesis
$S'\subseteq S$ and would be **false without it**.

*Proof.* Under $S'\subseteq S$: $D\cap S' = D\cap S\cap S'$, so
$D\cap S'=\emptyset \iff (D\cap S)\cap S'=\emptyset \iff D\cap S\subseteq S\setminus S'$.
Without $S'\subseteq S$ the middle equality fails: take
$D\cap S'\ne\emptyset$ with $D\cap S'\cap S=\emptyset$, and the right-hand
condition holds while the left does not. $\square$

Both agents assume $S'\subseteq S$ (it is Def. 1.7, Shrink), so both are safe.
The referee records the check because the equivalence is the only non-formal
step in either proof, and because Def. 1.7's restriction to $\mathcal T'\subseteq\mathcal T$
is doing real work here and not merely bookkeeping.

**Where they differ, and it is not in the mathematics.** Seed148 additionally
states the *total-collapse* form ($\delta^{S'}=\emptyset\ne\delta^{S}$ iff every
displaced point's every witness is discarded) and the *degenerate shrink*
(Cor. 2.3); seed146 additionally states the difference set pointwise (Thm 2) and
the redundancy corollary (Cor. 3.2). Each is a corollary of the other's
statement. **Two independent derivations, one theorem, no disagreement.** §5A
below is the only place where an independent check could have separated them,
and it does not.

---

## 4. Resolution monotonicity: §J2 and §J3 are one lemma

§J3 asserts $\delta_\sigma = 0 \not\Leftarrow \delta^{\mathrm{base}}_\sigma = 0$
— a projection can kill curvature the total object retains. That is the same
statement in the *other* argument of $e$.

**Definition 4.1 (resolution).** A resolution of $\mathcal C$ is a pair
$r=(S,\pi)$ with $S\subseteq\mathcal T$ and $\pi : Q\to Q_r$ any function. Set
$$\delta^r_\sigma := \{\,x : \exists t\in S,\ \pi e(\mathfrak h_\sigma x,t)\ne \pi e(x,t)\,\},\qquad
D^r_\sigma(x):=\{t\in S : \pi e(\mathfrak h_\sigma x,t)\ne\pi e(x,t)\}.$$
Order resolutions by $r'\preceq r$ iff $S'\subseteq S$ and $\pi'=\varphi\circ\pi$
for some $\varphi : Q_r\to Q_{r'}$ (i.e. $\pi'$ is coarser).

**Theorem 3 (resolution monotonicity).** $r'\preceq r \Rightarrow \delta^{r'}_\sigma\subseteq\delta^r_\sigma$
for all $\sigma$; and
$\delta^r_\sigma\setminus\delta^{r'}_\sigma=\{x : D^r_\sigma(x)\ne\emptyset,\ D^{r'}_\sigma(x)=\emptyset\}$.

*Proof.* Let $x\in\delta^{r'}_\sigma$, witnessed by $t\in S'$. Then
$\varphi\pi e(\mathfrak h_\sigma x,t)\ne\varphi\pi e(x,t)$; since $\varphi$ is a
function, $\pi e(\mathfrak h_\sigma x,t)\ne\pi e(x,t)$, and $t\in S'\subseteq S$,
so $x\in\delta^r_\sigma$. The difference formula is the definition of set
difference applied to $x\in\delta^r \iff D^r_\sigma(x)\ne\emptyset$. $\square$

Theorem 1 is the case $\pi'=\pi=\mathrm{id}_Q$; §J3's implication is the case
$S'=S$. So:

**Corollary 4.2.** $\delta_\sigma = 0 \Rightarrow \delta^{\mathrm{base}}_\sigma = 0$
holds always (take $r' = $ base, $r = $ total). The converse fails (Ex. E2).
The arrow in §J3 is therefore correctly oriented in the transmission, and the
transmission's *one-directional* writing of it is exactly right: the implication
that holds is the one it does not claim, and the one it denies is the one that
fails.

---

## 5. The counterexamples, and their minimality

### E1 — $\delta = 0$ does not give Advance

$X=\{x_0,x_1\}$, $Q=\{0,1\}$, $\mathcal T=\{t_1,t_2\}$, matrix (rows points,
columns tests)

| | $t_1$ | $t_2$ |
|---|---|---|
| $x_0$ | 0 | 0 |
| $x_1$ | 1 | 0 |

Charts $I=\{0,1,2\}$; $\rho_{01}=\rho_{12}=\mathrm{id}$, $\rho_{02}=\mathrm{sw}$
(the transposition), all other $\rho_{ij}=\mathrm{id}$. For $\sigma=(0,1,2)$,
$\mathfrak h_\sigma=\rho_{02}^{-1}\rho_{12}\rho_{01}=\mathrm{sw}$.

- $\mathcal T$ (full): $D_\sigma(x_0)=D_\sigma(x_1)=\{t_1\}$, so
  $\delta^{\mathcal T}_\sigma=\{x_0,x_1\}\ne\emptyset$.
- $\mathcal T'=\{t_2\}$ (a shrink, and *nonempty* — the degenerate
  $\mathcal T'=\emptyset$ is not needed): $D_\sigma(x)\cap\mathcal T'=\emptyset$
  for both points, so $\delta^{\mathcal T'}_\sigma=\emptyset$.

So the defect vanishes under the shrunken test set and does not under the larger
one. This is Theorem 2 case (1) with $D_\sigma(x)=\{t_1\}\subseteq\mathcal T\setminus\mathcal T'$
— a *strict* decrease, and by Cor. 3.1 the strictness is exactly because $t_1$
is the unique detector.

**Why this refutes $\delta = 0\Rightarrow\operatorname{Advance}$.** §G leaves
$\operatorname{SearchSep}$ undefined. I define it, relative to a reference test
set $\mathcal T$: $\operatorname{SearchSep}_{\mathcal T}(\mathcal T')=1$ iff
$\sim_{\mathcal T'}\;=\;\sim_{\mathcal T}$, i.e. the working test set separates
everything the reference separates. *(This definition is mine; the transmission
supplies none, and the proposition below is only as strong as it.)*

**Proposition 5.1.** In E1, $\delta^{\mathcal T'}_\sigma=\emptyset$ for every
$\sigma\in N(I)$, yet $\operatorname{SearchSep}_{\mathcal T}(\mathcal T')=0$;
hence $\operatorname{Advance}$ fails while $\delta=0$.

*Proof.* Every $\mathfrak h_\sigma$ in E1 is $\mathrm{id}$ or $\mathrm{sw}$;
for $\mathrm{id}$, $\delta=\emptyset$ trivially, and for $\mathrm{sw}$,
$\delta^{\{t_2\}}=\emptyset$ as computed, since column $t_2$ is constant. And
$x_0\sim_{\mathcal T'}x_1$ (both $0$ at $t_2$) while $x_0\not\sim_{\mathcal T}x_1$
(they differ at $t_1$), so $\sim_{\mathcal T'}\ne\sim_{\mathcal T}$ and the
conjunct $\operatorname{SearchSep}=1$ of §G fails. $\operatorname{Advance}$ is a
conjunction, so it fails. $\square$

**Theorem 5 (minimality of E1, by exhaustion).** Suppose $(X,\mathcal T,e)$,
$\mathfrak h\in\operatorname{Aut}(X)$, and $\emptyset\ne\mathcal T'\subsetneq\mathcal T$
satisfy $\delta^{\mathcal T'}=\emptyset\ne\delta^{\mathcal T}$. Then
$|X|\ge 2$, $|Q|\ge2$, $|\mathcal T|\ge2$. Each bound is attained
simultaneously by E1, and at $(|X|,|\mathcal T|,|Q|)=(2,2,2)$ exactly $4$ of the
$16$ Chu matrices work, all isomorphic to E1.

*Proof.*
*(Bounds.)* If $|Q|=1$ then $e$ is constant and $D_\sigma(x)=\emptyset$ for all
$x$, so $\delta^{\mathcal T}=\emptyset$ — contradiction. If $|X|=1$ then
$\operatorname{Aut}(X)=\{\mathrm{id}\}$, so $\mathfrak h x = x$ and again
$\delta^{\mathcal T}=\emptyset$. If $|\mathcal T|\le1$ then
$\emptyset\ne\mathcal T'\subsetneq\mathcal T$ is impossible.

*(Exhaustion at $(2,2,2)$.)* Take $X=\{x_0,x_1\}$, $Q=\{0,1\}$,
$\mathcal T=\{t_1,t_2\}$, $\mathcal T'=\{t_2\}$ (the only nonempty proper
subsets are $\{t_1\},\{t_2\}$, exchanged by relabelling). $\operatorname{Aut}(X)=\{\mathrm{id},\mathrm{sw}\}$;
$\mathfrak h=\mathrm{id}$ gives $\delta=\emptyset$ always, so $\mathfrak h=\mathrm{sw}$.
A column $t$ is a pair $(e(x_0,t),e(x_1,t))\in Q^2$, four possibilities. With
$\mathfrak h=\mathrm{sw}$: $x_0\in\delta^{\{t\}}\iff e(x_1,t)\ne e(x_0,t)\iff$
column $t$ non-constant, and symmetrically for $x_1$; so
$\delta^{\{t\}}=X$ if $t$ is non-constant and $\emptyset$ if $t$ is constant,
and $\delta^{S}=\bigcup_{t\in S}\delta^{\{t\}}$. Hence the requirement is:
$t_2$ constant ($2$ columns: $(0,0),(1,1)$) **and** $t_1$ non-constant
($2$ columns: $(0,1),(1,0)$). That is $2\times2=4$ of the $4\times4=16$
matrices, and the four are carried onto one another by the two relabellings of
$Q$ and of $X$, so all are isomorphic to E1. The check is finite and complete.
$\square$

*Remark 5.2.* Dropping invertibility of $\mathfrak h$ (allowing non-iso
transition maps) does not lower the bounds: $|X|=1$ still forces
$\mathfrak h=\mathrm{id}$. It does add solutions at $(2,2,2)$ — the two constant
endomaps of $X$ — which detect only one point rather than two. E1 remains
minimal; it is no longer unique.

*Remark 5.4 (seed148, restored: the chart-count bound is convention-dependent).*
Seed148 additionally claimed $|\mathcal F|\ge2$ charts are needed, under its own
convention that a loop is a string $(i_0,\dots,i_n,i_0)$ with $n\ge1$ and that
self-transitions $\rho_{ii}$ are not admitted. Seed146's Def. 1.3 imposes
$\rho_{ii}=\mathrm{id}$, which likewise excludes a one-chart witness. **The
referee flags this as a convention, not a theorem**, exactly as seed148 did: if
one admits $\rho_{ii}=\mathrm{sw}$, a single chart suffices and the bound drops
to $|I|=1$. Neither agent inflated this, and it is not part of Theorem 5's
minimality claim, which is in $(|X|,|\mathcal T|,|Q|)$ only.

*Remark 5.5 (referee: adjudicating $\operatorname{SearchSep}$).* The mandate asks
whether seed146's Def. — $\operatorname{SearchSep}_{\mathcal T}(\mathcal T')=1
\iff\ \sim_{\mathcal T'}=\sim_{\mathcal T}$ — is the right reading of §G, and
whether it is circular. Four findings, in order.

1. **The transmission's predicate is unary.** §G writes
   $\operatorname{SearchSep}(\mathcal T_\alpha)=1$, a predicate of one test set.
   The literal reading is therefore seed148's *absolute* one: $\mathcal T_\alpha$
   is **separating**, i.e. $\sim_{\mathcal T_\alpha}$ is equality on $X$.
   Seed146's binary $\operatorname{SearchSep}_{\mathcal T}(\mathcal T')$ is a
   **generalisation**, relative to a reference set; it specialises to the
   absolute reading when the reference $\mathcal T$ is itself separating.
2. **It is not circular.** Circularity would mean the definition makes
   $\delta=0\Rightarrow\operatorname{Advance}$ true by construction. It is used
   in the opposite direction — to make a conjunct of Advance *fail* — so the
   danger, if any, is the mirror one: a definition rigged to be easy to falsify.
   That is also not the case. $\operatorname{SearchSep}_{\mathcal T}$ does **not**
   fail on every proper shrink: deleting a test that is redundant in seed146's
   own sense (Cor. 3.2) leaves $\sim_{\mathcal T'}=\sim_{\mathcal T}$ and the
   predicate holds with $\mathcal T'\subsetneq\mathcal T$. The predicate is
   therefore non-trivial in both truth values on proper shrinks, which is the
   test a rigged definition fails.
3. **It is productive, not stipulative.** Under seed146's Def. one has a theorem,
   not a tautology: if $\sim_{\mathcal T'}=\sim_{\mathcal T}$ then
   $\delta^{\mathcal T'}_\sigma=\delta^{\mathcal T}_\sigma$ for every $\sigma$
   (immediate from Def. 1.5, since $\mathfrak h_\sigma x\sim_{\mathcal T'}x
   \iff \mathfrak h_\sigma x\sim_{\mathcal T}x$). So SearchSep is exactly the
   condition making a shrink $\delta$-faithful. Under seed148's absolute reading
   one has Prop. 3.4 instead. Both readings carry content; neither is an escape
   hatch.
4. **The refutation does not depend on the choice.** In E1,
   $\mathcal T'=\{t_2\}$ has $x_0\sim_{\mathcal T'}x_1$, so $\sim_{\mathcal T'}$
   is the total relation. It is therefore neither equal to $\sim_{\mathcal T}$
   (seed146's reading fails) nor equality on $X$ (seed148's reading fails).
   **E1 falsifies the SearchSep conjunct under both readings**, so Prop. 5.1
   stands under either, and the residual risk seed146 flagged in §6 is smaller
   than seed146 believed — though not zero, since a *third* definition of
   SearchSep not of the form "the working tests separate as much as X" could in
   principle still rescue the implication. The referee has not found a
   defensible such reading and does not claim none exists.

*Remark 5.3.* Two charts suffice: with $I=\{0,1\}$, $\rho_{01}=\mathrm{sw}$,
$\rho_{10}=\mathrm{id}$ and $\sigma=(0,1,0)$ one gets
$\mathfrak h_\sigma=\rho_{00}^{-1}\rho_{10}\rho_{01}=\mathrm{sw}$. The
three-chart presentation is used above only because it reads more cleanly.

### E2 — §J3: $\delta_\sigma = 0 \not\Leftarrow \delta^{\mathrm{base}}_\sigma = 0$

$X=\{x_0,x_1\}$, $Q=\{0,1\}$, $\mathcal T=\{t_1\}$, $e(x_i,t_1)=i$,
$\mathfrak h_\sigma=\mathrm{sw}$ as in E1. Base projection
$\pi : Q\to Q_{\mathrm{base}}=\{*\}$.

- Total resolution $r=(\mathcal T,\mathrm{id}_Q)$: $\delta^r_\sigma=\{x_0,x_1\}\ne\emptyset$.
- Base resolution $r^{\mathrm{base}}=(\mathcal T,\pi)\preceq r$:
  $\pi e(\mathfrak h x,t_1)=*=\pi e(x,t_1)$, so $\delta^{r^{\mathrm{base}}}_\sigma=\emptyset$.

So $\delta^{\mathrm{base}}_\sigma=0$ while $\delta_\sigma\ne0$: the projection
kills curvature the total object retains. This is the transmission's *hidden
curvature* ($\pi\mathfrak H_\sigma=1 \wedge \widetilde{\mathfrak H}_\sigma\ne1$),
now with a two-by-one witness.

**Minimality of E2.** $|X|\ge2$ and $|Q|\ge2$ by the argument of Theorem 5;
$|\mathcal T|\ge1$ since $\delta^r\ne\emptyset$ requires a detecting test; and
$\pi$ must be non-injective. E2 realises $(|X|,|\mathcal T|,|Q|,|Q_{\mathrm{base}}|)=(2,1,2,1)$,
all minimal. Up to relabelling of $X$ and $Q$ it is the unique such example:
with $|\mathcal T|=1$ and $\mathfrak h=\mathrm{sw}$ the single column must be
non-constant, which is $2$ of the $4$ columns, exchanged by the relabelling of
$Q$.

---

### E2′ — seed148's variant of the §J3 witness, restored

Seed148 gave a different §J3 counterexample, and it is worth keeping alongside
E2 because its projection is the shape the transmission's *seven components*
actually have, rather than a collapse to a point.

$X=\{a,b\}$, $\mathcal T=\{t\}$, $Q=\{0,1\}^2$ read as (sem, prov),
$e(a,t)=(0,0)$, $e(b,t)=(0,1)$, $\mathfrak h_\sigma=\mathrm{sw}$,
$\pi=$ first projection $Q\to\{0,1\}$.

- Base: $\pi e(\mathfrak h_\sigma a,t)=\pi(0,1)=0=\pi e(a,t)$, and symmetrically
  for $b$. So $\delta^{\mathrm{base}}_\sigma=\emptyset$.
- Total: $e(\mathfrak h_\sigma a,t)=(0,1)\ne(0,0)=e(a,t)$, so
  $\delta_\sigma=\{a,b\}\ne\emptyset$.

Four evaluations, all displayed. The base is flat, the total is not: D0016's
गुह्यवक्रता, with the hidden curvature living in the provenance coordinate
specifically. E2′ is *not* smaller than E2 ($|Q|=4$ against $|Q|=2$), so E2
retains the minimality claim of §5; E2′ is retained for its interpretive value,
not as a competing minimal example. **The referee records that seed148 did not
claim minimality for E2′, and none is claimed here.**

---

## 5A. Referee: the exhaustive count, recomputed from scratch

Theorem 5's count is a finite exhaustive verification, hence proof per
`CLAUDE.md` — but only if it is right. The referee redid it independently rather
than reading seed146's enumeration back. It is right.

**Setup.** $X=\{x_0,x_1\}$, $Q=\{0,1\}$, $\mathcal T=\{t_1,t_2\}$. A matrix is a
choice of two columns, each a pair $(e(x_0,t),e(x_1,t))\in Q^2$: $4\times4=16$.
Required: $\mathfrak h\in\operatorname{Aut}(X)$ and $\emptyset\ne\mathcal T'\subsetneq\mathcal T$
with $\delta^{\mathcal T'}=\emptyset\ne\delta^{\mathcal T}$.

**Step 1 — $\mathfrak h$.** $\operatorname{Aut}(\{x_0,x_1\})=\{\mathrm{id},\mathrm{sw}\}$.
$\mathfrak h=\mathrm{id}$ gives $D_\sigma(x)=\emptyset$ for both $x$, so
$\delta^{S}=\emptyset$ for every $S$, and $\delta^{\mathcal T}\ne\emptyset$ fails.
So $\mathfrak h=\mathrm{sw}$. **1 of the 2 automorphisms survives.**

**Step 2 — the detector sets under $\mathrm{sw}$.**
$D(x_0)=\{t : e(x_1,t)\ne e(x_0,t)\}$ and $D(x_1)=\{t : e(x_0,t)\ne e(x_1,t)\}$
— *the same set*, namely the set of non-constant columns. Write $N$ for it. Then
$\delta^{S}=X$ if $S\cap N\ne\emptyset$ and $\delta^{S}=\emptyset$ otherwise. So
$\delta$ takes only the two values $\emptyset$ and $X$ here; there is no
intermediate case to overlook.

**Step 3 — the constraint.** With $\mathcal T'=\{t_2\}$ (the other choice
$\{t_1\}$ is the same by the relabelling $t_1\leftrightarrow t_2$, which is an
isomorphism of Chu spaces): $\delta^{\{t_2\}}=\emptyset$ forces $t_2\notin N$,
i.e. $t_2$ **constant**; $\delta^{\mathcal T}\ne\emptyset$ then forces
$t_1\in N$, i.e. $t_1$ **non-constant**.

**Step 4 — the count.** Constant columns: $(0,0),(1,1)$ — two. Non-constant:
$(0,1),(1,0)$ — two. Admissible matrices: $2\times2=\mathbf{4}$ out of
$\mathbf{16}$. **Seed146's count is confirmed.**

**Step 5 — the isomorphism claim, which seed146 asserted rather than exhibited.**
The relabelling group acting is generated by $\tau_X$ (swap the rows) and
$\tau_Q$ (swap the two values of $Q$, acting on *both* columns simultaneously —
this is the point at which a sloppy argument would double-count). Orbit of
E1 $=\bigl(t_1=(0,1),\,t_2=(0,0)\bigr)$:

| | $t_1$ | $t_2$ |
|---|---|---|
| E1 | $(0,1)$ | $(0,0)$ |
| $\tau_X$E1 | $(1,0)$ | $(0,0)$ |
| $\tau_Q$E1 | $(1,0)$ | $(1,1)$ |
| $\tau_X\tau_Q$E1 | $(0,1)$ | $(1,1)$ |

Four distinct matrices, and they are precisely the four admissible ones. So the
orbit is the whole solution set: **a single isomorphism class, as claimed.**
(Note $\tau_X$ fixes constant columns and swaps the non-constant ones, while
$\tau_Q$ swaps both pairs; the two generators therefore act independently on the
two coordinates, which is why the orbit has size exactly $4$ and not $2$.)

**Step 6 — Remark 5.2 (invertibility dropped), also recomputed.** The
non-invertible self-maps of $X$ are the two constants $c_0,c_1$ ($c_i$ sends
everything to $x_i$). Take $\mathfrak h=c_0$: $D(x_0)=\emptyset$ and
$D(x_1)=\{t : e(x_0,t)\ne e(x_1,t)\}=N$. So $\delta^{S}=\{x_1\}$ if
$S\cap N\ne\emptyset$, else $\emptyset$. The constraint is the *same* ($t_2$
constant, $t_1$ non-constant), giving $4$ further solutions with $\mathfrak h=c_0$
and $4$ with $\mathfrak h=c_1$. These are **not** isomorphic to E1: $|\delta^{\mathcal T}|=1$
against $|\delta^{\mathcal T}|=2$, and cardinality of the defect is a relabelling
invariant. So uniqueness genuinely fails without invertibility, while the
minimality bounds are untouched ($|X|=1$ still forces $\mathfrak h=\mathrm{id}$).
**Remark 5.2 is confirmed in both of its clauses.**

**Referee's conclusion on §5.** The count holds, the isomorphism claim holds, the
invertibility caveat holds. This is the one part of the night's work that is
proof in the strict sense of `CLAUDE.md` — a complete finite enumeration — and it
survives independent recomputation. No number in it was measured.

---

## 6. What this does **not** prove

Stated explicitly, because the transmission's §J4 asks for it and because a
program written as a boxed display is still a program.

- **The ordinal ladder §C.** $\delta^{(n)}\to\chi^{(n+1)}\to\delta^{(n+1)}$, the
  hocolim at limits, and $\partial\delta^{(\lambda)}\ne0\Rightarrow\lambda\mapsto\lambda+1$:
  untouched. No convergence, no smallness, no proof that $\Gamma$ is well
  defined on $\mathcal O_\alpha$, no value for $\kappa$.
- **The step functor $\mathfrak F$ and $\mathfrak F_{\alpha+1}\succeq\mathfrak F_\alpha$.**
  Untouched. I do not know that $\mathfrak F$ is a functor.
- **$\mathbb B=\int^{\alpha}\Diamond_\alpha$ and the closure claim §E.** Untouched.
- **The seven components of $\delta_\sigma$** ($\delta^{\mathrm{sem}}$, …,
  $\delta^{\mathrm{prov}}$). I prove a theorem about the *observational
  skeleton* of a defect and about coarsening of the value set (Thm 3), which is
  the shape a component-projection has. I do **not** prove the seven components
  are independent, well defined, or exhaustive.
- **$\operatorname{Advance}$ beyond one conjunct.** $\operatorname{Verify}$,
  $\operatorname{PreserveProv}$, $\operatorname{UsefulEscape}$,
  $\operatorname{DeclaredBoundaryPreserved}$ are undefined in the transmission
  and I do not define them. Prop. 5.1 refutes the implication by falsifying
  $\operatorname{SearchSep}$ **under my Def. in §5**; a different definition of
  $\operatorname{SearchSep}$ could in principle rescue the implication, and I
  say so rather than hiding it. *(Referee, Rem. 5.5: this residual risk is
  narrower than stated — E1 falsifies the conjunct under seed146's relative
  reading **and** under seed148's absolute reading, which is the transmission's
  literal unary one. Both were checked. A reading not of the form "the working
  tests separate as much as X" is not excluded.)* What is unconditional is the *mathematical*
  half: $\delta$ vanishing under a shrunken $\mathcal T$ while non-vanishing
  under a larger one (E1) — that needs no definition of Advance at all.
- **The Yang–Baxter defect §D.** Untouched.
- **Changing test sets.** Def. 1.7 covers $\mathcal T'\subseteq\mathcal T$ only.
  §F's warning that "the measurement domain itself changes" describes the case
  $\mathcal T'\not\subseteq\mathcal T$, where Theorem 1 is simply false: adding
  one test and deleting another can raise or lower $\delta$ arbitrarily. Nothing
  here bears on that case, which is the interesting one for §C.
- **Charts with distinct test sets.** Def. 1.3 gives every chart the same
  $(\mathcal T, e)$. The genuinely fibred case is not treated.
- **No machine verification.** No Agda or Lean was authored and none was
  typechecked; there is no toolchain in this container. Every proof above is
  finite, elementary, and checked by hand; Theorem 5 is a complete enumeration
  of $16$ cases, done in §5 and reproducible by reading it.

---

## 7. Prior art, and the novelty claim

Searched **before** writing, per `CLAUDE.md`. What I actually read: the nLab
page *Chu space*; the Wikipedia page *Formal concept analysis*; search-result
excerpts of the Wikipedia *Chu space* page and of Pratt's Chu-space notes. I did
**not** read any PDF (they do not decode in this container), so De
Nicola–Hennessy 1984 and Ganter–Wille 1999 are cited from their standard
statements, not from a text I opened, and I mark them as such.

- **Chu spaces**: Chu 1979 (the construction, in Barr's *\*-Autonomous
  Categories*, LNM 752); Barr 1991/1996; Pratt 1992–1999. A Chu space is
  *separated* when all rows are distinct and *extensional* when all columns are
  distinct — i.e. when $\sim_{\mathcal T}$ and $\sim_X$ are trivial. The
  separated quotient $X/\!\sim_{\mathcal T}$ is standard, as is the observation
  that separatedness of $(X,\mathcal T,e)$ over $Q=2$ is the $T_0$ axiom.
- **The polarity**: the pair (antitone $S\mapsto\;\sim_S$, monotone
  $S\mapsto\operatorname{Sep}(S)$) is a Birkhoff polarity (*Lattice Theory*,
  1940, chapter on Galois connections), and Ore's "Galois connexions" (1944).
  In formal concept analysis the derivation operators
  $A\mapsto A'$, $B\mapsto B'$ of a context $(G,M,I)$ form exactly this Galois
  connection (Wille 1982; Ganter–Wille 1999); *object clarification* is the
  quotient by $\sim_M$, and its coarsening under attribute restriction is
  folklore there.
- **Testing semantics**: "fewer tests distinguish fewer processes" is the
  monotonicity underlying testing preorders, De Nicola–Hennessy, *Testing
  equivalences for processes*, TCS 34 (1984).
- **Holonomy/descent**: $\mathfrak h_\sigma=\mathrm{id}$ for all $\sigma$ iff
  $\rho$ is a Čech 1-cocycle is the definition of the descent obstruction; not
  new by any margin.

**Therefore: Theorems 1 and 3 are classical in substance** — the monotone half
of a Galois polarity, specialised along $x\mapsto(\mathfrak h_\sigma x,x)$. I
claim no novelty for them and I would not have run an experiment to find them.
What I have not located in the literature, and offer as at most a small
contribution:

1. the *difference formula* Thm 2 and its corollary that strict decrease is
   exactly the destruction of some point's whole detector set (Cor. 3.1) — this
   is elementary enough that it is probably folklore in FCA under a name like
   "reducible attribute"; I state it as a likely rediscovery;
2. the observation that §J2 and §J3 are the two coordinate directions of the
   single resolution-monotonicity lemma (Thm 3);
3. the minimal counterexample with its exhaustive uniqueness count (Thm 5).

An honestly-labelled rediscovery beats a false novelty claim. This is one.

**Seed148's additional citation (restored).** Seed148 traced the
separated/extensional Chu space and the *biextensional collapse* to
**M. Barr, *\*-Autonomous Categories*, LNM 752 (1979), §6**, attribution quoted
from `arxiv.org/html/2412.11478` Def. 2.4 and its following remark — HTML, which
did decode — and stated explicitly that it did **not** read Barr 1979 itself.
Seed146 cited the same body of work through the nLab page and Pratt's notes, and
added De Nicola–Hennessy 1984 from its standard statement, no PDF opened. The
referee opened no new source and adds no citation. **No PDF is claimed as read
by anyone in this chain.**

---

## 7A. Referee: what the replication does and does not buy

Two independent proofs of one theorem is an experiment, and the result of this
one should be stated at its true strength and no higher.

**What it buys.**

1. *The definitional choices are not idiosyncratic.* Both agents, without
   contact, arrived at the same observational reading of $\ominus 1$ — the
   defect as the locus where the tests can see the holonomy move a point — and
   at the same detector/witness set. That two independent readings of an
   under-specified transmission converge is genuine evidence that this is the
   reading §G intends, and it is the strongest thing the replication supplies.
   It is evidence about **D0016's intent**, not about the mathematics.
2. *The refutation is robust to the definition of SearchSep.* Seed146 defined it
   relatively, seed148 absolutely, and E1 kills the conjunct either way
   (Rem. 5.5). A counterexample that survives two independent formalisations of
   the disputed predicate is worth more than one that survives one.
3. *Neither agent inflated weak monotonicity to strict.* Two independent refusals
   is mild evidence that the temptation was visible and resisted rather than
   never noticed.

**What it does not buy, and this is the larger half.**

4. *Two proofs of a classical theorem is weak evidence.* Theorems 1 and 3 are the
   monotone half of a Birkhoff polarity. Two agents rederiving a 1940 result
   agree because the result is easy, not because independent agreement is
   informative. Replication is informative in proportion to the probability that
   an error would have been *independent*; for a one-line monotonicity argument
   that probability is near zero on both sides, so the correlation of the two
   outcomes carries almost no information. **A replication of an easy theorem
   measures the difficulty of the theorem, not the reliability of the agents.**
5. *The one genuinely checkable claim was replicated by only one agent.* The
   exhaustive count at $(2,2,2)$ appears in seed146 alone; seed148 proved the
   minimality *bounds* but did not enumerate. So the count was **not**
   independently replicated by the two agents — it was replicated by the referee
   in §5A, which is a second check but not an independent one in the same sense.
6. *Convergence on a definition is not validation of a definition.* Both agents
   chose the weakest reading under which the slogan is true. Two agents
   optimising the same objective under the same instruction will converge whether
   or not the objective is right; the convergence in (1) is therefore weaker
   evidence than it first looks, and the referee downgrades it accordingly.

**Still unproved, in full.** Nothing in §6's list was touched by either agent or
by the referee: the ordinal ladder §C ($\delta^{(n)}\to\chi^{(n+1)}\to\delta^{(n+1)}$,
the hocolim at limits, $\kappa$, the well-definedness of $\Gamma$); the step
functor $\mathfrak F$ and $\mathfrak F_{\alpha+1}\succeq\mathfrak F_\alpha$;
$\mathbb B=\int^{\alpha}\Diamond_\alpha$ and the closure claim §E; the seven
components of $\delta_\sigma$ (independence, well-definedness, exhaustiveness);
the Yang–Baxter defect §D; and four of the five conjuncts of $\operatorname{Advance}$
($\operatorname{Verify}$, $\operatorname{PreserveProv}$,
$\operatorname{UsefulEscape}$, $\operatorname{DeclaredBoundaryPreserved}$), which
remain undefined in the transmission and undefined here. Also unproved, and
worth naming because §F says it is the interesting case: everything under
$\mathcal T'\not\subseteq\mathcal T$, where Theorem 1 is false.

**What one §J2 discharge buys against D0016 as a whole:** one boxed display of
roughly forty, and the easiest one. That is the honest accounting.

---

## 8. What the theorem licenses, and at what generality

Only this, and I write it at the generality I can defend:

> For a defect measured as *the set of points on which the tests can see the
> holonomy move them*, deleting tests never raises the defect, and lowers it
> exactly on those points whose every detector was deleted. Hence a report of
> "$\delta=0$" carries no information at all unless the test set is also
> reported, and it carries **no** information about $\rho$ when the test set is
> not separating.

Not licensed: any claim about defects measured otherwise (norms, spectra,
probabilities); any claim under test-set *change* rather than shrinkage; any
claim about the ordinal ladder. §J5 of the transmission notes that tonight's
fleet measurement (`0742-seed141`) is the same statement in another vocabulary.
It is *analogous*, and the analogy is worth recording, but Theorem 1 does not
prove anything about grep recall — a lexical sweep is not a Chu space until
someone says what $X$, $\mathcal T$ and $e$ are, and I have not.

---

*Question and framework: the repository owner, D0016, 2026-08-14.*

*Attribution of the mathematics. Definitions 1.1–1.7, Theorems 1–5, Cor. 3.1–3.3,
E1, E2, Rem. 5.2–5.3: **seed146** (`0747`). Cor. 2.3, Prop. 3.4, Rem. 5.4, E2′,
and the Barr 1979 §6 citation: **seed148** (`0749`), restored here after seed146's
commit `e08c07ab` silently overwrote seed148's file. §3A, §5A, Rem. 5.5, §7A, and
this merge: **seed150** (referee, `0751`). The two agents worked without sight of
each other and their results agree; §3A proves the agreement rather than assuming
it, and §5A recomputes the only claim that is proof in the strict sense.*

*No experiment was run; no floating-point number appears above. No Agda or Lean
was authored and none was typechecked — there is no toolchain in this container,
and no machine verification is claimed by anyone in this chain. No PDF was
decoded or claimed as read.*
