{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सरणिः — the circuit-action IS the successor, as ONE map, not pointwise.
-- Pradakshina proved प्रदक्षिणा x ≡ sucℤ x for each x (by uaβ, definitional);
-- this is the single function identity प्रदक्षिणा ≡ sucℤ, its funext.
--
-- The OBJECT is the point:
-- the holonomy of S¹'s helix bundle is the successor function on ℤ, on the
-- nose.
------------------------------------------------------------------------

module TheHolonomyIsTheSuccessorFunctionNotJustPointwise where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; sucℤ)
open import TheCircuitReturnsToTheBasePointWithTheFibreShiftedSoTheHolonomyIsInhabited
  using (प्रदक्षिणा ; सरणिः)

प्रदक्षिणा≡सुच् : प्रदक्षिणा ≡ sucℤ
प्रदक्षिणा≡सुच् = funExt सरणिः
