{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EGB.SuccessorCost
--
-- The Rust natural machine's REOPEN scan on ℤ/12 printed "persistent 7"
-- for the successor action r ↦ r + 1.  Seven is not a measurement; it is
-- a closed form the machine already knew (Ramanujan strand: a number the
-- machine printed is an identity wearing a scan's costume).
--
-- Write m = 2^a · q with q odd.  The machine's state count for m is
-- q + a: the SUM–PRODUCT SPLIT of the integer m — the odd part q enters
-- additively as itself, the 2-part 2^a enters additively as its exponent
-- a.  The successor's reopening cost is the whole gap between the
-- product reading and the sum reading of m:
--
--     m − (q + a)  =  q·2^a − (q + a)  =  q·(2^a − 1) − a.
--
-- At (a,q) = (2,3), m = 12: both sides are 7.  The scan output is the
-- right-hand side; the identity below makes it a checked term.
--
-- What is proved here (arithmetic only):
--   • costAgree   — the two subtraction forms agree for ALL a, q, with
--                   no hypotheses at all (truncated ∸ absorbs every
--                   degenerate case symmetrically; this is formulation
--                   (ii) of the brief, closed in more generality than
--                   asked: the 1 ≤ q hypothesis proved unnecessary).
--   • costLaw⁺    — the addition form (no subtraction on the left):
--                   (q + a) + cost ≡ m, under the single hypothesis
--                   1 ≤ q; the side condition a ≤ q·(2^a − 1) is
--                   DERIVED, not assumed, via suc a ≤ 2^a.
--   • machine7 …  — the machine's scan outputs (a,q) = (2,3), (3,1),
--                   (1,5), (0,7) as computed normal forms (refl).
--
-- NOT claimed: anything about the Rust machine's semantics.  The bridge
-- "cost of the successor action = this number" is the machine lane's to
-- certify.  This module is the arithmetic identity only.
------------------------------------------------------------------------

module EGB.SuccessorCost where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order

------------------------------------------------------------------------
-- Positivity of 2^a, in the form the split needs: 2^a is a successor.

private
  pow2Pos : (a : ℕ) → Σ ℕ (λ k → 2 ^ a ≡ suc k)
  pow2Pos zero = 0 , refl
  pow2Pos (suc a) =
    let k = fst (pow2Pos a)
    in k + suc (k + 0) , cong (2 ·_) (snd (pow2Pos a))

  -- 2^a ≡ suc (2^a ∸ 1): the truncated predecessor is exact here.
  pow2suc : (a : ℕ) → 2 ^ a ≡ suc (2 ^ a ∸ 1)
  pow2suc a =
    snd (pow2Pos a) ∙ cong suc (sym (cong (_∸ 1) (snd (pow2Pos a))))

------------------------------------------------------------------------
-- The sum–product split of m = q·2^a: peel one copy of q off the
-- product.  This single rewriting is the whole content of "7".

splitPow : (q a : ℕ) → q · 2 ^ a ≡ q + q · (2 ^ a ∸ 1)
splitPow q a = cong (q ·_) (pow2suc a) ∙ ·-suc q (2 ^ a ∸ 1)

------------------------------------------------------------------------
-- PRIMARY: the two ways of writing the reopening cost agree,
-- for all a and q, no hypotheses.
--
--   m ∸ (state count)  =  q·(2^a ∸ 1) ∸ a.
--
-- Proof: split m as q + q·(2^a ∸ 1) and cancel q on both sides of ∸.

costAgree : (a q : ℕ) → q · 2 ^ a ∸ (q + a) ≡ q · (2 ^ a ∸ 1) ∸ a
costAgree a q =
  cong (_∸ (q + a)) (splitPow q a) ∙ ∸-cancelˡ q (q · (2 ^ a ∸ 1)) a

------------------------------------------------------------------------
-- The side condition for the addition form, derived from scratch:
-- a < 2^a, hence a ≤ 2^a ∸ 1, hence a ≤ q·(2^a ∸ 1) for q ≥ 1.

private
  sucA≤pow2 : (a : ℕ) → suc a ≤ 2 ^ a
  sucA≤pow2 zero = ≤-refl
  sucA≤pow2 (suc a) =
    subst (λ y → suc (suc a) ≤ y)
          (cong (2 ^ a +_) (sym (+-zero (2 ^ a))))
          (≤-trans step1 step2)
    where
    -- suc (suc a) = 1 + suc a ≤ suc a + suc a
    step1 : 1 + suc a ≤ suc a + suc a
    step1 = ≤-+k (suc-≤-suc zero-≤)

    step2 : suc a + suc a ≤ 2 ^ a + 2 ^ a
    step2 = ≤-+-≤ (sucA≤pow2 a) (sucA≤pow2 a)

  a≤pow2∸1 : (a : ℕ) → a ≤ 2 ^ a ∸ 1
  a≤pow2∸1 a =
    fst s , cong (_∸ 1) (sym (+-suc (fst s) a) ∙ snd s)
    where s = sucA≤pow2 a

  a≤cost : (a q : ℕ) → 1 ≤ q → a ≤ q · (2 ^ a ∸ 1)
  a≤cost a q h = ≤-trans (a≤pow2∸1 a) step
    where
    step : 2 ^ a ∸ 1 ≤ q · (2 ^ a ∸ 1)
    step = subst (λ y → y ≤ q · (2 ^ a ∸ 1))
                 (·-identityˡ (2 ^ a ∸ 1))
                 (≤-·k {k = 2 ^ a ∸ 1} h)

------------------------------------------------------------------------
-- The addition form: state count plus reopening cost reassembles m,
-- with no subtraction on the outside.  Hypothesis 1 ≤ q only (q is the
-- odd part of a positive integer, so this is no restriction); the
-- inequality a ≤ q·(2^a ∸ 1) is derived above, not assumed.

costLaw⁺ : (a q : ℕ) → 1 ≤ q
         → (q + a) + (q · (2 ^ a ∸ 1) ∸ a) ≡ q · 2 ^ a
costLaw⁺ a q h =
    sym (+-assoc q a (c ∸ a))
  ∙ cong (q +_) (+-comm a (c ∸ a) ∙ ≤-∸-+-cancel (a≤cost a q h))
  ∙ sym (splitPow q a)
  where c = q · (2 ^ a ∸ 1)

------------------------------------------------------------------------
-- The machine's scan outputs as computed normal forms.  Each is refl:
-- the type checker evaluates both readings of the cost to the same
-- numeral.  (a,q) = (2,3) is ℤ/12, the "persistent 7".

machine7 : 3 · 2 ^ 2 ∸ (3 + 2) ≡ 7          -- m = 12, cost 7
machine7 = refl

machine7' : 3 · (2 ^ 2 ∸ 1) ∸ 2 ≡ 7         -- same 7, other reading
machine7' = refl

machine7⁺ : (3 + 2) + (3 · (2 ^ 2 ∸ 1) ∸ 2) ≡ 3 · 2 ^ 2
machine7⁺ = refl                             -- 5 states + 7 cost = 12

machine4a : 1 · 2 ^ 3 ∸ (1 + 3) ≡ 4         -- m = 8,  (a,q) = (3,1)
machine4a = refl

machine4b : 5 · 2 ^ 1 ∸ (5 + 1) ≡ 4         -- m = 10, (a,q) = (1,5)
machine4b = refl

machine0 : 7 · 2 ^ 0 ∸ (7 + 0) ≡ 0          -- m = 7 odd: no gap at all
machine0 = refl
