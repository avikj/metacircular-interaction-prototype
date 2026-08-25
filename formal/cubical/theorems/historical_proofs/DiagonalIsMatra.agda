{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DiagonalIsMatra
--
-- The identity the Sankalita thread left open:
--
--     mātrā n  ≡  Σ_{a+b=n} meru a b
--
-- Virahāṅka's mātrāmeru (c. 600–800) is the shallow diagonal of Piṅgala's
-- meru-prastāra (c. 300–200 BCE).  Both arrays were already in this
-- repository; the identity between them was not.
--
-- ────────────────────────────────────────────────────────────────────
-- HOW IT GOES, AFTER FOUR ENCODINGS
--
-- `Sankalita` §§8–13 refuted three numeric encodings, each for a
-- different reason, and left Piṅgala's own: sort the patterns by
-- syllable count.  `DurationIsSyllablesPlusGuru` carried that to an
-- equivalence, `PairsSummingTo` made the index set finite structurally,
-- and this file takes cardinalities.
--
-- The shifted family is what makes the induction close:
--
--     SortedC c n  =  Σ[ ((a,b),_) ∈ Pairs n ]  Chosen (c + a) b
--
-- with `SortedC c 0 ≃ Chosen c 0` and
-- `SortedC c (suc n) ≃ Chosen c (suc n) ⊎ SortedC (suc c) n`, matching
-- `Sankalita.AD` step for step.  `AD` walks the first index up and the
-- second down; so does the peeling of `Pairs`.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS USED, ALL PRIOR ART
--
--   `Pingala.meruCount`         Chosen n k ≃ Fin (meru n k)
--   `Pingala.matraCount`        Metre n ≃ Fin (mātrā n)
--   `PairsSummingTo.pairsSuc-Iso`
--   `DurationIsSyllablesPlusGuru.metre-sorts`
--   `Cubical.Data.Sigma`        Σ-contractFst, Σ-cong-equiv-fst/snd
--   `Cubical.Data.Sum`          Σ⊎≃
--   `Cubical.Data.SumFin`       SumFin⊎≃, SumFin≃Fin
--
-- Nothing new is proved about arrays; the content is the assembly.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module DiagonalIsMatra where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; invEquiv ; idEquiv)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr ; Σ⊎≃)
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit)
open import Cubical.Data.SumFin using (SumFin⊎≃ ; SumFin≃Fin) renaming (Fin to SFin)

open import PingalaPrastara using (Chosen ; meru ; meruCount ; Metre ; matra ; matraCount)
open import Sankalita using (AD ; antidiag)
open import PairsSummingTo using (Pairs ; pairsSuc-Iso ; pairs0-Iso)
open import DurationIsSyllablesPlusGuru using (Sorted ; metre-sorts)

------------------------------------------------------------------------
-- 1.  Chosen, as a SumFin
------------------------------------------------------------------------

chosenFin : (a b : ℕ) → Chosen a b ≃ SFin (meru a b)
chosenFin a b =
  compEquiv (isoToEquiv (meruCount a b)) (invEquiv (SumFin≃Fin (meru a b)))

------------------------------------------------------------------------
-- 2.  The shifted family, and its two structural equivalences
------------------------------------------------------------------------

SortedC : ℕ → ℕ → Type
SortedC c n = Σ[ p ∈ Pairs n ] Chosen (c + fst (fst p)) (snd (fst p))

-- base: Pairs 0 is contractible at ((0,0), refl)
isContrPairs0 : isContr (Pairs 0)
isContrPairs0 = ((0 , 0) , refl) , λ p → Iso.leftInv pairs0-Iso p

sortedC0 : (c : ℕ) → SortedC c 0 ≃ Chosen (c + 0) 0
sortedC0 c = Σ-contractFst isContrPairs0

-- step: peel the a = 0 pair, and the rest shifts the offset up by one
sortedCsuc : (c n : ℕ) → SortedC c (suc n) ≃ (Chosen (c + 0) (suc n) ⊎ SortedC (suc c) n)
sortedCsuc c n =
  compEquiv
    (invEquiv (Σ-cong-equiv-fst (invEquiv (isoToEquiv (pairsSuc-Iso n)))))
    (compEquiv Σ⊎≃
      (⊎Equiv (Σ-contractFst isContrUnit) shift))
  where
  ⊎Equiv : {A B C D : Type} → A ≃ B → C ≃ D → (A ⊎ C) ≃ (B ⊎ D)
  ⊎Equiv e f = isoToEquiv is
    where
    open import Cubical.Foundations.Equiv using (equivFun ; invEq ; retEq ; secEq)
    is : Iso _ _
    Iso.fun is (inl a) = inl (equivFun e a)
    Iso.fun is (inr c) = inr (equivFun f c)
    Iso.inv is (inl b) = inl (invEq e b)
    Iso.inv is (inr d) = inr (invEq f d)
    Iso.rightInv is (inl b) = cong inl (secEq e b)
    Iso.rightInv is (inr d) = cong inr (secEq f d)
    Iso.leftInv  is (inl a) = cong inl (retEq e a)
    Iso.leftInv  is (inr c) = cong inr (retEq f c)

  shift : (Σ[ p ∈ Pairs n ] Chosen (c + suc (fst (fst p))) (snd (fst p))) ≃ SortedC (suc c) n
  shift = Σ-cong-equiv-snd
            (λ p → pathToEquiv (cong (λ z → Chosen z (snd (fst p)))
                                     (+-suc c (fst (fst p)))))

------------------------------------------------------------------------
-- 3.  The shifted family counted
------------------------------------------------------------------------

sortedCFin : (c n : ℕ) → SortedC c n ≃ SFin (AD c n)
sortedCFin c zero =
  compEquiv (sortedC0 c)
    (compEquiv (pathToEquiv (cong (λ z → Chosen z 0) (+-zero c)))
               (chosenFin c 0))
sortedCFin c (suc n) =
  compEquiv (sortedCsuc c n)
    (compEquiv
      (⊎E (compEquiv (pathToEquiv (cong (λ z → Chosen z (suc n)) (+-zero c)))
                     (chosenFin c (suc n)))
          (sortedCFin (suc c) n))
      (SumFin⊎≃ (meru c (suc n)) (AD (suc c) n)))
  where
  ⊎E : {A B C D : Type} → A ≃ B → C ≃ D → (A ⊎ C) ≃ (B ⊎ D)
  ⊎E e f = isoToEquiv is
    where
    open import Cubical.Foundations.Equiv using (equivFun ; invEq ; retEq ; secEq)
    is : Iso _ _
    Iso.fun is (inl a) = inl (equivFun e a)
    Iso.fun is (inr c') = inr (equivFun f c')
    Iso.inv is (inl b) = inl (invEq e b)
    Iso.inv is (inr d) = inr (invEq f d)
    Iso.rightInv is (inl b) = cong inl (secEq e b)
    Iso.rightInv is (inr d) = cong inr (secEq f d)
    Iso.leftInv  is (inl a) = cong inl (retEq e a)
    Iso.leftInv  is (inr c') = cong inr (retEq f c')

------------------------------------------------------------------------
-- 4.  The unshifted case is the antidiagonal
------------------------------------------------------------------------

sortedIsSortedC0 : (n : ℕ) → Sorted n ≃ SortedC 0 n
sortedIsSortedC0 n = invEquiv Σ-assoc-≃

metreFin : (n : ℕ) → Metre n ≃ SFin (antidiag n)
metreFin n =
  compEquiv (metre-sorts n)
    (compEquiv (sortedIsSortedC0 n) (sortedCFin 0 n))

------------------------------------------------------------------------
-- 5.  THE IDENTITY, by comparing the two counts of `Metre n`
------------------------------------------------------------------------

metreFin' : (n : ℕ) → Metre n ≃ SFin (matra n)
metreFin' n =
  compEquiv (isoToEquiv (matraCount n)) (invEquiv (SumFin≃Fin (matra n)))

diagonal-is-matra : (n : ℕ) → matra n ≡ antidiag n
diagonal-is-matra n =
  SumFin-inj (matra n) (antidiag n)
    (compEquiv (invEquiv (metreFin' n)) (metreFin n))
  where
  open import Cubical.Data.Fin using (Fin-inj)
  open import Cubical.Foundations.Univalence using (ua)

  -- SumFin injectivity, from `Cubical.Data.Fin.Fin-inj` through
  -- `SumFin≃Fin` -- the same route `Cubical.Data.FinSet.Base` uses to
  -- show `card` is well defined.
  SumFin-inj : (m k : ℕ) → SFin m ≃ SFin k → m ≡ k
  SumFin-inj m k e =
    Fin-inj m k
      (ua (compEquiv (invEquiv (SumFin≃Fin m))
                     (compEquiv e (SumFin≃Fin k))))

------------------------------------------------------------------------
-- 6.  It runs, and the two arrays agree.
--
--   mātrā 6 = 13, and the antidiagonal a+b=6 of the meru is
--   C(6,0)+C(5,1)+C(4,2)+C(3,3) = 1+5+6+1 = 13.
------------------------------------------------------------------------

check-6 : matra 6 ≡ antidiag 6
check-6 = diagonal-is-matra 6

check-6-value : matra 6 ≡ 13
check-6-value = refl

check-9 : matra 9 ≡ antidiag 9
check-9 = diagonal-is-matra 9

------------------------------------------------------------------------
-- 7.  The thread, closed.
--
--   `Sankalita` §§8–13    three numeric encodings refuted, each with its
--                         counterexample recorded
--   `DurationIsSyllablesPlusGuru`
--                         the typed route: mātrāOf p ≡ varṇa p + guruOf p,
--                         and Metre n ≃ Σ_{a+b=n} Chosen a b
--   `PairsSummingTo`      the index set is finite, structurally
--   here                  cardinalities, and the identity
--
-- Virahāṅka's mātrāmeru is the shallow diagonal of Piṅgala's
-- meru-prastāra — a theorem now, between two arrays this repository had
-- held separately, from sources about a thousand years apart within one
-- tradition.
--
-- No numeric identity was proved along the way that is not a corollary of
-- the typed one, which is the shape `Pingala.agda` set: count the objects,
-- then read the numbers off.
------------------------------------------------------------------------
