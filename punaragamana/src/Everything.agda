{-# OPTIONS --cubical --safe --guardedness #-}

-- Punarāgamana · Everything
--
-- The single entry point: typechecking this module typechecks the library.

module Everything where

open import Punaragamana.Carrier
open import Punaragamana.Orbit
open import Punaragamana.Nucleus

-- PENDING — do not invent these two.  They are specified to arrive in a
-- second message: an arithmetic instance (Viveka) and an executable
-- regression suite pinning concrete numerals (Compute).  The import lines are
-- left here, commented, so that adding them is one edit and so that their
-- absence is visible rather than silent; uncomment as each module lands.
--
-- open import Punaragamana.Viveka
-- open import Punaragamana.Compute
