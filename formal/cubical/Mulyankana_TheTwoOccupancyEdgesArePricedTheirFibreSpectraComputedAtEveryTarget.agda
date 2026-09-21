{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡Æ‡‡≤‡‡Ø‡æ‡ô‡‡ï‡®‡Æ‡ ‚î the pricing.
-- The mathematics is the fibre of a map (cubical, the one
-- admitted non-Indian substrate); the three-verdict discipline is
-- Avaccheda's (‡∞‡ø‡ï‡‡‡Æ‡ / ‡‡ï‡Æ‡ / ‡‡‡ ‚î a target nothing reaches, a
-- contractible fibre, a fibre that IS the memory required), and the
-- refusal to collapse three verdicts into two is Saptabhangi.‡¶‡‡∞‡‡®‡Ø‡.
--
-- WHY THIS MODULE EXISTS.  Two Bool ‚Üí ‚Ñï edges live in
-- NaturalMachine.FiniteOccupancyChannelNoGo: `asNat` and `bothNat`.
-- Lopa's deciding rules R1‚ìR4 cannot reach them (target ‚ï is neither
-- contractible nor ‚ä nor a truncation).
-- This module
-- forces the verdicts by computation: the COMPLETE fibre spectrum of both
-- maps, at every target, so the edges are priced rather than graded.
--
-- THE PRICES.
--
--   asNat : Bool ‚í ‚ï          0 ‚¶ ‡‡ï‡Æ‡, 1 ‚¶ ‡‡ï‡Æ‡, n+2 ‚¶ ‡∞‡ø‡ï‡‡‡Æ‡.
--     No ‡‡‡ anywhere: the elision loses nothing ‚î the WHICH survives
--     at every reached target.  A left inverse exists on the image; the
--     map fails only to reach, never to remember.
--
--   bothNat (uncurried) : Bool ó Bool ‚í ‚ï
--     1 ‚¶ ‡‡ï‡Æ‡ (only (true,true)), n+2 ‚¶ ‡∞‡ø‡ï‡‡‡Æ‡, and 0 ‚¶ ‡‡‡ with the
--     fibre computed EXACTLY: three points, Unit ‚ä Unit ‚ä Unit ‚î the
--     memory destroyed at 0 is precisely the distinction among
--     (true,false), (false,true), (false,false).  This is the amount,
--     not a flag (Avaccheda: the fibre IS the amount).
--
-- Together the two maps are the sharpest small contrast the verdict
-- lane owns: one Bool‚í‚ï edge that never forgets and one that forgets
-- exactly two bits' worth at exactly one target.
------------------------------------------------------------------------

module Mulyankana_TheTwoOccupancyEdgesArePricedTheirFibreSpectraComputedAtEveryTarget where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Bool using (Bool ; false ; true ; true‚â¢false)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; isSet‚Ñï ; znots ; snotz ; injSuc)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd ; Œ£PathP)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Relation.Nullary using (¬¨_)

open import NaturalMachine.FiniteOccupancyChannelNoGo using (asNat ; bothNat)

------------------------------------------------------------------------
-- ‡‡‡‡ñ‡‡Ø‡æ-‡‡ô‡‡ï‡‡‡ asNat ‚î the edge that never forgets.
------------------------------------------------------------------------

‡§è‡§ï‡§Æ‡•ç-‡§Ö‡§∏‡§Ç‡§ñ‡•ç‡§Ø‡§æ-‡•¶ : isContr (fiber asNat 0)
‡§è‡§ï‡§Æ‡•ç-‡§Ö‡§∏‡§Ç‡§ñ‡•ç‡§Ø‡§æ-‡•¶ = (false , refl) , contr
  where
  contr : (q : fiber asNat 0) ‚Üí (false , refl) ‚â° q
  contr (false , p) = Œ£PathP (refl , isSet‚Ñï 0 0 refl p)
  contr (true  , p) = Empty.rec (snotz p)

‡§è‡§ï‡§Æ‡•ç-‡§Ö‡§∏‡§Ç‡§ñ‡•ç‡§Ø‡§æ-‡•ß : isContr (fiber asNat 1)
‡§è‡§ï‡§Æ‡•ç-‡§Ö‡§∏‡§Ç‡§ñ‡•ç‡§Ø‡§æ-‡•ß = (true , refl) , contr
  where
  contr : (q : fiber asNat 1) ‚Üí (true , refl) ‚â° q
  contr (true  , p) = Œ£PathP (refl , isSet‚Ñï 1 1 refl p)
  contr (false , p) = Empty.rec (znots p)

‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§Ö‡§∏‡§Ç‡§ñ‡•ç‡§Ø‡§æ : (n : ‚Ñï) ‚Üí ¬¨ fiber asNat (suc (suc n))
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§Ö‡§∏‡§Ç‡§ñ‡•ç‡§Ø‡§æ n (false , p) = znots p
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§Ö‡§∏‡§Ç‡§ñ‡•ç‡§Ø‡§æ n (true  , p) = znots (injSuc p)

------------------------------------------------------------------------
-- ‡â‡‡Ø-‡‡ô‡‡ï‡‡‡ bothNat, uncurried ‚î the edge that forgets exactly once.
------------------------------------------------------------------------

g : Bool √ó Bool ‚Üí ‚Ñï
g xy = bothNat (fst xy) (snd xy)

‡§è‡§ï‡§Æ‡•ç-‡§â‡§≠‡§Ø-‡•ß : isContr (fiber g 1)
‡§è‡§ï‡§Æ‡•ç-‡§â‡§≠‡§Ø-‡•ß = ((true , true) , refl) , contr
  where
  contr : (q : fiber g 1) ‚Üí ((true , true) , refl) ‚â° q
  contr ((true  , true ) , p) = Œ£PathP (refl , isSet‚Ñï 1 1 refl p)
  contr ((true  , false) , p) = Empty.rec (znots p)
  contr ((false , true ) , p) = Empty.rec (znots p)
  contr ((false , false) , p) = Empty.rec (znots p)

‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§â‡§≠‡§Ø : (n : ‚Ñï) ‚Üí ¬¨ fiber g (suc (suc n))
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§â‡§≠‡§Ø n ((true  , true ) , p) = znots (injSuc p)
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§â‡§≠‡§Ø n ((true  , false) , p) = znots p
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§â‡§≠‡§Ø n ((false , true ) , p) = znots p
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§â‡§≠‡§Ø n ((false , false) , p) = znots p

-- ‡‡‡ at 0, and the fibre computed exactly: three points, no more.
‡§¨‡§π‡•Å-‡§â‡§≠‡§Ø-‡•¶ : fiber g 0 ‚âÉ (Unit ‚äé (Unit ‚äé Unit))
‡§¨‡§π‡•Å-‡§â‡§≠‡§Ø-‡•¶ = isoToEquiv (iso fun inv rightInv leftInv)
  where
  fun : fiber g 0 ‚Üí Unit ‚äé (Unit ‚äé Unit)
  fun ((true  , true ) , p) = Empty.rec (snotz p)
  fun ((true  , false) , p) = inl tt
  fun ((false , true ) , p) = inr (inl tt)
  fun ((false , false) , p) = inr (inr tt)

  inv : Unit ‚äé (Unit ‚äé Unit) ‚Üí fiber g 0
  inv (inl tt)       = (true  , false) , refl
  inv (inr (inl tt)) = (false , true ) , refl
  inv (inr (inr tt)) = (false , false) , refl

  rightInv : (k : Unit ‚äé (Unit ‚äé Unit)) ‚Üí fun (inv k) ‚â° k
  rightInv (inl tt)       = refl
  rightInv (inr (inl tt)) = refl
  rightInv (inr (inr tt)) = refl

  leftInv : (q : fiber g 0) ‚Üí inv (fun q) ‚â° q
  leftInv ((true  , true ) , p) = Empty.rec (snotz p)
  leftInv ((true  , false) , p) = Œ£PathP (refl , isSet‚Ñï 0 0 refl p)
  leftInv ((false , true ) , p) = Œ£PathP (refl , isSet‚Ñï 0 0 refl p)
  leftInv ((false , false) , p) = Œ£PathP (refl , isSet‚Ñï 0 0 refl p)

-- and ‡‡‡ said as Avaccheda's verdict demands ‚î not merely "not ‡‡ï‡Æ‡"
-- but the memory exhibited: two elements the collapse would identify.
‡§¨‡§π‡•Å-‡§∏‡§æ‡§ï‡•ç‡§∑‡§ø‡§®‡•ç : ¬¨ isContr (fiber g 0)
‡§¨‡§π‡•Å-‡§∏‡§æ‡§ï‡•ç‡§∑‡§ø‡§®‡•ç c =
  true‚â¢false
    (cong (Œª q ‚Üí fst (fst q))
          (sym (snd c ((true , false) , refl))
           ‚àô snd c ((false , true) , refl)))
