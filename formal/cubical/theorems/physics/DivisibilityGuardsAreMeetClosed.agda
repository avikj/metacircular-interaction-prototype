{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DivisibilityGuardsAreMeetClosed
--
-- corpus-native intersection-closed guard family ‚î the divisibility
-- guards, with `D_d ‚à© D_e = D_lcm(d,e)` ‚î and says of it:
--
--   "PROVED on paper in one line from unique factorisation; **not**
--    mechanised here ‚î the Agda module carries no divisibility
--    instance."
--
-- Mechanised here, and WITHOUT unique factorisation: the meet law is
-- exactly the lcm's universal property, so it needs no factorisation at
-- all.  That is a narrowing of ¬ß6.1's own account of its proof, offered
-- for its author (¬ß4 below), not applied.
--
-- Cubical v0.5 has no lcm module.  Per the standing idiom in this
-- corpus, the lcm is therefore taken by its universal property rather
-- than constructed: `IsLcm d e l` says l is a common multiple that
-- divides every common multiple.  Nothing below asserts that such an l
-- exists ‚î existence is a separate obligation and is NOT discharged.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS DOES NOT DO, and it is the interesting half
--
-- This does NOT become an instance of `ElsewhereCondition.directedRooted`.
-- I read that module: its `Guard A = A ‚í Bool`, so a guard there is a
-- DECISION, while `D d` below is a Œ ‚î a search for the cofactor.
-- Turning `D d` into a `Guard` is exactly the step of deciding
-- divisibility, which is available for ‚ï but is not free and is not
-- done here.  So ¬ß6.1's family is meet-closed as stated, and is still
-- not plugged in, and the thing standing between them is a decision.
--
-- That is the same axis as
-- `AskingIsNotAPropertyOfTheFunction` and
-- `PermanentUnsaidIsStableAndTemporaryIsASearch`, met
-- here from a third direction and not by design.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 ‚î container pin.  --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module DivisibilityGuardsAreMeetClosed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; _¬∑_ ; ¬∑-assoc)
open import Cubical.Data.Sigma

------------------------------------------------------------------------
-- 1.  Divisibility, and the guard it names
------------------------------------------------------------------------

_divides_ : ‚Ñï ‚Üí ‚Ñï ‚Üí Type
d divides x = Œ£[ k ‚àà ‚Ñï ] (x ‚â° k ¬∑ d)

-- the guard "d divides the point"
D : ‚Ñï ‚Üí ‚Ñï ‚Üí Type
D d x = d divides x

divides-trans : {a b c : ‚Ñï} ‚Üí a divides b ‚Üí b divides c ‚Üí a divides c
divides-trans {a} {b} {c} (k , b‚â°ka) (j , c‚â°jb) =
  j ¬∑ k , c‚â°jb ‚àô cong (j ¬∑_) b‚â°ka ‚àô ¬∑-assoc j k a

------------------------------------------------------------------------
-- 2.  The lcm by its universal property ‚î no construction, no
--     factorisation
------------------------------------------------------------------------

record IsLcm (d e l : ‚Ñï) : Type where
  field
    d‚à£l   : d divides l
    e‚à£l   : e divides l
    least : (m : ‚Ñï) ‚Üí d divides m ‚Üí e divides m ‚Üí l divides m

open IsLcm public

------------------------------------------------------------------------
-- 3.  THE MEET LAW.  D_l is exactly D_d ‚à© D_e, pointwise, both ways.
------------------------------------------------------------------------

lcmGuard‚Üíboth :
  {d e l : ‚Ñï} ‚Üí IsLcm d e l ‚Üí (x : ‚Ñï) ‚Üí D l x ‚Üí (D d x √ó D e x)
lcmGuard‚Üíboth isl x lx =
  divides-trans (isl .d‚à£l) lx , divides-trans (isl .e‚à£l) lx

both‚ÜílcmGuard :
  {d e l : ‚Ñï} ‚Üí IsLcm d e l ‚Üí (x : ‚Ñï) ‚Üí (D d x √ó D e x) ‚Üí D l x
both‚ÜílcmGuard isl x (dx , ex) = isl .least x dx ex

-- and therefore the directedness hypothesis ¬ß2 asks for, at any point
-- where both guards fire: a third guard that fires there and is narrower
-- than both EVERYWHERE, not just at that point.
divisibilityIsDirected :
  {d e l : ‚Ñï} ‚Üí IsLcm d e l ‚Üí (x : ‚Ñï) ‚Üí D d x ‚Üí D e x
  ‚Üí (D l x) √ó ((y : ‚Ñï) ‚Üí D l y ‚Üí (D d y √ó D e y))
divisibilityIsDirected isl x dx ex =
    both‚ÜílcmGuard isl x (dx , ex)
  , lcmGuard‚Üíboth isl

------------------------------------------------------------------------
-- 4.  A narrowing offered to ¬ß6.1, NOT applied
--
-- ¬ß6.1 says the meet law is "PROVED on paper in one line from unique
-- factorisation".  ¬ß3 uses no factorisation: `both‚ílcmGuard` IS the
-- universal property applied, and `lcmGuard‚íboth` is two transitivities.
-- Unique factorisation is needed for a different sentence in the same
-- paragraph ‚î that `D_d ‚ãê D_e` iff `v_p(e) ‚â v_p(d)` for every p, which
-- is genuinely about valuations and is NOT proved here.
--
-- Suggested replacement, for that note's author to take or leave:
--
--   "the meet law is the lcm's universal property and needs no
--    factorisation; unique factorisation is what turns the containment
--    order into the valuation coordinate."
--
-- The existence of the lcm is a third statement again, and none of the
-- three is discharged by the other two.  Nothing here constructs one.
------------------------------------------------------------------------
