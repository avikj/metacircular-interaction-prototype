{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusPresentation
--
-- The corpus's own mathematics, pointed at the corpus's own checked
-- declarations.  This module introduces NO new semantic theory:
--
--   * the presentation quotient is FutureBehavior.FutureQuotient.Meaning
--     — the greatest behavioral congruence, with effectivity, full
--     abstraction, factorization, and terminality all inherited, not
--     re-proved and not replaced by a minimizer or an MDL objective;
--   * the descent law is FiniteInformation.FactorsThrough ≃
--     FiberConstant, and refinement demands are decided by it;
--   * presentation invariance is ObservationPresentation's postEquiv
--     iso, instantiated, not restated;
--   * the contraction rule is TranscriptDescent's: retain while
--     reconstruction is obstructed (collisionObstructsDecoder), erase
--     exactly when the fibre is contractible (isContrSingl);
--   * the states are FORMED REFLECTED DECLARATIONS — the bridge of
--     ReflectedFormation applied to the enumeration of CorpusNames.
--
-- THE LOSSLESS SPLIT, as one term (presentation-splits):
--
--     formed presentations  ≃  Σ (m : Meaning) RealizationFiber m
--
-- compact meaning plus exact proof-relevant realization fibre is the
-- full formed mathematics.  Nothing is erased before reconstructibility:
-- the realization fibre keeps every collapsed distinction, and the one
-- record shown erasable (carrying-the-view-is-free) is erasable because
-- its fibre is CONTRACTIBLE — the Carrier law's free binding — while
-- the set-level future-view fibre at meaning level is a point
-- (view-fiber-contractible) precisely because Meaning is fully
-- abstract; the proof-relevant mass stays upstairs in the realization
-- fibre, unidentified with its shadow.
--
-- WHAT THE ACTIONS ARE.  Structural navigation of the elaborated term
-- (descend / shift) and the structural shape observation.  These are
-- checked total functions on formed syntax — no synthetic similarity
-- action, no score.  Every semantic identification below is backed by a
-- checked inhabitant: an ≃, an isContr, a ¬, a FactorsThrough, or a
-- path in the quotient.
--
-- SCOPE, exactly.  The machine observes the SHAPE of formed
-- declarations and its quotient is the future-shape meaning; that is
-- the seed instance of the flow
--
--   checked declaration → formed presentation → machine → Meaning,
--
-- uniform in the enumeration and in the observation: any refinement of
-- `shape` (the paired observation refined-view-decodes exhibits one)
-- yields a finer Meaning by futureEq-of-finer, and the split theorem
-- is generic in both.  What is NOT here: no claim that shape meaning
-- exhausts semantic meaning (it provably does not:
-- view-needs-refinement), and no re-proof of what the imported modules
-- already own.
------------------------------------------------------------------------

module CorpusPresentation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; fiber ; equivFun)
open import Cubical.Foundations.HLevels using (isSetΠ)
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; isSetℕ ; injSuc ; znots)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd ; Σ-contractSnd ; Σ≡Prop)
open import Cubical.Data.List using (List)
open import Cubical.Data.Unit using (Unit)
open import Cubical.HITs.SetQuotients using ([_])
open import Cubical.Relation.Nullary using (¬_)

open import Agda.Builtin.List
  using () renaming (List to BList ; [] to []ᵇ ; _∷_ to _∷ᵇ_)
open import Agda.Builtin.Reflection
  using ( Name ; Term ; TC ; Arg ; arg ; Abs ; abs
        ; arg-info ; visible ; modality ; relevant ; quantity-ω
        ; var ; con ; def ; lam ; pat-lam ; pi ; agda-sort ; lit ; meta ; unknown
        ; bindTC ; returnTC ; quoteTC ; unify )

import FutureBehavior as FB
open import FiniteInformation
  using (FactorsThrough ; FiberConstant ; fiberConstant→factorsThrough)
open import ObservationPresentation using (factorsThrough-postEquivIso)
open import TranscriptDescent using (collisionObstructsDecoder)

open import CorpusNames using (corpus)
open import ReflectedFormation
  using (Decl ; mkDecl ; declAll ; refsTerm ; refsDecl ; _++ᵇ_)

------------------------------------------------------------------------
-- §0.  The enumeration, formed.  The macro runs the bridge at
--      elaboration time and lands its result as a checked literal: the
--      corpus's declarations, as first-class values of this module.
------------------------------------------------------------------------

macro
  formedAll : Term → TC Unit
  formedAll hole =
    bindTC (declAll corpus) λ ds →
    bindTC (quoteTC ds)     (unify hole)

corpusFormed : BList Decl
corpusFormed = formedAll

lenᵇ : {A : Type₀} → BList A → ℕ
lenᵇ []ᵇ       = zero
lenᵇ (_ ∷ᵇ xs) = suc (lenᵇ xs)

-- Every included checked declaration is reachable as a formed
-- presentation: the formation covers the enumeration, name for name.
formation-covers-the-enumeration : lenᵇ corpusFormed ≡ lenᵇ corpus
formation-covers-the-enumeration = refl

------------------------------------------------------------------------
-- §1.  The machine over formed presentations.
--
-- State   = elaborated Term (a formed presentation)
-- Action  = structural navigation, total, checked
-- Obs     = structural shape (head constructor and arity), a set
------------------------------------------------------------------------

data Probe : Type₀ where
  descend shift : Probe

argsOf : Term → BList (Arg Term)
argsOf (var _ as)     = as
argsOf (con _ as)     = as
argsOf (def _ as)     = as
argsOf (pat-lam _ as) = as
argsOf (meta _ as)    = as
argsOf _              = []ᵇ

firstArg : BList (Arg Term) → Term → Term
firstArg (arg _ t ∷ᵇ _) _    = t
firstArg _              dflt = dflt

secondArg : BList (Arg Term) → Term → Term
secondArg (_ ∷ᵇ arg _ t ∷ᵇ _) _    = t
secondArg _                   dflt = dflt

stepT : Term → Probe → Term
stepT (lam _ (abs _ b)) descend = b
stepT (pi (arg _ a) _)  descend = a
stepT t                 descend = firstArg (argsOf t) t
stepT (pi _ (abs _ b))  shift   = b
stepT t                 shift   = secondArg (argsOf t) t

headCode : Term → ℕ
headCode (var _ _)     = 0
headCode (con _ _)     = 1
headCode (def _ _)     = 2
headCode (lam _ _)     = 3
headCode (pat-lam _ _) = 4
headCode (pi _ _)      = 5
headCode (agda-sort _) = 6
headCode (lit _)       = 7
headCode (meta _ _)    = 8
headCode unknown       = 9

shape : Term → ℕ
shape t = headCode t + 10 · lenᵇ (argsOf t)

M : FB.Machine ℓ-zero ℓ-zero ℓ-zero
M = record
  { State    = Term
  ; Action   = Probe
  ; Obs      = ℕ
  ; isSetObs = isSetℕ
  ; step     = stepT
  ; observe  = shape
  }

------------------------------------------------------------------------
-- §2.  The presentation quotient IS the future-behavior quotient.
--      Meaning, effectivity, full abstraction, factor, factor-unique,
--      crystal-minimal, and terminality arrive by `open … public`;
--      none is restated here.
------------------------------------------------------------------------

open FB.MachineFutureBehavior M public

------------------------------------------------------------------------
-- §3.  THE LOSSLESS SPLIT.  Compact meaning plus exact realization
--      fibre is, up to equivalence, the full space of formed
--      presentations.  The forward map carries a presentation to its
--      meaning together with itself and the reflexive witness; nothing
--      is discarded, and the inverse is a projection.
------------------------------------------------------------------------

RealizationFiber : Meaning → Type _
RealizationFiber m = fiber [_] m

presentation-splits : Term ≃ (Σ[ m ∈ Meaning ] RealizationFiber m)
presentation-splits = isoToEquiv split
  where
  split : Iso Term (Σ[ m ∈ Meaning ] RealizationFiber m)
  Iso.fun      split t           = [ t ] , t , refl
  Iso.inv      split (m , t , p) = t
  Iso.rightInv split (m , t , p) i = p i , t , (λ j → p (i ∧ j))
  Iso.leftInv  split t           = refl

------------------------------------------------------------------------
-- §4.  REFINEMENT IS DECIDED BY FACTORIZATION, and the decision has
--      both verdicts on the corpus's own formed syntax.
--
-- The demanded view: the reference census of a presentation (how many
-- declarations it mentions).  The shape observation does NOT support
-- it — two formed terms with one head and one argument each mention
-- one and two names — so the demand obstructs every decoder and the
-- view needs refinement (retain: reconstruction is obstructed).  The
-- refined observation pairing shape with the census supports it with
-- a definitional decoder (erase nothing further: reconstruction
-- exists).  Both verdicts are the existing machinery's, instantiated.
------------------------------------------------------------------------

refsLen : Term → ℕ
refsLen t = lenᵇ (refsTerm t)

private
  vArg : Term → Arg Term
  vArg = arg (arg-info visible (modality relevant quantity-ω))

  -- Two formed presentations colliding in shape (same head, one
  -- argument) whose reference censuses differ: 1 against 2.
  collide₁ collide₂ : Term
  collide₁ = def (quote FB.run) (vArg (var 0 []ᵇ) ∷ᵇ []ᵇ)
  collide₂ = def (quote FB.run) (vArg (def (quote FB.behavior) []ᵇ) ∷ᵇ []ᵇ)

  one≢two : ¬ (1 ≡ 2)
  one≢two p = znots (injSuc p)

view-needs-refinement : ¬ FactorsThrough shape refsLen
view-needs-refinement =
  collisionObstructsDecoder shape refsLen
    {x = collide₁} {x' = collide₂} refl one≢two

refinedShape : Term → ℕ × ℕ
refinedShape t = shape t , refsLen t

refined-view-decodes : FactorsThrough refinedShape refsLen
refined-view-decodes =
  fiberConstant→factorsThrough isSetℕ refinedShape refsLen
    (λ x x' p → cong snd p)

-- And the verdicts are presentation-invariant: any lossless change of
-- the observation's codomain preserves exactly what can descend.
shape-presentation-invariant :
  {Z : Type₀} (e : ℕ ≃ Z)
  → Iso (FactorsThrough shape refsLen)
        (FactorsThrough (equivFun e ∘ shape) refsLen)
shape-presentation-invariant = factorsThrough-postEquivIso isSetℕ shape refsLen

------------------------------------------------------------------------
-- §5.  THE CONTRACTION RULE, both sides.
--
-- Erase exactly when reconstruction exists: carrying the current
-- observation beside the presentation adds a CONTRACTIBLE fibre — the
-- free binding of the Carrier law — so that record is erasable, by an
-- equivalence, with the erasure's inverse constructing it back.
--
-- Retain otherwise: the realization fibre of §3 is where every
-- distinction the quotient collapses continues to live, and §4's
-- obstruction shows a view whose reconstruction from shape alone is
-- impossible — that distinction may not be erased.
------------------------------------------------------------------------

carrying-the-view-is-free :
  (Σ[ t ∈ Term ] singl (shape t)) ≃ Term
carrying-the-view-is-free = Σ-contractSnd (λ t → isContrSingl (shape t))

------------------------------------------------------------------------
-- §6.  THE FUTURE-VIEW FIBRE AT MEANING LEVEL IS A POINT — full
--      abstraction read as contractibility: a meaning is exactly its
--      complete observable future, so the set-level fibre over a
--      realized behavior is contractible, centred on the meaning that
--      realizes it.  The proof-relevant mass is NOT here — it is
--      upstairs in RealizationFiber, which §3 keeps and §4 shows is
--      genuinely non-trivial.  The two are related by the split, never
--      identified.
------------------------------------------------------------------------

view-fiber-isProp : (b : List Probe → ℕ) → isProp (fiber quotBehavior b)
view-fiber-isProp b (m , p) (n , q) =
  Σ≡Prop (λ x → isSetΠ (λ _ → isSetℕ) _ _)
         (quotBehavior-injective m n (p ∙ sym q))

view-fiber-contractible :
  (m : Meaning) → isContr (fiber quotBehavior (quotBehavior m))
view-fiber-contractible m =
  (m , refl) , view-fiber-isProp (quotBehavior m) (m , refl)

------------------------------------------------------------------------
-- §7.  The formed corpus enters the machine: each formed declaration's
--      elaborated type is a state, its meaning a point of the quotient.
--      Uniform in the enumeration — extending CorpusNames extends this
--      map with no new code.
------------------------------------------------------------------------

mapᵇ : {A B : Type₀} → (A → B) → BList A → BList B
mapᵇ f []ᵇ       = []ᵇ
mapᵇ f (x ∷ᵇ xs) = f x ∷ᵇ mapᵇ f xs

corpusStates : BList Term
corpusStates = mapᵇ Decl.type corpusFormed

corpusMeanings : BList Meaning
corpusMeanings = mapᵇ [_] corpusStates

meanings-cover-the-enumeration : lenᵇ corpusMeanings ≡ lenᵇ corpus
meanings-cover-the-enumeration = refl
