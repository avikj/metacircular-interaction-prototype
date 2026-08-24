-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.RealizedPayloadCapability where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (_∷_)
open import Cubical.Data.Sigma

open import NaturalMachine.Obstruction using
  (Shape ; Vocab ; Tm ; Over ; unfold ; unfold-elim)
open import NaturalMachine.PayloadMorphism using (MorphismClass)
open import NaturalMachine.DatumSensitivePayload

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
