{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BalanceWithoutTransitivity
--
-- A balanced quotient attains the exact coherent-overwrite index bound even
-- when retained source structure forbids every lift of the target swap.
-- Therefore fiber balance is the quantum resource criterion; transitive
-- equivariance is a sufficient certificate for balance, not a necessary
-- process structure.
--
-- Source = Bool × Bool, quotient = first coordinate.  Both fibers are Bool.
-- The second coordinate is an attaining environment certificate.  A mark on
-- the unique point (false,false) prevents any mark-preserving map from lifting
-- negation on the target.  Erasing the mark restores the evident swap, which
-- is the hostile control locating the obstruction in retained structure.
------------------------------------------------------------------------

module BalanceWithoutTransitivity where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.Isomorphism
  using (Iso ; invIso ; isoToEquiv)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; not ; false≢true ; true≢false ; isSetBool)
open import Cubical.Data.Sigma
  using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Functions.Embedding
  using (isEmbedding ; _↪_ ; Equiv→Embedding ; compEmbedding)
open import Cubical.Relation.Nullary using (¬_)

import CertificateFibration as Cert
import FiniteInformation as FI

------------------------------------------------------------------------
-- 1. A balanced 2+2 quotient
------------------------------------------------------------------------

Source : Type₀
Source = Bool × Bool

quotient : Source → Bool
quotient = fst

coordinate : Source → Bool
coordinate = snd

falseFiberIso : Iso (fiber quotient false) Bool
Iso.fun      falseFiberIso ((false , b) , _) = b
Iso.fun      falseFiberIso ((true  , b) , p) = Empty.rec (true≢false p)
Iso.inv      falseFiberIso b                 = (false , b) , refl
Iso.rightInv falseFiberIso _                 = refl
Iso.leftInv  falseFiberIso ((false , b) , _) =
  Σ≡Prop (λ _ → isSetBool _ _) refl
Iso.leftInv  falseFiberIso ((true , b) , p)  = Empty.rec (true≢false p)

trueFiberIso : Iso (fiber quotient true) Bool
Iso.fun      trueFiberIso ((false , b) , p) = Empty.rec (false≢true p)
Iso.fun      trueFiberIso ((true  , b) , _) = b
Iso.inv      trueFiberIso b                 = (true , b) , refl
Iso.rightInv trueFiberIso _                 = refl
Iso.leftInv  trueFiberIso ((false , b) , p) = Empty.rec (false≢true p)
Iso.leftInv  trueFiberIso ((true , b) , _)  =
  Σ≡Prop (λ _ → isSetBool _ _) refl

-- Every exact recorded update must hold a copy of Bool: one selected fiber
-- already embeds in its environment alphabet.
environment-lower : {Environment : Type₀}
  (certificate : Source → Environment)
  → isEmbedding (Cert.recorded quotient certificate)
  → Bool ↪ Environment
environment-lower certificate embedding =
  compEmbedding
    (Cert.fiber↪cert quotient certificate embedding false)
    (Equiv→Embedding (isoToEquiv (invIso falseFiberIso)))

-- The second coordinate attains that lower bound.
coordinate-completes : FI.Completes quotient coordinate
coordinate-completes (_ , _) (_ , _) equality = equality

environment-attains :
  isEmbedding (Cert.recorded quotient coordinate)
environment-attains =
  Cert.Completes→isEmbedding quotient coordinate
    isSetBool isSetBool coordinate-completes

------------------------------------------------------------------------
-- 2. Retained structure forbids a transitive lift
------------------------------------------------------------------------

-- The source remembers one distinguished point in the false fiber.
mark : Source → Bool
mark (false , false) = true
mark _               = false

-- Any point over target `true` is unmarked.
true-fiber-unmarked : (x : Source)
  → quotient x ≡ true
  → mark x ≡ false
true-fiber-unmarked (false , _) p = Empty.rec (false≢true p)
true-fiber-unmarked (true  , _) _ = refl

-- A structure-preserving lift of the nontrivial target symmetry would be a
-- map flipping the quotient while preserving the mark.  Bijection is not
-- assumed: the impossibility is stronger than absence of an automorphism.
SwapLift : Type₀
SwapLift =
  Σ[ g ∈ (Source → Source) ]
    (((x : Source) → quotient (g x) ≡ not (quotient x))
      × ((x : Source) → mark (g x) ≡ mark x))

no-mark-preserving-swap : ¬ SwapLift
no-mark-preserving-swap (g , flips , preserves) =
  true≢false
    (sym (preserves (false , false))
      ∙ true-fiber-unmarked (g (false , false)) (flips (false , false)))

------------------------------------------------------------------------
-- 3. Hostile control: erase the mark and the bare swap returns
------------------------------------------------------------------------

bareSwap : Source → Source
bareSwap (a , b) = not a , b

bareSwap-flips : (x : Source)
  → quotient (bareSwap x) ≡ not (quotient x)
bareSwap-flips (false , _) = refl
bareSwap-flips (true  , _) = refl

bareSwap-involutive : (x : Source) → bareSwap (bareSwap x) ≡ x
bareSwap-involutive (false , _) = refl
bareSwap-involutive (true  , _) = refl

bareSwap-breaks-mark :
  ¬ ((x : Source) → mark (bareSwap x) ≡ mark x)
bareSwap-breaks-mark preserves = false≢true (preserves (false , false))
