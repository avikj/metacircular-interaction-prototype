{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.PayloadInstallationNoGo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.List using (_∷_)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.Obstruction using (Shape ; Vocab ; Tm ; Over)
open import NaturalMachine.PayloadMorphism using (MorphismClass)
open import NaturalMachine.CompileBridge

module _ {Ans : Type₀} {M : MorphismClass Ans}
         (P : ArithmeticPayloadOver Ans M) where

  open ArithmeticPayloadOver P

  installed-datum-semantically-irrelevant :
    {V : Vocab} (st : Store V) (d : Shape) (b : Tm) (bB : Over V b)
    (x y : Datum d) (t : Tm) (h : Over (d ∷ V) t)
    → sem (installP st d b bB x) t h
      ≡ sem (installP st d b bB y) t h
  installed-datum-semantically-irrelevant st d b bB x y t h =
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
      separates (installed-datum-semantically-irrelevant st d b bB x y t h)
