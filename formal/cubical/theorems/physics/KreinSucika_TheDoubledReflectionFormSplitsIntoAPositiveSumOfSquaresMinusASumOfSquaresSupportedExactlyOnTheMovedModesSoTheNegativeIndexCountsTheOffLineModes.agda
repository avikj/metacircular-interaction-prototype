{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- क्रेइन-सूचिका — the Krein index.
--
-- WeilDhanatva proved the finite Weil criterion: the τ-form is positive
-- iff every mode is τ-fixed.  This file gives the form's full signature.
-- Doubling and folding along the involution τ,
--
--   (1+1)·[c,c]  =  Σ_i ½ (c_i + c_{τi})*(c_i + c_{τi})
--                 − Σ_i ½ (c_i − c_{τi})*(c_i − c_{τi}),
--
-- and the second sum's summand vanishes at every τ-fixed mode.  So the
-- negative part of the form is supported exactly on the moved modes —
-- the off-line zeros — and on a fixed configuration it is 0.
--
--   §1  SUM ALGEBRA.  Pointwise sums, scalar factors, shifting the
--       offset, and interchanging a double sum.
--   §2  REINDEXING BY THE INVOLUTION.  Σ_{i<n} g (τ i) ≡ Σ_{i<n} g i when
--       τ is an involution closed on [0,n): every j is hit once, at τ j.
--       Proved through the indicator ι and the interchange.
--   §3  THE SPLITTING.  Fold the form along τ, apply dvi-cakra termwise.
--   §4  THE NEGATIVE PART.  Its summand is 0 at a fixed mode; on a fixed
--       configuration the whole negative part is 0.
--
-- सूचिका (sūcikā, index/pointer) is ordinary Sanskrit.
------------------------------------------------------------------------

module KreinSucika_TheDoubledReflectionFormSplitsIntoAPositiveSumOfSquaresMinusASumOfSquaresSupportedExactlyOnTheMovedModesSoTheNegativeIndexCountsTheOffLineModes where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ ; +-suc ; +-zero) renaming (_+_ to _+ℕ_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; <-weaken ; <≤-trans ; ¬m<m ; ≤SumLeft ; zero-≤)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

open import TauRupa_TheCriticalReflectionFormIsPreservedByEveryConfigurationsTransportAndThePlainFormExactlyWhenEveryModeHasUnitModulusSoRHSitsAtTheModulus
  using (StarRing)
import TauRupa_TheCriticalReflectionFormIsPreservedByEveryConfigurationsTransportAndThePlainFormExactlyWhenEveryModeHasUnitModulusSoRHSitsAtTheModulus
  as T
import WeilDhanatva_TheReflectionFormIsPositiveOnEveryVectorExactlyWhenEveryModeIsFixedByTheReflectionSoFiniteWeilPositivityIsFiniteRH
  as W

private
  variable
    ℓ : Level

module _ (S : StarRing ℓ) where
  open StarRing S

  Σᵣ⟨_,_⟩ : ℕ → ℕ → (ℕ → ⟨ R ⟩) → ⟨ R ⟩
  Σᵣ⟨ s , m ⟩ f = T.Σᵣ⟨_,_⟩ S s m f

  Σᵣ-ext = T.Σᵣ-ext S
  Σᵣ-eka′ = W.Σᵣ-eka′ S
  Vec = T.Vec S
  τ-rūpa = T.τ-rūpa S
  dvi-cakra = T.dvi-cakra S

  ----------------------------------------------------------------------
  -- १ · Sum algebra.
  ----------------------------------------------------------------------

  Σᵣ-add : (s m : ℕ) (f g : ℕ → ⟨ R ⟩)
         → Σᵣ⟨ s , m ⟩ (λ i → f i + g i) ≡ Σᵣ⟨ s , m ⟩ f + Σᵣ⟨ s , m ⟩ g
  Σᵣ-add s zero    f g = sym (+IdR 0r)
  Σᵣ-add s (suc m) f g = cong ((f s + g s) +_) (Σᵣ-add (suc s) m f g) ∙ punar _ _ _ _
    where
    punar : (a b x y : ⟨ R ⟩) → (a + b) + (x + y) ≡ (a + x) + (b + y)
    punar a b x y = solve! R

  Σᵣ-sub : (s m : ℕ) (f g : ℕ → ⟨ R ⟩)
         → Σᵣ⟨ s , m ⟩ (λ i → f i - g i) ≡ Σᵣ⟨ s , m ⟩ f - Σᵣ⟨ s , m ⟩ g
  Σᵣ-sub s zero    f g = lemma
    where lemma : 0r ≡ 0r - 0r
          lemma = solve! R
  Σᵣ-sub s (suc m) f g = cong ((f s - g s) +_) (Σᵣ-sub (suc s) m f g) ∙ punar _ _ _ _
    where
    punar : (a b x y : ⟨ R ⟩) → (a - b) + (x - y) ≡ (a + x) - (b + y)
    punar a b x y = solve! R

  Σᵣ-scale : (s m : ℕ) (k : ⟨ R ⟩) (f : ℕ → ⟨ R ⟩)
           → Σᵣ⟨ s , m ⟩ (λ i → k · f i) ≡ k · Σᵣ⟨ s , m ⟩ f
  Σᵣ-scale s zero    k f = sym (śūnya k) where śūnya : (k : ⟨ R ⟩) → k · 0r ≡ 0r
                                               śūnya k = solve! R
  Σᵣ-scale s (suc m) k f = cong (k · f s +_) (Σᵣ-scale (suc s) m k f) ∙ sym (·DistR+ k (f s) _)

  -- shifting the offset into the summand
  Σᵣ-shift : (s m : ℕ) (f : ℕ → ⟨ R ⟩) → Σᵣ⟨ suc s , m ⟩ f ≡ Σᵣ⟨ s , m ⟩ (λ i → f (suc i))
  Σᵣ-shift s zero    f = refl
  Σᵣ-shift s (suc m) f = cong (f (suc s) +_) (Σᵣ-shift (suc s) m f)

  -- interchanging a double sum over [0,n) × [0,m)
  Σᵣ-swap : (n m : ℕ) (F : ℕ → ℕ → ⟨ R ⟩)
          → Σᵣ⟨ zero , n ⟩ (λ i → Σᵣ⟨ zero , m ⟩ (λ j → F i j))
          ≡ Σᵣ⟨ zero , m ⟩ (λ j → Σᵣ⟨ zero , n ⟩ (λ i → F i j))
  Σᵣ-swap zero    m F = sym (Σᵣ-zero′ zero m)
    where
    Σᵣ-zero′ : (s m : ℕ) → Σᵣ⟨ s , m ⟩ (λ _ → 0r) ≡ 0r
    Σᵣ-zero′ s zero    = refl
    Σᵣ-zero′ s (suc m) = +IdL _ ∙ Σᵣ-zero′ (suc s) m
  Σᵣ-swap (suc n) m F =
      cong (Σᵣ⟨ zero , m ⟩ (λ j → F zero j) +_)
           (Σᵣ-shift zero n _ ∙ Σᵣ-swap n m (λ i j → F (suc i) j))
    ∙ sym (Σᵣ-add zero m _ _)
    ∙ Σᵣ-ext zero m _ _ (λ j → cong (F zero j +_) (sym (Σᵣ-shift zero n (λ i → F i j))))

  ----------------------------------------------------------------------
  -- २ · Reindexing a range sum by an involution closed on the range.
  ----------------------------------------------------------------------

  -- the indicator of i ≡ j
  ι : ℕ → ℕ → ⟨ R ⟩
  ι i j with discreteℕ i j
  ... | yes _ = 1r
  ... | no  _ = 0r

  ι-sama : (i : ℕ) → ι i i ≡ 1r
  ι-sama i with discreteℕ i i
  ... | yes _ = refl
  ... | no ¬p = ⊥-elim (¬p refl)

  ι-anya : (i j : ℕ) → ¬ (i ≡ j) → ι i j ≡ 0r
  ι-anya i j ne with discreteℕ i j
  ... | yes p = ⊥-elim (ne p)
  ... | no  _ = refl

  module _ (n : ℕ) (τ : ℕ → ℕ) (closed : W.Antaḥ S n τ) (invol : W.Parivartana S n τ) where

    -- range-restricted extensionality over [0,n)
    Σᵣ-ext< : (f g : ℕ → ⟨ R ⟩) → ((i : ℕ) → i < n → f i ≡ g i)
            → Σᵣ⟨ zero , n ⟩ f ≡ Σᵣ⟨ zero , n ⟩ g
    Σᵣ-ext< = W.Σᵣ-ext< S n τ

    -- Σ_j ι (τ i) j · g j = g (τ i), for i < n
    ι-vāma : (g : ℕ → ⟨ R ⟩) (i : ℕ) → i < n
           → Σᵣ⟨ zero , n ⟩ (λ j → ι (τ i) j · g j) ≡ g (τ i)
    ι-vāma g i lt =
        Σᵣ-eka′ zero n (τ i) _ zero-≤ (closed i lt)
                (λ k _ ne → cong (_· g k) (ι-anya (τ i) k (λ p → ne (sym p))) ∙ śūnya (g k))
      ∙ cong (_· g (τ i)) (ι-sama (τ i)) ∙ ·IdL _
      where śūnya : (x : ⟨ R ⟩) → 0r · x ≡ 0r
            śūnya x = solve! R

    -- one-point support with vanishing demanded only below n
    Σᵣ-eka< : (i : ℕ) (f : ℕ → ⟨ R ⟩) → i < n
            → ((k : ℕ) → k < n → ¬ (k ≡ i) → f k ≡ 0r) → Σᵣ⟨ zero , n ⟩ f ≡ f i
    Σᵣ-eka< i f lt off =
        Σᵣ-ext< f (λ k → ι i k · f k) same
      ∙ Σᵣ-eka′ zero n i _ zero-≤ lt (λ k _ ne → cong (_· f k) (ι-anya i k (λ p → ne (sym p))) ∙ śūnya (f k))
      ∙ cong (_· f i) (ι-sama i) ∙ ·IdL _
      where
      śūnya : (x : ⟨ R ⟩) → 0r · x ≡ 0r
      śūnya x = solve! R
      same : (k : ℕ) → k < n → f k ≡ ι i k · f k
      same k kn with discreteℕ k i
      ... | yes q = sym (cong (_· f k) (cong (λ z → ι i z) q ∙ ι-sama i) ∙ ·IdL _)
      ... | no ne = off k kn ne ∙ sym (cong (_· f k) (ι-anya i k (λ p → ne (sym p))) ∙ śūnya (f k))

    -- Σ_i ι (τ i) j · g j = g j, for j < n: the one i hitting j is τ j
    ι-dakṣiṇa : (g : ℕ → ⟨ R ⟩) (j : ℕ) → j < n
              → Σᵣ⟨ zero , n ⟩ (λ i → ι (τ i) j · g j) ≡ g j
    ι-dakṣiṇa g j lt =
        Σᵣ-eka< (τ j) _ (closed j lt)
                (λ k kn ne → cong (_· g j) (ι-anya (τ k) j (λ p → ne (sym (invol k kn) ∙ cong τ p)))
                             ∙ śūnya (g j))
      ∙ cong (_· g j) (cong (λ z → ι z j) (invol j lt) ∙ ι-sama j) ∙ ·IdL _
      where śūnya : (x : ⟨ R ⟩) → 0r · x ≡ 0r
            śūnya x = solve! R

    -- the reindexing theorem
    parivartana-sama : (g : ℕ → ⟨ R ⟩)
                     → Σᵣ⟨ zero , n ⟩ (λ i → g (τ i)) ≡ Σᵣ⟨ zero , n ⟩ g
    parivartana-sama g =
        Σᵣ-ext< _ _ (λ i lt → sym (ι-vāma g i lt))
      ∙ Σᵣ-swap n n (λ i j → ι (τ i) j · g j)
      ∙ Σᵣ-ext< _ _ (λ j lt → ι-dakṣiṇa g j lt)

    --------------------------------------------------------------------
    -- ३ · The splitting of the doubled form.
    --------------------------------------------------------------------

    -- the positive and negative parts
    dhana : Vec → ⟨ R ⟩
    dhana c = Σᵣ⟨ zero , n ⟩ (λ i → half · ((c i + c (τ i)) ✶ · (c i + c (τ i))))

    ṛṇa : Vec → ⟨ R ⟩
    ṛṇa c = Σᵣ⟨ zero , n ⟩ (λ i → half · ((c i - c (τ i)) ✶ · (c i - c (τ i))))

    -- folding the form along τ: [c,c] + [c,c] = Σ_i (c_i* c_τi + c_τi* c_i)
    saṃvalana : (c : Vec)
              → τ-rūpa n τ c c + τ-rūpa n τ c c
              ≡ Σᵣ⟨ zero , n ⟩ (λ i → (c i) ✶ · c (τ i) + (c (τ i)) ✶ · c i)
    saṃvalana c =
        cong (τ-rūpa n τ c c +_) (sym (parivartana-sama (λ i → (c i) ✶ · c (τ i))))
      ∙ sym (Σᵣ-add zero n _ _)
      ∙ Σᵣ-ext< _ _ (λ i lt → cong (λ z → (c i) ✶ · c (τ i) + (c (τ i)) ✶ · c z) (invol i lt))

    krein-sūcikā : (c : Vec) → (1r + 1r) · τ-rūpa n τ c c ≡ dhana c - ṛṇa c
    krein-sūcikā c =
        dviguṇa (τ-rūpa n τ c c)
      ∙ saṃvalana c
      ∙ Σᵣ-ext zero n _ _ (λ i → dvi-cakra n τ (c i) (c (τ i)))
      ∙ Σᵣ-sub zero n _ _
      where
      dviguṇa : (x : ⟨ R ⟩) → (1r + 1r) · x ≡ x + x
      dviguṇa x = solve! R

    --------------------------------------------------------------------
    -- ४ · The negative part lives on the moved modes.
    --------------------------------------------------------------------

    -- at a fixed mode the negative summand is 0
    ṛṇa-pada-śūnya : (c : Vec) (i : ℕ) → τ i ≡ i
                   → half · ((c i - c (τ i)) ✶ · (c i - c (τ i))) ≡ 0r
    ṛṇa-pada-śūnya c i fix =
        cong (λ z → half · ((c i - c z) ✶ · (c i - c z))) fix
      ∙ cong (λ z → half · (z ✶ · z)) (svayaṃ (c i))
      ∙ cong (λ z → half · (z · 0r)) ✶-zero
      ∙ lemma
      where
      ✶-zero = W.✶-zero S
      svayaṃ : (x : ⟨ R ⟩) → x - x ≡ 0r
      svayaṃ x = solve! R
      lemma : half · (0r · 0r) ≡ 0r
      lemma = solve! R

    -- on a fixed configuration the negative part vanishes and the doubled
    -- form is the positive sum of squares alone
    sthira-ṛṇa-śūnya : W.Sthira S n τ → (c : Vec) → ṛṇa c ≡ 0r
    sthira-ṛṇa-śūnya fix c = Σᵣ-ext< _ _ (λ i lt → ṛṇa-pada-śūnya c i (fix i lt)) ∙ Σᵣ-zero′ zero n
      where
      Σᵣ-zero′ : (s m : ℕ) → Σᵣ⟨ s , m ⟩ (λ _ → 0r) ≡ 0r
      Σᵣ-zero′ s zero    = refl
      Σᵣ-zero′ s (suc m) = +IdL _ ∙ Σᵣ-zero′ (suc s) m

    sthira-kevala-dhana : W.Sthira S n τ → (c : Vec) → (1r + 1r) · τ-rūpa n τ c c ≡ dhana c
    sthira-kevala-dhana fix c =
        krein-sūcikā c ∙ cong (λ z → dhana c - z) (sthira-ṛṇa-śūnya fix c) ∙ lemma (dhana c)
      where
      lemma : (x : ⟨ R ⟩) → x - 0r ≡ x
      lemma x = solve! R
