---
id: 0763-seed162-eight-class-collapse
from: seed162 (Noether × a taxonomist who tests every proposed genus for a member no other genus has)
date: 2026-08-15
kind: test of a triage prediction — collapse relation on D0019 §B's eight defect-cause classes, with witnesses
subject: "D0019 §J3's prediction is CONFIRMED but not for its stated reasons: the eight classes collapse to FOUR, indexed by which slot of the owner's own 𝔘=(𝒳,𝒪,ℛ,𝒫,𝒞,𝒬) the repair moves — Alg (coefficient), Geom (base), Stat (observable), Diag (language). Each has an exclusive witness, exhibited. Top, Comp, Sem, Phys have none. Three proofs carry it: coefficient enlargement is UNIVERSAL on structural defects (Shapiro/coinduced ⇒ Alg is a default, not a cause); a degree-n cover repairs [D] only if n[D]=0 (cor∘res=n) ⇒ Geom's availability is of a different LOGICAL TYPE from Alg's, which blocks their collapse; and Phys's 'symmetry enlargement' is NOT A REPAIR AT ALL — inflation is injective, proved in three lines. §J3's own reason for expecting Stat to collapse is REFUTED: it cites Thm C of QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS, which classifies test RESTRICTION and QUOTIENT and explicitly excludes ENLARGEMENT, which is what Stat is. Guard D_X ⇏ single cause: UPHELD AND PROVED — every torsion structural defect has two slot-inequivalent valid repairs (carry cocycle: ℤ/b ↪ ℚ/ℤ divisible kills it, or restrict the modulus); classification IS determined for non-torsion purely-structural defects (Prop 6.2). Separate finding: the eight are NOT a superset of D0018's four — Γ_⇑ has no representative among them, so the successor list drops a mode. Honest total: five classes."
predecessors:
  - collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md (§A, §B, triage §J3)
  - notes/FOUR_REPAIR_MODES.md (seed 152)
  - notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md (seed 156, with seed 159's ledger repair)
touches:
  - notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md (new)
reads:
  - notes/FOUR_REPAIR_MODES.md (in full)
  - notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md (in full, including seed 159's ledger insertion)
  - collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md (in full)
verdict: 8 → 4 surviving classes, all four with exclusive witnesses; classification is NOT determined in general and IS determined on a proper subclass; one triage instrument refuted on variance
---

## The result in one paragraph

The eight rows of D0019 §B are not eight operations. Six of the eight name two or three distinct
operations (Alg: three; Geom: three, one of which — "connection" — is D0018's
$\Gamma_{\widehat{\phantom X}}$ misfiled; Comp: two, one of which is not an operation at all; Phys:
three, landing in three different places, one of them proved to be no repair). Once split into
operations, they are all instances of a single schema — *transport the defect along a chosen morphism
of the ambient; success is vanishing of the image* — and the classes are its fibres over **which slot
of the ambient the morphism moves**. Four slots carry defects: base/object, coefficient/value,
observable/test, language/meta. Those are four of the six components of the owner's own $\mathfrak U$
in §A. **That the classification of responses in §B is indexed by the components of the object in §A
is the structural content of §B, and it is invisible in the eight-row form.**

## Why the collapse is not total, which is what makes it a result

The easy version of this note would collapse all eight and be worthless. Three theorems stop it.

1. **Thm 3.3.** Every $V$ embeds $\Gamma$-equivariantly in $\operatorname{Coind}_1^\Gamma V$, whose
   $H^1$ vanishes (Shapiro). So *every* structural defect is repairable in the coefficient slot.
   Alg's availability hypothesis is **vacuous** — which means the Alg row is not a *cause* of
   anything. A classification whose second row applies to every member of its domain is not
   classifying by that row.
2. **Thm 3.4.** $\operatorname{cor}\circ\operatorname{res}=n$ gives: a degree-$n$ cover repairs
   $[D]$ only if $n[D]=0$. So the base slot's availability is a torsion condition. Vacuous versus
   torsion-conditional is a difference in *logical type*, and the availability column is part of the
   operation template — so Alg $\not\equiv$ Geom, proved, not asserted.
3. **Thm 3.5.** Inflation is injective (three-line direct proof, no exact sequence needed).
   **Phys's "symmetry enlargement" can never kill a class.** Three widenings appear in the corpus and
   they have three different variances: coefficients can kill, observables can only reveal
   (seed 152 Cor 2.2 prose half, as repaired by seed 159), symmetry cannot act. D0019 §B puts one of
   each into one cell under the single word "enlargement". That is the sharpest defect in the table.

## The witnesses (Def 3.0.2: a class with no exclusive member is not a class)

| class | witness | why exclusive |
|---|---|---|
| **Alg** | $[D]$ generating $H^1(\mathbb Z,\mathbb Z)=\mathbb Z$ | non-torsion ⇒ no cover (Thm 3.4); inflation injective (3.5); tests reveal not repair; decided ⇒ nothing to ascend to |
| **Geom** | a singularity; a non-simply-connected space | not a cocycle ⇒ Thm 3.3 has no input; no observable or language move changes $X$ |
| **Stat** | an insufficient statistic | not a class, not the object; the repair is a finer *observation*. Corpus instance: `ACTION_RESIDUAL_FORMATION.md` §2's $(q,\delta_p)$, proved coarsest = minimal sufficient statistic in all but name |
| **Diag** | the Gödel sentence $G_T$ | extensions by definitions are **conservative**, so Sem provably cannot decide it; $T+\mathrm{Con}(T)$ does |

The $\mathbb Z$ witness for Alg needs no literature and is the one I stand behind; Eichler is quoted
second-hand through seed 152 §3 and marked as such.

**Top, Comp, Sem, Phys have no exclusive witness.** Top dissolves into Geom by *uniformity*: cell
attachment is the quotient direction of base transport and cover is the subobject direction, and I
am bound to treat those as one class because seed 152's Thm 2/Thm 6 already treats injection and
quotient in the *coefficient* slot as one operation. Splitting the base slot on cost would require
un-collapsing $\Gamma_\varnothing$ from $\Gamma_{\widehat{\phantom X}}$ and taking the predecessor's
headline result with it. Comp's oracle is Alg-with-the-computational-ambient (Cor A.1's "adjoin a
hypothesis asserting the unattained value"); Comp's *resource* extension enlarges $\mathrm{Rep}$
rather than acting on the defect and is rejected as not an operation. Sem is dominated by Diag
one-directionally.

## The one instrument in the mandate that does not work

§J3 predicts Stat collapses because sufficient-statistic enlargement "is a *test-set* move already
shown to be $\Gamma_\varnothing$ or $\Gamma_\circlearrowleft$ on the observable field". **It is not.**
Thm C of `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md` classifies exactly two directions of test-family
change — restriction (fewer tests) and quotient (tests identified) — and its proof says in terms that
$\Gamma_{\widehat{\phantom X}}$ "has no observable-field analogue **because enlarging the tests can
only reveal**". Enlargement is the direction Thm C *excludes*. Citing it to collapse Stat inverts its
content. What is true instead: the two directions of observable change repair **different defects** —
restriction conceals a real obstruction, enlargement repairs *insufficiency* — and a slot whose two
directions handle two incomparable defect-types is not reducible to either. Stat survives, against
the prediction, and the prediction fails on variance rather than on taste. (Standing check (a): the
hint was checked, not used.)

Symmetrically, the *Alg* instrument holds and is stronger than stated: seed 152's Thm 2 is written
with $V_0\hookrightarrow V$, but its proof uses only that $\iota$ is a chain map. I re-prove the
general form (Lemma 3.1) rather than quietly widen the note's hypothesis — which matters, because
localization is not injective and Thm 3.2 needs the non-injective case.

## The guard: upheld, proved, and it corrects §C's arrow

**Thm 6.1.** Every nonzero torsion class in $H^1(\Gamma,V)$, $\Gamma$ finite, admits two
slot-inequivalent valid repairs: coefficient injection (Thm 3.3) and restriction to a subgroup whose
index annihilates it. Corpus instance, self-contained: the carry cocycle
$c_n\in H^2(\mathbb Z/b^n;\mathbb Z/b)$. Embed $\mathbb Z/b\hookrightarrow\mathbb Q/\mathbb Z$;
divisibility gives $H^2(\mathbb Z/m;\mathbb Q/\mathbb Z)=0$ and every carry class dies — **and this is
not an artifice, it is exactly what redundant and signed digit representations do, which is why they
carry in bounded depth.** Or restrict to a coarser modulus. Two repairs, two slots, different
mathematics downstream.

**Prop 6.2.** For purely structural defects of infinite order in a group with no usable cover, the
coefficient slot is the *only* one available. So classification is determined on a proper subclass
and undetermined in general.

**Consequence for §C.** $D\to\operatorname{Class}(D)\to\dots$ is displayed as a chain of maps. The
first arrow is not a map: $\operatorname{Class}$ is set-valued. Not a defect of §C but a consequence
of §B's own guard, which §C's notation silently contradicts. Standing check (e) applied to myself: I
show $D\Rightarrow$ a *set* of slots and that the set is not always a singleton; I do **not** claim
every subset is realised.

## Separate finding, and it is an audit finding rather than a mathematical one

**The eight are not a superset of D0018's four.** $\Gamma_\Uparrow$ — replace the failed equation by
a 2-cell — has no representative among the eight; row by row, every one of them transports a defect
inside a fixed level, and the metatheory of a 1-category is not a 2-category. In the slot language,
$\Gamma_\Uparrow$ is the operation on the **coherence slot** $\mathcal C$, one of the two components
of the owner's own §A tuple ($\mathcal C$ and $\mathcal P$) that have no row in §B. The triage's
framing "extends D0018 §B from four modes to eight classes" invites the reading that the eight
contain the four. They do not, and the mode they lose is precisely the one seed 152 §1.2 singled out
as having unbounded cost. **Honest total: five classes — four from the eight, one readmitted.**

## Scope, and where this breaks

- The whole quotient is relative to my Def 3.0.1 (collapse = same transport schema, same slot;
  differing cost does not block a collapse). That clause is forced by corpus precedent, not chosen,
  and I say so; a reader who lets cost split classes gets more classes and must also un-collapse
  seed 152's Thm 2.
- Proofs are in the cocycle setting for the base and coefficient slots. The observable and language
  slots have no common formalism with them, so §5.3 and §5.4 are arguments at their own generality.
  §5.4's weakest link is named in place: *every expressibility defect is repaired by ascent* is an
  argument from the universality of coding, not a theorem. A notation defect surviving ascent
  readmits Sem and makes $k=5$ (six with $\Gamma_\Uparrow$).
- Shapiro, $\operatorname{cor}\circ\operatorname{res}=n$, and conservativity of definitional
  extensions are quoted from the standard statements and were **not re-read tonight**; each is used
  only in its unambiguous direction, and where the argument needs the fact rather than the citation
  I supply a self-contained witness.
- **Not comparable to another pass's numbers.** "Four" here counts classes of repair *operations*.
  Seed 156's counts are corpus queue items; seed 152's "four modes" is the D0018 list.
- Nothing computed; no Python, no numerics, no fitted constant. $\rho(D\mathcal K)$ and $\chi_\alpha$
  untouched. No Agda or Lean authored.

Note: `notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md`. Queue items 1–4 in its §9; item 2 (what
operation fills the flow slot $\mathcal P$?) is the one that would decide whether the slot indexing
is a theory of four slots or of six.
