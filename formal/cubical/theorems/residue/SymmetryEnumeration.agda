{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SymmetryEnumeration
--
-- From counting to enumerating.
--
-- SymmetryCardinality proves |Fin n ≃ Fin n| ≡ n! — a cardinality,
-- i.e. a mere count.  This module upgrades the count to a *checked
-- enumeration*: an explicit equivalence
--
--     symmetryEnum n : (Fin n ≃ Fin n) ≃ Fin (n !)
--
-- whose forward map assigns every permutation its index (its Lehmer
-- code, read as a factorial-base numeral) and whose backward map
-- *generates* the permutation at any index.  This is a generation
-- step, not just a verification: `invEq (symmetryEnum n) k` computes
-- the k-th permutation of Fin n.
--
-- The equivalence is the composite of two library pieces —
--   lehmerEquiv    : (Fin n ≃ Fin n) ≃ LehmerCode n
--   lehmerFinEquiv : LehmerCode n ≃ Fin (factorial n)
-- — transported along the structural-induction bridge
-- factorial≡! : LehmerCode.factorial n ≡ n ! from SymmetryCardinality.
--
-- Corollary, through the univalence keystone (PathIsSymmetry): the
-- loop space of the universe at the classifying point Fin n is itself
-- enumerated by Fin (n !).  Each of the n! loops at the point "the
-- n-element set" has an index, and every index yields a loop.
------------------------------------------------------------------------

module SymmetryEnumeration where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin ; fzero ; isContrFin1)
import Cubical.Data.Fin.LehmerCode as LehmerCode

open import SymmetryCardinality using (factorial≡!)
open import PathIsSymmetry using (finPathIsSymmetry)

------------------------------------------------------------------------
-- 1.  The enumeration.
------------------------------------------------------------------------

-- Permutation ↦ Lehmer code ↦ factorial-base index, with the codomain
-- rewritten from LehmerCode.factorial n to Data.Nat's n !.
symmetryEnum : (n : ℕ) → (Fin n ≃ Fin n) ≃ Fin (n !)
symmetryEnum n =
  subst (λ m → (Fin n ≃ Fin n) ≃ Fin m) (factorial≡! n)
        (compEquiv LehmerCode.lehmerEquiv LehmerCode.lehmerFinEquiv)

-- The two directions, named: rank a permutation / generate the k-th
-- permutation.  `unrank` is the generation step.
rank : (n : ℕ) → (Fin n ≃ Fin n) → Fin (n !)
rank n = equivFun (symmetryEnum n)

unrank : (n : ℕ) → Fin (n !) → (Fin n ≃ Fin n)
unrank n = invEq (symmetryEnum n)

-- Round trips, for free from the equivalence structure: the
-- enumeration is exhaustive (every index is hit) and irredundant
-- (distinct indices give distinct permutations).
unrank-rank : (n : ℕ) (e : Fin n ≃ Fin n) → unrank n (rank n e) ≡ e
unrank-rank n = retEq (symmetryEnum n)

rank-unrank : (n : ℕ) (k : Fin (n !)) → rank n (unrank n k) ≡ k
rank-unrank n = secEq (symmetryEnum n)

------------------------------------------------------------------------
-- 2.  Corollary through univalence: the loop space at the classifying
--     point is enumerated.
--
-- PathIsSymmetry identifies (Fin n ≡ Fin n) with (Fin n ≃ Fin n) by
-- univalence; composing with symmetryEnum enumerates the loops
-- themselves.  ΩGroup≃Symmetric (loc. cit.) says this identification
-- is a group isomorphism, so the indexing below is an enumeration of
-- the underlying set of the loop group Ω(Type, Fin n).
------------------------------------------------------------------------

loopEnum : (n : ℕ) → (Fin n ≡ Fin n) ≃ Fin (n !)
loopEnum n = compEquiv (finPathIsSymmetry n) (symmetryEnum n)

------------------------------------------------------------------------
-- 3.  Sanity theorems at the base cases.
--
-- 0! = 1! = 1, so both enumerations land in Fin 1, which is
-- contractible; the identity permutation must sit at index fzero, and
-- there is nothing else.  (These hold by contractibility — the subst
-- in symmetryEnum blocks definitional computation, so they are proved
-- propositionally, which is all a set-level statement can ask for.)
------------------------------------------------------------------------

rank-id₀ : rank 0 (idEquiv (Fin 0)) ≡ fzero
rank-id₀ = isContr→isProp isContrFin1 _ _

rank-id₁ : rank 1 (idEquiv (Fin 1)) ≡ fzero
rank-id₁ = isContr→isProp isContrFin1 _ _

-- Generation at the base case: the 0-th (only) permutation of a
-- one-element set is the identity.  (Fin 1 ≃ Fin 1) is contractible
-- with centre idEquiv, so this too is propositional but canonical.
unrank₁-id : unrank 1 fzero ≡ idEquiv (Fin 1)
unrank₁-id = equivEq (funExt λ x → isContr→isProp isContrFin1 _ _)
