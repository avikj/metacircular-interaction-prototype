{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The 2719 gate: the kernel empties the 53 × 53 × 17 box once, and
-- the interface caches it.  2719 is the last and largest of
-- Ramanujan's eighteen; with this scan the entire soundness half of
-- his 1916 assertion becomes kernel-signed in the theorem layer.
------------------------------------------------------------------------

module Ramanujan2719Gate_TheKernelEmptiesTheLargeBoxOnceAndCachesIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Maybe using (Maybe ; just ; nothing)
open import Cubical.Data.Unit using (Unit ; tt)

open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (loop)
open import RamanujanTernary_BelowSevenTwentyTheOddExceptionsAreExactlyHisSeventeenTowardTheOpenList
  using (noHit)

scan2719 : Maybe Unit
scan2719 = loop (λ x → loop (λ y → loop (λ z → noHit 2719 x y z) 16) 52) 52

scan2719-ok : scan2719 ≡ just tt
scan2719-ok = refl
