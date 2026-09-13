{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- गुरु-सीमा — the summand-wise statement `Lagakriya_…` §८ left.
--
-- That module says, exactly: "What is therefore still not proved is the
-- summand-wise statement — that `Chosen n k` is empty for k > n — which
-- is true, is what would let the infinite `Σ[ k ∈ ℕ ]` be replaced by a
-- finite one over `Fin (suc n)`, and is not needed for anything above.
-- Someone who wants the row read term by term rather than in total has
-- to prove it."
--
-- Proved here, from `PingalaPrastara`'s own `varna` and `guruOf`:
--
--   गुरु≤वर्ण  : every pattern has at most as many guru as syllables;
--   रिक्तम्     : Chosen n k is empty when n < k;
--   परिमितः    : Σ[ k ∈ ℕ ] Chosen n k ≃ Σ[ k ∈ Fin (suc n) ] Chosen n (toℕ k),
--
-- so the row can be read term by term over the finite index.
------------------------------------------------------------------------
module GuruSima_TheGuruCountNeverExceedsTheSyllableCountSoChosenIsEmptyAboveTheDiagonalAndTheRowIsAFiniteSum where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; ≤-suc ; isProp≤ ; <-asym)
open import Cubical.Data.Fin using (Fin ; toℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ≡Prop ; ΣPathP)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import PingalaPrastara using (Syllable ; laghu ; guru ; Pattern ; varna ; guruOf ; Chosen)

-- १ · at most as many guru as syllables
गुरु≤वर्ण : (p : Pattern) → guruOf p ≤ varna p
गुरु≤वर्ण []          = zero-≤
गुरु≤वर्ण (laghu ∷ p) = ≤-suc (गुरु≤वर्ण p)
गुरु≤वर्ण (guru ∷ p)  = suc-≤-suc (गुरु≤वर्ण p)

-- २ · so Chosen is empty above the diagonal
रिक्तम् : (n k : ℕ) → n < k → ¬ Chosen n k
रिक्तम् n k n<k (p , vp , gp) =
  <-asym n<k (subst2 _≤_ gp vp (गुरु≤वर्ण p))

-- ३ · and the row is a finite sum
private
  bound : (n : ℕ) (c : Σ[ k ∈ ℕ ] Chosen n k) → fst c < suc n
  bound n (k , p , vp , gp) = suc-≤-suc (subst2 _≤_ gp vp (गुरु≤वर्ण p))

परिमितः : (n : ℕ) → (Σ[ k ∈ ℕ ] Chosen n k) ≃ (Σ[ k ∈ Fin (suc n) ] Chosen n (toℕ k))
परिमितः n = isoToEquiv (iso to from sec (λ _ → refl))
  where
  to : Σ[ k ∈ ℕ ] Chosen n k → Σ[ k ∈ Fin (suc n) ] Chosen n (toℕ k)
  to c = (fst c , bound n c) , snd c

  from : Σ[ k ∈ Fin (suc n) ] Chosen n (toℕ k) → Σ[ k ∈ ℕ ] Chosen n k
  from (k , c) = toℕ k , c

  sec : (c : Σ[ k ∈ Fin (suc n) ] Chosen n (toℕ k)) → to (from c) ≡ c
  sec ((k , h) , c) = ΣPathP (Σ≡Prop (λ _ → isProp≤) refl , refl)
