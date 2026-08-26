{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अवच्छेद — the cut.  यत् सीमा धारयति तत् आधारः, यत् न धारयति सा स्मृतिः ।
--
-- (what the boundary retains is the base; what it does not retain is the
--  memory.)
--
-- ────────────────────────────────────────────────────────────────────
-- are the same construction and neither knows it.  102 files in this
-- corpus name Myhill–Nerode; not one of the causal-state notes contains
-- the word पुनरागमन.  This module is the identification.
--
-- THE PHYSICS LANE'S OWN SENTENCES, quoted because they are already the
-- statement and only the vocabulary is missing:
--
--   "The boundary is not an object placed between two already constituted
--    worlds.  It is the datum through which composition across the cut is
--    possible."
--
--   "The state at a temporal boundary is therefore not necessarily the
--    machine's internal register.  It is the least retained distinction
--    sufficient for the admitted future questions."
--
--   "Memory is a failure of factorization."
--
-- And its predictive quotient (3):  h ∼ h′ ⟺ P(F ∣ h) = P(F ∣ h′).
--
-- THAT QUOTIENT IS THE FIBER OF THE RESPONSE MAP.  Write the response as
-- `f : A → B`, a history to the profile it induces.  Then two histories
-- are predictively identified exactly when they lie in one fiber of `f`,
-- and the three sentences above become three facts about that fiber.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED BELOW, and none of it is constructed by hand.
--
--  §१  A ≃ Σ[ b ∈ B ] fiber f b.  The history set decomposes as
--      (boundary datum, what the boundary did not retain).  This is NOT a
--      new theorem: it is `Carrier f` with its two Σ's exchanged, and
--      `Loss.Carrier` already proves `A ≃ Carrier f` for every
--      `f`, with no h-level hypothesis on either side.  The physics
--      lane's decomposition and the पुनरागमन law are one line apart.
--
--  §२  "No memory" is `isEquiv f`, i.e. every fiber contractible.  Then
--      A ≡ B: the boundary IS the history set and nothing is retained
--      beyond it.  This is the cut theorem's d = rank T at rank = |A|.
--
--  §३  So "memory is a failure of factorization" reads, exactly,
--      MEMORY IS THE FIBER FAILING TO BE CONTRACTIBLE — and the failure
--      has the three verdicts of `Tantujala_…agda`, not two:
--          रिक्तम्  a profile no history induces  (b outside the image)
--          एकम्    contractible — no memory at that profile
--          बहु     memory required, and the fiber IS the amount
--      `isContr` merges the first and the third, so a two-valued verdict
--      on a cut cannot distinguish "unreachable" from "remembered", which
--      is `Saptabhangi.दुर्नयः` arriving in physics.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.  The cut theorem over a field says the least
-- boundary dimension is `rank T`, a NUMBER.  Nothing below computes a
-- rank, and the correspondence proved here is the structural one: the
-- decomposition, not its dimension.  Nonnegative rank and quantum
-- realizations impose further constraints the physics note names, and
-- none of them appear here.  Nothing below is about physical spacetime.
--
-- TERM.  अवच्छेद — delimitation, cutting off, the marking of a boundary —
-- is standard Nyāya-Vaiśeṣika technical vocabulary (अवच्छेदक, the
-- delimitor: that which restricts a property to its locus).  LIMIT: it is
-- used here for the process-table cut of the physics note, which no
-- Sanskrit source states; the term is borrowed for its exact sense of a
-- delimiting boundary and nothing is attributed to any text.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Avaccheda_TheCutsBoundaryIsTheBaseAndMemoryIsTheFiberFailingToBeContractible where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Function
open import Cubical.Data.Sigma

private variable ℓ ℓ' : Level

------------------------------------------------------------------------
-- १ · अवच्छेदः — the cut decomposes the history set.
--
-- Σ[ b ∈ B ] fiber f b ≃ A.  The left side is (boundary datum, the
-- histories that datum does not separate); the right is the histories.
-- Nothing is built: it is Σ-swap composed with the contractibility of
-- singletons, which is the same pair of facts `Loss.Carrier`
-- uses to prove A ≃ Carrier f.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) where
  -- One universe, because an equivalence needs both sides in it.  This is
  -- the same restriction `Loss.Carrier` carries in its own
  -- {A B : Type ℓ} — a further sign these are one construction.

  -- what the boundary does not retain, at a given boundary datum
  स्मृतिः : B → Type ℓ
  स्मृतिः b = fiber f b
  -- The decomposition.  `Σ-contractSnd` will not fire here (the second
  -- component is genuinely dependent), so the retract is written, and it
  -- is one line of cube: `λ j → p (i ∧ j)` slides the witness along the
  -- very path that says the history lands on that boundary datum.  At
  -- i = 0 the conjunction collapses to `refl`, at i = 1 it is `p` itself.
  -- This is the same contractible-singleton fact `Loss.Carrier`
  -- runs on, in the other order — the physics note's decomposition and
  -- the पुनरागमन law are not analogous, they are one construction.
  अवच्छेदः : (Σ[ b ∈ B ] स्मृतिः b) ≃ A
  अवच्छेदः = isoToEquiv (iso प्रति अनु (λ _ → refl) निवृत्ति)
    where
    प्रति : Σ[ b ∈ B ] स्मृतिः b → A
    प्रति (_ , a , _) = a
    अनु : A → Σ[ b ∈ B ] स्मृतिः b
    अनु a = f a , a , refl
    निवृत्ति : (x : Σ[ b ∈ B ] स्मृतिः b) → अनु (प्रति x) ≡ x
    निवृत्ति (b , a , p) i = p i , a , λ j → p (i ∧ j)
  -- the same read as a path, which is what transports
  अवच्छेद-पथः : (Σ[ b ∈ B ] स्मृतिः b) ≡ A
  अवच्छेद-पथः = ua अवच्छेदः

------------------------------------------------------------------------
-- २ · स्मृत्यभावः — no memory is exactly `isEquiv`.
--
-- "The boundary retains everything" is every fiber contractible, which is
-- the DEFINITION of isEquiv, not a consequence of it — so this is `refl`
-- on the record's field and the content is that the physics reading and
-- the type-theoretic one are the same predicate.
------------------------------------------------------------------------

module _ {A B : Type ℓ} {f : A → B} where

  स्मृत्यभावः : isEquiv f → (b : B) → isContr (fiber f b)
  स्मृत्यभावः e = equiv-proof e

  -- and then the cut is trivial: the boundary IS the history set.
  सीमा-सर्वम् : isEquiv f → A ≡ B
  सीमा-सर्वम् e = ua (f , e)

------------------------------------------------------------------------
-- ३ · त्रयो भङ्गाः — the three verdicts, at the cut.
--
-- `Tantujala_…agda` proves the fiber census has three answers and that
-- `isContr` merges two of them.  Here that theorem is READ at the cut and
-- becomes a statement about memory: a boolean verdict on a boundary
-- cannot tell "this profile is never induced" from "this profile is
-- induced by many histories and the boundary must remember which".
--
-- The witnesses are the smallest possible and are `refl`, because the
-- point is not that they are hard — it is that they are DIFFERENT.
------------------------------------------------------------------------

open import Cubical.Data.Unit
open import Cubical.Data.Bool
open import Cubical.Data.Empty renaming (rec to ⊥-rec)

-- रिक्तम् : a profile no history induces.  ⊥ → Unit has empty fiber at tt.
रिक्तम्-उदाहरणम् : fiber {A = ⊥} {B = Unit} (λ ()) tt → ⊥
रिक्तम्-उदाहरणम् (() , _)

-- बहु : two histories, one profile.  Bool → Unit remembers a bit.
बहु-उदाहरणम् : fiber {A = Bool} {B = Unit} (λ _ → tt) tt
बहु-उदाहरणम् = false , refl

बहु-उदाहरणम्' : fiber {A = Bool} {B = Unit} (λ _ → tt) tt
बहु-उदाहरणम्' = true , refl

-- Neither fiber is contractible, and a verdict that says only "not
-- contractible" has said one word about two situations: in the first
-- nothing is remembered because nothing happened, in the second a bit
-- must cross the boundary.  That is the दुर्नय.

------------------------------------------------------------------------
-- ४ · शेषः — what this leaves.
--
-- The identification is structural and it is now a term.  What it does
-- NOT give: the rank.  `d = rank T` is a dimension and §१ is a
-- decomposition, so the numerical half of the cut theorem is still only
-- in prose.  The honest next piece is a finite instance where the fiber
-- census and the rank are both computed and compared — and the physics
-- note is explicit that nonnegative rank can EXCEED ordinary rank, so a
-- classical latent variable and a linear factorization are already two
-- verdicts there, which is the same three-verdict warning one level up.
------------------------------------------------------------------------
