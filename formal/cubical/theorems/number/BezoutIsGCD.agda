{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BezoutIsGCD
--
-- `CoprimePowers` closes the composition law for Bézout certificates and
-- names what is left: the bridge from a certificate to `isGCD _ _ 1`,
-- which is what `CRTChain.Coprimes` consumes.  Here is the bridge.
--
-- ────────────────────────────────────────────────────────────────────
-- THE STATEMENT
--
-- Over ℕ, cleared of subtraction — which is how the kuṭṭaka states its
-- own output, as a pair of multipliers with a unit remainder:
--
--     BezN a b  =  Σ x, Σ y,  a·x ≡ b·y + 1
--
--     bezN→isGCD :  BezN a b → isGCD a b 1
--
-- A common divisor `d` of `a` and `b` divides `a·x` and `b·y`, so it
-- divides their difference — and in ℕ, where there is no difference to
-- take, the argument goes through the witnesses exactly as
-- `SuccessorIsNotTropical.cd-consecutive` does: `u·d ≡ v·d + 1` forces
-- `v < u`, and then `(suc k)·d ≡ 1` by cancellation.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS COMPLETES
--
--   `CoprimePowers`  coprime bases ⟹ coprime powers, certificates composing
--   here             a certificate ⟹ `isGCD _ _ 1`
--   `CRTChain`       `isGCD` data ⟹ the residue equivalence, any frontier
--
-- so the chain from Āryabhaṭa's multipliers to the walk's residue count
-- is now unbroken except for one arithmetical fact, stated below.
--
-- STILL OPEN, and it is now the only gap: that distinct primes are
-- coprime, i.e. that a certificate EXISTS for `p, q`.  Nothing above
-- produces one; the walk's concrete frontiers compute gcds instead
-- (`CRTChain.walk8-coprimes`), and that is enough for any named frontier
-- and not enough for all of them.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module BezoutIsGCD where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-untrunc ; ∣-oneˡ)
open import Cubical.Data.Nat.GCD using (isGCD ; isCD)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

------------------------------------------------------------------------
-- 1.  The kuṭṭaka's output, cleared of subtraction
------------------------------------------------------------------------

BezN : ℕ → ℕ → Type
BezN a b = Σ[ x ∈ ℕ ] Σ[ y ∈ ℕ ] (a · x ≡ b · y + 1)

------------------------------------------------------------------------
-- 2.  The one arithmetic step: u·d ≡ v·d + 1 forces d to be a unit
------------------------------------------------------------------------

private
  shuffle : (α d x : ℕ) → (α · d) · x ≡ (α · x) · d
  shuffle α d x = solveℕ!

unit-from-step : (u v d : ℕ) → u · d ≡ v · d + 1 → d ∣ 1
unit-from-step u v d p = go (splitℕ-≤ u v)
  where
  vd<ud : (v · d) < (u · d)
  vd<ud = subst (suc (v · d) ≤_) (sym (+-comm (v · d) 1) ∙ sym p) ≤-refl

  go : ((u ≤ v) ⊎ (v < u)) → d ∣ 1
  go (inl u≤v) = Empty.rec (¬m<m (≤<-trans (≤-·k u≤v) vd<ud))
  go (inr v<u) = ∣ suc k , unit ∣₁
    where
    k : ℕ
    k = v<u .fst

    pk : k + suc v ≡ u
    pk = v<u .snd

    step2 : (k · d) + ((suc v) · d) ≡ (v · d) + 1
    step2 = ·-distribʳ k (suc v) d ∙ cong (_· d) pk ∙ p

    step3 : ((k · d) + d) + (v · d) ≡ 1 + (v · d)
    step3 = sym (+-assoc (k · d) d (v · d)) ∙ step2 ∙ +-comm (v · d) 1

    step4 : (k · d) + d ≡ 1
    step4 = inj-+m step3

    unit : (suc k) · d ≡ 1
    unit = +-comm d (k · d) ∙ step4

------------------------------------------------------------------------
-- 3.  THE BRIDGE
------------------------------------------------------------------------

bezN→isGCD : (a b : ℕ) → BezN a b → isGCD a b 1
bezN→isGCD a b (x , y , p) =
  (∣-oneˡ a , ∣-oneˡ b) , divides
  where
  divides : (d : ℕ) → isCD a b d → d ∣ 1
  divides d (d∣a , d∣b) = go (∣-untrunc d∣a) (∣-untrunc d∣b)
    where
    go : Σ[ α ∈ ℕ ] (α · d ≡ a) → Σ[ β ∈ ℕ ] (β · d ≡ b) → d ∣ 1
    go (α , pa) (β , pb) =
      unit-from-step (α · x) (β · y) d
        ( sym (shuffle α d x)
        ∙ cong (_· x) pa
        ∙ p
        ∙ cong (λ z → (z · y) + 1) (sym pb)
        ∙ cong (_+ 1) (shuffle β d y) )

------------------------------------------------------------------------
-- 4.  It runs: 8 and 9, from the certificate the kuṭṭaka would produce.
--
--   8·8 = 64 = 9·7 + 1.
------------------------------------------------------------------------

bez-8-9 : BezN 8 9
bez-8-9 = 8 , 7 , refl

gcd-8-9 : isGCD 8 9 1
gcd-8-9 = bezN→isGCD 8 9 bez-8-9

------------------------------------------------------------------------
-- 5.  The chain, now unbroken except at one place.
--
--   `Kuttaka.bezout`     Āryabhaṭa's procedure returns the multipliers
--   `CoprimePowers`      certificates compose: coprime bases ⟹ coprime powers
--   here                 a certificate is an `isGCD _ _ 1`
--   `CRTChain`           `isGCD` data ⟹ the residue equivalence
--   `LosslessLowerBound` and the count is a minimum
--
-- The one remaining gap is the EXISTENCE of a certificate for two
-- distinct primes.  Everything downstream of it is done.
------------------------------------------------------------------------
