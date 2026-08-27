{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विकर्ण — the diagonal.  A CONFIGURATION MAP THAT NO PROGRAM STEPS,
-- SO UNIVERSALITY DEMANDS A CHANGE OF REPRESENTATION.
--
-- Vishvayantra's uStep is a universal evaluator AS A FUNCTION.  The
-- classical self-hosting question asks for it AS A TABLE: one U in
-- Code whose runs simulate every machine.  This file proves the two
-- theorems that pin down what such a U can and cannot be.
--
--  1. `no-native-universal-table` — there is no table that is every
--     table ON THE NOSE: no U whose one-step action on raw
--     configurations agrees with every machine's.  Two machines that
--     disagree at one configuration kill every candidate.  So a
--     universal table, if it exists, MUST read its subject machine in
--     some encoding on the tape: the change of representation is not
--     an implementation convenience but a theorem.
--
--  2. `diagonal-escapes` — and the encoding is exactly where the
--     diagonal lives.  Fix any tape-reading of codes (`decode`, here
--     five naturals per rule off the right tape, with `encode` its
--     section — decode ∘ encode = id, proved).  Lawvere's fixed-point
--     argument then constructs a concrete map of configurations,
--
--         diag c  =  bump (uStep-conf (decode c) c),
--
--     the state-successor of what the machine READ OFF THE TAPE would
--     do — and diag is realized by NO program: a table M evaluated at
--     its own encoding would have to equal its own successor.  The
--     universal function exists (it is uStep); the diagonal shows the
--     family of table-behaviors cannot exhaust the configuration
--     maps, and the escape is manufactured from self-reference, not
--     counted from cardinality.
--
-- Together: universality is necessarily universality-up-to-encoding,
-- and every encoding hands the diagonal its pen.
------------------------------------------------------------------------

module Vikarna_TheDiagonalConfigurationMapThatNoProgramStepsSoUniversalityDemandsAChangeOfRepresentation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Empty as Empty using (⊥)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open import Vrddhi_AVerifiedProgramTheSuccessorMachineAddsOneStrokeAndItsCertificateIsAFibrePoint
  using (incr ; unary)

------------------------------------------------------------------------
-- §1  No table is every table.
------------------------------------------------------------------------

-- One machine stands still at the empty tape; another moves.  A
-- native universal table would have to do both at once.
no-native-universal-table :
  ¬ (Σ[ U ∈ Code ] ((M : Code) (c : Conf) →
       snd (uStep (U , c)) ≡ snd (uStep (M , c))))
no-native-universal-table (U , agree) =
  znots (cong fst (sym (agree [] (unary 0)) ∙ agree incr (unary 0)))

------------------------------------------------------------------------
-- §2  Reading a machine off the tape: decode, with encode a section.
------------------------------------------------------------------------

encodeMove : Move → ℕ
encodeMove left  = 0
encodeMove right = 1
encodeMove stay  = 2

decodeMove : ℕ → Move
decodeMove zero          = left
decodeMove (suc zero)    = right
decodeMove (suc (suc _)) = stay

decodeMove-encodeMove : (m : Move) → decodeMove (encodeMove m) ≡ m
decodeMove-encodeMove left  = refl
decodeMove-encodeMove right = refl
decodeMove-encodeMove stay  = refl

-- Five naturals per rule, flattened onto a tape.
flatten : Code → List ℕ
flatten []                            = []
flatten ((q , s , q' , s' , mv) ∷ rs) =
  q ∷ s ∷ q' ∷ s' ∷ encodeMove mv ∷ flatten rs

unflatten : List ℕ → Code
unflatten (q ∷ s ∷ q' ∷ s' ∷ m ∷ t) = (q , s , q' , s' , decodeMove m) ∷ unflatten t
unflatten _                         = []

unflatten-flatten : (M : Code) → unflatten (flatten M) ≡ M
unflatten-flatten [] = refl
unflatten-flatten ((q , s , q' , s' , mv) ∷ rs) i =
  (q , s , q' , s' , decodeMove-encodeMove mv i) ∷ unflatten-flatten rs i

-- A machine written on the right tape; the rest of the configuration
-- blank.
encode : Code → Conf
encode M = 0 , [] , 0 , flatten M

-- Any configuration read as a machine.
decode : Conf → Code
decode (q , ls , hd , rs) = unflatten rs

decode-encode : (M : Code) → decode (encode M) ≡ M
decode-encode = unflatten-flatten

------------------------------------------------------------------------
-- §3  The diagonal.
------------------------------------------------------------------------

-- The state-successor: a jog no configuration survives unmoved.
bump : Conf → Conf
bump (q , t) = suc q , t

bump-moves : (c : Conf) → ¬ c ≡ bump c
bump-moves (q , t) p = n≢sucn q (cong fst p)
  where
  n≢sucn : (n : ℕ) → ¬ n ≡ suc n
  n≢sucn zero    e = znots e
  n≢sucn (suc n) e = n≢sucn n (injSuc e)

-- What the machine read off the tape would do — bumped.
diag : Conf → Conf
diag c = bump (snd (uStep (decode c , c)))

-- THE THEOREM.  No table steps the diagonal: a candidate M, evaluated
-- at its own encoding, would have to equal its own successor.  The
-- family of program behaviors does not exhaust the configuration
-- maps, and the escape is one act of self-reference.
diagonal-escapes :
  ¬ (Σ[ M ∈ Code ] ((c : Conf) → snd (uStep (M , c)) ≡ diag c))
diagonal-escapes (M , steps) =
  bump-moves x (steps (encode M) ∙ why)
  where
  x : Conf
  x = snd (uStep (M , encode M))

  why : diag (encode M) ≡ bump x
  why = cong (λ N → bump (snd (uStep (N , encode M)))) (decode-encode M)
