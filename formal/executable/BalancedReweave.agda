{-# OPTIONS --safe #-}

module BalancedReweave where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat
open import Agda.Builtin.Bool

-- A perfect tree contains 2^rank endomorphisms.  The left subtree is newer:
-- it acts first, followed by the older right subtree.
data EndoTree (A : Set) : Nat → Set where
  leaf : (A → A) → EndoTree A zero
  node : {n : Nat} → EndoTree A n → EndoTree A n → EndoTree A (suc n)

runTree : {A : Set} {n : Nat} → EndoTree A n → A → A
runTree (leaf f) x = f x
runTree (node newer older) x = runTree older (runTree newer x)

-- Binary digits from a stated rank.  The type permits at most one perfect
-- tree at each rank, so the logarithmic-height invariant is structural rather
-- than a comment checked by a separate validator.
data PlanFrom (A : Set) : Nat → Set where
  done : {n : Nat} → PlanFrom A n
  zeroD : {n : Nat} → PlanFrom A (suc n) → PlanFrom A n
  oneD : {n : Nat} → EndoTree A n → PlanFrom A (suc n) → PlanFrom A n

Plan : Set → Set
Plan A = PlanFrom A zero

runPlanFrom : {A : Set} {n : Nat} → PlanFrom A n → A → A
runPlanFrom done x = x
runPlanFrom (zeroD ds) x = runPlanFrom ds x
runPlanFrom (oneD t ds) x = runPlanFrom ds (runTree t x)

runPlan : {A : Set} → Plan A → A → A
runPlan = runPlanFrom

-- Binary carry.  One update touches exactly the trailing occupied digits.
insertTree : {A : Set} {n : Nat} → EndoTree A n → PlanFrom A n → PlanFrom A n
insertTree t done = oneD t done
insertTree t (zeroD ds) = oneD t ds
insertTree t (oneD u ds) = zeroD (insertTree (node t u) ds)

insertTree-sound : {A : Set} {n : Nat} (t : EndoTree A n)
  (ds : PlanFrom A n) (x : A)
  → runPlanFrom (insertTree t ds) x ≡ runPlanFrom ds (runTree t x)
insertTree-sound t done x = refl
insertTree-sound t (zeroD ds) x = refl
insertTree-sound t (oneD u ds) x = insertTree-sound (node t u) ds x

empty : {A : Set} → Plan A
empty = done

push : {A : Set} → (A → A) → Plan A → Plan A
push f = insertTree (leaf f)

push-sound : {A : Set} (f : A → A) (p : Plan A) (x : A)
  → runPlan (push f p) x ≡ runPlan p (f x)
push-sound f p x = insertTree-sound (leaf f) p x

-- The original suspended-composition shape, retained as the control.
data LinearPlan (A : Set) : Set where
  linearDone : LinearPlan A
  linearPush : (A → A) → LinearPlan A → LinearPlan A

runLinearPlan : {A : Set} → LinearPlan A → A → A
runLinearPlan linearDone x = x
runLinearPlan (linearPush f p) x = runLinearPlan p (f x)

-- The balanced representation specializes persistent rooted reweaving to
-- endomorphisms, the case where a long-lived state language is updated many
-- times.  Arbitrary type-changing updates remain represented by
-- RootedReweave.CompiledProfile.
Profile : Set → Set → Set → Set
Profile Root State View = Root → State → View

record BalancedProfile (R X O : Set) : Set where
  constructor balanced
  field
    plan : Plan X
    base : Profile R X O

open BalancedProfile

read : {R X O : Set} → BalancedProfile R X O → Profile R X O
read C r x = base C r (runPlan (plan C) x)

update : {R X O : Set} → (X → X) → BalancedProfile R X O
  → BalancedProfile R X O
update f C = balanced (push f (plan C)) (base C)

update-read : {R X O : Set} (f : X → X) (C : BalancedProfile R X O)
  (r : R) (x : X) → read (update f C) r x ≡ read C r (f x)
update-read f C r x rewrite push-sound f (plan C) x = refl

-- Native benchmark entry points.  Both execute the same k successor maps;
-- they test evaluator shape and stack behavior, not an asymptotic speedup.
repeatPlan : Nat → Plan Nat
repeatPlan zero = empty
repeatPlan (suc n) = push suc (repeatPlan n)

repeatLinearPlan : Nat → LinearPlan Nat
repeatLinearPlan zero = linearDone
repeatLinearPlan (suc n) = linearPush suc (repeatLinearPlan n)

balancedCount : Nat → Nat
balancedCount n = runPlan (repeatPlan n) zero

linearPlanCount : Nat → Nat
linearPlanCount n = runLinearPlan (repeatLinearPlan n) zero

linearCount : Nat → Nat
linearCount zero = zero
linearCount (suc n) = suc (linearCount n)

repeatPlan-commutes-suc : (n x : Nat)
  → runPlan (repeatPlan n) (suc x) ≡ suc (runPlan (repeatPlan n) x)
repeatPlan-commutes-suc zero x = refl
repeatPlan-commutes-suc (suc n) x
  rewrite push-sound suc (repeatPlan n) (suc x)
  | push-sound suc (repeatPlan n) x
  | repeatPlan-commutes-suc n (suc x) = refl

balancedCount-sound : (n : Nat) → balancedCount n ≡ linearCount n
balancedCount-sound zero = refl
balancedCount-sound (suc n) rewrite push-sound suc (repeatPlan n) zero
  | repeatPlan-commutes-suc n zero
  | balancedCount-sound n = refl

linearPlanCount-sound : (n : Nat) → linearPlanCount n ≡ linearCount n
linearPlanCount-sound zero = refl
linearPlanCount-sound (suc n) = linearPlanCount-step n
  where
  linearPlan-commutes-suc : (m x : Nat)
    → runLinearPlan (repeatLinearPlan m) (suc x)
      ≡ suc (runLinearPlan (repeatLinearPlan m) x)
  linearPlan-commutes-suc zero x = refl
  linearPlan-commutes-suc (suc m) x
    rewrite linearPlan-commutes-suc m (suc x) = refl

  linearPlanCount-step : (m : Nat)
    → linearPlanCount (suc m) ≡ linearCount (suc m)
  linearPlanCount-step m rewrite linearPlan-commutes-suc m zero
    | linearPlanCount-sound m = refl

-- Algebra-specific normalization for the two-state carrier.  A Bool
-- endomorphism has exactly two entries; composition is evaluated eagerly into
-- those entries, so neither the update nor a later read retains history.
record BoolTable : Set where
  constructor boolTable
  field
    atFalse : Bool
    atTrue : Bool

open BoolTable

applyBoolTable : BoolTable → Bool → Bool
applyBoolTable t false = atFalse t
applyBoolTable t true = atTrue t

tabulateBool : (Bool → Bool) → BoolTable
tabulateBool f = boolTable (f false) (f true)

tabulateBool-sound : (f : Bool → Bool) (x : Bool)
  → applyBoolTable (tabulateBool f) x ≡ f x
tabulateBool-sound f false = refl
tabulateBool-sound f true = refl

composeBoolTable : (Bool → Bool) → BoolTable → BoolTable
composeBoolTable f t = boolTable
  (applyBoolTable t (f false))
  (applyBoolTable t (f true))

composeBoolTable-sound : (f : Bool → Bool) (t : BoolTable) (x : Bool)
  → applyBoolTable (composeBoolTable f t) x ≡ applyBoolTable t (f x)
composeBoolTable-sound f t false = refl
composeBoolTable-sound f t true = refl

record FusedBoolProfile (R O : Set) : Set where
  constructor fusedBool
  field
    boolPlan : BoolTable
    boolBase : Profile R Bool O

open FusedBoolProfile

readFusedBool : {R O : Set} → FusedBoolProfile R O → Profile R Bool O
readFusedBool C r x = boolBase C r (applyBoolTable (boolPlan C) x)

updateFusedBool : {R O : Set} → (Bool → Bool) → FusedBoolProfile R O
  → FusedBoolProfile R O
updateFusedBool f C = fusedBool (composeBoolTable f (boolPlan C)) (boolBase C)

updateFusedBool-read : {R O : Set} (f : Bool → Bool)
  (C : FusedBoolProfile R O) (r : R) (x : Bool)
  → readFusedBool (updateFusedBool f C) r x ≡ readFusedBool C r (f x)
updateFusedBool-read f C r x rewrite composeBoolTable-sound f (boolPlan C) x = refl

not : Bool → Bool
not false = true
not true = false

identityBoolTable : BoolTable
identityBoolTable = tabulateBool (λ x → x)

repeatFusedFlip : Nat → BoolTable
repeatFusedFlip zero = identityBoolTable
repeatFusedFlip (suc n) = composeBoolTable not (repeatFusedFlip n)

fusedFlipCount : Nat → Bool
fusedFlipCount n = applyBoolTable (repeatFusedFlip n) false

repeatBalancedFlip : Nat → Plan Bool
repeatBalancedFlip zero = empty
repeatBalancedFlip (suc n) = push not (repeatBalancedFlip n)

balancedFlipCount : Nat → Bool
balancedFlipCount n = runPlan (repeatBalancedFlip n) false

fused-balanced-flip : (n : Nat) (x : Bool)
  → applyBoolTable (repeatFusedFlip n) x
    ≡ runPlan (repeatBalancedFlip n) x
fused-balanced-flip zero false = refl
fused-balanced-flip zero true = refl
fused-balanced-flip (suc n) x
  rewrite composeBoolTable-sound not (repeatFusedFlip n) x
  | fused-balanced-flip n (not x)
  | push-sound not (repeatBalancedFlip n) x = refl
