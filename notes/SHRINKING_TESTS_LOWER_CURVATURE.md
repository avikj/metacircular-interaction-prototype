# Shrinking the tests lowers the curvature

**Source of the question.** `collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md`
(the owner's transmission of 2026-08-14), §G and its triage item **§J2**:

$$\operatorname{Shrink}(\mathcal T)\Rightarrow\delta\downarrow,\qquad \delta=0\not\Rightarrow\operatorname{Advance},\qquad \text{शून्यवक्रता}\ne\text{सत्य}.$$

The transmission asserts this and says explicitly that it is asserted, not proved, and that
"the exact statement (which order, which $\downarrow$, strict or weak) is not written down
anywhere above." Credit for the question and for the framework is the owner's; what follows
is the proof, the strictness condition, and two finite counterexamples. §J3's non-implication
$\delta_\sigma=0\;\not\Leftarrow\;\delta^{\mathrm{base}}_\sigma=0$ falls out of the same lemma
and is settled in §6.

**Verdict, stated up front, so the summary cannot outrun the body.**

- The monotonicity is **true and weak** (§4, Thm 1): shrinking the test set can only shrink the
  detected defect, and equality is the generic case. Weak monotonicity is all that holds.
- The **strictness condition** is exactly the existence of a *sole witness* among the discarded
  tests (§4, Thm 2). This is the content: without it the slogan would be unlicensed.
- $\delta=0\not\Rightarrow$ truth is **proved by a 2-point, 2-test, 2-value finite
  counterexample** (§5), verified exhaustively by hand, and minimal in each of
  $|X|,|\mathcal T|,|Q|$ *among examples whose shrunken test set is non-empty* (§5.2 — with the
  empty shrink the claim is Corollary 2.1 and needs no example at all).
- The underlying Galois monotonicity is **classical** — Birkhoff polarities, formal concept
  analysis, and the separated/extensional quotient of a Chu space (Barr 1979). See §2. What is
  not classical, as far as the search in §2 reached, is only the *packaging*: the identification
  of §G's `SearchSep` conjunct as precisely the hypothesis that makes $\delta=0$ informative
  (§4, Prop 3). That is a one-line corollary, and I claim nothing more for it.

---

## 1. Why this is a `PROVE` item and not a `DEMONSTRATE` item

`CLAUDE.md`: *before running any computation, write down the theorem it would replace.* The
theorem a defect-sweep would be standing in for is Theorem 1 below. It is a page of algebra —
in fact four lines — and it determines exactly the behaviour that `0742-seed141` observed by
counting (recall 14/15 where the defect has a lexical name, 1/7 and 1/6 where it does not).
Per §J5 that empirical coincidence is the reason the artifact was kept; it is not the reason
the statement is true, and it is superseded by §4. No measurement is reported in this note.

## 2. Prior art, searched before the write-up

Searched: nLab (`Chu construction`, `formal concept analysis`), Wikipedia, arXiv HTML.
PDFs do not decode in this container and none is claimed as read.

1. **The Galois connection between test sets and distinguishability is Birkhoff's polarity**
   (Birkhoff, *Lattice Theory*, 1940), the foundation of **formal concept analysis**
   (Wille 1982; Ganter–Wille, *Formal Concept Analysis*, 1999). The order-reversing
   correspondence "more attributes ⇒ finer object equivalence" is the defining property of the
   polarity. Lemma 0 below **is** this, restricted to kernels.
2. **Separated / extensional Chu spaces and the biextensional collapse.** A Chu space
   $\langle X,r,A\rangle$ is *separated* iff $x=y\iff\forall a\,(\langle x,a\rangle\in r\iff\langle y,a\rangle\in r)$,
   *extensional* dually; every Chu space has a separated-and-extensional quotient, the
   *biextensional collapse*. The earliest source is **M. Barr, *\*-Autonomous Categories*,
   Lecture Notes in Mathematics 752 (1979), §6**, where these were "first been considered …
   under a slightly different terminology"; this attribution is quoted from
   `arxiv.org/html/2412.11478` (*Properties preserved by classes of Chu transforms*),
   Definition 2.4 and the remark following it, which is the text I actually read.
   I did **not** read Barr 1979 and therefore quote no numbered statement from it beyond the
   section number that source gives. Barr, *The separated extensional Chu category*, TAC 4
   (1998), is the later dedicated treatment; I did not read it either and cite it only by title.
   Pratt's Chu-space notes are the standard modern exposition; the arXiv source above does not
   attribute the separation properties to him and neither do I.
3. **Holonomy as descent obstruction** (§J3's own gloss) is standard Čech-style descent; the
   transmission's $\mathfrak H_\sigma$ over $N(\mathcal F)$ is the usual loop-composite.

**Conclusion of the search.** *The mathematics of §4 is classical.* Theorem 1 is the polarity
monotonicity of Birkhoff/FCA, transported along a holonomy map; Theorem 2 is the elementary
sharpening one gets by asking when a Galois-coarsening is strict, and I found no source stating
it in these terms, which is weak evidence of novelty and not a claim of it. §5's counterexample
is of the kind any FCA text could produce in a line. **A rediscovery honestly labelled**: that
is what this note is, and it is the right outcome — the transmission's §J2 asked for a proof,
and a proof of a classical fact is still a proof, and it removes an unproved boxed display.

## 3. The definitions, fixed

The transmission leaves the order and the sense of $\downarrow$ unspecified. I fix them.

**Definition 3.1 (Chu space).** $\mathcal C=(X,\mathcal T,e)$ with $X$ a set of *points*,
$\mathcal T$ a set of *tests*, $e:X\times\mathcal T\to Q$ the evaluation into a *value set* $Q$.
(The transmission writes $e_\alpha:\mathcal F_\alpha\times\mathcal T_\alpha\to Q_\alpha$; I write
the carrier as $X$ and keep $\mathcal F$ for the chart family of Definition 3.4, per §A–§B where
$X_\alpha$ and $\mathcal F_\alpha$ are separate slots of $\Diamond_\alpha$.)

**Definition 3.2 (separation quotient).** For $S\subseteq\mathcal T$,
$$x\sim_S x'\;:\iff\;\forall t\in S,\;e(x,t)=e(x',t).$$
This is an equivalence relation; $q_S:X\to X/{\sim_S}$ is the quotient. $S$ is **separating**
iff $\sim_S$ is equality on $X$, i.e. iff $(X,S,e|_{X\times S})$ is separated in Barr's sense.
Note $\sim_\varnothing=X\times X$, the total relation.

**Definition 3.3 (instrument; the order on instruments).** More generally an *instrument* is a
map $\iota:X\to V$ into any set; its kernel $\sim_\iota$ is $x\sim_\iota x'\iff\iota x=\iota x'$.
Order instruments by refinement of kernel: $\iota'\preceq\iota$ ("$\iota'$ is **coarser**")
iff $\sim_\iota\;\subseteq\;\sim_{\iota'}$. A test set $S$ gives the instrument
$\iota_S=(t\mapsto e(-,t))_{t\in S}:X\to Q^S$, whose kernel is $\sim_S$.

This is the order the transmission's $\operatorname{Shrink}$ and $\downarrow$ refer to; making
it explicit is half the work, because **two different operations are both "shrinking"**:
discarding tests, and coarsening the value set $Q$ along a projection $\pi$. Both coarsen the
kernel, and Lemma 0 covers both. §6 uses this.

**Definition 3.4 (holonomy datum).** A *holonomy datum over $\mathcal C$* is a finite index set
$\mathcal F=\{i_0,\dots,i_m\}$ (the charts) together with, for certain ordered pairs $(i,j)$, a
*transport* $\rho_{ij}:X\to X$. The nerve $N(\mathcal F)$ has as its $n$-simplices the composable
strings; for a **loop** $\sigma=(i_0,i_1,\dots,i_n,i_0)$ the *holonomy* is the composite
$$\mathfrak h_\sigma:=\rho_{i_ni_0}\circ\rho_{i_{n-1}i_n}\circ\cdots\circ\rho_{i_0i_1}\;:\;X\to X.$$
No invertibility and no groupoid law is assumed: transports are arbitrary self-maps, which is
the weakest hypothesis under which everything below still holds. (If the $\rho$ are invertible
and $\rho_{ji}=\rho_{ij}^{-1}$ then every $\mathfrak h_\sigma$ is trivial and there is nothing
to measure; holonomy exists precisely because that is *not* assumed.)

**Definition 3.5 (the defect, as an $S$-observable).** Fix a loop $\sigma$ and $S\subseteq\mathcal T$.
$$\operatorname{Det}_\sigma(S):=\{x\in X:\ \mathfrak h_\sigma x\not\sim_S x\},\qquad
D_\sigma(S):=\{(x,t)\in X\times S:\ e(\mathfrak h_\sigma x,t)\ne e(x,t)\}.$$
$$\delta_\sigma(S):=\bigl[\,q_S\circ\mathfrak h_\sigma\ \text{versus}\ q_S\,\bigr],\qquad
\delta_\sigma(S)=0\ :\iff\ q_S\circ\mathfrak h_\sigma=q_S\ \iff\ \operatorname{Det}_\sigma(S)=\varnothing .$$
This is the transmission's $\delta_\sigma=\mathfrak H_\sigma\ominus 1$ read *through the tests*:
$\ominus 1$ is comparison with the identity, and "comparison" is only ever available up to what
$\mathcal T$ can see. $\operatorname{Det}$ and $D$ are the two natural refinements of the
yes/no defect, ordered by inclusion; $|{\operatorname{Det}}|$ and $|D|$ are the numerical
$\downarrow$. The aggregate obstruction of §B, $\mathcal O(S):=\int^{\sigma\in N(\mathcal F)}\delta_\sigma$,
is read here as $\operatorname{Ob}(S):=\{\sigma\in N(\mathcal F)\ \text{a loop}:\delta_\sigma(S)\ne0\}$.

*Remark 3.6.* $\delta_\sigma(S)=0$ implies $\mathfrak h_\sigma$ descends to $X/{\sim_S}$ and
descends **to the identity**: from $q_S\mathfrak h_\sigma=q_S$, if $x\sim_S y$ then
$q_S\mathfrak h_\sigma x=q_Sx=q_Sy=q_S\mathfrak h_\sigma y$. So no separate descent hypothesis
is needed anywhere below. Note also that $\delta_\sigma(S)=0$ does **not** require
$\mathfrak h_\sigma$ to descend before quotienting — Definition 3.5 is deliberately stated on
$X$, not on $X/\sim_S$, for exactly this reason.

## 4. The theorem

**Lemma 0 (polarity monotonicity; classical, §2.1).** If $S'\subseteq S\subseteq\mathcal T$ then
$\sim_S\ \subseteq\ \sim_{S'}$. More generally if $\iota'\preceq\iota$ then
$\sim_\iota\subseteq\sim_{\iota'}$ by definition.

*Proof.* If $x\sim_S x'$ then $e(x,t)=e(x',t)$ for all $t\in S\supseteq S'$, hence for all
$t\in S'$. $\square$

**Theorem 1 (Shrink $\Rightarrow\delta\downarrow$; weak monotonicity).**
Let $\sigma$ be any loop in $N(\mathcal F)$ and $S'\subseteq S\subseteq\mathcal T$. Then
$$\operatorname{Det}_\sigma(S')\subseteq\operatorname{Det}_\sigma(S),\qquad
D_\sigma(S')= D_\sigma(S)\cap(X\times S')\subseteq D_\sigma(S),$$
hence $|\operatorname{Det}_\sigma(S')|\le|\operatorname{Det}_\sigma(S)|$,
$|D_\sigma(S')|\le|D_\sigma(S)|$, and
$$\delta_\sigma(S)=0\ \Longrightarrow\ \delta_\sigma(S')=0 .$$
Consequently $\operatorname{Ob}(S')\subseteq\operatorname{Ob}(S)$: the whole obstruction
$\mathcal O$ is monotone. The same holds verbatim for any coarsening $\iota'\preceq\iota$ of
instruments in place of $S'\subseteq S$.

*Proof.* Let $x\in\operatorname{Det}_\sigma(S')$, i.e. $\mathfrak h_\sigma x\not\sim_{S'}x$. By
Lemma 0, $\sim_S\subseteq\sim_{S'}$, so $\mathfrak h_\sigma x\sim_S x$ would give
$\mathfrak h_\sigma x\sim_{S'}x$; hence $\mathfrak h_\sigma x\not\sim_S x$ and
$x\in\operatorname{Det}_\sigma(S)$. The statement for $D$ is immediate from the definition,
which is a restriction of the same condition to $t\in S'$. The implication on $\delta$ is the
case $\operatorname{Det}_\sigma(S)=\varnothing$. For $\operatorname{Ob}$, apply the implication
loopwise. The general instrument case replaces the appeal to Lemma 0's subset clause by its
definitional clause. $\square$

Four lines, as predicted. Note what is **not** claimed: nothing is asserted about
$\delta_\sigma(S')<\delta_\sigma(S)$, and nothing about *growing* $\mathcal T$ (the transmission's
§F warns that $\mathcal T_\alpha\subseteq\mathcal T_{\alpha+1}$ **or not** — the measurement
domain may change non-monotonically, and then Theorem 1 says nothing at all: it is a statement
about comparable instruments only, and §F's $\Phi_{\mathrm{cut}}$ produces incomparable ones).

**Theorem 2 (the strictness condition — the content).** With $S'\subseteq S$ and $\sigma$ fixed,
$$\operatorname{Det}_\sigma(S')\subsetneq\operatorname{Det}_\sigma(S)
\iff \exists x\in X:\ \mathfrak h_\sigma x\not\sim_S x\ \text{ and }\ \mathfrak h_\sigma x\sim_{S'}x,$$
i.e. iff some point's displacement is witnessed **only** by discarded tests. Writing
$W_\sigma(x):=\{t\in\mathcal T: e(\mathfrak h_\sigma x,t)\ne e(x,t)\}$ for the witness set of $x$,
this reads
$$\operatorname{Det}_\sigma(S')\subsetneq\operatorname{Det}_\sigma(S)
\iff \exists x:\ \varnothing\ne W_\sigma(x)\cap S\ \subseteq\ S\setminus S' .$$
In particular the total collapse
$$\delta_\sigma(S')=0\ \wedge\ \delta_\sigma(S)\ne0
\iff \varnothing\ne\ \bigcup_{x}\bigl(W_\sigma(x)\cap S\bigr)\ \text{ and }\ W_\sigma(x)\cap S'=\varnothing\ \text{ for every }x .$$
And $t\in S$ is **$\sigma$-critical for $S$** — its removal alone strictly lowers the defect —
iff $\exists x$ with $W_\sigma(x)\cap S=\{t\}$.

*Proof.* ($\Leftarrow$) Such an $x$ lies in $\operatorname{Det}_\sigma(S)\setminus\operatorname{Det}_\sigma(S')$,
and the inclusion of Theorem 1 is then proper. ($\Rightarrow$) Properness of the inclusion
supplies $x\in\operatorname{Det}_\sigma(S)\setminus\operatorname{Det}_\sigma(S')$, which is
verbatim the displayed condition. The reformulation through $W_\sigma$ is the observation that
$\mathfrak h_\sigma x\sim_Ux\iff W_\sigma(x)\cap U=\varnothing$ for any $U\subseteq\mathcal T$.
The total-collapse and criticality clauses are the special cases
$\operatorname{Det}_\sigma(S')=\varnothing\ne\operatorname{Det}_\sigma(S)$ and
$S'=S\setminus\{t\}$. $\square$

**Corollary 2.1 (the degenerate shrink, and why the slogan is licensed).** Take $S'=\varnothing$.
Then $\sim_\varnothing$ is total, $\operatorname{Det}_\sigma(\varnothing)=\varnothing$, and
$$\delta_\sigma(\varnothing)=0\quad\text{for every holonomy datum whatsoever,}$$
however wild $\mathfrak h_\sigma$ is. So $\delta=0$ is *unconditionally achievable by shrinking*
and therefore carries, by itself, exactly zero information about $\mathfrak h_\sigma$. That is
शून्यवक्रता $\ne$ सत्य, proved. Theorem 2 says the drop from $S$ to $\varnothing$ is strict
precisely when some $\mathfrak h_\sigma$ moved a point detectably at all — i.e. the instrument
was doing work, and shrinking destroyed the evidence rather than the defect.

**Proposition 3 (when $\delta=0$ *is* truth; §G's `SearchSep` identified).**
If $S$ is separating (Def. 3.2) then
$$\delta_\sigma(S)=0\iff\mathfrak h_\sigma=\operatorname{id}_X .$$
*Proof.* $\Leftarrow$ trivial. $\Rightarrow$: $q_S$ is injective when $\sim_S$ is equality, so
$q_S\mathfrak h_\sigma=q_S$ gives $\mathfrak h_\sigma x=x$ for all $x$. $\square$

Hence in §G's predicate
$\operatorname{Advance}\iff\operatorname{Verify}\wedge\operatorname{SearchSep}(\mathcal T)\wedge\cdots$,
the conjunct $\operatorname{SearchSep}(\mathcal T)=1$ is **exactly** the hypothesis converting
$\delta=0$ from vacuity into a theorem about the object. Read this way §G's anti-degeneracy
clause is not an extra axiom but the contrapositive of Corollary 2.1: $\delta=0$ is admissible
evidence only relative to a certified-separating instrument. This is the only sentence in this
note I did not find already written down somewhere, and it is a corollary, not a discovery.

## 5. $\delta=0\not\Rightarrow\operatorname{Advance}$: a finite counterexample, exhaustively verified

Per `CLAUDE.md`, a **finite exhaustive verification is proof**. Everything below is a check of
at most eight equalities between elements of a two-element set, done by hand and displayed in
full, so the reader verifies it rather than trusting it.

**Example 5.1 (non-degenerate shrink: $S'\ne\varnothing$).**
$$X=\{a,b\},\qquad \mathcal T=\{t_1,t_2\},\qquad Q=\{0,1\},$$
$$e(a,t_1)=0,\quad e(b,t_1)=1,\qquad e(a,t_2)=0,\quad e(b,t_2)=0 .$$
Charts $\mathcal F=\{i,j\}$, transports $\rho_{ij}=\text{swap }(a\leftrightarrow b)$,
$\rho_{ji}=\operatorname{id}$; the loop $\sigma=(i,j,i)$ has
$\mathfrak h_\sigma=\rho_{ji}\circ\rho_{ij}=\text{swap}\ne\operatorname{id}_X$.
(Transports are not required to be mutually inverse — Def. 3.4.)

*Full instrument $S=\mathcal T$.* $e(\mathfrak h_\sigma a,t_1)=e(b,t_1)=1\ne0=e(a,t_1)$, so
$a\in\operatorname{Det}_\sigma(S)$; likewise $e(\mathfrak h_\sigma b,t_1)=e(a,t_1)=0\ne1$, so
$b\in\operatorname{Det}_\sigma(S)$. Thus $\operatorname{Det}_\sigma(\mathcal T)=\{a,b\}$,
$D_\sigma(\mathcal T)=\{(a,t_1),(b,t_1)\}$, $|D|=2$, and $\delta_\sigma(\mathcal T)\ne0$.

*Shrunken instrument $S'=\{t_2\}$.* $e(\mathfrak h_\sigma a,t_2)=e(b,t_2)=0=e(a,t_2)$ and
$e(\mathfrak h_\sigma b,t_2)=e(a,t_2)=0=e(b,t_2)$. All (both) points check out:
$\operatorname{Det}_\sigma(S')=\varnothing$, $D_\sigma(S')=\varnothing$, $\delta_\sigma(S')=0$.

Four evaluations exhaust the pairs $(x,t)$ used; two more, $e(a,t_1),e(b,t_1)$, are quoted above.
So: **$\delta=0$ under the shrunken test set, $\delta\ne0$ under the larger, with the shrunken
set non-empty.** The transported object is genuinely wrong (it swaps $a$ and $b$) and the
instrument reports perfection. Advance fails here for the reason Prop. 3 predicts:
$\operatorname{SearchSep}(S')=0$, since $a\sim_{S'}b$. The strictness of Theorem 2 is visible:
$W_\sigma(a)=W_\sigma(b)=\{t_1\}$, so $t_1$ is $\sigma$-critical, and it is exactly the discarded
test.

**Minimality 5.2.** Example 5.1 is minimal in all three parameters simultaneously, among examples
with $S'\ne\varnothing$:
- $|Q|\ge2$: if $|Q|=1$ then $\sim_S$ is total for every $S$ and $\delta_\sigma(S)=0$ always,
  so no larger set can have $\delta\ne0$.
- $|X|\ge2$: if $|X|=1$ then $\mathfrak h_\sigma=\operatorname{id}$ forcibly and $\delta\equiv0$.
- $|\mathcal T|\ge2$: with $S'\subsetneq S\subseteq\mathcal T$ and $S'\ne\varnothing$ we need
  $|S|\ge2$.
- $|\mathcal F|\ge2$ **given Def. 3.4 as stated**, since a loop needs at least one edge and I
  wrote loops as strings $(i_0,\dots,i_n,i_0)$ with $n\ge1$. If self-transitions $\rho_{ii}$ are
  admitted, $|\mathcal F|=1$ with $\rho_{ii}=\text{swap}$ works and is smaller; I state the bound
  under the convention actually used and note it is convention-dependent.

Dropping the requirement $S'\ne\varnothing$, the minimum is $|X|=2,|\mathcal T|=1,|Q|=2$ with
$S=\{t_1\}$, $S'=\varnothing$ — Corollary 2.1's degenerate case, which needs no example at all
since it holds identically.

**What Example 5.1 does and does not refute.** It refutes $\delta=0\Rightarrow\operatorname{Advance}$
and, more sharply, $\delta=0\Rightarrow\mathfrak h_\sigma=\operatorname{id}$. It does **not**
refute anything about $\operatorname{Advance}$'s other four conjuncts, which are undefined in the
transmission at the level of precision needed to falsify them, and I make no claim about them.

## 6. §J3: $\delta_\sigma=0\ \not\Leftarrow\ \delta^{\mathrm{base}}_\sigma=0$

The transmission's vector-valued defect
$\delta_\sigma=(\delta^{\mathrm{sem}},\delta^{\mathrm{proof}},\dots,\delta^{\mathrm{prov}})$ with
"$\pi\mathfrak H_\sigma=1\wedge\widetilde{\mathfrak H}_\sigma\ne1\Rightarrow$ hidden curvature"
is the *value-coarsening* instance of Definition 3.3, and therefore an instance of Theorem 1 —
not a separate phenomenon. Precisely:

**Proposition 4.** Let $\pi:Q\to Q^{\mathrm{base}}$ be any map, and let
$e^{\mathrm{base}}:=\pi\circ e$ define the base Chu space on the *same* $X,\mathcal T$. Then
$\iota^{\mathrm{base}}_{S}\preceq\iota_S$ for every $S$, hence
$\delta_\sigma(S)=0\Rightarrow\delta^{\mathrm{base}}_\sigma(S)=0$, and the converse fails.

*Proof of the implication.* $e(x,t)=e(x',t)\Rightarrow\pi e(x,t)=\pi e(x',t)$, so
$\sim_S\subseteq\sim^{\mathrm{base}}_S$; apply Theorem 1 in its instrument form. $\square$

*Proof of failure of the converse — Example 6.1, exhaustive.*
$$X=\{a,b\},\quad\mathcal T=\{t\},\quad Q=\{0,1\}\times\{0,1\}\ \ (\text{coordinates: sem, prov}),\quad \pi=\text{first projection},$$
$$e(a,t)=(0,0),\qquad e(b,t)=(0,1),$$
with $\mathcal F,\rho,\sigma$ as in Example 5.1, so $\mathfrak h_\sigma=\text{swap}$.
Base: $e^{\mathrm{base}}(a,t)=0=e^{\mathrm{base}}(b,t)$, so $a\sim^{\mathrm{base}}_{\mathcal T}b$,
$e^{\mathrm{base}}(\mathfrak h_\sigma a,t)=0=e^{\mathrm{base}}(a,t)$ and symmetrically for $b$;
$\delta^{\mathrm{base}}_\sigma(\mathcal T)=0$. Total: $e(\mathfrak h_\sigma a,t)=e(b,t)=(0,1)\ne(0,0)=e(a,t)$,
so $\operatorname{Det}_\sigma(\mathcal T)=\{a,b\}$ and $\delta_\sigma(\mathcal T)\ne0$. Two
evaluations of $e$ and their two images under $\pi$ exhaust the check. $\square$

This is the transmission's गुह्यवक्रता (hidden curvature) exhibited: the *sem* component is
flat, the *prov* component is not, and a reader who projects sees nothing. Size
$(|X|,|\mathcal T|,|Q|)=(2,1,4)$; $|Q|=4$ is forced only by the requirement that $\pi$ be
non-injective with a two-element fibre, i.e. $|Q|\ge2$ and $|Q^{\mathrm{base}}|\ge1$ with a
collapsed pair — $Q=\{0,1\}$ and $\pi$ constant is smaller and works identically, at the cost of
the "component" reading. I keep the product form because it is the transmission's own picture.

**Corollary 5 (unification).** §J2 and §J3 are one theorem. Discarding tests and coarsening
values are both coarsenings of the instrument $\iota$, and Theorem 1 is stated at that level. The
transmission's two separate boxed non-implications are the two ways of shrinking an instrument.

## 7. What is *not* proved here — scope limits

Explicitly, and per §J4, which already says so:

1. **The ordinal ladder §C** ($\delta^{(n)}\to\chi^{(n+1)}\to\delta^{(n+1)}$,
   $\delta^{(\lambda)}=\operatorname{hocolim}$, $\partial\delta^{(\lambda)}\ne0\Rightarrow\lambda\mapsto\lambda+1$):
   untouched. No convergence, no smallness, no well-definedness of $\Gamma$ on $\mathcal O_\alpha$,
   $\kappa$ unspecified. Nothing here bears on it.
2. **The step functor $\mathfrak F$ and $\mathbb B=\int^\alpha\Diamond_\alpha$** (§E): untouched.
   In particular $\mathfrak F_{\alpha+1}\succeq\mathfrak F_\alpha$ is not proved and is not
   Theorem 1 in disguise — Theorem 1 orders *instruments*, not step functors, and I assert no
   bridge.
3. **$\operatorname{Advance}$'s other conjuncts** (`Verify`, `PreserveProv`, `UsefulEscape`,
   `DeclaredBoundaryPreserved`): undefined at the needed precision; §5 refutes the implication
   from $\delta=0$ only, by making `SearchSep` fail. It does not show the implication would
   survive if `SearchSep` held — Prop. 3 shows only that $\delta=0$ then forces
   $\mathfrak h_\sigma=\operatorname{id}$, which is not `Advance`.
4. **Non-monotone test change** (§F's "or not"): Theorem 1 is silent whenever $S,S'$ are
   $\preceq$-incomparable, which is the generic case for $\Phi_{\mathrm{cut}}$'s adjunctions
   (Fourier, Mellin, Loc, Lift, …). The slogan therefore applies to *shrinking*, not to
   *changing*, and no note should cite it for the latter.
5. **Yang–Baxter defect** (§D): not addressed.
6. **Infinite $\mathcal F$, infinite $X$**: Theorems 1–2 and Props 3–4 use no finiteness; only
   §5–§6's counterexamples are finite, which is the direction finiteness is wanted. The
   cardinal-valued readings $|{\operatorname{Det}}|,|D|$ are monotone as cardinals in general.
7. Per §J6: this note supplies **no licence** to relabel existing results in $\delta$-notation.

**Substrate.** No Python written, modified, or run. No Agda or Lean authored and no typechecking
claimed — there is no toolchain in this container. No PDF decoded; §2 names exactly which
sources were read as HTML and which were not read at all. No floating-point quantity appears in
this note; every number in §5–§6 is a cardinality of a set with at most four elements, listed.

---

*Question and framework: the owner, D0016, 2026-08-14. Proof, strictness condition, and
counterexamples: seed148, 2026-08-14.*
