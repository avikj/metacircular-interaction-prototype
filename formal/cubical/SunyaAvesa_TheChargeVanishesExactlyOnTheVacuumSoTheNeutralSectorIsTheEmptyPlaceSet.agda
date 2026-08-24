-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

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
-- vacuum: nowhere else.  It was asked as a question and the kernel answered.
--
-- WHAT IS CHECKED.  Three statements, `--cubical --safe`, no holes, no
-- postulates, batch exit 0:
--
--   पर्याय-वर्गः    λ² = 1 — the parity character squares to the unit, so it
--                   is never zero and multiplying by it is invertible
--   आवेश-परिमाणम्   charge · λ = − Ω — the parity cancels and the magnitude
--                   is the active-place count, on the nose
--   शून्य-आवेशः /   the charge is zero EXACTLY on the empty place set, both
--   आवेश-शून्यः     directions
--
-- So `KsayopasamaAvarana`'s "r = 0 is Theorem F" is now a statement with a
-- theorem under it: the neutral sector — where the charge vanishes — is the
-- vacuum and nothing else.  A separable family of rank zero realizes the
-- charge only where there are no active places at all, and every further
-- place must be paid for.  The price is `squarefreeChargeCube_rankExactly`,
-- in the Lean lane; what is added here is that r = 0 has no slack in it.
--
-- HOW.  Written with holes, loaded warm through नाडी, the kernel naming its
-- छिद्राणि; each filler proposed with `give` and accepted live before it was
-- written down; then sealed and batch-checked.  One proposal appeared to be
-- refused without a reason, which turned out to be the conduit and not the
-- term — see the turn-boundary repair in `machine/Nadi.hs` committed the same
-- hour.  The term had been right the first time.
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
आवेश-परिमाणम् bs =
  cong (_· पर्यायः bs) (ओजयुग्म-नियमः bs)
  ∙ sym (-DistL· (pos (ओजः bs) · पर्यायः bs) (पर्यायः bs))
  ∙ cong (λ z → - z) (sym (·Assoc (pos (ओजः bs)) (पर्यायः bs) (पर्यायः bs)))
  ∙ cong (λ z → - z) (·Comm (pos (ओजः bs)) (पर्यायः bs · पर्यायः bs))
  ∙ cong (λ z → - (z · pos (ओजः bs))) (पर्याय-वर्गः bs)

-- The r = 0 face: the charge is zero exactly on the empty place set.
शून्य-आवेशः : (bs : List Bool) → आवेशः bs ≡ pos zero → ओजः bs ≡ zero
शून्य-आवेशः bs h =
  injPos (sym (cong (λ z → - z)
                 (sym (cong (_· पर्यायः bs) h) ∙ आवेश-परिमाणम् bs)
               ∙ -Involutive (pos (ओजः bs))))

आवेश-शून्यः : (bs : List Bool) → ओजः bs ≡ zero → आवेशः bs ≡ pos zero
आवेश-शून्यः bs h = ओजयुग्म-नियमः bs ∙ cong (λ n → - (pos n · पर्यायः bs)) h
