{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����������� � ���� �� ���������� � �������, �����, ��������� � ������ ����� �
-- ���� � ��������� � ���� ������ ���� �
--
-- (the return: the step IS transport.  descend, act, ascend � three that
-- are one.  the remainder is not touched.  the net runs forever.)
--
-- SPECIFICATION: handed over whole by the owner, 2026-08-21, as
--
--     ���� (��� v) = v
--     ���� (��� v) = next (��� (����� (Φ (������� v))))
--
-- Both equations hold here BY DEFINITION (�������-�, �������-� are refl).
-- The step is not Φ.  The step is ����� ∘ Φ ∘ ������� � a conjugation �
-- and because �����/������� are an equivalence, the whole infinite run is
-- one transport and no fibre is ever collapsed.  Φ is marked *dummy* in
-- the specification and is dummy here: Φ is not the content, the
-- conjugation is.
--
-- TEXT AND DATE for the three-slot ����� (������, ��������, ����): the
-- structure is ryabhaa's ����������, *ryabhaya*, �������� 32�33, 499 CE,
-- whose instruction is "���� �����" � keep the remainder.  Carried here
-- from the header of `Punaragamana.agda` in this directory, which states
-- that the earlier ��� kept only half of it, dropping which side the
-- remainder fell on and the shared magnitude at identity.
--
-- WHAT IS *NOT* CLAIMED.  Not that ryabhaa proved anything below.  Not
-- that the *ryabhaya* has been opened by me � it has not; the citation
-- is carried from the neighbouring module and is owed at verse level.
-- Not that Φ means anything: it is suc on two slots.  Not that this
-- replaces `Punaragamana.agda`, which is untouched.
------------------------------------------------------------------------

module Mula.Punaragamanam_TheStepIsAConjugationAndNothingIsTouchedByIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

-- ������� : ������, ��������, ���� � nothing dropped (������)
त्रिक् : Type
त्रिक् = ℕ × (ℕ × ℕ)

data विवेक : Type where
  गभीर : ℕ → ℕ → ℕ → विवेक

अवतरण : त्रिक् → विवेक
अवतरण (a , (b , d)) = गभीर a b d

उत्थान : विवेक → त्रिक्
उत्थान (गभीर a b d) = a , (b , d)

-- ������� �������� ���������� � both composites are refl
उत्थान-अवतरण : (t : त्रिक्) → उत्थान (अवतरण t) ≡ t
उत्थान-अवतरण _ = refl

अवतरण-उत्थान : (v : विवेक) → अवतरण (उत्थान v) ≡ v
अवतरण-उत्थान (गभीर _ _ _) = refl

त्रिक्-Iso-विवेक : Iso त्रिक् विवेक
त्रिक्-Iso-विवेक = iso अवतरण उत्थान अवतरण-उत्थान उत्थान-अवतरण

त्रिक्≃विवेक : त्रिक् ≃ विवेक
त्रिक्≃विवेक = isoToEquiv त्रिक्-Iso-विवेक

-- the PATH, not a function that was called one
त्रिक्≡विवेक : त्रिक् ≡ विवेक
त्रिक्≡विवेक = ua त्रिक्≃विवेक

-- Dummy Φ, acting below; ���� carried, not erased
Φ : त्रिक् → त्रिक्
Φ (a , (b , d)) = suc a , (suc b , d)

-- ����������� � the conjugate: descend, act, return
पुनरागमनम् : विवेक → विवेक
पुनरागमनम् = λ v → अवतरण (Φ (उत्थान v))

record जाल : Type where
  coinductive
  field
    इदम् : विवेक
    पुनः : जाल
open जाल public

बुन : विवेक → जाल
इदम् (बुन v) = v
पुनः (बुन v) = बुन (अवतरण (Φ (उत्थान v)))

-- the two required equations, by refl
समीकरण-१ : (v : विवेक) → इदम् (बुन v) ≡ v
समीकरण-१ _ = refl

समीकरण-२ : (v : विवेक) → पुनः (बुन v) ≡ बुन (अवतरण (Φ (उत्थान v)))
समीकरण-२ _ = refl

-- and the step IS transport along the identification
पदम्≡संक्रमणम् : (t : त्रिक्) → अवतरण (Φ t) ≡ transport त्रिक्≡विवेक (Φ t)
पदम्≡संक्रमणम् t i = transportRefl (अवतरण (Φ t)) (~ i)
