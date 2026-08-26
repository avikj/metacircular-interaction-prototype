{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- A raw little-endian digit word is uniquely a canonical numeral followed
-- by a finite run of zero digits at its most-significant end.
--
-- This is a statement about the fibers of the positional chart `value`.
-- It does not compute their automorphism groups, preserve concatenation, or
-- identify the finite-word presentation with a digit tower.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module RawWordPaddingNormalForm (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Equiv
  using (_≃_ ; propBiimpl→Equiv)
open import Cubical.Foundations.Isomorphism
  using (iso ; isoToEquiv)
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Fin
  using (fzero ; fone ; toℕ ; toℕ-injective)
open import Cubical.Data.List
  using (List ; [] ; _∷_ ; rev)
open import Cubical.Data.Sigma
  using (_×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)

import Digits

module D = Digits k

------------------------------------------------------------------------
-- 1. Splitting and joining
------------------------------------------------------------------------

zeroRun : ℕ → D.Word
zeroRun zero    = []
zeroRun (suc n) = fzero ∷ zeroRun n

-- `padHigh w n` appends n zero places at the high, right-hand end of the
-- little-endian word.  Recursing through w makes that orientation explicit.
padHigh : D.Word → ℕ → D.Word
padHigh []      n = zeroRun n
padHigh (d ∷ w) n = d ∷ padHigh w n

nonzero→positive : (n : ℕ) → ¬ (n ≡ 0) → 0 < n
nonzero→positive zero    n≢0 = Empty.rec (n≢0 refl)
nonzero→positive (suc n) n≢0 = suc-≤-suc zero-≤

-- Inspect the tail first.  If it has no canonical core, the current digit
-- either extends the high-zero run or becomes the unique leading digit.
extendSplit : D.Digit → D.CanWord × ℕ → D.CanWord × ℕ
extendSplit d (([] , canonical) , n) with discreteℕ (toℕ d) 0
... | yes d≡0 = ([] , tt) , suc n
... | no d≢0  = (d ∷ [] , nonzero→positive (toℕ d) d≢0) , n
extendSplit d (((e ∷ es) , canonical) , n) =
  (d ∷ e ∷ es , canonical) , n

split : D.Word → D.CanWord × ℕ
split [] = ([] , tt) , 0
split (d ∷ w) = extendSplit d (split w)

join : D.CanWord × ℕ → D.Word
join ((w , canonical) , n) = padHigh w n

split-zeroRun : (n : ℕ) → split (zeroRun n) ≡ (([] , tt) , n)
split-zeroRun zero = refl
split-zeroRun (suc n) = cong (extendSplit fzero) (split-zeroRun n)

extend-empty-positive :
    (d : D.Digit) (positive : 0 < toℕ d) (n : ℕ)
  → extendSplit d (([] , tt) , n) ≡ ((d ∷ [] , positive) , n)
extend-empty-positive d positive n with discreteℕ (toℕ d) 0
... | yes d≡0 =
      Empty.rec (¬-<-zero (subst (0 <_) d≡0 positive))
... | no d≢0 =
      cong (λ core → core , n)
        (Σ≡Prop D.isPropCanonical refl)

join-extendSplit : (d : D.Digit) (normal : D.CanWord × ℕ)
                 → join (extendSplit d normal) ≡ d ∷ join normal
join-extendSplit d (([] , canonical) , n) with discreteℕ (toℕ d) 0
... | yes d≡0 = cong (λ e → e ∷ zeroRun n) (sym (toℕ-injective d≡0))
... | no d≢0 = refl
join-extendSplit d (((e ∷ es) , canonical) , n) = refl

-- Joining a split raw word recovers every digit, including every high zero.
join-split : (w : D.Word) → join (split w) ≡ w
join-split [] = refl
join-split (d ∷ w) =
    join-extendSplit d (split w)
  ∙ cong (d ∷_) (join-split w)

-- Splitting a padded canonical word recovers both the core and the exact
-- number of high zero places.  Canonicity is proposition-valued, so the
-- proof component contributes no spurious coordinate.
split-padHigh :
    (w : D.Word) (canonical : D.Canonical w) (n : ℕ)
  → split (padHigh w n) ≡ ((w , canonical) , n)
split-padHigh [] canonical n =
  split-zeroRun n
  ∙ cong (λ core → core , n)
      (Σ≡Prop D.isPropCanonical refl)
split-padHigh (d ∷ []) canonical n =
      cong (extendSplit d) (split-zeroRun n)
    ∙ extend-empty-positive d canonical n
split-padHigh (d ∷ e ∷ es) canonical n
  = cong (extendSplit d) (split-padHigh (e ∷ es) canonical n)

split-join : (normal : D.CanWord × ℕ) → split (join normal) ≡ normal
split-join ((w , canonical) , n) = split-padHigh w canonical n

rawWord≃canonical×padding : D.Word ≃ (D.CanWord × ℕ)
rawWord≃canonical×padding =
  isoToEquiv (iso split join split-join join-split)

canonicalCore : D.Word → D.CanWord
canonicalCore = fst ∘ split

paddingCount : D.Word → ℕ
paddingCount = snd ∘ split

reconstruct : (w : D.Word)
            → padHigh (fst (canonicalCore w)) (paddingCount w) ≡ w
reconstruct = join-split

------------------------------------------------------------------------
-- 2. The positional chart sees exactly the canonical coordinate
------------------------------------------------------------------------

value-zeroRun : (n : ℕ) → D.value (zeroRun n) ≡ 0
value-zeroRun zero = refl
value-zeroRun (suc n) =
    cong (λ z → 0 + D.b · z) (value-zeroRun n)
  ∙ cong (0 +_) (sym (0≡m·0 D.b))

value-padHigh : (w : D.Word) (n : ℕ)
              → D.value (padHigh w n) ≡ D.value w
value-padHigh [] n = value-zeroRun n
value-padHigh (d ∷ w) n =
  cong (λ z → toℕ d + D.b · z) (value-padHigh w n)

value-is-core-value : (w : D.Word)
                    → D.value w ≡ D.valueC (canonicalCore w)
value-is-core-value w =
    sym (cong D.value (join-split w))
  ∙ value-padHigh (fst (canonicalCore w)) (paddingCount w)

same-value→same-core : (x y : D.Word)
                     → D.value x ≡ D.value y
                     → canonicalCore x ≡ canonicalCore y
same-value→same-core x y same =
  Σ≡Prop D.isPropCanonical
    (D.value-inj
      (fst (canonicalCore x))
      (fst (canonicalCore y))
      (snd (canonicalCore x))
      (snd (canonicalCore y))
      (sym (value-is-core-value x) ∙ same ∙ value-is-core-value y))

same-core→same-value : (x y : D.Word)
                     → canonicalCore x ≡ canonicalCore y
                     → D.value x ≡ D.value y
same-core→same-value x y same =
    value-is-core-value x
  ∙ cong D.valueC same
  ∙ sym (value-is-core-value y)

same-value≃same-core : (x y : D.Word)
                     → (D.value x ≡ D.value y)
                       ≃ (canonicalCore x ≡ canonicalCore y)
same-value≃same-core x y =
  propBiimpl→Equiv
    (isSetℕ _ _)
    (D.isSetCanWord _ _)
    (same-value→same-core x y)
    (same-core→same-value x y)

------------------------------------------------------------------------
-- 3. Sharp finite controls
------------------------------------------------------------------------

empty-and-one-zero-same-value :
  D.value [] ≡ D.value (fzero ∷ [])
empty-and-one-zero-same-value = sym (value-zeroRun 1)

empty-padding-count : paddingCount [] ≡ 0
empty-padding-count = refl

one-zero-padding-count : paddingCount (fzero ∷ []) ≡ 1
one-zero-padding-count = refl

padding-count-really-separates :
  ¬ (paddingCount [] ≡ paddingCount (fzero ∷ []))
padding-count-really-separates = znots

-- High-end padding is directional: reversal moves the zero to the low end,
-- where it belongs to the canonical core rather than to the padding count.
reversal-source-count : paddingCount (fone ∷ fzero ∷ []) ≡ 1
reversal-source-count = refl

reversal-target-count :
  paddingCount (rev (fone ∷ fzero ∷ [])) ≡ 0
reversal-target-count = refl

reversal-changes-padding :
  ¬ (paddingCount (fone ∷ fzero ∷ [])
     ≡ paddingCount (rev (fone ∷ fzero ∷ [])))
reversal-changes-padding = snotz
