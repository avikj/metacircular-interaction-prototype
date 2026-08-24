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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ProvenanceIsCarriedAndNeverConsumedSoFreeWasDoingDoubleDuty
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- `notes/` grepped.  **No tradition term is claimed and none is
-- invented.**  This is an audit of a record of mine about a note of this
-- corpus's own (Δ 28 §39–47); there is no source to cite and inventing a
-- Sanskrit label would assert a provenance nobody checked — which would
-- be a small joke at this module's expense and still wrong.
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT.  Target: `ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem`,
-- a COUNTING `Only`.  Its header states the count:
--
--   "THREE OF THE FOUR COMPOSE FOR FREE.  Boundary preservation is a
--    path and paths compose; migration is a function and functions
--    compose; provenance is a list and lists append.  Only COMPLEXITY
--    IMPROVEMENT needs a theorem … the content is only the count —
--    three free, one earned."
--
-- **THE COUNT IS RIGHT AND THE WORD IS NOT.  `free` is doing double
-- duty for two different things, and the two are not comparable.**
--
--   DERIVABLE-FREE.  Boundary preservation composes by `∙`, migration by
--   function composition.  Each is a real obligation discharged by a
--   real operation; there is something to prove and the proof is one
--   symbol.
--
--   VACUOUSLY FREE.  Provenance is `List Prov` with NO condition
--   anywhere.  It composes by `++` because nothing constrains it —
--   including `++` itself.  §2 below proves the sharp form: **any
--   certificate's provenance may be REPLACED BY THE EMPTY LIST and the
--   result is still a certificate.**  So no theorem downstream can ever
--   recover a step from it.
--
-- Those are opposite situations wearing one word.  A reader counting
-- "three free, one earned" concludes the record is three-quarters
-- discharged; it is one-half discharged, one-quarter under-specified
-- (migration, whose law is independent — 43380f01's neighbours record
-- that), and one-quarter inert.
--
-- **AND THE COUNT DRIFTED IN THE APPENDS, WHICH IS HOW I NOTICED.**  The
-- first append there revises it to "THREE FREE, ONE EARNED, AND ONE
-- UNDER-SPECIFIED" — five slots for four components, because migration
-- is counted in both lists.  A four-item count that reads as five is
-- the symptom; the conflated word is the cause.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   len / lenAppend    length is additive over `++`, by induction —
--                      v0.5's `Cubical.Data.List.Properties` has
--                      `length-map` but no `length-++`, so it is proved
--                      here rather than assumed
--   provenanceLengthIsAdditive
--                      composing certificates adds provenance lengths.
--                      This is the ONLY thing provenance satisfies.
--   provenanceMayBeDiscarded
--                      and it satisfies nothing else: `(s , i , m , _)`
--                      ↦ `(s , i , m , [])` is a certificate for the
--                      same pair.  **This is the proof that `free` meant
--                      `vacuous` here**, and it is the whole finding
--   provenanceIsNotDeterminedByTheOtherThree
--                      immediately: two certificates for the same pair
--                      agreeing on the first three components and
--                      differing on the fourth
--
-- WHAT IS NOT CLAIMED.  This does not FIX anything.  Adding a law to
-- provenance — that an entry corresponds to a step, that the length
-- tracks the chain — is not done, and the audited module is NOT
-- amended: its four-component Σ is unchanged and still admits inert
-- provenance.  Nothing here concerns migration's law, which is settled
-- elsewhere and is a different failure (under-specified, not inert).
-- Nothing here is a compiler, and Δ 28 §39–47's planner is untouched.
-- ASSOCIATIVITY of composition is still not proved anywhere on this
-- line, and §1 below does not need it.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.ProvenanceIsCarriedAndNeverConsumedSoFreeWasDoingDoubleDuty where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem
  using (Certified ; composeCertified)

------------------------------------------------------------------------
-- 1.  Length, and its additivity — v0.5 ships neither
------------------------------------------------------------------------

len : {ℓ : Level} {A : Type ℓ} → List A → ℕ
len []       = zero
len (_ ∷ xs) = suc (len xs)

lenAppend :
  {ℓ : Level} {A : Type ℓ} (xs ys : List A)
  → len (xs ++ ys) ≡ len xs + len ys
lenAppend []       ys = refl
lenAppend (x ∷ xs) ys = cong suc (lenAppend xs ys)

------------------------------------------------------------------------
-- 2.  What provenance satisfies, and what it does not
------------------------------------------------------------------------

module _ {Sys B Prov : Type}
         (sem  : Sys → B)
         (cost : Sys → List ℕ)
         (M    : Sys → Type)
  where

  -- `Prov` is implicit in `Certified` and appears only in its fourth
  -- component, so no application determines it.  Fixing it once here is
  -- what makes every statement below have a type at all — and it is a
  -- small instance of the same point: the provenance type is so
  -- unconstrained that the elaborator cannot find it either.
  Cert : Sys → Sys → Type
  Cert = Certified {Prov = Prov} sem cost M

  prov : {d e : Sys} → Cert d e → List Prov
  prov c = snd (snd (snd c))

  ----------------------------------------------------------------------
  -- 2a.  The one law it has: composition adds lengths
  ----------------------------------------------------------------------

  provenanceLengthIsAdditive :
    (d e f : Sys) (c₁ : Cert d e) (c₂ : Cert e f)
    → len (prov (composeCertified sem cost M d e f c₁ c₂))
      ≡ len (prov c₁) + len (prov c₂)
  provenanceLengthIsAdditive d e f c₁ c₂ = lenAppend (prov c₁) (prov c₂)

  ----------------------------------------------------------------------
  -- 2b.  And the one it does not have: it may simply be thrown away
  ----------------------------------------------------------------------

  provenanceMayBeDiscarded : (d e : Sys) → Cert d e → Cert d e
  provenanceMayBeDiscarded d e (s , i , m , _) = (s , i , m , [])

  provenanceIsNotDeterminedByTheOtherThree :
    (d e : Sys) (c : Cert d e) (p : List Prov)
    → Σ[ c′ ∈ Cert d e ]
        ( (fst c′ ≡ fst c)
        × (fst (snd c′) ≡ fst (snd c))
        × (fst (snd (snd c′)) ≡ fst (snd (snd c)))
        × (prov c′ ≡ p) )
  provenanceIsNotDeterminedByTheOtherThree d e (s , i , m , _) p =
    (s , i , m , p) , refl , refl , refl , refl
