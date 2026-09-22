{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ������ � �������� ����� ������������ ������������� �
-- (viloma: "against the grain", the backward reading.  A mtr-metre read
-- from its last syllable to its first keeps its total duration.)
--
-- THE TERMS, THEIR TEXTS, THEIR DATES.  The object is Pigala's, the
-- ����������� � a metre measured by DURATION, laghu(light) counting 1 and
-- guru(heavy) counting 2 � the mtr material of the *��������������*
-- (Chandastra, c. 300�200 BCE), stated as a duration rule for whole
-- classes of metres by Virahka, *Vttajtisamuccaya* (c. 600�800 CE),
-- ch. 6.  Pigala's �������� (prastra) lays every laghu�guru pattern out
-- in a table; this file records ONE symmetry of that table.
--
-- WHY THIS IS NOT ALREADY IN THE CORPUS.  `Virahanka_�TheTwoStepRecurrence`
-- splits `fiber ����� (2+n)` into two smaller fibers; it never touches the
-- order of the syllables inside a metre.  No file proves ����� invariant
-- under `rev` (����� never meets `rev`).  The mtr of a metre is a
-- SUM, and a sum forgets order � so the palindromic symmetry of the
-- prastra is a fact the recurrence cannot see, and it is landed here as
-- an equivalence, not a count.
------------------------------------------------------------------------

module Viloma_TheBackwardReadingOfAMatraMetrePreservesItsDurationSoReversalIsAnInvolutionOnEachDurationFiber where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ
                                    ; +-zero ; +-comm ; +-assoc)
open import Cubical.Data.List using (List ; [] ; _∷_ ; [_] ; _++_ ; rev)
open import Cubical.Data.List.Properties using (rev-rev)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (Σ≡Prop ; fst ; snd)

------------------------------------------------------------------------
-- ������ and ����� � Pigala's weight (laghu 1, guru 2) and the total
-- duration of a pattern, exactly as in `Virahanka_�`.
------------------------------------------------------------------------

मात्रा : Bool → ℕ
मात्रा true  = 1
मात्रा false = 2

छन्दः : List Bool → ℕ
छन्दः []       = 0
छन्दः (x ∷ xs) = मात्रा x + छन्दः xs

------------------------------------------------------------------------
-- � � ����� is a monoid homomorphism into (�, +): concatenation of two
-- metres adds their durations.  The mtr forgets everything but the sum.
------------------------------------------------------------------------

छन्दः-++ : (xs ys : List Bool) → छन्दः (xs ++ ys) ≡ छन्दः xs + छन्दः ys
छन्दः-++ []       ys = refl
छन्दः-++ (x ∷ xs) ys =
  cong (मात्रा x +_) (छन्दः-++ xs ys)
  ∙ +-assoc (मात्रा x) (छन्दः xs) (छन्दः ys)

------------------------------------------------------------------------
-- � � The heart: ����� (rev xs) ≡ ����� xs.  Reversing a metre snocs the
-- head onto the reversed tail; the homomorphism turns that snoc into a
-- sum, and commutativity puts the head back in front.
------------------------------------------------------------------------

छन्दः-rev : (xs : List Bool) → छन्दः (rev xs) ≡ छन्दः xs
छन्दः-rev []       = refl
छन्दः-rev (x ∷ xs) =
  छन्दः-++ (rev xs) [ x ]
  ∙ cong (छन्दः (rev xs) +_) (+-zero (मात्रा x))     -- छन्दः [ x ] = मात्रा x + 0
  ∙ cong (_+ मात्रा x) (छन्दः-rev xs)                 -- induction on the tail
  ∙ +-comm (छन्दः xs) (मात्रा x)                      -- put the head in front

------------------------------------------------------------------------
-- � � THE MAP EQUALITY (A ≡ B).  ����� ∘ rev ≡ ����� as functions
-- List Bool � �.  The backward reading of every metre has the same
-- duration as the forward reading � Pigala's prastra is symmetric under
-- ������, at the level of duration.
------------------------------------------------------------------------

विलोम-मात्रासाम्य : (λ xs → छन्दः (rev xs)) ≡ छन्दः
विलोम-मात्रासाम्य i xs = छन्दः-rev xs i

------------------------------------------------------------------------
-- � � THE FIBER EQUIVALENCE (A � A, inhabited by reversal, not identity).
-- Because ����� is a set-map, each duration-fiber's witness is a
-- proposition, so reversal � carrying (xs, ����� xs ≡ n) to
-- (rev xs, �����-rev xs ∙ p) � is its own two-sided inverse via rev-rev.
------------------------------------------------------------------------

-- The fiber reversal map: carry a metre of duration n to its backward
-- reading, correcting the duration proof through �����-rev.
विलोम : (n : ℕ) → fiber छन्दः n → fiber छन्दः n
विलोम n (xs , p) = rev xs , छन्दः-rev xs ∙ p

-- Applying ������ twice is the identity on each fiber (rev-rev), so ������ is
-- its own two-sided inverse.
विलोम-आवृत्तिद्वयम् : (n : ℕ) (w : fiber छन्दः n) → विलोम n (विलोम n w) ≡ w
विलोम-आवृत्तिद्वयम् n (xs , p) = Σ≡Prop (λ _ → isSetℕ _ _) (rev-rev xs)

विलोम-पर्याय : (n : ℕ) → fiber छन्दः n ≃ fiber छन्दः n
विलोम-पर्याय n =
  isoToEquiv (iso (विलोम n) (विलोम n) (विलोम-आवृत्तिद्वयम् n) (विलोम-आवृत्तिद्वयम् n))
