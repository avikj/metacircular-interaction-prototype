{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CakravalaDescent — the cyclic method's step, and why ONE congruence
-- suffices.
--
-- SOURCE AND PRIORITY.  The cakravāla ("cycle", "wheel") is stated by
-- JAYADEVA (~950 CE, surviving through Udayadivākara's Sundarī, 1073) and
-- given in full by BHĀSKARA II, Bījagaṇita, 1150 CE.  It solves
-- x² − D y² = 1 for every non-square D, terminating, by a descent that
-- never leaves the integers.  Brouncker and Wallis reach the problem in
-- 1657 and Lagrange proves termination in 1768 — six hundred years later.
-- "Pell's equation" is Euler's misattribution to a man who never worked
-- on it, and the name has outlived every correction since.
--
-- WHY THIS FILE EXISTS, which is the part worth reading.  `Bhavana.agda`
-- line 287 says, of the step where coprimality enters: "that step is in
-- CakravalaDescent".  There was no `CakravalaDescent`.  Line 14 says
-- "See notes/CAKRAVALA.md"; there is no such note.  Two references
-- pointing at work that was never done, in a form a reader takes as
-- "it is handled over there" — a claim carrying no evidence, which is the
-- same defect this repository has spent the day removing from its verdict
-- types.  A dangling citation is a bare label.  The repair is to make the
-- reference true, not to delete it.
--
-- THE STEP.  Given a² − D b² = k and an m with k | (a + bm), set
--
--     a' = (am + Db)/k        b' = (a + bm)/k        k' = (m² − D)/k
--
-- and then a'² − D b'² = k'.  Bhāskara's choice rule — choose, among the m
-- satisfying the congruence, one minimising |m² − D| — is what makes the
-- cycle terminate; it is NOT proved here and is not claimed.
--
-- HOW IT IS STATED HERE.  The three divisions are given as HYPOTHESES in
-- multiplied form (a·m + D·b ≡ k · a', and so on).  That is not a
-- weakening: it is exactly the algorithm's own situation, since the whole
-- force of Bhāskara's choice is that all three divisions come out exact.
-- Stating them multiplied keeps the theorem over an arbitrary commutative
-- ring, where there is no division to perform.
--
-- WHAT IS PROVED.  No postulates, no holes, --safe.
--
--   cakravalaScaled   the step's identity in k²-scaled form, over ANY
--                     commutative ring and with NO cancellation:
--                        k · (k · k') ≡ (k · k) · N D a' b'
--   cakravalaStep     the step itself, given that k is a non-zero-divisor:
--                        N D a' b' ≡ k'
--   oneCongruence     Bhāskara needs only k | (a + bm): the other two
--                     divisibilities follow, up to the factor b.  This is
--                     `Bhavana.choiceToNumerator` and
--                     `choiceToDiscriminant` read as divisibility.
--
-- WHAT IS NOT.  Termination.  Minimality of Bhāskara's choice.  The
-- removal of the factor b in `oneCongruence` — that needs gcd(k, b) = 1,
-- which is a kuṭṭaka (`Kuttaka.agda`), and joining the two is a further
-- step this file does not take.  Existence of solutions is not claimed.
------------------------------------------------------------------------

module CakravalaDescent where

open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.Ring.Properties using (module RingTheory)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)

open import Bhavana using (module Form)

private
  variable
    ℓ : Level

module Descent (CR : CommRing ℓ) where

  open CommRingStr (snd CR)
  open RingTheory (CommRing→Ring CR)
  open Form CR

  ----------------------------------------------------------------------
  -- 0.  Divisibility, carrying its cofactor
  --
  -- `d ∣ x` is the cofactor together with the equation, not a proposition
  -- about which one it is.  Same rule as everywhere else here: acceptance
  -- yields a witness.
  ----------------------------------------------------------------------

  _∣_ : R → R → Type ℓ
  d ∣ x = Σ[ c ∈ R ] x ≡ d · c

  ----------------------------------------------------------------------
  -- 1.  THE STEP, SCALED.  No hypotheses on k, no cancellation, any
  -- commutative ring.
  --
  -- Brahmagupta's composition with the trivial triple (m, 1, m² − D) is
  -- `Bhavana.cakravalaCleared`; the whole of the cakravāla step is that
  -- composition read with the three exact divisions substituted in, plus
  -- `normScale` to pull k out of both new coordinates at once.
  ----------------------------------------------------------------------

  cakravalaScaled : (D a b m k a' b' k' : R)
                  → N D a b ≡ k
                  → a · m + D · b ≡ k · a'
                  → a + b · m     ≡ k · b'
                  → m · m - D     ≡ k · k'
                  → k · (k · k') ≡ (k · k) · N D a' b'
  cakravalaScaled D a b m k a' b' k' nab ea eb ek =
      cong₂ _·_ (sym nab) (sym ek)
    ∙ Bhavana.Form.cakravalaCleared CR D a b m
    ∙ cong₂ (N D) ea eb
    ∙ sym (normScale k D a' b')

  ----------------------------------------------------------------------
  -- 2.  THE STEP.  Cancelling k² needs k to be a non-zero-divisor, which
  -- over ℤ is k ≠ 0 — and k = 0 would say a² = D b², i.e. the descent had
  -- already produced a square root of D and there is nothing to descend.
  --
  -- The hypothesis is taken as the cancellation property itself rather
  -- than as `k ≠ 0` plus a domain structure, because that is the weakest
  -- thing the proof uses and it keeps the theorem over any CommRing.
  ----------------------------------------------------------------------

  cakravalaStep : (D a b m k a' b' k' : R)
                → ((x y : R) → k · x ≡ k · y → x ≡ y)   -- k cancels
                → N D a b ≡ k
                → a · m + D · b ≡ k · a'
                → a + b · m     ≡ k · b'
                → m · m - D     ≡ k · k'
                → N D a' b' ≡ k'
  cakravalaStep D a b m k a' b' k' cancel nab ea eb ek =
    sym (cancel k' (N D a' b') (cancel (k · k') (k · N D a' b') step))
    where
    step : k · (k · k') ≡ k · (k · N D a' b')
    step = cakravalaScaled D a b m k a' b' k' nab ea eb ek
         ∙ sym (·Assoc k k (N D a' b'))

  ----------------------------------------------------------------------
  -- 3.  WHY ONE CONGRUENCE SUFFICES (Bhāskara's choice rule).
  --
  -- The algorithm asks the solver to find m with k | (a + bm) and nothing
  -- else.  The other two exactness conditions are consequences, up to the
  -- factor b: `Bhavana`'s two polynomial identities say precisely that
  -- b·(am + Db) and b²·(m² − D) are combinations of (a + bm) and k.
  --
  -- This is what makes the cakravāla an algorithm rather than a search.
  -- The remaining factor b is removed by gcd(k, b) = 1, which is a
  -- kuṭṭaka; that join is not made here and is not claimed.
  ----------------------------------------------------------------------

  oneCongruence : (D a b m k : R)
                → N D a b ≡ k
                → k ∣ (a + b · m)
                → (k ∣ (b · (a · m + D · b))) × (k ∣ ((b · b) · (m · m - D)))
  oneCongruence D a b m k nab (c , hc) = numer , discr
    where
    numer : k ∣ (b · (a · m + D · b))
    numer = a · c - 1r
          , ( Bhavana.Form.choiceToNumerator CR D a b m
            ∙ cong₂ _-_ (cong (λ w → a · w) hc) nab
            ∙ cong₂ _-_ (·Assoc a k c ∙ cong (λ w → w · c) (·Comm a k)
                          ∙ sym (·Assoc k a c))
                        (sym (·IdR k))
            ∙ sym (·DistR- k (a · c) 1r) )

    discr : k ∣ ((b · b) · (m · m - D))
    discr = c · (b · m - a) + 1r
          , ( Bhavana.Form.choiceToDiscriminant CR D a b m
            ∙ cong₂ _+_ (cong (λ w → w · (b · m - a)) hc
                          ∙ sym (·Assoc k c (b · m - a)))
                        (nab ∙ sym (·IdR k))
            ∙ sym (·DistR+ k (c · (b · m - a)) 1r) )

------------------------------------------------------------------------
-- 4.  ONE STEP AT D = 13, COMPUTED.
--
-- Bhāskara's own worked example in the Bījagaṇita.  Start from the
-- trivial triple 3² − 13·1² = −4, and take m = 1, which satisfies the
-- congruence −4 | (3 + 1·1) = 4.  Then
--
--     a' = (3·1 + 13·1)/(−4) = 16/(−4) = −4
--     b' = (3 + 1·1)/(−4)    =  4/(−4) = −1
--     k' = (1 − 13)/(−4)     = −12/(−4) =  3
--
-- and indeed (−4)² − 13·(−1)² = 16 − 13 = 3.  The three hypotheses are
-- each `refl` — the kernel performs the multiplications — so this exhibits
-- the step's premises being met by actual integers rather than asserting
-- that they can be.
------------------------------------------------------------------------

open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

module StepAtThirteen where

  open Descent ℤCommRing
  open CommRingStr (snd ℤCommRing) using (_·_ ; _-_ ; _+_)
  open Bhavana.Form ℤCommRing using (N)

  -- 3² − 13·1² = −4
  premiseNorm : N (pos 13) (pos 3) (pos 1) ≡ negsuc 3
  premiseNorm = refl

  -- a·m + D·b = 3·1 + 13·1 = 16 = (−4)·(−4)
  premiseA : pos 3 · pos 1 + pos 13 · pos 1 ≡ negsuc 3 · negsuc 3
  premiseA = refl

  -- a + b·m = 3 + 1·1 = 4 = (−4)·(−1)
  premiseB : pos 3 + pos 1 · pos 1 ≡ negsuc 3 · negsuc 0
  premiseB = refl

  -- m² − D = 1 − 13 = −12 = (−4)·3
  premiseK : pos 1 · pos 1 - pos 13 ≡ negsuc 3 · pos 3
  premiseK = refl

  -- and the conclusion the step delivers, which the kernel also computes:
  -- (−4)² − 13·(−1)² = 3.
  descended : N (pos 13) (negsuc 3) (negsuc 0) ≡ pos 3
  descended = refl

  -- The scaled identity at these numbers, obtained from the general
  -- theorem rather than recomputed — so this is the theorem being applied,
  -- not a coincidence of arithmetic.
  scaledHere : negsuc 3 · (negsuc 3 · pos 3)
             ≡ (negsuc 3 · negsuc 3) · N (pos 13) (negsuc 3) (negsuc 0)
  scaledHere = cakravalaScaled (pos 13) (pos 3) (pos 1) (pos 1) (negsuc 3)
                               (negsuc 3) (negsuc 0) (pos 3)
                               premiseNorm premiseA premiseB premiseK
