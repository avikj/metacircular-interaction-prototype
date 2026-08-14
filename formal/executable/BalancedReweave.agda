{-# OPTIONS --safe #-}

module BalancedReweave where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat

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

balancedCount : Nat → Nat
balancedCount n = runPlan (repeatPlan n) zero

linearCount : Nat → Nat
linearCount zero = zero
linearCount (suc n) = suc (linearCount n)

balancedCount-sound : (n : Nat) → balancedCount n ≡ linearCount n
balancedCount-sound zero = refl
balancedCount-sound (suc n) rewrite push-sound suc (repeatPlan n) zero
  | balancedCount-sound n = refl
