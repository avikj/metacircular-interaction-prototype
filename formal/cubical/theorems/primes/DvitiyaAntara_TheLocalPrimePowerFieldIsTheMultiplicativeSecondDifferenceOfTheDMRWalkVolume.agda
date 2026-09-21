{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्वितीय-अन्तर — the second difference.
--
-- THE LOCAL PRIME-POWER FIELD IS RECOVERED FROM THE DMR WALK VOLUME BY
-- A MULTIPLICATIVE SECOND DIFFERENCE — over ℕ, with no logarithm, no
-- reals, and no division.
--
-- `RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization`
-- puts the Davis–Matiyasevich–Robinson observable into the corpus as a
-- typed object, built from
--
--     η  j  =  p  when j is a prime power p^k (k ≥ 1), else 1
--     Πη m  =  Π_{j ≤ m} η j
--     δ  x  =  Π_{m < x} Πη m
--
-- and states RH as a uniform inequality on the harmonic sum at δ(n).
-- Nothing is proved there about δ, and that is deliberate: the type sits
-- open.  This module proves the one structural fact about δ that needs
-- no analysis — that δ loses nothing.
--
-- The usual way to say it is additive: log δ is the first Riesz mean of
-- the von Mangoldt field, and Λ is its discrete second difference.  That
-- reading needs a logarithm and hence ℝ.  It is not needed.  Both of δ's
-- defining clauses are already recursions, so the same content is a
-- product identity on ℕ:
--
--   §1  δ (suc n) ≡ δ n · Πη n            the first difference (a
--                                         quotient, stated as a product)
--   §2  Πη (suc m) ≡ Πη m · η (suc m)     the inner recursion
--   §3  δ (suc (suc n)) · δ n ≡ (δ (suc n) · δ (suc n)) · η (suc n)
--
-- §3 is the second difference.  Additively it reads
--
--     log δ(n+2) − 2 log δ(n+1) + log δ(n)  =  log η(n+1) ,
--
-- i.e. Λ is the discrete curvature of the cumulative walk volume — but
-- §3 says it with a multiplication, so it holds in ℕ and is checked
-- rather than transported through ℝ.
--
--   §4  and therefore η is DETERMINED by δ at three consecutive points,
--       given cancellation at δ(suc n)².  The cancellation is taken as
--       an explicit hypothesis rather than assumed: it holds as soon as
--       δ(suc n) is positive, and positivity of δ is a fact about `spf`
--       and the fuel recursion that this module does not prove.
--
-- So the walk volume is a lossless encoding of the local prime-power
-- field: two summations up, one second difference back down, exactly,
-- with no asymptotics anywhere.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 for every n, on the `η`, `Πη`, `δ`
-- of the DMR module as they stand.  NOT claimed: anything about the RH
-- inequality itself, which remains open there and is untouched here;
-- nothing about ζ, Dirichlet series, Mellin transforms, or analytic
-- continuation; nothing about the size of δ or of the harmonic sum; and
-- no positivity of δ — §4 carries its cancellation hypothesis in the
-- open rather than discharging it.
------------------------------------------------------------------------

module DvitiyaAntara_TheLocalPrimePowerFieldIsTheMultiplicativeSecondDifferenceOfTheDMRWalkVolume where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _·_)
open import Cubical.Tactics.NatSolver using (solveℕ!)

open import RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization
  using (η ; Πη ; δ)

------------------------------------------------------------------------
-- १ · The first difference.  Both are the defining clauses, so both
--     hold by `refl`: the recursions ARE the difference equations.
------------------------------------------------------------------------

delta-step : (n : ℕ) → δ (suc n) ≡ δ n · Πη n
delta-step n = refl

Pi-step : (m : ℕ) → Πη (suc m) ≡ Πη m · η (suc m)
Pi-step m = refl

------------------------------------------------------------------------
-- २ · A commutative rearrangement, isolated so §3 is one rewrite.
--
--     (a · (b · c)) · d  ≡  (a · (d · b)) · c
--
-- Both sides are the product of the same four factors; over ℕ this is
-- the semiring solver's business and not an arithmetic fact about δ.
------------------------------------------------------------------------

rearrange : (a b c d : ℕ) → (a · (b · c)) · d ≡ (a · (d · b)) · c
rearrange a b c d = solveℕ!

------------------------------------------------------------------------
-- ३ · THE SECOND DIFFERENCE.
--
--   δ(n+2) · δ(n)
--     = (δ(n+1) · Πη(n+1)) · δ(n)              §1 at n+1
--     = (δ(n+1) · (Πη n · η(n+1))) · δ(n)      §2 at n
--     = (δ(n+1) · (δ(n) · Πη n)) · η(n+1)      rearrangement
--     = (δ(n+1) · δ(n+1)) · η(n+1)             §1 at n, backwards.
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
-- ४ · AND SO η IS DETERMINED BY δ.  Any `k` satisfying the second
--     difference at n is η (suc n), as soon as the common factor can be
--     cancelled.  The hypothesis is carried, not discharged.
------------------------------------------------------------------------

η-is-determined :
    (n k : ℕ)
  → ((a b : ℕ) → (δ (suc n) · δ (suc n)) · a ≡ (δ (suc n) · δ (suc n)) · b → a ≡ b)
  → δ (suc (suc n)) · δ n ≡ (δ (suc n) · δ (suc n)) · k
  → k ≡ η (suc n)
η-is-determined n k cancel eq =
  cancel k (η (suc n)) (sym eq ∙ second-difference n)
