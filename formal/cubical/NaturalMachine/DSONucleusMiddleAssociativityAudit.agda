{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Finite associativity audit for the explicitly generated Delta 29 middle
-- family.  The proof factors by the first generator; the remaining generators
-- stay symbolic.  Thus each output coordinate is normalized four times rather
-- than once for every one of 64 triples.
------------------------------------------------------------------------

module NaturalMachine.DSONucleusMiddleAssociativityAudit where

open import Cubical.Foundations.Prelude

import NaturalMachine.DSONucleusExecutionCalibration as E
open import NaturalMachine.DSONucleusMiddleProduct

middle-assoc : (x y z : Generator)
  → (middleSeed x ⊙M middleSeed y) ⊙M middleSeed z
    ≡ middleSeed x ⊙M (middleSeed y ⊙M middleSeed z)
middle-assoc genZero y z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genA y z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genC y z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genControl y z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

-- Scope: this remains only the four generated seeds.  The symbolic y,z
-- factorization is a proof compression, not a generalization of the theorem.
