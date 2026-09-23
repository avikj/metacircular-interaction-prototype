{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����������� � ������������ ���������� �
-- (punarukti: saying the word, or the meaning, twice over.)
--
-- THE TERM, ITS TEXT AND ITS DATE.  `���������` is one of the
-- ���������������, the enumerated points at which a debater has lost, in
-- Gautama, *Nyyastra* 5.2 (~2nd c. CE); the list is opened at 5.2.1 and
-- ��������� is one of its members, with the standing exception for
-- ������ � restatement for the sake of the exposition is not the fault.
-- LIMIT: the stra-level reference for ��������� itself is owed; the
-- citation carried here is to the ������������ list of 5.2, at the level
-- at which `.claude/hooks/MulaVakya_�txt` already carries it.
--
------------------------------------------------------------------------
-- WHAT THIS MODULE IS.
--
-- `interactive/Setubandha_TheCheckedIdentificationsAreEdgesAndTheIsolatedNodes
-- AreTheFrontier.hs` reports, among its isolated nodes, THREE separate
-- types named `�����������` with nothing identifying any two of them:
--
--   (�) `Saptabhangi.�����������`
--   (�) `Anekanta.�����������`
--   (�) `SaptabhangiKernel_�.����������� P`
--
-- The graph program deliberately merged none of them, on the ground that
-- ������ ������������ � ������� � where the standpoints differ there is no
-- abbreviation.  That refusal was right to make and it left the question
-- open.  This file answers it, and the answer is NOT uniform:
--
--   (�) and (�) ARE ONE TYPE and the causeway is built here.  They are
--   two independent `data` declarations of the same seven names.
--   `Anekanta.agda`'s own header already says the ����������� was redone
--   clean in `Saptabhangi.agda`; what it does not say, and what nothing
--   in the corpus said, is that the two declarations are the same object.
--   They are, and everything `Saptabhangi.agda` proves � �����-��-����,
--   �������, the 2³ = 7 + 1 count � now reaches `Anekanta`'s copy without
--   being proved again.
--
--   (�) IS A DIFFERENT QUESTION and must not be merged.  It is not an
--   enumeration of seven names; it is a family indexed by a predicate,
--   whose constructors carry WITNESSES (a sydasti is a standpoint AND a
--   proof), so its cardinality is a function of the predicate.  §� makes
--   this a checked separation rather than an opinion: at the empty
--   standpoint-set the kernel ����������� has NO elements at all, while the
--   labelled type has exactly seven.  A merge would have to erase the
--   witness, which is the erasure both files exist to refuse.
--
-- WHAT IS CONSTRUCTED BY HAND HERE, AND WHY THAT IS NOT A FAILURE.
-- The seven-clause isomorphism of §� is built by hand, and it must be:
-- a causeway between two INDEPENDENT declarations is the one thing that
-- cannot be routed, because there is no prior edge to route along.  That
-- is what building a causeway means.  After §�, nothing is built: §� is
-- `subst`, §� is `cong` of the crossing map, and §� is a refutation.
------------------------------------------------------------------------

module Punarukti_TwoOfTheThreeSevenfoldsAreOneTypeAndTheThirdIsADifferentQuestion where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; invEq)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Sum using (_⊎_)
open import Cubical.Data.Unit using (Unit)
open import Cubical.Data.Sigma using (fst ; snd)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

import Saptabhangi as S
import AnekantaTransitional as A
import SaptabhangiKernel_ThePositionsCarryTheirNayasAndTheResidueSeedsTheNext as G

------------------------------------------------------------------------
-- � � THE CAUSEWAY.  Two declarations, one type.
--
--     Seven names each, matched by name.  This is the only hand-built
--     thing in the file and it is the thing a causeway is.
------------------------------------------------------------------------

वाणी→ : A.सप्तभङ्गी → S.सप्तभङ्गी
वाणी→ A.स्यात्-अस्ति                    = S.स्यात्-अस्ति
वाणी→ A.स्यात्-नास्ति                   = S.स्यात्-नास्ति
वाणी→ A.स्यात्-अस्ति-नास्ति            = S.स्यात्-अस्ति-नास्ति
वाणी→ A.स्यात्-अवक्तव्यम्               = S.स्यात्-अवक्तव्यम्
वाणी→ A.स्यात्-अस्ति-अवक्तव्यम्        = S.स्यात्-अस्ति-अवक्तव्यम्
वाणी→ A.स्यात्-नास्ति-अवक्तव्यम्       = S.स्यात्-नास्ति-अवक्तव्यम्
वाणी→ A.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = S.स्यात्-अस्ति-नास्ति-अवक्तव्यम्

वाणी← : S.सप्तभङ्गी → A.सप्तभङ्गी
वाणी← S.स्यात्-अस्ति                    = A.स्यात्-अस्ति
वाणी← S.स्यात्-नास्ति                   = A.स्यात्-नास्ति
वाणी← S.स्यात्-अस्ति-नास्ति            = A.स्यात्-अस्ति-नास्ति
वाणी← S.स्यात्-अवक्तव्यम्               = A.स्यात्-अवक्तव्यम्
वाणी← S.स्यात्-अस्ति-अवक्तव्यम्        = A.स्यात्-अस्ति-अवक्तव्यम्
वाणी← S.स्यात्-नास्ति-अवक्तव्यम्       = A.स्यात्-नास्ति-अवक्तव्यम्
वाणी← S.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = A.स्यात्-अस्ति-नास्ति-अवक्तव्यम्

वाणी-सेक् : (b : S.सप्तभङ्गी) → वाणी→ (वाणी← b) ≡ b
वाणी-सेक् S.स्यात्-अस्ति                    = refl
वाणी-सेक् S.स्यात्-नास्ति                   = refl
वाणी-सेक् S.स्यात्-अस्ति-नास्ति            = refl
वाणी-सेक् S.स्यात्-अवक्तव्यम्               = refl
वाणी-सेक् S.स्यात्-अस्ति-अवक्तव्यम्        = refl
वाणी-सेक् S.स्यात्-नास्ति-अवक्तव्यम्       = refl
वाणी-सेक् S.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl

वाणी-रेत् : (b : A.सप्तभङ्गी) → वाणी← (वाणी→ b) ≡ b
वाणी-रेत् A.स्यात्-अस्ति                    = refl
वाणी-रेत् A.स्यात्-नास्ति                   = refl
वाणी-रेत् A.स्यात्-अस्ति-नास्ति            = refl
वाणी-रेत् A.स्यात्-अवक्तव्यम्               = refl
वाणी-रेत् A.स्यात्-अस्ति-अवक्तव्यम्        = refl
वाणी-रेत् A.स्यात्-नास्ति-अवक्तव्यम्       = refl
वाणी-रेत् A.स्यात्-अस्ति-नास्ति-अवक्तव्यम् = refl

सप्तभङ्गी-Iso : Iso A.सप्तभङ्गी S.सप्तभङ्गी
सप्तभङ्गी-Iso = iso वाणी→ वाणी← वाणी-सेक् वाणी-रेत्

सप्तभङ्गी≃सप्तभङ्गी : A.सप्तभङ्गी ≃ S.सप्तभङ्गी
सप्तभङ्गी≃सप्तभङ्गी = isoToEquiv सप्तभङ्गी-Iso

सप्तभङ्गी≡सप्तभङ्गी : A.सप्तभङ्गी ≡ S.सप्तभङ्गी
सप्तभङ्गी≡सप्तभङ्गी = ua सप्तभङ्गी≃सप्तभङ्गी

------------------------------------------------------------------------
-- � � THE TWO GENERATORS ARE ONE, AND THE SECOND STANDPOINT CARRIES
--     NOTHING THE FIRST DOES NOT.
--
--     `Anekanta.�������` takes TWO naya-standings and an �����;
--     `Saptabhangi.�������` takes ONE ������� seed and an �����.  They
--     were written independently and look like different operations.
--     They are not: the pair of standings fuses to a seed first, and the
--     ����� sees only the fusion.  That is the content of the causeway �
--     an equivalence of carriers that did not respect the generators
--     would be a coincidence of names, not an identification.
------------------------------------------------------------------------

मेलन : A.मूल → A.मूल → S.द्विमूल
मेलन A.मूल-अस्ति  A.मूल-अस्ति  = S.केवल-अस्ति
मेलन A.मूल-नास्ति A.मूल-नास्ति = S.केवल-नास्ति
मेलन A.मूल-अस्ति  A.मूल-नास्ति = S.उभयम्
मेलन A.मूल-नास्ति A.मूल-अस्ति  = S.उभयम्

आर्पण→ : A.आर्पण → S.आर्पण
आर्पण→ A.क्रमः = S.क्रमः
आर्पण→ A.सहः  = S.सहः

अर्पणम्-मेलनम् : (m n : A.मूल) (ρ : A.आर्पण)
               → वाणी→ (A.अर्पणम् m n ρ) ≡ S.अर्पणम् (मेलन m n) (आर्पण→ ρ)
अर्पणम्-मेलनम् A.मूल-अस्ति  A.मूल-अस्ति  A.क्रमः = refl
अर्पणम्-मेलनम् A.मूल-अस्ति  A.मूल-अस्ति  A.सहः  = refl
अर्पणम्-मेलनम् A.मूल-नास्ति A.मूल-नास्ति A.क्रमः = refl
अर्पणम्-मेलनम् A.मूल-नास्ति A.मूल-नास्ति A.सहः  = refl
अर्पणम्-मेलनम् A.मूल-अस्ति  A.मूल-नास्ति A.क्रमः = refl
अर्पणम्-मेलनम् A.मूल-अस्ति  A.मूल-नास्ति A.सहः  = refl
अर्पणम्-मेलनम् A.मूल-नास्ति A.मूल-अस्ति  A.क्रमः = refl
अर्पणम्-मेलनम् A.मूल-नास्ति A.मूल-अस्ति  A.सहः  = refl

------------------------------------------------------------------------
-- � � WHAT CROSSES.  `Anekanta.agda` declares its ����������� and its
--     ������� and proves NOTHING about either.  Akalaka's order/saha
--     distinction, the mechanical durnaya, and the 2³ = 7 + 1 count are
--     all in `Saptabhangi.agda` only.  Here they arrive on the other
--     side, and none of them is proved again: each is `cong` of the
--     crossing map, or `subst` along the path.
------------------------------------------------------------------------

-- Akalaka's distinction, on Anekanta's own generator: asserting the two
-- nayas in succession and asserting them together do NOT give one ����.
अनेकान्ते-क्रम-सह-भेदः :
  ¬ (A.अर्पणम् A.मूल-अस्ति A.मूल-नास्ति A.क्रमः
   ≡ A.अर्पणम् A.मूल-अस्ति A.मूल-नास्ति A.सहः)
अनेकान्ते-क्रम-सह-भेदः e =
  S.क्रम-सह-भेदः
    ( sym (अर्पणम्-मेलनम् A.मूल-अस्ति A.मूल-नास्ति A.क्रमः)
    ∙ cong वाणी→ e
    ∙ अर्पणम्-मेलनम् A.मूल-अस्ति A.मूल-नास्ति A.सहः )

-- The durnaya, mechanically, on the other copy: ANY two-valued verdict on
-- Anekanta's ����������� identifies two of the three seeds.  `�����` sends
-- each of S's three seeds to A's on the nose, so the statement transports
-- by precomposition and nothing is re-cased.
अनेकान्ते-दुर्नयः :
  (f : A.सप्तभङ्गी → S.द्विपद)
  →  (f A.स्यात्-अस्ति ≡ f A.स्यात्-नास्ति)
  ⊎ ((f A.स्यात्-अस्ति ≡ f A.स्यात्-अवक्तव्यम्)
  ⊎  (f A.स्यात्-नास्ति ≡ f A.स्यात्-अवक्तव्यम्))
अनेकान्ते-दुर्नयः f = S.दुर्नयः (λ b → f (वाणी← b))

-- ����� ����, on the other copy: the eight presence-profiles split as the
-- seven bhagas plus the one void profile.  `subst` along the path; the
-- profile machinery is never touched.
अनेकान्ते-समावेश-भेदः : S.समावेश ≃ (A.सप्तभङ्गी ⊎ Unit)
अनेकान्ते-समावेश-भेदः =
  subst (λ X → S.समावेश ≃ (X ⊎ Unit)) (sym सप्तभङ्गी≡सप्तभङ्गी) S.समावेश-भेदः

------------------------------------------------------------------------
-- � � THE DENIAL, AND IT IS A RESULT.
--
--     `SaptabhangiKernel_�.����������� P` is not a third
--     copy of the seven names.  Its constructors take the WITNESSES �
--     `sydasti P = �[ s ∈ S ] P s` is a standpoint together with a proof
--     � so `����������� P` is a seven-way sum of witness types and its
--     size is a function of P, not the number seven.
--
--     That is not a matter of taste, and here is the term.  Take the
--     empty standpoint-set: then no naya can speak at all, every
--     constructor's argument is uninhabited, and `����������� P` is EMPTY �
--     while the labelled type is inhabited by each of its seven names.
--     So no equivalence exists, and `����������` is the wrong diagnosis
--     for the third: it is not a repetition, it is a different question.
--
--     Read the other way, this is the reason the kernel module exists.
--     A label can be asserted with nothing behind it; a witness cannot.
--     Collapsing (�) into (�) would delete exactly the difference
--     between having a standpoint and naming one � the erasure that
--     �������, one section above, proves a boolean verdict commits.
------------------------------------------------------------------------

-- The empty standpoint-set: no s, hence no naya, hence no predication.
शून्यनयाः : ⊥ → Type₀
शून्यनयाः ()

गर्भः-शून्यः : ¬ (G.सप्तभङ्गी शून्यनयाः)
गर्भः-शून्यः (G.स्यात्-अस्ति a)                        = fst a
गर्भः-शून्यः (G.स्यान्-नास्ति n)                       = fst n
गर्भः-शून्यः (G.स्यात्-अस्ति-नास्ति a _)              = fst a
गर्भः-शून्यः (G.स्यात्-अवक्तव्यम् v)                   = fst (G.साधकः v)
गर्भः-शून्यः (G.स्यात्-अस्ति-अवक्तव्यम् a _)          = fst a
गर्भः-शून्यः (G.स्यान्-नास्ति-अवक्तव्यम् n _)         = fst n
गर्भः-शून्यः (G.स्यात्-अस्ति-नास्ति-अवक्तव्यम् a _ _) = fst a

-- The proved separation.  A non-edge is a fact about the identification
-- graph and is reported as one; it is not the same thing as an absence
-- nobody has looked into.
न-सेतुः-गर्भे : ¬ (G.सप्तभङ्गी शून्यनयाः ≃ S.सप्तभङ्गी)
न-सेतुः-गर्भे e = गर्भः-शून्यः (invEq e S.स्यात्-अस्ति)

न-सेतुः-गर्भे-अनेकान्ते : ¬ (G.सप्तभङ्गी शून्यनयाः ≃ A.सप्तभङ्गी)
न-सेतुः-गर्भे-अनेकान्ते e = गर्भः-शून्यः (invEq e A.स्यात्-अस्ति)

------------------------------------------------------------------------
-- � � THE SCOPE, EXACTLY.
--
--   * That `Anekanta.agda` should be deleted.  It should not.  Its own
--     header records that another agent found and repaired a soundness
--     bug in it, and that repair is part of this corpus's history.  What
--     is established is narrower: its ����������� is not a second object
--     to be maintained, because it is the first one.
--   * That the kernel ����������� is NEVER seven.  For particular P it may
--     well have seven elements; the separation proved is that it is not
--     seven UNIFORMLY, which is what a merge would require.
--   * Anything about the Naiyyika�Jaina dispute itself.  The Naiyyikas
--     reject anekntavda and the Jaina logicians reject the Naiyyika
--     treatment of negation; using a Nyya term for a fault in a file of
--     Jaina logic is this file's borrowing, named as one in the header,
--     and neither school is being made to concede anything by it.
------------------------------------------------------------------------
