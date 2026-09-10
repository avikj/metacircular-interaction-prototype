{-# OPTIONS --safe #-}

module InstalledRootedQuotient where

open import Agda.Builtin.Equality
open import Agda.Builtin.Sigma
open import Agda.Builtin.Nat
open import Agda.Builtin.Bool
import TheoremCompiledObservation as TC

data ⊥ : Set where

Not : Set → Set
Not A = A → ⊥

sym : {A : Set} {x y : A} → x ≡ y → y ≡ x
sym refl = refl

trans : {A : Set} {x y z : A} → x ≡ y → y ≡ z → x ≡ z
trans refl q = q

cong : {A B : Set} (f : A → B) {x y : A} → x ≡ y → f x ≡ f y
cong f refl = refl

-- One quotient shared by all roots.  Every rooted observation must factor;
-- importing this theorem is exactly what licenses installation.
record RootedSufficient (R X Q O : Set) : Set where
  constructor rootedSufficient
  field
    quotient : X → Q
    observeLarge : R → X → O
    observeSmall : R → Q → O
    factors : (r : R) (x : X)
      → observeLarge r x ≡ observeSmall r (quotient x)

open RootedSufficient

-- The origin is retained, not reconstructed.  `aligned` states that the
-- installed small state is exactly its theorem-provided image.
record Installed {R X Q O : Set} (S : RootedSufficient R X Q O) : Set where
  constructor installed
  field
    origin : X
    small : Q
    aligned : quotient S origin ≡ small

open Installed

install : {R X Q O : Set} (S : RootedSufficient R X Q O) (x : X) → Installed S
install S x = installed x (quotient S x) refl

readInstalled : {R X Q O : Set} {S : RootedSufficient R X Q O}
  → Installed S → R → O
readInstalled {S = S} I r = observeSmall S r (small I)

install-sound : {R X Q O : Set} (S : RootedSufficient R X Q O)
  (x : X) (r : R) → observeLarge S r x ≡ readInstalled (install S x) r
install-sound S x r = factors S r x

readInstalled-sound : {R X Q O : Set} {S : RootedSufficient R X Q O}
  (I : Installed S) (r : R)
  → observeLarge S r (origin I) ≡ readInstalled I r
readInstalled-sound {S = S} I r = trans (factors S r (origin I))
  (cong (observeSmall S r) (aligned I))

-- A new action may remain in the installed language only with this theorem.
record Descends {R X Q O : Set} (S : RootedSufficient R X Q O)
  (largeStep : X → X) : Set where
  constructor descends
  field
    smallStep : Q → Q
    commutes : (x : X)
      → quotient S (largeStep x) ≡ smallStep (quotient S x)

open Descends

stepInstalled : {R X Q O : Set} {S : RootedSufficient R X Q O}
  (largeStep : X → X) → Descends S largeStep → Installed S → Installed S
stepInstalled {S = S} largeStep D I = installed
  (largeStep (origin I))
  (smallStep D (small I))
  (trans (commutes D (origin I)) (cong (smallStep D) (aligned I)))

stepInstalled-sound : {R X Q O : Set} {S : RootedSufficient R X Q O}
  (largeStep : X → X) (D : Descends S largeStep) (I : Installed S) (r : R)
  → observeLarge S r (largeStep (origin I))
    ≡ readInstalled (stepInstalled largeStep D I) r
stepInstalled-sound {S = S} largeStep D I r =
  readInstalled-sound (stepInstalled largeStep D I) r

-- Exact obstruction: the old quotient joins x and y, but the proposed action
-- sends them to distinguishable quotient states.
ActionTear : {R X Q O : Set} (S : RootedSufficient R X Q O)
  → (X → X) → Set
ActionTear {X = X} S h = Σ X (λ x → Σ X (λ y →
  Σ (quotient S x ≡ quotient S y) (λ _ →
    Not (quotient S (h x) ≡ quotient S (h y)))))

tear-refutes-descent : {R X Q O : Set} (S : RootedSufficient R X Q O)
  (h : X → X) → ActionTear S h → Not (Descends S h)
tear-refutes-descent S h (x , y , same , apart) D = apart
  (trans (commutes D x)
    (trans (cong (smallStep D) same) (sym (commutes D y))))

-- Evidence directs the only possible transition.  The tear branch contains
-- no Q-state at all: it reopens the retained origin and performs h in X.
data ExtensionEvidence {R X Q O : Set} (S : RootedSufficient R X Q O)
  (h : X → X) : Set where
  accepted : Descends S h → ExtensionEvidence S h
  obstructed : ActionTear S h → ExtensionEvidence S h

data ExtensionResult {R X Q O : Set} (S : RootedSufficient R X Q O) : Set where
  remainsInstalled : Installed S → ExtensionResult S
  reopened : X → ExtensionResult S

extend : {R X Q O : Set} {S : RootedSufficient R X Q O}
  (h : X → X) → ExtensionEvidence S h → Installed S → ExtensionResult S
extend h (accepted D) I = remainsInstalled (stepInstalled h D I)
extend h (obstructed tear) I = reopened (h (origin I))

-- Productive iteration stays compressed only because the same descent theorem
-- is replayed at every successor stage, while every stage retains its origin.
iterateInstalled : {R X Q O : Set} {S : RootedSufficient R X Q O}
  (h : X → X) → Descends S h → Nat → Installed S → Installed S
iterateInstalled h D zero I = I
iterateInstalled h D (suc n) I = iterateInstalled h D n (stepInstalled h D I)

iterateInstalled-origin : {R X Q O : Set} {S : RootedSufficient R X Q O}
  (h : X → X) (D : Descends S h) (n : Nat) (I : Installed S)
  → origin (iterateInstalled h D n I) ≡ TC.iterate n h (origin I)
iterateInstalled-origin h D zero I = refl
iterateInstalled-origin h D (suc n) I = iterateInstalled-origin h D n (stepInstalled h D I)

-- Executable rooted parity instance.  Two roots read parity and its complement.
-- Successor remains installed; predecessor tears the parity quotient because
-- 0 and 2 are both even while pred 0 and pred 2 have different parity.
data ParityRoot : Set where evenRoot oddRoot : ParityRoot

parityLarge : ParityRoot → Nat → Bool
parityLarge evenRoot n = TC.parity n
parityLarge oddRoot n = TC.not (TC.parity n)

paritySmall : ParityRoot → Bool → Bool
paritySmall evenRoot b = b
paritySmall oddRoot b = TC.not b

rootedParity : RootedSufficient ParityRoot Nat Bool Bool
rootedParity = rootedSufficient TC.parity parityLarge paritySmall proof
  where
  proof : (r : ParityRoot) (n : Nat)
    → parityLarge r n ≡ paritySmall r (TC.parity n)
  proof evenRoot n = refl
  proof oddRoot n = refl

successorDescends : Descends rootedParity suc
successorDescends = descends TC.not (λ n → refl)

pred : Nat → Nat
pred zero = zero
pred (suc n) = n

false≠true : Not (false ≡ true)
false≠true ()

predecessorTear : ActionTear rootedParity pred
predecessorTear = zero , suc (suc zero) , refl , false≠true

predecessorCannotDescend : Not (Descends rootedParity pred)
predecessorCannotDescend = tear-refutes-descent rootedParity pred predecessorTear

installedTwo : Installed rootedParity
installedTwo = install rootedParity (suc (suc zero))

afterSuccessor : Installed rootedParity
afterSuccessor = stepInstalled suc successorDescends installedTwo

afterPredecessor : ExtensionResult rootedParity
afterPredecessor = extend pred (obstructed predecessorTear) installedTwo

extensionWasReopened : Bool
extensionWasReopened with afterPredecessor
... | remainsInstalled I = false
... | reopened x = true

reopenedState : Nat
reopenedState with afterPredecessor
... | remainsInstalled I = zero
... | reopened x = x

reopenedState-is-one : reopenedState ≡ suc zero
reopenedState-is-one = refl
