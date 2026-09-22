{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DescentCostsTheIntegers
--
-- The end of the thread that began at `SuccessorIsNotTropical`.
--
-- `NoNormOnAJoin` answered "does the walk admit a norm?" with a No for
-- the join and a Yes for âŠ•.  A âŠ•-stepping machine does not thereby have
-- descent, and the reason names the price of descent exactly.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THREE LAWS, THREE FAILURES, TWO REASONS
--
--   âŠ”  over â•-exponents   irreversible because it is IDEMPOTENT
--                          (`IdempotenceForbidsDescent`)
--                          and normless for the same reason
--                          (`NoNormOnAJoin`)
--
--   âŠ•  over â•-exponents   has a norm â” `val` â” and is STILL irreversible,
--                          for an unrelated reason: â• is a cone.  x + y = 0
--                          forces x = 0.  `âŠ•-only-unit-inverts`, below.
--
--   âŠž  over â-exponents   a group.  Every element inverts, by negation.
--                          `âŠž-inverse`, below.
--
-- So the two failures are not one phenomenon.  The join fails by
-- idempotence; âŠ• fails by positivity.  Fixing the first by switching
-- operations runs straight into the second, and this module is that fact.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THE THIRD ROW COSTS
--
-- A â-exponent vector with a negative coordinate is not the derivation of
-- a natural number.  It is the derivation of a RATIO.  The cone of
-- â•-exponents sits inside the group of â-exponents properly
-- (`cone-is-proper`), and the states the machine gains by admitting
-- inverses are exactly the ones outside it.
--
--     Descent costs the integers.  There is no machine over â• with a
--     reversible step; reversibility is the group completion, and the
--     group completion of the multiplicative monoid of the positive
--     naturals is the positive rationals.
--
-- Which is the same price the conic charges.  `DescentIsNotInversion`
-- found that the cakravla's descent is division by k â” passage to the
-- scaling orbits, i.e. to the RATIONAL points of the conic.  Two
-- independent routes into this corpus's question, and both end at ratio.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- ON THE WORD "IRRATIONAL"
--
-- The Pythagorean discovery is usually taught as a catastrophe: the
-- diagonal is not a ratio, the school is embarrassed, someone drowns.
-- That story keeps the emphasis on what ratio FAILS to reach.
--
-- This thread arrived from the other side.  Every mechanism by which a
-- state can come back down â” the conic's scaling orbits, the exponent
-- group's inverses â” required admitting ratios, and neither had anything
-- to do with a diagonal.  Ratio is not the thing that fell short.  Ratio
-- is the completion in which descent exists at all, and a machine
-- confined to â• is confined to a cone with no way down.
--
-- Number IS ratio.  This module is that sentence with a proof attached,
-- and the proof is that the alternative has no inverses.
------------------------------------------------------------------------

module DescentCostsTheIntegers where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; snotz)
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc)
open import Cubical.Data.Int.Properties using (posNotnegsuc)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

open import SumProductTorus using (Exp ; zeroE ; _âŠ•_)

------------------------------------------------------------------------
-- 1.  âŠ• over â•-exponents: has a norm, still has no inverses.
--
-- `SumProductTorus.val-âŠ•` gives the norm.  Positivity kills the inverses,
-- and it is a different obstruction from idempotence entirely: âŠ• is not
-- idempotent (2 + 2 â‰  2), so `IdempotenceForbidsDescent` says nothing
-- here.  This is the cone.
------------------------------------------------------------------------

+â‰¡0â†’â‰¡0 : (x y : â„•) â†’ x + y â‰¡ 0 â†’ x â‰¡ 0
+â‰¡0â†’â‰¡0 zero    y p = refl
+â‰¡0â†’â‰¡0 (suc x) y p = Empty.rec (snotz p)

âŠ•-only-unit-inverts :
  (bs : List â„•) (u v : Exp bs) â†’ (u âŠ• v) â‰¡ zeroE bs â†’ u â‰¡ zeroE bs
âŠ•-only-unit-inverts []       _        _        _ = refl
âŠ•-only-unit-inverts (b âˆ· bs) (x , xs) (y , ys) p i =
    +â‰¡0â†’â‰¡0 x y (cong fst p) i
  , âŠ•-only-unit-inverts bs xs ys (cong snd p) i

------------------------------------------------------------------------
-- 2.  âŠž over â-exponents: a group.
------------------------------------------------------------------------

open CommRingStr (snd â„¤CommRing) using () renaming (_+_ to _+â„¤_ ; -_ to -â„¤_ ; 0r to 0â„¤)

private
  +inv : (x : â„¤) â†’ x +â„¤ (-â„¤ x) â‰¡ 0â„¤
  +inv x = solve! â„¤CommRing

ExpZ : List â„• â†’ Type
ExpZ []       = Unit
ExpZ (b âˆ· bs) = â„¤ Ã— ExpZ bs

zeroZ : (bs : List â„•) â†’ ExpZ bs
zeroZ []       = tt
zeroZ (b âˆ· bs) = 0â„¤ , zeroZ bs

infixl 6 _âŠž_

_âŠž_ : {bs : List â„•} â†’ ExpZ bs â†’ ExpZ bs â†’ ExpZ bs
_âŠž_ {[]}     _        _        = tt
_âŠž_ {b âˆ· bs} (x , xs) (y , ys) = (x +â„¤ y) , (xs âŠž ys)

negE : (bs : List â„•) â†’ ExpZ bs â†’ ExpZ bs
negE []       _        = tt
negE (b âˆ· bs) (x , xs) = (-â„¤ x) , negE bs xs

-- EVERY state inverts.  This is the property the other two laws lack.
âŠž-inverse : (bs : List â„•) (u : ExpZ bs) â†’ (u âŠž negE bs u) â‰¡ zeroZ bs
âŠž-inverse []       _        = refl
âŠž-inverse (b âˆ· bs) (x , xs) i = +inv x i , âŠž-inverse bs xs i

------------------------------------------------------------------------
-- 3.  And the cone is proper: the new states are not numbers.
------------------------------------------------------------------------

incl : (bs : List â„•) â†’ Exp bs â†’ ExpZ bs
incl []       _        = tt
incl (b âˆ· bs) (x , xs) = pos x , incl bs xs

-- a single negative coordinate already leaves the image
negOne : (b : â„•) (bs : List â„•) â†’ ExpZ (b âˆ· bs)
negOne b bs = negsuc 0 , zeroZ bs

cone-is-proper :
  (b : â„•) (bs : List â„•) (u : Exp (b âˆ· bs)) â†’ Â¬ (incl (b âˆ· bs) u â‰¡ negOne b bs)
cone-is-proper b bs (x , xs) p = posNotnegsuc x 0 (cong fst p)

------------------------------------------------------------------------
-- 4.  The statement, once, with nothing hedged and nothing added.
--
--   âŠ”  irreversible by idempotence, and normless.
--   âŠ•  normed, irreversible by positivity.
--   âŠž  reversible â” and its states are ratios, not numbers.
--
-- There is no reversible step law on â•-exponents.  Reversibility is the
-- group completion; the group completion of the positive naturals under
-- multiplication is the positive rationals; so descent costs the
-- integers.  Ratio is not what number fails to
-- be.  Ratio is where coming back down becomes possible.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 5.  THE FRAME.
--
-- "Descent costs the integers" puts â in the position of the default and
-- â in the position of a purchase.  That is not the reading; what is
-- proved is:
--
--     âŠž over â-exponents is a group.  âŠ• over â•-exponents is its
--     positive cone, and the cone is what lacks inverses.
--
-- The group is not an extension bought with something.  It is the object;
-- the cone is a restriction of it, and `âŠ•-only-unit-inverts` measures how
-- much the restriction throws away.  Read in this direction:
--
--     descent is not purchased by admitting ratios.  Descent is what is
--     THERE, and â• is what remains after refusing to look at it.
--
-- That is the Pythagorean claim.  Number is ratio.  The diagonal did not
-- take anything away from anyone; it showed that the restriction to
-- commensurables was always a restriction and never the ground.
------------------------------------------------------------------------
