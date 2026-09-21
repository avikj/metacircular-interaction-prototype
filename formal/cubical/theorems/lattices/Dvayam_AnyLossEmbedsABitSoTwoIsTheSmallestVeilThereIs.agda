{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡¶‡‡µ‡Ø‡Æ‡ ‚î ‡Ø‡‡‡∞ ‡ï‡ø‡û‡‡‡ø‡‡ ‡®‡‡‡ü‡ ‡‡‡‡∞ ‡¶‡‡µ‡Ø‡ ‡ó‡‡‡Æ‡ ‡
--
-- (wherever anything is lost, a two is hidden.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- README movement 34 says every wall this corpus hit is the same size,
-- ‚/2, because "‚/2 is the smallest possible fibre ‚î the minimal hiding
-- ‚î so the first obstruction any observation meets is a bit."  That is
-- stated there as a pattern over instances.  Here it is as a theorem, and
-- it is not about any of those instances:
--
--   **any failure of injectivity embeds `Bool` into a fibre.**
--
-- Given two points the map cannot tell apart, the fibre over their common
-- image contains an injective copy of `Bool`.  So there is no such thing
-- as losing less than one bit: the moment an observation confuses
-- anything at all, a two is sitting inside the fibre, and every larger
-- loss contains this one.
--
-- WHICH IS WHY THE FIRST VEIL IS ALWAYS BINARY ‚î not as a coincidence
-- across the sieve's parity, the determinant's mod-2 residue, the odd H¬
-- class and the rest, but because a bit is the floor and everything else
-- is above it.  Movement 34's list is a list of things that hit the
-- floor.
--
-- RELATION TO `Parampara_‚¶agda`, checked before writing this and cited
-- rather than rediscovered.  That module constructs `Bool ‚í fiber ‚¶`
-- SPECIFIC to a concrete three-chain, as one half of an iso computing
-- particular fibres.  This is the general statement ‚î any `f`, any pair it
-- confuses ‚î and neither subsumes the other: Parampara computes fibres,
-- this one says every nontrivial fibre contains a two.  Its ¬ß‡ counting
-- and this floor are the same fact at two altitudes.
------------------------------------------------------------------------

module Dvayam_AnyLossEmbedsABitSoTwoIsTheSmallestVeilThereIs where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

private variable ‚Ñì : Level

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) {a a' : A}
         (‡§∏‡§ô‡•ç‡§ï‡§∞‡§É : f a ‚â° f a')          -- the map confuses them
         (‡§≠‡•á‡§¶‡§É : ¬¨ (a ‚â° a'))            -- and they are not the same
         where

------------------------------------------------------------------------
-- ‡ß ¬ ‡¶‡‡µ‡ø-‡®‡‡Ø‡æ‡‡ ‚î the two points, placed in one fibre.
------------------------------------------------------------------------

  ‡§¶‡•ç‡§µ‡§ø-‡§®‡•ç‡§Ø‡§æ‡§∏‡§É : Bool ‚Üí fiber f (f a)
  ‡§¶‡•ç‡§µ‡§ø-‡§®‡•ç‡§Ø‡§æ‡§∏‡§É true  = a  , refl
  ‡§¶‡•ç‡§µ‡§ø-‡§®‡•ç‡§Ø‡§æ‡§∏‡§É false = a' , sym ‡§∏‡§ô‡•ç‡§ï‡§∞‡§É

------------------------------------------------------------------------
-- ‡® ¬ ‡®‡‡Ø‡æ‡‡ ‡®‡ø‡µ‡‡‡ ‚î and the placement is injective, so the fibre
--     genuinely contains a two.  There is no losing less than a bit.
------------------------------------------------------------------------

  ‡§¶‡•ç‡§µ‡§ø-‡§®‡§ø‡§µ‡•á‡§∂‡§É : (x y : Bool) ‚Üí ‡§¶‡•ç‡§µ‡§ø-‡§®‡•ç‡§Ø‡§æ‡§∏‡§É x ‚â° ‡§¶‡•ç‡§µ‡§ø-‡§®‡•ç‡§Ø‡§æ‡§∏‡§É y ‚Üí x ‚â° y
  ‡§¶‡•ç‡§µ‡§ø-‡§®‡§ø‡§µ‡•á‡§∂‡§É true  true  _ = refl
  ‡§¶‡•ç‡§µ‡§ø-‡§®‡§ø‡§µ‡•á‡§∂‡§É false false _ = refl
  ‡§¶‡•ç‡§µ‡§ø-‡§®‡§ø‡§µ‡•á‡§∂‡§É true  false p = Empty.rec (‡§≠‡•á‡§¶‡§É (cong fst p))
    where open import Cubical.Data.Empty as Empty using ()
  ‡§¶‡•ç‡§µ‡§ø-‡§®‡§ø‡§µ‡•á‡§∂‡§É false true  p = Empty.rec (‡§≠‡•á‡§¶‡§É (sym (cong fst p)))
    where open import Cubical.Data.Empty as Empty using ()
