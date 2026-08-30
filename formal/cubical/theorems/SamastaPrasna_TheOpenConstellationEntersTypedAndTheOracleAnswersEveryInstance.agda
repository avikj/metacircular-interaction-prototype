{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- समस्त-प्रश्न — the open constellation, asked whole.
--
-- Everything open from this session's frame enters as a type, in one
-- module, over one computable toolkit (imported from the RH module):
--
--   Goldbach     every even number ≥ 4 is a sum of two primes
--   TwinPrimes   there is no largest p with p, p+2 both prime
--   RH           already typed in the sibling module (imported)
--
-- and the reflection frame that binds them:
--
--   GoldbachAt (2n) is by definition the reflection statement: some k
--   has n−k and n+k both prime, exhibited here as p, q with p + q = 2n.
--
-- THE ORACLE ANSWERS EVERY INSTANCE.  Primality is a computable
-- predicate, so each individual question is decided by evaluation:
-- the inhabitants at the bottom are answers the typechecker COMPUTED —
-- refl proves primeb 97 ≡ true by running the sieve, not by citation.
-- The open problems are exactly the (n : ℕ) → … closures over the
-- instances: every fibre decidable, the whole section unproven.  That
-- is the precise shape of this class of open problem, now sitting in
-- the corpus as three uninhabited-so-far types.
--
-- WHAT IS NOT CLAIMED.  No inhabitant of Goldbach, TwinPrimes, or RH
-- is offered.  The instances checked below are finitely many and prove
-- nothing about the closures.
------------------------------------------------------------------------

module SamastaPrasna_TheOpenConstellationEntersTypedAndTheOracleAnswersEveryInstance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)

open import RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization
  using (spf ; eqb ; ltb ; leb ; RH)

------------------------------------------------------------------------
-- primality, computable: j ≥ 2 whose smallest factor ≥ 2 is j itself
------------------------------------------------------------------------

primeb : ℕ → Bool
primeb j = andb (ltb 1 j) (eqb (spf j) j)
  where
  andb : Bool → Bool → Bool
  andb true b  = b
  andb false _ = false

------------------------------------------------------------------------
-- the three questions
------------------------------------------------------------------------

-- Goldbach at one even number: two primes summing to it.  This IS the
-- reflection statement at center n — with 2n = p + q the pair is
-- (n − k, n + k) for k = n − p.
GoldbachAt : ℕ → Type
GoldbachAt m = Σ[ p ∈ ℕ ] Σ[ q ∈ ℕ ]
               (primeb p ≡ true) × (primeb q ≡ true) × (p + q ≡ m)

Goldbach : Type
Goldbach = (n : ℕ) → GoldbachAt (4 + 2 · n)

-- Twin primes: beyond every bound, a pair at distance 2.
TwinPrimes : Type
TwinPrimes = (n : ℕ) → Σ[ p ∈ ℕ ]
             (leb n p ≡ true) × (primeb p ≡ true) × (primeb (2 + p) ≡ true)

-- RH is imported: the Davis–Matiyasevich–Robinson inequality as a type.
RH-whole : Type
RH-whole = RH

------------------------------------------------------------------------
-- THE ORACLE'S ANSWERS, computed.  Each refl below is the typechecker
-- evaluating the sieve.  Nothing is asserted; everything is run.
------------------------------------------------------------------------

goldbach-at-100 : GoldbachAt 100          -- center 50, reflection k = 47
goldbach-at-100 = 3 , 97 , refl , refl , refl

goldbach-at-210 : GoldbachAt 210          -- center 105: the session's wheel
goldbach-at-210 = 83 , 127 , refl , refl , refl

twins-beyond-100 : Σ[ p ∈ ℕ ] (leb 100 p ≡ true)
                   × (primeb p ≡ true) × (primeb (2 + p) ≡ true)
twins-beyond-100 = 101 , refl , refl , refl

-- and one asymmetric fact the oracle computes as easily: 121 is not
-- prime, so the k = 16 survivor at center 105 fails above the wheel —
-- the session's own example, now checked rather than narrated.
the-survivor-that-fails : primeb 121 ≡ false
the-survivor-that-fails = refl
