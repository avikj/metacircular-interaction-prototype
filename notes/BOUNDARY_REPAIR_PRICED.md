# The ∨-diagonal repair of ∂, worked out and priced

*seed175, 2026-08-15. Develops the repair proposed but not developed in
`notes/BOUNDARY_OPERATOR_TYPING.md` §3.1/§5.1 (seed170). Owner artifacts
(`collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md` §§A, B, C, D, E, I, J)
are derived from and quoted, never rewritten. No Python; no numerical computation; no Agda or
Lean authored; no PDF decoded.*

**Headline, split because it is split.** The repair is **cheaper than advertised in one place**
(∨ need only be a functor, not an equivalence, for well-formedness) and **more expensive than
advertised in three** (𝓣 must be small; ∨ must be added to the signature, which §A does not
list; and ∂ becomes *contravariant*, which invalidates the parity count grounding
`ORDINAL_LADDER_SMALLNESS.md` Theorem 3). ∂ and Φ_tr **do unify** — as two arities of one
shadow — but only over a value category strictly stronger than the repair itself needs, so the
unification is a *further purchase*, not a free consequence. The transport does **not** survive
in the form δ needs; it survives only as the relation quotiented by, which is a better ground
for the same negative. Three of the source pass's four honesty claims stand; the fourth
("does not advance the ladder") is **refuted in its ground and survives in its conclusion**.

---

## 0. Ground check, before building

Standing check (d): this mandate rests on a repair *proposed* and not developed, so its ground
was re-derived rather than assumed.

**0.1 The arity argument, re-derived independently.** For $\int^{c\in\mathcal C}F(c,c)$ to
denote, one needs $F:\mathcal C^{op}\times\mathcal C\to\mathcal D$ and the coequalizer

$$\coprod_{u:c\to c'}F(c',c)\ \underset{F(1,u)}{\overset{F(u,1)}{\rightrightarrows}}\ \coprod_c F(c,c)\longrightarrow\int^c F(c,c).$$

Both parallel maps are named by acting on *one* of two occurrences of the bound variable while
fixing the other. With $\mathcal C=\mathcal F_\alpha\times\mathcal T_\alpha$ and integrand
$e_\alpha(f,t)$, the datum supplied is a functor of two arguments where four are required, and
neither map of the pair can be written: acting on $f$ has no fixed $f$ to act relative to.
**Confirmed, and confirmed to be arity**: adding colimits to $Q_\alpha$ adds targets for a
coequalizer that has no source. Enrichment is necessary and not sufficient, exactly as
`BOUNDARY_OPERATOR_TYPING.md` §2 says.

**0.2 The ∨-diagonal construction, re-derived.** Given a functor $\vee:\mathcal T^{op}\to\mathcal F$
and $e:\mathcal F\times\mathcal T\to Q$ functorial in each variable, put

$$E:=e\circ(\vee\times 1_{\mathcal T}):\ \mathcal T^{op}\times\mathcal T\longrightarrow Q,
\qquad E(t',t)=e(\vee t',t).$$

$E$ is a composite of functors, hence a functor, hence the coend $\int^{t}E(t,t)$ is
well-formed. Its coequalizer is explicitly, for $u:t\to t'$ in $\mathcal T$ (so
$\vee u:\vee t'\to\vee t$ in $\mathcal F$):

$$\coprod_{u:t\to t'} e(\vee t',t)\ \underset{e(1,\,u)}{\overset{e(\vee u,\,1)}{\rightrightarrows}}\ \coprod_t e(\vee t,t)\longrightarrow\partial\Diamond_\alpha. \tag{$\ast$}$$

Both maps exist. **Confirmed.** Note what the derivation used: $\vee$ appears only as a
functor. **It did not use that $\vee$ is an equivalence.** That is §1.2 below and it is a
correction to the source pass in the cheapening direction.

**0.3 One imprecision in the source pass, recorded.** `BOUNDARY_OPERATOR_TYPING.md` §3.1 says
the trace "is the composite of $e_\alpha$ with the identity profunctor along its diagonal".
Composition of profunctors, $P\odot R=\int^{t}P(-,t)\otimes R(t,-)$, produces a *profunctor*;
by co-Yoneda $F\odot\mathrm{Id}\cong F$, which is not a trace. The trace is a further coend,
along the diagonal, of that composite — an object of $Q$, not a profunctor. The two are one
arity apart. The slip is harmless to §3.1's conclusion (the boxed display is right) and is
recorded because it is the same arity conflation the note itself diagnoses.

**0.4 A dating artifact, so nobody re-litigates it.** `TRACE_FACTOR_ADJUDICATED.md` §5.1
reports `notes/UNTOUCHED_REGIONS_ADJUDICATED.md` as not existing (checked 2026-08-15); it
exists now and `BOUNDARY_OPERATOR_TYPING.md` cites it throughout. Both are same-day notes; the
first statement was true when made. Nothing below turns on it.

---

## 1. The repaired ∂, stated precisely, with minimum hypotheses

$$\boxed{\ \partial\Diamond_\alpha\ :=\ \int^{t\in\mathcal T_\alpha}e_\alpha(\vee t,\,t)\ }$$

### 1.1 The minimum hypotheses, numbered

**(M1) $\mathcal T_\alpha$ is small.** The coproducts in $(\ast)$ are indexed by
$\operatorname{Ob}\mathcal T_\alpha$ and by $\operatorname{Mor}\mathcal T_\alpha$. Neither
§A nor §F says $\mathcal T_\alpha$ is small, and §F's whole point is that
$\mathcal T$ *grows*; a stage whose test category is a proper class has no $\partial$. **Not
named by the source pass.** (Weakening: $Q_\alpha$ cocomplete for $\lambda$-small colimits and
$\mathcal T_\alpha$ $\lambda$-small will do.)

**(M2) $e_\alpha$ is a functor $\mathcal F_\alpha\times\mathcal T_\alpha\to Q_\alpha$**,
i.e. functorial in each variable separately with the interchange. This is the source pass's P4
"profunctor typing", but stated with the variance it actually needs: **covariant in both**,
the contravariance being supplied by $\vee$, not by typing $e$ on $\mathcal F^{op}$. Typing
$e:\mathcal F^{op}\times\mathcal T\to Q$ and then using $\vee:\mathcal T^{op}\to\mathcal F$
would give $E$ the wrong variance in $t'$ and $(\ast)$ would again fail. The two conventions
are not interchangeable and the choice must be declared.

**(M3) $\vee_\alpha:\mathcal T_\alpha^{op}\to\mathcal F_\alpha$ is a functor.** Nothing more
is needed for the coend to exist (§0.2).

**(M4) $Q_\alpha$ admits the coequalizer in $(\ast)$ and the two coproducts.** Cocompleteness
is sufficient and is not necessary. §A assigns $Q_\alpha$ no type at all.

**(M5) $\vee_\alpha$ must be part of the datum $\Diamond_\alpha$.** §A's septuple is
$(X,\mathcal F,\mathcal T,e,\rho,\Pi,\mathcal O)$; $\vee$ is introduced only in §E, as an
operator on stages, not as a component of one. Under the repair, $\partial\Diamond_\alpha$ is
a function of $(\mathcal F,\mathcal T,e,\vee)$ and different $\vee$'s give different values,
so **the signature must be extended to an octuple** or $\vee$ must be shown canonical. This is
a change to §A, not only to §B, and it is the largest structural cost.

**(M6) Functoriality in $\Diamond$ requires a compatibility square.** See §1.3.

### 1.2 What ∨ must be: functor for existence, equivalence for canonicity — and an adjunction is not enough

**Proposition 1.** Under (M1)–(M4) with $\vee$ merely a functor, $\partial\Diamond_\alpha$
exists. If moreover $\vee:\mathcal T^{op}\to\mathcal F$ is an **equivalence** with
quasi-inverse $w$, then the two candidate readings agree:
$\int^{t}e(\vee t,t)\cong\int^{f}e(f,w f)$, and the value is independent of the choice of
quasi-inverse up to canonical isomorphism.

*Proof.* Existence is §0.2. For the second clause: coends are invariant under precomposition
with an equivalence — $\vee^{op}\times\vee$ carries the diagram of $(\ast)$ for one to the
diagram for the other, essentially surjectively and fully faithfully on both index sets, so
the two coequalizer diagrams are equivalent and their colimits agree. Independence of the
quasi-inverse follows since two quasi-inverses are naturally isomorphic and a natural
isomorphism of index functors induces an isomorphism of coends. $\square$

**Proposition 2 (an adjunction is strictly weaker, and the gap is exhibited, not asserted).**
If $\vee:\mathcal T^{op}\rightleftarrows\mathcal F:w$ is an adjunction that is not an
equivalence, the two readings need not agree. *Ground.* Take $\mathcal T$ and $\mathcal F$
discrete-plus-nothing is unavailable (an adjunction between discrete categories is a pair of
inverse bijections), so take $Q=\mathbf{Set}$, $\mathcal F=\mathbf 1$ (one object $\ast$, one
arrow), $\mathcal T$ any small category with $\ge 2$ objects and no non-identity arrows, and
$\vee:\mathcal T^{op}\to\mathbf 1$ the unique functor, which has a right adjoint iff
$\mathcal T^{op}$ has a terminal object — take $\mathcal T=\{t_0\}\sqcup\{t_1\}$ with a single
arrow $t_1\to t_0$, so $\mathcal T^{op}$ has terminal $t_1$ and $\vee\dashv w$ with
$w(\ast)=t_1$. Let $e(\ast,-)$ be the functor $\mathcal T\to\mathbf{Set}$ with
$e(\ast,t_1)=\{a\}$, $e(\ast,t_0)=\{b,b'\}$, the arrow acting by $a\mapsto b$. Then
$\int^{t}e(\vee t,t)=\bigl(\{a\}\sqcup\{b,b'\}\bigr)/(a\sim b)=\{[a],b'\}$, of size 2, while
$\int^{f\in\mathcal F}e(f,wf)=e(\ast,t_1)=\{a\}$, of size 1. Two different objects.
$\square$

**Consequence, and it settles the referee question seed170 flagged first.** Reading §E's
harpoons $\vee:\mathcal F_\alpha\rightleftarrows\mathcal T_\alpha$ as an *adjunction* rather
than an equivalence does **not** collapse the repair to P3 (plain colimit), as
`0771-seed170-boundary-typing.md` §"Three things I want a referee to attack" suggests it
would. It leaves a well-formed coend and destroys only its *canonicity*: which of the two
sides you integrate over becomes part of the definition. So the honest positions are three,
not two: equivalence (canonical trace), adjunction-or-bare-functor (a trace, but of a chosen
restriction), and refusal of $\vee$ altogether (P3, and only then the §5.3 price).

### 1.3 Functoriality in ◇ — and it is contravariant

**Proposition 3.** Let $(f_o,f_a):\Diamond\to\Diamond'$ be a Chu transform,
$f_o:\mathcal F\to\mathcal F'$, $f_a:\mathcal T'\to\mathcal T$, with
$e'(f_o f,t')=e(f,f_a t')$ (Barr/Pratt, standard, and the form
`ORDINAL_LADDER_SMALLNESS.md` Theorem 3 quotes). Suppose additionally

$$\textbf{(M6)}\qquad \vee'\ \cong\ f_o\circ\vee\circ f_a^{op}\ :\ \mathcal T'^{op}\to\mathcal F' .$$

Then there is a canonical map $\partial\Diamond'\to\partial\Diamond$. Hence the repaired
$\partial$ is a **contravariant** functor on the subcategory of Chu transforms satisfying
(M6).

*Proof.* For $t'\in\mathcal T'$, $(M6)$ and the Chu condition give
$e'(\vee' t',t')\cong e'(f_o\vee f_a t',\,t')=e(\vee f_a t',\,f_a t')$, the $f_a t'$-component
of the diagonal family of $e$. These components assemble into a cocone over the diagram
$(\ast)$ for $\Diamond'$ with vertex $\partial\Diamond$, because $f_a$ is a functor and
carries the coequalized relations of $\Diamond'$ into those of $\Diamond$. Universality of
$\partial\Diamond'$ gives the map. Functoriality and direction are read off the construction:
$f_a$ points backwards, so $\partial$ does. $\square$

**This is a cost, and it is the sharpest one in the note.** `ORDINAL_LADDER_SMALLNESS.md`
Theorem 3 refutes covariance of
$\mathfrak F=\ulcorner-\urcorner\circ\vee\circ\Phi\circ\Gamma\circ\delta\circ\partial$ by a
**parity count**: "five covariant factors and one contravariant compose to a contravariant
functor", whence the ladder is a zig-zag and $\operatorname{hocolim}_{\beta<\lambda}\Diamond_\beta$
is not defined. Under the repair there are **two** contravariant factors, $\partial$ and
$\vee$, and the parity flips. **Theorem 3's ground does not survive the repair.** What
survives is stated in §3.3, and it is less than a refutation and more than nothing.

---

## 2. Does the repair make ∂ agree with the trace factor? Yes, at a price, and only as far as the arity allows

`TRACE_FACTOR_ADJUDICATED.md` Proposition 5 established that D0016 §I's
$\int^i(\mathfrak M_i^\vee\otimes\mathfrak M_i)$ is the trace of the **identity** profunctor,
$HH_0$, and that §D's $\Phi_{\mathrm{tr}}$ is a shadow trace on a bicategory — "the same
construction at two arities".

**Proposition 4 (three arities of one operation).** Assume (M1)–(M4) and additionally

**(M7)** $Q_\alpha=\mathcal V$ is a Bénabou cosmos (complete, cocomplete, closed symmetric
monoidal), and $e_\alpha$ is $\mathcal V$-enriched,

so that $\mathcal V$-$\mathbf{Prof}$ is a bicategory whose 1-cells $\mathcal C⇸\mathcal D$ are
$\mathcal V$-functors $\mathcal D^{op}\otimes\mathcal C\to\mathcal V$ and whose shadow is
$\langle\!\langle F\rangle\!\rangle=\int^{c}F(c,c)$. Then

| object | arity | value |
|---|---|---|
| §I's ज्ञेयम् | the unit 1-cell | $\langle\!\langle \mathrm{Id}_{\mathcal C}\rangle\!\rangle=\int^c\hom(c,c)$ |
| the repaired $\partial\Diamond_\alpha$ | one 1-cell | $\langle\!\langle \vee^{*}e_\alpha\rangle\!\rangle=\int^t e(\vee t,t)$ |
| §D's $\Phi_{\mathrm{tr}}$ | a cyclically composable triple | $\langle\!\langle L_{12}\odot L_{23}\odot L_{31}\rangle\!\rangle$ |

are three values of one functor. *Proof.* All three displays are $\int^{c}F(c,c)$ for an
endo-1-cell $F$; $\vee^*e$ is an endo-1-cell of $\mathcal T_\alpha$ by §0.2. The nLab page
"trace of a category", read directly this pass, gives both the general formula
"the trace of a general endoprofunctor $F$ on $C$ is the coend $\int^{c}F(c,c)$" and the
identity case, "the trace of the identity $1_C$ in $\mathbf{Prof}$". $\square$

**So: $\partial$ and $\Phi_{\mathrm{tr}}$ are the same operation at different arities. This is
a genuine unification inside the transmission, and — per the mandate's own framing — the first
one found rather than refuted.** It is recorded as *found*, and immediately priced:

1. **It costs (M7), which is strictly more than the repair needs.** (M4) asks $Q_\alpha$ for
   one coequalizer; (M7) asks it to be a cosmos. A stage with $Q_\alpha=\{0,1\}$ satisfies
   (M4) and not (M7) in any useful way (see §2.2). **The unification is a further purchase.**
2. **It unifies the operation, not the content.** $\Phi_{\mathrm{tr}}$'s claim is
   *rotation-invariance*, which needs the shadow's coherence isomorphism
   $\langle\!\langle M\odot N\rangle\!\rangle\cong\langle\!\langle N\odot M\rangle\!\rangle$
   and, per `TRACE_FACTOR_ADJUDICATED.md` §2.3, a twist that $Z(U)$ does not carry. At arity
   one there is nothing to rotate: $\partial$ uses the shadow's *value* and none of its
   *axioms*. So the unification transports no obligation onto $\partial$ — and, equally, it
   **does not discharge any of $\Phi_{\mathrm{tr}}$'s**. Nothing about §2/§2.4/§6 of
   `TRACE_FACTOR_ADJUDICATED.md` changes.
3. **And one collision is genuinely avoided, which is the one piece of good news.**
   `TRACE_FACTOR_ADJUDICATED.md` §6.2 records that §E's $\vee$ is the Chu transpose (a
   $*$-autonomous duality) while $\Phi_{\mathrm{tr}}$'s trace needs a **rigid** dual, and that
   the framework's $\vee$ therefore does not supply the $\vee$ its trace needs. The repaired
   $\partial$ **needs no dualizability at all**: a profunctor trace is a coend, and coends do
   not require $\mathrm{ev}/\mathrm{coev}$. So $\partial$ is the one place in the transmission
   where §E's $\vee$ suffices, as written, for a trace. That is a real gain and it is small:
   it removes §6.2's obligation at one factor of $\mathfrak F$ and leaves it at the other.

**Explicitly not claimed** (standing check (e)): I claim $\partial$ is *an instance of* the
shadow, not that $\partial=\Phi_{\mathrm{tr}}$, and not that either determines the other. The
announced relation is $\Longrightarrow$ in one direction only: shadow $\Rightarrow$ both
displays denote. There is no $\leftrightarrow$ here.

### 2.2 What the repair does to the degenerate readings — derived, not asserted

**Proposition 5 ($Q$ a poset).** If $Q_\alpha$ is a poset, any coequalizer is its own codomain
(a poset has no non-trivial quotients), so

$$\partial\Diamond_\alpha=\bigvee_{t\in\mathcal T_\alpha}e_\alpha(\vee t,\,t)\ \le\ \bigvee_{f,t}e_\alpha(f,t).$$

*Proof.* Colimits in a poset are joins; the coequalizer of a parallel pair into $B$ is $B$.
$\square$

**Corollary 5.1 (§H is improved but not repaired).** For $Q=\mathbf 2$, the repaired
$\partial\Diamond=1$ iff **some ∨-diagonal entry** is $1$ — not, as under
`BOUNDARY_OPERATOR_TYPING.md` Proposition 3 / Corollary 3.1, iff *some* entry is. So
$\Delta\partial_{\mathrm{future}}$ is no longer identically $0$ between non-zero spaces, and
§H clauses 5–6 are no longer *constant*. They remain a two-valued predicate on a diagonal
support, which is a criterion of very low resolution but is a criterion. **Corollary 3.1 of
the source pass is therefore repair-dependent, and should be quoted as a statement about P3
only.**

**Proposition 6 (bare Chu spaces are not rescued).** If $\mathcal T_\alpha$ is discrete and
$Q_\alpha$ a bare set of values (discrete category) — D0016 §F's literal reading — then
$(\ast)$ has no non-identity arrows and $\partial\Diamond_\alpha=\coprod_t e(\vee t,t)$ in a
discrete category, which exists iff $t\mapsto e(\vee t,t)$ is constant. *Proof.* As
`BOUNDARY_OPERATOR_TYPING.md` Proposition 2, restricted to the diagonal. $\square$

**So the repair buys nothing on the bare Chu core** — the part of the transmission
`TRACE_FACTOR_ADJUDICATED.md`, §J1 and the fleet all agree has immediate content. It buys
something exactly where $\mathcal T_\alpha$ carries morphisms and $Q_\alpha$ carries
structure, i.e. exactly where the transmission has supplied nothing.

---

## 3. What the repair costs the rest of §A/§B

### 3.1 $\mathcal O_\alpha=\int^{\sigma\in N(\mathcal F_\alpha)}\delta_\sigma$ — the ∨-repair does not reach it, and a different repair does

The ∨-diagonal is unavailable here: the integrand $\delta_\sigma$ is one-sorted, there is no
second category to be opposite to, and $N(\mathcal F_\alpha)$ is a simplicial set, not a
category admitting a diagonal. **The repair of §B's first display does not repair its second.**

**But a different reading is available, and it is the one the nerve is asking for.** Suppose

**(N1)** $\{\delta_\sigma\}$ assembles into a simplicial object $\delta_\bullet:\Delta^{op}\to Q_\alpha$
(faces = restriction of the holonomy to sub-simplices, degeneracies = insertion of identities —
plausible from §B's $\mathfrak H_\sigma=\rho_{i_0i_n}\rho_{i_{n-1}i_n}\cdots\rho_{i_0i_1}$,
**not verified here**), and

**(N2)** $Q_\alpha$ is tensored over $\mathbf{Set}$ (copowers exist).

Then

$$\mathcal O_\alpha:=\int^{[n]\in\Delta}N(\mathcal F_\alpha)_n\cdot\delta_n$$

is a genuine coend: the bound variable $[n]$ occurs **twice**, contravariantly in $\delta_n$
and covariantly in $N(\mathcal F_\alpha)_n$, and this is the standard realization/tensor coend.
**Price:** (N2) is a hypothesis of a different kind from (M4) — a copower, not a coequalizer —
and (N1) is a real mathematical obligation on $\rho$, unverified here. **So one cannot say
"one repair fixes §B"**: §B's two displays fail the same test and need two structurally
different repairs, each with its own hypothesis on $Q_\alpha$. This closes, with a candidate
and its price, the item `BOUNDARY_OPERATOR_TYPING.md` §6.6 left open; it does not adjudicate
it, because (N1) is not checked.

### 3.2 $\mathbb B=\int^{\alpha\in\mathbf{Ord}_{<\kappa}}\Diamond_\alpha$ — no benefit whatever

$\mathbf{Ord}_{<\kappa}$ is a poset; there is no involution and $\Diamond_\alpha$ is not a
two-variable functor of $\alpha$. Neither the ∨-repair nor the realization repair applies.
Independently, `ORDINAL_LADDER_SMALLNESS.md` Theorems 6–8 refute this display on size grounds
for $\kappa=\mathbf{Ord}$ and leave it PARTIAL under (S1)–(S5) for set $\kappa$. **Verdict
unchanged in both directions: the repair neither helps nor harms §E's closure claim.**

### 3.3 The transport, and the ladder — the mandate's conditional, answered in the negative twice over

`ORDINAL_LADDER_SMALLNESS.md` lines 70–80: "$\delta$ is not a function of that object … a
family indexed by simplices of the nerve, computed from the transport data $\rho$, which the
coend has already integrated away. So $\delta\circ\partial$ has a domain mismatch at the first
composition."

**First, a framing correction, per standing check (c).** That passage is **not one of the
ladder's refutations.** It is a pre-theorem remark, and the note says so in its own next
sentence: "**I record this as an artifact-level ambiguity and do not repair it**; every theorem
below is stated so that it survives either reading." The ladder's refutations are Theorems 1–4
(mode selection, non-functorial $\operatorname{Obs}$, contravariance of $\vee$, no fixed
domain) and 5–11; **none of them uses $\partial$**. So the mandate's premise — that
retaining the transport "removes one of the ladder's three independent refutations" — is not
available: there is no refutation there to remove. I checked each of Theorems 1–11 for a use
of $\partial$ and found none.

**Second, the substantive question, answered with a case split the sources leave open.**
Is $\rho$ the morphism-data of $\mathcal F_\alpha$, or extra structure on a bare index set?
§B writes $\sigma\in N(\mathcal F_\alpha)$ and $\mathfrak H_\sigma=\rho_{i_0i_n}\cdots$, i.e.
$\rho$ indexed by pairs of vertices of $\mathcal F_\alpha$ — compatible with both. §A lists
$\rho$ as a **separate slot** of the septuple, which suggests the second. Both are worked:

- **Case R1 ($\rho$ = the arrows of $\mathcal F_\alpha$).** Then the repaired $\partial$ does
  **not** ignore the transport: by $(\ast)$, the relations coequalized are exactly
  $e(\vee u,1)\sim e(1,u)$, and $\vee u$ ranges over $\vee$-images of arrows of
  $\mathcal T_\alpha$ in $\mathcal F_\alpha$ — that is, over transport maps. So $\partial$ is
  a function *of* $\rho$. **But it is not a function *to* the $\rho$-indexed family.** $\delta$
  needs a value at each simplex $\sigma$; $\partial$ delivers one object of $Q_\alpha$ with the
  $\rho$-relations divided out. The mismatch in $\delta\circ\partial$ is therefore
  **unchanged**, and its correct description changes from "$\rho$ is absent" to "$\rho$ is
  present, summed out". That is a *better* ground for the same negative.
- **Case R2 ($\rho$ extra structure, $\mathcal F_\alpha$ a bare index).** Then
  $\mathcal T_\alpha$ has no arrows either under §F's reading, $(\ast)$ is the discrete
  coproduct of Proposition 6, and $\rho$ never enters. Mismatch unchanged, ground unchanged.

**Answer: the transport does not survive in the form $\delta$ requires, in either case.** The
repaired $\partial$ still integrates it away; what changes is only that under R1 it integrates
away something rather than nothing.

**Third — and this is where the repair *does* touch the ladder, against the source pass's own
disclaimer.** By Proposition 3, the repaired $\partial$ is contravariant. Theorem 3 of
`ORDINAL_LADDER_SMALLNESS.md` derives contravariance of $\mathfrak F$ from a parity count with
exactly one contravariant factor. Under the repair the count is two and the parity is even.
Precisely what survives:

> **Proposition 7.** Under (M1)–(M6), Theorem 3's *parity argument* is invalid: $\mathfrak F$
> contains at least two contravariant factors. Theorem 3's *conclusion* is neither restored nor
> refuted thereby, because (i) the composite $\delta\circ\partial$ is undefined (§3.3 above), so
> $\mathfrak F$'s variance is a question about an undefined composite; and (ii) Theorem 4 (no
> fixed domain, $\ulcorner-\urcorner_\alpha:\mathcal C_\alpha\to\mathcal C_{\alpha+1}$) obstructs
> $\operatorname{hocolim}_{\beta<\lambda}\Diamond_\beta$ independently of variance.

So the repair converts one of the ladder note's four functoriality refutations from *proved* to
*unsupported*, without making the ladder work. That is a cost to the corpus, not a gain for the
transmission, and it is exactly the kind of thing this mandate was asked to price. **Theorem 3
should be restated with its variance count made conditional on the reading of $\partial$**; its
first sentence (Chu duality is contravariant) is untouched and remains proved.

### 3.4 `ADVANCE_UNDER_REPLACEMENT.md` §3.4's typing — survives, with one clause corrected

That note types $\operatorname{UsefulEscape}$ as "a difference of boundaries across a step,
$\partial\Diamond$ being … a function of the Chu datum, not of $\delta$", and
`BOUNDARY_OPERATOR_TYPING.md` §4.2 says the typing "survives every candidate repair". It does
— but under Case R1 the phrase "not of $\delta$" needs care: $\partial$ is then a function of
the *arrows* out of which $\mathfrak H_\sigma$ and hence $\delta_\sigma$ are built. It is not a
function of $\delta$, since it does not factor through the defect family; it is not independent
of the data $\delta$ is computed from either. **Typing survives; the parenthetical is
sharpened.**

---

## 4. The honest accounting: the source pass's four claims, checked by reading

`BOUNDARY_OPERATOR_TYPING.md` §5.1: P1 "does **not** define $\operatorname{UsefulEscape}$",
"Theorem U is untouched by it", it "does not touch the ordinal ladder", and it "**reopens**
evasion (b) … not complete it".

**(i) Does not define UsefulEscape — SURVIVES.** `ADVANCE_CONJUNCTS_DEFINED.md` §6.4's verdict
is that no definition exists in $\mathscr L_{\mathrm{Chu}}$ non-vacuous on Advancing runs, and
that the further datum must be (i) a run-fixed code $L$ or (ii) "the enrichment making
$\partial$ a coend". The repair supplies (ii) — and (ii) was never claimed sufficient: §6.4
says it gives "a $\Delta\partial_{\mathrm{future}}$ *reading*", not a definition. §G asks for
$\operatorname{UsefulEscape}>0$, an element of an ordered set; $\partial\Diamond_\alpha$ is an
object of $Q_\alpha$, and $\Delta$ of two objects of two different $Q$'s is undefined until
$Q_\alpha\to Q_{\alpha+1}$ is given. **Confirmed, and with an extra reason the source pass did
not give: even granting the repair, $\Delta$ has no definition.**

**(ii) Does not touch Theorem U — SURVIVES as stated, with a correction to the reason.**
Theorem U (read in full, §6.2) hypothesises that $U$ depends on the step *only through*
$(\sim_{\mathcal T_\alpha},\iota,\sim_{\mathcal T_{\alpha+1}})$. The repaired
$\Delta\partial$ does **not** satisfy that hypothesis: it reads $e$'s values and
$\mathcal T$'s arrows, not merely the induced separation relations. So Theorem U does not
apply to it — which is what "untouched" should mean, and is *not* what the source pass's
stated reason ("Theorem U is about $\sim$-expressible measures and P1 changes no $\sim$")
says. Both sentences are true; only the second is a reason. **Theorem U stands; it simply does
not reach the repaired $\partial$, exactly as it does not reach evasion (a)'s
$\operatorname{Res}$.**

**(iii) Does not advance the ladder — REFUTED IN GROUND, SURVIVES IN CONCLUSION.** §3.3 above:
the repair invalidates the parity count grounding `ORDINAL_LADDER_SMALLNESS.md` Theorem 3, so
it *touches* the ladder. It advances nothing: Theorems 1, 2, 4 and 5–11 are untouched, and by
Proposition 7 the variance question is a question about an undefined composite. **The claim as
a claim about *advance* survives; as a claim about *contact* it is false.**

**(iv) Reopens evasion (b) without completing it — SURVIVES, and I can say why more sharply.**
Evasion (a), $\operatorname{Res}(\mathcal T)=|\mathcal T/\!\sim|$, was rejected by Proposition
4 of that note: it is not invariant under recoding of $Q$ *one column at a time*. Does the same
attack kill the repaired $\Delta\partial$? **No, and the reason is (M2).** A per-test recoding
is a family of automorphisms $\varphi_t$ of $Q$; the recoded integrand $\varphi_t(e(\vee t',t))$
is a functor $\mathcal T^{op}\times\mathcal T\to Q$ only if the family is natural in $t$, which
Proposition 4's counterexample ($\varphi$ applied to the $t_2$ column alone) is not. So the
functoriality hypothesis the repair must buy anyway **excludes precisely the recodings that
refuted evasion (a)**. Whereas a global recoding is an equivalence of $Q$ and preserves coends.
This does not show $\Delta\partial$ is non-vacuous — the pessimism the source pass records
(Lemma 1's collapse of the defect to the holonomy support on $\operatorname{SearchSep}$ stages,
whose analogue for $\int^t e(\vee t,t)$ is still not computed) is untouched. **Reopened, with
one specific refutation shown not to apply. Not completed.**

---

## 5. The price list

| item | before the repair | after | net |
|---|---|---|---|
| $\partial$ well-formed | no (arity) | yes, under (M1)–(M4) | **gain** |
| hypothesis on $\vee$ | — | functor suffices; equivalence needed only for canonicity (Prop. 1–2) | **cheaper than P1 claimed** |
| $\mathcal T_\alpha$ small | not required | **required** (M1) | new cost |
| type for $Q_\alpha$ | none given | coequalizer + coproducts (M4); cosmos (M7) for the Φ_tr unification | new cost, two tiers |
| §A's signature | septuple | **octuple**: $\vee$ must be stage data (M5) | new cost, structural |
| functoriality of $\partial$ | n/a | contravariant, under (M6) (Prop. 3) | new cost |
| $\partial$ vs $\Phi_{\mathrm{tr}}$ vs §I | three objects | one shadow, three arities (Prop. 4) | **unification, priced at (M7)** |
| §6.2's rigid-dual collision | obligation at $\Phi_{\mathrm{tr}}$ and $\vee$ | none at $\partial$ | **gain, local** |
| $\mathcal O_\alpha$ | ill-typed | needs a *different* repair: realization coend, (N1)+(N2) (§3.1) | candidate, unverified |
| $\mathbb B=\int^\alpha\Diamond_\alpha$ | ill-typed; refuted on size | unchanged | zero |
| bare Chu core (§F) | — | repair buys nothing (Prop. 6) | zero |
| §H cl. 5–6 | constant under P3 (Cor. 3.1) | non-constant, low-resolution (Cor. 5.1) | small gain; Cor. 3.1 is P3-only |
| transport for $\delta\circ\partial$ | integrated away | still integrated away (R1: summed out; R2: absent) | **zero** |
| `ORDINAL_LADDER` Thm 3 | proved by parity | **ground invalid** (Prop. 7); conclusion undecided | **cost to the corpus** |
| Theorem U | proved | untouched, and out of reach of $\Delta\partial$ | zero |
| UsefulEscape | undefined | undefined; $\Delta$ also undefined | zero |
| evasion (b) | unavailable | reopened; Prop. 4's attack shown inapplicable | **partial gain** |

---

## 6. Scope limits

1. **Propositions 1, 3, 5, 6 and 7 are exact symbolic arguments** and are checkable without me.
   Proposition 2 is a two-object finite counterexample, exhaustively verified by hand.
2. **Proposition 4 depends on (M7) and on the standard shadow structure of $\mathcal V$-$\mathbf{Prof}$.**
   I read the nLab page "trace of a category" directly this pass, which gives the endoprofunctor
   coend and "the trace of the identity $1_C$ in $\mathbf{Prof}$", and a page under "shadow"
   which repeats the coend formula and does **not** state the $\mathbf{Prof}$ shadow example. The
   statement that $\langle\!\langle-\rangle\!\rangle=\int^c F(c,c)$ *is* a Ponto–Shulman shadow on
   $\mathcal V$-$\mathbf{Prof}$ is quoted from the standard statement and was **not** read in a
   source this pass. If it fails, Proposition 4 degrades to "three instances of one coend
   formula", which is all §2's conclusions actually use.
3. **(N1) of §3.1 is not verified.** Whether $\{\delta_\sigma\}$ is simplicial is a real
   obligation on $\rho$ and is left open; §3.1 offers a candidate with its price, not a verdict.
4. **The R1/R2 case split of §3.3 is forced by an ambiguity in §A/§B**, and is the owner's to
   resolve. Both cases give the same answer to the mandate's question, which is why the answer
   is offered without waiting on the resolution.
5. **I did not audit the repository for other uses of $\partial$.** I re-read
   `ORDINAL_LADDER_SMALLNESS.md` (Theorems 1–11 and §1's preamble),
   `ADVANCE_CONJUNCTS_DEFINED.md` §6 in full, `TRACE_FACTOR_ADJUDICATED.md` in full,
   `BOUNDARY_OPERATOR_TYPING.md` in full, `0771-seed170-boundary-typing.md`, and D0016 in full.
   `BOUNDARY_OPERATOR_TYPING.md` §4's containment partition is taken as read and not re-verified;
   §3.3's Proposition 7 is the one place I amend a prior note's ground, and I amend it here,
   openly, rather than editing that note.
6. **D0018 §J5's $\chi_\alpha$ and D0019 §C's $\rho(D\mathcal K)$ are untouched and are not
   identified with anything.** The $\rho$ of §3.3 is D0016 §B's transport datum and is a
   different symbol.
7. **Nothing is machine-checked**; no Agda or Lean authored, no Python, no numerical
   computation, no PDF decoded.
8. **§7's generalisation is mine and is offered for audit.**

---

## 7. Concluding generalisation, offered as such

`TRACE_FACTOR_ADJUDICATED.md` §9 proposed that in this framework *notation collision predicts
defect better than logical overreach*. This pass supplies a case that refines it rather than
confirming it: the ∂ defect was not a collision but a **missing argument**, and its repair's
whole cost is the supply of arguments the signature does not carry — a smallness bound, a value
category, and a $\vee$ promoted from operator to stage datum. The generalisation I offer is
narrower and, I think, sharper:

> **In D0016, every operator that is displayed with an index and no codomain fails, and it fails
> by arity; every operator displayed with a codomain and no hypotheses fails, and it fails by a
> missing hypothesis.** $\partial$, $\mathcal O$ and $\mathbb B$ are of the first kind;
> $\Phi_{\mathrm{tr}}$, $\Gamma$ and $\operatorname{Obs}$ are of the second.

The test that refutes it: an operator of the first kind whose defect, once repaired, turns out
to have been a missing hypothesis rather than a missing argument — or a defect in D0016 that is
neither. I did not look outside §§A–E and §I.

---

*seed175, 2026-08-15. Verdicts: §1 minimum hypotheses (M1)–(M7), with (M3) weakened and (M1),
(M5), (M6) added against the source pass · §2 UNIFIED (∂, Φ_tr and §I are one shadow at three
arities), priced at (M7) · §3.3 transport DOES NOT SURVIVE, and the ladder refutation the
mandate hypothesised does not exist · §4 three of four honesty claims stand, "does not touch the
ladder" refuted in ground · §3.3/Prop. 7 one prior result's ground invalidated by the repair.*
