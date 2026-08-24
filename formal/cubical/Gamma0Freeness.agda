-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Gamma0Freeness
--
-- Freeness of the stabilizer action on normalization events, over all
-- of ℤ: if H·U ≡ U for a unimodular U, then H is the identity.  This
-- is the torsor's freeness clause (R0033): distinct payloads move the
-- base event to distinct events — the payload is faithful.
--
-- Proof: right-multiply by adj U, associate (solver, entrywise),
-- collapse U·adj U to det·I (M2Unimodular), then cancel the nonzero
-- determinant entrywise by integrality of ℤ.  Discreteness and
-- integrality each enter exactly once, both through M2Unimodular.
------------------------------------------------------------------------

module Gamma0Freeness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Int using (isIntegralℤ)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R ; M ; mul ; dia)
open import M2Unimodular using (adj ; det ; idm ; adjR ; unimodularNonzero)

open CommRingStr (ℤCommRing .snd)

-- associativity of 2x2 multiplication, entrywise by solver ------------

private
  as11 : (a b c e a' b' c' e' a'' b'' c'' e'' : R)
       → (a · a' + b · c') · a'' + (a · b' + b · e') · c''
         ≡ a · (a' · a'' + b' · c'') + b · (c' · a'' + e' · c'')
  as11 _ _ _ _ _ _ _ _ _ _ _ _ = solve! ℤCommRing
  as12 : (a b c e a' b' c' e' a'' b'' c'' e'' : R)
       → (a · a' + b · c') · b'' + (a · b' + b · e') · e''
         ≡ a · (a' · b'' + b' · e'') + b · (c' · b'' + e' · e'')
  as12 _ _ _ _ _ _ _ _ _ _ _ _ = solve! ℤCommRing
  as21 : (a b c e a' b' c' e' a'' b'' c'' e'' : R)
       → (c · a' + e · c') · a'' + (c · b' + e · e') · c''
         ≡ c · (a' · a'' + b' · c'') + e · (c' · a'' + e' · c'')
  as21 _ _ _ _ _ _ _ _ _ _ _ _ = solve! ℤCommRing
  as22 : (a b c e a' b' c' e' a'' b'' c'' e'' : R)
       → (c · a' + e · c') · b'' + (c · b' + e · e') · e''
         ≡ c · (a' · b'' + b' · e'') + e · (c' · b'' + e' · e'')
  as22 _ _ _ _ _ _ _ _ _ _ _ _ = solve! ℤCommRing

mulAssoc : (x y z : M) → mul (mul x y) z ≡ mul x (mul y z)
mulAssoc (a , b , c , e) (a' , b' , c' , e') (a'' , b'' , c'' , e'') i =
  ( as11 a b c e a' b' c' e' a'' b'' c'' e'' i
  , as12 a b c e a' b' c' e' a'' b'' c'' e'' i
  , as21 a b c e a' b' c' e' a'' b'' c'' e'' i
  , as22 a b c e a' b' c' e' a'' b'' c'' e'' i )

-- entry lemmas for cancelling a diagonal factor ----------------------

private
  s1 : (h11 h12 d : R) → d · h11 ≡ h11 · d + h12 · 0r
  s1 _ _ _ = solve! ℤCommRing
  s3 : (h21 h22 d : R) → d · h22 ≡ h21 · 0r + h22 · d
  s3 _ _ _ = solve! ℤCommRing
  r2 : (h11 h12 d : R) → d · h12 ≡ h11 · 0r + h12 · d
  r2 _ _ _ = solve! ℤCommRing
  r3 : (h21 h22 d : R) → d · h21 ≡ h21 · d + h22 · 0r
  r3 _ _ _ = solve! ℤCommRing
  oneR : (d : R) → d ≡ d · 1r
  oneR d = sym (·IdR d)
  cancelSelf : (x : R) → x - x ≡ 0r
  cancelSelf _ = solve! ℤCommRing
  distSub : (x a b : R) → x · (a - b) ≡ x · a - x · b
  distSub _ _ _ = solve! ℤCommRing
  addBack : (a b : R) → a ≡ (a - b) + b
  addBack _ _ = solve! ℤCommRing
  zeroAdd : (b : R) → 0r + b ≡ b
  zeroAdd _ = solve! ℤCommRing

  fromDiff : (a b : R) → a - b ≡ 0r → a ≡ b
  fromDiff a b p = addBack a b ∙ cong (_+ b) p ∙ zeroAdd b

  -- cancellation of a nonzero factor, with the subtraction kept
  -- symbolic (the solver cannot see literals under ℤ subtraction:
  -- x - 1 computes to predℤ x before reflection)
  genCancel : (x a b : R) → x · a ≡ x · b → (x ≡ 0r → ⊥) → a ≡ b
  genCancel x a b p xnz =
    fromDiff a b
      (isIntegralℤ x (a - b)
        (distSub x a b ∙ cong (λ w → w - x · b) p ∙ cancelSelf (x · b))
        xnz)

-- the theorem ---------------------------------------------------------

module _ (h11 h12 h21 h22 : R)
         (u11 u12 u21 u22 : R)
         (εu : R)
         (hdetU : u11 · u22 - u12 · u21 ≡ εu)
         (hεu : εu · εu ≡ 1r)
         (hfix : mul (h11 , h12 , h21 , h22) (u11 , u12 , u21 , u22)
                 ≡ (u11 , u12 , u21 , u22)) where

  private
    H U : M
    H = (h11 , h12 , h21 , h22)
    U = (u11 , u12 , u21 , u22)

    dU : R
    dU = det U

    dUnz : (dU ≡ 0r) → ⊥
    dUnz p = unimodularNonzero εu hεu (sym hdetU ∙ p)

    -- H · (dU · I) ≡ dU · I
    collapse : mul H (dia dU dU) ≡ dia dU dU
    collapse =
      cong (mul H) (sym (adjR U))
      ∙ sym (mulAssoc H U (adj U))
      ∙ cong (λ m → mul m (adj U)) hfix
      ∙ adjR U

    q1 : h11 · dU + h12 · 0r ≡ dU
    q1 i = fst (collapse i)
    q2 : h11 · 0r + h12 · dU ≡ 0r
    q2 i = fst (snd (collapse i))
    q3 : h21 · dU + h22 · 0r ≡ 0r
    q3 i = fst (snd (snd (collapse i)))
    q4 : h21 · 0r + h22 · dU ≡ dU
    q4 i = snd (snd (snd (collapse i)))

    p1 : h11 ≡ 1r
    p1 = genCancel dU h11 1r (s1 h11 h12 dU ∙ q1 ∙ oneR dU) dUnz
    p2 : h12 ≡ 0r
    p2 = isIntegralℤ dU h12 (r2 h11 h12 dU ∙ q2) dUnz
    p3 : h21 ≡ 0r
    p3 = isIntegralℤ dU h21 (r3 h21 h22 dU ∙ q3) dUnz
    p4 : h22 ≡ 1r
    p4 = genCancel dU h22 1r (s3 h21 h22 dU ∙ q4 ∙ oneR dU) dUnz

  -- the action on events is free: a payload fixing one event is trivial
  freeness : H ≡ idm
  freeness i = (p1 i , p2 i , p3 i , p4 i)
