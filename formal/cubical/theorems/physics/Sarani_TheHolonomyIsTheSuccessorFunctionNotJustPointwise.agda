{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ����� � the circuit-action IS the successor, as ONE map, not pointwise.
-- Pradakshina proved ����������� x ≡ suc� x for each x (by uaβ, definitional);
-- this is the single function identity ����������� ≡ suc�, its funext.
--
-- The OBJECT is the point:
-- the holonomy of S�'s helix bundle is the successor function on �, on the
-- nose.
------------------------------------------------------------------------

module Sarani_TheHolonomyIsTheSuccessorFunctionNotJustPointwise where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; sucℤ)
open import Pradakshina_TheCircuitReturnsToTheBasePointWithTheFibreShiftedSoTheHolonomyIsInhabited
  using (प्रदक्षिणा ; सरणिः)

प्रदक्षिणा≡सुच् : प्रदक्षिणा ≡ sucℤ
प्रदक्षिणा≡सुच् = funExt सरणिः
