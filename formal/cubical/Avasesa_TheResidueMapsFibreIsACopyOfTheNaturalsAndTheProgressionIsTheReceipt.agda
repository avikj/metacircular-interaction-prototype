-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अवशेष — शेषस्य तन्तुः श्रेढी एव ।
--
-- (the remainder's fibre is nothing but the progression.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS EXISTS: A CLASS, NOT AN INSTANCE.
--
-- `machine/Lopa_…hs` grades 1062 one-way edges in this corpus, and their
-- mass is concentrated: **237 have source ℕ**, and their maps are
-- overwhelmingly decision procedures and arithmetic level sets —
-- `eqb`, `chkPos`, `gtAll`, `res4`, `rangeB`, `hull`, `kron`.
--
-- The finite-source edges are enumerable, and a case-table emitter
-- sweeps them.  **An ℕ-source edge is not enumerable and no table will
-- ever reach it.**  It has to be priced by an identification.
--
-- And a residue map has one, exactly: **the fibre of `_mod k` over `r`
-- is a copy of ℕ**, and the identification is the arithmetic
-- progression `q ↦ r + k·q`.  Not a bound, not a count — a bijection
-- with a standard type, which is what सूत्र ८ demands of a receipt.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED.
--
-- §१  `श्रेढी k r : ℕ → ℕ`, the progression, and that it lands in the
--     fibre: `(r + k·q) mod k ≡ r` whenever `r < k`.
-- §२  **`अवशेष-तन्तुः : fiber (_mod (suc k)) r ≃ ℕ`** for `r < suc k`.
--     Both round trips.  The receipt for every residue edge in the
--     corpus, in one term.
-- §३  the degenerate reading: at `r ≥ k` the fibre is EMPTY (रिक्तम्),
--     because `mod<` bounds every value.  So the three सङ्ख्या are all
--     present in one family — रिक्तम् above the modulus, and बहु (a full
--     copy of ℕ) below it, with एकम् occurring nowhere.
--
-- **NOT CLAIMED:** that every ℕ-source edge is a residue map.  This
-- prices the residue class and says nothing about `hull`, `kron`, or a
-- general comparison predicate — those need their own identifications
-- and most of them may have none.  The queue's 237 are not hereby
-- priced; a class of them is.
--
-- ────────────────────────────────────────────────────────────────────
-- TERM.  शेष / अवशेष — remainder.  Āryabhaṭa, आर्यभटीयम् गणितपादः ३२–३३
-- (499 CE), the kuṭṭaka: **शेषं रक्ष** — *keep the remainder* — and
-- recurse on it.  The instruction that the discarded part is the object.
-- LIMIT: Āryabhaṭa states a procedure for solving linear congruences and
-- proves nothing below; no source states a fibre, a type, or an
-- equivalence.  What is claimed is that the set his procedure's
-- remainder ranges over IS the fibre of the residue map, which is a fact
-- about `Cubical.Data.Nat.Mod`'s definitions.  The European name for the
-- procedure is the "extended Euclidean algorithm", a restatement, named
-- after the source and as one.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Avasesa_TheResidueMapsFibreIsACopyOfTheNaturalsAndTheProgressionIsTheReceipt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Empty using (⊥)

------------------------------------------------------------------------
-- १ · श्रेढी — the progression, and that it lands in the fibre.
------------------------------------------------------------------------

श्रेढी : (k r : ℕ) → ℕ → ℕ
श्रेढी k r q = r + k · q

module _ (k r : ℕ) (r<k : r < suc k) where

  private
    K : ℕ
    K = suc k

  -- (r + K·q) mod K ≡ r.  The multiple dies by zero-charac-gen; what is
  -- left is r, which is already reduced because r < K.
  श्रेढी-अवशेषः : (q : ℕ) → (r + K · q) mod K ≡ r
  श्रेढी-अवशेषः q =
      cong (λ z → (r + z) mod K) (·-comm K q)
    ∙ mod-rCancel K r (q · K)
    ∙ cong (λ z → (r + z) mod K) (zero-charac-gen K q)
    ∙ cong (_mod K) (+-zero r)
    ∙ modIndBase k r r<k

------------------------------------------------------------------------
-- २ · अवशेष-तन्तुः — the receipt.
--
-- `fiber (_mod K) r ≃ ℕ`.  Forward: take the quotient.  Backward: run
-- the progression.  The two round trips are `≡remainder+quotient` and
-- cancellation of `K ·_`, and the fibre's proof component is carried for
-- free because ℕ is a set.
------------------------------------------------------------------------

  अवशेष-तन्तुः : fiber (_mod K) r ≃ ℕ
  अवशेष-तन्तुः = isoToEquiv (iso भागः श्रेढी-तन्तौ पुनरागमनम् प्रत्यागमनम्)
    where
    भागः : fiber (_mod K) r → ℕ
    भागः (m , _) = quotient m / K

    श्रेढी-तन्तौ : ℕ → fiber (_mod K) r
    श्रेढी-तन्तौ q = (r + K · q) , श्रेढी-अवशेषः q

    -- m ≡ r + K·(m/K), because the remainder IS r by the fibre's own witness
    विभागः : (m : ℕ) → m mod K ≡ r → r + K · (quotient m / K) ≡ m
    विभागः m p = cong (_+ K · (quotient m / K)) (sym p) ∙ ≡remainder+quotient K m

    पुनरागमनम् : (q : ℕ) → भागः (श्रेढी-तन्तौ q) ≡ q
    पुनरागमनम् q =
      inj-sm· {k} {quotient (r + K · q) / K} {q}
        (inj-m+ {r} (विभागः (r + K · q) (श्रेढी-अवशेषः q)))

    प्रत्यागमनम् : (x : fiber (_mod K) r) → श्रेढी-तन्तौ (भागः x) ≡ x
    प्रत्यागमनम् (m , p) =
      Σ≡Prop (λ _ → isSetℕ _ _) (विभागः m p)

------------------------------------------------------------------------
-- ३ · शेषः — the three counts in one family.
--
-- Above the modulus the fibre is EMPTY: `mod<` bounds every value by K,
-- so nothing maps to an r ≥ K.  Below it the fibre is a full copy of ℕ.
-- **एकम् occurs nowhere in this family** — a residue map is never
-- injective at any residue, and never partially so.  रिक्तम् and बहु,
-- with nothing between.
------------------------------------------------------------------------

  रिक्त-अवशेषः : (s : ℕ) → suc k ≤ s → fiber (_mod (suc k)) s → ⊥
  रिक्त-अवशेषः s k≤s (m , p) =
    ¬m<m (≤<-trans k≤s (subst (_< suc k) p (mod< k m)))
