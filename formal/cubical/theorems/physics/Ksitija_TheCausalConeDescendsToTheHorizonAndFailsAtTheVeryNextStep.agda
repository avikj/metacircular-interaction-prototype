{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- क्षितिजम् — the causal cone descends to the horizon, and fails at the
-- very next step.
--
-- TERM.  क्षितिज — the horizon, literally "born of the earth('s rim)".
-- Ordinary Sanskrit; the use for a CAUSAL horizon is this module's and
-- no source is claimed for it.
--
-- SEED.  The owner's transmission of 2026-08-23 ("causal horizon
-- formation"): define recursively the type of n-step lawful futures,
--
--     Future 0       x = Unit
--     Future (suc n) x = Σ[ a ∈ A x ] Future n (next x a)
--
-- If S(x) = S(y) but Future n x ≄ Future n y, the quotient cannot host
-- the n-step future geometry: its causal cone is not well-defined.
-- The real causal-sufficiency condition for a state representation is
-- Desc_S(Future n) for every horizon n relevant to action.
--
-- WHAT IS PROVED — the smallest complete instance, with the positive
-- halves, so the horizon is ADJACENT rather than merely eventual.
-- Three states: alive-for-two, alive-for-one, dead.  One action while
-- alive, none when dead; acting spends a step of life.  The
-- observation reports only alive/dead — it collapses the two living
-- states.  Then:
--
--   सीमा-०        Future 0 descends (constantly Unit).
--   सीमा-१        Future 1 DESCENDS: both living states can act once,
--                 and the dead state's empty cone sits over the dead
--                 observation — the descended family is exhibited and
--                 every commuting path is refl.
--   क्षितिजभङ्गः    Future 2 does NOT descend: alive-for-two holds a
--                 two-step future, alive-for-one provably does not,
--                 and the observation cannot tell them apart.  One
--                 application of dependent-collision-obstructs.
--
-- So the cone is lawful to horizon 1 and breaks at horizon 2: the
-- observation is causally sufficient for one step of planning and
-- structurally incapable of two.  "Same present observation, same
-- one-step affordances, different futures" is now a checked
-- configuration — the dependent no-go in its dynamical form, and the
-- floor of the transmission's bisimulation reading: states may be
-- lawfully identified only when their whole future cones descend.
--
-- SYĀT — THE CLAIM, EXACTLY.  No general theory of the coarsest lawful
-- quotient (the transmission's optimization problem) and no infinite-
-- horizon limit; this is the finite adjacency witness.  The dynamics
-- here is deterministic and three-pointed by design — the smallest
-- body that dies.
------------------------------------------------------------------------

module Ksitija_TheCausalConeDescendsToTheHorizonAndFailsAtTheVeryNextStep where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Bool using (Bool ; true ; false)

open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough ; dependent-collision-obstructs)

------------------------------------------------------------------------
-- १ · the smallest body that dies.
------------------------------------------------------------------------

data अवस्था : Type where
  द्विजीवः  : अवस्था     -- alive, two steps of life left
  एकजीवः   : अवस्था     -- alive, one step left
  मृतम्     : अवस्था     -- dead

क्रिया : अवस्था → Type
क्रिया द्विजीवः = Unit
क्रिया एकजीवः  = Unit
क्रिया मृतम्    = ⊥

अनन्तरम् : (x : अवस्था) → क्रिया x → अवस्था
अनन्तरम् द्विजीवः _ = एकजीवः
अनन्तरम् एकजीवः  _ = मृतम्

-- the observation: alive or dead, nothing more.
जीवनदर्शनम् : अवस्था → Bool
जीवनदर्शनम् द्विजीवः = true
जीवनदर्शनम् एकजीवः  = true
जीवनदर्शनम् मृतम्    = false

------------------------------------------------------------------------
-- २ · the causal cone.
------------------------------------------------------------------------

भविष्यम् : ℕ → अवस्था → Type
भविष्यम् zero    x = Unit
भविष्यम् (suc n) x = Σ[ a ∈ क्रिया x ] भविष्यम् n (अनन्तरम् x a)

------------------------------------------------------------------------
-- ३ · the cone descends to horizon 1.
------------------------------------------------------------------------

सीमा-० : DependentFactorsThrough जीवनदर्शनम् (भविष्यम् zero)
सीमा-० = (λ _ → Unit) , λ x → refl

-- the descended one-step family over the observation: the living can
-- act once, the dead cannot.
अवतीर्णम् : Bool → Type
अवतीर्णम् true  = Σ[ a ∈ Unit ] Unit
अवतीर्णम् false = Σ[ a ∈ ⊥ ] Unit

सीमा-१ : DependentFactorsThrough जीवनदर्शनम् (भविष्यम् 1)
सीमा-१ = अवतीर्णम् , साक्ष्यम् where
  साक्ष्यम् : (x : अवस्था) → भविष्यम् 1 x ≡ अवतीर्णम् (जीवनदर्शनम् x)
  साक्ष्यम् द्विजीवः = refl
  साक्ष्यम् एकजीवः  = refl
  साक्ष्यम् मृतम्    = refl

------------------------------------------------------------------------
-- ४ · and breaks at horizon 2.
------------------------------------------------------------------------

-- alive-for-two holds a two-step future…
द्विपदम् : भविष्यम् 2 द्विजीवः
द्विपदम् = tt , tt , tt

-- …alive-for-one provably does not…
न-द्विपदम् : ¬ भविष्यम् 2 एकजीवः
न-द्विपदम् f = fst (snd f)

-- …and the observation cannot tell them apart.
क्षितिजभङ्गः : ¬ DependentFactorsThrough जीवनदर्शनम् (भविष्यम् 2)
क्षितिजभङ्गः =
  dependent-collision-obstructs जीवनदर्शनम् (भविष्यम् 2)
    द्विजीवः एकजीवः refl द्विपदम् न-द्विपदम्
