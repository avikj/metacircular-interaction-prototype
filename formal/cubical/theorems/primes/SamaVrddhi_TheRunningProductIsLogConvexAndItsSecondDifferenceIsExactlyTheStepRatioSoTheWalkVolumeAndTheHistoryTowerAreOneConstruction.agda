{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सम-वृद्धि — even growth.
--
-- A RUNNING PRODUCT IS LOG-CONVEX, AND STRICTLY SO EXACTLY WHERE ITS
-- STEP STRICTLY GROWS.  Over ℕ, with no logarithm, no reals, and no
-- division.
--
-- `DvitiyaAntara` proves the multiplicative second difference for the
-- DMR walk volume, using the inner recursion of `Πη` to cancel a factor.
-- That cancellation is special to that instance.  Underneath it there is
-- a construction that needs nothing arithmetic at all: for ANY sequence
-- of stage sizes `C : ℕ → ℕ`, the running product
--
--     vol 0        = 1
--     vol (n + 1)  = vol n · C n
--
-- satisfies a second-difference identity and a convexity inequality, and
-- both hold for every `C` whatsoever.
--
--   §1  vol (n+1) ≡ vol n · C n .                       (the recursion)
--
--   §2  THE SECOND DIFFERENCE, in the ν-free multiplicative form:
--
--         (vol n · vol (n+2)) · C n
--           ≡ (vol (n+1) · vol (n+1)) · C (n+1) .
--
--       Additively this reads
--         log vol(n+2) − 2 log vol(n+1) + log vol n = log (C(n+1)/C n),
--       which is why the second difference of the cumulative volume is
--       the LOCAL STEP RATIO and nothing else.  The identity above says
--       it with a multiplication, so it lives in ℕ and is checked rather
--       than transported through ℝ.
--
--   §3  LOG-CONVEXITY.  If the stage sizes do not shrink then
--
--         vol (n+1) · vol (n+1)  ≤  vol n · vol (n+2) .
--
--   §4  AND STRICTLY, exactly where the stage strictly grows — given
--       that the stages are positive, which is carried as a hypothesis
--       and used only through `vol` being positive.
--
--       So: the sites of strict convexity of the cumulative volume are
--       EXACTLY the sites where the stage size strictly increases.  That
--       is an exact local detector, not an asymptotic statement.
--
--   §5  AND THE DMR WALK VOLUME IS THIS CONSTRUCTION AT `C := Πη`:
--
--         vol Πη n ≡ δ n         for every n,
--
--       by induction, both sides being the same recursion.  So the walk
--       volume of the arithmetization is not a separate object from the
--       cumulative product of stage sizes — it IS one, and §§2–4 apply
--       to it verbatim.
--
-- THE READING THAT IS NOT PROVED HERE.  `Πη m = Π_{j ≤ m} η j` collects
-- one prime for each prime power below m, which is the standard product
-- formula for `lcm(1,…,m)`; under that identification §5 says the walk
-- volume and the cumulative CRT stage tower are literally the same
-- sequence, and the two consumers of it — the harmonic observer and the
-- local curvature receiver — read one source in two coordinates.  THAT
-- IDENTIFICATION IS ARITHMETIC AND IS NOT PROVED ANYWHERE BELOW: no
-- `lcm` is defined in this corpus, and `η`'s definition through `spf`
-- would have to be related to it.  Everything §§1–5 claims is
-- independent of it, because `C` is arbitrary.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–3 for every sequence `C` and every n,
-- with no positivity and no arithmetic.  §4 additionally under
-- positivity of every stage.  §5 for the `δ` of the DMR module as it
-- stands.  NOT claimed: anything about primes — the word does not occur
-- in any statement below, only in the commentary; that `Πη` is `lcm`;
-- anything about logarithms, entropy, or probability, which are the
-- reading of §§2–4 and not their content; and nothing about the size or
-- growth of `vol`, only about its convexity.
------------------------------------------------------------------------

module SamaVrddhi_TheRunningProductIsLogConvexAndItsSecondDifferenceIsExactlyTheStepRatioSoTheWalkVolumeAndTheHistoryTowerAreOneConstruction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _·_)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; ≤-·k ; <-·sk ; suc-≤-suc ; zero-≤ ; ¬-<-zero)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Tactics.NatSolver using (solveℕ!)

open import RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization
  using (Πη ; δ)

------------------------------------------------------------------------
-- ० · Two arithmetic scraps, isolated so nothing below repeats them.
------------------------------------------------------------------------

private
  ·-positive : (a b : ℕ) → 0 < a → 0 < b → 0 < (a · b)
  ·-positive zero    b       p q = ⊥-rec (¬-<-zero p)
  ·-positive (suc a) zero    p q = ⊥-rec (¬-<-zero q)
  ·-positive (suc a) (suc b) p q = suc-≤-suc zero-≤

  positive→suc : (m : ℕ) → 0 < m → Σ[ k ∈ ℕ ] (m ≡ suc k)
  positive→suc zero    p = ⊥-rec (¬-<-zero p)
  positive→suc (suc k) _ = k , refl

  -- the whole algebraic content of §§2–4, on fresh variables
  rearrange : (v c d : ℕ) → (v · ((v · c) · d)) · c ≡ ((v · c) · (v · c)) · d
  rearrange v c d = solveℕ!

  leftForm : (v c : ℕ) → c · ((v · v) · c) ≡ (v · c) · (v · c)
  leftForm v c = solveℕ!

  rightForm : (v c d : ℕ) → d · ((v · v) · c) ≡ v · ((v · c) · d)
  rightForm v c d = solveℕ!

------------------------------------------------------------------------
-- The construction: a running product of arbitrary stage sizes.
------------------------------------------------------------------------

module _ (C : ℕ → ℕ) where

  vol : ℕ → ℕ
  vol zero    = 1
  vol (suc n) = vol n · C n

  ------------------------------------------------------------------
  -- १ · The recursion IS the first difference.
  ------------------------------------------------------------------

  step : (n : ℕ) → vol (suc n) ≡ vol n · C n
  step n = refl

  ------------------------------------------------------------------
  -- २ · THE SECOND DIFFERENCE IS THE LOCAL STEP RATIO.
  ------------------------------------------------------------------

  second-difference : (n : ℕ)
    → (vol n · vol (suc (suc n))) · C n
      ≡ (vol (suc n) · vol (suc n)) · C (suc n)
  second-difference n = rearrange (vol n) (C n) (C (suc n))

  ------------------------------------------------------------------
  -- ३ · LOG-CONVEXITY, wherever the stage does not shrink.
  ------------------------------------------------------------------

  log-convex : (n : ℕ) → C n ≤ C (suc n)
    → (vol (suc n) · vol (suc n)) ≤ (vol n · vol (suc (suc n)))
  log-convex n h =
    subst2 _≤_
      (leftForm  (vol n) (C n))
      (rightForm (vol n) (C n) (C (suc n)))
      (≤-·k {k = (vol n · vol n) · C n} h)

  ------------------------------------------------------------------
  -- ४ · AND STRICTLY, exactly where the stage strictly grows.
  ------------------------------------------------------------------

  module _ (Cpos : (m : ℕ) → 0 < C m) where

    vol-positive : (n : ℕ) → 0 < vol n
    vol-positive zero    = suc-≤-suc zero-≤
    vol-positive (suc n) = ·-positive (vol n) (C n) (vol-positive n) (Cpos n)

    strictly-log-convex : (n : ℕ) → C n < C (suc n)
      → (vol (suc n) · vol (suc n)) < (vol n · vol (suc (suc n)))
    strictly-log-convex n h =
      subst2 _<_
        (cong (C n ·_)       (sym kEq) ∙ leftForm  (vol n) (C n))
        (cong (C (suc n) ·_) (sym kEq) ∙ rightForm (vol n) (C n) (C (suc n)))
        (<-·sk {k = k} h)
      where
        witness : Σ[ k ∈ ℕ ] (((vol n · vol n) · C n) ≡ suc k)
        witness =
          positive→suc ((vol n · vol n) · C n)
            (·-positive (vol n · vol n) (C n)
              (·-positive (vol n) (vol n) (vol-positive n) (vol-positive n))
              (Cpos n))

        k : ℕ
        k = witness .fst

        kEq : ((vol n · vol n) · C n) ≡ suc k
        kEq = witness .snd

------------------------------------------------------------------------
-- ५ · THE DMR WALK VOLUME IS THIS CONSTRUCTION AT `C := Πη`.
------------------------------------------------------------------------

walk-volume-is-a-running-product : (n : ℕ) → vol Πη n ≡ δ n
walk-volume-is-a-running-product zero    = refl
walk-volume-is-a-running-product (suc n) =
  cong (_· Πη n) (walk-volume-is-a-running-product n)
