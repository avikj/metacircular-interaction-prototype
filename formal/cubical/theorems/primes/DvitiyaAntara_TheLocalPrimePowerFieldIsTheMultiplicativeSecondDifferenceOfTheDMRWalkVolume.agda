{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- �������-����� � the second difference.
--
-- THE LOCAL PRIME-POWER FIELD IS RECOVERED FROM THE DMR WALK VOLUME BY
-- A MULTIPLICATIVE SECOND DIFFERENCE � over �, with no logarithm, no
-- reals, and no division.
--
-- `RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization`
-- puts the Davis�Matiyasevich�Robinson observable into the corpus as a
-- typed object, built from
--
--     �  j  =  p  when j is a prime power p^k (k � 1), else 1
--     Π� m  =  Π_{j � m} � j
--     δ  x  =  Π_{m < x} Π� m
--
-- and states RH as a uniform inequality on the harmonic sum at δ(n).
-- This module proves the one structural fact about δ that needs
-- no analysis � that δ loses nothing.
--
-- The usual way to say it is additive: log δ is the first Riesz mean of
-- the von Mangoldt field, and � is its discrete second difference.  That
-- reading needs a logarithm and hence �.  It is not needed.  Both of δ's
-- defining clauses are already recursions, so the same content is a
-- product identity on �:
--
--   §1  δ (suc n) ≡ δ n � Π� n            the first difference (a
--                                         quotient, stated as a product)
--   §2  Π� (suc m) ≡ Π� m � � (suc m)     the inner recursion
--   §3  δ (suc (suc n)) � δ n ≡ (δ (suc n) � δ (suc n)) � � (suc n)
--
-- §3 is the second difference.  Additively it reads
--
--     log δ(n+2) − 2 log δ(n+1) + log δ(n)  =  log �(n+1) ,
--
-- i.e. � is the discrete curvature of the cumulative walk volume � but
-- §3 says it with a multiplication, so it holds in � and is checked
-- rather than transported through �.
--
--   §4  and therefore � is DETERMINED by δ at three consecutive points,
--       given cancellation at δ(suc n)².  The cancellation is taken as
--       an explicit hypothesis rather than assumed: it holds as soon as
--       δ(suc n) is positive.
--
-- So the walk volume is a lossless encoding of the local prime-power
-- field: two summations up, one second difference back down, exactly,
-- with no asymptotics anywhere.
--
-- SYT � THE CLAIM, EXACTLY.  §§1�4 for every n, on the `�`, `Π�`, `δ`
-- of the DMR module as they stand.
------------------------------------------------------------------------

module DvitiyaAntara_TheLocalPrimePowerFieldIsTheMultiplicativeSecondDifferenceOfTheDMRWalkVolume where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _·_)
open import Cubical.Tactics.NatSolver using (solveℕ!)

open import RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization
  using (η ; Πη ; δ)

------------------------------------------------------------------------
-- � � The first difference.  Both are the defining clauses, so both
--     hold by `refl`: the recursions ARE the difference equations.
------------------------------------------------------------------------

delta-step : (n : ℕ) → δ (suc n) ≡ δ n · Πη n
delta-step n = refl

Pi-step : (m : ℕ) → Πη (suc m) ≡ Πη m · η (suc m)
Pi-step m = refl

------------------------------------------------------------------------
-- � � A commutative rearrangement, isolated so §3 is one rewrite.
--
--     (a � (b � c)) � d  ≡  (a � (d � b)) � c
--
-- Both sides are the product of the same four factors; over � this is
-- the semiring solver's business and not an arithmetic fact about δ.
------------------------------------------------------------------------

rearrange : (a b c d : ℕ) → (a · (b · c)) · d ≡ (a · (d · b)) · c
rearrange a b c d = solveℕ!

------------------------------------------------------------------------
-- � � THE SECOND DIFFERENCE.
--
--   δ(n+2) � δ(n)
--     = (δ(n+1) � Π�(n+1)) � δ(n)              §1 at n+1
--     = (δ(n+1) � (Π� n � �(n+1))) � δ(n)      §2 at n
--     = (δ(n+1) � (δ(n) � Π� n)) � �(n+1)      rearrangement
--     = (δ(n+1) � δ(n+1)) � �(n+1)             §1 at n, backwards.
------------------------------------------------------------------------

second-difference :
    (n : ℕ)
  → δ (suc (suc n)) · δ n ≡ (δ (suc n) · δ (suc n)) · η (suc n)
second-difference n =
    (δ (suc n) · (Πη n · η (suc n))) · δ n
  ≡⟨ rearrange (δ (suc n)) (Πη n) (η (suc n)) (δ n) ⟩
    (δ (suc n) · (δ n · Πη n)) · η (suc n)
  ≡⟨ refl ⟩
    (δ (suc n) · δ (suc n)) · η (suc n) ∎

------------------------------------------------------------------------
-- � � AND SO � IS DETERMINED BY δ.  Any `k` satisfying the second
--     difference at n is � (suc n), as soon as the common factor can be
--     cancelled.  The hypothesis is carried, not discharged.
------------------------------------------------------------------------

η-is-determined :
    (n k : ℕ)
  → ((a b : ℕ) → (δ (suc n) · δ (suc n)) · a ≡ (δ (suc n) · δ (suc n)) · b → a ≡ b)
  → δ (suc (suc n)) · δ n ≡ (δ (suc n) · δ (suc n)) · k
  → k ≡ η (suc n)
η-is-determined n k cancel eq =
  cancel k (η (suc n)) (sym eq ∙ second-difference n)
