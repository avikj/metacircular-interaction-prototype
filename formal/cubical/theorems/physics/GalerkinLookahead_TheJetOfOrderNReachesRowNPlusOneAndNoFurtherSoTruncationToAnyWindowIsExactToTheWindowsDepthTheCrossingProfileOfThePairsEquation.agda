{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- GalerkinLookahead — for every window M, the Galerkin-truncated jet
-- stream of the pair agrees with the exact jet stream to depth M:
--
--     take j (galerkin M i) ≡ take j (jets i)     whenever i + j ≤ M.
--
-- This is SthairyaSutra's crossing profile at the pair's own equation:
-- the advection by a = 2 cos(N x₁) reads one row beyond what it writes,
-- so each jet reaches exactly one more row, Jet n vanishing beyond
-- |k₁| = n + 1, and a truncation to |k₁| ≤ M loses nothing until the
-- jets reach it.  GalerkinJets checked this at M = 2, 3; here it is
-- proved for every M from the support lemma of convolution with a.
--
--   §1  ring facts on ℤ[i] and the row-support predicate Rows n f
--       (f vanishes on the rows |k₁| > n);
--   §2  THE SUPPORT LEMMA: Rows n g → Rows (n+1) ((c · a) ∗ g), by
--       cases on the mode of a — only (±1, 0) carries weight, and there
--       g is read one row further out;
--   §3  Rows is closed under the field operations, so every jet has
--       Rows (n+1) (Jet n), by induction through the jet table;
--   §4  truncation fixes a field within its rows, so the truncated table
--       equals the exact table while n + 1 ≤ M, and the streams agree.
--
-- SYĀT.  Exact, for every window, for the pair's equation at ν = 1 and
-- N = 2 as GalerkinJets fixes them.  Convergence of the jets is not here.
------------------------------------------------------------------------

module GalerkinLookahead_TheJetOfOrderNReachesRowNPlusOneAndNoFurtherSoTruncationToAnyWindowIsExactToTheWindowsDepthTheCrossingProfileOfThePairsEquation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _∸_ ; discreteℕ ; snotz)
open import Cubical.Data.Nat.Order
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; abs ; sucℤ ; predℤ) renaming (_·_ to _·i_ ; _+_ to _+i_ ; -_ to -i_)
open import Cubical.Data.Int.Properties using (·Comm)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import TorusFourierLayer_TheTriangularPairIsDerivedFromItsVelocityFieldTheNonlinearTermIsDivergenceFreeSoThePressureIsConstantAndTheCoarseStressAndContinuationAreComputed
open import GalerkinJets_TheTaylorJetsOfThePairAtTimeZeroAreExactOnAWideningWindowAndTheTruncationResidualSitsOnTheBoundaryRow
open import HistoryCompletion_TheValueStreamOfATraceUnderAnEvaluatorCompletesByCorecursionItsLimitDescendsToTruncationsAndBoundednessDoesNot
  using (module Take ; module JetStream)
open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive using (Dhārā)
open Dhārā

------------------------------------------------------------------------
-- §1  ring facts and row support
------------------------------------------------------------------------

-- z · 0 = 0 (0 · z = 0 is definitional, multiplication recursing on its
-- first argument)
z·0c : (z : ℤi) → z ·c 0c ≡ 0c
z·0c (x , y) = cong₂ _,_ (cong₂ (λ u w → u +i (-i w)) (·Comm x (pos 0)) (·Comm y (pos 0)))
                          (cong₂ _+i_ (·Comm x (pos 0)) (·Comm y (pos 0)))

Rows : ℕ → Field → Type₀
Rows n f = (k₁ k₂ : ℤ) → n < abs k₁ → f k₁ k₂ ≡ 0c

-- a sum over the box of terms that all vanish, vanishes
sumL-zero : (g : ℤ → ℤi) → ((p : ℤ) → g p ≡ 0c) → sumL box g ≡ 0c
sumL-zero g z =
  cong₂ _+c_ (z (negsuc 1)) (cong₂ _+c_ (z (negsuc 0)) (cong₂ _+c_ (z (pos 0)) (cong₂ _+c_ (z (pos 1)) (cong (_+c 0c) (z (pos 2))))))

------------------------------------------------------------------------
-- §2  THE SUPPORT LEMMA
------------------------------------------------------------------------

-- reading one row further out
abs-pred : (n : ℕ) (k : ℤ) → suc n < abs k → n < abs (predℤ k)
abs-pred n (pos zero) h = ⊥-rec (¬-<-zero h)
abs-pred n (pos (suc m)) h = pred-≤-pred h
abs-pred n (negsuc m) h = ≤-suc (<-weaken h)

abs-suc : (n : ℕ) (k : ℤ) → suc n < abs k → n < abs (sucℤ k)
abs-suc n (pos m) h = ≤-suc (<-weaken h)
abs-suc n (negsuc zero) h = ⊥-rec (¬-<-zero (pred-≤-pred h))
abs-suc n (negsuc (suc m)) h = pred-≤-pred h

-- k − pos 1 is predℤ k and k − negsuc 0 is sucℤ k, definitionally

-- every term of the convolution vanishes on the far rows
term-zero : (c : ℤi) (n : ℕ) (g : Field) → Rows n g → (k₁ k₂ : ℤ) → suc n < abs k₁
          → (p₁ p₂ : ℤ) → (c ·c a p₁ p₂) ·c g (k₁ Cubical.Data.Int.- p₁) (k₂ Cubical.Data.Int.- p₂) ≡ 0c
term-zero c n g rg k₁ k₂ h (pos zero) (pos zero) = cong (_·c g (k₁ Cubical.Data.Int.- pos zero) (k₂ Cubical.Data.Int.- pos zero)) (z·0c c)
term-zero c n g rg k₁ k₂ h (pos zero) (pos (suc m)) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (pos zero) (negsuc m) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (pos (suc zero)) (pos zero) =
  cong ((c ·c 1c) ·c_) (rg (predℤ k₁) k₂ (abs-pred n k₁ h)) ∙ z·0c (c ·c 1c)
term-zero c n g rg k₁ k₂ h (pos (suc zero)) (pos (suc m)) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (pos (suc zero)) (negsuc m) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (pos (suc (suc m'))) (pos zero) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (pos (suc (suc m'))) (pos (suc m)) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (pos (suc (suc m'))) (negsuc m) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (negsuc zero) (pos zero) =
  cong ((c ·c 1c) ·c_) (rg (sucℤ k₁) k₂ (abs-suc n k₁ h)) ∙ z·0c (c ·c 1c)
term-zero c n g rg k₁ k₂ h (negsuc zero) (pos (suc m)) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (negsuc zero) (negsuc m) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (negsuc (suc m')) (pos zero) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (negsuc (suc m')) (pos (suc m)) = cong (_·c _) (z·0c c)
term-zero c n g rg k₁ k₂ h (negsuc (suc m')) (negsuc m) = cong (_·c _) (z·0c c)

conv-rows : (c : ℤi) (n : ℕ) (g : Field) → Rows n g → Rows (suc n) ((c ·f a) ∗ g)
conv-rows c n g rg k₁ k₂ h =
  sumL-zero _ (λ p₁ → sumL-zero _ (λ p₂ → term-zero c n g rg k₁ k₂ h p₁ p₂))

------------------------------------------------------------------------
-- §3  Rows is closed under the field operations; every jet has Rows (n+1)
------------------------------------------------------------------------

rows-mono : (n m : ℕ) → n ≤ m → (f : Field) → Rows n f → Rows m f
rows-mono n m n≤m f r k₁ k₂ h = r k₁ k₂ (≤<-trans n≤m h)

rows-+f : (n : ℕ) (f g : Field) → Rows n f → Rows n g → Rows n (f +f g)
rows-+f n f g rf rg k₁ k₂ h = cong₂ _+c_ (rf k₁ k₂ h) (rg k₁ k₂ h)

rows-negf : (n : ℕ) (f : Field) → Rows n f → Rows n (negf f)
rows-negf n f rf k₁ k₂ h = cong negc (rf k₁ k₂ h)

rows-·f : (n : ℕ) (c : ℤi) (f : Field) → Rows n f → Rows n (c ·f f)
rows-·f n c f rf k₁ k₂ h = cong (c ·c_) (rf k₁ k₂ h) ∙ z·0c c

rows-∂₂ : (n : ℕ) (f : Field) → Rows n f → Rows n (∂₂ f)
rows-∂₂ n f rf k₁ k₂ h = cong ((i ·c ι k₂) ·c_) (rf k₁ k₂ h) ∙ z·0c (i ·c ι k₂)

rows-Δ : (n : ℕ) (f : Field) → Rows n f → Rows n (Δ f)
rows-Δ n f rf k₁ k₂ h = cong (negc (ι (N ·i k₁ ·i (N ·i k₁) +i k₂ ·i k₂)) ·c_) (rf k₁ k₂ h) ∙ z·0c (negc (ι (N ·i k₁ ·i (N ·i k₁) +i k₂ ·i k₂)))

-- the initial datum v lives on the rows |k₁| ≤ 1
rows-v : Rows 1 v
rows-v (pos zero) k₂ h = ⊥-rec (¬-<-zero h)
rows-v (pos (suc zero)) k₂ h = ⊥-rec (¬m<m h)
rows-v (pos (suc (suc m))) (pos k) h = refl
rows-v (pos (suc (suc m))) (negsuc k) h = refl
rows-v (negsuc zero) k₂ h = ⊥-rec (¬m<m h)
rows-v (negsuc (suc m)) (pos k) h = refl
rows-v (negsuc (suc m)) (negsuc k) h = refl

-- a table correct on orders ≤ n: each entry k ≤ n has Rows (k + 1)
Good : ℕ → (ℕ → Field) → Type₀
Good n G = (k : ℕ) → k ≤ n → Rows (suc k) (G k)

-- the Leibniz sum at order n reaches row n + 2
rows-leib : (n : ℕ) (G : ℕ → Field) → Good n G → (m : ℕ) → m ≤ n → Rows (suc (suc n)) (leib G n m)
rows-leib n G good zero _ =
  rows-·f _ (ι (binom n zero)) _ (conv-rows (ι (decay zero)) (suc n) _ (rows-∂₂ _ _ (good n ≤-refl)))
rows-leib n G good (suc m) m≤n =
  rows-+f _ _ _
    (rows-·f _ (ι (binom n (suc m))) _ (conv-rows (ι (decay (suc m))) (suc n) _
      (rows-∂₂ _ _ (rows-mono _ _ (suc-≤-suc (∸-≤ n (suc m))) _ (good (n ∸ suc m) (∸-≤ n (suc m)))))))
    (rows-leib n G good m (≤-trans ≤-sucℕ m≤n))

rows-step : (n : ℕ) (G : ℕ → Field) → Good n G → Rows (suc (suc n)) (step G n)
rows-step n G good =
  rows-+f _ _ _ (rows-negf _ _ (rows-leib n G good n ≤-refl))
                (rows-·f _ (ι ν) _ (rows-Δ _ _ (rows-mono _ _ ≤-sucℕ _ (good n ≤-refl))))

-- the exact table is good at every order
table-good : (n : ℕ) → Good n (table n)
table-good zero k k≤0 = rows-mono 1 (suc k) (suc-≤-suc zero-≤) v rows-v
table-good (suc n) k k≤ with discreteℕ k (suc n)
... | yes e = subst (λ j → Rows (suc j) (step (table n) n)) (sym e) (rows-step n (table n) (table-good n))
... | no ne = table-good n k (≤-suc-≢ k≤ ne)

jet-rows : (n : ℕ) → Rows (suc n) (Jet n)
jet-rows n = table-good n n ≤-refl

------------------------------------------------------------------------
-- §4  truncation fixes a field within its rows; the streams agree
------------------------------------------------------------------------

T-fixes : (M : ℕ) (f : Field) → Rows M f → (k₁ k₂ : ℤ) → T M f k₁ k₂ ≡ f k₁ k₂
T-fixes M f rf k₁ k₂ with ≤Dec (abs k₁) M
... | yes _ = refl
... | no ¬le = sym (rf k₁ k₂ (<-asym' (λ lt → ¬le (pred-≤-pred lt))))

T-fixes-ext : (M : ℕ) (f : Field) → Rows M f → T M f ≡ f
T-fixes-ext M f rf = funExt λ k₁ → funExt λ k₂ → T-fixes M f rf k₁ k₂

-- the truncated table equals the exact table while n + 1 ≤ M
tableT-eq : (M n : ℕ) → suc n ≤ M → tableT M n ≡ table n
tableT-eq M zero _ = refl
tableT-eq M (suc n) h =
  cong (λ G → extend G n (T M (step G n))) (tableT-eq M n (≤-trans ≤-sucℕ h))
  ∙ cong (extend (table n) n) (T-fixes-ext M _ (rows-mono _ _ h _ (rows-step n (table n) (table-good n))))

JT-exact : (M n : ℕ) → suc n ≤ M → JT M n ≡ Jet n
JT-exact M n h = cong (λ G → G n) (tableT-eq M n h)

-- THE THEOREM: the streams agree to the window's depth
open Take
open JetStream

lookahead : (M i j : ℕ) → i + j ≤ M → take j (galerkin M i) ≡ take j (jets i)
lookahead M i zero _ = refl
lookahead M i (suc j) h =
  cong₂ _∷_ (JT-exact M i (≤-trans (suc-≤-suc (≤SumLeft {n = i} {k = j})) h'))
            (lookahead M (suc i) j h')
  where
    open import Cubical.Data.Nat using (+-suc)
    h' : suc (i + j) ≤ M
    h' = subst (_≤ M) (+-suc i j) h
