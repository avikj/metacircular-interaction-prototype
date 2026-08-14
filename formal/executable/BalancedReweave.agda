{-# OPTIONS --safe #-}

module BalancedReweave where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat
open import Agda.Builtin.Bool
open import Agda.Builtin.Sigma

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

-- Adaptive online selection.  A lazy epoch records its total chain length and
-- the consecutive reads since its latest write.  A write resets the latter:
-- earlier reads had a different chain length and cannot honestly contribute
-- to the current break-even calculation.
data AdaptiveMode : Set where
  lazyMode : Plan Bool → Nat → Nat → AdaptiveMode
  fusedMode : BoolTable → AdaptiveMode

pred : Nat → Nat
pred zero = zero
pred (suc n) = n

-- For |Bool| = 2, q(k-1) > k(|X|-1) reduces to k < q(k-1).
shouldFuse : Nat → Nat → Bool
shouldFuse k q = k < q * pred k

normaliseBool : Plan Bool → BoolTable
normaliseBool p = tabulateBool (runPlan p)

normaliseBool-sound : (p : Plan Bool) (x : Bool)
  → applyBoolTable (normaliseBool p) x ≡ runPlan p x
normaliseBool-sound p x = tabulateBool-sound (runPlan p) x

runMode : AdaptiveMode → Bool → Bool
runMode (lazyMode p k q) x = runPlan p x
runMode (fusedMode t) x = applyBoolTable t x

updateMode : (Bool → Bool) → AdaptiveMode → AdaptiveMode
updateMode f (lazyMode p k q) = lazyMode (push f p) (suc k) zero
updateMode f (fusedMode t) = fusedMode (composeBoolTable f t)

updateMode-sound : (f : Bool → Bool) (m : AdaptiveMode) (x : Bool)
  → runMode (updateMode f m) x ≡ runMode m (f x)
updateMode-sound f (lazyMode p k q) x = push-sound f p x
updateMode-sound f (fusedMode t) x = composeBoolTable-sound f t x

-- A read returns both its observation and the representation for the next
-- operation.  Crossing the threshold changes representation, never value.
readMode : AdaptiveMode → Bool → Σ Bool (λ _ → AdaptiveMode)
readMode (fusedMode t) x = applyBoolTable t x , fusedMode t
readMode (lazyMode p k q) x with shouldFuse k (suc q)
... | false = runPlan p x , lazyMode p k (suc q)
... | true = runPlan p x , fusedMode (normaliseBool p)

readMode-value : (m : AdaptiveMode) (x : Bool)
  → fst (readMode m x) ≡ runMode m x
readMode-value (fusedMode t) x = refl
readMode-value (lazyMode p k q) x with shouldFuse k (suc q)
... | false = refl
... | true = refl

readMode-next : (m : AdaptiveMode) (x y : Bool)
  → runMode (snd (readMode m x)) y ≡ runMode m y
readMode-next (fusedMode t) x y = refl
readMode-next (lazyMode p k q) x y with shouldFuse k (suc q)
... | false = refl
... | true = normaliseBool-sound p y

record AdaptiveBoolProfile (R O : Set) : Set where
  constructor adaptiveBool
  field
    adaptiveMode : AdaptiveMode
    adaptiveBase : Profile R Bool O

open AdaptiveBoolProfile

readAdaptiveBool : {R O : Set} → AdaptiveBoolProfile R O → R → Bool
  → Σ O (λ _ → AdaptiveBoolProfile R O)
readAdaptiveBool C r x =
  adaptiveBase C r (fst step) , adaptiveBool (snd step) (adaptiveBase C)
  where
  step = readMode (adaptiveMode C) x

readAdaptiveBool-value : {R O : Set} (C : AdaptiveBoolProfile R O)
  (r : R) (x : Bool)
  → fst (readAdaptiveBool C r x) ≡ adaptiveBase C r (runMode (adaptiveMode C) x)
readAdaptiveBool-value C r x
  rewrite readMode-value (adaptiveMode C) x = refl

updateAdaptiveBool : {R O : Set} → (Bool → Bool) → AdaptiveBoolProfile R O
  → AdaptiveBoolProfile R O
updateAdaptiveBool f C = adaptiveBool (updateMode f (adaptiveMode C)) (adaptiveBase C)

updateAdaptiveBool-sound : {R O : Set} (f : Bool → Bool)
  (C : AdaptiveBoolProfile R O) (r : R) (x : Bool)
  → adaptiveBase C r (runMode (adaptiveMode (updateAdaptiveBool f C)) x)
    ≡ adaptiveBase C r (runMode (adaptiveMode C) (f x))
updateAdaptiveBool-sound f C r x
  rewrite updateMode-sound f (adaptiveMode C) x = refl

writeFlips : Nat → AdaptiveMode
writeFlips zero = lazyMode empty zero zero
writeFlips (suc n) = updateMode not (writeFlips n)

readRepeatedly : Nat → AdaptiveMode → AdaptiveMode
readRepeatedly zero m = m
readRepeatedly (suc n) m = readRepeatedly n (snd (readMode m false))

isFused : AdaptiveMode → Bool
isFused (lazyMode p k q) = false
isFused (fusedMode t) = true

adaptiveSelected : Nat → Nat → Bool
adaptiveSelected writes reads = isFused (readRepeatedly reads (writeFlips writes))

xor : Bool → Bool → Bool
xor false y = y
xor true false = true
xor true true = false

writeModeN : Nat → AdaptiveMode → AdaptiveMode
writeModeN zero m = m
writeModeN (suc n) m = writeModeN n (updateMode not m)

observeAdaptiveN : Nat → AdaptiveMode → Bool
  → Σ Bool (λ _ → AdaptiveMode)
observeAdaptiveN zero m acc = acc , m
observeAdaptiveN (suc n) m acc =
  observeAdaptiveN n (snd step) (xor (fst step) acc)
  where
  step = readMode m false

adaptiveEpochs : Nat → Nat → Nat → AdaptiveMode → Bool → Bool
adaptiveEpochs zero writes reads m acc = acc
adaptiveEpochs (suc epochs) writes reads m acc =
  adaptiveEpochs epochs writes reads (snd observed) (fst observed)
  where
  observed = observeAdaptiveN reads (writeModeN writes m) acc

adaptiveMixed : Nat → Nat → Nat → Bool
adaptiveMixed epochs writes reads =
  adaptiveEpochs epochs writes reads (lazyMode empty zero zero) false

writePlanN : Nat → Plan Bool → Plan Bool
writePlanN zero p = p
writePlanN (suc n) p = writePlanN n (push not p)

observePlanN : Nat → Plan Bool → Bool → Bool
observePlanN zero p acc = acc
observePlanN (suc n) p acc = observePlanN n p (xor (runPlan p false) acc)

lazyEpochs : Nat → Nat → Nat → Plan Bool → Bool → Bool
lazyEpochs zero writes reads p acc = acc
lazyEpochs (suc epochs) writes reads p acc =
  lazyEpochs epochs writes reads p′ (observePlanN reads p′ acc)
  where
  p′ = writePlanN writes p

lazyMixed : Nat → Nat → Nat → Bool
lazyMixed epochs writes reads = lazyEpochs epochs writes reads empty false

writeTableN : Nat → BoolTable → BoolTable
writeTableN zero t = t
writeTableN (suc n) t = writeTableN n (composeBoolTable not t)

observeTableN : Nat → BoolTable → Bool → Bool
observeTableN zero t acc = acc
observeTableN (suc n) t acc =
  observeTableN n t (xor (applyBoolTable t false) acc)

fusedEpochs : Nat → Nat → Nat → BoolTable → Bool → Bool
fusedEpochs zero writes reads t acc = acc
fusedEpochs (suc epochs) writes reads t acc =
  fusedEpochs epochs writes reads t′ (observeTableN reads t′ acc)
  where
  t′ = writeTableN writes t

fusedMixed : Nat → Nat → Nat → Bool
fusedMixed epochs writes reads =
  fusedEpochs epochs writes reads identityBoolTable false
