{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡æ‡∞-‡‡µ‡‡‡‡‡ø ‚î ‡‡æ‡∞‡µ‡‡‡Ø‡æ‡ ‡ó‡‡®‡æ-‡ï‡‡∞‡ø‡Ø‡æ‡Ø‡æ‡ ‡‡®‡‡‡‡ ‡‡ø‡∞‡ã-‡‡æ‡∞‡‡ ‡‡ø‡¶‡‡Ø‡‡ ‡
--
-- (the fibre of a weighted counting map splits by the head's weight.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- `Avrtti_‚¶agda` ¬ß‡ names this as its next rung, in its own words:
-- `length` charges one per constructor so its fibre recurrence has no
-- guard, while a WEIGHTED map does, "and the general weighted emitter is
-- not written here."  It even gives the shape it would have.  This writes
-- it.
--
-- THE CORRECTION TO THAT SHAPE, and it is why the rung is a rung.  ¬ß‡
-- proposes
--
--     fiber f n ‚â Œ[ x ‚àà X ] Œ[ m ‚àà ‚ï ] (w x + m ‚â° n) ó fiber f m
--
-- which cannot hold as stated: the empty list inhabits `fiber f 0` and
-- has no head `x` to produce.  The nil case is a SEPARATE SUMMAND, and
-- the honest decomposition is a coproduct ‚î ¬ß‡® below.  With it the
-- recurrence is exact and both round trips close by `refl`, because
-- `f (x ‚à xs)` reduces to `w x + f xs` definitionally and no fitting
-- proof has to be constructed at all.
--
-- AND WHY ¬ß‡'s `Œ[ m ]` FORM IS EQUIVALENT ANYWAY, which is worth saying
-- because it is the corpus's own law: `Œ[ m ‚àà ‚ï ] (f xs ‚â° m) ó ‚¶` carries
-- a `singl (f xs)`, which is contractible, so the `m` and its witness
-- contract away and the form collapses to ¬ß‡®'s.  The intermediate value
-- rides free ‚î `fibre/src/Loss/Carrier.agda`, and `Lekha_‚¶agda` for the
-- same fact at length.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Bharavrtti_TheWeightedCountingMapsFibreDecomposesByHeadWeightAndTheNilCaseIsASeparateSummand where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; fiber)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv ; Iso)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)

private variable ‚Ñì : Level

module _ {X : Type ‚Ñì} (w : X ‚Üí ‚Ñï) where

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡æ‡∞-‡ó‡‡®‡æ ‚î the weighted counting map: charge `w x` per element.
------------------------------------------------------------------------

  ‡§≠‡§æ‡§∞‡§É : List X ‚Üí ‚Ñï
  ‡§≠‡§æ‡§∞‡§É []       = 0
  ‡§≠‡§æ‡§∞‡§É (x ‚à∑ xs) = w x + ‡§≠‡§æ‡§∞‡§É xs

------------------------------------------------------------------------
-- ‡® ¬ ‡‡µ‡‡‡‡‡ø‡ ‚î the fibre decomposes: the nil case, or a head with its
--     weight fitting into what remains.
--
-- Both round trips are `refl`: `‡‡æ‡∞‡ (x ‚à xs)` reduces to `w x + ‡‡æ‡∞‡ xs`,
-- so the "fitting proof" ¬ß‡ expected to construct is the SAME path,
-- carried across unchanged.
------------------------------------------------------------------------

  ‡§≠‡§æ‡§∞-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (n : ‚Ñï)
    ‚Üí fiber ‡§≠‡§æ‡§∞‡§É n ‚âÉ ((0 ‚â° n) ‚äé (Œ£[ x ‚àà X ] Œ£[ xs ‚àà List X ] (w x + ‡§≠‡§æ‡§∞‡§É xs ‚â° n)))
  ‡§≠‡§æ‡§∞-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É n = isoToEquiv (iso ‡§≠‡§ô‡•ç‡§ó‡§É ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É)
    where
      ‡§≠‡§ô‡•ç‡§ó‡§É : fiber ‡§≠‡§æ‡§∞‡§É n ‚Üí ((0 ‚â° n) ‚äé (Œ£[ x ‚àà X ] Œ£[ xs ‚àà List X ] (w x + ‡§≠‡§æ‡§∞‡§É xs ‚â° n)))
      ‡§≠‡§ô‡•ç‡§ó‡§É ([]     , p) = inl p
      ‡§≠‡§ô‡•ç‡§ó‡§É (x ‚à∑ xs , p) = inr (x , xs , p)

      ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É : ((0 ‚â° n) ‚äé (Œ£[ x ‚àà X ] Œ£[ xs ‚àà List X ] (w x + ‡§≠‡§æ‡§∞‡§É xs ‚â° n))) ‚Üí fiber ‡§≠‡§æ‡§∞‡§É n
      ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (inl p)            = [] , p
      ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (inr (x , xs , q)) = (x ‚à∑ xs) , q

      ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (y : _) ‚Üí ‡§≠‡§ô‡•ç‡§ó‡§É (‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É y) ‚â° y
      ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (inl p)            = refl
      ‡§®‡§ø‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (inr (x , xs , q)) = refl

      ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É : (y : fiber ‡§≠‡§æ‡§∞‡§É n) ‚Üí ‡§∏‡§ô‡•ç‡§ò‡§æ‡§§‡§É (‡§≠‡§ô‡•ç‡§ó‡§É y) ‚â° y
      ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É ([]     , p) = refl
      ‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§æ‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É (x ‚à∑ xs , p) = refl


------------------------------------------------------------------------
-- ‡© ¬ ‡‡µ‡‡‡‡‡ø‡ ‡µ‡ø‡®‡æ ‡‡‡µ‡∞‡‡‡®‡‡® ‚î the recurrence with NO subtraction.
--
-- The usual weighted recurrence is written with `n ‚à w x`, which over ‚ï
-- is truncated and needs a guard that `w x ‚â n`.  Clearing it the way
-- `BhavanaSemiring.agda` clears bhvan -- move the subtraction across
-- rather than truncate -- gives a statement with no monus, no guard, and
-- no side condition: the fibre is a coproduct of SHIFTED fibres.
--
-- `ANEKANTA.md` ¬ß7's lesson, on a different object: a statement forced
-- into the poorer language got stronger, because the guard was an
-- artefact of the subtraction and not of the mathematics.
------------------------------------------------------------------------

  ‡§∂‡§ø‡§∑‡•ç‡§ü-‡§≠‡§æ‡§∞‡§É : X ‚Üí List X ‚Üí ‚Ñï
  ‡§∂‡§ø‡§∑‡•ç‡§ü-‡§≠‡§æ‡§∞‡§É x xs = w x + ‡§≠‡§æ‡§∞‡§É xs

  ‡§≠‡§æ‡§∞-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§®‡§ø‡§∞‡§™‡§µ‡§∞‡•ç‡§§‡§®‡§æ : (n : ‚Ñï)
    ‚Üí fiber ‡§≠‡§æ‡§∞‡§É n ‚âÉ ((0 ‚â° n) ‚äé (Œ£[ x ‚àà X ] fiber (‡§∂‡§ø‡§∑‡•ç‡§ü-‡§≠‡§æ‡§∞‡§É x) n))
  ‡§≠‡§æ‡§∞-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É-‡§®‡§ø‡§∞‡§™‡§µ‡§∞‡•ç‡§§‡§®‡§æ = ‡§≠‡§æ‡§∞-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É
