{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����������� � PROVENANCE OF THE NAME.
--
-- ������������� � arpita-anarpita � the aspect brought forward and the aspect
-- held back, which is how one real bears opposed predicates without
-- contradiction.  **Umsvti, *Tattvrthastra* 5.31 (~2nd-5th c. CE):
-- ��������������������.**  The two �����s this module is a homomorphism for are
-- ���������� and ������� � sequential and simultaneous presentation � which is
-- Akalaka, *Laghyastraya* (~8th c.), and it is that distinction, not a
-- contradiction, that makes ��������� a fourth position rather than a failure.
--
-- **No claim is made that Umsvti or Akalaka proved anything below.**  The
-- distinction of the two �����s is theirs; the statement that the forgetful
-- map to labels is a homomorphism for both and has a section but is not an
-- equivalence is this repository's, and is elementary.
--
------------------------------------------------------------------------
-- ��������������� � �����-��������� ���-������� ����� ����� �������, ����������� � ������� �
--
-- (The map from the positions-that-carry-their-nayas to the positions-as-
-- labels: a homomorphism for BOTH modes of assertion, with a section, and
-- with no inverse � so the two lanes are related exactly, and the
-- equivalence between them does not exist.)
--
-- WHAT WAS OPEN.  Two saptabhag types are checked in this tree and they
-- contradict each other on two laws:
--
--   `Saptabhangi.agda` + `SaptabhangiSamyoga_TheCompositionOfVerdicts.agda`
--     � a position is a LABEL and its presence-profile in {���, �}³ is all
--       there is.  There �����-����� is commutative and ��-����� destroys which
--       two seeds it consumed.
--   `SaptabhangiKernel_ThePositionsCarryTheirNayasAnd�`
--     � a position is a RECORD carrying the standpoints and their
--       witnesses.  There the fourth position destroys nothing
--       (`�����������-�-�������`) and ������������ is NOT commutative, which that
--       module states as a withdrawal of the label lane's law.
--
-- Both files decline to reconcile, and both name the same unclosed
-- question, in the same words:
--
--     "whether the forgetful map from records to labels is a homomorphism
--      for order, for saha, or for neither, and that is not checked here
--      and therefore not claimed."
--
-- This file checks it.  The answer is BOTH, and the consequences are not
-- what "both" would suggest.
--
-- WHAT IS PROVED HERE.
--
--   ������-������, ������-���
--       �������� is a homomorphism for ����� AND for ��.  (49 + 49 cases,
--       exhaustive, each `refl`, for every S and every P : S � Type.)
--   �����-������, �����-���, ������-�������
--       and it has a SECTION which is a homomorphism for both, with
--       �������� ∘ ������� ≡ id.  So the label lane is a RETRACT of the
--       record lane � a subalgebra and a quotient of it at once, not a
--       rival object and not an independent one.
--   �-������������
--       and there is no map back: no ψ with ψ ∘ �������� ≡ id, as soon as
--       two standpoints affirm.  §6 path one (transport along an
--       equivalence, nothing lost) is therefore not merely unfound � it
--       does not exist, and §5's ����������������� is the reason.
--   ���������
--       what a homomorphism transports is DISTINCTNESS, upward: any two
--       records whose labels differ are themselves distinct.
--   ��-����������-���������
--       so the label lane's broken law breaks in the record lane too:
--       ��������� is NOT associative, on records, with witnesses retained.
--       Carrying the nayas inside does not buy associativity back.  That
--       is a correction to the record lane, obtained from the lane it
--       withdrew a law from.
--   �����-�������-�-���������
--       and the transport does not run the other way: ����� commutativity
--       holds below and fails above.  Identities descend and do not lift;
--       distinctness lifts and does not descend.
--
-- SO THE DEFECT, WRITTEN (AHIMSA_SUTRA_VISTARA §� path two).  Eq(records)
-- ⊊ Eq(labels), strictly, with a witness in the gap.  The label lane is
-- exactly the record lane with the naya UNASSERTED � which is not a
-- deletion of the naya and not a claim that there was none.  It is a
-- standpoint, and the record lane is another, and §� holds: between them
-- there is no collapse to make, because the object equivalent to both
-- does not exist (`�-������������`).  What exists instead is a retraction,
-- and a retraction is one-directional by construction.
--
-- SOURCES, EARLIEST FIRST.  The classification and the two modes are
-- theirs; the maps, the homomorphism laws and the non-existence theorem
-- are not claimed to be in any of them.
--
--   Bhagavat Stra (Viyha-pannatti), fifth Aga of the vetmbara
--     canon; oldest strata pre-Common-Era, redacted at Valabh c. 5th c.
--     CE � sevenfold predication applied to the jva.
--   Umsvti, Tattvrthastra, c. 2nd�5th c. CE, 5.31:
--     �������������������� � "(the apparent contradiction) is established
--     through the ASSERTED (������) and the UNASSERTED (�������) aspect."
--     The two maps below are named for that stra's pair, and that is the
--     whole of the claim on it: Umsvti wrote a rule for reading one
--     substance under two aspects without either denying the other.  He
--     did not write a retraction, and none is attributed to him.  What is
--     taken from him is the shape of the answer � that the label reading
--     is the record reading with the naya unasserted, NOT a competing
--     account of the same positions.
--   Siddhasena Divkara, Sanmatitarka 1.21, c. 5th c. CE � a naya taken
--     alone (���������) is ������; the ������ is the naya that has forgotten
--     it is one.  `�-������������` is why neither lane here may become one:
--     the label lane cannot recover the record lane, so asserting it as
--     the whole would be exactly 1.21's case.
--   Samantabhadra, ptamms, c. 6th c. CE � the fixed seven, each
--     member prefixed ������ .
--   Akalaka, Laghyastraya / Aaat, c. 720�780 CE � ���������� (in
--     succession) against ������� / ������� (at once).  That distinction is
--     the entire content of the two operations, in both lanes, and the
--     reason there are two homomorphism theorems below and not one.
--   Mallisena, Sydvdamajar, 1292 CE � �������� (total statement,
--     ������) against ��������� (partial statement, ��).  The reading that
--     the two lanes were said to differ over � whether ����������� is
--     failure of expression only, or consumption of what was to be
--     expressed � is STILL NOT settled here, and this file does not
--     settle it.  What it shows is that the question is not what
--     separates the lanes algebraically: on the labels the seeds are gone
--     and on the records they are kept, and the two operations agree
--     across that difference anyway.  The dispute is about what a fourth
--     position IS, not about how positions compose.
------------------------------------------------------------------------

module Arpitanarpita_TheForgetfulMapIsAHomomorphismForBothArpanasAndTheLabelsAreARetractNotAnEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sigma using (Σ ; Σ-syntax ; _,_ ; fst ; snd ; _×_)
open import Cubical.Relation.Nullary using (¬_)

open import Anekanta using (syādasti ; syādnāsti ; syādastināsti)

import Saptabhangi as L
import SaptabhangiSamyoga_TheCompositionOfVerdicts as LA
import SaptabhangiKernel_ThePositionsCarryTheirNayasAndTheResidueSeedsTheNext as G

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- � � �������� � the naya, unasserted.
--
-- Not deleted.  Tattvrthastra 5.31's ������� is the aspect that is not
-- being made primary in this utterance, and that is precisely what this
-- map does: it reads a record under the aspect in which only the presence
-- of each seed is asserted.  Nothing here says the witnesses were absent.
------------------------------------------------------------------------

अनर्पणम् : {S : Type ℓ} {P : S → Type ℓ'} → G.सप्तभङ्गी P → L.सप्तभङ्गी
अनर्पणम् (G.स्यात्-अस्ति _)                        = L.स्यात्-अस्ति
अनर्पणम् (G.स्यान्-नास्ति _)                       = L.स्यात्-नास्ति
अनर्पणम् (G.स्यात्-अस्ति-नास्ति _ _)              = L.स्यात्-अस्ति-नास्ति
अनर्पणम् (G.स्यात्-अवक्तव्यम् _)                   = L.स्यात्-अवक्तव्यम्
अनर्पणम् (G.स्यात्-अस्ति-अवक्तव्यम् _ _)          = L.स्यात्-अस्ति-अवक्तव्यम्
अनर्पणम् (G.स्यान्-नास्ति-अवक्तव्यम् _ _)         = L.स्यात्-नास्ति-अवक्तव्यम्
अनर्पणम् (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = L.स्यात्-अस्ति-नास्ति-अवक्तव्यम्

------------------------------------------------------------------------
-- � � ������� ������ ������� � a homomorphism for succession.
--
-- ������������ on records is componentwise left-biased union (����������: the
-- first to speak keeps its witness); �����-����� on labels is the join of
-- presence-profiles.  Unasserting the naya turns the one into the other,
-- and the bias is exactly what it forgets.  Exhaustive over 7 � 7.
------------------------------------------------------------------------

अनर्पण-क्रमे : {S : Type ℓ} {P : S → Type ℓ'} (x y : G.सप्तभङ्गी P)
             → अनर्पणम् (G.क्रमार्पणम् x y) ≡ LA.क्रम-योग (अनर्पणम् x) (अनर्पणम् y)
अनर्पण-क्रमे (G.स्यात्-अस्ति _) (G.स्यात्-अस्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति _) (G.स्यान्-नास्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति _) (G.स्यात्-अस्ति _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति _) (G.स्यान्-नास्ति _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अस्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यान्-नास्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अस्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अवक्तव्यम् _) (G.स्यान्-नास्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-क्रमे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अवक्तव्यम् _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यान्-नास्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यान्-नास्ति _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अस्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यान्-नास्ति _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-क्रमे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl

------------------------------------------------------------------------
-- � � ������� ��� ������� � a homomorphism for simultaneity too.
--
-- This is the half that was expected to fail, and it does not.  ������� on
-- records replaces the pair by ������-����������� (����� a n) � RETAINING both;
-- ���������� on labels replaces the profile (��� , ��� , _) by (� , � , ���) �
-- DESTROYING both.  Unasserting the naya carries the one to the other,
-- because the presence-profile of a retained pair and of a destroyed pair
-- are the same profile.  Exhaustive over 7 � 7.
------------------------------------------------------------------------

अनर्पण-सहे : {S : Type ℓ} {P : S → Type ℓ'} (x y : G.सप्तभङ्गी P)
           → अनर्पणम् (G.सहार्पणम् x y) ≡ LA.सह-योग (अनर्पणम् x) (अनर्पणम् y)
अनर्पण-सहे (G.स्यात्-अस्ति _) (G.स्यात्-अस्ति _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति _) (G.स्यान्-नास्ति _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति _) (G.स्यात्-अस्ति _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति _) (G.स्यान्-नास्ति _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अस्ति _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यान्-नास्ति _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति _ _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-सहे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अस्ति _) = refl
अनर्पण-सहे (G.स्यात्-अवक्तव्यम् _) (G.स्यान्-नास्ति _) = refl
अनर्पण-सहे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-सहे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-सहे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अवक्तव्यम् _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अवक्तव्यम् _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यान्-नास्ति _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यान्-नास्ति _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यान्-नास्ति-अवक्तव्यम् _ _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अस्ति _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यान्-नास्ति _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अस्ति-नास्ति _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अवक्तव्यम् _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अस्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यान्-नास्ति-अवक्तव्यम् _ _) = refl
अनर्पण-सहे (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् _ _ _) = refl

------------------------------------------------------------------------
-- � � ������� � the naya, asserted.
--
-- The other direction of 5.31.  A label carries no witness, so to read it
-- as a record one must SUPPLY the aspect: one affirming standpoint, one
-- denying standpoint � which is exactly `sydastinsti P`, Anekntavda's
-- own non-vacuity hypothesis (Anekanta §4).  Nothing is
-- invented: the pair is a hypothesis of the theorem, not a default.
------------------------------------------------------------------------

अर्पणम् : {S : Type ℓ} {P : S → Type ℓ'}
        → syādasti P → syādnāsti P → L.सप्तभङ्गी → G.सप्तभङ्गी P
अर्पणम् a n L.स्यात्-अस्ति                    = G.स्यात्-अस्ति a
अर्पणम् a n L.स्यात्-नास्ति                   = G.स्यान्-नास्ति n
अर्पणम् a n L.स्यात्-अस्ति-नास्ति            = G.स्यात्-अस्ति-नास्ति a n
अर्पणम् a n L.स्यात्-अवक्तव्यम्               = G.स्यात्-अवक्तव्यम् (G.शेषम् a n)
अर्पणम् a n L.स्यात्-अस्ति-अवक्तव्यम्        = G.स्यात्-अस्ति-अवक्तव्यम् a (G.शेषम् a n)
अर्पणम् a n L.स्यात्-नास्ति-अवक्तव्यम्       = G.स्यान्-नास्ति-अवक्तव्यम् n (G.शेषम् a n)
अर्पणम् a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् a n (G.शेषम् a n)

-- �������� ∘ ������� ≡ id : the label lane is a RETRACT.  Asserting an
-- aspect and then not asserting it returns the label untouched.
अनर्पण-अर्पणम् : {S : Type ℓ} {P : S → Type ℓ'}
                 (a : syādasti P) (n : syādnāsti P) (x : L.सप्तभङ्गी)
               → अनर्पणम् (अर्पणम् a n x) ≡ x
अनर्पण-अर्पणम् a n L.स्यात्-अस्ति                    = refl
अनर्पण-अर्पणम् a n L.स्यात्-नास्ति                   = refl
अनर्पण-अर्पणम् a n L.स्यात्-अस्ति-नास्ति            = refl
अनर्पण-अर्पणम् a n L.स्यात्-अवक्तव्यम्               = refl
अनर्पण-अर्पणम् a n L.स्यात्-अस्ति-अवक्तव्यम्        = refl
अनर्पण-अर्पणम् a n L.स्यात्-नास्ति-अवक्तव्यम्       = refl
अनर्पण-अर्पणम् a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl

-- and so �������� is onto: every label is some record's label.
अनर्पणम्-सर्वगम् : {S : Type ℓ} {P : S → Type ℓ'} → syādastināsti P
                 → (x : L.सप्तभङ्गी) → Σ[ b ∈ G.सप्तभङ्गी P ] (अनर्पणम् b ≡ x)
अनर्पणम्-सर्वगम् (a , n) x = अर्पणम् a n x , अनर्पण-अर्पणम् a n x

------------------------------------------------------------------------
-- � � ������ � ������� � the section is a homomorphism for both modes.
--
-- So the labels are not merely a quotient of the records: they SIT INSIDE
-- them, as a subalgebra closed under both ������������ and ���������, and the
-- retraction is algebraic in both directions it runs.  Exhaustive, 7 � 7
-- twice.
------------------------------------------------------------------------

अर्पण-क्रमे : {S : Type ℓ} {P : S → Type ℓ'}
              (a : syādasti P) (n : syādnāsti P) (x y : L.सप्तभङ्गी)
            → अर्पणम् a n (LA.क्रम-योग x y) ≡ G.क्रमार्पणम् (अर्पणम् a n x) (अर्पणम् a n y)
अर्पण-क्रमे a n L.स्यात्-अस्ति L.स्यात्-अस्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति L.स्यात्-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति L.स्यात्-अस्ति-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति L.स्यात्-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति L.स्यात्-अस्ति = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति L.स्यात्-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति L.स्यात्-अस्ति-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति L.स्यात्-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अस्ति = refl
अर्पण-क्रमे a n L.स्यात्-अवक्तव्यम् L.स्यात्-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अवक्तव्यम् L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अस्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-क्रमे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl

अर्पण-सहे : {S : Type ℓ} {P : S → Type ℓ'}
            (a : syādasti P) (n : syādnāsti P) (x y : L.सप्तभङ्गी)
          → अर्पणम् a n (LA.सह-योग x y) ≡ G.सहार्पणम् (अर्पणम् a n x) (अर्पणम् a n y)
अर्पण-सहे a n L.स्यात्-अस्ति L.स्यात्-अस्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति L.स्यात्-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति L.स्यात्-अस्ति-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति L.स्यात्-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-नास्ति L.स्यात्-अस्ति = refl
अर्पण-सहे a n L.स्यात्-नास्ति L.स्यात्-नास्ति = refl
अर्पण-सहे a n L.स्यात्-नास्ति L.स्यात्-अस्ति-नास्ति = refl
अर्पण-सहे a n L.स्यात्-नास्ति L.स्यात्-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-नास्ति L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-नास्ति L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-नास्ति L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अस्ति = refl
अर्पण-सहे a n L.स्यात्-अवक्तव्यम् L.स्यात्-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अवक्तव्यम् L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अस्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति = refl
अर्पण-सहे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-नास्ति = refl
अर्पण-सहे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति = refl
अर्पण-सहे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-नास्ति-अवक्तव्यम् = refl
अर्पण-सहे a n L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् L.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl

------------------------------------------------------------------------
-- � � � ������������ � and there is no way back.
--
-- �������� is onto and it is a homomorphism for both modes; it is still
-- not invertible, and the failure is not delicate.  Two standpoints that
-- both affirm give two records with one label, so ANY ψ : labels �
-- records satisfying ψ ∘ �������� ≡ id would identify them.
--
-- This is AHIMSA_SUTRA_VISTARA §� in this instance: ������� is not
-- �������, it is ������, and ����������� ������ � � ��������, ������ �  §�'s
-- first path (transport along an equivalence, nothing lost) is therefore
-- unavailable HERE AS A THEOREM and not as a report of failure to find
-- one.  What is owed is the second path, and §��§� are it.
------------------------------------------------------------------------

-- a standpoint every position provably carries (each constructor has at
-- least one �� in it, so this is total without a default and without a
-- choice)
साक्षि-स्थानम् : {S : Type ℓ} {P : S → Type ℓ'} → G.सप्तभङ्गी P → S
साक्षि-स्थानम् (G.स्यात्-अस्ति a)                        = fst a
साक्षि-स्थानम् (G.स्यान्-नास्ति n)                       = fst n
साक्षि-स्थानम् (G.स्यात्-अस्ति-नास्ति a _)              = fst a
साक्षि-स्थानम् (G.स्यात्-अवक्तव्यम् v)                   = fst (G.साधकः v)
साक्षि-स्थानम् (G.स्यात्-अस्ति-अवक्तव्यम् a _)          = fst a
साक्षि-स्थानम् (G.स्यान्-नास्ति-अवक्तव्यम् n _)         = fst n
साक्षि-स्थानम् (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् a _ _) = fst a

न-प्रत्यानयनम् : {S : Type ℓ} {P : S → Type ℓ'} (a a' : syādasti P)
              → ¬ (fst a ≡ fst a')
              → ¬ (Σ[ ψ ∈ (L.सप्तभङ्गी → G.सप्तभङ्गी P) ]
                     ((b : G.सप्तभङ्गी P) → ψ (अनर्पणम् b) ≡ b))
न-प्रत्यानयनम् a a' विवेकः (ψ , स) = विवेकः
  (cong साक्षि-स्थानम् (sym (स (G.स्यात्-अस्ति a)) ∙ स (G.स्यात्-अस्ति a')))

------------------------------------------------------------------------
-- � � ��������� � what the map does transport, and in which direction.
--
-- A homomorphism carries equations DOWN and distinctness UP.  So every
-- law the label lane FAILS is a law the record lane fails, and the
-- record lane's extra structure cannot repair it.  That is the useful
-- half of a lossy map, and it is why writing the defect is not a
-- consolation prize.
------------------------------------------------------------------------

उन्नयनम् : {S : Type ℓ} {P : S → Type ℓ'} (x y : G.सप्तभङ्गी P)
         → ¬ (अनर्पणम् x ≡ अनर्पणम् y) → ¬ (x ≡ y)
उन्नयनम् x y ने e = ने (cong अनर्पणम् e)

------------------------------------------------------------------------
-- � � ��-���������� ��������� � the broken law breaks upstairs too.
--
-- `SaptabhangiSamyoga.��-����������` proves ��-����� is not associative on
-- labels, and attributes it to ���������� destroying the two seeds.  The
-- record lane keeps the seeds, and withdrew that attribution.  The
-- withdrawal was right about the seeds and it does not save the law:
-- ��������� is not associative on records either, with both nayas and both
-- witnesses retained throughout.  The reason is not destruction.  It is
-- that ��������� tests the JOINED position for an asti-nsti pair, and
-- whether that pair is present depends on the grouping.
--
-- Given only that some standpoint affirms and some standpoint denies �
-- Anekntavda's own hypothesis � with no assumption about S, P, or
-- decidability.
------------------------------------------------------------------------

private
  -- the label-side counterexample, restated here because
  -- SaptabhangiSamyoga keeps its two sides private
  वामतः-दक्षिणतः : ¬ ( LA.सह-योग (LA.सह-योग L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति)
                                 L.स्यात्-नास्ति
                     ≡ LA.सह-योग L.स्यात्-अस्ति-नास्ति
                                 (LA.सह-योग L.स्यात्-अस्ति L.स्यात्-नास्ति) )
  वामतः-दक्षिणतः e = LA.आम्≢न (cong LA.नास्त्यंशः e)

सह-असङ्गतिः-ऊर्ध्वम् : {S : Type ℓ} {P : S → Type ℓ'}
                        (a : syādasti P) (n : syādnāsti P)
  → ¬ ( G.सहार्पणम् (G.सहार्पणम् (G.स्यात्-अस्ति-नास्ति a n) (G.स्यात्-अस्ति a))
                     (G.स्यान्-नास्ति n)
      ≡ G.सहार्पणम् (G.स्यात्-अस्ति-नास्ति a n)
                     (G.सहार्पणम् (G.स्यात्-अस्ति a) (G.स्यान्-नास्ति n)) )
सह-असङ्गतिः-ऊर्ध्वम् {P = P} a n =
  उन्नयनम् _ _ (λ e → वामतः-दक्षिणतः (वामम् ∙ e ∙ sym दक्षिणम्))
  where
    X Y Z : G.सप्तभङ्गी P
    X = G.स्यात्-अस्ति-नास्ति a n
    Y = G.स्यात्-अस्ति a
    Z = G.स्यान्-नास्ति n

    वामम् : LA.सह-योग (LA.सह-योग L.स्यात्-अस्ति-नास्ति L.स्यात्-अस्ति) L.स्यात्-नास्ति
          ≡ अनर्पणम् (G.सहार्पणम् (G.सहार्पणम् X Y) Z)
    वामम् = cong (λ t → LA.सह-योग t L.स्यात्-नास्ति) (sym (अनर्पण-सहे X Y))
          ∙ sym (अनर्पण-सहे (G.सहार्पणम् X Y) Z)

    दक्षिणम् : LA.सह-योग L.स्यात्-अस्ति-नास्ति (LA.सह-योग L.स्यात्-अस्ति L.स्यात्-नास्ति)
             ≡ अनर्पणम् (G.सहार्पणम् X (G.सहार्पणम् Y Z))
    दक्षिणम् = cong (LA.सह-योग L.स्यात्-अस्ति-नास्ति) (sym (अनर्पण-सहे Y Z))
             ∙ sym (अनर्पण-सहे X (G.सहार्पणम् Y Z))

------------------------------------------------------------------------
-- � � �����-������� � ��������� � and the transport does not run back.
--
-- �����-����� commutes on labels (`LA.�����-�������`).  ������������ does not
-- commute on records, and the two records that separate them have the
-- SAME label.  So Eq(records) ⊊ Eq(labels) strictly, with this in the
-- gap: an identity that holds below and fails above.
--
-- Together with §�: identities descend and do not lift; distinctness
-- lifts and does not descend.  That is the exact shape of the defect,
-- and it is the answer to "is the forgetful map a homomorphism for order,
-- for saha, or for neither" � it is one for both, and being one for both
-- is precisely what makes the two lanes inequivalent in a stateable way
-- rather than merely different.
------------------------------------------------------------------------

क्रम-विनिमयः-न-ऊर्ध्वम् : {S : Type ℓ} {P : S → Type ℓ'} (a a' : syādasti P)
                          → ¬ (fst a ≡ fst a')
                          → ¬ ( G.क्रमार्पणम् (G.स्यात्-अस्ति a) (G.स्यात्-अस्ति a')
                              ≡ G.क्रमार्पणम् (G.स्यात्-अस्ति a') (G.स्यात्-अस्ति a) )
क्रम-विनिमयः-न-ऊर्ध्वम् a a' विवेकः e = विवेकः (cong साक्षि-स्थानम् e)

-- ...while below, the same two compose to the same thing, on the nose.
क्रम-विनिमयः-अधः : {S : Type ℓ} {P : S → Type ℓ'} (a a' : syādasti P)
  → अनर्पणम् (G.क्रमार्पणम् (G.स्यात्-अस्ति a) (G.स्यात्-अस्ति a'))
  ≡ अनर्पणम् (G.क्रमार्पणम् (G.स्यात्-अस्ति a') (G.स्यात्-अस्ति a))
क्रम-विनिमयः-अधः a a' = refl

------------------------------------------------------------------------
-- �� � ��������� � the hypotheses are inhabited, so none of this is vacuous.
--
-- §� and §� need TWO standpoints that affirm and one that denies.
-- `Anekanta.Two` will not do � over Bool with P b = (b ≡
-- true) the affirming standpoint is unique � so a three-standpoint family
-- is given.  This is the same non-vacuity obligation Aneknta §4 accepts
-- for itself, discharged for the sharper claim.
------------------------------------------------------------------------

private
  data त्रि : Type₀ where
    प्रथमः द्वितीयः तृतीयः : त्रि

  -- affirmed at the first and the second standpoint, denied at the third
  प्रश्नः : त्रि → Type₀
  प्रश्नः प्रथमः  = Unit
  प्रश्नः द्वितीयः = Unit
  प्रश्नः तृतीयः  = ⊥

  भेदः : त्रि → Type₀
  भेदः प्रथमः  = Unit
  भेदः द्वितीयः = ⊥
  भेदः तृतीयः  = ⊥

  प्रथमः≢द्वितीयः : ¬ (प्रथमः ≡ द्वितीयः)
  प्रथमः≢द्वितीयः e = subst भेदः e tt

  अ₁ अ₂ : syādasti प्रश्नः
  अ₁ = प्रथमः , tt
  अ₂ = द्वितीयः , tt

  न₁ : syādnāsti प्रश्नः
  न₁ = तृतीयः , λ z → z

-- two affirming standpoints, one label: nothing recovers them.
प्रत्यानयनं-नास्ति-अत्र
  : ¬ (Σ[ ψ ∈ (L.सप्तभङ्गी → G.सप्तभङ्गी प्रश्नः) ]
         ((b : G.सप्तभङ्गी प्रश्नः) → ψ (अनर्पणम् b) ≡ b))
प्रत्यानयनं-नास्ति-अत्र = न-प्रत्यानयनम् अ₁ अ₂ प्रथमः≢द्वितीयः

-- succession does not commute upstairs, here, concretely.
क्रमः-अविनिमयी-अत्र
  : ¬ ( G.क्रमार्पणम् (G.स्यात्-अस्ति अ₁) (G.स्यात्-अस्ति अ₂)
      ≡ G.क्रमार्पणम् (G.स्यात्-अस्ति अ₂) (G.स्यात्-अस्ति अ₁) )
क्रमः-अविनिमयी-अत्र = क्रम-विनिमयः-न-ऊर्ध्वम् अ₁ अ₂ प्रथमः≢द्वितीयः

-- simultaneity does not associate upstairs, here, concretely.
सहः-असङ्गतः-अत्र
  : ¬ ( G.सहार्पणम् (G.सहार्पणम् (G.स्यात्-अस्ति-नास्ति अ₁ न₁) (G.स्यात्-अस्ति अ₁))
                     (G.स्यान्-नास्ति न₁)
      ≡ G.सहार्पणम् (G.स्यात्-अस्ति-नास्ति अ₁ न₁)
                     (G.सहार्पणम् (G.स्यात्-अस्ति अ₁) (G.स्यान्-नास्ति न₁)) )
सहः-असङ्गतः-अत्र = सह-असङ्गतिः-ऊर्ध्वम् अ₁ न₁

------------------------------------------------------------------------
-- �� � ��� ���������� � what this does NOT settle.
--
-- The two lanes were said to be separated by a reading of Malliea
-- (Sydvdamajar, 1292): is ����������� the failure of one utterance to
-- carry a joint content (�������� demanded of a ���������-shaped medium), or
-- the consumption of what was to be uttered?  That question is still
-- open, and this file must not be read as answering it.
--
-- What it removes is a different claim � that the question is what makes
-- the two algebras incomparable.  It is not.  The two operations agree
-- across the difference (§�, §�): whether the fourth position retains its
-- pair or destroys it, the presence-profile is the same, so composition
-- commutes with unasserting the naya either way.  The reading of
-- Malliea changes what a position IS.  It does not change how positions
-- compose, and any argument for one reading that runs through the
-- composition laws is now known to prove nothing.
--
-- Nor does it license either lane to absorb the other.  §� says there is
-- no equivalence, so §� of AHIMSA_SUTRA_VISTARA applies literally:
-- ������ ������������ � ������� � where the standpoints genuinely differ the
-- collapse DOES NOT EXIST, and the object equivalent to both, which a
-- reconciliation would have to be, is the thing proved absent.  What
-- exists is a retraction, and a retraction has a direction: the record
-- lane can always speak the label lane's sentences, and the label lane
-- can never recover the record lane's.  Asserting either as the whole is
-- Sanmatitarka 1.21's ������, and in the label lane's case it is now a
-- refutable one.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- �� � ��� ������� � ����� � three more carvings in the same tree, read
--       2026-08-20, NOT reconciled here, and named so the next reader
--       does not think this file covered them.
--
-- The two lanes above are not the only saptabhag in `machine/`.  Two
-- further shapes are live, and they are not the record/label difference
-- this file settled:
--
--   `machine/Obstruction.hs`  � a SECOND label type, `Bhanga` = B1�B7,
--     with `Sthana = Position Bhanga | ADharmin`.  Seven positions and an
--     eighth, exactly as `machine/Saptabhangi_TheSevenfoldVerdict.hs`, and
--     a DIFFERENT TYPE with a differently-named eighth (`ADharmin`, no
--     subject to predicate of, against `Apratipatti`, nothing predicated).
--     `machine/NayaKosha_TheStandpointStore.hs` imports Obstruction's and
--     therefore agrees with it, so the split is two-against-one.  The two
--     lanes already disagree, in writing, at the INTERPRETATION function
--     and not at the algebra: `Obstruction.sthana` sets nsti on every
--     refusal by construction, and `Saptabhangi_TheSevenfoldVerdict.
--     vacanaOfRejection` refuses to, on the ground that an unparseable
--     refusal is not formable as a predication.  Nothing here bears on
--     that: this file compares COMPOSITION laws, and those two differ
--     over what a given refusal IS.  A homomorphism argument cannot
--     settle it, for the same reason §�� gives about Malliea.
--
--   `machine/Naya.hs` � a fifth carving, `Verdict` = Ekartha | Durnaya |
--     OrderBhanga | Avaktavya | Abhinna.  It is NOT the seven: it drops
--     positions five, six and seven, and adds two that are not bhagas at
--     all (Ekartha, "collapse permitted, you said one thing twice", and
--     Abhinna, "the looking was unfit").  It is also mixed in the record/
--     label sense settled above � its INPUT standpoints carry their
--     witness sets, and its `OrderBhanga` and `Avaktavya` carry only the
--     standpoint NAMES.  So it unasserts the naya at exactly the point of
--     composition, which is the map of §�, applied halfway.
--
-- Whether the two label types are the same object is a question with a
-- likely-cheap answer (both are the seven, so a bijection is immediate)
-- and it is NOT the interesting one; the disagreement between them is at
-- `sthana`, not at `order`/`saha`, and settling the algebra would settle
-- nothing there.  Whether `Naya.hs`'s five-way carving is a quotient, a
-- subalgebra, or neither is open and is not claimed here in any
-- direction.
--
-- Written rather than reconciled, per §�: a defect that is recorded lives
-- (�������� ������ �����), and one that is not is the �����.
------------------------------------------------------------------------
