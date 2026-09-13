{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सीमा-शेष — the boundary residual.
--
-- On the whole line a shift and its inverse cancel: U_a⁻¹ = U_{−a}.  On a
-- finite window [0, t) the truncated shift S_a and its adjoint S_a* do
-- not: S_a* S_a is the indicator of [0, t − a) and S_a S_a* the indicator
-- of [a, t), so
--
--     S_a* S_a − S_a S_a*  =  M_{[0,a)} − M_{[t−a,t)}.
--
-- Both words have net displacement zero.  Their finite-window actions
-- differ by two boundary strips of width a.  Endpoint displacement
-- descends; boundary interaction history does not.  This is the shift
-- algebra's instance of SankramanaShreni's localization, and it is the
-- mechanism by which the finite prime-translation operator keeps
-- injecting fresh boundary-scale words as the window grows.
--
--   §1  THE TRUNCATED SHIFT AND ITS ADJOINT on functions of ℕ.
--   §2  THE TWO COMPOSITES, pointwise: S* S f x is f x when x + a < t,
--       and S S* f x is f x when a ≤ x < t — otherwise zero.
--   §3  BULK AND STRIPS.  In the bulk (a ≤ x, x + a < t) the composites
--       agree; on the left strip x < a the first keeps f and the second
--       kills it; on the right strip t − a ≤ x the reverse.
--   §4  LOCALIZATION.  The two words are meaning-equal under net
--       displacement (both zero in ℤ) and cost-apart under the window
--       action on the constant one at the origin (one against zero), so
--       by SankramanaShreni no function of the displacement recovers the
--       window action.
--
-- सीमा (sīmā, boundary) and शेष (śeṣa, residual) are ordinary Sanskrit.
------------------------------------------------------------------------

module SimaSesa_OnAFiniteWindowTheTwoNetZeroShiftWordsAgreeInTheBulkAndDifferOnTheBoundaryStripsSoDisplacementDescendsAndBoundaryHistoryDoesNot where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _∸_ ; +∸ ; snotz)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤Dec ; <Dec ; ≤-∸-+-cancel ; ≤SumRight ; ≤SumLeft ; ≤<-trans)
open import Cubical.Data.Int using (ℤ ; pos ; isSetℤ ; +Comm) renaming (_+_ to _+ℤ_ ; -_ to -ℤ_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import SankramanaShreni_TheLocalizationSequenceAsOneObjectMeaningDescendsAndCostDoesNot
  using (module Localization)

------------------------------------------------------------------------
-- १ · The truncated shift and its adjoint on the window [0, t).
------------------------------------------------------------------------

module _ (t a : ℕ) where

  -- right shift by a: f moved to the right, zero fills the left
  S : (ℕ → ℕ) → ℕ → ℕ
  S f x with ≤Dec a x
  ... | yes _ = f (x ∸ a)
  ... | no  _ = zero

  -- its adjoint: f moved to the left, truncated at the window's end
  S* : (ℕ → ℕ) → ℕ → ℕ
  S* f x with <Dec (x + a) t
  ... | yes _ = f (x + a)
  ... | no  _ = zero

  --------------------------------------------------------------------
  -- २ · The two composites, pointwise.
  --------------------------------------------------------------------

  -- S* S keeps f exactly where x + a < t
  S*S : (f : ℕ → ℕ) (x : ℕ) → x + a < t → S* (S f) x ≡ f x
  S*S f x lt with <Dec (x + a) t
  ... | no  ¬lt = ⊥-elim (¬lt lt)
  ... | yes _   with ≤Dec a (x + a)
  ...   | no  ¬le = ⊥-elim (¬le ≤SumRight)
  ...   | yes _   = cong f (+∸ x a)

  S*S-śūnya : (f : ℕ → ℕ) (x : ℕ) → ¬ (x + a < t) → S* (S f) x ≡ zero
  S*S-śūnya f x ¬lt with <Dec (x + a) t
  ... | no  _  = refl
  ... | yes lt = ⊥-elim (¬lt lt)

  -- S S* keeps f exactly where a ≤ x and x < t
  SS* : (f : ℕ → ℕ) (x : ℕ) → a ≤ x → x < t → S (S* f) x ≡ f x
  SS* f x le lt with ≤Dec a x
  ... | no  ¬le = ⊥-elim (¬le le)
  ... | yes _   with <Dec ((x ∸ a) + a) t
  ...   | no  ¬lt = ⊥-elim (¬lt (subst (_< t) (sym (≤-∸-+-cancel le)) lt))
  ...   | yes _   = cong f (≤-∸-+-cancel le)

  SS*-śūnya : (f : ℕ → ℕ) (x : ℕ) → ¬ (a ≤ x) → S (S* f) x ≡ zero
  SS*-śūnya f x ¬le with ≤Dec a x
  ... | no  _  = refl
  ... | yes le = ⊥-elim (¬le le)

  --------------------------------------------------------------------
  -- ३ · Bulk and strips.
  --------------------------------------------------------------------

  -- in the bulk the two net-zero words act identically
  madhya-sama : (f : ℕ → ℕ) (x : ℕ) → a ≤ x → x + a < t
              → S* (S f) x ≡ S (S* f) x
  madhya-sama f x le lt =
    S*S f x lt ∙ sym (SS* f x le (≤<-trans ≤SumLeft lt))

  -- on the left strip the first word keeps f and the second kills it
  vāma-sīmā : (f : ℕ → ℕ) (x : ℕ) → ¬ (a ≤ x) → x + a < t
            → (S* (S f) x ≡ f x) × (S (S* f) x ≡ zero)
  vāma-sīmā f x ¬le lt = S*S f x lt , SS*-śūnya f x ¬le

  -- on the right strip the first word kills f and the second keeps it
  dakṣiṇa-sīmā : (f : ℕ → ℕ) (x : ℕ) → a ≤ x → x < t → ¬ (x + a < t)
               → (S* (S f) x ≡ zero) × (S (S* f) x ≡ f x)
  dakṣiṇa-sīmā f x le lt ¬lt = S*S-śūnya f x ¬lt , SS* f x le lt

------------------------------------------------------------------------
-- ४ · Localization: displacement descends, boundary history does not.
------------------------------------------------------------------------

-- the two net-zero words
data Krama : Type₀ where
  pūrva : Krama   -- S* after S : displacement (+a) then (−a)
  para  : Krama   -- S after S* : displacement (−a) then (+a)

-- meaning: net displacement, in ℤ
gati : ℕ → Krama → ℤ
gati a pūrva = (-ℤ pos a) +ℤ pos a
gati a para  = pos a +ℤ (-ℤ pos a)

-- both words displace by zero
gati-sama : (a : ℕ) → gati a pūrva ≡ gati a para
gati-sama a = +Comm (-ℤ pos a) (pos a)

-- cost: the word's window action on the constant one, read at the origin,
-- on the window t = 2 with shift a = 1
eka : ℕ → ℕ
eka _ = suc zero

mūlya : Krama → ℕ
mūlya pūrva = S* 2 1 (S 2 1 eka) zero
mūlya para  = S 2 1 (S* 2 1 eka) zero

mūlya-apart : ¬ (mūlya pūrva ≡ mūlya para)
mūlya-apart p = snotz p

open Localization {X = Krama} {Y = ℤ} isSetℤ (gati 1) mūlya

-- no function of the net displacement recovers the window action
sīmā-na-avatarati : ¬ (Σ[ c ∈ (Ĝ → ℕ) ] ((w : Krama) → c (L w) ≡ mūlya w))
sīmā-na-avatarati = costDoesNotDescend pūrva para (gati-sama 1) mūlya-apart
