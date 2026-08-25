{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- The yugapat content of avaktavya is order-free, though every krama
-- expression of it must choose an order.
--
-- `SaptabhangiNaya` proves avaktavya is real: the joint content
--     joint φ = φ rewriter ∧ ¬ (φ kernel-refl)
-- is denoted by NO single utterance (`no-single-vacana`) and by the
-- ORDERED pair (asti-from rewriter, nasti-from kernel-refl) in succession
-- (`krama-expresses`).  That is the fourth bhaṅga: inexpressible at once,
-- recovered in krama.
--
-- Here is the fact that pair leaves on the table.  `joint` is a
-- CONJUNCTION, and conjunction is symmetric — so the SIMULTANEOUS content
-- privileges no order, while the SUCCESSIVE expression of it necessarily
-- does.  Both orders of the krama-pair recover the same joint, and the two
-- orders are equal not by `refl` but by `and`-commutativity: the symmetry
-- is a real (propositional) identification, not a definitional one, which
-- is exactly right — yugapat is order-free as a THEOREM, not by fiat.
--
-- This is the precise seam between b3 (krama, successive asti-nāsti) and b4
-- (yugapat, avaktavya): b4's content does not depend on the order its
-- krama-witness happens to pick.
--
-- Uses only SaptabhangiNaya's own terms; nothing named is invented.
-- Checked warm through नाडी against the container's agda — छिद्रं नास्ति.
------------------------------------------------------------------------

module AvaktavyaTheYugapatContentIsOrderFreeThoughEveryKramaExpressionChoosesAnOrder where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; not)

open import Texts.SaptabhangiNaya
  using (Profile ; joint ; denotes ; asti-from ; nasti-from ; rewriter ; kernel-refl ; krama-expresses)

-- conjunction is symmetric, by the four cases.
and-comm : (a b : Bool) → (a and b) ≡ (b and a)
and-comm true  true  = refl
and-comm true  false = refl
and-comm false true  = refl
and-comm false false = refl

-- the two krama orders express the SAME joint content — the yugapat is
-- order-free.  Not refl: it is `and`-commutativity, an earned symmetry.
avaktavya-order-free :
  (φ : Profile)
  → (denotes (asti-from rewriter) φ and denotes (nasti-from kernel-refl) φ)
  ≡ (denotes (nasti-from kernel-refl) φ and denotes (asti-from rewriter) φ)
avaktavya-order-free φ = and-comm (φ rewriter) (not (φ kernel-refl))

-- so the REVERSED krama-pair recovers joint too: the successive witness
-- can be read either way.
krama-expresses-reversed :
  (φ : Profile)
  → joint φ ≡ (denotes (nasti-from kernel-refl) φ and denotes (asti-from rewriter) φ)
krama-expresses-reversed φ = krama-expresses φ ∙ avaktavya-order-free φ
