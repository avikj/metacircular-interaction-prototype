-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सञ्ज्ञा — नाम पूर्वं दत्तम्, गणना तु न पश्यति ।
--
-- (the name was assigned already; it is the census that could not see it.)
--
-- ────────────────────────────────────────────────────────────────────
-- TERM, TEXT, DATE.
--
-- सञ्ज्ञा is Pāṇini's device of technical designation: a sūtra assigns a
-- name to a class of forms, and every later sūtra then operates by that
-- name and never re-describes the class.  अष्टाध्यायी १.१.१ वृद्धिरादैच्
-- (आत् and ऐच् receive the सञ्ज्ञा *vṛddhi*) and १.४.१४ सुप्तिङन्तं पदम्
-- (what ends in सुप् or तिङ् receives the सञ्ज्ञा *pada*), c. 500 BCE.
--
-- SCOPE, and what is NOT claimed.  Pāṇini stated no fibre, no type and no
-- equivalence, and nothing below is attributed to him.  What is borrowed
-- is one discipline of the सञ्ज्ञा-sūtra and nothing else: **a class that
-- has been named is thereafter referred to by that name.**  This corpus
-- assigns names to fibres and then, in `machine/Lopa_…hs`, goes back to
-- re-describing the class — which is why one-way edges sit UNDECIDED
-- while their fibres are written out in the very files the census read.
-- The compound `Samjna_…` is this repository's own file title; the word
-- सञ्ज्ञा is Pāṇini's.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS HERE, AND WHAT IS DELIBERATELY NOT.
--
-- `scripts/Abhijnana_…sh --check` was completed on 2026-08-22: it now
-- emits a probe per lead and lets the kernel answer.  Of 17 STRONG leads
-- it turned 5 green.  **Four of those five are already published and are
-- NOT restated here** — `matraOf`/`Metre` and `varna`/`Vak` in
-- `Chandomudra_…`, `chargeOneProjector`/`chargeOneFiber` and
-- `value`/`Fib` in `Tantusandhi_…`, which landed while this was being
-- checked.  Restating them would inflate a count, which is the one thing
-- a recognition pass must not do.  §१ is the fifth.
--
-- §२ is the more useful half and it comes out of the DEATHS.  Nine of
-- the fourteen probed leads failed, and **five of the nine failed the
-- same way**: the written type is not `fiber f b` but
--
--     Σ[ n ∈ ℕ ] ((n ∈ domain) × (q n ≡ v)),
--
-- the fibre of `q` RESTRICTED to a domain predicate.  The census has no
-- vocabulary for that at all, so it prices those edges at nothing.  §२
-- gives it one: such a type is the honest fibre of the restricted map,
-- and the passage between them is Σ-associativity — an equivalence, not
-- a `refl`, and the gap is exactly the restriction.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CENSUS THAT PRODUCED THIS, REPORTED WHOLE.
--
--   undecided one-way edges                     1056
--   fibre rows usable after detection             244   (of Upalabdhi's 475)
--   STRONG leads (source type AND map name)        17
--   WEAK   leads (source type only)              9209   ← never probed
--   probed 17 · GREEN 5 · DEATH 9 · SKIP 3
--
-- **A source-and-map match is a LEAD, not a hit: 9 of 14 died.**  The
-- deaths sort into four kinds and none of them is noise:
--
--   (i)   fibre of a RESTRICTED map — five of the nine, and §२ below;
--   (ii)  the same short name in two modules — `NaturalMachine.Digits.value`
--         joined `Swarm.S03CarryFiber.Fib` because both end in `value`;
--         different maps out of different `Word`s;
--   (iii) the queued map is a FACTOR, not the map — `EvenQuery` is the
--         fibre of `sgn ∘ Ω` and the join saw only `Ω` (Tantusandhi §३
--         names the composite);
--   (iv)  a bound variable read as a map name — `Div α = Σ[ κ ∈ ℕ ] Σ[ d ∈ ℕ ]
--         (κ + d ≡ α)` BINDS `κ`, and `ChargePolynomialFinite.κ : ℕ → ℤ`
--         is a different thing spelled the same.
--
-- Three leads were SKIPPED, not refuted: `PingalaPrastara.Chosen`,
-- `NaturalMachine.TypedUnfold.Lang` and `Gurutama.म` are JOINT fibres of
-- two or more observables, and a pair of equations is not an equation of
-- pairs until `ΣPath≃PathΣ` says so — छन्दोमुद्रा §३ performs exactly that
-- passage for `Chosen`; the other two are open.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module Samjna_TheSemanticFibreCarriedItsNameAndTheFiveThatDidNotAreFibresOfARestriction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber ; invEquiv)
open import Cubical.Data.Bool using (Bool ; false)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma

open import NaturalMachine.DependentOptimizationFibration
  using (semantics ; SemanticFiber ; left-point ; right-point)
open import NaturalMachine.SieveFiber
  using (Vis ; q ; domain ; _∈_ ; Fibre)

------------------------------------------------------------------------
-- १ · अर्थतन्तुः — the semantic fibre IS the fibre of the semantics map.
--
-- queue edge:  Configuration ⟶ Bool
--              « NaturalMachine.DependentOptimizationFibration.semantics
-- written at:  DependentOptimizationFibration.agda:36–38, as
--              `SemanticFiber output = Σ[ configuration ∈ Configuration ]
--               semantics configuration ≡ output`.
--
-- The definition spans two lines, which is why the one-line grep the
-- recognition pass shipped with could not see it and the seven-shape
-- detector could.
------------------------------------------------------------------------

अर्थ-तन्तुः : (b : Bool) → fiber semantics b ≡ SemanticFiber b
अर्थ-तन्तुः b = refl

-- What the recognition buys, and it costs no transport: the host's two
-- named points of `SemanticFiber false` ARE two points of the fibre of
-- `semantics` over `false`.  The edge is therefore not merely undecided
-- but demonstrably non-injective over that value.
अर्थ-तन्तोः-बिन्दू : fiber semantics false × fiber semantics false
अर्थ-तन्तोः-बिन्दू = left-point , right-point

------------------------------------------------------------------------
-- २ · सावच्छेदतन्तुः — the fibre of a map cut down to a domain.
--
-- `NaturalMachine.SieveFiber` writes, at line 465,
--
--     Fibre v = Σ[ n ∈ ℕ ] ((n ∈ domain) × (q n ≡ v))
--
-- and the probe `fiber q v ≡ Fibre v` DIES: the membership conjunct is
-- not in `fiber q v` and no amount of unfolding will put it there.  The
-- kernel is right and the lead was wrong, but the death is informative,
-- because the written type is a fibre — of a different map.  Cut `q`
-- down to the subtype the domain predicate carves out, and `Fibre` is
-- that map's fibre, up to Σ-associativity.
--
-- The same shape kills `SieveScaleTower.Fibre₁ ₂ ₃` and
-- `ChargeGradedPeeling.G`; those five deaths are one phenomenon.
--
-- NOT CLAIMED: that the census edge `ℕ ⟶ Vis « q` is thereby priced.  It
-- is not.  What is priced is the edge out of the RESTRICTED domain, and
-- the census does not currently hold that edge — naming the gap is the
-- content of this section, not closing it.
------------------------------------------------------------------------

अवच्छिन्नम् : Type
अवच्छिन्नम् = Σ[ n ∈ ℕ ] (n ∈ domain)

-- projections, not a pattern match: `सावच्छिन्न-q x` must reduce for a
-- VARIABLE `x`, or `fiber सावच्छिन्न-q v` does not unfold to the Σ below.
सावच्छिन्न-q : अवच्छिन्नम् → Vis
सावच्छिन्न-q x = q (fst x)

सावच्छेद-तन्तुः : (v : Vis) → Fibre v ≃ fiber सावच्छिन्न-q v
सावच्छेद-तन्तुः v = invEquiv Σ-assoc-≃

------------------------------------------------------------------------
-- ३ · शेषः — what this leaves.
--
-- The recognition pass is now closed as an instrument: it emits probes
-- and the kernel answers them, so a lead can no longer be reported as a
-- hit by an instrument that never asked.  Its measured false-positive
-- rate on the leads it can probe is 9 of 14, and that number is the one
-- that decides whether it should be run across all 249 source types with
-- its 9209 weak leads.  On this evidence: run it, but only after the
-- weak key is sharpened, because a 64% death rate on the STRONG key is
-- the optimistic figure.
--
-- Open, in order of how much is already written: (a) the two joint
-- fibres skipped above; (b) the four other restricted fibres, which §२'s
-- statement covers verbatim and which are four more modules' worth of
-- imports; (c) death kind (iv), which is a defect of the extractor and
-- not of the corpus — a Σ binder must never be offered as a map name.
------------------------------------------------------------------------
