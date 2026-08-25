{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भित्ति-द्वयम् — two more walls, and the frontier shrinks honestly.
--
-- After सेतु-प्रमाणम् the big component holds 20 banks.  The next-largest
-- candidate merges into it are Unit's component (6 banks) and Fin 840's
-- (5 banks).  Both are impossible for the reason भित्तिः retired ℕ ≃ Bool:
-- a finite type is not the naturals.
--
--   भित्ति-एक  : ¬ (ℕ ≃ Unit)       — 6×20 = 120 candidate crossings retired
--   भित्ति-फिन : ∀ n → ¬ (ℕ ≃ Fin n) — 5×20 = 100 retired at n = 840, and
--                                      every future Fin-bank merge with it
--
-- Unit: injectivity of the equivalence sends isPropUnit's collision back
-- to 0 ≡ 1 in ℕ.  Fin: restrict the equivalence to the inclusion
-- Fin (suc n) ↪ ℕ and land in Fin n; the library's `pigeonhole` (suc n
-- into n) hands two distinct points with equal image, and injectivity of
-- the composite refutes them.  Nothing invented; the pigeonhole is
-- cubical v0.5's own (`Cubical.Data.Fin.Properties`).
--
-- With these, every finite-hub component's merge into the ℕ-component is
-- retired, and what remains on the candidate list is genuinely open.
-- भित्ति-द्वय is built here, 2026-08-23.
------------------------------------------------------------------------

module BhittiDvaya_TwoMoreWallsTheFiniteBanksCannotMergeWithTheNaturals where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; retEq)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
open import Cubical.Data.Nat.Order using (_<_ ; ≤-refl ; isProp≤)
open import Cubical.Data.Unit using (Unit ; isPropUnit)
open import Cubical.Data.Fin using (Fin ; fzero ; toℕ)
open import Cubical.Data.Fin.Properties using (pigeonhole)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd ; Σ≡Prop ; _×_)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- injectivity of an equivalence (as in भित्तिः, restated locally)
------------------------------------------------------------------------

अभेद : {A B : Type} (e : A ≃ B) {x y : A} → equivFun e x ≡ equivFun e y → x ≡ y
अभेद e {x} {y} p = sym (retEq e x) ∙ cong (invEq e) p ∙ retEq e y

------------------------------------------------------------------------
-- १ · भित्ति-एक — ℕ is not Unit.
------------------------------------------------------------------------

भित्ति-एक : (ℕ ≃ Unit) → ⊥
भित्ति-एक e =
  znots (अभेद e {zero} {suc zero}
          (isPropUnit (equivFun e zero) (equivFun e (suc zero))))

------------------------------------------------------------------------
-- २ · भित्ति-फिन — ℕ is not Fin n, for any n.
--
-- The composite  Fin (suc n) --toℕ--> ℕ --e--> Fin n  is injective
-- (toℕ is injective by Σ≡Prop on the order proof; e by अभेद), and the
-- library pigeonhole for suc n > n produces i ≢ j with equal images.
------------------------------------------------------------------------

भित्ति-फिन : (n : ℕ) → (ℕ ≃ Fin n) → ⊥
भित्ति-फिन n e = i≢j (toℕ-inj (अभेद e p))
  where
    g : Fin (suc n) → Fin n
    g k = equivFun e (toℕ k)

    ph : Σ (Fin (suc n)) (λ i → Σ (Fin (suc n)) (λ j → (¬ (i ≡ j)) × (g i ≡ g j)))
    ph = pigeonhole ≤-refl g

    i   = fst ph
    j   = fst (snd ph)
    i≢j = fst (snd (snd ph))
    p   = snd (snd (snd ph))

    toℕ-inj : {a b : Fin (suc n)} → toℕ a ≡ toℕ b → a ≡ b
    toℕ-inj q = Σ≡Prop (λ _ → isProp≤) q
