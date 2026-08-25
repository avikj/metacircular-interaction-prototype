{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FutureBehavior
--
-- The future-behavior quotient, checked in Cubical Agda.
--
-- This is the corpus's one central construction (Myhill–Nerode /
-- sufficient statistic / observability): for an observed transition
-- system (X, A, step, observe), two states are future-equivalent when
-- every finite action word yields the same observation.  The quotient
-- by that relation is the minimal fully abstract machine with the same
-- behavior.
--
-- Ported from the Lean development `formal/lean/Pairfield/
-- FutureBehavior.lean` and the statement of `notes/NATURAL_CRYSTAL.md`
-- (equations (1)–(2)), with the set-quotient realized as the HIT
-- `Cubical.HITs.SetQuotients._/_` instead of Lean's `Quotient`.
--
-- This module also absorbs the parallel port that briefly lived in
-- `NaturalMachine/PortQueue.agda` (see notes/LEAN_TO_CUBICAL_PORT_MAP.md
-- §4; the two landed the same day from two directions).  Everything
-- PortQueue proved is here under this module's names — its liftQ is
-- `factor`, its runQ ledger is `run quotStep` / `quotRun-[]`, its
-- stepQ/observeQ/behaviorQ(-inj) are quotStep/quotObserve/
-- quotBehavior(-injective) — plus its one genuinely new statement, the
-- effectivity ISO `[]-effectiveIso` (the univalent strengthening of
-- Lean's Quotient.exact/Quotient.sound pair).
--
-- Contents (all proved, no holes, --safe):
--
--   run, behavior, FutureEq        the relation (Lean: run/behavior/
--                                  FutureEq), its equivalence proofs,
--                                  and the step congruence
--   futureEq-of-finer,             refinement and product laws for
--   futureEq-pair→/←               observations (Lean: futureEq_of_finer,
--                                  futureEq_pair_iff)
--   isBehavioralCongruence         behavioral congruences; FutureEq is
--                                  one, and is the GREATEST one
--                                  (congruence→futureEq)
--   FutureQuotient                 Meaning = X / FutureEq with:
--     quotStep, quotObserve          descent of step and observation
--     quotRun-[]                     execution commutes with quotienting
--                                    (Lean: quotientRun_mk)
--     []-effective,                  the quotient is effective: a path
--     []-effectiveIso                of meanings yields future equality,
--                                    and in fact the path space at two
--                                    named states IS future equality
--                                    (an Iso, available for transport)
--     quotBehavior,                  full abstraction: meanings embed
--     quotBehavior-injective         into complete behaviors (Lean:
--                                    quotientBehavior_injective)
--     factor, factor-unique          universal property of the quotient
--     crystal-minimal                the quotient machine separates its
--                                    own behaviors
--     Terminal                       terminality among behavior-
--                                    preserving quotients: every
--                                    congruence quotient X / S maps
--                                    onto Meaning by a unique machine
--                                    morphism
--   Machine, MachineFutureBehavior packaging: the quotient of a machine
--                                  is again a machine (`crystal`), with
--                                  the same behavior on every word
--
-- The descent obligations are exactly those audited in
-- `notes/CUBICAL_QUOTIENT_AUDIT.md` §1: a function leaves the quotient
-- only through a proof that it respects the relation.
------------------------------------------------------------------------

module FutureBehavior where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Foundations.HLevels
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/ ; squash/)
open import Cubical.Relation.Binary.Base using (module BinaryRelation)

private
  variable
    ℓX ℓA ℓO ℓF ℓP ℓR ℓT : Level
    X : Type ℓX
    A : Type ℓA
    O : Type ℓO
    F : Type ℓF
    P : Type ℓP
    T : Type ℓT

------------------------------------------------------------------------
-- 0.  Observed transition systems
------------------------------------------------------------------------

record Machine (ℓX ℓA ℓO : Level) : Type (ℓ-suc (ℓ-max ℓX (ℓ-max ℓA ℓO))) where
  field
    State    : Type ℓX
    Action   : Type ℓA
    Obs      : Type ℓO
    isSetObs : isSet Obs
    step     : State → Action → State
    observe  : State → Obs

------------------------------------------------------------------------
-- 1.  Running words and complete observable futures
------------------------------------------------------------------------

-- Apply a word of actions from left to right.
run : (X → A → X) → X → List A → X
run step x []      = x
run step x (a ∷ w) = run step (step x a) w

-- The complete observable future of one state.
behavior : (X → A → X) → (X → O) → X → List A → O
behavior step observe x w = observe (run step x w)

-- Equality under every finite future experiment.
FutureEq : {ℓX ℓA ℓO : Level} {X : Type ℓX} {A : Type ℓA} {O : Type ℓO}
  → (X → A → X) → (X → O) → X → X → Type (ℓ-max ℓA ℓO)
FutureEq {A = A} step observe x y =
  (w : List A) → behavior step observe x w ≡ behavior step observe y w

------------------------------------------------------------------------
-- 2.  FutureEq is an equivalence relation and a step congruence
------------------------------------------------------------------------

futureEq-refl : (step : X → A → X) (observe : X → O) (x : X)
  → FutureEq step observe x x
futureEq-refl step observe x w = refl

futureEq-sym : (step : X → A → X) (observe : X → O) {x y : X}
  → FutureEq step observe x y → FutureEq step observe y x
futureEq-sym step observe h w = sym (h w)

futureEq-trans : (step : X → A → X) (observe : X → O) {x y z : X}
  → FutureEq step observe x y → FutureEq step observe y z
  → FutureEq step observe x z
futureEq-trans step observe hxy hyz w = hxy w ∙ hyz w

-- Future equality is preserved when the same action is taken on both
-- sides: the future (a ∷ w) of the parents is the future w of the
-- children, definitionally.
futureEq-step : (step : X → A → X) (observe : X → O) {x y : X}
  → FutureEq step observe x y → (a : A)
  → FutureEq step observe (step x a) (step y a)
futureEq-step step observe h a w = h (a ∷ w)

-- The relation is literally equality of the two behavior functions.
futureEq→behavior≡ : (step : X → A → X) (observe : X → O) {x y : X}
  → FutureEq step observe x y
  → behavior step observe x ≡ behavior step observe y
futureEq→behavior≡ step observe h = funExt h

behavior≡→futureEq : (step : X → A → X) (observe : X → O) {x y : X}
  → behavior step observe x ≡ behavior step observe y
  → FutureEq step observe x y
behavior≡→futureEq step observe p w = funExt⁻ p w

------------------------------------------------------------------------
-- 3.  Comparing observations: refinement and pairing
------------------------------------------------------------------------

-- A finer observation can split old meanings but cannot merge them.
futureEq-of-finer : (step : X → A → X)
    (coarse : X → O) (fine : X → F) (forget : F → O)
  → ((x : X) → forget (fine x) ≡ coarse x)
  → {x y : X} → FutureEq step fine x y → FutureEq step coarse x y
futureEq-of-finer step coarse fine forget hf {x} {y} h w =
  sym (hf (run step x w)) ∙ cong forget (h w) ∙ hf (run step y w)

-- Joint observation preserves exactly the intersection of two
-- distinctions.
futureEq-pair→ : (step : X → A → X) (left : X → O) (right : X → P)
  → {x y : X} → FutureEq step (λ s → left s , right s) x y
  → FutureEq step left x y × FutureEq step right x y
futureEq-pair→ step left right h =
  (λ w → cong fst (h w)) , (λ w → cong snd (h w))

futureEq-pair← : (step : X → A → X) (left : X → O) (right : X → P)
  → {x y : X} → FutureEq step left x y × FutureEq step right x y
  → FutureEq step (λ s → left s , right s) x y
futureEq-pair← step left right (hl , hr) w i = hl w i , hr w i

------------------------------------------------------------------------
-- 4.  Behavioral congruences; FutureEq is the greatest one
------------------------------------------------------------------------

-- A relation whose classes can be observed and stepped: identified
-- states look the same now and stay identified under every action.
record isBehavioralCongruence {ℓX ℓA ℓO ℓR : Level}
    {X : Type ℓX} {A : Type ℓA} {O : Type ℓO}
    (step : X → A → X) (observe : X → O)
    (S : X → X → Type ℓR) : Type (ℓ-max (ℓ-max ℓX ℓA) (ℓ-max ℓO ℓR)) where
  field
    respects-observe : {x y : X} → S x y → observe x ≡ observe y
    respects-step    : {x y : X} (a : A) → S x y → S (step x a) (step y a)

-- FutureEq itself is a behavioral congruence …
futureEq-isCongruence : (step : X → A → X) (observe : X → O)
  → isBehavioralCongruence step observe (FutureEq step observe)
futureEq-isCongruence step observe = record
  { respects-observe = λ h → h []
  ; respects-step    = λ a h → futureEq-step step observe h a
  }

-- … and it is the GREATEST one: every behavioral congruence is
-- contained in it.  (Induction on the future word: the empty word is
-- the observation clause, and a ∷ w steps both sides and recurses.)
congruence→futureEq :
    {X : Type ℓX} {A : Type ℓA} {O : Type ℓO} {S : X → X → Type ℓR}
    {step : X → A → X} {observe : X → O}
  → isBehavioralCongruence step observe S
  → {x y : X} → S x y → FutureEq step observe x y
congruence→futureEq isC s [] =
  isBehavioralCongruence.respects-observe isC s
congruence→futureEq isC s (a ∷ w) =
  congruence→futureEq isC (isBehavioralCongruence.respects-step isC a s) w

------------------------------------------------------------------------
-- 5.  The future-behavior quotient
------------------------------------------------------------------------

module FutureQuotient {ℓX ℓA ℓO : Level}
    {X : Type ℓX} {A : Type ℓA} {O : Type ℓO}
    (step : X → A → X) (setO : isSet O) (observe : X → O) where

  _≈_ : X → X → Type (ℓ-max ℓA ℓO)
  _≈_ = FutureEq step observe

  -- Because O is a set, future equality is a proposition …
  isProp≈ : BinaryRelation.isPropValued _≈_
  isProp≈ x y = isPropΠ (λ w → setO _ _)

  -- … and an equivalence relation.
  ≈-isEquivRel : BinaryRelation.isEquivRel _≈_
  ≈-isEquivRel = BinaryRelation.equivRel
    (futureEq-refl step observe)
    (λ x y → futureEq-sym step observe)
    (λ x y z → futureEq-trans step observe)

  -- The quotient: states up to complete observable future.
  Meaning : Type (ℓ-max ℓX (ℓ-max ℓA ℓO))
  Meaning = X / _≈_

  isSetMeaning : isSet Meaning
  isSetMeaning = squash/

  ----------------------------------------------------------------------
  -- 5a.  Descent: the machine structure survives the quotient
  ----------------------------------------------------------------------

  -- Every action descends because future equality is a congruence.
  quotStep : Meaning → A → Meaning
  quotStep m a = SQ.rec squash/
    (λ x → [ step x a ])
    (λ x y h → eq/ _ _ (futureEq-step step observe h a))
    m

  quotStep-[] : (x : X) (a : A) → quotStep [ x ] a ≡ [ step x a ]
  quotStep-[] x a = refl

  -- The present observation descends because the empty future is among
  -- all futures.
  quotObserve : Meaning → O
  quotObserve = SQ.rec setO observe (λ x y h → h [])

  quotObserve-[] : (x : X) → quotObserve [ x ] ≡ observe x
  quotObserve-[] x = refl

  -- Executing before or after quotienting gives the same meaning
  -- (Lean: quotientRun_mk).
  quotRun-[] : (x : X) (w : List A)
    → run quotStep [ x ] w ≡ [ run step x w ]
  quotRun-[] x []      = refl
  quotRun-[] x (a ∷ w) = quotRun-[] (step x a) w

  -- The quotient machine has the same complete behavior as the
  -- original machine, on every state and every word.
  quotient-preserves-behavior : (x : X) (w : List A)
    → behavior quotStep quotObserve [ x ] w ≡ behavior step observe x w
  quotient-preserves-behavior x w = cong quotObserve (quotRun-[] x w)

  ----------------------------------------------------------------------
  -- 5b.  Effectivity: paths of meanings are exactly future equality
  ----------------------------------------------------------------------

  []-effective : (x y : X) → Path Meaning [ x ] [ y ] → x ≈ y
  []-effective = SQ.effective isProp≈ ≈-isEquivRel

  -- Strictly more: the path space of the quotient at two named states
  -- IS future equality — an isomorphism of types, not just a function
  -- (the univalent form of Lean's Quotient.exact / Quotient.sound).
  []-effectiveIso : (x y : X) → Iso (Path Meaning [ x ] [ y ]) (x ≈ y)
  []-effectiveIso = SQ.isEquivRel→effectiveIso isProp≈ ≈-isEquivRel

  ----------------------------------------------------------------------
  -- 5c.  Full abstraction: meanings embed into complete behaviors
  ----------------------------------------------------------------------

  -- A meaning has a complete observable behavior independent of
  -- representative.
  quotBehavior : Meaning → List A → O
  quotBehavior = SQ.rec (isSetΠ (λ _ → setO))
    (behavior step observe)
    (λ x y h → funExt h)

  quotBehavior-[] : (x : X) → quotBehavior [ x ] ≡ behavior step observe x
  quotBehavior-[] x = refl

  -- Distinct meanings have distinct complete futures
  -- (Lean: quotientBehavior_injective).
  quotBehavior-injective : (m n : Meaning)
    → quotBehavior m ≡ quotBehavior n → m ≡ n
  quotBehavior-injective = SQ.elimProp2
    (λ m n → isPropΠ (λ _ → squash/ m n))
    (λ x y p → eq/ x y (λ w → funExt⁻ p w))

  -- The lifted behavior is the quotient machine's own behavior.
  quotBehavior-is-machine-behavior : (m : Meaning)
    → quotBehavior m ≡ behavior quotStep quotObserve m
  quotBehavior-is-machine-behavior = SQ.elimProp
    (λ m → isSetΠ (λ _ → setO) _ _)
    (λ x → funExt (λ w → sym (quotient-preserves-behavior x w)))

  -- Minimality in the observability sense: two states of the quotient
  -- machine with the same complete behavior are the same state.
  crystal-minimal : (m n : Meaning)
    → behavior quotStep quotObserve m ≡ behavior quotStep quotObserve n
    → m ≡ n
  crystal-minimal m n p = quotBehavior-injective m n
    (quotBehavior-is-machine-behavior m
      ∙ p
      ∙ sym (quotBehavior-is-machine-behavior n))

  ----------------------------------------------------------------------
  -- 5d.  Universal property of the quotient
  ----------------------------------------------------------------------

  -- Every quantity valued in a set and constant on future-equivalence
  -- classes factors through meaning (Lean: quotientLift) …
  factor : (setT : isSet T) (target : X → T)
    → ({x y : X} → x ≈ y → target x ≡ target y)
    → Meaning → T
  factor setT target const = SQ.rec setT target (λ x y h → const h)

  factor-[] : (setT : isSet T) (target : X → T)
      (const : {x y : X} → x ≈ y → target x ≡ target y) (x : X)
    → factor setT target const [ x ] ≡ target x
  factor-[] setT target const x = refl

  -- … and the factorization is unique.
  factor-unique : (setT : isSet T) (target : X → T)
      (const : {x y : X} → x ≈ y → target x ≡ target y)
      (g : Meaning → T)
    → ((x : X) → g [ x ] ≡ target x)
    → (m : Meaning) → g m ≡ factor setT target const m
  factor-unique setT target const g hg = SQ.elimProp (λ m → setT _ _) hg

  ----------------------------------------------------------------------
  -- 5e.  Terminality among behavior-preserving quotients
  --
  -- Any quotient of X by a behavioral congruence S is again an observed
  -- machine, and it maps onto Meaning by a unique map that commutes
  -- with step, observation, and the two quotient projections.  Meaning
  -- is the coarsest behavior-preserving quotient.
  ----------------------------------------------------------------------

  module Terminal {ℓR : Level} {S : X → X → Type ℓR}
      (isC : isBehavioralCongruence step observe S) where

    open isBehavioralCongruence isC

    Q : Type (ℓ-max ℓX ℓR)
    Q = X / S

    -- The competing quotient is itself an observed machine: step and
    -- observation descend along S by the congruence assumptions.
    stepQ : Q → A → Q
    stepQ q a = SQ.rec squash/
      (λ x → [ step x a ])
      (λ x y s → eq/ _ _ (respects-step a s))
      q

    observeQ : Q → O
    observeQ = SQ.rec setO observe (λ x y s → respects-observe s)

    -- The mediating map: it exists because S is contained in FutureEq
    -- (S-classes are merged, never split, by the behavior quotient).
    mediate : Q → Meaning
    mediate = SQ.rec squash/
      [_]
      (λ x y s → eq/ x y (congruence→futureEq isC s))

    -- It commutes with the two projections …
    mediate-[] : (x : X) → mediate [ x ] ≡ [ x ]
    mediate-[] x = refl

    -- … with the descended step …
    mediate-step : (a : A) (q : Q)
      → mediate (stepQ q a) ≡ quotStep (mediate q) a
    mediate-step a = SQ.elimProp (λ q → squash/ _ _) (λ x → refl)

    -- … and with the descended observation: mediate is a machine
    -- morphism.
    mediate-observe : (q : Q) → observeQ q ≡ quotObserve (mediate q)
    mediate-observe = SQ.elimProp (λ q → setO _ _) (λ x → refl)

    -- And it is the ONLY map commuting with the projections.
    mediate-unique : (g : Q → Meaning)
      → ((x : X) → g [ x ] ≡ [ x ])
      → (q : Q) → g q ≡ mediate q
    mediate-unique g hg = SQ.elimProp (λ q → squash/ _ _) hg

------------------------------------------------------------------------
-- 6.  Packaging: the quotient of a machine is a machine
------------------------------------------------------------------------

module MachineFutureBehavior {ℓX ℓA ℓO : Level} (M : Machine ℓX ℓA ℓO) where

  open Machine M
  open FutureQuotient step isSetObs observe public

  -- The behavioral crystal of M (notes/NATURAL_CRYSTAL.md, eq. (2)).
  crystal : Machine (ℓ-max ℓX (ℓ-max ℓA ℓO)) ℓA ℓO
  crystal = record
    { State    = Meaning
    ; Action   = Action
    ; Obs      = Obs
    ; isSetObs = isSetObs
    ; step     = quotStep
    ; observe  = quotObserve
    }

  -- Soundness: crystallization changes no observable future.
  crystal-sound : (x : State) (w : List Action)
    → behavior (Machine.step crystal) (Machine.observe crystal) [ x ] w
      ≡ behavior step observe x w
  crystal-sound = quotient-preserves-behavior

  -- Completeness (full abstraction): the crystal separates behaviors.
  crystal-fullyAbstract : (m n : Machine.State crystal)
    → behavior (Machine.step crystal) (Machine.observe crystal) m
      ≡ behavior (Machine.step crystal) (Machine.observe crystal) n
    → m ≡ n
  crystal-fullyAbstract = crystal-minimal
