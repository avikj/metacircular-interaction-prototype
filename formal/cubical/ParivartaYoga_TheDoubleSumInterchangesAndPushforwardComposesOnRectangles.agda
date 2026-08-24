-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- परिवर्तयोगः — the double sum interchanges, and pushforward composes
-- on rectangles.
--
-- TERM.  परिवर्त (interchange, turning about) and योग (sum, as in the
-- measure lane's योगफल/शाखितयोगः vocabulary).  The compound परिवर्त-योग
-- is built here; no source is claimed for it.
--
-- SEED.  The owner's transmission of 2026-08-23 ("causal horizon"):
-- "the next finite theorem is Fubini as transport."  The full statement
-- — g_!(f_!w) ≡ (g∘f)_!w across the fibre-composition equivalence शेष
-- (fc/Sesa_TheCompositesRemainder…:92) — needs fibre ENUMERATIONS,
-- which the corpus does not yet carry for arbitrary maps.  What is
-- landable exactly, today, is the RECTANGULAR case, which is also the
-- interchange law the span/path-integral reading consumes first:
--
--     Σ_y Σ_z w(y,z)  ≡  Σ_z Σ_y w(y,z)
--
-- over nonempty SumFin index types, spending exactly associativity and
-- commutativity — the same two laws क्रमनैरपेक्ष्यम् spends, and no
-- more.  On a rectangle X = Fin(1+a) × Fin(1+b) with the two
-- projections as observations, the nested totals ARE f_! then g_!, so
-- this theorem is pushforward functoriality for the product square —
-- the case where both fibres are constant.  The general fib version
-- remains owed and is named in the ledger.
--
-- WHAT IS PROVED.
--
--   विभाजनम्     the pointwise sum splits across a total:
--                total (λ z → f z +ᵂ g z) ≡ total f +ᵂ total g.
--                This is the "abides" law; it is where assoc and comm
--                are spent, through the four-point exchange विनिमयः.
--   परिवर्तः      THE INTERCHANGE: the two nesting orders of the double
--                total agree, for every rectangular weight family.
--
-- WHAT IS NOT CLAIMED.  Not the dependent Fubini over fib_{g∘f} ≃
-- Σ fib_g fib_f (owed: fibre enumerations + transport of the fold along
-- क्रमनैरपेक्ष्यम्'s invariance); not any infinite or measure-theoretic
-- statement.  The algebra ledger for the lane now reads: SamaVibhaga
-- none · SthulaBhara assoc · BahuShakha none · KramaNairapeksya
-- assoc+comm · ParivartaYoga assoc+comm.
------------------------------------------------------------------------

module ParivartaYoga_TheDoubleSumInterchangesAndPushforwardComposesOnRectangles where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total)

private
  variable
    ℓ : Level

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W)
         (assoc : (x y z : W) → x +ᵂ (y +ᵂ z) ≡ (x +ᵂ y) +ᵂ z)
         (comm  : (x y : W) → x +ᵂ y ≡ y +ᵂ x) where

  -- the four-point exchange: (x+y)+(z+w) ≡ (x+z)+(y+w).
  विनिमयः : (x y z w : W)
          → (x +ᵂ y) +ᵂ (z +ᵂ w) ≡ (x +ᵂ z) +ᵂ (y +ᵂ w)
  विनिमयः x y z w =
      sym (assoc x y (z +ᵂ w))
    ∙ cong (x +ᵂ_) (assoc y z w
                    ∙ cong (_+ᵂ w) (comm y z)
                    ∙ sym (assoc z y w))
    ∙ assoc x z (y +ᵂ w)

  -- the pointwise sum splits across a total.
  विभाजनम् : (b : ℕ) (f g : Fin (suc b) → W)
           → total _+ᵂ_ b (λ z → f z +ᵂ g z)
             ≡ (total _+ᵂ_ b f) +ᵂ (total _+ᵂ_ b g)
  विभाजनम् zero    f g = refl
  विभाजनम् (suc b) f g =
      cong ((f fzero +ᵂ g fzero) +ᵂ_)
           (विभाजनम् b (λ z → f (fsuc z)) (λ z → g (fsuc z)))
    ∙ विनिमयः (f fzero) (g fzero)
              (total _+ᵂ_ b (λ z → f (fsuc z)))
              (total _+ᵂ_ b (λ z → g (fsuc z)))

  -- THE INTERCHANGE.
  परिवर्तः : (a b : ℕ) (w : Fin (suc a) → Fin (suc b) → W)
           → total _+ᵂ_ a (λ y → total _+ᵂ_ b (w y))
             ≡ total _+ᵂ_ b (λ z → total _+ᵂ_ a (λ y → w y z))
  परिवर्तः zero    b w = refl
  परिवर्तः (suc a) b w =
      cong (total _+ᵂ_ b (w fzero) +ᵂ_)
           (परिवर्तः a b (λ y → w (fsuc y)))
    ∙ sym (विभाजनम् b (w fzero)
                      (λ z → total _+ᵂ_ a (λ y → w (fsuc y) z)))
