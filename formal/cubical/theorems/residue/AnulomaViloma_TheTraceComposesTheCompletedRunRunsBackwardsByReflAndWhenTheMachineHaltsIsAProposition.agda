{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनुलोम-विलोम — with the grain and against it.
--
-- Three theorems about the lossless universal machine of Vishvayantra,
-- each an answer the completed step gives that the visible step cannot.
--
--  1. THE TRACE COMPOSES.  For any maps g, f and any target c,
--
--       fiber (g ∘ f) c  ≃  Σ (w : fiber g c). fiber f (π₁ w)
--
--     — the kept fibre of a composite is the composite of kept fibres.
--     Instantiated at the machine: fiber (run (m + n)) factors through
--     the n-fibre and then the m-fibre (`trace-composes`), so the
--     ledger of a long run is assembled from the ledgers of its legs,
--     leg by leg, with nothing double-kept and nothing dropped.
--
--  2. THE COMPLETED RUN RUNS BACKWARDS, BY REFL.  The inverse of the
--     lossless completion literally reads the source out of the fibre:
--     `source-recovered` and `completed-reversible` are refl.  Reverse
--     execution of the completed machine is not a search and not an
--     algorithm; it is a projection, and it computes.
--
--  3. WHEN THE MACHINE HALTS IS A PROPOSITION.  Halting is the table's
--     silence, an equation in a set, so `Halted` is a proposition;
--     silence persists (`silence-persists`); and the pair (first
--     halting time, its minimality) is a proposition
--     (`halting-time-is-a-proposition`): if the machine halts, WHEN it
--     first halts carries no choice and admits no second answer.
------------------------------------------------------------------------

module AnulomaViloma_TheTraceComposesTheCompletedRunRunsBackwardsByReflAndWhenTheMachineHaltsIsAProposition where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function using (_∘_ ; idfun)
open import Cubical.Foundations.HLevels using (isPropΠ2 ; isProp× ; isSet×)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Foundations.GroupoidLaws using (lUnit)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-antisym ; isProp≤ ; zero-≤)
open import Cubical.Data.List using (List ; [])
open import Cubical.Data.List.Properties using (isOfHLevelList)
open import Cubical.Data.Maybe using (Maybe ; nothing ; rec ; isOfHLevelMaybe)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource

private
  variable
    ℓa ℓb ℓc : Level
    A : Type ℓa
    B : Type ℓb
    C : Type ℓc

------------------------------------------------------------------------
-- §1  The trace composes.
------------------------------------------------------------------------

module _ (g : B → C) (f : A → B) where

  fibers-compose : (c : C) →
    Iso (fiber (g ∘ f) c) (Σ (fiber g c) (λ w → fiber f (fst w)))
  Iso.fun (fibers-compose c) (a , p) = (f a , p) , a , refl
  Iso.inv (fibers-compose c) ((b , p) , a , q) = a , cong g q ∙ p
  Iso.rightInv (fibers-compose c) ((b , p) , a , q) =
    J (λ b' q' → (p' : g b' ≡ c) →
         Iso.fun (fibers-compose c) (Iso.inv (fibers-compose c) ((b' , p') , a , q'))
           ≡ ((b' , p') , a , q'))
      (λ p' i → (f a , lUnit p' (~ i)) , a , refl)
      q p
  Iso.leftInv (fibers-compose c) (a , p) i = a , lUnit p (~ i)

------------------------------------------------------------------------
-- §2  Instantiated at the machine: run is additive and its trace
--     factors leg by leg.
------------------------------------------------------------------------

run-additive : (m n : ℕ) (mc : Machine) → run (m + n) mc ≡ run n (run m mc)
run-additive zero    n mc = refl
run-additive (suc m) n mc = run-additive m n (uStep mc)

trace-composes : (m n : ℕ) (end : Machine) →
  fiber (run (m + n)) end ≃ Σ (fiber (run n) end) (λ w → fiber (run m) (fst w))
trace-composes m n end =
  compEquiv
    (pathToEquiv (λ i → fiber (funExt (λ mc → run-additive m n mc) i) end))
    (isoToEquiv (fibers-compose (run n) (run m) end))

------------------------------------------------------------------------
-- §3  The completed run runs backwards, by refl.
------------------------------------------------------------------------

-- The inverse of ANY lossless completion reads the source out of the
-- fibre.  No search, no algorithm: a projection, and it is refl.
completed-reversible : (f : A → B) (a : A) →
  invEq (lossless f) (equivFun (lossless f) a) ≡ a
completed-reversible f a = refl

-- The same, at the machine, for every depth: run forward n steps
-- keeping the fibre, invert, and the source configuration is returned
-- definitionally.
source-recovered : (n : ℕ) (mc : Machine) →
  invEq (run-lossless n) (run n mc , mc , refl) ≡ mc
source-recovered n mc = refl

------------------------------------------------------------------------
-- §4  When the machine halts is a proposition.
------------------------------------------------------------------------

isSetConf : isSet Conf
isSetConf =
  isSet× isSetℕ (isSet× (isOfHLevelList 0 isSetℕ)
                        (isSet× isSetℕ (isOfHLevelList 0 isSetℕ)))

-- Halting is an equation in a set, hence a proposition: there is at
-- most one silence.
isPropHalted : (mc : Machine) → isProp (Halted mc)
isPropHalted (M , c) = isOfHLevelMaybe 0 isSetConf (δ M c) nothing

-- A halted machine stays where it is, at every further depth.
run-of-halted : (k : ℕ) (mc : Machine) → Halted mc → run k mc ≡ mc
run-of-halted zero    mc h = refl
run-of-halted (suc k) mc h =
  (λ i → run k (halted-is-fixed mc h i)) ∙ run-of-halted k mc h

HaltsAt : ℕ → Machine → Type
HaltsAt n mc = Halted (run n mc)

-- Silence persists: a machine silent at depth m is silent at every
-- later depth.
silence-persists : (m k : ℕ) (mc : Machine) →
  HaltsAt m mc → HaltsAt (m + k) mc
silence-persists m k mc h =
  subst Halted (sym (run-additive m k mc ∙ run-of-halted k (run m mc) h)) h

-- The first halting time: the depth, its silence, and its minimality.
FirstHalt : Machine → ℕ → Type
FirstHalt mc n = HaltsAt n mc × ((m : ℕ) → HaltsAt m mc → n ≤ m)

-- THE THEOREM.  If the machine halts, when it first halts is a
-- proposition: any two answers agree, as data.
halting-time-is-a-proposition : (mc : Machine) → isProp (Σ ℕ (FirstHalt mc))
halting-time-is-a-proposition mc (n , h , least) (n' , h' , least') =
  Σ≡Prop (λ k → isProp× (isPropHalted (run k mc))
                        (isPropΠ2 (λ _ _ → isProp≤)))
         (≤-antisym (least n' h') (least' n h))

-- The empty table's first halt is computed: depth zero, silence by
-- refl, minimality by zero-≤.
empty-first-halt : (c : Conf) → FirstHalt ([] , c) zero
empty-first-halt c = refl , λ m _ → zero-≤
