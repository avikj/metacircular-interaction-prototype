{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.SaturationAtACutIsIdempotent
--
-- `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` §31–32 ("Isbell
-- nucleus at a cut") describes an elimination procedure:
--
--   "Nuc(K_e): saturated dual pairs (x, y) with y = K↑x, x = K↓y —
--    exact burden profile and exact residual profile, a tight separable
--    majorant. … Elimination via nucleus generators: compute, cover,
--    pass generator coefficients, compose by min-plus convolution,
--    re-saturate.  No tractability theorem claimed."
--
-- "Re-saturate" is stated as a step of an algorithm and nothing says it
-- terminates, or that it terminates in ONE application.  That is the
-- gap this module fills, at the level of generality where it is a
-- theorem rather than an assertion.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY IS CLAIMED FOR ANY THEOREM BELOW.  This is the Galois
-- connection induced by a relation — Birkhoff's polarities (`Lattice
-- Theory`, 1940, §V on polarities); the same adjunction is the basis of
-- formal concept analysis (Ganter & Wille, `Formale Begriffsanalyse`,
-- 1996 / `Formal Concept Analysis`, 1999), where the saturated pairs
-- are the *concepts* of a context and the closure below is the concept
-- closure; and Isbell's construction (`Adequate subcategories`, 1960;
-- the conjugation of 1966) is the enriched form the note's name points
-- at.  All that is contributed here is that the step Δ 28 §31–32 calls
-- "re-saturate" is checked to be idempotent, so the procedure does not
-- loop.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, for an arbitrary K : X → Y → Type
--
--   ↑-antitone / ↓-antitone   the two polarities reverse inclusion
--   unit / counit             A ⊆ ↓(↑ A) and B ⊆ ↑(↓ B)
--   triangle↑ / triangle↑'    ↑ A and ↑(↓(↑ A)) contain each other —
--                             saturating a profile that came from a
--                             saturation changes nothing
--   c-inflationary / c-monotone / c-idempotent
--                             so c = ↓ ∘ ↑ is a closure operator, and
--                             re-saturation is idempotent
--   fixedGivesSaturated / saturatedGivesFixed
--                             the saturated dual pairs of §31 are
--                             EXACTLY the fixed points of c
--
-- The content for §31–32 is the last two together with idempotence: an
-- implementation may re-saturate once after each composition and stop,
-- and "saturated pair" is not an extra condition to maintain — it is
-- what being a fixed point of the closure means.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED, and this is the load-bearing part.
--
-- The note's ↑ and ↓ are min-plus RESIDUATIONS over a semiring-valued
-- kernel, taking burden profiles to residual profiles.  The ↑ and ↓
-- below are the two-valued polarities of a RELATION.  That the former
-- is an instance of the latter is NOT proved here and is not obvious:
-- it needs the kernel's values to form a quantale and the residuations
-- to be its adjoints, none of which is set up in this repository.  So
-- what is established is that the SATURATION discipline is sound
-- wherever the adjunction holds — not that Δ 28's particular ↑/↓ satisfy
-- it.  Reading this as a theorem about min-plus convolution would be
-- exactly the error of quoting a figure without its input.
--
-- Inclusion is used, not equality: `A ⊆ B` and `B ⊆ A` are proved
-- separately and never combined into a path.  Turning them into `A ≡ B`
-- needs the predicates to be proposition-valued and funExt, neither of
-- which is assumed, and nothing below needs it.
--
-- No tractability theorem is claimed here either — §31–32 says it
-- claims none, and computing c is no cheaper for being idempotent.
--
-- On the two-slot shape: this repository already carries a distinct
-- two-slot structure in `formal/cubical/AbhavaAvacchedaka.agda` and
-- `NaturalMachine/TheAnuyogitaAvacchedakaIsADistinctSlot`, from
-- Nyāya-Vaiśeṣika's treatment of absence, where the pratiyogin and the
-- anuyogin occupy separate delimitor slots.  It is NOT claimed that
-- that is a Galois connection or that these are the same structure —
-- the Naiyāyika slots are not required to be adjoint and nothing here
-- checks that they are.  The pointer is so a later reader compares them
-- rather than assuming either way.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.SaturationAtACutIsIdempotent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_)

------------------------------------------------------------------------
-- 0.  Inclusion
------------------------------------------------------------------------

_⊆_ : {A : Type} → (A → Type) → (A → Type) → Type
_⊆_ {A} P Q = (a : A) → P a → Q a

⊆-refl : {A : Type} (P : A → Type) → P ⊆ P
⊆-refl P a p = p

⊆-trans : {A : Type} (P Q R : A → Type) → P ⊆ Q → Q ⊆ R → P ⊆ R
⊆-trans P Q R f g a p = g a (f a p)

------------------------------------------------------------------------
-- 1.  The two polarities of a cut
--
-- K x y reads "burden x is discharged by residual y".  ↑ A collects the
-- residuals discharging every burden in A; ↓ B the burdens discharged
-- by every residual in B.
------------------------------------------------------------------------

module _ {X Y : Type} (K : X → Y → Type) where

  ↑ : (X → Type) → (Y → Type)
  ↑ A y = (x : X) → A x → K x y

  ↓ : (Y → Type) → (X → Type)
  ↓ B x = (y : Y) → B y → K x y

  ↑-antitone : (A A' : X → Type) → A ⊆ A' → ↑ A' ⊆ ↑ A
  ↑-antitone A A' sub y f x a = f x (sub x a)

  ↓-antitone : (B B' : Y → Type) → B ⊆ B' → ↓ B' ⊆ ↓ B
  ↓-antitone B B' sub x g y b = g y (sub y b)

  unit : (A : X → Type) → A ⊆ ↓ (↑ A)
  unit A x a y f = f x a

  counit : (B : Y → Type) → B ⊆ ↑ (↓ B)
  counit B y b x g = g y b

------------------------------------------------------------------------
-- 2.  Saturating a saturated profile changes nothing
------------------------------------------------------------------------

  triangle↑ : (A : X → Type) → ↑ A ⊆ ↑ (↓ (↑ A))
  triangle↑ A = counit (↑ A)

  triangle↑' : (A : X → Type) → ↑ (↓ (↑ A)) ⊆ ↑ A
  triangle↑' A = ↑-antitone A (↓ (↑ A)) (unit A)

------------------------------------------------------------------------
-- 3.  Hence re-saturation is idempotent
------------------------------------------------------------------------

  c : (X → Type) → (X → Type)
  c A = ↓ (↑ A)

  c-inflationary : (A : X → Type) → A ⊆ c A
  c-inflationary = unit

  c-monotone : (A A' : X → Type) → A ⊆ A' → c A ⊆ c A'
  c-monotone A A' sub = ↓-antitone (↑ A') (↑ A) (↑-antitone A A' sub)

  c-idempotent-in : (A : X → Type) → c (c A) ⊆ c A
  c-idempotent-in A = ↓-antitone (↑ A) (↑ (c A)) (triangle↑ A)

  c-idempotent-out : (A : X → Type) → c A ⊆ c (c A)
  c-idempotent-out A = unit (c A)

------------------------------------------------------------------------
-- 4.  The saturated dual pairs are exactly the fixed points
------------------------------------------------------------------------

  Saturated : (X → Type) → (Y → Type) → Type
  Saturated A B = ((↑ A ⊆ B) × (B ⊆ ↑ A)) × ((↓ B ⊆ A) × (A ⊆ ↓ B))

  fixedGivesSaturated : (A : X → Type) → c A ⊆ A → Saturated A (↑ A)
  fixedGivesSaturated A fix =
    (⊆-refl (↑ A) , ⊆-refl (↑ A)) , (fix , unit A)

  saturatedGivesFixed :
    (A : X → Type) (B : Y → Type) → Saturated A B → c A ⊆ A
  saturatedGivesFixed A B ((_ , ba) , (da , _)) =
    ⊆-trans (c A) (↓ B) A (↓-antitone B (↑ A) ba) da

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section names a gap —
--
--   "what is established is that the SATURATION discipline is sound
--    wherever the adjunction holds — not that Δ 28's particular ↑/↓
--    satisfy it"
--
-- — without saying what would close it.  Now said, in
-- `NaturalMachine.TheSaturationClosureNeedsOnlyAGaloisConnection`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
-- Everything above uses NOTHING about `Type`, `⊆`, or the relation K.
-- It uses two preorders, two maps, and the two directions of a
-- contravariant Galois connection.  Antitonicity, unit, counit, the
-- triangles, idempotence, and the fixed-point characterisation are all
-- DERIVED from those, in `module Galois`.
--
-- The consequence for Δ 28 is that the residuation case requires no
-- re-proving of anything above.  It requires exactly:
--
--   a preorder on burden profiles, a preorder on residual profiles, and
--
--     galFwd : a ≼ d b → b ⊑ u a
--     galBwd : b ⊑ u a → a ≼ d b
--
--   for the min-plus ↑ and ↓ — and nothing else.
--
-- §5 there checks that THIS module is one instance: `galFwdPred` and
-- `galBwdPred` are a line each, and the closure theory transports with
-- nothing re-proved.  That is what makes the size of the remaining
-- obligation credible rather than asserted.
--
-- STILL NOT CLAIMED, and unchanged: the min-plus instance itself.
-- Neither direction is proved for a semiring-valued kernel, and no
-- quantale is constructed anywhere in this repository, so the
-- idempotence result STILL does not apply to min-plus convolution.
-- Making an obligation small and explicit is not discharging it.
------------------------------------------------------------------------
