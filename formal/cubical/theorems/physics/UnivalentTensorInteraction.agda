{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- UnivalentTensorInteraction
--
-- A smallest local-to-joint physical carrier with univalent identity.
--
-- Two local population interfaces each compile to Unit, so their tensor-like
-- product is Unit × Unit.  A coherent joint sector nevertheless has two
-- phases.  Forgetting to separate populations identifies those phases, and
-- no decoder from the local product can reconstruct them.  A joint
-- interference port reopens exactly that lost distinction.
--
-- The two phases are not taken as the ontology.  Their reversible exchange
-- is an equivalence and therefore a path of the joint state space by
-- univalence.  Transport along that path moves the state; the finite Bool
-- compiler is only one executable presentation of this path-sensitive
-- structure.
--
-- This is not a construction of Hilbert tensor products, Born probabilities,
-- entanglement entropy, or a physical quantum computer.  It is the exact
-- local/joint obstruction those larger constructions must preserve.
------------------------------------------------------------------------

module UnivalentTensorInteraction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; true≢false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1. The separate population interface and the coherent joint sector
------------------------------------------------------------------------

LocalPopulation : Type₀
LocalPopulation = Unit

SeparatePopulation : Type₀
SeparatePopulation = LocalPopulation × LocalPopulation

JointCoherence : Type₀
JointCoherence = Bool

plus minus : JointCoherence
plus  = true
minus = false

-- Both coherent joint phases have the same two local population records.
forgetJoint : JointCoherence → SeparatePopulation
forgetJoint phase = tt , tt

local-populations-collide : forgetJoint plus ≡ forgetJoint minus
local-populations-collide = refl

-- The collision is genuine: no function of the separate population record
-- can reconstruct every coherent joint phase.
no-local-reconstruction :
  (recover : SeparatePopulation → JointCoherence)
  → ¬ ((phase : JointCoherence) → recover (forgetJoint phase) ≡ phase)
no-local-reconstruction recover round =
  true≢false (sym (round plus) ∙ round minus)

------------------------------------------------------------------------
-- 2. The joint reversible process is a universe path
------------------------------------------------------------------------

phaseExchange : JointCoherence ≃ JointCoherence
phaseExchange = isoToEquiv (iso not not invol invol)
  where
    invol : (phase : JointCoherence) → not (not phase) ≡ phase
    invol true  = refl
    invol false = refl

jointPhaseLoop : JointCoherence ≡ JointCoherence
jointPhaseLoop = ua phaseExchange

-- Transport, rather than an external relabelling convention, executes the
-- phase exchange.
transport-plus-to-minus :
  subst (λ X → X) jointPhaseLoop plus ≡ minus
transport-plus-to-minus = uaβ phaseExchange plus

-- The universe loop is observable and therefore cannot be collapsed to refl.
joint-loop-nontrivial : ¬ (jointPhaseLoop ≡ refl)
joint-loop-nontrivial loop≡refl =
  false≢true
    (sym transport-plus-to-minus
    ∙ cong (λ p → subst (λ X → X) p plus) loop≡refl
    ∙ substRefl {B = λ X → X} plus)

-- At the compiled point level, two successive exchanges close.  The path is
-- retained even though its induced point motion is involutive.
exchange-closes-on-points :
  (phase : JointCoherence)
  → equivFun phaseExchange (equivFun phaseExchange phase) ≡ phase
exchange-closes-on-points true  = refl
exchange-closes-on-points false = refl

------------------------------------------------------------------------
-- 3. Interaction-relative compilation and reopening
------------------------------------------------------------------------

data Interaction : Type₀ where
  separatePopulation jointInterference : Interaction

Compiled : Interaction → Type₀
Compiled separatePopulation = SeparatePopulation
Compiled jointInterference   = JointCoherence

compile : (port : Interaction) → JointCoherence → Compiled port
compile separatePopulation = forgetJoint
compile jointInterference   = λ phase → phase

separate-compiler-collides :
  compile separatePopulation plus ≡ compile separatePopulation minus
separate-compiler-collides = refl

joint-compiler-separates :
  ¬ (compile jointInterference plus ≡ compile jointInterference minus)
joint-compiler-separates = true≢false

-- The compiled dynamics is port-relative.  Population dynamics is trivial;
-- the joint interference chart retains the transported phase exchange.
compiledExchange : (port : Interaction) → Compiled port → Compiled port
compiledExchange separatePopulation populations = tt , tt
compiledExchange jointInterference phase = equivFun phaseExchange phase

compile-exchange :
  (port : Interaction) (phase : JointCoherence)
  → compile port (equivFun phaseExchange phase)
    ≡ compiledExchange port (compile port phase)
compile-exchange separatePopulation phase = refl
compile-exchange jointInterference phase = refl

record JointReopening : Type₀ where
  field
    localCollision :
      compile separatePopulation plus ≡ compile separatePopulation minus
    jointSeparator :
      ¬ (compile jointInterference plus ≡ compile jointInterference minus)
    localCannotRecover :
      (recover : SeparatePopulation → JointCoherence)
      → ¬ ((phase : JointCoherence) → recover (forgetJoint phase) ≡ phase)

interaction-reopens-joint-phase : JointReopening
interaction-reopens-joint-phase .JointReopening.localCollision =
  separate-compiler-collides
interaction-reopens-joint-phase .JointReopening.jointSeparator =
  joint-compiler-separates
interaction-reopens-joint-phase .JointReopening.localCannotRecover =
  no-local-reconstruction

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: the local product quotient, its non-reconstructible joint fiber,
-- the univalent phase loop and its state transport, and compilation commuting
-- with the admitted interaction.
--
-- Not claimed: that Bool is a complete quantum state space, that this is a
-- Bell experiment, or that a classical population collision alone proves
-- physical entanglement.  The theorem isolates the proof-relevant seam a
-- future Hilbert/spin-network realization must instantiate.
------------------------------------------------------------------------
