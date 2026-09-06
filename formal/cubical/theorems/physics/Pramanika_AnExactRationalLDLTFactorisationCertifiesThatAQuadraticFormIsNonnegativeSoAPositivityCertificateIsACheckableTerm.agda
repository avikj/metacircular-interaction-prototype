{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रामाणिक — the certified.
--
-- The Weil positivity oracle reduces positivity on a support length to
-- the positivity of a FINITE quadratic form, verified numerically.  For
-- that verification to enter the corpus it must be a term.  This file
-- makes the certificate shape a theorem over ℚ:
--
--     A = L · D · Lᵀ with every D_k ≥ 0   ⇒   vᵀ A v ≥ 0 for every v,
--
-- because vᵀ L D Lᵀ v = Σ_k D_k (Lᵀv)_k².  Over ℚ the equation A = L D Lᵀ
-- is decidable entry by entry, so a concrete certificate (L, D) is
-- checked by computation and the theorem hands back positivity.
--
--   §1  DOUBLE SUMS over ℚ: interchange, and pulling factors out.
--   §2  THE QUADRATIC FORM and its diagonalisation through the factors.
--   §3  POSITIVITY from a nonnegative diagonal.
--
-- प्रामाणिक (prāmāṇika, authoritative/certified) is ordinary Sanskrit.
------------------------------------------------------------------------

module Pramanika_AnExactRationalLDLTFactorisationCertifiesThatAQuadraticFormIsNonnegativeSoAPositivityCertificateIsACheckableTerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat using (discreteℕ ; +-suc)
open import Cubical.Data.Nat.Order using (≤-refl ; ≤-suc ; ¬-<-zero ; pred-≤-pred) renaming (_<_ to _<ℕ_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Bool using (Bool ; true ; false ; _and_ ; false≢true)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; ¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  pada : (v l d l′ v′ : ⟨ R ⟩) → (v · ((l · d) · l′)) · v′ ≡ d · ((v · l) · (v′ · l′))
  pada v l d l′ v′ = solve! R

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order using (_≤_ ; isRefl≤ ; isTrans≤ ; ≤Dec)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; anṛṇa-varga ; anṛṇa-yoga)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩ ; Σ-guṇa)
open import DvandvaVarga_TheSquareOfTheInnerProductPlusTheSumOfPairSquaresIsTheProductOfNormsSoCauchySchwarzHoldsOverQAndTheResolvedDualityOfTheAdjointReceiverIsAttainedAtTheVectorItself
  using (Σ-ext ; Σ-add ; Σ-anṛṇa)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (anṛṇa-guṇa)

------------------------------------------------------------------------
-- १ · Double sums.
------------------------------------------------------------------------

Σ-śūnya : (n : ℕ) → Σ⟨ n ⟩ (λ _ → 0) ≡ 0
Σ-śūnya zero    = refl
Σ-śūnya (suc n) = +IdR _ ∙ Σ-śūnya n

Σ-ext< : (n : ℕ) (f g : ℕ → ℚ) → ((i : ℕ) → i <ℕ n → f i ≡ g i) → Σ⟨ n ⟩ f ≡ Σ⟨ n ⟩ g
Σ-ext< zero    f g e = refl
Σ-ext< (suc n) f g e = cong₂ _+_ (Σ-ext< n f g (λ i lt → e i (≤-suc lt))) (e n ≤-refl)

Σ-swap : (n m : ℕ) (F : ℕ → ℕ → ℚ)
       → Σ⟨ n ⟩ (λ i → Σ⟨ m ⟩ (λ j → F i j)) ≡ Σ⟨ m ⟩ (λ j → Σ⟨ n ⟩ (λ i → F i j))
Σ-swap zero    m F = sym (Σ-śūnya m)
Σ-swap (suc n) m F = cong (_+ Σ⟨ m ⟩ (λ j → F n j)) (Σ-swap n m F)
                   ∙ sym (Σ-add (λ j → Σ⟨ n ⟩ (λ i → F i j)) (λ j → F n j) m)

-- pulling a right factor out
Σ-guṇaʳ : (f : ℕ → ℚ) (q : ℚ) (n : ℕ) → Σ⟨ n ⟩ (λ i → f i · q) ≡ Σ⟨ n ⟩ f · q
Σ-guṇaʳ f q n = Σ-ext (λ i → f i · q) (λ i → q · f i) n (λ i → ·Comm (f i) q) ∙ Σ-guṇa q f n ∙ ·Comm q (Σ⟨ n ⟩ f)

------------------------------------------------------------------------
-- २ · The quadratic form and its diagonalisation.
------------------------------------------------------------------------

module _ (n : ℕ) (A L : ℕ → ℕ → ℚ) (D : ℕ → ℚ) where

  LDLᵀ : Type₀
  LDLᵀ = (i j : ℕ) → i <ℕ n → j <ℕ n → A i j ≡ Σ⟨ n ⟩ (λ k → (L i k · D k) · L j k)

  Anṛṇa-D : Type₀
  Anṛṇa-D = (k : ℕ) → k <ℕ n → 0 ≤ D k

  -- vᵀ A v
  Q : (ℕ → ℚ) → ℚ
  Q v = Σ⟨ n ⟩ (λ i → Σ⟨ n ⟩ (λ j → (v i · A i j) · v j))

  -- (Lᵀ v)_k
  w : (ℕ → ℚ) → ℕ → ℚ
  w v k = Σ⟨ n ⟩ (λ i → v i · L i k)

  -- the diagonalisation: vᵀ A v = Σ_k D_k (Lᵀv)_k²
  vibhāga : LDLᵀ → (v : ℕ → ℚ) → Q v ≡ Σ⟨ n ⟩ (λ k → D k · (w v k · w v k))
  vibhāga ldl v =
      Σ-ext< n _ _ (λ i i<n → Σ-ext< n _ _ (λ j j<n →
          cong (λ z → (v i · z) · v j) (ldl i j i<n j<n)
        ∙ cong (_· v j) (sym (Σ-guṇa (v i) _ n))
        ∙ sym (Σ-guṇaʳ _ (v j) n)
        ∙ Σ-ext _ _ n (λ k → Sama.pada ℚRing (v i) (L i k) (D k) (L j k) (v j))))
    -- now Σ_i Σ_j Σ_k D_k ((v_i L_ik)(v_j L_jk)); swap j,k inside, then i,k outside
    ∙ Σ-extₙ n _ _ (λ i → Σ-swap n n (λ j k → D k · ((v i · L i k) · (v j · L j k))))
    ∙ Σ-swap n n (λ i k → Σ⟨ n ⟩ (λ j → D k · ((v i · L i k) · (v j · L j k))))
    -- and factor: Σ_i Σ_j D_k (a_i b_j) = D_k (Σ a_i)(Σ b_j)
    ∙ Σ-extₙ n _ _ (λ k →
          Σ-extₙ n _ _ (λ i → Σ-guṇa (D k) _ n ∙ cong (D k ·_) (Σ-guṇa (v i · L i k) _ n))
        ∙ Σ-guṇa (D k) _ n
        ∙ cong (D k ·_) (Σ-guṇaʳ (λ i → v i · L i k) (w v k) n))
    where
    Σ-extₙ : (n : ℕ) (f g : ℕ → ℚ) → ((i : ℕ) → f i ≡ g i) → Σ⟨ n ⟩ f ≡ Σ⟨ n ⟩ g
    Σ-extₙ n f g e = Σ-ext< n f g (λ i _ → e i)

  ----------------------------------------------------------------------
  -- ३ · Positivity from a nonnegative diagonal.
  ----------------------------------------------------------------------

  Σ-anṛṇa< : (f : ℕ → ℚ) (k : ℕ) → ((i : ℕ) → i <ℕ k → 0 ≤ f i) → 0 ≤ Σ⟨ k ⟩ f
  Σ-anṛṇa< f zero    _   = isRefl≤ 0
  Σ-anṛṇa< f (suc k) 0≤f = anṛṇa-yoga {Σ⟨ k ⟩ f} {f k} (Σ-anṛṇa< f k (λ i lt → 0≤f i (≤-suc lt))) (0≤f k ≤-refl)

  prāmāṇika : LDLᵀ → Anṛṇa-D → (v : ℕ → ℚ) → 0 ≤ Q v
  prāmāṇika ldl 0≤D v = subst (0 ≤_) (sym (vibhāga ldl v))
    (Σ-anṛṇa< (λ k → D k · (w v k · w v k)) n
       (λ k k<n → anṛṇa-guṇa (D k) (w v k · w v k) (0≤D k k<n) (anṛṇa-varga (w v k))))

  ----------------------------------------------------------------------
  -- ४ · The checker: the certificate is verified by computation, and the
  --     verification hands back the two hypotheses.
  ----------------------------------------------------------------------

  dec→bool : {P : Type₀} → Dec P → Bool
  dec→bool (yes _) = true
  dec→bool (no  _) = false

  dec-satya : {P : Type₀} (d : Dec P) → dec→bool d ≡ true → P
  dec-satya (yes p) _ = p
  dec-satya (no  _) e = ⊥-elim (false≢true e)

  sarva : (k : ℕ) → (ℕ → Bool) → Bool
  sarva zero    f = true
  sarva (suc k) f = sarva k f and f k

  and-satya : (a b : Bool) → a and b ≡ true → (a ≡ true) × (b ≡ true)
  and-satya true  true  _ = refl , refl
  and-satya true  false e = ⊥-elim (false≢true e)
  and-satya false true  e = ⊥-elim (false≢true e)
  and-satya false false e = ⊥-elim (false≢true e)

  sarva-satya : (k : ℕ) (f : ℕ → Bool) → sarva k f ≡ true → (i : ℕ) → i <ℕ k → f i ≡ true
  sarva-satya zero    f _ i lt = ⊥-elim (¬-<-zero lt)
  sarva-satya (suc k) f e i lt with discreteℕ i k
  ... | yes p = subst (λ z → f z ≡ true) (sym p) (snd (and-satya (sarva k f) (f k) e))
  ... | no ¬p = sarva-satya k f (fst (and-satya (sarva k f) (f k) e)) i (suc-le i k lt ¬p)
    where
    suc-le : (i k : ℕ) → i <ℕ suc k → ¬ (i ≡ k) → i <ℕ k
    suc-le i k lt ne with pred-≤-pred lt
    ... | (zero  , q) = ⊥-elim (ne q)
    ... | (suc j , q) = j , (+-suc j i ∙ q)

  -- the certificate check
  sādhya : Bool
  sādhya = sarva n (λ i → sarva n (λ j → dec→bool (discreteℚ (A i j) (Σ⟨ n ⟩ (λ k → (L i k · D k) · L j k)))))
           and sarva n (λ k → dec→bool (≤Dec 0 (D k)))

  sādhya-ldl : sādhya ≡ true → LDLᵀ
  sādhya-ldl e i j i<n j<n =
    dec-satya (discreteℚ (A i j) _)
      (sarva-satya n _ (sarva-satya n _ (fst (and-satya _ _ e)) i i<n) j j<n)

  sādhya-D : sādhya ≡ true → Anṛṇa-D
  sādhya-D e k k<n = dec-satya (≤Dec 0 (D k)) (sarva-satya n _ (snd (and-satya _ _ e)) k k<n)

  -- THE THEOREM: a certificate that checks is a proof of positivity.
  prāmāṇika-sādhya : sādhya ≡ true → (v : ℕ → ℚ) → 0 ≤ Q v
  prāmāṇika-sādhya e = prāmāṇika (sādhya-ldl e) (sādhya-D e)

------------------------------------------------------------------------
-- ५ · A certificate that checks, by computation: A = [[2,1],[1,2]] with
--     L = [[1,0],[½,1]] and D = (2, 3/2).  sādhya evaluates to true, and
--     the theorem returns positivity of the form for every vector.
------------------------------------------------------------------------

open import Cubical.Data.Int using (pos)
open import Cubical.Data.NatPlusOne using (1+_)

udāharaṇa-A : ℕ → ℕ → ℚ
udāharaṇa-A zero    zero    = 2
udāharaṇa-A zero    (suc _) = 1
udāharaṇa-A (suc _) zero    = 1
udāharaṇa-A (suc _) (suc _) = 2

udāharaṇa-L : ℕ → ℕ → ℚ
udāharaṇa-L zero    zero    = 1
udāharaṇa-L zero    (suc _) = 0
udāharaṇa-L (suc _) zero    = [ pos 1 / 1+ 1 ]
udāharaṇa-L (suc _) (suc _) = 1

udāharaṇa-D : ℕ → ℚ
udāharaṇa-D zero    = 2
udāharaṇa-D (suc _) = [ pos 3 / 1+ 1 ]

udāharaṇa-sādhya : sādhya 2 udāharaṇa-A udāharaṇa-L udāharaṇa-D ≡ true
udāharaṇa-sādhya = refl

udāharaṇa-dhana : (v : ℕ → ℚ) → 0 ≤ Q 2 udāharaṇa-A udāharaṇa-L udāharaṇa-D v
udāharaṇa-dhana = prāmāṇika-sādhya 2 udāharaṇa-A udāharaṇa-L udāharaṇa-D udāharaṇa-sādhya

------------------------------------------------------------------------
-- ६ · The other side: a vector with vᵀAv < 0, checked by computation, is
--     a witness of indefiniteness — the shape of the oracle's rigorous
--     witnesses that the archimedean part alone is indefinite past L*.
------------------------------------------------------------------------

open import Cubical.Data.Rationals.Order using (_<_ ; <Dec)

ṛṇa-sākṣī : (n : ℕ) (A : ℕ → ℕ → ℚ) (v : ℕ → ℚ)
          → dec→bool n A A (λ _ → 0) (<Dec (Q n A A (λ _ → 0) v) 0) ≡ true
          → Q n A A (λ _ → 0) v < 0
ṛṇa-sākṣī n A v e = dec-satya n A A (λ _ → 0) (<Dec (Q n A A (λ _ → 0) v) 0) e

-- the form of the swap on two modes, [[0,1],[1,0]], is indefinite: v = (1, −1)
viparyaya-A : ℕ → ℕ → ℚ
viparyaya-A zero    zero    = 0
viparyaya-A zero    (suc _) = 1
viparyaya-A (suc _) zero    = 1
viparyaya-A (suc _) (suc _) = 0

viparyaya-v : ℕ → ℚ
viparyaya-v zero    = 1
viparyaya-v (suc _) = -1

viparyaya-ṛṇa : Q 2 viparyaya-A viparyaya-A (λ _ → 0) viparyaya-v < 0
viparyaya-ṛṇa = ṛṇa-sākṣī 2 viparyaya-A viparyaya-v refl
