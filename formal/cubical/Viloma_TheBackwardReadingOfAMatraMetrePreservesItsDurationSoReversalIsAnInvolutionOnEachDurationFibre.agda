-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विलोम — विलोमेन पठितं मात्रावृत्तं तावन्मात्रमेव ।
-- (viloma: "against the grain", the backward reading.  A mātrā-metre read
-- from its last syllable to its first keeps its total duration.)
--
-- THE TERMS, THEIR TEXTS, THEIR DATES.  The object is Piṅgala's, the
-- मात्रावृत्त — a metre measured by DURATION, laghu(light) counting 1 and
-- guru(heavy) counting 2 — the mātrā material of the *छन्दःशास्त्रम्*
-- (Chandaḥśāstra, c. 300–200 BCE), stated as a duration rule for whole
-- classes of metres by Virahāṅka, *Vṛttajātisamuccaya* (c. 600–800 CE),
-- ch. 6.  Piṅgala's प्रस्तार (prastāra) lays every laghu–guru pattern out
-- in a table; this file records ONE symmetry of that table.
--
-- WHAT IS AND IS NOT CLAIMED.  विलोम is ordinary Sanskrit for "reverse /
-- against the grain"; the metrical reversal-invariance theorem below is
-- NOT claimed as Piṅgala's or Virahāṅka's — neither wrote a list, a fibre,
-- or an involution.  What IS claimed, and checked: the total-mātrā map
-- छन्दः : List Bool → ℕ is invariant under list reversal, so छन्दः ∘ rev
-- ≡ छन्दः as maps, and consequently reversal is a NON-identity
-- self-equivalence — an involution — of every duration-fibre.  The
-- substrate (List, rev, univalent fibres) is cubical type theory
-- (Voevodsky) and is claimed for no Indian source.  The compound विलोम-…
-- is built here, 2026-08-22.
--
-- WHY THIS IS NOT ALREADY IN THE CORPUS.  `Virahanka_…TheTwoStepRecurrence`
-- splits `fiber छन्दः (2+n)` into two smaller fibres; it never touches the
-- order of the syllables inside a metre.  No file proves छन्दः invariant
-- under `rev` (grep: छन्दः never meets `rev`).  The mātrā of a metre is a
-- SUM, and a sum forgets order — so the palindromic symmetry of the
-- prastāra is a fact the recurrence cannot see, and it is landed here as
-- an equivalence, not a count.
------------------------------------------------------------------------

module Viloma_TheBackwardReadingOfAMatraMetrePreservesItsDurationSoReversalIsAnInvolutionOnEachDurationFibre where

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
-- मात्रा and छन्दः — Piṅgala's weight (laghu 1, guru 2) and the total
-- duration of a pattern, exactly as in `Virahanka_…`.
------------------------------------------------------------------------

मात्रा : Bool → ℕ
मात्रा true  = 1
मात्रा false = 2

छन्दः : List Bool → ℕ
छन्दः []       = 0
छन्दः (x ∷ xs) = मात्रा x + छन्दः xs

------------------------------------------------------------------------
-- १ · छन्दः is a monoid homomorphism into (ℕ, +): concatenation of two
-- metres adds their durations.  The mātrā forgets everything but the sum.
------------------------------------------------------------------------

छन्दः-++ : (xs ys : List Bool) → छन्दः (xs ++ ys) ≡ छन्दः xs + छन्दः ys
छन्दः-++ []       ys = refl
छन्दः-++ (x ∷ xs) ys =
  cong (मात्रा x +_) (छन्दः-++ xs ys)
  ∙ +-assoc (मात्रा x) (छन्दः xs) (छन्दः ys)

------------------------------------------------------------------------
-- २ · The heart: छन्दः (rev xs) ≡ छन्दः xs.  Reversing a metre snocs the
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
-- ३ · THE MAP EQUALITY (A ≡ B).  छन्दः ∘ rev ≡ छन्दः as functions
-- List Bool → ℕ.  The backward reading of every metre has the same
-- duration as the forward reading — Piṅgala's prastāra is symmetric under
-- विलोम, at the level of duration.
------------------------------------------------------------------------

विलोम-मात्रासाम्य : (λ xs → छन्दः (rev xs)) ≡ छन्दः
विलोम-मात्रासाम्य i xs = छन्दः-rev xs i

------------------------------------------------------------------------
-- ४ · THE FIBRE EQUIVALENCE (A ≃ A, inhabited by reversal, not identity).
-- Because छन्दः is a set-map, each duration-fibre's witness is a
-- proposition, so reversal — carrying (xs, छन्दः xs ≡ n) to
-- (rev xs, छन्दः-rev xs ∙ p) — is its own two-sided inverse via rev-rev.
------------------------------------------------------------------------

-- The fibre reversal map: carry a metre of duration n to its backward
-- reading, correcting the duration proof through छन्दः-rev.
विलोम : (n : ℕ) → fiber छन्दः n → fiber छन्दः n
विलोम n (xs , p) = rev xs , छन्दः-rev xs ∙ p

-- Applying विलोम twice is the identity on each fibre (rev-rev), so विलोम is
-- its own two-sided inverse.
विलोम-आवृत्तिद्वयम् : (n : ℕ) (w : fiber छन्दः n) → विलोम n (विलोम n w) ≡ w
विलोम-आवृत्तिद्वयम् n (xs , p) = Σ≡Prop (λ _ → isSetℕ _ _) (rev-rev xs)

विलोम-पर्याय : (n : ℕ) → fiber छन्दः n ≃ fiber छन्दः n
विलोम-पर्याय n =
  isoToEquiv (iso (विलोम n) (विलोम n) (विलोम-आवृत्तिद्वयम् n) (विलोम-आवृत्तिद्वयम् n))
