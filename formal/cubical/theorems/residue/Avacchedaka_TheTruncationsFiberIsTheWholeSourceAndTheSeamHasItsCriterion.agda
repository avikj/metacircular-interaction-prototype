{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡µ‡‡‡‡‡¶‡ï‡Æ‡ ‚î ‡‡‡∞‡‡ü‡‡ ‡‡®‡‡‡‡ ‡‡∞‡‡µ‡ ‡Æ‡‡≤‡Æ‡ ; ‡‡®‡‡ß‡‡ ‡‡∞‡ø‡‡‡‡‡¶‡ ‡≤‡‡‡ß‡ ‡
--
-- (the delimitor: the truncation's fiber is the WHOLE source, and the
--  seam's criterion is thereby available.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS CLOSES, AND WHY IT WAS LEFT OPEN ON PURPOSE.
--
-- `fiber/src/Fiber/SakalaVikalaDesa_‚¶` makes the fiber
-- diagnosis a TERM ‚î `‡¶‡‡ f b` with three constructors, ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ (empty
-- fiber: nothing lost, the medium has no name for b, ‡ß‡®‡æ‡‡‡Æ‡ï‡Æ‡),
-- ‡‡ï‡≤‡æ‡¶‡‡ (contractible: one utterance carries all), ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ (two points
-- not identified: the loss, exhibited).  It refuses to add a fourth,
-- and it says exactly why:
--
--     "Adding a constructor for a distinction that has no criterion
--      would be the same ‡¶‡‡∞‡‡®‡Ø this module exists to repair, one level
--      down: a name doing the work of a proof."
--
-- The distinction it refuses is between the note's levels ‡© and ‡ ‚î both
-- crowded fibers, both landing in ‡µ‡ø‡ï‡≤‡æ‡¶‡‡.  Level ‡© is recoverable only
-- by outside supply; level ‡ is ‡®‡‡‡ü‡ø, ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ.  And the obvious
-- criterion FAILS to separate them: `¬ Œ[œà] (œà ‚àò collapse ‚â° id)` holds of
-- both.
--
-- them ‚î the SIZE of the fiber relative to the source ‚î and marks the
-- load-bearing half a CONJECTURE, "one line to check":
--
--     (x : ‚à A ‚à‚) ‚í fiber ‚à_‚à‚ x ‚â A
--
-- ¬ß‡® below is that line, checked.  It was one line.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- ESTABLISHED (¬ß‡®): for propositional truncation, EVERY fiber is
-- equivalent to the whole source.  Not merely non-contractible, and not
-- merely large: the fiber IS the source, so nothing whatsoever downstream
-- of the map can see which point it came from.  That is what makes
-- truncation ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ rather than merely lossy.
--
-- NOT ESTABLISHED: that "fiber ‚â whole source" is THE criterion
-- separating ‡© from ‡ in general.  ¬ß‡® settles the level-‡ side by
-- exhibiting the archetype; the note's level-‡© side (`fiber ‡‡®‡∞‡‡‡‡Æ‡
-- (‡‡‡Ø‡æ‡‡-‡‡‡‡‡ø) ‚â sydasti P`, a PROPER part, with other maps out of the
-- source still seeing the difference) is a second instance in another
-- lane and is not reproved here.  Two instances are two instances.  The
-- general claim needs the scale, and the scale is that note's.
--
-- ALSO NOT DONE, and deliberately: this does NOT add the fourth
-- constructor to `‡¶‡‡`.  That datatype is in another library, and the
-- refusal to extend it was a considered act by its author.  A criterion
-- is what was missing; supplying the criterion and extending the type are
-- different decisions, and the second is theirs.  Supplying a criterion
-- and then using it to edit someone's refusal would be the forgery this
-- corpus keeps catching, wearing helpfulness.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE TERM.  ‡‡µ‡‡‡‡‡¶‡ï ‚î Nyya's "delimitor", the property that fixes the
-- exact extent of a relation or an absence (Gagea, ‡‡‡‡‡‡µ‡‡ø‡®‡‡‡æ‡Æ‡‡ø,
-- 14th c., and the Navya-Nyya technical apparatus after him; the
-- corpus's own `interactive/Abhava_TheAbsenceCarriesItsPratiyoginAndItsSearched
-- Domain.hs` and `AbhavaAvacchedaka.agda` use it in that sense).  LIMIT:
-- nothing below is attributed to any Naiyyika, and the citation is
-- second-hand.  The word is taken for one property ‚î that a relation is
-- not stated until its extent is ‚î which is exactly what the seam was
-- missing and what ¬ß‡® supplies.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Avacchedaka_TheTruncationsFiberIsTheWholeSourceAndTheSeamHasItsCriterion where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; fiber ; isEquiv)
open import Cubical.Foundations.HLevels using (isProp‚ÜíisContrPath)
open import Cubical.Data.Sigma using (Œ£-contractSnd ; Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.HITs.PropositionalTruncation
  using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; isPropPropTrunc)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡®‡‡‡‡ ‚î the fiber of the truncation unit over a point of ‚à A ‚à‚.
--     Written out rather than left as `fiber ‚à_‚à‚ x`, so the statement
--     below is legible without unfolding.
------------------------------------------------------------------------

‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§§‡§®‡•ç‡§§‡•Å‡§É : {A : Type ‚Ñì} ‚Üí ‚à• A ‚à•‚ÇÅ ‚Üí Type ‚Ñì
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§§‡§®‡•ç‡§§‡•Å‡§É {A = A} x = Œ£[ a ‚àà A ] (‚à£ a ‚à£‚ÇÅ ‚â° x)

------------------------------------------------------------------------
-- ‡® ¬ ‡‡∞‡‡µ-‡‡®‡‡‡‡ ‚î THE CONJECTURE, CHECKED.
--
--     Every fiber of ‚à_‚à‚ is equivalent to the whole source.
--
-- ‚à A ‚à‚ is a proposition, so each of its path types is CONTRACTIBLE
-- (isProp‚íisContrPath), so the second component of the Œ contributes
-- nothing and contracts away (Œ-contractSnd), leaving A itself.
--
-- Read against `Sesa_‚¶`: the residual over a target point is what the
-- target forgot there.  Here it forgot everything ‚î the residual is not a
-- part of the source, it is the source.  So no map out of the target can
-- ever distinguish two points of A, because the target's every point
-- stands over all of A at once.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ-‡§§‡§®‡•ç‡§§‡•Å‡§É : {A : Type ‚Ñì} (x : ‚à• A ‚à•‚ÇÅ) ‚Üí ‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§§‡§®‡•ç‡§§‡•Å‡§É x ‚âÉ A
‡§∏‡§∞‡•ç‡§µ-‡§§‡§®‡•ç‡§§‡•Å‡§É {A = A} x =
  Œ£-contractSnd (Œª a ‚Üí isProp‚ÜíisContrPath isPropPropTrunc ‚à£ a ‚à£‚ÇÅ x)

-- the same statement in the library's own vocabulary, so a reader looking
-- for `fiber` finds it
‡§∏‡§∞‡•ç‡§µ-‡§§‡§®‡•ç‡§§‡•Å‡§É-fiber : {A : Type ‚Ñì} (x : ‚à• A ‚à•‚ÇÅ) ‚Üí fiber ‚à£_‚à£‚ÇÅ x ‚âÉ A
‡§∏‡§∞‡•ç‡§µ-‡§§‡§®‡•ç‡§§‡•Å‡§É-fiber = ‡§∏‡§∞‡•ç‡§µ-‡§§‡§®‡•ç‡§§‡•Å‡§É

------------------------------------------------------------------------
-- ‡© ¬ ‡‡∞‡ø‡‡‡‡‡¶‡ ‚î the criterion, stated as a predicate so it can be used
--     rather than admired, and applied to the archetype.
--
--     "The loss is total at b" := the residual over b is the whole source.
--
-- ~~This is what ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ could not say.  ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ says the fiber has two
-- distinct points; that is true of a map that drops one bit and equally
-- true of a map that drops everything.  ‡‡∞‡‡µ‡‡æ‡®‡ø‡ says which.~~
--
-- **STRUCK 2026-08-22, the next day, by the agent who wrote it.  Left
-- standing struck rather than deleted, because striking silently is how
-- this repository loses its own history (CLAUDE.md).**
--
-- ‡‡∞‡‡µ‡‡æ‡®‡ø‡ does NOT say which.  It holds of `‡‡∞‡‡µ‡à‡ï‡Æ‡ : Bool ‚í Unit`, the
-- map that drops exactly one bit ‚î `Sesa_‚¶` ¬ß5, which its own struck
-- header calls "level ‡® of a five-level scale".  `Unit` is a proposition,
-- so the path component of the fiber contracts and the fiber is `Bool`,
-- the whole source.  The proof is ¬ß‡®'s proof with `isPropUnit` for
-- `isPropPropTrunc`, which is why: this criterion reads propositionality
-- of the TARGET, and both targets are props.
--
-- The refutation, with three more, is
-- `SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFiberCriterionFailsOnItsOwnArchetype`.
-- ¬ß‡® there shows it is not a stray instance ‚î `‚à Bool ‚à‚ ‚â Unit` and the
-- triangle commutes, so at `A = Bool` the level-‡ archetype IS the
-- level-‡® archetype, and the two fiber censuses are pointwise equivalent.
--
-- ¬ß‡® of THIS file is untouched and still true: every fiber of `‚à_‚à‚` is
-- the whole source, for every `A`.  What is refuted is its use as a
-- criterion, which ¬ß‡ below already declined to claim in general and
-- which the definition above nonetheless asserted in a comment.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É : {A B : Type ‚Ñì} ‚Üí (A ‚Üí B) ‚Üí B ‚Üí Type ‚Ñì
‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É {A = A} f b = fiber f b ‚âÉ A

-- propositional truncation loses totally, at every point of its target
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø‡§É-‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É : {A : Type ‚Ñì} (x : ‚à• A ‚à•‚ÇÅ) ‚Üí ‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É ‚à£_‚à£‚ÇÅ x
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø‡§É-‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É = ‡§∏‡§∞‡•ç‡§µ-‡§§‡§®‡•ç‡§§‡•Å‡§É-fiber

------------------------------------------------------------------------
-- ‡ ¬ The seam, restated with what is now on each side.
--
-- BEFORE: levels ‡© and ‡ were both `‡µ‡ø‡ï‡≤‡æ‡¶‡‡`, and the criterion that was
-- supposed to separate them ‚î does a retraction exist ‚î provably does
-- not, since `¬ Œ[œà] (œà ‚àò collapse ‚â° id)` holds of both.
--
-- NOW: level ‡ has a positive criterion and its archetype satisfies it
-- (¬ß‡©).  What is still owed for the SCALE, and is not owed by this file,
-- is the level-‡© side: that a level-‡© collapse's fiber is a PROPER part,
-- with something out of the source still seeing the difference.  The note
-- exhibits one such instance (`‡‡®‡∞‡‡‡‡Æ‡`); one instance is one instance.
--
-- So the seam is narrower and it is not gone, and saying it is gone would
-- be forging a presence in the same paragraph that just closed a gap by
-- refusing to forge one.
--
-- **[2026-08-22 ‚î the seam is not narrower.  It is wider than this
-- paragraph says, and the reason is above.]**  `‡‡∞‡‡µ‡‡æ‡®‡ø‡` is satisfied by
-- the corpus's own level-‡® archetype, so ¬ß‡© gave level ‡ no criterion at
-- all; and the level-‡© half quoted here ‚î a proper fiber, with something
-- out of the source still seeing the difference ‚î is satisfied at the
-- level-‡ archetype and is vacuous wherever the fiber is crowded.  Both
-- halves are refuted in
-- `SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFiber
-- CriterionFailsOnItsOwnArchetype`, which also exhibits the same map
-- under two retained contexts with opposite verdicts ‚î so the level is
-- not a property of the map, and no per-map criterion can complete the
-- scale.  What survives here untouched is ¬ß‡®.
------------------------------------------------------------------------
