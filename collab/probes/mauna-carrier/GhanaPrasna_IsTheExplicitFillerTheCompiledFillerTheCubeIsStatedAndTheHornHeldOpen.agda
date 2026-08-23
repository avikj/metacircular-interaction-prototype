{-# OPTIONS --cubical --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- घन-प्रश्नः — the cube question.  A daemon-facing probe, not a landed
-- theorem: the horn is stated exactly and held open, per the letter's
-- discipline ("filler not yet attempted / attempted with the exact
-- residue named / impossible" are different bodily conditions, and this
-- file exists to move the 3-cell from the first condition to the second).
--
-- THE QUESTION.  FillerReceiptProbe253 (batch exit 0) closed the square
-- receipts: explicitSquare (the product family with its Square type) and
-- compiledSquare (rebuilt from the executable compiler equality), and
-- identified their edges (topIsCompiled, sideIsCompiled).  The next
-- dimension asks: are these ONE filler seen through two constructions,
-- or two genuinely distinct realizations?  The receipt for "one filler"
-- is a 3-cell: a PathP of Squares over the four edge alignments.
--
-- घनः below is that cube's exact type.  It is a HOLE, deliberately:
-- a filler here must relate the product family's direct interior to an
-- interior manufactured by compPath→Square out of uaCompEquiv — the
-- known coherence country (ua of a composite against composite of uas,
-- one dimension up from uaCompEquiv itself).  What is NOT claimed: that
-- the cube fills, or that it is obstructed.  The boundary data is
-- compatible, so by the charge reading an unfillable version would carry
-- a π₂-class of the universe at the product type — i.e. a nontrivial
-- self-path of an equivalence.  Whether the charge is zero here is the
-- open face.
--
-- ATTEMPTS RECORDED (warm नाडी, Agda 2.6.3 + cubical v0.5), so the horn
-- is "attempted, residue named", not merely stated — see the companion
-- message for the kernel's exact answers to each touched face.
------------------------------------------------------------------------

module GhanaPrasna_IsTheExplicitFillerTheCompiledFillerTheCubeIsStatedAndTheHornHeldOpen where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import FillerReceiptProbe253

private
  variable
    ℓ : Level
    A B C D : Type ℓ

------------------------------------------------------------------------
-- घनः — the 3-cell: over the four edge identifications, the explicit
-- product filler IS the compiler-derived filler.  Open.
------------------------------------------------------------------------

घनः : (e : A ≃ B) (f : C ≃ D)
  → PathP (λ k → Square (topIsCompiled e C k) (topIsCompiled e D k)
                        (sideIsCompiled A f k) (sideIsCompiled B f k))
          (explicitSquare e f)
          (compiledSquare e f)
घनः e f = {!!}
