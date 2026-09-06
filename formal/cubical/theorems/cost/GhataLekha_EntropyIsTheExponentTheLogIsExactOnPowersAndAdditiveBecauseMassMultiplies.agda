{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- घात-लेख — the exponent record.
--
-- THE LOGARITHM, DISCHARGED WITHOUT A REAL NUMBER.  The weighted
-- second law left one residue: "the logarithm turning products into
-- sums."  On the powers of two — the masses of uniform binary
-- systems, which is what counting distinctions produces — the
-- logarithm is EXACT and needs no analysis:
--
--   §1  THE HOM LAW: 2^(m+n) = 2^m · 2^n — sums of exponents are
--       products of masses, by induction and associativity.
--
--   §2  THE LOG IS WELL-DEFINED: the exponential is injective —
--       equal masses, equal exponents — via positivity and the
--       doubling cancellation, so on its image the logarithm is a
--       function, not a choice.
--
--   §3  ENTROPY ADDS: for weights of masses 2^m and 2^n, the
--       independent product has mass 2^(m+n) — the weight calculus's
--       multiplication composed with the hom law.  The entropy OF a
--       uniform system IS its exponent; joining independent systems
--       adds exponents; and this is a theorem of ℕ, with the real
--       logarithm a later interpolation of what is already exact on
--       every system counting distinguishes.
--
-- The second law's ledger closes: distinctions count (the counting
-- law), counts weigh (the weight calculus), weights multiply
-- (independence), and exponents add (this file).  Heat's arithmetic,
-- from the displacement theorem to additive entropy, every step a
-- term.
--
-- SYĀT — THE CLAIM, EXACTLY.  Exactness on powers of two; the
-- interpolation to arbitrary masses (real logarithms) and to
-- non-uniform weights (Shannon proper) are the standing
-- constructions.
------------------------------------------------------------------------

module GhataLekha_EntropyIsTheExponentTheLogIsExactOnPowersAndAdditiveBecauseMassMultiplies where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-suc ; +-zero ; injSuc ; snotz)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥ ; rec)

open import BharaGana_MassIsConservedPermutedAndMultipliedThePreLogarithmicSecondLaw
  using (Bhāra ; māna ; māna² ; _⊠_ ; svātantrya-guṇa ; guṇa-viṣama)

------------------------------------------------------------------------
-- १ · The exponential and its hom law.
------------------------------------------------------------------------

ghāta : ℕ → ℕ
ghāta zero    = 1
ghāta (suc n) = ghāta n + (ghāta n + 0)

dvi-ghāta : (m n : ℕ) → ghāta (m + n) ≡ ghāta m · ghāta n
dvi-ghāta zero    n = sym (+-zero (ghāta n))
dvi-ghāta (suc m) n =
  cong₂ _+_ (dvi-ghāta m n) (cong (_+ 0) (dvi-ghāta m n))
  ∙ cong ((ghāta m · ghāta n) +_) (+-zero (ghāta m · ghāta n))
  ∙ sym (guṇa-viṣama (ghāta m) (ghāta m + 0) (ghāta n)
         ∙ cong ((ghāta m · ghāta n) +_)
                (cong (_· ghāta n) (+-zero (ghāta m))))

------------------------------------------------------------------------
-- २ · The log is well-defined on powers.
------------------------------------------------------------------------

dhana : (n : ℕ) → Σ[ j ∈ ℕ ] ghāta n ≡ suc j
dhana zero    = 0 , refl
dhana (suc n) with dhana n
... | j , p = (j + suc (j + 0)) , cong₂ (λ a b → a + (b + 0)) p p

sama-yugma-inj : (m n : ℕ) → m + m ≡ n + n → m ≡ n
sama-yugma-inj zero    zero    _ = refl
sama-yugma-inj zero    (suc n) p = rec (snotz (sym p))
sama-yugma-inj (suc m) zero    p = rec (snotz p)
sama-yugma-inj (suc m) (suc n) p =
  cong suc (sama-yugma-inj m n
    (injSuc (sym (+-suc m m) ∙ injSuc p ∙ +-suc n n)))

ghāta-inj : (m n : ℕ) → ghāta m ≡ ghāta n → m ≡ n
ghāta-inj zero    zero    _ = refl
ghāta-inj zero    (suc n) p with dhana n
... | j , q = rec (snotz (sym (injSuc (p ∙ cong₂ (λ a b → a + (b + 0)) q q) ∙ +-suc j (j + 0))))
ghāta-inj (suc m) zero    p with dhana m
... | j , q = rec (snotz (sym (injSuc (sym p ∙ cong₂ (λ a b → a + (b + 0)) q q) ∙ +-suc j (j + 0))))
ghāta-inj (suc m) (suc n) p =
  cong suc (ghāta-inj m n
    (sama-yugma-inj (ghāta m) (ghāta n)
      (sym (cong₂ _+_ refl (+-zero (ghāta m))) ∙ p ∙ cong₂ _+_ refl (+-zero (ghāta n)))))

------------------------------------------------------------------------
-- ३ · Entropy adds.
------------------------------------------------------------------------

entropy-yoga : (w v : Bhāra) (m n : ℕ)
             → māna w ≡ ghāta m → māna v ≡ ghāta n
             → māna² (w ⊠ v) ≡ ghāta (m + n)
entropy-yoga w v m n pw pv =
  svātantrya-guṇa w v
  ∙ cong₂ _·_ pw pv
  ∙ sym (dvi-ghāta m n)
