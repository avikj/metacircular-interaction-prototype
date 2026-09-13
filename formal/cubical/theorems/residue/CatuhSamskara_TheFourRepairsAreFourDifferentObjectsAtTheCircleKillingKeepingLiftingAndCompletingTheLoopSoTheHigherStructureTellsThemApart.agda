{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- चतुः-संस्कारः — the four repairs, told apart.
--
-- `ObstructionCalculus`, the checked fragment of Hieroglyphics II, wrote
-- of the document's four repair kinds  Γ∅, Γ⇑, Γ↺, Γ^ :  "Γ⇑ (promote the
-- defect to a 2-cell) and Γ↺ (keep it as a class) need genuine higher
-- structure to differ from Γ∅.  … it does mean this module cannot see
-- them."  And of the two it could see, `Γ^ → Γ∅` with no converse.
--
-- The higher structure is the circle, and at the circle all four are
-- different objects.  The defect is the diamond at `base`: the two routes
-- `refl` and `loop` from base to base do not agree (loop≢refl, from
-- `AsetChidra`).  Then:
--
--   Γ∅  kill the class     — set-truncate: in ∥ S¹ ∥₂ the loop IS refl and
--                            the whole object collapses to a point;
--   Γ↺  keep the class     — the loop survives as [loop] ∈ ΩS¹ ≡ ℤ, a set-
--                            level datum with winding 1 ≠ 0;
--   Γ⇑  lift to a 2-cell   — the non-commutation becomes a COMPONENT of a
--                            descent datum (const base , loop); that datum
--                            differs from the trivial one, and set-
--                            truncating the codomain makes them equal again;
--   Γ^  complete           — the universal cover `helix`: the loop no
--                            longer closes (its lift ends at 1, not 0), the
--                            monodromy sucℤ has no fixed point, and the
--                            obstruction is self-classified: ΩS¹ ≡ ℤ is the
--                            deck group,  D ≃ Code(X̂/X).
--
-- So the repairs are ordered by what they retain — nothing, a class, a
-- datum, a cover — and none is another: exactly the document's claim that
-- the higher structure is what tells the repairs apart.
------------------------------------------------------------------------
module CatuhSamskara_TheFourRepairsAreFourDifferentObjectsAtTheCircleKillingKeepingLiftingAndCompletingTheLoopSoTheHigherStructureTellsThemApart where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Foundations.GroupoidLaws using (lUnit)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz ; injSuc)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; sucℤ)
open import Cubical.Data.Int.Properties using (injPos ; injNegsuc ; posNotnegsuc)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.PropositionalTruncation as PT using ()
open import Cubical.HITs.SetTruncation as ST using (∥_∥₂ ; ∣_∣₂ ; isSetSetTrunc)
open import Cubical.HITs.S1 using (S¹ ; base ; loop ; helix ; ΩS¹ ; ΩS¹≡ℤ ; ΩS¹Isoℤ ; winding ; encode ; isSetΩS¹)
open import Cubical.HITs.S1.Properties using (isConnectedS¹)

open import DefectCalculus using (Coequalizes)
open import EffectiveDescent using (isPropCoequalizes)
open import ObstructionCalculus using (Kind ; Γ∅ ; Γ⇑ ; Γ↺ ; Γ^)
open import AsetChidra_TheDescentEquivalenceFailsAtANonSetTheWitnessIsTheLoopOfTheCircleSoTheSetHypothesisOfRepresentabilityIsNecessary
  using (loop≢refl ; q ; DescentData ; loopDatum ; restrictAlong ; not-in-image)

------------------------------------------------------------------------
-- ० · the defect: the diamond at base does not commute
------------------------------------------------------------------------

δ≠0 : ¬ (loop ≡ refl)
δ≠0 = loop≢refl

------------------------------------------------------------------------
-- १ · Γ∅ — kill the class.  Set-truncate: the loop becomes refl and the
--     object collapses to a point.
------------------------------------------------------------------------

Γ∅-kills : cong ∣_∣₂ loop ≡ refl
Γ∅-kills = isSetSetTrunc _ _ _ _

Γ∅-collapses : isContr ∥ S¹ ∥₂
Γ∅-collapses =
  ∣ base ∣₂ ,
  ST.elim (λ _ → isProp→isSet (isSetSetTrunc _ _))
          (λ x → PT.rec (isSetSetTrunc _ _) (λ p → cong ∣_∣₂ p) (isConnectedS¹ x))

------------------------------------------------------------------------
-- २ · Γ↺ — keep the class.  The loop survives as a set-level datum in
--     ΩS¹ ≡ ℤ, with winding 1.
------------------------------------------------------------------------

Γ↺-class : ΩS¹ ≡ ℤ
Γ↺-class = ΩS¹≡ℤ

Γ↺-isDatum : isSet ΩS¹
Γ↺-isDatum = isSetΩS¹

Γ↺-keeps : winding loop ≡ pos 1
Γ↺-keeps = cong winding (lUnit loop) ∙ Iso.rightInv ΩS¹Isoℤ (pos 1)

Γ↺-nonzero : ¬ (winding loop ≡ pos 0)
Γ↺-nonzero p = snotz (injPos (sym Γ↺-keeps ∙ p))

------------------------------------------------------------------------
-- ३ · Γ⇑ — lift the defect to a 2-cell.  The non-commutation is a
--     component of a descent datum; it is not the trivial datum; and after
--     Γ∅ on the codomain the two data coincide again.
------------------------------------------------------------------------

Γ⇑-datum : DescentData
Γ⇑-datum = loopDatum

Γ⇑-trivial : DescentData
Γ⇑-trivial = restrictAlong (λ _ → base)

Γ⇑-distinct : ¬ (Γ⇑-datum ≡ Γ⇑-trivial)
Γ⇑-distinct e = not-in-image ((λ _ → base) , sym e)

-- with a set for codomain, every 2-cell component is forced: Γ⇑ = Γ∅
Γ⇑-flattens : (f : Unit → ∥ S¹ ∥₂) (c c' : Coequalizes q f) → c ≡ c'
Γ⇑-flattens f = isPropCoequalizes isSetSetTrunc q f

------------------------------------------------------------------------
-- ४ · Γ^ — complete.  The universal cover: the loop no longer closes, the
--     monodromy has no fixed point, and the obstruction classifies itself.
------------------------------------------------------------------------

Γ^-cover : S¹ → Type
Γ^-cover = helix

-- the lift of the loop from 0 ends at 1: it is a path, not a loop
Γ^-unwinds : subst helix loop (pos 0) ≡ pos 1
Γ^-unwinds = Γ↺-keeps

private
  nofix-ℕ : (n : ℕ) → ¬ (suc n ≡ n)
  nofix-ℕ zero    p = snotz p
  nofix-ℕ (suc n) p = nofix-ℕ n (injSuc p)

-- the monodromy sucℤ moves every point
Γ^-monodromy-free : (z : ℤ) → ¬ (sucℤ z ≡ z)
Γ^-monodromy-free (pos n)          p = nofix-ℕ n (injPos p)
Γ^-monodromy-free (negsuc zero)    p = posNotnegsuc 0 0 p
Γ^-monodromy-free (negsuc (suc n)) p = nofix-ℕ n (sym (injNegsuc p))

-- self-classified: the deck group is the loop space  (D ≃ Code(X̂/X))
Γ^-self-classified : ΩS¹ ≡ ℤ
Γ^-self-classified = ΩS¹≡ℤ

------------------------------------------------------------------------
-- ५ · four objects, none another
------------------------------------------------------------------------

-- Γ∅ retains nothing; Γ↺ retains a set with two distinct points
¬isContrℤ : ¬ isContr ℤ
¬isContrℤ c = snotz (injPos (sym (c .snd (pos 1)) ∙ c .snd (pos 0)))

-- what each repair hands back
Retained : Kind → Type
Retained Γ∅ = ∥ S¹ ∥₂
Retained Γ↺ = ΩS¹
Retained Γ⇑ = DescentData
Retained Γ^ = Σ[ x ∈ S¹ ] helix x

four-are-four :
    isContr (Retained Γ∅)
  × (¬ isContr (Retained Γ↺))
  × (Σ[ d ∈ Retained Γ⇑ ] Σ[ d' ∈ Retained Γ⇑ ] (¬ d ≡ d'))
  × ((z : ℤ) → ¬ (sucℤ z ≡ z))
four-are-four =
    Γ∅-collapses
  , (λ c → ¬isContrℤ (subst isContr ΩS¹≡ℤ c))
  , (Γ⇑-datum , Γ⇑-trivial , Γ⇑-distinct)
  , Γ^-monodromy-free
