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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.CarryBorrowObservation
--
-- A checked return from one fixed random-byte encounter with
-- `runtime/demo/out/carry_cocycle.svg`.  The sampled interval lies in the
-- base-4 table for
--
--     z(w) = number of initial zero digits
--
-- of a little-endian word.  The table suggests two statements that must not
-- be conflated:
--
--   * a positive value warrants one exact exclusion: the first digit is 0;
--   * the value does not determine the word: distinct words collide at 0.
--
-- Digit complement E exchanges this borrow observation with the analogous
-- carry observation (initial 3-digits).  This is the word-level equation
-- `c(E w) = z(w)` displayed by the SVG and stated in DIGIT_CRYSTAL (2.2),
-- now proved for every finite base-4 word rather than checked on 256 cells.
--
-- The negative result is not a new decoder principle.  It specializes the
-- core theorem `TranscriptDescent.collisionObstructsDecoder`: a single
-- observation collision with different targets obstructs every decoder on
-- the reachable image.
--
-- Rigor boundary:
--
--   PROVED HERE: complement/carry/borrow equations, the positive-observation
--   exclusion, and failure of complete-word descent through borrow count.
--
--   NOT CLAIMED: that a borrow observation is a pramāṇa in Dignāga's sense,
--   that apoha is a Boolean complement, or that extensional correctness of
--   this finite observation supplies its causal or epistemic warrant.  The
--   historical tradition generated the question; the terms below certify
--   only the stated finite mathematics.
------------------------------------------------------------------------

module NaturalMachine.CarryBorrowObservation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map ; length)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteInformation using (FactorsThrough)
open import NaturalMachine.TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1. The exact base-4 word object selected by the sampled SVG
------------------------------------------------------------------------

data Digit4 : Type₀ where
  d0 d1 d2 d3 : Digit4

Word4 : Type₀
Word4 = List Digit4

complement : Digit4 → Digit4
complement d0 = d3
complement d1 = d2
complement d2 = d1
complement d3 = d0

E : Word4 → Word4
E = map complement

complement-involutive : (d : Digit4) → complement (complement d) ≡ d
complement-involutive d0 = refl
complement-involutive d1 = refl
complement-involutive d2 = refl
complement-involutive d3 = refl

E-involutive : (w : Word4) → E (E w) ≡ w
E-involutive []       = refl
E-involutive (d ∷ w) = cong₂ _∷_ (complement-involutive d) (E-involutive w)

------------------------------------------------------------------------
-- 2. Carry and borrow observations
------------------------------------------------------------------------

-- Words are little-endian, so these are initial runs in the list and
-- trailing runs in the displayed numeral.
carryCount : Word4 → ℕ
carryCount []       = zero
carryCount (d0 ∷ w) = zero
carryCount (d1 ∷ w) = zero
carryCount (d2 ∷ w) = zero
carryCount (d3 ∷ w) = suc (carryCount w)

borrowCount : Word4 → ℕ
borrowCount []       = zero
borrowCount (d0 ∷ w) = suc (borrowCount w)
borrowCount (d1 ∷ w) = zero
borrowCount (d2 ∷ w) = zero
borrowCount (d3 ∷ w) = zero

-- DIGIT_CRYSTAL (2.2), at word level and without a finite census.
carry-E≡borrow : (w : Word4) → carryCount (E w) ≡ borrowCount w
carry-E≡borrow []       = refl
carry-E≡borrow (d0 ∷ w) = cong suc (carry-E≡borrow w)
carry-E≡borrow (d1 ∷ w) = refl
carry-E≡borrow (d2 ∷ w) = refl
carry-E≡borrow (d3 ∷ w) = refl

borrow-E≡carry : (w : Word4) → borrowCount (E w) ≡ carryCount w
borrow-E≡carry []       = refl
borrow-E≡carry (d0 ∷ w) = refl
borrow-E≡carry (d1 ∷ w) = refl
borrow-E≡carry (d2 ∷ w) = refl
borrow-E≡carry (d3 ∷ w) = cong suc (borrow-E≡carry w)

------------------------------------------------------------------------
-- 3. What a positive borrow observation warrants
------------------------------------------------------------------------

StartsZero : Word4 → Type₀
StartsZero []       = ⊥
StartsZero (d0 ∷ w) = Unit
StartsZero (d1 ∷ w) = ⊥
StartsZero (d2 ∷ w) = ⊥
StartsZero (d3 ∷ w) = ⊥

borrow-positive→startsZero : (w : Word4) (n : ℕ)
                           → borrowCount w ≡ suc n → StartsZero w
borrow-positive→startsZero []       n p = Empty.rec (znots p)
borrow-positive→startsZero (d0 ∷ w) n p = tt
borrow-positive→startsZero (d1 ∷ w) n p = Empty.rec (znots p)
borrow-positive→startsZero (d2 ∷ w) n p = Empty.rec (znots p)
borrow-positive→startsZero (d3 ∷ w) n p = Empty.rec (znots p)

startsZero→borrow-positive : (w : Word4) → StartsZero w
                           → Σ[ n ∈ ℕ ] borrowCount w ≡ suc n
startsZero→borrow-positive []       z = Empty.rec z
startsZero→borrow-positive (d0 ∷ w) z = borrowCount w , refl
startsZero→borrow-positive (d1 ∷ w) z = Empty.rec z
startsZero→borrow-positive (d2 ∷ w) z = Empty.rec z
startsZero→borrow-positive (d3 ∷ w) z = Empty.rec z

-- The transported observation warrants the same exclusion.  Complement is
-- a map between observations; it does not recover the word.
complement-carry-positive→startsZero : (w : Word4) (n : ℕ)
                                     → carryCount (E w) ≡ suc n
                                     → StartsZero w
complement-carry-positive→startsZero w n p =
  borrow-positive→startsZero w n (sym (carry-E≡borrow w) ∙ p)

------------------------------------------------------------------------
-- 4. What the observation cannot warrant: complete-word reconstruction
------------------------------------------------------------------------

-- Both words occur literally in the fixed SVG interval: the second is
-- L = 237, w = (1,3,2,3), z_n = 0.  The shorter control has the same
-- observation for the same structural reason: its first digit is nonzero.
sampleShort sample237 : Word4
sampleShort = d1 ∷ []
sample237   = d1 ∷ d3 ∷ d2 ∷ d3 ∷ []

sameBorrowObservation : borrowCount sampleShort ≡ borrowCount sample237
sameBorrowObservation = refl

sampleWordsDiffer : ¬ (sampleShort ≡ sample237)
sampleWordsDiffer p = znots (injSuc (cong length p))

-- No function on the reachable image of `borrowCount` can replay the full
-- word.  This is the exact core decoder obstruction, not a cardinality
-- slogan and not an inference from the picture.
borrowCountDoesNotDecodeWord :
  ¬ FactorsThrough borrowCount (λ w → w)
borrowCountDoesNotDecodeWord =
  collisionObstructsDecoder borrowCount (λ w → w)
    sameBorrowObservation sampleWordsDiffer

