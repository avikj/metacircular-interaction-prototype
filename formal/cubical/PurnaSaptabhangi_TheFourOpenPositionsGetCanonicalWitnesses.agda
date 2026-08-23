{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पूर्णसप्तभङ्गी — the map-level sevenfold, completed on the nose.
--
-- WHAT THIS CLOSES.  `GananaSaptabhangi_…agda` §6 (दोषलेखः) shows the
-- map-level classification IS the sevenfold — the non-empty selections of
-- three fibre seeds, 2³ − 1 = 7 — and supplies canonical witnesses for
-- THREE positions:
--
--   id    : Bool → Bool   every fibre contractible          → pure अस्ति
--   एकम्   : Bool → Unit    every fibre crowded               → pure नास्ति
--   asNat : Bool → ℕ      contractible then empty, never
--                         crowded (injective into a set)     → अस्ति-अवक्तव्य
--
-- and leaves the remaining FOUR "as the open frame, stated not smuggled":
-- नास्ति-अवक्तव्य, अस्ति-नास्ति, pure अवक्तव्य, and the full triple.  This
-- module supplies canonical witnesses for those four, so all seven bhaṅgas
-- occupy the classification with a term.  A count with witnesses for only
-- three of its seven cells is a claim standing on an unbuilt frame; the
-- sevenfold is a theorem only once every selection is inhabited.
--
-- The seeds, following the neighbour's readings:
--   सकलादेश (contractible fibre) ↔ अस्ति    — something carried whole
--   विकलादेश (crowded fibre)     ↔ नास्ति   — something lost, exhibited
--   रिक्त    (empty fibre)        ↔ अवक्तव्य  — something the source cannot utter
--
-- Each position is stated cleanly: the seeds that occur are witnessed
-- existentially (क्वचित्, with the b that witnesses), and the seeds that do
-- NOT occur are REFUTED (¬ their क्वचित्), never merely left unexhibited —
-- the standard `asNat` set for the third position with its न-नास्ति.
--
-- WHAT IS AND IS NOT CLAIMED OF SOURCES.  The sevenfold count and the
-- krama/yugapat cut are `Saptabhangi.agda`'s; the seed/selection reading is
-- `SakalaVikalaDesa`'s and `GananaSaptabhangi`'s; sakalādeśa / vikalādeśa
-- are Malliṣeṇa's (Syādvādamañjarī, 1292) at शब्द grade via the note.  पूर्ण-
-- सप्तभङ्गी and the four witness maps are this repository's own; NO claim
-- that any Jain author classified functions — the claim is only that the
-- non-classical logic they enumerated (three values, the third combinable
-- with the other two) is, on the nose, the selection algebra of the fibre.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9, --cubical --safe, no postulates,
-- no holes, no native_decide.  Verified 2026-08-23.
------------------------------------------------------------------------

module PurnaSaptabhangi_TheFourOpenPositionsGetCanonicalWitnesses where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; isSetBool)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sum.Properties using (isSet⊎)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

import GananaSaptabhangi_TheMapLevelCensusIsTheSevenfoldItselfAndTheCorpusAlreadyHoldsThreePositions as G

private
  variable
    A B : Type

------------------------------------------------------------------------
-- ० · discriminators — the only impurity two Bools or a sum ever needs.
------------------------------------------------------------------------

true≢false : ¬ (true ≡ false)
true≢false p = subst कोड p tt
  where कोड : Bool → Type
        कोड true  = Unit
        कोड false = ⊥

false≢true : ¬ (false ≡ true)
false≢true p = true≢false (sym p)

-- inl x vs inr y, in any Bool ⊎ Unit-shaped codomain we use
inl≢inr : {x : Bool} {y : Unit} → ¬ (inl x ≡ inr y)
inl≢inr p = true≢false (cong टैग p)
  where टैग : Bool ⊎ Unit → Bool
        टैग (inl _) = true
        टैग (inr _) = false

-- inl false vs inl true
inlfalse≢inltrue : ¬ (inl false ≡ inl true)
inlfalse≢inltrue p = false≢true (cong पत p)
  where पत : Bool ⊎ Unit → Bool
        पत (inl b) = b
        पत (inr _) = false

inltrue≢inlfalse : ¬ (inl true ≡ inl false)
inltrue≢inlfalse p = inlfalse≢inltrue (sym p)

isSetBU : isSet (Bool ⊎ Unit)
isSetBU = isSet⊎ isSetBool isSetUnit

------------------------------------------------------------------------
-- १ · नास्ति-अवक्तव्य — the constant map Bool → Bool ⊎ Unit at inl true.
--
-- inl true is hit twice (विकलादेश → नास्ति), everything else empty
-- (रिक्त → अवक्तव्य), and NO fibre is contractible (the one inhabited
-- fibre is crowded), so अस्ति is refuted.
------------------------------------------------------------------------

नित्य : Bool → Bool ⊎ Unit
नित्य _ = inl true

नित्य-नास्ति : G.नास्ति-क्वचित् नित्य
नित्य-नास्ति = inl true , (false , refl) , (true , refl)
            , λ p → false≢true (cong fst p)

नित्य-अवक्तव्य : G.अवक्तव्य-क्वचित् नित्य
नित्य-अवक्तव्य = inl false , λ (b , p) → inltrue≢inlfalse p

नित्य-न-अस्ति : ¬ G.अस्ति-क्वचित् नित्य
नित्य-न-अस्ति (b* , c) =
  false≢true (cong fst (isContr→isProp c (false , pc) (true , pc)))
  where pc : नित्य (fst (fst c)) ≡ b*
        pc = snd (fst c)

नास्ति-अवक्तव्य-पदम् :
  G.नास्ति-क्वचित् नित्य × G.अवक्तव्य-क्वचित् नित्य × (¬ G.अस्ति-क्वचित् नित्य)
नास्ति-अवक्तव्य-पदम् = नित्य-नास्ति , नित्य-अवक्तव्य , नित्य-न-अस्ति

------------------------------------------------------------------------
-- २ · अस्ति-नास्ति — the krama both-position (third bhaṅga): a surjection
-- (Bool ⊎ Unit) → Bool, contractible at false, crowded at true, and NO
-- empty fibre, so अवक्तव्य is refuted.
------------------------------------------------------------------------

क्रमद्वि : Bool ⊎ Unit → Bool
क्रमद्वि (inl b) = b
क्रमद्वि (inr _) = true

क्रमद्वि-अस्ति : G.अस्ति-क्वचित् क्रमद्वि
क्रमद्वि-अस्ति = false , isc
  where
    isc : isContr (Σ[ a ∈ (Bool ⊎ Unit) ] (क्रमद्वि a ≡ false))
    fst isc = inl false , refl
    snd isc (inl false , p) = ΣPathP (refl , isSetBool false false refl p)
    snd isc (inl true  , p) = ⊥-rec (true≢false p)
    snd isc (inr tt    , p) = ⊥-rec (true≢false p)

क्रमद्वि-नास्ति : G.नास्ति-क्वचित् क्रमद्वि
क्रमद्वि-नास्ति = true , (inl true , refl) , (inr tt , refl)
              , λ p → inltrue≢inr (cong fst p)
  where inltrue≢inr : ¬ (inl true ≡ inr tt)
        inltrue≢inr = inl≢inr

क्रमद्वि-न-अवक्तव्य : ¬ G.अवक्तव्य-क्वचित् क्रमद्वि
क्रमद्वि-न-अवक्तव्य (false , ne) = ne (inl false , refl)
क्रमद्वि-न-अवक्तव्य (true  , ne) = ne (inl true  , refl)

अस्ति-नास्ति-पदम् :
  G.अस्ति-क्वचित् क्रमद्वि × G.नास्ति-क्वचित् क्रमद्वि × (¬ G.अवक्तव्य-क्वचित् क्रमद्वि)
अस्ति-नास्ति-पदम् = क्रमद्वि-अस्ति , क्रमद्वि-नास्ति , क्रमद्वि-न-अवक्तव्य

------------------------------------------------------------------------
-- ३ · pure अवक्तव्य — the empty source against an inhabited codomain.
-- Every fibre over the inhabited Unit is empty; अस्ति and नास्ति are both
-- refuted because their witnesses would require a domain element and there
-- are none.  This is the position §6 said "needs an EMPTY source".
------------------------------------------------------------------------

रिक्त-स्रोतः : ⊥ → Unit
रिक्त-स्रोतः ()

रिक्त-अवक्तव्य : G.अवक्तव्य-क्वचित् रिक्त-स्रोतः
रिक्त-अवक्तव्य = tt , fst

रिक्त-न-अस्ति : ¬ G.अस्ति-क्वचित् रिक्त-स्रोतः
रिक्त-न-अस्ति (u , c) = fst (fst c)

रिक्त-न-नास्ति : ¬ G.नास्ति-क्वचित् रिक्त-स्रोतः
रिक्त-न-नास्ति (u , x , _) = fst x

अवक्तव्य-पदम् :
  G.अवक्तव्य-क्वचित् रिक्त-स्रोतः
    × (¬ G.अस्ति-क्वचित् रिक्त-स्रोतः)
    × (¬ G.नास्ति-क्वचित् रिक्त-स्रोतः)
अवक्तव्य-पदम् = रिक्त-अवक्तव्य , रिक्त-न-अस्ति , रिक्त-न-नास्ति

------------------------------------------------------------------------
-- ४ · the full triple अस्ति-नास्ति-अवक्तव्य — the seventh bhaṅga, all three
-- seeds at once.  (Unit ⊎ Bool) → (Bool ⊎ Unit): inl false hit once
-- (अस्ति), inl true hit twice (नास्ति), inr tt hit never (अवक्तव्य).
------------------------------------------------------------------------

त्रिपद : Unit ⊎ Bool → Bool ⊎ Unit
त्रिपद (inl _)     = inl false
त्रिपद (inr false) = inl true
त्रिपद (inr true)  = inl true

त्रिपद-अस्ति : G.अस्ति-क्वचित् त्रिपद
त्रिपद-अस्ति = inl false , isc
  where
    isc : isContr (Σ[ a ∈ (Unit ⊎ Bool) ] (त्रिपद a ≡ inl false))
    fst isc = inl tt , refl
    snd isc (inl tt    , p) = ΣPathP (refl , isSetBU (inl false) (inl false) refl p)
    snd isc (inr false , p) = ⊥-rec (inltrue≢inlfalse p)
    snd isc (inr true  , p) = ⊥-rec (inltrue≢inlfalse p)

त्रिपद-नास्ति : G.नास्ति-क्वचित् त्रिपद
त्रिपद-नास्ति = inl true , (inr false , refl) , (inr true , refl)
            , λ p → false≢true (cong ध p)
  where ध : (Σ[ a ∈ (Unit ⊎ Bool) ] (त्रिपद a ≡ inl true)) → Bool
        ध (inl _ , _)     = false
        ध (inr b , _)     = b

त्रिपद-अवक्तव्य : G.अवक्तव्य-क्वचित् त्रिपद
त्रिपद-अवक्तव्य = inr tt , ne
  where ne : ¬ (Σ[ a ∈ (Unit ⊎ Bool) ] (त्रिपद a ≡ inr tt))
        ne (inl _     , p) = inl≢inr p
        ne (inr false , p) = inl≢inr p
        ne (inr true  , p) = inl≢inr p

पूर्ण-पदम् :
  G.अस्ति-क्वचित् त्रिपद × G.नास्ति-क्वचित् त्रिपद × G.अवक्तव्य-क्वचित् त्रिपद
पूर्ण-पदम् = त्रिपद-अस्ति , त्रिपद-नास्ति , त्रिपद-अवक्तव्य
