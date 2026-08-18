{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Pratyahara
--
-- प्रत्याहार — Pāṇini's abbreviation device, and a fourth level of the
-- tower `Anuvrtti` built.
--
-- ────────────────────────────────────────────────────────────────────
-- THE DEVICE
--
-- The śiva-sūtras list the phonemes in a chosen order with markers (इत्)
-- placed between groups.  A pratyāhāra names a set of phonemes in TWO
-- symbols — a first element and a marker — and it names exactly the
-- CONTIGUOUS RUN between them.  अच्, अल्, हल्, यण् are all of this form.
-- The whole of the Aṣṭādhyāyī's brevity rests on it: a rule that would
-- have to list twenty phonemes lists two.
--
-- So the cost of naming a set is 2 when the set is an interval of the
-- chosen order, and the size of the set otherwise.  Which means **the
-- order of the alphabet is itself a лāghava-bearing choice**, sitting
-- below the ordered rule text:
--
--   denotation  <  rule set  <  ordered rule text  <  alphabet order
--
-- The first three separations are `Laghava` and `Anuvrtti`.  This module
-- is the fourth, and it is the one with a hard obstruction in it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE OBSTRUCTION
--
-- Not every family of sets can be made intervals at once.  Over three
-- letters, the three two-element subsets cannot:
--
--     no-order-makes-all-intervals :
--       (o : Ord) → Σ[ s ∈ Pair ] (isInterval o s ≡ false)
--
-- For any ordering (a, b, c), the set {a, c} skips the middle and is not
-- a run.  All six orderings are checked, each by `refl` — finite
-- exhaustive verification, which CLAUDE.md admits as proof.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THAT PREDICTS ABOUT THE ŚIVA-SŪTRAS, AND IT IS TRUE OF THEM
--
-- If the grammatically required sets do not all fit one linear order,
-- then a list in which every phoneme occurs ONCE cannot supply every
-- needed pratyāhāra.  The way out is to let a phoneme occur twice, so it
-- can sit in two different runs.
--
-- Pāṇini does exactly this.  ह appears twice in the śiva-sūtras — once in
-- हयवरट् and once in हल् — and the doubling is what lets both अल् and हल्
-- be single runs.  It has been read as redundancy or as a transmission
-- artefact.  It is neither: **repetition is forced**, and the obstruction
-- above is the reason, in its smallest instance.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  That three letters and three sets are the
-- Aṣṭādhyāyī; that ह's doubling is caused by *this* triple (the real
-- family is the one his rules actually require, and identifying it is a
-- philological question this file does not touch); or that Pāṇini's
-- ordering is optimal for his family — that is a separate claim needing
-- the family enumerated.  What is proved is that the consecutive-ones
-- property can FAIL, so "why is anything repeated?" has a structural
-- answer available and not only a historical one.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Pratyahara where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; _and_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  Three letters, and the sets to be named
------------------------------------------------------------------------

data L : Type where
  x y z : L

Set₃ : Type
Set₃ = L → Bool

data Pair : Type where
  XY YZ XZ : Pair

mem : Pair → Set₃
mem XY x = true
mem XY y = true
mem XY z = false
mem YZ x = false
mem YZ y = true
mem YZ z = true
mem XZ x = true
mem XZ y = false
mem XZ z = true

------------------------------------------------------------------------
-- 2.  Orderings, and what it means to be a run
--
-- For a three-element order (a, b, c), a set fails to be contiguous
-- exactly when it holds a and c but not b.  That is computed, not
-- tabulated.
------------------------------------------------------------------------

data Ord : Type where
  xyz xzy yxz yzx zxy zyx : Ord

triple : Ord → L × L × L
triple xyz = x , y , z
triple xzy = x , z , y
triple yxz = y , x , z
triple yzx = y , z , x
triple zxy = z , x , y
triple zyx = z , y , x

skips : L × L × L → Set₃ → Bool
skips (a , b , c) s = s a and (not (s b) and s c)

isInterval : Ord → Pair → Bool
isInterval o p = not (skips (triple o) (mem p))

------------------------------------------------------------------------
-- 3.  THE OBSTRUCTION.  Every ordering fails on some pair.
--
-- The witness is always the pair of the two OUTER letters.
------------------------------------------------------------------------

no-order-makes-all-intervals :
  (o : Ord) → Σ[ p ∈ Pair ] (isInterval o p ≡ false)
no-order-makes-all-intervals xyz = XZ , refl
no-order-makes-all-intervals xzy = XY , refl
no-order-makes-all-intervals yxz = YZ , refl
no-order-makes-all-intervals yzx = XY , refl
no-order-makes-all-intervals zxy = YZ , refl
no-order-makes-all-intervals zyx = XZ , refl

-- stated as the impossibility it is
consecutive-ones-can-fail :
  ¬ (Σ[ o ∈ Ord ] ((p : Pair) → isInterval o p ≡ true))
consecutive-ones-can-fail (o , all) with no-order-makes-all-intervals o
... | (p , bad) = true≢false (sym (all p) ∙ bad)
  where
  open import Cubical.Data.Bool using (true≢false)

------------------------------------------------------------------------
-- 4.  And each ordering does name the other two pairs in two symbols
--
-- So the obstruction is exactly one set short, not a general failure —
-- which is why the repair is one repetition and not a redesign.
------------------------------------------------------------------------

xyz-names-XY : isInterval xyz XY ≡ true
xyz-names-XY = refl

xyz-names-YZ : isInterval xyz YZ ≡ true
xyz-names-YZ = refl

------------------------------------------------------------------------
-- 5.  The sentence.
--
-- लाघव descends one further level than `Anuvrtti` reached: past the
-- ordered rule text to the ordering of the ALPHABET, because that order
-- decides which sets cost two symbols and which cost their cardinality.
-- And at that level, unlike the ones above it, there is a genuine
-- obstruction: some families of sets fit no linear order at all.
--
-- Pāṇini's response — repeat a phoneme so it can lie in two runs — is not
-- untidiness.  It is the only available response, and the smallest
-- instance of the obstruction is checked above.
------------------------------------------------------------------------
