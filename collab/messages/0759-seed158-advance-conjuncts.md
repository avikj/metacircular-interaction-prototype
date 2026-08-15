---
id: 0759-seed158-advance-conjuncts
seed: 158
date: 2026-08-15
kind: result
tags: [PROVE, chu, advance, D0016, D0016-G, D0018, definitions, clean-negative, decidability]
artifact: notes/ADVANCE_CONJUNCTS_DEFINED.md
depends_on:
  - notes/ADVANCE_UNDER_REPLACEMENT.md          # seed154, Thms F′, 2–6
  - notes/CHANGING_TESTS_VERSUS_SHRINKING.md    # seed149, Thms A–F
  - collab/upstream/raw/D0016-owner-diamond-transmission-2026-08-14.md   # §A §B §F §G §H
  - collab/upstream/raw/D0018-owner-third-transmission-2026-08-14.md     # §A §D
credit: framework, Advance, the four preservation clauses and gain(σ) are the repository owner's
computation: none — no experiment, no measurement, no fitted constant, no Python, no Agda/Lean
---

# Three definitions, one clean negative, and a collapse theorem

**Mandate.** Define the four undefined conjuncts of D0016 §G's `Advance`, or prove no
definition of the required kind exists; then say whether `Advance` is decidable.

## Verification first

Re-derived seed154's Theorem 3 and Theorem 5 from (H1)–(H6) before using them. **Both
correct**, both one-line lattice arguments, **no circularity** (neither invokes the other),
and seed154's `Incomparable ⇒ Δ ⊊ ∼ ⊊ ∇` is stated as an implication and not silently
upgraded — the converse is false and seed154 does not claim it. One sharpening: on a
separating stage δ_σ(𝒯_α) = supp(𝔥_σ) **exactly** (Lemma 1), so the defect is not merely
constant along Advancing runs, it is not a function of the instrument at all.

## Outcome, conjunct by conjunct

| conjunct | type | verdict |
|---|---|---|
| `Verify(Π_α)=1` | unary, on Π_α | **defined** (Def. 2) — claims-with-citations; non-vacuous, independent of SearchSep (all four truth-value combinations realised, finite witnesses) |
| `PreserveProv=1` | **binary on a step** — confirmed, and D0018 §A supplies the argument list the owner omitted in §G (प्रमाणरक्षा sits in a clause list attached to α→α+1) | **defined** (Def. 3a, citation-rigid); the free-re-citation reading (3b) is rejected — it collapses |
| `UsefulEscape>0` | binary on a step | **clean negative** (Theorem U): *no* function of resolving power works — proved without any monotonicity hypothesis, hence strictly stronger than the F′ route |
| `DeclaredBoundaryPreserved=1` | (declaration, stage) | **defined** (Def. 5) but **collapses** (Cor. K.1): under SearchSep it is decided by the declaration alone |

## The one result that changes the picture

**Theorem K (Collapse).** Any conjunct expressible as `P̂(∼_{𝒯_α}, A)` for a fixed anchor `A`
is, on stages where `SearchSep=1`, a function of `A` alone — because SearchSep pins ∼ to Δ_X.

So the escape route the prior pass identified (drop *relativity of the comparison base*)
**generalises to all four — for definability, and for nothing else.** The real dividing line
is not anchored-vs-relative but **sub-instrumental vs whole-instrument**: `Verify` and
`PreserveProv` have content only because a citation is a *proper subset* `S_π ⊊ 𝒯_α`, and
SearchSep constrains ∼_{𝒯_α} while saying nothing about ∼_{S_π}. Drop the citation field and
both conjuncts are vacuous the moment SearchSep holds (Cor. K.3). **The citation record is
not bookkeeping; it is the only thing giving two of five conjuncts content.**

## `Advance` decidable?

**Conditionally, and never as a function of `◇_α`.**

- **Theorem D(a):** two ledgered stages with the *same* D0016 §A septuple differ in
  `Advance` (witnessed: same X, 𝒯, e, same claims, different citations). So `Advance` is not
  a function of the stage as typed — confirming seed154 Cor. 4.1 with a witness rather than
  by absence of definitions.
- **Theorem D(b):** on *ledgered* stages (septuple + citations + transport j + ι +
  ∂_decl) with everything finite, four conjuncts are decidable by finite evaluation.
  `UsefulEscape` is decidable **iff** the owner declares a code L in advance (D0018 §A's
  `gain`); Prop. 5 shows a post-hoc L makes the conjunct true by construction — so the
  side condition *is* the content. I state Definition 4 as a conditional and adopt nothing.
- Two conjuncts do no work on Advancing runs (Cor. K.1, K.2), so `Advance` is effectively
  `SearchSep ∧ Verify ∧ PreserveProv^rig` plus a fourth awaiting L.
- **Decidable ≠ progress** (§9): no well-founded measure is produced, and F′/Theorem U say
  none exists in the resolving-power language. `Advance` underwrites no convergence claim.

## Rejected on purpose

Counting independent tests |𝒯/∼_T| escapes both F′ and Theorem U — and is not invariant
under recoding Q (Prop. 4, two-point witness). A quantity that moves when you rename a
dial's markings is not measuring the dial. Rejected.

D0018 §J5's χ_α: untouched, not measured, not rehabilitated, not used as support.

## For the owner

1. `PreserveProv` — **provability** (D0018 §A प्रमाणरक्षा) or **provenance** (D0016 §B
   δ^prov)? Same arity and shape either way; I took the first and flagged it.
2. Will you declare a run-fixed code `L`? Without it `UsefulEscape` has no definition.
   Alternatively, fix the enrichment that makes ∂ = ∫^{(f,t)} e(f,t) a coend rather than a
   coproduct — over a bare set it degenerates to a cardinality.
3. seed154 §7's discrepancy is still open and still upstream of everything here: does
   𝔉 contain ∨, and does Φ_cut enlarge or recut?
