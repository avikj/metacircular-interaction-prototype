{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CyclicParseval — over any commutative ring, for any finite family of
-- characters χ_θ(t) with dual characters χ̄_θ(s) satisfying the
-- orthogonality Σ_θ χ_θ(t) χ̄_θ(s) = N·δ_{ts} on t, s < N,
--
--     Σ_{θ<N} b̂(θ) · č(θ)  ≡  N · Σ_{t<N} b_t c_t,
--
-- where b̂(θ) = Σ_t b_t χ_θ(t) and č(θ) = Σ_s c_s χ̄_θ(s).  With c = b
-- and χ̄ the conjugate character this is Parseval: the block Σ b_t² is
-- (1/N) Σ_θ |b̂(θ)|², a sum of squares on the spectral side.
--
-- WHAT THIS IS.  The discrete shadow of the zero side of the prime
-- boundary.  BoundaryBlockGeneral says the mean square of a received
-- signal is the pair field paired with the receiver's autocorrelation,
-- positive because it is a sum of squares in time.  This module says
-- the same block is a sum of products on the frequency side, and that
-- it is a sum of SQUARES there exactly when the dual character is the
-- conjugate of the character — when the frequencies are real.  In the
-- prime system the frequencies are the zeros ρ, the spectral form is
-- Weil's Σ_ρ H(ρ−½) H(1−ρ̄−½), and it is a sum of squares iff the zeros
-- are on the line.  That is the whole of what RH adds to positivity.
--
--   §1  the Kronecker delta on ℕ and the collapse Σ_s g_s δ_{ts} = g_t;
--   §2  the theorem, from bilinearity, exchange, and orthogonality;
--   §3  over ℤ at N = 2 with the character (−1)^{tθ}, orthogonality
--       discharged by computation, and Parseval read back: for
--       b = (3 , −1), Σ b² = 10 and Σ_θ b̂(θ)² = 4 + 16 = 20 = 2·10.
--
-- SYĀT — THE CLAIM, EXACTLY.  Bilinearity plus an orthogonality
-- hypothesis, over any commutative ring.  The roots of unity enter only
-- through the hypothesis; no root of unity is constructed here beyond
-- −1.  No zeros of ζ, no Weil form: those name the reading.
------------------------------------------------------------------------

module CyclicParseval_TheBlockIsASpectralSumOfProductsWheneverTheCharactersAreOrthogonalSoPositivityOnTheSpectralSideIsWhereTheFrequenciesAreReal where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; discreteℕ)
open import Cubical.Data.Nat.Order
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.Ring.Properties using (module RingTheory)
open import Cubical.Algebra.CommRing.Base using (CommRing→Ring)

open import BoundaryBlockGeneral_ForEveryFiniteReceiverAndEveryFiniteCoefficientSignalTheMeanSquareIsThePairFieldPairedWithTheAutocorrelationLags using (module General)

module Parseval {ℓ : Level} (R' : CommRing ℓ) where

  open CommRingStr (R' .snd) renaming (_+_ to _+r_ ; _·_ to _·r_ ; -_ to neg)
  open RingTheory (CommRing→Ring R') using (0LeftAnnihilates ; 0RightAnnihilates)
  open General R' using (Sig ; sum ; sum-ext ; sum-ext< ; sum-0 ; sum-+ ; sum-·l ; sum-·r ; sum-swap ; sum-prod)

  private
    K : Type ℓ
    K = fst R'

  ----------------------------------------------------------------------
  -- §1  the Kronecker delta and its collapse
  ----------------------------------------------------------------------

  δ : ℕ → ℕ → K
  δ t s with discreteℕ t s
  ... | yes _ = 1r
  ... | no _  = 0r

  δ-diag : (t : ℕ) → δ t t ≡ 1r
  δ-diag t with discreteℕ t t
  ... | yes _ = refl
  ... | no ¬p = ⊥-rec (¬p refl)

  δ-off : (t s : ℕ) → ¬ (t ≡ s) → δ t s ≡ 0r
  δ-off t s ne with discreteℕ t s
  ... | yes p = ⊥-rec (ne p)
  ... | no _ = refl

  -- Σ_{s<N} g s · δ t s ≡ g t whenever t < N
  collapse : (N : ℕ) (g : Sig) (t : ℕ) → t < N → sum N (λ s → g s ·r δ t s) ≡ g t
  collapse zero g t t<0 = ⊥-rec (¬-<-zero t<0)
  collapse (suc N) g zero _ =
    cong₂ _+r_ (cong (g 0 ·r_) (δ-diag 0) ∙ ·IdR _)
               (sum-ext N (λ s → cong (g (suc s) ·r_) (δ-off 0 (suc s) znots) ∙ 0RightAnnihilates _) ∙ sum-0 N)
    ∙ +IdR _
    where open import Cubical.Data.Nat using (znots)
  collapse (suc N) g (suc t) t<N =
    cong₂ _+r_ (cong (g 0 ·r_) (δ-off (suc t) 0 snotz) ∙ 0RightAnnihilates _)
               (sum-ext N (λ s → cong (g (suc s) ·r_) (δ-suc t s)) ∙ collapse N (g ∘ suc) t (pred-≤-pred t<N))
    ∙ +IdL _
    where
      open import Cubical.Data.Nat using (snotz ; injSuc)
      δ-suc : (t s : ℕ) → δ (suc t) (suc s) ≡ δ t s
      δ-suc t s = helper (discreteℕ t s)
        where
          helper : Dec (t ≡ s) → δ (suc t) (suc s) ≡ δ t s
          helper (yes p) = (cong (δ (suc t)) (cong suc (sym p)) ∙ δ-diag (suc t))
                           ∙ sym (cong (δ t) (sym p) ∙ δ-diag t)
          helper (no ¬p) = δ-off (suc t) (suc s) (λ q → ¬p (injSuc q)) ∙ sym (δ-off t s ¬p)

  ----------------------------------------------------------------------
  -- §2  Parseval from orthogonality
  ----------------------------------------------------------------------

  nat : ℕ → K
  nat zero = 0r
  nat (suc n) = 1r +r nat n

  -- characters χ θ t and dual characters χ̄ θ s
  Orthogonal : (N : ℕ) (χ χ̄ : ℕ → ℕ → K) → Type ℓ
  Orthogonal N χ χ̄ = (t s : ℕ) → t < N → s < N → sum N (λ θ → χ θ t ·r χ̄ θ s) ≡ nat N ·r δ t s

  transform : (N : ℕ) (χ : ℕ → ℕ → K) (b : Sig) → Sig
  transform N χ b θ = sum N (λ t → b t ·r χ θ t)

  parseval : (N : ℕ) (χ χ̄ : ℕ → ℕ → K) → Orthogonal N χ χ̄ → (b c : Sig)
           → sum N (λ θ → transform N χ b θ ·r transform N χ̄ c θ) ≡ nat N ·r sum N (λ t → b t ·r c t)
  parseval N χ χ̄ orth b c =
    -- expand each product of transforms into a double sum
    sum-ext N (λ θ → sum-prod N (λ t → b t ·r χ θ t) (λ s → c s ·r χ̄ θ s))
    -- move the θ-sum innermost
    ∙ sum-swap N N _
    ∙ sum-ext N (λ t → sum-swap N N _)
    -- regroup each term and apply orthogonality
    ∙ sum-ext< N (λ t t<N → sum-ext< N (λ s s<N →
        sum-ext N (λ θ → rearr (b t) (c s) (χ θ t) (χ̄ θ s))
        ∙ sum-·l N (b t ·r c s) _
        ∙ cong ((b t ·r c s) ·r_) (orth t s t<N s<N)
        ∙ regroup (b t) (c s) (nat N) (δ t s)))
    -- collapse the δ
    ∙ sum-ext< N (λ t t<N → sum-·l N (nat N ·r b t) _ ∙ cong ((nat N ·r b t) ·r_) (collapse N c t t<N))
    ∙ sum-ext N (λ t → sym (·Assoc _ _ _))
    ∙ sum-·l N (nat N) _
    where
      rearr : (a b x y : K) → (a ·r x) ·r (b ·r y) ≡ (a ·r b) ·r (x ·r y)
      rearr a b x y =
        sym (·Assoc _ _ _) ∙ cong (a ·r_) (·Assoc _ _ _ ∙ cong (_·r y) (·Comm x b) ∙ sym (·Assoc _ _ _))
        ∙ ·Assoc _ _ _
      regroup : (a b n d : K) → (a ·r b) ·r (n ·r d) ≡ (n ·r a) ·r (b ·r d)
      regroup a b n d =
        ·Assoc _ _ _
        ∙ cong (_·r d) (sym (·Assoc _ _ _) ∙ cong (a ·r_) (·Comm b n) ∙ ·Assoc _ _ _ ∙ cong (_·r b) (·Comm a n))
        ∙ sym (·Assoc _ _ _)

------------------------------------------------------------------------
-- §3  Over ℤ at N = 2: the character (−1)^{tθ}.
------------------------------------------------------------------------

open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

open Parseval ℤCommRing
open General ℤCommRing using (Sig ; sum)
open CommRingStr (ℤCommRing .snd) using () renaming (_·_ to _·r_)

-- (−1)^{tθ}, by the parity of t · θ
sign : ℕ → ℕ → ℤ
sign θ t = par (t · θ)
  where
    open import Cubical.Data.Nat using (_·_ ; isEvenT ; isOddT)
    par : ℕ → ℤ
    par zero = pos 1
    par (suc zero) = negsuc 0
    par (suc (suc n)) = par n

-- the dual character of (−1)^{tθ} is itself
orth₂ : Orthogonal 2 sign sign
orth₂ zero zero _ _ = refl
orth₂ zero (suc zero) _ _ = refl
orth₂ (suc zero) zero _ _ = refl
orth₂ (suc zero) (suc zero) _ _ = refl
orth₂ zero (suc (suc s)) _ s<2 = ⊥-rec (¬-<-zero (pred-≤-pred (pred-≤-pred s<2)))
orth₂ (suc zero) (suc (suc s)) _ s<2 = ⊥-rec (¬-<-zero (pred-≤-pred (pred-≤-pred s<2)))
orth₂ (suc (suc t)) _ t<2 _ = ⊥-rec (¬-<-zero (pred-≤-pred (pred-≤-pred t<2)))

-- b = (3 , −1): transform (2 , 4); Σ_θ b̂(θ)² = 4 + 16 = 20 = 2 · (9 + 1)
b₀ : Sig
b₀ zero = pos 3
b₀ (suc zero) = negsuc 0
b₀ _ = pos 0

spectral : sum 2 (λ θ → transform 2 sign b₀ θ ·r transform 2 sign b₀ θ) ≡ pos 20
spectral = refl

temporal : nat 2 ·r sum 2 (λ t → b₀ t ·r b₀ t) ≡ pos 20
temporal = refl

parseval₂ : sum 2 (λ θ → transform 2 sign b₀ θ ·r transform 2 sign b₀ θ) ≡ nat 2 ·r sum 2 (λ t → b₀ t ·r b₀ t)
parseval₂ = parseval 2 sign sign orth₂ b₀ b₀
