{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- व्यय-लेख — the expense ledger.
--
-- The oracle's verdict on the moving singular orbit (ORACLE_NS_moving_
-- orbit, Theorems 3.1, 3.3, 5.2, 6.1): under parabolic rescaling every
-- integrated dissipation, flux and defect reading carries the weight
-- r⁻¹, so a reading bounded at every dyadic rung costs a summable
-- budget — the orbit is budget-invisible; Leray's own lower bound makes
-- "positive normalised dissipation at every scale" a theorem about
-- every singular solution, so budget exhaustion excludes nothing but an
-- atom; and the one proven emptying of the orbit's fibre is backward
-- uniqueness applied to a limit with a bounded L³ reading.  Three of its
-- finite parts are terms here.
--
--   §1  THE EXPONENT LEDGER (Lemma 0.1).  Degrees under u ↦ r u(rx, r²s):
--       dissipation, flux and defect integrate with weight r⁻¹, |u|³ with
--       r⁻², and the L³ norm at fixed time with weight r⁰ — the only
--       unweighted reading in the package.  By refl.
--
--   §2  THE DYADIC LEDGER (Theorem 3.1).  With W_{n+1} = e_n + 2 W_n the
--       weighted budget of a reading e through n rungs, a reading
--       bounded by M at every rung has W_n + M ≤ M · 2ⁿ: the total is
--       bounded, whatever the reading's positivity.  So "nonzero at every
--       scale ⇒ finite budget exhausted" is refuted by the ledger itself.
--
--   §3  THE WITNESS RECORD (Theorem 5.2, in Sphota's form).  An orbit
--       limit carries the readings Top (vanishing at the final time in
--       L³_loc), Bottom (nontrivial on the unit cylinder) and Exterior
--       (bounded away from the axis).  Backward uniqueness — the
--       classical Escauriaza–Seregin–Šverák mechanism, taken as a
--       hypothesis — sends Top and Exterior to vanishing; Bottom refuses
--       vanishing; the joint fibre is empty.  The one remaining field is
--       (★): the a priori L³ bound that supplies Top.
--
-- व्यय (vyaya, expense) and लेख (lekha, record) are the corpus's own
-- words for cost and ledger.
------------------------------------------------------------------------

module VyayaLekha_TheDyadicLedgerOfABoundedReadingIsBoundedSoNoBudgetExcludesTheMovingOrbitAndOnlyBackwardUniquenessEmptiesItsFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; _^_ ; +-zero ; +-comm ; +-assoc ; ·-distribˡ ; ·-identityʳ ; ·-comm ; ·-assoc)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; ≤-+k ; ≤-·k ; ≤-trans)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc) renaming (_+_ to _+ℤ_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Sphota_TheBlowUpWitnessIsADependentRecordEachInheritedReadingShrinksItsFibreAndTwoIncompatibleReadingsEmptyIt
  using (Witness ; dvi-virodha)

------------------------------------------------------------------------
-- १ · The exponent ledger.
------------------------------------------------------------------------

data Qty : Type₀ where
  velocity gradient stress forcing dissipation flux defect cube pressure³ᐟ² : Qty

-- pointwise degree under u ↦ r u(x₀ + r x, T* + r² s)
deg : Qty → ℤ
deg velocity    = pos 1
deg gradient    = pos 2
deg stress      = pos 2
deg forcing     = pos 3
deg dissipation = pos 4
deg flux        = pos 4
deg defect      = pos 4
deg cube        = pos 3
deg pressure³ᐟ² = pos 3

-- the space–time measure and the space measure
dxdt dx : ℤ
dxdt = negsuc 4      -- r⁻⁵
dx   = negsuc 2      -- r⁻³

-- integrated readings: degree plus the measure's
budget : Qty → ℤ
budget q = deg q +ℤ dxdt

-- dissipation, flux and defect integrate with weight r⁻¹ …
diss-r⁻¹ : budget dissipation ≡ negsuc 0
diss-r⁻¹ = refl

flux-r⁻¹ : budget flux ≡ negsuc 0
flux-r⁻¹ = refl

defect-r⁻¹ : budget defect ≡ negsuc 0
defect-r⁻¹ = refl

-- … |u|³ and |p|^{3/2} with weight r⁻² …
cube-r⁻² : budget cube ≡ negsuc 1
cube-r⁻² = refl

-- … and the L³ norm at fixed time with no weight at all
L³-r⁰ : deg cube +ℤ dx ≡ pos 0
L³-r⁰ = refl

------------------------------------------------------------------------
-- २ · The dyadic ledger: a bounded reading has a bounded budget.
------------------------------------------------------------------------

-- weighted budget through n rungs: W_{n+1} = e_n + 2 W_n
W : (ℕ → ℕ) → ℕ → ℕ
W e zero    = zero
W e (suc n) = e n + 2 · W e n

-- M + M ≡ 2 · M
dvi : (M : ℕ) → M + M ≡ 2 · M
dvi M = cong (M +_) (sym (+-zero M))

-- (M + 2w) + M ≡ 2 · (w + M)
punar : (M w : ℕ) → (M + 2 · w) + M ≡ 2 · (w + M)
punar M w =
    cong (_+ M) (+-comm M (2 · w))
  ∙ sym (+-assoc (2 · w) M M)
  ∙ cong (2 · w +_) (dvi M)
  ∙ ·-distribˡ 2 w M

-- 2 · (a) ≤ 2 · (b) from a ≤ b
dvi-≤ : {a b : ℕ} → a ≤ b → 2 · a ≤ 2 · b
dvi-≤ {a} {b} le = subst2 _≤_ (·-comm a 2) (·-comm b 2) (≤-·k le)

vyaya-sīmā : (e : ℕ → ℕ) (M : ℕ) → ((j : ℕ) → e j ≤ M)
           → (n : ℕ) → W e n + M ≤ M · (2 ^ n)
vyaya-sīmā e M bound zero = subst (M ≤_) (sym (·-identityʳ M)) ≤-refl
vyaya-sīmā e M bound (suc n) =
  ≤-trans step (subst (2 · (W e n + M) ≤_) (·-assoc 2 M (2 ^ n) ∙ cong (_· 2 ^ n) (·-comm 2 M) ∙ sym (·-assoc M 2 (2 ^ n)))
                                            (dvi-≤ (vyaya-sīmā e M bound n)))
  where
  -- (e n + 2 W) + M ≤ (M + 2 W) + M ≡ 2 · (W + M)
  step : (e n + 2 · W e n) + M ≤ 2 · (W e n + M)
  step = subst ((e n + 2 · W e n) + M ≤_) (punar M (W e n)) (≤-+k (≤-+k (bound n)))

------------------------------------------------------------------------
-- ३ · The witness record, and the one remaining field.
------------------------------------------------------------------------

module _ {ℓ ℓ′ : Level}
         (Ancient : Type ℓ)                        -- ancient suitable limits
         (Top Bottom Exterior Vanishes : Ancient → Type ℓ′)
         -- the classical mechanism: backward uniqueness for the limit's vorticity
         (backward-uniqueness : (U : Ancient) → Top U → Exterior U → Vanishes U)
         -- a nontrivial limit does not vanish
         (bottom-refuses : (U : Ancient) → Bottom U → Vanishes U → ⊥)
  where

  -- the orbit limit carrying its three inherited readings
  Ancestry : Ancient → Type ℓ′
  Ancestry U = Top U × Bottom U × Exterior U

  -- the joint fibre is empty: Sphota's two-readings theorem with
  -- A = Top × Exterior and B = Bottom
  orbit-śūnya : Witness Ancestry → ⊥
  orbit-śūnya =
    dvi-virodha Ancestry
      {A = λ U → Top U × Exterior U} {B = Bottom}
      (λ U anc → fst anc , snd (snd anc))
      (λ U anc → fst (snd anc))
      (λ U te b → bottom-refuses U b (backward-uniqueness U (fst te) (snd te)))

  -- (★): the a priori L³ bound, as the type of what supplies Top.  With
  -- it, every orbit limit that is nontrivial and exterior-bounded is
  -- excluded; without it, the fibre over (Bottom , Exterior) stands.
  module _ (BoundedL³ : Ancient → Type ℓ′)
           (★ : (U : Ancient) → BoundedL³ U)
           (bounded→top : (U : Ancient) → BoundedL³ U → Top U) where

    tāraka-śūnya : Witness (λ U → Bottom U × Exterior U) → ⊥
    tāraka-śūnya (U , b , ex) =
      bottom-refuses U b (backward-uniqueness U (bounded→top U (★ U)) ex)
