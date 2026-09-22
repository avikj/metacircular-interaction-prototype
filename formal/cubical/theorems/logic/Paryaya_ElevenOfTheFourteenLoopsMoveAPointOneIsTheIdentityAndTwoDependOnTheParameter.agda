{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ������ � paryya � THE SUBSTANCE IS UNCHANGED AND THE MODE IS NOT
--
-- THE TERM, ITS TEXT AND ITS DATE.  ������ (paryya) is the Jaina term
-- for a MODE of a substance, paired against ������ (dravya), the
-- substance itself: `������������������������� ���` � the real is what is
-- endowed with origination, cessation and persistence � and
-- `������������� ��������` � a substance is that which has qualities and
-- modes.  Umsvti, *Tattvrthastra* 5.29 and 5.37 (~2nd�5th c.).  The
-- two ROOT standpoints built on the pair, ��������������� (substance-
-- regarding) and ��������������� (mode-regarding), are Siddhasena
-- Divkara, *Sanmatitarka* 1.3�1.6 (~5th c.); the durnaya sharpening �
-- either naya asserting itself by denying the other is false � is
-- Siddhasena's and Akalaka's (~8th c.).  Jaina; the Naiyyikas reject
-- anekntavda outright, and the school is named because the dispute is
-- the content.
--
-- ��������������������������������������������������������������������
-- WHAT THIS IS, AND HOW IT DIFFERS FROM ITS COMPANION.
--
-- `Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere`
-- proves the GENERAL annihilation: `cong F p ≡ refl` for every
-- set-valued `F` and every loop `p`, with no hypothesis on `F`.  It
-- exhibits ONE loop (`ua notEquiv`) to show the sector is not empty.
--
-- This module is the CENSUS.  `interactive/Setubandha_�.hs` scans the corpus
-- for checked identifications and reports fourteen of the form `A � A`,
-- filing them as "no reachability, real content".  Under the companion's
-- theorem those fourteen are the ONLY inhabited charged sector this
-- corpus has.  So each is named here and decided, and the answer is
-- three-valued, not two:
--
--   ��  move a point, hence `ua e � refl`               � real charge
--    �  is the identity function, hence `ua e ≡ refl`   � NOT charge
--    �  are FAMILIES whose answer depends on the parameter: identity at
--       one instantiation and not at another             � no answer exists
--
-- The count of charged loops in this corpus is therefore **11**, not 14,
-- and two of the fourteen rows are not loops at all but families over a
-- type variable, which the extractor cannot see because it matches
-- conclusions and not telescopes.
--
-- ��������������������������������������������������������������������
-- THE DISCRIMINANT (§�).  For `e : A � A`, `ua e ≡ refl` implies
-- `equivFun e a ≡ a` for every `a`.  One moved point therefore refutes
-- `ua e ≡ refl`, and this is the whole test.  It is the contrapositive
-- of `uaIdEquiv` and needs no injectivity of `ua`.
--
-- THE PAYOFF (§�).  At the graph's own hub � `�`, degree 7, the largest
-- component's centre � the corpus holds exactly one checked automorphism,
-- `PathIsSymmetry.swap01-Equiv`, the transposition (0 1).  It squares to
-- the identity and is not the identity, so the subgroup of `Aut(�)` that
-- this corpus has actually checked at its hub is exactly **�/2**.  Every
-- set-valued observable reports `refl` on its loop.  The untruncated
-- observable reports `0 � 1`.  That is the same fact twice, and the
-- second reading is the one with content.
--
-- interactive/Setubandha_�.hs (the census this decides).
------------------------------------------------------------------------

module Paryaya_ElevenOfTheFourteenLoopsMoveAPointOneIsTheIdentityAndTwoDependOnTheParameter where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Equiv using (_≃_; equivFun; idEquiv; compEquiv; invEquiv; equivEq)
open import Cubical.Foundations.Isomorphism using (isoToEquiv; iso)
open import Cubical.Data.Bool using (Bool; true; false; not; true≢false; false≢true)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Data.List using (List; []; _∷_; rev)
open import Cubical.Data.Maybe using (Maybe; just; nothing)
open import Cubical.Data.Nat using (ℕ; zero; suc; snotz; znots)
open import Cubical.Data.Int using (ℤ; pos; negsuc; injPos)
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd)
open import Cubical.Relation.Nullary using (¬_)

-- the fourteen rows, each in the module that checked it
import CycleHolonomy                                as CY
import AchromaticToy                                   as AT
import ReversalInvariant                            as RV
import ExactTwoStateInstrument          as EI
import StructuredDefect                 as SD
import TheArithmeticCircleIsFourPeriodic as AC
import UnivalentTensorInteraction       as UT
import BraidCoherenceBoundary           as BR
import DefectCalculus                   as DC
import PathIsSymmetry                   as PS

-- the general annihilation theorem, applied and not re-proved
import Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere as NAYA

private variable ℓ : Level

------------------------------------------------------------------------
-- � �� THE DISCRIMINANT.  `ua e ≡ refl` forces every point to be fixed.
------------------------------------------------------------------------

स्थैर्यम् : {A : Type ℓ} (e : A ≃ A) → ua e ≡ refl → (a : A) → equivFun e a ≡ a
स्थैर्यम् e p a =
  sym (uaβ e a) ∙ cong (λ q → transport q a) p ∙ transportRefl a

-- one moved point is the whole refutation
चलनम् : {A : Type ℓ} (e : A ≃ A) (a : A)
      → ¬ (equivFun e a ≡ a) → ¬ (ua e ≡ refl)
चलनम् e a moves p = moves (स्थैर्यम् e p a)

------------------------------------------------------------------------
-- � �� ELEVEN THAT MOVE A POINT.  Real charge, one row at a time.
------------------------------------------------------------------------

-- �.�  CycleHolonomy.holBool : Bool � Bool � three `not`s, so `not`.
१-holBool : ¬ (ua CY.holBool ≡ refl)
१-holBool = चलनम् CY.holBool true
  (λ q → false≢true (sym (CY.holBoolIsNot true) ∙ q))

-- �.�  AchromaticToy.holonomy : G� � G� � the two-lens cycle, also `not`.
२-holonomy : ¬ (ua AT.holonomy ≡ refl)
२-holonomy = चलनम् AT.holonomy true
  (λ q → false≢true (sym (funExt⁻ AT.holonomyIsNot true) ∙ q))

-- �.�  ExactTwoStateInstrument.xEventEquiv � the Pauli-X frame change
--      flips the outcome label, so no event is fixed.
३-xEvent : ¬ (ua EI.xEventEquiv ≡ refl)
३-xEvent = चलनम् EI.xEventEquiv (EI.basisState false , true)
  (λ q → false≢true (cong snd q))

-- �.�  StructuredDefect.notEquiv : Bool � Bool
४-structuredNot : ¬ (ua SD.notEquiv ≡ refl)
४-structuredNot = चलनम् SD.notEquiv true false≢true

-- �.�  DefectCalculus.notEquiv : Bool � Bool
५-defectNot : ¬ (ua DC.notEquiv ≡ refl)
५-defectNot = चलनम् DC.notEquiv true false≢true

-- �.�  UnivalentTensorInteraction.phaseExchange : JointCoherence � itself
६-phaseExchange : ¬ (ua UT.phaseExchange ≡ refl)
६-phaseExchange = चलनम् UT.phaseExchange true false≢true

-- �.�  TheArithmeticCircleIsFourPeriodic.e : Pair � Pair � the quarter
--      turn over � sends the unit (1,0) to (0,1).
७-quarterTurn : ¬ (ua AC.e ≡ refl)
७-quarterTurn = चलनम् AC.e (pos 1 , pos 0)
  (λ q → znots (injPos (cong fst q)))

-- �.����  BraidCoherenceBoundary: three of the four crossings move a point.
८-swap₁ : ¬ (ua BR.swap₁Equiv ≡ refl)
८-swap₁ = चलनम् BR.swap₁Equiv (true , false , true)
  (λ q → false≢true (cong fst q))

९-swap₂ : ¬ (ua BR.swap₂Equiv ≡ refl)
९-swap₂ = चलनम् BR.swap₂Equiv (true , true , false)
  (λ q → false≢true (cong (λ x → fst (snd x)) q))

१०-flipFirst : ¬ (ua BR.flipFirstEquiv ≡ refl)
१०-flipFirst = चलनम् BR.flipFirstEquiv (true , true , true)
  (λ q → false≢true (cong fst q))

-- �.��  PathIsSymmetry.swap01-Equiv : � � � � the corpus's ONLY checked
--       automorphism at the identification graph's hub node.
११-swap01 : ¬ (ua PS.swap01-Equiv ≡ refl)
११-swap01 = चलनम् PS.swap01-Equiv zero snotz

------------------------------------------------------------------------
-- � �� ONE THAT IS THE IDENTITY, AND TWO THAT HAVE NO ANSWER.
------------------------------------------------------------------------

-- �.�  BraidCoherenceBoundary.identityCrossingEquiv is `iso id id �`.
--      It is a row in the census and it carries NOTHING: its ua-loop is
--      `refl`, so the census's fourteen drops to thirteen on this line,
--      and to eleven decided ones on §�.� and §�.�.
शून्य-पर्यायः : ua BR.identityCrossingEquiv ≡ refl
शून्य-पर्यायः = cong ua (equivEq refl) ∙ uaIdEquiv

-- �.�  CycleHolonomy.hol is not a loop: it is a FAMILY over three
--      equivalences, and the census matched its conclusion.  At the
--      identity arguments it is the identity �
हेतु-सापेक्षः-तुच्छः : (A : Type ℓ)
  → ua (CY.hol (idEquiv A) (idEquiv A) (idEquiv A)) ≡ refl
हेतु-सापेक्षः-तुच्छः A = cong ua (CY.holTrivial A) ∙ uaIdEquiv

-- � and at `notEquiv` it is not (that instantiation IS `holBool`, §�.�).
-- So the family has no answer; only its instances do.

-- �.�  ReversalInvariant.revEquiv is likewise a family, over the
--      letter type.  Over an empty alphabet reversal is the identity �
शून्याक्षरे : (xs : List ⊥) → rev xs ≡ xs
शून्याक्षरे []       = refl
शून्याक्षरे (x ∷ xs) = ⊥-rec x

हेतु-सापेक्षः-वर्णः : ua (RV.revEquiv {A = ⊥}) ≡ refl
हेतु-सापेक्षः-वर्णः = cong ua (equivEq (funExt शून्याक्षरे)) ∙ uaIdEquiv

-- � and over Bool it is not: `head?` is a chromatic observable and it
-- separates the two readings of `true � false � []` (RV.head?-sees-rev).
हेतु-सापेक्षः-वर्णः-चलति : ¬ (ua (RV.revEquiv {A = Bool}) ≡ refl)
हेतु-सापेक्षः-वर्णः-चलति = चलनम् (RV.revEquiv {A = Bool}) RV.w₂
  (λ q → RV.just-true≢just-false
           (sym RV.head?-w₂ ∙ sym (cong RV.head? q) ∙ RV.head?-rev-w₂))

------------------------------------------------------------------------
-- � �� THE HUB.  What �� the corpus has actually checked at `�`.
------------------------------------------------------------------------

-- The hub loop, named.
हस्त-आवर्तः : ℕ ≡ ℕ
हस्त-आवर्तः = ua PS.swap01-Equiv

-- It is an involution �
द्वित्वम् : compEquiv PS.swap01-Equiv PS.swap01-Equiv ≡ idEquiv ℕ
द्वित्वम् = equivEq (funExt PS.swap01-involutive)

आवर्तः-वर्गः : हस्त-आवर्तः ∙ हस्त-आवर्तः ≡ refl
आवर्तः-वर्गः =
  sym (uaCompEquiv PS.swap01-Equiv PS.swap01-Equiv)
  ∙ cong ua द्वित्वम्
  ∙ uaIdEquiv

-- � and it is not the identity (§�.��).  So the subgroup of Aut(�)
-- generated by the corpus's own checked loop at its hub node is exactly
-- �/2: order dividing two, and not one.
द्विवर्गः : (हस्त-आवर्तः ∙ हस्त-आवर्तः ≡ refl) × (¬ (हस्त-आवर्तः ≡ refl))
द्विवर्गः = आवर्तः-वर्गः , ११-swap01

------------------------------------------------------------------------
-- � �� THE TWO STANDPOINTS ON THAT LOOP.
------------------------------------------------------------------------

-- ������������� � the substance-regarding standpoint.  Any observable
-- landing in a set reports `refl`.  This is the companion's theorem,
-- applied here and not re-proved.
द्रव्यार्थिकः : (X : Type₀) → isSet X → (F : Type₀ → X)
              → cong F हस्त-आवर्तः ≡ refl
द्रव्यार्थिकः X isSetX F = NAYA.नय-निरोधः isSetX F हस्त-आवर्तः

-- ������������� � the mode-regarding standpoint.  Do not land in a set:
-- transport along the SAME loop, and it reports the relabeling.
पर्यायार्थिकः : transport हस्त-आवर्तः zero ≡ suc zero
पर्यायार्थिकः = uaβ PS.swap01-Equiv zero

-- and the two are not reconcilable by working harder at the first: the
-- loop the first standpoint annihilates is the loop the second reads.
अनेकान्तः :
    ((X : Type₀) → isSet X → (F : Type₀ → X) → cong F हस्त-आवर्तः ≡ refl)
  × (¬ (transport हस्त-आवर्तः zero ≡ zero))
अनेकान्तः = द्रव्यार्थिकः , λ q → snotz (sym पर्यायार्थिकः ∙ q)
