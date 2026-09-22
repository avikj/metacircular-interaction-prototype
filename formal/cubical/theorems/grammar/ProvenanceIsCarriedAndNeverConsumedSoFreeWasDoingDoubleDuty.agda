{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ProvenanceIsCarriedAndNeverConsumedSoFreeWasDoingDoubleDuty
--
-- ────────────────────────────────────────────────────────────────────
-- TWO SENSES OF `free` IN THE FOUR COMPONENTS OF
-- `ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem`.
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
-- Those are opposite situations wearing one word.
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
------------------------------------------------------------------------

module ProvenanceIsCarriedAndNeverConsumedSoFreeWasDoingDoubleDuty where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import ACertifiedRewriteComposesAndOnlyOneComponentNeedsATheorem
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
