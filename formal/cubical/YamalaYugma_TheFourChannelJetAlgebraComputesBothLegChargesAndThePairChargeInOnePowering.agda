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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- यमल-युग्मम् — the twin pair.  The 4-channel jet transfer of the owner's
-- twin message (μ⊗μ / κ⊗μ / μ⊗κ / κ⊗κ), as the algebra
--
--     ℤ[ε₁,ε₂] / (ε₁², ε₂²)  =  (value, leg₁, leg₂, pair),
--
-- extending Yamala's one-leg dual numbers to two legs.  The PAIR channel
-- ε₁ε₂ is where twin correlation lives: multiplying two elements, its
-- component obeys the SECOND-ORDER twisted Leibniz law
--
--     (xy)₁₂ = x·y₁₂ + x₁·y₂ + x₂·y₁ + x₁₂·y,
--
-- definitional here (§2) — the two cross terms x₁y₂ + x₂y₁ are the two
-- ways one charge lands on each leg, the interference of the twin walls.
--
-- AND THE AUTOMATIC DIFFERENTIATION, TWO ORDERS AT ONCE (§3): lift z to
-- (z,1,1,0) and power it.  The result carries
--
--     ( zⁿ , n·zⁿ⁻¹ , n·zⁿ⁻¹ , n(n−1)·zⁿ⁻² )
--
-- — value, both first charges, and the SECOND FACTORIAL MOMENT in the
-- pair channel, with no differentiation rule supplied.  At z = −1,
-- n = ω(d): (μ, κ₁, κ₁, κ₂) — Yamala's jet plus the two-prime pair
-- charge κ₂(d) = ω(ω−1)(−1)^ω, the κ⊗κ channel of the twin transfer,
-- computed by the same ⊛-powering that computes μ.  The divisor-tree
-- exponential is again discarded for a 4-slot exact state.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9), ring identities by
-- solve! with ΣPathP componentwise; the recurrences native.
------------------------------------------------------------------------

module YamalaYugma_TheFourChannelJetAlgebraComputesBothLegChargesAndThePairChargeInOnePowering where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.Int using (ℤ; pos; _+_; _·_)
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd; ΣPathP)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

-- the twin-pair jet: (value, leg₁ charge, leg₂ charge, pair charge).
J² : Type
J² = ℤ × ℤ × ℤ × ℤ

-- multiplication in ℤ[ε₁,ε₂]/(ε₁²,ε₂²): εᵢ² = 0 kills same-leg squares,
-- the pair channel collects the four surviving second-order routes.
_⊛₂_ : J² → J² → J²
(a , a₁ , a₂ , a₁₂) ⊛₂ (b , b₁ , b₂ , b₁₂) =
  ( a · b
  , a · b₁ + a₁ · b
  , a · b₂ + a₂ · b
  , a · b₁₂ + a₁ · b₂ + a₂ · b₁ + a₁₂ · b )

one₂ : J²
one₂ = (pos 1 , pos 0 , pos 0 , pos 0)

------------------------------------------------------------------------
-- §1 · commutative monoid: the transfer composes.
⊛₂-assoc : (x y z : J²) → (x ⊛₂ y) ⊛₂ z ≡ x ⊛₂ (y ⊛₂ z)
⊛₂-assoc (a , a₁ , a₂ , a₁₂) (b , b₁ , b₂ , b₁₂) (c , c₁ , c₂ , c₁₂) =
  ΣPathP (solve! ℤCommRing , ΣPathP (solve! ℤCommRing ,
  ΣPathP (solve! ℤCommRing , solve! ℤCommRing)))

⊛₂-comm : (x y : J²) → x ⊛₂ y ≡ y ⊛₂ x
⊛₂-comm (a , a₁ , a₂ , a₁₂) (b , b₁ , b₂ , b₁₂) =
  ΣPathP (solve! ℤCommRing , ΣPathP (solve! ℤCommRing ,
  ΣPathP (solve! ℤCommRing , solve! ℤCommRing)))

⊛₂-unitˡ : (x : J²) → one₂ ⊛₂ x ≡ x
⊛₂-unitˡ (a , a₁ , a₂ , a₁₂) =
  ΣPathP (solve! ℤCommRing , ΣPathP (solve! ℤCommRing ,
  ΣPathP (solve! ℤCommRing , solve! ℤCommRing)))

------------------------------------------------------------------------
-- §2 · the four channels of a product, named: μ⊗μ / κ⊗μ / μ⊗κ / κ⊗κ.
-- The pair channel's law — the second-order twisted Leibniz — is
-- DEFINITIONAL: the four routes to double charge are the whole content.
pairChannel : (x y : J²) →
  snd (snd (snd (x ⊛₂ y)))
    ≡ fst x · snd (snd (snd y))
    + fst (snd x) · fst (snd (snd y))
    + fst (snd (snd x)) · fst (snd y)
    + snd (snd (snd x)) · fst y
pairChannel (a , a₁ , a₂ , a₁₂) (b , b₁ , b₂ , b₁₂) = refl

-- each leg projects to Yamala's one-leg dual numbers homomorphically:
-- forgetting a leg forgets its charge and the pair, keeps the other jet.
leg₁ : J² → ℤ × ℤ
leg₁ (a , a₁ , a₂ , a₁₂) = (a , a₁)

leg₁-hom : (x y : J²)
  → leg₁ (x ⊛₂ y) ≡ ( fst x · fst y
                     , fst x · fst (snd y) + fst (snd x) · fst y )
leg₁-hom (a , a₁ , a₂ , a₁₂) (b , b₁ , b₂ , b₁₂) = refl

------------------------------------------------------------------------
-- §3 · AUTOMATIC DIFFERENTIATION, TWO ORDERS AT ONCE.  The scalar tower:
-- power, first charge, and the pair charge's recurrence
--     mixed (suc n) = z · mixed n + 2·deriv n
-- (each new factor either contributes its unit to one of the two legs of
-- an existing single charge — two ways — or lets an existing pair ride).
pow : ℤ → ℕ → ℤ
pow z zero    = pos 1
pow z (suc n) = z · pow z n

deriv : ℤ → ℕ → ℤ
deriv z zero    = pos 0
deriv z (suc n) = z · deriv z n + pow z n

mixed : ℤ → ℕ → ℤ
mixed z zero    = pos 0
mixed z (suc n) = z · mixed z n + (deriv z n + deriv z n)

-- the doubly-lifted base and its ⊛₂-powers.
dpow₂ : ℤ → ℕ → J²
dpow₂ z zero    = one₂
dpow₂ z (suc n) = (z , pos 1 , pos 1 , pos 0) ⊛₂ dpow₂ z n

-- THE TWO-LEG AD THEOREM: one powering computes value, both leg charges,
-- and the pair charge.  At z = −1, n = ω(d): (μ, κ₁, κ₁, κ₂).
autodiff₂ : (z : ℤ) (n : ℕ)
  → dpow₂ z n ≡ (pow z n , deriv z n , deriv z n , mixed z n)
autodiff₂ z zero    = refl
autodiff₂ z (suc n) =
  cong ((z , pos 1 , pos 1 , pos 0) ⊛₂_) (autodiff₂ z n)
  ∙ ΣPathP (refl , ΣPathP (step , ΣPathP (step , stepPair)))
  where
  -- leg channels: z·deriv + 1·pow ≡ deriv (suc n)
  step : z · deriv z n + pos 1 · pow z n ≡ z · deriv z n + pow z n
  step = solve! ℤCommRing
  -- pair channel: z·mixed + 1·deriv + 1·deriv + 0·pow ≡ mixed (suc n)
  stepPair : z · mixed z n + pos 1 · deriv z n + pos 1 · deriv z n
             + pos 0 · pow z n
           ≡ z · mixed z n + (deriv z n + deriv z n)
  stepPair = solve! ℤCommRing
