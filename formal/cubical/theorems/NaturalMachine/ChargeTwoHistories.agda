{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.ChargeTwoHistories where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; -_ ; injPos ; isSetℤ)
  renaming (_+_ to _+ℤ_ ; _-_ to _-ℤ_)
open import Cubical.Data.Bool using (Bool ; false ; true ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

open import NaturalMachine.FiniteIndraWeave using (TotalView ; Tear ; tear)
open import NaturalMachine.ProductiveIndraNet using (Net ; observe)

-- A repeated prime has one charge-two history; two distinct primes have
-- the two possible orders.  No ordering of the primes is asserted here.
SquareHistory : Type₀
SquareHistory = Unit

SplitHistory : Type₀
SplitHistory = Bool

square-history-unique : (history : SquareHistory) → history ≡ tt
square-history-unique tt = refl

false≠true : ¬ (false ≡ true)
false≠true = false≢true

split-histories-distinct : ¬ (false ≡ true)
split-histories-distinct = false≠true

-- Coefficients on the two ordered histories.  Endpoint augmentation forgets
-- order and sums them; the relative channel is the primitive difference.
SplitProfile : Type₀
SplitProfile = ℤ × ℤ

augment : SplitProfile → ℤ
augment (x , y) = x +ℤ y

relative : SplitProfile → ℤ
relative (x , y) = x -ℤ y

sign : ℤ → SplitProfile
sign z = z , - z

zeroProfile : SplitProfile
zeroProfile = pos 0 , pos 0

augment-sign : (z : ℤ) → augment (sign z) ≡ pos 0
augment-sign z = solve! ℤCommRing

relative-sign : (z : ℤ) → relative (sign z) ≡ z +ℤ z
relative-sign z = solve! ℤCommRing

-- Exact kernel description: every augmentation-zero profile has second
-- coordinate -first, hence is completely read by the x-y channel.
kernel-is-sign : (profile : SplitProfile) → augment profile ≡ pos 0
  → snd profile ≡ - fst profile
kernel-is-sign (x , y) vanishes =
    step₁ x y
  ∙ cong (_-ℤ x) vanishes
  ∙ step₂ x
  where
  step₁ : (x y : ℤ) → y ≡ (x +ℤ y) -ℤ x
  step₁ x y = solve! ℤCommRing

  step₂ : (x : ℤ) → pos 0 -ℤ x ≡ - x
  step₂ x = solve! ℤCommRing

kernel-relative-exact : (profile : SplitProfile)
  → augment profile ≡ pos 0
  → relative profile ≡ fst profile +ℤ fst profile
kernel-relative-exact (x , y) vanishes =
  cong (x -ℤ_) (kernel-is-sign (x , y) vanishes)
  ∙ solve! ℤCommRing

-- The one-history p² fiber has no nonzero augmentation kernel.
SquareProfile : Type₀
SquareProfile = ℤ

squareAugment : SquareProfile → ℤ
squareAugment coefficient = coefficient

square-kernel-zero : (coefficient : SquareProfile)
  → squareAugment coefficient ≡ pos 0 → coefficient ≡ pos 0
square-kernel-zero coefficient vanishes = vanishes

one : ℤ
one = pos (suc zero)

signOne : SplitProfile
signOne = sign one

signOne-annihilates : augment signOne ≡ pos 0
signOne-annihilates = augment-sign one

signOne-relative : relative signOne ≡ pos (suc (suc zero))
signOne-relative = relative-sign one

signOne-relative-nonzero : ¬ (relative signOne ≡ pos 0)
signOne-relative-nonzero equality =
  snotz (injPos (sym signOne-relative ∙ equality))

------------------------------------------------------------------------
-- Productive observation: endpoint augmentation sees one common zero, while
-- the relative channel retains the split-history kernel at every depth.
------------------------------------------------------------------------

historyView : TotalView Bool SplitProfile
historyView false target = signOne
historyView true target = zeroProfile

augmentation-coherent : (left right target : Bool)
  → augment (historyView left target) ≡ augment (historyView right target)
augmentation-coherent false false target = refl
augmentation-coherent false true target = signOne-annihilates
augmentation-coherent true false target = sym signOne-annihilates
augmentation-coherent true true target = refl

relative-separates : (target : Bool)
  → ¬ (relative (historyView false target)
          ≡ relative (historyView true target))
relative-separates target = signOne-relative-nonzero

history-tear : Tear false historyView
history-tear = tear true false refute
  where
  refute : ¬ (historyView false false ≡ historyView true false)
  refute equality = signOne-relative-nonzero (cong relative equality)

historyNet : Net Bool SplitProfile
Net.view historyNet = historyView
Net.next historyNet = historyNet

history-two : observe 2 historyNet ≡ historyView ∷ historyView ∷ []
history-two = refl

iterate : ℕ → Net Bool SplitProfile → Net Bool SplitProfile
iterate zero net = net
iterate (suc n) net = iterate n (Net.next net)

endpoint-stays-annihilated : (depth : ℕ) (left right target : Bool)
  → augment (Net.view (iterate depth historyNet) left target)
    ≡ augment (Net.view (iterate depth historyNet) right target)
endpoint-stays-annihilated zero = augmentation-coherent
endpoint-stays-annihilated (suc depth) = endpoint-stays-annihilated depth
