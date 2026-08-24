-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PairsSummingTo
--
-- Ingredient (i) of `DurationIsSyllablesPlusGuru` §7, built rather than
-- described.
--
--     pairsFin : (n : ℕ) → Pairs n ≃ SumFin (suc n)
--
-- where `Pairs n = Σ[ (a,b) ∈ ℕ × ℕ ] (a + b ≡ n)`.  The antidiagonal
-- index set is finite, with `n + 1` elements, by a structural induction
-- and **no truncated subtraction** — which is what every other encoding in
-- this thread died of.
--
-- ────────────────────────────────────────────────────────────────────
-- THE INDUCTION
--
--     Pairs 0        ≃  ⊤
--     Pairs (suc n)  ≃  ⊤ ⊎ Pairs n
--
-- the first summand being the pair `(0 , suc n)` and the rest having `a`
-- a successor, dropping to the previous level.  `Cubical.Data.SumFin`
-- defines `Fin (suc n) = ⊤ ⊎ Fin n` **definitionally**, so the second
-- line composes into the result with no arithmetic at all.
--
-- Every round-trip obligation beyond the pair itself is an equation in
-- ℕ, hence a proposition, hence `isSetℕ`.  Same observation that made
-- `DurationIsSyllablesPlusGuru`'s Σ-contraction go through.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT REMAINS OF THE DIAGONAL IDENTITY
--
-- `Sankalita` §13 refuted three encodings; `DurationIsSyllablesPlusGuru`
-- carried the fourth to an equivalence and then §7 named two remaining
-- ingredients.  This is the first.  The second — that the library's `sum`
-- over this FinSet is the recursive `Sankalita.AD` — is a reindexing, and
-- reindexing is precisely what the third refuted encoding got wrong, so
-- it is not being called routine here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.PairsSummingTo where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ ; injSuc)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.SumFin using () renaming (Fin to SumFin)

------------------------------------------------------------------------
-- 1.  The antidiagonal index set
------------------------------------------------------------------------

Pairs : ℕ → Type
Pairs n = Σ[ ab ∈ (ℕ × ℕ) ] (fst ab + snd ab ≡ n)

------------------------------------------------------------------------
-- 2.  Base: only (0,0) sums to 0
------------------------------------------------------------------------

pairs0-Iso : Iso (Pairs 0) Unit
Iso.fun      pairs0-Iso _ = tt
Iso.inv      pairs0-Iso _ = (0 , 0) , refl
Iso.rightInv pairs0-Iso _ = refl
Iso.leftInv  pairs0-Iso ((zero  , zero)  , p) =
  ΣPathP (refl , isProp→PathP (λ _ → isSetℕ _ _) _ _)
Iso.leftInv  pairs0-Iso ((zero  , suc b) , p) = Empty.rec (snotz p)
  where open import Cubical.Data.Empty as Empty using (⊥)
        open import Cubical.Data.Nat using (snotz)
Iso.leftInv  pairs0-Iso ((suc a , b)     , p) = Empty.rec (snotz p)
  where open import Cubical.Data.Empty as Empty using (⊥)
        open import Cubical.Data.Nat using (snotz)

------------------------------------------------------------------------
-- 3.  Step: peel the a = 0 pair off
------------------------------------------------------------------------

pairsSuc-Iso : (n : ℕ) → Iso (Pairs (suc n)) (Unit ⊎ Pairs n)
Iso.fun (pairsSuc-Iso n) ((zero  , b) , p) = inl tt
Iso.fun (pairsSuc-Iso n) ((suc a , b) , p) = inr ((a , b) , injSuc p)

Iso.inv (pairsSuc-Iso n) (inl _)              = (0 , suc n) , refl
Iso.inv (pairsSuc-Iso n) (inr ((a , b) , q))  = (suc a , b) , cong suc q

Iso.rightInv (pairsSuc-Iso n) (inl tt) = refl
Iso.rightInv (pairsSuc-Iso n) (inr ((a , b) , q)) =
  cong inr (ΣPathP (refl , isProp→PathP (λ _ → isSetℕ _ _) _ _))

Iso.leftInv (pairsSuc-Iso n) ((zero  , b) , p) =
  ΣPathP ( ΣPathP (refl , sym p)
         , isProp→PathP (λ _ → isSetℕ _ _) _ _ )
Iso.leftInv (pairsSuc-Iso n) ((suc a , b) , p) =
  ΣPathP (refl , isProp→PathP (λ _ → isSetℕ _ _) _ _)

------------------------------------------------------------------------
-- 4.  THE STATEMENT.  `SumFin (suc n) = ⊤ ⊎ SumFin n` definitionally, so
--     the induction composes with no arithmetic.
------------------------------------------------------------------------

⊎-cong : {A B : Type} → A ≃ B → (Unit ⊎ A) ≃ (Unit ⊎ B)
⊎-cong e = isoToEquiv is
  where
  open import Cubical.Foundations.Equiv using (equivFun ; invEq ; retEq ; secEq)
  is : Iso _ _
  Iso.fun is (inl t) = inl t
  Iso.fun is (inr a) = inr (equivFun e a)
  Iso.inv is (inl t) = inl t
  Iso.inv is (inr b) = inr (invEq e b)
  Iso.rightInv is (inl t) = refl
  Iso.rightInv is (inr b) = cong inr (secEq e b)
  Iso.leftInv  is (inl t) = refl
  Iso.leftInv  is (inr a) = cong inr (retEq e a)

pairsFin : (n : ℕ) → Pairs n ≃ SumFin (suc n)
pairsFin zero    = compEquiv (isoToEquiv pairs0-Iso) unitEquiv
  where
  open import Cubical.Data.Empty as Empty using (⊥)
  unitEquiv : Unit ≃ SumFin 1
  unitEquiv = isoToEquiv is
    where
    is : Iso Unit (SumFin 1)
    Iso.fun      is _        = inl tt
    Iso.inv      is _        = tt
    Iso.rightInv is (inl tt) = refl
    Iso.rightInv is (inr ())
    Iso.leftInv  is _        = refl
pairsFin (suc n) =
  compEquiv (isoToEquiv (pairsSuc-Iso n)) (⊎-cong (pairsFin n))

------------------------------------------------------------------------
-- 5.  So the antidiagonal index set has n+1 elements, structurally.
--
-- That is ingredient (i).  Ingredient (ii) — that the library's sum over
-- this FinSet is `Sankalita.AD` — is a reindexing, and this thread's
-- record on reindexings is one for one against.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  State of the diagonal-sum thread, facts only.
--
-- PROVED, all checked in this repository:
--
--   `Sankalita.sankalita-column`      Σ_{m<n} meru m r ≡ meru n (suc r)
--   `Sankalita.varasankalita`         Σ^r 1 at n ≡ meru n r
--   `Sankalita.AD2-breaks-the-recurrence`
--                                     the row-2 antidiagonal sums are not
--                                     Fibonacci-recurrent
--   `DurationIsSyllablesPlusGuru.matra-split`
--                                     matrāOf p ≡ varṇa p + guruOf p
--   `DurationIsSyllablesPlusGuru.metre-sorts`
--                                     Metre n ≃ Σ_{a+b=n} Chosen a b
--   here `pairsFin`                   Pairs n ≃ SumFin (suc n)
--
-- AND NOW ALSO PROVED, in `NaturalMachine.DiagonalIsMatra`:
--
--   `diagonal-is-matra : (n : ℕ) → matra n ≡ antidiag n`
--
-- The cardinality computation this section declined to estimate turned
-- out to need the SHIFTED family `SortedC c n` — the unshifted one does
-- not close the induction — plus `Σ-contractFst`, `Σ⊎≃`, `SumFin⊎≃` and
-- `Fin-inj`.  Declining to estimate was right: the shift was the content,
-- and no sentence written before doing it would have named it.
------------------------------------------------------------------------
