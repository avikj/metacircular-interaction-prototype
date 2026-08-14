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
middle-assoc genZero genZero z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genZero genA z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genZero genC z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genZero genControl z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genA genZero z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genA genA z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genA genC z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genA genControl z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genC genZero z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genC genA z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genC genC z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genC genControl z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genControl genZero z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genControl genA z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genControl genC z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
middle-assoc genControl genControl z =
  funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

-- Scope: this remains only the four generated seeds.  The symbolic y,z
-- factorization is a proof compression, not a generalization of the theorem.
