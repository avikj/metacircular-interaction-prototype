{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BoundaryBlock — the mean square of a received signal Σₜ b(t)², where
-- b(t) = Σₙ cₙ f(t − n) is the receiver f driven by the coefficients c,
-- equals the pair field cₘ cₙ paired with the receiver's autocorrelation
-- ρ(m − n) = Σₜ f(t) f(t + (m − n)):
--
--     Σₜ ( Σₙ cₙ f(t − n) )²  ≡  Σₘ Σₙ cₘ cₙ ρ(m − n).
--
-- WHAT THIS IS.  The prime-boundary document's §4 boundary profile
-- h = f ∗ f̃ and the earlier "prime-side mean square Q_T(h) ≥ 0": the
-- left side is manifestly a sum of squares, the right side is the
-- pairing of the pair field with h = ρ.  So positivity of the pair-field
-- pairing at an autocorrelation receiver is an identity, not an
-- estimate — that is why the document's receiver is chosen as f ∗ f.
-- Over any commutative ring, at fixed finite sizes:
--
--   §1  receiver f on four slots {0,1,2,3}, coefficients c on three
--       slots {0,1,2}, received signal b on six slots {0,…,5};
--   §2  ρ₀ ρ₁ ρ₂ the autocorrelation lags (ρ₃ = 0 because the receiver
--       has width four and the coefficients width three);
--   §3  block : Σₜ b(t)² ≡ c₀²ρ₀ + c₁²ρ₀ + c₂²ρ₀ + 2c₀c₁ρ₁ + 2c₁c₂ρ₁
--                            + 2c₀c₂ρ₂        (solver, seven variables).
--   §4  over ℤ, the block at f = (1,1,1,1), c = (1,−1,1) is 4, read both
--       ways.
--
-- SYĀT — THE CLAIM, EXACTLY.  One polynomial identity at fixed sizes,
-- checked by the ring solver.  The general finite case is the same
-- identity with more terms; the document's infinite case adds a limit
-- that is NOT here.  "Prime" names the slots; no arithmetic function
-- appears.
------------------------------------------------------------------------

module BoundaryBlock_ThePrimeSideMeanSquareOfAReceivedSignalIsThePairFieldPairedWithTheReceiversAutocorrelation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver

module Block {ℓ : Level} (R' : CommRing ℓ) where

  open CommRingStr (R' .snd) renaming (_+_ to _+r_ ; _·_ to _·r_ ; -_ to neg)

  private
    K : Type ℓ
    K = fst R'

  -- §1  the received signal b(t) = c₀ f(t) + c₁ f(t−1) + c₂ f(t−2)
  b₀ b₁ b₂ b₃ b₄ b₅ : (f₀ f₁ f₂ f₃ c₀ c₁ c₂ : K) → K
  b₀ f₀ f₁ f₂ f₃ c₀ c₁ c₂ = c₀ ·r f₀
  b₁ f₀ f₁ f₂ f₃ c₀ c₁ c₂ = c₀ ·r f₁ +r c₁ ·r f₀
  b₂ f₀ f₁ f₂ f₃ c₀ c₁ c₂ = c₀ ·r f₂ +r c₁ ·r f₁ +r c₂ ·r f₀
  b₃ f₀ f₁ f₂ f₃ c₀ c₁ c₂ = c₀ ·r f₃ +r c₁ ·r f₂ +r c₂ ·r f₁
  b₄ f₀ f₁ f₂ f₃ c₀ c₁ c₂ = c₁ ·r f₃ +r c₂ ·r f₂
  b₅ f₀ f₁ f₂ f₃ c₀ c₁ c₂ = c₂ ·r f₃

  sq : K → K
  sq x = x ·r x

  meanSquare : (f₀ f₁ f₂ f₃ c₀ c₁ c₂ : K) → K
  meanSquare f₀ f₁ f₂ f₃ c₀ c₁ c₂ =
    sq (b₀ f₀ f₁ f₂ f₃ c₀ c₁ c₂) +r sq (b₁ f₀ f₁ f₂ f₃ c₀ c₁ c₂) +r sq (b₂ f₀ f₁ f₂ f₃ c₀ c₁ c₂)
    +r sq (b₃ f₀ f₁ f₂ f₃ c₀ c₁ c₂) +r sq (b₄ f₀ f₁ f₂ f₃ c₀ c₁ c₂) +r sq (b₅ f₀ f₁ f₂ f₃ c₀ c₁ c₂)

  -- §2  autocorrelation lags of the receiver
  ρ₀ ρ₁ ρ₂ : (f₀ f₁ f₂ f₃ : K) → K
  ρ₀ f₀ f₁ f₂ f₃ = f₀ ·r f₀ +r f₁ ·r f₁ +r f₂ ·r f₂ +r f₃ ·r f₃
  ρ₁ f₀ f₁ f₂ f₃ = f₀ ·r f₁ +r f₁ ·r f₂ +r f₂ ·r f₃
  ρ₂ f₀ f₁ f₂ f₃ = f₀ ·r f₂ +r f₁ ·r f₃

  -- the pair field paired with the autocorrelation, Σₘ Σₙ cₘ cₙ ρ(m−n)
  pairing : (f₀ f₁ f₂ f₃ c₀ c₁ c₂ : K) → K
  pairing f₀ f₁ f₂ f₃ c₀ c₁ c₂ =
      (c₀ ·r c₀ +r c₁ ·r c₁ +r c₂ ·r c₂) ·r ρ₀ f₀ f₁ f₂ f₃
    +r (1r +r 1r) ·r (c₀ ·r c₁ +r c₁ ·r c₂) ·r ρ₁ f₀ f₁ f₂ f₃
    +r (1r +r 1r) ·r (c₀ ·r c₂) ·r ρ₂ f₀ f₁ f₂ f₃

  -- §3  THE BLOCK IDENTITY
  block : (f₀ f₁ f₂ f₃ c₀ c₁ c₂ : K)
        → meanSquare f₀ f₁ f₂ f₃ c₀ c₁ c₂ ≡ pairing f₀ f₁ f₂ f₃ c₀ c₁ c₂
  block f₀ f₁ f₂ f₃ c₀ c₁ c₂ = solve! R'

------------------------------------------------------------------------
-- §4  Over ℤ.
------------------------------------------------------------------------

open Block ℤCommRing

-- f = (1,1,1,1), c = (1,−1,1): b = (1,0,1,1,0,1), Σ b² = 4;
-- ρ = (4,3,2), pairing = 3·4 + 2·(−2)·3 + 2·1·2 = 12 − 12 + 4 = 4.
block-at-alternating : meanSquare (pos 1) (pos 1) (pos 1) (pos 1) (pos 1) (negsuc 0) (pos 1) ≡ pos 4
block-at-alternating = refl

pairing-at-alternating : pairing (pos 1) (pos 1) (pos 1) (pos 1) (pos 1) (negsuc 0) (pos 1) ≡ pos 4
pairing-at-alternating = refl
