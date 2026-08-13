{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine
--
-- The generative presentation of the natural numbers, machine-checked,
-- with positional notation exhibited as a CHART rather than as the
-- object.  Companion prose: notes/NATURAL_MACHINE.md.
--
-- Thesis, in one sentence: symbols are π₀, geometry lives in identity
-- types, and univalence is what makes them say the same thing.
--
-- HEADLINE STATEMENTS (all checked, no postulates, no holes, --safe):
--
--  1. pathIsSymmetry        (X ≡ X) ≃ (X ≃ X), any type X.
--     ΩGroup≃Symmetric      ... and it is a group isomorphism onto the
--                           symmetric group of X; specialised to
--                           ΩFin≃Sym : Ω(Type, Fin n) ≅ Sₙ.
--
--  2. ℕ-algebra-Aut-trivial The initial (1 + X)-algebra is rigid, while
--     swap01-≢-id           ℕ as a bare type is not.  Structure is what
--                           cuts symmetry down; that is the SIP.
--
--  3. ℕ≃Tally / ℕ≃CanWord   Three presentations, defined independently,
--                           with equivalences CONSTRUCTED (the digit one
--                           through the odometer `sucw` and injectivity
--                           of `value` on canonical words).
--
--  4. transport-+-is-⊕      Transporting ℕ's addition along `ua` yields
--                           literally the schoolbook ripple-carry
--                           algorithm defined natively on digit words.
--     ℕ-Monoid≡CanWord-Monoid
--                           ... and the two monoids are EQUAL, by SIP.
--
--  5. chartSymmetry         Reversal and complement are commuting
--                           involutions of the digit chart (Klein four)
--                           and NEITHER descends along the value map;
--                           complement is π-equivariant, reversal is
--                           not, and reversal instead exchanges the two
--                           truncations.  Place value is a chart.
--
--  6. card≡MereEq           ℕ is π₀ of FinSet; the numeral names a
--     FinSetLoop≃Sym        connected component, and what it forgets is
--                           the loop space Sₙ.
--
--  7. Controls              Canonicity is load-bearing, the big-endian
--                           misreading is refuted, and a deliberately
--                           wrong equivalence fails to type-check (in
--                           NaturalMachine/Control/, excluded here).
------------------------------------------------------------------------

module NaturalMachine where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)

open import NaturalMachine.PathIsSymmetry public
open import NaturalMachine.FreeMonoid public
open import NaturalMachine.CountedExecution public
open import NaturalMachine.SmithPathCountedExecution public
open import NaturalMachine.Decategorification public
open import NaturalMachine.SymmetryCardinality public
open import NaturalMachine.SymmetryArithmeticAction public
open import NaturalMachine.SmithCapability public
open import NaturalMachine.DigitTowerLimit public

import NaturalMachine.Digits
import NaturalMachine.Endian
import NaturalMachine.Transport
import NaturalMachine.Controls
import NaturalMachine.CountedDigits
import NaturalMachine.ResidueTransport

------------------------------------------------------------------------
-- The base-dependent development, instantiated.  Every statement holds
-- for every base b = 2 + k; these are two concrete witnesses that the
-- parameterised modules really do instantiate.
------------------------------------------------------------------------

module Base2 where
  open NaturalMachine.Digits    0 public
  open NaturalMachine.Endian    0 public
  open NaturalMachine.Transport 0 public
  open NaturalMachine.Controls  0 public
  open NaturalMachine.ResidueTransport 0 public

module Base10 where
  open NaturalMachine.Digits    8 public
  open NaturalMachine.Endian    8 public
  open NaturalMachine.Transport 8 public
  open NaturalMachine.Controls  8 public
  open NaturalMachine.CountedDigits 8 public
  open NaturalMachine.ResidueTransport 8 public

-- Sanity: the module parameter really is the base offset.
base2-is-2 : Base2.b ≡ 2
base2-is-2 = refl

base10-is-10 : Base10.b ≡ 10
base10-is-10 = refl
