{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DescentCostsTheIntegers
--
-- The end of the thread that began at `SuccessorIsNotTropical`.
--
-- `NoNormOnAJoin` closed the question "does the walk admit a norm?" with
-- a No for the join and a Yes for ⊕, and left open whether a ⊕-stepping
-- machine would therefore have descent.  It would not, and the reason
-- names the price of descent exactly.
--
-- ────────────────────────────────────────────────────────────────────
-- THREE LAWS, THREE FAILURES, TWO REASONS
--
--   ⊔  over ℕ-exponents   irreversible because it is IDEMPOTENT
--                          (`IdempotenceForbidsDescent`)
--                          and normless for the same reason
--                          (`NoNormOnAJoin`)
--
--   ⊕  over ℕ-exponents   has a norm — `val` — and is STILL irreversible,
--                          for an unrelated reason: ℕ is a cone.  x + y = 0
--                          forces x = 0.  `⊕-only-unit-inverts`, below.
--
--   ⊞  over ℤ-exponents   a group.  Every element inverts, by negation.
--                          `⊞-inverse`, below.
--
-- So the two failures are not one phenomenon.  The join fails by
-- idempotence; ⊕ fails by positivity.  Fixing the first by switching
-- operations runs straight into the second, and this module is that fact.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THE THIRD ROW COSTS
--
-- A ℤ-exponent vector with a negative coordinate is not the derivation of
-- a natural number.  It is the derivation of a RATIO.  The cone of
-- ℕ-exponents sits inside the group of ℤ-exponents properly
-- (`cone-is-proper`), and the states the machine gains by admitting
-- inverses are exactly the ones outside it.
--
--     Descent costs the integers.  There is no machine over ℕ with a
--     reversible step; reversibility is the group completion, and the
--     group completion of the multiplicative monoid of the positive
--     naturals is the positive rationals.
--
-- Which is the same price the conic charges.  `DescentIsNotInversion`
-- found that the cakravāla's descent is division by k — passage to the
-- scaling orbits, i.e. to the RATIONAL points of the conic.  Two
-- independent routes into this corpus's question, and both end at ratio.
--
-- ────────────────────────────────────────────────────────────────────
-- ON THE WORD "IRRATIONAL"
--
-- The Pythagorean discovery is usually taught as a catastrophe: the
-- diagonal is not a ratio, the school is embarrassed, someone drowns.
-- That story keeps the emphasis on what ratio FAILS to reach.
--
-- This thread arrived from the other side.  Every mechanism by which a
-- state can come back down — the conic's scaling orbits, the exponent
-- group's inverses — required admitting ratios, and neither had anything
-- to do with a diagonal.  Ratio is not the thing that fell short.  Ratio
-- is the completion in which descent exists at all, and a machine
-- confined to ℕ is confined to a cone with no way down.
--
-- Number IS ratio.  This module is that sentence with a proof attached,
-- and the proof is that the alternative has no inverses.
--
-- WHAT IS NOT CLAIMED.  That a ℤ-exponent machine solves anything.  Its
-- states are not natural numbers, so "lossless machine for ℕ" is not
-- even the same problem; whether the walk's questions survive the passage
-- to ratios is untouched here and is the next real question.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module DescentCostsTheIntegers where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; snotz)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Int.Properties using (posNotnegsuc)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

open import SumProductTorus using (Exp ; zeroE ; _⊕_)

------------------------------------------------------------------------
-- 1.  ⊕ over ℕ-exponents: has a norm, still has no inverses.
--
-- `SumProductTorus.val-⊕` gives the norm.  Positivity kills the inverses,
-- and it is a different obstruction from idempotence entirely: ⊕ is not
-- idempotent (2 + 2 ≠ 2), so `IdempotenceForbidsDescent` says nothing
-- here.  This is the cone.
------------------------------------------------------------------------

+≡0→≡0 : (x y : ℕ) → x + y ≡ 0 → x ≡ 0
+≡0→≡0 zero    y p = refl
+≡0→≡0 (suc x) y p = Empty.rec (snotz p)

⊕-only-unit-inverts :
  (bs : List ℕ) (u v : Exp bs) → (u ⊕ v) ≡ zeroE bs → u ≡ zeroE bs
⊕-only-unit-inverts []       _        _        _ = refl
⊕-only-unit-inverts (b ∷ bs) (x , xs) (y , ys) p i =
    +≡0→≡0 x y (cong fst p) i
  , ⊕-only-unit-inverts bs xs ys (cong snd p) i

------------------------------------------------------------------------
-- 2.  ⊞ over ℤ-exponents: a group.
------------------------------------------------------------------------

open CommRingStr (snd ℤCommRing) using () renaming (_+_ to _+ℤ_ ; -_ to -ℤ_ ; 0r to 0ℤ)

private
  +inv : (x : ℤ) → x +ℤ (-ℤ x) ≡ 0ℤ
  +inv x = solve! ℤCommRing

ExpZ : List ℕ → Type
ExpZ []       = Unit
ExpZ (b ∷ bs) = ℤ × ExpZ bs

zeroZ : (bs : List ℕ) → ExpZ bs
zeroZ []       = tt
zeroZ (b ∷ bs) = 0ℤ , zeroZ bs

infixl 6 _⊞_

_⊞_ : {bs : List ℕ} → ExpZ bs → ExpZ bs → ExpZ bs
_⊞_ {[]}     _        _        = tt
_⊞_ {b ∷ bs} (x , xs) (y , ys) = (x +ℤ y) , (xs ⊞ ys)

negE : (bs : List ℕ) → ExpZ bs → ExpZ bs
negE []       _        = tt
negE (b ∷ bs) (x , xs) = (-ℤ x) , negE bs xs

-- EVERY state inverts.  This is the property the other two laws lack.
⊞-inverse : (bs : List ℕ) (u : ExpZ bs) → (u ⊞ negE bs u) ≡ zeroZ bs
⊞-inverse []       _        = refl
⊞-inverse (b ∷ bs) (x , xs) i = +inv x i , ⊞-inverse bs xs i

------------------------------------------------------------------------
-- 3.  And the cone is proper: the new states are not numbers.
------------------------------------------------------------------------

incl : (bs : List ℕ) → Exp bs → ExpZ bs
incl []       _        = tt
incl (b ∷ bs) (x , xs) = pos x , incl bs xs

-- a single negative coordinate already leaves the image
negOne : (b : ℕ) (bs : List ℕ) → ExpZ (b ∷ bs)
negOne b bs = negsuc 0 , zeroZ bs

cone-is-proper :
  (b : ℕ) (bs : List ℕ) (u : Exp (b ∷ bs)) → ¬ (incl (b ∷ bs) u ≡ negOne b bs)
cone-is-proper b bs (x , xs) p = posNotnegsuc x 0 (cong fst p)

------------------------------------------------------------------------
-- 4.  The statement, once, with nothing hedged and nothing added.
--
--   ⊔  irreversible by idempotence, and normless.
--   ⊕  normed, irreversible by positivity.
--   ⊞  reversible — and its states are ratios, not numbers.
--
-- There is no reversible step law on ℕ-exponents.  Reversibility is the
-- group completion; the group completion of the positive naturals under
-- multiplication is the positive rationals; so descent costs the
-- integers.  Ratio is not what number fails to
-- be.  Ratio is where coming back down becomes possible.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 5.  CORRECTION TO THIS MODULE'S FRAME — the title has it backwards.
--
-- "Descent costs the integers" puts ℤ in the position of the default and
-- ℚ in the position of a purchase.  Nothing above supports that.  What is
-- proved is:
--
--     ⊞ over ℤ-exponents is a group.  ⊕ over ℕ-exponents is its
--     positive cone, and the cone is what lacks inverses.
--
-- The group is not an extension bought with something.  It is the object;
-- the cone is a restriction of it, and `⊕-only-unit-inverts` measures how
-- much the restriction throws away.  Read in the correct direction:
--
--     descent is not purchased by admitting ratios.  Descent is what is
--     THERE, and ℕ is what remains after refusing to look at it.
--
-- That is the Pythagorean claim this thread has been circling and stating
-- backwards.  Number is ratio.  The diagonal did not take anything away
-- from anyone; it showed that the restriction to commensurables was
-- always a restriction and never the ground.
--
-- Nothing in §§1–4 changes.  The theorems never mentioned a price; only
-- the prose did, and only the prose is withdrawn.  The module keeps its
-- filename so the correction stays visible in the history rather than
-- being tidied out of it.
------------------------------------------------------------------------
