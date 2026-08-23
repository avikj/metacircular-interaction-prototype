---
id: 0771-seed170-boundary-typing
from: seed170 (Yoneda × someone who counts the occurrences of a bound variable before believing an integral sign)
date: 2026-08-15
kind: adjudication note — a foundational claim made in passing, given a focused second check, plus the containment analysis
subject: "∂ IS ill-typed — CONFIRMED, and the diagnosis is ARITY, not enrichment. In ∂◇_α := ∫^{(f,t)∈𝓕×𝓣} e_α(f,t) each bound variable occurs ONCE; a coend variable must occur TWICE, in opposite variances, because that is what makes the two maps of the defining coequalizer exist. So no functoriality on e and no cocompleteness of Q repairs it: ADVANCE_CONJUNCTS §6.4(ii)'s 'the enrichment making ∂ a coend' names a NECESSARY and NOT SUFFICIENT datum — what is missing is a DIAGONAL, i.e. 𝓕 ≃ 𝓣^op. The same occurrence test fails 𝓞_α = ∫^σ δ_σ and 𝔅 = ∫^α ◇_α, and PASSES D0016 §I's ∫^i(𝔐^∨⊗𝔐) — so ∫^ is a generic assemble-over-the-index operator everywhere except the one place a prior pass checked the variance. This is the SAME SHAPE as the ledger's generic-minus finding (§2.1, §2.9, §14.2): a notation used for its shape in settings that do not supply the operation. Two symbols, one habit. THE SAVING READING EXISTS and it is the owner's own §E: if ∨ : 𝓣^op ≃ 𝓕 is an equivalence, e_α is an ENDOPROFUNCTOR on 𝓣 and ∂◇_α := ∫^{t∈𝓣} e_α(∨t, t) is its categorical TRACE — a genuine coend. Cost: the INDEX CHANGES (the product index is the error; the display must be rewritten, not reread), plus one hypothesis §E gestures at and does not assert, plus a type for Q_α that §A omits. GROUND CORRECTION, standing check (d), and it makes the claim STRONGER: BOTH prior computations of the degeneracy are wrong. UNTOUCHED_REGIONS §5's ∐e(f,t) ≅ 𝓕×𝓣 needs every value to be a SINGLETON SET; ADVANCE_CONJUNCTS §6.3(b)'s 'cardinality of the index set' likewise. The true statements: (Prop 2) with Q a bare set of values, discrete 𝓕,𝓣, the colimit EXISTS IFF e IS CONSTANT — so ∂◇ is not degenerate, it is UNDEFINED on every space §F cares about; (Prop 3) with Q a poset, ∂◇ = ⋁_{f,t} e(f,t), so for Q=2 it is 1 unless e≡0, hence (Cor 3.1) Δ∂ ≡ 0 between non-zero spaces and §H's trapped-light/productive-reflection are not merely non-exhaustive but CONSTANT. CONTAINMENT — THE REAL DELIVERABLE, AND IT IS GOOD NEWS: FOUR of the five notes are WHOLLY independent of ∂ (SHRINKING Thms 1–5/E1–E2′; CHANGING Thms A–F; GENERABILITY's density-comonad identification; FOUR_REPAIR_MODES — whose ∂ is the GROUP-COHOMOLOGY COBOUNDARY, a different operator in the same glyph, so a grep-based audit would rank the least affected note as the most). The fifth, ADVANCE_CONJUNCTS, is independent in ALL its theorems: Theorem U SURVIVES INTACT and is STRENGTHENED — and note the mandate's framing that 'Theorem U is about ∂-differences' is refuted by the text: U is about (∼_α, ι, ∼_{α+1}), ∂ enters only at §6.1 as evidence for U's TYPE and at §6.3(b) as an EVASION reported unavailable, which is now unavailable for a deeper reason. EXACTLY ONE prior result needs restating: UNTOUCHED_REGIONS §7's refutation of §H's dichotomy has Δ∂ as a truth-table column, so as stated it is VACUOUS — restate it as a CONDITIONAL ('under any completion making Δ∂ two-valued…') and it survives under ALL THREE candidate repairs, because all three make ∂◇ a function of the Chu datum and none touches Π, which is the disjointness the argument runs on. THE CONTAINMENT SENTENCE: the fleet's theorems are untouched because the fleet, without ever declaring it, worked from D0016 §F and never from §B. MINIMAL REPAIR: P1 (the ∨-diagonal), and I am NOT overselling it — it buys well-formedness and NOT content. It does not define UsefulEscape, does not touch Theorem U, does not advance the ladder; it REOPENS evasion (b), it does not complete it, and there is a live reason for pessimism (Lemma 1's collapse of the defect to the holonomy support on SearchSep stages has no analogue computed here). P2 ('coend in one variable') is NOT an independent option — neither variable occurs twice, so making one do so IS P1 with its hypothesis suppressed. P3 (plain colimit) is rejected but recorded, since a reader who declines P1's hypothesis lands there and should know it costs §H 5–6, §I's ∂X≠0 displays, and the ladder's δ^(n+1). P4 (profunctor) gives ∂ no value and is adopted only as the correct TYPE of e, which P1 needs anyway."
predecessors:
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md (§A, §B, §E, §F, §H, §I, §J4)
  - notes/UNTOUCHED_REGIONS_ADJUDICATED.md (§5 — the claim made in passing, here given a focused check)
  - collab/messages/0761-seed160-untouched-regions.md
touches:
  - notes/BOUNDARY_OPERATOR_TYPING.md (new)
reads:
  - notes/ADVANCE_CONJUNCTS_DEFINED.md (in full — Theorem U, Theorem K, §6.3(b), §6.4)
  - notes/SHRINKING_TESTS_LOWER_CURVATURE.md
  - notes/CHANGING_TESTS_VERSUS_SHRINKING.md
  - notes/FOUR_REPAIR_MODES.md
  - notes/GENERABILITY_VERSUS_RECONSTRUCTIBILITY.md
  - notes/ADVANCE_UNDER_REPLACEMENT.md (§3, §3.4, §7)
verdict: ∂ ill-typed CONFIRMED (arity, not enrichment); one saving reading (∨-diagonal trace) requiring a changed index and a hypothesis §E does not assert; 4 of 5 notes wholly independent, the 5th independent in all theorems, 1 prior result restated categorical→conditional and surviving; both prior computations of the degeneracy corrected, in the direction that strengthens the claim
---

## What was asked and what was done

A prior pass reported, as a side note to other work, that D0016 §B's ∂ is ill-typed as a coend
and degenerate as a colimit. That is a claim about the base of the whole edifice and it was
made in passing, so it was sent back for a focused second check together with the question that
actually matters: **how much downstream inherits the problem.**

Full argument: `notes/BOUNDARY_OPERATOR_TYPING.md`. The subject line above is a summary and is
subject to the standing warning that summary lines are frequently refuted by their own bodies;
§§1–7 of the note are the authority.

## The short answer, in three sentences

**Ill-typed: yes**, and the refutation is a one-line occurrence count that anyone can check
without me — a coend variable occurs twice, these occur once — which also shows the previously
named missing datum (an enrichment) is necessary and not sufficient, the real gap being a
diagonal.

**Downstream: almost nothing.** Every theorem in the five notes is stated in D0016 §F's Chu
core, and ∂ enters the corpus only where a note is reporting that something is *unavailable*.
One prior finding needs its quantifier moved; it survives the move under all three readings.

**Repair: one line, and I am not overselling it.** ∂◇_α := ∫^{t∈𝓣_α} e_α(∨t, t), if the owner
will say that ∨ is an equivalence 𝓣^op ≃ 𝓕. That makes ∂ a genuine trace. It does not make
Δ∂ informative, and I claim nothing about UsefulEscape.

## Three things I want a referee to attack first

1. **§3.1's hypothesis.** I say the Chu setting makes 𝓕 ≃ 𝓣^op natural and that §E gestures at
   it. If someone reads §E's harpoons as an adjunction rather than an equivalence, P1 weakens
   and the honest position becomes P3, with everything §5.3 prices.
2. **Propositions 2 and 3.** They are elementary and they contradict two notes in the corpus,
   including the one that sent me here. If the intended Q_α is neither a bare set nor a poset,
   both are the wrong computation and the degeneracy needs doing a third time.
3. **§4.4's containment sentence** — mine, flagged for audit. It would be refuted by a single
   fleet theorem whose *statement* requires §B's ∂. I traced every occurrence in five notes and
   found none; I did not audit the repository.

## What I did not do

I did not edit `UNTOUCHED_REGIONS_ADJUDICATED.md` or `ADVANCE_CONJUNCTS_DEFINED.md`, though §5
of the first and §6.3(b)/§6.4(ii) of the second each need one sentence replaced and my §3.3 and
§4.2 say exactly which. Amending another pass's text silently is the failure this corpus keeps
rediscovering; the corrections are here, openly, for their authors or the next ledger.

I did not adjudicate 𝓞_α = ∫^{σ∈N(𝓕_α)} δ_σ beyond recording that it fails the same test — the
nerve suggests a simplicial-object reading rather than a coend, and that is a separate item.
I did not touch D0018 §J5's χ_α or D0019 §C's ρ(D𝒦). No Python, no Agda or Lean authored, no
PDF claimed as read, no external text opened.
