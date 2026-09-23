{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TwoProfilesSuffice
--
-- CORRECTION TO `OneLemmaFiveSites` ¬ß3 AND ITS HEADER.
--
-- That module drew a distinction between two routes to `¬ FactorsThrough`:
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
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS ACTUALLY TRUE
--
--   ONE profile never suffices ‚î ¬ß2.  For every œ there is an utterance
--   agreeing with the joint content on it, so no single profile refutes
--   the whole language.  That much of the prose was right, and it is now
--   a theorem rather than an observation.
--
--   TWO profiles do ‚î ¬ß3.  œ‚ = (‚ä,‚ä,‚ä) and œ‚ = (‚ä,‚ä,‚ä).  The joint
--   content is false on both, and each of the six utterances says `true`
--   on one of them.  Their agreement sets are
--
--       at œ‚   { asti kernel-ind , nsti rewriter , nsti kernel-refl }
--       at œ‚   { asti rewriter , asti kernel-refl , nsti kernel-ind }
--
--   which are complementary ‚î disjoint, and together all six.  So the
--   pair separates, and `avaktavya-does-not-factor` follows from two
--   witnesses rather than from a six-fold case analysis.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THE CORRECTED DISTINCTION IS
--
-- Not collision-versus-exhaustion.  The real invariant is the NUMBER OF
-- WITNESSES an absence needs:
--
--     ‡≤‡æ‡ò‡µ, ‡‡®‡‡µ‡‡‡‡‡ø, carry/borrow, the fuel obstructions   1
--     ‡‡µ‡ï‡‡‡µ‡‡Ø                                              2
--
-- and 6 was never the answer ‚î it was the size of the decoder space,
-- which is an upper bound anyone can read off, not a measure of the
-- absence.  In Navya-Nyya terms the witnesses are the *avacchedaka*,
-- the delimitor that makes an abhva over an infinite pratiyogin-space
-- exact; counting them measures the absence, counting the pratiyogins
-- measures only the language.
--
-- This bears on the standing deflationary thread.  It does not move
-- anything up the abhva tower ‚î the absence here was exact before and
-- is exact now ‚î but it says the earlier reading was measuring the
-- wrong thing, and that a "must be exhaustive" verdict is a claim about
-- witness count that has to be proved, not read off a finite type.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 ‚î the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module TwoProfilesSuffice where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; _and_ ; true‚â¢false ; false‚â¢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬¨_)

open import SaptabhangiNaya
  using ( Naya ; rewriter ; kernel-refl ; kernel-ind
        ; Profile ; mk ; Vacana ; asti-from ; nasti-from
        ; denotes ; joint )

------------------------------------------------------------------------
-- 1.  Saying it, and separating it
------------------------------------------------------------------------

Says : Vacana ‚Üí Profile ‚Üí Type‚ÇÄ
Says v œÜ = denotes v œÜ ‚â° joint œÜ

Separates : Profile ‚Üí Profile ‚Üí Type‚ÇÄ
Separates œÜ œà = (v : Vacana) ‚Üí (¬¨ Says v œÜ) ‚äé (¬¨ Says v œà)

------------------------------------------------------------------------
-- 2.  ONE PROFILE IS NEVER ENOUGH
--
-- joint œ = œ rewriter ‚àß ¬ (œ kernel-refl).  If `œ kernel-refl` is
-- false the joint content is just `œ rewriter`, said by asti-from
-- rewriter; if it is true the joint content is false, and when
-- `œ rewriter` is also true that is said by nsti-from rewriter.  Every
-- profile falls into one of these.
------------------------------------------------------------------------

every-profile-is-said : (œÜ : Profile) ‚Üí Œ£[ v ‚àà Vacana ] Says v œÜ
every-profile-is-said œÜ = choose (œÜ rewriter) (œÜ kernel-refl) refl refl
  where
  choose : (a b : Bool) ‚Üí œÜ rewriter ‚â° a ‚Üí œÜ kernel-refl ‚â° b
         ‚Üí Œ£[ v ‚àà Vacana ] Says v œÜ
  choose true  true  pa pb =
    nasti-from rewriter , (cong not pa ‚àô sym (cong‚ÇÇ _and_ pa (cong not pb)))
  choose true  false pa pb =
    asti-from rewriter , (pa ‚àô sym (cong‚ÇÇ _and_ pa (cong not pb)))
  choose false true  pa pb =
    asti-from rewriter , (pa ‚àô sym (cong‚ÇÇ _and_ pa (cong not pb)))
  choose false false pa pb =
    asti-from rewriter , (pa ‚àô sym (cong‚ÇÇ _and_ pa (cong not pb)))

no-single-separator :
  ¬¨ (Œ£[ œÜ ‚àà Profile ] ((v : Vacana) ‚Üí ¬¨ Says v œÜ))
no-single-separator (œÜ , sep) =
  sep (every-profile-is-said œÜ .fst) (every-profile-is-said œÜ .snd)

------------------------------------------------------------------------
-- 3.  TWO PROFILES ARE
------------------------------------------------------------------------

œÜ‚ÇÅ : Profile
œÜ‚ÇÅ = mk true true false

œÜ‚ÇÇ : Profile
œÜ‚ÇÇ = mk false false true

-- the joint content is false on both
joint-œÜ‚ÇÅ : joint œÜ‚ÇÅ ‚â° false
joint-œÜ‚ÇÅ = refl

joint-œÜ‚ÇÇ : joint œÜ‚ÇÇ ‚â° false
joint-œÜ‚ÇÇ = refl

-- and every utterance says `true` on one of them
pair-separates : Separates œÜ‚ÇÅ œÜ‚ÇÇ
pair-separates (asti-from  rewriter)    = inl true‚â¢false
pair-separates (asti-from  kernel-refl) = inl true‚â¢false
pair-separates (asti-from  kernel-ind)  = inr true‚â¢false
pair-separates (nasti-from rewriter)    = inr true‚â¢false
pair-separates (nasti-from kernel-refl) = inr true‚â¢false
pair-separates (nasti-from kernel-ind)  = inl true‚â¢false

------------------------------------------------------------------------
-- 4.  AVAKTAVYA FROM TWO WITNESSES
------------------------------------------------------------------------

FactorsThroughOneUtterance : Type‚ÇÄ
FactorsThroughOneUtterance = Œ£[ v ‚àà Vacana ] ((œÜ : Profile) ‚Üí Says v œÜ)

avaktavya-from-two : ¬¨ FactorsThroughOneUtterance
avaktavya-from-two (v , agrees) = split (pair-separates v)
  where
  split : ((¬¨ Says v œÜ‚ÇÅ) ‚äé (¬¨ Says v œÜ‚ÇÇ)) ‚Üí _
  split (inl bad) = bad (agrees œÜ‚ÇÅ)
  split (inr bad) = bad (agrees œÜ‚ÇÇ)

------------------------------------------------------------------------
-- 5.  The agreement sets, recorded because they are the content
--
-- Each utterance agrees with the joint content on exactly one of the two
-- profiles, and the three-three split is what makes the pair work.
------------------------------------------------------------------------

says-ki-œÜ‚ÇÅ : Says (asti-from kernel-ind) œÜ‚ÇÅ
says-ki-œÜ‚ÇÅ = refl

says-nr-œÜ‚ÇÅ : Says (nasti-from rewriter) œÜ‚ÇÅ
says-nr-œÜ‚ÇÅ = refl

says-nk-œÜ‚ÇÅ : Says (nasti-from kernel-refl) œÜ‚ÇÅ
says-nk-œÜ‚ÇÅ = refl

says-ar-œÜ‚ÇÇ : Says (asti-from rewriter) œÜ‚ÇÇ
says-ar-œÜ‚ÇÇ = refl

says-ak-œÜ‚ÇÇ : Says (asti-from kernel-refl) œÜ‚ÇÇ
says-ak-œÜ‚ÇÇ = refl

says-nki-œÜ‚ÇÇ : Says (nasti-from kernel-ind) œÜ‚ÇÇ
says-nki-œÜ‚ÇÇ = refl

------------------------------------------------------------------------
-- 6.  What this leaves standing and what it removes.
--
-- STANDS.  `Saptabhangi.no-single-vacana` is correct and is not
-- touched; ¬ß5 above is literally its six cases regrouped by which
-- profile they use.  `AvaktavyaDoesNotFactor` is correct.  The
-- order/yugapat contrast ‚î succession expresses the joint content,
-- simultaneity does not ‚î is untouched, and that is the Jain point.
--
-- REMOVED.  The claim that exhaustion is FORCED here.  It is not; two
-- witnesses do it, and the six-fold analysis was a convenience.  A
-- verdict of "this one must be exhaustive" is a lower bound on witness
-- count and needs a proof of its own ‚î ¬ß2 is that proof for the bound 1,
-- and ¬ß3 shows the bound is exactly 2.
--
-- OPEN, named and not estimated: whether any site in this corpus needs
-- more than two.  Nothing here suggests one does, and nothing here rules
-- it out.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  CORRECTION, appended 2026-08-18 ‚î same day, next commit.
--
-- ¬ß"WHAT THE CORRECTED DISTINCTION IS" above says the invariant is the
-- number of witnesses, "1 for ‡≤‡æ‡ò‡µ, ‡‡®‡‡µ‡‡‡‡‡ø, carry/borrow and the fuel
-- obstructions; 2 for ‡‡µ‡ï‡‡‡µ‡‡Ø".  That counts in two units.  A collision
-- is one PAIR and a pair is two POINTS.
--
-- `WitnessNumberIsTwo` fixes one measure ‚î the least list
-- of points on which no decoder survives ‚î and under it:
--
--   * one point is NEVER enough for any `FactorsThrough` obstruction,
--     with no hypotheses, because the constant decoder `Œª _ ‚í t x`
--     answers any single point;
--   * a collision is exactly a refuting pair;
--   * the ‡‡µ‡ï‡‡‡µ‡‡Ø site is 2 as well, by `every-profile-is-said` below
--     for the floor and `pair-separates` for the ceiling.
--
-- So it is 2 versus 2, not 1 versus 2.  What differs between the sites
-- is the ROUTE to the pair ‚î constructed from a collision, or found by
-- looking ‚î which is a fact about obtaining the witness, not about the
-- absence.
--
-- The error is the same shape as the one this module was written to
-- correct: a quantity named before a measure was fixed.
------------------------------------------------------------------------
