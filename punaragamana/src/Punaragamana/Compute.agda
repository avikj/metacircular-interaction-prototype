-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- Executable regression suite.
--
-- Not restatements of the theorems -- the claim that the development
-- COMPUTES.  Each holds by refl, so Agda must normalize both sides to
-- the same numeral.  If a change makes something reduce only
-- propositionally, this module breaks and the others do not.
------------------------------------------------------------------------

module Punaragamana.Compute where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; suc; _+_)
open import Cubical.Data.Sigma using (_×_; _,_)

open import Punaragamana.Orbit
open import Punaragamana.Viveka

दो-पद : जाल
दो-पद = पुनः (पुनः (आरम्भ (2 , 3)))

-- (2,3) → (3,4) → (4,5)
पद-निर्देशांक : उत्थान (इदम् दो-पद) ≡ (4 , 5)
पद-निर्देशांक = refl

-- the carried sum is recomputed, not stale payload
पद-दक्षिण : दक्षिण (इदम् दो-पद) ≡ 9
पद-दक्षिण = refl

-- the witness is genuinely inhabited there
पद-प्रमाण : 4 + 5 ≡ दक्षिण (इदम् दो-पद)
पद-प्रमाण = प्रमाण (इदम् दो-पद)

-- deeper, via lookup
दश-पद : उत्थान (lookup (आरम्भ (2 , 3)) 10) ≡ (12 , 13)
दश-पद = refl

दश-दक्षिण : दक्षिण (lookup (आरम्भ (2 , 3)) 10) ≡ 25
दश-दक्षिण = refl

-- transport along ua computes on CANONICAL input ...
परिवहन-गणना : दक्षिण (परिवहन (2 , 3)) ≡ 5
परिवहन-गणना = refl

परिवहन-निर्देशांक : उत्थान (परिवहन (2 , 3)) ≡ (2 , 3)
परिवहन-निर्देशांक = refl

-- ... but NOT on a neutral variable. Recorded as a NON-theorem, which is
-- exactly why परिवहन-अवतरण (uaβ) is load-bearing rather than decorative:
--
--   (x : ℕ × ℕ) → परिवहन x ≡ अवतरण x
--   ✗  transp (λ i → विवेक) i0 (prim^unglue x) != अवतरण x
--
-- The propositional statement is परिवहन-अवतरण, and it holds for all x.

-- the square closes definitionally for an OPAQUE variable
वर्ग-अपारदर्शी : (v : विवेक) → उत्थान (Φ-विवेक v) ≡ Φ (उत्थान v)
वर्ग-अपारदर्शी v = refl

अवतरण-अपारदर्शी : (x : ℕ × ℕ) → उत्थान (अवतरण x) ≡ x
अवतरण-अपारदर्शी x = refl
