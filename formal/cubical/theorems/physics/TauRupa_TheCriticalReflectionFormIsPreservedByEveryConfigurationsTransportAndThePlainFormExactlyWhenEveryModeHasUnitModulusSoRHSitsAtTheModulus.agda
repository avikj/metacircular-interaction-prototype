{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- τ-रूप — the reflection form.
--
-- The oracle's construction for the prime boundary transport (ORACLE_RH_
-- completion, §§2–4): on the modal space ℓ²(Z, m) of nontrivial zeros
-- the transport is T_t = diag e^{(ρ−½)t}; no inner product makes it
-- unitary unless RH; and Weil's form is the ℓ² form twisted by the
-- critical-line reflection τ : ρ ↦ 1 − ρ̄, under which T_t is
-- τ-unitary for every t unconditionally, the negative index being
-- exactly the number of off-line zeros.  RH is τ = 1: the τ-form is the
-- plain form, T_t is unitary, every mode has unit modulus.
--
-- The finite algebra of that picture, over any commutative *-ring with
-- a half, on a finite configuration of modes with an involution τ:
--
--   §1  SUMS over a finite index range, valued in the ring; pointwise
--       extensionality; the sum of a function supported at one index.
--   §2  THE *-RING and the two forms: plain ⟨c,d⟩ = Σ (c i)* d i and the
--       τ-form [c,d] = Σ (c i)* d (τ i).
--   §3  THE TWO-CYCLE SPLITTING.  On a τ-2-cycle the form is
--       a* b + b* a = ½ (a+b)*(a+b) − ½ (a−b)*(a−b): one positive and one
--       negative square — the Krein index counts the 2-cycles.
--   §4  THE TRANSPORT.  E with E i · (E (τ i))* = 1 (the reflection law
--       e^{(ρ−½)t} e^{(½−ρ)t} = 1) preserves the τ-form for EVERY
--       configuration: τ-unitarity is unconditional.
--   §5  WHERE RH SITS.  E preserves the plain form for all vectors
--       exactly when every mode has unit modulus, (E i)* E i = 1 — for
--       E = e^{(ρ−½)t} that is Re ρ = ½.  The equivalence is finite
--       algebra; the inequality (W) that would supply it is the analytic
--       boundary.
--
-- रूप (rūpa, form) is ordinary Sanskrit.
------------------------------------------------------------------------

module TauRupa_TheCriticalReflectionFormIsPreservedByEveryConfigurationsTransportAndThePlainFormExactlyWhenEveryModeHasUnitModulusSoRHSitsAtTheModulus where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ ; +-suc ; +-zero) renaming (_+_ to _+ℕ_)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; <-weaken ; <≤-trans ; ¬m<m ; ≤SumLeft ; zero-≤)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- २ (first) · The *-ring.
------------------------------------------------------------------------

record StarRing (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    R     : CommRing ℓ
  open CommRingStr (snd R) public
  field
    _✶    : ⟨ R ⟩ → ⟨ R ⟩
    ✶-inv : (x : ⟨ R ⟩) → (x ✶) ✶ ≡ x
    ✶-add : (x y : ⟨ R ⟩) → (x + y) ✶ ≡ x ✶ + y ✶
    ✶-mul : (x y : ⟨ R ⟩) → (x · y) ✶ ≡ x ✶ · y ✶
    ✶-neg : (x : ⟨ R ⟩) → (- x) ✶ ≡ - (x ✶)
    ✶-one : 1r ✶ ≡ 1r
    half  : ⟨ R ⟩
    half2 : half + half ≡ 1r

module _ (S : StarRing ℓ) where
  open StarRing S

  ----------------------------------------------------------------------
  -- १ · Ring-valued sums over [s, s + n).
  ----------------------------------------------------------------------

  Σᵣ⟨_,_⟩ : ℕ → ℕ → (ℕ → ⟨ R ⟩) → ⟨ R ⟩
  Σᵣ⟨ s , zero ⟩ f = 0r
  Σᵣ⟨ s , suc n ⟩ f = f s + Σᵣ⟨ suc s , n ⟩ f

  Σᵣ-ext : (s n : ℕ) (f g : ℕ → ⟨ R ⟩) → ((i : ℕ) → f i ≡ g i) → Σᵣ⟨ s , n ⟩ f ≡ Σᵣ⟨ s , n ⟩ g
  Σᵣ-ext s zero    f g e = refl
  Σᵣ-ext s (suc n) f g e = cong₂ _+_ (e s) (Σᵣ-ext (suc s) n f g e)

  Σᵣ-zero : (s n : ℕ) (f : ℕ → ⟨ R ⟩) → ((i : ℕ) → s ≤ i → f i ≡ 0r) → Σᵣ⟨ s , n ⟩ f ≡ 0r
  Σᵣ-zero s zero    f v = refl
  Σᵣ-zero s (suc n) f v =
    cong₂ _+_ (v s ≤-refl) (Σᵣ-zero (suc s) n f (λ i le → v i (<-weaken le))) ∙ +IdR 0r

  -- a function supported at one index i in [s, s + n) sums to its value there
  Σᵣ-eka : (s n i : ℕ) (f : ℕ → ⟨ R ⟩) → s ≤ i → i < s +ℕ n
         → ((j : ℕ) → ¬ (j ≡ i) → f j ≡ 0r) → Σᵣ⟨ s , n ⟩ f ≡ f i
  Σᵣ-eka s zero    i f le lt off =
    ⊥-elim (¬m<m (<≤-trans lt (subst (_≤ i) (sym (+-zero s)) le)))
  Σᵣ-eka s (suc n) i f le lt off with discreteℕ s i
  ... | yes p = cong (f s +_) (Σᵣ-zero (suc s) n f tail) ∙ +IdR (f s) ∙ cong f p
    where
    tail : (j : ℕ) → suc s ≤ j → f j ≡ 0r
    tail j sj = off j (λ q → ¬m<m (subst (λ z → suc i ≤ z) q (subst (λ z → suc z ≤ j) p sj)))
  ... | no ¬p = cong (_+ Σᵣ⟨ suc s , n ⟩ f) (off s ¬p) ∙ +IdL _
              ∙ Σᵣ-eka (suc s) n i f (suc-le le ¬p) (subst (i <_) (+-suc s n) lt) off
    where
    suc-le : s ≤ i → ¬ (s ≡ i) → suc s ≤ i
    suc-le (zero  , e) ne = ⊥-elim (ne e)
    suc-le (suc k , e) ne = k , (+-suc k s ∙ e)

  ----------------------------------------------------------------------
  -- २ · The plain form and the τ-form on a configuration of n modes.
  ----------------------------------------------------------------------

  Vec : Type ℓ
  Vec = ℕ → ⟨ R ⟩

  module _ (n : ℕ) (τ : ℕ → ℕ) where

    plain : Vec → Vec → ⟨ R ⟩
    plain c d = Σᵣ⟨ zero , n ⟩ (λ i → (c i) ✶ · d i)

    τ-rūpa : Vec → Vec → ⟨ R ⟩
    τ-rūpa c d = Σᵣ⟨ zero , n ⟩ (λ i → (c i) ✶ · d (τ i))

    --------------------------------------------------------------------
    -- ३ · The two-cycle splitting.
    --------------------------------------------------------------------

    -- a* b + b* a = ½ (a+b)*(a+b) − ½ (a−b)*(a−b)
    dvi-cakra : (a b : ⟨ R ⟩)
              → (a ✶) · b + (b ✶) · a
              ≡ half · ((a + b) ✶ · (a + b)) - half · ((a - b) ✶ · (a - b))
    dvi-cakra a b =
        sym (·IdL _)
      ∙ cong (_· ((a ✶) · b + (b ✶) · a)) (sym half2)
      ∙ vistāra (a ✶) (b ✶) a b half
      ∙ cong₂ (λ u v → half · (u · (a + b)) - half · (v · (a - b)))
              (sym (✶-add a b))
              (sym (✶-add a (- b) ∙ cong (a ✶ +_) (✶-neg b)))
      where
      -- the pure ring identity, with a*, b* as atoms
      vistāra : (p q a b h : ⟨ R ⟩)
              → (h + h) · (p · b + q · a) ≡ h · ((p + q) · (a + b)) - h · ((p - q) · (a - b))
      vistāra p q a b h = solve! R

    --------------------------------------------------------------------
    -- ४ · The transport preserves the τ-form for every configuration.
    --------------------------------------------------------------------

    record Saṅkramaṇa : Type ℓ where
      field
        E       : ℕ → ⟨ R ⟩
        reflect : (i : ℕ) → E i · (E (τ i)) ✶ ≡ 1r
    open Saṅkramaṇa

    apply : Saṅkramaṇa → Vec → Vec
    apply T c i = E T i · c i

    -- the reflection law, starred: (E i)* · E (τ i) = 1
    reflect✶ : (T : Saṅkramaṇa) (i : ℕ) → (E T i) ✶ · E T (τ i) ≡ 1r
    reflect✶ T i =
        cong (λ z → (E T i) ✶ · z) (sym (✶-inv (E T (τ i))))
      ∙ sym (✶-mul (E T i) ((E T (τ i)) ✶))
      ∙ cong _✶ (reflect T i)
      ∙ ✶-one

    τ-avikāra : (T : Saṅkramaṇa) (c d : Vec)
              → τ-rūpa (apply T c) (apply T d) ≡ τ-rūpa c d
    τ-avikāra T c d = Σᵣ-ext zero n _ _ pada
      where
      pada : (i : ℕ) → ((E T i · c i) ✶) · (E T (τ i) · d (τ i)) ≡ (c i) ✶ · d (τ i)
      pada i =
          cong (_· (E T (τ i) · d (τ i))) (✶-mul (E T i) (c i))
        ∙ punar ((E T i) ✶) ((c i) ✶) (E T (τ i)) (d (τ i))
        ∙ cong (λ z → z · ((c i) ✶ · d (τ i))) (reflect✶ T i)
        ∙ ·IdL _
        where
        punar : (e c′ e′ d′ : ⟨ R ⟩) → (e · c′) · (e′ · d′) ≡ (e · e′) · (c′ · d′)
        punar e c′ e′ d′ = solve! R

    --------------------------------------------------------------------
    -- ५ · Where RH sits: the plain form is preserved exactly at unit modulus.
    --------------------------------------------------------------------

    UnitModulus : Saṅkramaṇa → Type ℓ
    UnitModulus T = (i : ℕ) → i < n → (E T i) ✶ · E T i ≡ 1r

    PlainUnitary : Saṅkramaṇa → Type ℓ
    PlainUnitary T = (c d : Vec) → plain (apply T c) (apply T d) ≡ plain c d

    -- unit modulus gives plain unitarity, pointwise
    modulus→unitary : (T : Saṅkramaṇa) → UnitModulus T → PlainUnitary T
    modulus→unitary T um c d = go zero n ≤-refl
      where
      -- summands agree for every i < n; the sum runs over [0, n)
      pada : (i : ℕ) → i < n → ((E T i · c i) ✶) · (E T i · d i) ≡ (c i) ✶ · d i
      pada i lt =
          cong (_· (E T i · d i)) (✶-mul (E T i) (c i))
        ∙ punar ((E T i) ✶) ((c i) ✶) (E T i) (d i)
        ∙ cong (λ z → z · ((c i) ✶ · d i)) (um i lt)
        ∙ ·IdL _
        where
        punar : (e c′ e′ d′ : ⟨ R ⟩) → (e · c′) · (e′ · d′) ≡ (e · e′) · (c′ · d′)
        punar e c′ e′ d′ = solve! R
      go : (s m : ℕ) → s +ℕ m ≤ n
         → Σᵣ⟨ s , m ⟩ (λ i → ((E T i · c i) ✶) · (E T i · d i)) ≡ Σᵣ⟨ s , m ⟩ (λ i → (c i) ✶ · d i)
      go s zero    _  = refl
      go s (suc m) le = cong₂ _+_ (pada s (≤-trans (≤SumLeft {n = suc s} {k = m}) le′)) (go (suc s) m le′)
        where
        le′ : suc (s +ℕ m) ≤ n
        le′ = subst (_≤ n) (+-suc s m) le

    -- the delta vector at a mode
    δ : ℕ → Vec
    δ i j with discreteℕ j i
    ... | yes _ = 1r
    ... | no  _ = 0r

    δ-sama : (i : ℕ) → δ i i ≡ 1r
    δ-sama i with discreteℕ i i
    ... | yes _ = refl
    ... | no ¬p = ⊥-elim (¬p refl)

    δ-anya : (i j : ℕ) → ¬ (j ≡ i) → δ i j ≡ 0r
    δ-anya i j ne with discreteℕ j i
    ... | yes p = ⊥-elim (ne p)
    ... | no  _ = refl

    -- plain unitarity, tested on the delta vectors, gives unit modulus
    unitary→modulus : (T : Saṅkramaṇa) → PlainUnitary T → UnitModulus T
    unitary→modulus T pu i lt =
        cong (λ z → z ✶ · z) (sym (·IdR (E T i)))
      ∙ cong (λ z → (E T i · z) ✶ · (E T i · z)) (sym (δ-sama i))
      ∙ sym (Σᵣ-eka zero n i _ zero-≤ lt off-L)
      ∙ pu (δ i) (δ i)
      ∙ Σᵣ-eka zero n i _ zero-≤ lt off-R
      ∙ cong (λ z → z ✶ · z) (δ-sama i)
      ∙ cong (_· 1r) ✶-one
      ∙ ·IdL 1r
      where
      śūnya : (e : ⟨ R ⟩) → e · 0r ≡ 0r
      śūnya e = solve! R
      śūnya′ : (x : ⟨ R ⟩) → x · 0r ≡ 0r
      śūnya′ x = solve! R
      off-L : (j : ℕ) → ¬ (j ≡ i) → (E T j · δ i j) ✶ · (E T j · δ i j) ≡ 0r
      off-L j ne = cong (λ z → (E T j · z) ✶ · (E T j · z)) (δ-anya i j ne)
                 ∙ cong (λ z → (z ✶) · z) (śūnya (E T j)) ∙ śūnya′ (0r ✶)
      off-R : (j : ℕ) → ¬ (j ≡ i) → (δ i j) ✶ · δ i j ≡ 0r
      off-R j ne = cong (λ z → (z ✶) · z) (δ-anya i j ne) ∙ śūnya′ (0r ✶)
