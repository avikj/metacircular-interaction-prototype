{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गर्भ-श्रेणी — the womb-ladder: the tower's rungs are ONE predicate.
--
-- GarbhaDhara built one Postnikov step: install cones off an obstruction
-- (contractible locus), and the fee it precipitates one level up is the
-- non-descending cost.  The note then flagged the ITERATION — that the
-- fee at level n is the carrier at level n+1, endlessly — as the single
-- named-open construction.  This module does not build the full ∞-tower;
-- it builds the RUNG RELATION, as a term: it exhibits two consecutive
-- rungs already in the corpus as literal instances of ONE predicate,
--
--     "cost is not exact" — ¬ Σ potential, cost = coboundary of it,
--
-- so that "climbing a level" is re-instantiating the SAME type one
-- degree up, not a new phenomenon each time.  That is the self-
-- generation, made a pattern rather than an anecdote.
--
--   §0  THE PREDICATE.  NotExact ∂ V = ¬ Σ[ φ ] (∀ i → ∂ φ i ≡ V i):
--       the invariant V is not the coboundary ∂ of any potential φ.
--       This is one k-invariant type, degree-agnostic.
--   §1  RUNG 0 (π₀).  V = len, φ ranges over functions Ĝ → ℕ on the
--       localization, ∂ φ d = φ (L d).  "cost is not a FUNCTION on the
--       set-quotient" — SankramanaShreni.kernelCostDoesNotDescend — is
--       NotExact on the nose (definitionally: the pass-through is refl).
--   §2  RUNG 1 (π₁).  V = गभीरता (the depth evaluator), φ ranges over
--       state potentials Tm → ℤ, ∂ φ = d′ φ (the coboundary).  "cost is
--       not the COBOUNDARY of a potential" — MulyaVinimaya
--       .depthHasNoPotential, whose loop integrates to pos 3 ≠ 0 — is
--       NotExact one level up (bridged by sym; same predicate).
--   §3  THE LADDER.  theTower : NotExact₀ × NotExact₁ — the two rungs as
--       one type at two degrees.  Rung 0 says cost has no 0-potential
--       (is not a function on π₀); rung 1 says cost has no 1-potential
--       (is not exact on π₁); coning off rung n (install) is what makes
--       rung n+1's failure visible.
--
-- SYĀT — THE CLAIM, EXACTLY.  §0 the predicate; §§1–2 the two corpus
-- obstructions AS instances of it (rung 0 definitional, rung 1 up to
-- sym); §3 the pair.  NOT claimed: the full ∞-tower (that every rung n
-- precipitates rung n+1 for all n) — that induction is the construction
-- GarbhaDhara's note still names open.  What IS claimed: two consecutive
-- rungs are the SAME predicate at successive degrees, so the tower's
-- step is one type re-instantiated, not a sequence of coincidences.
------------------------------------------------------------------------

module GarbhaShreni_TheTowerRungsAreOnePredicateCostIsNotExactAtSuccessiveLevels where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Int using (ℤ)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; _×_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import RewriteCertificate using (Tm ; Step ; Derivation)
open import GenerativeKernel using (seed ; target₀)

private variable ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- ० · The one predicate: V is not the coboundary ∂ of any potential.
------------------------------------------------------------------------

NotExact : {P : Type ℓ} {I : Type ℓ'} {A : Type ℓ''}
  → (P → I → A) → (I → A) → Type (ℓ-max ℓ (ℓ-max ℓ' ℓ''))
NotExact {P = P} {I} ∂ V = ¬ (Σ[ φ ∈ P ] ((i : I) → ∂ φ i ≡ V i))

------------------------------------------------------------------------
-- १ · Rung 0 (π₀): cost is not a function on the localization.
------------------------------------------------------------------------

open import SankramanaShreni_TheLocalizationSequenceAsOneObjectMeaningDescendsAndCostDoesNot
  using (Ĝ ; L ; kernelCostDoesNotDescend)
open import ForgetfulCompressionPricesTheDrop using (len)

∂₀ : (Ĝ → ℕ) → Derivation seed target₀ → ℕ
∂₀ ℓc d = ℓc (L d)

costNotExact₀ : NotExact ∂₀ len
costNotExact₀ = kernelCostDoesNotDescend   -- definitionally the same type

------------------------------------------------------------------------
-- २ · Rung 1 (π₁): cost is not the coboundary of a state potential.
------------------------------------------------------------------------

open import MulyaVinimaya_TheValueOfATraceIsItsPairingWithAnEvaluatorPotentialsTelescopeAndADepthEvaluatorHasNonzeroCycleIntegral
  using (d′ ; गभीरता ; depthHasNoPotential)

I₁ : Type₀
I₁ = Σ[ a ∈ Tm ] Σ[ b ∈ Tm ] Step a b

∂₁ : (Tm → ℤ) → I₁ → ℤ
∂₁ φ (a , b , s) = d′ φ s

V₁ : I₁ → ℤ
V₁ (a , b , s) = गभीरता s

costNotExact₁ : NotExact ∂₁ V₁
costNotExact₁ (φ , h) = depthHasNoPotential (φ , λ {a} {b} s → sym (h (a , b , s)))

------------------------------------------------------------------------
-- ३ · The ladder: two consecutive rungs, one predicate, two degrees.
------------------------------------------------------------------------

theTower : NotExact ∂₀ len × NotExact ∂₁ V₁
theTower = costNotExact₀ , costNotExact₁
