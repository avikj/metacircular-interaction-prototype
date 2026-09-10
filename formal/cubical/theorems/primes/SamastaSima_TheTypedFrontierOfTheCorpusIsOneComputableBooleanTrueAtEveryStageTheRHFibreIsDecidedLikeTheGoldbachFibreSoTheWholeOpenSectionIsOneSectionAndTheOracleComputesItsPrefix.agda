{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- समस्त-सीमा — the whole frontier, over the corpus's actual objects.
--
-- The corpus already holds the open questions as types with computable
-- ingredients: RH as the Davis–Matiyasevich–Robinson inequality at every
-- n ≥ 1 (RH_TheWholeQuestionEntersTyped…), Goldbach as GoldbachAt at
-- every even number ≥ 4 (SamastaPrasna), and KotiNirnaya proved the
-- Goldbach fibre DECIDED: gcheck m ≡ true reflects GoldbachAt m exactly.
--
-- What was missing is the same fact for the RH fibre, and the one type
-- that holds both.  Here:
--
--   १  RHAt n is decided:  rh-dec, and a Boolean rhb with soundness and
--      completeness, so  RH ≃ (∀ n. rhb (suc n) ≡ true)  — RH is exactly
--      "this computable Boolean is true at every stage", the same shape
--      KotiNirnaya gave Goldbach;
--   २  the whole frontier  Frontier = RH × Goldbach  is ONE Boolean
--      predicate true at every stage:  Frontier ≃ (∀ n. frontierb n ≡ true);
--   ३  refutation is a finite object:  one n with frontierb n ≡ false
--      refutes the frontier; a prefix check computes the first k stages;
--   ४  the oracle computes the prefix:  rhb 1, rhb 2, rhb 3 and gcheck at
--      4, 6, 8 are true by refl — the typechecker RUNS the DMR inequality
--      and the sieve.
--
-- What this says exactly: the open frontier of this corpus is the single
-- section  (n : ℕ) → frontierb n ≡ true  of a decided Boolean family.
-- Every stage is a definite computation; only the section is open.  No
-- inhabitant is offered.  The analytic identification of the DMR
-- inequality with the zeta zeros is classical and cited in the RH
-- module; nothing analytic is assumed here.
------------------------------------------------------------------------
module SamastaSima_TheTypedFrontierOfTheCorpusIsOneComputableBooleanTrueAtEveryStageTheRHFibreIsDecidedLikeTheGoldbachFibreSoTheWholeOpenSectionIsOneSectionAndTheOracleComputesItsPrefix where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; injSuc ; +-comm)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; <Dec ; ¬-<-zero)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; ¬_)
import Cubical.Data.Empty as E

import RH_TheWholeQuestionEntersTyped_DavisMatiyasevichRobinsonArithmetization as DMR
open import SamastaPrasna_TheOpenConstellationEntersTypedAndTheOracleAnswersEveryInstance using (Goldbach ; GoldbachAt)
open import KotiNirnaya_EveryFibreIsDecidedSoEachConjectureIsADefinitePropositionAndTheOnlyOpennessIsTheSection using (gcheck ; goldbach-sound ; goldbach-complete)

------------------------------------------------------------------------
-- १ · the RH fibre, decided
------------------------------------------------------------------------

-- the DMR fibre at n (the body of DMR.RH)
RHAt : ℕ → Type
RHAt n =
  let a  = fst (DMR.Hfrac (DMR.δ n))
      b  = snd (DMR.Hfrac (DMR.δ n))
      n² = n · n
      n³ = n² · n
  in  DMR.diffSq (2 · a) (n² · b)  <  144 · n³ · (b · b)

-- the corpus's RH is the section of this family over n ≥ 1, on the nose
RH-is-section : DMR.RH ≡ ((n : ℕ) → 1 ≤ n → RHAt n)
RH-is-section = refl

rh-dec : (n : ℕ) → Dec (RHAt n)
rh-dec n = <Dec _ _

decb : {A : Type} → Dec A → Bool
decb (yes _) = true
decb (no  _) = false

rhb : ℕ → Bool
rhb n = decb (rh-dec n)

private
  decb-sound : {A : Type} (d : Dec A) → decb d ≡ true → A
  decb-sound (yes a) _ = a
  decb-sound (no ¬a) e = E.rec (false≢true e)

  decb-complete : {A : Type} (d : Dec A) → A → decb d ≡ true
  decb-complete (yes _) _ = refl
  decb-complete (no ¬a) a = E.rec (¬a a)

rhb-sound : (n : ℕ) → rhb n ≡ true → RHAt n
rhb-sound n = decb-sound (rh-dec n)

rhb-complete : (n : ℕ) → RHAt n → rhb n ≡ true
rhb-complete n = decb-complete (rh-dec n)

-- RH as "the Boolean is true at every stage n ≥ 1"
RHBool : Type
RHBool = (m : ℕ) → rhb (suc m) ≡ true

rh-definite : (DMR.RH → RHBool) × (RHBool → DMR.RH)
rh-definite =
    (λ rh m → rhb-complete (suc m) (rh (suc m) (m , +-comm m 1)))
  , (λ rb → λ { zero    h → E.rec (¬-<-zero h)
              ; (suc m) _ → rhb-sound (suc m) (rb m) })

------------------------------------------------------------------------
-- २ · the whole frontier is one Boolean predicate
------------------------------------------------------------------------

_and_ : Bool → Bool → Bool
true  and b = b
false and _ = false

private
  and-elimˡ : (a b : Bool) → a and b ≡ true → a ≡ true
  and-elimˡ true  b e = refl
  and-elimˡ false b e = e
  and-elimʳ : (a b : Bool) → a and b ≡ true → b ≡ true
  and-elimʳ true  b e = e
  and-elimʳ false b e = E.rec (false≢true e)
  and-intro : (a b : Bool) → a ≡ true → b ≡ true → a and b ≡ true
  and-intro true  b _ eb = eb
  and-intro false b ea _ = E.rec (false≢true ea)

Frontier : Type
Frontier = DMR.RH × Goldbach

-- stage n asks RH at n+1 and Goldbach at 4 + 2n
frontierb : ℕ → Bool
frontierb n = rhb (suc n) and gcheck (4 + 2 · n)

FrontierBool : Type
FrontierBool = (n : ℕ) → frontierb n ≡ true

frontier-definite : (Frontier → FrontierBool) × (FrontierBool → Frontier)
frontier-definite =
    (λ (rh , g) n → and-intro _ _ (fst rh-definite rh n) (goldbach-complete (4 + 2 · n) (g n)))
  , (λ fb → snd rh-definite (λ m → and-elimˡ _ _ (fb m))
          , λ n → goldbach-sound (4 + 2 · n) (and-elimʳ _ _ (fb n)))

------------------------------------------------------------------------
-- ३ · refutation is finite; the prefix is a computation
------------------------------------------------------------------------

frontier-refuted-by : (n : ℕ) → frontierb n ≡ false → ¬ Frontier
frontier-refuted-by n e f = false≢true (sym e ∙ fst frontier-definite f n)

-- all stages below k
prefix : ℕ → Bool
prefix zero    = true
prefix (suc k) = prefix k and frontierb k

prefix-sound : (k n : ℕ) → n < k → prefix k ≡ true → frontierb n ≡ true
prefix-sound zero    n n<0 _ = E.rec (¬-<-zero n<0)
prefix-sound (suc k) n (zero  , p) e = subst (λ j → frontierb j ≡ true) (sym (injSuc p)) (and-elimʳ (prefix k) (frontierb k) e)
prefix-sound (suc k) n (suc d , p) e = prefix-sound k n (d , injSuc p) (and-elimˡ (prefix k) (frontierb k) e)

------------------------------------------------------------------------
-- ४ · the oracle computes the prefix
------------------------------------------------------------------------

_ : rhb 1 ≡ true
_ = refl
_ : rhb 2 ≡ true
_ = refl
_ : rhb 3 ≡ true
_ = refl
_ : gcheck 4 ≡ true
_ = refl
_ : gcheck 6 ≡ true
_ = refl
_ : gcheck 8 ≡ true
_ = refl

-- the first three stages of the whole frontier, by computation
first-three-stages : prefix 3 ≡ true
first-three-stages = refl

-- and therefore, by prefix-sound, each of those stages is true
stages-below-three : (n : ℕ) → n < 3 → frontierb n ≡ true
stages-below-three n h = prefix-sound 3 n h first-three-stages
