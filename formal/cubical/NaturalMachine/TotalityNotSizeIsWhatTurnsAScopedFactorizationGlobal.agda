{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TotalityNotSizeIsWhatTurnsAScopedFactorizationGlobal
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Scoped descent and factorization through a quotient are this corpus's
-- own construction; there is no source to cite, and a fabricated
-- Sanskrit label would assert a provenance nobody checked.  Checked
-- before naming: `.claude/hooks/priority-ledger.txt` (CURRENT header)
-- and `.claude/hooks/european-frame.txt`; no row applies, and the frame
-- check's scope requires Indian material, of which this module has
-- none.  `formal/` and `notes/` grepped first.  `--guardedness` is
-- carried because `VacuityVerdict` declares it and the option is
-- infective.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CLAIM, AND MY OWN WRONG GUESS ABOUT IT
--
-- `VacuityVerdict`'s header ends:
--
--   "In particular, **checking a larger finite sample never constructs
--    `GlobalFactorization`.**  It remains `undecided` until an ambient
--    theorem is supplied."
--
-- At a430ec41 I logged this as possibly unformalisable — *"a statement
-- about a SAMPLING PROCEDURE, and no sampling procedure exists in
-- either module"* — and said to retire it if so.  **That guess was
-- wrong, and it was wrong in a way this line keeps repeating: I took
-- the sentence's own noun ("larger") for its content.**  Size is not
-- the operative property.  TOTALITY is, and totality is expressible
-- with no sampling procedure at all.
--
-- WHAT IS PROVED
--
--   totalScopeGivesGlobal
--        `((x : X) → S x) → ScopedFactorization S q f
--         → GlobalFactorization q f`.
--        The scope's INHABITEDNESS EVERYWHERE is exactly what the
--        global agreement needs — the descent map is carried over
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
--        global factorization — it **destroys the local one**, since
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
--
-- **AND THIS IS THE THIRD INSTANCE OF ONE PATTERN IN SIX CYCLES.**
-- 4e2a577d: coverage needs the fuel to EXHAUST, not to exceed the
-- archive's length.  a5881b77: a delivery discipline's strength is the
-- RELATION, not the number of its edges.  Here: a scope yields a global
-- descent by being TOTAL, not by being large.  Each time the quantity
-- reached for was a proxy that happens to imply the real hypothesis in
-- the easy direction and is not equivalent to it.  **The proxy is
-- always the one that can be counted.**
--
-- WHAT IS NOT CLAIMED.  **`VacuityVerdict` is NOT amended and NOT
-- retracted**; its sentence is true, and everything here is built from
-- its own definitions, lemmas and controls, unaltered.  It is NOT
-- claimed that totality is NECESSARY for a global factorization — a
-- global factorization can exist while a given scope is proper, as
-- `constant-is-genuine` shows over `OnlyFalse`; the implication proved
-- is one-way and the module says so.  Nothing here formalises
-- "sampling", "finite", or "larger": no sample, no cardinality, and no
-- enumeration appears, and the point is precisely that none is needed.
-- No h-level is assumed of `X`, `Z`, `Y`.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TotalityNotSizeIsWhatTurnsAScopedFactorizationGlobal where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.VacuityVerdict
  using ( Scope ; ScopedFactorization ; GlobalFactorization
        ; localCollision-refutes-scoped ; ambientCollision-refutes-global
        ; OnlyFalse ; AllBool ; constantCarrier ; identityObservation
        ; localIdentity ; identityAmbientCollision ; identity-forms-globally )

private
  variable
    X Z Y : Type₀

------------------------------------------------------------------------
-- 1.  Totality is the whole hypothesis
--
-- `descend` is carried over unchanged; only the agreement obligation
-- moves, and it moves exactly because every `x` is in scope.
------------------------------------------------------------------------

totalScopeGivesGlobal :
    (S : Scope X) (q : X → Z) (f : X → Y)
  → ((x : X) → S x)
  → ScopedFactorization S q f → GlobalFactorization q f
GlobalFactorization.descend (totalScopeGivesGlobal S q f tot fac) =
  ScopedFactorization.descend fac
GlobalFactorization.agrees (totalScopeGivesGlobal S q f tot fac) x =
  ScopedFactorization.agrees fac x (tot x)

allBoolIsTotal : (b : Bool) → AllBool b
allBoolIsTotal _ = tt

------------------------------------------------------------------------
-- 2.  …and short of totality, enlargement does not approach it
------------------------------------------------------------------------

noGlobalForTheIdentity :
  ¬ (GlobalFactorization constantCarrier identityObservation)
noGlobalForTheIdentity =
  ambientCollision-refutes-global
    OnlyFalse constantCarrier identityObservation identityAmbientCollision

theIdentityStillFactorsOnTheSmallScope :
  ScopedFactorization OnlyFalse constantCarrier identityObservation
theIdentityStillFactorsOnTheSmallScope = localIdentity

enlargingDestroysTheFactorization :
  ¬ (ScopedFactorization AllBool constantCarrier identityObservation)
enlargingDestroysTheFactorization =
  localCollision-refutes-scoped
    AllBool constantCarrier identityObservation identity-forms-globally
