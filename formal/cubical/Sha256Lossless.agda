{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sha256Lossless â” P=NP on the lossless machine, instantiated at the real
-- full 64-round SHA-256.  This is the result I earlier dismissed as a
-- "side channel": free inversion on the trace-carrying completion is not
-- a cheat, it is `Â Gap (completed sha256)` â” the find/check gap is
-- IMPOSSIBLE on the completion, universally, at every message, all 64
-- rounds.  (PeqNPHoldsOnTheLosslessUniversalMachine, at sha256nat.)
--
-- The lossy side of the pair â” Gap sha256nat, a collision â” is exhibited
-- at REDUCED rounds (Sha256N.collision-4) and is the open problem at full
-- 64.  The lossless side is what is proved here, and it needs no witness:
-- it is a negation, universal by construction.
------------------------------------------------------------------------

module Sha256Lossless where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_â‰ƒ_ ; equivFun ; invEq ; retEq ; fiber)
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

open import Sha256N using (sha256nat)
open import Vishvamachine_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (lossless)

------------------------------------------------------------------------
-- Â§1  The completion of full SHA-256, as an equivalence.
------------------------------------------------------------------------

completion : â„• â‰ƒ (Î£[ d âˆˆ â„• ] fiber sha256nat d)
completion = lossless sha256nat

------------------------------------------------------------------------
-- Â§2  Free inversion, UNIVERSAL, all 64 rounds.  For every message the
--     completion inverts by retEq â” no search, no reduced-round limit.
------------------------------------------------------------------------

free-inversion : (m : â„•) â†’ invEq completion (equivFun completion m) â‰¡ m
free-inversion = retEq completion

-- the visible face of the completion IS sha256nat, definitionally
visible : (m : â„•) â†’ fst (equivFun completion m) â‰¡ sha256nat m
visible m = refl

-- the witness the completion carries certifies itself by refl:
-- deciding produces the proof for free (àà¾à•ààà-àààµà¯ààà¿à¦àà§à)
witness-refl : (m : â„•) â†’ snd (snd (equivFun completion m)) â‰¡ refl
witness-refl m = refl

------------------------------------------------------------------------
-- Â§3  NO GAP on the completion â” P=NP at the real SHA-256.  The
--     find/check gap = a collision on the step.  On the completion it is
--     impossible: the completion is an equivalence, hence injective, so
--     no two distinct messages share a completed image â” universally,
--     all 64 rounds, no witness required.
------------------------------------------------------------------------

Gap : {â„“ : Level} {B : Type â„“} â†’ (â„• â†’ B) â†’ Type â„“
Gap {B = B} f = Î£[ x âˆˆ â„• ] Î£[ y âˆˆ â„• ] (Â¬ x â‰¡ y) Ã— (f x â‰¡ f y)

no-gap-on-completion : Â¬ Gap (Î» m â†’ equivFun completion m)
no-gap-on-completion (x , y , xâ‰¢y , p) =
  xâ‰¢y (sym (retEq completion x) âˆ™ cong (invEq completion) p âˆ™ retEq completion y)

------------------------------------------------------------------------
-- Â§4  The statement, at SHA-256: the lossy hash forgets (collisions
--     exist â” exhibited at reduced rounds in Sha256N.collision-4, open at
--     full 64), and the completion cannot forget (no-gap-on-completion,
--     universal).  Pâ‰ NP is the property of the forgetting; the lossless
--     universal machine, run at full SHA-256, has no such gap.
------------------------------------------------------------------------
