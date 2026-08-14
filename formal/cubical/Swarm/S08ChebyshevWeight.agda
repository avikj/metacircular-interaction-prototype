{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Swarm.S08ChebyshevWeight
--
-- THE GRADING THAT SATISFACTION CANNOT SEE.
--
-- `runtime/panini/cakravala.py` verifies every Pell solution by
-- substitution and says, in its own docstring, that this is the failure
-- such a check *cannot* see: "the answer is true and wrong" — a pair
-- (x,y) with x² − D y² = 1 that is not the fundamental solution.  Its
-- shipped screen `is_bhavana_square` catches only the case where the
-- offender is a bhāvanā SQUARE.
--
-- The reason it can only catch squares is exact, and it is the content
-- of this module.  The solution group is infinite cyclic, δ ↦ δⁿ, and
-- the FIRST COORDINATE of δⁿ depends on n and on x(δ) alone:
--
--     fst (δⁿ)  =  Tₙ (fst δ)         whenever N(δ) = 1
--
-- with Tₙ the Chebyshev polynomial of the first kind.  D and the second
-- coordinate drop out completely.  So the index n — the WEIGHT — is
-- readable off x by inverting a one-variable integer polynomial, and
-- `is_bhavana_square` is exactly the n = 2 member of that family:
--
--     T₂ u = 2u² − 1     ⟺     u² = (x+1)/2      (the shipped test)
--     T₃ u = 4u³ − 3u                            (missed: see below)
--
-- The certified escape is D = 3, δ = (2,1), δ³ = (26,15):  26² − 3·15²
-- = 1, so substitution accepts it, and 26 + 1 = 27 is odd, so the
-- shipped square screen returns False.  It is weight 3, and no test
-- graded by 2 can see it.
--
-- Contents
--   bhavana-norm        Brahmagupta's samāsa-bhāvanā is norm-multiplicative
--   trace-is-Chebyshev  fst (δⁿ) ≡ Tₙ (fst δ)  for N(δ) = 1   [the object]
--   T2 , T3             the two graded pieces, as polynomials
--   witness-*           the D = 3 weight-3 escape, by computation
------------------------------------------------------------------------

module Swarm.S08ChebyshevWeight where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open CommRingStr (ℤCommRing .snd)

R : Type
R = fst ℤCommRing

-- ---------------------------------------------------------------------
-- the quadratic order ℤ[√D], its norm, and Brahmagupta's composition
-- ---------------------------------------------------------------------

-- (a , b) denotes a + b√D
Sol : Type
Sol = R × R

-- samāsa-bhāvanā (Brahmagupta, 628 CE): multiplication in ℤ[√D]
mulS : R → Sol → Sol → Sol
mulS D (a , b) (c , d) = (a · c + D · (b · d) , a · d + b · c)

N : R → Sol → R
N D (a , b) = a · a - D · (b · b)

-- ---------------------------------------------------------------------
-- Brahmagupta's identity
-- ---------------------------------------------------------------------

private
  bhavana-raw : (D a b c d : R)
    →   (a · c + D · (b · d)) · (a · c + D · (b · d))
      - D · ((a · d + b · c) · (a · d + b · c))
    ≡ (a · a - D · (b · b)) · (c · c - D · (d · d))
  bhavana-raw = solve ℤCommRing

bhavana-norm : (D : R) (p q : Sol) → N D (mulS D p q) ≡ N D p · N D q
bhavana-norm D (a , b) (c , d) = bhavana-raw D a b c d

-- ---------------------------------------------------------------------
-- powers in the solution group, and the Chebyshev polynomials
-- ---------------------------------------------------------------------

pow : R → Sol → ℕ → Sol
pow D δ zero    = (1r , 0r)
pow D δ (suc n) = mulS D δ (pow D δ n)

-- Tₙ, first kind:  T₀ = 1, T₁ = u, T_{n+2} = 2u·T_{n+1} − Tₙ
T : R → ℕ → R
T u zero          = 1r
T u (suc zero)    = u
T u (suc (suc n)) = ((1r + 1r) · u) · T u (suc n) - T u n

-- ---------------------------------------------------------------------
-- the two ring lemmas the induction needs
-- ---------------------------------------------------------------------

private
  one-step : (D u v : R) → u · 1r + D · (v · 0r) ≡ u
  one-step = solve ℤCommRing

  -- the whole content: the recurrence holds UP TO a multiple of (1 − N).
  -- Nothing here assumes N = 1; the defect is displayed rather than hidden.
  step-raw : (D u v x y : R)
    →   u · (u · x + D · (v · y)) + D · (v · (u · y + v · x))
    ≡   (((1r + 1r) · u) · (u · x + D · (v · y)) - x)
      + x · (1r - (u · u - D · (v · v)))
  step-raw = solve ℤCommRing

  killer : (a x : R) → a + x · (1r - 1r) ≡ a
  killer = solve ℤCommRing

  step : (D u v x y : R) → (u · u - D · (v · v) ≡ 1r)
    →   u · (u · x + D · (v · y)) + D · (v · (u · y + v · x))
    ≡   ((1r + 1r) · u) · (u · x + D · (v · y)) - x
  step D u v x y h =
      step-raw D u v x y
    ∙ cong (λ z → (((1r + 1r) · u) · (u · x + D · (v · y)) - x) + x · (1r - z)) h
    ∙ killer (((1r + 1r) · u) · (u · x + D · (v · y)) - x) x

-- ---------------------------------------------------------------------
-- THE THEOREM
--
--   For a norm-one δ = (u,v), the first coordinate of δⁿ is Tₙ(u).
--   The index n is therefore a function of x alone: a WEIGHT, readable
--   without knowing D or v.
-- ---------------------------------------------------------------------

private
  both : (D u v : R) → (N D (u , v) ≡ 1r) → (n : ℕ)
       → (fst (pow D (u , v) n) ≡ T u n)
       × (fst (pow D (u , v) (suc n)) ≡ T u (suc n))
  both D u v h zero    = refl , one-step D u v
  both D u v h (suc n) =
    let ih = both D u v h n
        x  = fst (pow D (u , v) n)
        y  = snd (pow D (u , v) n)
    in  snd ih
      , ( step D u v x y h
        ∙ cong₂ (λ a b → ((1r + 1r) · u) · a - b) (snd ih) (fst ih) )

trace-is-Chebyshev : (D u v : R) → (N D (u , v) ≡ 1r) → (n : ℕ)
                   → fst (pow D (u , v) n) ≡ T u n
trace-is-Chebyshev D u v h n = fst (both D u v h n)

-- ---------------------------------------------------------------------
-- the graded pieces, explicitly
-- ---------------------------------------------------------------------

T2 : (u : R) → T u 2 ≡ (1r + 1r) · (u · u) - 1r
T2 = solve ℤCommRing

T3 : (u : R) → T u 3 ≡ (1r + 1r + 1r + 1r) · (u · (u · u)) - (1r + 1r + 1r) · u
T3 = solve ℤCommRing

-- ---------------------------------------------------------------------
-- the certified escape:  D = 3, δ = (2,1), δ³ = (26,15)
--
--   * both are genuine solutions (substitution accepts both);
--   * (26,15) is the CUBE of (2,1), hence not fundamental;
--   * 26 = T₃(2), and 26 is not in the image of T₂ over ℤ
--     (T₂ u = 26 forces 2u² = 27, impossible by parity), which is
--     precisely why `is_bhavana_square(3, 26, 15)` returns False.
-- ---------------------------------------------------------------------

D3 : R
D3 = pos 3

witness-base-norm : N D3 (pos 2 , pos 1) ≡ 1r
witness-base-norm = refl

witness-cube : pow D3 (pos 2 , pos 1) 3 ≡ (pos 26 , pos 15)
witness-cube = refl

witness-cube-norm : N D3 (pos 26 , pos 15) ≡ 1r
witness-cube-norm = refl

-- the weight is visible in the first coordinate alone, with no D and no v
witness-weight : T (pos 2) 3 ≡ pos 26
witness-weight = refl

-- and it is exactly the instance of the theorem
witness-is-instance : fst (pow D3 (pos 2 , pos 1) 3) ≡ T (pos 2) 3
witness-is-instance = trace-is-Chebyshev D3 (pos 2) (pos 1) witness-base-norm 3
