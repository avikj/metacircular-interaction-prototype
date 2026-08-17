{-# OPTIONS --safe #-}

module RootedReweave where

open import Agda.Builtin.Equality
open import Agda.Builtin.Sigma
open import Agda.Builtin.Bool
open import Agda.Builtin.Nat
import RewriteDynamics as RW

data ⊥ : Set where

contradiction : {A : Set} → ⊥ → A
contradiction ()

Profile : Set → Set → Set → Set
Profile Root State View = Root → State → View

-- A local state transformation acts contravariantly on every rooted view.
-- This is the whole global reweaving operation.
reweave : {R X Y O : Set} → (X → Y) → Profile R Y O → Profile R X O
reweave f P r x = P r (f x)

reweave-id-at : {R X O : Set} (P : Profile R X O) (r : R) (x : X)
  → reweave (λ z → z) P r x ≡ P r x
reweave-id-at P r x = refl

reweave-compose-at : {R X Y Z O : Set} (f : X → Y) (g : Y → Z)
  (P : Profile R Z O) (r : R) (x : X)
  → reweave f (reweave g P) r x ≡ reweave (λ z → g (f z)) P r x
reweave-compose-at f g P r x = refl

-- Persistent compiled representation.  All roots share `base`; a local
-- rewrite changes only the suspended state map.  No root is traversed.
record CompiledProfile (R X Y O : Set) : Set where
  constructor compiled
  field
    stateMap : X → Y
    base : Profile R Y O

open CompiledProfile

read : {R X Y O : Set} → CompiledProfile R X Y O → Profile R X O
read C = reweave (stateMap C) (base C)

update : {R W X Y O : Set} → (W → X) → CompiledProfile R X Y O
  → CompiledProfile R W Y O
update f C = compiled (λ w → stateMap C (f w)) (base C)

update-read : {R W X Y O : Set} (f : W → X) (C : CompiledProfile R X Y O)
  (r : R) (w : W) → read (update f C) r w ≡ reweave f (read C) r w
update-read f C r w = refl

update-compose : {R V W X Y O : Set} (f : V → W) (g : W → X)
  (C : CompiledProfile R X Y O) (r : R) (v : V)
  → read (update f (update g C)) r v
    ≡ read (update (λ z → g (f z)) C) r v
update-compose f g C r v = refl

Tear : {R X O : Set} → Profile R X O → Profile R X O → Set
Tear {R} {X} P Q = Σ R (λ r → Σ X (λ x → P r x ≡ Q r x → ⊥))

pullTear : {R X Y O : Set} (f : X → Y) (P Q : Profile R Y O)
  → (Σ R (λ r → Σ X (λ x → P r (f x) ≡ Q r (f x) → ⊥)))
  → Tear (reweave f P) (reweave f Q)
pullTear f P Q t = t

record Equiv (X Y : Set) : Set where
  constructor equiv
  field
    to : X → Y
    from : Y → X
    to-from : (y : Y) → to (from y) ≡ y
    from-to : (x : X) → from (to x) ≡ x

open Equiv

sym : {A : Set} {x y : A} → x ≡ y → y ≡ x
sym refl = refl

trans : {A : Set} {x y z : A} → x ≡ y → y ≡ z → x ≡ z
trans refl q = q

cong : {A B : Set} (f : A → B) {x y : A} → x ≡ y → f x ≡ f y
cong f refl = refl

-- Under a local equivalence, global reweaving retains the tear exactly:
-- pull it to every rooted view, or recover the original witness through the
-- inverse.  This is the non-erasure statement Delta 25 asks for.
tear-reweave-forward : {R X Y O : Set} (e : Equiv X Y)
  (P Q : Profile R Y O) → Tear P Q → Tear (reweave (to e) P) (reweave (to e) Q)
tear-reweave-forward e P Q (r , y , neq) =
  r , from e y , (λ eq → neq
    (trans (cong (P r) (sym (to-from e y)))
      (trans eq (cong (Q r) (to-from e y)))))

tear-reweave-back : {R X Y O : Set} (e : Equiv X Y)
  (P Q : Profile R Y O) → Tear (reweave (to e) P) (reweave (to e) Q) → Tear P Q
tear-reweave-back e P Q (r , x , neq) = r , to e x , neq

-- Executable nontrivial instance: a local bit flip reindexes both rooted
-- observers at once; the two roots respond differently but coherently.
data Root : Set where north south : Root

flip : Bool → Bool
flip false = true
flip true = false

rooted : Profile Root Bool Bool
rooted north b = b
rooted south b = flip b

rewoven : Profile Root Bool Bool
rewoven = reweave flip rooted

north-after south-after : Bool
north-after = rewoven north false
south-after = rewoven south false

north-control : north-after ≡ true
north-control = refl

south-control : south-after ≡ false
south-control = refl

-- Direct relation to the proof-relevant executable rewrite dynamics.  The
-- state map is not reimplemented: it projects the target computed by
-- `RW.rootStep`, whose derivation and semantic theorem live in that object.
rewriteTarget : RW.Tm → RW.Tm
rewriteTarget t = fst (RW.rootStep t)

data EvalRoot : Set where atZero atOne : EvalRoot

rootedEval : Profile EvalRoot RW.Tm Nat
rootedEval atZero t = RW.eval t zero
rootedEval atOne  t = RW.eval t (suc zero)

compiledEval : CompiledProfile EvalRoot RW.Tm RW.Tm Nat
compiledEval = compiled (λ t → t) rootedEval

afterIntrinsic : CompiledProfile EvalRoot RW.Tm RW.Tm Nat
afterIntrinsic = update rewriteTarget compiledEval

afterIntrinsic-sound : (r : EvalRoot) (t : RW.Tm)
  → read afterIntrinsic r t ≡ read compiledEval r t
afterIntrinsic-sound atZero t = sym (RW.rootStep-sound t zero)
afterIntrinsic-sound atOne  t = sym (RW.rootStep-sound t (suc zero))
