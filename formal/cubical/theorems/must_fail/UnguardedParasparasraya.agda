{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- UnguardedParasparasraya
--
-- *** THIS FILE MUST FAIL TO TYPE-CHECK. ***
--
-- The negative control of
-- `logic/Parasparasraya_TheMutualDependenceObjectionChecks…`: the
-- TRADITIONAL parasparāśraya, the vicious circle the Nyāya and Jaina
-- literature catalogued as a defect of definition.  Two streams, each
-- defined as the other WITH NO CONSTRUCTOR GUARDING THE LEANING: no
-- observation is produced at any step, so the circle establishes
-- nothing — and the typechecker must say so.
--
-- WHY IT MUST FAIL.  `śeṣam` alone strips a coinductive layer without
-- producing one; the definitions below are corecursive calls at depth
-- zero, so the termination/productivity checker rejects them.  If this
-- file ever compiles, the guardedness criterion has stopped separating
-- the generative circle from the vicious one, and the positive module's
-- entire claim — that the typechecker is the arbiter — is void.  A
-- control that starts compiling is itself the defect.
--
-- The positive counterpart differs in exactly one respect: there, each
-- stream's head is produced BEFORE the leaning (`śiras` is defined and
-- `śeṣam` refers across), so every observation depth is answered.  The
-- distance between defect and definition is one guarded constructor.
------------------------------------------------------------------------

module UnguardedParasparasraya where

open import Cubical.Foundations.Prelude using (Type)
open import Cubical.Data.Bool using (Bool)

record Dhārā (A : Type) : Type where
  coinductive
  field
    śiras : A
    śeṣam : Dhārā A

open Dhārā

-- The vicious circle: each stream IS the tail of the other, with no
-- head ever produced.  parasparāśraya in the tradition's own sense.
mutual
  śūnya : Dhārā Bool
  śūnya = śeṣam riktā

  riktā : Dhārā Bool
  riktā = śeṣam śūnya
