{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����-�������� � the seam ford.  (� � �) � �, hence ≡ �; and composed with
-- LosslessReturn's own ������≡������, a third path neither file paid for:
--
--                          ������ ≡ � .
--
-- PROVENANCE.  ����� and ���������� are Pigala's own pratyayas
-- (�������������� �.�����; Halyudha's ������������ is the received
-- commentary): ���������� carries an index to the pattern it names, �����
-- carries a pattern back to its index, and their joint existence is
-- exactly invertibility � which is the whole content of a ford.
-- The DIAGONAL enumeration itself is Cantor (1878).
--
-- No Bool, no Dec, no decision anywhere: �� moves by matching a
-- constructor, and ��� is structural in (diagonal, first coordinate).
------------------------------------------------------------------------

module SetuYugma_TheSeamFordJoinsTheValliToPingalaAndVivekaIsTheNaturalNumbers where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; invEquiv ; compEquiv)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-comm ; injSuc ; snotz)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using () renaming (rec to ⊥-rec)
open import LosslessReturn using (विवेक ; युग्म≃विवेक ; युग्म≡विवेक)

------------------------------------------------------------------------
-- �� � one step of the diagonal walk.  Along the current diagonal while
-- the second coordinate survives; at its exhaustion, open the next.
------------------------------------------------------------------------

पद : ℕ × ℕ → ℕ × ℕ
पद (x , suc y) = (suc x , y)
पद (x , zero)  = (zero , suc x)

------------------------------------------------------------------------
-- ���������� � index � pattern.  ��������� � the triangular count.
-- ����� � pattern � index.
------------------------------------------------------------------------

उद्दिष्ट : ℕ → ℕ × ℕ
उद्दिष्ट zero    = (zero , zero)
उद्दिष्ट (suc n) = पद (उद्दिष्ट n)

त्रिकोण : ℕ → ℕ
त्रिकोण zero    = zero
त्रिकोण (suc n) = suc n + त्रिकोण n

नष्ट : ℕ × ℕ → ℕ
नष्ट (x , y) = त्रिकोण (x + y) + x

------------------------------------------------------------------------
-- ��-����� � the step is exactly the successor on indices.  This one lemma
-- carries both round trips.
------------------------------------------------------------------------

पद-नष्ट : (p : ℕ × ℕ) → नष्ट (पद p) ≡ suc (नष्ट p)
पद-नष्ट (x , suc y) =
  +-suc (त्रिकोण (suc (x + y))) x
  ∙ cong (λ z → suc (त्रिकोण z + x)) (sym (+-suc x y))
पद-नष्ट (x , zero) =
  +-zero (suc (x + त्रिकोण x))
  ∙ cong suc (+-comm x (त्रिकोण x))
  ∙ cong (λ z → suc (त्रिकोण z + x)) (sym (+-zero x))

------------------------------------------------------------------------
-- ����� ∘ ���������� ≡ id.
------------------------------------------------------------------------

नष्ट-उद्दिष्ट : (n : ℕ) → नष्ट (उद्दिष्ट n) ≡ n
नष्ट-उद्दिष्ट zero    = refl
नष्ट-उद्दिष्ट (suc n) =
  पद-नष्ट (उद्दिष्ट n) ∙ cong suc (नष्ट-उद्दिष्ट n)

------------------------------------------------------------------------
-- ���������� ∘ ����� ≡ id.  ��� walks it, structural in (diagonal, first
-- coordinate): (suc x , y) hands back to (x , suc y) � same diagonal, x
-- smaller; (zero , suc y) hands back to (y , zero) � the diagonal smaller.
------------------------------------------------------------------------

चार : (d x y : ℕ) → x + y ≡ d → उद्दिष्ट (नष्ट (x , y)) ≡ (x , y)
चार zero    zero    zero    e = refl
चार zero    zero    (suc y) e = ⊥-rec (snotz e)
चार zero    (suc x) y       e = ⊥-rec (snotz e)
चार (suc d) zero    zero    e = refl
चार (suc d) zero    (suc y) e =
  cong उद्दिष्ट (पद-नष्ट (y , zero))
  ∙ cong पद (चार d y zero (+-zero y ∙ injSuc e))
चार (suc d) (suc x) y       e =
  cong उद्दिष्ट (पद-नष्ट (x , suc y))
  ∙ cong पद (चार (suc d) x (suc y) (+-suc x y ∙ cong suc (injSuc e)))

उद्दिष्ट-नष्ट : (p : ℕ × ℕ) → उद्दिष्ट (नष्ट p) ≡ p
उद्दिष्ट-नष्ट (x , y) = चार (x + y) x y refl

------------------------------------------------------------------------
-- ����� � the ford.  Both pratyayas exist, so the edge inverts.
------------------------------------------------------------------------

युग्म-Iso-ℕ : Iso (ℕ × ℕ) ℕ
युग्म-Iso-ℕ = iso नष्ट उद्दिष्ट नष्ट-उद्दिष्ट उद्दिष्ट-नष्ट

युग्म≃ℕ : (ℕ × ℕ) ≃ ℕ
युग्म≃ℕ = isoToEquiv युग्म-Iso-ℕ

युग्म≡ℕ : (ℕ × ℕ) ≡ ℕ
युग्म≡ℕ = ua युग्म≃ℕ

------------------------------------------------------------------------
-- ����� � two solutions meet and a third arises that neither contained,
-- and all three survive.  LosslessReturn paid for (� � �) ≡ ������; this file
-- paid for (� � �) ≡ �; the composite is free, and it is the crossing the
-- ford was minted for.
------------------------------------------------------------------------

विवेक≃ℕ : विवेक ≃ ℕ
विवेक≃ℕ = compEquiv (invEquiv युग्म≃विवेक) युग्म≃ℕ

विवेक≡ℕ : विवेक ≡ ℕ
विवेक≡ℕ = sym युग्म≡विवेक ∙ युग्म≡ℕ
