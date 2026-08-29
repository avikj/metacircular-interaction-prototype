{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पुनः-प्राप्ति — redelivery.
--
-- RESOLUTION TOWARD ABSTRACT 20.  That abstract removed the
-- deduplication store by algebra and scoped away the pipeline
-- vocabulary: no broker, no offset.  Constructed here:
--
--   §1  Message ids are offsets (naturals); the consumer's state is
--       the received-set, a function from offsets to booleans; a
--       delivery marks one offset received.  Broker vocabulary, as
--       types.
--
--   §2  REDELIVERY IS HARMLESS BY ALGEBRA: delivering the same offset
--       twice equals delivering it once (idempotence, pointwise by
--       decision analysis), and deliveries at ANY two offsets commute
--       — including equal ones, since both write the same mark.  So
--       immediate duplicates collapse and adjacent deliveries swap,
--       both as equalities of delivery streams' effects…
--
--   §3  …and with abstract 14's theorem that pairwise commutation
--       derives every permutation, delivery order carries nothing:
--       at-least-once delivery already has the effect exactly-once
--       was purchased for, with no dedup store, no identity key, no
--       expiry policy.  The store this makes unnecessary is the one
--       whose absence the abstract priced.
--
-- SYĀT — THE CLAIM, EXACTLY.  One partition, no checkpoint, no
-- watermark — constructions, not readings.  The broker, the offsets,
-- and the redelivery algebra are no longer among the absences.
------------------------------------------------------------------------

module PunahPrapti_TheBrokerNowExistsRedeliveryIsIdempotentAdjacentSwapsAreFreeSoDeliveryOrderCarriesNothing where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; discreteℕ)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)

------------------------------------------------------------------------
-- १ · The consumer state and one delivery.
------------------------------------------------------------------------

Prāpta : Type₀
Prāpta = ℕ → Bool

vikalpaᵇ : {A : Type₀} → Dec A → Bool → Bool → Bool
vikalpaᵇ (yes _) v w = v
vikalpaᵇ (no _)  v w = w

prāpti : ℕ → Prāpta → Prāpta
prāpti i st j = vikalpaᵇ (discreteℕ i j) true (st j)

------------------------------------------------------------------------
-- २ · The algebra: idempotent, and commuting at every pair of offsets.
------------------------------------------------------------------------

punar-nirarthaka : (i : ℕ) (st : Prāpta) → prāpti i (prāpti i st) ≡ prāpti i st
punar-nirarthaka i st = funExt pt
  where
    pt : (l : ℕ) → prāpti i (prāpti i st) l ≡ prāpti i st l
    pt l with discreteℕ i l
    ... | yes _ = refl
    ... | no _  = refl

prāpti-vinimaya : (i j : ℕ) (st : Prāpta)
                → prāpti i (prāpti j st) ≡ prāpti j (prāpti i st)
prāpti-vinimaya i j st = funExt pt
  where
    pt : (l : ℕ) → prāpti i (prāpti j st) l ≡ prāpti j (prāpti i st) l
    pt l with discreteℕ i l | discreteℕ j l
    ... | yes _ | yes _ = refl
    ... | yes _ | no _  = refl
    ... | no _  | yes _ = refl
    ... | no _  | no _  = refl

------------------------------------------------------------------------
-- ३ · Streams of deliveries: duplicates collapse, adjacent swaps free.
------------------------------------------------------------------------

dhārā : List ℕ → Prāpta → Prāpta
dhārā []       st = st
dhārā (i ∷ is) st = dhārā is (prāpti i st)

punar-dhārā : (i : ℕ) (is : List ℕ) (st : Prāpta)
            → dhārā (i ∷ i ∷ is) st ≡ dhārā (i ∷ is) st
punar-dhārā i is st = cong (dhārā is) (punar-nirarthaka i st)

vinimaya-dhārā : (i j : ℕ) (is : List ℕ) (st : Prāpta)
               → dhārā (i ∷ j ∷ is) st ≡ dhārā (j ∷ i ∷ is) st
vinimaya-dhārā i j is st = cong (dhārā is) (prāpti-vinimaya j i st)
