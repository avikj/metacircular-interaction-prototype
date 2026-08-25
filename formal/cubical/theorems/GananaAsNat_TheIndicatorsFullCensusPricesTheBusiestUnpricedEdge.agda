{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गणना-asNat — the indicator's full census, pricing the busiest unpriced
-- edge the organism itself asked for.
--
-- PROVENANCE OF THE TASK: ./jiva, first boot in this container
-- (2026-08-23), sector ३ "five unpriced directed edges to price first" —
-- all five are Bool ⟶ ℕ at price-score 856, among them
-- `NaturalMachine.FiniteOccupancyChannelNoGo.asNat` (false↦0, true↦1).
-- One receipt prices the shape all five share: the indicator.
--
-- THE RECEIPT, an identification per point of the codomain (never a
-- bound), in SakalaVikalaDesa's three-verdict vocabulary:
--
--   fibre over 0        : contractible  — सकलादेश  (exactly false)
--   fibre over 1        : contractible  — सकलादेश  (exactly true)
--   fibre over suc(suc n): empty        — अवक्तव्यम् (nothing lost: ℕ merely
--                                         has names Bool cannot utter)
--
-- So asNat is INJECTIVE but not an equivalence, and its entire defect is
-- अवक्तव्य — the empty kind, धनात्मकम्, no information destroyed.  The map
-- was never lossy; it is merely partial on names.  By प्रतिबिम्ब-सङ्घातः
-- this is the best case for routing: on its image the edge is invertible,
-- so every composite THROUGH asNat prices as the other factor alone.
--
-- गणना-asNat is built here, 2026-08-23.  Elementary; no source claimed.
------------------------------------------------------------------------

module GananaAsNat_TheIndicatorsFullCensusPricesTheBusiestUnpricedEdge where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv)
open isEquiv
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; snotz ; injSuc)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; isSetBool ; true≢false ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)
open import NaturalMachine.FiniteOccupancyChannelNoGo using (asNat)

-- asNat is IMPORTED from its home, not redefined: the first push of this
-- file redefined it locally and ./jiva correctly counted a NEW unpriced
-- edge (heartbeat 1270→1271) instead of a discharge — the receipt must
-- attach to the original declaration.  The organism audited its own
-- pricing pass in one diff.

शेष : ℕ → Type
शेष n = Σ[ b ∈ Bool ] (asNat b ≡ n)

------------------------------------------------------------------------
-- १ · over zero: exactly false.
------------------------------------------------------------------------

शून्य-सकल : isContr (शेष 0)
fst शून्य-सकल = false , refl
snd शून्य-सकल (false , p) i = false , isSetℕ 0 0 refl p i
  where open import Cubical.Data.Nat using (isSetℕ)
snd शून्य-सकल (true  , p) = ⊥-rec (snotz p)

------------------------------------------------------------------------
-- २ · over one: exactly true.
------------------------------------------------------------------------

एक-सकल : isContr (शेष 1)
fst एक-सकल = true , refl
snd एक-सकल (true  , p) i = true , isSetℕ 1 1 refl p i
  where open import Cubical.Data.Nat using (isSetℕ)
snd एक-सकल (false , p) = ⊥-rec (znots p)

------------------------------------------------------------------------
-- ३ · above one: empty.  अवक्तव्यम् — the names Bool cannot utter.
------------------------------------------------------------------------

ऊर्ध्व-रिक्त : (n : ℕ) → ¬ शेष (suc (suc n))
ऊर्ध्व-रिक्त n (false , p) = snotz (sym p)
ऊर्ध्व-रिक्त n (true  , p) = snotz (injSuc (sym p))

------------------------------------------------------------------------
-- ४ · the consequences the router reads off the census.
------------------------------------------------------------------------

-- injective: the collision of any two booleans under asNat is refuted or
-- resolved by the censuses above — direct proof by cases.
अभेद-asNat : (a b : Bool) → asNat a ≡ asNat b → a ≡ b
अभेद-asNat false false _ = refl
अभेद-asNat true  true  _ = refl
अभेद-asNat false true  p = ⊥-rec (znots p)
अभेद-asNat true  false p = ⊥-rec (snotz p)

-- not an equivalence: the point 2 has an empty fibre.
न-समता : ¬ (isEquiv asNat)
न-समता e = ऊर्ध्व-रिक्त 0 (fst (e .equiv-proof 2))
