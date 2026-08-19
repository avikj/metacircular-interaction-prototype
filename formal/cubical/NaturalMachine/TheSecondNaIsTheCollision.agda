{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheSecondNaIsTheCollision
--
-- अण् is two sets, and here they are — computed from the शिवसूत्राणि
-- rather than asserted from memory.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS FILE EXISTS
--
-- `PratyaharaBuysTotalityWithLocality` proved that repeating a letter
-- destroys locality of naming, using a three-letter toy order `x y z x`,
-- and asserted in prose that this is "the smallest instance of the
-- ambiguity at अण्, whose ण् is an अनुबन्ध in both the first शिवसूत्र
-- and the sixth".
--
-- That is a historical claim made from memory, in a repository whose
-- protocol says a citation you did not check is an error of the same
-- kind as a fitted constant.  It is checked here, by computing both
-- readings from the list.
--
-- `Sivasutra.agda` — another identity's file, untouched — encodes the
-- FIRST FOUR sūtras and extracts with a first-match rule:
--
--     upto m (x ∷ xs) = if x ≡ m then [] else …
--
-- At four sūtras that is correct, because ण् occurs once there.  It is
-- not a definition of प्रत्याहार though; it is a CONVENTION, and the
-- convention only becomes visible at the sixth sūtra, which that file
-- does not reach.  Nothing there is wrong.  The assumption is invisible
-- at its own scope, which is the interesting part.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SIX SŪTRAS, AND THE TWO ण्
--
--     १  अ इ उ ण्          ४  ऐ औ च्
--     २  ॠ ऌ क्           ५  ह य व र ट्
--     ३  ए ओ ङ्           ६  ल ण्
--
-- ण् closes the first and the sixth, so अण् has two readings:
--
--     narrow   a i u
--     wide     a i u ṛ ḷ e o ai au h y v r l
--
-- Both are used — the narrow one is the vowel class, the wide one is
-- vowels-and-semivowels, required wherever अण् must cover य् व् र् ल्.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §3  both readings, each by `refl` from the list;
--   §4  they differ, with `e` the witness;
--   §5  so the name ण् does not determine its set, and the toy collision
--       is realised at the actual शिवसूत्राणि.
--
-- NOT CLAIMED: that the traditional resolution is anything in
-- particular.  Pāṇini fixes the reading by other means and which means
-- is a question about the sūtras this file does not enter.  Claimed only
-- that the ambiguity is in the list, not in anyone's account of it.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheSecondNaIsTheCollision where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true ; if_then_else_ ; _or_)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteInformation using (FactorsThrough)
open import NaturalMachine.AnyonyaAbhava using (Anyonya ; anyonya→samsarga)

------------------------------------------------------------------------
-- 1.  The sounds and अनुबन्ध of the first six sūtras
------------------------------------------------------------------------

data Sym : Type₀ where
  a i u ṛ ḷ e o ai au h y v r l : Sym     -- sounds
  Ṇ K Ṅ C Ṭ : Sym                          -- अनुबन्ध

isMarker : Sym → Bool
isMarker Ṇ = true
isMarker K = true
isMarker Ṅ = true
isMarker C = true
isMarker Ṭ = true
isMarker _ = false

isṆ : Sym → Bool
isṆ Ṇ = true
isṆ _ = false

------------------------------------------------------------------------
-- 2.  The list, through the sixth sūtra — where the second ण् lives
------------------------------------------------------------------------

sivasutra6 : List Sym
sivasutra6 =
  a ∷ i ∷ u ∷ Ṇ ∷                -- १  अ इ उ ण्
  ṛ ∷ ḷ ∷ K ∷                    -- २  ॠ ऌ क्
  e ∷ o ∷ Ṅ ∷                    -- ३  ए ओ ङ्
  ai ∷ au ∷ C ∷                  -- ४  ऐ औ च्
  h ∷ y ∷ v ∷ r ∷ Ṭ ∷            -- ५  ह य व र ट्
  l ∷ Ṇ ∷ []                     -- ६  ल ण्

-- collect the sounds, skipping `n` occurrences of ण् and stopping at the
-- next one.  Other अनुबन्ध are sūtra boundaries and are never emitted.
collect : ℕ → List Sym → List Sym
collect n       []       = []
collect zero    (x ∷ xs) =
  if isṆ x then [] else (if isMarker x then collect zero xs else x ∷ collect zero xs)
collect (suc k) (x ∷ xs) =
  if isṆ x then collect k xs
           else (if isMarker x then collect (suc k) xs else x ∷ collect (suc k) xs)

------------------------------------------------------------------------
-- 3.  BOTH READINGS, each by refl
------------------------------------------------------------------------

aṆ-narrow : collect 0 sivasutra6 ≡ a ∷ i ∷ u ∷ []
aṆ-narrow = refl

aṆ-wide : collect 1 sivasutra6
        ≡ a ∷ i ∷ u ∷ ṛ ∷ ḷ ∷ e ∷ o ∷ ai ∷ au ∷ h ∷ y ∷ v ∷ r ∷ l ∷ []
aṆ-wide = refl

------------------------------------------------------------------------
-- 4.  AND THEY DIFFER — ए is in one and not the other
------------------------------------------------------------------------

isE : Sym → Bool
isE e = true
isE _ = false

hasE : List Sym → Bool
hasE []       = false
hasE (x ∷ xs) = isE x or hasE xs

narrow-lacks-e : hasE (collect 0 sivasutra6) ≡ false
narrow-lacks-e = refl

wide-has-e : hasE (collect 1 sivasutra6) ≡ true
wide-has-e = refl

readings-differ : Anyonya (collect 0 sivasutra6) (collect 1 sivasutra6)
readings-differ p = false≢true (cong hasE p)

------------------------------------------------------------------------
-- 5.  SO THE NAME ण् DOES NOT DETERMINE ITS SET
--
-- Both readings are called by the same अनुबन्ध.  The collision the toy
-- order `x y z x` exhibited is here, at the शिवसूत्राणि themselves.
------------------------------------------------------------------------

data Reading : Type₀ where
  atFirstṆ atSixthṆ : Reading

nameOf : Reading → Sym
nameOf atFirstṆ = Ṇ
nameOf atSixthṆ = Ṇ

setOf : Reading → List Sym
setOf atFirstṆ = collect 0 sivasutra6
setOf atSixthṆ = collect 1 sivasutra6

same-anubandha : nameOf atFirstṆ ≡ nameOf atSixthṆ
same-anubandha = refl

aṆ-does-not-factor : ¬ FactorsThrough nameOf setOf
aṆ-does-not-factor =
  anyonya→samsarga nameOf setOf
    {x = atFirstṆ} {x' = atSixthṆ}
    same-anubandha
    readings-differ

------------------------------------------------------------------------
-- 6.  What this settles, and what it costs.
--
-- SETTLED.  The prose citation in `PratyaharaBuysTotalityWithLocality`
-- is now a computation: अण् really does denote two different sets, and
-- the reason really is that ण् closes two sūtras.  The toy collision
-- there was a faithful model, which is worth knowing, because a toy that
-- turns out not to model anything is just a toy.
--
-- COST.  Two more sūtras of encoding.  That is the whole price of moving
-- a historical claim from memory into the checker, and it is the price
-- CLAUDE.md's directive is asking for whenever a source is named.
--
-- AND ONE THING FOUND ON THE WAY.  `Sivasutra.upto` stops at the first
-- matching अनुबन्ध.  Within its four sūtras that is exactly right.  Past
-- them it silently selects the narrow reading of अण् and offers no sign
-- that a choice was made.  This is not a defect in that file — it is the
-- ordinary situation of a convention that is invisible at the scope
-- where it is introduced, and it is the same shape as everything else
-- this thread has found: what a decoder cannot see, it cannot report.
--
-- OPEN, named and not estimated.  Whether Pāṇini's own means of fixing
-- the reading is itself local — whether the disambiguating machinery can
-- be read off the rule where अण् occurs, or needs the whole grammar.
-- That is a question about the सूत्रs and this file does not enter it.
------------------------------------------------------------------------
