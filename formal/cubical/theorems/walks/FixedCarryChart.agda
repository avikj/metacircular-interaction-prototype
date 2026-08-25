{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FixedCarryChart
--
-- `CarryChartBridge` proved the one-step residue square for canonical
-- numeral words and then killed its iteration: canonicalization forgets the
-- ambient width.  The missing coordinate already exists in the repository.
-- `DigitTowerFinLimit.W A n = Fin n → A` retains exactly n places, and its
-- `dropMSD` restricts along the top-preserving inclusion Fin n ↪ Fin (suc n).
--
-- This module is the exact adapter between that fixed-width tower and the
-- existing digit/carry chart.  It proves:
--
--   * fixed-width MSD deletion composes strictly;
--   * enumerating a level word as a little-endian raw word intertwines the
--     tower deletion with `Endian.π`;
--   * reducing its b^(n+1) residue coordinate is exactly the b^n coordinate
--     after fixed-width deletion; and
--   * normalization into `CanWord` preserves each stage's residue chart.
--
-- The last statement is deliberately stagewise.  It does not turn
-- normalization into a morphism of towers; `normalizeMSD-not-iterable` is
-- precisely the obstruction to that stronger, false translation.
------------------------------------------------------------------------

module FixedCarryChart where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Nat.Order
open import Cubical.Data.Fin
  using (Fin ; fzero ; fone ; fsuc ; flast ; toℕ ; toℕ-injective)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sigma using (Σ≡Prop ; fst ; _,_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_)

import Digits
import Endian
import CarryObstruction
import CarryChartBridge
import DigitTowerFinLimit
import FinTopSplit

------------------------------------------------------------------------
-- One adjacent pair b^(n+1) → b^n, where n = 1 + n'.
------------------------------------------------------------------------

module FixedBridge (k n' : ℕ) where

  module D = Digits k
  module E = Endian k
  module C = CarryObstruction.BasePower k n'
  module B = CarryChartBridge.Bridge k n'
  module T = DigitTowerFinLimit
  module F = FinTopSplit

  ----------------------------------------------------------------------
  -- The level-retaining carrier and its strict transition.
  ----------------------------------------------------------------------

  LevelWord : ℕ → Type₀
  LevelWord m = T.W D.Digit m

  dropMSD : (m : ℕ) → LevelWord (suc m) → LevelWord m
  dropMSD = T.dropMSD

  dropMSD² : (m : ℕ) → LevelWord (suc (suc m)) → LevelWord m
  dropMSD² m w i = w (F.injectSuc (F.injectSuc i))

  -- Unlike normalized deletion on `CanWord`, adjacent fixed-level maps
  -- compose on the nose.  The width is present in the source and target
  -- types, so no zero place can disappear between the two steps.
  dropMSD-compose : (m : ℕ) (w : LevelWord (suc (suc m)))
                  → dropMSD m (dropMSD (suc m) w) ≡ dropMSD² m w
  dropMSD-compose m w = refl

  ----------------------------------------------------------------------
  -- The existing raw-word chart, enumerated from least to most significant.
  ----------------------------------------------------------------------

  toWord : {m : ℕ} → LevelWord m → D.Word
  toWord {zero}  w = []
  toWord {suc m} w = w fzero ∷ toWord (w ∘ fsuc)

  length-toWord : {m : ℕ} (w : LevelWord m) → length (toWord w) ≡ m
  length-toWord {zero}  w = refl
  length-toWord {suc m} w = cong suc (length-toWord (w ∘ fsuc))

  private
    inject-zero : {m : ℕ}
                → F.injectSuc (fzero {k = m}) ≡ fzero
    inject-zero = toℕ-injective refl

    fsuc-inject : {m : ℕ} (i : Fin m)
                → fsuc (F.injectSuc i) ≡ F.injectSuc (fsuc i)
    fsuc-inject i = toℕ-injective refl

    fsuc-last : (m : ℕ)
              → fsuc (flast {k = m}) ≡ flast {k = suc m}
    fsuc-last m = toℕ-injective refl

    zero-last : fzero {k = 0} ≡ flast {k = 0}
    zero-last = toℕ-injective refl

    tail-drop : {m : ℕ} (w : LevelWord (suc (suc m)))
              → dropMSD m (w ∘ fsuc)
              ≡ (dropMSD (suc m) w) ∘ fsuc
    tail-drop w = funExt λ i → cong w (fsuc-inject i)

  -- Every fixed-width word is its lower restriction followed by the top
  -- digit.  This is the raw-list form of `FinTopSplit.topSplit`.
  toWord-snoc : {m : ℕ} (w : LevelWord (suc m))
              → toWord w ≡ toWord (dropMSD m w) ++ (w flast ∷ [])
  toWord-snoc {zero} w = cong (_∷ []) (cong w zero-last)
  toWord-snoc {suc m} w =
    cong₂ _∷_
      (cong w (sym inject-zero))
      ( toWord-snoc (w ∘ fsuc)
      ∙ cong₂ _++_
          (cong (toWord {m = m}) (tail-drop w))
          (cong (_∷ []) (cong w (fsuc-last m))) )

  -- Consequently the function-indexed tower deletion is exactly the raw
  -- `Endian.π`, without normalization and without a canonicity premise.
  toWord-dropMSD : {m : ℕ} (w : LevelWord (suc m))
                 → E.π (toWord w) ≡ toWord (dropMSD m w)
  toWord-dropMSD {m} w =
      cong E.π (toWord-snoc w)
    ∙ E.π-snoc (toWord (dropMSD m w)) (w flast)

  ----------------------------------------------------------------------
  -- Stagewise projection to the numeral chart.
  ----------------------------------------------------------------------

  levelValue : {m : ℕ} → LevelWord m → ℕ
  levelValue w = D.value (toWord w)

  canonicalize : {m : ℕ} → LevelWord m → D.CanWord
  canonicalize w = D.digitsC (levelValue w)

  canonicalize-value : {m : ℕ} (w : LevelWord m)
                     → D.valueC (canonicalize w) ≡ levelValue w
  canonicalize-value w = D.value-digits (levelValue w)

  -- When the retained top digit is nonzero, the fixed-width raw word is
  -- already canonical.  On this locus the stagewise projection really does
  -- commute with one tower transition.
  canonical-snoc-positive : (xs : D.Word) (y : D.Digit)
                          → 0 < toℕ y
                          → D.Canonical (xs ++ (y ∷ []))
  canonical-snoc-positive []             y positive = positive
  canonical-snoc-positive (x ∷ [])       y positive = positive
  canonical-snoc-positive (x ∷ z ∷ xs)   y positive =
    canonical-snoc-positive (z ∷ xs) y positive

  toWord-canonical : {m : ℕ} (w : LevelWord (suc m))
                   → 0 < toℕ (w flast)
                   → D.Canonical (toWord w)
  toWord-canonical w positive =
    subst D.Canonical (sym (toWord-snoc w))
      (canonical-snoc-positive
        (toWord (dropMSD _ w)) (w flast) positive)

  canonicalize-is-toWord : {m : ℕ} (w : LevelWord (suc m))
                         → (positive : 0 < toℕ (w flast))
                         → canonicalize w ≡
                           (toWord w , toWord-canonical w positive)
  canonicalize-is-toWord w positive =
    Σ≡Prop D.isPropCanonical
      (D.digits-value (toWord w) (toWord-canonical w positive))

  canonicalize-drop-natural : {m : ℕ} (w : LevelWord (suc m))
                            → (positive : 0 < toℕ (w flast))
                            → B.normalizeMSD (canonicalize w)
                            ≡ canonicalize (dropMSD m w)
  canonicalize-drop-natural w positive =
      cong B.normalizeMSD (canonicalize-is-toWord w positive)
    ∙ cong D.digitsC (cong D.value (toWord-dropMSD w))

  ----------------------------------------------------------------------
  -- Sharp naturality locus of the stagewise canonicalization.
  ----------------------------------------------------------------------

  -- Deleting the final digit of a nonempty canonical numeral strictly
  -- lowers its value.  This is the load-bearing fact excluded by the
  -- earlier single counterexample: a canonical word cannot be a nonzero
  -- fixed point of normalized MSD deletion.
  π-value-strict : (d : D.Digit) (w : D.Word)
                 → D.Canonical (d ∷ w)
                 → D.value (E.π (d ∷ w)) < D.value (d ∷ w)
  π-value-strict d [] canonical =
    subst (0 <_)
      (sym
        ( cong (toℕ d +_) (sym (0≡m·0 D.b))
        ∙ +-zero (toℕ d) ))
      canonical
  π-value-strict d (e ∷ w) canonical =
    toℕ d + D.b · D.value (E.π (e ∷ w))
      ≡<⟨ cong (toℕ d +_)
            (·-comm D.b (D.value (E.π (e ∷ w)))) ⟩
    toℕ d + D.value (E.π (e ∷ w)) · D.b
      <≡⟨ <-k+ (<-·sk {k = suc k} (π-value-strict e w canonical)) ⟩
    toℕ d + D.value (e ∷ w) · D.b
      ≡⟨ cong (toℕ d +_) (·-comm (D.value (e ∷ w)) D.b) ⟩
    toℕ d + D.b · D.value (e ∷ w) ∎
    where open <-Reasoning

  normalizeMSD-fixed-zero : (u : D.CanWord)
                          → B.normalizeMSD u ≡ u
                          → D.valueC u ≡ 0
  normalizeMSD-fixed-zero ([] , canonical) fixed = refl
  normalizeMSD-fixed-zero (d ∷ w , canonical) fixed =
    Empty.rec
      (<→≢ (π-value-strict d w canonical)
        ( sym (B.normalizeMSD-value ((d ∷ w) , canonical))
        ∙ cong D.valueC fixed ))

  -- A zero top place contributes nothing to evaluation, even though its
  -- presence remains visible in the fixed-width carrier.
  levelValue-zero-top : {m : ℕ} (w : LevelWord (suc m))
                      → toℕ (w flast) ≡ 0
                      → levelValue w ≡ levelValue (dropMSD m w)
  levelValue-zero-top w top-zero =
      cong D.value (toWord-snoc w)
    ∙ B.value-snoc (toWord (dropMSD _ w)) (w flast)
    ∙ cong (λ z → D.value (toWord (dropMSD _ w))
                  + D.b ^ length (toWord (dropMSD _ w)) · z)
        top-zero
    ∙ cong (D.value (toWord (dropMSD _ w)) +_)
        (sym (0≡m·0 (D.b ^ length (toWord (dropMSD _ w)))))
    ∙ +-zero (D.value (toWord (dropMSD _ w)))

  -- On the zero-top stratum, the square commutes at exactly one semantic
  -- point: the lower word must evaluate to zero.  It may still contain
  -- fixed-width leading zeroes; the theorem concerns the represented value,
  -- not literal list equality.
  zero-top-lower-zero→natural : {m : ℕ} (w : LevelWord (suc m))
                              → toℕ (w flast) ≡ 0
                              → levelValue (dropMSD m w) ≡ 0
                              → B.normalizeMSD (canonicalize w)
                                ≡ canonicalize (dropMSD m w)
  zero-top-lower-zero→natural w top-zero lower-zero =
      cong B.normalizeMSD
        (cong D.digitsC (levelValue-zero-top w top-zero ∙ lower-zero))
    ∙ cong D.digitsC (sym lower-zero)

  zero-top-natural→lower-zero : {m : ℕ} (w : LevelWord (suc m))
                              → toℕ (w flast) ≡ 0
                              → B.normalizeMSD (canonicalize w)
                                ≡ canonicalize (dropMSD m w)
                              → levelValue (dropMSD m w) ≡ 0
  zero-top-natural→lower-zero w top-zero natural =
      sym (canonicalize-value (dropMSD _ w))
    ∙ normalizeMSD-fixed-zero (canonicalize (dropMSD _ w))
        ( cong B.normalizeMSD
            (sym (cong D.digitsC (levelValue-zero-top w top-zero)))
        ∙ natural )

  NaturalityLocus : {m : ℕ} → LevelWord (suc m) → Type₀
  NaturalityLocus {m} w =
    (0 < toℕ (w flast)) ⊎ (levelValue (dropMSD m w) ≡ 0)

  locus→canonicalize-drop-natural : {m : ℕ} (w : LevelWord (suc m))
                                   → NaturalityLocus w
                                   → B.normalizeMSD (canonicalize w)
                                     ≡ canonicalize (dropMSD m w)
  locus→canonicalize-drop-natural w (inl positive) =
    canonicalize-drop-natural w positive
  locus→canonicalize-drop-natural {m} w (inr lower-zero)
    with ≤-split (zero-≤ {toℕ (w flast)})
  ... | inl positive = canonicalize-drop-natural w positive
  ... | inr zero≡top =
    zero-top-lower-zero→natural w (sym zero≡top) lower-zero

  canonicalize-drop-natural→locus : {m : ℕ} (w : LevelWord (suc m))
                                   → B.normalizeMSD (canonicalize w)
                                     ≡ canonicalize (dropMSD m w)
                                   → NaturalityLocus w
  canonicalize-drop-natural→locus {m} w natural
    with ≤-split (zero-≤ {toℕ (w flast)})
  ... | inl positive = inl positive
  ... | inr zero≡top =
    inr (zero-top-natural→lower-zero w (sym zero≡top) natural)

  chartN : LevelWord C.n → Fin C.N
  chartN w =
    (levelValue w mod C.N) , mod< (C.bp C.n) (levelValue w)

  chartM : LevelWord (suc C.n) → Fin C.M
  chartM w =
    (levelValue w mod C.M) , mod< C.M' (levelValue w)

  -- Normalization forgets width but not the coordinate at a fixed stage.
  chartN-canonicalizes : (w : LevelWord C.n)
                       → chartN w ≡ B.chartN (canonicalize w)
  chartN-canonicalizes w = Σ≡Prop (λ _ → isProp≤)
    (sym (cong (_mod C.N) (canonicalize-value w)))

  chartM-canonicalizes : (w : LevelWord (suc C.n))
                       → chartM w ≡ B.chartM (canonicalize w)
  chartM-canonicalizes w = Σ≡Prop (λ _ → isProp≤)
    (sym (cong (_mod C.M) (canonicalize-value w)))

  ----------------------------------------------------------------------
  -- The exact fixed-level carry square.
  ----------------------------------------------------------------------

  levelValue-mod : (w : LevelWord (suc C.n))
                 → levelValue w mod C.N
                 ≡ levelValue (dropMSD C.n w) mod C.N
  levelValue-mod w =
      cong (λ z → D.value z mod C.N) (toWord-snoc w)
    ∙ B.value-snoc-mod
        (toWord (dropMSD C.n w))
        (w flast)
        (length-toWord (dropMSD C.n w))

  -- Width is now carried by the type.  The former explicit length premise
  -- disappears, and the square composes because `dropMSD-compose` does.
  red-chart-drops : (w : LevelWord (suc C.n))
                  → C.red (chartM w) ≡ chartN (dropMSD C.n w)
  red-chart-drops w = Σ≡Prop (λ _ → isProp≤)
    (C.mod-mod (levelValue w) ∙ levelValue-mod w)

------------------------------------------------------------------------
-- Definitional guards at the binary 3 → 2 digit transition.
------------------------------------------------------------------------

private
  module F₂ = FixedBridge 0 1

  w101 : F₂.LevelWord 3
  w101 (0 , _) = fone
  w101 (1 , _) = fzero
  w101 (suc (suc _) , _) = fone

  _ : F₂.toWord w101 ≡ fone ∷ fzero ∷ fone ∷ []
  _ = refl

  _ : F₂.toWord (F₂.dropMSD 2 w101) ≡ fone ∷ fzero ∷ []
  _ = refl

  _ : F₂.dropMSD 1 (F₂.dropMSD 2 w101) ≡ F₂.dropMSD² 1 w101
  _ = F₂.dropMSD-compose 1 w101

------------------------------------------------------------------------
-- The nonzero-top premise is real: a zero top place is erased before the
-- canonical-word transition sees it.  Binary [1,0,0] is the least displayed
-- witness at the same 3 → 2 level used above.
------------------------------------------------------------------------

module BinaryNaturalityCounterexample where

  module FB = FixedBridge 0 1

  w000 : FB.LevelWord 3
  w000 _ = fzero

  zero-top-all-zero-natural :
      FB.B.normalizeMSD (FB.canonicalize w000)
      ≡ FB.canonicalize (FB.dropMSD 2 w000)
  zero-top-all-zero-natural =
    FB.locus→canonicalize-drop-natural w000 (inr refl)

  w100 : FB.LevelWord 3
  w100 (0 , _) = fone
  w100 (1 , _) = fzero
  w100 (suc (suc _) , _) = fzero

  w100-outside-locus : ¬ FB.NaturalityLocus w100
  w100-outside-locus (inl positive) = ¬-<-zero positive
  w100-outside-locus (inr lower-zero) = snotz lower-zero

  normalized-high-value-zero :
      FB.D.valueC (FB.B.normalizeMSD (FB.canonicalize w100)) ≡ 0
  normalized-high-value-zero = refl

  canonical-lower-value-one :
      FB.D.valueC (FB.canonicalize (FB.dropMSD 2 w100)) ≡ 1
  canonical-lower-value-one = refl

  canonicalize-not-a-tower-map :
    ¬ ((w : FB.LevelWord 3)
      → FB.B.normalizeMSD (FB.canonicalize w)
      ≡ FB.canonicalize (FB.dropMSD 2 w))
  canonicalize-not-a-tower-map natural =
    w100-outside-locus
      (FB.canonicalize-drop-natural→locus w100 (natural w100))
