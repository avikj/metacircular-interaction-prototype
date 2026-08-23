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
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm ; ·-comm ; 0≡m·0)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)

infixl 20 _+T_ _·T_

data HaskellTerm : Type₀ where
  var   : ℕ → HaskellTerm
  zeroT : HaskellTerm
  sucT  : HaskellTerm → HaskellTerm
  _+T_  : HaskellTerm → HaskellTerm → HaskellTerm
  _·T_  : HaskellTerm → HaskellTerm → HaskellTerm

Environment : Type₀
Environment = ℕ → ℕ

evaluate : Environment → HaskellTerm → ℕ
evaluate ρ (var n)  = ρ n
evaluate ρ zeroT    = zero
evaluate ρ (sucT t) = suc (evaluate ρ t)
evaluate ρ (l +T r) = evaluate ρ l + evaluate ρ r
evaluate ρ (l ·T r) = evaluate ρ l · evaluate ρ r

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
  ∷ (sucT x +T y , sucT (x +T y))
  ∷ (zeroT , zeroT ·T x)
  ∷ (sucT x , sucT zeroT +T x)
  ∷ []

sound-1 : Sound (x , zeroT +T x)
sound-1 ρ = refl

sound-2 : Sound (sucT x +T y , sucT (x +T y))
sound-2 ρ = refl

sound-3 : Sound (zeroT , zeroT ·T x)
sound-3 ρ = 0≡m·0 (ρ 0) ∙ sym (·-comm zero (ρ 0))

sound-4 : Sound (sucT x , sucT zeroT +T x)
sound-4 ρ = refl

expectedDiscoveriesSound : AllSound expectedDiscoveries
expectedDiscoveriesSound =
    sound-1
  all∷ sound-2
  all∷ sound-3
  all∷ sound-4
  all∷ all[]
