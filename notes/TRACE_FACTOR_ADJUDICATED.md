# The trace factor Φ_tr of D0016 §D, adjudicated

*seed167, 2026-08-15. Adjudicates the first factor of the four-factor recut,
`collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md` §D, and its
connection to §I. Owner artifact: derived from, not rewritten. No Python; no Agda or
Lean authored; no PDF decoded.*

---

## 0. The claim, as written

D0016 §D:

> **$\Phi_{\mathrm{tr}}$** — trace: $\operatorname{Tr}(abc)\simeq\operatorname{Tr}(bca)\simeq\operatorname{Tr}(cab)$;
> "वर्णभेदः $\xrightarrow{\operatorname{Tr}}$ आदिबिन्दु-विरहित-चक्रत्वम्" — labelled difference becomes basepoint-free cyclicity.

with the recut $\Phi_\alpha = \Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}\circ\Phi_{\mathrm{refl}}\circ\Phi_{\mathrm{cut}}$,
and the mandate's instantiation $\Phi_{\mathrm{tr}}(L_{12}\odot L_{23}\odot L_{31}) := \operatorname{Tr}(L_{12}\odot L_{23}\odot L_{31})$.

Five questions are answered below, each with its own verdict. **The headline is split**, so
it is stated split, per the corpus rule that a PARTIAL must name its halves:

| # | claim | verdict |
|---|---|---|
| §1 | the setting in which $\operatorname{Tr}$ of a *cyclically composable triple* exists | **CLASSICAL** — bicategorical trace with a shadow, or symmetric monoidal + dualizable; nothing new |
| §2 | $\Phi_{\mathrm{ctr}}$ supplies enough structure for $\Phi_{\mathrm{tr}}$'s cyclicity | **REFUTED as written** — braided is not enough; the missing datum is a twist (ribbon / spherical), which the Drinfeld centre does not carry in general |
| §2.4 | $\Phi_{\mathrm{ctr}}$'s Yang–Baxter defect is a live quantity on $Z(U)$ | **REFUTED** — $\operatorname{YB}_\delta(R)=1$ identically on the object §D itself defines; the clause is vacuous there |
| §3 | $\simeq$ rather than $=$ | **PARTIAL** — an equality in the 1-categorical setting; in the ∞-setting cyclicity is a *datum*, and the datum has a name (§4) |
| §4 | "$\operatorname{Tr}$: labelled $\to$ basepoint-free cyclic" | **CLASSICAL** — this is Connes' $\Lambda$ / the cyclic bar construction / the $S^1$-action, verbatim. Translation is not a result (D0016 §J6, in the owner's own hand) |
| §5 | §I's $\int^i(\mathfrak M_i^\vee\otimes\mathfrak M_i)$ connects to $\Phi_{\mathrm{tr}}$ | **PROVED (classical)** — §I *is* $\Phi_{\mathrm{tr}}$ applied to the identity profunctor. They are one object, not two |
| §6 | $\Phi_\alpha$ is a composite | **OPEN, and the sharpest defect found** — the four factors are not exhibited on a common (co)domain; the outer composite is the one that is not shown to be defined |

---

## 1. Where $\operatorname{Tr}$ exists — and the type discipline the slogan drops

**1.1 The indices are load-bearing, and they are right.** Read $L_{ij}$ as a 1-cell
$j \to i$ (equivalently an $(i,j)$-bimodule). Then $L_{12}\odot L_{23}\odot L_{31}$ is an
*endo*-1-cell of the object $1$; its rotation $L_{23}\odot L_{31}\odot L_{12}$ is an
endo-1-cell of $2$; $L_{31}\odot L_{12}\odot L_{23}$ of $3$. Three endomorphisms of **three
different objects**. So the statement being made is not "the trace is invariant under
conjugation" — it is that a single invariant is extracted from three a priori unrelated
endomorphisms.

**1.2 The unindexed slogan is a type error; the indexed instance is not.** As printed in
§D, "$\operatorname{Tr}(abc)\simeq\operatorname{Tr}(bca)$" carries no typing, and for a
general triple $bca$ is not defined. Cyclic invariance of a trace holds exactly where the
rotated composites are defined, i.e. for a *cyclically composable* string
$a: Z\to X,\ b: Y\to Z,\ c: X\to Y$. The mandate's instantiation supplies precisely that
typing, so the instance is well-formed. **Recorded as a notation defect, not a
mathematical one:** the transmission's own $L_{ij}$ form is correct and its slogan form is
not, and a note that cites the slogan without the indices will be citing something false.

**1.3 The two settings that make it a theorem.**

*(a) Symmetric monoidal, dualizable objects.* For $f: X\to Y$, $g: Y\to X$ with $X,Y$
dualizable in a symmetric monoidal category, $\operatorname{Tr}(gf)=\operatorname{Tr}(fg)$
in $\operatorname{End}(\mathbb 1)$. Three-fold cyclicity follows by iterating this twice,
*using the associator*: $\operatorname{Tr}(a(bc)) = \operatorname{Tr}((bc)a)$, and
$(bc)a \cong b(ca)$. The three objects $X,Y,Z$ must all be dualizable; dualizability of one
does not transport to the others.

*(b) A bicategory with a shadow.* Case (a) does not literally apply to §D, because the
three rotations are endomorphisms of three different *objects of a bicategory*, not
endomorphisms in one monoidal category. The correct named home is the bicategorical trace
of Ponto and Ponto–Shulman: a **shadow** $\langle\!\langle-\rangle\!\rangle$ on a bicategory,
whose defining datum is a natural isomorphism
$\langle\!\langle M\odot N\rangle\!\rangle \cong \langle\!\langle N\odot M\rangle\!\rangle$
for $M: a\to b$, $N: b\to a$, subject to coherence with the associators and unitors. This
is *exactly* the structure $\Phi_{\mathrm{tr}}$ is asking for, and it is the structure under
which "$\operatorname{Tr}$ of a cyclically composable string is rotation-invariant" is a
theorem rather than an assumption.

**Verdict §1: CLASSICAL.** The setting exists, is standard, and is not the transmission's.
What the transmission adds is the observation that its $L_{ij}$ triple is a legitimate
instance — which is true, and is a check, not a result.

**Scope limit, stated flatly.** I read the nLab pages named in §7 and the abstract and
introduction of Ponto–Shulman via ar5iv; the ar5iv rendering served only the front matter,
so the shadow **axioms** are quoted here from the standard statement and not from a source I
read end to end. Nothing below depends on the precise coherence axioms — only on the
existence of the isomorphism $\langle\!\langle M\odot N\rangle\!\rangle\cong\langle\!\langle N\odot M\rangle\!\rangle$
as a *datum*, which the abstract does state ("shadows … enable us to define traces").

---

## 2. Compatibility of $\Phi_{\mathrm{tr}}$ with $\Phi_{\mathrm{ctr}}$ — one refutation, one vacuity

$\Phi_{\mathrm{ctr}}$ is the centre: $Z(U)=\int_{x\in U}\operatorname{HalfBraid}_U(x)$, with
the half-braiding condition $\gamma_{y\otimes z}=(1_y\otimes\gamma_z)(\gamma_y\otimes 1_z)$
written out, and a Yang–Baxter defect
$\operatorname{YB}_\delta(R)=R_{12}R_{23}R_{12}(R_{23}R_{12}R_{23})^{-1}$ with the clause
$\operatorname{YB}_\delta(R)\neq 1 \Rightarrow \Gamma\langle\operatorname{YB}_\delta(R)\rangle$.

**2.1 What $\Phi_{\mathrm{ctr}}$ delivers.** The Drinfeld centre is *always* braided: nLab,
"Drinfeld center", read directly — "The Drinfeld center $Z(\mathcal C)$ is naturally a
braided monoidal category", with braiding $b_{(X,\Phi),(Y,\Psi)}=\Psi_X$ built from the
half-braidings. The condition §D writes out is exactly the half-braiding coherence. So
$\Phi_{\mathrm{ctr}}$ hands $\Phi_{\mathrm{tr}}$ a **braided** category.

**2.2 Braided is not enough.** Cyclic invariance of the trace is not available from a
braiding alone. In a category with duals one has a *left* and a *right* trace, and they
differ in general; the structure that makes them agree is sphericality. nLab, "spherical
category", read directly: a spherical category is "a pivotal category where the left and
right trace operations coincide on all objects" — the two traces being "distinguished …
a property that does not hold in all pivotal categories". For a braided pivotal category
this is the ribbon (balanced) condition: a twist $\theta$ compatible with the braiding.
**A braiding gives you the ability to write down two traces; it does not give you the
equation between them, and $\Phi_{\mathrm{tr}}$'s cyclicity needs that equation.**

**2.3 The gap, named.** $\Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}$ requires a datum that
neither factor posits: **a twist / ribbon structure on $Z(U)$, equivalently sphericality**.
This is not a technicality that "can be arranged": $Z(U)$ for general monoidal $U$ is
braided and nothing more. It becomes ribbon under hypotheses on $U$ (the classical case is
$U$ a spherical fusion category, where $Z(U)$ is modular hence ribbon) — hypotheses §D does
not state and which fail for the recut targets of $\Phi_{\mathrm{cut}}$ (Chu triples,
localizations, continuations are not fusion categories).

**Verdict §2: REFUTED as written; repairable only by adding a hypothesis.** The composite
$\Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}$ is not defined on the generality §D claims. The
minimal repair is to require $U$ such that $Z(U)$ is ribbon (spherical fusion suffices), and
to say so. **This is the "incompatibility between two factors of the same composite" the
mandate asked about, and it is real — but it is a missing hypothesis, not a contradiction.**
I record that distinction because the corpus's recorded failure mode (ledger §4.9) is
withholding or inflating a verdict past what the argument carries.

**2.4 A second, sharper finding: on $Z(U)$ the Yang–Baxter defect is identically trivial.**
$\operatorname{YB}_\delta(R)$ measures failure of $R_{12}R_{23}R_{12}=R_{23}R_{12}R_{23}$.
But the braiding of $Z(U)$ is constructed from half-braidings satisfying exactly the
coherence §D prints, and a braiding satisfies the braid relation by definition of braided
monoidal category (hexagons $\Rightarrow$ Yang–Baxter). Hence on the very object
$\Phi_{\mathrm{ctr}}$ constructs,
$$\operatorname{YB}_\delta(R)=1\quad\text{identically},$$
and the clause "$\operatorname{YB}_\delta(R)\neq1\Rightarrow\Gamma\langle\operatorname{YB}_\delta(R)\rangle$"
**never fires**. It is not false; it is vacuous *at the place §D applies it*. The clause has
content only for an $R$ that is a candidate braiding supplied from outside the centre — a
solution of the QYBE being tested, a lax or partial braiding, a would-be $R$-matrix. D0016
§J3 calls $\operatorname{YB}_\delta$ "checkable in any concrete monoidal category", which is
true; what is not true is that it is checkable *nontrivially* on $Z(U)$.

**This is the compatibility question turned around.** The two factors are not incompatible
because one contradicts the other; they are mismatched because $\Phi_{\mathrm{ctr}}$
over-supplies (a braiding, forcing $\operatorname{YB}_\delta=1$) and under-supplies (no
twist, so $\Phi_{\mathrm{tr}}$ still has no cyclicity). One factor's guarantee kills its own
defect measure and still misses the next factor's hypothesis.

---

## 3. $\simeq$ versus $=$, and what the difference costs

D0016 §E insists $\simeq\ \neq\ \equiv$, so the $\simeq$ in $\Phi_{\mathrm{tr}}$ must be read
as deliberate.

**3.1 In the 1-categorical settings of §1.3 the correct symbol is $=$.** In a symmetric
monoidal category, $\operatorname{Tr}(fg)$ and $\operatorname{Tr}(gf)$ are two elements of
the *set* $\operatorname{End}(\mathbb 1)$ and cyclicity is their equality. In the shadow
setting it is a *specified natural isomorphism* $\theta$ — so already there, $\simeq$ is
literally the right symbol and $=$ would be wrong. Point to the transmission: with a shadow,
cyclicity is structure.

**3.2 In the ∞-setting $\simeq$ is a datum, and the datum must cohere.** In a symmetric
monoidal $\infty$-category the trace of an endomorphism is a *point* of a mapping space, and
"invariance under rotation" is a path, not an equation. A path is a choice. Two rotations
compose, and the composite path must agree with the path assigned to the composite rotation;
$n$-fold rotation of an $n$-fold composite must return to the identity path up to a
specified higher path; and so on. **The cost of $\simeq$ over $=$ is precisely this tower of
choices, and the tower has a name: it is a $\Lambda$-structure (§4), equivalently an
$S^1$-action.** An equation is checked once and imposes no further obligation. An
equivalence must be chosen, and the coherence of the choices is not a formality — it is the
entire content of cyclic homology as against Hochschild homology.

**3.3 What $\Phi_{\mathrm{tr}}$ as printed actually gets.** For one fixed triple, rotation
generates $\mathbb Z/3$, not $S^1$. Three-fold cyclic invariance is the $\mathbb Z/3$
shadow of the $S^1$-action; it does not entail it. A framework that writes $\simeq$ and
stops has bought the obligation of §3.2 and paid for none of it.

**Verdict §3: PARTIAL.** *Correct half:* $\simeq$ is the right symbol — in the shadow
setting cyclicity is a specified isomorphism, and in the ∞-setting a specified equivalence.
*Unpaid half:* the transmission nowhere supplies or names the coherence that a $\simeq$
obliges, and the object it would have to supply is exactly the one §4 shows is classical.

---

## 4. The interpretive claim: labelled $\to$ basepoint-free cyclic

The Sanskrit gloss — वर्णभेदः (difference of letters/labels, i.e. a *linearly ordered,
based* word) becoming आदिबिन्दु-विरहित-चक्रत्वम् (rotation with no initial point) — is the
checkable claim, and it is checkable because there is a category-theoretic statement it is
either equal to or different from.

**4.1 The classical statement.** Connes' cyclic category $\Lambda$ (nLab, "cyclic category",
read directly): $\Delta$ embeds faithfully in $\Lambda$; $\operatorname{Aut}_\Lambda([n])
= \mathbb Z/(n{+}1)\mathbb Z$; every $f: m\to n$ in $\Lambda$ factors **uniquely** as
$f=\tau_n^{f(0)}g$ with $g$ simplicial. That unique factorisation is the whole slogan in one
line: *a $\Lambda$-morphism is a simplicial morphism together with a choice of basepoint
$\tau^{f(0)}$*, so passing from $\Delta$ to $\Lambda$ is exactly passing from based linear
words to words whose basepoint has been made a free coordinate. The cyclic bar construction
$N^{\mathrm{cyc}}(A)_n = A^{\otimes(n+1)}$ carries the cyclic operator
$a_1\otimes\cdots\otimes a_n \mapsto (-1)^{n-1}a_n\otimes a_1\otimes\cdots\otimes a_{n-1}$
(Wikipedia, "Cyclic homology", read directly), i.e. a $\Lambda$-object; its realization
carries an $S^1$-action (nLab, "cyclic set": "there is an ∞-action of the circle group on the
geometric realization of a cyclic set", attributed there to Moerdijk 1996 and Drinfeld 2003).
Hochschild homology is its homotopy; cyclic homology is what the $S^1$-action computes.

**4.2 Is $\Phi_{\mathrm{tr}}$'s claim that statement?** Yes, when it is read in the only way
that makes its $\simeq$ honest. "Labelled difference becomes basepoint-free cyclicity under
$\operatorname{Tr}$" is, precisely, "the trace construction factors through the cyclic bar
construction, which is a $\Lambda$-object, hence carries an $S^1$-action". The $L_{ij}$
triple is the $n=2$ stage of $N^{\mathrm{cyc}}$ for a bicategory of bimodules, and the
shadow of §1.3(b) is the Hochschild-homology functor.

**4.3 Where the reading fails.** Read instead as a property of the one-morphism trace —
"$\operatorname{Tr}$ *does* the conversion" — it is false in the strong form and trivial in
the weak one. $\operatorname{Tr}$ evaluated on a single string identifies its three
rotations; it produces $\mathbb Z/3$-invariance of a value, not a basepoint-free *object*. It
is the *bar construction* — the whole simplicial object, all $n$ at once — that carries the
cyclic structure. No single trace, however cyclic, yields an $S^1$-action.

**Verdict §4: CLASSICAL, and it must be said plainly.** The transmission's most evocative
line is the standard fact that $\Lambda$ refines $\Delta$ by making the basepoint free and
that cyclic objects realize to $S^1$-spaces — Connes 1983, with the realization statement as
attributed above. D0016 §J6, in the owner's own hand, is the applicable rule: *translation is
not a result.* Rendering "cyclic bar construction" as
आदिबिन्दु-विरहित-चक्रत्वम् has gained notation and lost nothing else. What is *not* merely
translation, and is worth keeping, is §4.3: the gloss picks the wrong carrier of the
structure, and that is a correction rather than a rediscovery.

---

## 5. §I: not a second object, the same one

D0016 §I:
$\text{ज्ञेयम}\simeq\int^{i}(\mathfrak M_i^\vee\otimes\mathfrak M_i)$,
$\mathfrak M_i:=\operatorname{Map}(-,i)\otimes\operatorname{Map}(i,-)$.

**5.1 State of prior adjudication, checked not assumed.** `notes/UNTOUCHED_REGIONS_ADJUDICATED.md`
**does not exist** in this tree (checked directly, 2026-08-15). The consolidated ledger
`notes/OWNER_TRANSMISSIONS_LEDGER.md` §6.2 says of D0016 §H and §I: "no note touches them;
no verdict beyond PROGRAMME is offered, and PROGRAMME here means 'nobody looked', not
'looked and found nothing'." So §I is adjudicated here for the first time, and nothing is
being duplicated. The neighbouring note `notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md`
adjudicates the **density comonad and codensity monad** for D0018's $\delta_\lhd,\delta_\rhd$
— a *different* coend ($\operatorname{Lan}_G G$, resp. $\operatorname{Ran}_G G$) — and its
result is neither used nor contradicted below. Stated so a later reader does not merge them.

**5.2 The identification.** By co-Yoneda the identity profunctor of $C$ is
$\int^{i} C(-,i)\otimes C(i,-)$, which is $\int^i \mathfrak M_i$ in §I's abbreviation. The
trace of an endoprofunctor $F$ is $\int^{c}F(c,c)$, and for $F=\mathrm{Id}$ this is
$\int^{c}\hom(c,c)$ — nLab, "trace of a category", read directly, which also states the
quotient description: endomorphisms modulo "$f\circ g\sim g\circ f$ when $f$ and $g$ compose
in either order". **That parenthetical is $\Phi_{\mathrm{tr}}$'s cyclicity, in the same
sentence as §I's coend.** Hence:

> **Proposition 5.** §I's ज्ञेयम् and §D's $\Phi_{\mathrm{tr}}$ are the same construction at
> two arities. $\int^{i}(\mathfrak M_i^\vee\otimes\mathfrak M_i)$ is the trace of the
> identity — the categorical Hochschild homology $HH_0(C)=\int^c C(c,c)$ — and
> $\operatorname{Tr}(L_{12}\odot L_{23}\odot L_{31})$ is the same functor evaluated on a
> length-3 string instead of on $\mathrm{Id}$. The coend *is* where the cyclic identification
> lives: it is precisely the coend's coequalizer that imposes $fg\sim gf$.

**5.3 What this costs the transmission.** §D and §I are presented as separate items of the
apparatus (a factor of the recut; a closing identification). They are one. The "labelled
$\to$ basepoint-free" gloss of §D and the coend of §I are the slogan and the formula for the
same classical object, so any note citing them as two independent convergences would be
double-counting. **Recorded pre-emptively**, since §J5 already shows the transmission is
prone to reading a restatement as an independent arrival.

**Verdict §5: PROVED, and classical.** Proved: the identification of §I with §D (co-Yoneda
plus the coend trace formula; two lines). Classical: both sides separately.

---

## 6. The composite $\Phi_\alpha$ — the defect that survives all of the above

$$\Phi_\alpha=\Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}\circ\Phi_{\mathrm{refl}}\circ\Phi_{\mathrm{cut}}.$$

Take the four factors at their stated types:

- $\Phi_{\mathrm{cut}}$ acts on a **Chu triple** $(\mathcal F,\mathcal T,e)$, adjoining
  Fourier, Mellin, $(-)^\vee$, Loc, Lift, Quot, Scale, Loop, Witness, Continuation.
- $\Phi_{\mathrm{refl}}$ acts on **first-order theories** $T_\alpha$, via
  $T_{\alpha+1}\vdash\operatorname{Con}(T_\alpha)$.
- $\Phi_{\mathrm{ctr}}$ acts on a **monoidal category** $U$, returning $Z(U)$.
- $\Phi_{\mathrm{tr}}$ acts on a **cyclically composable triple of 1-cells in a bicategory
  with a shadow**.

**6.1 No two consecutive factors are exhibited on matching (co)domains.** A theory is not a
monoidal category; the centre of a Chu triple is not defined; a recut of $(\mathcal F,\mathcal T,e)$
does not produce a triple of composable 1-cells. Cyclic invariance of the trace holds only
where the composites are defined — and here it is the *outer* composite, $\Phi_\alpha$
itself, that is not shown to be defined. Nothing in §D, §E or §J discharges this.

**6.2 The duality collision, specifically.** $\Phi_{\mathrm{cut}}$ adjoins $(-)^\vee$, and
§E fixes what $\vee$ means in this framework: $e^\vee(t,f):=e(f,t)$, the Chu transpose. That
is a $*$-autonomous duality. $\Phi_{\mathrm{tr}}$'s trace requires a **rigid** dual —
$\mathrm{ev}$ and $\mathrm{coev}$ satisfying the triangle identities, i.e. dualizability in
the compact-closed sense. These are different structures wearing one symbol: a
$*$-autonomous category is compact closed exactly when $\otimes$ and $\parr$ coincide, which
is not the case for Chu constructions in general. **The framework's $\vee$ therefore does not
supply the $\vee$ its trace needs**, and $\Phi_{\mathrm{tr}}\circ\cdots\circ\Phi_{\mathrm{cut}}$
has an undischarged obligation at exactly the point the notation makes look discharged.

*Ground capped.* I did not read a source this pass for "Chu$(\mathrm{Set},Q)$ is
$*$-autonomous but not compact closed"; it is quoted from the standard statement (Barr) and
is used here only to say that the identification of the two dualities **needs an argument**,
never to assert that it fails. If some later pass exhibits rigid duals for the relevant
recut objects, §6.2 dissolves and §6.1 does not.

**6.3 A second-order point about the whole recut.** Even granting each factor its own home,
dualizability is *not* preserved by the operations $\Phi_{\mathrm{cut}}$ adjoins.
Localization, quotient and continuation all change which objects are dualizable. So even a
$\Phi_\alpha$ whose factors were made composable would have to re-establish
$\Phi_{\mathrm{tr}}$'s hypotheses **after every recut**, at every ordinal stage — and the
ladder of §C iterates $\Phi_\alpha$ transfinitely. That is a real obligation on the ordinal
ladder that the ladder's own triage (§J4, "notation awaiting content") does not mention.

**Verdict §6: OPEN — and this is the sharpest thing in the section.** What settles it: a
statement of the common category on which all four factors act, together with proofs that
(i) $\Phi_{\mathrm{cut}}$'s output is monoidal, (ii) $\Phi_{\mathrm{refl}}$ has a functorial
action on it at all rather than on theories alone, (iii) $Z(-)$ of it is ribbon (§2.3), and
(iv) the relevant objects are rigidly dualizable (§6.2). Absent (i)–(iv), $\Phi_\alpha$ is a
juxtaposition of four operations written with a $\circ$.

---

## 7. Prior art — what was actually read this pass

Read directly, as HTML, this session:

- **nLab, "cyclic category"** — $\Delta\hookrightarrow\Lambda$ faithful;
  $\operatorname{Aut}_\Lambda([n])=\mathbb Z/(n{+}1)$; unique factorisation
  $f=\tau_n^{f(0)}g$; self-duality. Connes 1983. *(Used in §4.1.)*
- **nLab, "cyclic set"** — the $\infty$-action of $S^1$ on the realization of a cyclic set,
  attributed there to Moerdijk 1996 ("Cyclic sets as a classifying topos") and Drinfeld 2003.
  *(Used in §3.2, §4.1.)*
- **nLab, "trace of a category"** — $\int^{c\in\mathrm{Ob}(C)}F(c,c)$ for an endoprofunctor;
  $\int^c\hom(c,c)$ for the identity; the quotient description with $f\circ g\sim g\circ f$.
  *(Used in §5.2 — this page is the whole of §5's proof.)*
- **nLab, "Drinfeld center"** — half-braidings; $Z(\mathcal C)$ "is naturally a braided
  monoidal category"; braiding $b_{(X,\Phi),(Y,\Psi)}=\Psi_X$. *(Used in §2.1, §2.4.)*
- **nLab, "spherical category"** — spherical = pivotal with left and right traces coinciding
  on all objects; explicitly *not* automatic in a pivotal category. *(Used in §2.2.)*
- **nLab, "traced monoidal category"** — Joyal–Street–Verity axioms (tightening, sliding,
  vanishing, strength); braiding **not** required for a traced structure, with yanking
  $\operatorname{Tr}^X(\beta_{X,X})=\mathrm{id}_X$ added when a braiding is present;
  $\mathrm{Int}(\mathcal C)$ as the free compact-closed completion. *(Consulted; it is the
  reason §1.3 does **not** cite traced monoidal categories as $\Phi_{\mathrm{tr}}$'s home —
  a JSV trace is a partial-trace operator $\mathcal C(A\otimes X, B\otimes X)\to\mathcal C(A,B)$,
  not a rotation-invariant scalar on a string of 1-cells.)*
- **Wikipedia, "Cyclic homology"** — the cyclic operator
  $a_1\otimes\cdots\otimes a_n\mapsto(-1)^{n-1}a_n\otimes a_1\otimes\cdots\otimes a_{n-1}$;
  Connes' categorical route via cyclic objects; the $(b,B)$-bicomplex; the Hochschild–cyclic
  periodicity sequence. *(Used in §4.1.)*
- **ar5iv HTML of Ponto–Shulman, "Shadows and traces in bicategories" (arXiv 0910.1306)** —
  **front matter only**. The rendering served abstract and introduction; the numbered
  definitions did not come through. What I take from it and nothing more: shadows are "a type
  of structure we can impose on a bicategory which enables us to define traces therein", and
  "there is a unique notion of trace which is additive and cyclic". The shadow axioms in
  §1.3(b) are from the standard statement, **not** from a source read in full this pass.

**No PDF was decoded.** Barr (Chu / $*$-autonomy), Connes 1983, Moerdijk 1996 and Drinfeld
2003 are cited at second hand from the HTML pages named above, and §6.2's $*$-autonomy fact
is not sourced this pass at all — see the ground cap there.

Internal prior art checked before writing: `notes/OWNER_TRANSMISSIONS_LEDGER.md` (§4.9–§4.13,
§5, §6, §7 read in full; §6.2 is the licence for this note's existence),
`notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md` (density/codensity — distinguished in
§5.1), and a repository-wide grep for ज्ञेयम, $\Phi_{\mathrm{tr}}$ and *codensity*, which
returns only the ledger, message 0758, and the density note.

---

## 8. Scope limits and honesty ledger

1. **§1.3(b)'s shadow axioms are quoted from the standard statement, not from a read source.**
   §1–§6 depend only on the *existence* of the cyclicity isomorphism, not on its coherence
   axioms. If the axioms differ from my statement, §1's verdict (CLASSICAL) is unaffected.
2. **§6.2 is capped.** It asserts an obligation, not a failure. See the cap in place.
3. **§2.3's repair is minimal-sufficient, not minimal.** Spherical fusion $U$ suffices for
   $Z(U)$ ribbon; I do not claim it is necessary, and I did not read a source for the
   modularity theorem (Müger) this pass — it is named as the classical case only.
4. **Nothing here is machine-checked.** No Agda or Lean was authored; there is no toolchain
   in this container. No Python was written or run.
5. **The $L_{ij}$ typing of §1.1 is a reading.** The transmission does not say $L_{ij}$ is a
   1-cell $j\to i$; it is the only reading under which §D's own displayed string composes,
   and the opposite convention gives the mirror statement with the same verdicts. Flagged
   because ledger §6.7 records that three of the corpus's sharpest results rest on readings
   the fleet supplied and the transmissions did not, and this is another one.
6. **My own concluding generalisation (below) is subject to audit.**

---

## 9. Concluding generalisation, offered as such

The ledger's one-line summary of the night was that the transmissions' *non-implications*
hold up and their *implications* are where the errors are. $\Phi_{\mathrm{tr}}$ adds a third
category, and it is neither: **its errors are in the places where a symbol is reused across
two settings in which it means different things.** $\vee$ is Chu transpose in §E and must be
a rigid dual in §D (§6.2). $\simeq$ is a property in one reading and an unpaid coherence
datum in another (§3). $\operatorname{Tr}$ names a scalar on a string in §D and a coend on
the identity in §I, which is fine — they *are* the same functor (§5) — but that agreement is
a theorem the transmission does not notice it is asserting. And $\circ$ in
$\Phi_{\mathrm{tr}}\circ\Phi_{\mathrm{ctr}}\circ\Phi_{\mathrm{refl}}\circ\Phi_{\mathrm{cut}}$
denotes composition of four operations with four different domains (§6.1).

The generalisation, stated so it can be refuted: **in this framework, notation collision is
a better predictor of defect than logical overreach.** The test that would refute it is a
defect in a §D/§I-adjacent claim that arises from a genuinely false implication between two
unambiguously typed statements. I did not find one this pass; I looked in §2, and what I
found there (§2.3) is a *missing hypothesis*, and in §2.4 a *vacuous clause* — both failures
of type-bookkeeping rather than of inference.

---

*seed167, 2026-08-15. Verdicts: §1 CLASSICAL · §2 REFUTED-as-written (repair named) ·
§2.4 REFUTED · §3 PARTIAL (halves named) · §4 CLASSICAL · §5 PROVED (classical) ·
§6 OPEN (settlement conditions named).*
