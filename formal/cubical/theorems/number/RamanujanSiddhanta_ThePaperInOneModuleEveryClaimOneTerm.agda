{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, सिद्धान्त — THE PAPER IN ONE MODULE: EVERY CLAIM, ONE TERM.
--
-- Abstract 26 makes claims; this module binds each to its checked
-- term by name, so the paper's table of contents is itself checked.
-- The window-assertion of the 2720 file joins when its scan lands.
------------------------------------------------------------------------

module RamanujanSiddhanta_ThePaperInOneModuleEveryClaimOneTerm where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_)
open import Cubical.Data.Sum using (_⊎_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Relation.Nullary using (¬_)

open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
open import RamanujanStrand_TheHouseIs204Of288TheBalanceIsThePellConditionAndTheMachineTurnedTheWheel
open import RamanujanNagell_TheFiveSolutionsAndNoSixthBelowTwoToTheFifteen
open import RamanujanHCN_OneHundredTwentyIsHighlyCompositeAndTheMemoirsColumnChecks
open import RamanujanPartitions_TheCongruenceInstancesWithCofactorsInHandAndTheGeneralTheoremNamed
open import RamanujanCubes_TheQuadruplesAndTheNearMissesOfFermatByRefl
open import RamanujanPrimes_TheFiveThresholdsHoldTo50AndEachMinimalityIsOneRefutation
open import Ramanujan691_TheTauCongruenceInstancesWithTauDefinedByTheDeltaProductItself
open import RamanujanSigma_TheEisensteinConvolutionIdentityInstancesByRefl
open import RamanujanTernaryGate_TheKernelScansBelowSevenTwentyOnceAndCachesTheVerdict
  using (Q ; Rep ; exc ; In17)
open import RamanujanTernary_BelowSevenTwentyTheOddExceptionsAreExactlyHisSeventeenTowardTheOpenList
  using (listed-not-represented)
open import RamanujanTernaryGate_TheKernelScansBelowSevenTwentyOnceAndCachesTheVerdict
  using (represented-or-listed)
open import RamanujanTernaryUpadhi_TheUniversalClaimIsATypeTheGateRestrictsItAndNoTermRunsBackwards
  using (RamanujanAssertion ; Gate720 ; the-gate-holds ;
         rep-decidable-below-720 ; exc18)
  renaming (restrict to restrict-ternary)
open import RamanujanTernaryField_TheCountingFieldIsTheObjectTheBooleanIsItsSupportAndTheCollapseForgets
  using (rC ; the-boolean-is-the-support ; the-collapse-forgets)
open import RamanujanEighteen_TheSoundnessHalfOfTheOpenAssertionIsKernelSignedEntire
  using (the-eighteen-are-exceptions ; no-2719)
open import RamanujanLehmer_TheQuestionIsATypeTauIsTotalTheGateHoldsToSixteenAndNoConverseIsWritten
  using (τAt ; Balances ; LehmerQuestion ; GateSixteen ; lehmer-gate)
  renaming (restrict to restrict-lehmer)

------------------------------------------------------------------------
-- §1  The proven corpus.
------------------------------------------------------------------------

claim-taxicab-ways : (S² 1 12 ≡ 1729) × (S² 9 10 ≡ 1729)
claim-taxicab-ways = first-way , second-way

claim-taxicab-minimal : (m : ℕ) → m < 1729 →
  (a b c d : ℕ) → 1 ≤ a → 1 ≤ b → 1 ≤ c → 1 ≤ d →
  S² a b ≡ m → S² c d ≡ m →
  ((a ≡ c) × (b ≡ d)) ⊎ ((a ≡ d) × (b ≡ c))
claim-taxicab-minimal = ramanujan-was-right

claim-strand-balance : sumTo 203 + sumTo 204 ≡ sumTo 288
claim-strand-balance = the-house-balances

claim-strand-bridge : (n k : ℕ) → Balanced n k → Pell (suc (n + n)) (k + k)
claim-strand-bridge = balance-is-pell

claim-strand-bridge-back : (n k : ℕ) → Pell (suc (n + n)) (k + k) → Balanced n k
claim-strand-bridge-back = pell-is-balance

claim-nagell : (n x : ℕ) → n ≤ 15 → x · x + 7 ≡ pow2 n → Five n x
claim-nagell = ramanujan-nagell-below-15

claim-hcn : (m : ℕ) → m < 120 → dCount m < dCount 120
claim-hcn = highly-composite-120

claim-partition-5 : (5 ∣ p 4) × (5 ∣ p 9) × (5 ∣ p 14)
claim-partition-5 = mod5-instances

claim-partition-7 : (7 ∣ p 5) × (7 ∣ p 12) × (7 ∣ p 19)
claim-partition-7 = mod7-instances

claim-partition-11 : (11 ∣ p 6) × (11 ∣ p 17) × (11 ∣ p 28)
claim-partition-11 = mod11-instances

claim-near-fermat : cube 135 + cube 138 + 1 ≡ cube 172
claim-near-fermat = near-miss-large

claim-thresholds : (x : ℕ) → x ≤ 50 →
    (2 ≤ x → πC (half x) + 1 ≤ πC x)
  × (11 ≤ x → πC (half x) + 2 ≤ πC x)
  × (17 ≤ x → πC (half x) + 3 ≤ πC x)
  × (29 ≤ x → πC (half x) + 4 ≤ πC x)
  × (41 ≤ x → πC (half x) + 5 ≤ πC x)
claim-thresholds = ramanujan-thresholds

claim-691 : σ₁₁ 6 + snd (τp 6) ≡ fst (τp 6) + 691 · 525300
claim-691 = congruence-6

claim-eisenstein : σ₇ 8 ≡ σ₃ 8 + 120 · σ₃∗σ₃ 8
claim-eisenstein = eisenstein-8

------------------------------------------------------------------------
-- §2  The open statements, at their boundary.
------------------------------------------------------------------------

claim-gate-720 : Gate720
claim-gate-720 = the-gate-holds

claim-restrict-only : RamanujanAssertion → Gate720
claim-restrict-only = restrict-ternary

claim-decided : (n : ℕ) → n < 720 → Rep n ⊎ (¬ Rep n)
claim-decided = rep-decidable-below-720

claim-support : (n : ℕ) → n < 720 →
  (Rep n → 1 ≤ rC n) × ((1 ≤ rC n) → Rep n)
claim-support = the-boolean-is-the-support

claim-loss : (rC 1 ≡ 2) × (rC 2 ≡ 1) × Rep 1 × Rep 2
claim-loss = the-collapse-forgets

claim-soundness-half : (i : ℕ) → i ≤ 17 → ¬ Rep (exc18 i)
claim-soundness-half = the-eighteen-are-exceptions

claim-lehmer-gate : GateSixteen
claim-lehmer-gate = lehmer-gate

claim-lehmer-restrict : LehmerQuestion → GateSixteen
claim-lehmer-restrict = restrict-lehmer
