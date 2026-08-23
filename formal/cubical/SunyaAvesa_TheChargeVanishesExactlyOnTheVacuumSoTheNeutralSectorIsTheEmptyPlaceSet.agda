{-# OPTIONS --cubical --safe #-}
--
-- शून्य-आवेशः — the charge is zero.  Written with holes and composed in
-- conversation with the kernel; the header is filled in when the holes are.
--
-- WHAT IS BEING ASKED.  `OjaYugma_...` checked that the squarefree prime
-- charge is − Ω · λ, with Ω the active-place count and λ = (−1)^Ω the parity
-- character of `notes/GAUGE.md` Theorem F.  Theorem F says the twirl's
-- fixed-point algebra is the NEUTRAL sector and every charged observable has
-- expectation zero.  `notes/KsayopasamaAvarana_...` reads that as "r = 0 is
-- Theorem F" — a rank-zero separable family is the zero function.
--
-- That reading is only worth its words if the charge vanishes exactly on the
-- vacuum: nowhere else.  Here it is asked as a question.
module SunyaAvesa_TheChargeVanishesExactlyOnTheVacuumSoTheNeutralSectorIsTheEmptyPlaceSet where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false)
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Int
  using (ℤ; pos; -_; _+_; _·_; -Involutive; -DistR·; -DistL·; ·DistL+; ·Assoc; ·Comm; pos+; pos0+; injPos)

open import OjaYugma_TheSquarefreeChargeIsTheActivePlaceCountTimesTheParityCharacter
  using (चिह्नम्; सक्रियम्; ओजः; पर्यायः; आवेशः; ओजयुग्म-नियमः)

-- λ² = 1: the parity character squares to the unit, so it is never zero and
-- multiplying by it is invertible.
पर्याय-वर्गः : (bs : List Bool) → पर्यायः bs · पर्यायः bs ≡ pos (suc zero)
पर्याय-वर्गः [] = refl
पर्याय-वर्गः (true ∷ bs) =
  sym (-DistL· (पर्यायः bs) (- पर्यायः bs))
  ∙ cong (λ z → - z) (sym (-DistR· (पर्यायः bs) (पर्यायः bs)))
  ∙ -Involutive (पर्यायः bs · पर्यायः bs)
  ∙ पर्याय-वर्गः bs
पर्याय-वर्गः (false ∷ bs) = पर्याय-वर्गः bs

-- The magnitude is readable: multiply the charge by λ and the parity cancels.
आवेश-परिमाणम् : (bs : List Bool) → आवेशः bs · पर्यायः bs ≡ - (pos (ओजः bs))
आवेश-परिमाणम् bs = {!!}

-- The r = 0 face: the charge is zero exactly on the empty place set.
शून्य-आवेशः : (bs : List Bool) → आवेशः bs ≡ pos zero → ओजः bs ≡ zero
शून्य-आवेशः bs h = {!!}

आवेश-शून्यः : (bs : List Bool) → ओजः bs ≡ zero → आवेशः bs ≡ pos zero
आवेश-शून्यः bs h = {!!}
