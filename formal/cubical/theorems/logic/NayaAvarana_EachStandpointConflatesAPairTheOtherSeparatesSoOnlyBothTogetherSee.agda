{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- नय-आवरणम् — each standpoint carries its own obscuration: it conflates a
-- pair the other separates, so only both together see.
--
-- THE COMPLETION OF THE द्रव्यपर्याय ↔ क्रम-सह JOIN.  `DravyaParyaya_…`
-- (Umāsvāti, Tattvārthasūtra 5.29/5.37; Siddhasena, Sanmatitarka 1.3–6)
-- identified the two standpoints in cubespace: dravyārthika reads the
-- type, paryāyārthika reads the paths.  `KramaSaha_…` proved they do not
-- commute and priced the commutator: exactly ℤ.  Siddhasena's sentence is
-- stronger than either: EACH standpoint, taken as sole, denies the other
-- — a durnaya — and this module checks that sentence in BOTH directions,
-- as two blindness theorems with explicit conflated pairs:
--
--   the dravya census   O₁ X = ∥ X ∥₂        (what points are there)
--   the paryāya census  O₂ X = ∥ Ω X ∥₂      (what loops are there)
--
--   द्रव्य-अन्धः     :  O₁ conflates S¹ with Unit      (both census to a point)
--   पर्याय-पृथक्    :  O₂ separates that very pair    (ℤ against the point)
--
--   पर्याय-अन्धः    :  O₂ conflates Bool × S¹ with S¹  (both census to ℤ —
--                     the second component vanishes without residue)
--   द्रव्य-पृथक्    :  O₁ separates that very pair    (Bool against Unit)
--
-- Neither census subsumes the other; each is refutably incomplete with a
-- WITNESSED pair it cannot tell apart; and the pair it misses is exactly
-- a pair the other resolves.  That is anekāntavāda as a pair of checked
-- counterexamples — the necessity of the plurality of nayas, not its
-- recommendation.
--
-- ON THE NAME.  आवरण (obscuration) is the tradition's own word for what
-- blocks a knower from an object — ज्ञानावरण heads the karma taxonomy
-- (Umāsvāti, Tattvārthasūtra 8.5).  The compound नय-आवरण — the obscuration
-- carried BY a standpoint, structural rather than karmic — is built here,
-- 2026-08-23.  No claim that any Jain author stated these equivalences;
-- the claim is that Sanmatitarka 1.3–6's "each naya, made sole, is false"
-- has these four terms as its smallest cubical instance.
------------------------------------------------------------------------

module NayaAvarana_EachStandpointConflatesAPairTheOtherSeparatesSoOnlyBothTogetherSee where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv
  using (_≃_ ; equivFun ; invEq ; retEq ; compEquiv ; invEquiv ; isContr→Equiv)
open import Cubical.Data.Int using (ℤ)
open import Cubical.Data.Bool using (Bool ; true ; false ; isSetBool ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit ; isPropUnit)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.PropositionalTruncation using () renaming (rec to rec₁)
open import Cubical.HITs.S1 using (S¹ ; base ; ΩS¹ ; isConnectedS¹)
open import Cubical.HITs.SetTruncation
  using (∥_∥₂ ; ∣_∣₂ ; isSetSetTrunc ; setTruncIso)
  renaming (rec to rec₂ ; elim to elim₂)

open import KramaSaha_TheOrderOfStandpointsIsTheChargeItself
  using (क्रमः-लूप-प्रथमम् ; अक्रमता)

------------------------------------------------------------------------
-- ० · small instruments: contractibility transports backwards along an
-- equivalence, and a contractible type set-truncates to a contractible one.
------------------------------------------------------------------------

निवर्त-सङ्कोचः : {A B : Type} → A ≃ B → isContr B → isContr A
निवर्त-सङ्कोचः e (c , h) =
  invEq e c , λ a → cong (invEq e) (h (equivFun e a)) ∙ retEq e a

सङ्कोच-गणना : {A : Type} → isContr A → isContr ∥ A ∥₂
सङ्कोच-गणना (c , h) =
  ∣ c ∣₂ ,
  elim₂ (λ _ → isProp→isSet (isSetSetTrunc _ _)) (λ a i → ∣ h a i ∣₂)

------------------------------------------------------------------------
-- १ · द्रव्य-अन्धः — the dravya census conflates S¹ with Unit.
-- Both truncate to a point: the census that reads only points cannot
-- tell the circle from the point, because the circle's content is not
-- in its points.
------------------------------------------------------------------------

एक-गणना : isContr ∥ S¹ ∥₂
एक-गणना =
  ∣ base ∣₂ ,
  elim₂ (λ _ → isProp→isSet (isSetSetTrunc _ _))
        (λ s → rec₁ (isSetSetTrunc _ _) (cong ∣_∣₂) (isConnectedS¹ s))

द्रव्य-अन्धः : ∥ S¹ ∥₂ ≃ ∥ Unit ∥₂
द्रव्य-अन्धः =
  isContr→Equiv एक-गणना (सङ्कोच-गणना (tt , λ u → isPropUnit tt u))

------------------------------------------------------------------------
-- २ · पर्याय-पृथक् — the paryāya census separates that very pair.
-- ∥ Ω S¹ ∥₂ ≃ ℤ (KramaSaha) is not contractible (अक्रमता); ∥ Ω Unit ∥₂ is.
------------------------------------------------------------------------

बिन्दु-लूप-सङ्कोचः : isContr ∥ Path Unit tt tt ∥₂
बिन्दु-लूप-सङ्कोचः = सङ्कोच-गणना (refl , λ p → isSetUnit tt tt refl p)

पर्याय-पृथक् : ¬ (∥ ΩS¹ ∥₂ ≃ ∥ Path Unit tt tt ∥₂)
पर्याय-पृथक् e = अक्रमता (निवर्त-सङ्कोचः e बिन्दु-लूप-सङ्कोचः)

------------------------------------------------------------------------
-- ३ · पर्याय-अन्धः — the paryāya census conflates Bool × S¹ with S¹.
-- At the basepoint (true , base) the loops of the product are the loops
-- of the circle alone: the Bool coordinate of any loop is a self-path in
-- a set, hence trivial.  The second substance vanishes from the loop
-- census WITHOUT RESIDUE — both sides census to the same ℤ.
------------------------------------------------------------------------

युगल-लूपः : Type
युगल-लूपः = Path (Bool × S¹) (true , base) (true , base)

लूप-प्रक्षेपः : Iso युगल-लूपः ΩS¹
Iso.fun      लूप-प्रक्षेपः p = cong snd p
Iso.inv      लूप-प्रक्षेपः q i = true , q i
Iso.rightInv लूप-प्रक्षेपः q = refl
Iso.leftInv  लूप-प्रक्षेपः p j i =
  isSetBool true true refl (cong fst p) j i , snd (p i)

पर्याय-अन्धः : ∥ युगल-लूपः ∥₂ ≃ ∥ ΩS¹ ∥₂
पर्याय-अन्धः = isoToEquiv (setTruncIso लूप-प्रक्षेपः)

-- and the conflation is at full charge: both censuses read ℤ, so what O₂
-- reports for the two-substance space is literally what it reports for one.
पर्याय-अन्धः-भारः : ∥ युगल-लूपः ∥₂ ≃ ℤ
पर्याय-अन्धः-भारः = compEquiv पर्याय-अन्धः क्रमः-लूप-प्रथमम्

------------------------------------------------------------------------
-- ४ · द्रव्य-पृथक् — the dravya census separates that very pair.
-- ∥ Bool × S¹ ∥₂ ≃ Bool: two components, exhibited; against एक-गणना's
-- single point, through the wall Bool ≄ Unit.
------------------------------------------------------------------------

द्वि-गणना : ∥ Bool × S¹ ∥₂ ≃ Bool
द्वि-गणना = isoToEquiv (iso अङ्कः निवेशः (λ _ → refl) परावृत्तिः)
  where
    अङ्कः : ∥ Bool × S¹ ∥₂ → Bool
    अङ्कः = rec₂ isSetBool fst
    निवेशः : Bool → ∥ Bool × S¹ ∥₂
    निवेशः b = ∣ b , base ∣₂
    पदम् : (a : Bool × S¹) → निवेशः (अङ्कः ∣ a ∣₂) ≡ ∣ a ∣₂
    पदम् (b , s) =
      rec₁ (isSetSetTrunc (निवेशः b) ∣ b , s ∣₂)
           (λ q i → ∣ b , q i ∣₂)
           (isConnectedS¹ s)
    परावृत्तिः : (x : ∥ Bool × S¹ ∥₂) → निवेशः (अङ्कः x) ≡ x
    परावृत्तिः = elim₂ (λ _ → isProp→isSet (isSetSetTrunc _ _)) पदम्

नो-द्वि-एक : ¬ (Bool ≃ Unit)
नो-द्वि-एक e =
  true≢false (sym (retEq e true)
             ∙ cong (invEq e) (isPropUnit _ _)
             ∙ retEq e false)

द्रव्य-पृथक् : ¬ (∥ Bool × S¹ ∥₂ ≃ ∥ S¹ ∥₂)
द्रव्य-पृथक् e =
  नो-द्वि-एक (compEquiv (invEquiv द्वि-गणना)
             (compEquiv e (isContr→Equiv एक-गणना (tt , λ u → isPropUnit tt u))))

------------------------------------------------------------------------
-- ५ · दोषलेखः.  Two censuses, two blindness witnesses, mutually covered —
-- the smallest instance, not a completeness theorem: no claim that O₁ and
-- O₂ JOINTLY classify spaces (they do not — they cannot separate spaces
-- agreeing on π₀ and π₁ at the basepoint; the tower continues upward, and
-- so, by गुह्य-नास्ति's restratification, does the sevenfold).  What is
-- proved is exactly Sanmatitarka 1.3–6's shape: each naya sole is false
-- by counterexample, and the counterexample of each lies in the sight of
-- the other.
------------------------------------------------------------------------
