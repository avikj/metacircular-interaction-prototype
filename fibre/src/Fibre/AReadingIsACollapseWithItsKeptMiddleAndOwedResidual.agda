{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- AReadingIsACollapseWithItsKeptMiddleAndOwedResidual
--
-- The kernel overview names "six readings of the same object — memory,
-- charge, symmetry, price, distance, verdict" and points OUTWARD to
-- separate theorem files. This module does NOT pretend those six domain
-- theorems are one term (they are not, and forcing them would be the hollow
-- consolidation §0 of the overview warns against). It builds the shared
-- SHAPE every reading instantiates, so a reading stops being prose and
-- becomes a structure a domain file can inhabit.
--
-- A READING is a collapse `f : Source → Target` whose readout lands in a
-- set (a reading decategorifies — the recurring fact of this corpus). From
-- it the Carrier/Sesa law derives, at the record level:
--
--   middle          = Carrier f          -- the universal lossless middle
--   residual b      = शेष f b            -- what the collapse forgets over b
--   middle≃source   : middle ≃ Source    -- the source reading NEVER loses
--   lossless-iff    : (every residual contractible) → middle ≃ Target
--
-- So "reading" = a collapse together with its kept middle and owed
-- residual, and the two halves of the design law are its two derived
-- theorems. A typed family of readings is then just a function into
-- `Reading`; §3 gives the `verdict` reading (Bool → Unit) as a checked
-- instance whose residual is exactly one bit.
------------------------------------------------------------------------

module Fibre.AReadingIsACollapseWithItsKeptMiddleAndOwedResidual where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Unit using (Unit ; isSetUnit ; tt)

open import Fibre.Carrier
open import Fibre.Sesa_TheResidualIsTheOtherProjectionOfTheSameGraph

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The shape of a reading.
------------------------------------------------------------------------

record Reading (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Source     : Type ℓ
    Target     : Type ℓ
    collapse   : Source → Target
    target-set : isSet Target      -- the readout decategorifies into a set

  -- the universal lossless middle of this reading
  middle : Type ℓ
  middle = Carrier collapse

  -- what the collapse forgets over a target point
  residual : Target → Type ℓ
  residual = शेष collapse

  -- THE SOURCE READING NEVER LOSES : unconditionally an equivalence.
  middle≃source : middle ≃ Source
  middle≃source = मूल-प्रक्षेप-समता collapse

  -- THE TARGET READING is lossless exactly when every residual vanishes.
  lossless-iff : ((b : Target) → isContr (residual b)) → middle ≃ Target
  lossless-iff = निःशेषः→समता collapse

open Reading

------------------------------------------------------------------------
-- §2  The verdict reading : Bool → Unit, a checked instance whose residual
--     over the single target point is exactly one bit. A typed family of
--     readings is then just a function `I → Reading`.
------------------------------------------------------------------------

verdict : Reading ℓ-zero
Source     verdict = Bool
Target     verdict = Unit
collapse   verdict = सर्वैकम्
target-set verdict = isSetUnit

-- the residual of the verdict reading is one bit, from Fibre.Sesa
verdict-residual-is-one-bit : residual verdict tt ≃ Bool
verdict-residual-is-one-bit = शेष-सर्वैकम्≃Bool
