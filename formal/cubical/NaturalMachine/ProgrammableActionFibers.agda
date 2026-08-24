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

------------------------------------------------------------------------
-- NaturalMachine.ProgrammableActionFibers
--
-- An exact family of deterministic basis actions has two nearby total maps:
--
--   keep  (p , x) = (p , action p x)
--   erase (p , x) =      action p x.
--
-- Their fibres are not estimates.  Keeping the program leaves one action
-- fibre; erasing it forms the dependent sum of every program fibre.  These
-- are the types whose finite cardinalities become the maximum/sum coherent
-- environment law in PROGRAMMABLE_SCALAR_COHERENCE_BOUNDARY.
--
-- The final section keeps the interface boundary explicit.  A collision has
-- no exact inverse after every residual has been discarded.  The existing
-- two-history phase pair then exhibits the corresponding reduced cut:
-- dephasing identifies the pair, while the retained off-diagonal port still
-- separates it.
------------------------------------------------------------------------

module NaturalMachine.ProgrammableActionFibers where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.Equiv.Fiberwise using (fibers-total)
open import Cubical.Foundations.Isomorphism
  using (Iso ; iso ; invIso ; isoToEquiv)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; Σ-syntax ; _,_)
open import Cubical.Functions.Embedding
  using (isEmbedding ; _↪_ ; Equiv→Embedding ; compEmbedding)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.CertificateFibration as Cert
import NaturalMachine.CoherentSurvivalDephasing as Phase

private
  variable
    ℓp ℓx ℓy ℓe : Level

module _ {Program : Type ℓp} {Data : Type ℓx} {Output : Type ℓy}
         (action : Program → Data → Output) where

  ----------------------------------------------------------------------
  -- 1. The two program interfaces and their exact fibres
  ----------------------------------------------------------------------

  keepProgram : Program × Data → Program × Output
  keepProgram (program , datum) = program , action program datum

  eraseProgram : Program × Data → Output
  eraseProgram (program , datum) = action program datum

  -- This is HoTT 4.7.6 (`fibers-total`) with constant input/output
  -- families.  The output program selects exactly one action fibre.
  keep-program-fiber : (program : Program) (output : Output)
    → Iso (fiber keepProgram (program , output))
          (fiber (action program) output)
  keep-program-fiber program output =
    fibers-total (λ _ → Data) (λ _ → Output) action

  -- Erasing the program removes the summand tag.  The inverse merely
  -- re-associates the same data, so both round trips compute by `refl`.
  erase-program-fiber : (output : Output)
    → Iso (fiber eraseProgram output)
          (Σ[ program ∈ Program ] fiber (action program) output)
  Iso.fun      (erase-program-fiber output) ((program , datum) , equality) =
    program , datum , equality
  Iso.inv      (erase-program-fiber output) (program , datum , equality) =
    (program , datum) , equality
  Iso.rightInv (erase-program-fiber output) _ = refl
  Iso.leftInv  (erase-program-fiber output) _ = refl

  ----------------------------------------------------------------------
  -- 2. Certificate/environment lower bounds, inherited without recounting
  ----------------------------------------------------------------------

  keep-certificate-lower : {Environment : Type ℓe}
    (certificate : Program × Data → Environment)
    → isEmbedding (Cert.recorded keepProgram certificate)
    → (program : Program) (output : Output)
    → fiber (action program) output ↪ Environment
  keep-certificate-lower certificate embedding program output =
    compEmbedding
      (Cert.fiber↪cert keepProgram certificate embedding (program , output))
      (Equiv→Embedding
        (isoToEquiv (invIso (keep-program-fiber program output))))

  erase-certificate-lower : {Environment : Type ℓe}
    (certificate : Program × Data → Environment)
    → isEmbedding (Cert.recorded eraseProgram certificate)
    → (output : Output)
    → (Σ[ program ∈ Program ] fiber (action program) output) ↪ Environment
  erase-certificate-lower certificate embedding output =
    compEmbedding
      (Cert.fiber↪cert eraseProgram certificate embedding output)
      (Equiv→Embedding
        (isoToEquiv (invIso (erase-program-fiber output))))

  ----------------------------------------------------------------------
  -- 3. No residual means no exact reversal at a collision
  ----------------------------------------------------------------------

  collision-no-residual : {left right : Program × Data}
    → eraseProgram left ≡ eraseProgram right
    → ¬ (left ≡ right)
    → (recover : Output → Program × Data)
    → ((input : Program × Data) → recover (eraseProgram input) ≡ input)
    → ⊥
  collision-no-residual {left = left} {right = right}
    same-output distinct recover round-trip =
      distinct
        (sym (round-trip left)
          ∙ cong recover same-output
          ∙ round-trip right)

------------------------------------------------------------------------
-- 4. The hostile phase control at the reduced cut
--
-- `dephaseℤ` is the exact algebraic shadow of discarding the orthogonal
-- collision record.  The two global phase states survive as distinct inputs,
-- but the reduced chart identifies them.  This does not formalize Hilbert
-- spaces or partial trace; the note supplies the standard inner-product
-- argument that forces the orthogonal record.
------------------------------------------------------------------------

reduced-collision-loses-sign :
  Phase.dephaseℤ Phase.phasePlus ≡ Phase.dephaseℤ Phase.phaseMinus
reduced-collision-loses-sign = Phase.phase-pair-same-after-dephasing

retained-coherence-separates :
  ¬ (Phase.offDiagonalPort Phase.phasePlus
      ≡ Phase.offDiagonalPort Phase.phaseMinus)
retained-coherence-separates = Phase.off-diagonal-port-separates

