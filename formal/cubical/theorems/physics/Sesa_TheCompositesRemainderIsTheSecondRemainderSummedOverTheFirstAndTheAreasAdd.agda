{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- शेष — the remainder that is KEPT and becomes the material of the next
-- step.  Āryabhaṭa, *Āryabhaṭīya*, Gaṇitapāda 32–33 (499), where the
-- kuṭṭaka's governing move is exactly that: divide, keep the remainder,
-- recurse on it.
--
-- LIMIT ON THE TERM.  Āryabhaṭa states a descent on integers.  He states
-- nothing whatever about maps of types, fibres, or composition of maps,
-- and none of the theorems below are attributed to him.  शेष is borrowed
-- for its exact sense — the part not consumed by the step, carried into
-- the next one — because that is what a fibre of a map is.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS SETTLES.
--
-- `Avaccheda_….agda` proves the cut decomposition A ≃ Σ[ b ∈ B ] fibre f b
-- maps composed:
--
--     rank(AB) = rank(B) − dim(im B ∩ ker A)                       (11)
--
-- and reads its defect term as an "alignment obstruction" — as though
-- composition failed to be additive, against the fibration's additivity.
--
-- IT IS THE SAME THEOREM.  (11) is rank–nullity applied to A restricted
-- to im B, i.e. it is the fibre decomposition of that restricted map:
-- the defect dim(im B ∩ ker A) is the DIMENSION OF ITS FIBRE, and the
-- "non-additivity" of composition is the additivity of the fibration read
-- on a different map.  §१ below is the type-theoretic form of that fact,
-- with no linear algebra in it at all:
--
--   §१  शेष : fibre (g ∘ f) z ≃ Σ[ p ∈ fibre g z ] fibre f (fst p)
--
--       The remainder of the composite is the remainder of f summed over
--       the remainder of g.  Nothing is lost and nothing is created by
--       composing; the fibres reassemble.
--
--   §२  शेषसमता : if f has a uniform remainder — fibre f y ≃ Φ for every
--       y — then fibre (g ∘ f) z ≃ fibre g z × Φ.  At cardinality this is
--       |fibre(g∘f)| = |fibre g| · |Φ|, i.e. LOGS ADD.  This is the whole
--       of "area = log of the fibre" under composition, and it is an
--       equivalence, not an inequality.
--
--   §३  शून्यशेष : g ∘ f has contractible fibres as soon as both do —
--       the composite of two cuts that retain nothing retains nothing.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  No rank is computed here and no field is
-- mentioned; these are equivalences of types, and the passage to a
-- number needs finiteness that is not assumed below.  Nothing here is
-- about entropy, area, black holes, or physical spacetime: the reading
-- of §२ as "logs add" is a reading, stated in this comment and nowhere
-- in a theorem.  In particular §२'s hypothesis (a uniform fibre) is
-- exactly what a general map does NOT have, which is why §१ and not §२
-- is the general law.
--
-- CHECKED: Agda 2.8.0 + agda/cubical (the installed version), --cubical
-- --safe, no postulates, no holes.  Exit code reported in the session log.
------------------------------------------------------------------------

module Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.GroupoidLaws
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.HLevels
open import Cubical.Data.Sigma

private
  variable
    ℓ ℓ' ℓ'' : Level

module _ {X : Type ℓ} {Y : Type ℓ'} {Z : Type ℓ''}
         (g : Y → Z) (f : X → Y) where

  -- §१  the composite's remainder, reassembled.
  शेष-Iso : (z : Z) → Iso (fiber (λ x → g (f x)) z)
                          (Σ[ p ∈ fiber g z ] fiber f (fst p))
  Iso.fun (शेष-Iso z) (x , q) = ((f x , q) , (x , refl))
  Iso.inv (शेष-Iso z) ((y , p) , (x , r)) = (x , cong g r ∙ p)
  Iso.rightInv (शेष-Iso z) ((y , p) , (x , r)) =
    J (λ y' r' → (p' : g y' ≡ z) →
         Iso.fun (शेष-Iso z) (Iso.inv (शेष-Iso z) ((y' , p') , (x , r')))
           ≡ ((y' , p') , (x , r')))
      (λ p' i → ((f x , lUnit p' (~ i)) , (x , refl)))
      r p
  Iso.leftInv (शेष-Iso z) (x , q) = cong (x ,_) (sym (lUnit q))

  शेष : (z : Z) → fiber (λ x → g (f x)) z ≃ (Σ[ p ∈ fiber g z ] fiber f (fst p))
  शेष z = isoToEquiv (शेष-Iso z)

  -- §२  a uniform remainder: the two remainders multiply, so their logs add.
  शेषसमता : {Φ : Type ℓ} → ((y : Y) → fiber f y ≃ Φ) →
            (z : Z) → fiber (λ x → g (f x)) z ≃ (fiber g z × Φ)
  शेषसमता {Φ = Φ} u z =
    compEquiv (शेष z) (Σ-cong-equiv-snd (λ p → u (fst p)))

  -- §३  no remainder composed with no remainder is no remainder.
  शून्यशेष : ((y : Y) → isContr (fiber f y)) →
             ((z : Z) → isContr (fiber g z)) →
             (z : Z) → isContr (fiber (λ x → g (f x)) z)
  शून्यशेष cf cg z =
    isOfHLevelRespectEquiv 0 (invEquiv (शेष z))
      (isOfHLevelΣ 0 (cg z) (λ p → cf (fst p)))
