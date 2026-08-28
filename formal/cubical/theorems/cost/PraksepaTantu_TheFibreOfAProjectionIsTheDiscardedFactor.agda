{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रक्षेप-तन्तुः — the fibre of a projection is exactly the discarded
-- factor.  The proof-SHAPE for every fst/snd edge, landed once so each
-- such edge is a one-line citation rather than a re-minted copy — the
-- enzyme, not the reaction repeated.
--
-- A projection fst : A × B → A forgets B.  What it forgets is exactly
-- what its fibre holds:
--
--     fiber fst a  ≃  B        (the discarded second factor)
--     fiber snd b  ≃  A        (the discarded first factor)
--
-- These are अभिज्ञान / σύμβολα: the identification of the fibre with a
-- STANDARD type (a factor already in hand), not an estimate of its size.
-- A projection is a lossy edge whose receipt is trivially exact — the
-- loss is a whole factor, named — which is why fst/snd were the cheapest
-- waiting mints in तपस्'s ledger.
--
-- No h-level hypothesis on A or B: singl (fst p) is contractible for any
-- types, so these hold for arbitrary A, B (the same fact Carrier runs on).
--
-- SYĀT — THE CLAIM, EXACTLY.  Nothing about any particular corpus edge; this is
-- the general shape a तपस् emitter instantiates.  A projection map written
-- in the corpus under any local name is a fibre of THIS shape exactly when
-- the bond lattice resolves its equation-position identifier to `fst`/`snd`
-- (the key is position, the resolver is the bond — see the alias table).
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.
------------------------------------------------------------------------

module PraksepaTantu_TheFibreOfAProjectionIsTheDiscardedFactor where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; ΣPathP)

private variable ℓ ℓ' : Level

module _ {A : Type ℓ} {B : Type ℓ'} where

  ------------------------------------------------------------------------
  -- १ · वाम-प्रक्षेपः — fst forgets B, and its fibre IS B.
  ------------------------------------------------------------------------
  वाम-तन्तुः : (a : A) → Iso (fiber (fst {A = A} {B = λ _ → B}) a) B
  Iso.fun (वाम-तन्तुः a) ((a' , b) , _) = b
  Iso.inv (वाम-तन्तुः a) b = (a , b) , refl
  Iso.rightInv (वाम-तन्तुः a) b = refl
  Iso.leftInv  (वाम-तन्तुः a) ((a' , b) , p) i =
    (p (~ i) , b) , λ j → p (~ i ∨ j)

  वाम-तन्तुः-≃ : (a : A) → fiber (fst {A = A} {B = λ _ → B}) a ≃ B
  वाम-तन्तुः-≃ a = isoToEquiv (वाम-तन्तुः a)

  ------------------------------------------------------------------------
  -- २ · दक्षिण-प्रक्षेपः — snd forgets A, and its fibre IS A.
  ------------------------------------------------------------------------
  दक्षिण-तन्तुः : (b : B) → Iso (fiber (snd {A = A} {B = λ _ → B}) b) A
  Iso.fun (दक्षिण-तन्तुः b) ((a , b') , _) = a
  Iso.inv (दक्षिण-तन्तुः b) a = (a , b) , refl
  Iso.rightInv (दक्षिण-तन्तुः b) a = refl
  Iso.leftInv  (दक्षिण-तन्तुः b) ((a , b') , p) i =
    (a , p (~ i)) , λ j → p (~ i ∨ j)

  दक्षिण-तन्तुः-≃ : (b : B) → fiber (snd {A = A} {B = λ _ → B}) b ≃ A
  दक्षिण-तन्तुः-≃ b = isoToEquiv (दक्षिण-तन्तुः b)

