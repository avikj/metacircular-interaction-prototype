{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FrontierCount
--
-- The assembly `CoprimePowersN` §5 left named: the walk's residue count at
-- a GENERAL frontier, as one term.
--
--     frontier-count :
--       (es : List Entry) → AllPrime es → Distinct es
--       → Fin (prodOf es) ≃ VecOf es
--
-- Given a list of (prime, exponent) pairs with distinct primes, the
-- residue vector against those prime powers has exactly as many values as
-- their product.  No frontier is named; `WalkObservationCount`'s
-- hand-composed three steps at frontier 8 were the special case.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT MAKES IT GO
--
-- `CoprimePowers.bez-mul`.  Coprimality to each factor gives coprimality
-- to the product, by one ring identity and no primality — so the head's
-- coprimality to the whole tail product (`bezHead`) is a fold, and the
-- CRT chain is then an induction with nothing arithmetic left in it.
--
-- Primality enters exactly once, at `primes→coprime-powers`, to produce
-- the base certificate for two distinct primes.  Everything after that is
-- the certificate composing.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS STILL NOT CLAIMED
--
-- That the walk's installs, as a list, satisfy `AllPrime` and `Distinct`
-- at every frontier.  `WalkPrimePowers.installs-are-prime-powers` says
-- each install is a prime power; turning the install STREAM into a list
-- with distinct bases is a statement about the walk's dynamics, not about
-- arithmetic, and is not proved here.  What is closed is that the count
-- follows from those hypotheses with no further arithmetic input.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module FrontierCount where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; isContr→Equiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _^_)
open import Cubical.Data.Nat.GCD using (isGCD)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Data.Int.Properties using (pos·pos)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Fin.Properties using (isContrFin1)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; isContrUnit)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

open import FinCardinality using (crtEquiv)
open import WalkJumps using (IsPrime)
open import SourcedProofs.CoprimePowers using (module Bezout)
open import CoprimePowersN
  using (Bez→isGCD ; isGCD→Bez ; primes→coprime-powers)

open Bezout ℤCommRing using (Bez ; bez-one ; bez-mul)

------------------------------------------------------------------------
-- 1.  Frontiers as lists of (prime, exponent)
------------------------------------------------------------------------

Entry : Type
Entry = ℕ × ℕ

prodOf : List Entry → ℕ
prodOf []             = 1
prodOf ((p , i) ∷ es) = (p ^ i) · prodOf es

VecOf : List Entry → Type
VecOf []             = Unit
VecOf ((p , i) ∷ es) = Fin (p ^ i) × VecOf es

AllPrime : List Entry → Type
AllPrime []             = Unit
AllPrime ((p , _) ∷ es) = IsPrime p × AllPrime es

FreshFrom : ℕ → List Entry → Type
FreshFrom p []             = Unit
FreshFrom p ((q , _) ∷ es) = (¬ (p ≡ q)) × FreshFrom p es

Distinct : List Entry → Type
Distinct []             = Unit
Distinct ((p , _) ∷ es) = FreshFrom p es × Distinct es

------------------------------------------------------------------------
-- 2.  Positivity, carried as a successor witness
------------------------------------------------------------------------

Pos : ℕ → Type
Pos a = Σ[ m ∈ ℕ ] (a ≡ suc m)

pos-· : (a b : ℕ) → Pos a → Pos b → Pos (a · b)
pos-· a b (m , pa) (n , pb) =
    (n + m · suc n)
  , cong₂ _·_ pa pb

pos-^ : (p : ℕ) → Pos p → (i : ℕ) → Pos (p ^ i)
pos-^ p _  zero    = 0 , refl
pos-^ p pp (suc i) = pos-· p (p ^ i) pp (pos-^ p pp i)

prime→Pos : (p : ℕ) → IsPrime p → Pos p
prime→Pos zero          pr = Empty.rec (¬-<-zero (pr .fst))
  where open import Cubical.Data.Empty as Empty using (⊥)
        open import Cubical.Data.Nat.Order using (¬-<-zero)
prime→Pos (suc p)       _  = p , refl

pos-prod : (es : List Entry) → AllPrime es → Pos (prodOf es)
pos-prod []             _          = 0 , refl
pos-prod ((p , i) ∷ es) (pp , rest) =
  pos-· (p ^ i) (prodOf es) (pos-^ p (prime→Pos p pp) i) (pos-prod es rest)

------------------------------------------------------------------------
-- 3.  The head is coprime to the whole tail product — a fold of `bez-mul`
------------------------------------------------------------------------

bezHead : (p i : ℕ) → IsPrime p → (es : List Entry)
        → AllPrime es → FreshFrom p es
        → Bez (pos (p ^ i)) (pos (prodOf es))
bezHead p i pp []             _           _              = bez-one (pos (p ^ i))
bezHead p i pp ((q , j) ∷ es) (qq , rest) (p≢q , fresh) =
  subst (Bez (pos (p ^ i))) (sym (pos·pos (q ^ j) (prodOf es)))
    (bez-mul {a = pos (p ^ i)} {b = pos (q ^ j)} {c = pos (prodOf es)}
             (isGCD→Bez (p ^ i) (q ^ j)
                (primes→coprime-powers p q pp qq p≢q i j))
             (bezHead p i pp es rest fresh))

headCoprime : (p i : ℕ) → IsPrime p → (es : List Entry)
            → AllPrime es → FreshFrom p es
            → isGCD (p ^ i) (prodOf es) 1
headCoprime p i pp es rest fresh =
  Bez→isGCD (p ^ i) (prodOf es) (bezHead p i pp es rest fresh)

------------------------------------------------------------------------
-- 4.  CRT at positive moduli, and the chain
------------------------------------------------------------------------

crtPos : (a b : ℕ) → Pos a → Pos b → isGCD a b 1
       → Fin (a · b) ≃ (Fin a × Fin b)
crtPos a b (m , pa) (n , pb) cop =
  subst2 (λ u v → Fin (u · v) ≃ (Fin u × Fin v)) (sym pa) (sym pb)
    (crtEquiv m n (subst2 (λ u v → isGCD u v 1) pa pb cop))

frontier-count :
  (es : List Entry) → AllPrime es → Distinct es
  → Fin (prodOf es) ≃ VecOf es
frontier-count []             _           _              =
  isContr→Equiv isContrFin1 isContrUnit
frontier-count ((p , i) ∷ es) (pp , rest) (fresh , dist) =
  compEquiv
    (crtPos (p ^ i) (prodOf es)
            (pos-^ p (prime→Pos p pp) i) (pos-prod es rest)
            (headCoprime p i pp es rest fresh))
    (≃-× (idEquiv (Fin (p ^ i))) (frontier-count es rest dist))
  where open import Cubical.Foundations.Equiv using (compEquiv ; idEquiv)
        open import Cubical.Data.Sigma using (≃-×)

------------------------------------------------------------------------
-- 5.  Frontier 8 again, now as an instance rather than a construction.
--
--   2³ · 3 · 5 · 7 = 840
------------------------------------------------------------------------

open import PrimalityDecision using (decIsPrime)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Empty as E using (⊥)
open import Cubical.Data.Nat using (znots ; injSuc)

isYes : {A : Type} → Dec A → Bool
isYes (yes _) = true
isYes (no  _) = false

fromDec : {A : Type} (d : Dec A) → isYes d ≡ true → A
fromDec (yes a) _ = a
fromDec (no  _) p = E.rec (false≢true p)

frontier8 : List Entry
frontier8 = (2 , 3) ∷ (3 , 1) ∷ (5 , 1) ∷ (7 , 1) ∷ []

frontier8-prod : prodOf frontier8 ≡ 840
frontier8-prod = refl

frontier8-primes : AllPrime frontier8
frontier8-primes =
    fromDec (decIsPrime 2) refl
  , fromDec (decIsPrime 3) refl
  , fromDec (decIsPrime 5) refl
  , fromDec (decIsPrime 7) refl
  , tt

frontier8-count : Fin 840 ≃ VecOf frontier8
frontier8-count =
  frontier-count frontier8 frontier8-primes frontier8-distinct
  where
  n2≢3 : ¬ (2 ≡ 3)
  n2≢3 x = znots (injSuc (injSuc x))
  n2≢5 : ¬ (2 ≡ 5)
  n2≢5 x = znots (injSuc (injSuc x))
  n2≢7 : ¬ (2 ≡ 7)
  n2≢7 x = znots (injSuc (injSuc x))
  n3≢5 : ¬ (3 ≡ 5)
  n3≢5 x = znots (injSuc (injSuc (injSuc x)))
  n3≢7 : ¬ (3 ≡ 7)
  n3≢7 x = znots (injSuc (injSuc (injSuc x)))
  n5≢7 : ¬ (5 ≡ 7)
  n5≢7 x = znots (injSuc (injSuc (injSuc (injSuc (injSuc x)))))

  frontier8-distinct : Distinct frontier8
  frontier8-distinct =
      (n2≢3 , n2≢5 , n2≢7 , tt)
    , (n3≢5 , n3≢7 , tt)
    , (n5≢7 , tt)
    , tt
    , tt

------------------------------------------------------------------------
-- 6.  What changed.
--
-- `WalkObservationCount` composed CRT three times by hand for one
-- frontier.  Here the frontier is data: a list of (prime, exponent)
-- pairs, primality read off `decIsPrime`, distinctness by computation,
-- and the count follows.  The arithmetic that made this impossible in the
-- earlier module — coprimality of prime powers — is `CoprimePowers` plus
-- `DistinctPrimesAreCoprime`, and it enters here exactly once.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- PROVENANCE CORRECTION, 2026-08-18.
--
-- This module says "the Chinese remainder theorem" for the simultaneous
-- congruence result it runs on, and that name was used without being
-- checked — in a session whose brief was to build from Indian sources and
-- credit the origin rather than the restatement, and three modules after
-- building Āryabhaṭa's kuṭṭaka by name.
--
-- The **kuṭṭaka** (*Āryabhaṭīya* 2.32–33, 499 CE) is a general
-- constructive method for exactly this problem — given remainders against
-- two moduli, produce the number — and Brahmagupta (628) and Bhāskara II
-- (1150) extend it.  The *Sun Zi Suanjing* (c. 3rd–5th c.) poses the
-- problem with a rule for a special case; Qin Jiushao's general method is
-- 1247.  Both traditions have it, and this file's own chain runs on the
-- Indian one: `CoprimePowers`, `BezoutIsGCD` and `CoprimePowersN` all
-- carry Bézout certificates, which is what the pulveriser returns.
--
-- Nothing mathematical changes.  The citation does.  See
-- notes/DID_THE_THREE_ROOTS_SUFFICE.md.
------------------------------------------------------------------------
