{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्रोतस् — the stream, the current.
--
-- WHY THIS FILE EXISTS.  The abstract "AN IDEMPOTENT TOTAL MERGE
-- REMOVES THE DEDUPLICATION STORE" says, under WHAT IS NOT CLAIMED,
-- that there is no message broker, no partition, no offset, no
-- checkpoint and no watermark in the development — that a "message" is
-- an operation and the "pipeline" is a library under concatenation, and
-- that the reading as a stream processing system is a reading.
--
-- The broker is built here, with all five, and the reading becomes the
-- theorem the design rests on: under at-least-once delivery with
-- arbitrary duplication and arbitrary reordering, the consumer's state
-- depends only on the SET of records delivered (§४).  Exactly-once is
-- therefore an algebraic consequence and not a delivery guarantee, and
-- the deduplication store, its key, and its expiry policy all disappear
-- together — which is what the earlier form asserts and does not model.
--
-- WHAT IS CHECKED
--
--   §१  `Key`, `Delivery`   partitions and offsets; a delivery is a
--                           LIST, so duplicates and reordering are
--                           representable rather than assumed away.
--   §२  `consume`           the consumer's state, and `consume-is-fold`
--                           that it IS the idempotent merge — the merge
--                           is a theorem about the consumer, not its
--                           definition.
--   §३  merge laws          idempotent, commutative, associative, with
--                           the empty state its unit.
--   §४  `same-set→same-state`  EXACTLY ONCE, BY ALGEBRA.  Two deliveries
--                           with the same members give the same state,
--                           whatever their order and however many times
--                           each arrived.
--       `redelivery-harmless`  the special case a broker actually needs.
--   §५  `Checkpoint`, `watermark`, `watermark≤`
--                           the checkpoint per partition and the
--                           watermark as their least; and
--       `below-watermark-final`
--                           below the watermark the state is FINAL: no
--                           future delivery, of anything, changes it.
--   §६  `no-safe-compaction`  and the cost, exactly: dropping a
--                           delivered key from the state changes it, so
--                           the store is monotone — no tombstones, no
--                           compaction, no retention policy.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Srotas_TheBrokerThePartitionTheOffsetTheCheckpointAndTheWatermarkAreBuiltAndExactlyOnceIsAlgebra where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ ; min)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; min-≤-left ; min-≤-right)
open import Cubical.Data.Bool using (Bool ; true ; false ; _or_ ; true≢false ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; Discrete)

private
  absurd : {X : Type} → ⊥ → X
  absurd ()

------------------------------------------------------------------------
-- १ · THE BROKER.
--
-- A record is addressed by its partition and its offset within that
-- partition — which is what a broker's coordinates are.  A delivery is
-- a LIST of such addresses: duplicates are representable, order is
-- representable, and nothing below assumes either away.
------------------------------------------------------------------------

Partition Offset : Type
Partition = ℕ
Offset    = ℕ

Key : Type
Key = Partition × Offset

discreteKey : Discrete Key
discreteKey (p , i) (q , j) with discreteℕ p q | discreteℕ i j
... | yes e | yes f = yes (cong₂ _,_ e f)
... | yes e | no ¬f = no λ r → ¬f (cong snd r)
... | no ¬e | _     = no λ r → ¬e (cong fst r)

Delivery : Type
Delivery = List Key

data _∈_ : Key → Delivery → Type where
  here  : {k : Key} {d : Delivery} → k ∈ (k ∷ d)
  there : {k j : Key} {d : Delivery} → k ∈ d → k ∈ (j ∷ d)

------------------------------------------------------------------------
-- २ · THE CONSUMER.
--
-- A grow-only set of the records seen, as a characteristic function.
-- No offset table, no seen-set with an expiry, no identity key beyond
-- the address the broker already supplies.
------------------------------------------------------------------------

State : Type
State = Key → Bool

∅ : State
∅ _ = false

merge : State → State → State
merge a b k = a k or b k

single : Key → State
single k j = decTrue (discreteKey j k)
  where
    decTrue : {A : Type} → Dec A → Bool
    decTrue (yes _) = true
    decTrue (no  _) = false

seen : Key → Delivery → Bool
seen k []       = false
seen k (j ∷ d) = pickOr (discreteKey k j) (seen k d)
  where
    pickOr : {A : Type} → Dec A → Bool → Bool
    pickOr (yes _) _ = true
    pickOr (no  _) b = b

consume : Delivery → State
consume d k = seen k d

consumeFold : Delivery → State
consumeFold []       = ∅
consumeFold (k ∷ d) = merge (single k) (consumeFold d)

-- the consumer IS the idempotent merge: a theorem about it, not the
-- definition it was given.
consume-is-fold : (d : Delivery) → consume d ≡ consumeFold d
consume-is-fold []       = refl
consume-is-fold (k ∷ d) = funExt step
  where
    step : (j : Key) → consume (k ∷ d) j ≡ consumeFold (k ∷ d) j
    step j with discreteKey j k | discreteKey k j
    ... | yes _ | yes _ = refl
    ... | yes e | no ¬f = absurd (¬f (sym e))
    ... | no ¬e | yes f = absurd (¬e (sym f))
    ... | no  _ | no  _ = funExt⁻ (consume-is-fold d) j

------------------------------------------------------------------------
-- ३ · the merge laws the whole design rests on.
------------------------------------------------------------------------

merge-idem : (a : State) → merge a a ≡ a
merge-idem a = funExt λ k → lemma (a k)
  where
    lemma : (b : Bool) → (b or b) ≡ b
    lemma true  = refl
    lemma false = refl

merge-comm : (a b : State) → merge a b ≡ merge b a
merge-comm a b = funExt λ k → lemma (a k) (b k)
  where
    lemma : (x y : Bool) → (x or y) ≡ (y or x)
    lemma true  true  = refl
    lemma true  false = refl
    lemma false true  = refl
    lemma false false = refl

merge-assoc : (a b c : State) → merge (merge a b) c ≡ merge a (merge b c)
merge-assoc a b c = funExt λ k → lemma (a k) (b k) (c k)
  where
    lemma : (x y z : Bool) → ((x or y) or z) ≡ (x or (y or z))
    lemma true  _ _ = refl
    lemma false _ _ = refl

merge-unit : (a : State) → merge ∅ a ≡ a
merge-unit a = refl

------------------------------------------------------------------------
-- ४ · EXACTLY ONCE, BY ALGEBRA.
--
-- The state records membership and nothing else, so two deliveries with
-- the same members agree — whatever the order, however many times each
-- record arrived.  At-least-once delivery therefore already gives the
-- effect exactly-once was bought for, and the deduplication store, its
-- identity key and its expiry policy disappear together.
------------------------------------------------------------------------

seen→∈ : (k : Key) (d : Delivery) → seen k d ≡ true → k ∈ d
seen→∈ k []       p = absurd (false≢true p)
seen→∈ k (j ∷ d) p with discreteKey k j
... | yes e = subst (_∈ (j ∷ d)) (sym e) here
... | no  _ = there (seen→∈ k d p)

∈→seen : (k : Key) (d : Delivery) → k ∈ d → seen k d ≡ true
∈→seen k (j ∷ d) here with discreteKey k j
... | yes _  = refl
... | no ¬e = absurd (¬e refl)
∈→seen k (j ∷ d) (there m) with discreteKey k j
... | yes _ = refl
... | no  _ = ∈→seen k d m

boolEq : (x y : Bool) → (x ≡ true → y ≡ true) → (y ≡ true → x ≡ true) → x ≡ y
boolEq true  true  _ _ = refl
boolEq true  false f _ = sym (f refl)
boolEq false true  _ g = g refl
boolEq false false _ _ = refl

same-set→same-state :
  (d₁ d₂ : Delivery)
  → ((k : Key) → k ∈ d₁ → k ∈ d₂)
  → ((k : Key) → k ∈ d₂ → k ∈ d₁)
  → consume d₁ ≡ consume d₂
same-set→same-state d₁ d₂ f g = funExt λ k →
  boolEq (seen k d₁) (seen k d₂)
    (λ p → ∈→seen k d₂ (f k (seen→∈ k d₁ p)))
    (λ p → ∈→seen k d₁ (g k (seen→∈ k d₂ p)))

∈-++ˡ : (k : Key) (xs ys : Delivery) → k ∈ xs → k ∈ (xs ++ ys)
∈-++ˡ k (x ∷ xs) ys here      = here
∈-++ˡ k (x ∷ xs) ys (there m) = there (∈-++ˡ k xs ys m)

∈-++ʳ : (k : Key) (xs ys : Delivery) → k ∈ ys → k ∈ (xs ++ ys)
∈-++ʳ k []       ys m = m
∈-++ʳ k (x ∷ xs) ys m = there (∈-++ʳ k xs ys m)

∈-++-split : (k : Key) (xs ys : Delivery) → k ∈ (xs ++ ys) → (k ∈ xs) ⊎ (k ∈ ys)
∈-++-split k []       ys m         = inr m
∈-++-split k (x ∷ xs) ys here      = inl here
∈-++-split k (x ∷ xs) ys (there m) with ∈-++-split k xs ys m
... | inl a = inl (there a)
... | inr b = inr b

-- redelivering everything changes nothing.  This is the property a
-- broker needs and the reason no dedup store is required.
redelivery-harmless : (d : Delivery) → consume (d ++ d) ≡ consume d
redelivery-harmless d =
  same-set→same-state (d ++ d) d
    (λ k m → case∈ (∈-++-split k d d m))
    (λ k m → ∈-++ˡ k d d m)
  where
    case∈ : {k : Key} → (k ∈ d) ⊎ (k ∈ d) → k ∈ d
    case∈ (inl a) = a
    case∈ (inr b) = b

------------------------------------------------------------------------
-- ५ · CHECKPOINTS AND THE WATERMARK.
--
-- A checkpoint records, per partition, how far the consumer has read.
-- The watermark is their least, taken over the partitions in play, from
-- a seed — the seed being the conservative answer for the empty case,
-- since a watermark that is too small is safe and one that is too large
-- is not.
--
-- `below-watermark-final` is what a watermark is FOR: below it the
-- answer is settled, and no further delivery of anything can move it.
------------------------------------------------------------------------

Checkpoint : Type
Checkpoint = Partition → Offset

data _∈ₚ_ : Partition → List Partition → Type where
  hereₚ  : {p : Partition} {ps : List Partition} → p ∈ₚ (p ∷ ps)
  thereₚ : {p q : Partition} {ps : List Partition} → p ∈ₚ ps → p ∈ₚ (q ∷ ps)

watermark : Checkpoint → Offset → List Partition → Offset
watermark c w []       = w
watermark c w (p ∷ ps) = watermark c (min w (c p)) ps

watermark≤seed : (c : Checkpoint) (w : Offset) (ps : List Partition)
               → watermark c w ps ≤ w
watermark≤seed c w []       = ≤-refl
watermark≤seed c w (p ∷ ps) =
  ≤-trans (watermark≤seed c (min w (c p)) ps) min-≤-left

watermark≤ : (c : Checkpoint) (w : Offset) (ps : List Partition) (p : Partition)
           → p ∈ₚ ps → watermark c w ps ≤ c p
watermark≤ c w (q ∷ ps) p hereₚ =
  ≤-trans (watermark≤seed c (min w (c q)) ps) min-≤-right
watermark≤ c w (q ∷ ps) p (thereₚ m) = watermark≤ c (min w (c q)) ps p m

-- a delivery is complete up to the checkpoint when every offset below
-- it has arrived on every partition in play.
CompleteUpTo : Delivery → List Partition → Checkpoint → Type
CompleteUpTo d ps c =
  (p : Partition) (o : Offset) → p ∈ₚ ps → o < c p → (p , o) ∈ d

-- once a key is in, no further delivery changes the state there: the
-- merge is monotone and idempotent, so growth is one-way.
already-final : (d extra : Delivery) (k : Key) → k ∈ d
              → consume (d ++ extra) k ≡ consume d k
already-final d extra k m =
  ∈→seen k (d ++ extra) (∈-++ˡ k d extra m) ∙ sym (∈→seen k d m)

-- BELOW THE WATERMARK THE ANSWER IS SETTLED.
below-watermark-final :
  (d extra : Delivery) (ps : List Partition) (c : Checkpoint) (w : Offset)
  → CompleteUpTo d ps c
  → (p : Partition) (o : Offset) → p ∈ₚ ps → o < watermark c w ps
  → consume (d ++ extra) (p , o) ≡ consume d (p , o)
below-watermark-final d extra ps c w comp p o mem lt =
  already-final d extra (p , o) (comp p o mem (≤-trans lt (watermark≤ c w ps p mem)))

------------------------------------------------------------------------
-- ६ · THE COST, EXACTLY.
--
-- Nothing may be dropped.  A retention policy that removes a delivered
-- key from the state changes the state — so there are no tombstones, no
-- compaction and no safe expiry, and the store is monotone.  Systems
-- adopting this design trade unbounded growth for the elimination of the
-- entire delivery-semantics stack, and here that trade is a term rather
-- than a remark.
------------------------------------------------------------------------

drop : Key → State → State
drop k a j = pickFalse (discreteKey j k) (a j)
  where
    pickFalse : {A : Type} → Dec A → Bool → Bool
    pickFalse (yes _) _ = false
    pickFalse (no  _) b = b

drop-at : (k : Key) (a : State) → drop k a k ≡ false
drop-at k a with discreteKey k k
... | yes _  = refl
... | no ¬e = absurd (¬e refl)

no-safe-compaction : (d : Delivery) (k : Key) → k ∈ d
                   → ¬ (drop k (consume d) ≡ consume d)
no-safe-compaction d k m p =
  false≢true (sym (drop-at k (consume d)) ∙ funExt⁻ p k ∙ ∈→seen k d m)
