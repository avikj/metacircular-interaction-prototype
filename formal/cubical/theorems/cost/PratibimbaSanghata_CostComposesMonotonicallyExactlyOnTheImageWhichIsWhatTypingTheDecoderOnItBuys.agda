{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रतिबिम्ब-सङ्घातः — cost composes monotonically EXACTLY on the image, and
-- that is what typing the decoder on the Image buys.  Two facts the corpus
-- already holds, in different files, that are one fact.
--
-- FACT A (`README` §C4).  `FactorsThrough` has two definitions under one
-- name.  `FiniteInformation` types its decoder on the IMAGE — "the empty
-- fiber unroutable by type, the router's guard is sound THERE" — while
-- `QuotientFiberLaw` types it on the full codomain, and gating against the
-- wrong one makes the रिक्तम् rows transportable.  Recorded as a naming
-- defect.
--
-- FACT B (`DesaSanghata_…NotAGradedMonoid`, `Vilopa_…FailureOfChoice`, both
-- this corpus, today).  Cost does not compose: an empty inner fiber deletes
-- a point of the outer fiber, विकलादेश collapses to सकलादेश, monotonicity
-- fails — and the annihilation happens exactly when no section
-- `(w : शेष g z) → शेष f (fst w)` exists.
--
-- THEY ARE THE SAME FACT.  The section whose absence कills composition IS
-- the statement that the outer fiber lies inside the image of `f`.  So:
--
--   * on the full codomain there is no graded monoid (Fact B), and
--   * on the image there is (§३ below), because the section is free,
--
-- and C4's "two definitions" is not a naming slip to be tidied — it is the
-- boundary between a cost model that composes and one that does not.  The
-- Image-typed decoder is sound for exactly the reason cost is monotone
-- there, and no other.
--
-- WHAT §३ IS.  Not a new inequality: the hypothesis named, and shown to be
-- the image condition.  `अच्छेद-सङ्घातः` says a crowded outer stage stays
-- crowded through composition whenever every outer point is hit by `f`.
-- That is the router's guard, and it is the whole of it — there is nothing
-- else to check.
--
-- §४ is the price of the repair, and it is not nothing: the image condition
-- is a Π, so it is not decidable here and cannot be tested pointwise, which
-- is `Vilopa` §४ arriving from the other side.  A router does not VERIFY the
-- guard; it CARRIES a section, or it has no route.  That is why the receipt
-- economy's unit is a term and not a check.
--
-- No source claimed for the mathematics; it is elementary.  प्रतिबिम्ब is
-- ordinary Sanskrit for image/reflection; the compound is built here,
-- 2026-08-22.
------------------------------------------------------------------------

module PratibimbaSanghata_CostComposesMonotonicallyExactlyOnTheImageWhichIsWhatTypingTheDecoderOnItBuys where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open Iso
open import Cubical.Foundations.GroupoidLaws using (lUnit)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

शेष : {A B : Type ℓ} (f : A → B) → B → Type ℓ
शेष {A = A} f b = Σ[ a ∈ A ] (f a ≡ b)

------------------------------------------------------------------------
-- १ · The composition law (SankramanaSesa's शेष-सङ्घातः; term cited, not
-- claimed), restated locally so this module stands alone under the kernel.
------------------------------------------------------------------------

module _ {A B C : Type ℓ} (f : A → B) (g : B → C) (z : C) where

  private
    fwd : शेष (λ a → g (f a)) z → Σ[ w ∈ शेष g z ] शेष f (fst w)
    fwd (a , p) = ((f a , p) , (a , refl))

    bwd : (Σ[ w ∈ शेष g z ] शेष f (fst w)) → शेष (λ a → g (f a)) z
    bwd ((b , q) , (a , p)) = (a , cong g p ∙ q)

    bwd-fwd : (x : शेष (λ a → g (f a)) z) → bwd (fwd x) ≡ x
    bwd-fwd (a , p) i = (a , sym (lUnit p) i)

    fwd-bwd : (w : Σ[ w ∈ शेष g z ] शेष f (fst w)) → fwd (bwd w) ≡ w
    fwd-bwd ((b , q) , (a , p)) = lem a b p q
      where
      lem : (a : A) (b : B) (p : f a ≡ b) (q : g b ≡ z)
          → fwd (bwd ((b , q) , (a , p))) ≡ ((b , q) , (a , p))
      lem a b p q =
        J (λ b' p' → (q' : g b' ≡ z)
              → fwd (bwd ((b' , q') , (a , p'))) ≡ ((b' , q') , (a , p')))
          (λ q' i → ((f a , lUnit q' (~ i)) , (a , refl)))
          p q

  शेष-सङ्घातः : शेष (λ a → g (f a)) z ≃ (Σ[ w ∈ शेष g z ] शेष f (fst w))
  शेष-सङ्घातः = isoToEquiv (iso fwd bwd fwd-bwd bwd-fwd)

------------------------------------------------------------------------
-- २ · प्रतिबिम्बे — THE IMAGE CONDITION, named.  "Every point of the outer
-- fiber over z is hit by f."  This is precisely the section whose absence
-- Vilopa proves the annihilation requires, and precisely what typing a
-- decoder on the Image asserts.
------------------------------------------------------------------------

प्रतिबिम्बे : {A B C : Type ℓ} (f : A → B) (g : B → C) (z : C) → Type ℓ
प्रतिबिम्बे f g z = (w : शेष g z) → शेष f (fst w)

------------------------------------------------------------------------
-- ३ · अच्छेद-सङ्घातः — ON THE IMAGE, COST IS MONOTONE.
--
-- A crowded outer stage stays crowded through composition.  No annihilation,
-- no hiding of upstream loss: the graded monoid that fails on the codomain
-- exists here.  The proof is one retraction — the section splits `fst`.
------------------------------------------------------------------------

अच्छेद-सङ्घातः : {A B C : Type ℓ} (f : A → B) (g : B → C) (z : C)
              → प्रतिबिम्बे f g z
              → ¬ (isContr (शेष g z))
              → ¬ (isContr (शेष (λ a → g (f a)) z))
अच्छेद-सङ्घातः f g z s nb c = nb बहिः-सङ्कोचः
  where
    Σc : isContr (Σ[ w ∈ शेष g z ] शेष f (fst w))
    Σc = isOfHLevelRespectEquiv 0 (शेष-सङ्घातः f g z) c
      where open import Cubical.Foundations.HLevels using (isOfHLevelRespectEquiv)
    बहिः-सङ्कोचः : isContr (शेष g z)
    fst बहिः-सङ्कोचः   = fst (fst Σc)
    snd बहिः-सङ्कोचः w = cong fst (snd Σc (w , s w))

------------------------------------------------------------------------
-- ४ · दोषलेखः — the price of the repair, which is the same price one level
-- down.
--
-- `प्रतिबिम्बे` is a Π.  It is not decidable here and cannot be tested
-- pointwise; `Vilopa` §४ says the same thing from the other side, that the
-- obstruction yields only the non-existence of a section and never a witness
-- point.  So a router does NOT verify this guard.  It CARRIES a section, or
-- it has no route — which is exactly why the unit of proof-of-transport is a
-- term and not a check, and why `FactorsThrough` must be TYPED on the image
-- rather than gated against it.  C4's "two definitions under one name" is
-- therefore not a tidy-up: keeping both is keeping the boundary between a
-- composable cost model and an incomposable one, and the names should say
-- which side each is on.
--
-- Not proved here: that the image-restricted composites form a category with
-- the monoid structure assembled.  §३ is the key step (no annihilation), not
-- the assembly.
------------------------------------------------------------------------
