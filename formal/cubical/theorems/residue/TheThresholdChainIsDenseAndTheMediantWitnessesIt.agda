{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheThresholdChainIsDenseAndTheMediantWitnessesIt
--
-- "Density of ⊑ is untouched" has been the last line of the NOT-CLAIMED
-- section of three modules on the threshold line —
-- `TheThresholdOrderIsTotalAndTheClaimIsAntitone`,
-- `TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary`, and
-- `WhichThresholdStatementsDescendToTheRate` — and it is touched here.
--
-- The chain IS dense, and the witness is not constructed by a search:
-- it is the MEDIANT.  Between p/(suc q) and p'/(suc q') lies
--
--   (p + p') / (suc q + suc q')
--
-- and both halves of the betweenness reduce, after distributing, to the
-- SAME inequality that was assumed.  No case analysis, no ordering
-- lemmas beyond additive cancellation.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   _⊏_               strict threshold order, p · suc q' < p' · suc q
--   mediant           (p + p' , q + suc q'), which is a threshold pair
--                     with denominator suc q + suc q' — definitionally,
--                     since `suc q + suc q'` IS `suc (q + suc q')`
--   mediantIsAbove    (p , q) ⊏ mediant
--   mediantIsBelow    mediant ⊏ (p' , q')
--   thresholdsAreDense    the two together
--   ⊏-gives-⊑         and ⊏ refines the ⊑ chain the other threshold
--                     modules use, so this is density OF THAT CHAIN and
--                     not of a relation introduced for the occasion
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY, and the attribution is worth getting right.  The mediant
-- and its betweenness property are classical: they organise the Farey
-- dissection (Haros 1802; Farey 1816) and the Stern–Brocot tree (Stern
-- 1858; Brocot 1861).  Nothing here is new; what is new to this corpus
-- is only that the threshold chain's density is now checked rather than
-- listed as untouched.
--
-- Also worth recording rather than mining: the mediant is the same
-- operation the vallī/kuṭṭaka tradition uses when it forms a new pair
-- from two convergents — `KuttakaValli.agda` and the convergent modules
-- on that line are ANOTHER IDENTITY'S here, and this module does not
-- enter them.  It is NOT claimed that the mediant is "really" the
-- kuṭṭaka's step; that would need the two constructions compared, which
-- is their author's to do.
--
-- WHAT IS NOT CLAIMED.  Density is proved for ⊏ on PAIRS, and ⊑ is a
-- preorder, not an order — so this says nothing about density of the
-- RATES, which would need the quotient that
-- `WhichThresholdStatementsDescendToTheRate` explicitly does not form.
-- The mediant is one witness, not the only one, and no claim is made
-- that it is in lowest terms — it need not be.  Nothing is proved about
-- iterating it, so no Stern–Brocot enumeration, no completeness of the
-- generated set, and no claim that every threshold between two given
-- ones is reachable.  `⊏` is not shown to be irreflexive or transitive
-- here; only the two betweenness facts are.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheThresholdChainIsDenseAndTheMediantWitnessesIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-suc ; ·-distribˡ ; ·-distribʳ)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; ≤-k+ ; ≤-+k ; <-weaken)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone using (_⊑_)
open import Cubical.Data.Sigma using (_×_ ; _,_)

------------------------------------------------------------------------
-- 1.  Strict order on thresholds, and additive cancellation for <
------------------------------------------------------------------------

_⊏_ : ℕ × ℕ → ℕ × ℕ → Type
(p , q) ⊏ (p' , q') = p · suc q' < p' · suc q

<-shiftˡ : (c : ℕ) {a b : ℕ} → a < b → (c + a) < (c + b)
<-shiftˡ c {a} {b} h = subst (_≤ c + b) (+-suc c a) (≤-k+ h)

------------------------------------------------------------------------
-- 2.  The mediant
--
-- Its denominator is `suc q + suc q'`, and that is DEFINITIONALLY
-- `suc (q + suc q')`, so the mediant is a threshold pair with no
-- arithmetic needed to see it.
------------------------------------------------------------------------

mediant : ℕ × ℕ → ℕ × ℕ → ℕ × ℕ
mediant (p , q) (p' , q') = (p + p') , (q + suc q')

------------------------------------------------------------------------
-- 3.  Both halves reduce to the hypothesis
------------------------------------------------------------------------

mediantIsAbove :
  (p q p' q' : ℕ) → (p , q) ⊏ (p' , q')
  → (p , q) ⊏ mediant (p , q) (p' , q')
mediantIsAbove p q p' q' h =
  subst2 _<_ (·-distribˡ p (suc q) (suc q')) (·-distribʳ p p' (suc q))
    (<-shiftˡ (p · suc q) h)

mediantIsBelow :
  (p q p' q' : ℕ) → (p , q) ⊏ (p' , q')
  → mediant (p , q) (p' , q') ⊏ (p' , q')
mediantIsBelow p q p' q' h =
  subst2 _<_ (·-distribʳ p p' (suc q')) (·-distribˡ p' (suc q) (suc q'))
    (≤-+k h)

thresholdsAreDense :
  (p q p' q' : ℕ) → (p , q) ⊏ (p' , q')
  → ((p , q) ⊏ mediant (p , q) (p' , q'))
  × (mediant (p , q) (p' , q') ⊏ (p' , q'))
thresholdsAreDense p q p' q' h =
  mediantIsAbove p q p' q' h , mediantIsBelow p q p' q' h

------------------------------------------------------------------------
-- 4.  And ⊏ refines the chain the other modules use
------------------------------------------------------------------------

⊏-gives-⊑ : (a b : ℕ × ℕ) → a ⊏ b → a ⊑ b
⊏-gives-⊑ (p , q) (p' , q') = <-weaken
