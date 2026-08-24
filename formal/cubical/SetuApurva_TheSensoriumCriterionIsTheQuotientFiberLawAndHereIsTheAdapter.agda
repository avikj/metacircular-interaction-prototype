-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सेतु-अपूर्वम् — इन्द्रिय-प्रमाणं तत्त्वतः तन्तु-विधिः ; अयं सेतुः ।
--
-- (the sensorium criterion IS the quotient/fiber law; this is the adapter.)
--
-- AN EDGE, NOT A NODE.  `Setubandha` measures this corpus at 196 nodes, 143
-- edges, 73 components, 93% of defined types isolated.  Costumes are cheap
-- here and there are already twelve; what is scarce is the identification
-- between two of them, constructed rather than asserted.
--
-- `NaturalMachine.QuotientFiberLaw`'s own header says what it wants:
--
--     "The other eleven costumes now have a single hook to be instantiated
--      against, one by one, each instantiation a `refl`-grade adapter rather
--      than a note."
--
-- `ApurvaIndriyam_…` was written as a note — a standalone module proving,
-- for an arbitrary reading S and proposal q, that a blind pair separated by
-- q refutes every derivation of q from S.  That is the same law, and saying
-- so in prose is worth nothing.  This module says it as a term:
--
--     collision-obstructs, the Law's own fiber-invisibility statement, is
--     `अपूर्वम्` applied.
--
-- WHAT THE PIECES CORRESPOND TO.  Reading the Law's definitions as a
-- sensorium: `obs os : X → List Bool` IS a reading S, its transcript the
-- observation; `AllBlind os x y` gives `obs os x ≡ obs os y` by `obs-agree`,
-- which is a blind pair; `FactorsThrough os t` is `प्रवहति (obs os) t` with
-- the equation reversed, so §1 is `sym` and nothing more; and `t x ≡ not (t y)`
-- is separation at the two-valued codomain, so §3 converts it by `notFix`.
--
-- DIRECTION, and it is not symmetric.  This derives THEIRS from MINE.  The
-- reverse does not follow: `अपूर्वम्` quantifies over an arbitrary codomain Q
-- while `collision-obstructs` is stated at `Bool` with separation as `≡ not`,
-- so the Law's statement is an instance of the general one.  In exchange the
-- Law carries what this side does not — `charged⇒separator` CONSTRUCTS the
-- separator where `अपूर्वम्` only refutes, plus `law`'s iff and `not-both`'s
-- exclusivity.  Neither module subsumes the other; this edge is the part that
-- can be built, and the part that cannot is named here rather than left for a
-- reader to discover.
--
-- HOW IT WAS BUILT, because the method is the point.  Not by writing the
-- module and spawning a cold `agda --safe` for a one-bit verdict.  Through
-- `machine/Nadi.hs`, the warm conduit: load the skeleton with `?`, the kernel
-- answers `holes: 0 1`, `goal 0` answers `प्रवहति (obs os) t`, fill, reload,
-- `छिद्रं नास्ति`.  Four exchanges against one warm elaborator.  The batch
-- interface is a boolean verdict on a many-valued state — the corpus's own
-- durnaya, arriving as interface design (msg 0920).
------------------------------------------------------------------------

module SetuApurva_TheSensoriumCriterionIsTheQuotientFiberLawAndHereIsTheAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; not ; true ; false ; true≢false)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.QuotientFiberLaw
open import ApurvaIndriyam_AMapThatFactorsIsBlindOnTheFibresSoASeparatedBlindPairCertifiesANewSense
  using (प्रवहति ; तन्तौ-अन्धः ; अपूर्वम्)

module _ (X : Type) where
  open Law X

  ----------------------------------------------------------------------
  -- १ · The Law's `FactorsThrough` IS `प्रवहति` of the transcript reading.
  -- Only the equation's direction differs, so the whole content is `sym`.
  ----------------------------------------------------------------------

  प्रवहति-तः : (os : List Query) (t : X → Bool)
             → FactorsThrough os t → प्रवहति (obs os) t
  प्रवहति-तः os t (g , comm) = g , λ x → sym (comm x)

  ----------------------------------------------------------------------
  -- २ · Separation at Bool: a flipped pair is an unequal pair.
  ----------------------------------------------------------------------

  notFix : (b : Bool) → ¬ (b ≡ not b)
  notFix true  e = true≢false e
  notFix false e = true≢false (sym e)

  ----------------------------------------------------------------------
  -- ३ · THE EDGE.  `collision-obstructs`, derived from `अपूर्वम्`.
  --
  -- `obs-agree` turns AllBlind into the blind pair; `notFix` turns the flip
  -- into separation; §१ turns FactorsThrough into प्रवहति.  Then it is the
  -- general criterion applied, and nothing else happens.
  ----------------------------------------------------------------------

  collision-obstructs-from-अपूर्वम् :
      (os : List Query) (t : X → Bool) (x y : X)
    → AllBlind os x y → t x ≡ not (t y)
    → ¬ FactorsThrough os t
  collision-obstructs-from-अपूर्वम् os t x y bs c fac =
    अपूर्वम् (obs os) t x y
      (obs-agree os x y bs)
      (λ p → notFix (t y) (sym p ∙ c))
      (प्रवहति-तः os t fac)

------------------------------------------------------------------------
-- मर्यादा, at the site.
--
-- * This is one edge.  `ApurvaIndriyam` remains a costume of the Law and
--   should be read as one; the honest effect of this module is to make that
--   readable by the kernel instead of asserted in a header.
-- * `SamacaranaNityam`, `ParimanaAndha`, `TiryakTantu`, `EkaVidhih` and
--   `SamuhaDrstih` are the same session's other five costumes and are NOT
--   adapted here.  Naming them is cheaper than leaving the reader to count.
-- * The reverse derivation is not attempted and §head says why it would not
--   go through unchanged.
------------------------------------------------------------------------
