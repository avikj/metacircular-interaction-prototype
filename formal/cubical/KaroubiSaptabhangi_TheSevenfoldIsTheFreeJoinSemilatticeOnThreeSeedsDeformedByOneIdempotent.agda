{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- �������-����������� � ����������� ������� ���������� ������-����������� ; ��� ������
-- ����� ���������-������������� �������� �
--
-- (the sevenfold under order is the free join-semilattice on three seeds;
--  saha is that semilattice deformed by ONE idempotent retraction.)
--
-- ON THE NAME.  ������� is Karoubi's, transliterated, and named because the
-- structure below is the splitting of an idempotent and it would be
-- dishonest to give that a  label it does not have.  Everything
-- else here is `Saptabhangi`'s and `SaptabhangiSamyoga`'s vocabulary.
-- Per CLAUDE.md's file-naming rule, note 2: where the mathematics
-- originates elsewhere, say so rather than inventing a term.
--
------------------------------------------------------------------------
-- WHAT IS SEEN.
--
-- `SaptabhangiSamyoga` proves order associative/commutative/idempotent and
-- ��� non-associative, by a counterexample.  `Avaktavyakernel_�` prices the
-- collapse as a fibre.  What neither says is what ��� IS, and it has a
-- one-line answer:
--
--     ���  =  r ∘ order,   r = ����������,   r idempotent  (§1)
--
-- so ��� is not a second primitive operation.  It is order read through a
-- RETRACTION, and every difference between the two modes is a property of
-- r.  Three of them, each a term:
--
--   §1  r is idempotent � hence a retraction, hence ��� factors.
--   §2  r is NOT a join-homomorphism, exhibited at (����� , ������).  That
--       single failure IS the non-associativity: conjugating an associative
--       operation by a non-homomorphic idempotent is exactly how a
--       non-associative operation arises, and `Avaktavyakernel_�.�����������-�����`
--       is the converse half (identity � associative).
--   §3  �'s kernel, universally.  `SaptabhangiSamyoga` records `������` as
--       ONE refl � that the seventh bhaga arises by order.  §3 gives the
--       universally quantified statement it was an instance of:
--
--           ��-�-������ : (x y : �����������) � ���������� (��-����� x y) ≡ ���
--                                          � ��������� (��-����� x y) ≡ �
--
--       ��� can never carry both seeds.  §4 then names the consequence: for
--       ALL x y, `��-����� x y` is neither the third nor the seventh bhaga.
--       Those two are KRAMA-ONLY, structurally � and they are precisely r's
--       kernel, and precisely the two non-fixed points of the fibre computed
--       in `Avaktavyakernel_�§1.4`.  Three descriptions, one pair.
--
-- THE READING, and it is the reason the file exists.  Under order the seven
-- are the non-empty selections from three seeds � the free join-semilattice
-- on three generators, which is what `Saptabhangi.�����-����` counts.  So
-- SEVEN IS A UNIVERSAL PROPERTY, not a tally.  And the sevenfold splits
-- 5 + 2: five positions both modes reach, two only succession does, the two
-- being the collapse fibre of the tongue-break.  Akalaka's distinction
-- between order and saha (Laghyastraya, c. 720�780) is, in this algebra,
-- exactly the statement that r has non-trivial kernel � and the size of that
-- kernel is why the count is seven rather than five.
--
-- CHECKED: Agda 2.6.3, agda/cubical v0.5, this lane's own .agda-lib,
-- --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module KaroubiSaptabhangi_TheSevenfoldIsTheFreeJoinSemilatticeOnThreeSeedsDeformedByOneIdempotent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

open import Saptabhangi
open import SaptabhangiSamyoga_TheCompositionOfVerdicts

------------------------------------------------------------------------
-- � � ����������� � the tongue-break is IDEMPOTENT, so ��� = r ∘ order with
--     r a retraction.  ��� is not a second primitive.
------------------------------------------------------------------------

जिह्वा-पुनरुक्तिः : (t : समावेश) → जिह्वाभेदः (जिह्वाभेदः t) ≡ जिह्वाभेदः t
जिह्वा-पुनरुक्तिः (आम् , आम् , _) = refl
जिह्वा-पुनरुक्तिः (आम् , न   , _) = refl
जिह्वा-पुनरुक्तिः (न   , आम् , _) = refl
जिह्वा-पुनरुक्तिः (न   , न   , _) = refl

------------------------------------------------------------------------
-- � � �-������������ � r is not a join-homomorphism.  THE ROOT of §7's
--     non-associativity upstream, exhibited at the one pair that breaks.
------------------------------------------------------------------------

न-सङ्क्रमणम् : ¬ (जिह्वाभेदः (संयोग (अन्तर्भाव स्यात्-अस्ति) (अन्तर्भाव स्यात्-नास्ति))
                ≡ संयोग (जिह्वाभेदः (अन्तर्भाव स्यात्-अस्ति))
                        (जिह्वाभेदः (अन्तर्भाव स्यात्-नास्ति)))
न-सङ्क्रमणम् e = आम्≢न (sym (cong fst e))

------------------------------------------------------------------------
-- � � ��-�-������ � ��� NEVER carries both seeds.  Universally quantified;
--     upstream had the single instance `������`.
------------------------------------------------------------------------

सह-न-उभयम् : (x y : सप्तभङ्गी)
           → नास्त्यंशः (सह-योग x y) ≡ आम् → अस्त्यंशः (सह-योग x y) ≡ न
सह-न-उभयम् x y = कार्यम् (संयोग (अन्तर्भाव x) (अन्तर्भाव y))
  where
    कार्यम् : (t : समावेश)
           → नास्त्यंशः (प्रत्यन्तर्भाव (जिह्वाभेदः t)) ≡ आम्
           → अस्त्यंशः (प्रत्यन्तर्भाव (जिह्वाभेदः t)) ≡ न
    कार्यम् (आम् , आम् , _)   q = ⊥-rec (आम्≢न (sym q))
    कार्यम् (आम् , न   , आम्) q = ⊥-rec (आम्≢न (sym q))
    कार्यम् (आम् , न   , न)   q = ⊥-rec (आम्≢न (sym q))
    कार्यम् (न   , आम् , आम्) _ = refl
    कार्यम् (न   , आम् , न)   _ = refl
    कार्यम् (न   , न   , आम्) q = ⊥-rec (आम्≢न (sym q))
    कार्यम् (न   , न   , न)   q = ⊥-rec (आम्≢न (sym q))

------------------------------------------------------------------------
-- � � ������� ���� � the third and the seventh are KRAMA-ONLY.  They are r's
--     kernel, and they are the two non-fixed points of the fibre computed
--     in `Avaktavyakernel_�§1.4`.  So: 7 = 5 + 2, and the 2 is the collapse.
------------------------------------------------------------------------

तृतीयः-क्रमजः : (x y : सप्तभङ्गी) → ¬ (सह-योग x y ≡ स्यात्-अस्ति-नास्ति)
तृतीयः-क्रमजः x y e =
  आम्≢न (sym (cong अस्त्यंशः e) ∙ सह-न-उभयम् x y (cong नास्त्यंशः e))

सप्तमः-क्रमजः : (x y : सप्तभङ्गी) → ¬ (सह-योग x y ≡ स्यात्-अस्ति-नास्ति-अवक्तव्यम्)
सप्तमः-क्रमजः x y e =
  आम्≢न (sym (cong अस्त्यंशः e) ∙ सह-न-उभयम् x y (cong नास्त्यंशः e))
