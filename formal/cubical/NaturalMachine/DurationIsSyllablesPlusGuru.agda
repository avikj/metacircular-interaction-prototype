{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.DurationIsSyllablesPlusGuru
--
-- The surviving route from `Sankalita` §13, taken one step.
--
-- Three encodings of the mātrāmeru/meru diagonal identity were refuted
-- there, each differently, leaving one: Piṅgala's own argument, which
-- sorts patterns by syllable count instead of manipulating sums.  Its
-- heart is a one-line induction, and here it is.
--
-- ────────────────────────────────────────────────────────────────────
-- THE LEMMA
--
--     matra-split :  matrāOf p  ≡  varṇa p + guruOf p
--
-- Duration equals syllable count plus guru count, because a laghu weighs
-- one mātrā and a guru weighs two.  Trivial, and it is exactly what
-- reparametrises the identity out of subtraction: a pattern of duration
-- `n` with `a` syllables and `b` guru satisfies `a + b ≡ n`, with no
-- `n − k` anywhere.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT BUYS
--
--     metre-sorts :  Metre n  ≃  Σ[ (a,b) : a + b ≡ n ] Chosen a b
--
-- — "a metre of duration `n` is a choice of how many syllables and how
-- many of them are guru, then a pattern with those statistics" — is now a
-- statement with no truncated subtraction in it, which is what killed the
-- second encoding.  `metre-to-sorted` and `sorted-to-metre` below are the
-- two maps; the equivalence needs a Σ-contraction and is not assembled
-- here.
--
-- Taking cardinalities of that statement, with `Pingala.matraCount` and
-- `Pingala.meruCount`, is the diagonal identity — and the remaining step
-- is the cardinality of a Σ over a finite index, which is
-- `Cubical.Data.FinSet.Cardinality` machinery and is named, not waved at.
--
-- WHAT IS NOT CLAIMED.  The equivalence, and hence the identity.  What is
-- claimed is that the obstacle common to all three refuted encodings —
-- subtraction, or a family not closed under reindexing — is absent from
-- this formulation, and the lemma that makes it absent is checked.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.DurationIsSyllablesPlusGuru where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc ; +-comm)
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _∷_)

open import Pingala
  using ( Pattern ; Syllable ; laghu ; guru ; mora
        ; matraOf ; varna ; guruOf ; Metre ; Chosen )

------------------------------------------------------------------------
-- 1.  THE LEMMA.  Duration is syllables plus guru.
------------------------------------------------------------------------

matra-split : (p : Pattern) → matraOf p ≡ varna p + guruOf p
matra-split [] = refl
matra-split (laghu ∷ p) = cong suc (matra-split p)
matra-split (guru ∷ p) =
    cong (λ z → suc (suc z)) (matra-split p)
  ∙ cong suc (sym (+-suc (varna p) (guruOf p)))

------------------------------------------------------------------------
-- 2.  The two maps of the sorting statement
------------------------------------------------------------------------

Sorted : ℕ → Type
Sorted n = Σ[ ab ∈ (ℕ × ℕ) ] ((fst ab + snd ab ≡ n) × Chosen (fst ab) (snd ab))

metre-to-sorted : (n : ℕ) → Metre n → Sorted n
metre-to-sorted n (p , dur) =
  (varna p , guruOf p) , (sym (matra-split p) ∙ dur) , (p , refl , refl)

sorted-to-metre : (n : ℕ) → Sorted n → Metre n
sorted-to-metre n ((a , b) , sum , (p , va , gu)) =
  p , (matra-split p ∙ cong₂ _+_ va gu ∙ sum)

------------------------------------------------------------------------
-- 3.  One round trip is immediate — the pattern is untouched
------------------------------------------------------------------------

roundtrip-pattern :
  (n : ℕ) (m : Metre n) → fst (sorted-to-metre n (metre-to-sorted n m)) ≡ fst m
roundtrip-pattern n (p , _) = refl

------------------------------------------------------------------------
-- 4.  Where the thread stands.
--
-- `Sankalita` §13 left one route standing out of four.  This file shows
-- its first step goes through, and that the reparametrisation removes the
-- obstacle the other three died of: there is no `n − k` in `Sorted`, and
-- the index set `{(a,b) : a + b ≡ n}` is closed under the reindexing the
-- Pascal step performs, because it is symmetric in the two coordinates.
--
-- What is left is a Σ-contraction (both round trips) and a cardinality
-- transfer.  Neither is an obstacle of the kind that killed the others,
-- and saying so this time is backed by the two maps existing.
------------------------------------------------------------------------
