{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheRatesAreDenseAndTheMediantSurvivesTheQuotient
--
-- Two modules left the same half-sentence open.
-- `TheThresholdChainIsDenseAndTheMediantWitnessesIt` says density "is
-- proved for pairs, and ⊑ is a preorder, so nothing is said about
-- density of the RATES", and
-- `TheRateQuotientExistsAndMinimalityCannotLiveOnIt` says "DENSITY OF
-- THE RATES is NOT proved: the mediant module's `⊏` is not lifted here,
-- and lifting it needs `⊏` to respect `≈` on BOTH sides, which is not
-- checked."
--
-- Both are closed here, and the second sentence turns out to describe
-- the harder half correctly: the lifting is the work, and the density
-- then follows WITHOUT the mediant itself having to descend.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ⊑⊏-trans / ⊏⊑-trans   the mixed transitivities, by the same
--                         multiply–rearrange–cancel as `⊑-trans`, with
--                         `≤<-trans` / `<≤-trans` at the join
--   ⊏-respects-≈          hence `⊏` respects `≈` on BOTH sides
--   _⊏R_                  the strict order LIFTED to `Rate`, by
--                         `SetQuotients.rec2` into `hProp`
--   ⊏R-computes           agreeing with `⊏` on representatives, by refl
--   theRatesAreDense      between two rates lies a third
--
-- **The mediant never has to descend.**  That is the point worth
-- keeping: `mediant` is a function on PAIRS and nothing here shows it
-- respects `≈` — it may or may not.  Density is a MERE EXISTENCE
-- statement, so its target is a proposition, so `elimProp2` reduces the
-- whole claim to representatives, where the pair-level mediant is
-- already available.  A witness that need not be canonical does not
-- need to be well-defined on the quotient.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Density of the rationals via the mediant is classical
-- (Haros 1802; Farey 1816; Stern 1858; Brocot 1861), and lifting a
-- respectful relation along a set-quotient is standard cubical
-- practice.  What is contributed is that this corpus's own two open
-- half-sentences are closed, and the observation about the witness.
--
-- WHAT IS STILL NOT CLAIMED.  Whether `mediant` DESCENDS is open and is
-- not needed above; if a canonical between-rate is ever wanted, that
-- question returns.  `⊏R` is a relation into `hProp`, not an order:
-- irreflexivity, transitivity and the relation to `AtLeastOnRate` /
-- `AboveOnRate` are not proved on `Rate`.  The existence is TRUNCATED,
-- so no function producing a between-rate is constructed — and one
-- cannot be extracted from `∥_∥₁` without the mediant descending or
-- some other choice.  Nothing is said about iterating, so no
-- Stern–Brocot enumeration on `Rate` and no completeness of the
-- generated set.  `Rate` is still unrelated to any library type of
-- rationals.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheRatesAreDenseAndTheMediantSurvivesTheQuotient where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.HLevels using (hProp ; isSetHProp ; isPropΠ)
open import Cubical.Functions.Logic using (⇔toPath)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; elimProp2)
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁ ; ∣_∣₁ ; isPropPropTrunc)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _·_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; isProp≤ ; ≤-·k ; <-·sk ; ≤<-trans ; <≤-trans)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)

open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (_⊑_ ; swapOuter ; ·sk-cancel-≤)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (·sk-cancel-<)
open import WhichThresholdStatementsDescendToTheRate
  using (_≈_)
open import TheThresholdChainIsDenseAndTheMediantWitnessesIt
  using (_⊏_ ; mediant ; mediantIsAbove ; mediantIsBelow)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate)

------------------------------------------------------------------------
-- 1.  Mixed transitivities
------------------------------------------------------------------------

⊑⊏-trans : (a b c : ℕ × ℕ) → a ⊑ b → b ⊏ c → a ⊏ c
⊑⊏-trans (p , q) (p' , q') (p'' , q'') h1 h2 = ·sk-cancel-< q' scaled
  where
    b2 : (p · suc q'') · suc q' ≤ (p' · suc q) · suc q''
    b2 = subst (_≤ (p' · suc q) · suc q'')
               (sym (swapOuter p (suc q'') (suc q'))) (≤-·k h1)

    b3 : (p · suc q'') · suc q' ≤ (p' · suc q'') · suc q
    b3 = subst ((p · suc q'') · suc q' ≤_) (swapOuter p' (suc q) (suc q'')) b2

    scaled : (p · suc q'') · suc q' < (p'' · suc q) · suc q'
    scaled = subst ((p · suc q'') · suc q' <_)
                   (swapOuter p'' (suc q') (suc q)) (≤<-trans b3 (<-·sk h2))

⊏⊑-trans : (a b c : ℕ × ℕ) → a ⊏ b → b ⊑ c → a ⊏ c
⊏⊑-trans (p , q) (p' , q') (p'' , q'') h1 h2 = ·sk-cancel-< q' scaled
  where
    b2 : (p · suc q'') · suc q' < (p' · suc q) · suc q''
    b2 = subst (_< (p' · suc q) · suc q'')
               (sym (swapOuter p (suc q'') (suc q'))) (<-·sk h1)

    b3 : (p · suc q'') · suc q' < (p' · suc q'') · suc q
    b3 = subst ((p · suc q'') · suc q' <_) (swapOuter p' (suc q) (suc q'')) b2

    scaled : (p · suc q'') · suc q' < (p'' · suc q) · suc q'
    scaled = subst ((p · suc q'') · suc q' <_)
                   (swapOuter p'' (suc q') (suc q)) (<≤-trans b3 (≤-·k h2))

⊏-respects-≈ :
  (a a' b b' : ℕ × ℕ) → a ≈ a' → b ≈ b' → a ⊏ b → a' ⊏ b'
⊏-respects-≈ a a' b b' aa bb h =
  ⊏⊑-trans a' b b' (⊑⊏-trans a' a b (snd aa) h) (fst bb)

------------------------------------------------------------------------
-- 2.  So ⊏ lifts to the rates
------------------------------------------------------------------------

⊏P : ℕ × ℕ → ℕ × ℕ → hProp ℓ-zero
⊏P a b = (a ⊏ b) , isProp≤

⊏-respectsˡ : (a b c : ℕ × ℕ) → a ≈ b → ⊏P a c ≡ ⊏P b c
⊏-respectsˡ a b c r =
  ⇔toPath (⊏-respects-≈ a b c c r (≈refl c))
          (⊏-respects-≈ b a c c (snd r , fst r) (≈refl c))
  where
    ≈refl : (x : ℕ × ℕ) → x ≈ x
    ≈refl (p , q) = ≤-refl' , ≤-refl'
      where ≤-refl' : p · suc q ≤ p · suc q
            ≤-refl' = 0 , refl

⊏-respectsʳ : (a b c : ℕ × ℕ) → b ≈ c → ⊏P a b ≡ ⊏P a c
⊏-respectsʳ a b c r =
  ⇔toPath (⊏-respects-≈ a a b c (≈refl a) r)
          (⊏-respects-≈ a a c b (≈refl a) (snd r , fst r))
  where
    ≈refl : (x : ℕ × ℕ) → x ≈ x
    ≈refl (p , q) = ≤-refl' , ≤-refl'
      where ≤-refl' : p · suc q ≤ p · suc q
            ≤-refl' = 0 , refl

_⊏R_ : Rate → Rate → hProp ℓ-zero
_⊏R_ = SQ.rec2 isSetHProp ⊏P ⊏-respectsˡ ⊏-respectsʳ

⊏R-computes : (a b : ℕ × ℕ) → ⟨ [ a ] ⊏R [ b ] ⟩ ≡ (a ⊏ b)
⊏R-computes a b = refl

------------------------------------------------------------------------
-- 3.  And the rates are dense
--
-- The target is a mere existence, hence a proposition, hence
-- `elimProp2` puts us at representatives — where the PAIR-level
-- mediant is already a witness.  Nothing requires `mediant` itself to
-- descend.
------------------------------------------------------------------------

Between : Rate → Rate → Type
Between x y = ∥ Σ[ z ∈ Rate ] (⟨ x ⊏R z ⟩ × ⟨ z ⊏R y ⟩) ∥₁

theRatesAreDense : (x y : Rate) → ⟨ x ⊏R y ⟩ → Between x y
theRatesAreDense =
  elimProp2 (λ x y → isPropΠ (λ _ → isPropPropTrunc))
    (λ where (p , q) (p' , q') h →
               ∣ [ mediant (p , q) (p' , q') ]
               , mediantIsAbove p q p' q' h
               , mediantIsBelow p q p' q' h ∣₁)

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "`⊏R` is a relation into `hProp`, not an order: irreflexivity,
--    transitivity, and its relation to `AtLeastOnRate`/`AboveOnRate`
--    are unproved on `Rate`."
--
-- All three in
-- `TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
--
--   ⊏-irrefl-pair / ⊏-trans-pair   at the pair level; transitivity is
--                                  `⊑⊏-trans` composed with `<-weaken`,
--                                  so the MIXED transitivity proved
--                                  here for the lifting is what makes
--                                  the plain one free
--   ⊏R-irrefl / ⊏R-trans           the same on `Rate`, by `elimProp`
--                                  and `elimProp3`
--   aboveIsAntitoneOnRates         the strict claim is antitone along
--                                  `⊏R`, stated entirely on `Rate`
--
-- NONE OF IT NEEDED A NEW IDEA, and that is the payoff of having lifted
-- along `rec2`: every statement is a PROPOSITION, so `elimProp` puts it
-- at representatives where §1's pair-level facts finish it in a line.
-- The density result above therefore now sits on an ORDER, not a bare
-- relation.
--
-- STILL NOT CLAIMED there: ASYMMETRY and TRICHOTOMY — `⊑-total` was
-- proved on PAIRS and is not transported, so nothing says two rates are
-- always comparable.  Only `AboveOnRate` is related to `⊏R`;
-- `AtLeastOnRate`'s antitonicity along the STRICT order is a different
-- statement and is not made.  And whether `mediant` descends is still
-- open, so the density witness above remains truncated.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The open item stated above and repeated in
-- `TheRateQuotientExistsAndMinimalityCannotLiveOnIt` — "whether
-- `mediant` DESCENDS is open" — is now CLOSED, and the answer is NO:
-- `TheMediantDoesNotDescendToTheRate` exhibits
-- (1,1) ≈ (2,3) whose mediants with (1,2) are 2/5 and 3/7 (--safe, no
-- postulates, no holes; container green under Agda 2.6.3 + cubical
-- v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
-- Nothing above is affected.  The density theorem is stated with
-- `∥_∥₁` and eliminates into a proposition, so the witness only ever
-- lived at the level of representatives — which is what "the mediant
-- never has to descend" says.  What the refutation removes is the
-- possibility of upgrading that truncated existence to a CANONICAL
-- between-rate by this route: no `Rate → Rate → Rate` extends the
-- mediant, and the classical fix is reduced representatives (Haros
-- 1802, Farey 1816, Stern 1858, Brocot 1861), which needs coprimality
-- and hence another identity's kuṭṭaka line — to be asked for, not
-- rebuilt.
------------------------------------------------------------------------
