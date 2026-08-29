{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अभिलेख-अनिर्धार — the specification's underdetermination.
--
-- RESOLUTION TOWARD ABSTRACT 16.  That abstract proved pruning by
-- observational equivalence collapses an unbounded fibre, and scoped
-- away the synthesis vocabulary: no specification language, no
-- example-based synthesis.  Constructed here:
--
--   §1  A SPECIFICATION is a list of input–output examples;
--       satisfaction is the conjunction of the example equations.
--       Example-based synthesis vocabulary, as types.
--
--   §2  THE SPECIFICATION DOES NOT DETERMINE THE PROGRAM: the
--       one-example spec (0 ↦ 0) is satisfied by the identity and by
--       the constant-zero program, which are proved distinct at input
--       1 — and every function of the observed behaviour (the outputs
--       on the spec's inputs) agrees on the two, so no judge fed the
--       observations selects between them.
--
--   §3  THE FIBRE IS UNBOUNDED, BY AN INJECTION: n ↦ (the program
--       multiplying by n) sends every natural to a satisfier of the
--       spec, and the assignment is injective — evaluating at 1
--       recovers n.  A dedup keyed on spec-behaviour does not remove a
--       duplicate; it collapses a copy of ℕ.
--
-- SYĀT — THE CLAIM, EXACTLY.  Examples over ℕ with unary programs; no
-- version-space algebra and no enumerative search appear — those are
-- constructions.  The specification language and the exhibited gap are
-- no longer among the absences.
------------------------------------------------------------------------

module AbhilekhaAnirdhara_TheSpecificationNowExistsDoesNotDetermineTheProgramAndItsFibreCarriesAnInjectionOfTheNaturals where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _·_ ; snotz)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)

------------------------------------------------------------------------
-- १ · Specifications and satisfaction.
------------------------------------------------------------------------

Abhilekha : Type₀
Abhilekha = List (ℕ × ℕ)

tṛpti : (ℕ → ℕ) → Abhilekha → Type₀
tṛpti f []             = Unit
tṛpti f ((i , o) ∷ s) = (f i ≡ o) × tṛpti f s

-- The one-example specification: zero maps to zero.
abhilekha₀ : Abhilekha
abhilekha₀ = (zero , zero) ∷ []

------------------------------------------------------------------------
-- २ · Two satisfiers, distinct, observationally identical on the spec.
------------------------------------------------------------------------

ātman śūnyaka : ℕ → ℕ
ātman n = n
śūnyaka _ = zero

ātman-tṛpta : tṛpti ātman abhilekha₀
ātman-tṛpta = refl , tt

śūnyaka-tṛpta : tṛpti śūnyaka abhilekha₀
śūnyaka-tṛpta = refl , tt

bhinna : ātman ≡ śūnyaka → ⊥
bhinna p = snotz (funExt⁻ p 1)

-- The spec's whole observation of a program is its output at 0, and
-- the two agree there — so every judge of observations agrees.
andha-nirṇaya : {A : Type₀} (judge : ℕ → A)
              → judge (ātman zero) ≡ judge (śūnyaka zero)
andha-nirṇaya judge = refl

------------------------------------------------------------------------
-- ३ · The unbounded fibre: a copy of ℕ inside the satisfiers.
------------------------------------------------------------------------

guṇaka : ℕ → (ℕ → ℕ)
guṇaka n i = n · i

guṇya-śūnya : (n : ℕ) → n · zero ≡ zero
guṇya-śūnya zero    = refl
guṇya-śūnya (suc n) = guṇya-śūnya n

guṇaka-tṛpta : (n : ℕ) → tṛpti (guṇaka n) abhilekha₀
guṇaka-tṛpta n = guṇya-śūnya n , tt

guṇa-eka : (n : ℕ) → n · 1 ≡ n
guṇa-eka zero    = refl
guṇa-eka (suc n) = cong suc (guṇa-eka n)

guṇaka-vibhinna : (n m : ℕ) → guṇaka n ≡ guṇaka m → n ≡ m
guṇaka-vibhinna n m p = sym (guṇa-eka n) ∙ funExt⁻ p 1 ∙ guṇa-eka m
