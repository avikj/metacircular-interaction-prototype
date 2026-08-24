-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PrimePairField
--
-- Delta 23 §12: the bounded prime-pair dependent type, with Goldbach and
-- twin primes as the two transverse fibrations of ONE object.
-- Companion prose: notes/TWO_FIBRATIONS_ONE_FIELD.md.
--
-- WHAT THIS IS NOT.  Writing Goldbach as a type is not progress on
-- Goldbach.  `Goldbach` and `Twin` below are DEFINITIONS; they are
-- restatements, and nothing here proves or weakens either.
-- NATURAL_MACHINE.md's own standard applies: an asserted isomorphism is
-- not transport, and a definition is not a theorem.
--
-- WHAT IS CONTENT.  Delta 23 §2 claims Goldbach and twin primes are
-- "transverse global properties of the support of one dependent type".
-- That claim is exact and checkable, and §3 identifies the two
-- foliations as the anti-diagonal and the off-diagonal.  Checked here:
--
--   * centre and gap ARE the two light-cone coordinates of
--     CenterRelative (fibreCentre / fibreGap);
--   * every prime pair lands in the open positive cone (inCone);
--   * the one-leg reflection J₂ EXCHANGES the two foliations
--     (Delta 16 Cor 16.2) but provably CANNOT preserve the cone
--     (noSelfDualPair).
--
-- So the involution that would carry Goldbach's fibration to the twin
-- fibration is exactly the one that destroys the positivity making them
-- arithmetic statements.  That is a real obstruction, and it is why
-- "two projections of one object" does not reduce either to the other.
------------------------------------------------------------------------

module PrimePairField where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; suc ; zero) renaming (_+_ to _+ℕ_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; _+_ ; _-_ ; -_ ; fromNatℤ ; pos+)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁)

open import CenterRelative
  using ( Φraw ; J₂CR ; τCR ; Pos ; InCone ; u₋ ; u₊
        ; thm17-1-lower ; thm17-1-upper ; thm16-4 ; exchangePreservesCone )

------------------------------------------------------------------------
-- 1.  The field, over any primality predicate
--
-- Delta 23 §12 asks for `Prime_X`, a decidable bounded prime type.  The
-- structural theorems below do not depend on HOW primality is decided,
-- so the predicate is a parameter: nothing here smuggles in arithmetic.
------------------------------------------------------------------------

module Field (IsPrime : ℤ → Type) where

  -- A prime pair, carrying its positivity as data.  Legs, not centre and
  -- radius: those are derived, which is the point.
  PrimePair : Type
  PrimePair =
    Σ[ p ∈ ℤ ] Σ[ q ∈ ℤ ]
      ((IsPrime p × IsPrime q) × (Pos p × Pos q))

  leg₁ leg₂ : PrimePair → ℤ
  leg₁ (p , _)         = p
  leg₂ (_ , q , _)     = q

  -- Delta 23 §2's two projections, as Delta 16 defines them:
  --   centre = p + q   (the anti-diagonal coordinate, W)
  --   gap    = q - p   (the off-diagonal coordinate, R)
  toCR : PrimePair → ℤ × ℤ
  toCR (p , q , _) = Φraw (p , q)

  centre gap : PrimePair → ℤ
  centre x = fst (toCR x)
  gap    x = snd (toCR x)

  ----------------------------------------------------------------------
  -- 2.  The two conjectures, as DEFINITIONS (Delta 23 §2)
  --
  -- Stated, not proved, not weakened.  They are here so that §3's
  -- structural theorems have something to be about.
  ----------------------------------------------------------------------

  -- Goldbach: every sufficiently large centre fibre is inhabited.
  -- "Sufficiently large" is left as the predicate `Large`, since the
  -- bound is not what is at issue.
  Goldbach : (Large : ℤ → Type) → Type
  Goldbach Large =
    (w : ℤ) → Large w → ∥ (Σ[ x ∈ PrimePair ] (centre x ≡ w)) ∥₁

  -- Twin primes: the fixed-gap fibre at gap 2 is cofinal in centre.
  Twin : (Beyond : ℤ → ℤ → Type) → Type
  Twin Beyond =
    (m : ℤ) → ∥ (Σ[ x ∈ PrimePair ] ((gap x ≡ pos 2) × Beyond m (centre x))) ∥₁

  ----------------------------------------------------------------------
  -- 3.  The content: the two fibrations are the light-cone coordinates
  ----------------------------------------------------------------------

  -- The centre fibration is the first light-cone coordinate doubled:
  -- fixing the centre fixes p + q.
  fibreCentre : (x : PrimePair) → u₋ (toCR x) ≡ leg₁ x + leg₁ x
  fibreCentre (p , q , _) = thm17-1-lower p q

  -- The gap fibration is the second: fixing the gap fixes q - p.
  fibreGap : (x : PrimePair) → u₊ (toCR x) ≡ leg₂ x + leg₂ x
  fibreGap (p , q , _) = thm17-1-upper p q

  -- Positivity of both legs is inherited by the cone.
  private
    posDouble : (n : ℤ) → Pos n → Pos (n + n)
    posDouble n (m , e) =
      (m +ℕ suc m) , (cong₂ _+_ e e ∙ sym (pos+ (suc m) (suc m)))

  inCone : (x : PrimePair) → InCone (toCR x)
  inCone (p , q , (_ , (pp , qp))) =
    subst Pos (sym (thm17-1-lower p q)) (posDouble p pp) ,
    subst Pos (sym (thm17-1-upper p q)) (posDouble q qp)

  ----------------------------------------------------------------------
  -- 4.  The obstruction
  --
  -- Delta 16 Cor 16.2: J₂ carries the fixed-centre foliation to the
  -- fixed-relative foliation -- exactly the exchange Delta 23 §3 wants
  -- between Goldbach and twin primes.  But thm16-4 says J₂ cannot
  -- preserve the cone, and §3 above says every prime pair is IN the cone.
  --
  -- Hence: no prime pair's image survives the exchange.
  ----------------------------------------------------------------------

  noSelfDualPair : (x : PrimePair) → ¬ InCone (J₂CR (toCR x))
  noSelfDualPair x = thm16-4 (toCR x) (inCone x)

  -- By contrast the leg exchange τ (Weyl reflection) preserves the cone,
  -- so it is an honest symmetry of the field.  The two involutions are
  -- not interchangeable, and this is where they part.
  exchangeStays : (x : PrimePair) → InCone (τCR (toCR x))
  exchangeStays x = exchangePreservesCone (toCR x) (inCone x)

------------------------------------------------------------------------
-- 5.  Controls: the development is not vacuous
--
-- A vacuous formalisation typechecks as happily as a substantial one,
-- and the fleet audit of 2026-08-14 found that CenterRelative was the
-- only module in this tree carrying its own controls.  So:
------------------------------------------------------------------------

module Controls where

  -- A primality predicate that holds of exactly 3 and 5.  Enough to
  -- exhibit a genuine inhabitant; nothing here claims to decide primality.
  data Tiny : ℤ → Type where
    three : Tiny (pos 3)
    five  : Tiny (pos 5)

  open Field Tiny

  pos3 : Pos (pos 3)
  pos3 = 2 , refl

  pos5 : Pos (pos 5)
  pos5 = 4 , refl

  -- The twin pair (3,5): centre 8, gap 2.
  twin35 : PrimePair
  twin35 = pos 3 , pos 5 , ((three , five) , (pos3 , pos5))

  -- Its coordinates compute.
  centre-twin35 : centre twin35 ≡ pos 8
  centre-twin35 = refl

  gap-twin35 : gap twin35 ≡ pos 2
  gap-twin35 = refl

  -- It is in the cone, so §3 is inhabited ...
  twin35InCone : InCone (toCR twin35)
  twin35InCone = inCone twin35

  -- ... and §4 is a statement about something that exists.
  twin35NotSelfDual : ¬ InCone (J₂CR (toCR twin35))
  twin35NotSelfDual = noSelfDualPair twin35
