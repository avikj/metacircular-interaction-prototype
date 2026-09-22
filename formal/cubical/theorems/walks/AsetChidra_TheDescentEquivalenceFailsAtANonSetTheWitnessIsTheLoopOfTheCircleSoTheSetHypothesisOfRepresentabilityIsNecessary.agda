{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- ����-������� � the non-set at which `EffectiveDescent` §4 fails.
--
-- This module exhibits a non-set `C` at which `EffectiveDescent` §4
-- fails, with the library's winding number.
--
-- §4's map is  restrictAlong g = (g ∘ q , λ x y p � cong g p)  from
-- (B � C) to the descent data  �[ f ∈ (A � C) ] Coequalizes q f.  Take
-- A = B = Unit, q = id (a surjection), C = S�.  The descent datum
--
--     loopDatum = (const base , λ _ _ _ � loop)
--
-- is a perfectly good datum � it coequalises id � but it is not in the
-- image: any g with restrictAlong g ≡ loopDatum would give loop ≡ refl,
-- and winding separates them (winding loop = 1, winding refl = 0).  So
-- the map is not an equivalence, not even surjective, and the ONLY
-- hypothesis of §4 that fails is `isSet S�`, which indeed fails for the
-- same reason.
--
-- What this settles: the set hypothesis in §4's `descentEquiv` is
-- necessary, not a convenience � `descends-split` needs a section,
-- `descends` needs a set, and neither hypothesis can be dropped.
------------------------------------------------------------------------
module AsetChidra_TheDescentEquivalenceFailsAtANonSetTheWitnessIsTheLoopOfTheCircleSoTheSetHypothesisOfRepresentabilityIsNecessary where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_ ; idfun)
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Foundations.Equiv using (isEquiv ; fiber ; equiv-proof)
open import Cubical.Foundations.GroupoidLaws using (lUnit)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Nat using (zero ; suc ; snotz)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Data.Int.Properties using (injPos)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Functions.Surjection using (isSurjection)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.HITs.S1 using (S¹ ; base ; loop ; winding ; intLoop ; ΩS¹Isoℤ)

open import DefectCalculus using (Coequalizes)

-- � � ��(S�) separates loop from refl
loop≢refl : ¬ (loop ≡ refl)
loop≢refl p = snotz (injPos one≡zero)
  where
  one≡zero : pos 1 ≡ pos 0
  one≡zero =
      sym (Iso.rightInv ΩS¹Isoℤ (pos 1))          -- pos 1 ≡ winding (refl ∙ loop)
    ∙ cong winding (sym (lUnit loop) ∙ p)         -- ≡ winding refl
    ∙ Iso.rightInv ΩS¹Isoℤ (pos 0)                -- ≡ pos 0

¬isSetS¹ : ¬ isSet S¹
¬isSetS¹ s = loop≢refl (s base base loop refl)

-- � � the descent problem of §4 at A = B = Unit, q = id, C = S�
q : Unit → Unit
q = idfun Unit

q-surj : isSurjection q
q-surj u = ∣ u , refl ∣₁

DescentData : Type
DescentData = Σ[ f ∈ (Unit → S¹) ] Coequalizes q f

-- §4's map, written out (it is stated there only under `isSet C`)
restrictAlong : (Unit → S¹) → DescentData
restrictAlong g = g ∘ q , λ x y p → cong g p

-- the datum that carries the loop
loopDatum : DescentData
loopDatum = (λ _ → base) , λ _ _ _ → loop

-- � � it is not in the image
private
  D : (f : Unit → S¹) → Coequalizes q f
  D f x y p = cong f p

not-in-image : ¬ (fiber restrictAlong loopDatum)
not-in-image (g , e) = loop≢refl (sym (λ i → both i tt tt refl))
  where
  both : D (λ _ → base) ≡ (λ _ _ _ → loop)
  both = sym (fromPathP (λ i → D (fst (e i)))) ∙ fromPathP (λ i → snd (e i))

-- � � so §4's equivalence fails at this non-set, though q is a surjection
not-equiv : ¬ isEquiv restrictAlong
not-equiv eq = not-in-image (fst (eq .equiv-proof loopDatum))
