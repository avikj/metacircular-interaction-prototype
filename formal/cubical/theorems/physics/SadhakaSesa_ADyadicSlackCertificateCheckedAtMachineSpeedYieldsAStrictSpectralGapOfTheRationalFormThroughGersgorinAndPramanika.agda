{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- साधक-शेष — the prover with a remainder.
--
-- The certificate format that scales: integers A′, L′, D′, E′, c′ with
--
--     A′ − c′·I  =  L′ D′ L′ᵀ + E′      exactly over ℤ,
--     D′ ≥ 0,   4 E′_ii ≥ Σ_j |E′_ij| + Σ_j |E′_ji|.
--
-- Then for every rational v:  vᵀA′v ≥ c′ · Σ v_i².  Checked over Saṅkhyā
-- at machine speed; the soundness runs through Sadhaka (the LDLᵀ part),
-- Gersgorin (the slack) and the additivity of the quadratic form.
--
--   §1  ABSOLUTE VALUE AND ORDER on Saṅkhyā, sound into ℚ.
--   §2  ADDITIVITY of the quadratic form in the matrix; the identity.
--   §3  THE CHECK and the theorem.
------------------------------------------------------------------------

module SadhakaSesa_ADyadicSlackCertificateCheckedAtMachineSpeedYieldsAStrictSpectralGapOfTheRationalFormThroughGersgorinAndPramanika where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ)
open import Cubical.Data.Nat.Order using (≤-refl ; ≤-suc) renaming (_<_ to _<ℕ_)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; false≢true)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)
import Cubical.Data.Int as ℤ
import Cubical.Data.Int.Order as ℤO
open ℤ using (pos ; neg)
open import Cubical.Data.NatPlusOne using (1+_)
open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order using (isRefl≤ ; isTrans≤ ; ≤-+o ; ≤-o+) renaming (_≤_ to _≤ℚ_)

open import Sankhya_SignedIntegersOverTheBuiltinNaturalsWithSoundArithmeticIntoTheLibrarysIntegersSoCertificatesComputeAtMachineSpeed
  using (𝕊 ; ⁺_ ; ⁻_ ; toℤ ; _⊗_ ; _⊕_ ; ⊗-sama ; ⊕-sama)
open import Sadhaka_AnIntegerLDLTCertificateCheckedAtMachineSpeedYieldsThePositivityOfTheRationalFormThroughPramanika
  using (eq𝕊 ; eq𝕊-sama ; toℚ ; toℚ-⊗ ; toℚ-⊕ ; Σ𝕊 ; Σ-toℚ ; toℚ-anṛṇa ; sarva ; sarva-satya ; and-satya)
open import Nirapeksa_TheAbsoluteValueOnTheRationalsIsTheMaximumOfAnElementAndItsNegativeSoItIsNonnegativeDominatesBothAndIsSubadditive
  using (∣_∣ ; dhana-sama ; ṛṇa-sama)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩)

------------------------------------------------------------------------
-- १ · Absolute value and order on Saṅkhyā.
------------------------------------------------------------------------

abs𝕊 : 𝕊 → 𝕊
abs𝕊 (⁺ a) = ⁺ a
abs𝕊 (⁻ a) = ⁺ a

neg𝕊 : 𝕊 → 𝕊
neg𝕊 (⁺ a) = ⁻ a
neg𝕊 (⁻ a) = ⁺ a

-- [neg a / 1] ≤ 0 and 0 ≤ [pos a / 1]
neg-≤0 : (a : ℕ) → toℚ (⁻ a) ≤ℚ 0
neg-≤0 zero    = isRefl≤ 0
neg-≤0 (suc a) = subst (ℤO._≤ pos 0 ℤ.· pos 1) (sym (ℤ.·IdR (ℤ.negsuc a))) (ℤO.<-weaken ℤO.negsuc<-zero)

-- (−1)·neg a ≡ pos a in ℤ
eka-neg : (a : ℕ) → ℤ.negsuc 0 ℤ.· neg a ≡ pos a
eka-neg zero    = ℤ.·AnnihilR (ℤ.negsuc 0)
eka-neg (suc a) = ℤ.negsuc·negsuc 0 a ∙ ℤ.·IdL (pos (suc a))

-- −[neg a / 1] ≡ [pos a / 1]
neg-toℚ : (a : ℕ) → - toℚ (⁻ a) ≡ toℚ (⁺ a)
neg-toℚ a = cong (λ z → [ z / 1 ]) (eka-neg a)

abs-sama : (x : 𝕊) → ∣ toℚ x ∣ ≡ toℚ (abs𝕊 x)
abs-sama (⁺ a) = dhana-sama (toℚ (⁺ a)) (toℚ-anṛṇa a)
abs-sama (⁻ a) = ṛṇa-sama (toℚ (⁻ a)) (neg-≤0 a) ∙ neg-toℚ a

-- toℚ (neg𝕊 x) ≡ − toℚ x
neg𝕊-sama : (x : 𝕊) → toℚ (neg𝕊 x) ≡ - toℚ x
neg𝕊-sama (⁺ a) = cong (λ z → [ z / 1 ]) (sym (ℤ.-pos a) ∙ cong ℤ.-_ (sym (ℤ.·IdL (pos a))) ∙ sym (ℤ.negsuc·pos 0 a))
neg𝕊-sama (⁻ a) = sym (neg-toℚ a)

śūnya? : ℕ → Bool
śūnya? zero    = true
śūnya? (suc _) = false

anṛṇa? : 𝕊 → Bool
anṛṇa? (⁺ _) = true
anṛṇa? (⁻ a) = śūnya? a

anṛṇa?-sama : (z : 𝕊) → anṛṇa? z ≡ true → 0 ≤ℚ toℚ z
anṛṇa?-sama (⁺ a)       _ = toℚ-anṛṇa a
anṛṇa?-sama (⁻ zero)    _ = isRefl≤ 0
anṛṇa?-sama (⁻ (suc a)) e = ⊥-elim (false≢true e)

-- x ≤ y decided as: y − x nonnegative
le𝕊 : 𝕊 → 𝕊 → Bool
le𝕊 x y = anṛṇa? (y ⊕ neg𝕊 x)

le𝕊-sama : (x y : 𝕊) → le𝕊 x y ≡ true → toℚ x ≤ℚ toℚ y
le𝕊-sama x y e = subst2 _≤ℚ_ (+IdR (toℚ x)) lemma (≤-o+ 0 (toℚ y - toℚ x) (toℚ x) diff)
  where
  diff : 0 ≤ℚ toℚ y - toℚ x
  diff = subst (0 ≤ℚ_) (toℚ-⊕ y (neg𝕊 x) ∙ cong (toℚ y +_) (neg𝕊-sama x)) (anṛṇa?-sama (y ⊕ neg𝕊 x) e)
  lemma : toℚ x + (toℚ y - toℚ x) ≡ toℚ y
  lemma = +Comm (toℚ x) (toℚ y - toℚ x) ∙ sym (+Assoc (toℚ y) (- toℚ x) (toℚ x)) ∙ cong (toℚ y +_) (+InvL (toℚ x)) ∙ +IdR (toℚ y)

------------------------------------------------------------------------
-- २ · Additivity of the form in the matrix, and the diagonal term.
------------------------------------------------------------------------

open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver
import Pramanika_AnExactRationalLDLTFactorisationCertifiesThatAQuadraticFormIsNonnegativeSoAPositivityCertificateIsACheckableTerm as P
import Gersgorin_ADiagonallyDominantMatrixWithNonnegativeDiagonalHasANonnegativeQuadraticFormSoASlackTermInACertificateIsAbsorbedRowByRow as G
open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; anṛṇa-yoga ; anṛṇa-varga)
open import DvandvaVarga_TheSquareOfTheInnerProductPlusTheSumOfPairSquaresIsTheProductOfNormsSoCauchySchwarzHoldsOverQAndTheResolvedDualityOfTheAdjointReceiverIsAttainedAtTheVectorItself
  using (Σ-add ; Σ-anṛṇa)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ-guṇa)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (anṛṇa-guṇa)

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R) renaming (_+_ to _⊞_ ; _·_ to _⊠_)
  yoga : (a b c d : ⟨ R ⟩) → (a ⊠ (b ⊞ c)) ⊠ d ≡ (a ⊠ b) ⊠ d ⊞ (a ⊠ c) ⊠ d
  yoga a b c d = solve! R
  karṇa : (a c : ⟨ R ⟩) → (a ⊠ c) ⊠ a ≡ c ⊠ (a ⊠ a)
  karṇa a c = solve! R

-- Q_{B+C} = Q_B + Q_C on [0,n)
Q-yoga : (n : ℕ) (B C : ℕ → ℕ → ℚ) (v : ℕ → ℚ)
       → G.Q n (λ i j → B i j + C i j) v ≡ G.Q n B v + G.Q n C v
Q-yoga n B C v =
    P.Σ-ext< n _ _ (λ i _ → P.Σ-ext< n _ _ (λ j _ → Sama.yoga ℚRing (v i) (B i j) (C i j) (v j)) ∙ Σ-add _ _ n)
  ∙ Σ-add _ _ n

-- the diagonal matrix c·I
δ : ℚ → ℕ → ℕ → ℚ
δ c i j with discreteℕ i j
... | yes _ = c
... | no  _ = 0

-- a sum with a single nonzero index i < n
Σ-zero< : (f : ℕ → ℚ) (k : ℕ) → ((j : ℕ) → j <ℕ k → f j ≡ 0) → Σ⟨ k ⟩ f ≡ 0
Σ-zero< f zero    _ = refl
Σ-zero< f (suc k) z = cong₂ _+_ (Σ-zero< f k (λ j lt → z j (≤-suc lt))) (z k ≤-refl) ∙ +IdR 0

Σ-eka< : (f : ℕ → ℚ) (i k : ℕ) → i <ℕ k → ((j : ℕ) → ¬ (j ≡ i) → f j ≡ 0) → Σ⟨ k ⟩ f ≡ f i
Σ-eka< f i zero    i<0 _ = ⊥-elim (Cubical.Data.Nat.Order.¬-<-zero i<0)
Σ-eka< f i (suc k) i<sk off with discreteℕ k i
... | yes p = cong₂ _+_ (Σ-zero< f k (λ j j<k → off j (λ q → Cubical.Data.Nat.Order.¬m<m (subst (λ z → z <ℕ k) (q ∙ sym p) j<k)))) (cong f p) ∙ +IdL (f i)
... | no ¬p = cong₂ _+_ (Σ-eka< f i k (suc-le i<sk ¬p) off) (off k ¬p) ∙ +IdR (f i)
  where
  suc-le : i <ℕ suc k → ¬ (k ≡ i) → i <ℕ k
  suc-le lt ne with Cubical.Data.Nat.Order.pred-≤-pred lt
  ... | (zero  , q) = ⊥-elim (ne (sym q))
  ... | (suc m , q) = m , (Cubical.Data.Nat.+-suc m i ∙ q)

δ-sama : (c : ℚ) (i : ℕ) → δ c i i ≡ c
δ-sama c i with discreteℕ i i
... | yes _ = refl
... | no ¬p = ⊥-elim (¬p refl)

δ-anya : (c : ℚ) (i j : ℕ) → ¬ (j ≡ i) → δ c i j ≡ 0
δ-anya c i j ne with discreteℕ i j
... | yes p = ⊥-elim (ne (sym p))
... | no  _ = refl

-- Q_{cI}(v) = c · Σ v_i²
Q-δ : (n : ℕ) (c : ℚ) (v : ℕ → ℚ) → G.Q n (δ c) v ≡ c · Σ⟨ n ⟩ (λ i → v i · v i)
Q-δ n c v =
    P.Σ-ext< n _ _ (λ i i<n →
        Σ-eka< (λ j → (v i · δ c i j) · v j) i n i<n (λ j ne → cong (λ z → (v i · z) · v j) (δ-anya c i j ne) ∙ lemma (v i) (v j))
      ∙ cong (λ z → (v i · z) · v i) (δ-sama c i)
      ∙ Sama.karṇa ℚRing (v i) c)
  ∙ Σ-guṇa c _ n
  where
  lemma : (a b : ℚ) → (a · 0) · b ≡ 0
  lemma a b = cong (_· b) (·AnnihilR a) ∙ ·AnnihilL b

------------------------------------------------------------------------
-- ३ · The check and the theorem.
------------------------------------------------------------------------

catur-sama : toℚ (⁺ 4) ≡ 1 + 1 + 1 + 1
catur-sama = eq/ _ _ refl

≤Monotone+ : (a b x y : ℚ) → a ≤ℚ b → x ≤ℚ y → a + x ≤ℚ b + y
≤Monotone+ a b x y ab xy = isTrans≤ (a + x) (b + x) (b + y) (≤-+o a b x ab) (≤-o+ x y b xy)

module _ (n : ℕ) (A L E : ℕ → ℕ → 𝕊) (D : ℕ → ℕ) (c : ℕ) where

  D𝕊 : ℕ → 𝕊
  D𝕊 k = ⁺ (D k)

  c𝕊 : 𝕊
  c𝕊 = ⁺ c

  δ𝕊 : ℕ → ℕ → 𝕊
  δ𝕊 i j with discreteℕ i j
  ... | yes _ = c𝕊
  ... | no  _ = ⁺ 0

  -- the right-hand side L D Lᵀ + E + c·I, in Saṅkhyā
  dakṣiṇa : ℕ → ℕ → 𝕊
  dakṣiṇa i j = (Σ𝕊 n (λ k → (L i k ⊗ D𝕊 k) ⊗ L j k) ⊕ E i j) ⊕ δ𝕊 i j

  -- row and column absolute sums of E
  paṅkti stambha : ℕ → 𝕊
  paṅkti i = Σ𝕊 n (λ j → abs𝕊 (E i j))
  stambha i = Σ𝕊 n (λ j → abs𝕊 (E j i))

  ldl? dom? : Bool
  ldl? = sarva n (λ i → sarva n (λ j → eq𝕊 (A i j) (dakṣiṇa i j)))
  dom? = sarva n (λ i → le𝕊 (paṅkti i ⊕ stambha i) ((⁺ 4) ⊗ E i i))

  sādhya : Bool
  sādhya = ldl? and dom?

  Aℚ Lℚ Eℚ Mℚ : ℕ → ℕ → ℚ
  Aℚ i j = toℚ (A i j)
  Lℚ i j = toℚ (L i j)
  Eℚ i j = toℚ (E i j)
  Mℚ i j = Σ⟨ n ⟩ (λ k → (Lℚ i k · toℚ (D𝕊 k)) · Lℚ j k)

  δ-toℚ : (i j : ℕ) → toℚ (δ𝕊 i j) ≡ δ (toℚ c𝕊) i j
  δ-toℚ i j with discreteℕ i j
  ... | yes _ = refl
  ... | no  _ = refl

  -- the identity, read in ℚ
  A-sama : sādhya ≡ true → (i j : ℕ) → i <ℕ n → j <ℕ n → Aℚ i j ≡ (Mℚ i j + Eℚ i j) + δ (toℚ c𝕊) i j
  A-sama e i j i<n j<n =
      cong (λ z → [ z / 1 ]) (eq𝕊-sama (A i j) (dakṣiṇa i j) (sarva-satya n (λ j′ → eq𝕊 (A i j′) (dakṣiṇa i j′)) (sarva-satya n (λ i′ → sarva n (λ j′ → eq𝕊 (A i′ j′) (dakṣiṇa i′ j′))) (fst (and-satya ldl? dom? e)) i i<n) j j<n))
    ∙ toℚ-⊕ (Σ𝕊 n (λ k → (L i k ⊗ D𝕊 k) ⊗ L j k) ⊕ E i j) (δ𝕊 i j)
    ∙ cong₂ _+_ (toℚ-⊕ (Σ𝕊 n (λ k → (L i k ⊗ D𝕊 k) ⊗ L j k)) (E i j)
                 ∙ cong (_+ Eℚ i j) (Σ-toℚ n (λ k → (L i k ⊗ D𝕊 k) ⊗ L j k)
                                     ∙ P.Σ-ext< n (λ k → toℚ ((L i k ⊗ D𝕊 k) ⊗ L j k)) (λ k → (Lℚ i k · toℚ (D𝕊 k)) · Lℚ j k)
                                         (λ k _ → toℚ-⊗ (L i k ⊗ D𝕊 k) (L j k) ∙ cong (_· Lℚ j k) (toℚ-⊗ (L i k) (D𝕊 k)))))
                (δ-toℚ i j)

  -- diagonal dominance, read in ℚ
  prabhutva : sādhya ≡ true → G.Prabhutva n Eℚ
  prabhutva e i i<n =
    subst2 _≤ℚ_ (toℚ-⊕ (paṅkti i) (stambha i)
                 ∙ cong₂ _+_ (Σ-toℚ n (λ j → abs𝕊 (E i j)) ∙ P.Σ-ext< n (λ j → toℚ (abs𝕊 (E i j))) (λ j → ∣ Eℚ i j ∣) (λ j _ → sym (abs-sama (E i j))))
                             (Σ-toℚ n (λ j → abs𝕊 (E j i)) ∙ P.Σ-ext< n (λ j → toℚ (abs𝕊 (E j i))) (λ j → ∣ Eℚ j i ∣) (λ j _ → sym (abs-sama (E j i)))))
                (toℚ-⊗ (⁺ 4) (E i i) ∙ cong (_· Eℚ i i) catur-sama)
      (le𝕊-sama (paṅkti i ⊕ stambha i) ((⁺ 4) ⊗ E i i) (sarva-satya n (λ i′ → le𝕊 (paṅkti i′ ⊕ stambha i′) ((⁺ 4) ⊗ E i′ i′)) (snd (and-satya ldl? dom? e)) i i<n))

  -- THE THEOREM: a dyadic slack certificate that checks gives the spectral gap c.
  sādhaka-śeṣa : sādhya ≡ true → (v : ℕ → ℚ) → toℚ c𝕊 · Σ⟨ n ⟩ (λ i → v i · v i) ≤ℚ G.Q n Aℚ v
  sādhaka-śeṣa e v =
    subst (toℚ c𝕊 · Σ⟨ n ⟩ (λ i → v i · v i) ≤ℚ_)
      (sym (P.Σ-ext< n _ _ (λ i i<n → P.Σ-ext< n _ _ (λ j j<n → cong (λ z → (v i · z) · v j) (A-sama e i j i<n j<n)))
            ∙ Q-yoga n (λ i j → Mℚ i j + Eℚ i j) (δ (toℚ c𝕊)) v
            ∙ cong (_+ G.Q n (δ (toℚ c𝕊)) v) (Q-yoga n Mℚ Eℚ v)))
      (subst (_≤ℚ (G.Q n Mℚ v + G.Q n Eℚ v) + G.Q n (δ (toℚ c𝕊)) v)
             (cong (_+ G.Q n (δ (toℚ c𝕊)) v) (+IdR 0) ∙ +IdL _ ∙ Q-δ n (toℚ c𝕊) v)
             (≤Monotone+ (0 + 0) (G.Q n Mℚ v + G.Q n Eℚ v) (G.Q n (δ (toℚ c𝕊)) v) (G.Q n (δ (toℚ c𝕊)) v)
                (≤Monotone+ 0 (G.Q n Mℚ v) 0 (G.Q n Eℚ v)
                   (P.prāmāṇika n Mℚ Lℚ (λ k → toℚ (D𝕊 k)) (λ i j _ _ → refl) (λ k _ → toℚ-anṛṇa (D k)) v)
                   (G.gersgorin n Eℚ (prabhutva e) v))
                (isRefl≤ (G.Q n (δ (toℚ c𝕊)) v))))
