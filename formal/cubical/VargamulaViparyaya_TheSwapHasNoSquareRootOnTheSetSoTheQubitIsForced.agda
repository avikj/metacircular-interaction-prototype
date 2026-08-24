{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- VargamulaViparyaya_TheSwapHasNoSquareRootOnTheSet
--                     SoTheQubitIsForced
--
-- TERMS.  वर्गमूल · varga-mūla — "square root", the standard term of Sanskrit
-- mathematics (Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda, 499 CE, gives the
-- digit-by-digit वर्गमूल algorithm; Brahmagupta continues it).  विपर्यय ·
-- viparyaya — reversal, inversion, exchange; a common word, here the swap /
-- logical NOT.  The compound वर्गमूलविपर्यय ("square-root-of-inversion") and
-- ALL the mathematics below are built here, 2026-08-24, claimed of no source.
-- No source proved this theorem; what is borrowed is two words.
--
-- WHAT IS PROVED, exactly and only:  the two-element SET `Bool` has no
-- self-equivalence whose square is the swap.  `√NOT-does-not-exist` is a
-- closed `¬`.  Every self-equivalence `g` of Bool satisfies
-- `g (g true) ≡ true` (`ff-true`, no case escapes), so `g ∘ g` fixes `true`
-- while `not` moves it — they cannot be equal.
--
-- WHY IT MATTERS (this is a READING of the checked term, not a further
-- claim):  the automorphism group of a finite SET is a permutation group,
-- discrete, and here `Aut Bool = S₂ = ℤ/2` — every element has order dividing
-- 2, so the swap (the only nontrivial element) has no square root.  √NOT — the
-- quantum gate whose square is NOT — is exactly this missing square root.  It
-- cannot exist on the set; to hold it one must ENRICH the object, replacing
-- the 2-point set with the 2-dimensional ℂ-space (a qubit), whose
-- automorphism group is the CONTINUOUS `U(2)`, in which every element has all
-- its roots — √NOT among them.  So the qubit is not posited; it is FORCED by
-- the set's inability to halve the swap.  The same univalence that here gives
-- only permutations (`ua notEquiv` is the NOT gate, an involution) gives,
-- over a linear enrichment, the unitaries — and a unitary is precisely a
-- norm-preserving (lossless) automorphism: ahiṃsā over ℂ, exactly as a
-- permutation is ahiṃsā over a set.  NONE of that ℂ / U(2) content is checked
-- here; only the impossibility that forces it.
--
-- Checked at the pin: --cubical --safe, agda 2.6.3 + cubical (loads clean);
-- uses no v0.9-only construct.
------------------------------------------------------------------------

module VargamulaViparyaya_TheSwapHasNoSquareRootOnTheSetSoTheQubitIsForced where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Bool
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

module _ (e : Bool ≃ Bool) where
  private f = equivFun e

  -- an equivalence is injective: drag the equation back along the section.
  inj : (x y : Bool) → f x ≡ f y → x ≡ y
  inj x y p = sym (retEq e x) ∙ cong (invEq e) p ∙ retEq e y

  -- THE FIXED-POINT LEMMA.  Every self-equivalence of Bool returns `true`
  -- to `true` after two applications — there is no exception, because there
  -- are only two places `f true` can go and both force it.
  ff-true : f (f true) ≡ true
  ff-true with dichotomyBool (f true)
  ... | inl p = cong f p ∙ p                    -- f true ≡ true
  ... | inr p = cong f p ∙ ⊎→ (dichotomyBool (f false))   -- f true ≡ false
     where ⊎→ : (f false ≡ true) ⊎ (f false ≡ false) → f false ≡ true
           ⊎→ (inl r) = r
           ⊎→ (inr r) = ⊥.rec (false≢true (inj false true (r ∙ sym p)))

-- THE THEOREM.  No self-equivalence of the SET Bool squares to the swap.
-- Apply the supposed square-root twice to `true`: the fixed-point lemma says
-- the result is `true`, while `not true` is `false`.  true ≡ false is absurd.
√NOT-does-not-exist : ¬ (Σ[ g ∈ (Bool ≃ Bool) ] (compEquiv g g ≡ notEquiv))
√NOT-does-not-exist (g , p) =
  false≢true (sym (funExt⁻ (cong equivFun p) true) ∙ ff-true g)
