{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The deterministic five-round output of machine/MathMachine.hs, promoted
-- from strings to a typed arithmetic object.
--
-- Haskell emits its live discoveries as a temporary Agda module.  That
-- module must prove by refl that its AST is `expectedDiscoveries`, then
-- transports `expectedDiscoveriesSound` below onto the generated output.
-- Thus the smoke run is not certified because seven lines look plausible:
-- every generated equation denotes a universally quantified equality of
-- naturals, and the Agda kernel checks all seven proofs.
--
-- This is deliberately a first bounded bridge, not yet a certificate for
-- arbitrary later rounds or invented symbols.  Extending the shared AST and
-- proof-certificate language is the next boundary; finite fingerprints are
-- never treated as proofs here.
------------------------------------------------------------------------

module NaturalMachine.HaskellDiscoveryBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-assoc ; +-comm)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)

infixl 20 _+T_

data HaskellTerm : Type₀ where
  var   : ℕ → HaskellTerm
  zeroT : HaskellTerm
  sucT  : HaskellTerm → HaskellTerm
  _+T_  : HaskellTerm → HaskellTerm → HaskellTerm

Environment : Type₀
Environment = ℕ → ℕ

evaluate : Environment → HaskellTerm → ℕ
evaluate ρ (var n)  = ρ n
evaluate ρ zeroT    = zero
evaluate ρ (sucT t) = suc (evaluate ρ t)
evaluate ρ (l +T r) = evaluate ρ l + evaluate ρ r

Equation : Type₀
Equation = HaskellTerm × HaskellTerm

Sound : Equation → Type₀
Sound (l , r) = (ρ : Environment) → evaluate ρ l ≡ evaluate ρ r

data AllSound : List Equation → Type₀ where
  all[]  : AllSound []
  _all∷_ : {e : Equation} {es : List Equation}
         → Sound e → AllSound es → AllSound (e ∷ es)

infixr 20 _all∷_

x y z : HaskellTerm
x = var 0
y = var 1
z = var 2

-- This order is Haskell's `Data.Map` key order, exactly what the emitter
-- serialises.  A change in generation, canonicalisation, proof admission,
-- or ordering changes the generated AST and breaks the refl bridge.

expectedDiscoveries : List Equation
expectedDiscoveries =
    (x , zeroT +T x)
  ∷ (x +T y , y +T x)
  ∷ (x +T (x +T y) , y +T (x +T x))
  ∷ (x +T (y +T y) , y +T (x +T y))
  ∷ (x +T (y +T z) , y +T (x +T z))
  ∷ (sucT x +T y , sucT (x +T y))
  ∷ (sucT x , sucT zeroT +T x)
  ∷ []

sound-1 : Sound (x , zeroT +T x)
sound-1 ρ = refl

sound-2 : Sound (x +T y , y +T x)
sound-2 ρ = +-comm (ρ 0) (ρ 1)

sound-3 : Sound (x +T (x +T y) , y +T (x +T x))
sound-3 ρ =
  +-assoc (ρ 0) (ρ 0) (ρ 1)
  ∙ +-comm (ρ 0 + ρ 0) (ρ 1)

sound-4 : Sound (x +T (y +T y) , y +T (x +T y))
sound-4 ρ =
  +-assoc (ρ 0) (ρ 1) (ρ 1)
  ∙ +-comm (ρ 0 + ρ 1) (ρ 1)

sound-5 : Sound (x +T (y +T z) , y +T (x +T z))
sound-5 ρ =
  +-assoc (ρ 0) (ρ 1) (ρ 2)
  ∙ cong (_+ ρ 2) (+-comm (ρ 0) (ρ 1))
  ∙ sym (+-assoc (ρ 1) (ρ 0) (ρ 2))

sound-6 : Sound (sucT x +T y , sucT (x +T y))
sound-6 ρ = refl

sound-7 : Sound (sucT x , sucT zeroT +T x)
sound-7 ρ = refl

expectedDiscoveriesSound : AllSound expectedDiscoveries
expectedDiscoveriesSound =
    sound-1
  all∷ sound-2
  all∷ sound-3
  all∷ sound-4
  all∷ sound-5
  all∷ sound-6
  all∷ sound-7
  all∷ all[]
