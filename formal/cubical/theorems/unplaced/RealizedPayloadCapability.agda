{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module RealizedPayloadCapability where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (_∷_)
open import Cubical.Data.Sigma

open import Obstruction using
  (Shape ; Vocab ; Tm ; Over ; unfold ; unfold-elim)
open import PayloadMorphism using (MorphismClass)
open import DatumSensitivePayload

module _ {Ans : Type₀} {M : MorphismClass Ans}
         (P : DatumSensitivePayloadOver Ans M) where

  open DatumSensitivePayloadOver P

  -- The input type of the semantics-preserving installation edge.
  -- Raw Datum remains available, but only this checked package carries the
  -- preservation capability.
  RealizedDatum : {V : Vocab} (st : Store V) (d : Shape)
                (b : Tm) (bB : Over V b) → Type₀
  RealizedDatum st d b bB = Σ[ x ∈ Datum d ] Realizes st d b bB x

  install-realized : {V : Vocab} (st : Store V) (d : Shape)
                   (b : Tm) (bB : Over V b)
                   → RealizedDatum st d b bB → Store (d ∷ V)
  install-realized st d b bB r = installP st d b bB (fst r)

  realized-installation-preserves :
    {V : Vocab} (st : Store V) (d : Shape) (b : Tm) (bB : Over V b)
    (r : RealizedDatum st d b bB) (t : Tm) (h : Over (d ∷ V) t)
    → sem (install-realized st d b bB r) t h
      ≡ sem st (unfold d b t) (unfold-elim V d b bB t h)
  realized-installation-preserves st d b bB (x , rx) t h =
    unfold-preserves st d b bB x rx t h
