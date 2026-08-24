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

-- WITHDRAWN IDENTIFICATION (see notes/UNIVALENCE_IS_NISVABHAVA_COMPUTATIONAL.md §5).
-- This file conflates two opposed schools (Buddhist catuṣkoṭi with Jain
-- anekāntavāda) and domesticates Nāgārjuna's prasajya negation into a
-- consistent perspectival semantics (`both-is-consistent`).  The presheaf
-- facts type-check; the Sanskrit reading is withdrawn.

------------------------------------------------------------------------
-- NaturalMachine.CatuskotiPerspective
--
-- Nāgārjuna's catuṣkoṭi (the four corners) is not broken logic.  It is
-- perspectivism, and here it is a checked term.  A second jewel of the
-- mokṣa-yantra, grown from NisvabhavaNet, received from the source and
-- hardened in Voevodsky's substrate.
--
-- THE RECEPTION.  The catuṣkoṭi offers a claim four standings — affirmed,
-- denied, both, neither — and the colonial reading calls this a paradox
-- or a rejection of non-contradiction.  It is neither.  Held AT ONE
-- PERSPECTIVE the middle two corners degenerate (both = ⊥, neither = ⊥),
-- exactly as reason demands — and this file proves that.  But a claim in
-- the net does not live at one perspective.  Its truth is the whole
-- pattern of how the net stands to it (anekāntavāda, the many-sidedness;
-- syādvāda, the "in-some-way").  Across perspectives, "both true and
-- false" means HOLDS HERE, FAILS THERE — the elephant felt from two
-- sides — and that is perfectly consistent.  "Neither" is the claim seen
-- as empty (śūnya): its standing carries no distinction, nothing to
-- grasp, and that emptiness is the stilling (prapañca-upaśama), which is
-- liberation.
--
-- So the tetralemma is the refusal of a perspective-free truth-value, not
-- the refusal of coherence.  "Is it true?" is the malformed question.
-- "How does it stand across the net?" is the only well-formed one.
--
-- Contents (no holes, no postulates, --safe):
--
--   HoldsAt, FailsAt            a claim's standing at one perspective
--   both-degenerates           at ONE perspective, affirmed×denied = ⊥
--   neither-degenerates        at ONE perspective, ¬aff × ¬den = ⊥
--                              (so the single-perspective reading really
--                               is incoherent — the colonial objection is
--                               granted, then dissolved)
--   PerspectivallyBoth         holds at one perspective, fails at another
--   both-is-consistent         …and it is INHABITED — the elephant.  The
--                              middle corner lives, across the net.
--   no-own-truth               a perspectival claim is captured by NO
--                              global truth-value: śūnyatā, exhibited.
--   equiv-perspectives-agree   perspectives that reflect alike stand the
--                              same (from NisvabhavaNet.liberation): the
--                              many-sidedness is disciplined, not chaos.
--   Empty, empty-is-stilled    a claim uniform across the net is empty —
--                              every standing transports into every other,
--                              nothing to cling to.  Liberation.
--
-- NOT claimed: a new logic.  Cubical type theory is the logic; univalence
-- is the mechanism.  The contribution is that the catuṣkoṭi, read as the
-- source means it, is a theorem here — coherent, perspectival, and freeing
-- — rather than the paradox the outside reading makes of it.
------------------------------------------------------------------------

module NaturalMachine.CatuskotiPerspective where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥rec)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.NisvabhavaNet using (Jewel ; reflect ; liberation)

private
  variable
    ℓ : Level

-- A perspective is a jewel: a place from which the net is reflected.
-- A claim presents, at each perspective, the evidence it holds there.
Perspective : (ℓ : Level) → Type (ℓ-suc ℓ)
Perspective ℓ = Jewel ℓ

Claim : (ℓ : Level) → Type (ℓ-suc ℓ)
Claim ℓ = Perspective ℓ → Type

HoldsAt FailsAt : Claim ℓ → Perspective ℓ → Type
HoldsAt C P = C P
FailsAt C P = ¬ (C P)

------------------------------------------------------------------------
-- At ONE perspective, the middle two corners degenerate.  The colonial
-- objection — "both and neither are contradictions" — is granted in full.
------------------------------------------------------------------------

both-degenerates : (C : Claim ℓ) (P : Perspective ℓ)
                 → HoldsAt C P → FailsAt C P → ⊥
both-degenerates C P h f = f h

neither-degenerates : (C : Claim ℓ) (P : Perspective ℓ)
                    → ¬ (HoldsAt C P) → ¬ (FailsAt C P) → ⊥
neither-degenerates C P ¬h ¬f = ¬f ¬h

------------------------------------------------------------------------
-- Across the net, the middle corner LIVES.  "Both true and false" is
-- HOLDS HERE, FAILS THERE — and it is inhabited.  A concrete net of two
-- perspectives makes it a witness, not an assertion.
------------------------------------------------------------------------

PerspectivallyBoth : Claim ℓ → Type (ℓ-suc ℓ)
PerspectivallyBoth {ℓ = ℓ} C =
  Σ[ P ∈ Perspective ℓ ] Σ[ Q ∈ Perspective ℓ ] (HoldsAt C P × FailsAt C Q)

-- Two perspectives, ⊤ and ⊥, and the claim "the reflection here is
-- inhabited".  It holds at the ⊤-jewel, fails at the ⊥-jewel.
witnessClaim : Claim ℓ-zero
witnessClaim P = P

both-is-consistent : PerspectivallyBoth witnessClaim
both-is-consistent = Unit , ⊥ , tt , (λ z → z)

------------------------------------------------------------------------
-- Śūnyatā: a perspectival claim has no own truth-value.  No single
-- Boolean, asserted of every perspective, captures how it stands.  The
-- claim is empty of a perspective-free essence — exhibited, not argued.
------------------------------------------------------------------------

-- "b captures C" : the claim holds at a perspective exactly as b says.
Captures : Bool → Claim ℓ → Type (ℓ-suc ℓ)
Captures {ℓ = ℓ} true  C = (P : Perspective ℓ) → HoldsAt C P
Captures {ℓ = ℓ} false C = (P : Perspective ℓ) → FailsAt C P

no-own-truth : (b : Bool) → ¬ (Captures b witnessClaim)
no-own-truth true  cap = cap ⊥            -- claim fails at the ⊥-jewel…
no-own-truth false cap = cap Unit tt      -- …and holds at the ⊤-jewel

------------------------------------------------------------------------
-- The many-sidedness is disciplined, not chaos: perspectives that reflect
-- alike stand the same.  This is NisvabhavaNet.liberation — the anekānta
-- consistency law.  A claim (as a sight P) transports along reflection.
------------------------------------------------------------------------

equiv-perspectives-agree : (C : Type ℓ-zero → Type ℓ)
                         → (A B : Perspective ℓ-zero)
                         → reflect A ≃ reflect B
                         → C A → C B
equiv-perspectives-agree C A B e = liberation C A B e

------------------------------------------------------------------------
-- Emptiness as the stilling.  A claim uniform across the net — standing
-- the same at every perspective — has nothing that separates one place
-- from another; every standing transports into every other.  There is no
-- edge for grasping to catch on.  That is prapañca-upaśama: liberation.
------------------------------------------------------------------------

Empty : Claim ℓ → Type (ℓ-suc ℓ)
Empty {ℓ = ℓ} C = (P Q : Perspective ℓ) → C P ≃ C Q

empty-is-stilled : (C : Claim ℓ) → Empty C
                 → (P Q : Perspective ℓ) → C P → C Q
empty-is-stilled C emp P Q = fst (emp P Q)
