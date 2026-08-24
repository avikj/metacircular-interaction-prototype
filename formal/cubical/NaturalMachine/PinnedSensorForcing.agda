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
-- NaturalMachine.PinnedSensorForcing
--
-- A uniquely refuted bad world forces its refuter into every sound sensor
-- anatomy.  What it forces is a least CORE, not the whole anatomy: inert or
-- redundant sensors may still be added.  Conversely, absence of pinned
-- worlds does not by itself license deletion, because an uncovered bad world
-- has zero refuters and is therefore not pinned either.
--
-- The constructive deletion theorem retains exactly the missing datum: after
-- deleting a sensor, every bad world must come with an explicitly different
-- refuter.  Two Bool controls separate both overstatements from this repair.
------------------------------------------------------------------------

module NaturalMachine.PinnedSensorForcing where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; true≢false)
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Data.Sigma using (Σ-syntax ; fst ; snd ; _,_ ; _×_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓS ℓW ℓG ℓR ℓA : Level

------------------------------------------------------------------------
-- Generic scheme
------------------------------------------------------------------------

module Scheme
  {Sensor : Type ℓS} {World : Type ℓW}
  (Good : World → Type ℓG)
  (Refutes : Sensor → World → Type ℓR)
  where

  Bad : World → Type ℓG
  Bad world = ¬ Good world

  -- A proof-relevant active predicate is deliberate: the forcing theorem
  -- transports the actual admission witness along the unique-refuter path.
  Sound : (Sensor → Type ℓA) → Type _
  Sound Active =
    (world : World) → Bad world →
    Σ[ sensor ∈ Sensor ] (Active sensor × Refutes sensor world)

  record Pinned (world : World) (sensor : Sensor)
    : Type (ℓ-max ℓS ℓR) where
    field
      refutes : Refutes sensor world
      unique  : (other : Sensor) → Refutes other world → other ≡ sensor

  open Pinned public

  -- Theorem P(i), constructively and without finiteness or decidable equality.
  pinned-forces-active :
    (Active : Sensor → Type ℓA) → Sound Active →
    {world : World} {sensor : Sensor} →
    Bad world → Pinned world sensor → Active sensor
  pinned-forces-active Active sound {world} bad pinned =
    subst Active (unique pinned other refutation) active
    where
      witness : Σ[ candidate ∈ Sensor ]
                (Active candidate × Refutes candidate world)
      witness = sound world bad

      other : Sensor
      other = fst witness

      active : Active other
      active = fst (snd witness)

      refutation : Refutes other world
      refutation = snd (snd witness)

  -- Coverage by pins is stronger than merely saying that pinned worlds exist:
  -- it chooses the unique refuter for every bad world.
  PinningFamily : Type _
  PinningFamily =
    (world : World) → Bad world →
    Σ[ sensor ∈ Sensor ] Pinned world sensor

  ContainsPins :
    (Active : Sensor → Type ℓA) → PinningFamily → Type _
  ContainsPins Active pinning =
    (world : World) (bad : Bad world) →
    Active (fst (pinning world bad))

  sound→contains-pins :
    (Active : Sensor → Type ℓA) →
    (pinning : PinningFamily) →
    Sound Active → ContainsPins Active pinning
  sound→contains-pins Active pinning sound world bad =
    pinned-forces-active Active sound bad (snd (pinning world bad))

  contains-pins→sound :
    (Active : Sensor → Type ℓA) →
    (pinning : PinningFamily) →
    ContainsPins Active pinning → Sound Active
  contains-pins→sound Active pinning contains world bad =
    fst pinned , contains world bad , refutes (snd pinned)
    where
      pinned : Σ[ sensor ∈ Sensor ] Pinned world sensor
      pinned = pinning world bad

  -- Thus a pinning family characterizes soundness by containment of a least
  -- forced core.  It does NOT say that Active itself is uniquely determined.
  forced-core-characterization :
    (Active : Sensor → Type ℓA) →
    (pinning : PinningFamily) →
    (Sound Active → ContainsPins Active pinning) ×
    (ContainsPins Active pinning → Sound Active)
  forced-core-characterization Active pinning =
    sound→contains-pins Active pinning ,
    contains-pins→sound Active pinning

  Deleted : Sensor → Sensor → Type ℓS
  Deleted deleted sensor = ¬ (sensor ≡ deleted)

  -- This is the constructive content required by deletion.  Merely knowing
  -- that no refuter is unique does not manufacture the alternative.
  AlternativesAfterDeleting : Sensor → Type _
  AlternativesAfterDeleting deleted =
    (world : World) → Bad world →
    Σ[ sensor ∈ Sensor ]
      (Deleted deleted sensor × Refutes sensor world)

  alternatives→deletion-sound :
    (deleted : Sensor) →
    AlternativesAfterDeleting deleted → Sound (Deleted deleted)
  alternatives→deletion-sound deleted alternatives world bad =
    fst witness , fst (snd witness) , snd (snd witness)
    where
      witness : Σ[ sensor ∈ Sensor ]
                  (Deleted deleted sensor × Refutes sensor world)
      witness = alternatives world bad

  NoPinned : Type _
  NoPinned =
    (world : World) → (bad : Bad world) →
    (sensor : Sensor) → ¬ Pinned world sensor

------------------------------------------------------------------------
-- Control 1: a pinned core can have distinct sound supersets
------------------------------------------------------------------------

GoodUnit : Unit → Type₀
GoodUnit tt = ⊥

badUnit : ¬ GoodUnit tt
badUnit impossible = impossible

CoreRefutes : Bool → Unit → Type₀
CoreRefutes false tt = Unit
CoreRefutes true  tt = ⊥

module Core = Scheme GoodUnit CoreRefutes

falsePinned : Core.Pinned tt false
Core.Pinned.refutes falsePinned = tt
Core.Pinned.unique falsePinned false refutation = refl
Core.Pinned.unique falsePinned true  refutation = Empty.rec refutation

corePinning : Core.PinningFamily
corePinning tt bad = false , falsePinned

Minimal : Bool → Type₀
Minimal false = Unit
Minimal true  = ⊥

Extended : Bool → Type₀
Extended false = Unit
Extended true  = Unit

minimalContains : Core.ContainsPins Minimal corePinning
minimalContains tt bad = tt

extendedContains : Core.ContainsPins Extended corePinning
extendedContains tt bad = tt

minimalSound : Core.Sound Minimal
minimalSound = Core.contains-pins→sound Minimal corePinning minimalContains

extendedSound : Core.Sound Extended
extendedSound = Core.contains-pins→sound Extended corePinning extendedContains

PointwiseEquivalent :
  (Bool → Type₀) → (Bool → Type₀) → Type₀
PointwiseEquivalent Left Right =
  (sensor : Bool) →
  (Left sensor → Right sensor) × (Right sensor → Left sensor)

-- Both anatomies are sound and contain the forced sensor, but the inert true
-- sensor belongs only to Extended.  Pinning therefore cannot prove anatomy
-- uniqueness without a separate irredundancy convention.
minimal≠extended : ¬ PointwiseEquivalent Minimal Extended
minimal≠extended equivalent = snd (equivalent true) tt

------------------------------------------------------------------------
-- Control 2: zero refuters means no pins AND no sound anatomy
------------------------------------------------------------------------

NoRefutes : Bool → Unit → Type₀
NoRefutes sensor tt = ⊥

module EmptyScheme = Scheme GoodUnit NoRefutes

empty-has-no-pins : EmptyScheme.NoPinned
empty-has-no-pins tt bad sensor pinned =
  EmptyScheme.Pinned.refutes pinned

empty-has-no-sound-anatomy :
  (Active : Bool → Type ℓA) → ¬ EmptyScheme.Sound Active
empty-has-no-sound-anatomy Active sound =
  snd (snd (sound tt badUnit))

------------------------------------------------------------------------
-- Positive control: explicit alternatives make deletion sound
------------------------------------------------------------------------

BothRefute : Bool → Unit → Type₀
BothRefute sensor tt = Unit

module BothScheme = Scheme GoodUnit BothRefute

alternative-after-false : BothScheme.AlternativesAfterDeleting false
alternative-after-false tt bad = true , true≢false , tt

deleting-false-is-sound : BothScheme.Sound (BothScheme.Deleted false)
deleting-false-is-sound =
  BothScheme.alternatives→deletion-sound false alternative-after-false
