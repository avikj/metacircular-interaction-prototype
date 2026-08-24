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

{-# OPTIONS --cubical --safe #-}
--
-- व्याप्तिः — pervasion.  In Nyāya, vyāpti is the invariable concomitance that
-- licenses an inference: wherever the hetu is, the sādhya is, without
-- exception.  Gaṅgeśa, *Tattvacintāmaṇi*, c. 1325, is where its definition is
-- fought over at length; the notion is older, in the *Nyāyasūtra* tradition.
-- The word is taken for what it names — what must hold everywhere once it
-- holds somewhere.  Nothing below is attributed to those texts.
--
-- WHAT THIS ANSWERS.  `Anuvrtti_...` proved that an observer sees a law
-- exactly when its class is a congruence for the rule, and that one blind
-- pair with different futures refutes every predictor.  That is a criterion.
-- It does not say WHAT TO DO when the criterion fails.
--
-- `NaturalMachine/QuotientFiberLaw.agda` says visibility returns only by a
-- separating query.  It does not say which query, or how much.
--
-- This module makes both constructive, in the direction that matters:
--
--     given a rule f and a pair the observer wants to identify, there is a
--     LEAST congruence identifying it, and it is BUILT — the closure of the
--     pair under the rule, nothing more.
--
-- So the cost of an observer's chosen blindness is not a mood.  It is a
-- computed set: identify (a,b) and you are forced to identify (f a, f b),
-- and (f² a, f² b), and nothing else.  Dually — and this is the direction
-- the instrument uses — the minimal information an observer must ADD to see
-- a law is the failure of its own kernel to be closed under that same step,
-- which is a finite computation and not a search.
--
-- The corpus's own name for the general shape is the fibre: a class sees a
-- quotient, and the separating query is what re-enters the fibre.  Here the
-- separating query is exhibited rather than asserted to exist.
module Vyapti_TheLeastCongruenceContainingAPairIsConstructedAndIsTheMinimalSeparatingQuery where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Nat using (ℕ; zero; suc)

private
  variable
    ℓ ℓ' : Level

module _ (X : Type ℓ) (f : X → X) where

  -- a relation on the states
  Rel : Type (ℓ-suc ℓ)
  Rel = X → X → Type ℓ

  -- what it takes to be a congruence for f: an equivalence, closed under
  -- the step.  Stated as a record so the four obligations are named.
  record Anukula (R : Rel) : Type ℓ where
    field
      rfl   : (x : X) → R x x
      symm  : {x y : X} → R x y → R y x
      trns  : {x y z : X} → R x y → R y z → R x z
      onward : {x y : X} → R x y → R (f x) (f y)

  open Anukula public

  -- ---------------------------------------------------------- the closure
  -- व्याप्तिः: the least congruence containing a seed relation.  Four
  -- constructors, one for each obligation, and NOTHING ELSE — which is
  -- exactly why it is least.
  data Vyapti (S : Rel) : X → X → Type ℓ where
    bija  : {x y : X} → S x y → Vyapti S x y          -- बीजम्, the seed
    sama  : (x : X) → Vyapti S x x
    vipar : {x y : X} → Vyapti S x y → Vyapti S y x
    setu  : {x y z : X} → Vyapti S x y → Vyapti S y z → Vyapti S x z
    gati  : {x y : X} → Vyapti S x y → Vyapti S (f x) (f y)   -- गतिः, the step

  -- it IS a congruence
  vyapti-anukula : (S : Rel) → Anukula (Vyapti S)
  vyapti-anukula S = record { rfl = sama ; symm = vipar ; trns = setu ; onward = gati }

  -- it contains the seed
  vyapti-bija : (S : Rel) {x y : X} → S x y → Vyapti S x y
  vyapti-bija S s = bija s

  -- and it is contained in EVERY congruence that contains the seed.  This is
  -- the leastness, and with it the closure is not "a" separating cost but
  -- THE separating cost.
  vyapti-alpistha : (S R : Rel) → Anukula R
    → ({x y : X} → S x y → R x y)
    → {x y : X} → Vyapti S x y → R x y
  vyapti-alpistha S R c into (bija s)     = into s
  vyapti-alpistha S R c into (sama x)     = rfl c x
  vyapti-alpistha S R c into (vipar p)    = symm c (vyapti-alpistha S R c into p)
  vyapti-alpistha S R c into (setu p q)   = trns c (vyapti-alpistha S R c into p) (vyapti-alpistha S R c into q)
  vyapti-alpistha S R c into (gati p)     = onward c (vyapti-alpistha S R c into p)

  -- ------------------------------------------------------- the consequence
  -- If an observer identifies a pair, it has thereby identified the whole
  -- forward orbit of that pair, and it cannot stop short.  This is the price
  -- of a chosen blindness, and it is forced, not chosen twice.
  पुनः : ℕ → X → X
  पुनः zero x = x
  पुनः (suc k) x = f (पुनः k x)

  मूल्यम् : (S : Rel) {x y : X} → S x y → (n : ℕ)
    → Vyapti S (पुनः n x) (पुनः n y)
  मूल्यम् S s zero = bija s
  मूल्यम् S s (suc n) = gati (मूल्यम् S s n)
