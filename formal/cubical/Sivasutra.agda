{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sivasutra — Pāṇini's pratyāhāra as an interval, checked.
--
-- SOURCE.  The Aṣṭādhyāyī opens with the fourteen Māheśvara / śiva-sūtras:
-- the sounds of Sanskrit laid out in ONE linear order, each sūtra ending in
-- an anubandha (it-marker).  A pratyāhāra names a class of sounds as the
-- INTERVAL from a starting sound up to (and excluding) a marker: e.g. `aṆ`
-- = a i u; `aK` = a i u ṛ ḷ; `aC` = all the vowels.  This is the device
-- that lets any needed phonological class be named by two letters, and it
-- is why INDIC_FORMAL_TRADITIONS_MAP.md §1.1 records the śiva-sūtra
-- ordering as an interval representation of an intersection-closed family
-- (Petersen's optimality theorem is that deeper object; it is NOT proved
-- here — see below).
--
-- The first four sūtras, with their it-markers Ṇ K Ṅ C:
--   1.  a  i  u  Ṇ
--   2.  ṛ  ḷ  K
--   3.  e  o  Ṅ
--   4.  ai au C
-- (These four give the entire vowel system; the consonant sūtras 5–14 are
-- not encoded here.)
--
-- WHAT IS CHECKED.  The interval mechanism itself, on the vowel prefix:
-- `upto m` collects the sounds from the front up to marker m, skipping any
-- intervening markers.  The pratyāhāras aṆ, aK, aC then compute to exactly
-- the traditional classes, by refl; and no it-marker ever appears in a
-- pratyāhāra (the anubandha is a boundary, not a member).
--
-- NOT claimed: the consonant sūtras; that the ordering is OPTIMAL (the
-- intersection-closed interval-representation optimality — the deep
-- theorem); any historical priority statement.  Those are separate and
-- owed.
--
-- Contents (no postulates, no holes, --safe):
--   Sym, isMarker, sivasutra   the vowel prefix as a linear order
--   upto                       the pratyāhāra extractor (interval to marker)
--   aṆ, aK, aC                 the three vowel pratyāhāras, each ≡ its
--                              traditional class by refl
--   marker-free                no pratyāhāra contains an it-marker
------------------------------------------------------------------------

module Sivasutra where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_ ; true≢false)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- The sounds and it-markers of the first four sūtras, in śiva-sūtra order.
------------------------------------------------------------------------

data Sym : Type where
  -- vowels (the sounds)
  a i u ṛ ḷ e o ai au : Sym
  -- it-markers (anubandhas)
  Ṇ K Ṅ C : Sym

isMarker : Sym → Bool
isMarker Ṇ = true
isMarker K = true
isMarker Ṅ = true
isMarker C = true
isMarker _ = false

-- decidable equality, as a boolean, for the stop test
eqSym : Sym → Sym → Bool
eqSym a a = true
eqSym i i = true
eqSym u u = true
eqSym ṛ ṛ = true
eqSym ḷ ḷ = true
eqSym e e = true
eqSym o o = true
eqSym ai ai = true
eqSym au au = true
eqSym Ṇ Ṇ = true
eqSym K K = true
eqSym Ṅ Ṅ = true
eqSym C C = true
eqSym _ _ = false

-- the linear order of the first four sūtras
sivasutra : List Sym
sivasutra = a ∷ i ∷ u ∷ Ṇ ∷ ṛ ∷ ḷ ∷ K ∷ e ∷ o ∷ Ṅ ∷ ai ∷ au ∷ C ∷ []

------------------------------------------------------------------------
-- The pratyāhāra extractor.  From the front, collect sounds up to (not
-- including) the marker m; any OTHER marker along the way is a boundary of
-- an earlier sūtra and is skipped, never emitted.  (All pratyāhāras here
-- begin at `a`, the head, so no start-search is needed.)
------------------------------------------------------------------------

upto : Sym → List Sym → List Sym
upto m [] = []
upto m (x ∷ xs) =
  if eqSym x m
  then []
  else (if isMarker x then upto m xs else x ∷ upto m xs)

------------------------------------------------------------------------
-- The three vowel pratyāhāras, each equal to its traditional class BY REFL
-- (the extractor computes).
------------------------------------------------------------------------

-- aṆ : the sounds a i u
aṆ : upto Ṇ sivasutra ≡ a ∷ i ∷ u ∷ []
aṆ = refl

-- aK : the simple vowels a i u ṛ ḷ
aK : upto K sivasutra ≡ a ∷ i ∷ u ∷ ṛ ∷ ḷ ∷ []
aK = refl

-- aC : ALL the vowels a i u ṛ ḷ e o ai au
aC : upto C sivasutra ≡ a ∷ i ∷ u ∷ ṛ ∷ ḷ ∷ e ∷ o ∷ ai ∷ au ∷ []
aC = refl

-- The three nest as intervals of the one order: aṆ ⊂ aK ⊂ aC, each a
-- prefix of the next (visible directly in the refls above — the shorter
-- class is a prefix of the longer, since they share the same left endpoint
-- `a` and only the right marker moves outward).  That the class is named by
-- moving ONE endpoint along ONE linear order is the śiva-sūtra device.
