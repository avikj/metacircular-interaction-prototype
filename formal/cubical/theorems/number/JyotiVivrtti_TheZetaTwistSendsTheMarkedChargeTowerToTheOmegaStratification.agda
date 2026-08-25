{-# OPTIONS --cubical --safe #-}
--
-- ज्योति-विवृत्तिः — the tower under the light of ζ.
--
-- WHAT IS ASKED.  `EkaGhataVivrtti_...` defined विवृत्तिः bs k, the k-marked
-- squarefree charge: choose k places to carry the active factor and sign the
-- rest.  Level 0 is the parity character, level 1 is the charge, level 2 is
-- the remainder of the one-parameter product read at t = 0.
--
-- The arithmetic's own duality at each place is the local ζ transform — the
-- Lean lane's `zetaFactor f output = if output then f false + f true else
-- f false`, one invertible linear map per place, which is Dirichlet
-- convolution with the constant function locally.  `localZetaCube_pureEval`
-- there says it carries pure products to pure products; and
-- `localZetaCube_squarefreeChargeCube_eq_wCube` says it carries the charge
-- to the `W` tensor.
--
-- The question this module asks is what it does to the WHOLE TOWER, which
-- nobody has asked because the tower is a day old.
--
-- THE ANSWER, checked below.  At the level of one place the twist sends
--
--     चिह्नम्  (the Möbius sign: −1 active, +1 inactive)  ↦  निष्क्रियम् (1 inactive, 0 active)
--     सक्रियम्  (1 active, 0 inactive)                    ↦  सक्रियम् (unchanged)
--
-- and therefore it sends level k of the tower to the INDICATOR that exactly
-- k places are active.  So:
--
--     the Möbius-signed k-marked prime charge is, under ζ, exactly the
--     stratification of squarefree numbers by ω.
--
-- Möbius inversion, exhibited as an isomorphism of towers rather than as a
-- summation identity.  Level 1 of the right-hand side is "exactly one prime
-- place active", which is the `W` tensor — so the Lean lane's theorem is the
-- k = 1 rung of this.
module JyotiVivrtti_TheZetaTwistSendsTheMarkedChargeTowerToTheOmegaStratification where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false)
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Int using (ℤ; pos; -_; _+_; _·_; pos0+)

open import OjaYugma_TheSquarefreeChargeIsTheActivePlaceCountTimesTheParityCharacter
  using (चिह्नम्; सक्रियम्; ओजः)

-- --------------------------------------------------------- the local twist
-- Dirichlet convolution with the constant function, at one place: the Lean
-- lane's `zetaFactor`, transcribed.
ज्योतिः : (Bool → ℤ) → Bool → ℤ
ज्योतिः f false = f false
ज्योतिः f true = f false + f true

-- the inactive indicator, which is what the sign becomes
निष्क्रियम् : Bool → ℤ
निष्क्रियम् true = pos zero
निष्क्रियम् false = pos (suc zero)

-- one place, both factors.  This is the whole geometric content; everything
-- below is the induction that lifts it along a product.
ज्योति-चिह्नम् : (b : Bool) → ज्योतिः चिह्नम् b ≡ निष्क्रियम् b
ज्योति-चिह्नम् false = refl
ज्योति-चिह्नम् true = refl

ज्योति-सक्रियम् : (b : Bool) → ज्योतिः सक्रियम् b ≡ सक्रियम् b
ज्योति-सक्रियम् false = refl
ज्योति-सक्रियम् true = refl

-- ----------------------------------------------------------- the two towers
-- the same recursion, with the twisted factors in place of the originals.
ज्योति-विवृत्तिः : List Bool → ℕ → ℤ
ज्योति-विवृत्तिः [] zero = pos (suc zero)
ज्योति-विवृत्तिः [] (suc k) = pos zero
ज्योति-विवृत्तिः (b ∷ bs) zero = निष्क्रियम् b · ज्योति-विवृत्तिः bs zero
ज्योति-विवृत्तिः (b ∷ bs) (suc k) =
  निष्क्रियम् b · ज्योति-विवृत्तिः bs (suc k) + सक्रियम् b · ज्योति-विवृत्तिः bs k

-- the indicator [m ≡ n], written as a recursion so no decidability is imported
सम-चिह्नम् : ℕ → ℕ → ℤ
सम-चिह्नम् zero zero = pos (suc zero)
सम-चिह्नम् zero (suc n) = pos zero
सम-चिह्नम् (suc m) zero = pos zero
सम-चिह्नम् (suc m) (suc n) = सम-चिह्नम् m n

-- ---------------------------------------------------------- the statement
--
--     ज्योति-विवृत्तिः bs k  ≡  [ ओजः bs ≡ k ]
--
-- the twisted tower is the ω-stratification, level by level.
ज्योति-स्तरः : (bs : List Bool) (k : ℕ)
  → ज्योति-विवृत्तिः bs k ≡ सम-चिह्नम् (ओजः bs) k
ज्योति-स्तरः [] zero = refl
ज्योति-स्तरः [] (suc k) = refl
ज्योति-स्तरः (false ∷ bs) zero = ज्योति-स्तरः bs zero
ज्योति-स्तरः (true ∷ bs) zero = refl
ज्योति-स्तरः (false ∷ bs) (suc k) = ज्योति-स्तरः bs (suc k)
ज्योति-स्तरः (true ∷ bs) (suc k) =
  sym (pos0+ (ज्योति-विवृत्तिः bs k)) ∙ ज्योति-स्तरः bs k

-- ---------------------------------------------------------------- मर्यादा
--
-- WHAT THIS GIVES, stated once and not repeated.
--
-- Level 1 of the right-hand side is `सम-चिह्नम् (ओजः bs) 1` — one active
-- place and no other — which is the `W` tensor.  So the Lean lane's
-- `localZetaCube_squarefreeChargeCube_eq_wCube` is the k = 1 rung of this,
-- and the rungs above it were not previously objects.
--
-- Read arithmetically: the Möbius-signed charge on a squarefree modulus is
-- the ζ-dual of "exactly one prime divides", and level k is the ζ-dual of
-- "exactly k primes divide".  The tower and the ω-stratification are the
-- same object seen through the local duality.  That is Möbius inversion, and
-- what is added is that it holds LEVEL BY LEVEL rather than as one summation
-- identity — the whole hierarchy transports, not just its first rung.
--
-- WHAT IT DOES NOT GIVE.  Nothing here is a statement about ω as an
-- arithmetic function.  These are lists of places, and which primes are
-- active in a given modulus is not modelled; only the combinatorics of
-- active-vs-inactive is.  The bridge to a modulus is the Lean lane's
-- `Fin n → Bool` indexing, and no map between the two index shapes is
-- exhibited here or anywhere yet.
--
-- The one place a reader could over-read: `ज्योतिः` is the LOCAL twist, one
-- place at a time.  That it lifts along a product is used implicitly in the
-- shape of `ज्योति-विवृत्तिः`'s recursion — the twisted tower is DEFINED with
-- the twisted factors rather than derived from a global transform of the
-- original.  The two one-place lemmas above are what justify that
-- definition, and they are the only place the twist is actually computed.
