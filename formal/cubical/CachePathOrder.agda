-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- CachePathOrder
--
-- A checked bridge between two existing corpus objects:
--
-- * fixed-policy persistent caches install a declared root path by union;
-- * ObligatioOrderTrilemma proves that every commuting update has a
--   permutation-invariant finite fold.
--
-- The endpoint theorem below is the specialization.  The cost theorem is
-- deliberately stated for any natural-valued potential and marginal-cost
-- law.  Finite-cache cardinality is the intended instance:
--
--   potential K              = |K|
--   marginal K P             = |P ∖ K|
--   potential K + marginal K P = potential (K ∪ P).
--
-- Thus accumulated new-node cost telescopes to endpoint growth and inherits
-- permutation invariance.  No eviction, alternative-path selection, or
-- prefix-reading controller is represented here.
------------------------------------------------------------------------

module CachePathOrder where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; false; true; not; _and_; _or_)
open import Cubical.Data.List using (List; []; _∷_; foldl)
open import Cubical.Data.Nat using (ℕ; zero; _+_; +-assoc; +-comm; +-zero; inj-m+)
open import ObligatioOrderTrilemma using (Perm; foldlPermInvariant)

private
  variable
    ℓ : Level
    A : Type ℓ

-- A path and a cache have the same extensional carrier: their Boolean
-- membership functions.  A lawful fixed-policy path cache is an
-- ancestor-closed inhabitant of this type; commutation itself needs only the
-- union update, so the closure witness stays at the note-level interface.
Cache : Type ℓ → Type ℓ
Cache A = A → Bool

Trace : Type ℓ → Type ℓ
Trace = Cache

install : Cache A → Trace A → Cache A
install K P x = K x or P x

orCommuteStep : (x a b : Bool) → ((x or a) or b) ≡ ((x or b) or a)
orCommuteStep false false false = refl
orCommuteStep false false true  = refl
orCommuteStep false true  false = refl
orCommuteStep false true  true  = refl
orCommuteStep true  false false = refl
orCommuteStep true  false true  = refl
orCommuteStep true  true  false = refl
orCommuteStep true  true  true  = refl

installCommutes : (K : Cache A) (P Q : Trace A)
                → install (install K P) Q ≡ install (install K Q) P
installCommutes K P Q = funExt (λ x → orCommuteStep (K x) (P x) (Q x))

orIdempotentStep : (x a : Bool) → ((x or a) or a) ≡ (x or a)
orIdempotentStep false false = refl
orIdempotentStep false true  = refl
orIdempotentStep true  false = refl
orIdempotentStep true  true  = refl

installIdempotent : (K : Cache A) (P : Trace A)
                  → install (install K P) P ≡ install K P
installIdempotent K P = funExt (λ x → orIdempotentStep (K x) (P x))

batch : Cache A → List (Trace A) → Cache A
batch K paths = foldl install K paths

-- The existing generic commuting-fold theorem now says exactly that a batch
-- of persistent path installations has no endpoint order information.
batchOrderIndependent : {ps qs : List (Trace A)}
                      → Perm ps qs
                      → (K : Cache A)
                      → batch K ps ≡ batch K qs
batchOrderIndependent p K =
  foldlPermInvariant install installCommutes p K

-- Rather than smuggling a particular finite-set encoding into the theorem,
-- expose the one law cardinality must satisfy.  This also identifies the
-- reusable object: marginal acquisition cost is an exact potential cocycle.
record CostModel (A : Type ℓ) : Type ℓ where
  field
    potential : Cache A → ℕ
    marginal  : Cache A → Trace A → ℕ
    stepLaw   : (K : Cache A) (P : Trace A)
              → potential K + marginal K P ≡ potential (install K P)

open CostModel

totalCost : CostModel A → Cache A → List (Trace A) → ℕ
totalCost M K []       = zero
totalCost M K (P ∷ ps) =
  marginal M K P + totalCost M (install K P) ps

-- Every sequence cost is endpoint potential minus initial potential, stated
-- without truncated subtraction.  The induction is the exact telescoping
-- calculation.
totalCostTelescopes : (M : CostModel A) (K : Cache A)
                    → (ps : List (Trace A))
                    → potential M K + totalCost M K ps
                    ≡ potential M (batch K ps)
totalCostTelescopes M K [] = +-zero (potential M K)
totalCostTelescopes M K (P ∷ ps) =
  +-assoc (potential M K) (marginal M K P)
          (totalCost M (install K P) ps)
  ∙ cong (_+ totalCost M (install K P) ps) (stepLaw M K P)
  ∙ totalCostTelescopes M (install K P) ps

-- Permuted batches have equal endpoints; exact potential accounting then
-- cancels the common initial potential and forces equal total acquisition
-- cost.  Individual marginal vectors need not agree.
totalCostOrderIndependent : (M : CostModel A) {ps qs : List (Trace A)}
                          → Perm ps qs
                          → (K : Cache A)
                          → totalCost M K ps ≡ totalCost M K qs
totalCostOrderIndependent M {ps} {qs} p K = inj-m+ (
    totalCostTelescopes M K ps
  ∙ cong (potential M) (batchOrderIndependent p K)
  ∙ sym (totalCostTelescopes M K qs))

------------------------------------------------------------------------
-- Concrete finite-inventory instance
--
-- `inventory` is the declared finite node list.  If it has no duplicates,
-- `count inventory K` is ordinary cache cardinality and `newCount` is
-- |P ∖ K|.  The algebra does not need duplicate-freeness: both sides count
-- every occurrence in the same way.
------------------------------------------------------------------------

bit : Bool → ℕ
bit false = zero
bit true  = 1

count : List A → Cache A → ℕ
count []       K = zero
count (x ∷ xs) K = bit (K x) + count xs K

newCount : List A → Cache A → Trace A → ℕ
newCount []       K P = zero
newCount (x ∷ xs) K P =
  bit (not (K x) and P x) + newCount xs K P

bitInstallLaw : (k p : Bool)
              → bit k + bit (not k and p) ≡ bit (k or p)
bitInstallLaw false false = refl
bitInstallLaw false true  = refl
bitInstallLaw true  false = refl
bitInstallLaw true  true  = refl

shuffle+ : (a b c d : ℕ) → (a + b) + (c + d) ≡ (a + c) + (b + d)
shuffle+ a b c d =
  sym (+-assoc a b (c + d))
  ∙ cong (a +_) (+-assoc b c d)
  ∙ cong (λ z → a + (z + d)) (+-comm b c)
  ∙ cong (a +_) (sym (+-assoc c b d))
  ∙ +-assoc a c (b + d)

countInstallLaw : (inventory : List A) (K : Cache A) (P : Trace A)
                → count inventory K + newCount inventory K P
                ≡ count inventory (install K P)
countInstallLaw []       K P = refl
countInstallLaw (x ∷ xs) K P =
  shuffle+ (bit (K x)) (count xs K)
           (bit (not (K x) and P x)) (newCount xs K P)
  ∙ cong₂ _+_ (bitInstallLaw (K x) (P x)) (countInstallLaw xs K P)

finiteInventoryCostModel : List A → CostModel A
finiteInventoryCostModel inventory = record
  { potential = count inventory
  ; marginal  = newCount inventory
  ; stepLaw   = countInstallLaw inventory
  }
