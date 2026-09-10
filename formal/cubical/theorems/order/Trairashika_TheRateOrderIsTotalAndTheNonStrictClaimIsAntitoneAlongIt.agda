{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Trairashika_TheRateOrderIsTotalAndTheNonStrictClaimIsAntitoneAlongIt
--
-- `TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt` proved
-- irreflexivity and transitivity of `⊏R` on `Rate` and closed with:
--
--   "ASYMMETRY and TRICHOTOMY are not proved: `⊏-total`-style
--    comparability was proved for `⊑` on PAIRS and is not transported
--    here, so nothing says two rates are always comparable.  No claim
--    relates `⊏R` to `AtLeastOnRate` — only to `AboveOnRate`; the
--    non-strict claim's antitonicity along the STRICT order is a
--    different statement and is not made."
--
-- All of it is closed here, on `Rate` itself.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ⊏R-asym            x ⊏R y → ¬ (y ⊏R x), from transitivity and
--                      irreflexivity — no arithmetic
--   ⊏-trichotomy-pair  (a ⊏ b) ⊎ (a ≈ b) ⊎ (b ⊏ a) on PAIRS, by
--                      `splitℕ-<` then `≤-split`
--   ⊏R-trichotomy      (x ⊏R y) ⊎ (x ≡ y) ⊎ (y ⊏R x) on RATES — an
--                      honest SUM, not a truncation.  The three cases
--                      are mutually exclusive, so the sum is a
--                      proposition (`isProp⊎` twice, disjointness from
--                      irreflexivity and asymmetry), so `elimProp2`
--                      applies and the pair-level split finishes it
--   ⊏R-connected       ¬ (x ⊏R y) → ¬ (y ⊏R x) → x ≡ y, the corollary
--                      that makes `⊏R` a strict TOTAL order
--   _⊑R_               the NON-strict order lifted to `Rate` by `rec2`,
--                      computing to `⊑` on representatives by `refl`
--   ⊑R-refl / ⊑R-trans / ⊑R-antisym / ⊑R-total
--                      `⊑R` is a total order on `Rate` — antisymmetry
--                      is `eq/`, which is exactly where the quotient
--                      turns a preorder on pairs into an order.
--                      Totality's two disjuncts OVERLAP on equal rates,
--                      so that sum is NOT a proposition and is not
--                      lifted by `elimProp2`; it is read off trichotomy
--   ⊏R→⊑R              strict implies non-strict
--   ¬⊏R→⊑R / ⊑R→¬⊏R    ¬ (x ⊏R y)  ⇔  y ⊑R x, both directions
--   ⊏R→⊑R×≢ / ⊑R×≢→⊏R
--                      x ⊏R y  ⇔  (x ⊑R y) × ¬ (x ≡ y), both directions
--   atLeastIsAntitoneOnRates
--                      the NON-strict claim is antitone along the
--                      NON-strict order, on `Rate`
--   atLeastIsAntitoneOnRatesStrictly
--                      and hence along the STRICT order — the statement
--                      the earlier module says is "not made"
--   aboveGivesAtLeastOnRate
--                      the strict claim implies the non-strict one on
--                      `Rate`, so the two families are ordered too
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Trichotomy for a cross-multiplication order on positive
-- fractions is the rule of three (trairāśika) read as a comparison;
-- that a decidable, mutually-exclusive three-way split is a proposition
-- and so descends through a set-quotient by `elimProp` is standard.
-- What is contributed is that the corpus's `Rate` now carries a strict
-- total order and a total order that agree in the usual way, with both
-- claim families antitone along both.
--
-- THE SCOPE, EXACTLY.  Nothing here is truncated: trichotomy is a
-- genuine sum, and its elimination into propositions is by
-- `elimProp2`, not by choice — the sum is a proposition BECAUSE the
-- cases exclude each other, and that exclusion is proved, not assumed.
-- `Rate` still has no arithmetic, no lowest-terms section and no
-- relation to any library type of rationals.  Decidability of `≈` and
-- of `⊏R` on `Rate` is NOT stated as a `Dec`: trichotomy gives it on
-- representatives, and `Dec` is a proposition when the decided type is,
-- so it would lift by the same route, but that lift is not written.
-- Density (`theRatesAreDense`) remains truncated for the reason its
-- own module gives.
--
-- CHECKED against the declared pin (Agda 2.8.0 + cubical v0.9).
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module Trairashika_TheRateOrderIsTotalAndTheNonStrictClaimIsAntitoneAlongIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩ ; str)
open import Cubical.Foundations.HLevels
  using (hProp ; isSetHProp ; isPropΠ ; isProp→ ; isProp× ; isPropΣ)
open import Cubical.Functions.Logic using (⇔toPath)
open import Cubical.HITs.SetQuotients as SQ
  using (_/_ ; [_] ; eq/ ; squash/ ; elimProp ; elimProp2 ; elimProp3)
open import Cubical.Data.Nat using (ℕ ; suc ; _·_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; isProp≤ ; ≤-refl ; <-weaken ; <-asym ; <-asym'
        ; splitℕ-< ; ≤-split ; ¬m<m)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr ; isProp⊎)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; isProp¬)

open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast ; _⊑_ ; ⊑-total ; atLeastAntitone)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above ; aboveGivesAtLeast)
open import WhichThresholdStatementsDescendToTheRate
  using (_≈_ ; ⊑-trans ; ≈-refl ; ≈-sym)
open import TheThresholdChainIsDenseAndTheMediantWitnessesIt
  using (_⊏_)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate ; AtLeastOnRate ; AboveOnRate)
open import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
  using (_⊏R_ ; ⊑⊏-trans)
open import TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
  using (⊏R-irrefl ; ⊏R-trans)

------------------------------------------------------------------------
-- 1.  Asymmetry: no arithmetic, just the order already proved
------------------------------------------------------------------------

⊏R-asym : (x y : Rate) → ⟨ x ⊏R y ⟩ → ¬ ⟨ y ⊏R x ⟩
⊏R-asym x y xy yx = ⊏R-irrefl x (⊏R-trans x y x xy yx)

------------------------------------------------------------------------
-- 2.  Trichotomy
--
-- At the pair level the middle case is `≈`, which `eq/` turns into a
-- PATH on the quotient.  The three cases exclude one another, so the
-- sum is a proposition and `elimProp2` carries it across.
------------------------------------------------------------------------

⊏-trichotomy-pair : (a b : ℕ × ℕ) → ((a ⊏ b) ⊎ (a ≈ b)) ⊎ (b ⊏ a)
⊏-trichotomy-pair (p , q) (p' , q')
  with splitℕ-< (p · suc q') (p' · suc q)
... | inl lt = inl (inl lt)
... | inr ge with ≤-split ge
...   | inl gt = inr gt
...   | inr e  = inl (inr ( subst (p · suc q' ≤_) (sym e) ≤-refl
                          , subst (_≤ p · suc q') (sym e) ≤-refl ))

Trichotomy : Rate → Rate → Type
Trichotomy x y = (⟨ x ⊏R y ⟩ ⊎ (x ≡ y)) ⊎ ⟨ y ⊏R x ⟩

-- The exclusions.
⊏R-≢ : (x y : Rate) → ⟨ x ⊏R y ⟩ → x ≡ y → ⊥
⊏R-≢ x y h e = ⊏R-irrefl y (subst (λ z → ⟨ z ⊏R y ⟩) e h)

≡-¬⊏R : (x y : Rate) → x ≡ y → ⟨ y ⊏R x ⟩ → ⊥
≡-¬⊏R x y e h = ⊏R-irrefl x (subst (λ z → ⟨ z ⊏R x ⟩) (sym e) h)

isPropTrichotomy : (x y : Rate) → isProp (Trichotomy x y)
isPropTrichotomy x y =
  isProp⊎ (isProp⊎ (str (x ⊏R y)) (squash/ x y) (⊏R-≢ x y))
          (str (y ⊏R x))
          (λ where (inl h) k → ⊏R-asym x y h k
                   (inr e) k → ≡-¬⊏R x y e k)

⊏R-trichotomy : (x y : Rate) → Trichotomy x y
⊏R-trichotomy =
  elimProp2 isPropTrichotomy
    (λ a b → carry (⊏-trichotomy-pair a b))
  where
    carry : {a b : ℕ × ℕ}
         → ((a ⊏ b) ⊎ (a ≈ b)) ⊎ (b ⊏ a) → Trichotomy [ a ] [ b ]
    carry (inl (inl h)) = inl (inl h)
    carry {a} {b} (inl (inr e)) = inl (inr (eq/ a b e))
    carry (inr h) = inr h

-- Hence `⊏R` is CONNECTED: two rates neither of which is below the
-- other are the same rate.
⊏R-connected : (x y : Rate) → ¬ ⟨ x ⊏R y ⟩ → ¬ ⟨ y ⊏R x ⟩ → x ≡ y
⊏R-connected x y nxy nyx = go (⊏R-trichotomy x y)
  where
    go : Trichotomy x y → x ≡ y
    go (inl (inl h)) = ⊥.rec (nxy h)
    go (inl (inr e)) = e
    go (inr h)       = ⊥.rec (nyx h)

------------------------------------------------------------------------
-- 3.  The non-strict order on `Rate`
--
-- `⊑` respects `≈` on both sides by `⊑-trans` alone, so it lifts by
-- the same `rec2` as `⊏` did.
------------------------------------------------------------------------

⊑P : ℕ × ℕ → ℕ × ℕ → hProp ℓ-zero
⊑P a b = (a ⊑ b) , isProp≤

⊑-respectsˡ : (a b c : ℕ × ℕ) → a ≈ b → ⊑P a c ≡ ⊑P b c
⊑-respectsˡ a b c r =
  ⇔toPath (λ h → ⊑-trans b a c (snd r) h)
          (λ h → ⊑-trans a b c (fst r) h)

⊑-respectsʳ : (a b c : ℕ × ℕ) → b ≈ c → ⊑P a b ≡ ⊑P a c
⊑-respectsʳ a b c r =
  ⇔toPath (λ h → ⊑-trans a b c h (fst r))
          (λ h → ⊑-trans a c b h (snd r))

_⊑R_ : Rate → Rate → hProp ℓ-zero
_⊑R_ = SQ.rec2 isSetHProp ⊑P ⊑-respectsˡ ⊑-respectsʳ

⊑R-computes : (a b : ℕ × ℕ) → ⟨ [ a ] ⊑R [ b ] ⟩ ≡ (a ⊑ b)
⊑R-computes a b = refl

⊑R-refl : (x : Rate) → ⟨ x ⊑R x ⟩
⊑R-refl = elimProp (λ x → str (x ⊑R x)) (λ a → fst (≈-refl a))

⊑R-trans : (x y z : Rate) → ⟨ x ⊑R y ⟩ → ⟨ y ⊑R z ⟩ → ⟨ x ⊑R z ⟩
⊑R-trans =
  elimProp3 (λ x y z → isProp→ (isProp→ (str (x ⊑R z)))) ⊑-trans

-- Antisymmetry is where the quotient earns its keep: on pairs, mutual
-- `⊑` is `≈`, which is NOT equality; on `Rate` it is `eq/`.
⊑R-antisym : (x y : Rate) → ⟨ x ⊑R y ⟩ → ⟨ y ⊑R x ⟩ → x ≡ y
⊑R-antisym =
  elimProp2 (λ x y → isProp→ (isProp→ (squash/ x y)))
    (λ a b h k → eq/ a b (h , k))

------------------------------------------------------------------------
-- 4.  Strict against non-strict on `Rate`
------------------------------------------------------------------------

⊏R→⊑R : (x y : Rate) → ⟨ x ⊏R y ⟩ → ⟨ x ⊑R y ⟩
⊏R→⊑R =
  elimProp2 (λ x y → isProp→ (str (x ⊑R y))) (λ a b → <-weaken)

-- ¬ (x ⊏R y)  ⇔  y ⊑R x, both ways.  The forward direction is the one
-- that uses decidability of `<` on ℕ (`<-asym'`); the backward one is
-- plain asymmetry of `<`.
¬⊏R→⊑R : (x y : Rate) → ¬ ⟨ x ⊏R y ⟩ → ⟨ y ⊑R x ⟩
¬⊏R→⊑R =
  elimProp2 (λ x y → isProp→ (str (y ⊑R x))) (λ a b n → <-asym' n)

⊑R→¬⊏R : (x y : Rate) → ⟨ y ⊑R x ⟩ → ¬ ⟨ x ⊏R y ⟩
⊑R→¬⊏R =
  elimProp2 (λ x y → isProp→ (isProp¬ ⟨ x ⊏R y ⟩))
            (λ a b h k → <-asym k h)

-- Totality of `⊑R` as a genuine sum.  Its two disjuncts OVERLAP on
-- equal rates, so the sum is not a proposition and `elimProp2` does
-- not apply to it directly; it is instead read off the trichotomy,
-- which is one.
⊑R-total : (x y : Rate) → ⟨ x ⊑R y ⟩ ⊎ ⟨ y ⊑R x ⟩
⊑R-total x y = go (⊏R-trichotomy x y)
  where
    go : Trichotomy x y → ⟨ x ⊑R y ⟩ ⊎ ⟨ y ⊑R x ⟩
    go (inl (inl h)) = inl (⊏R→⊑R x y h)
    go (inl (inr e)) = inl (subst (λ z → ⟨ x ⊑R z ⟩) e (⊑R-refl x))
    go (inr h)       = inr (⊏R→⊑R y x h)

-- x ⊏R y  ⇔  (x ⊑R y) × ¬ (x ≡ y).
⊏R→⊑R×≢ : (x y : Rate) → ⟨ x ⊏R y ⟩ → ⟨ x ⊑R y ⟩ × (¬ (x ≡ y))
⊏R→⊑R×≢ x y h = ⊏R→⊑R x y h , ⊏R-≢ x y h

⊑R×≢→⊏R : (x y : Rate) → ⟨ x ⊑R y ⟩ × (¬ (x ≡ y)) → ⟨ x ⊏R y ⟩
⊑R×≢→⊏R x y (h , ne) = go (⊏R-trichotomy x y)
  where
    go : Trichotomy x y → ⟨ x ⊏R y ⟩
    go (inl (inl lt)) = lt
    go (inl (inr e))  = ⊥.rec (ne e)
    go (inr gt)       = ⊥.rec (⊑R→¬⊏R y x h gt)

------------------------------------------------------------------------
-- 5.  The non-strict claim is antitone along BOTH orders
------------------------------------------------------------------------

atLeastIsAntitoneOnRates :
  (x y : Rate) → ⟨ x ⊑R y ⟩
  → (bs : List Bool) → ⟨ AtLeastOnRate y bs ⟩ → ⟨ AtLeastOnRate x bs ⟩
atLeastIsAntitoneOnRates =
  elimProp2
    (λ x y → isProp→ (isPropΠ (λ bs → isProp→ (str (AtLeastOnRate x bs)))))
    (λ where (p , q) (p' , q') h bs → atLeastAntitone p q p' q' bs h)

-- The statement the earlier module says is "not made": the NON-strict
-- claim along the STRICT order.
atLeastIsAntitoneOnRatesStrictly :
  (x y : Rate) → ⟨ x ⊏R y ⟩
  → (bs : List Bool) → ⟨ AtLeastOnRate y bs ⟩ → ⟨ AtLeastOnRate x bs ⟩
atLeastIsAntitoneOnRatesStrictly x y h =
  atLeastIsAntitoneOnRates x y (⊏R→⊑R x y h)

-- And the two families are themselves ordered on `Rate`.
aboveGivesAtLeastOnRate :
  (x : Rate) (bs : List Bool)
  → ⟨ AboveOnRate x bs ⟩ → ⟨ AtLeastOnRate x bs ⟩
aboveGivesAtLeastOnRate =
  elimProp
    (λ x → isPropΠ (λ bs → isProp→ (str (AtLeastOnRate x bs))))
    (λ where (p , q) bs → aboveGivesAtLeast p q bs)
