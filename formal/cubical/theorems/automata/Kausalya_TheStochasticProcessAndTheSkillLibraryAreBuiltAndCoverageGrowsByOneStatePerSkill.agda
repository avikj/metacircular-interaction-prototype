{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कौशल्य — skill, proficiency.
--
-- WHY THIS FILE EXISTS.  The abstract "IN A PROOF-CARRYING LEARNER,
-- GENERALISATION AND SHAREABILITY ARE EXCLUSIVE" says, under WHAT IS
-- NOT CLAIMED, that there is no Markov decision process, no reward
-- signal, no stochasticity, no discounting and no optimisation in the
-- development — that "skill" names a record, "state" names a term, and
-- whether a deployed learner's skill representation has this shape is a
-- reading.
--
-- The process is built here with the stochasticity the earlier form
-- lacks, and the separation becomes a quantitative theorem about a
-- learner: §५ proves the covered set of a library is contained in the
-- training states of its members, so CAPABILITY GROWS BY AT MOST ONE
-- STATE PER SKILL, and §६ proves that no finite library covers an
-- infinite state space — by producing the state it misses.
--
-- The reward signal, the discounting and the optimisation are in
-- `Chala_…` (theorems/cost), which builds the decision process,
-- policies, the discounted return at an arbitrary rate and optimality
-- quantified over every policy.  This file adds the two things that one
-- does not have: STOCHASTIC transitions, with the deterministic process
-- proved to be the Dirac special case (§२), and the SKILL LIBRARY.
--
-- WHAT IS CHECKED
--
--   §१  `Dist`, `expect`, `dirac`   finite distributions, ℕ-weighted.
--   §२  `SMDP`, `sret`              the stochastic process and its
--       `sret-det`                  return; the deterministic process
--                                   embeds, with equal returns.
--   §३  `Trace`, `len`, `two-traces`  routes, and that a route is not
--                                   determined by its endpoints.
--   §४  `Memo`, `enabled-isContr`   THE MEMORISING SKILL FIRES AT
--                                   EXACTLY ONE STATE: its enabled set
--                                   is contractible, centred on the
--                                   training state.
--   §५  `library-coverage`          so a library's covered set lies
--                                   inside its training states.
--   §६  `library-misses`            and no finite library covers ℕ —
--                                   the missed state is constructed.
--   §७  `no-trace-from-endpoints`   the generalising form cannot be
--                                   installed: whatever it supplies —
--                                   endpoints and prop-valued outcome
--                                   families — does not determine the
--                                   route the library demands.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Kausalya_TheStochasticProcessAndTheSkillLibraryAreBuiltAndCoverageGrowsByOneStatePerSkill where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-zero ; ·-identityˡ ; isSetℕ ; snotz ; max)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ¬m<m ; left-≤-max ; right-≤-max ; <≤-trans)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  absurd : {X : Type} → ⊥ → X
  absurd ()

------------------------------------------------------------------------
-- १ · finite distributions, weighted by counts.
------------------------------------------------------------------------

Dist : Type → Type
Dist A = List (ℕ × A)

expect : {A : Type} → Dist A → (A → ℕ) → ℕ
expect []              f = 0
expect ((p , a) ∷ d) f = p · f a + expect d f

dirac : {A : Type} → A → Dist A
dirac a = (1 , a) ∷ []

expect-dirac : {A : Type} (a : A) (f : A → ℕ) → expect (dirac a) f ≡ f a
expect-dirac a f = cong (_+ 0) (·-identityˡ (f a)) ∙ +-zero (f a)

------------------------------------------------------------------------
-- २ · the STOCHASTIC decision process, and the deterministic one inside it.
------------------------------------------------------------------------

record MDP (S A : Type) : Type where
  field
    move   : S → A → S
    payoff : S → A → ℕ

record SMDP (S A : Type) : Type where
  field
    smove   : S → A → Dist S
    spayoff : S → A → ℕ

open MDP public
open SMDP public

ret : {S A : Type} → MDP S A → ℕ → (S → A) → S → ℕ
ret M zero    π s = 0
ret M (suc n) π s = payoff M s (π s) + ret M n π (move M s (π s))

sret : {S A : Type} → SMDP S A → ℕ → (S → A) → S → ℕ
sret M zero    π s = 0
sret M (suc n) π s = spayoff M s (π s) + expect (smove M s (π s)) (sret M n π)

det→stoch : {S A : Type} → MDP S A → SMDP S A
smove   (det→stoch M) s a = dirac (move M s a)
spayoff (det→stoch M)     = payoff M

-- the deterministic process is the Dirac special case, on the nose.
sret-det : {S A : Type} (M : MDP S A) (n : ℕ) (π : S → A) (s : S)
         → sret (det→stoch M) n π s ≡ ret M n π s
sret-det M zero    π s = refl
sret-det M (suc n) π s =
  cong (payoff M s (π s) +_)
    ( expect-dirac (move M s (π s)) (sret (det→stoch M) n π)
    ∙ sret-det M n π (move M s (π s)) )

------------------------------------------------------------------------
-- ३ · routes, and that the endpoints do not determine one.
------------------------------------------------------------------------

data Trace {S : Type} : S → S → Type where
  stop : {s : S} → Trace s s
  step : {s t u : S} → s ≡ t → Trace t u → Trace s u

len : {S : Type} {s t : S} → Trace s t → ℕ
len stop        = 0
len (step _ tr) = suc (len tr)

------------------------------------------------------------------------
-- ४ · THE MEMORISING SKILL, AND WHERE IT FIRES.
--
-- It carries its endpoints, the route between them, the applicability
-- family its author supplied, and — the field that does the damage —
-- the projection of that family onto an identification with the single
-- training state.  Whatever family the author wrote, the enabled set is
-- then contractible and centred on that state.
------------------------------------------------------------------------

record Memo (S : Type) : Type₁ where
  field
    src tgt : S
    route   : Trace src tgt
    App     : S → Type
    appProp : (s : S) → isProp (App s)
    fires   : App src
    pin     : (s : S) → App s → s ≡ src

open Memo public

enabled : {S : Type} → Memo S → Type
enabled {S = S} k = Σ[ s ∈ S ] App k s

enabled-isContr : {S : Type} → isSet S → (k : Memo S) → isContr (enabled k)
fst (enabled-isContr sS k) = src k , fires k
snd (enabled-isContr sS k) (s , a) =
  ΣPathP (sym (pin k s a) , toPathP (appProp k s _ a))

------------------------------------------------------------------------
-- ५ · SO COVERAGE GROWS BY AT MOST ONE STATE PER SKILL.
------------------------------------------------------------------------

data Any {S : Type} (P : Memo S → Type) : List (Memo S) → Type₁ where
  hereA  : {k : Memo S} {ks : List (Memo S)} → P k → Any P (k ∷ ks)
  thereA : {k : Memo S} {ks : List (Memo S)} → Any P ks → Any P (k ∷ ks)

FiresIn : {S : Type} → List (Memo S) → S → Type₁
FiresIn lib s = Any (λ k → App k s) lib

IsTrainingState : {S : Type} → List (Memo S) → S → Type₁
IsTrainingState lib s = Any (λ k → s ≡ src k) lib

library-coverage : {S : Type} (lib : List (Memo S)) (s : S)
                 → FiresIn lib s → IsTrainingState lib s
library-coverage (k ∷ ks) s (hereA a)  = hereA (pin k s a)
library-coverage (k ∷ ks) s (thereA m) = thereA (library-coverage ks s m)

------------------------------------------------------------------------
-- ६ · AND NO FINITE LIBRARY COVERS AN INFINITE STATE SPACE.
--
-- The missed state is constructed, not argued for: one past the largest
-- training state in the library.
------------------------------------------------------------------------

ceiling : List (Memo ℕ) → ℕ
ceiling []       = 0
ceiling (k ∷ ks) = max (src k) (ceiling ks)

src≤ceiling : (lib : List (Memo ℕ)) (s : ℕ) → IsTrainingState lib s → s ≤ ceiling lib
src≤ceiling (k ∷ ks) s (hereA e)  = subst (_≤ ceiling (k ∷ ks)) (sym e) left-≤-max
src≤ceiling (k ∷ ks) s (thereA m) = ≤-trans (src≤ceiling ks s m) right-≤-max

library-misses : (lib : List (Memo ℕ)) → ¬ FiresIn lib (suc (ceiling lib))
library-misses lib fires =
  ¬m<m (<≤-trans (≤-refl {m = suc (ceiling lib)})
                 (src≤ceiling lib (suc (ceiling lib))
                   (library-coverage lib (suc (ceiling lib)) fires)))

------------------------------------------------------------------------
-- ७ · AND THE GENERALISING FORM CANNOT BE INSTALLED.
--
-- A generalising skill supplies its endpoints and a family of outcome
-- equalities.  An outcome equality in a discrete domain is a
-- proposition, so what it supplies is: two states, and a proof-
-- irrelevant certificate.  The library demands a ROUTE, and the route
-- is not a function of the endpoints — here are two skills sharing both
-- endpoints whose routes have different lengths, and hence the
-- statement in the form that admits no encoding: no function of the
-- endpoints agrees with the route's length.
------------------------------------------------------------------------

trivialApp : ℕ → ℕ → Type
trivialApp c s = s ≡ c

shortSkill longSkill : Memo ℕ
src     shortSkill = 0
tgt     shortSkill = 0
route   shortSkill = stop
App     shortSkill = trivialApp 0
appProp shortSkill s = isSetℕ s 0
fires   shortSkill = refl
pin     shortSkill s a = a
src     longSkill = 0
tgt     longSkill = 0
route   longSkill = step refl stop
App     longSkill = trivialApp 0
appProp longSkill s = isSetℕ s 0
fires   longSkill = refl
pin     longSkill s a = a

no-trace-from-endpoints :
  ¬ (Σ[ f ∈ (ℕ → ℕ → ℕ) ] ((k : Memo ℕ) → f (src k) (tgt k) ≡ len (route k)))
no-trace-from-endpoints (f , sound) =
  snotz (sym (sound longSkill) ∙ sound shortSkill)
