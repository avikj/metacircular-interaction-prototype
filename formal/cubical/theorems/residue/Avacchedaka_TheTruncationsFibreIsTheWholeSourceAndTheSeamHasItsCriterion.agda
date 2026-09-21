{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡µ‡‡‡‡‡¶‡ï‡Æ‡ ‚î ‡‡‡∞‡‡ü‡‡ ‡‡®‡‡‡‡ ‡‡∞‡‡µ‡ ‡Æ‡‡≤‡Æ‡ ; ‡‡®‡‡ß‡‡ ‡‡∞‡ø‡‡‡‡‡¶‡ ‡≤‡‡‡ß‡ ‡
--
-- (the delimitor: the truncation's fibre is the WHOLE source, and the
--  seam's criterion is thereby available.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS PROVES.
--
-- `fibre/src/Loss/WholePartialDesa_‚¶` makes the fibre
-- diagnosis a TERM ‚î `‡¶‡‡ f b` with three constructors, ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ (empty
-- fibre: nothing lost, the medium has no name for b, ‡ß‡®‡æ‡‡‡Æ‡ï‡Æ‡),
-- ‡‡ï‡≤‡æ‡¶‡‡ (contractible: one utterance carries all), ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ (two points
-- not identified: the loss, exhibited).  It refuses to add a fourth,
-- and it says exactly why:
--
--     "Adding a constructor for a distinction that has no criterion
--      would be the same ‡¶‡‡∞‡‡®‡Ø this module exists to repair, one level
--      down: a name doing the work of a proof."
--
-- The distinction it refuses is between the note's levels ‡© and ‡ ‚î both
-- crowded fibres, both landing in ‡µ‡ø‡ï‡≤‡æ‡¶‡‡.  Level ‡© is recoverable only
-- by outside supply; level ‡ is ‡®‡‡‡ü‡ø, ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ.  And the obvious
-- criterion FAILS to separate them: `¬ Œ[œà] (œà ‚àò collapse ‚â° id)` holds of
-- both.
--
-- them ‚î the SIZE of the fibre relative to the source ‚î and marks the
-- load-bearing half a CONJECTURE, "one line to check":
--
--     (x : ‚à A ‚à‚) ‚í fibre ‚à_‚à‚ x ‚â A
--
-- ¬ß‡® below proves that line.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- ESTABLISHED (¬ß‡®): for propositional truncation, EVERY fibre is
-- equivalent to the whole source.  Not merely non-contractible, and not
-- merely large: the fibre IS the source, so nothing whatsoever downstream
-- of the map can see which point it came from.  That is what makes
-- truncation ‡‡‡‡∞‡‡ø‡ï‡æ‡∞‡‡Ø‡æ rather than merely lossy.
--
-- ALSO, deliberately: this does NOT add the fourth
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
------------------------------------------------------------------------

module Avacchedaka_TheTruncationsFibreIsTheWholeSourceAndTheSeamHasItsCriterion where

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
-- ‡ß ¬ ‡‡®‡‡‡‡ ‚î the fibre of the truncation unit over a point of ‚à A ‚à‚.
--     Written out rather than left as `fiber ‚à_‚à‚ x`, so the statement
--     below is legible without unfolding.
------------------------------------------------------------------------

‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§§‡§®‡•ç‡§§‡•Å‡§É : {A : Type ‚Ñì} ‚Üí ‚à• A ‚à•‚ÇÅ ‚Üí Type ‚Ñì
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø-‡§§‡§®‡•ç‡§§‡•Å‡§É {A = A} x = Œ£[ a ‚àà A ] (‚à£ a ‚à£‚ÇÅ ‚â° x)

------------------------------------------------------------------------
-- ‡® ¬ ‡‡∞‡‡µ-‡‡®‡‡‡‡ ‚î THE THEOREM.
--
--     Every fibre of ‚à_‚à‚ is equivalent to the whole source.
--
-- ‚à A ‚à‚ is a proposition, so each of its path types is CONTRACTIBLE
-- (isProp‚íisContrPath), so the second component of the Œ contributes
-- nothing and contracts away (Œ-contractSnd), leaving A itself.
--
-- Read against `Residue_‚¶`: the residual over a target point is what the
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
-- ‡‡∞‡‡µ‡‡æ‡®‡ø‡ does NOT separate the levels.  It holds of `‡‡∞‡‡µ‡à‡ï‡Æ‡ : Bool ‚í Unit`, the
-- map that drops exactly one bit ‚î `Residue_‚¶` ¬ß5, which its own struck
-- header calls "level ‡® of a five-level scale".  `Unit` is a proposition,
-- so the path component of the fibre contracts and the fibre is `Bool`,
-- the whole source.  The proof is ¬ß‡®'s proof with `isPropUnit` for
-- `isPropPropTrunc`, which is why: this criterion reads propositionality
-- of the TARGET, and both targets are props.
--
-- The refutation, with three more, is
-- `SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFibreCriterionFailsOnItsOwnArchetype`.
-- ¬ß‡® there shows it is not a stray instance ‚î `‚à Bool ‚à‚ ‚â Unit` and the
-- triangle commutes, so at `A = Bool` the level-‡ archetype IS the
-- level-‡® archetype, and the two fibre censuses are pointwise equivalent.
--
-- ¬ß‡® of THIS file holds: every fibre of `‚à_‚à‚` is
-- the whole source, for every `A`.  What is refuted is its use as a
-- criterion, which ¬ß‡ below does not claim in general.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É : {A B : Type ‚Ñì} ‚Üí (A ‚Üí B) ‚Üí B ‚Üí Type ‚Ñì
‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É {A = A} f b = fiber f b ‚âÉ A

-- propositional truncation loses totally, at every point of its target
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø‡§É-‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É : {A : Type ‚Ñì} (x : ‚à• A ‚à•‚ÇÅ) ‚Üí ‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É ‚à£_‚à£‚ÇÅ x
‡§§‡•ç‡§∞‡•Å‡§ü‡§ø‡§É-‡§∏‡§∞‡•ç‡§µ‡§π‡§æ‡§®‡§ø‡§É = ‡§∏‡§∞‡•ç‡§µ-‡§§‡§®‡•ç‡§§‡•Å‡§É-fiber

------------------------------------------------------------------------
-- ‡ ¬ The seam, and the refutation of the criterion.
--
-- `‡‡∞‡‡µ‡‡æ‡®‡ø‡` is satisfied by
-- the corpus's own level-‡® archetype, so ¬ß‡© gave level ‡ no criterion at
-- all; and the level-‡© half of the scale ‚î a proper fibre, with something
-- out of the source still seeing the difference ‚î is satisfied at the
-- level-‡ archetype and is vacuous wherever the fibre is crowded.  Both
-- halves are refuted in
-- `SapeksaNirapeksa_TheLossLevelIsNotAPropertyOfTheMapAloneAndTheFibre
-- CriterionFailsOnItsOwnArchetype`, which also exhibits the same map
-- under two retained contexts with opposite verdicts ‚î so the level is
-- not a property of the map, and no per-map criterion can complete the
-- scale.  What survives here untouched is ¬ß‡®.
------------------------------------------------------------------------
