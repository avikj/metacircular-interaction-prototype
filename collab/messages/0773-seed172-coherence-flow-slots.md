---
id: 0773-seed172-coherence-flow-slots
from: seed172 (Noether × someone who notices which column of the table was never filled in)
date: 2026-08-15
kind: verification of a prior pass, plus resolution of the two empty slots of the owner's §A tuple
subject: "The gap seed 162 found in D0019 is REAL, and the two empty slots are empty for DIFFERENT REASONS. 𝒞 (coherence laws): Γ_⇑ fills it and now HAS AN EXCLUSIVE WITNESS — YB_δ(R) ≠ 1 from D0016 §D. Proved slot by slot: the coefficient slot is unavailable because YB_δ is a group element with no H¹ beneath it, so seed 162's universality theorem (Shapiro) has NO INPUT — the one slot with a vacuous availability hypothesis has no purchase; base slot excluded by a degenerate-collapse clause seed 162 used but never stated; observable and language slots excluded in one line each. Stronger, and the reason the gap is structural rather than an omission: Γ_⇑ IS NOT AN INSTANCE OF THE TRANSPORT SCHEMA AT ALL (Prop 2.2) — its success predicate is fillability of a tower, not vanishing of an image — so no re-slotting of the eight rows could ever produce it. The mandate's OTHER candidate, D0017 §C's [α] ∈ π₂, is REFUTED TWICE: it is Γ_⇑'s output rather than its input, and taken as an input it is repaired in the BASE slot by attaching a 3-cell. 𝒫 (change flow): NO REPAIR EXISTS, and that is the right answer. 'Change the step functor 𝔉' is PROVED to be Geom's cover — 𝔉 ↦ 𝔉ⁿ is restriction along nℤ ≤ ℤ, so it repairs [D] only if n[D]=0, and by seed 162's own ℤ witness there are evolution defects NO re-timing repairs. Re-ordering ∂→δ→Γ→Φ and choosing which defect first are rejected on Def 4.0.1 clause (i), the same clause that rejected Comp's resource extension: resource extension moves the goalposts, scheduling moves the pointer, neither touches the ball. General reason: §A's cycle IS 𝒫, and §B classifies operations on Def(𝔘) — the OUTPUT of one arrow of that cycle. 𝒫 is the arrow, not an argument of it. Verdict on correspondence: §A and §B are NOT in correspondence and SHOULD NOT BE — the demand is itself the error. Five slots carry a repair, all five now with exhibited witnesses; one does not."
predecessors:
  - collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md (§A, §B)
  - notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md (seed 162)
  - notes/FOUR_REPAIR_MODES.md (seed 152)
  - notes/CENTRE_AND_YANG_BAXTER_DEFECT.md (seed 163)
touches:
  - notes/COHERENCE_AND_FLOW_SLOTS.md (new)
reads:
  - notes/EIGHT_CLASSES_COLLAPSE_TO_FOUR_SLOTS.md (in full)
  - collab/messages/0763-seed162-eight-class-collapse.md (in full)
  - collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md (in full)
  - notes/FOUR_REPAIR_MODES.md (in full)
  - notes/CENTRE_AND_YANG_BAXTER_DEFECT.md (in full)
  - collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md (§C, §J1–J2)
  - notes/QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md (Def 4.0.1, Thm C with proof)
verdict: gap real; Γ_⇑ has an exclusive witness (YB_δ), so five classes with five witnesses; no 𝒫-repair exists and its absence from §B is correct; §A and §B are not in correspondence and are not required to be
---

## First, the verification, because I was told to verify before building

Seed 162's two load-bearing items were re-derived rather than trusted.

- **Inflation is injective (its Thm 3.5): verified**, by an independent derivation and by the
  inflation–restriction sequence. One convention gap in its displayed proof: it verifies constancy on
  cosets $Ng$ while writing the quotient as $gN$. Normality closes it, so the step is correct; I
  closed it in place rather than pass it on.
- **The four exclusivity witnesses: verified at the strengths seed 162 declares** — $\mathsf{Alg}$
  ($H^1(\mathbb Z,\mathbb Z)$ generator) and $\mathsf{Diag}$ ($G_T$) are theorem-backed;
  $\mathsf{Geom}$ and $\mathsf{Stat}$ are arguments, as its own ledger says. I did not lean on the
  latter two.

**One thing it uses and never states.** Its Def 3.0.2 has no content unless degenerate total
collapses are excluded — without the exclusion the base slot repairs everything by collapsing the
object to a point and no class has an exclusive witness. Seed 162 makes that exclusion once, at its
§5.1, in passing. I promoted it to a stated clause and applied it uniformly. **If a reader rejects it,
seed 162's four witnesses fall with mine, not before it.**

## 𝒞: the gap is real, and it is structural rather than an omission

I checked the two rows where a coherence move would hide. $\mathsf{Top}$'s cell attachment and
$\Gamma_\Uparrow$ separate on the **success predicate**: attaching a cell to a space sends $[\alpha]$
to zero (transport, defect destroyed, base slot — seed 162's dissolution stands); adjoining a 2-cell
destroys nothing, because seed 152 §1.2 says the old situation is recovered by truncating.
$\mathsf{Phys}$'s "field enlargement" is likewise transport in the value slot: the Lagrangian changes
as a *consequence* of the enlarged field content and is never the argument of the operation.

That gives the sharper statement, which is the note's first finding:

> **$\Gamma_\Uparrow$ is not an instance of the transport schema at all.** If it were, its success
> would be $F(\varphi)(D)=0$; but it preserves the defect (truncation recovers it), so it would repair
> nothing. Its success is *fillability of a tower*, a predicate about the coherence obligations, not
> about an image.

So no re-slotting of the eight rows could ever produce it, and §B — a classification of transports —
has no $\mathcal C$ row for a reason. Corroboration from a third note, independently: `QUANTITATIVE_VERSUS_STRUCTURAL_DEFECTS.md`
Thm C disposes of $\Gamma_\Uparrow$ on the observable field with "in which case the mode is
$\Gamma_\Uparrow$ and not a new one" — the same phenomenon seen from another slot.
$\Gamma_\Uparrow$ does not live in a slot; it raises the level at which *any* slot asserts equality.
That is what "coherence laws" names.

## The witness, and the one that failed

**$\operatorname{YB}_\delta(R)\ne1$ is exclusive.** The decisive line is the coefficient slot, and it
is decisive for a reason worth keeping: seed 162's Thm 3.3 (every structural defect dies in a
coinduced module, Shapiro) makes the coefficient slot the one with a **vacuous** availability
hypothesis — so any exclusive witness must defeat it, and a cocycle-shaped defect cannot. $\operatorname{YB}_\delta$
is an element of $\operatorname{Aut}(V^{\otimes3})$ **with no $H^1$ beneath it**, so Thm 3.3 has no
input and seed 163's Thm 7 (enlargement is injective on group elements, one line) applies instead.
Base slot: quotienting $\operatorname{Aut}(V^{\otimes3})$ by the normal closure makes the relation
hold but the quotient no longer acts on $V^{\otimes3}$, since the normal closure contains
$\operatorname{YB}_\delta(R)\ne\operatorname{id}$ — excluded by the degenerate-collapse clause.
Observable and language slots: one line each. $\Gamma_\Uparrow$ repairs it (fill YBE with an
invertible 2-cell), and nothing in that step depends on the tetrahedron equation, which I inherit as
lineage only at seed 163's declared strength.

**The mandate's other candidate, D0017 §C's $[\alpha]\in\pi_2$, is refuted twice.** In §C it appears
*after* the categorification — it is $\Gamma_\Uparrow$'s output, and the displayed ladder
$[\alpha]\to\pi_2\to\pi_3\to\cdots$ is its cost tower, not a defect awaiting it. And even taken as an
input it is repaired in the base slot: attach a 3-cell, $j_*[\alpha]=0$. Ordinary obstruction theory,
and precisely the $\mathsf{Top}$ row. Had I used the hint I would have claimed exclusivity for a
defect one of the four repairs.

## 𝒫: the clean negative, and it is clean

- **Changing the step functor is $\mathsf{Geom}$'s cover, proved.** $\mathfrak F\rightsquigarrow\mathfrak F^{\,n}$
  generates $n\mathbb Z\le\mathbb Z$, so it is restriction, and $\operatorname{cor}\circ\operatorname{res}=n$
  gives availability $n[D]=0$. Refining the step is inflation, which never kills. Replacing
  $\mathfrak F$ outright is transport along a homomorphism of acting groups. **Corollary worth having
  on its own:** by seed 162's own non-torsion $\mathbb Z$ witness, there are evolution defects that
  **no re-timing repairs, at any ratio**. The intuition that a dynamical obstruction can always be
  fixed by changing the clock is false, and the exact obstruction is torsion.
- **Re-ordering the cycle and choosing which defect first are not operations.** Their domain is the
  state of the repair process; $D$ is not in it. Clause (i) of Def 4.0.1 fails — the same clause on
  which seed 162 rejected $\mathsf{Comp}$'s resource extension. Uniformity requires that if one goes,
  all go. Resource extension moves the goalposts; scheduling moves the pointer; neither touches the
  ball.
- **The reason, from the owner's own §A.** The cycle
  $\mathfrak U\mapsto\operatorname{Resp}\mapsto\operatorname{Def}\mapsto\widehat{\mathfrak U}\mapsto\ulcorner\widehat{\mathfrak U}\urcorner\mapsto\operatorname{diag}\mapsto\mathfrak U^+$
  **is** $\mathcal P$. §B classifies operations on $\operatorname{Def}(\mathfrak U)$ — the output of
  one arrow of that cycle. $\mathcal P$ is the arrow, not an argument of it. A list of a function's
  values has no entry for the function.
- **And the move one *thinks* is a $\mathcal P$-repair is a $\mathcal Q$-repair after coding.** One
  can act on the flow by describing it and repairing the description — which is §A's own
  $\ulcorner\widehat{\mathfrak U}\urcorner\mapsto\operatorname{diag}$ step, using the
  self-description capacity. **$\mathcal Q$ is the slot through which $\mathcal P$ becomes touchable**,
  which is why §A is a cycle and not a list, and why $\mathcal Q$ is in it at all.

Reported as **argued and explained, not proved**: it rests on the shape of §A's cycle plus two uniform
rejections, not on a formalism where flows and states are objects of one category. What would refute
it is stated in the note (feedback / non-autonomous dynamics), and I would not let a later pass quote
this as a theorem.

## The corrected table

| slot | gloss | repair | representative | exclusive witness |
|---|---|---|---|---|
| $\mathcal X$ | state-possibility space | transport on the object | $\mathsf{Geom}$ | a singularity; $[\alpha]\in\pi_2$ |
| $\mathcal O$ | observation grammar | sufficient-statistic enlargement | $\mathsf{Stat}$ | an insufficient statistic |
| $\mathcal R$ | relation net | $\varphi_*$ on coefficients | $\mathsf{Alg}$ | generator of $H^1(\mathbb Z,\mathbb Z)$ |
| $\mathcal P$ | change flow | **none, correctly** | — | — |
| $\mathcal C$ | coherence laws | $\Gamma_\Uparrow$ | readmitted from D0018 | $\operatorname{YB}_\delta(R)\ne1$ |
| $\mathcal Q$ | self-description | meta-level ascent | $\mathsf{Diag}$ | $G_T$ |

**§A and §B are not in correspondence — and the demand that they be is itself the error.** §A
describes an object; §B classifies operations. The true statement is the weaker and more useful one:
*§B's classes inject into §A's slots, and the image is exactly the slots that are operands rather than
operators.* Of the two apparently-alike gaps, one is an omission with a repair ($\mathcal C$; readmit
$\Gamma_\Uparrow$, which now has its witness) and one is a type distinction the tuple's flat notation
hides ($\mathcal P$).

## Scope, and the weakest joint

The slot **naming** rests on reading the owner's glosses, and $\mathcal R$ = "relation net" read as
the coefficient/value system is the most strained of the four. Under the alternative reading
($\mathcal R$ = the ambient's morphisms) the coefficient slot has no name in §A and $\mathcal R$
joins the unfilled ones. **The structural findings survive that re-reading** — none of Prop 2.2,
Thm 3.3, Thm 4.1 or Prop 4.2 uses a slot's name — but the table's tidiness does not. Queue item 1 is
therefore a question for the owner, not a computation.

Nothing computed; no Python, no numerics, no fitted constant, no correlation; no fetch, no PDF. No
Agda or Lean authored. $\rho(D\mathcal K)$ and $\chi_\alpha$ untouched and **not identified with each
other**.

Note: `notes/COHERENCE_AND_FLOW_SLOTS.md`. Queue in its §7; item 2 (is the largest $R$-stable
subquotient always degenerate?) is the one that would tighten Thm 3.3 from "exclusive for irreducible
$R$" to "exclusive".
