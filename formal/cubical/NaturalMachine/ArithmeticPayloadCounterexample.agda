{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ArithmeticPayloadOver is inhabited, but not for an arithmetic reason.
--
-- The smallest standard counterexample uses the existing unrestricted
-- integer carrier class.  A Boolean store chooses either the zero vector
-- or one fixed nonzero vector.  Semantics ignores the term, coverage,
-- installed datum, and vocabulary; composition is first projection.
-- Nevertheless every field of ArithmeticPayloadOver is satisfied,
-- including separation and pointwise minimal carriers.
--
-- Therefore the record is consistent, but its maps do not yet express
-- the advertised dependence of an answer on installed arithmetic data.
-- In particular `Datum` and `installP` are not constrained by any law:
-- the semantic preservation square commutes here because installation
-- does nothing.  This is an exact interface no-go, not an arithmetic
-- implementation.
------------------------------------------------------------------------

module NaturalMachine.ArithmeticPayloadCounterexample where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true ; if_then_else_)
open import Cubical.Data.Nat.Order using (zero-≤ ; suc-≤-suc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.Obstruction using (Shape ; Vocab ; Tm ; var ; Over)
open import NaturalMachine.PayloadMorphism
  using ( MorphismClass ; Layer ; Uncls ; FactorsAt ; MinCarrier ; r₀ ; r₁
        ; table-row-1 ; U-min-zero )
open import NaturalMachine.CompileBridge using (ArithmeticPayloadOver)

------------------------------------------------------------------------
-- Universal no-go: the preservation law's right-hand side does not mention
-- the installed datum.  Hence every two data at one shape induce the same
-- semantics on every covered term.  This follows for EVERY inhabitant, not
-- only for the Boolean countermodel below.
------------------------------------------------------------------------

module _ {Ans : Type₀} {M : MorphismClass Ans}
         (P : ArithmeticPayloadOver Ans M) where

  open ArithmeticPayloadOver P

  installed-data-semantically-indistinguishable :
    {V : Vocab} (st : Store V) (d : Shape) (b : Tm) (bB : Over V b)
    (x y : Datum d) (t : Tm) (h : Over (d ∷ V) t)
    → sem (installP st d b bB x) t h
      ≡ sem (installP st d b bB y) t h
  installed-data-semantically-indistinguishable st d b bB x y t h =
      unfold-preserves st d b bB x t h
    ∙ sym (unfold-preserves st d b bB y t h)

  DatumAffectsSemantics : Type₀
  DatumAffectsSemantics =
    Σ[ V ∈ Vocab ] Σ[ st ∈ Store V ]
    Σ[ d ∈ Shape ] Σ[ b ∈ Tm ] Σ[ bB ∈ Over V b ]
    Σ[ x ∈ Datum d ] Σ[ y ∈ Datum d ]
    Σ[ t ∈ Tm ] Σ[ h ∈ Over (d ∷ V) t ]
      ¬ (sem (installP st d b bB x) t h
       ≡ sem (installP st d b bB y) t h)

  no-installed-datum-affects-semantics : ¬ DatumAffectsSemantics
  no-installed-datum-affects-semantics
    (V , st , d , b , bB , x , y , t , h , separates) =
      separates
        (installed-data-semantically-indistinguishable st d b bB x y t h)

answer : Bool → Layer 3
answer false = r₀
answer true  = r₁

answer-minimal : (b : Bool) → MinCarrier (Uncls 3) (answer b) (if b then 1 else 0)
answer-minimal false = U-min-zero 3
answer-minimal true  = table-row-1 .fst

-- A complete inhabitant of the purported arithmetic interface whose only
-- information is one Boolean chosen before the task is inspected.
boolean-store-payload : ArithmeticPayloadOver (Layer 3) (Uncls 3)
boolean-store-payload = record
  { Datum = λ _ → Unit
  ; Store = λ _ → Bool
  ; atom = λ st _ _ → answer st
  ; installP = λ st _ _ _ _ → st
  ; combine = λ x _ → x
  ; sem = λ st _ _ → answer st
  ; sem-node = λ _ _ _ _ _ → refl
  ; unfold-preserves = λ _ _ _ _ _ _ _ → refl
  ; Cost = Unit
  ; vcost = λ _ _ _ → tt
  ; carrier = λ st _ _ → if st then 1 else 0
  ; carrier-minimal = λ st _ _ → answer-minimal st
  ; payload-separates =
      [] , var , tt , false , true ,
      (λ p → table-row-1 .fst .snd 0 (suc-≤-suc zero-≤)
        (subst (λ r → FactorsAt (Uncls 3) r 0) p (U-min-zero 3 .fst)))
  }
