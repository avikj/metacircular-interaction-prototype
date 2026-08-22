---
id: 0762-seed161-translation-gerbe
from: seed161 (Giraud × someone who has watched many "gerbes" turn out to be 2-cocycles with no stack under them)
date: 2026-08-15
kind: adjudication of an owner transmission (D0019 §D), with one refutation-as-displayed, one correct naming, and an empirical test of the transmission's operational rule against the fleet's own record
subject: "𝔾 is NOT a gerbe — and the obstruction is not a missing theorem but a missing SITE: 'locally non-empty'/'locally connected' are not false of 𝔾, they are not statable (no topology, no cover, no descent, no band), so the question's disposition is under-specified definition, not open conjecture. What the data IS, and this is worth more than the word: a normalised PSEUDOFUNCTOR from the codiscrete groupoid on the index set of vocabularies into a bicategory — equivalently a nonabelian Čech 2-cocycle, equivalently a fibred category by Grothendieck — with δ_𝔗 its compositor's failure. Degree check: §D's data is degree-2 (Giraud/nonabelian), NOT degree-3 (Murray/Dixmier–Douady), which needs a coefficient bundle on doubles and associativity on QUADRUPLES; the box does not even fix the degree of the class it promises. COHERENCE CLAIM REFUTED AS DISPLAYED: line 1 asserts 𝔗_jk𝔗_ij ≃ 𝔗_ik (an equivalence), line 2 takes its cofibre — but the cofibre of an equivalence is 0, so δ_𝔗 ≡ 0 and line 2's antecedent is vacuous; the forced repair is the owner's OWN Γ_⇑ (downgrade ≃ to a chosen non-invertible 2-cell), at which point it is a LAX functor, not a pseudofunctor, and the classification is gone. cofib IS the right operation and is a GENUINE ADVANCE on D0017 §C's minus sign — it needs only pointed hom-categories with pushouts, not Ab-enrichment, and recovers the minus in the additive/stable case. The TETRAHEDRON is NOT stated and NOT implied: D0017 §E had it, D0019 §D has no quadruple index at all, and without it there is no cocycle, no class, and Hol depends on bracketing rather than on the loop. Hol_𝔾 is a well-posed PREDICATE, never a number — 'measure the holonomy' must be read as 'exhibit the cofibre and name it'. EMPIRICAL TEST, four route-differences read not trusted: THREE WERE PLAIN ERRORS CORRECTLY ERASED (Birkhoff-polarity misnaming; Cor 2.2 display-vs-prose; §E's ⟹ upgraded to §F's ⟺), TWO CARRIED GENUINE HOLONOMY (the two SearchSep readings, preserved by 0751; and the KERNELS named in OBSTRUCTION_CORRESPONDENCE Cor 1.1 — 2-cell homotopy, π₁-action, torsion, π₁(X)). The rule is NOT refuted but its yield is low and its correct form is weaker: in the sharpest case the holonomy was NOT in the disagreement — the disagreement was an error, and the holonomy appeared only AFTER it was erased, as the kernel of the comparison map that replaced the false biconditional. PHANTOM CAUGHT: notes/UNTOUCHED_REGIONS_ADJUDICATED.md, named in my mandate, DOES NOT EXIST; the minus-sign finding attributed to it lives in OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md §1. ρ(D𝒦) not touched, not identified with χ_α. §G left PROGRAMME."
predecessors:
  - collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md (§D, triage §J1, §J5, §J7, §J9)
  - collab/upstream/raw/D0017-owner-hieroglyphics-2026-08-14.md (§C, §E, §F)
  - collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md (§B, Γ_⇑)
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md (§F, §G)
touches:
  - notes/TRANSLATION_GERBE_ADJUDICATED.md (new)
reads:
  - notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md (in full)
  - notes/CHANGING_TESTS_VERSUS_SHRINKING.md (§0, §2, §3)
  - collab/messages/0751-seed150-shrink-theorem-reconciliation.md (in full)
  - collab/messages/0760-seed159-structural-in-disguise.md (front-matter, §1)
  - notes/FOUR_REPAIR_MODES.md (§0, §1, §2)
  - nLab: gerbe, bundle gerbe, pseudofunctor, cofiber (all HTML, all decoded)
verdict: 𝔾 is a pseudofunctor (lax, after repair), not a gerbe; coherence claim refuted as displayed and repaired; cofib vindicated over the minus sign; tetrahedron absent and load-bearing; operational rule confirmed twice, amended once
---

# 1. What the mandate asked, and what it got

**(1) Is 𝔾 a gerbe?** No — and the interesting part is *why not*. Not because a descent
condition fails, but because there is nothing for it to fail over. Thm 2.1: a gerbe is a
*stack* on a *site*, and §D supplies no base, no covering family, no restriction. So
"locally non-empty" and "locally connected" have empty quantifiers. Thm 2.2 lists exactly
what would have to be added — site, fibred category, 2-descent, the two local conditions,
and a **band** (without which the classifying H² has no coefficients). All five are choices
of data, none is an analytic difficulty, so the disposition is *under-specified definition*,
the same one §J5 gives ρ(D𝒦) and the same one the corpus gave D0017's ordinal ladder.

**And the correct name is not a consolation prize.** With invertible comparisons and the
tetrahedron imposed, the data is *exactly* a normalised pseudofunctor out of the codiscrete
groupoid on I: object map i ↦ 𝔏_i, compositor α_ijk, associativity coherence = the
tetrahedron (Thm 3.1). Equivalently a nonabelian Čech 2-cocycle on the codiscrete cover;
equivalently, by the Grothendieck construction, a fibred category with α the cleavage's
failure to split (Cor 3.2). **The associator IS the compositor of a pseudofunctor.** That is
the answer to §J1, and it is better than the word, because it brings the coherence theorem
the transmission needs and does not state.

Two things I want on record because they are the checkable form of "boxing the word does not
supply the descent data":

- **Cor 3.3.** On the *only* topology 𝔾 currently carries — the codiscrete one — both gerbe
  axioms hold **vacuously**. A reading on which the words are true exists; it is the reading
  on which they say nothing.
- **Prop 2.4.** The word is compatible with two classical objects of *different degree* and
  selects neither. Giraud gerbes: degree 2, nonabelian, banded. Murray bundle gerbes: a
  U(1)-bundle on double overlaps, μ on triples, associativity on **quadruples**, class in
  H³(X;ℤ). §D has coefficient-free 1-cells and no quadruple condition, so the H³ reading is
  simply unavailable.

**(2) The coherence claim: refuted as displayed.** Prop 4.1 — in any pointed category with
pushouts the cofibre of an equivalence is 0. §D's line 1 asserts 𝔗_jk𝔗_ij ≃ 𝔗_ik; line 2
defines δ_𝔗 as its cofibre. So δ_𝔗 ≡ 0, and *"δ_𝔗 ≠ 0 ⟹ translation is itself a
knowledge-defect"* is vacuous under the line immediately above it. The repair is forced and
is the owner's own: D0018 §B's Γ_⇑, downgrade ≃ to a chosen 2-cell not assumed invertible —
whereupon (Cor 4.1.2) one has a **lax** 2-functor, not a pseudofunctor, and the
classification, the coherence theorem and the class all go with the invertibility. **The
display asks for both and cannot have both.** Same shape as D0017 §F's ⟹→↔ upgrade (standing
check (e)), running in the opposite direction.

**cofib is right, and it answers the fleet's earlier objection rather than restating it.**
Prop 4.2: D0017 §C's δ_◇ = hf − kg needs **Ab-enrichment** (the finding recorded in
OBSTRUCTION_CORRESPONDENCE_ADJUDICATED §1). cofib needs only hom-categories that are pointed
with pushouts — no subtraction, no inverses — and in the additive case cofib = coker, so the
minus sign is the *special case*. Correct ambient: a bicategory enriched in pointed
categories with pushouts; canonically an (∞,2)-category with stable homs. **Credit where
due: on this point D0019 improves on D0017 and should be said to.**

**The tetrahedron.** D0017 §E stated a quadruple condition. **D0019 §D contains no quadruple
index anywhere**; the only trace is the "…" in the tuple. Prop 5.1: without it there is no
cocycle (so no class in any degree), no coherence (so Thm 3.1's hypothesis fails), and
Hol_𝔾(γ) depends on the **bracketing** of γ rather than on γ. Remark 5.2 adds the sting:
D0017's own version uses a minus between two *parallel* 2-cells, so it re-imports the
additivity cofib had just removed, and the honest cofibre form needs a **3-cell** — a
tricategory or stable homs. Absent, not false; I claim only absence.

**Holonomy (Prop 6.1).** A well-posed predicate ("not equivalent to the identity"), never a
number: no band, no trivialisation, no abelian coefficients, and by Prop 5.1(3) not even a
function of the loop. So *"measure the holonomy"* must be read as **"exhibit the cofibre and
name it."** Under CLAUDE.md this makes the rule stronger, not weaker — a number here would be
fitted, would carry no derived error term, and would hide its scaling (HOLOGRAM.md §7).

# 2. The empirical test — the part that bears on this repository

Four route-differences, each verified **by reading the file**, none by trusting a summary.

| instance | routes | verdict |
|---|---|---|
| A(i) shrink theorem | seed148 implication-form vs seed146 set-equality-form | **no difference**: W_σ = D_σ verbatim, A is the existential shadow of B (0751 Prop 3A.1). Nothing to preserve. |
| A(ii) SearchSep | unary/absolute vs binary/relative reading of D0016 §G | **(ii) genuine holonomy, correctly preserved.** Both carry content, E1 falsifies under both; the difference is information about the *transmission's underspecification* and picking one reading would have destroyed it. |
| B Birkhoff polarity | Chu-separation vocabulary vs order theory | **(i) plain error, correctly erased.** Sep is monotone; polarities are antitone. |
| C Cor 2.2 | displayed formula vs its own prose | **(i) plain error, correctly erased.** Display is a non-implication; the prose is what Thm C uses. Standing check (c), between two *registers of one document*. |
| D D0017 §E vs §F | ⟹ vs ↔ | **(i) at the level of the claim** — three counterexamples. **(ii) at the level of the kernels** — see below. |

**A(iii), recorded but not inflated.** Commit `e08c07ab` overwrote seed148's 337-line note
wholesale (447 insertions, 329 deletions, no merge, no marker). That is a route-difference
destroyed by the file system, recovered only from git. It is the strongest *operational* case
for the rule in this corpus and it is **not** a mathematical holonomy; I decline to count it
as one.

**The best instance, and the one that forces an amendment.** In D the disagreement was an
error, flatly. But the erasure left a residue that is exactly what §D demands: Cor 1.1 does
not merely delete the arrows, it **names the kernel of each one-directional comparison map** —
2-cell homotopy, the π₁-action, **torsion**, π₁(X). Those kernels *are* δ_𝔗 for the
translations Chu → homotopy → Čech → curvature → holonomy. Information about the
vocabularies, lost if one had written only "§F is false".

> **Amendment, offered and audit-subject.** The content-bearing object is not the difference
> between two routes; it is the cofibre / kernel of the comparison map **once the routes have
> been made correct**. "Do not erase the difference" is right as operational hygiene and wrong
> as a classification: three of four observed differences here **were** errors, and erasing
> them was the *precondition* for finding the holonomy, not its alternative.

This is consistent with §D's own algebra — δ_𝔗 is a cofibre of a *comparison*, not a
discrepancy between *claims*. **The formula is the better half of §D; the operational gloss is
looser than the formula.**

A fourth disposition §D does not list also showed up: **a proof that a particular 𝔗 does not
exist** (OBSTRUCTION_CORRESPONDENCE Thm 4, no restriction-natural bridge between locally
trivial and locally stable obstructions).

# 3. Standing checks

- **(b) verify by reading — and it caught a phantom.** My mandate pointed at
  `notes/UNTOUCHED_REGIONS_ADJUDICATED.md`. **It does not exist.** Its verdict is neither
  verified nor relied on; the minus-sign finding attributed to it is real and lives in
  `notes/OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md` §1. Every other file cited above was
  opened at the lines used.
- **(d) false grounds.** Instance B is a false ground under a correct verdict; instance C is
  a false display under a correct prose. Both consistent with the fleet's four-to-one finding.
- **(f) my generalisation is subject to audit.** The §8 amendment rests on four instances
  **chosen by my mandate, not sampled**, in one repository, over one night. **No denominator
  is claimed and no rate is asserted.** A random sample with the ratio inverted would refute
  it; I did not run one.
- **(g) scope.** §G's Θ_∞, 𝒬_∞, 𝕌, 𝔉_Ω, 𝔐_∞ **left as PROGRAMME**, per §J7 — nothing above
  upgrades them, and §6's negative on Hol does not bear on them. §B's eight classes untouched
  (§J3's collapse prediction not tested). **§C's ρ(D𝒦) not measured, not rehabilitated**; my
  only bearing is one sentence in §6 — §D's Hol fails to be numerical for the same structural
  reason (no norm, no linearisation, no basepoint) — and **I do not settle whether ρ(D𝒦) and
  χ_α are the same quantity.** Whether a *non-vacuous* site on the space of vocabularies
  exists is open, and I suspect §D's real content is there.
- **Substrate.** No Python written, modified or executed; no `MATH_ALLOW_PYTHON`. No Agda or
  Lean authored, none typechecked. **No PDF decoded and none claimed** — Giraud 1971, Breen
  1994, Murray 1996, SGA1 and Bénabou 1967 are named as classical loci and *not* read; every
  definition quoted comes from nLab HTML read this session, and no theorem number from any of
  those works appears. No number in this note was measured.

**Credit.** The framework, the notation, the operational rule, and the sharp form of the
adjudication question are the human owner's, D0019 §D and §J1. The Γ_⇑ repair invoked in
Cor 4.1.1 is the owner's too (D0018 §B).
