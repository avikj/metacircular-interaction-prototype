{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Finite associativity audit for the explicitly generated Delta 29 middle
-- family.  The exhaustive normalization is sealed abstractly: consumers use
-- the theorem without re-expanding the 64 x 4 min/max calculations.
------------------------------------------------------------------------

module NaturalMachine.DSONucleusMiddleAssociativityAudit where

open import Cubical.Foundations.Prelude
import NaturalMachine.DSONucleusExecutionCalibration as E
open import NaturalMachine.DSONucleusMiddleProduct

abstract
  middle-assoc : (x y z : Generator)
    → (middleSeed x ⊙M middleSeed y) ⊙M middleSeed z
      ≡ middleSeed x ⊙M (middleSeed y ⊙M middleSeed z)
  middle-assoc genZero genZero genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genZero genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genZero genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genZero genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genA genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genA genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genA genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genA genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genC genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genC genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genC genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genC genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genControl genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genControl genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genControl genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genZero genControl genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genZero genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genZero genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genZero genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genZero genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genA genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genA genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genA genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genA genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genC genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genC genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genC genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genC genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genControl genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genControl genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genControl genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genA genControl genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genZero genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genZero genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genZero genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genZero genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genA genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genA genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genA genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genA genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genC genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genC genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genC genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genC genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genControl genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genControl genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genControl genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genC genControl genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genZero genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genZero genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genZero genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genZero genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genA genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genA genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genA genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genA genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genC genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genC genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genC genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genC genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genControl genZero =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genControl genA =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genControl genC =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }
  middle-assoc genControl genControl genControl =
    funExt λ { E.e → refl ; E.a → refl ; E.c → refl ; E.d → refl }

-- Scope remains only Generator^3.  Abstract sealing changes proof reduction,
-- not the theorem or its fail-visible exhaustive verification.
