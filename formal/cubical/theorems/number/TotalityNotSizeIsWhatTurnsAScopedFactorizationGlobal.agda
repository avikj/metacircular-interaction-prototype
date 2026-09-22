{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TotalityNotSizeIsWhatTurnsAScopedFactorizationGlobal
--
-- `--guardedness` is carried because `VacuityVerdict` declares it and the
-- option is infective.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CLAIM
--
-- `VacuityVerdict`'s header ends:
--
--   "In particular, **checking a larger finite sample never constructs
--    `GlobalFactorization`.**  It remains `undecided` until an ambient
--    theorem is supplied."
--
-- Size is not
-- the operative property.  TOTALITY is, and totality is expressible
-- with no sampling procedure at all.
--
-- WHAT IS PROVED
--
--   totalScopeGivesGlobal
--        `((x : X) â’ S x) â’ ScopedFactorization S q f
--         â’ GlobalFactorization q f`.
--        The scope's INHABITEDNESS EVERYWHERE is exactly what the
--        global agreement needs â” the descent map is carried over
--        unchanged, and only the agreement obligation moves.  So a
--        sample does construct a global factorization the moment it
--        stops being a sample.
--   allBoolIsTotal
--        and that hypothesis is not vacuous: the audited module's own
--        `AllBool` satisfies it.
--   noGlobalForTheIdentity
--        the negative half, on the audited module's own control: at
--        `OnlyFalse` the identity observation FACTORS (`localIdentity`)
--        and yet no global factorization exists at all, because
--        `identityAmbientCollision` refutes every one.
--   enlargingDestroysTheFactorization
--        and enlarging that scope to `AllBool` does not approach a
--        global factorization â” it **destroys the local one**, since
--        `identity-forms-globally` is a collision inside the larger
--        scope.
--
-- **SO THE HEADER'S SENTENCE IS TRUE AND ITS REASON IS NOT SIZE.**
-- Reading the four together: evidence of descent only ever RESTRICTS
-- along scope inclusion (`restrict-factorization`, already there), so
-- enlarging never creates it; the sole route from scoped to global is
-- totality; and enlargement short of totality can strictly lose what
-- was already had.  "A larger finite sample never constructs
-- `GlobalFactorization`" is the corollary of those, at every scope that
-- is not total.
------------------------------------------------------------------------

module TotalityNotSizeIsWhatTurnsAScopedFactorizationGlobal where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (Â¬_)

open import VacuityVerdict
  using ( Scope ; ScopedFactorization ; GlobalFactorization
        ; localCollision-refutes-scoped ; ambientCollision-refutes-global
        ; OnlyFalse ; AllBool ; constantCarrier ; identityObservation
        ; localIdentity ; identityAmbientCollision ; identity-forms-globally )

private
  variable
    X Z Y : Typeâ‚€

------------------------------------------------------------------------
-- 1.  Totality is the whole hypothesis
--
-- `descend` is carried over unchanged; only the agreement obligation
-- moves, and it moves exactly because every `x` is in scope.
------------------------------------------------------------------------

totalScopeGivesGlobal :
    (S : Scope X) (q : X â†’ Z) (f : X â†’ Y)
  â†’ ((x : X) â†’ S x)
  â†’ ScopedFactorization S q f â†’ GlobalFactorization q f
GlobalFactorization.descend (totalScopeGivesGlobal S q f tot fac) =
  ScopedFactorization.descend fac
GlobalFactorization.agrees (totalScopeGivesGlobal S q f tot fac) x =
  ScopedFactorization.agrees fac x (tot x)

allBoolIsTotal : (b : Bool) â†’ AllBool b
allBoolIsTotal _ = tt

------------------------------------------------------------------------
-- 2.  â¦and short of totality, enlargement does not approach it
------------------------------------------------------------------------

noGlobalForTheIdentity :
  Â¬ (GlobalFactorization constantCarrier identityObservation)
noGlobalForTheIdentity =
  ambientCollision-refutes-global
    OnlyFalse constantCarrier identityObservation identityAmbientCollision

theIdentityStillFactorsOnTheSmallScope :
  ScopedFactorization OnlyFalse constantCarrier identityObservation
theIdentityStillFactorsOnTheSmallScope = localIdentity

enlargingDestroysTheFactorization :
  Â¬ (ScopedFactorization AllBool constantCarrier identityObservation)
enlargingDestroysTheFactorization =
  localCollision-refutes-scoped
    AllBool constantCarrier identityObservation identity-forms-globally
