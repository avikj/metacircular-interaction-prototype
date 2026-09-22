{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AskingIsNotAPropertyOfTheFunction
--
-- Whether a definition asks a decision is a property of the definition,
-- not of the function the definition computes.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT PROVOKED THIS
--
-- calls it mechanical:
--
--   "installed cognition reduces to `refl`; description needs a proof
--    from outside"
--
-- and its exhibit is `BhedaAvatarana.àà•àà¦à : ààà¦ (suc a)(suc b) â‰¡
-- à—ààà° (ààà¦ a b)`, which is `refl`, where the same equation for a
-- `discreteâ•`-driven descent is not.
--
-- The criterion is real â” `àà•àà¦à`
-- IS `refl`.  What is proved here is where
-- the criterion lives.  It is a predicate on PRESENTATIONS, and no
-- invariant of the computed function can report it.  So it cannot be
-- checked by a type, and this is why `Jiva.agda` had to be read rather
-- than type-checked to establish that the lane is decisionless.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE TWO PRESENTATIONS
--
--   peel  : â• â’ â• â’ â•     falls by structure, never asks
--   askâ•  : â• â’ â• â’ â•     `verdict (discreteâ• a b)`, asks once
--
-- `sameFunction : peel â‰¡ askâ•` (funext, twice).  They are one function.
-- `asks byStructure â‰¡ false`, `asks byDecision â‰¡ true`.  Hence the
-- collision, hence the obstruction.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- IN WHICH RESPECT EACH ASKS LESS â” no ranking, both directions checked
--
-- `peel` asks less of the PROVER: its step law `peel (suc a)(suc b) â‰¡
-- peel a b` is `refl`.  This is the note's criterion, and it holds.
--
-- `ask` asks less of the AUTHOR: it is ONE definition, uniform in
-- `Discrete A`, and is instantiated below at both â• and Bool from the
-- same line.  `peel` is a case tree over â•'s constructors and has to be
-- rewritten for every new carrier.  The step law `askâ• (suc a)(suc b) â‰¡
-- askâ• a b` is still available â” `ask-step` proves it â” but its proof
-- routes through `peel`, which is the honest form of the note's point:
-- not "the decided version lacks the law", but "the decided version's
-- law is a theorem where the structural version's is a reduction."
--
-- These two are incomparable.  A carrier with decidable equality and no
-- useful induction principle favours `ask`; an open term favours `peel`.
------------------------------------------------------------------------

module AskingIsNotAPropertyOfTheFunction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; discreteâ„•)
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false ; falseâ‰¢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Discrete)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

private
  variable
    â„“ : Level

------------------------------------------------------------------------
-- 1.  The decided presentation: one definition, every discrete carrier
------------------------------------------------------------------------

verdict : {A : Type â„“} â†’ Dec A â†’ â„•
verdict (yes _) = 0
verdict (no  _) = 1

ask : {A : Type â„“} â†’ Discrete A â†’ A â†’ A â†’ â„•
ask d x y = verdict (d x y)

askâ„• : â„• â†’ â„• â†’ â„•
askâ„• = ask discreteâ„•

-- the uniformity is exhibited, not asserted: the same `ask` at a second
-- carrier, with only its `Discrete` supplied.
discreteBool : Discrete Bool
discreteBool true  true  = yes refl
discreteBool false false = yes refl
discreteBool true  false = no trueâ‰¢false
discreteBool false true  = no falseâ‰¢true

askBool : Bool â†’ Bool â†’ â„•
askBool = ask discreteBool

------------------------------------------------------------------------
-- 2.  The structural presentation: â• only, falls by constructors
------------------------------------------------------------------------

peel : â„• â†’ â„• â†’ â„•
peel zero    zero    = 0
peel zero    (suc _) = 1
peel (suc _) zero    = 1
peel (suc a) (suc b) = peel a b

-- the note's criterion, at this pair: the step law is a reduction.
peel-step : (a b : â„•) â†’ peel (suc a) (suc b) â‰¡ peel a b
peel-step _ _ = refl

------------------------------------------------------------------------
-- 3.  They are the same function
------------------------------------------------------------------------

peel-diagonal : (a : â„•) â†’ peel a a â‰¡ 0
peel-diagonal zero    = refl
peel-diagonal (suc a) = peel-diagonal a

peel-off : (a b : â„•) â†’ Â¬ (a â‰¡ b) â†’ peel a b â‰¡ 1
peel-off zero    zero    ne = âŠ¥.rec (ne refl)
peel-off zero    (suc _) _  = refl
peel-off (suc _) zero    _  = refl
peel-off (suc a) (suc b) ne = peel-off a b (Î» p â†’ ne (cong suc p))

same : (a b : â„•) â†’ peel a b â‰¡ askâ„• a b
same a b = go (discreteâ„• a b)
  where
    go : (d : Dec (a â‰¡ b)) â†’ peel a b â‰¡ verdict d
    go (yes p)  = subst (Î» x â†’ peel a x â‰¡ 0) p (peel-diagonal a)
    go (no  Â¬p) = peel-off a b Â¬p

sameFunction : peel â‰¡ askâ„•
sameFunction = funExt (Î» a â†’ funExt (Î» b â†’ same a b))

-- the decided presentation's step law, available but derived
ask-step : (a b : â„•) â†’ askâ„• (suc a) (suc b) â‰¡ askâ„• a b
ask-step a b = sym (same (suc a) (suc b)) âˆ™ peel-step a b âˆ™ same a b

------------------------------------------------------------------------
-- 4.  Asking, as a predicate on presentations
------------------------------------------------------------------------

data Presentation : Type where
  byStructure : Presentation
  byDecision  : Presentation

run : Presentation â†’ (â„• â†’ â„• â†’ â„•)
run byStructure = peel
run byDecision  = askâ„•

asks : Presentation â†’ Bool
asks byStructure = false
asks byDecision  = true

------------------------------------------------------------------------
-- 5.  THE COLLISION, and the obstruction it forces
--
-- Isolated in the shape the corpus already uses, so that the general
-- lemma applies rather than a fresh argument being written.
------------------------------------------------------------------------

asking-collision :
  Î£[ p âˆˆ Presentation ] Î£[ q âˆˆ Presentation ]
    ((run p â‰¡ run q) Ã— (Â¬ (asks p â‰¡ asks q)))
asking-collision = byStructure , byDecision , sameFunction , falseâ‰¢true

-- routed through TranscriptDescent.collisionObstructsDecoder,
-- the same lemma that carries Laghava Â§3, Anuvrtti Â§4, CarryBorrowObservation
-- and OneLemmaFiveSites.
asking-does-not-factor-through-the-function :
  Â¬ FactorsThrough run asks
asking-does-not-factor-through-the-function =
  collisionObstructsDecoder run asks {byStructure} {byDecision}
    sameFunction falseâ‰¢true

-- the same statement in the elementary form, kept because it is the one
-- a reader can check without opening two other modules
no-invariant-of-the-function-reports-asking :
  Â¬ (Î£[ f âˆˆ ((â„• â†’ â„• â†’ â„•) â†’ Bool) ]
       ((p : Presentation) â†’ f (run p) â‰¡ asks p))
no-invariant-of-the-function-reports-asking (f , h) =
  falseâ‰¢true (sym (h byStructure) âˆ™ cong f sameFunction âˆ™ h byDecision)

------------------------------------------------------------------------
-- 6.  The consequence for the decisionless discipline
--
-- "proclaimed 'no checking' yet used `discreteâ•`", was flagged, and was
-- kept out of the `Jiva` closure.  Â§5 says why that had to be caught by
-- reading and could not have been caught by the build: the closure
-- type-checks the functions, and asking is invisible to every invariant
-- of a function.
------------------------------------------------------------------------
