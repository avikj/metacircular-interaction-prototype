-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.CarryChartBridge
--
-- The exact adapter between the two already-checked sides of the base-b
-- chart:
--
--   Digits / Endian                 CarryObstruction.BasePower
--   ---------------------------     -------------------------------
--   little-endian words             Fin (b^(n+1))
--   delete the most-significant     reduce modulo b^n
--   digit, then normalize
--
-- There is a real typing obstruction before the square can commute.
-- Endian.`π` acts on raw words, but it does NOT preserve `Canonical`:
-- deleting the last digit may expose a zero as the new leading digit.
-- `rawπ-does-not-restrict` is the three-digit counterexample.  Therefore
-- the correct operation on `CanWord` is
--
--     normalizeMSD = digitsC ∘ value ∘ π.
--
-- For a word whose lower part has exactly n digits, `red-chart-truncates`
-- proves that reducing its b^(n+1)-chart coordinate is exactly the b^n-chart
-- coordinate of `normalizeMSD`.  The equality is propositional, not `refl`:
-- the successor presentations `N` and `M` in CarryObstruction are identified
-- with b^n and b^(n+1) by the checked paths `N≡` and `M≡b`.
--
-- No H² claim is added here.  This module only makes the already-proved
-- nonsplitting obstruction operational inside the existing digit chart.
------------------------------------------------------------------------

module NaturalMachine.CarryChartBridge where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Nat.Order
open import Cubical.Data.Fin using (Fin ; fzero ; fone ; toℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.Sigma using (Σ≡Prop ; fst ; _,_)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.Digits
import NaturalMachine.Endian
import NaturalMachine.CarryObstruction

------------------------------------------------------------------------
-- One adjacent pair of levels b^(n+1) → b^n, with n = 1 + n'.
------------------------------------------------------------------------

module Bridge (k n' : ℕ) where

  module D = NaturalMachine.Digits k
  module E = NaturalMachine.Endian k
  module C = NaturalMachine.CarryObstruction.BasePower k n'

  ----------------------------------------------------------------------
  -- The naïve translation is ill-typed: raw MSD deletion is not closed
  -- on canonical words.
  ----------------------------------------------------------------------

  rawπ-counterexample : D.CanWord
  rawπ-counterexample =
    (fone ∷ fzero ∷ fone ∷ []) , suc-≤-suc zero-≤

  rawπ-counterexample-fails : ¬ D.Canonical (E.π (fst rawπ-counterexample))
  rawπ-counterexample-fails = ¬-<-zero

  rawπ-does-not-restrict :
    ¬ ((w : D.CanWord) → D.Canonical (E.π (fst w)))
  rawπ-does-not-restrict closes =
    rawπ-counterexample-fails (closes rawπ-counterexample)

  -- Normalization is not optional bookkeeping: it is the operation that
  -- returns raw truncation to the canonical-word chart.
  normalizeMSD : D.CanWord → D.CanWord
  normalizeMSD (w , _) = D.digitsC (D.value (E.π w))

  normalizeMSD-value : (w : D.CanWord)
                     → D.valueC (normalizeMSD w) ≡ D.value (E.π (fst w))
  normalizeMSD-value (w , _) = D.value-digits (D.value (E.π w))

  ----------------------------------------------------------------------
  -- A second obstruction: normalization cannot simply be iterated to model
  -- fixed-width tower truncation.  On [1,0,1], the first normalized drop
  -- contracts [1,0] all the way to [1].  A second actual-MSD drop therefore
  -- deletes the remaining 1, whereas two raw place drops leave [1].
  --
  -- The next tower adapter must retain the level/width as state; CanWord
  -- alone has forgotten which zero place was removed by normalization.
  ----------------------------------------------------------------------

  normalizeTwoRawMSDs : D.CanWord → D.CanWord
  normalizeTwoRawMSDs (w , _) =
    D.digitsC (D.value (E.π (E.π w)))

  rawπ-counterexample-value-one :
      D.value (E.π (fst rawπ-counterexample)) ≡ 1
  rawπ-counterexample-value-one = E.value-v1

  normalizeMSD-once :
      normalizeMSD rawπ-counterexample ≡ D.digitsC 1
  normalizeMSD-once = cong D.digitsC rawπ-counterexample-value-one

  normalizeMSD²-value-zero :
      D.valueC (normalizeMSD (normalizeMSD rawπ-counterexample)) ≡ 0
  normalizeMSD²-value-zero =
      normalizeMSD-value (normalizeMSD rawπ-counterexample)
    ∙ cong (λ z → D.value (E.π (fst z))) normalizeMSD-once

  normalizeTwoRawMSDs-value-one :
      D.valueC (normalizeTwoRawMSDs rawπ-counterexample) ≡ 1
  normalizeTwoRawMSDs-value-one =
      D.value-digits (D.value (E.π (E.π (fst rawπ-counterexample))))
    ∙ E.value-u1

  normalizeMSD-not-iterable :
    ¬ ((w : D.CanWord) →
      normalizeMSD (normalizeMSD w) ≡ normalizeTwoRawMSDs w)
  normalizeMSD-not-iterable iterates =
    znots
      ( sym normalizeMSD²-value-zero
      ∙ cong D.valueC (iterates rawπ-counterexample)
      ∙ normalizeTwoRawMSDs-value-one )

  ----------------------------------------------------------------------
  -- Residue coordinates of a canonical word at the two adjacent levels.
  -- These are total: values outside the displayed digit width are reduced.
  ----------------------------------------------------------------------

  chartN : D.CanWord → Fin C.N
  chartN (w , _) =
    (D.value w mod C.N) , mod< (C.bp C.n) (D.value w)

  chartM : D.CanWord → Fin C.M
  chartM (w , _) =
    (D.value w mod C.M) , mod< C.M' (D.value w)

  ----------------------------------------------------------------------
  -- Positional arithmetic: appending one most-significant digit adds its
  -- value at place b^(length xs).
  ----------------------------------------------------------------------

  value-snoc : (xs : D.Word) (y : D.Digit)
             → D.value (xs ++ (y ∷ []))
             ≡ D.value xs + D.b ^ length xs · toℕ y
  value-snoc [] y =
      cong (λ z → toℕ y + z) (sym (0≡m·0 D.b))
    ∙ +-zero (toℕ y)
    ∙ sym (·-identityˡ (toℕ y))
  value-snoc (d ∷ xs) y =
    ( cong (λ z → toℕ d + D.b · z) (value-snoc xs y)
    ∙ cong (λ z → toℕ d + z)
        (sym (·-distribˡ D.b (D.value xs) (D.b ^ length xs · toℕ y))) )
    ∙
    ( cong (λ z → toℕ d + (D.b · D.value xs + z))
        (·-assoc D.b (D.b ^ length xs) (toℕ y))
    ∙ +-assoc (toℕ d) (D.b · D.value xs)
        ((D.b · D.b ^ length xs) · toℕ y) )

  -- At exactly n lower digits, the removed place is a multiple of C.N.
  high-place-vanishes : (xs : D.Word) (y : D.Digit)
                      → length xs ≡ C.n
                      → (D.b ^ length xs · toℕ y) mod C.N ≡ 0
  high-place-vanishes xs y len =
      cong (_mod C.N)
        ( cong (_· toℕ y) (cong (D.b ^_) len ∙ sym C.N≡)
        ∙ ·-comm C.N (toℕ y) )
    ∙ zero-charac-gen C.N (toℕ y)

  -- Hence a literal word-snoc and its lower word have the same residue.
  value-snoc-mod : (xs : D.Word) (y : D.Digit)
                 → length xs ≡ C.n
                 → D.value (xs ++ (y ∷ [])) mod C.N
                 ≡ D.value xs mod C.N
  value-snoc-mod xs y len =
      cong (_mod C.N) (value-snoc xs y)
    ∙ mod-rCancel C.N (D.value xs) (D.b ^ length xs · toℕ y)
    ∙ cong (λ z → (D.value xs + z) mod C.N)
        (high-place-vanishes xs y len)
    ∙ cong (_mod C.N) (+-zero (D.value xs))

  -- On an explicit snoc, normalization produces the canonical numeral for
  -- the lower word.  No canonicity premise on `xs` is needed: normalization
  -- removes any newly exposed leading zeros.
  normalizeMSD-snoc :
      (xs : D.Word) (y : D.Digit)
      (canonical : D.Canonical (xs ++ (y ∷ [])))
    → normalizeMSD ((xs ++ (y ∷ [])) , canonical)
    ≡ D.digitsC (D.value xs)
  normalizeMSD-snoc xs y canonical =
    cong D.digitsC (cong D.value (E.π-snoc xs y))

  ----------------------------------------------------------------------
  -- The commuting square.  This is the exact operational adapter requested
  -- by ATLAS_OF_N: word-level MSD truncation is modular reduction, after the
  -- normalization which CanWord's invariant forces.
  ----------------------------------------------------------------------

  red-chart-truncates :
      (xs : D.Word) (y : D.Digit)
      (canonical : D.Canonical (xs ++ (y ∷ [])))
      (width : length xs ≡ C.n)
    → C.red (chartM ((xs ++ (y ∷ [])) , canonical))
    ≡ chartN (normalizeMSD ((xs ++ (y ∷ [])) , canonical))
  red-chart-truncates xs y canonical width =
    Σ≡Prop (λ _ → isProp≤)
      ( C.mod-mod (D.value (xs ++ (y ∷ [])))
      ∙ value-snoc-mod xs y width
      ∙ cong (λ w → D.value w mod C.N) (sym (E.π-snoc xs y))
      ∙ sym (cong (_mod C.N)
          (D.value-digits (D.value (E.π (xs ++ (y ∷ [])))))) )

------------------------------------------------------------------------
-- Definitional guards for the smallest nontrivial square:
-- binary three-bit words reduce from Fin 8 to Fin 4.
------------------------------------------------------------------------

private
  module BinaryLevel2 = Bridge 0 1

  _ : BinaryLevel2.C.N ≡ 4
  _ = refl

  _ : BinaryLevel2.C.M ≡ 8
  _ = refl
