{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ComparisonNeedNotBeInjective
--
-- SUFFICIENCY IS NOT NECESSITY: an explicit revised observer whose
-- comparison map is NOT injective and whose satisfaction invariant
-- holds in full.
--
--
-- WHAT IS PROVED HERE, against `AtomicSatisfaction.ChangedResponses`
-- itself (no re-axiomatization):
--
--   * `square`         the response square commutes;
--   * `invariant`      the FULL biconditional invariant holds;
--   * `not-injective`  and `j` is not injective.
--
-- What makes this possible: `j`
-- merges `one` and `two`, and NEITHER is realized — the only realized
-- old outcome is `zer`.  Injectivity on all of `Y_q` is strictly
-- stronger than what the biconditional needs, and the difference is the
-- set of unrealized outcomes, which is what §4 of the note is about.
--
-- The companion control is
-- `NaturalMachine/Control/InjectivityNecessary.agda`.
------------------------------------------------------------------------

module ComparisonNeedNotBeInjective where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)

open import AtomicSatisfaction using (module ChangedResponses)

------------------------------------------------------------------------
-- 0.  Three old outcomes; two of them never occur.

data Three : Type where
  zer one two : Three

sep : Three → Bool
sep two = true
sep _   = false

one≢two : one ≡ two → ⊥
one≢two p = true≢false (sym (cong sep p))

------------------------------------------------------------------------
-- 1.  The instance.  One state, one probe; `j` merges the two
--     unrealized outcomes `one` and `two`.

Y : Unit → Type
Y _ = Three

Y′ : Unit → Type
Y′ _ = Bool

r : (q : Unit) → Unit → Y q
r _ _ = zer

j : (q : Unit) → Y q → Y′ q
j _ zer = false
j _ one = true
j _ two = true

r′ : (q : Unit) → Unit → Y′ q
r′ _ _ = false

open ChangedResponses {X = Unit} {X′ = Unit} {Q = Unit} Y Y′ r r′ (λ x → x) j

------------------------------------------------------------------------
-- 2.  The square commutes and the FULL biconditional holds.

square : ResponseSquare
square q x′ = refl

fwd : (y : Three) → false ≡ j tt y → zer ≡ y
fwd zer _ = refl
fwd one p = ⊥-rec (true≢false (sym p))
fwd two p = ⊥-rec (true≢false (sym p))

invariant : SatisfactionInvariant
invariant x′ q y = (fwd y , λ old≡y → cong (j q) old≡y)

------------------------------------------------------------------------
-- 3.  ... with a comparison map that is not injective.

not-injective : InjectiveComparisons → ⊥
not-injective inj = one≢two (inj tt {one} {two} refl)
