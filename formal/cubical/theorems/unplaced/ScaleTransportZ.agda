{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ScaleTransportZ
--
-- Discharging the abstract order/analytic fields of ScaleTransportCriticality
-- over the concrete ordered group ℤ.  This turns obligations B and C from the
-- ledger into checked terms:
--
--   B  (functional equation, dual-exp)  : the exponent pairing exp(dual m) =
--        −exp m is supplied by ± pairing; here it is a hypothesis of
--        `all-critical` discharged trivially by any concrete symmetric mode set.
--   C  (grows-unbounds)                 : PROVED — a positive integer exponent
--        makes the additive scale orbit unbounded (`grows`), by an Archimedean
--        bound `orbit-lb`.  No longer a field.
--   the order layer (¬<0→≤0, antisymmetry, neg≤0→0≤) : PROVED from ℤ's order.
--
-- Obligation A (the explicit formula bridging the arithmetic B(t) to these
-- exponent modes) is the classical analytic input — Prop 2/3 of the derivation,
-- Bombieri §V — and needs ζ's continuation, so it lives outside this arithmetic
-- kernel; it is not a --safe term and is cited, not faked.
--
-- Obligation D, held in view: in this model `Bounded (exp m)` is exactly
-- `exp m ≤ 0` (`boundedOrbit→≤0` / `≤0→boundedOrbit`), so D — proving every
-- orbit bounded from the arithmetic side — is exactly "every exponent ≤ 0",
-- i.e. Θ ≤ ½; with the ± pairing (B) `all-critical` then gives exp ≡ 0,
-- i.e. Θ = ½.  D is the sole remaining mountain.
------------------------------------------------------------------------

module ScaleTransportZ where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc) renaming (_+_ to _+ℕ_)
open import Cubical.Data.Nat.Properties using (+-comm)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; -_ ; _+_ ; sucℤ ; -Involutive ; pos+)
open import Cubical.Data.Int.Order
  using ( _<_ ; _≤_ ; isRefl≤ ; isTrans≤ ; isAntisym≤ ; ≤Monotone+
        ; -Dist≤ ; zero-≤pos ; negsuc<-zero ; <-weaken ; suc-≤-suc
        ; ≤<-trans ; isIrrefl< )
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import ScaleTransportCriticality

------------------------------------------------------------------------
-- §1  ℤ is an OrderedExponents (the order fields, proved).
------------------------------------------------------------------------

z-¬<0→≤0 : {a : ℤ} → ¬ (pos 0 < a) → a ≤ pos 0
z-¬<0→≤0 {pos zero}    _ = isRefl≤
z-¬<0→≤0 {pos (suc n)} h = ⊥.rec (h (suc-≤-suc zero-≤pos))
z-¬<0→≤0 {negsuc n}    _ = <-weaken negsuc<-zero

z-neg≤0→0≤ : {a : ℤ} → (- a) ≤ pos 0 → pos 0 ≤ a
z-neg≤0→0≤ {a} h = subst (pos 0 ≤_) (-Involutive a) (-Dist≤ h)

ℤexp : OrderedExponents ℓ-zero
ℤexp = record
  { G = ℤ
  ; 𝟎 = pos 0
  ; _<_ = _<_
  ; _≤_ = _≤_
  ; neg = -_
  ; ¬<0→≤0   = z-¬<0→≤0
  ; ≤0∧0≤→≡0 = isAntisym≤
  ; neg≤0→0≤ = z-neg≤0→0≤
  }

------------------------------------------------------------------------
-- §2  The additive scale orbit and the Archimedean growth theorem (C).
------------------------------------------------------------------------

orbit : ℤ → ℕ → ℤ
orbit e zero    = pos 0
orbit e (suc n) = orbit e n + e

BoundedOrbit : ℤ → Type₀
BoundedOrbit e = Σ[ B ∈ ℤ ] ((n : ℕ) → orbit e n ≤ B)

-- pos(suc n) = pos n + pos 1, in ℤ.
sucpos : (n : ℕ) → pos (suc n) ≡ pos n + pos 1
sucpos n = sym (cong pos (+-comm n 1)) ∙ pos+ n 1

-- a positive-exponent orbit dominates the naturals.
orbit-lb : (e : ℤ) → pos 1 ≤ e → (n : ℕ) → pos n ≤ orbit e n
orbit-lb e h1 zero    = isRefl≤
orbit-lb e h1 (suc n) =
  subst (_≤ orbit e (suc n)) (sym (sucpos n))
    (≤Monotone+ (orbit-lb e h1 n) h1)

-- every integer is exceeded by some pos n.
arch : (B : ℤ) → Σ[ n ∈ ℕ ] B < pos n
arch (pos k)    = suc k , isRefl≤
arch (negsuc k) = zero  , negsuc<-zero

-- C, proved: a positive exponent has no bounded orbit.
grows : (e : ℤ) → pos 0 < e → ¬ BoundedOrbit e
grows e 0<e (B , bnd) with arch B
... | (n , B<n) = isIrrefl< (≤<-trans (isTrans≤ (orbit-lb e 0<e n) (bnd n)) B<n)

-- D, made local: a nonpositive exponent has a bounded orbit, and conversely.
≤0→boundedOrbit : (e : ℤ) → e ≤ pos 0 → BoundedOrbit e
≤0→boundedOrbit e e≤0 = pos 0 , bound
  where
  bound : (n : ℕ) → orbit e n ≤ pos 0
  bound zero    = isRefl≤
  bound (suc n) = ≤Monotone+ (bound n) e≤0   -- orbit n + e ≤ 0 + 0 = 0

boundedOrbit→≤0 : (e : ℤ) → BoundedOrbit e → e ≤ pos 0
boundedOrbit→≤0 e bo = z-¬<0→≤0 (λ 0<e → grows e 0<e bo)

------------------------------------------------------------------------
-- §3  A concrete transport over ℤ, with B and C discharged, and the
--     criticality corollary specialised.
------------------------------------------------------------------------

mkTransport :
    (Mode : Type₀) (exp : Mode → ℤ) (dual : Mode → Mode)
  → ((m : Mode) → exp (dual m) ≡ (- exp m))
  → Transport ℤexp
mkTransport Mode exp dual de = record
  { Mode           = Mode
  ; exp            = exp
  ; Bounded        = λ m → BoundedOrbit (exp m)
  ; grows-unbounds = λ m 0<e → grows (exp m) 0<e
  ; dual           = dual
  ; dual-exp       = de
  }

-- The concrete criticality theorem: over ℤ, functional-equation pairing plus
-- all orbits bounded forces every exponent to 0 (every zero on the line).
all-critical :
    (Mode : Type₀) (exp : Mode → ℤ) (dual : Mode → Mode)
  → (de  : (m : Mode) → exp (dual m) ≡ (- exp m))
  → (bdd : (m : Mode) → BoundedOrbit (exp m))
  → (m : Mode) → exp m ≡ pos 0
all-critical Mode exp dual de bdd =
  criticality ℤexp (mkTransport Mode exp dual de) bdd

-- D's sufficiency, stated exactly: if every exponent is nonpositive (Θ ≤ ½)
-- and the functional equation pairs exponents (B), then every exponent is 0
-- (Θ = ½).  This is the whole RH-shaped conclusion, resting solely on the
-- nonpositivity estimate D = "(m) → exp m ≤ 0".
criticality-from-≤0 :
    (Mode : Type₀) (exp : Mode → ℤ) (dual : Mode → Mode)
  → (de : (m : Mode) → exp (dual m) ≡ (- exp m))
  → ((m : Mode) → exp m ≤ pos 0)
  → (m : Mode) → exp m ≡ pos 0
criticality-from-≤0 Mode exp dual de h =
  all-critical Mode exp dual de (λ m → ≤0→boundedOrbit (exp m) (h m))
