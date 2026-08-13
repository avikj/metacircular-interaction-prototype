{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PortQueue
--
-- Top-ranked port from the Lean corpus
-- (formal/pairfield/Pairfield/FutureBehavior.lean), rebuilt on native
-- set quotients.  See notes/LEAN_TO_CUBICAL_PORT_MAP.md for the full
-- inventory and ranking.
--
-- Content: two states of an observed action system are
-- future-equivalent when every finite action word produces the same
-- observation.  The relation is an equivalence and a congruence for
-- every action, so the system descends to the quotient of meanings,
-- where the complete behavior map is injective.
--
-- What the Cubical rebuild gains over the Lean original:
--
--   * `FutureEq` and "equality of behavior functions" are related by
--     `funExt` / `funExt⁻`, which are definitionally inverse here, so
--     Lean's `futureEq_iff_behavior_eq` costs zero lemmas;
--   * the `Setoid` packaging disappears: the HIT quotient `X / FutureEq`
--     takes the raw relation, and `SQ.rec` is the whole lift API
--     (`quotientLift`, `quotientStep`, `quotientObserve` in Lean);
--   * all `_mk`-computation lemmas (`quotientStep_mk`,
--     `quotientObserve_mk`, `quotientLift_mk`) hold by `refl`;
--   * effectivity is an actual `Iso` between the path space of the
--     quotient and `FutureEq` — the univalent form of "the quotient
--     identifies exactly the behaviorally equal states".
--
-- No postulates, no holes; every statement below is proved.
------------------------------------------------------------------------

module NaturalMachine.PortQueue where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Foundations.HLevels using (isPropΠ ; isSetΠ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/ ; squash/)
open import Cubical.Relation.Binary.Base
open BinaryRelation

private
  variable
    ℓx ℓa ℓo ℓf ℓp ℓt : Level

module ObservedAction {X : Type ℓx} {A : Type ℓa} (step : X → A → X) where

  ----------------------------------------------------------------------
  -- Execution: apply a word of actions from left to right.
  ----------------------------------------------------------------------

  run : X → List A → X
  run x []      = x
  run x (a ∷ w) = run (step x a) w

  module Observe {O : Type ℓo} (observe : X → O) where

    -- The complete observable future of one state.
    behavior : X → List A → O
    behavior x w = observe (run x w)

    -- Equality under every finite future experiment.
    FutureEq : X → X → Type (ℓ-max ℓa ℓo)
    FutureEq x y = (w : List A) → behavior x w ≡ behavior y w

    futureEq-refl : (x : X) → FutureEq x x
    futureEq-refl x w = refl

    futureEq-sym : (x y : X) → FutureEq x y → FutureEq y x
    futureEq-sym x y h w = sym (h w)

    futureEq-trans : (x y z : X) → FutureEq x y → FutureEq y z → FutureEq x z
    futureEq-trans x y z hxy hyz w = hxy w ∙ hyz w

    futureEqIsEquivRel : isEquivRel FutureEq
    futureEqIsEquivRel = record
      { reflexive  = futureEq-refl
      ; symmetric  = futureEq-sym
      ; transitive = futureEq-trans }

    -- Future equality is a congruence for every action.
    futureEq-step : (x y : X) → FutureEq x y
                  → (a : A) → FutureEq (step x a) (step y a)
    futureEq-step x y h a w = h (a ∷ w)

    -- Lean's `futureEq_iff_behavior_eq` is the definitional
    -- funExt/funExt⁻ round trip; no lemma is needed on either side.
    futureEq→behaviorPath : {x y : X} → FutureEq x y → behavior x ≡ behavior y
    futureEq→behaviorPath = funExt

    behaviorPath→futureEq : {x y : X} → behavior x ≡ behavior y → FutureEq x y
    behaviorPath→futureEq = funExt⁻

  ----------------------------------------------------------------------
  -- Comparing observers (Lean: futureEq_of_finer, futureEq_pair_iff).
  ----------------------------------------------------------------------

  -- A finer observation can split old meanings but cannot merge them.
  futureEq-of-finer : {O : Type ℓo} {F : Type ℓf}
      (coarse : X → O) (fine : X → F) (forget : F → O)
    → ((x : X) → forget (fine x) ≡ coarse x)
    → {x y : X}
    → Observe.FutureEq fine x y
    → Observe.FutureEq coarse x y
  futureEq-of-finer coarse fine forget commutes {x} {y} h w =
    sym (commutes (run x w)) ∙ cong forget (h w) ∙ commutes (run y w)

  -- Joint observation preserves exactly the intersection of two
  -- distinctions (both directions of Lean's iff, as functions).
  futureEq-pair-split : {O : Type ℓo} {P : Type ℓp}
      (left : X → O) (right : X → P) {x y : X}
    → Observe.FutureEq (λ s → left s , right s) x y
    → Observe.FutureEq left x y × Observe.FutureEq right x y
  futureEq-pair-split left right h =
    (λ w → cong fst (h w)) , (λ w → cong snd (h w))

  futureEq-pair-join : {O : Type ℓo} {P : Type ℓp}
      (left : X → O) (right : X → P) {x y : X}
    → Observe.FutureEq left x y
    → Observe.FutureEq right x y
    → Observe.FutureEq (λ s → left s , right s) x y
  futureEq-pair-join left right hl hr w i = hl w i , hr w i

  ----------------------------------------------------------------------
  -- The behavioral quotient, as a native set quotient.
  ----------------------------------------------------------------------

  module BehavioralQuotient {O : Type ℓo}
      (isSetO : isSet O) (observe : X → O) where

    open Observe observe public

    isPropFutureEq : isPropValued FutureEq
    isPropFutureEq x y = isPropΠ (λ w → isSetO _ _)

    -- The type of behavioral meanings.
    Meaning : Type (ℓ-max ℓx (ℓ-max ℓa ℓo))
    Meaning = X / FutureEq

    ⟦_⟧ : X → Meaning
    ⟦ x ⟧ = [ x ]

    isSetMeaning : isSet Meaning
    isSetMeaning = squash/

    -- Every quantity constant on future-equivalence classes factors
    -- through meaning (Lean: quotientLift).  `SQ.rec` is the whole API.
    liftQ : {T : Type ℓt} (isSetT : isSet T) (target : X → T)
          → ((x y : X) → FutureEq x y → target x ≡ target y)
          → Meaning → T
    liftQ = SQ.rec

    -- Every action descends because future equality is a congruence.
    stepQ : A → Meaning → Meaning
    stepQ a = SQ.rec squash/ (λ x → [ step x a ])
      (λ x y h → eq/ (step x a) (step y a) (futureEq-step x y h a))

    -- The present observation descends: the empty future is a future.
    observeQ : Meaning → O
    observeQ = SQ.rec isSetO observe (λ x y h → h [])

    -- Lean's `_mk` computation lemmas, all definitional.
    stepQ-⟦⟧ : (a : A) (x : X) → stepQ a ⟦ x ⟧ ≡ ⟦ step x a ⟧
    stepQ-⟦⟧ a x = refl

    observeQ-⟦⟧ : (x : X) → observeQ ⟦ x ⟧ ≡ observe x
    observeQ-⟦⟧ x = refl

    -- Executing an entire word directly on meanings.
    runQ : Meaning → List A → Meaning
    runQ m []      = m
    runQ m (a ∷ w) = runQ (stepQ a m) w

    -- Executing before or after quotienting gives the same meaning.
    runQ-⟦⟧ : (x : X) (w : List A) → runQ ⟦ x ⟧ w ≡ ⟦ run x w ⟧
    runQ-⟦⟧ x []      = refl
    runQ-⟦⟧ x (a ∷ w) = runQ-⟦⟧ (step x a) w

    -- A meaning has a complete observable behavior, independent of the
    -- representative.
    behaviorQ : Meaning → (List A → O)
    behaviorQ = SQ.rec (isSetΠ (λ _ → isSetO)) behavior
      (λ x y h → funExt h)

    behaviorQ-⟦⟧ : (x : X) → behaviorQ ⟦ x ⟧ ≡ behavior x
    behaviorQ-⟦⟧ x = refl

    -- Distinct meanings have distinct complete futures.
    behaviorQ-inj : (m m' : Meaning) → behaviorQ m ≡ behaviorQ m' → m ≡ m'
    behaviorQ-inj = SQ.elimProp2
      (λ m m' → isPropΠ (λ _ → squash/ m m'))
      (λ x y h → eq/ x y (funExt⁻ h))

    -- Effectivity: the path space of the quotient at two named states
    -- IS future equality.  This is strictly more than Lean's
    -- `Quotient.exact`/`Quotient.sound` pair: it is an isomorphism of
    -- types, available for further transport.
    meaningPath→futureEq : (x y : X) → ⟦ x ⟧ ≡ ⟦ y ⟧ → FutureEq x y
    meaningPath→futureEq = SQ.effective isPropFutureEq futureEqIsEquivRel

    meaningPathIsoFutureEq : (x y : X) → Iso (⟦ x ⟧ ≡ ⟦ y ⟧) (FutureEq x y)
    meaningPathIsoFutureEq =
      SQ.isEquivRel→effectiveIso isPropFutureEq futureEqIsEquivRel
