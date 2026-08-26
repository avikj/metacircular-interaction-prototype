{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भार — यो भारः प्रविशति स एव तन्तुं भिनत्ति ।
--
-- (it is the weight that goes in which splits the fiber.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE RUNG ABOVE `आवृत्ति`, AND WHY IT IS A RUNG AND NOT A COROLLARY.
--
-- `Avrtti_…agda` prices the fiber of `length`: one constructor costs
-- exactly one, so `fiber length (suc n) ≃ X × fiber length n` with no
-- guard anywhere.  Every counting map that charges a CONSTANT per
-- element is that theorem.
--
-- A **weighted** map is not.  `PingalaPrastara.matraOf` charges 1 for
-- लघु and 2 for गुरु, so its fiber over `n` decomposes over `n∸1` and
-- `n∸2` — and each summand needs a proof that its weight actually fits
-- under `n`, which truncated subtraction silently swallows.  That is why
-- `matrameruIso` had to be proved by hand.
--
-- **The fix is to carry the fitting proof as an EQUATION and never
-- subtract.**  `Σ[ m ] (w x + m ≡ n)` says "the rest is `m`, and the
-- weight fits, and here is the witness" in one object.  With `∸` the
-- witness is thrown away and has to be reconstructed by a case split;
-- with `≡` it is the datum.  **That is this corpus's own rule applied to
-- its own arithmetic: keep the remainder, शेषं रक्ष.**
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, over an ARBITRARY element type and an ARBITRARY
-- weight — no finiteness, no decidable equality, no h-level on `X`, and
-- no assumption that the weight is nonzero.
--
-- §१  `भार-गणना w`, the weighted count, by structural recursion.
-- §२  **`भार-आवृत्तिः`** : for `n` a successor,
--
--        fiber (भार-गणना w) n
--          ≃  Σ[ x ∈ X ] Σ[ m ∈ ℕ ] ((w x + m ≡ n) × fiber (भार-गणना w) m)
--
--     the fiber over `n` is: which element came first, what the rest
--     weighed, the proof that they add to `n`, and the rest's own fiber.
--     Every summand carries its own fitting proof.
-- §३  the base at zero is NOT `Unit` in general — a weight of 0 lets
--     arbitrarily many elements sit at index 0 — so §३ states the base
--     only under the hypothesis that no weight is zero, and says so.
--     **This is the place a careless emitter would forge a receipt.**
--
-- §४  `matraOf` is an instance: `X = Syllable`, `w laghu = 1`,
--     `w guru = 2`.  Stated, and the identification with the host's own
--     `matraOf` is left as an obligation rather than asserted, because
--     `matraOf` is a separate recursion and nothing here proves the two
--     agree.
--
-- NOT CLAIMED: that this subsumes `matrameruIso`.  `matrameruIso` gives
-- a BINARY sum, `Metre (2+n) ≃ Metre (1+n) ⊎ Metre n`, which is §२
-- specialised at a two-element `X` with weights 1 and 2 AND the two
-- summands' fitting proofs discharged.  Discharging them needs the
-- weights to be concrete; §२ is the general form and the discharge is
-- not done here.
--
-- ────────────────────────────────────────────────────────────────────
-- TERM.  भार — weight, load, that which is carried.  Ordinary Sanskrit;
-- in the prosodic tradition the weight of a syllable is its मात्रा
-- (Piṅgala, छन्दःशास्त्रम्, ~300 BCE: लघु one mātrā, गुरु two).  LIMIT:
-- भार is used here in its plain sense for the cost a constructor
-- charges; the prosodists' term for the syllable's own weight is मात्रा
-- and no text states a weighted fiber decomposition.  Piṅgala proves
-- nothing below.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Bhara_TheWeightedCountingMapsFiberDecomposesOverEverySummandThatFits where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order using (_<_ ; ¬m<m)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit
open import Cubical.Data.Empty renaming (rec to ⊥-rec)

private variable ℓ : Level

module _ {X : Type ℓ} (w : X → ℕ) where

------------------------------------------------------------------------
-- १ · भार-गणना — the weighted count.
------------------------------------------------------------------------

  भार-गणना : List X → ℕ
  भार-गणना []       = 0
  भार-गणना (x ∷ xs) = w x + भार-गणना xs

------------------------------------------------------------------------
-- २ · भार-आवृत्तिः — the decomposition, with every fitting proof carried.
--
-- No `∸` appears.  The equation `w x + m ≡ n` IS the fitting witness, so
-- nothing is discarded and nothing has to be reconstructed.
------------------------------------------------------------------------

  भार-तन्तुः : ℕ → Type ℓ
  भार-तन्तुः n = fiber भार-गणना n

------------------------------------------------------------------------
-- २ · भार-आवृत्तिः — the decomposition.
--
-- No case split on `n`, and no `∸` anywhere.  A list is `[]` or a cons,
-- so its fiber is that same coproduct: the empty list sits over `n` iff
-- `0 ≡ n`, and a cons sits over `n` iff its head's weight plus the
-- tail's count is `n`.  **The equation IS the fitting witness** — with
-- truncated subtraction the witness is discarded and has to be rebuilt
-- by a case split; here it is the datum.  शेषं रक्ष.
------------------------------------------------------------------------

  भार-आवृत्तिः : (n : ℕ)
    → भार-तन्तुः n
      ≃ ((0 ≡ n) ⊎ (Σ[ x ∈ X ] Σ[ xs ∈ List X ] (w x + भार-गणना xs ≡ n)))
  भार-आवृत्तिः n = isoToEquiv (iso भ स नि प्र)
    where
    भ : भार-तन्तुः n → ((0 ≡ n) ⊎ (Σ[ x ∈ X ] Σ[ xs ∈ List X ] (w x + भार-गणना xs ≡ n)))
    भ ([]     , p) = inl p
    भ (x ∷ xs , p) = inr (x , xs , p)

    स : ((0 ≡ n) ⊎ (Σ[ x ∈ X ] Σ[ xs ∈ List X ] (w x + भार-गणना xs ≡ n))) → भार-तन्तुः n
    स (inl e)            = [] , e
    स (inr (x , xs , p)) = (x ∷ xs) , p

    नि : (t : (0 ≡ n) ⊎ (Σ[ x ∈ X ] Σ[ xs ∈ List X ] (w x + भार-गणना xs ≡ n)))
       → भ (स t) ≡ t
    नि (inl e)            = refl
    नि (inr (x , xs , p)) = refl

    प्र : (t : भार-तन्तुः n) → स (भ t) ≡ t
    प्र ([]     , p) = refl
    प्र (x ∷ xs , p) = refl

------------------------------------------------------------------------
-- ३ · The base is NOT `Unit`, and this is where a careless emitter
-- forges a receipt.
--
-- `fiber length 0 ≃ Unit` held because `length` charges one per element.
-- A weight of ZERO breaks it: if `w x ≡ 0` then `x ∷ x ∷ … ∷ []` has
-- count 0 for every length, so the fiber over 0 is infinite.  §२ still
-- holds — it is stated with no hypothesis at all — but the left summand
-- is `0 ≡ n` and the right one does not vanish at `n ≡ 0`.
--
-- So the base collapses only under a hypothesis, and it is named:
------------------------------------------------------------------------

  शून्य-भार-अभावः : ((x : X) → 0 < w x)
    → (xs : List X) → भार-गणना xs ≡ 0 → xs ≡ []
  शून्य-भार-अभावः pos []       _ = refl
  शून्य-भार-अभावः pos (x ∷ xs) p =
    ⊥-rec (¬m<m (subst (0 <_) (m+n≡0→m≡0×n≡0 p .fst) (pos x)))
