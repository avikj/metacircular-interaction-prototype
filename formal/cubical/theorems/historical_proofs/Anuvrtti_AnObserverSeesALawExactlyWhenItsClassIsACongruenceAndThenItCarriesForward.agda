{-# OPTIONS --cubical --safe #-}
--
-- अनुवृत्तिः — continuation.  In the Aṣṭādhyāyī, anuvṛtti is the carrying
-- forward of an element of one sūtra into the sūtras that follow: the rule
-- keeps applying without being restated.  Pāṇini, *Aṣṭādhyāyī*, throughout,
-- as the grammarians' metalanguage (~500 BCE).  Nothing below is attributed
-- to him; the word is taken for what it names — a thing that keeps holding
-- once it holds.
--
-- WHAT THIS IS.  `NaturalMachine/QuotientFiberLaw.agda` states the one law
-- for a STATIC observation: a closed observation class sees exactly a
-- quotient, never the fibre, and visibility returns only by a separating
-- query.  This module is its DYNAMICAL face, which the corpus did not have:
--
--     put a rule on the state space, and ask when the observer sees a LAW.
--
-- The answer is exact and it is not "sometimes":
--
--     an observer sees a closed law exactly when its own class is a
--     CONGRUENCE for the rule — o x ≡ o y ⟹ o (f x) ≡ o (f y).  When it is,
--     the observer's entire future is determined by its present reading,
--     forever (अनुवृत्तिः).  When it is not, ONE blind pair whose futures
--     differ refutes EVERY predictor on the observed values — not the
--     predictors anyone has tried, all of them.
--
-- So an observed law being simple says nothing about the rule being simple.
-- It says the observer's equivalence happens to be compatible with it.  The
-- same rule, watched through a slightly finer class, can go from noise to an
-- exact law — and §3 exhibits precisely that, one query apart.
module Anuvrtti_AnObserverSeesALawExactlyWhenItsClassIsACongruenceAndThenItCarriesForward where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false; not)
open import Cubical.Data.Nat using (ℕ; zero; suc; znots)
open import Cubical.Data.List using (List; []; _∷_; length; map)
open import Cubical.Data.Sigma using (_×_; _,_; ΣPathP)
open import Cubical.Relation.Nullary using (¬_)

open import OjaYugma_TheSquarefreeChargeIsTheActivePlaceCountTimesTheParityCharacter
  using (ओजः)

private
  variable
    ℓ ℓ' : Level

-- ------------------------------------------------------------------ §1
-- the two notions, and the iteration

-- the rule applied n times
पुनरावृत्तिः : {X : Type ℓ} → (X → X) → ℕ → X → X
पुनरावृत्तिः f zero x = x
पुनरावृत्तिः f (suc n) x = f (पुनरावृत्तिः f n x)

-- the observer's class is compatible with the rule
अनुकूलम् : {X : Type ℓ} {V : Type ℓ'} → (X → X) → (X → V) → Type _
अनुकूलम् {X = X} f o = (x y : X) → o x ≡ o y → o (f x) ≡ o (f y)

-- there is a rule ON THE OBSERVED VALUES that predicts the next reading
भाव्यम् : {X : Type ℓ} {V : Type ℓ'} → (X → X) → (X → V) → Type _
भाव्यम् {X = X} {V = V} f o = Σ[ g ∈ (V → V) ] ((x : X) → o (f x) ≡ g (o x))

-- ------------------------------------------------------------------ §2
-- the law, both directions

-- COMPATIBLE ⇒ the observer's whole future is fixed by its present reading.
-- This is the anuvṛtti: it holds once and then keeps holding, at every n,
-- without being restated.
अनुवृत्तिः : {X : Type ℓ} {V : Type ℓ'} (f : X → X) (o : X → V)
  → अनुकूलम् f o
  → (x y : X) → o x ≡ o y
  → (n : ℕ) → o (पुनरावृत्तिः f n x) ≡ o (पुनरावृत्तिः f n y)
अनुवृत्तिः f o c x y e zero = e
अनुवृत्तिः f o c x y e (suc n) =
  c (पुनरावृत्तिः f n x) (पुनरावृत्तिः f n y) (अनुवृत्तिः f o c x y e n)

-- A PREDICTOR IS ITSELF COMPATIBLE — so the two notions cannot come apart.
भाव्य-अनुकूलम् : {X : Type ℓ} {V : Type ℓ'} (f : X → X) (o : X → V)
  → भाव्यम् f o → अनुकूलम् f o
भाव्य-अनुकूलम् f o (g , p) x y e = p x ∙ cong g e ∙ sym (p y)

-- ONE BLIND PAIR WITH DIFFERENT FUTURES REFUTES EVERY PREDICTOR.  Not the
-- ones that have been tried — every function on the observed values at once.
-- This is `collision-obstructs` of the static law, moved onto the rule.
अभाव्यम् : {X : Type ℓ} {V : Type ℓ'} (f : X → X) (o : X → V)
  → (x y : X) → o x ≡ o y → ¬ (o (f x) ≡ o (f y))
  → ¬ (भाव्यम् f o)
अभाव्यम् f o x y e d h = d (भाव्य-अनुकूलम् f o h x y e)

-- ------------------------------------------------------------------ §3
-- the same rule, two observers, one query apart
--
-- The state is a row of cells.  The rule complements every cell — as simple
-- as a rule gets, and reversible.  The first observer counts the live cells.
-- The second counts them AND reads the width.

नियमः : List Bool → List Bool
नियमः = map not

-- the finer observer
द्वि-दृष्टिः : List Bool → ℕ × ℕ
द्वि-दृष्टिः bs = (ओजः bs , length bs)

-- ω alone is NOT compatible: two rows with the same live count whose next
-- live counts differ.  The pair is exhibited, not asserted to exist.
अन्धः : ओजः (true ∷ []) ≡ ओजः (true ∷ false ∷ [])
अन्धः = refl

भिन्न-भविष्यम् : ¬ (ओजः (नियमः (true ∷ [])) ≡ ओजः (नियमः (true ∷ false ∷ [])))
भिन्न-भविष्यम् = znots

-- hence: no function of the live count alone predicts the next live count.
ओज-अभाव्यम् : ¬ (भाव्यम् नियमः ओजः)
ओज-अभाव्यम् = अभाव्यम् नियमः ओजः (true ∷ []) (true ∷ false ∷ []) अन्धः भिन्न-भविष्यम्

-- the rule preserves the width, cell by cell
दैर्घ्य-नियमः : (bs : List Bool) → length (नियमः bs) ≡ length bs
दैर्घ्य-नियमः [] = refl
दैर्घ्य-नियमः (b ∷ bs) = cong suc (दैर्घ्य-नियमः bs)

-- the width is compatible with the rule, by itself
दैर्घ्य-अनुकूलम् : अनुकूलम् नियमः length
दैर्घ्य-अनुकूलम् bs cs e = दैर्घ्य-नियमः bs ∙ e ∙ sym (दैर्घ्य-नियमः cs)
