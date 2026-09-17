{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ���������� � the hidden circuit.  The loss is not in the fibre; it is in
-- the TRUNCATION of the fibre.  Taking fibres is lossless (A � �_b fiber
-- f b, an equivalence).  What loses is crushing the fibre family down a
-- level � and here is the exact witness of what a set-level census cannot
-- see: a fibre that is a CIRCLE, which the census �−�� reads as a POINT.
--
-- f = const : S� � Unit.  Its fibre over tt is S� (every tt ≡ tt is
-- contractible, so �[x∈S�](tt≡tt) � S�).
--
--   census : isContr � fiber f tt ��     -- �� sees one point: ��������-looking
--   loop   : � (fiber f tt � Unit)        -- but the fibre is S�, not a point
--
-- So even �−�� merges the circle-fibre with the point-fibre.
-- WholePartialDesa's census and GuhyaNasti's "the loss hides in the loops
-- and the set-level census cannot see it", made exact and graded: the loss
-- lives at level � 1, above where the census truncates.
------------------------------------------------------------------------

module GudhaAvarta_TheSetCensusReadsTheCircleFibreAsAPointSoTheLoopIsExactlyTheTruncationsLoss where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; fiber ; invEquiv ; compEquiv ; equivToIso)
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Foundations.HLevels using (isOfHLevelRespectEquiv)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; Σ-contractSnd)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit ; isContrUnit)
open import Cubical.Data.Nat using (znots)
open import Cubical.Data.Int using (ℤ ; pos ; injPos)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.S1 using (S¹ ; base ; loop ; winding)
open import Cubical.HITs.PropositionalTruncation
  using (∥_∥₁ ; ∣_∣₁ ; squash₁) renaming (rec to rec₁)
open import Cubical.HITs.SetTruncation
  using (∥_∥₂ ; ∣_∣₂ ; isSetSetTrunc ; setTruncIso) renaming (elim to elim₂)

cst : S¹ → Unit
cst _ = tt

-- tt ≡ tt is contractible (Unit is a set, inhabited by refl).
isContr-tt≡ : isContr (tt ≡ tt)
isContr-tt≡ = refl , λ p → isSetUnit tt tt refl p

-- the fibre over tt IS the circle.
fibre≃S¹ : fiber cst tt ≃ S¹
fibre≃S¹ = Σ-contractSnd (λ _ → isContr-tt≡)

------------------------------------------------------------------------
-- THE FIBRE IS NOT A POINT.  S� � Unit � S� is a proposition � refl ≡ loop
-- at base; winding sends that to pos 0 ≡ pos 1.
------------------------------------------------------------------------

¬S¹≃Unit : ¬ (S¹ ≃ Unit)
¬S¹≃Unit e = znots (injPos w0≡w1)
  where
    isPropS¹ : isProp S¹
    isPropS¹ = isContr→isProp (isOfHLevelRespectEquiv 0 (invEquiv e) isContrUnit)
    refl≡loop : refl ≡ loop
    refl≡loop = isProp→isSet isPropS¹ base base refl loop
    w0≡w1 : pos 0 ≡ pos 1
    w0≡w1 = cong winding refl≡loop

fibre-not-point : ¬ (fiber cst tt ≃ Unit)
fibre-not-point e = ¬S¹≃Unit (compEquiv (invEquiv fibre≃S¹) e)

------------------------------------------------------------------------
-- THE SET CENSUS READS IT AS A POINT.  S� is connected, so � S� �� is
-- contractible; the fibre-equivalence transports that to the fibre.
------------------------------------------------------------------------

-- S� is (propositionally) connected: proved by S�-induction into a prop.
conn : (s : S¹) → ∥ base ≡ s ∥₁
conn base     = ∣ refl ∣₁
conn (loop i) = isProp→PathP (λ i → squash₁ {A = base ≡ loop i})
                             (∣ refl ∣₁) (∣ refl ∣₁) i

isContr∥S¹∥₂ : isContr (∥ S¹ ∥₂)
fst isContr∥S¹∥₂ = ∣ base ∣₂
snd isContr∥S¹∥₂ =
  elim₂ (λ _ → isProp→isSet (isSetSetTrunc _ _))
        (λ s → rec₁ (isSetSetTrunc _ _) (λ p → cong ∣_∣₂ p) (conn s))

census : isContr (∥ fiber cst tt ∥₂)
census = isOfHLevelRespectEquiv 0
           (invEquiv (isoToEquiv (setTruncIso (equivToIso fibre≃S¹))))
           isContr∥S¹∥₂
