# $\Phi_{\mathrm{ctr}}$: the centre factor and the Yang–Baxter defect, adjudicated

*Derived from the human owner's transmission
`collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md` §D, the
$\Phi_{\mathrm{ctr}}$ bullet. The formulas $Z(U)=\int_{x\in U}\operatorname{HalfBraid}_U(x)$,
$\gamma_{y\otimes z}=(1_y\otimes\gamma_z)(\gamma_y\otimes 1_z)$,
$R_{12}R_{23}R_{12}=R_{23}R_{12}R_{23}$,
$\operatorname{YB}_\delta(R):=R_{12}R_{23}R_{12}(R_{23}R_{12}R_{23})^{-1}$ and the clause
$\operatorname{YB}_\delta(R)\ne1\Rightarrow\Gamma\langle\operatorname{YB}_\delta(R)\rangle$
are the owner's, quoted verbatim and not rewritten. Everything below is proof, refutation,
or scope-fixing for them.*

Seed 163, 2026-08-15. No computation was run; no Python; no Agda or Lean authored.

---

## 0. Verdict table

| item | verdict |
|---|---|
| 1. $Z(U)$ is the Drinfeld centre | **PARTIAL — split:** the *intended object* is the Drinfeld centre $Z(\mathcal C)$ (CLASSICAL, nLab read); the *displayed end* $\int_{x\in U}$ is **REFUTED as written** — $\operatorname{HalfBraid}_U(-)$ is not a functor of $x$, so no end or coend over $x$ exists (Thm 1, Prop 1.2) |
| 1′. where the end really lives | **PROVED:** $\operatorname{HalfBraid}_U(x)=\int_{y\in U}\operatorname{Iso}_U(x\otimes y,\,y\otimes x)$, an end over $y$ — the *inner* variable (Thm 2) |
| 2. order and variance of $\gamma_{y\otimes z}=(1_y\otimes\gamma_z)(\gamma_y\otimes1_z)$ | **PROVED correct**, verbatim agreement with nLab (§2.1) |
| 2′. "naturality in $y$ is implied by the $\otimes$-axiom" | **REFUTED**, explicit counterexample in $\mathrm{Vect}_k$ (Thm 3). Naturality is *independent* and the transmission omits it |
| 3. $\operatorname{YB}_\delta(R)$ well-formed | **PROVED under the omitted hypothesis** $R\in\operatorname{Aut}(V\otimes V)$ (§3.1); without it the expression is undefined and the honest defect is a parallel pair, not a group element |
| 3′. $\operatorname{YB}_\delta(R)=1\iff$ braid relation | **PROVED** (Thm 4), and it *is* an iff, not merely $\Rightarrow$ — cancellation, which needs the same invertibility hypothesis |
| 3″. $\operatorname{YB}_\delta$ is a well-defined *invariant* | **REFUTED as an element, PROVED as a class:** gauge change $R\mapsto(g\otimes g)R(g\otimes g)^{-1}$ conjugates it, and the left/right variants differ (Thm 5). Only its conjugacy class, hence only its vanishing, is invariant |
| 3‴. completeness of the obstruction | **PROVED / CLASSICAL:** $\operatorname{YB}_\delta(R)=1$ on three strands already gives $B_n$-representations for all $n$ (Thm 6, nLab read) |
| 4. $\Gamma\langle\operatorname{YB}_\delta(R)\rangle$ as a repair | **PARTIAL — split:** the notation is **ambiguous between two of the four modes** (§4.1). Under D0016 §C's own typing $\Gamma_\alpha:\mathcal O_\alpha\to\operatorname{Cell}$ it is $\Gamma_\Uparrow$, the one mode `FOUR_REPAIR_MODES.md` §1.2 declines to certify. $\Gamma_{\widehat{\phantom X}}$ (completion) is **REFUTED here** (Thm 7); $\Gamma_\circlearrowleft$ is available and cheap (Thm 5); $\Gamma_\varnothing$ is available and is what the literature actually does |

Scope limit stated up front: everything below is at the level of a monoidal category and a
single invertible $R$ on $V^{\otimes2}$. Nothing here touches $\Phi_{\mathrm{tr}}$,
$\Phi_{\mathrm{refl}}$, $\Phi_{\mathrm{cut}}$, or the composite $\Phi_\alpha$, and nothing
here says whether $\Phi_{\mathrm{ctr}}$ belongs in that composite at all.

**Prior state, verified by reading and not by trusting a summary.**
`notes/OWNER_TRANSMISSIONS_LEDGER.md` §1.10 adjudicates $\Phi_{\mathrm{tr}}$ and
$\operatorname{YB}_\delta$ only, and only as "CLASSICAL / definitional … carries no content
beyond notation", explicitly recording that the *use* of
$\Gamma\langle\operatorname{YB}_\delta(R)\rangle$ "has **not** been checked". A grep of
`notes/` and `collab/` for `HalfBraid|half-braiding|Drinfeld cent` returns the transmission
file and nothing else: **the centre half of $\Phi_{\mathrm{ctr}}$ was untouched.** §1.10's
"carries no content" is corrected in one respect below (Thm 5): the definitional reading is
right about $\Leftrightarrow$, and wrong to stop there, because the object so defined is not
well-defined as an element.

---

## 1. What $Z(U)$ is, and what the displayed end is not

### 1.1 The standard object (CLASSICAL — sources read, HTML only)

Read, and quoted verbatim from `ncatlab.org/nlab/show/Drinfeld+center` (also served at
`center+of+a+monoidal+category`):

> "$Z(\mathcal C,\otimes)\;≔\;\mathrm{End}_{\mathbf B_\otimes\mathcal C}(\mathrm{id}_{\mathbf B_\otimes\mathcal C})$"

and in components:

> Objects: pairs $(X,\Phi)$ consisting of an object $X\in\mathcal C$ and a natural
> isomorphism (half-braiding) "$\Phi_{(-)}:X\otimes(-)\to(-)\otimes X$";
> "$\Phi_{Y\otimes Z}=(\mathrm{id}_Y\otimes\Phi_Z)\circ(\Phi_Y\otimes\mathrm{id}_Z)$";
> morphisms $f$ with "$(\mathrm{id}\otimes f)\circ\Phi_Z=\Psi_Z\circ(f\otimes\mathrm{id})$";
> braiding "$b_{(X,\Phi),(Y,\Psi)}=\Psi_X$".

Also read: `en.wikipedia.org/wiki/Braided_monoidal_category`, which supplies the naturality
requirement on a braiding ("a choice of isomorphism $\gamma_{A,B}:A\otimes B\to B\otimes A$
for each pair … which form a natural family") and the attribution "Braided monoidal
categories were introduced by André Joyal and Ross Street in a 1986 preprint. A modified
version of this paper was published in 1993." **Ground caveat (standing check (d)):** that
Wikipedia page states the hexagons only as diagrams; the fetch returned no verbatim symbolic
hexagon identities, so I do **not** quote them and nothing below rests on them. Majid's
independent construction of the centre I did **not** read in any source and cite only as
located lineage. No PDF was decoded and I claim none.

So the transmission's *intended* object is standard and correctly named: the data "an object
with a half-braiding against every other object, compatible with $\otimes$" is the object
part of $Z(\mathcal C)$, and the displayed $\gamma_{y\otimes z}$ equation is verbatim the
nLab compatibility axiom. That much is **CLASSICAL**.

### 1.2 The end binds the wrong variable — and cannot be repaired by re-reading $\int$

Write $\operatorname{HalfBraid}_U(x)$ for the set of half-braidings on a fixed $x$, as the
transmission does: $\{\gamma_y\}_{y\in U}$.

**Theorem 1 (the displayed end does not exist).** *An end $\int_{x\in U}F(x)$ presupposes a
functor $F:U^{\mathrm{op}}\times U\to\mathcal V$ (or at least a functor on one variable, for
a limit). The assignment $x\mapsto\operatorname{HalfBraid}_U(x)$ carries no such structure:
a morphism $f:x\to x'$ in $U$ induces a map of half-braiding sets in neither direction.*

**Proof.** Suppose $\gamma$ is a half-braiding on $x$ and $f:x\to x'$. A candidate transport
would have to produce $\gamma'_y:x'\otimes y\to y\otimes x'$ from
$\gamma_y:x\otimes y\to y\otimes x$ and $f$. The only composites available are
$(1_y\otimes f)\gamma_y:x\otimes y\to y\otimes x'$ and $\gamma_y(f\otimes 1_y)^{-1}$, neither
of which has the required source or target unless $f$ is invertible; and if $f$ is invertible
the transport $\gamma'_y:=(1_y\otimes f)\gamma_y(f^{-1}\otimes1_y)$ is functorial only on the
**core** (the groupoid of isomorphisms) of $U$. Hence $\operatorname{HalfBraid}_U$ is at best
a functor on $\mathrm{core}(U)$, and the end over all of $U$ is not defined. $\square$

**Proposition 1.2 (nor is it a Grothendieck construction).** *The charitable reading
"$\int_{x\in U}$ = category of elements of $x\mapsto\operatorname{HalfBraid}_U(x)$" fails for
the same reason: the Grothendieck construction requires a (pseudo)functor $U\to\mathbf{Cat}$,
which Theorem 1 denies. What is true is the weaker, standard statement: the **objects** of
$Z(U)$ are the disjoint union $\coprod_{x\in U}\operatorname{HalfBraid}_U(x)$, and the
morphisms are **not** read off from that union — they are imposed by the separate naturality
condition $(1\otimes f)\Phi_Z=\Psi_Z(f\otimes1)$ quoted in §1.1.* $\square$

**Reading.** $Z(U)$ is a category assembled from fibres, not a limit over $x$. The integral
sign is doing decorative work in the $x$ slot. Note also that the abstract nLab definition
$\mathrm{End}_{\mathbf B_\otimes\mathcal C}(\mathrm{id})$ *is* an end-shaped object — but the
delooping $\mathbf B_\otimes\mathcal C$ has a single object, so that end has an empty index in
the sense the transmission wants; the objects of $\mathcal C$ appear there as $1$-cells, i.e.
as the $y$ of the next theorem, not as the bound variable $x$.

### 1.3 Where an honest end does live

**Theorem 2 (the correct end, and a free repair of §2′).** *For fixed $x$,*
$$\operatorname{HalfBraid}_U(x)\;=\;\int_{y\in U}\operatorname{Iso}_U\bigl(x\otimes y,\;y\otimes x\bigr)$$
*where the integrand is the functor $U^{\mathrm{op}}\times U\to\mathbf{Set}$,
$(y,y')\mapsto\operatorname{Iso}_U(x\otimes y,\,y'\otimes x)$, intersected with the
$\otimes$-compatibility. The wedge condition defining that end is **exactly** naturality of
$\gamma$ in $y$.*

**Proof.** An element of the end is a family $(\gamma_y)_{y}$ with
$(1_{y}\otimes\ldots)$ — concretely, dinaturality says that for every $f:y\to y'$ the square
$(f\otimes 1_x)\circ\gamma_y=\gamma_{y'}\circ(1_x\otimes f)$ commutes, which is the naturality
square of $\Phi_{(-)}:x\otimes(-)\Rightarrow(-)\otimes x$. Ends of $\mathbf{Set}$-valued
bifunctors are computed as exactly such families. $\square$

**This is the yield of item 1 and I state it flatly.** The transmission binds $\int$ over
$x$, where no end exists; the end exists over $y$, where the transmission wrote a set-former
$\{\gamma_y\}_{y\in U}$ instead. Moving the integral one variable inward is not cosmetic: it
*supplies for free* the naturality condition that §2 below shows is missing and not implied.
The correct statement of the owner's line is
$$Z(U)\;=\;\coprod_{x\in U}\ \int_{y\in U}\operatorname{Iso}_U(x\otimes y,\;y\otimes x)\quad\text{(objects), morphisms as in §1.1.}$$

---

## 2. The half-braiding axiom: order, variance, naturality

### 2.1 Order and variance are correct (PROVED)

With $\gamma_y:x\otimes y\to y\otimes x$:
$$x\otimes y\otimes z\ \xrightarrow{\ \gamma_y\otimes1_z\ }\ y\otimes x\otimes z\ \xrightarrow{\ 1_y\otimes\gamma_z\ }\ y\otimes z\otimes x,$$
so $(1_y\otimes\gamma_z)(\gamma_y\otimes1_z)$ is a map $x\otimes(y\otimes z)\to(y\otimes z)\otimes x$,
which is the source and target of $\gamma_{y\otimes z}$. The composite is written
right-to-left, so $\gamma_y\otimes1_z$ acts first — the only order for which the types match.
This agrees verbatim with nLab's
$\Phi_{Y\otimes Z}=(\mathrm{id}_Y\otimes\Phi_Z)\circ(\Phi_Y\otimes\mathrm{id}_Z)$.
**The transmission is right, including the order, and no swap is needed.** (Associators are
suppressed on both sides identically; in a non-strict $U$ insert them, which changes nothing.)

### 2.2 Naturality is omitted, and is not implied (REFUTED)

The transmission writes $\operatorname{HalfBraid}_U(x)=\{\gamma_y:x\otimes y\cong y\otimes x\}_{y\in U}$
— a family of isomorphisms, with *no naturality clause*. nLab says "natural isomorphism".
The question is whether the $\otimes$-axiom recovers it.

**Theorem 3 (it does not).** *There is a strict monoidal category $U$, an object $x$, and a
family $(\gamma_y)_{y\in U}$ of isomorphisms $x\otimes y\to y\otimes x$ satisfying
$\gamma_{y\otimes z}=(1_y\otimes\gamma_z)(\gamma_y\otimes1_z)$ which is **not** natural in
$y$. Hence the displayed axiom is strictly weaker than "half-braiding", and
$\operatorname{HalfBraid}_U(x)$ as literally defined in D0016 §D is not the fibre of the
Drinfeld centre.*

**Proof.** Let $k$ be a field, $V=k^2$, and let $U\subset\mathrm{Vect}_k$ be the full
monoidal subcategory on the objects $V^{\otimes n}$, $n\ge0$ (so $V^{\otimes0}=k$ is the
unit, and all $k$-linear maps between these objects are morphisms). Take $x=k$, the unit, so
that $x\otimes y=y=y\otimes x$ on the nose and $\gamma_y\in\mathrm{Aut}(y)$.

Fix $A\in\mathrm{GL}(V)$ and set $\gamma_{V^{\otimes n}}:=A^{\otimes n}$ (so
$\gamma_k=\mathrm{id}$). Since $x$ is the unit, both $1_y\otimes\gamma_z$ and
$\gamma_y\otimes1_z$ are the evident maps and the composite is $\gamma_y\otimes\gamma_z$;
and $\gamma_{y\otimes z}=A^{\otimes(m+n)}=A^{\otimes m}\otimes A^{\otimes n}=\gamma_y\otimes\gamma_z$.
So the $\otimes$-axiom holds for **every** invertible $A$.

Naturality in $y$ demands $\gamma_{y'}\circ f=f\circ\gamma_y$ for every morphism
$f:y\to y'$ of $U$. Taking $y=y'=V$ and $f$ ranging over all of $\mathrm{End}(V)=M_2(k)$,
this forces $A$ to be central in $M_2(k)$, i.e. $A$ scalar. Choose
$A=\begin{pmatrix}1&1\\0&1\end{pmatrix}$: the family satisfies the transmission's axiom and
is not natural. $\square$

**Consequence.** Item 2's answer is: **order and variance right, one axiom missing.** The
missing axiom is not decorative — without it $b_{(X,\Phi),(Y,\Psi)}=\Psi_X$ is not a braiding
(a braiding is by definition a natural family, per the Wikipedia line quoted in §1.1), so a
referee who "checks hexagons before believing a braiding" cannot even begin: the hexagons are
statements about a natural transformation and there is not yet one. And by Theorem 2 the
repair is the same edit as §1.3's: bind the end over $y$ and naturality arrives as the wedge
condition. **One correction fixes both defects**, which is the reason to prefer it to simply
appending the word "natural".

---

## 3. The Yang–Baxter defect

### 3.1 The omitted hypothesis

$\operatorname{YB}_\delta(R):=R_{12}R_{23}R_{12}(R_{23}R_{12}R_{23})^{-1}$ is written with an
inverse. It is therefore **undefined** unless $R_{23}R_{12}R_{23}$ is invertible. Sufficient
and, in the ambient the transmission is evidently using, necessary in practice:

> **Hypothesis (I).** $V$ is an object of a monoidal category, $R\in\operatorname{Aut}(V\otimes V)$
> is invertible, and $R_{12}=R\otimes1_V$, $R_{23}=1_V\otimes R$ in $\operatorname{Aut}(V^{\otimes3})$.

Under (I), $\operatorname{YB}_\delta(R)\in G:=\operatorname{Aut}(V^{\otimes3})$, a group, so
"$\ne1$" is meaningful. **The transmission states no hypothesis at all**, and this matters
beyond pedantry: solutions of the Yang–Baxter equation are routinely non-invertible
(idempotent and set-theoretic degenerate solutions), and for those the entire clause is
vacuous. For non-invertible $R$ the honest obstruction is not a group element but the
**parallel pair** $(R_{12}R_{23}R_{12},\,R_{23}R_{12}R_{23})$ of morphisms $V^{\otimes3}\to V^{\otimes3}$,
whose "defect" lives in a coequalizer, not a group. I record that as the correct
generalisation and prove nothing about it.

### 3.2 It is a genuine obstruction, and the $\Leftrightarrow$ is real

**Theorem 4.** *Under (I): $\operatorname{YB}_\delta(R)=1$ **iff**
$R_{12}R_{23}R_{12}=R_{23}R_{12}R_{23}$.*

**Proof.** In the group $G$, $ab^{-1}=1\iff a=b$; right multiplication by the invertible
element $b=R_{23}R_{12}R_{23}$ is a bijection. $\square$

This is the ledger §1.10 reading, and it is correct — but note precisely what carries it:
**cancellation in a group**, which is available only under (I). Ledger §1.10 calls this "true
by definition"; it is true by definition *plus* an unstated hypothesis, and standing check (e)
applies in miniature — the announced $\Rightarrow$ of the transmission is here legitimately an
$\Leftrightarrow$, but only because $G$ is a group.

### 3.3 What is *not* well defined (REFUTED as an element)

**Theorem 5.** *Under (I), $\operatorname{YB}_\delta$ is well defined only up to conjugacy and
up to a left/right choice:*
1. *(gauge) For $g\in\operatorname{Aut}(V)$ put $R^g:=(g\otimes g)R(g\otimes g)^{-1}$. Then
   $\operatorname{YB}_\delta(R^g)=g^{\otimes3}\operatorname{YB}_\delta(R)\,g^{-\otimes3}$.*
2. *(handedness) The mirror defect
   $\operatorname{YB}_\delta'(R):=(R_{23}R_{12}R_{23})^{-1}R_{12}R_{23}R_{12}$ satisfies
   $\operatorname{YB}_\delta'=b^{-1}\operatorname{YB}_\delta\,b$ with $b=R_{23}R_{12}R_{23}$,
   and in general $\operatorname{YB}_\delta'\ne\operatorname{YB}_\delta$.*
*Consequently the assignment $R\mapsto\operatorname{YB}_\delta(R)\in G$ is not gauge-invariant;
only its class in the set of conjugacy classes of $G$ is, and hence only the predicate
$\operatorname{YB}_\delta=1$ is an invariant of the gauge orbit.*

**Proof.** (1) $(R^g)_{12}=g^{\otimes3}R_{12}g^{-\otimes3}$ and likewise for $R_{23}$; conjugation
is a group automorphism, so it passes through the word and the inverse. (2) $ab^{-1}$ and
$b^{-1}a$ are conjugate by $b$, and are equal iff $ab^{-1}$ commutes with $b$; take any
$R$ for which they do not. Non-equality is not vacuous: if $\operatorname{YB}_\delta$ were
always central the two would coincide, and centrality of $ab^{-1}$ in $\operatorname{Aut}(V^{\otimes3})$
is a strong condition no hypothesis supplies. $\square$

**This is the content ledger §1.10 missed** when it wrote that the definition "carries no
content beyond notation". The notation carries a *false suggestion*: that
$\operatorname{YB}_\delta(R)$ is a number-like invariant of $R$ one can compare, add to a
ledger, or feed to $\Gamma$. It is a cocycle-like object, not a class — precisely the
$\Gamma_\circlearrowleft$ situation of `notes/FOUR_REPAIR_MODES.md` Thm 6(i), where the honest
move is to pass to the class and the dishonest move is to keep the representative.

### 3.4 The obstruction is complete (CLASSICAL)

**Theorem 6.** *Under (I), if $\operatorname{YB}_\delta(R)=1$ then $b_i\mapsto1^{\otimes(i-1)}\otimes R\otimes1^{\otimes(n-i-1)}$
defines a representation of the braid group $B_n$ for **every** $n$; no further obstruction
appears at $n\ge4$.*

**Ground.** Read: `ncatlab.org/nlab/show/Yang-Baxter+equation`, which gives the braid form
"$(R\otimes\mathrm{id})\circ(\mathrm{id}\otimes R)\circ(R\otimes\mathrm{id})=(\mathrm{id}\otimes R)\circ(R\otimes\mathrm{id})\circ(\mathrm{id}\otimes R)$"
and states "Any solution $R$ to the Yang–Baxter equation generates representations of all
braid groups $\mathrm{Br}_n$" via "$b_i\mapsto\mathrm{id}^{\otimes(i-1)}\otimes R\otimes\mathrm{id}^{\otimes(n-i-1)}$".
**Caveat on ground (standing check (d)):** that page explicitly does **not** impose
invertibility — the fetch returned "The document does not impose invertibility as a
requirement". For a *group* representation invertibility is required, so I state (I) and do
not attribute the hypothesis to nLab. The remaining Artin relation, $b_ib_j=b_jb_i$ for
$|i-j|\ge2$, holds automatically since $R_{i,i+1}$ and $R_{j,j+1}$ act on disjoint tensor
factors; that one line is mine and needs no source.

**Why this belongs in the adjudication.** It says the transmission's single defect is not a
first term of a tower: three strands is the whole obstruction. That is a point in the
transmission's favour and I record it as such.

---

## 4. Does $\Gamma\langle\operatorname{YB}_\delta(R)\rangle$ make sense as a repair?

`notes/FOUR_REPAIR_MODES.md` was read in full, not summarised from memory. Its content used
here: the four modes $\Gamma_\circlearrowleft$ (pass to the class; always available; lossless;
destroys the gauge), $\Gamma_\varnothing$ (kill the class; needs a displayed datum — a
quotient, a coefficient enlargement, or an added hypothesis; lossy; **not natural**, Thm 6(ii)),
$\Gamma_{\widehat{\phantom X}}$ (completion; available **iff** the class dies in a larger
ambient, Thm 1 and Thm 2), $\Gamma_\Uparrow$ (replace the failed equation by a 2-cell; lossless;
cost is a coherence tower; §1.2 states plainly "**I prove nothing about it here**" and flags it
as the one mode "whose availability cannot be checked by a finite computation in the general
case"). Its §4.3 finding is that the four modes classify *structural* (cocycle-shaped) defects
and say nothing about quantitative ones.

### 4.1 The notation names two different modes

$\Gamma\langle-\rangle$ is used in D0016 in two typings that do not agree.

* **§C typing.** $\Gamma_\alpha:\mathcal O_\alpha\to\operatorname{Cell}(\mathcal C_{\alpha+1})$,
  with $X^+_\alpha:=X_\alpha\amalg^h_{\partial\mathcal O_\alpha}\Gamma_\alpha\langle\mathcal O_\alpha\rangle$
  and $\partial\Gamma_\alpha\langle\delta^{(n)}\rangle=\delta^{(n+1)}$. This is
  **$\Gamma_\Uparrow$**: adjoin a cell filling the failed equation.
* **Bracket typing.** $\langle-\rangle$ is standard notation for "the (normal) subgroup
  generated by", and $\operatorname{YB}_\delta(R)$ lives in a group. Read that way,
  $\Gamma\langle\operatorname{YB}_\delta(R)\rangle$ is the quotient
  $G\twoheadrightarrow G/\langle\!\langle\operatorname{YB}_\delta(R)\rangle\!\rangle$, in which
  the braid relation holds by fiat. That is **$\Gamma_\varnothing$ in its quotient form**,
  `FOUR_REPAIR_MODES` Thm 6(ii) verbatim ("a quotient $H^1\to H^1/\langle[D]\rangle$").

These are different modes with different costs: $\Gamma_\Uparrow$ is lossless and unbounded in
obligation; $\Gamma_\varnothing$ is lossy and bounded. **The transmission's own notation does
not determine which repair is proposed**, and a reader will supply whichever they prefer. That
is the reportable defect of item 4, and it is a defect of the clause, not of the reader.

### 4.2 Which modes actually apply here

* **$\Gamma_\circlearrowleft$ — available, cheap, and mandatory before anything else.** By
  Theorem 5 the raw defect is gauge-dependent; passing to its conjugacy class is exactly
  "relocate the defect one level up, from a cocycle to a class", and it is forced rather than
  chosen. Any use of $\operatorname{YB}_\delta(R)$ as a *thing* must be a use of its class.
* **$\Gamma_{\widehat{\phantom X}}$ — REFUTED.** Theorem 7 below.
* **$\Gamma_\varnothing$ — available, and is what the literature does.** The standard move is
  the added hypothesis: restrict attention to those $R$ satisfying YBE (i.e. to $R$-matrices).
  `FOUR_REPAIR_MODES` §1.1 prices this correctly: lossy, and honest only if the datum is
  displayed. Here it is displayed, because "let $R$ be an $R$-matrix" is a visible hypothesis.
  The quotient variant of §4.1 is *also* $\Gamma_\varnothing$ but is worse: quotienting
  $\operatorname{Aut}(V^{\otimes3})$ by the normal closure destroys the representation one was
  trying to build (the quotient no longer acts on $V^{\otimes3}$), so the datum bought is not
  the datum wanted. **Scope limit:** I have not determined whether some smaller quotient works.
* **$\Gamma_\Uparrow$ — the §C reading, and unpriced.** Its first obligation is nameable:
  filling the YB equation with an invertible 2-cell in a monoidal $2$-category, and the
  coherence that filler must satisfy is the Zamolodchikov tetrahedron equation. **Ground:**
  I read `ncatlab.org/nlab/show/braided+monoidal+2-category`, which does **not** state the
  axioms in the returned content; it cites "Mikhail Kapranov, Vladimir Voevodsky,
  *2-Categories and Zamolodchikov tetrahedra equations*" and their "Braided monoidal
  2-categories and Manin–Schechtman higher braid groups". **I therefore assert only that this
  is the located lineage; I did not read the axioms and do not claim the tetrahedron equation
  as verified here.** What I do claim, and it needs no source: this is the first rung of
  `FOUR_REPAIR_MODES` §1.2's tower, so the mode is available in principle and uncertified in
  practice, exactly as that note says.

**Theorem 7 (completion is unavailable for this defect).** *Under (I), let
$\iota:G\hookrightarrow G'$ be any injective homomorphism of groups extending the ambient
(the group-theoretic analogue of `FOUR_REPAIR_MODES` Thm 2's coefficient enlargement
$V_0\hookrightarrow V$). If $\operatorname{YB}_\delta(R)\ne1$ then
$\iota(\operatorname{YB}_\delta(R))\ne1$. Hence no enlargement of the ambient kills the
defect, and $\Gamma_{\widehat{\phantom X}}$ does not apply.*

**Proof.** Injectivity. $\square$

**Why this is not trivial in context.** `FOUR_REPAIR_MODES` Thm 2 shows that in the cocycle
setting the completion mode works *because* $\iota_*:H^1(\Gamma,V_0)\to H^1(\Gamma,V)$ need
not be injective — enlarging coefficients can kill a class without killing the cocycle. Here
the defect is not a class in a cohomology group but an element of a group, and enlargement is
injective on elements. **So the structural difference between the two situations is exactly
that $\operatorname{YB}_\delta$ has no $H^1$ under it.** The four-mode classification does
apply — the defect is structural, not quantitative, so §4.3 of that note does not exclude it —
but it applies with the *best* mode removed. That is the sharpest thing this section says:
$\Phi_{\mathrm{ctr}}$'s defect is one for which the good repair is unavailable, and the
transmission's clause offers, ambiguously, one of the two remaining ones.

---

## 5. What this leaves open

1. **`PROVE`** — Is there a cohomological reformulation under which $\operatorname{YB}_\delta$
   *does* become a class in a group where enlargement is non-injective (so that Theorem 7 is
   evaded and $\Gamma_{\widehat{\phantom X}}$ returns)? Deformation theory of $R$-matrices
   (Gerstenhaber-style) is the obvious place; I have not looked.
2. **`SEARCH`** — Kapranov–Voevodsky's axioms in a source that renders as HTML, to replace the
   lineage citation in §4.2 by a read one, and thereby price $\Gamma_\Uparrow$ for this defect.
3. **`PROVE`** — The non-invertible case of §3.1: what is the right defect for a parallel pair,
   and does any of the four modes apply to it?
4. **`PROVE`** — Does $\Phi_{\mathrm{ctr}}$, once corrected as in §1.3, compose with
   $\Phi_{\mathrm{refl}}$ and $\Phi_{\mathrm{cut}}$ in the order D0016 §D asserts? Nothing here
   bears on the composite.

## 6. Honesty ledger

- Nothing was computed. No Python, no measurement, no fitted quantity. No Agda or Lean was
  authored and nothing is claimed typechecked.
- Sources read, HTML only: nLab `Drinfeld+center` / `center+of+a+monoidal+category`, nLab
  `Yang-Baxter+equation`, nLab `braided+monoidal+2-category`, Wikipedia
  `Braided_monoidal_category`. nLab `half-braiding` returned 404 and was not read. **No PDF was
  decoded and none is claimed.** Majid, Joyal–Street's paper itself, and Kapranov–Voevodsky
  were **not** read; they are named as lineage only.
- The Wikipedia hexagon identities were *not* obtained verbatim (diagrams only); no argument
  above uses them. §2.2's counterexample uses only naturality-as-definition, quoted.
- Theorem 3's counterexample takes $x$ to be the unit object, where the axiom degenerates most.
  It refutes the general implication "$\otimes$-axiom $\Rightarrow$ naturality", which is all it
  is asked to do. It does not show the implication fails for a *braided* $U$ or for $x$ far
  from the unit, and I do not claim it does.
- Theorem 5(2)'s non-equality is argued by "no hypothesis forces centrality"; I did not exhibit
  a specific $R$ with $\operatorname{YB}_\delta'\ne\operatorname{YB}_\delta$. **That half of
  Theorem 5 is therefore weaker than the rest: PROVED for (1), argued-not-exhibited for (2).**
  The verdict table's "left/right variants differ" should be read at that strength.
- Ledger §1.10 is corrected, not overturned: its $\Leftrightarrow$ reading is right (Thm 4);
  its "no content beyond notation" is wrong in one respect (Thm 5), and it was right that the
  *use* of $\Gamma\langle-\rangle$ was unchecked — §4 checks it and finds the notation ambiguous.
- The concluding generalisation of §4.2 — "this is a structural defect for which the completion
  mode is provably unavailable, because there is no $H^1$ beneath it" — is offered at the
  generality of one defect plus Theorem 7's one-line proof, and is subject to audit.
