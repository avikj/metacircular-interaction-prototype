{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MultiplicationUnfoldsInLinearPeels
--
-- The cost arc, carried onto the multiplication kernel. `mul x (unary b)`
-- unfolds, in exactly b+1 steps, into a right-nested sum of b copies of x
-- (`copies x b`). Each `mul-suc` peel is one step; `mul-zero` closes it. So
-- the multiplicative layer costs the number of FACTORS (b). Reducing the
-- resulting b copies of `unary a` to the value then runs the additive engine
-- ~a per copy — total ~a·b, the unary magnitude of the OUTPUT. Cost tracks
-- the winding number of the result, not the size of the input (a+b): the
-- clean case that shows "cost = output magnitude", not "linear in input".
------------------------------------------------------------------------

module MultiplicationUnfoldsInLinearPeels where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

open import RewriteCertificateMul

len : {a b : Tm} → Derivation a b → ℕ
len (done _)        = zero
len (then-step _ d) = suc (len d)

unary : ℕ → Tm
unary zero    = zero
unary (suc n) = suc (unary n)

-- congruence lift on the left of an add, length preserved
underAddL : {a b : Tm} → Derivation a b → (z : Tm) → Derivation (add a z) (add b z)
underAddL (done x)        z = done (add x z)
underAddL (then-step s d) z = then-step (add-left s z) (underAddL d z)

len-underAddL : {a b : Tm} (d : Derivation a b) (z : Tm) → len (underAddL d z) ≡ len d
len-underAddL (done _)        z = refl
len-underAddL (then-step _ d) z = cong (λ (k : ℕ) → suc k) (len-underAddL d z)

-- b right-nested copies of x
copies : Tm → ℕ → Tm
copies x zero    = zero
copies x (suc n) = add (copies x n) x

-- THE PEEL : mul x (unary b) unfolds to b copies of x in b+1 steps
mulPeel : (x : Tm) (b : ℕ) → Derivation (mul x (unary b)) (copies x b)
mulPeel x zero    = then-step (mul-zero x) (done zero)
mulPeel x (suc m) = then-step (mul-suc x (unary m)) (underAddL (mulPeel x m) x)

-- cost of the multiplicative layer = number of factors (+1)
len-mulPeel : (x : Tm) (b : ℕ) → len (mulPeel x b) ≡ suc b
len-mulPeel x zero    = refl
len-mulPeel x (suc m) =
  cong (λ (k : ℕ) → suc k) (len-underAddL (mulPeel x m) x ∙ len-mulPeel x m)
