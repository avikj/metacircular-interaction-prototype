{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TwoProfilesSuffice
--
-- CORRECTION TO `OneLemmaFiveSites` Â§3 AND ITS HEADER.
--
-- That module drew a distinction between two routes to `Â FactorsThrough`:
--
--   COLLISION   exhibit two points the coarse map identifies and the
--               fine map separates; one pair kills every decoder.
--   EXHAUSTION  when the decoders are a small finite set, refute each in
--               turn.
--
-- and filed `Saptabhangi.no-single-vacana` under EXHAUSTION with the
-- reason: *"no single pair of profiles separates the joint content from
-- every utterance, because different utterances fail on different
-- profiles."*
--
-- The distinction is real.  That reason is false, and this module gives
-- the pair.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS ACTUALLY TRUE
--
--   ONE profile never suffices â” Â§2.  For every Ï there is an utterance
--   agreeing with the joint content on it, so no single profile refutes
--   the whole language.  That much of the prose was right, and it is now
--   a theorem rather than an observation.
--
--   TWO profiles do â” Â§3.  Ïâ = (âŠ,âŠ,âŠ) and Ïâ = (âŠ,âŠ,âŠ).  The joint
--   content is false on both, and each of the six utterances says `true`
--   on one of them.  Their agreement sets are
--
--       at Ïâ   { asti kernel-ind , nsti rewriter , nsti kernel-refl }
--       at Ïâ   { asti rewriter , asti kernel-refl , nsti kernel-ind }
--
--   which are complementary â” disjoint, and together all six.  So the
--   pair separates, and `avaktavya-does-not-factor` follows from two
--   witnesses rather than from a six-fold case analysis.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THE CORRECTED DISTINCTION IS
--
-- Not collision-versus-exhaustion.  The real invariant is the NUMBER OF
-- WITNESSES an absence needs:
--
--     à²à¾à˜àµ, àà¨ààµààààà¿, carry/borrow, the fuel obstructions   1
--     ààµà•àààµàà¯                                              2
--
-- and 6 was never the answer â” it was the size of the decoder space,
-- which is an upper bound anyone can read off, not a measure of the
-- absence.  In Navya-Nyya terms the witnesses are the *avacchedaka*,
-- the delimitor that makes an abhva over an infinite pratiyogin-space
-- exact; counting them measures the absence, counting the pratiyogins
-- measures only the language.
--
-- This bears on the standing deflationary thread.  It does not move
-- anything up the abhva tower â” the absence here was exact before and
-- is exact now â” but it says the earlier reading was measuring the
-- wrong thing, and that a "must be exhaustive" verdict is a claim about
-- witness count that has to be proved, not read off a finite type.
------------------------------------------------------------------------

module TwoProfilesSuffice where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; _and_ ; trueâ‰¢false ; falseâ‰¢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠ_ ; inl ; inr)
open import Cubical.Relation.Nullary using (Â¬_)

open import SaptabhangiNaya
  using ( Naya ; rewriter ; kernel-refl ; kernel-ind
        ; Profile ; mk ; Vacana ; asti-from ; nasti-from
        ; denotes ; joint )

------------------------------------------------------------------------
-- 1.  Saying it, and separating it
------------------------------------------------------------------------

Says : Vacana â†’ Profile â†’ Typeâ‚€
Says v Ï† = denotes v Ï† â‰¡ joint Ï†

Separates : Profile â†’ Profile â†’ Typeâ‚€
Separates Ï† Ïˆ = (v : Vacana) â†’ (Â¬ Says v Ï†) âŠ (Â¬ Says v Ïˆ)

------------------------------------------------------------------------
-- 2.  ONE PROFILE IS NEVER ENOUGH
--
-- joint Ï = Ï rewriter âˆ§ Â (Ï kernel-refl).  If `Ï kernel-refl` is
-- false the joint content is just `Ï rewriter`, said by asti-from
-- rewriter; if it is true the joint content is false, and when
-- `Ï rewriter` is also true that is said by nsti-from rewriter.  Every
-- profile falls into one of these.
------------------------------------------------------------------------

every-profile-is-said : (Ï† : Profile) â†’ Î£[ v âˆˆ Vacana ] Says v Ï†
every-profile-is-said Ï† = choose (Ï† rewriter) (Ï† kernel-refl) refl refl
  where
  choose : (a b : Bool) â†’ Ï† rewriter â‰¡ a â†’ Ï† kernel-refl â‰¡ b
         â†’ Î£[ v âˆˆ Vacana ] Says v Ï†
  choose true  true  pa pb =
    nasti-from rewriter , (cong not pa âˆ™ sym (congâ‚‚ _and_ pa (cong not pb)))
  choose true  false pa pb =
    asti-from rewriter , (pa âˆ™ sym (congâ‚‚ _and_ pa (cong not pb)))
  choose false true  pa pb =
    asti-from rewriter , (pa âˆ™ sym (congâ‚‚ _and_ pa (cong not pb)))
  choose false false pa pb =
    asti-from rewriter , (pa âˆ™ sym (congâ‚‚ _and_ pa (cong not pb)))

no-single-separator :
  Â¬ (Î£[ Ï† âˆˆ Profile ] ((v : Vacana) â†’ Â¬ Says v Ï†))
no-single-separator (Ï† , sep) =
  sep (every-profile-is-said Ï† .fst) (every-profile-is-said Ï† .snd)

------------------------------------------------------------------------
-- 3.  TWO PROFILES ARE
------------------------------------------------------------------------

Ï†â‚ : Profile
Ï†â‚ = mk true true false

Ï†â‚‚ : Profile
Ï†â‚‚ = mk false false true

-- the joint content is false on both
joint-Ï†â‚ : joint Ï†â‚ â‰¡ false
joint-Ï†â‚ = refl

joint-Ï†â‚‚ : joint Ï†â‚‚ â‰¡ false
joint-Ï†â‚‚ = refl

-- and every utterance says `true` on one of them
pair-separates : Separates Ï†â‚ Ï†â‚‚
pair-separates (asti-from  rewriter)    = inl trueâ‰¢false
pair-separates (asti-from  kernel-refl) = inl trueâ‰¢false
pair-separates (asti-from  kernel-ind)  = inr trueâ‰¢false
pair-separates (nasti-from rewriter)    = inr trueâ‰¢false
pair-separates (nasti-from kernel-refl) = inr trueâ‰¢false
pair-separates (nasti-from kernel-ind)  = inl trueâ‰¢false

------------------------------------------------------------------------
-- 4.  AVAKTAVYA FROM TWO WITNESSES
------------------------------------------------------------------------

FactorsThroughOneUtterance : Typeâ‚€
FactorsThroughOneUtterance = Î£[ v âˆˆ Vacana ] ((Ï† : Profile) â†’ Says v Ï†)

avaktavya-from-two : Â¬ FactorsThroughOneUtterance
avaktavya-from-two (v , agrees) = split (pair-separates v)
  where
  split : ((Â¬ Says v Ï†â‚) âŠ (Â¬ Says v Ï†â‚‚)) â†’ _
  split (inl bad) = bad (agrees Ï†â‚)
  split (inr bad) = bad (agrees Ï†â‚‚)

------------------------------------------------------------------------
-- 5.  The agreement sets, recorded because they are the content
--
-- Each utterance agrees with the joint content on exactly one of the two
-- profiles, and the three-three split is what makes the pair work.
------------------------------------------------------------------------

says-ki-Ï†â‚ : Says (asti-from kernel-ind) Ï†â‚
says-ki-Ï†â‚ = refl

says-nr-Ï†â‚ : Says (nasti-from rewriter) Ï†â‚
says-nr-Ï†â‚ = refl

says-nk-Ï†â‚ : Says (nasti-from kernel-refl) Ï†â‚
says-nk-Ï†â‚ = refl

says-ar-Ï†â‚‚ : Says (asti-from rewriter) Ï†â‚‚
says-ar-Ï†â‚‚ = refl

says-ak-Ï†â‚‚ : Says (asti-from kernel-refl) Ï†â‚‚
says-ak-Ï†â‚‚ = refl

says-nki-Ï†â‚‚ : Says (nasti-from kernel-ind) Ï†â‚‚
says-nki-Ï†â‚‚ = refl

------------------------------------------------------------------------
-- 6.  What this leaves standing and what it removes.
--
-- STANDS.  `Saptabhangi.no-single-vacana` is correct and is not
-- touched; Â§5 above is literally its six cases regrouped by which
-- profile they use.  `AvaktavyaDoesNotFactor` is correct.  The
-- krama/yugapat contrast â” succession expresses the joint content,
-- simultaneity does not â” is untouched, and that is the Jain point.
--
-- REMOVED.  The claim that exhaustion is FORCED here.  It is not; two
-- witnesses do it, and the six-fold analysis was a convenience.  A
-- verdict of "this one must be exhaustive" is a lower bound on witness
-- count and needs a proof of its own â” Â§2 is that proof for the bound 1,
-- and Â§3 shows the bound is exactly 2.
------------------------------------------------------------------------

--
-- `WitnessNumberIsTwo` fixes one measure â” the least list
-- of points on which no decoder survives â” and under it:
--
--   * one point is NEVER enough for any `FactorsThrough` obstruction,
--     with no hypotheses, because the constant decoder `Î» _ â’ t x`
--     answers any single point;
--   * a collision is exactly a refuting pair;
--   * the ààµà•àààµàà¯ site is 2 as well, by `every-profile-is-said` below
--     for the floor and `pair-separates` for the ceiling.
--
-- So it is 2 versus 2, not 1 versus 2.  What differs between the sites
-- is the ROUTE to the pair â” constructed from a collision, or found by
-- looking â” which is a fact about obtaining the witness, not about the
-- absence.
--
-- The error is the same shape as the one this module was written to
-- correct: a quantity named before a measure was fixed.
------------------------------------------------------------------------
