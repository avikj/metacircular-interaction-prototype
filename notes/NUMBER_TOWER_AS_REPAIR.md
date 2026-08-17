# The number tower is not an instance of the four repair modes

*Adjudication of `collab/upstream/raw/D0020-owner-fifth-transmission-2026-08-15.md` §1's tower
$\aleph\subset\zeta\subset\vartheta\subset\varrho\subset\chi$ against its own triage §J2, which
asserts the tower is "the first concrete instance of the repair-mode theory —
$\Gamma_\varnothing$ performed by coefficient enlargement, which `notes/FOUR_REPAIR_MODES.md`
proved is what $\Gamma_{\widehat{\phantom X}}$ actually is, and which
`notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` proved is universal on structural defects by
Shapiro", and which explicitly invites either outcome: "if it does not, the theory is wrong
somewhere."*

*The tower, the four displayed defects, the slogan
$\mathrm{असमर्थता}\xrightarrow{\Gamma}\mathrm{विस्तृतलोकः}$, and the standard applied here —
**समता प्रमाणेन, साम्येन न**, equality by proof not by resemblance (§5) — are the owner's.
The verdicts, theorems and refutations below are this note's.*

Seed 181, 2026-08-15.

---

## 0. Verdict table

| step | transmission's displayed defect | is it an instance of one of the four modes? | what it actually is |
|---|---|---|---|
| $\aleph\subset\zeta$ | $3-5\notin\aleph$ | **no** — no group, no coefficient module, no cocycle (Thm 1) | group completion; initial object of a solution category (Thm 2) |
| $\zeta\subset\vartheta$ | $1\div2\notin\zeta$ | **no**, same failure | localisation; **the same construction as step 1** (Thm 3) |
| $\vartheta\subset\varrho$ | $\xi^2=2$ | **no**, and the display is **wrong about its own target**: $\xi^2=2$ repairs to $\vartheta(\sqrt2)$, never to $\varrho$ (Thm 4) | metric/order completion; and by Ostrowski the repair is **not unique** (Thm 5) |
| $\varrho\subset\chi$ | $\xi^2=-1$ | **no**, and it is a *different shape* from 1–3, provably in two ways (Thms 6, 7) | root adjunction = algebraic closure by accident of $\varrho$ (Thm 8) |

**Headline.** The correspondence J2 proposes is a **relabelling**, and the mode-hypothesis that
fails is the first one: the four modes are operations on a **1-cocycle $D\in Z^1(\Gamma,V)$**, and
in none of the four tower steps does a $\Gamma$, a $V$, or a $D$ exist prior to the repair. §J2's
supporting ground is worse than its claim: Shapiro's lemma is a statement about
$H^1(\Gamma,\operatorname{Coind}V)$ and has no bearing whatever on $3-5\notin\mathbb N$.

**But the tower is not empty of content**, and two of its steps supply the corpus with the best
instances it has of results it had only argued for:

- Step 3 gives the D0019 §B guard "$D_X\not\Rightarrow$ a single cause" a *classical theorem* as
  witness: **Ostrowski** (Thm 5). The completion defect of $\mathbb Q$ has one repair per place —
  $\mathbb R$ and every $\mathbb Q_p$ — pairwise non-isomorphic. `EIGHT_CLASSES` Thm 6.1 proved
  non-uniqueness with a degenerate example ($\Gamma'=1$); here it is a theorem of number theory.
- Step 4 is the **only non-rigid step**, and this is exactly the "chosen lift" that
  `FOUR_REPAIR_MODES.md` Thm 3 identified as the missing datum (Thm 6). Parallel, not instance —
  I say why in §4.3.

**Scope limit up front:** everything below is standard algebra and standard number theory, proved
from definitions where a proof is three lines and quoted by name where it is a named theorem
(Ostrowski, Artin–Schreier, fundamental theorem of algebra, Artin's construction of algebraic
closures). Nothing computed; no Agda, no Lean, no Python, nothing typechecked.

---

## 1. The mode-hypothesis, and where it fails

`FOUR_REPAIR_MODES.md` §1 fixes the setting before it fixes the modes: a group $\Gamma$, an
abelian $\Gamma$-module $V$, and a **defect** $\delta$ = a cocycle $D\in Z^1(\Gamma,V)$ arising as
$D_\gamma=f|\gamma-f$ for an $f$ in a larger ambient carrying the $\Gamma$-action. Every one of
the four modes takes this as input:

- $\Gamma_\circlearrowleft$ is $Z^1\to H^1$ — needs $Z^1$;
- $\Gamma_{\widehat{\phantom X}}$ is $f\mapsto f+R$ with $\partial R=-D$ — needs $\partial$ and $D$;
- $\Gamma_\varnothing$ is the choice of an enlargement $V\to V'$ or a quotient of $H^1$ — needs $V$;
- $\Gamma_\Uparrow$ needs an equation between 1-cells in an ambient admitting enrichment.

The note states this as scope limit in its §0 and `EIGHT_CLASSES` restates it as its scope limit
(i). It is not an incidental hypothesis: it is the hypothesis on which Thms 1–6 of that note and
Thms 3.1–3.5 of its successor are proved.

### Theorem 1 (no tower step presents a cocycle)

*In each of the four steps, the datum supplied by the transmission is a set $A$ (a monoid, a ring,
a field), an equation $E$ with parameters in $A$, and the assertion $E$ has no solution in $A$.
This datum determines no group $\Gamma$ acting on $A$, no $\Gamma$-module $V$, and no
$D\in Z^1(\Gamma,V)$.*

**Proof.** A cocycle defect in the sense of §1 of `FOUR_REPAIR_MODES.md` requires three pieces of
data not present: (i) a group $\Gamma$ with (ii) an action on an abelian group $V$, and (iii) an
element $f$ of an ambient with $f|\gamma-f\in V$ for all $\gamma$. In "$3-5\notin\mathbb N$" the
only objects named are the monoid $(\mathbb N,+)$ and the pair $(3,5)$. Any $\Gamma$ and $V$ must
therefore be *supplied*, and a supplied $\Gamma$ makes the claim "this is an instance" a claim
about the supplied structure, not about the tower. $\square$

This is the whole refutation, and it is worth saying why it is not pedantry. The four modes are
distinguished from one another **by their availability hypotheses**:
$\Gamma_{\widehat{\phantom X}}$ is available iff $[D]=0$ (Thm 1 of that note),
$\Gamma_\circlearrowleft$ repairs iff $[D]=0$ (Thm 6(iii)), $\Gamma_\varnothing$ always. A
classification whose discriminating column cannot be evaluated on an instance does not classify
that instance; it names it. **That is precisely D0016 §J6's "translation is not a result."**

### 1.1 The one place in the tower where cohomology genuinely lives — and it is downstream

There *is* real group cohomology attached to the tower's top step, and locating it sharpens the
verdict rather than rescuing it. With $\Gamma=\operatorname{Gal}(\mathbb C/\mathbb R)=\mathbb Z/2$:
$H^1(\Gamma,\mathbb C^\times)=1$ (Hilbert 90) and $H^2(\Gamma,\mathbb C^\times)=\operatorname{Br}(\mathbb R)=\mathbb Z/2$,
generated by the Hamilton quaternions. So descent obstructions along $\mathbb C/\mathbb R$ *are*
cocycle defects and the four modes apply to them.

**But $\Gamma$ does not exist until the extension does.** $\operatorname{Gal}(\mathbb C/\mathbb R)$
is a product of the repair, not an input to it. So the cocycle machinery is available for defects
*relative to* a tower step already taken, and unavailable for the step itself. I record this as
the structural statement: **the four modes classify obstructions to descent along an extension;
they do not classify the construction of the extension.** The tower is the second kind of thing
throughout.

### 1.2 A second, independent failure: the mode read off is not well defined

Even granting a forced reading, the assignment is not a function of the defect.

$\mathbb Z$ is standardly built as $\mathbb N^2/\!\sim$, $\mathbb Q$ as
$(\mathbb Z\times\mathbb Z^{\ne0})/\!\sim$, and $\mathbb R$ as (Cauchy sequences)/(null sequences):
each is *literally* "pass from a representative to its class", which is $\Gamma_\circlearrowleft$'s
operation. But $\mathbb R$ is equally standardly built by Dedekind cuts, which selects a subset and
quotients nothing; and $\mathbb C$ as $\mathbb R^2$ with a multiplication, which quotients nothing
either, or as $\mathbb R[x]/(x^2+1)$, which does. So the mode one reads off changes with the
construction chosen, while the defect does not change. A classification whose value depends on the
presentation of the repair rather than on the defect is not classifying the defect.

---

## 2. Steps 1 and 2 are one step, and the shape is adjointness

What the first two steps *are* is worth stating exactly, because it is a proof and it is short.

### Theorem 2 ($\aleph\subset\zeta$ is the group completion, and it is initial)

*Let $\mathbf{CMon}$ be commutative monoids and $\mathbf{Ab}$ abelian groups, $U:\mathbf{Ab}\to\mathbf{CMon}$
the forgetful functor. The map $\eta:\mathbb N\to\mathbb Z$ is universal: for every abelian group
$G$ and monoid map $\varphi:\mathbb N\to U G$ there is a unique group map
$\bar\varphi:\mathbb Z\to G$ with $\bar\varphi\eta=\varphi$.*

**Proof.** $K(M):=(M\times M)/\!\sim$ with $(a,b)\sim(c,d)\iff\exists e:a+d+e=c+b+e$ is a group
under componentwise addition, $\eta(a)=[(a,0)]$, and $K(\mathbb N)\cong\mathbb Z$ since $\mathbb N$
is cancellative. Given $\varphi$, the only possible $\bar\varphi[(a,b)]=\varphi(a)-\varphi(b)$; it
is well defined by cancellativity of $G$ and is a homomorphism. $\square$

**So the "defect" $3-5\notin\mathbb N$ is repaired by the *initial* object of the category of
abelian groups under $\mathbb N$.** The success predicate is not "a class vanishes"; it is
"a functor is representable / an adjoint exists". Note what this buys and the four modes do not
supply: **the repair is unique up to unique isomorphism**, so there is nothing to choose. Compare
`FOUR_REPAIR_MODES.md` Thm 3, where the repair is a $V^\Gamma$-torsor and a lift *must* be chosen.

### Theorem 3 (steps 1 and 2 are the same construction, not two instances)

*Let $(M,\cdot)$ be a commutative monoid and $S\subseteq M$ a submonoid. Then
$S^{-1}M:=(M\times S)/\!\sim$, $(m,s)\sim(m',s')\iff\exists t\in S: tms'=tm's$, with
$\eta(m)=[(m,1)]$, is initial among monoid maps $M\to N$ sending $S$ into $N^\times$.
Taking $M=(\mathbb N,+)$, $S=\mathbb N$ gives $\mathbb Z$; taking $M=(\mathbb Z,\cdot)$,
$S=\mathbb Z^{\ne0}$ gives $\mathbb Q$.*

**Proof.** The verification is the standard one and identical in both instances: $\sim$ is
transitive because $S$ is multiplicatively closed; the operation is well defined; and any $f:M\to N$
inverting $S$ factors uniquely by $[(m,s)]\mapsto f(m)f(s)^{-1}$. $\square$

**Consequence, and it is a correction to the transmission's own presentation.** §1 displays four
defects and thereby four repairs. Steps 1 and 2 are **one repair applied twice**, to $(\mathbb N,+)$
and to $(\mathbb Z,\times)$. The tower has, at most, three distinct repair shapes, not four. This
is the same finding `EIGHT_CLASSES` §3.2 made about $\mathsf{Alg}$'s row (extension, localisation
and completion are one operation) — arrived at here independently and, unlike there, without a
cocycle in sight, which is itself evidence that the shared shape is adjointness and not cohomology.

---

## 3. Step 3: the display names a defect whose repair is not $\varrho$

The transmission writes the third step as $\xi^2=2\rightsquigarrow\sqrt2\in\varrho$ while
elsewhere in the same display defining $\varrho$ as $\overline{\vartheta}$, the *closure* of the
rationals. These are two different repairs of two different defects and they must not share a step.

### Theorem 4 (the displayed defect cannot produce $\varrho$)

*Let $\mathcal E$ be the set of all polynomial equations with rational coefficients, and let
$\mathbb Q^{\mathrm{alg}}$ be the field obtained by adjoining solutions of every member of
$\mathcal E$ (an algebraic closure of $\mathbb Q$). Then $|\mathbb Q^{\mathrm{alg}}|=\aleph_0<2^{\aleph_0}=|\mathbb R|$.
Hence **no** repair of defects of the displayed type — "this polynomial equation has no solution" —
yields $\mathbb R$, however often iterated.*

**Proof.** $\mathcal E$ is countable ($\mathbb Q[x]$ is countable), each member has finitely many
roots, so the set of algebraic numbers is a countable union of finite sets, hence countable; it is
infinite, so $|\mathbb Q^{\mathrm{alg}}|=\aleph_0$. Cantor gives $|\mathbb R|=2^{\aleph_0}>\aleph_0$.
$\square$

So $\varrho$ is not reached by repairing $\xi^2=2$. **The actual defect of step 3 is: a Cauchy
sequence of rationals need not converge in $\mathbb Q$** — equivalently, a bounded set need not
have a supremum. Its repair is the metric completion (or Dedekind completion), and $\mathbb R$ is
characterised by it: $\mathbb R$ is the unique Dedekind-complete ordered field up to isomorphism.
This is an **order-theoretic/topological** repair, and it is the only step of the tower that uses
data ($\le$, $|\cdot|$) not present in the pure algebra. Calling it $\xi^2=2$ hides exactly that.

The transmission's own §5 rule adjudicates this: the resemblance is that both "adjoin what is
missing"; the proof is that they differ by a cardinal.

### Theorem 5 (the completion defect has infinitely many pairwise non-isomorphic repairs — Ostrowski)

*Every nontrivial absolute value on $\mathbb Q$ is equivalent to the usual $|\cdot|_\infty$ or to
$|\cdot|_p$ for a prime $p$ (Ostrowski's theorem; quoted, not reproved). The corresponding
completions $\mathbb R,\mathbb Q_2,\mathbb Q_3,\dots$ are pairwise non-isomorphic as valued fields
(and $\mathbb R\not\cong\mathbb Q_p$ even as fields: $\mathbb Q_p$ is totally disconnected, and
$\mathbb R$ has a unique ordering while $\mathbb Q_p$ admits none for $p$ odd since $-1$ or a unit
becomes a square).*

**Consequence — this is the note's positive transfer.** D0019 §B's guard, boxed as
"$D_X\not\Rightarrow$ a single cause", and `EIGHT_CLASSES` Thm 6.1, which proved a defect can have
two slot-inequivalent repairs, both hold here with a classical theorem as witness and with a
countably infinite family rather than two: **"the rationals are incomplete" does not determine
$\mathbb R$.** $\mathbb R$ is the repair one gets by *choosing the archimedean place*, and the
choice is a datum, not a consequence. `EIGHT_CLASSES` Thm 6.1's own witness was $\Gamma'=1$, which
its author flagged as degenerate; Ostrowski is not degenerate. **I record this as the strongest
instance of the guard in the corpus, and it comes from the transmission's tower — but from the
step the transmission mislabelled.**

---

## 4. Step 4: proved to be a different shape

The task's warning is right and the difference is provable, twice, in two independent registers.

### Theorem 6 (rigidity: the tower is rigid at every step but the last)

*(i) $\operatorname{Aut}(\mathbb Z)=1$ (as a ring, hence as a group under $\mathbb N$).*
*(ii) $\operatorname{Aut}(\mathbb Q)=1$ as a field.*
*(iii) $\operatorname{Aut}(\mathbb R)=1$ as a field — no continuity assumed.*
*(iv) $\operatorname{Aut}(\mathbb C/\mathbb R)=\{\mathrm{id},\ \text{conjugation}\}\cong\mathbb Z/2\ne1$.*

**Proof.** (i) A ring map fixes $1$, hence every $n=1+\cdots+1$ and every $-n$.
(ii) Likewise fixes $\mathbb Z$, hence $a/b$.
(iii) Let $\sigma\in\operatorname{Aut}(\mathbb R)$. For $x\ge0$, $x=y^2$, so
$\sigma(x)=\sigma(y)^2\ge0$: $\sigma$ preserves $\ge$. It fixes $\mathbb Q$ by (ii). If
$\sigma(x)\ne x$ pick $q\in\mathbb Q$ strictly between them; applying $\sigma$ to the inequality
$x<q$ (or $q<x$) gives $\sigma(x)<q$ (resp. $q<\sigma(x)$), contradicting the choice of $q$. So
$\sigma=\mathrm{id}$.
(iv) $\sigma$ fixes $\mathbb R$ and permutes the roots of $x^2+1$, so $\sigma(i)=\pm i$; both
choices are ring maps. $\square$

**This is the exact sense in which the last step is not like the others.** In steps 1–3 the
repaired object has no automorphism over the defective one: the repair is unique up to *unique*
isomorphism, so "the" integers, "the" rationals, "the" reals are legitimate definite articles. In
step 4 there are two square roots of $-1$ and **no property of $\mathbb C$ distinguishes them**;
"the" imaginary unit is a choice. The transmission's display $\xi^2=-1\rightsquigarrow\iota\in\chi$
names $\iota$ as if it were determined by the repair. It is not.

### Theorem 7 (the last step is the only lossy one)

*$\mathbb N\subset\mathbb Z\subset\mathbb Q\subset\mathbb R$ are extensions of ordered structures:
the order on each extends the order on its predecessor, and each of $\mathbb Z,\mathbb Q,\mathbb R$
is an ordered ring/field. $\mathbb C$ admits **no** ordering making it an ordered field.*

**Proof.** In an ordered field every square is $\ge0$ and $-1<0$; $i^2=-1$ is then both $\ge0$ and
$<0$. $\square$

In the vocabulary of `FOUR_REPAIR_MODES.md` §1.1, whose columns are *preserves* and *destroys*:
steps 1–3 destroy nothing; step 4 destroys the order. The four modes place lossiness at
$\Gamma_\varnothing$ and losslessness at $\Gamma_{\widehat{\phantom X}}$ (§1.1's note that only
$\Gamma_\circlearrowleft$ and $\Gamma_{\widehat{\phantom X}}$ cost nothing). J2 assigns *all four*
steps to the same mode. Theorem 7 says any assignment sending all four to one mode is wrong on the
lossiness column alone, whichever mode is chosen.

### Theorem 8 (closure versus root-adjunction: the coincidence special to $\varrho$)

*(a) $\mathbb C=\mathbb R[x]/(x^2+1)$: adjoining one root of one polynomial.
(b) $\mathbb C$ is algebraically closed (fundamental theorem of algebra; quoted).
(c) These coincide only by (b). For $\mathbb Q$ they do not: $\mathbb Q(\sqrt2)$ is not
algebraically closed ($x^2-3$ has no root in it, since $\sqrt3\notin\mathbb Q(\sqrt2)$).
(d) By Artin–Schreier, if $C$ is algebraically closed and $1<[C:F]<\infty$ then $[C:F]=2$ and $F$
is real closed (quoted). Hence the step $\mathbb R\subset\mathbb C$ **terminates**: there is no
proper finite algebraic extension of $\mathbb C$, and no room for a further step of the same kind.*

**Proof of (c).** $[\mathbb Q(\sqrt2):\mathbb Q]=2$ and $\sqrt3\in\mathbb Q(\sqrt2)$ would give
$\sqrt3=a+b\sqrt2$, so $3=a^2+2b^2+2ab\sqrt2$, forcing $ab=0$; $b=0$ gives $\sqrt3\in\mathbb Q$ and
$a=0$ gives $3=2b^2$, both impossible over $\mathbb Q$. $\square$

**Reading.** Three of the tower's steps are *unbounded in principle and stopped by fiat*:
adjoining $\sqrt2$ does not exhaust the algebraic defects of $\mathbb Q$, and the general repair —
an algebraic closure — needs Zorn (Artin's construction; and existence of algebraic closures is
not a theorem of ZF), and is unique only up to **non-unique** isomorphism. The tower's last step
looks canonical only because $\mathbb R$ is real closed, so one root of one equation closes
everything. **That is a theorem about $\mathbb R$, not a property of the repair mode.** Reading
$\varrho\subset\chi$ as "the same enlargement as the others, once more" imports that theorem
silently — which is exactly the failure D0016 §J6 names.

### 4.3 What the last step *does* share with the proved theory — stated as a parallel, not an instance

`FOUR_REPAIR_MODES.md` Thm 3: the set of completions is empty or a torsor under $V^\Gamma$; hence
"$X$ known $+$ $D$ known $\Rightarrow\widehat X$ reconstructible" is **false** without a chosen
lift, and *"the" completion is a definition and not a theorem*.

Theorem 6(iv) is the same sentence about $\mathbb C$: the set of solutions of $\xi^2=-1$ in
$\mathbb C$ is a torsor under $\operatorname{Aut}(\mathbb C/\mathbb R)=\mathbb Z/2$, and "the"
imaginary unit is a definition, not a theorem. And Theorem 5 is the same sentence about $\mathbb R$
with $\operatorname{Aut}$ replaced by the set of places.

**I decline to call either an instance.** Thm 3's torsor group is $V^\Gamma$, the invariants of a
coefficient module of a cocycle; here it is a Galois group, and no $V$ exists (Thm 1). What is
shared is a *proposition schema* — **repairs of a defect form a torsor under the automorphisms of
the repaired object fixing the defective one, so the repair is canonical iff that group is
trivial** — which is provable directly, in one line, in any category, and which subsumes Thm 3 as
the special case where the objects are cocycle-completions. That schema, and not $\Gamma_\varnothing$,
is what the tower instantiates.

**Proposition 9 (the schema).** *Let $\mathcal C$ be a category, $X\in\mathcal C$, and let
$\mathcal S$ be the category of repairs of a defect of $X$ (objects: pairs $(Y,\iota:X\to Y)$
solving the defect; morphisms: maps under $X$). If $\mathcal S$ has an initial object $Y_0$, then
$\operatorname{Aut}_{\mathcal S}(Y_0)=1$ and $Y_0$ is unique up to unique isomorphism. Conversely
if some repair $Y$ has $\operatorname{Aut}_{\mathcal S}(Y)\ne1$ then $Y$ is not initial.*
**Proof.** Initial objects have only the identity endomorphism (any endo equals the unique map),
and two initial objects are uniquely isomorphic. $\square$

Applied: $\mathbb Z,\mathbb Q$ are initial (Thms 2, 3) and rigid (Thm 6 i–ii); $\mathbb R$ is
initial *once a place is fixed* and rigid (Thm 6 iii) but the place is a choice (Thm 5); $\mathbb C$
**is** initial among $\mathbb R$-algebras with a *chosen* square root of $-1$, and is not initial
among $\mathbb R$-algebras in which $x^2+1$ merely has a root, which is why Thm 6(iv) is nonzero.
**The chosen lift of `FOUR_REPAIR_MODES.md` Thm 3 is, here, literally the choice of $i$.**

---

## 5. What §J2 asked, answered

> "The number tower is therefore a test case with a known answer: does the proved theory classify
> these four extensions correctly? If it does, that is confirmation on an independent instance; if
> it does not, the theory is wrong somewhere."

**Neither disjunct holds, and the dichotomy is the thing to reject.** The theory does not classify
them, and the theory is *not* thereby wrong: it is correctly scoped, and both source notes state
the scope in their §0. `FOUR_REPAIR_MODES.md` §4.3 already found and reported the same boundary
from the other side — the shifted-prime barrier, where "the classification does not apply" because
the defect is a magnitude, not a class. The number tower is a **second** kind of defect outside the
scope, and a more interesting one than a magnitude, because it is perfectly structural and still
not cohomological:

> **The four modes classify obstructions living in a fixed ambient. The tower's defects are
> obstructions to the ambient's *existence*, and their repairs are universal constructions. The
> discriminating datum is a universal property, not a cohomology class.**

`EIGHT_CLASSES` §4's slot language, if forced on the tower, mislocates it a second way: what is
enlarged in $\mathbb N\subset\mathbb Z$ is the **object** slot $\mathcal X$, not the coefficient
slot $\mathcal R$. J2's phrase "coefficient enlargement" is wrong even on its own reading, since
there are no coefficients. And the invocation of Shapiro is empty: Thm 3.3 of that note takes
$D\in Z^1(\Gamma,V)$ as input and produces $\operatorname{Coind}_1^\Gamma V$. With no $\Gamma$ and
no $V$ there is nothing to coinduce.

---

## 6. Prior art

Searched before writing; no fetch performed. Everything in §§2–4 is classical and I claim no
novelty for any of it:

- Group completion / Grothendieck group of a commutative monoid; localisation of a commutative
  monoid and of a ring: Bourbaki, *Algèbre* I; Atiyah–Macdonald Ch. 3. The observation that
  $\mathbb N\to\mathbb Z$ and $\mathbb Z\to\mathbb Q$ are one construction is textbook.
- The characterisation of $\mathbb R$ as the unique Dedekind-complete ordered field, and of the
  completion as a reflection: standard analysis.
- Ostrowski's theorem: Cassels, *Local Fields*, Ch. 2. The reading "the completion defect of
  $\mathbb Q$ has one repair per place" is the standard adelic viewpoint.
- Rigidity of $\mathbb R$ ($\operatorname{Aut}(\mathbb R)=1$) is a classical exercise; the proof in
  Thm 6(iii) is the usual one.
- Artin–Schreier: Lang, *Algebra*, VI §2. Existence of algebraic closure via Zorn: Artin's
  construction, Lang V §2; its non-provability in ZF is a known independence result, **quoted, not
  verified here**.
- The framing "a number system is what you get by repairing an inability" is Klein's and Dedekind's
  and is not new to the transmission; the transmission's contribution is the compression into one
  display, and I treat the display as the owner's presentation, not as a claim of priority.

**What is new here is only the adjudication**: that the tower is not cohomological (Thm 1), that
steps 1–2 are one construction (Thm 3), that the displayed step-3 defect cannot reach $\mathbb R$
(Thm 4), that the tower is rigid except at the top (Thm 6), and that these facts are jointly
incompatible with a single-mode assignment.

---

## 7. Queue

1. **`PROVE`** — Proposition 9 makes "repair is canonical iff $\operatorname{Aut}$ is trivial" a
   schema strictly containing `FOUR_REPAIR_MODES.md` Thm 3. Is the containment strict in a useful
   direction — i.e. is there a corpus defect where the schema decides and Thm 3 does not apply?
   Thm 5 (Ostrowski) and Thm 6(iv) are two; a third would justify promoting the schema.
2. **`PROVE`** — `EIGHT_CLASSES` §9.2 asks what operation fills the flow slot $\mathcal P$. The
   tower suggests a different gap: **universal-construction repairs fill none of the six slots of
   $\mathfrak U$**, because they change the ambient rather than a slot of it. If that is right,
   $\mathfrak U$ needs a seventh component or the slot theory needs a stated domain.
3. **`SEARCH`** — Prior art for classifying repairs by *universal property* rather than by which
   structure moves; the obvious place is the theory of reflective subcategories and of
   Kan-extension-shaped completions, and nothing was fetched.
4. **`PROVE`** — D0020 §J1's $\mathfrak{sl}_2$ action on the divisor lattice remains the
   transmission's one exactly-checkable claim and is untouched here.

## 8. Honesty ledger

- Nothing computed. No Python, no numerics, no fitted quantity, no correlation. No Agda or Lean
  authored; nothing claimed typechecked.
- **Grounds by strength.** Thms 1, 2, 3, 4, 6, 7, 8(c) and Prop 9 are proved here from definitions
  and I stand behind them. Ostrowski (Thm 5), the fundamental theorem of algebra (8b),
  Artin–Schreier (8d), Artin's construction and the ZF-independence of algebraic closure are
  **quoted from standard statements, not re-read tonight**; each is used only in the direction in
  which it is unambiguous. Hilbert 90 and $\operatorname{Br}(\mathbb R)=\mathbb Z/2$ (§1.1) are
  quoted the same way and are not load-bearing — §1.1's conclusion follows from Thm 1 alone.
- **Second-hand readings, marked.** `notes/ATLAS_OF_N.md`, `notes/ACTION_RESIDUAL_FORMATION.md`,
  `notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` and `notes/SEED64_BOUNDARY_FACTORIZATION_AT_U2.md`
  are known to me only through `FOUR_REPAIR_MODES.md` §4 and `EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md`;
  I did not open them and no argument above depends on them. `FOUR_REPAIR_MODES.md` and
  `EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md` themselves were read **in full** and their Thms 1–6 and
  3.1–3.5 re-derived where used.
- **On the archive (standing check).** D0020 states up front that its transcription is
  structurally faithful but **not display-complete**, with `[…run…]` markers where displays were
  dropped. §1 carries such a marker immediately after the tower display. **I therefore report that
  the tower's four defect-arrows as transcribed may not be all the owner transmitted, and I do not
  conclude from the absence of further displays.** Every verdict above is against the four arrows
  *as transcribed*; a fuller display could change step 3's reading in particular, since the
  transcription contains both $\xi^2=2$ and $\varrho=\overline\vartheta$ and Thm 4 shows these
  cannot both describe one repair.
- **On the prompt (standing check).** The task described the tower as "naturals, integers,
  rationals, reals, complex — check the transmission's own reading". Checked: the transmission's
  §1 states exactly this parenthetically, and additionally glosses $\varrho$ as
  $\overline\vartheta$. The gloss is the load-bearing discrepancy of §3 and would have been missed
  had I taken the prompt's list as the scope.
- **On the concluding generalisation.** §5's boxed statement — that the four modes classify
  obstructions in a fixed ambient while the tower's are obstructions to the ambient — is offered at
  exactly the generality of the four instances examined plus Thm 1's definitional observation. It
  is not proved for all universal constructions and I do not claim it is.

*Credit: the tower, its four defect-arrows, the slogan
$\mathrm{असमर्थता}\xrightarrow{\Gamma}\mathrm{विस्तृतलोकः}$, the test-case framing of §J2, and the
standard **समता प्रमाणेन, साम्येन न** are the human owner's (D0020 §1, §5, §J2). The four repair
modes are the owner's (D0018 §B) as made precise in `notes/FOUR_REPAIR_MODES.md`. This note
supplies the refutation, the four theorems separating the steps, the Ostrowski reading of the
guard, and the schema of Prop 9.*
