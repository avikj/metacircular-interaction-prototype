{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡-‡‡‡‡∞‡‡µ‡Æ‡ ‚î ‡‡®‡‡¶‡‡∞‡ø‡Ø-‡‡‡∞‡Æ‡æ‡‡ ‡‡‡‡‡‡µ‡‡ ‡‡®‡‡‡-‡µ‡ø‡ß‡ø‡ ; ‡‡Ø‡ ‡‡‡‡‡ ‡
--
-- (the sensorium criterion IS the quotient/fiber law; this is the adapter.)
--
-- AN EDGE, NOT A NODE.  `Setubandha` measures this corpus at 196 nodes, 143
-- edges, 73 components, 93% of defined types isolated.  Costumes are cheap
-- here and there are already twelve; what is scarce is the identification
-- between two of them, constructed rather than asserted.
--
-- `QuotientFiberLaw`'s own header says what it wants:
--
--     "The other eleven costumes now have a single hook to be instantiated
--      against, one by one, each instantiation a `refl`-grade adapter rather
--      than a note."
--
-- `ApurvaIndriyam_‚¶` was written as a note ‚î a standalone module proving,
-- for an arbitrary reading S and proposal q, that a blind pair separated by
-- q refutes every derivation of q from S.  That is the same law, and saying
-- so in prose is worth nothing.  This module says it as a term:
--
--     collision-obstructs, the Law's own fiber-invisibility statement, is
--     `‡‡‡‡∞‡‡µ‡Æ‡` applied.
--
-- WHAT THE PIECES CORRESPOND TO.  Reading the Law's definitions as a
-- sensorium: `obs os : X ‚í List Bool` IS a reading S, its transcript the
-- observation; `AllBlind os x y` gives `obs os x ‚â° obs os y` by `obs-agree`,
-- which is a blind pair; `FactorsThrough os t` is `‡‡‡∞‡µ‡‡‡ø (obs os) t` with
-- the equation reversed, so ¬ß1 is `sym` and nothing more; and `t x ‚â° not (t y)`
-- is separation at the two-valued codomain, so ¬ß3 converts it by `notFix`.
--
-- DIRECTION, and it is not symmetric.  This derives THEIRS from MINE.  The
-- reverse does not follow: `‡‡‡‡∞‡‡µ‡Æ‡` quantifies over an arbitrary codomain Q
-- while `collision-obstructs` is stated at `Bool` with separation as `‚â° not`,
-- so the Law's statement is an instance of the general one.  In exchange the
-- Law carries what this side does not ‚î `charged‚íseparator` CONSTRUCTS the
-- separator where `‡‡‡‡∞‡‡µ‡Æ‡` only refutes, plus `law`'s iff and `not-both`'s
-- exclusivity.  Neither module subsumes the other; this edge is the part that
-- can be built, and the part that cannot is named here rather than left for a
-- reader to discover.
--
-- HOW IT WAS BUILT, because the method is the point.  Not by writing the
-- module and spawning a cold `agda --safe` for a one-bit verdict.  Through
-- `interactive/Nadi.hs`, the warm conduit: load the skeleton with `?`, the kernel
-- answers `holes: 0 1`, `goal 0` answers `‡‡‡∞‡µ‡‡‡ø (obs os) t`, fill, reload,
-- `‡‡ø‡¶‡‡∞‡ ‡®‡æ‡‡‡‡ø`.  Four exchanges against one warm elaborator.  The batch
-- interface is a boolean verdict on a many-valued state ‚î the corpus's own
-- durnaya, arriving as interface design (msg 0920).
------------------------------------------------------------------------

module SetuApurva_TheSensoriumCriterionIsTheQuotientFiberLawAndHereIsTheAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; not ; true ; false ; true‚â¢false)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import QuotientFiberLaw
open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense
  using (‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø ; ‡§§‡§®‡•ç‡§§‡•å-‡§Ö‡§®‡•ç‡§ß‡§É ; ‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç)

module _ (X : Type) where
  open Law X

  ----------------------------------------------------------------------
  -- ‡ß ¬ The Law's `FactorsThrough` IS `‡‡‡∞‡µ‡‡‡ø` of the transcript reading.
  -- Only the equation's direction differs, so the whole content is `sym`.
  ----------------------------------------------------------------------

  ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø-‡§§‡§É : (os : List Query) (t : X ‚Üí Bool)
             ‚Üí FactorsThrough os t ‚Üí ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø (obs os) t
  ‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø-‡§§‡§É os t (g , comm) = g , Œª x ‚Üí sym (comm x)

  ----------------------------------------------------------------------
  -- ‡® ¬ Separation at Bool: a flipped pair is an unequal pair.
  ----------------------------------------------------------------------

  notFix : (b : Bool) ‚Üí ¬¨ (b ‚â° not b)
  notFix true  e = true‚â¢false e
  notFix false e = true‚â¢false (sym e)

  ----------------------------------------------------------------------
  -- ‡© ¬ THE EDGE.  `collision-obstructs`, derived from `‡‡‡‡∞‡‡µ‡Æ‡`.
  --
  -- `obs-agree` turns AllBlind into the blind pair; `notFix` turns the flip
  -- into separation; ¬ß‡ß turns FactorsThrough into ‡‡‡∞‡µ‡‡‡ø.  Then it is the
  -- general criterion applied, and nothing else happens.
  ----------------------------------------------------------------------

  collision-obstructs-from-‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç :
      (os : List Query) (t : X ‚Üí Bool) (x y : X)
    ‚Üí AllBlind os x y ‚Üí t x ‚â° not (t y)
    ‚Üí ¬¨ FactorsThrough os t
  collision-obstructs-from-‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç os t x y bs c fac =
    ‡§Ö‡§™‡•Ç‡§∞‡•ç‡§µ‡§Æ‡•ç (obs os) t x y
      (obs-agree os x y bs)
      (Œª p ‚Üí notFix (t y) (sym p ‚àô c))
      (‡§™‡•ç‡§∞‡§µ‡§π‡§§‡§ø-‡§§‡§É os t fac)

------------------------------------------------------------------------
-- ‡Æ‡∞‡‡Ø‡æ‡¶‡æ, at the site.
--
-- * This is one edge.  `ApurvaIndriyam` remains a costume of the Law and
--   should be read as one; the honest effect of this module is to make that
--   readable by the kernel instead of asserted in a header.
-- * `SamacaranaNityam`, `ParimanaAndha`, `TiryakFiber`, `EkaVidhih` and
--   `SetDrstih` are the same session's other five costumes and are NOT
--   adapted here.  Naming them is cheaper than leaving the reader to count.
-- * The reverse derivation is not attempted and ¬ßhead says why it would not
--   go through unchanged.
------------------------------------------------------------------------
