{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheFourVerdictsAreNotAPartitionAndUndecidedIsExclusiveOnlyWithForms
--
-- `--guardedness` is carried because `VacuityVerdict` declares it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE AUDIT.  Target: `VacuityVerdict`, whose header
-- says:
--
--   "The finite runtime used four strings: FORMS, GENUINE, VACUOUS, and
--    UNDECIDED-VACUOUS.  **The distinction is not four labels.  It is
--    the difference between four types.**"
--
-- That is right, and it leaves the reader one inference short.  Four
-- constructors of one datatype read as a CLASSIFICATION â” four boxes,
-- each object in one.  **`Verdict` is not a partition**, and which
-- pairs collide is not incidental: it is the whole epistemic content of
-- the fourth label.
--
-- WHAT IS PROVED â” all six pairs, decided:
--
--   EXCLUSIVE (4).  Nothing can be `forms` and anything else, and
--   nothing can be `genuine` and `vacuous`:
--     formsExcludesUndecided   a local collision refutes the scoped
--                              factorization every other verdict carries
--     formsExcludesVacuous     hence this
--     formsExcludesGenuine     and this, through `globalâ’scoped` â”
--                              **the only one of the four needing a
--                              lemma rather than a projection**
--     genuineExcludesVacuous   an ambient collision refutes a global
--                              factorization
--
--   COMPATIBLE (2), and BOTH involve `undecided`:
--     vacuousGivesUndecided        `vacuous`'s payload CONTAINS
--                                  `undecided`'s â” projection, no work
--     genuineGivesUndecided        and a global factorization restricts
--                                  to every scope
--     bothVerdictsAtOnce           exhibited on the module's own finite
--                                  control: `constantCarrier` /
--                                  `constantObservation` over
--                                  `OnlyFalse` carries a
--                                  `GlobalFactorization` AND a
--                                  `ScopedFactorization` simultaneously,
--                                  so `genuine â¦` and `undecided â¦` are
--                                  both derivable for one triple
--
-- **AND THE ASYMMETRY IS EXACTLY THE POINT THE HEADER WAS MAKING.**
-- `forms` and `genuine` and `vacuous` are claims about the OBJECT â” a
-- collision exists, a descent exists, a descent exists but is
-- ambiently worthless.  `undecided` is a claim about **what the checker
-- was handed**: a scoped factorization and no ambient theorem either
-- way.  A statement about the evidence cannot exclude a statement about
-- the object, which is why it collides with two of the three, and it is
-- refuted only by `forms` â” the one verdict that destroys the very
-- payload `undecided` carries.  The header's own sentence, *"it remains
-- `undecided` until an ambient theorem is supplied"*, says this; the
-- theorems below are that sentence with its quantifiers.
------------------------------------------------------------------------

module TheFourVerdictsAreNotAPartitionAndUndecidedIsExclusiveOnlyWithForms where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

open import VacuityVerdict
  using ( Scope ; LocalCollision ; AmbientCollision
        ; ScopedFactorization ; GlobalFactorization
        ; localCollision-refutes-scoped ; ambientCollision-refutes-global
        ; globalâ†’scoped
        ; OnlyFalse ; constantCarrier ; constantObservation
        ; constant-is-genuine )

private
  variable
    X Z Y : Typeâ‚€

------------------------------------------------------------------------
-- 1.  The four exclusions
------------------------------------------------------------------------

formsExcludesUndecided :
    (S : Scope X) (q : X â†’ Z) (f : X â†’ Y)
  â†’ LocalCollision S q f â†’ Â¬ (ScopedFactorization S q f)
formsExcludesUndecided = localCollision-refutes-scoped

formsExcludesVacuous :
    (S : Scope X) (q : X â†’ Z) (f : X â†’ Y)
  â†’ LocalCollision S q f
  â†’ Â¬ (ScopedFactorization S q f Ã— AmbientCollision S q f)
formsExcludesVacuous S q f c p = localCollision-refutes-scoped S q f c (fst p)

-- the only exclusion that is not a projection away: a global
-- factorization must first be restricted to the scope
formsExcludesGenuine :
    (S : Scope X) (q : X â†’ Z) (f : X â†’ Y)
  â†’ LocalCollision S q f â†’ Â¬ (GlobalFactorization q f)
formsExcludesGenuine S q f c g =
  localCollision-refutes-scoped S q f c (globalâ†’scoped S q f g)

genuineExcludesVacuous :
    (S : Scope X) (q : X â†’ Z) (f : X â†’ Y)
  â†’ GlobalFactorization q f â†’ Â¬ (AmbientCollision S q f)
genuineExcludesVacuous S q f g c = ambientCollision-refutes-global S q f c g

------------------------------------------------------------------------
-- 2.  The two compatibilities, both with `undecided`
------------------------------------------------------------------------

vacuousGivesUndecided :
    (S : Scope X) (q : X â†’ Z) (f : X â†’ Y)
  â†’ ScopedFactorization S q f Ã— AmbientCollision S q f
  â†’ ScopedFactorization S q f
vacuousGivesUndecided S q f = fst

genuineGivesUndecided :
    (S : Scope X) (q : X â†’ Z) (f : X â†’ Y)
  â†’ GlobalFactorization q f â†’ ScopedFactorization S q f
genuineGivesUndecided = globalâ†’scoped

------------------------------------------------------------------------
-- 3.  â¦and the compatibility is inhabited, on the audited module's own
--     finite control
------------------------------------------------------------------------

bothVerdictsAtOnce :
  GlobalFactorization constantCarrier constantObservation
  Ã— ScopedFactorization OnlyFalse constantCarrier constantObservation
bothVerdictsAtOnce =
    constant-is-genuine
  , genuineGivesUndecided OnlyFalse constantCarrier constantObservation
      constant-is-genuine
