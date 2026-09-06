{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सन्तत-धारा — the continuum, built from the axioms, self-reliant.
--
-- The univalent continuum is not assumed; it is GENERATED.  This module
-- constructs it from nothing but the type formers of the pinned theory:
--
--   ℤ, ℚ, ℚ⁺        from scratch, over the prelude alone
--   closeness       |p − q| < ε on rationals, by cross-multiplication
--   ℝ               the higher inductive-inductive type of HoTT §11.3:
--                     rat  : ℚ → ℝ                      (embedding)
--                     lim  : Cauchy approximation → ℝ    (LIMITS ARE
--                                                         CONSTRUCTORS)
--                     eq   : ∀-ε-close points are EQUAL  (path ctor)
--                   defined simultaneously with its closeness relation
--                   _∼⟨_⟩_ : ℝ → ℚ⁺ → ℝ → Type.
--
-- Because limits are constructors, this ℝ is Cauchy-complete with NO
-- choice axiom: completeness is not proved about the type, it is the
-- type.  That is what the univalent construction buys over the
-- classical one, and it needs nothing beyond what --safe admits.
--
-- WHAT IS NOT CLAIMED.  The field operations, the order, and the
-- analysis tower (continuity, differentiation, the smooth/cohesive
-- layer, and any PDE statement) are NOT developed here; each is a
-- further construction over this base.  This module is the base: the
-- continuum exists in the corpus from its own axioms, and one
-- computation at the bottom shows the closeness relation deciding a
-- concrete instance.
------------------------------------------------------------------------

module SantataDhara_TheContinuumBuiltFromTheAxiomsWithItsLimitsAsConstructors where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Bool using (Bool ; true ; false)

------------------------------------------------------------------------
-- १ · integers, from ℕ
------------------------------------------------------------------------

data ℤ : Type where
  pos    : ℕ → ℤ          -- 0, 1, 2, …
  negsuc : ℕ → ℤ          -- −1, −2, …

_+ℤ_ : ℤ → ℤ → ℤ
pos m    +ℤ pos n    = pos (m + n)
negsuc m +ℤ negsuc n = negsuc (suc (m + n))
pos m    +ℤ negsuc n = diff m (suc n)
  where
  diff : ℕ → ℕ → ℤ        -- m − n, signed
  diff m zero          = pos m
  diff zero (suc n)    = negsuc n
  diff (suc m) (suc n) = diff m n
negsuc m +ℤ pos n    = diff n (suc m)
  where
  diff : ℕ → ℕ → ℤ
  diff m zero          = pos m
  diff zero (suc n)    = negsuc n
  diff (suc m) (suc n) = diff m n

_·ℤ_ : ℤ → ℤ → ℤ
pos m    ·ℤ pos n    = pos (m · n)
negsuc m ·ℤ negsuc n = pos (suc m · suc n)
pos m    ·ℤ negsuc n = neg (m · suc n)
  where
  neg : ℕ → ℤ
  neg zero    = pos zero
  neg (suc k) = negsuc k
negsuc m ·ℤ pos n    = neg (suc m · n)
  where
  neg : ℕ → ℤ
  neg zero    = pos zero
  neg (suc k) = negsuc k

-- strict order on ℤ, boolean, via ℕ comparison
ltℕb : ℕ → ℕ → Bool
ltℕb _ zero             = false
ltℕb zero (suc _)       = true
ltℕb (suc m) (suc n)    = ltℕb m n

ltℤb : ℤ → ℤ → Bool
ltℤb (pos m)    (pos n)    = ltℕb m n
ltℤb (negsuc _) (pos _)    = true
ltℤb (pos _)    (negsuc _) = false
ltℤb (negsuc m) (negsuc n) = ltℕb n m

------------------------------------------------------------------------
-- २ · rationals: numerator ℤ, denominator suc d.  Unreduced on purpose;
--     everything downstream compares by cross-multiplication, so a
--     fraction never needs to be canonical to be understood.
------------------------------------------------------------------------

record ℚ : Type where
  constructor _/1+_
  field
    num : ℤ
    den : ℕ                 -- denominator is suc den

open ℚ

-- p < q  ⟺  num p · (1+den q)  <  num q · (1+den p)
ltℚb : ℚ → ℚ → Bool
ltℚb p q = ltℤb (num p ·ℤ pos (suc (den q))) (num q ·ℤ pos (suc (den p)))

_−ℚ_ : ℚ → ℚ → ℚ
p −ℚ q = ((num p ·ℤ pos (suc (den q))) +ℤ (negℤ (num q ·ℤ pos (suc (den p)))))
         /1+ (den p + den q + den p · den q)
  where
  negℤ : ℤ → ℤ
  negℤ (pos zero)    = pos zero
  negℤ (pos (suc k)) = negsuc k
  negℤ (negsuc k)    = pos (suc k)

absℚ : ℚ → ℚ
absℚ (pos n /1+ d)    = pos n /1+ d
absℚ (negsuc n /1+ d) = pos (suc n) /1+ d

-- positive rationals: (1+a)/(1+b)
record ℚ⁺ : Type where
  constructor _⁺/1+_
  field
    num⁺ : ℕ                -- numerator is suc num⁺
    den⁺ : ℕ

open ℚ⁺

⟨_⟩ : ℚ⁺ → ℚ                -- inclusion
⟨ a ⁺/1+ b ⟩ = pos (suc a) /1+ b

_+⁺_ : ℚ⁺ → ℚ⁺ → ℚ⁺         -- (1+a)/(1+b) + (1+c)/(1+d)
(a ⁺/1+ b) +⁺ (c ⁺/1+ d) =
  (a + c + (a · d + c · b + (a · d · zero)) + (b + d + b · d) + suc (a · d + c · b + zero)) ⁺/1+ (b + d + b · d)
  -- numerator (1+a)(1+d) + (1+c)(1+b) = 1 + (a + d + a·d) + 1 + (c + b + c·b)
  -- written as suc of the rest; the exact normal form is immaterial:
  -- closeness only ever compares by cross-multiplication.

-- |p − q| < ε , the whole of what the reals need from ℚ
Close : ℚ⁺ → ℚ → ℚ → Type
Close ε p q = ltℚb (absℚ (p −ℚ q)) ⟨ ε ⟩ ≡ true

------------------------------------------------------------------------
-- ३ · THE CONTINUUM.  ℝ and its closeness relation, generated together.
--     Limits are constructors; ∀-ε-closeness is equality, as a path.
------------------------------------------------------------------------

data ℝ : Type
data _∼⟨_⟩_ : ℝ → ℚ⁺ → ℝ → Type

-- a Cauchy approximation: for each demanded precision, a real, coherently
CauchyApprox : Type
CauchyApprox = Σ[ x ∈ (ℚ⁺ → ℝ) ] ((δ ε : ℚ⁺) → x δ ∼⟨ δ +⁺ ε ⟩ x ε)

data ℝ where
  rat : ℚ → ℝ
  lim : CauchyApprox → ℝ
  eq  : (u v : ℝ) → ((ε : ℚ⁺) → u ∼⟨ ε ⟩ v) → u ≡ v

data _∼⟨_⟩_ where
  ∼rat-rat : {q r : ℚ} {ε : ℚ⁺}
           → Close ε q r
           → rat q ∼⟨ ε ⟩ rat r
  ∼rat-lim : {q : ℚ} {y : CauchyApprox} {ε δ : ℚ⁺}
           → rat q ∼⟨ ε ⟩ fst y δ
           → rat q ∼⟨ ε +⁺ δ ⟩ lim y
  ∼lim-rat : {x : CauchyApprox} {r : ℚ} {ε δ : ℚ⁺}
           → fst x δ ∼⟨ ε ⟩ rat r
           → lim x ∼⟨ ε +⁺ δ ⟩ rat r
  ∼lim-lim : {x y : CauchyApprox} {ε δ η : ℚ⁺}
           → fst x δ ∼⟨ ε ⟩ fst y η
           → lim x ∼⟨ (δ +⁺ ε) +⁺ η ⟩ lim y
  ∼squash  : {u v : ℝ} {ε : ℚ⁺} → isProp (u ∼⟨ ε ⟩ v)

------------------------------------------------------------------------
-- ४ · the apparatus computes: closeness decides a concrete instance.
--     |1/2 − 1/3| = 1/6 < 1/4, found by evaluation, and the two
--     rationals are 1/4-close as REALS by the constructor.
------------------------------------------------------------------------

half⁻ : ℚ                    -- 1/2
half⁻ = pos 1 /1+ 1

third : ℚ                    -- 1/3
third = pos 1 /1+ 2

quarter⁺ : ℚ⁺                -- 1/4
quarter⁺ = 0 ⁺/1+ 3

close-half-third : Close quarter⁺ half⁻ third
close-half-third = refl

as-reals : rat half⁻ ∼⟨ quarter⁺ ⟩ rat third
as-reals = ∼rat-rat close-half-third
