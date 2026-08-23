# The coherence slot has an operation and an exclusive witness; the flow slot has neither, and should not

*Derived from the human owner's transmission `collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md`,
§A and §B. The tuple $\mathfrak U=(\mathcal X,\mathcal O,\mathcal R,\mathcal P,\mathcal C,\mathcal Q)$
with its glosses (state-possibility space; observation grammar; relation net; change flow; coherence
laws; self-description capacity), the cycle
$\mathfrak U\mapsto\operatorname{Resp}\mapsto\operatorname{Def}\mapsto\widehat{\mathfrak U}\mapsto\ulcorner\widehat{\mathfrak U}\urcorner\mapsto\operatorname{diag}\mapsto\mathfrak U^+$,
the eight classes and their response column, and the guard $D_X\not\Rightarrow$ a single cause are
the owner's. D0017 §C's $\delta_\Diamond$, $[\alpha]\in\pi_2$ and the cell-attachment box, and
D0016 §D's $\operatorname{YB}_\delta$, are likewise the owner's. Everything below is proof,
refutation and scope-fixing. Nothing here restates a transmission as a result (D0019 §J9).*

Seed 172, 2026-08-15.

---

## 0. What is settled here

| claim | status |
|---|---|
| seed 162's inflation-is-injective step (Thm 3.5) | **verified**, proof re-derived independently (§1.1); one convention gap in its proof repaired |
| seed 162's four exclusivity witnesses | **verified at their stated strengths** (§1.2); two are theorems, two are arguments, and seed 162 says so |
| the $\mathcal C/\mathcal P$ gap in §B is real, not a mis-slotting | **proved** for $\mathcal C$ (§2.2 — $\Gamma_\Uparrow$ is *not an instance of the transport schema at all*, so it cannot be a fibre of it); **verified** for $\mathcal P$ (§2.3) |
| $\mathsf{Top}$'s cell attachment hides a $\mathcal C$-move | **refuted** (§2.1): cell attachment on a space *is* transport, in $\mathcal X$; seed 162's dissolution stands |
| $\mathsf{Phys}$'s "field enlargement" hides a $\mathcal P$-move | **refuted** (§2.3): it is transport in the value slot; the Lagrangian is not the operand |
| $\Gamma_\Uparrow$ stated in the `FOUR_REPAIR_MODES.md` five-column template | **done** (§3.1); its success predicate is **not** vanishing, which is the structural point |
| D0017 §C's $[\alpha]\in\pi_2$ is an exclusive witness for $\Gamma_\Uparrow$ | **refuted, twice over** (§3.2): it is the *output* of $\Gamma_\Uparrow$, not an input; and it is repaired in the base slot by cell attachment |
| D0016 §D's $\operatorname{YB}_\delta(R)\ne1$ is an exclusive witness for $\Gamma_\Uparrow$ | **proved** (Thm 3.3), modulo the degenerate-collapse disposition seed 162 already took at its §5.1 |
| "change the step functor $\mathfrak F$" is a new slot | **refuted** (Thm 4.1): it is $\mathsf{Geom}$'s cover, with degree = the time-step ratio, and inherits $n[D]=0$ |
| "re-order $\partial\to\delta\to\Gamma\to\Phi$", "choose which defect first" | **rejected** (Prop 4.2): fails clause (i) of `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Def 4.0.1, the same clause that rejected $\mathsf{Comp}$'s resource extension |
| **there is no $\mathcal P$-slot repair** | **argued at the generality of §4.3**, and *explained*: $\mathcal P$ is the arrow that produces $\operatorname{Def}(\mathfrak U)$, not an argument of it |
| §A and §B are in correspondence | **refuted**, and the failure has **two different kinds** (§5) |

**Scope limits, up front.** (i) Theorems 4.1 and the verifications of §1 live in the 1-cocycle
setting of `FOUR_REPAIR_MODES.md`. Thm 3.3 lives in a monoidal category with one invertible
$R\in\operatorname{Aut}(V^{\otimes2})$, exactly the setting of
`notes/CENTRE_AND_YANG_BAXTER_DEFECT.md` §3.1's Hypothesis (I). (ii) §4.3's negative is an argument
from the shape of §A's cycle plus two rejections, not a theorem in a common formalism; I say where it
would break. (iii) **The identification of seed 162's four slot-names with the owner's six components
is the weakest joint in both notes, and I make it explicit in §5.2 rather than inherit it silently.**
(iv) No computation, no Python, no numerics, no fitted quantity. No Agda or Lean authored, nothing
typechecked. (v) D0018 §J5's $\chi_\alpha$ and D0019 §C's $\rho(D\mathcal K)$ are untouched, and are
*not* identified with each other.

---

## 1. Verification of the result I am told to build on

Standing check (d): false grounds outnumber false claims. I check the two load-bearing items
separately from the verdict.

### 1.1 Thm 3.5 (inflation is injective) — verified, with one convention gap repaired

*Claim: $N\trianglelefteq G$ acting trivially on $V$, $\Gamma=G/N$; then
$\operatorname{inf}:H^1(\Gamma,V)\to H^1(G,V)$ is injective.*

Re-derived without looking at seed 162's proof, then compared. Let $D\in Z^1(\Gamma,V)$ with
$\operatorname{inf}(D)_g=D_{gN}=(R|g)-R$ for some $R\in V$ and all $g\in G$. Put $g=n\in N$: the
cocycle identity at the identity gives $D_{1_\Gamma}=0$, and $nN=1_\Gamma$, so $R|n=R$ for all
$n\in N$. Now for $g\in G$, $n\in N$: with the right action, $R|(gn)=(R|g)|n$, and since
$N\trianglelefteq G$ we may also write $R|(ng)=(R|n)|g=R|g$. Hence $g\mapsto R|g-R$ is constant on
cosets **provided the cosets are read on the side the action is written**. Seed 162's displayed proof
takes $g=n$ and then asserts "$R|g$ depends only on $gN$" using $R|(ng)=R|g$, i.e. it verifies
constancy on *left* cosets $Ng$ while writing the quotient as $gN$. Normality makes $Ng=gN$, so
**the step is correct**, but the two-line gap between what is verified and what is used is real and I
close it here rather than pass it on. With that, $\bar D_{gN}:=R|g-R$ is well defined on $\Gamma$ and
equals $D$, so $[D]=0$. $\square$

Independently: this is the injectivity half of the inflation–restriction sequence
$0\to H^1(G/N,V^N)\to H^1(G,V)\to H^1(N,V)$, standard, and with $N$ acting trivially $V^N=V$. Two
grounds agree. **Verified.**

### 1.2 The four exclusivity witnesses — verified, at the strengths seed 162 itself declares

- $\mathsf{Alg}$, generator of $H^1(\mathbb Z,\mathbb Z)$. Trivial action gives
  $H^1(\mathbb Z,\mathbb Z)=\operatorname{Hom}(\mathbb Z,\mathbb Z)=\mathbb Z$: correct. Exclusion of
  the base slot is Thm 3.4 ($\operatorname{cor}\circ\operatorname{res}=n$) plus $\mathbb Z$
  torsion-free: correct, and it is a **theorem**. Exclusion of the language slot ("decided and
  expressible") is a one-line observation and I accept it. **Verified.**
- $\mathsf{Diag}$, the Gödel sentence. The exclusion of $\mathsf{Sem}$ rests on conservativity of
  extensions by definitions, quoted not re-read there and not re-read here. Used only in its
  unambiguous direction. **Verified as an argument with a quoted ground.**
- $\mathsf{Geom}$ (a singularity) and $\mathsf{Stat}$ (an insufficient statistic). Both exclusions run
  "the defect is not a cocycle, so Thm 3.3 has no input". That is correct *as far as it goes* and is
  not a theorem in a common formalism — seed 162's own ledger says exactly this. **Verified at the
  declared strength, which is lower than the other two.** I do not lean on either below.

### 1.3 What I found that seed 162 did not say

Its Def 3.0.2 (a class survives iff it has a defect no other surviving class repairs) has **no
content unless degenerate total collapses are excluded**. Seed 162 excludes one at §5.1 — restricting
to the trivial subgroup "is not a cover but the total collapse of the base … so it repairs nothing
selectively" — and never states the exclusion as a standing clause. It must be one: without it, the
base slot repairs every structural defect by collapsing the object to a point, and no class has an
exclusive witness. I therefore state it, and I use it exactly once, in Thm 3.3(b′), where it is
load-bearing:

> **Clause D (degenerate collapse).** A transport $\varphi$ whose target retains none of the structure
> the defect was a defect *of* does not count as a repair. Formally: $\varphi$ must be such that the
> repaired datum still carries the functor $F$ in which the defect was valued, non-trivially.

This is seed 162's own disposition, promoted to a clause and applied uniformly. **If a reader rejects
Clause D, seed 162's four witnesses fall with mine, not before it.**

---

## 2. Is the $\mathcal C/\mathcal P$ gap real?

§B's eight rows are checked for a hidden $\mathcal C$- or $\mathcal P$-move. The two named candidates
are checked in full; the remaining six were checked and are transports in the four slots as seed 162
records, which I do not repeat.

### 2.1 $\mathsf{Top}$'s cell attachment is a base move. Seed 162's dissolution stands.

This is where a $\mathcal C$-move would hide, because D0017 §C's box
$$\mathfrak X_{n+1}=\mathfrak X_n\sqcup_{\partial\mathfrak X_n}\mathsf G\langle\delta^{(n)}\rangle$$
uses cell attachment as the repair of a *failed equation*, and D0016 §C types
$\Gamma_\alpha:\mathcal O_\alpha\to\operatorname{Cell}(\mathcal C_{\alpha+1})$, which
`CENTRE_AND_YANG_BAXTER_DEFECT.md` §4.1 reads as $\Gamma_\Uparrow$. So "attach a cell" names two
things and the question is whether §B's row is the second.

**They separate on the success predicate, and that is the whole test.**

- **(T1) Attach a cell to a space along $\alpha\in\pi_n(X)$.** Ambient morphism
  $j:X\to X\cup_\alpha e^{n+1}$; defect functor $F=\pi_n$; output $j_*[\alpha]=0$. Success **is**
  vanishing of the image. This is seed 162's Def 3.0.1 schema verbatim, in the object slot. The
  defect is *destroyed*.
- **(T2) Adjoin a 2-cell $\alpha:hf\Rightarrow kg$ filling a failed equation.** No morphism of the
  ambient sends the defect to zero: the defect is *retained as the 2-cell itself*.
  `FOUR_REPAIR_MODES.md` §1.1 prices this in its own words — $\Gamma_\Uparrow$ "preserves everything
  (no information discarded)". Nothing vanishes; what changes is the *status* of the equation.

§B's row says "cell attachment" in a list whose seven other entries are all transports, and its
response column is written at the level of spaces. **It is (T1).** So the row does not hide a
$\mathcal C$-move, and seed 162 dissolving $\mathsf{Top}$ into $\mathsf{Geom}$ by uniformity is
correct — not because cell attachment is *like* a cover, but because it satisfies the schema and
(T2) does not.

### 2.2 Why the $\mathcal C$ gap is not merely an omission

The sharper statement, which seed 162 does not make and which is this note's first finding:

> **Proposition 2.2.** $\Gamma_\Uparrow$ is not an instance of the transport schema of Def 3.0.1.
> Hence it is not a fibre of that schema over any slot, and no re-slotting of the eight rows can
> produce it.

**Proof.** Def 3.0.1's schema has success predicate $F(\varphi)(D)=0$. Suppose $\Gamma_\Uparrow$ were
such an instance, with morphism $\varphi:\mathfrak A\to\mathfrak A[\alpha]$ and defect functor $F$.
By `FOUR_REPAIR_MODES.md` §1.1 (column "destroys": *flatness*; column "preserves": *everything*), the
defect is recoverable from the output by truncation — §1.2 states this: "the old situation is
recovered by truncating". So $F(\varphi)(D)$ determines $D$; if $F(\varphi)(D)=0$ for some $D\ne0$
the truncation could not recover $D$. Hence success in the schema's sense never occurs for a nonzero
defect, and $\Gamma_\Uparrow$ repairs nothing under that predicate — contradiction with its being a
repair mode at all (`QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm A lists its success as *"the
obstruction is the distinguished element"* at each **level**, a predicate about the tower, not about
an image). $\square$

**Reading, and it is the reason §B has no $\mathcal C$ row rather than an accident.** §B classifies
*where you push the defect to make it go away*. $\Gamma_\Uparrow$ does not make it go away; it
changes the dimension in which equality is asserted, so that the defect stops being a failure and
becomes data. A classification of transports cannot contain it, however many rows it has. **The gap
is real and it is structural.**

Corroborating, independently and from another note: `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm
C's proof, when it reaches the observable field, disposes of $\Gamma_\Uparrow$ by saying it "requires
a 2-cell, which the observable field does not carry unless it is itself categorified — in which case
the mode is $\Gamma_\Uparrow$ and not a new one." That is the same phenomenon seen from the
$\mathcal O$ slot: $\Gamma_\Uparrow$ does not live in a slot, it applies **across** slots by raising
the level at which any of them asserts equality. That is precisely what "coherence laws" names.

### 2.3 $\mathsf{Phys}$'s "field enlargement" is a value-slot move, not a flow move

The plausible reading is: a Lagrangian is dynamics, dynamics is $\mathcal P$, so adding a field to a
Lagrangian moves $\mathcal P$. **That reading confuses the operand with the setting.** Test against
the schema. The defect repaired by adding a field (an anomaly; a required state with no carrier; a
mass term with nothing to couple to) is that some object fails to exist or some class fails to
vanish in the theory as given. The repair is the inclusion of the old field content into the new,
and the defect's image under it vanishes. Morphism, functor, vanishing: transport, in the slot of
*what the fields take values in* — seed 162's coefficient/value slot. The Lagrangian changes as a
*consequence* of the enlarged value system, and is not itself the argument of the operation.

The test that settles it: **is the flow the thing transported, or the thing that follows?** Under
field enlargement the equations of motion are re-derived from the enlarged data; nobody chooses a
new flow independently of the enlargement. So the flow is downstream. Seed 162's redistribution of
$\mathsf{Phys}$ stands, and its Thm 3.5 (symmetry enlargement is no repair) is verified in §1.1
above.

The remaining $\mathsf{Phys}$ item, symmetry *reduction*, is a base-slot quotient; nothing there
touches $\mathcal P$ either.

**Verdict on question 1: the gap is real. No row of the eight, correctly read, moves $\mathcal C$ or
$\mathcal P$.**

---

## 3. The $\mathcal C$-slot operation, and its exclusive witness

### 3.1 $\Gamma_\Uparrow$ in the five-column template

| column | content |
|---|---|
| **domain** | a parallel pair $u,v:A\rightrightarrows B$ in an ambient $\mathfrak X$ (D0017 §C: $u=hf$, $v=kg$, $\delta_\Diamond=u-v\ne0$), together with an enrichment of $\mathfrak X$ in which 2-cells $u\Rightarrow v$ can exist |
| **operation** | $\mathfrak X\rightsquigarrow\mathfrak X[\alpha]$, freely adjoining an invertible 2-cell $\alpha:u\Rightarrow v$; equivalently D0017 §C's $\mathfrak X_{n+1}=\mathfrak X_n\sqcup_{\partial\mathfrak X_n}\mathsf G\langle\delta^{(n)}\rangle$ read at the level of cells rather than of spaces |
| **availability** | the enrichment must exist **and** the coherence tower must be fillable. `FOUR_REPAIR_MODES.md` §1.2: not checkable by a finite computation in general. D0017 §C's own ladder $[\alpha]\to\pi_2\to\pi_3\to\cdots$ is that tower, written by the owner |
| **success** | *not* vanishing. Success is that the defect has been converted from an obstruction into structure: $u\ne v$ is replaced by $u\cong v$ witnessed by named data, and every consumer of the old equation is re-typed to consume $\alpha$ |
| **cost** | unbounded and *owed rather than paid*: every composite that commuted on the nose now needs a filler, and the fillers need fillers. Lossless in information, unbounded in obligation |

Two things about this table are worth stating because they are the reason $\Gamma_\Uparrow$ was lost
when §B replaced D0018 §B. Its availability column is the only one in the corpus that is not a
predicate on the defect; and its success column is the only one that is not "membership in a
distinguished singleton of a value set". A classification built by reading the other four columns
will not see it.

### 3.2 D0017 §C's $[\alpha]\in\pi_2$ is **not** an exclusive witness — refuted twice

The mandate offers it as a candidate. It fails, for two independent reasons, and the reasons are
worth more than the candidate.

**(i) Type.** In D0017 §C, $[\alpha]$ appears *after* the categorification: "when the square commutes
only up to a 2-cell, $hf\overset{\alpha}{\Longrightarrow}kg$, $[\alpha]\in\pi_2(\mathfrak X)$".
$[\alpha]$ is therefore the **output** of $\Gamma_\Uparrow$ applied to $\delta_\Diamond$, and the
displayed ladder $[\alpha]\to\pi_2\to\pi_3\to\pi_4\to\cdots$ is $\Gamma_\Uparrow$'s **cost tower**,
which is exactly what `FOUR_REPAIR_MODES.md` §1.2 declines to certify. A mode's own residue cannot be
a defect exhibiting the mode's exclusivity; the input to test is $\delta_\Diamond$, not $[\alpha]$.

**(ii) Even taken as an input, it is not exclusive.** $[\alpha]\in\pi_2(\mathfrak X)$ nonzero is
repaired in the **base slot**: attach a 3-cell along $\alpha$, and $j_*[\alpha]=0$ in
$\pi_2(\mathfrak X\cup_\alpha e^3)$ — operation (T1) of §2.1, availability vacuous, success automatic.
That is ordinary obstruction theory and it is precisely $\mathsf{Top}$'s row. So $[\alpha]$ is a
witness for nothing: the class it belongs to is $\mathcal X$.

**This refutes the mandate's stronger candidate and leaves the weaker one.** (Standing check (a): the
hint was tested, not used.)

### 3.3 $\operatorname{YB}_\delta(R)\ne1$ **is** an exclusive witness

Setting: `notes/CENTRE_AND_YANG_BAXTER_DEFECT.md` §3.1 Hypothesis (I) — $V$ an object of a monoidal
category, $R\in\operatorname{Aut}(V\otimes V)$, $R_{12}=R\otimes1$, $R_{23}=1\otimes R$ in
$G:=\operatorname{Aut}(V^{\otimes3})$, and
$\operatorname{YB}_\delta(R)=R_{12}R_{23}R_{12}(R_{23}R_{12}R_{23})^{-1}$. The **defect** is stated as
that note states it, in terms of what is wanted: *$R$ does not give braid-group representations on
the powers $V^{\otimes n}$* — equivalently, by that note's Thm 4 (an $\iff$, and it is a real $\iff$
because $G$ is a group; standing check (e), and that note flags the same point),
$\operatorname{YB}_\delta(R)\ne1$.

**Theorem 3.3.** *Under (I) with $\operatorname{YB}_\delta(R)\ne1$, and under Clause D of §1.3, none
of the four slot-operations repairs the defect, and $\Gamma_\Uparrow$ does.*

**Proof, slot by slot.**

**(a) Coefficient/value slot ($\mathcal R$): unavailable, proved.** The slot's operation is transport
along a map of the value system, here a homomorphism $\iota:G\to G'$ extending the ambient. This is
`CENTRE_AND_YANG_BAXTER_DEFECT.md` Thm 7: for injective $\iota$,
$\operatorname{YB}_\delta(R)\ne1\Rightarrow\iota(\operatorname{YB}_\delta(R))\ne1$; proof,
injectivity. I verified that proof (one line, correct) and I add the step that note leaves implicit
and which is the actual content: **seed 162's Thm 3.3, the universality of the coefficient slot, does
not apply here, because its input is a cocycle and $\operatorname{YB}_\delta$ is an element of a
group with no $H^1$ beneath it.** So the one slot with a *vacuous* availability hypothesis has, for
this defect, no purchase at all. That is the crux and it is why this witness works where a
cocycle-shaped one could not.

*Non-injective $\iota$?* Then $\iota$ is a quotient $G\twoheadrightarrow G/N$ with
$\operatorname{YB}_\delta(R)\in N$ — treated in (b).

**(b) Base/object slot ($\mathcal X$): unavailable under Clause D.** Two directions.
- *Quotient of the acting group.* $q:G\twoheadrightarrow G/\langle\!\langle\operatorname{YB}_\delta(R)\rangle\!\rangle=:G/N$
  makes the braid relation hold in the target. But $V^{\otimes3}$ is not a $G/N$-object: an action of
  $G/N$ on $V^{\otimes3}$ compatible with $G$'s would require $N$ to act trivially, and
  $N\ni\operatorname{YB}_\delta(R)\ne\operatorname{id}_{V^{\otimes3}}$. So the repaired datum no
  longer carries the functor the defect was valued in — Clause D excludes it. (This is the same
  finding that note reaches at §4.2 in different words: "the quotient no longer acts on
  $V^{\otimes3}$, so the datum bought is not the datum wanted". I have restated it as a failure of a
  stated clause rather than as a complaint.)
- *Quotient of the carrier.* Pass to the largest subquotient $W$ of $V^{\otimes3}$ on which
  $R_{12}R_{23}R_{12}=R_{23}R_{12}R_{23}$ holds and which is $R_{12},R_{23}$-stable. This exists and
  may be $0$; when it is $0$ or when it fails to be of the form $U^{\otimes3}$, Clause D excludes it
  for the same reason seed 162 excluded restriction to the trivial subgroup at its §5.1. **Scope
  limit, stated because it is the one place the theorem is not airtight: I have not shown that this
  subquotient is always degenerate.** If for some $R$ it is a nonzero $U^{\otimes3}$ with $R$
  restricting to a genuine $R$-matrix, then for *that* $R$ the base slot repairs and the witness must
  be taken with the exclusion of that family. The witness survives for any $R$ where it does not —
  e.g. any $R$ acting irreducibly on $V^{\otimes 3}$, where the only stable subquotients are $0$ and
  $V^{\otimes3}$ itself.

**(c) Observable slot ($\mathcal O$): unavailable.** By `FOUR_REPAIR_MODES.md` Cor 2.2 (prose half, as
repaired by seed 159 and re-quoted by seed 162 §1.3) enlarging tests can only reveal; by
`QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Thm C restricting or identifying tests is
$\Gamma_\varnothing$ or $\Gamma_\circlearrowleft$ on the test family, i.e. concealment or
bookkeeping. The defect here is an equation between two automorphisms of $V^{\otimes3}$; concealing
it does not produce a braid representation.

**(d) Language slot ($\mathcal Q$): unavailable.** $\operatorname{YB}_\delta(R)\ne1$ is decided and
expressible in the ambient — it is a computation in a group. There is nothing for a meta-level ascent
to decide. (Same argument as seed 162 §5.1 for the $\mathbb Z$ witness; I use it in the same
direction.)

**(e) $\Gamma_\Uparrow$ repairs it.** Fill the Yang–Baxter equation with an invertible 2-cell
$\Upsilon:R_{12}R_{23}R_{12}\Rightarrow R_{23}R_{12}R_{23}$ in a monoidal 2-category. Nothing is
discarded: $V^{\otimes3}$ is still acted on, $R$ is unchanged, and the braid representations are
recovered as weak ones. The first coherence obligation on $\Upsilon$ is nameable — it is the
Zamolodchikov tetrahedron equation, and the lineage is Kapranov–Voevodsky. **Ground, standing check
(d):** I take this located-lineage statement from `CENTRE_AND_YANG_BAXTER_DEFECT.md` §4.2, which
records explicitly that it read the nLab page for *braided monoidal 2-category*, that the page did
**not** state the axioms, and that it therefore asserts lineage only. I inherit it at that strength
and no higher: **I do not claim the tetrahedron equation as verified, and nothing above depends on
its precise form** — (e) needs only that a 2-cell can be adjoined and that its obligations are
nonempty, which is `FOUR_REPAIR_MODES.md` §1.2. $\square$

**Verdict on question 2: $\Gamma_\Uparrow$ does not collapse. The $\mathcal C$ slot has an operation
with an exclusive witness, and the honest class count is five.**

---

## 4. Is there a $\mathcal P$-slot repair?

$\mathcal P$ is the change flow: the dynamics, not the state. A $\mathcal P$-repair would alter *how
the system evolves* rather than what it is or how it is observed. The three candidates named in the
mandate are tested, not assumed.

### 4.1 Changing the step functor $\mathfrak F$ is the base slot, with a quantified hypothesis

**Theorem 4.1.** *Let the change flow be generated by a step $\mathfrak F$, so that the acting group
is $\Gamma=\mathbb Z\langle\mathfrak F\rangle$, and let $D\in Z^1(\Gamma,V)$ be a defect of the flow
(the failure of some $f$ to be $\mathfrak F$-invariant). Then:*
*(a) coarsening the step, $\mathfrak F\rightsquigarrow\mathfrak F^{\,n}$, is exactly restriction along
$n\mathbb Z\le\mathbb Z$, and by `EIGHT_CLASSES…` Thm 4 ($\operatorname{cor}\circ\operatorname{res}=n$)
it repairs $[D]$ only if $n[D]=0$;*
*(b) refining the step — presenting $\mathfrak F$ as $\mathfrak G^{\,n}$ for a new generator
$\mathfrak G$ — is inflation along $\mathbb Z\twoheadleftarrow\mathbb Z$ read in the other direction,
and by §1.1 above it never kills a class;*
*(c) replacing $\mathfrak F$ by an unrelated $\mathfrak F'$ is transport along a homomorphism of
acting groups, which is the base slot by definition.*
*Hence "change the dynamics" is $\mathsf{Geom}$'s operation, and it is not a new slot.*

**Proof.** (a) The subgroup of $\mathbb Z\langle\mathfrak F\rangle$ generated by $\mathfrak F^n$ is
$n\mathbb Z$; passing to the $\mathfrak F^n$-flow is restriction of the cocycle to that subgroup, and
Thm 3.4 applies verbatim. (b) is §1.1's statement with $G=\mathbb Z$, $\Gamma=G/N$. (c) is the
definition of the base slot. $\square$

**Corollary 4.1.1 (and it is worth having on its own).** By seed 162 §5.1's witness — a generator of
$H^1(\mathbb Z,\mathbb Z)=\mathbb Z$, non-torsion — **there are evolution defects that no change of
time-step repairs, at any ratio $n$.** The intuition that one can always fix a dynamical obstruction
by re-timing is false, and the exact obstruction is torsion.

### 4.2 Re-ordering the repair cycle, and choosing which defect first, are not operations

**Proposition 4.2.** *Neither (i) re-ordering the composite $\partial\to\delta\to\Gamma\to\Phi$ nor
(ii) choosing which defect to pursue first is a repair mode, under
`QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Def 4.0.1.*

**Proof.** Def 4.0.1 clause (i) requires a repair mode to be *a partial operation on defect-carrying
data*. In (i) and (ii) the domain is the state of the repair process — an ordering, or a pointer into
a queue — and the defect $D$ is not in the domain and is unchanged by the operation. Clause (i)
fails. $\square$

**This is not a new criterion; it is the criterion already used**, and used on a structurally
identical candidate: seed 162 §2.5 rejects $\mathsf{Comp}$'s *resource extension* on exactly clause
(i), because it "enlarges $\mathrm{Rep}$, not the object". The three rejections have one shape and
it is worth naming: **resource extension moves the goalposts; scheduling moves the pointer; neither
touches the ball.** Uniformity (which is what gave seed 162's collapse its teeth) requires that if
one is rejected, all are.

### 4.3 The negative, and why it is the right answer rather than a missing row

Collecting: every candidate $\mathcal P$-move is either a base-slot transport with the flow playing
the role of the object (§4.1), or not an operation on defects at all (§4.2). I state the general
reason, and I state it as an argument at the generality of §A's own cycle.

> **The disposition.** $\mathcal P$ is where repairs *act*; it is not what they act on. The owner's
> §A cycle
> $\mathfrak U\mapsto\operatorname{Resp}\mapsto\operatorname{Def}(\mathfrak U)\mapsto\widehat{\mathfrak U}\mapsto\ulcorner\widehat{\mathfrak U}\urcorner\mapsto\operatorname{diag}\mapsto\mathfrak U^+$
> **is** the change flow. §B classifies operations on $\operatorname{Def}(\mathfrak U)$ — on the
> *output* of one arrow of that cycle. $\mathcal P$ is the arrow, not an argument of it. A
> classification of the operations performed *by* a flow cannot contain a row for the flow, for the
> same reason a list of a function's values contains no entry for the function.

Two consequences, and the second is the reason this is a finding rather than a shrug.

1. **§B's missing $\mathcal P$ row is correct, and §B's missing $\mathcal C$ row is not.** The two
   gaps that look alike in the tuple are of different kinds. One is an omission with a repair
   ($\Gamma_\Uparrow$, readmitted); the other is a type distinction the tuple's flat notation hides.
2. **The apparent $\mathcal P$-repairs are $\mathcal Q$-repairs after coding.** One *can* act on the
   flow — by making the flow an object, describing it, and repairing the description. That is
   precisely §A's own $\ulcorner\widehat{\mathfrak U}\urcorner\mapsto\operatorname{diag}$ step, and
   the self-description capacity it uses is $\mathcal Q$. So the move exists and it is already
   classified: **$\mathcal Q$ is the slot through which $\mathcal P$ becomes touchable**, which is
   what makes §A's tuple a *cycle* rather than a list, and is exactly why $\mathcal Q$ is in it.

**Where this breaks (standing check (g)).** The argument is about the shape of §A's cycle plus two
uniform rejections; it is not a theorem in a formalism where flows and states are objects of one
category. A refutation would look like this: a defect $D$ of a system, and an operation whose domain
is $D$, whose codomain is a *new flow* not obtained as transport along a morphism of the acting
group, and whose success predicate is checkable on $D$. Non-autonomous or feedback dynamics —
where the flow depends on the state — is where I would look first, and I have not looked. I therefore
report the negative as **argued and explained, not proved**, and I would not let a later note quote
it as a theorem.

**Verdict on question 3: there is no $\mathcal P$-slot repair.**

---

## 5. The corrected table

### 5.1 Slots of $\mathfrak U$, repair operations, witnesses

| slot | owner's gloss (§A) | repair operation | representative | exclusive witness |
|---|---|---|---|---|
| $\mathcal X$ | state-possibility space | transport along a morphism of the object (cover, resolution, cell attachment, symmetry reduction) | $\mathsf{Geom}$ | a singularity; a non-simply-connected space; $[\alpha]\in\pi_2$ (§3.2) |
| $\mathcal O$ | observation grammar | sufficient-statistic enlargement | $\mathsf{Stat}$ | an insufficient statistic |
| $\mathcal R$ | relation net | $\varphi_*$ for a map of coefficient systems | $\mathsf{Alg}$ | a generator of $H^1(\mathbb Z,\mathbb Z)$ |
| $\mathcal P$ | change flow | **none, and correctly so** (§4) | — | — |
| $\mathcal C$ | coherence laws | $\Gamma_\Uparrow$: replace the equation by a 2-cell (§3.1) | readmitted from D0018 §B | $\operatorname{YB}_\delta(R)\ne1$ (Thm 3.3) |
| $\mathcal Q$ | self-description capacity | meta-level ascent | $\mathsf{Diag}$ | the Gödel sentence $G_T$ |

**Five slots carry a repair operation; one does not. Every one that does has an exclusive witness,
and all five witnesses are now exhibited** — four inherited and verified at their stated strengths
(§1.2), the fifth proved here (Thm 3.3).

### 5.2 Are §A and §B in correspondence? No, and the failure is of two kinds.

Plainly:

- §B has **eight rows and four classes** (seed 162, verified in §1). §A has **six slots**.
- Of the six, four are covered by §B's classes; one ($\mathcal C$) is **omitted** — an error of the
  eight-way list, repairable, and repaired here by readmitting $\Gamma_\Uparrow$ and giving it the
  witness it lacked;
- and one ($\mathcal P$) is **not a place where a repair can live** — so its absence from §B is
  correct and its presence in §A is correct, because §A is a description of the object and §B is a
  classification of operations, and the two are not required to have the same index set. **The
  demand that they correspond is itself the error.**

So: **§A and §B are not in correspondence, and should not be.** What is true is the weaker and more
useful statement: *the classes of §B inject into the slots of §A, and the image is exactly the slots
that are operands rather than operators.* That injection is the structural content seed 162 found;
this note identifies its image.

**The weakest joint, stated (standing check (f)).** Everything above indexes repairs by the owner's
six names, and the identification of seed 162's four working slots with $\mathcal X,\mathcal O,
\mathcal R,\mathcal Q$ is *interpretation of a gloss*, not a theorem. $\mathcal R$ is glossed
"relation net", and a coefficient module is a system of *values*; reading it as $\mathcal R$ is the
most strained of the four, and under a different reading — $\mathcal R$ = the morphisms of the
ambient — the coefficient slot has no name in §A and $\mathcal R$ joins $\mathcal P$ and $\mathcal C$
as unfilled. **My structural findings survive that re-reading** (Prop 2.2, Thm 3.3, Thm 4.1 and
Prop 4.2 never use a slot's *name*), but the tidiness of §5.1's table does not. A reader who wants
the correspondence tightened must first ask the owner what $\mathcal R$ denotes; that is a question,
not a defect, and I record it as the first queue item.

---

## 6. Prior art

Searched before writing, and I state exactly what I did: **no fetch was performed; nothing was
downloaded, and no PDF was decoded.** What follows is a statement of where the frame sits, from
standard knowledge, offered so a later reader can check it.

- Replacing a failed equation by a coherent 2-cell, and the resulting tower of obligations, is
  **coherence theory**: Mac Lane's coherence theorem in the monoidal case, $A_\infty$/operadic
  machinery in general. `FOUR_REPAIR_MODES.md` §1.2 already located this and I add nothing.
- The specific rung used in §3.3(e) — filling YBE with a 2-cell — is Kapranov–Voevodsky's braided
  monoidal 2-categories and the Zamolodchikov tetrahedron equation, **cited as located lineage only**,
  at the strength `CENTRE_AND_YANG_BAXTER_DEFECT.md` §4.2 established and no higher.
- The observation that "adjoin a filler" and "kill the class" are different in kind is old in
  obstruction theory and in homotopical algebra; what I have not found prior art for, and what is
  this note's contribution if anything is, is the use of *the success predicate's form* — vanishing
  of an image versus fillability of a tower — as the criterion that separates the coherence slot from
  the four transport slots.
- I did not search systematically for prior art on classifying repairs by which component of an
  ambient tuple they move; seed 162's §9.4 already carries that `SEARCH` item and it remains open.

## 7. Queue

1. **`SEARCH`/ask** — What does $\mathcal R$ denote in §A? The whole slot-naming of §5.1 rests on
   reading it as the value/coefficient system, which is the strained reading (§5.2). This is a
   question for the owner, and it is cheap.
2. **`PROVE`** — Thm 3.3(b)'s scope limit: is the largest $R$-stable subquotient of $V^{\otimes3}$ on
   which the braid relation holds always degenerate for $\operatorname{YB}_\delta(R)\ne1$? A negative
   would restrict the witness to a family (irreducible $R$ suffices, and is exhibited).
3. **`PROVE`** — §4.3's negative in a formalism where flows and states are objects of one category.
   Non-autonomous / feedback dynamics is where it would break if it breaks.
4. **`PROVE`** — Prop 2.2 says $\Gamma_\Uparrow$ is not a transport. Is there a *second* non-transport
   repair? If the non-transport operations also form a classifiable family, the honest count is not
   "four plus one" but "four transports plus $k$ level-changes", and $k$ is unknown. This is the
   successor of seed 162's §9.1 rather than of §9.2.
5. **`PROVE`** — seed 162 §9.1 stands: is every expressibility defect repaired by ascent? Untouched
   here.

## 8. Honesty ledger

- Nothing computed. No Python, no numerics, no fitted constant, no correlation. D0019 §C's
  $\rho(D\mathcal K)$ and D0018 §J5's $\chi_\alpha$ are untouched, are not identified with each
  other, and remain flagged.
- No Agda or Lean authored; nothing claimed typechecked. No fetch performed; no PDF decoded and none
  claimed.
- **Files read in full, not summarised:** `CLAUDE.md`;
  `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md`; `collab/messages/0763-seed162-eight-class-collapse.md`;
  `collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md`; `notes/FOUR_REPAIR_MODES.md`;
  `notes/CENTRE_AND_YANG_BAXTER_DEFECT.md`. Read in part, at the sections cited:
  `collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md` §C and §J1–J2;
  `notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` Def 4.0.1 and Thm C with proof. Every file the
  mandate named exists and was opened (standing check (b)).
- **Grounds, by strength.** §1.1 (inflation), Prop 2.2, Thm 4.1 and Prop 4.2 are proved here from
  definitions and from theorems I re-derived, and I stand behind them. Thm 3.3 is proved slot by slot
  with one stated scope limit in (b) and one inherited lineage citation in (e) that nothing depends
  on. §4.3's general negative is **argued, not proved**, and §4.3 says what would refute it.
- **Second-hand readings, marked.** Shapiro's lemma, $\operatorname{cor}\circ\operatorname{res}=n$,
  conservativity of definitional extensions, and the Kapranov–Voevodsky lineage are all inherited
  from the predecessor notes at the strength those notes declare, and were **not re-read**. Each is
  used only in the direction in which it is unambiguous. Where an argument needed the fact rather
  than the citation I supplied a self-contained substitute (§1.1's direct proof; §3.3(e)'s reduction
  to "the obligations are nonempty").
- **On seed 162.** Verified, not merely relied on. Its Thm 3.5 is correct with a convention gap I
  closed (§1.1); its four witnesses hold at their declared strengths (§1.2); and it has an unstated
  clause — the exclusion of degenerate total collapses — that its own §5.1 uses and that I have
  promoted to Clause D and applied uniformly (§1.3). **Its closing finding, that the eight lose
  $\Gamma_\Uparrow$, is upheld and strengthened**: I give the missing witness, so "five classes" is
  no longer a count with four witnesses and an assertion.
- **On the mandate's instruments (standing check (a)).** Both were tested. The
  $\operatorname{YB}_\delta$ candidate works, and is proved. The $[\alpha]\in\pi_2$ candidate
  **fails, twice** (§3.2): it is $\Gamma_\Uparrow$'s output rather than its input, and as an input it
  is repaired by cell attachment in the base slot. Had I used it, I would have claimed exclusivity
  for a defect that the $\mathsf{Top}$ row repairs.
- **On the concluding generalisation (standing check (f)).** "Five slots carry a repair, one does
  not" is offered at exactly this generality: the fifth is proved by one witness under one stated
  scope limit; the sixth's emptiness is argued from §A's own cycle and two uniform rejections, not
  proved; and the whole slot-*naming* rests on reading the owner's glosses, which §5.2 flags as the
  weakest joint and §7.1 turns into a question rather than an assumption.
- **Not comparable to another pass's numbers.** The "five" here counts classes of repair operations
  in the sense of `FOUR_REPAIR_MODES.md` §1.1's template. It is seed 162's four plus $\Gamma_\Uparrow$
  and is comparable to that count only. It is not comparable to any queue-item count, and no number
  here is a measurement of anything.

*Credit: $\mathfrak U$ and its six glosses, the cycle, the eight classes and the guard are the human
owner's (D0019 §A–§B); $\delta_\Diamond$, the cell-attachment box and $[\alpha]\in\pi_2$ are the
owner's (D0017 §C); $\operatorname{YB}_\delta$ is the owner's (D0016 §D). The four repair modes,
including $\Gamma_\Uparrow$ and the naming of its unbounded cost, are seed 152's. The eight-to-four
collapse, the slot indexing, and the observation that $\Gamma_\Uparrow$ has no representative among
the eight are seed 162's. This note supplies: the verification of that pass; Clause D; the proof that
$\Gamma_\Uparrow$ is not a transport at all; the exclusive witness for the coherence slot; the
refutation of $[\alpha]$ as a witness; the identification of "change the step functor" with
$\mathsf{Geom}$'s cover and its torsion obstruction; and the negative for the flow slot with its
explanation.*
