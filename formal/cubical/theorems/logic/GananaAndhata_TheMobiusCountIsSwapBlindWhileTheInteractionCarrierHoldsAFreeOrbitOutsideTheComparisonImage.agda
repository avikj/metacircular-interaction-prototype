{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गणना-अन्धता — the count's blindness.
--
-- THE CLAIM, in the language of the moduli conversation (2026-09-03):
-- the finite Möbius interaction I₂ = |top| − |mid₁| − |mid₂| + |bot|
-- is the decategorified shadow of the second cross-effect.  A cross-
-- effect carries a Σ₂-action; an alternating sum of cardinalities is
-- Σ₂-INVARIANT BY CONSTRUCTION and so cannot receive that action.
-- Therefore interaction can hide where no symmetric count reaches:
-- stored not in how many witnesses there are, but in how the swap
-- moves them.  Here is the smallest exhibit.
--
--   §1  THE FUNCTIONAL IS BLIND, in general: for every square of
--       counts, swapping the two middle entries fixes the Möbius
--       functional — one commutativity of +, nothing else.  The
--       blindness is not a fact about an example; it is a property
--       of the receiver ℕ, proved before any square is chosen.
--
--   §2  THE SQUARE: four copies of Bool, every leg constant.  The
--       Möbius count vanishes: 2 + 2 = 2 + 2, by refl — at the level
--       of cardinality this square says "no pair interaction".
--
--   §3  THE CARRIER IS NOT BLIND: the pullback of the two legs holds
--       the points p = (false,true) and q = (true,false).  Neither is
--       in the image of the comparison map from the bottom (both its
--       values have equal coordinates — computed, both cases).  The
--       swap of the two middle vertices is an automorphism of the
--       square; on the carrier it exchanges p and q, and p ≢ q.  A
--       free orbit of obstruction witnesses, invisible to §1.
--
-- So at k = 2: a square whose scalar interaction is zero, whose
-- comparison map is not surjective, and whose missed witnesses form
-- an orbit the symmetry moves freely.  The synergy is real and it is
-- carried ENTIRELY by the action — precisely what the trace-derivative
-- reading predicts the equivariant cross-effect sees and the Möbius
-- calculus cannot.
--
-- SYĀT — THE CLAIM, EXACTLY.  §1 for all counts; §2 and §3 for the
-- exhibited square: vanishing count, two named points outside the
-- comparison image, the swap exchanging them, their distinctness.
-- NOT claimed: that every zero-count square hides an orbit (false:
-- the cartesian squares do not), nor that no fixed missed witness
-- exists here (the diagonal point (true,true) is fixed and missed);
-- what is claimed and shown is that free-orbit synergy EXISTS below
-- the count's resolution, so the scalar calculus is not faithful.
------------------------------------------------------------------------

module GananaAndhata_TheMobiusCountIsSwapBlindWhileTheInteractionCarrierHoldsAFreeOrbitOutsideTheComparisonImage where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; +-comm)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as Empty using (⊥)

------------------------------------------------------------------------
-- १ · The Möbius functional cannot receive the swap.
--
-- To stay in ℕ the functional is carried as its positive and negative
-- parts: I₂ = (top + bot) − (mid₁ + mid₂).  Swapping the middles fixes
-- both parts; +-comm is the entire proof.  Every alternating count of
-- a two-cube factors through unordered middle data.
------------------------------------------------------------------------

mobiusPos : ℕ → ℕ → ℕ → ℕ → ℕ
mobiusPos top mid₁ mid₂ bot = top + bot

mobiusNeg : ℕ → ℕ → ℕ → ℕ → ℕ
mobiusNeg top mid₁ mid₂ bot = mid₁ + mid₂

swapBlindPos : (t m₁ m₂ b : ℕ) → mobiusPos t m₂ m₁ b ≡ mobiusPos t m₁ m₂ b
swapBlindPos t m₁ m₂ b = refl

swapBlindNeg : (t m₁ m₂ b : ℕ) → mobiusNeg t m₂ m₁ b ≡ mobiusNeg t m₁ m₂ b
swapBlindNeg t m₁ m₂ b = +-comm m₂ m₁

------------------------------------------------------------------------
-- २ · The square.  X∅ → X₁, X₂ → X₁₂, all four vertices Bool, every
--     leg the constant map at false.  It commutes on the nose.
------------------------------------------------------------------------

X : Type₀
X = Bool

e₁ e₂ : X → X          -- bottom into the two middles
e₁ _ = false
e₂ _ = false

f₁ f₂ : X → X          -- the two middles into the top
f₁ _ = false
f₂ _ = false

-- the Möbius count of this square vanishes: positive part = negative
-- part, by refl, with |Bool| = 2 at every vertex.
countVanishes : mobiusPos 2 2 2 2 ≡ mobiusNeg 2 2 2 2
countVanishes = refl

------------------------------------------------------------------------
-- ३ · The carrier, the comparison, the free orbit.
------------------------------------------------------------------------

-- the pullback of f₁ against f₂: pairs agreeing at the top.
P : Type₀
P = Σ X λ a → Σ X λ b → f₁ a ≡ f₂ b

-- the comparison map from the bottom vertex.
compare : X → P
compare x = e₁ x , e₂ x , refl

-- two witnesses at the top the bottom never reaches:
p q : P
p = false , true  , refl
q = true  , false , refl

-- the swap of the two middle vertices, as it acts on the carrier.
-- (It is an automorphism of the square: e₁ = e₂ and f₁ = f₂ hold
-- definitionally, so commutation with every leg is refl.)
σ : P → P
σ (a , b , _) = b , a , refl

-- it exchanges the witnesses…
σp≡q : σ p ≡ q
σp≡q = refl

σq≡p : σ q ≡ p
σq≡p = refl

-- …which are distinct: the orbit is free.
p≢q : p ≡ q → ⊥
p≢q e = false≢true (cong fst e)

-- and both lie outside the comparison image: every value of `compare`
-- has equal coordinates, p and q do not.  Both bottom points checked;
-- nothing sampled.
p-missed : (x : X) → compare x ≡ p → ⊥
p-missed x e = false≢true (cong (λ r → fst (snd r)) e)

q-missed : (x : X) → compare x ≡ q → ⊥
q-missed x e = false≢true (cong fst e)

------------------------------------------------------------------------
-- The statement assembled: one square, count zero (§2), yet the
-- carrier holds the pair {p, q} — missed by the comparison map, and
-- swapped freely by the symmetry the count provably cannot see (§1).
------------------------------------------------------------------------

record FreeOrbitBelowTheCount : Type₀ where
  field
    vanishing : mobiusPos 2 2 2 2 ≡ mobiusNeg 2 2 2 2
    missedP   : (x : X) → compare x ≡ p → ⊥
    missedQ   : (x : X) → compare x ≡ q → ⊥
    moved     : σ p ≡ q
    movedBack : σ q ≡ p
    free      : p ≡ q → ⊥

theExhibit : FreeOrbitBelowTheCount
theExhibit = record
  { vanishing = countVanishes
  ; missedP   = p-missed
  ; missedQ   = q-missed
  ; moved     = σp≡q
  ; movedBack = σq≡p
  ; free      = p≢q
  }
