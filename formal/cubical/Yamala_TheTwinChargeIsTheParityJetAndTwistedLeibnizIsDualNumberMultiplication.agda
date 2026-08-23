{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- यमल — the twin/paired number.  The twin-prime charge vector κ₁ is the
-- FIRST JET of the parity character z^{ω(d)} at z = −1, and its
-- "nonmultiplicative" twisted Leibniz law IS dual-number multiplication.
-- The apparently nonmultiplicative fixed-charge kernel compiles into a
-- two-dimensional multiplicative representation — automatic
-- differentiation through the Euler structure.  (Owner's twin-prime
-- message; the exact algebra as a term.)
--
-- THE ARITHMETIC (owner, stated; not re-derived here — it is the
-- reading that names the objects).  For squarefree d,
--     κ₁(d) = Σ_{p∣d} μ(d/p) = ω(d)·(−1)^{ω(d)−1}
--            = ∂/∂z [ z^{ω(d)} ] |_{z=−1},
-- and μ(d) = (−1)^{ω(d)} = z^{ω(d)} |_{z=−1}.  So the jet
--     J(d) = ( μ(d) , κ₁(d) ) = ( value , derivative ) of z^{ω(d)} at −1.
-- On coprime squarefree a,b:  μ(ab)=μ(a)μ(b) and
--     κ₁(ab) = κ₁(a)μ(b) + μ(a)κ₁(b)   — the μ-TWISTED DERIVATION law.
--
-- THE COMPILATION (checked below).  A dual number over ℤ is a value with
-- an infinitesimal part, ε² = 0.  Its multiplication is
--     (a , a') ⊛ (b , b') = ( a·b , a·b' + a'·b ),
-- whose SECOND COMPONENT is exactly the twisted Leibniz law (§2, refl).
-- So J is a monoid homomorphism (ℕ-coprime-squarefree, ·) → (Dual, ⊛):
-- the "nonmultiplicative" vector is a homomorphism into the 2-dim
-- dual-number algebra ℤ[ε]/(ε²) — equivalently the upper-triangular
-- matrices [[a,a'],[0,a]], whose product IS ⊛.
--
-- AND THE AUTOMATIC DIFFERENTIATION (§3).  Lifting z to the dual (z,1)
-- and taking the n-th ⊛-power computes value AND derivative at once:
--     (z,1)^{⊛ n} = ( z^n , (z^n)' ),
-- the formal derivative appearing with no separate differentiation
-- rule — dual arithmetic differentiates z^n for free.  At z = −1,
-- n = ω(d), this is (μ(d), κ₁(d)): the prime-charge vector IS executable
-- AD through the Euler product.  The IOI move: keep the sufficient jet
-- state, discard the exponential divisor tree, preserve exact semantics.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9) for the ℤ solver.
------------------------------------------------------------------------

module Yamala_TheTwinChargeIsTheParityJetAndTwistedLeibnizIsDualNumberMultiplication where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.Int using (ℤ; pos; _+_; _·_)
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd; ΣPathP)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

-- a dual number: (value , infinitesimal), the ring ℤ[ε]/(ε²).
Dual : Type
Dual = ℤ × ℤ

-- dual multiplication: ε² = 0 folds the cross terms into one.
_⊛_ : Dual → Dual → Dual
(a , a') ⊛ (b , b') = (a · b , a · b' + a' · b)

one⊛ : Dual
one⊛ = (pos 1 , pos 0)

------------------------------------------------------------------------
-- §1 · (Dual, ⊛, one⊛) is a commutative monoid — the multiplicative
-- backbone the twisted derivation compiles into.

⊛-assoc : (x y z : Dual) → (x ⊛ y) ⊛ z ≡ x ⊛ (y ⊛ z)
⊛-assoc (a , a') (b , b') (c , c') =
  ΣPathP (solve! ℤCommRing , solve! ℤCommRing)

⊛-comm : (x y : Dual) → x ⊛ y ≡ y ⊛ x
⊛-comm (a , a') (b , b') =
  ΣPathP (solve! ℤCommRing , solve! ℤCommRing)

⊛-unitˡ : (x : Dual) → one⊛ ⊛ x ≡ x
⊛-unitˡ (a , a') =
  ΣPathP (solve! ℤCommRing , solve! ℤCommRing)

------------------------------------------------------------------------
-- §2 · THE TWISTED LEIBNIZ LAW IS THE SECOND COMPONENT OF ⊛.  Given the
-- componentwise arithmetic hypotheses (μ,κ multiplicative/twisted on
-- coprime squarefree inputs), J(ab) = J(a) ⊛ J(b) — J is a hom.  The
-- law is definitional in ⊛: no proof beyond exhibiting the components.

twistedLeibniz-is-⊛ :
    (μa κa μb κb : ℤ)
  → ((μa , κa) ⊛ (μb , κb)) ≡ (μa · μb , μa · κb + κa · μb)
twistedLeibniz-is-⊛ μa κa μb κb = refl

-- so: if μ and κ satisfy μ(ab)=μa·μb and κ(ab)=μa·κb+κa·μb (the owner's
-- twisted derivation law), then J(ab) = J(a) ⊛ J(b) exactly.
J-hom :
    (μab κab μa κa μb κb : ℤ)
  → μab ≡ μa · μb
  → κab ≡ μa · κb + κa · μb
  → (μab , κab) ≡ (μa , κa) ⊛ (μb , κb)
J-hom μab κab μa κa μb κb pμ pκ i = pμ i , pκ i

------------------------------------------------------------------------
-- §3 · AUTOMATIC DIFFERENTIATION.  Lift z to (z,1) and ⊛-power it: the
-- result carries z^n AND its formal derivative, with no differentiation
-- rule supplied.  This is the parity jet z↦z^{ω} evaluated by dual
-- arithmetic; at z=−1, n=ω(d) it is (μ(d), κ₁(d)).

-- the scalar power and the formal derivative of z^n, defined natively.
pow : ℤ → ℕ → ℤ
pow z zero    = pos 1
pow z (suc n) = z · pow z n

deriv : ℤ → ℕ → ℤ                    -- (z^n)' = n·z^{n-1}, recursively
deriv z zero    = pos 0
deriv z (suc n) = z · deriv z n + pow z n

-- the dual power of the lifted base (z,1).
dpow : ℤ → ℕ → Dual
dpow z zero    = one⊛
dpow z (suc n) = (z , pos 1) ⊛ dpow z n

-- THE AD THEOREM: dual-powering computes value and derivative together.
autodiff : (z : ℤ) (n : ℕ) → dpow z n ≡ (pow z n , deriv z n)
autodiff z zero    = refl
autodiff z (suc n) =
  cong ((z , pos 1) ⊛_) (autodiff z n)
  ∙ λ i → pow z (suc n) , step i
  where
  -- second component: z·(deriv z n) + 1·(pow z n) ≡ z·deriv z n + pow z n
  step : z · deriv z n + pos 1 · pow z n ≡ z · deriv z n + pow z n
  step = solve! ℤCommRing
