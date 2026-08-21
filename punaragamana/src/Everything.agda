{-# OPTIONS --cubical --safe --guardedness #-}

-- Punarāgamana · Everything
--
-- The single entry point: typechecking this module typechecks the library.
-- check.sh drives exactly this file, so a module that is not reachable from
-- here is verified by nothing.

module Everything where

-- The law, and the machinery it generates.
open import Punaragamana.Carrier
open import Punaragamana.Orbit
open import Punaragamana.Nucleus

-- The arithmetic instance, and the proof that it computes.
open import Punaragamana.Viveka
open import Punaragamana.Compute
