# The eight defect-cause classes collapse to four slots — and the guard survives

*Derived from the human owner's transmission `collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md`
§B, and its triage §J3, which records a **prediction to be tested, not assumed**: that the eight
classes $\mathsf{Top},\mathsf{Alg},\mathsf{Geom},\mathsf{Stat},\mathsf{Comp},\mathsf{Sem},\mathsf{Diag},\mathsf{Phys}$
collapse to fewer. The eight names, the response column, the equations
$D_X=\operatorname{cofib}(\eta_X)$, $\Gamma=\Gamma_{\operatorname{Class}(D)}$, the guard
$D_X\not\Rightarrow$ a single cause, and the universal object
$\mathfrak U=(\mathcal X,\mathcal O,\mathcal R,\mathcal P,\mathcal C,\mathcal Q)$ of §A are the
owner's. What is below is proof, refutation and scope-fixing for them. Nothing here restates the
transmission as a result (D0019 §J9).*

Seed 162, 2026-08-15.

---

## 0. What is settled here

| claim | status |
|---|---|
| the eight rows are operations | **refuted**: six of the eight rows name 2–3 distinct operations, and one ($\mathsf{Phys}$) names a discipline (§2) |
| $\mathsf{Alg}$'s extension / localization / completion are one operation | **proved** (Lemma 3.1 + Thm 3.2): all three are $f_*$ for a map of coefficient systems, and Thm 2 of `FOUR_REPAIR_MODES.md` needs only chain-map-ness, not injectivity |
| $\mathsf{Geom}$'s "connection" is not a $\mathsf{Geom}$ move | **proved** (§2.3): a connection is a choice of $R$ with $\partial R=-D$, i.e. $\Gamma_{\widehat{\phantom X}}$ |
| $\mathsf{Phys}$'s "symmetry enlargement" is not a repair at all | **proved** (Thm 3.5): inflation is injective, so enlarging the symmetry group along a quotient can never kill a class |
| $\mathsf{Geom}$'s "cover" has a *quantified* availability hypothesis | **proved** (Thm 3.4): a finite cover of index $n$ repairs $[D]$ only if $n[D]=0$ |
| coefficient enlargement is **universal** on structural defects | **proved** (Thm 3.3, via Shapiro): every cocycle defect dies in some enlarged module |
| $\mathsf{Comp}$'s "resource extension" is not an operation on the defect | **proved-by-definition** (§2.5): it enlarges $\mathrm{Rep}$, not the object |
| the collapse relation | 8 classes → **4 surviving**, representatives $\mathsf{Alg},\mathsf{Geom},\mathsf{Stat},\mathsf{Diag}$ (§4) |
| witnesses | **exhibited for all four**, and shown exclusive (§5); $\mathsf{Top},\mathsf{Comp},\mathsf{Sem},\mathsf{Phys}$ have none |
| §J3's own reason for expecting $\mathsf{Stat}$ to collapse | **refuted** (§5.3): it is wrong *in variance*; $\mathsf{Stat}$ survives, but not for the reason J3 gives, and not against it either |
| the guard $D_X\not\Rightarrow$ a single cause | **upheld, and proved** (Thm 6.1): every torsion structural defect has two slot-inequivalent valid repairs |
| classification is determined on a proper subclass | **proved** (Prop 6.2): for non-torsion purely-structural defects the slot is unique |
| the eight extend D0018's four | **refuted** (§7): $\Gamma_\Uparrow$ has no representative among the eight; the successor list *drops* a mode |

**Scope limits, up front.** (i) Everything proved lives at the level of 1-cocycles with coefficients
in an abelian $\Gamma$-module, exactly as in `FOUR_REPAIR_MODES.md`; the $\mathsf{Stat}$, $\mathsf{Sem}$
and $\mathsf{Diag}$ arguments are outside that setting and are proved or argued at the generality
stated in each place, which is lower. (ii) The collapse criterion of §3.0 is mine, not the owner's,
and the whole quotient is relative to it; I state it before using it and I apply it uniformly, which
is the only defence available. (iii) Standard facts used (transfer, inflation–restriction, Shapiro,
conservativity of definitional extensions) are textbook and are **quoted from the standard
statements, not re-read tonight**; where a three-line proof exists I give it rather than lean on the
citation. (iv) No Agda or Lean authored, nothing typechecked, nothing computed. (v) D0019 §C's
$\rho(D\mathcal K)$ and D0018 §J5's $\chi_\alpha$ are flagged fitted-quantity hazards and are
untouched.

---

## 1. Verification of the two results I am told to rely on

Standing check (b), and §J3 makes both load-bearing. I read both notes in full and re-derive the two
statements actually used.

**1.1 `FOUR_REPAIR_MODES.md` Thm 2 ($\Gamma_{\widehat{\phantom X}}$ is $\Gamma_\varnothing$ bought
honestly). Verified — and it proves more than it states.** The proof is: $\iota:V_0\to V$ is a map of
$\Gamma$-modules, hence induces a chain map on cochains commuting with $\partial$, hence
$\iota_*[D]_{V}=[\iota D]$; combined with Thm 1 ($\widehat f$ exists iff the class is zero) this gives
the statement. **Nowhere is injectivity of $\iota$ used.** I record this because §3.1 needs the
non-injective case and I do not want to be quoting a hypothesis I then quietly drop — the hypothesis
$V_0\hookrightarrow V$ in the note's statement is inert in its proof, and I re-prove the general form
as Lemma 3.1 rather than assert that the note covers it.

**1.2 `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm A + Cor A.1 (all four modes have success
predicate "membership in a distinguished singleton"; hence no mode acts on a quantitative defect
except $\Gamma_\varnothing$ by fiat). Verified.** The four cases are read off `FOUR_REPAIR_MODES.md`
§1.1 and each is correct: $\Gamma_{\widehat{\phantom X}}$'s domain is $B^1$, the fibre of $[\cdot]$
over $0$; $\Gamma_\varnothing$'s codomain is $\{0\}$; $\Gamma_\circlearrowleft$ is total as a map but
repairs iff the class is $0$; $\Gamma_\Uparrow$'s success at each level is "the obstruction is the
distinguished element". I use Cor A.1 only for $\mathsf{Comp}$ (§2.5) and I use the phrase it
supplies — *adjoining a hypothesis that asserts the unattained value* — as the definition it is.

**1.3 What I checked and found needs saying.** Seed 156's ledger records that its Thm C leans on
seed 152's Cor 2.2, and that seed 159 re-derived Cor 2.2 with a refinement: **the displayed formula
of Cor 2.2 is a non-implication, and Thm C needs the positive monotonicity stated only in its
prose.** I read that ledger entry and I inherit the refinement rather than the display: below, when I
say "observables are tests and enlarging them can only reveal", the ground is
$\operatorname{Obs}_S\subseteq\operatorname{Obs}_{S'}$ for $S\subseteq S'$ — a one-line set inclusion
— and not the non-implication. This matters at §5.3, where the variance is the whole argument.
*This is exactly the mandate's warning instance: a flagged dependency whose consumer needed an
implication where the source displayed a non-implication. It has already been repaired upstream; I
am quoting the repaired form.*

---

## 2. The eight, as operations. Six of the rows are lists.

The template is `FOUR_REPAIR_MODES.md` §1.1: (domain, codomain / operation, availability hypothesis,
success predicate, cost). A row of D0019 §B is an *operation* only if these five can be filled in
without branching. Filling them in is the first finding, and it is negative.

### 2.1 $\mathsf{Top}$ — cell attachment

- **domain** a space $X$ with a distinguished class $\alpha\in\pi_n(X)$ (or a group with a
  distinguished element $g$).
- **operation** $X\mapsto X\cup_\alpha e^{n+1}$; on $\pi_1$ this is
  $\Gamma\mapsto\Gamma/\langle\!\langle g\rangle\!\rangle$.
- **availability** none: a cell can always be attached.
- **success** $j_*\alpha=0$ in $\pi_n(X\cup e)$ — automatic.
- **cost** unbounded and undisplayed: $\pi_{n+1}$ and everything above it change, and new classes
  appear (this is the whole content of obstruction theory). Cell attachment is *always available and
  never free*.

This is a single operation. **It acts on the base/object slot**, in the quotient direction.

### 2.2 $\mathsf{Alg}$ — extension / **localization** / **completion**

Three operations by name, as §J3 says. Written out:

| name | operation | availability | cost |
|---|---|---|---|
| extension | $V\to V'$, an injection of coefficient systems | $\iota_*[D]=0$ | the invariant $[D]_V$ is no longer visible in $V'$ |
| localization | $V\to S^{-1}V$ | $[D]$ dies after inverting $S$ | $S$-torsion information is destroyed; the map is **not injective** |
| completion | $V\to\widehat V$ ($I$-adic), or $f\mapsto f+R$ (the D0018 sense) | $[D]\mapsto 0$ | the ambient changes |

§3 proves these are one operation. Note already that the D0018 sense of "completion"
($\Gamma_{\widehat{\phantom X}}$: add a correction term to the *object*) and the $\mathsf{Alg}$ sense
($I$-adic completion of the *coefficients*) are different acts that Thm 2 of `FOUR_REPAIR_MODES.md`
identifies — the object-level correction exists precisely when the coefficient-level image dies. The
row's word "completion" is therefore doing two jobs, and both land in the same class.

### 2.3 $\mathsf{Geom}$ — **connection** / cover / resolution

Also three, and one of them is misfiled.

- **connection.** A connection is a choice of horizontal lift; the failure it repairs is that nearby
  fibres are not canonically identified, and the repair is a chosen splitting. In the cocycle
  language: a connection is an $R$ with $\partial R=-D$. **That is $\Gamma_{\widehat{\phantom X}}$
  verbatim** (`FOUR_REPAIR_MODES.md` Thm 1), and by Thm 1 its availability is $[D]=0$, and by Thm 3
  its non-uniqueness is a $V^\Gamma$-torsor — which is exactly the affine space of connections. So
  "connection" belongs to the $\mathsf{Alg}$ class, not to $\mathsf{Geom}$; the geometric clothing is
  the bundle, not the operation. *Ground: Thm 1 and Thm 3 of the predecessor, both re-derived in
  seed 156 §1.1, which I read.*
- **cover.** $\Gamma'\le\Gamma$, restrict. Acts on the base slot. Availability is **not** free —
  Thm 3.4 below.
- **resolution.** $\pi:\widetilde X\to X$ with $\widetilde X$ smooth, pull back. Acts on the base
  slot. Availability: existence of a resolution (a theorem, not a check).

So $\mathsf{Geom}$ = one class-of-operations on the base slot (cover, resolution) plus one item that
is $\mathsf{Alg}$'s.

### 2.4 $\mathsf{Stat}$ — sufficient-statistic enlargement

- **domain** an object $x$ together with an observation map (statistic) $T:\mathrm{Ob}\to S$.
- **defect** $T$ is not sufficient: the likelihood does not factor as $h(x)g(T(x),\theta)$;
  equivalently a square fails to commute.
- **operation** $T\rightsquigarrow T'=(T,\text{residual})$ into a larger $S'$.
- **success** $T'$ sufficient — an equality of the factorisation, a *unilateral* certificate in the
  sense of `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Criterion 2.2.2.
- **cost** every downstream statement is now about the finer statistic; the coarse summary is no
  longer adequate, and the minimal sufficient statistic may be as large as the sample.

One operation, cleanly. **It acts on the observable slot, in the *enlarging* direction** — and §5.3
shows this is the reason it does not collapse, and the reason §J3's stated reason for expecting it to
collapse is wrong.

### 2.5 $\mathsf{Comp}$ — **oracle** / **resource** extension

Two, and they are of different kinds.

- **oracle.** Adjoin $A$; work in the relativised model. This is exactly Cor A.1's *"adjoining a
  hypothesis that asserts the unattained value"* — with, in the honest version, the hypothesis
  displayed as a named oracle rather than smuggled. That is $\Gamma_\varnothing$ in its honest form,
  which by `FOUR_REPAIR_MODES.md` Thm 2 is $\Gamma_{\widehat{\phantom X}}$ at an enlarged coefficient
  system. Relativisation *is* the enlargement. So $\mathsf{Comp}$(oracle) $\in\mathsf{Alg}$'s class.
- **resource.** Allow time $t'>t$. This changes neither the object nor the defect: it changes
  $\mathrm{Rep}$, the set of values counted as repaired. Under
  `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Def 4.0.1 it fails clause (i) outright — it is not a
  partial operation on defect-carrying data. **It is moving the goalposts, and it should be recorded
  as such rather than as a mode.** (That it is often the *right* thing to do — the time hierarchy
  theorem says the goalposts genuinely move — is not in dispute; it is still not an operation on the
  defect.)

### 2.6 $\mathsf{Sem}$ — new sign / new type / new context

Three names, one operation: a morphism of signatures $\Sigma\to\Sigma'$ (adding a constant, a sort,
or a parameter is the same act at three arities). Availability: the extension must exist. Success: a
term now denotes the object. Cost: possible loss of **conservativity** — new theorems in the old
language. Acts on the language slot.

### 2.7 $\mathsf{Diag}$ — meta-level ascent

$T\mapsto T'\supseteq T+\mathrm{Con}(T)$, or object-language $\mapsto$ metalanguage. Availability:
the ascent must be expressible (Gödel coding). Success: the undecided sentence is decided. Cost:
$T'$ is again incomplete, so **the repair regenerates a defect of the same kind** — the only row of
the eight with that property. Acts on the language slot.

### 2.8 $\mathsf{Phys}$ — state-space / symmetry / field enlargement

Three names, and this row is not an operation but a **discipline**: it names *where physicists have
historically found the enlargement*, not what the enlargement does.

- **state-space enlargement** (add hidden variables, pass to phase space, enlarge the Hilbert space):
  this is coefficient/ambient enlargement, $\mathsf{Alg}$'s operation with a physical ambient.
- **field enlargement** (add a field to the Lagrangian): likewise.
- **symmetry enlargement**: Thm 3.5 proves this is **not a repair at all** — it can only reveal.
  What physicists actually do under this name is symmetry *reduction* (quotient by a gauge group),
  which is $\Gamma_\circlearrowleft$, or symmetry *breaking*, which is a base-slot move.

**Row-level verdict.** Of eight rows, one ($\mathsf{Top}$) is a single operation; four
($\mathsf{Alg},\mathsf{Geom},\mathsf{Comp},\mathsf{Phys}$) are lists containing items belonging to
different classes; two ($\mathsf{Sem},\mathsf{Stat}$) are single operations under several names; one
($\mathsf{Diag}$) is a single operation. **The table is a list of exemplars, not a classification of
operations.** Everything below is about what remains after the rows are split into operations.

---

## 3. The collapse relation, proved

### 3.0 The criterion (stated before use, applied uniformly)

**Definition 3.0.1.** Two operations $\Gamma_A,\Gamma_B$ **collapse**, written $\Gamma_A\equiv\Gamma_B$,
iff there is a single schema $\Gamma$ and a parameter $p$ such that $\Gamma_A=\Gamma(p_A)$ and
$\Gamma_B=\Gamma(p_B)$, where the schema is:

> **Transport.** Given a defect $D$ valued in a functor $F$ of the ambient $\mathfrak A$, and a
> morphism $\varphi:\mathfrak A\to\mathfrak A'$, output $F(\varphi)(D)$. Success: $F(\varphi)(D)=0$.

and where $p_A,p_B$ differ only in *which morphism* is chosen inside *the same slot* of the ambient.
**Differing costs do not block a collapse**: this is forced on me by the corpus precedent —
`FOUR_REPAIR_MODES.md` Thm 2 declares $\Gamma_{\widehat{\phantom X}}$ and $\Gamma_\varnothing$ not
independent although one amputates and the other enlarges. I apply that precedent in both variables,
which is the point at which uniformity has teeth: it forces $\mathsf{Top}$ (quotient in the base
slot) and $\mathsf{Geom}$'s cover (subobject in the base slot) into one class, exactly as it forces
$\mathsf{Alg}$'s extension (injection) and localization (non-injection) into one class.

**Definition 3.0.2 (the witness test).** A class **survives** iff there is a defect it repairs that
no other surviving class repairs. A class with no such witness is not a class.

Note the two are independent grounds for dissolving a row: Def 3.0.1 dissolves by *proved identity of
operation*; Def 3.0.2 dissolves by *absence of an exclusive member*. §4 uses the first, §5 the second,
and I keep them apart in the reporting.

### 3.1 Lemma (transport in the coefficient slot needs no injectivity)

*Let $\varphi:V\to W$ be a map of $\Gamma$-modules and $D\in Z^1(\Gamma,V)$. Then
$\varphi\circ D\in Z^1(\Gamma,W)$ and $[\varphi\circ D]=\varphi_*[D]$, where
$\varphi_*:H^1(\Gamma,V)\to H^1(\Gamma,W)$ is a group homomorphism.*

**Proof.** $\varphi$ is additive and $\Gamma$-equivariant, so
$\varphi(D_{\gamma\gamma'})=\varphi(D_\gamma|\gamma')+\varphi(D_{\gamma'})=(\varphi D)_\gamma|\gamma'+(\varphi D)_{\gamma'}$,
so $\varphi D$ is a cocycle; and $\varphi(\partial R)=\partial(\varphi R)$, so coboundaries go to
coboundaries and $\varphi_*$ is well defined and additive. $\square$

No injectivity, no surjectivity, no flatness. This is what makes the next theorem possible.

### 3.2 Theorem ($\mathsf{Alg}$ is one operation)

*Extension, localization and completion are the single operation "apply $\varphi_*$ for a chosen map
of coefficient systems $\varphi$", with success predicate $\varphi_*[D]=0$. They differ only in the
choice of $\varphi$: an injection, the localization map $V\to S^{-1}V$, and the completion map
$V\to\widehat V$ respectively.*

**Proof.** Each of the three is a map of $\Gamma$-modules (localization and completion are functorial
and the $\Gamma$-action is by module maps, so they are $\Gamma$-equivariant); Lemma 3.1 applies to
each without further hypothesis; and by `FOUR_REPAIR_MODES.md` Thm 1 applied in the target, the
object-level repair exists iff the image class vanishes. So all three fill the same five template
columns with only $\varphi$ varying. $\square$

**Consequence for §J3.** The prediction "$\mathsf{Alg}$'s list contains three operations by name" is
correct as a reading of the row and is **resolved in the direction J3 expected**: the three are one.
What J3 did not say, and what Lemma 3.1 supplies, is *why* — the row's three names are three sources
of $\varphi$, and the operation never inspects $\varphi$ beyond its being a map of coefficients.

### 3.3 Theorem (the coefficient slot is universal on structural defects)

*Let $\Gamma$ be a group, $V$ a $\Gamma$-module, $D\in Z^1(\Gamma,V)$. There is an injection of
$\Gamma$-modules $\varphi:V\hookrightarrow W$ with $\varphi_*[D]=0$.*

**Proof.** Take $W=\operatorname{Coind}_1^\Gamma V=\operatorname{Map}(\Gamma,V)$, into which $V$
embeds $\Gamma$-equivariantly by $v\mapsto(\gamma\mapsto\gamma v)$. Shapiro's lemma gives
$H^1(\Gamma,\operatorname{Coind}_1^\Gamma V)\cong H^1(1,V)=0$ (standard; Brown, *Cohomology of
Groups*, III.6.2 — quoted, not re-read tonight). So *every* class dies in $W$, in particular
$[D]$. $\square$

**Reading, and it is a caution rather than a triumph.** Coefficient enlargement always succeeds, and
the maximal version of it succeeds by killing *everything*: it is $\Gamma_\varnothing$ at full
strength, with the killing datum honestly displayed. So "$\mathsf{Alg}$ is available" carries no
information; what carries information is *which* enlargement, and how much of $H^1$ survives it.
Thm 3.3 is therefore the precise sense in which the $\mathsf{Alg}$ row of §B is not a *cause* of
anything: it is the default, available for every structural defect whatever caused it. **A
classification whose second row applies to every member of its domain is not classifying by that
row.**

### 3.4 Theorem (the base slot, subgroup direction: a quantified availability hypothesis)

*Let $\Gamma'\le\Gamma$ of finite index $n$, and $D\in Z^1(\Gamma,V)$. If
$\operatorname{res}^\Gamma_{\Gamma'}[D]=0$ then $n[D]=0$. Hence passing to a finite cover of degree
$n$ can repair only classes annihilated by $n$.*

**Proof.** $\operatorname{cor}\circ\operatorname{res}=n$ on $H^*(\Gamma,V)$ for $[\Gamma:\Gamma']=n$
(the transfer; standard, Brown III.9.5 — quoted, not re-read). Apply both sides to $[D]$: if
$\operatorname{res}[D]=0$ then $n[D]=\operatorname{cor}(0)=0$. $\square$

**This is the first genuine obstruction to collapse in the note**, and it is worth saying why. Thm 3.3
says the coefficient slot has *no* availability hypothesis. Thm 3.4 says the base slot has a sharp
one. Two operations with the same schema but availability hypotheses that are not merely different
but *of different logical type* — vacuous versus a torsion condition — are not the same operation
under any reading of Def 3.0.1, because the availability column is part of the template. So
$\mathsf{Alg}\not\equiv\mathsf{Geom}$, proved.

### 3.5 Theorem ($\mathsf{Phys}$'s symmetry enlargement is not a repair)

*Let $N\trianglelefteq G$ act trivially on $V$, and let $\Gamma=G/N$. Then inflation
$\operatorname{inf}:H^1(\Gamma,V)\to H^1(G,V)$ is injective. Hence enlarging the symmetry group from
$\Gamma$ to $G$ never kills a nonzero class.*

**Proof.** Direct, no exact sequence needed. Let $D\in Z^1(\Gamma,V)$ with
$\operatorname{inf}(D)=\partial R$ for some $R\in V$, i.e. $D_{gN}=R|g-R$ for all $g\in G$. Taking
$g=n\in N$: $D_{N}=D_{1_\Gamma}=0$, so $R|n-R=0$ for all $n\in N$, i.e. $R\in V^N=V$ (which is
automatic here) and, more to the point, $R|g$ depends only on $gN$. Hence $\gamma\mapsto R|\gamma-R$
is a well-defined coboundary on $\Gamma$ equal to $D$. So $[D]=0$ in $H^1(\Gamma,V)$. $\square$

**Reading.** This is the exact dual of `FOUR_REPAIR_MODES.md` Cor 2.2's coefficient half. Widening
*coefficients* can kill (Thm 3.3); widening *symmetry* cannot (Thm 3.5); widening *observables* can
only reveal (Cor 2.2's prose half, verified by seed 159). Three widenings, three different
variances — and D0019 §B's $\mathsf{Phys}$ row puts one of each in a single cell under the single
word "enlargement". **That is the sharpest single defect in the eight-way table and I state it as
the note's principal negative.**

---

## 4. The quotient: four slots

Splitting the rows (§2) and applying Def 3.0.1 with Thms 3.2–3.5:

| slot of $\mathfrak U$ | operations landing there | representative | availability |
|---|---|---|---|
| **base / object** ($\mathcal X$) | $\mathsf{Top}$ cell attachment (quotient direction); $\mathsf{Geom}$ cover (subobject direction), resolution; $\mathsf{Phys}$ symmetry reduction | $\mathsf{Geom}$ | quantified: $n[D]=0$ for a degree-$n$ cover (Thm 3.4) |
| **coefficient / value** ($\mathcal R$) | $\mathsf{Alg}$ extension, localization, completion; $\mathsf{Geom}$ connection; $\mathsf{Comp}$ oracle; $\mathsf{Phys}$ state-space and field enlargement | $\mathsf{Alg}$ | vacuous — always available (Thm 3.3) |
| **observable / test** ($\mathcal O$) | $\mathsf{Stat}$ sufficient-statistic enlargement (and, in the opposite direction, smoothing / averaging / norm change / range restriction — `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm C) | $\mathsf{Stat}$ | the enlargement must be admissible |
| **language / meta** ($\mathcal Q$) | $\mathsf{Sem}$ new sign / type / context; $\mathsf{Diag}$ meta-level ascent | $\mathsf{Diag}$ | the ascent must be codeable |
| — *rejected, not an operation* | $\mathsf{Comp}$ resource extension (§2.5: enlarges $\mathrm{Rep}$) | — | — |
| — *refuted, not a repair* | $\mathsf{Phys}$ symmetry enlargement (Thm 3.5) | — | — |

The slots are not imposed: they are four of the six components of the owner's own $\mathfrak U$
in §A. That the classification of *responses* in §B is indexed by the components of the *object* in
§A is, I think, the structural content of §B, and it is not visible in the eight-row form.

**8 → 4**, with two items rejected outright. The choice of representative is stated in §5.

---

## 5. The witness test. Four survive; four do not.

Def 3.0.2 is the decisive test and it is applied to each of the eight.

### 5.1 $\mathsf{Alg}$ **survives.** Witness: a non-torsion class.

Take $\Gamma=\mathbb Z$, $V=\mathbb Z$ trivial action. $H^1(\mathbb Z,\mathbb Z)=\operatorname{Hom}(\mathbb Z,\mathbb Z)=\mathbb Z$;
let $[D]$ be a generator.

- **base slot cannot repair it.** Every finite-index subgroup is $n\mathbb Z$; by Thm 3.4, killing
  $[D]$ by restriction requires $n[D]=0$, impossible in $\mathbb Z$. Infinite-index subgroups of
  $\mathbb Z$ are trivial, and restricting to the trivial subgroup is not a cover but the total
  collapse of the base — allowed formally, and its cost is that *nothing at all survives*, so it
  repairs nothing selectively. Inflation cannot help (Thm 3.5).
- **observable slot cannot repair it.** Enlarging tests only reveals (Cor 2.2, prose half); the
  restricting direction is $\Gamma_\varnothing$ on tests (`QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md`
  Thm C), i.e. concealment, not repair.
- **language slot cannot repair it.** The defect is decided and expressible: $[D]\ne0$ is a theorem
  of the ambient. There is nothing for an ascent to decide.
- **coefficient slot repairs it.** $\mathbb Z\hookrightarrow\operatorname{Map}(\mathbb Z,\mathbb Z)$,
  Thm 3.3. (Concretely and more usefully: the *corpus* instance is the Eichler period cocycle, nonzero
  in $H^1(\mathrm{SL}_2(\mathbb Z),V_{k-2})$ and killed by enlarging to smooth functions —
  `FOUR_REPAIR_MODES.md` Cor 2.1. That instance carries the same conclusion by the same argument
  once one knows the class has infinite order, which follows from Eichler–Shimura's identification of
  the cohomology with a space of cusp forms; **I have that statement at second hand through that
  note's §3 and I do not re-assert it as read.** The $\mathbb Z$ witness needs no literature and is
  the one I stand behind.)

**Exclusive. $\mathsf{Alg}$ survives.**

### 5.2 $\mathsf{Geom}$ **survives.** Witness: a defect not valued in any coefficient module.

Take $X$ a variety with a singular point, and the defect "$X$ is not smooth". Or, purely
group-theoretically: $X$ a space with $\pi_1(X)\ne1$ and the defect "$X$ is not simply connected".

- **coefficient slot cannot repair it.** There is no coefficient module in the datum. Thm 3.3 has no
  purchase: its input is a cocycle, and a singularity is not a cocycle. (This is
  `FOUR_REPAIR_MODES.md` §4.3's observation used in the opposite direction: there, a defect with no
  cocycle home defeated all four modes; here, a defect with no cocycle home is exactly what defeats
  the universal coefficient move and lets the base move be exclusive.)
- **observable and language slots cannot repair it.** Neither changes $X$.
- **base slot repairs it.** Resolution $\widetilde X\to X$; universal cover $\widetilde X\to X$.

**Exclusive. $\mathsf{Geom}$ survives**, and it absorbs $\mathsf{Top}$ (§5.5).

### 5.3 $\mathsf{Stat}$ **survives — and §J3's reason for expecting it not to is wrong.**

Witness: an insufficient statistic. $T$ loses information about $\theta$; the repair is to refine $T$
to $T'$ until the likelihood factors, the coarsest such $T'$ being the minimal sufficient statistic.

- **coefficient slot cannot repair it**: the defect is not a class in a module; it is the failure of
  a factorisation through $T$.
- **base slot cannot repair it**: the underlying object is not at fault; a finer *observation* is
  needed, and the sample space is unchanged.
- **the corpus instance is `notes/ACTION_RESIDUAL_FORMATION.md` §2**, as read through
  `FOUR_REPAIR_MODES.md` §4.2 (and I mark that as second-hand): the refined observable
  $(q,\delta_p)$ makes the failed square commute and is proved *coarsest*. That is a minimal
  sufficient statistic in all but name, and it is the corpus's own $\mathsf{Stat}$ move.

**Now the correction.** §J3 predicts $\mathsf{Stat}$ collapses because "sufficient-statistic
enlargement is a *test-set* move already shown to be $\Gamma_\varnothing$ or $\Gamma_\circlearrowleft$
on the observable field." **That inference is wrong, and wrong in variance.** Thm C of
`QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` classifies exactly two directions of test-family change:
*restriction* (fewer tests, $\Gamma_\varnothing$) and *quotient* (tests identified,
$\Gamma_\circlearrowleft$). Its proof says in terms:
$\Gamma_{\widehat{\phantom X}}$ "has no observable-field analogue **because enlarging the tests can
only reveal**". Enlargement is therefore the one direction Thm C explicitly *excludes* from its
classification — and $\mathsf{Stat}$ is enlargement. So Thm C does not cover $\mathsf{Stat}$, and
citing it to collapse $\mathsf{Stat}$ inverts its content.

**What is true instead, and it is the reason the observable slot needs its own class:** the two
directions of observable change repair *different defects*. Restriction conceals an obstruction that
is really there (dishonest unless displayed). Enlargement repairs *insufficiency* — the defect
"my tests do not separate what I need separated" — for which restriction is exactly the wrong move.
A slot with two directions repairing two incomparable defect-types is not reducible to either.

**Exclusive. $\mathsf{Stat}$ survives — but I record that it survives against J3's prediction, and
that J3's prediction failed on a variance error, not on a matter of taste.** (Standing check (a):
the mandate relayed J3's reasoning as an instrument. It is not usable as one. I checked it rather
than used it, which is what (a) asks.)

### 5.4 $\mathsf{Diag}$ **survives, and it absorbs $\mathsf{Sem}$.**

Witness: the Gödel sentence $G_T$ of a consistent r.e. theory $T$ extending arithmetic.

- **$\mathsf{Sem}$ cannot repair it, provably.** An extension by definitions — the paradigm
  "new sign / new type" move — is **conservative** over $T$ (standard; Shoenfield, *Mathematical
  Logic* §4.6, quoted not re-read). A conservative extension proves no new theorems in the language
  of $T$, and $G_T$ is in the language of $T$. So no amount of new vocabulary decides it.
- **the coefficient, base and observable slots cannot repair it**: $G_T$ is not a cocycle, not a
  property of a space, and not a statistic.
- **$\mathsf{Diag}$ repairs it**: $T'=T+\mathrm{Con}(T)$ decides $G_T$.

**Exclusive. $\mathsf{Diag}$ survives.**

**And $\mathsf{Sem}$ does not.** By Def 3.0.2 $\mathsf{Sem}$ needs a defect *it* repairs and the other
survivors do not. Its candidates are expressibility defects — the object has no name; two objects
share a name; the owner's own §D case where $A\to B\to C$ and $A\to C$ give different meanings and the
language has no sign for the difference. In every such case the metalanguage already contains a name
for both the object language's terms and their interpretations (that is what Gödel coding *is*), so
the ascent supplies the missing distinction. The domination is one-directional: $\mathsf{Diag}$
covers $\mathsf{Sem}$'s witnesses, $\mathsf{Sem}$ provably does not cover $\mathsf{Diag}$'s
(conservativity). **$\mathsf{Sem}$ dissolves into $\mathsf{Diag}$.**

*Ground, stated at the generality I can defend (standing check (d)): the conservativity half is a
theorem and I assert it. The domination half — every expressibility defect is repaired by ascent —
is an argument from the universality of coding, not a theorem; it is the weakest link in the note,
and if it fails then $k=5$ with $\mathsf{Sem}$ readmitted. I have not found a counterexample and I
have not proved there is none. A defect of pure notation that survives ascent would refute it.*

### 5.5 The four that do not survive

- **$\mathsf{Top}$: no exclusive witness.** Every witness for cell attachment is a base-slot defect,
  and $\mathsf{Geom}$'s cover/resolution act on the same slot. Cell attachment is the quotient
  direction, cover is the subobject direction. By the uniformity clause of Def 3.0.1 — which I am
  bound to by the corpus precedent that injection and quotient in the *coefficient* slot are one
  operation (`FOUR_REPAIR_MODES.md` Thm 2, Thm 6) — the two directions in the base slot are likewise
  one class. *Dissolved by Def 3.0.1, uniformly applied.* Had I allowed the cost difference to split
  the base slot, I would have had to un-collapse $\Gamma_\varnothing$ from
  $\Gamma_{\widehat{\phantom X}}$ as well, and the predecessor's headline result with it.
- **$\mathsf{Comp}$: no exclusive witness, and half of it is not an operation.** Oracle extension is
  the $\mathsf{Alg}$ operation with the computational ambient as coefficients (§2.5, via Cor A.1);
  resource extension enlarges $\mathrm{Rep}$ (§2.5) and fails clause (i) of Def 4.0.1. *Dissolved by
  Def 3.0.1 and by rejection.*
- **$\mathsf{Sem}$: dominated by $\mathsf{Diag}$** (§5.4). *Dissolved by Def 3.0.2.*
- **$\mathsf{Phys}$: not an operation.** A discipline naming three moves that land in three different
  places, one of which (symmetry enlargement) is proved to be no repair (Thm 3.5). *Rejected as a
  row; its parts redistributed.*

### 5.6 The quotient, reported

**Eight collapse to four: $\mathsf{Alg}$ (coefficient slot), $\mathsf{Geom}$ (base slot),
$\mathsf{Stat}$ (observable slot), $\mathsf{Diag}$ (language slot). Each has an exclusive witness,
exhibited above. $\mathsf{Top}$, $\mathsf{Comp}$, $\mathsf{Sem}$ and $\mathsf{Phys}$ have none.**

---

## 6. The guard. It is right, and it is provable.

D0019 §B boxes $D_X\not\Rightarrow$ a single cause. This is the substantive claim in §B and, unlike
the eight-way table, it survives.

### Theorem 6.1 (torsion structural defects have two slot-inequivalent valid repairs)

*Let $\Gamma$ be a finite group, $V$ a $\Gamma$-module, $[D]\in H^1(\Gamma,V)$ nonzero of order
$m$. Then:*
*(a) there is a coefficient injection $V\hookrightarrow W$ with $[D]\mapsto0$ (a valid $\mathsf{Alg}$
repair);*
*(b) there is a subgroup $\Gamma'\le\Gamma$ of index annihilating $[D]$ with
$\operatorname{res}[D]=0$ (a valid $\mathsf{Geom}$ repair);*
*and the two repairs are not related by any morphism of the ambient — they change different slots and
produce non-isomorphic repaired data.*

**Proof.** (a) Thm 3.3. (b) Take $\Gamma'=1$: $H^1(1,V)=0$, so $\operatorname{res}[D]=0$, and
$[\Gamma:1]=|\Gamma|$ annihilates $H^1(\Gamma,V)$ (standard: $|\Gamma|$ kills $H^n(\Gamma,-)$ for
$n\ge1$, by $\operatorname{cor}\circ\operatorname{res}=|\Gamma|$ with $\Gamma'=1$ and $H^1(1,V)=0$
— note this is Thm 3.4 read in the other direction and needs no separate citation). The repaired data
in (a) is $(\Gamma,W)$ with the base fixed and the coefficients enlarged; in (b) it is $(1,V)$ with
the coefficients fixed and the base collapsed. A morphism of ambients carrying one to the other would
have to be simultaneously the identity and not on each slot. $\square$

**A concrete corpus instance rather than the degenerate one.** The carry cocycle of
`notes/ATLAS_OF_N.md` §2.11: $c_n\in Z^2(\mathbb Z/b^n;\mathbb Z/b)$, whose class the corpus records
as the open question and whose group is $H^2(\mathbb Z/m;A)\cong A/mA$ for trivial action.

- **$\mathsf{Alg}$ repair:** embed $\mathbb Z/b\hookrightarrow\mathbb Q/\mathbb Z$. Since
  $\mathbb Q/\mathbb Z$ is divisible, $(\mathbb Q/\mathbb Z)/m(\mathbb Q/\mathbb Z)=0$, so
  $H^2(\mathbb Z/b^n;\mathbb Q/\mathbb Z)=0$ and every carry class dies. *And this is not an artifice:
  enlarging the digit module until carrying is a coboundary is precisely what redundant and signed
  digit representations do, which is why they carry in bounded depth.*
- **$\mathsf{Geom}$ repair:** restrict to a subgroup of index annihilating the class — work at a
  coarser modulus.

Two genuinely different, both-valid repairs, in two different slots, with different mathematics
downstream. **The guard is upheld: $\operatorname{Class}$ is not a function of $D$.**

### Proposition 6.2 (but classification *is* determined on a proper subclass)

*Let $D$ be a purely structural defect (a cocycle, with no observable or language content) whose class
has infinite order, in a group with no infinite-index proper subgroup usable as a cover. Then the only
slot in which $D$ is repairable is the coefficient slot.*

**Proof.** Base slot: excluded by Thm 3.4 (finite covers need $n[D]=0$) and Thm 3.5 (inflation is
injective). Observable slot: excluded by monotonicity — enlarging tests reveals, restricting conceals
(Cor 2.2's prose half + Thm C). Language slot: excluded because the defect is decided and expressible
by hypothesis. Coefficient slot: available by Thm 3.3. $\square$

§5.1's $\mathbb Z$ witness satisfies the hypotheses.

### 6.3 What this does to §C's arrow

D0019 §C displays $D\to\operatorname{Class}(D)\to\operatorname{UniversalityTest}(D)\to\Gamma(D)$ as a
chain of maps. Thm 6.1 says the first arrow is **not a map**: $\operatorname{Class}$ is set-valued.
This is not a defect of §C but a consequence of §B's own guard, which §C's arrow notation silently
contradicts. The repaired reading is
$$
D\ \longrightarrow\ \operatorname{Class}(D)\subseteq\{\text{slots}\},\qquad
\Gamma(D)\ \text{a choice of element of that set, with its cost}
$$
and Prop 6.2 identifies a subclass on which the set is a singleton and the arrow is a map after all.
**Standing check (e), applied to my own statement:** what I have shown is that the *forward*
implication $D\Rightarrow$ a set of slots holds and that the set is not always a singleton. I have
*not* shown that every subset of slots is realised, and I do not claim it.

---

## 7. The eight are not a superset of the four

$\Gamma_\Uparrow$ — categorify; replace the failed equation by a 2-cell — has **no representative
among the eight**. Checking row by row: $\mathsf{Top}$ attaches a cell to a space, which changes the
homotopy type, not the level of the equation; $\mathsf{Alg}$, $\mathsf{Geom}$, $\mathsf{Stat}$,
$\mathsf{Comp}$, $\mathsf{Phys}$ all transport a defect along a morphism inside a fixed level;
$\mathsf{Sem}$ and $\mathsf{Diag}$ change the language, and ascending from a theory to its
metatheory is not the same as ascending from an equation to a 2-cell (the metatheory of a 1-category
is not a 2-category).

In the slot language of §4, $\Gamma_\Uparrow$ is the operation on the **coherence slot** $\mathcal C$
of $\mathfrak U$ — the one slot of the owner's own §A tuple that has no row in §B. (The remaining
slot, $\mathcal P$, the change flow, likewise has none.)

**So D0019 §B is not a refinement of D0018 §B.** It replaces four modes by eight exemplars of which
four survive as classes, and in doing so it loses the one mode whose cost `FOUR_REPAIR_MODES.md` §1.2
singled out as unbounded. I record this flatly because the triage's framing — "extends D0018 §B from
four modes to eight classes" — invites the reading that the eight contain the four, and they do not.

**Honest count, therefore: five classes, of which four come from the eight and one must be readmitted
from D0018.**

---

## 8. Prior art

Searched before writing, and I state exactly what I did: **no fetch was performed tonight**; this is a
statement of where the frame sits, from standard knowledge, offered so a later reader can check it
rather than as a literature claim.

- The schema of §3.0 — *a defect is transported along a morphism of the ambient and repair is the
  vanishing of the image* — is **functoriality of an obstruction theory**, and is not new. Its two-variable
  form for group cohomology (covariant in coefficients, contravariant in the group) with
  restriction/corestriction/inflation is Brown, *Cohomology of Groups*, III.8–III.10.
- The specific asymmetries proved here (Thms 3.3, 3.4, 3.5) are all standard facts; **what is not
  standard, and is the note's contribution, is using their differing *availability types* — vacuous,
  torsion-conditional, impossible — as the criterion separating classes of repair.**
- Nearest frame for classifying *responses* rather than obstructions: Lawvere/Kelly change-of-base
  for indexed categories, of which §3.0's schema is a special case; and Tao's soft/hard cut, already
  located by `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` §4.3 for the orthogonal question.
- I did not find, and did not search systematically for, prior art on the *eight-fold* list itself; it
  reads as the owner's own synthesis and I treat it as such.

## 9. Queue

1. **`PROVE`** — §5.4's weak link: is every expressibility defect repaired by meta-level ascent? A
   defect of pure notation surviving ascent readmits $\mathsf{Sem}$ and makes $k=5$ (six with
   $\Gamma_\Uparrow$).
2. **`PROVE`** — The coherence slot $\mathcal C$ and the flow slot $\mathcal P$ have no class in §B.
   $\Gamma_\Uparrow$ fills $\mathcal C$ (§7). **What operation fills $\mathcal P$?** If none exists,
   the slot indexing of §4 is incomplete as a theory of $\mathfrak U$ and should be said to be a
   theory of four slots, not six.
3. **`PROVE`** — Thm 6.1 gives two slots for torsion defects and Prop 6.2 gives one for non-torsion.
   Is there a defect with **three** valid slot-inequivalent repairs? If the maximum is two, the guard
   has a sharp form.
4. **`SEARCH`** — Prior art for "classify repairs by which slot of the ambient they move". The obvious
   places are indexed/fibred category theory and the deformation-theory literature on obstruction
   functors; nothing was fetched tonight.

## 10. Honesty ledger

- Nothing computed. No Python, no numerics, no fitted constant, no correlation. D0019 §C's
  $\rho(D\mathcal K)$ and D0018 §J5's $\chi_\alpha$ are untouched and remain flagged.
- No Agda or Lean authored; nothing claimed typechecked.
- **Grounds, by strength.** Thms 3.1, 3.2, 3.5, 6.1(b-mechanism) and Prop 6.2 are proved here from
  definitions and I stand behind them. Thms 3.3 and 3.4 rest on Shapiro's lemma and the transfer
  identity $\operatorname{cor}\circ\operatorname{res}=n$, which are textbook and which I **quote from
  the standard statements without re-reading a source tonight**; both are used only in the direction
  in which they are unambiguous. §5.4's conservativity of extensions by definitions is quoted the
  same way. §5.4's domination half is an argument, not a theorem, and is flagged as the note's
  weakest link in place.
- **Second-hand readings, marked.** The Eichler instance (§5.1), `ACTION_RESIDUAL_FORMATION.md`
  (§5.3) and `ATLAS_OF_N.md`'s carry cocycle (§6.1) are read through `FOUR_REPAIR_MODES.md` §3, §4.2
  and §4.1 respectively. I did not open those files and I do not assert their theorems; where the
  argument needs the fact rather than the citation, I supply an independent witness that needs
  neither ($\mathbb Z$ in §5.1; the $\mathbb Q/\mathbb Z$ divisibility computation in §6.1, which is
  self-contained given $H^2(\mathbb Z/m;A)\cong A/mA$ for trivial action).
- **On the mandate's instruments (standing check (a)).** Both were checked rather than used. The
  $\mathsf{Alg}$ instrument (Thm 2 of the predecessor) is correct and in fact stronger than stated
  (§1.1). The $\mathsf{Stat}$ instrument (that Thm C already covers sufficient-statistic enlargement)
  is **wrong in variance** and §5.3 says why; had I used it, I would have collapsed a class that
  survives.
- **On the concluding generalisation (standing check (f)).** "Eight collapse to four, indexed by the
  slots of $\mathfrak U$" is offered at exactly this generality: it is relative to Def 3.0.1 (mine),
  it is proved for the base and coefficient slots by Thms 3.3–3.5 in the cocycle setting only, and
  it is argued rather than proved for the observable and language slots, whose defects are not
  cocycles and for which I have no common formalism. A reader who wants the result in one setting
  will have to supply that formalism, and §9.2 is where it would be tested first.
- **Not comparable to another pass's numbers.** The "four" of this note counts *classes of repair
  operations*; seed 156's counts are *corpus queue items*, and seed 152's "four modes" are the
  D0018 list. No number here is comparable to a number there.

---

## 11. Reader's addendum — full-read draw 5

*Added by Claude (Opus lineage), 2026-08-15, as part of the fifth random full-read draw
(`notes/FULL_READ_DRAW_5.md`, where this file was index 2320 of a 2900-entry frame). **Addition
only: no line above this section was altered, replaced or removed.** The note was read in full;
several things I would have flagged, §10 flags first, and this addendum only records what survives
that self-audit. Full statements are at `notes/FULL_READ_DRAW_5.md` §1.D.*

**Verified sound, by reading:** §1.1's claim that `FOUR_REPAIR_MODES.md` Thm 2 nowhere uses
injectivity of $\iota$ — correct, both directions go through for any map of $\Gamma$-modules;
§5.3's quotation of D0019 §J3 — verbatim accurate (raw file, lines 647–657), and its refutation
of J3 stands; Thm 3.3's Shapiro argument; Thm 3.5's proof as stated.

**D1 (structural, unresolved — the author's call, not a reader's). The trivial subgroup is
disqualified in §5.1 and load-bearing in §6.1.** §5.1 excludes $\Gamma'=1$ as "not a cover but the
total collapse of the base … repairs nothing selectively", in order to make $\mathsf{Alg}$'s
$\mathbb Z$ witness exclusive. Thm 6.1(b)'s proof then reads "Take $\Gamma'=1$" and calls it a
valid $\mathsf{Geom}$ repair. Both cannot stand. If $\Gamma'=1$ is valid, it also repairs §5.1's
$\mathbb Z$ class ($H^1(1,\mathbb Z)=0$), so $\mathsf{Alg}$ has no exclusive witness and by
Def 3.0.2 does not survive — the count becomes $8\to3$. If it is not valid, Thm 6.1(b) is unproved
and, for $\Gamma=\mathbb Z/p$ with $V=\mathbb Z/p$ trivial, unprovable: the only subgroups are $1$
and $\Gamma$, $H^1=\operatorname{Hom}(\mathbb Z/p,\mathbb Z/p)\neq0$, and
$\operatorname{res}^\Gamma_\Gamma[D]=[D]\neq0$. The guard itself is probably safe — §6.1's
$\mathbb Q/\mathbb Z$ carry-cocycle instance argues it better than the theorem does — but Thm 6.1
needs either a non-degeneracy hypothesis on $\Gamma'$ or an explicit ruling that base-collapse
counts as a repair, and §5.1 must then pay for that ruling.

**D2.** Prop 6.2's hypothesis "no infinite-index proper subgroup **usable as a cover**" is
undefined in the note, and "§5.1's $\mathbb Z$ witness satisfies the hypotheses" holds only under
the reading D1 shows is unavailable — $\mathbb Z$ has the infinite-index proper subgroup $1$.

**D3 (false ground, true verdict).** Thm 3.4's discussion concludes
$\mathsf{Alg}\not\equiv\mathsf{Geom}$ on the ground that "the availability column is part of the
template". Def 3.0.1 mentions only schema, parameter, slot and morphism, and states in bold that
differing *costs* do not block a collapse; the five-column template is §2's, not Def 3.0.1's. The
ground is unlicensed — and unnecessary, since Def 3.0.1 requires the two morphisms to lie in *the
same slot*, and coefficient $\neq$ base gives the verdict in one line.

**D4 (implication upgraded in a table cell).** Thm 3.4 proves necessity only
($\operatorname{res}[D]=0\Rightarrow n[D]=0$), and §0's row says so ("*only if*"). §4's table fills
the *availability* column with "quantified: $n[D]=0$ for a degree-$n$ cover", which reads as the
condition for availability. It is not: $n[D]=0$ does not produce a subgroup of index $n$ with
vanishing restriction. Nothing downstream breaks — §5.1 uses the correct direction — but §4 is
where a later reader will quote it from.

**D5 (§0 refuted by §5.4).** §0's witnesses row asserts flatly that
$\mathsf{Top},\mathsf{Comp},\mathsf{Sem},\mathsf{Phys}$ "have none". §5.4 and §10 both say the
$\mathsf{Sem}$ half is "an argument, not a theorem … the weakest link", with $k=5$ if it fails. The
hedge is in the body twice and in the summary table zero times.

**D6 (the headline number).** §0, the title and §5.6 carry **four**; §7 carries "**Honest count,
therefore: five classes**". §7 explains the difference and is right to; but it appears once, at the
end, uncross-referenced from any of the three places carrying 4 — the same mechanism §7 itself
complains about upstream.

**D7 (scope dropped from the principal negative).** Thm 3.5 proves inflation
$H^1(G/N,V)\to H^1(G,V)$ is injective: enlargement **along a quotient**. §0's row keeps that
qualifier; §2.8, §3.5's Reading, §4's rejection row and §5.5 all drop it and say flatly that
symmetry enlargement "is not a repair at all" / is "proved to be no repair", and §3.5 calls it "the
note's principal negative". The other reading — $\Gamma\le G$, the physicist embedding a symmetry
group in a larger one — is not covered and cannot be by this theorem: for a subgroup inclusion
there is no canonical $H^1(\Gamma,V)\to H^1(G,V)$ at all, so the defect does not transport and the
question is a different one. Whether *that* enlargement is also a non-repair is open.

**D8 (header claims more than theorem, in a word §5.2 redefines).** §3.3's header says "universal
on **structural** defects"; the theorem is about $Z^1(\Gamma,V)$, and §0's row is careful ("every
**cocycle** defect"). §5.2 then uses "structural" for defects that are explicitly not cocycles
("a singularity is not a cocycle") — and needs Thm 3.3 to fail on them for $\mathsf{Geom}$'s
witness to be exclusive. Under §5.2's sense of the word, §3.3's header is false, and its falsity is
what §5.2 requires.

**D9 (undischarged half of the concrete instance).** §6.1's carry cocycle sits in $H^2$ while
Thm 6.1 is stated for $H^1$; the $\mathsf{Alg}$ half is re-proved self-containedly and is fine. The
$\mathsf{Geom}$ half is one unproved clause — "restrict to a subgroup of index annihilating the
class — work at a coarser modulus" — with no subgroup exhibited and no index computed, inheriting
D1. So §6.1's "two genuinely different, both-valid repairs" is asserted where one of the two is
unverified.

*Reader's scope: I did not open `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm C,
`ATLAS_OF_N.md` §2.11 or `ACTION_RESIDUAL_FORMATION.md` §2; D4 and D9 rest on this note's own
statements and on the cohomological algebra, not on those sources. Nothing was computed.*

---

*Credit: the eight classes, their response column, the guard $D_X\not\Rightarrow$ a single cause, the
cause-classification test, and $\mathfrak U=(\mathcal X,\mathcal O,\mathcal R,\mathcal P,\mathcal C,\mathcal Q)$
are the human owner's (D0019 §A–§B); the prediction that the eight collapse is the triage's (§J3).
This note supplies the collapse criterion, the proofs, the witnesses, the two refutations
(symmetry enlargement is no repair; the $\mathsf{Stat}$ prediction fails on variance), and the
observation that the eight do not contain $\Gamma_\Uparrow$.*
