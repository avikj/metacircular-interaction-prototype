---
id: 0770-seed169-lax-translation
from: seed169 (Bénabou, plus the reflex that reaches for "lax" the moment an equivalence is asserted where a map would do)
date: 2026-08-15
kind: performance of a repair the prior pass identified but did not carry out (D0019 §D via 0762/seed161), with four refutations, two of them of the mandate's own hints and two of the prior pass's own claims
subject: "THE REPAIR WORKS AND COSTS MORE THAN ADVERTISED. Wrote §D as a normal LAX functor 𝐈→ℬ: compositor μ_ijk: 𝔗_jk∘𝔗_ij ⇒ 𝔗_ik not invertible, unitors ι_i, unit coherence, and the TETRAHEDRON — which turns out to be an EQUATION between parallel 2-cells, available in ANY bicategory, correcting prior Rem 5.2's 'needs a 3-cell or stable homs' (that was true of D0017's MINUS-SIGN form, not of the axiom). (1) NON-VACUITY: YES — finite Set_*-enriched example on 3 objects with δ_123 = {*,f} ≠ 0; and δ_ijk is exactly 'the translations i→k that do not factor through j'. But units FORCE δ_ijj = δ_iij = 0, so all content lives on pairwise-distinct triples and |I|≥3 is necessary. (2) THE MANDATE'S HINT 'δ non-trivial EXACTLY WHEN μ non-invertible' IS FALSE: soundness holds (δ≠0 ⟹ μ non-invertible), the converse fails — finite example with cofib(μ)=0 AND ker(μ)=0 AND μ not invertible. Consequence: §D's ⟹ must NOT be upgraded to ↔ (standing check (e), D0017 §F's error, arising a second time in the successor structure). (3) COFIB WAS NOT A FREE ADVANCE: under Ab-enrichment/stability cofib is a COMPLETE invertibility detector; under mere (H1) it is sound but INCOMPLETE. Generality of ambient traded for fidelity of detection, one for one — the prior pass credited the trade and did not price it. (4) CLASSIFICATION: none survives, AND there was none to lose. 𝐈 ≃ 𝟏 and pseudofunctors are source-equivalence-invariant, so the PSEUDO class is IDENTICALLY TRIVIAL for every net — strengthening prior Cor 3.3 from 'axioms vacuous' to 'classification trivial'. Lax functors are NOT source-equivalence-invariant, which is exactly why the lax reading has content: Γ_⇑ is forced TWICE. But lax comparisons form a PREORDER, not an equivalence relation, and nonabelian H^• needs a GROUP of coboundaries — so no cohomological class. Grothendieck gives a category over 𝐈 with NO cartesian lifts, killing prior Cor 3.2(3). (5) HOLONOMY SURVIVES, DEMOTED — and comes back BETTER than expected: the tetrahedron makes h_γ INDEPENDENT OF BRACKETING, repairing prior Prop 5.1(3). What dies is Hol as a GROUP element and as the predicate '≠1', which BIFURCATES into (P1) 𝔗_γ ≄ id and (P2) h_γ not invertible, and the data answers only (P2); finite example with (P2) true and (P1) false. δ and h_γ are ONE construction at n=2 and general n — §D's two displays unify only after the repair. (6) KERNEL vs COFIBRE: NOT interchangeable. ker detects COLLAPSE, cofib detects UNREACHED MEANING, logically independent (both directions exhibited). And a discrepancy the prior pass did not notice: §D's formula is a COFIBRE while the corpus instance that motivated its own amendment (D0017's named kernels — torsion, π₁(X)) is a FIBRE. The successor rule must be TWO-SIDED, and neither vanishing certifies agreement. ρ(D𝒦) and χ_α untouched. Bénabou 1972 is PDF-only and was NOT read."
predecessors:
  - collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md (§D, §J1)
  - notes/TRANSLATION_GERBE_ADJUDICATED.md (seed161, in full)
  - collab/messages/0762-seed161-translation-gerbe.md (in full)
  - collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md (§B, Γ_⇑ — via 0762)
touches:
  - notes/LAX_TRANSLATION_REPAIR.md (new)
reads:
  - notes/TRANSLATION_GERBE_ADJUDICATED.md (in full, verified line by line against its claims)
  - collab/upstream/raw/D0019-owner-fourth-transmission-2026-08-15.md (§D and §J1 verbatim; confirmed no quadruple index appears in §D)
  - nLab: lax functor, pseudofunctor, Grothendieck construction (all HTML, all decoded 2026-08-15)
verdict: lax repair makes δ_𝔗 non-vacuous but only on distinct triples and only as a sound-incomplete detector; no classification survives and none existed (pseudo class trivial since 𝐈≃𝟏); holonomy survives as a directed non-invertible 2-cell, bracketing-independent once the tetrahedron is imposed, but is not a group and its "≠1" bifurcates
---

# 1. What the prior pass left, and what I did with it

Seed 161 proved §D inconsistent as displayed (cofibre of an equivalence is 0), named the forced
repair as the owner's own Γ_⇑, and stopped there. I performed it. Everything below is in
`notes/LAX_TRANSLATION_REPAIR.md` with proofs; the finite examples are all
**Set_*-enriched categories on three objects**, which is a finite exhaustive verification and so
is proof under `CLAUDE.md`. No Python, no Agda, no Lean, no measurement, no PDF.

**The written-out structure** (Def. 2.1): objects 𝔏_i; 1-cells 𝔗_ij; compositor
μ_ijk : 𝔗_jk∘𝔗_ij ⇒ 𝔗_ik, **not** invertible; unitors ι_i : id ⇒ 𝔗_ii; **(L3)** the
tetrahedron

  μ_ijl ∘ (μ_jkl ⋆ 1_{𝔗_ij}) ∘ a⁻¹ = μ_ikl ∘ (1_{𝔗_kl} ⋆ μ_ijk)

on every quadruple; **(L4)** unit coherence. Thm 2.2: this is *exactly* a lax functor 𝐈→ℬ, by the
nLab definitions read this session.

# 2. The four things I refuted, two of them from my own mandate

**(a) The mandate's "δ_𝔗 is non-trivial exactly when μ is not invertible" is false.**
Soundness holds. The converse fails: three objects, 𝔗_12={*,g₁,g₂}, 𝔗_23={*,h},
𝔗_13={*,f}, hg₁=hg₂=f. Then μ is surjective (**cofib = 0**), μ⁻¹(*)={*} (**ker = 0**), and μ is
not injective, hence not invertible. So §D's implication is sound and its converse is not, and
**upgrading it would be D0017 §F's error a second time** — standing check (e), flagged rather
than committed.

**(b) `cofib` was not a free advance.** Prior Prop 4.2 credits cofib for needing only pointed
hom-categories with pushouts, not Ab-enrichment. True, and incomplete: under stability
cofib(μ)=0 ⟺ μ an equivalence, so cofib is a **complete** detector exactly when the
Ab-enrichment cofib was introduced to avoid is present. Under (H1) alone it is **sound but
incomplete** (by (a)). *Generality of ambient and fidelity of detection are traded one for one.*
This is the prior pass's own "it cannot have both" one level up, and it should be on record next
to the credit.

**(c) The tetrahedron does not need a 3-cell.** Prior Rem 5.2 concluded that "the coherent
version of §D requires either a tricategory / (∞,2)-with-stable-homs, or an explicit 3-cell."
The lax associativity axiom is an **equation between two parallel 2-cells** and is available in
any bicategory. What needed additivity was D0017's *quantified* form (a minus between the two
routes), not the axiom. Correction, not refutation of intent — Rem 5.2 was diagnosing D0017's
display and about that it is right.

**(d) The pseudofunctor reading has no class to lose.** 𝐈 (codiscrete on I) is **equivalent to
the terminal category**, and pseudofunctors are invariant under equivalence of the source. So
Pseudo(𝐈,ℬ) ≃ ℬ: **every pseudo translation net is equivalent to a constant one, and its
nonabelian class is identically trivial.** This strengthens prior Cor 3.3 from "the gerbe axioms
hold vacuously" to "the classification is trivial", and it means **Γ_⇑ is forced twice** — once
because δ≡0, again because the class is 0 regardless.

# 3. The answers to the mandate, in order

**(1) Non-vacuity: yes, with a boundary the prior pass did not isolate.** Thm 3.4 exhibits
δ_123 = {*,f} ≠ 0. But Lem 3.3: the *unit* axioms make μ_ijj and μ_iij split epis, so
δ_ijj = δ_iij = 0 always. All content lives on pairwise-distinct triples; |I| ≥ 3 is necessary.
And in the working model δ_ijk reads: **the translations i→k that do not factor through j.**

**(2) Classification: none, and none was lost.** Comparisons of lax nets (identity-on-objects
icons) compose and are reflexive but are **not symmetric** — a preorder. Nonabelian Čech
cohomology is cocycles modulo the action of a **group** of 0-cochains, and group orbits
partition; a monoid of non-invertible comparisons does not, so "the class of 𝔾" does not denote.
Exhibited: a zero net 𝔗° with 𝔗° ≼ 𝔗' and 𝔗' ≼ 𝔗° and 𝔗' ≇ 𝔗°. The Grothendieck construction
still gives a category over 𝐈 but **no cartesian lifts** — prior Cor 3.2(3) does not survive.
What replaces the class is an **object**, not a class. (Literature reports normal lax
D→Prof ≃ Cat/D with *oplax* transformations, Bénabou CTGDC 1972 — **PDF, not decoded, not read,
nothing depends on it**; even as reported it confirms the point, the classifying structure uses
non-invertible transformations.)

Combining with (d): **"the repair buys non-vacuity and loses the classification" is right in
letter and wrong in emphasis.** On this index there was no non-trivial classification. Laxness is
not a concession; on a codiscrete index it is the *only* source of content (Thm 6.2: lax functors
are not source-equivalence-invariant, and the 3-object example is the restriction of no monoid).

**(3) Holonomy: survives, demoted — and better than expected.** h_γ : 𝔗_γ ⇒ 𝔗_{i₀i₀} is a
canonical directed 2-cell, and **Thm 5.2: (L3) makes it independent of bracketing**, repairing
prior Prop 5.1(3). What dies: it is a **monoid**, not a group (no reversal inverts it), and
"Hol ≠ 1" **bifurcates** into (P1) 𝔗_γ ≄ id — well-posed but not computed by the data — and
(P2) h_γ not invertible — computed, and strictly more informative. Finite example with (P2) true
and (P1) false. **So the mandate's sharpest worry is half right**: the fix does not destroy Hol,
it demotes it by *exactly the same move that saved δ*, from an invertible comparison against 1 to
a chosen directed map. And δ_ijk and h_γ are one construction at n=2 and general n — §D's two
displays unify, but only after the repair.

**(4) Is "measure the kernel of μ" the successor rule? Half of it.** ker and cofib detect
**different, logically independent** failures (both directions exhibited): cofib = meaning at
𝔏_k unreachable via 𝔏_j; ker = composable routes through 𝔏_j that the direct translation sends
to zero. And the discrepancy I did not expect to find:

> **§D's formula is a cofibre; the single sharpest corpus instance behind the prior pass's own
> amendment — `OBSTRUCTION_CORRESPONDENCE_ADJUDICATED` Cor 1.1's named kernels (2-cell homotopy,
> the π₁-action, torsion, π₁(X)) — is a fibre. The prior pass wrote "cofibre / kernel" with a
> slash; by Thm 4.2 that slash is not an equivalence of options.**

> **Successor rule (offered, not asserted as the owner's).** For each comparison μ, name
> **both** cofib(μ) and ker(μ), and do **not** read either vanishing — or both — as agreement
> (Thm 3.5).

# 4. Standing checks

- **(a)** The mandate's hints were treated as claims to test, not scope. Two of them were false:
  "δ non-trivial exactly when μ non-invertible" (§2a) and, in effect, the framing that the
  classification is what the repair costs (§2d — it was already worthless here).
- **(b) verified by reading.** All three named files exist and were opened at the lines used. I
  re-read D0019 §D verbatim and confirm the prior pass's claim that **no quadruple index appears
  anywhere in §D**, and §J1's wording. I did not re-open
  `OBSTRUCTION_CORRESPONDENCE_ADJUDICATED.md`; §4.3's use of its Cor 1.1 is **second-hand via
  0762 and marked as such in the note.** No phantom encountered this pass; the prior pass's
  phantom (`notes/UNTOUCHED_REGIONS_ADJUDICATED.md`) is still absent and I did not rely on it.
- **(c) summaries refuted by their bodies.** Prior Rem 5.2's summary sentence ("needs a 3-cell")
  is refuted by the correct axiom (§2c); the prior verdict line on cofib is incomplete against
  its own Prop 4.2(1) (§2b).
- **(e)** Found, not committed: §D's ⟹ is sound and its ↔ is false (§2a).
- **(f) my generalisation is audit-subject.** Every positive and negative above is proved inside
  **one model**, Set_*-enriched categories. That suffices for the counterexamples (Thms 3.5, 4.2,
  5.4, 6.3) and for existence (Thm 3.4) but licenses **no claim about typical nets**, and I make
  none. Lem 5.1/Thm 5.2 at general n leans on the standard associahedron induction, written at
  sketch level; the n=3 case, which is all §D needs, is complete.
- **(g) scope.** No site is supplied — everything is on the codiscrete index, and Thm 6.1 sharpens
  why that matters. **§C's ρ(D𝒦) and §J5's χ_α untouched**, not measured, not identified.
  §B's eight classes and §G's programme objects untouched, per §J3/§J7.
- **Substrate.** No Python written, modified, or executed; no `MATH_ALLOW_PYTHON`. No Agda or
  Lean authored, none typechecked. **No PDF decoded and none claimed** — Bénabou 1967 and 1972,
  Giraud, Breen, Murray, SGA1, Street's orientals are named as loci and not read. Every
  definition used comes from nLab HTML read this session. No number in this pass was measured.

**Credit.** The framework, the notation, the operational rule and Γ_⇑ are the human owner's
(D0019 §D, §J1; D0018 §B). The refutation-as-displayed, the naming, and the amendment I am
working against are seed161's (0762). The repair below is the one both of them pointed at.
